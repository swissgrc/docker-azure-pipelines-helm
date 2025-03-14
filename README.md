# Docker image for running Helm commands in Azure Pipelines container jobs

<!-- markdownlint-disable MD013 -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-helm/blob/main/LICENSE) [![Build](https://img.shields.io/github/actions/workflow/status/swissgrc/docker-azure-pipelines-terraform/publish.yml?branch=develop&style=flat-square)](https://github.com/swissgrc/docker-azure-pipelines-terraform/actions/workflows/publish.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=swissgrc_docker-azure-pipelines-helm&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=swissgrc_docker-azure-pipelines-helm) [![Pulls](https://img.shields.io/docker/pulls/swissgrc/azure-pipelines-helm.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-helm) [![Stars](https://img.shields.io/docker/stars/swissgrc/azure-pipelines-helm.svg?style=flat-square)](https://hub.docker.com/r/swissgrc/azure-pipelines-helm)
<!-- markdownlint-restore -->

Docker image to run Helm and kubectl commands in [Azure Pipelines container jobs].

## Usage

This container can be used to run Helm and kubectl commands in [Azure Pipelines container jobs].

### Azure Pipelines Container Job

To use the image in an Azure Pipelines Container Job add the following task use it with the `container` property.

The following example shows the container used for a deployment step

```yaml
- stage: deploy
  jobs:
  - deployment: DeployWeb
    container: swissgrc/azure-pipelines-helm:latest
    environment: 'smarthotel-dev'
    strategy:
      runOnce:
        deploy:
          steps:
            - task: HelmDeploy@0
              displayName: Helm upgrade
              inputs:
                azureSubscriptionEndpoint: $(azureSubscriptionEndpoint)
                azureResourceGroup: $(azureResourceGroup)
                kubernetesCluster: $(kubernetesCluster)
                command: upgrade
                chartType: filepath
                chartPath: $(Build.ArtifactStagingDirectory)/sampleapp-v0.2.0.tgz
                releaseName: azuredevopsdemo
                install: true
                waitForExecution: false
```

## Included Software
- [swissgrc/azure-pipelines-azurecli:net9](https://github.com/swissgrc/docker-azure-pipelines-azurecli-net9) as base image
- Helm
- Kubectl

## Tags

<!-- markdownlint-disable MD013 -->
| Tag      | Description                                           | Size                                                                                                                          |
|----------|-------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| latest   | Latest stable release (from `main` branch)            | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/latest?style=flat-square)   |
| unstable | Latest unstable release (from `develop` branch)       | ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/swissgrc/azure-pipelines-helm/unstable?style=flat-square) |
| x.y.z    | Image for a specific version of Helm                  |                                                                                                                               |
<!-- markdownlint-restore -->

[Azure Pipelines container jobs]: https://docs.microsoft.com/en-us/azure/devops/pipelines/process/container-phases
