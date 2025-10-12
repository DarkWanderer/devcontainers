FROM fedora:44@sha256:37be4c0383aecf0c0e6f774bc062d31b1ff410848fc15ae088df64bdd3218661

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
        dotnet-sdk-9.0 \
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

USER ${USERNAME}
WORKDIR /workspace

RUN rustup-init -y --no-modify-path --profile minimal \
    && echo 'source $HOME/.cargo/env' >> /home/${USERNAME}/.bashrc \
    && source /home/${USERNAME}/.bashrc \
    && rustup component add llvm-tools-preview rust-analyzer clippy rustfmt \
    && cargo install --locked cargo-audit cargo-llvm-cov cargo-outdated \
    && rm -rf ~/.cargo/registry

COPY --chown=${USER_UID}:${USER_GID} config.toml /home/${USERNAME}/.cargo/config.toml

SHELL ["/bin/bash", "-c"]

CMD ["bash"]
