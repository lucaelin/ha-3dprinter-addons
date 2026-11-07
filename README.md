# 3dprinter-addons
Addons for Home-Assistant, related to 3D printing.

## Install

You can use the following button to add the repository to your Home Assistant instance.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Flucaelin%2Fha-3dprinter-addons)


## Addons

## Publishing OctoPrint images

The **Build OctoPrint** workflow builds and publishes architecture-specific images
when OctoPrint files change on `main`, or when run manually from GitHub Actions.

After the first publish, set each `ha-addon-3dprinter-octoprint-*` container
package's visibility to **Public** in its GitHub package settings. A public source
repository does not automatically make its container packages public. Home
Assistant must be able to pull the images without GitHub credentials.

### 3DPrinter-OctoPrint

OctoPrint, plain and simple.

### 3DPrinter-Remote

Run OctoPrint on a different machine from the printer.

### Camera-mjpg-streamer

Stream from camera.
