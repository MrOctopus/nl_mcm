Scriptname nl_mcm extends SKI_ConfigBase
{!!!!!!DO NOT RECOMPILE!!!!!!
	@author NeverLost
	@version 1.0.0	
}

int function GetVersion()
    return 100
endfunction

;----\------------\
; MCM \ PROPERTIES \
;--------------------------------------------------------

string property MCM_EXT = ".nlset" autoreadonly
string property MCM_PATH_SETTINGS
	string function get()
		Guard()
	endfunction
endproperty

int property MCM_ID
	int function get()
		Guard()
	endfunction
endproperty

; MISC CONSTANTS
float property SPINLOCK_TIMER = 0.4 autoreadonly
float property BUFFER_TIMER = 2.0 autoreadonly
int property LINE_LENGTH = 47 autoreadonly

; ERROR CODES
int property OK = 1 autoreadonly
int property ERROR = 0 autoreadonly

int property ERROR_MODULE_FULL = -1 autoreadonly
int property ERROR_MODULE_TAKEN = -2 autoreadonly
int property ERROR_MODULE_INIT = -3 autoreadonly
int property ERROR_MODULE_NONE = -4 autoreadonly

int property ERROR_MENU_NOID = -100 autoreadonly
int property ERROR_MENU_COOLDOWN = -200 autoreadonly
int property ERROR_MENU_JOURNALCLOSED = -300 autoreadonly
int property ERROR_MENU_NOTOWNER = -400 autoreadonly

; EVENT CODES
int property EVENT_DEFAULT = 0 autoreadonly
int property EVENT_HIGHLIGHT = 1 autoreadonly
int property EVENT_SELECT = 2 autoreadonly
int property EVENT_OPEN = 3 autoreadonly
int property EVENT_ACCEPT = 4 autoreadonly
int property EVENT_CHANGE = 5 autoreadonly

; FONTS
int property FONT_DEFAULT = 0x00 autoreadonly
int property FONT_PAPER = 0x01 autoreadonly

;---------\--------\
; CRITICAL \ EVENTS \
;--------------------------------------------------------

event OnGameReload()
	Guard()
endevent

event OnUpdate()	
	Guard()
endevent

event OnConfigClose()
	Guard()
endevent

event OnDefaultST()
	Guard()
endEvent

event OnKeyMapChangeST(int keycode, string conflict_control, string conflict_name)	
	Guard()
endEvent

;---------\-----------\
; CRITICAL \ FUNCTIONS \
;--------------------------------------------------------

int function _RegisterModule(nl_mcm_module module, string page_name, int z)				
	Guard()
endfunction

int function _UnregisterModule(string page_name)
	Guard()
endfunction

function SaveMCMToPreset(string preset_path)
	Guard()
endFunction

function LoadMCMFromPreset(string preset_path)
	Guard()
endFunction

string function GetCommonStore(string page_name, bool lock)
	Guard()
endfunction

function SetCommonStore(string page_name, string new_value)
	Guard()
endfunction

function AddKeyMapOptionST(String a_stateName, String a_text, Int a_keycode, Int a_flags = 0)
	Guard()
endfunction

function SetKeyMapOptionValueST(int a_keycode, bool no_update = false, string a_stateName = "")
	Guard()
endfunction

string function GetCustomControl(int a_keycode)
	Guard()
endfunction

function SetPage(String a_page, Int a_index)	
	Guard()
endFunction

;-------------\--------\
; NON-CRITICAL \ EVENTS \
;--------------------------------------------------------

event OnInit()
	Guard()
endevent

event OnConfigManagerReset(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	Guard()
endEvent

event OnConfigManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	Guard()
 endEvent

; Possible thrown exception
event OnPageReset(string page)
	Guard()
endevent

event OnHighlightST()
    Guard()
endEvent

event OnSelectST()
    Guard()
endEvent

event OnSliderOpenST()
    Guard()
endEvent

event OnMenuOpenST()
    Guard()
endEvent

event OnColorOpenST()
    Guard()
endEvent

event OnSliderAcceptST(float f)
    Guard()
endEvent
    
event OnMenuAcceptST(int i)
    Guard()
endEvent
    
event OnColorAcceptST(int col)
    Guard()
endEvent

event OnInputOpenST()
	Guard()
endEvent

event OnInputAcceptST(string str)
    Guard()
endEvent

;-------------\-----------\
; NON-CRITICAL \ FUNCTIONS \
;--------------------------------------------------------

; Possible thrown exception
function RelayPageEvent(string state_name, int event_id, float f = -1.0, string str = "")
	Guard()
endfunction

string[] function GetMCMSavedPresets(string default, string dir_path)
	Guard()
endfunction

function DeleteMCMSavedPreset(string preset_path)
	Guard()
endfunction

function AddParagraph(string text, string format = "", int flags = 0x01)
	Guard()
endfunction

function SetModName(string name)
	Guard()
endfunction

function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
	Guard()
endfunction

function SetFont(int font = 0x00)
	Guard()
endfunction

function SetSliderDialog(float value, float range_start, float range_end, float interval, float default = 0.0)
	Guard()
endFunction 

function SetMenuDialog(string[] options, int start_i, int default_i = 0)
    Guard()
endFunction

function RefreshPages()
	Guard()
endFunction

int function OpenMCM(bool skip_journal_check = false)
	Guard()
endfunction

int function CloseMCM(bool close_journal = false)
	Guard()
endfunction

;------\
; GUARD \
;--------------------------------------------------------

function Guard()
	Debug.MessageBox("SKI_ConfigBase: Don't recompile this script!")
endFunction
