# nl_mcm
An object-oriented module based extension of SkyUI MCM scripts.

## Info

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
	- Switch between them dynamically!
	- Fonts will automatically switch depending on the installed UI skin
* Exit MCM functionality
	- Allows you to exit the mcm menu/journal, so you can add buttons that will forcefully close the mcm
* Individual page version support
	- You can now update pages individually instead of the whole MCM using a new version tracking system
* Built-in preset saving functionality
	- Requires JContainers

## Releases
Latest release from main branch: \
[![](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml/badge.svg)](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml)

Latest release on the Nexus: \
[Nexus]()

## Documentation
Check out the [github wiki pages](https://github.com/MrOctopus/nl_mcm/wiki) for more details on how to use nl_mcm.