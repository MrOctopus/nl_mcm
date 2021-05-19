Scriptname nl_utilities_mcm extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

nl_utilities_checkpoint nl_checkpoint
bool _refresh_keys

;------------------\
; REGISTER MOD PAGE \
;--------------------------------------------------------

; - Before register
event OnInit()
	if RegisterModule("Utilities", 2, "nl_curios") != OK
		KeepTryingToRegister()
	endif
endevent

; - After register
event OnPageInit()
	; Get player ref
	alias player = (self as quest).GetAliasByName("PlayerRef")
	
	; Get attached scripts
	nl_checkpoint = player as nl_utilities_checkpoint
endevent

;-------------\
; CONFIG CLOSE \
;--------------------------------------------------------

event OnConfigClose()
	if _refresh_keys
		_refresh_keys = false
		nl_checkpoint.RefreshKeys()
	endif
endevent

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Left side
	AddHeaderOption(FONT_PRIMARY("Info"))
	AddParagraph("This module provides various new cool utilities", FONT_INFO())

	AddEmptyOption()
	AddTextOptionST("return_page", FONT_INFO("Return to main page"), "")
	
	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("Checkpoint Settings"))
	AddSliderOptionST("checkp_limit", "Checkpoint limit", nl_checkpoint.MarkerLimit)
	AddKeyMapOptionST("checkp_key_up", "Scroll up", nl_checkpoint.KeyUp)
	AddKeyMapOptionST("checkp_key_down", "Scroll down", nl_checkpoint.KeyDown)
	AddKeyMapOptionST("checkp_key_place", "Place new marker", nl_checkpoint.KeyPlace)
	AddKeyMapOptionST("checkp_key_move", "Teleport to marker", nl_checkpoint.KeyMove)
	AddKeyMapOptionST("checkp_key_delete", "Delete selected marker", nl_checkpoint.KeyDelete)
	AddEmptyOption()
endevent

;-------------\
; PAGE OPTIONS \
;--------------------------------------------------------

state checkp_limit
	event OnDefaultST()
		nl_checkpoint.MarkerLimit = 10
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent
	
	event OnSliderOpenST()
		SetSliderDialog(nl_checkpoint.MarkerLimit, 10, 30, 10.0, 10.0)
	endevent
	
	event OnSliderAcceptST(float f)
		nl_checkpoint.MarkerLimit = f as int
		SetSliderOptionValueST(f)
	endevent
endstate

state checkp_key_up
	event OnDefaultST()
		nl_checkpoint.KeyUp = 0x4E
		_refresh_keys = true
		SetKeyMapOptionValueST(0x4E)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		nl_checkpoint.KeyUp = keycode
		_refresh_keys = true
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_dowm
	event OnDefaultST()
		nl_checkpoint.KeyDown = 0x4A
		_refresh_keys = true
		SetKeyMapOptionValueST(0x4A)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		nl_checkpoint.KeyDown = keycode
		_refresh_keys = true
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_place
	event OnDefaultST()
		nl_checkpoint.KeyPlace = 0x9C
		_refresh_keys = true
		SetKeyMapOptionValueST(0x9C)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		nl_checkpoint.KeyPlace = keycode
		_refresh_keys = true
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_move
	event OnDefaultST()
		nl_checkpoint.KeyMove = 0x37
		_refresh_keys = true
		SetKeyMapOptionValueST(0x37)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		nl_checkpoint.KeyMove = keycode
		_refresh_keys = true
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_delete
	event OnDefaultST()
		nl_checkpoint.KeyDelete = 0xB5
		_refresh_keys = true
		SetKeyMapOptionValueST(0xB5)
	endevent

	event OnHighlightST()
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(int keycode)
		nl_checkpoint.KeyDelete = keycode
		_refresh_keys = true
		SetKeyMapOptionValueST(keycode)
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
