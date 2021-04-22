Scriptname nl_curios_mcm_core extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

int[] _mcm_select_type
int _mcm_hotkey = 0xC5

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
	_mcm_select_type = new int[2]
	_mcm_select_type[1] = 1
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
		_mcm_hotkey = 0xC5
		SetKeyMapOptionValueST(0xC5)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		UnregisterForKey(_mcm_hotkey)
		_mcm_hotkey = keycode
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
		ExitMCM(true)
	endevent
endstate

;---------------\
; MCM QUICK OPEN \
;--------------------------------------------------------


float property _quick_e_cd_time = 0.5 autoreadonly

bool _quick_e_open
bool _quick_e_cd
bool _journal_open

event OnUpdate()
	_quick_e_cd = false
endevent

; What the fuck is happening here?
event OnMenuOpen(string menu_name)
	_journal_open = true

	if !_quick_e_open || _quick_e_cd
		return
	endif

	_quick_e_open = false
	_quick_e_cd = true
	_mcm_select_type[0] = MCM_ID

	; Let's avoid crashing shall we?
	if _mcm_select_type[0] < 0
		_quick_e_cd = false
		return
	endif

	string sort_event = MENU_ROOT + ".contentHolder.modListPanel.modListFader.list.entryList.sortOn"

	; Numeric sortOn
	int handle = UiCallback.Create(JOURNAL_MENU, sort_event)
	UiCallback.PushString(handle, "modIndex")
	UiCallback.PushInt(handle, 16)

	; Alphabetic caseinsensitive sortOn
	int handle2 = UiCallback.Create(JOURNAL_MENU, sort_event)
	UiCallback.PushString(handle2, "text")
	UiCallback.PushInt(handle2, 1)

	; Wait 0.2 seconds for the ConfigManager to setNames
	Utility.Wait(0.2)
	UiCallback.Send(handle)
	Ui.Invoke(JOURNAL_MENU, "_root.QuestJournalFader.Menu_mc.ConfigPanelOpen")
	Ui.InvokeIntA(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.modListFader.list.doSetSelectedIndex", _mcm_select_type)
	Ui.InvokeIntA(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.modListFader.list.onItemPress", _mcm_select_type)
	UiCallback.Send(handle2)

	RegisterForSingleUpdate(_quick_e_cd_time)
endevent

event OnMenuClose(string menu_name)
	_journal_open = false
endevent

event OnKeyDown(int keycode)
	; We need to be careful here to avoid crashing
	if _quick_e_cd
		return
	endif

	if _journal_open
		_quick_e_cd = true
		ExitMCM(true)
		RegisterForSingleUpdate(_quick_e_cd_time)
	else
		_quick_e_open = true
		Input.TapKey(Input.GetMappedKey("Journal"))
	endif
endevent