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

/runner/config.sh --name "${RUNNER_NAME:-docker-runner}" --ephemeral --replace --unattended --url https://github.com/$GITHUB_ORG --token $REGISTRATION_TOKEN

# This script is PID 1 in the libkrun guest. A bash PID 1 does not forward
# SIGTERM to its children, so on `podman stop` run.sh / Runner.Listener never
# see the signal, are SIGKILLed after the stop timeout, and the runner stays
# registered on GitHub ("A session for this runner already exists" on restart).
# exec into tini (-g forwards signals to the whole child process group) so the
# listener receives SIGTERM and deregisters cleanly.
exec tini -g -- /runner/run.sh

