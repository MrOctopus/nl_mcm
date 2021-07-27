# NL_MCM FAQ

For the original SkyUI MCM FAQ, check out [this](https://github.com/schlangster/skyui/wiki/MCM-FAQ) page.

## Is NL_MCM compatible with "Regular" MCMs?

In short, **Yes**. NL_MCM menus will appear alongside regular MCM menus without any conflicts or issues.

## Why should I use NL_MCM as apposed to a "Regular" mcm?

The two main reasons to use NL_MCM over regular MCMs, is that the former is more simple to implement and maintain.
NL_MCM speeds up implementation of MCM's with a variety of QOL functions such as [QuickHotKey](https://github.com/MrOctopus/nl_mcm/wiki/nl_mcm_module#QuickHotkey), [AddParagraph](https://github.com/MrOctopus/nl_mcm/wiki/nl_mcm_module#AddParagraph), [SetSliderDialogue](https://github.com/MrOctopus/nl_mcm/wiki/nl_mcm_module#SetSliderDialog), and state_id based [Advanced States](https://github.com/MrOctopus/nl_mcm/wiki/nl_mcm_module#Advanced_States).  
NL_MCM also facilitates easier maintenance by allowing each page of your MCM to be separated into its own script, simplifying updates and ongoing development.

## Should I include resources from NL_MCM in with my mod?

This is entirely up to you. If you wish to include the NL_MCM redistributable with your mod you are entitled to do so, alternatively you can tell your users to install NL_MCM from its' [Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/49127) page as a requirement.

## How hard is it to convert my existing MCM to NL_MCM?

It depends on how your current MCM is implemented. If you are already using a State based MCM menu, then it should be relatively trivial to convert. Alternatively, if you are using the "OID" method for your MCM it will be a bit more work. It's still very doable, it will just take longer to fully implement.
