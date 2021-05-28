# nl_mcm
An object-oriented module based extension of SkyUI MCM scripts.

## Info
The current status of this project is that it is ready for use in development.
However, more feedback is required from other mod authors before the framework can be published on the nexus.

### Features
* Modularity
	- You can have 1 Core MCM menu, and release other mods that can attach as pages to that menu
* Automatic key conflict handling 
	- You no longer need to override `string GetCustomControl(int keyCode)` to define custom buttons
* Unregister and register pages on the fly 
	- You could make a quest dynamicaly add or remove pages from the MCM menu
* Automatic paragraph handling 
	- Supports html formatting
* Built-in font formats for different purposes
	- Switch between them dynamically
	- Fonts will automatically switch depending on the installed UI skin
* Open and Exit MCM functionality
	- Create direct quick hotkeys to your mcm menu
	- Close your mcm menu on command
* Individual page version support
	- You can now update pages individually instead of the whole MCM using a new version tracking system
* Extended control over pages
	- Set landing pages 
	- Set splash screens
	- Force page switches
* Built-in preset saving functionality
	- Requires JContainers

## Releases
Latest release from main branch: \
[![](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml/badge.svg)](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml)

Latest release on the Nexus: \
[Nexus]()

## Documentation
Check out the [github wiki pages](https://github.com/MrOctopus/nl_mcm/wiki) for more details on how to use nl_mcm.