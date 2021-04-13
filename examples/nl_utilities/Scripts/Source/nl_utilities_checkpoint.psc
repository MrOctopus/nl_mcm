Scriptname nl_utilities_checkpoint extends ReferenceAlias  
{
	@author NeverLost
	@version 1.0
}

import Debug

;-----------\
; PROPERTIES \
;--------------------------------------------------------

static property HeadingMarker auto

int property KeyUp = 0x4E auto hidden 		; + 0x4E Move up list
int property KeyDown = 0x4A auto hidden 	; - 0x4A Move down list
int property KeyPlace = 0x9C auto hidden 	; E 0x9C Place
int property KeyMove = 0x37 auto hidden 	; * 0x37 Moveto
int property KeyDelete = 0xB5 auto hidden 	; / 0xB5 Delete
int property MarkerLimit hidden
	function Set(int val)
		if val == _marker_limit
			return
		endif

		_marker_limit = val

		if _used_markers > _marker_limit
			_used_markers = _marker_limit

			if _current_selection >= _marker_limit
				_current_selection = _marker_limit - 1
			endif
		endif

		objectreference[] _empty_array = CreateObjectReferenceArray(_marker_limit)

		if _used_markers > 0
			_placed_markers = TransferObjectReferenceFromTo(_placed_markers, _empty_array)
		else
			_placed_markers = _empty_array
		endif
	endfunction

	int function Get()
		return _marker_limit
	endfunction
endproperty

;----------\
; VARIABLES \
;--------------------------------------------------------

int _open_menus
int _marker_limit = 10
int _used_markers
int _current_selection

objectreference[] _placed_markers
actor _player

;-------\
; EVENTS \
;--------------------------------------------------------

event OnInit()
	_player = self.GetActorReference()
	_placed_markers = CreateObjectReferenceArray(_marker_limit)
	Setup()
endevent

event OnPlayerLoadGame()
	Setup()
endevent

event OnMenuOpen(String MenuName)
	GotoState("InMenu")
endevent

;----------\
; FUNCTIONS \
;--------------------------------------------------------

function Setup()
	; Menus
	_open_menus = 0
	GoToState("Active")
	
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("MagicMenu")
	RegisterForMenu("FavoritesMenu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("BarterMenu")
	RegisterForMenu("Crafting Menu")
	RegisterForMenu("Dialogue Menu")
	RegisterForMenu("CustomMenu")
	RegisterForMenu("Journal Menu")
	RegisterForMenu("Console")
	RegisterForMenu("GiftMenu")
	RegisterForMenu("Lockpicking Menu")
	RegisterForMenu("Sleep/Wait Menu")
	RegisterForMenu("StatsMenu")
	RegisterForMenu("Training Menu")
	RegisterForMenu("TweenMenu")
	RegisterForMenu("Quantity Menu")
	RegisterForMenu("MessageBoxMenu")
	RegisterForMenu("Book Menu")
	RegisterForMenu("MapMenu")
	
	; Keys
	RefreshKeys()
endfunction

function ScrollUp()
	_current_selection = (_current_selection + 1) % _used_markers
	Notification("Current selection is " + (_current_selection + 1) + " out of possible "+_used_markers)
endfunction

function ScrollDown()
	_current_selection -= 1
	
	if _current_selection < 0
		_current_selection = _used_markers - 1
	endif

	Notification("Current selection is " + (_current_selection + 1) + " out of possible "+_used_markers)
endfunction

function PlaceMarker()
	if _used_markers == MarkerLimit
		Notification("Marker limit has been hit: " + MarkerLimit + ". Delete a marker before placing new ones!")
	else
		; Get Angle
		float x = _player.GetAngleX()
		float y = _player.GetAngleY()
		float z = _player.GetAngleZ()
		
		; Place and correct
		_placed_markers[_used_markers] = _player.PlaceAtMe(HeadingMarker)
		_placed_markers[_used_markers].SetAngle(x, y, z)
		
		_used_markers += 1
		Notification("A new marker has been set in slot " + _used_markers)
	endif
endfunction

function TeleportToMarker()
	_player.MoveTo(_placed_markers[_current_selection])
	Notification("You have been moved to marker " + (_current_selection + 1))
endfunction

function DeleteMarker()
	; Delete
	_placed_markers[_current_selection].Delete()
	_placed_markers[_current_selection].Disable()
	_placed_markers[_current_selection] = None
	
	Notification("Marker " + (_current_selection + 1) + " has been deleted. " + (_used_markers - 1) + " markers remain")
	
	; If not last rearrange array and keep selection
	if _current_selection + 1 != _used_markers
		int i = _current_selection + 1
		
		while i < MarkerLimit && _placed_markers[i] != None
			_placed_markers[i - 1] = _placed_markers[i]
			i += 1
		endwhile
		
	; Else if above zero, decrement
	elseif _current_selection > 0
		_current_selection -= 1
	endif
	
	_used_markers -= 1
endfunction

;-------\
; STATES \
;--------------------------------------------------------

state Active
	event OnKeyDown(Int keycode)
		if keycode == KeyPlace
			PlaceMarker()
		elseif _used_markers == 0
			Notification("Place a marker before attempting to use any other keys")
		
		elseif keycode == KeyUp
			ScrollUp()
		elseif keycode == KeyDown
			ScrollDown()			
		elseif keycode == KeyMove
			TeleportToMarker()
		elseif keycode == KeyDelete
			DeleteMarker()
		endif
	endevent
endstate

state InMenu
	event OnBeginState()
		_open_menus += 1
	endevent

	event OnMenuClose(String menu_name)
		_open_menus -= 1
		if _open_menus == 0
			GotoState("Active")
		endIf
	endevent

	event OnMenuOpen(String menu_name)
		_open_menus += 1
	endevent
endstate

;--------\
; UTILITY \
;--------------------------------------------------------

function RefreshKeys()
	UnregisterForAllKeys()
	RegisterForKey(KEYUP)
	RegisterForKey(KEYDOWN)
	RegisterForKey(KEYPLACE)
	RegisterForKey(KEYMOVE)
	RegisterForKey(KEYDELETE)
endfunction

objectreference[] function CreateObjectReferenceArray(int size)
	if size >= 30
		return new objectreference[30] 
	elseif size >= 20
		return new objectreference[20]
	endif
	
	return new objectreference[10]
endfunction

objectreference[] function TransferObjectReferenceFromTo(objectreference[] from, objectreference[] to)
	int i = to.length
	int j = from.length

	; Delete from objects if from > to
	while i < j
		if from[i]
			from[i].Delete()
			from[i].Disable()
			i += 1
		else
			i = j	
		endif
	endwhile

	i = 0
	j = to.length

	; Transfer objects
	while i < j
		if from[i]
			to[i] = from[i]
		else
			i = j
		endif
	endwhile

	return to
endfunction