FROM alpine:latest

# Arguments
ARG PRODUCT=terraform
ARG TERRAFORM_VERSION=1.9.8
ARG KUBECTL_VERSION=v1.31.3
ARG HELM_VERSION=3.16.3
ARG AWS_CLI_VERSION=2.13.0

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    unzip \
    tar \
    gzip \
    binutils \
    libc6-compat \
    ca-certificates \
    jq \
    openssl \
    aws-cli \
    && rm -rf /var/cache/apk/*

# Install Terraform
RUN apk add --update --virtual .deps --no-cache gnupg && \
    cd /tmp && \
    wget https://releases.hashicorp.com/${PRODUCT}/${TERRAFORM_VERSION}/${PRODUCT}_${TERRAFORM_VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/${PRODUCT}/${TERRAFORM_VERSION}/${PRODUCT}_${TERRAFORM_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/${PRODUCT}/${TERRAFORM_VERSION}/${PRODUCT}_${TERRAFORM_VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify ${PRODUCT}_${TERRAFORM_VERSION}_SHA256SUMS.sig ${PRODUCT}_${TERRAFORM_VERSION}_SHA256SUMS && \
    grep ${PRODUCT}_${TERRAFORM_VERSION}_linux_amd64.zip ${PRODUCT}_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip /tmp/${PRODUCT}_${TERRAFORM_VERSION}_linux_amd64.zip -d /tmp && \
    mv /tmp/${PRODUCT} /usr/local/bin/${PRODUCT} && \
    rm -f /tmp/${PRODUCT}_${TERRAFORM_VERSION}_linux_amd64.zip ${PRODUCT}_${TERRAFORM_VERSION}_SHA256SUMS ${TERRAFORM_VERSION}/${PRODUCT}_${TERRAFORM_VERSION}_SHA256SUMS.sig && \
    apk del .deps

# Install Helm
RUN curl -fsSL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 && \
    helm version

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && mv kubectl /usr/local/bin/ && \
    kubectl version --client

# Default entrypoint
ENTRYPOINT ["/bin/bash"]
