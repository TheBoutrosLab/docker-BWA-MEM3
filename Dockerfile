ARG MINIFORGE_VERSION=26.1.1-2
ARG SAMTOOLS_VERSION=1.24
ARG CONDA_ENV_PATH=/opt/conda/envs/bwa-mem3

FROM condaforge/miniforge3:${MINIFORGE_VERSION} AS builder

ARG CONDA_ENV_PATH
ARG BWA_MEM3_VERSION=0.14.0

RUN mamba create -qy -p ${CONDA_ENV_PATH} \
    -c bioconda \
    -c conda-forge \
    bwa-mem3==${BWA_MEM3_VERSION} && \
    mamba clean -afy

FROM ghcr.io/theboutroslab/samtools:${SAMTOOLS_VERSION} AS final

ARG CONDA_ENV_PATH

COPY --from=builder ${CONDA_ENV_PATH} ${CONDA_ENV_PATH}

ENV CONDA_ENV_PATH="${CONDA_ENV_PATH}" \
    PATH="${CONDA_ENV_PATH}/bin:${PATH}"

# Change the default user to bldocker from root
USER bldocker

LABEL maintainer="Yash Patel <ypatel@sbpdiscovery.org>" \
      org.opencontainers.image.source=https://github.com/TheBoutrosLab/docker-BWA-MEM3 \
      org.opencontainers.image.description="Dockerfile for bwa-mem3"
