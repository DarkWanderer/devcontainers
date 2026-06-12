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
/runner/run.sh

