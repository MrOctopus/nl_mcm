Scriptname nl_mcm_core extends nl_mcm_module

; Version
int function GetVersion()
	return 1
endfunction

event OnVersionUpdate(int version)
	OnPageInit()
endevent

bool enabled
int keyc = 0x07

; - EVENTS
event OnInit()
	; First arg is page name
	; Second is Z index (0 is top page). Multiples of Z indexes can result in a random page order on first init
	; Third arg is a quest editor string for the MCM quest you want to attach to. Default is "" which is the same quest
	if RegisterModule("General", 0) != OK
		KeepTryingToRegister()
	endif
endEvent

event OnPageInit()
endevent

event OnPageDraw()
	SetCursorPosition(TOP_TO_BOTTOM)
	
	; Normal api
	AddHeaderOption("Core")
	AddParagraph("Hello my name is Gunnar, and I am from Norway. I came to the land of the vikings in pursuit of happiness.", "<font color='#000080'>", "</font>")
	AddToggleOptionST("enable_core", "Enable module", enabled)
	
	; Dangerous API (But can result in faster page draws)
	; Only recommended for Add calls, Set calls should use local
	nl_mcm raw = UNSAFE_RAW_MCM
	
	; Automatic keyconflict handling
	raw.AddKeyMapOptionST("random_state", "Test", keyc, OPTION_FLAG_WITH_UNMAP)
endEvent

; OPTION 1

state random_state
	event OnDefaultST()
		keyc = 0x07
		SetKeyMapOptionValueST(keyc)
	endEvent
	
	event OnKeyMapChangeST(int keycode)
		keyc = keycode
		SetKeyMapOptionValueST(keyc)
	endevent
endstate

state enable_core
	event OnDefaultST()
		enabled = false
		SetToggleOptionValueST(enabled)
	endEvent

	event OnHighlightST()
		SetInfoText("Press to toggle")
	endEvent

	event OnSelectST()
		enabled = !enabled
		SetToggleOptionValueST(enabled)
		
		; Allows refreshing pages
		RefreshPages()
		
		; Exit to MCM list
		; ExitMCM()
		
		; Exit entire journal
		; ExitMCM(true)
	endEvent
endstate
