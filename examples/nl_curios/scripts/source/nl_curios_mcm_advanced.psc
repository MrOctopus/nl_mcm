Scriptname nl_curios_mcm_advanced extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Left side
	AddHeaderOption(FONT_PRIMARY("Info"))
	AddParagraph("Welcome to the advanced section :)!", FONT_INFO())

	AddEmptyOption()
	AddTextOptionST("return_page", FONT_INFO("Return to main page"), "")

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("Misc"))
	AddToggleOptionST("misc_toggle_font", "Toggle font color", CURRENT_FONT)
	AddKeyMapOptionST("misc_key_mcm", "Set MCM hotkey", MCM_QuickHotkey)
	
	AddEmptyOption()
	AddInputOptionST("misc_input_landingpage", "Set the MCM landing page", "")
	AddInputOptionST("misc_input_setsplash", "Set splash settings", "")
	AddInputOptionST("misc_input_goto", "Go to page", "")

	AddEmptyOption()
	AddHeaderOption(FONT_PRIMARY("User presets"))
endevent

state misc_toggle_font
	event OnDefaultST()
		SetFont(FONT_TYPE_DEFAULT)
		ForcePageReset()
	endevent

	event OnHighlightST()
		SetInfoText("Toggle the font")
	endevent

	event OnSelectST()
		if CURRENT_FONT == FONT_TYPE_DEFAULT
			SetFont(FONT_TYPE_PAPER)
		else
			SetFont(FONT_TYPE_DEFAULT)
		endif

		ForcePageReset()
	endevent
endstate

state misc_key_mcm
	event OnDefaultST()
		MCM_QuickHotkey = -1
		SetKeyMapOptionValueST(-1)
	endevent

	event OnHighlightST()
		SetInfoText("Set the quickopen MCM hotkey")
	endevent

	event OnKeyMapChangeST(int keycode)
		MCM_QuickHotkey = keycode
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state misc_input_landingpage
	event OnHighlightST()
		SetInfoText("Set the MCM landing page")
	endevent

	event OnInputOpenST()
		SetInputDialogStartText("Page name")
	endevent
	
	event OnInputAcceptST(string str)
		SetLandingPage(str)
	endevent
endstate

state misc_input_setsplash
	event OnHighlightST()
		SetInfoText("Set the splash settings")
	endevent

	event OnInputOpenST()
		SetInputDialogStartText("path,x,y")
	endevent
	
	event OnInputAcceptST(string str)
		string[] settings = StringUtil.Split(str, ",")

		if settings.length != 3
			return
		endif

		SetSplashScreen(settings[0], settings[1] as float, settings[2] as float)
	endevent
endstate

state misc_input_goto
	event OnHighlightST()
		SetInfoText("Go to a specific mod page")
	endevent

	event OnInputOpenST()
		SetInputDialogStartText("Page name")
	endevent
	
	event OnInputAcceptST(string str)
		GoToPage(str)
	endevent
endstate

state return_page
	event OnHighlightST()
		SetInfoText("Return to the main page")
	endevent

	event OnSelectST()
		GoToPage("Core")
	endevent
endstate
