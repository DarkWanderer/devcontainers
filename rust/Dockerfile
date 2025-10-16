FROM fedora:42@sha256:aa7befe5cfd1f0e062728c16453cd1c479d4134c7b85eac00172f3025ab0d522

ENV CARGO_HOME=/usr/local RUSTUP_HOME=/usr/local
COPY --chmod=644 config.toml /usr/local/config.toml

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN useradd --uid ${USER_UID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && mkdir /workspace && chown ${USERNAME}:${USERNAME} /workspace

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
    && rustup component add llvm-tools-preview rust-analyzer clippy rustfmt \
    && cargo install --locked cargo-audit cargo-llvm-cov cargo-outdated clippy-sarif sarif-fmt \
    && rm -rf /usr/local/registry

WORKDIR /workspace

SHELL ["/bin/bash", "-c"]

CMD ["bash"]
