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

/runner/config.sh --name docker-runner --ephemeral --replace --unattended --url https://github.com/$GITHUB_ORG --token $REGISTRATION_TOKEN
/runner/run.sh

