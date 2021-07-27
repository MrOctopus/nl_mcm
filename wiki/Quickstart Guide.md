# NL_MCM Quickstart Guide

This will walk you through setting up a NL_MCM menu from scratch. Alternatively, if you learn better from examples check out the two [Example](https://github.com/MrOctopus/nl_mcm/tree/main/examples/nl_curios) [Plugins](https://github.com/MrOctopus/nl_mcm/tree/main/examples/nl_utilities).

## Requirements

* [SkyUI SDJ 5.1](https://github.com/schlangster/skyui/wiki)
* Latest build of [NL_MCM](https://github.com/MrOctopus/nl_mcm/actions/workflows/ci.yml?query=branch%3Amain) from the CI pipeline. (Must be logged in to github to access)
* The Creation Kit.
* Some way to compile scripts. ([Pyro](https://github.com/fireundubh/pyro), Creation Kit, VS Code Papyrus Compiler, PCA SE, etc.)

## Getting Started

Start by creating your script, but instead of extending SKI_ConfigBase like is normally done for an MCM menu you should extend nl_mcm_module.

```papyrus
Scriptname myModMCM extends nl_mcm_module
```

Then register the name of the current page in OnInit, and define the mod name and Default page in OnPageInit.

```papyrus
Scriptname myModMCM extends nl_mcm_module

event OnInit()
    RegisterModule("Main")
endevent

event OnPageInit()
    SetModName("myModsName")
    SetLandingPage("Main")
endevent
```

Now you need to create the content that will be shown to users, this is done in the OnPageDraw event. In our case we'll define a header option, and a short paragraph of text.

```papyrus
Scriptname myModMCM extends nl_mcm_module

event OnInit()
    RegisterModule("Main")
endevent

event OnPageInit()
    SetModName("myModsName")
    SetLandingPage("Main")
endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption(FONT_PRIMARY("Main Options"))
    AddParagraph("Hello there! This is the MCM page for my amazing mod called myModsName.")
endevent
```

Now we need to create an option for the user to interact with, this requires us to define a value for the toggle option to change, set a default value for it and then add the toggle option to the OnPageDraw event.

```papyrus
Scriptname myModMCM extends nl_mcm_module

Bool Property coolFeatureEnabled auto
;Define a property for your feature, so that you can access it from other scripts.

event OnInit()
    RegisterModule("Main")
endevent

event OnPageInit()
    SetModName("myModsName")
    SetLandingPage("Main")
    coolFeatureEnabled = false
    ;Set the starting value, this is what will be shown when a user first views your MCM.
endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption(FONT_PRIMARY("Main Options"))
    AddParagraph("Hello there! This is the MCM page for my amazing mod called myModsName.")
    AddToggleOptionST("coolFeatureState", "My Cool Feature", coolFeatureEnabled)
    ;Add your toggle option.
endevent
```

You've now created a toggle option that will have a default value filled, but when a user clicks it nothing will happen. To make something happen we need to create a state with the same name as the first parameter of AddToggleOptionST.

```papyrus
Scriptname myModMCM extends nl_mcm_module

Bool Property coolFeatureEnabled auto

event OnInit()
    RegisterModule("Main")
endevent

event OnPageInit()
    SetModName("myModsName")
    SetLandingPage("Main")
    coolFeatureEnabled = false
endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption(FONT_PRIMARY("Main Options"))
    AddParagraph("Hello there! This is the MCM page for my amazing mod called myModsName.")
    AddToggleOptionST("coolFeatureState", "My Cool Feature", coolFeatureEnabled)
endevent

state coolFeatureState
    event OnSelectST(string state_id)
        coolFeatureEnabled = !coolFeatureEnabled
        ;Invert the value of coolFeatureEnabled
        SetToggleOptionValueST(coolFeatureEnabled, false, "coolFeatureState")
        ;Update the togglebox to represent the updated value.
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("This will toggle my cool feature on or off.")
        ;This is the text that will show at the bottom of the page.
    endEvent
endstate
```

Congratulation, you now have a simple MCM script. Save your script and move onto the next section to get it showing in game.

## Final Steps

You should now have something that looks like this:

```papyrus
Scriptname myModMCM extends nl_mcm_module

Bool Property coolFeatureEnabled auto

event OnInit()
    RegisterModule("Main")
endevent

event OnPageInit()
    SetModName("myModsName")
    SetLandingPage("Main")
    coolFeatureEnabled = false
endevent

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption(FONT_PRIMARY("Main Options"))
    AddParagraph("Hello there! This is the MCM page for my amazing mod called myModsName.")
    AddToggleOptionST("coolFeatureState", "My Cool Feature", coolFeatureEnabled)
endevent

state coolFeatureState
    event OnSelectST(string state_id)
        coolFeatureEnabled = !coolFeatureEnabled
        SetToggleOptionValueST(coolFeatureEnabled, false, "coolFeatureState")
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("This will toggle my cool feature on or off.")
    endEvent
endstate
```

Now you need to link this to a Quest to get it to appear in game. This can be done in either XEdit or the CK, and we'll be covering how to do it via the CK in this example.

1. Open the CK.
2. In the Object Window in the treeview on the left find the ``Character`` section.
3. Find the option labelled ``Quest`` and click it.
4. In the section to the right of the treeview, right click and select ``New``.
5. This should open up a window called ``Quest``, by default you should be seeing the ``Quest Data`` tab.
6. Enter ``myModName_MCM`` as both the ID and the Quest Name. 
7. Ensure ``Start Game Enabled`` and ``Run Once`` are __Enabled__. It should look something like [this](https://i.imgur.com/sNyRfZe.png).
8. Press ``OK`` to create the Quest.
9. Right click on the created quest and select ``Edit``.
10. Move to the ``Scripts`` tab.
11. Click ``Add``, and then click ``[New Script]``.
12. Name the script ``myModMCM`` and press ``OK``.
13. There should now be a script named myModMCM listed on the left of the page.
14. Click ``Add`` again and in the ``filter`` type in ``nl_mcm_module``. Select that script and add it to the list. (If you don't see it, check [Common Issues](https://github.com/Osmosis-Wrench/nl_mcm/blob/faq/wiki/Quickstart%20Guide.md#common-issues) below)
15. Press ``OK`` to save your changes to the quest.
16. Right click the quest and select ``Edit`` again.
17. Move back to the Scripts tab, and right click ``myModMCM`` and select ``Edit Source``.
18. Copy the script we have created above, and paste it into this window.
19. Save the script ``[File>Save]``, and it should save and compile without any errors.
20. In the top right hand corner of the CK, select ``File``, then ``Save`` and then name the file ``myModName.esp``

If you now load into the game with this created mod enabled, your MCM page should appear.  
If not, double check that you've followed all steps correctly and look over the Common Issues below.

## Common Issues

### I can't find nl_mcm_module

This means you haven't installed the NL_MCM SDK correctly. This SDK needs to be accessible to the Creation Kit for the scripts to show up. If you're launching the CK via MO2, make sure the SDK is installed like a regular mod and is enabled in the left panel. (It won't show in the right panel, because it doesn't have an ESP.)  
If you didn't do this, it's likely you also didn't install the SkyUI SDK correctly as well, so make sure you also install that.

__If you've found an issue that isn't covered here, raise a Github issue outlining your problem and somebody will get back to you eventually. If it's replicable it will be either dealt with in an update, or listed here as a common issue.__

## Useful Links

* The [Creation Kit Tutorials](https://www.creationkit.com/index.php?title=Category:Tutorials). Most basic modding issues are covered there, so if you need to learn how something works it's generally a great resource.
* The [SkyUI MCM Wiki](https://github.com/schlangster/skyui/wiki). Not everything covered there is true of NL_MCM as well, but a good portion of it is.

__If you feel this article could be improved, or found anything in it confusing please feel free to raise an Github issue or suggest changes in a pull request.__
