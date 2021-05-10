Scriptname nl_curios_mcm_core extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

bool _show_secret_page

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

	; This will cache if the call above fails
	SetModName("NeverLost's Curios")
endevent

; - After register
event OnPageInit()
	; Do nothing
endevent

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)

	; Left side
	AddHeaderOption(FONT_PRIMARY("Core"))
	AddParagraph("Hello there! This mcm acts as a core for all my small miscellaneous mods. Be on the lookout for new pages!", FONT_INFO())
	AddEmptyOption()
	AddEmptyOption()

	AddHeaderOption(FONT_PRIMARY("Thanks to"))
	AddParagraph("Dunc001\nKojak747\nFireundubh", FONT_INFO())

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("Misc"))
	AddToggleOptionST("misc_toggle_font", "Toggle font color", CURRENT_FONT)
	AddKeyMapOptionST("misc_key_mcm", "Quick mcm Key", MCM_QUICK_HOTKEY)
	AddEmptyOption()

	AddHeaderOption(FONT_PRIMARY("Fun"))

	if _show_secret_page
		AddTextOptionST("fun_show_page", "", FONT_WARNING("Discovered!"), OPTION_FLAG_DISABLED)
	else
		AddTextOptionST("fun_show_page", "", FONT_SUCCESS("Hidden..."))
	endif

	AddTextOptionST("fun_exit_mcm", "", FONT_DANGER("CLICK ME!"))
endevent

;-------------\
; PAGE OPTIONS \
;--------------------------------------------------------

state misc_toggle_font
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

state misc_key_mcm
	event OnDefaultST()
		MCM_QUICK_HOTKEY = -1
		SetKeyMapOptionValueST(-1)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		MCM_QUICK_HOTKEY = keycode
		SetKeyMapOptionValueST(keycode)
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
		CloseMCM(close_journal = true)
	endevent
endstate