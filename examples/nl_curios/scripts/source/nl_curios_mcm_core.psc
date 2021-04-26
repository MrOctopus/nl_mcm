Scriptname nl_curios_mcm_core extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

int _mcm_hotkey = -1

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
	RegisterForMenu(JOURNAL_MENU)
	RegisterForKey(_mcm_hotkey)
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
	AddKeyMapOptionST("misc_key_mcm", "Quick mcm Key", _mcm_hotkey)
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
		UnregisterForKey(_mcm_hotkey)
		_mcm_hotkey = -1
		SetKeyMapOptionValueST(-1)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		UnregisterForKey(_mcm_hotkey)
		_mcm_hotkey = keycode
		RegisterForKey(_mcm_hotkey)
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

;---------------\
; MCM QUICK OPEN \
;--------------------------------------------------------

; There are several ways to write the quick mcm open
; but this is the quickest and best one

bool _journal_open
bool _quick_open

event OnMenuOpen(string menu_name)
	_journal_open = true

	if !_quick_open
		return
	endif

	_quick_open = false

	while OpenMCM(skip_journal_check = true) == ERROR_MENU_COOLDOWN
		Utility.WaitMenuMode(0.1)
	endwhile
endevent

event OnMenuClose(string menu_name)
	_journal_open = false
	_quick_open = false
endevent

event OnKeyDown(int keycode)
	if _journal_open
		CloseMCM(close_journal = true)
	else
		_quick_open = true
		Input.TapKey(Input.GetMappedKey("Journal"))
	endif
endevent


; Another method is to do everything solely in the OnKeyDown event, but this is not very efficient:
;/
event OnKeyDown(int keycode)
	if Ui.IsMenuOpen(JOURNAL_MENU)
		CloseMCM(close_journal = true)
	else
		int upper_wait_limit = 5
		Input.TapKey(Input.GetMappedKey("Journal"))

		while upper_wait_limit > 0 
			int error_code = OpenMCM() 
		
			if error_code == ERROR_MENU_JOURNALCLOSED || error_code == ERROR_MENU_COOLDOWN 
				Utility.WaitMenuMode(0.3)
				upper_wait_limit -= 1
			else
				upper_wait_limit = 0
			endif
		endwhile
	endif
endevent
/;
