Scriptname nl_curios_mcm_core extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

string[] _shown_presets
bool _show_advanced
bool _show_credits

bool property ShowAdvancedPage
	function Set(bool show)
		if show
			(MY_QUEST as nl_curios_mcm_advanced).RegisterModule("Advanced", 100)
		else
			(MY_QUEST as nl_curios_mcm_advanced).UnregisterModule()
		endif

		_show_advanced = show
	endfunction

	bool function Get()
		return _show_advanced
	endfunction
endproperty

bool property ShowCreditsPage
	function Set(bool show)
		if show
			(MY_QUEST as nl_curios_mcm_credits).RegisterModule("Credits", 1000)
		else
			(MY_QUEST as nl_curios_mcm_credits).UnregisterModule()
		endif

		_show_credits = show
	endfunction

	bool function Get()
		return _show_credits
	endfunction
endproperty

;------------------\
; REGISTER MOD PAGE \
;--------------------------------------------------------

; - Before register
event OnInit()
	RegisterModule("Core")
	SetModName("NeverLost's Curios")
	SetLandingPage("Core")
endevent

; - After register
event OnPageInit()
	; Do nothing
endevent

;-----------\
; MOD EVENTS \
;--------------------------------------------------------

event OnGameReload()
	; No need to call parent.OnGameReload() anymore as was the case in the original SKYUI
	DEBUG_MSG("Game loaded")
endevent

event OnConfigClose()
	DEBUG_MSG("Config closed!")
endevent

;---------------\
; PRESET HANDLER \
;--------------------------------------------------------

int function SaveData()
	; It doesn't matter what type of jcontainers object this is.
	; As long as you load the data the same way you saved it
	; it's fine
	int jObj = JMap.object()
	
	JMap.setInt(jObj, "showadvanced", ShowAdvancedPage as int)
	JMap.setInt(jObj, "showcredits", ShowCreditsPage as int)

	return jObj
endfunction

function LoadData(int jObj)
	ShowAdvancedPage = JMap.getInt(jObj, "showadvanced") as bool
	ShowCreditsPage = JMap.getInt(jObj, "showcredits") as bool
endfunction

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)

	; Left side
	AddHeaderOption(FONT_PRIMARY("Core"))
	AddParagraph("Hello there! This MCM acts as a core menu for all of my smaller, miscellaneous mods. Be on the lookout for new pages!", FONT_INFO())

	AddEmptyOption()
	AddHeaderOption(FONT_PRIMARY("User presets"))
	
	; You don't HAVE to check if it's installed
	; but it's nice to disable options visually if it isn't
	if !JContainers.isInstalled()
		AddTextOptionST("preset_jcontainers", FONT_INFO("JContainers is not installed"), "")
	else
		int preset_flag = OPTION_FLAG_NONE

		AddInputOptionST("preset_save", "Create new preset", "")

		if GetNumMCMSavedPresets() == 0
			preset_flag = OPTION_FLAG_DISABLED
		endif

		AddMenuOptionST("preset_load", "Load a preset", "", preset_flag)
		AddMenuOptionST("preset_delete", "Delete a preset", "", preset_flag)
	endif

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("Pages"))

	if ShowAdvancedPage
		AddTextOptionST("mod_show_advanced", FONT_WARNING("Hide"), "Advanced")
	else
		AddTextOptionST("mod_show_advanced", FONT_SUCCESS("Show"), "Advanced")
	endif

	if ShowCreditsPage
		AddTextOptionST("mod_show_credits", FONT_WARNING("Hide"), "Credits")
	else
		AddTextOptionST("mod_show_credits", FONT_SUCCESS("Show"), "Credits")
	endif

	AddEmptyOption()
	AddHeaderOption(FONT_PRIMARY("Exit MCM?"))
	AddTextOptionST("exit_mcm", "", FONT_DANGER("Exit Now!"))
endevent

;-------------\
; PAGE OPTIONS \
;--------------------------------------------------------

state preset_save
	event OnHighlightST(string state_id)
		SetInfoText("Create a new preset")
	endevent

	event OnInputOpenST(string state_id)
		SetInputDialogStartText("presetname")
	endevent
	
	event OnInputAcceptST(string state_id, string str)
		SaveMCMToPreset(str)
		; We want to enable the disabled preset options
		; if there are saved presets
		ForcePageReset()
	endevent
endstate

state preset_load
	event OnHighlightST(string state_id)
		SetInfoText("Load a saved preset")
	endevent

	event OnMenuOpenST(string state_id)
		_shown_presets = GetMCMSavedPresets("Exit")
		SetMenuDialog(_shown_presets, 0)
	endevent

	event OnMenuAcceptST(string state_id, int i)
		; i = 0 means that the user
		; has either select the default option
		; or has exited the list by a button press
		if i != 0
			LoadMCMFromPreset(_shown_presets[i])

			; I'm only refreshing pages here, cause my loaded settings
			; affect the shown pages
			RefreshPages()

			; Alternatively just refresh the shown page's contents
			;ForcePageReset()
		endif

		; Set to NONE_STRING_PTR to allow for garbage collection
		; Not needed, but hey, let's be nice to papyrus
		_shown_presets = NONE_STRING_PTR
	endevent 
endstate

state preset_delete
	event OnHighlightST(string state_id)
		SetInfoText("Delete an existing preset")
		SetInfoText("Load a saved preset")
	endevent

	event OnMenuOpenST(string state_id)
		_shown_presets = GetMCMSavedPresets("Exit")
		SetMenuDialog(_shown_presets, 0)
	endevent

	event OnMenuAcceptST(string state_id, int i)
		; i = 0 means that the user
		; has either select the default option
		; or has exited the list by a button press
		if i != 0
			DeleteMCMSavedPreset(_shown_presets[i])
			
			; We want to disable the preset options
			; if there are no longer any presets
			ForcePageReset()
		endif

		; Set to NONE_STRING_PTR to allow for garbage collection
		; Not needed, but hey, let's be nice to papyrus
		_shown_presets = NONE_STRING_PTR
	endevent 
endstate

state mod_show_advanced
	event OnHighlightST(string state_id)
		SetInfoText("Show advanced page")
	endevent

	event OnSelectST(string state_id)
		ShowAdvancedPage = !ShowAdvancedPage
		RefreshPages()
	endevent
endstate

state mod_show_credits
	event OnHighlightST(string state_id)
		SetInfoText("Show credits page")
	endevent

	event OnSelectST(string state_id)
		ShowCreditsPage = !ShowCreditsPage
		RefreshPages()
	endevent
endstate

state exit_mcm
	event OnSelectST(string state_id)
		CloseMCM(close_journal = true)
	endevent
endstate