FROM fedora:43@sha256:2ad3073554aef41c15b2c52e968ec0540c931bc3dab8c599ca6eb6f32f3f2d14

ENV CARGO_HOME=/usr/local RUSTUP_HOME=/usr/local
COPY --chmod=644 config.toml /usr/local/config.toml

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN useradd --uid ${USER_UID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME}

RUN dnf update -y && \
    dnf install -y --setopt=install_weak_deps=False \
        ca-certificates \
        clang \
        cmake \
        curl \
        gcc \
        gh \
        git \
        jq \
        lld \
        make \
        mold \
        nodejs \
        npm \
        openssl-devel \
        pkg-config \
        protobuf-compiler \
        rustup \
        shadow-utils \
        sudo \
        wget \
        which \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN rustup-init -y \
    && rustup component add rust-src llvm-tools-preview rust-analyzer clippy rustfmt \
    && cargo install --locked cargo-audit cargo-llvm-cov cargo-outdated clippy-sarif sarif-fmt \
    && rm -rf /usr/local/registry \
    && mkdir -p /usr/local/registry \
    && chmod 777 /usr/local/registry

WORKDIR /workspace

SHELL ["/bin/bash", "-c"]

CMD ["bash"]
