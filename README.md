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

The current status of this project is that it is ready for use in development.
However, more feedback is required from other mod authors before the framework can be published on the nexus.

**Latest release from main branch:** \

[![](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml/badge.svg)](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml) \
**Latest release on the Nexus:**  \

[Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/49127)

## Documentation

* The source documentation is available in the [Wiki](https://github.com/MrOctopus/nl_mcm/wiki/1.-Home).
* The SDK source files are available in the following [Folder](https://github.com/MrOctopus/nl_mcm/tree/main/main/scripts/source).

### Examples

| Examples | Description | Link |
|-------------------------|--------------------------------------------------------|------------------------------------------------------------------------------|
| *NeverLost's Curios*    | nl_mcm being used to build a standalone mcm menu       | [CLICK](https://github.com/MrOctopus/nl_mcm/tree/main/examples/nl_curios)    |
| *NeverLost's Utilities* | nl_mcm being used to attach a page to another mcm menu | [CLICK](https://github.com/MrOctopus/nl_mcm/tree/main/examples/nl_utilities) |

### Compiling

**Pyro**
| Steps | Description                                                              |
|-------|--------------------------------------------------------------------------|
| 1.    | Import https://github.com/MrOctopus/nl_online/tree/main/skyui/source     |
| 2.    | Import https://github.com/MrOctopus/nl_mcm/tree/main/main/scripts/source |

**Manual**
| Steps | Description                                                                                                       |
|-------|-------------------------------------------------------------------------------------------------------------------|
| 1.    | Install the latest "SkyUI" SDK from the SkyUI [Wiki](https://github.com/schlangster/skyui/wiki)                   |
| 2.    | Install the latest "nl_mcm_SSE - SDK" from the [CI](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml?query=branch%3Amain) |

### Distribution

| Method         | Description                                                              |
|----------------|--------------------------------------------------------------------------|
| Dependency     | Make nl_mcm a download requirement, and link users to the [Nexus]() page |
| Redistribution | Redistribute the nl_mcm .pex files along with your mod                   |

## Licenses

All files in this repository are released under the [MIT License](LICENSE.md) with the following exceptions:
* If you are planning on releasing a nl_mcm mod through redistributing the .pex files, I only require you to include my name as well as link to this repository in your credits.
