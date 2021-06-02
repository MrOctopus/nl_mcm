# nl_mcm
An object-oriented module based extension of SkyUI MCM scripts.

## Main Features
* Modularity
	- You can have 1 Core MCM menu, and release other mods that can attach as pages to that menu
* Advanced state options
	- Allow several options to use the same state logic
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

## Info
Latest release from main branch: [![](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml/badge.svg)](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml) \
Latest release on the Nexus: [Nexus]() \

The current status of this project is that it is ready for use in development.
However, more feedback is required from other mod authors before the framework can be published on the nexus.

## Documentation
* The source documentation is available in the [Wiki](https://github.com/MrOctopus/nl_mcm/wiki).
* The SDK source files are available in the following [Folder](https://github.com/MrOctopus/nl_mcm/tree/main/main/scripts/source).

### Developers
| Compiling nl_mcm plugins | Description                                                                                             |
|--------------------------|---------------------------------------------------------------------------------------------------------|
| Pyro                     | Import https://github.com/MrOctopus/nl_mcm/tree/main/main/scripts/source                                |
| Manual                   | Install the latest [CI](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml) "nl_mcm - SSE" SDK|

| Examples              | Description                                            | Link                                                                         |
|-----------------------|--------------------------------------------------------|------------------------------------------------------------------------------|
| NeverLost's Curios    | nl_mcm being used to build a standalone mcm menu       | [CLICK](https://github.com/MrOctopus/nl_mcm/tree/main/examples/nl_curios)    |
| NeverLost's Utilities | nl_mcm being used to attach a page to another mcm menu | [CLICK](https://github.com/MrOctopus/nl_mcm/tree/main/examples/nl_utilities) |

### Users
This is a framework for mod authors/developers, and as such is not intended to be used as a standalone mod.