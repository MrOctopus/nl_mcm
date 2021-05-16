Scriptname nl_transmog_mcm extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

form[] _form_cache

;------------------\
; REGISTER MOD PAGE \
;--------------------------------------------------------

; - Before register
event OnInit()
	if RegisterModule("Transmogrifier", 1) != OK
		KeepTryingToRegister()
	endif
endevent

; - After register
event OnPageInit()
	_player = Game.GetPlayer()
	; Nothing to do yet!
endevent

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)

	; Left side
	AddHeaderOption(FONT_PRIMARY("Armors"))
	AddParagraph("Test", FONT_INFO())

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("Armors"))
	AddToggleOptionST("misc_toggle_font", "Toggle font color", CURRENT_FONT)
	AddEmptyOption()
	
	AddHeaderOption(FONT_PRIMARY("Weapons"))
endevent

;-------------\
; PAGE OPTIONS \
;--------------------------------------------------------


;-----\
; MISC \
;--------------------------------------------------------

string[] function GetInventoryArmors()
	int num_items = _player.GetNumItems()

	if num_items == 0
		return None
	endif

	int i = 0
	int num_armors

	form[] items = Utility.CreateFormArray(num_items)
	
	while i < num_items
		form tmp = _player.GetNthForm(i)

		if tmp as armor
			items[num_armors] = tmp
			num_armors += 1
		endif

		i += 1
	endwhile

	if num_armors == 0
		return None
	endif

	items = Utility.ResizeFormArray(items, num_armors)
	strings[] items_names = Utility.CreateStringArray(num_armors)
	
	while num_armors > 0
		num_armors -= 1
		item_names[num_armors] = items[num_armors].GetName()
	endwhile

	_form_cache = items
	return item_names
endfunction

function FilterArmors(form form)
endfunction

int function 

GetName()

Int GetNumItems()
(Container only) Returns the number of forms in the container.
Form GetNthForm(Int index)
(Container only) Returns the specified form from the container.