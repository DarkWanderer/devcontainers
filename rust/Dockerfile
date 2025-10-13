FROM fedora:42@sha256:0c5ab5380e63cb322552d624d2c78b835f11b526cfd32e1d6f687d0c245f38ce

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
    && rustup default stable \
    && rustup component add llvm-tools-preview rust-analyzer clippy rustfmt \
    && cargo install --locked cargo-audit cargo-llvm-cov cargo-outdated \
    && rm -rf /usr/local/registry

USER ${USERNAME}
WORKDIR /workspace

SHELL ["/bin/bash", "-c"]

CMD ["bash"]
