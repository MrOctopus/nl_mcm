Scriptname nl_curios_mcm_core extends nl_mcm_module

bool _show_secret_page

;------------------\
; REGISTER MOD PAGE \
;--------------------------------------------------------

; Before register
event OnInit()
	; It's good practice to check if we actually succeeded
	; in registering the module.
	if RegisterModule("Core", 0) != OK
		KeepTryingToRegister()
	endif

	; This will cache if the call above fails
	SetModName("NeverLost's Curios")
endevent

; After register
event OnPageInit()
	; Nothing to do yet!
endevent

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Left side
	AddHeaderOption(FONT_HEADER("Core"))
	AddParagraph("Hello there! This mcm acts as a core for all my small miscellaneous mods. Be on the lookout for new pages!", FONT_HELP())
	AddEmptyOption()
	AddEmptyOption()

	AddHeaderOption(FONT_HEADER("Thanks to"))
	AddParagraph("Duncan\nKojak\nFireundubh", FONT_ENABLED())

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_HEADER("Misc"))
	AddToggleOptionST("options_toggle_font", "Toggle font color", CURRENT_FONT)
	AddEmptyOption()

	AddHeaderOption(FONT_HEADER("Fun"))

	if _show_secret_page
		AddTextOptionST("fun_show_page", "", FONT_DISABLED("Discovered!"), OPTION_FLAG_DISABLED)
	else
		AddTextOptionST("fun_show_page", "", FONT_ENABLED("Hidden..."))
	endif

	AddTextOptionST("fun_exit_mcm", "", FONT_ENABLED("CLICK ME!"))
endevent

;-------------\
; PAGE OPTIONS \
;--------------------------------------------------------

state options_toggle_font
	event OnDefaultST()
		SetFont(FONT_DEFAULT)
		ForcePageReset()
	endevent

	event OnHighlightST()
		SetInfoText("Toggle the font.")
	endevent

	event OnSelectST()
		if CURRENT_FONT == FONT_DEFAULT
			SetFont(FONT_PAPER)
		else
			SetFont(FONT_DEFAULT)
		endif

		ForcePageReset()
	endevent
endstate

state fun_show_page
	event OnHighlightST()
		SetInfoText("Do you dare?")
	endevent

	event OnSelectST()
		_show_secret_page = true
		(OWNING_QUEST as nl_curios_mcm_secret).RegisterModule("Secret", 1)
		RefreshPages()
	endevent
endstate

state fun_exit_mcm
	event OnHighlightST()
		SetInfoText("Do you dare?")
	endevent

	event OnSelectST()
		ExitMCM(true)
	endevent
endstate
