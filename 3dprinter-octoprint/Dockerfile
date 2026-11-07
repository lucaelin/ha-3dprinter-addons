ARG BUILD_FROM="ghcr.io/home-assistant/amd64-base-debian:bookworm"
FROM ${BUILD_FROM}
ARG OCTOPRINT_VERSION="1.11.8"

# Setup path for persistent install of Python packages
ENV PATH=/data/python/octoprint/bin:${PATH}
ENV OCTOPRINT_VERSION=${OCTOPRINT_VERSION}

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
        --no-install-recommends \
        python3-venv \
        python3-dev \
        python3-wheel \
        build-essential \
        caddy \
        libffi-dev \
        # Extras.
        ffmpeg \
        avrdude \
        dfu-util \
        dfu-programmer \
        stm32flash \
        # Development/testing
        vim \
    && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /tmp/octoprint-build \
    && /tmp/octoprint-build/bin/python -m pip install --no-cache-dir --upgrade pip setuptools wheel \
    && /tmp/octoprint-build/bin/python -m pip wheel --no-cache-dir \
        --wheel-dir /opt/octoprint-wheels "OctoPrint==${OCTOPRINT_VERSION}" wheel \
    && /tmp/octoprint-build/bin/python -m pip install --no-index \
        --find-links /opt/octoprint-wheels "OctoPrint==${OCTOPRINT_VERSION}" wheel \
    && /tmp/octoprint-build/bin/python -m pip check \
    && /tmp/octoprint-build/bin/octoprint --version \
    && rm -rf /tmp/octoprint-build

# Copy root filesystem
COPY rootfs /
RUN chmod +x /etc/cont-init.d/*.sh
RUN chmod +x /etc/services.d/*/*
RUN chmod +x /scripts/*.sh
