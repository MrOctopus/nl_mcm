Scriptname nl_utilities_mcm extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

nl_utilities_checkpoint nl_checkpoint

;------------------\
; REGISTER MOD PAGE \
;--------------------------------------------------------

; - Before register
event OnInit()
	RegisterModule("Utilities", 2, "nl_curios")
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
	if PlayerUpdatedOptions
		nl_checkpoint.RefreshKeys()
	endif
endevent

;---------------\
; PRESET HANDLER \
;--------------------------------------------------------

int function SaveData()
	; It doesn't matter what type of jcontainers object this is.
	; As long as you load the data the same way you saved it
	; it's fine
	int jObj = JMap.object()
	
	JMap.setInt(jObj, "checkpoint", nl_checkpoint.MarkerLimit)
	JMap.setInt(jObj, "scrollup", nl_checkpoint.KeyUp)
	JMap.setInt(jObj, "scrolldown", nl_checkpoint.KeyDown)
	JMap.setInt(jObj, "place", nl_checkpoint.KeyPlace)
	JMap.setInt(jObj, "move",  nl_checkpoint.KeyMove)
	JMap.setInt(jObj, "delete", nl_checkpoint.KeyDelete)

	return jObj
endfunction

function LoadData(int jObj)
	nl_checkpoint.MarkerLimit = JMap.getInt(jObj, "checkpoint")
	nl_checkpoint.KeyUp = JMap.getInt(jObj, "scrollup")
	nl_checkpoint.KeyDown = JMap.getInt(jObj, "scrolldown")
	nl_checkpoint.KeyPlace = JMap.getInt(jObj, "place")
	nl_checkpoint.KeyMove = JMap.getInt(jObj, "move")
	nl_checkpoint.KeyDelete = JMap.getInt(jObj, "delete")
endfunction

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
	event OnDefaultST(string state_id)
		nl_checkpoint.MarkerLimit = 10
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("")
	endevent
	
	event OnSliderOpenST(string state_id)
		SetSliderDialog(nl_checkpoint.MarkerLimit, 10, 30, 10.0, 10.0)
	endevent
	
	event OnSliderAcceptST(string state_id, float f)
		nl_checkpoint.MarkerLimit = f as int
		SetSliderOptionValueST(f)
	endevent
endstate

state checkp_key_up
	event OnDefaultST(string state_id)
		nl_checkpoint.KeyUp = 0x4E
		SetKeyMapOptionValueST(0x4E)
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(string state_id, int keycode)
		nl_checkpoint.KeyUp = keycode
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_dowm
	event OnDefaultST(string state_id)
		nl_checkpoint.KeyDown = 0x4A
		SetKeyMapOptionValueST(0x4A)
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(string state_id, int keycode)
		nl_checkpoint.KeyDown = keycode
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_place
	event OnDefaultST(string state_id)
		nl_checkpoint.KeyPlace = 0x9C
		SetKeyMapOptionValueST(0x9C)
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(string state_id, int keycode)
		nl_checkpoint.KeyPlace = keycode
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_move
	event OnDefaultST(string state_id)
		nl_checkpoint.KeyMove = 0x37
		SetKeyMapOptionValueST(0x37)
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(string state_id, int keycode)
		nl_checkpoint.KeyMove = keycode
		SetKeyMapOptionValueST(keycode)
	endevent
endstate

state checkp_key_delete
	event OnDefaultST(string state_id)
		nl_checkpoint.KeyDelete = 0xB5
		SetKeyMapOptionValueST(0xB5)
	endevent

	event OnHighlightST(string state_id)
		SetInfoText("")
	endevent

	event OnKeyMapChangeST(string state_id, int keycode)
		nl_checkpoint.KeyDelete = keycode
		SetKeyMapOptionValueST(keycode)
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
