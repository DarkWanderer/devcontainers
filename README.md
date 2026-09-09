# Development container images

This repository builds two Fedora-based, AMD64-only images:

- `Dockerfile.devcontainer` provides Rust, .NET 10, Node.js, Clang, protobuf, and common development tools.
- `Dockerfile.runner` provides an ephemeral GitHub Actions organization runner with nested Podman support for environments using libkrun.

Both images are built on pushes and pull requests to `main`. Pushes to `main` and the weekly scheduled build publish the `latest` tags configured in the GitHub Actions workflow.

## Build locally

```sh
docker build --platform linux/amd64 -f Dockerfile.devcontainer -t devcontainer .
docker build --platform linux/amd64 -f Dockerfile.runner -t runner .
```

Run the development image with the workspace and Cargo target directory mounted separately:

```sh
docker run --rm -it \
  --platform linux/amd64 \
  --volume "$PWD:/workspace" \
  --volume cargo-target:/target \
  devcontainer
```

## Run the GitHub Actions runner

The runner needs a short-lived organization registration token and enough privilege to mount its temporary filesystems:

```sh
docker run --rm \
  --platform linux/amd64 \
  --privileged \
  --user 0 \
  --env GITHUB_ORG=example \
  --env REGISTRATION_TOKEN=token \
  --env RUNNER_NAME=docker-runner \
  runner
```

`GITHUB_ORG` and `REGISTRATION_TOKEN` must be non-empty. `RUNNER_NAME` is optional and defaults to `docker-runner`. The runner is registered with `--ephemeral`, so it accepts one job and then deregisters.

Nested containers use Podman with the Docker CLI compatibility shim. Inside the libkrun guest they share the guest's network namespace because the guest kernel does not provide the bridge and netfilter modules needed for container bridge networking. Container storage and runtime state are held in tmpfs and disappear when the runner stops.

## Lint

CI runs these linters:

```sh
shellcheck entrypoint.sh
actionlint
hadolint Dockerfile.devcontainer
hadolint Dockerfile.runner
```

## License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE).
