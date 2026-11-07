#!/usr/bin/with-contenv bashio
# ==============================================================================
# Prepare OctoPrint
# s6-overlay docs: https://github.com/just-containers/s6-overlay
# ==============================================================================
set -e

export BASEDIR="--basedir /data/config/octoprint"
VENV=/data/python/octoprint

if [ -d "$VENV" ] && ! "$VENV/bin/python" -c \
    'import sys; raise SystemExit(sys.version_info[:2] != (3, 11))' 2>/dev/null; then
    bashio::log.warning "Preserving the old Python environment; plugins may need reinstalling."
    mv "$VENV" "${VENV}.previous-$(date +%s)"
fi

if [ ! -x "$VENV/bin/python" ]; then
    bashio::log.info "Creating the persistent OctoPrint Python environment."
    python3 -m venv "$VENV"
fi

bashio::log.info "Installing OctoPrint ${OCTOPRINT_VERSION} from bundled wheels (no download required)."
"$VENV/bin/python" -m pip install --quiet --no-index \
    --find-links /opt/octoprint-wheels "OctoPrint==${OCTOPRINT_VERSION}" wheel
"$VENV/bin/octoprint" --version

# Create initial OctoPrint config, if missing.
if [ ! -f /data/config/octoprint/config.yaml ]; then
    mkdir -p /data/config/octoprint
fi

# Update OctoPrint config with settings for the addon to behave properly.
updateConfig()
{
    # octoprint $BASEDIR config set --bool api.allowCrossOrigin true
    octoprint $BASEDIR config set folder.generated "/tmp/octoprint/generated"
    octoprint $BASEDIR config set folder.timelapse_tmp "/tmp/octoprint/timelapse/tmp"
    # octoprint $BASEDIR config set --bool server.allowFraming true
    octoprint $BASEDIR config set server.commands.serverRestartCommand "/scripts/octoprint_restart.sh"
    octoprint $BASEDIR config set server.commands.systemRestartCommand "/scripts/system_restart.sh"
    octoprint $BASEDIR config set server.commands.systemShutdownCommand "/scripts/system_shutdown.sh"
    octoprint $BASEDIR config set webcam.ffmpeg "/usr/bin/ffmpeg"
}
updateConfig

# Other setting changes, if needed. E.g. creating a user.
# Update OctoPrint config with customized settings, not strictly required for addon to work but helps with features.
# updateConfigCustom() {
    # Add user, if needed.
    # { # Make sure Ingress user for OctoPrint exists.
    #     bashio::log.notice "Ensure Ingress user (homeassistant) exist."
    #     if ! octoprint --basedir /data/config/octoprint user list | grep -q 'homeassistant'; then
    #         new_password=$(date +%s | sha256sum | base64 | head -c 32 ; echo)
    #         octoprint --basedir /data/config/octoprint user add --password "$new_password" --admin homeassistant # 2> /dev/null
    #     fi
    # } || { # catch
    #     bashio::log.warning "Failed to ensure Ingress user exists, may not be able to launch."
    # }
    # Trusted networks, access control etc.
# }
