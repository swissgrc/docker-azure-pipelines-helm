# Base image containing dependencies used in builder and final image
FROM ghcr.io/swissgrc/azure-pipelines-azurecli:2.67.0-net9 AS base


# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_12/curl versioning=deb
ENV CURL_VERSION=7.88.1-10+deb12u8
# renovate: datasource=repology depName=debian_12/lsb-release versioning=deb
ENV LSBRELEASE_VERSION=12.0-1
# renovate: datasource=repology depName=debian_12/gnupg2 versioning=deb
ENV GNUPG_VERSION=2.2.40-1.1
# renovate: datasource=github-tags depName=helm/helm extractVersion=^v(?<version>.*)$
ENV HELM_VERSION=3.16.4

RUN apt-get update -y && \
  # Install necessary dependencies
  apt-get install -y --no-install-recommends \
    curl=${CURL_VERSION} \
    gnupg=${GNUPG_VERSION} \
    lsb-release=${LSBRELEASE_VERSION} && \
  # Download Helm
  curl -sL --proto "=https" https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    | tar -xzO linux-amd64/helm > /tmp/helm


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

# Kubectl
# renovate: datasource=github-tags depName=kubernetes/kubernetes extractVersion=^v(?<version>.*)$
ENV KUBE_VERSION=1.32.0
ADD https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl /tmp/kubectl
RUN cp /tmp/kubectl /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  # Smoke test
  kubectl version --client --output=json

# Helm
RUN cp /tmp/helm /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && \
  # Smoke test
  helm version
