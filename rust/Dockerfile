FROM fedora:44@sha256:37be4c0383aecf0c0e6f774bc062d31b1ff410848fc15ae088df64bdd3218661

COPY --chmod=644 config.toml /.cargo/config.toml

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN useradd --uid ${USER_UID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && mkdir /workspace \
    && chown ${USERNAME}:${USERNAME} /workspace

RUN dnf update -y && \
    dnf install -y \
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

RUN export CARGO_HOME=/usr/local && export RUSTUP_HOME=/usr/local \
    && rustup-init -y \
    && rustup component add llvm-tools-preview rust-analyzer clippy rustfmt \
    && cargo install --locked cargo-audit cargo-llvm-cov cargo-outdated \
    && rm -rf /usr/local/registry

USER ${USERNAME}
WORKDIR /workspace

SHELL ["/bin/bash", "-c"]

CMD ["bash"]
