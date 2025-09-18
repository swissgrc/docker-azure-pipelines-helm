# Base image containing dependencies used in builder and final image
FROM ghcr.io/swissgrc/azure-pipelines-azurecli:2.76.0-net9 AS base


# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_12/curl versioning=deb
ENV CURL_VERSION=7.88.1-10+deb12u12
# renovate: datasource=repology depName=debian_12/lsb-release versioning=deb
ENV LSBRELEASE_VERSION=12.0-1
# renovate: datasource=repology depName=debian_12/gnupg2 versioning=deb
ENV GNUPG_VERSION=2.2.40-1.1+deb12u1
# renovate: datasource=repology depName=debian_12/unzip versioning=deb
ENV UNZIP_VERSION=6.0-28

# Install necessary dependencies
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends \
    curl=${CURL_VERSION} \
    gnupg=${GNUPG_VERSION} \
    lsb-release=${LSBRELEASE_VERSION} \
    unzip=${UNZIP_VERSION}

# renovate: datasource=github-tags depName=kubernetes/kubernetes extractVersion=^v(?<version>.*)$
ENV KUBE_VERSION=1.34.0

# Download kubectl
ADD https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl /tmp/kubectl

# renovate: datasource=github-tags depName=helm/helm extractVersion=^v(?<version>.*)$
ENV HELM_VERSION=3.18.6

# Download Helm
ADD https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz /tmp/helm.tar.gz
RUN tar -xzf /tmp/helm.tar.gz -O linux-amd64/helm > /tmp/helm && \
  rm /tmp/helm.tar.gz

# renovate: datasource=github-tags depName=Azure/kubelogin extractVersion=^v(?<version>.*)$
ENV KUBELOGIN_VERSION=0.2.10

# Download kubelogin
ADD https://github.com/Azure/kubelogin/releases/download/v${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip /tmp/kubelogin.zip
RUN unzip -p /tmp/kubelogin.zip bin/linux_amd64/kubelogin > /tmp/kubelogin && \
  rm /tmp/kubelogin.zip

# Final image
FROM base AS final

LABEL org.opencontainers.image.vendor="Swiss GRC AG"
LABEL org.opencontainers.image.authors="Swiss GRC AG <opensource@swissgrc.com>"
LABEL org.opencontainers.image.title="azure-pipelines-helm"
LABEL org.opencontainers.image.documentation="https://github.com/swissgrc/docker-azure-pipelines-helm"

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /
COPY --from=build /tmp/ /tmp

RUN \
  # kubectl
  cp /tmp/kubectl /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  kubectl version --client --output=json && \
  # Helm
  cp /tmp/helm /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && \
  helm version && \
  # kubelogin
  cp /tmp/kubelogin /usr/local/bin/kubelogin && \
  chmod +x /usr/local/bin/kubelogin && \
  kubelogin --version && \
  # Cleanup
  rm -rf /tmp/*
