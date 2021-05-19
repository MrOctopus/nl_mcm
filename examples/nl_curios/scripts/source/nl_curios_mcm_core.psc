Scriptname nl_curios_mcm_core extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

bool _show_advanced
bool _show_credits

;------------------\
; REGISTER MOD PAGE \
;--------------------------------------------------------

; - Before register
event OnInit()
	; It's good practice to check if we actually succeeded
	; in registering the module.
	if RegisterModule("Core") != OK
		KeepTryingToRegister()
	endif

	; These will cache if the call above fails
	SetModName("NeverLost's Curios")
	;SetLandingPage("Core")
endevent

; - After register
event OnPageInit()
	; Do nothing
endevent

;---------------\
; PRESET HANDLER \
;--------------------------------------------------------

int function SaveData()
endfunction

function LoadData(int jObj)
endfunction

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)

	; Left side
	AddHeaderOption(FONT_PRIMARY("Core"))
	AddParagraph("Hello there! This MCM acts as a core menu for all of my smaller, miscellaneous mods. Be on the lookout for new pages!", FONT_INFO())

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("Pages"))

	if _show_advanced
		AddTextOptionST("mod_show_advanced", FONT_WARNING("Hide"), "Advanced")
	else
		AddTextOptionST("mod_show_advanced", FONT_SUCCESS("Show"), "Advanced")
	endif

	if _show_credits
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

state mod_show_advanced
	event OnHighlightST()
		SetInfoText("Show advanced page")
	endevent

	event OnSelectST()
		_show_advanced = !_show_advanced
		
		if _show_advanced
			(MY_QUEST as nl_curios_mcm_advanced).RegisterModule("Advanced", 100)
		else
			(MY_QUEST as nl_curios_mcm_advanced).UnregisterModule()
		endif

		RefreshPages()
	endevent
endstate

state mod_show_credits
	event OnHighlightST()
		SetInfoText("Show credits page")
	endevent

	event OnSelectST()
		_show_credits = !_show_credits
		
		if _show_credits
			(MY_QUEST as nl_curios_mcm_credits).RegisterModule("Credits", 1000)
		else
			(MY_QUEST as nl_curios_mcm_credits).UnregisterModule()
		endif

		RefreshPages()
	endevent
endstate

state exit_mcm
	event OnSelectST()
		CloseMCM(close_journal = true)
	endevent
endstate