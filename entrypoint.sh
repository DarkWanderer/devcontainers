#!/bin/bash

if [ -z ${REGISTRATION_TOKEN+x} ]
then
    echo -n REGISTRATION_TOKEN not set
    exit 1
fi

if [ -z ${GITHUB_ORG+x} ]
then
    echo -n GITHUB_ORG not set
    exit 1
fi

# libkrun's microVM guest runs this entrypoint as root (UID 0); the runner
# refuses to start as root unless this is set.
export RUNNER_ALLOW_RUNASROOT=1

# Nested podman/docker needs real chown(2) when extracting multi-UID image layers,
# and plain writes under /etc also fail. The guest's shared rootfs comes in over
# virtiofs, which allows neither - not even a no-op chown to a file's existing owner -
# because virtiofsd enforces real host-side permissions and isn't itself privileged.
# tmpfs is a real, guest-kernel-native filesystem that doesn't have either restriction,
# so shadow every path a container engine needs to write into with one.
# (/var/lib/containers is podman's default root storage; /run holds its runtime/lock
# state; /var/cache and /var/tmp are buildah's build-time scratch dirs;
# /etc/containers/networks is where `docker network create` - which the actions
# runner issues automatically for jobs with service containers - writes network
# definitions. The resulting network still can't route between containers, since the
# guest kernel has no bridge module, but at least the create call itself succeeds
# instead of hard-failing the job before any step runs.)
for path in /var/lib/containers /run /var/cache /var/tmp /etc/containers/networks; do
    mount -t tmpfs tmpfs "$path"
done

/runner/config.sh --name "${RUNNER_NAME:-docker-runner}" --ephemeral --replace --unattended --url https://github.com/$GITHUB_ORG --token $REGISTRATION_TOKEN

# This script is PID 1 in the libkrun guest. A bash PID 1 does not forward
# SIGTERM to its children, so on `podman stop` run.sh / Runner.Listener never
# see the signal, are SIGKILLed after the stop timeout, and the runner stays
# registered on GitHub ("A session for this runner already exists" on restart).
# exec into tini (-g forwards signals to the whole child process group) so the
# listener receives SIGTERM and deregisters cleanly.
exec tini -g -- /runner/run.sh

