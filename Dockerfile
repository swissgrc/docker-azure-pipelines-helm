# Base image containing dependencies used in builder and final image
FROM swissgrc/azure-pipelines-azurecli:2.45.0 AS base


# Builder image
FROM base AS build

# Make sure to fail due to an error at any stage in shell pipes
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# renovate: datasource=repology depName=debian_11/curl versioning=loose
ENV CURL_VERSION=7.74.0-1.3+deb11u7
# renovate: datasource=repology depName=debian_11/lsb-release versioning=loose
ENV LSBRELEASE_VERSION=11.1.0
# renovate: datasource=repology depName=debian_11/gnupg2 versioning=loose
ENV GNUPG_VERSION=2.2.27-2+deb11u2
# renovate: datasource=github-tags depName=kubernetes/kubernetes extractVersion=^v(?<version>.*)$
ENV KUBE_VERSION=1.26.2
# renovate: datasource=github-tags depName=helm/helm extractVersion=^v(?<version>.*)$
ENV HELM_VERSION=3.11.1

RUN apt-get update -y && \
  # Install necessary dependencies
  apt-get install -y --no-install-recommends curl=${CURL_VERSION} lsb-release=${LSBRELEASE_VERSION} gnupg=${GNUPG_VERSION} && \
  # Download Kubectl
  curl -o /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl  && \
  # Download Helm
  curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -xzO linux-amd64/helm > /tmp/helm


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
RUN cp /tmp/kubectl /usr/local/bin/kubectl && \
  chmod +x /usr/local/bin/kubectl && \
  # Smoke test
  kubectl version --client

# Helm
RUN cp /tmp/helm /usr/local/bin/helm && \
  chmod +x /usr/local/bin/helm && \
  # Smoke test
  helm version
