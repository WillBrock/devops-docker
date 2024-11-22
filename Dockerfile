FROM alpine:latest

# Arguments
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
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip && \
    unzip terraform.zip -d /usr/local/bin && \
    rm terraform.zip && \
    terraform --version

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
