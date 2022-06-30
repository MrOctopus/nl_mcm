Scriptname nl_curios_mcm_advanced extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

;-----------\
; MOD EVENTS \
;--------------------------------------------------------

event OnGameReload()
	DEBUG_MSG("The module is registered: " + IsModuleRegistered)
endevent

;---------------\
; PRESET HANDLER \
;--------------------------------------------------------

int function SaveData()
	; It doesn't matter what type of jcontainers object this is.
	; As long as you load the data the same way you saved it
	; it's fine
	int jObj = JMap.object()
	
	; If you want to do version checking on save/loads
	; you should save the version along with the jContainers file
	JMap.setInt(jObj, "version", GetVersion())

	JMap.setInt(jObj, "mcmhotkey", QuickHotkey)

	return jObj
endfunction

function LoadData(int jObj)
	; Check for incompatible preset version
	int version = JMap.getInt(jObj, "version")

	if version != GetVersion()
		return
	endif

	QuickHotkey = JMap.getInt(jObj, "mcmhotkey")
endfunction

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Left side
	AddHeaderOption(FONT_PRIMARY("Info"))
	AddParagraph("Welcome to the advanced section :)!", FONT_INFO())

	AddEmptyOption()
	AddTextOptionST("misc_test_advanced", FONT_INFO("Test normal"), "")
	int i = 1
	while i <= 3
		AddTextOptionST("misc_test_advanced___" + i, FONT_INFO("Test advanced " + i), "")
		i += 1
	endwhile

	AddEmptyOption()
	AddTextOptionST("return_page", FONT_INFO("Return to main page"), "")

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("Misc"))
	AddToggleOptionST("misc_toggle_font", "Toggle font color", GetCurrentFont())
	AddKeyMapOptionST("misc_key_mcm", "Set MCM hotkey", QuickHotkey)
	
	AddEmptyOption()
	AddInputOptionST("misc_input_landingpage", "Set the MCM landing page", "")
	AddInputOptionST("misc_input_renamepage", "Rename this page", "")
	AddInputOptionST("misc_input_setsplash", "Set splash settings", "")
	AddInputOptionST("misc_input_goto", "Go to page", "")
endevent

;-------------\
; PAGE OPTIONS \
;--------------------------------------------------------

state misc_test_advanced
	event OnHighlightST(string state_id)
		SetInfoText("This is advanced option: " + state_id)
	endevent

	event OnSelectST(string state_id)
		ShowMessage("This is advanced option: " + state_id)
	endevent
endstate

state misc_toggle_font
	event OnDefaultST(string state_id)
		SetFont(FONT_TYPE_DEFAULT)
		ForcePageReset()
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("Toggle the font")
	endevent

	event OnSelectST(string state_id)
		if GetCurrentFont() == FONT_TYPE_DEFAULT
			SetFont(FONT_TYPE_PAPER)
		else
			SetFont(FONT_TYPE_DEFAULT)
		endif

		ForcePageReset()
	endevent
endstate

state misc_key_mcm
	event OnDefaultST(string state_id)
		QuickHotkey = -1
		SetKeyMapOptionValueST(-1)
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("Set the quickopen MCM hotkey")
	endevent

	event OnKeyMapChangeST(string state_id, int keycode)
		QuickHotkey = keycode
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state misc_input_landingpage
	event OnHighlightST(string state_id)
		SetInfoText("Set the MCM landing page")
	endevent

	event OnInputOpenST(string state_id)
		SetInputDialogStartText("Page name")
	endevent
	
	event OnInputAcceptST(string state_id, string str)
		SetLandingPage(str)
	endevent
endstate

state misc_input_renamepage
	event OnHighlightST(string state_id)
		SetInfoText("Rename this page")
	endevent

	event OnInputOpenST(string state_id)
		SetInputDialogStartText("Page name")
	endevent
	
	event OnInputAcceptST(string state_id, string str)
		RenameModule(str)
	endevent
endstate

state misc_input_setsplash
	event OnHighlightST(string state_id)
		SetInfoText("Set the splash settings")
	endevent

	event OnInputOpenST(string state_id)
		SetInputDialogStartText("path,x,y")
	endevent
	
	event OnInputAcceptST(string state_id, string str)
		string[] settings = StringUtil.Split(str, ",")

		if settings.length != 3
			return
		endif

		SetSplashScreen(settings[0], settings[1] as float, settings[2] as float)
	endevent
endstate

state misc_input_goto
	event OnHighlightST(string state_id)
		SetInfoText("Go to a specific mod page")
	endevent

	event OnInputOpenST(string state_id)
		SetInputDialogStartText("Page name")
	endevent
	
	event OnInputAcceptST(string state_id, string str)
		GoToPage(str)
	endevent
endstate

state return_page
	event OnHighlightST(string state_id)
		SetInfoText("Return to the main page")
	endevent

	event OnSelectST(string state_id)
		GoToPage("Core")
	endevent
endstate
