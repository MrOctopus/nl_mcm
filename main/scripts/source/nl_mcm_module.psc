Scriptname nl_mcm_module extends Quest
{!!!!!!DO NOT RECOMPILE!!!!!!
	@author NeverLost
	@version 1.0.0	
}

import Ui
import Debug

;-------\----------\
; MODULE \ INTERNAL \ - ALSO KNOWN AS, IGNORE THIS SECTION
;--------------------------------------------------------

int property EVENT_DEFAULT = 0 autoreadonly
int property EVENT_HIGHLIGHT = 1 autoreadonly
int property EVENT_SELECT = 2 autoreadonly
int property EVENT_OPEN = 3 autoreadonly
int property EVENT_ACCEPT = 4 autoreadonly
int property EVENT_CHANGE = 5 autoreadonly

string property MENU_ROOT
	string function Get()
		return "_root.ConfigPanelFader.configPanel"
	endfunction
endproperty

string property JOURNAL_MENU
	string function Get()
		return "Journal Menu"
	endfunction
endproperty

string property MSG_ERROR
	string function Get()
		return "NL_MCM(" + _page_name + "): An error occured."
	endfunction
endproperty

string property MSG_ERROR_INACTIVE
	string function Get()
		return "NL_MCM(" + _page_name + "): WARN, A function has been called in an invalid state"
	endfunction
endproperty

string property MSG_ERROR_NOT_FOUND
	string function Get()
		return "NL_MCM(" + _page_name + "): Quest with editor id " + _quest_editorid + " could not be found."
	endfunction
endproperty

string property MSG_ERROR_MCM_NOT_FOUND
	string function Get()
		return "NL_MCM(" + _page_name + "): Quest with editor id " + _quest_editorid + " has no nl_mcm attached."
	endfunction
endproperty

string property MSG_ERROR_MAX_PAGE_REACHED
	string function Get()
		return "NL_MCM(" + _page_name + "): The hooked MCM has already reached the page limit."
	endfunction
endproperty

string property MSG_ERROR_PAGE_NAME_TAKEN
	string function Get()
		return "NL_MCM(" + _page_name + "): The hooked MCM already has a page with the same name."
	endfunction
endproperty

string property MSG_ERROR_NOT_INITIALIZED
	string function Get()
		return "NL_MCM(" + _page_name + "): The hooked MCM is not initialized."
	endfunction
endproperty

string property MSG_ERROR_PAGE_NOT_FOUND
	string function Get()
		return "NL_MCM(" + _page_name + "): The hooked MCM has no matching page name."
	endfunction
endproperty

nl_mcm MCM
string _quest_editorid
string _page_name
int _z
int _current_version

event _OnPageDraw()
	Guard()
endevent

event _OnPageEvent(string state_name, int event_id, float f, string str)
	Guard()
endevent

auto state _inactive
	event OnMenuOpen(string name)
		Guard()
	endevent

	event _OnPageDraw()
		Guard()
	endevent

	event _OnPageEvent(string state_name, int event_id, float f, string str)
		Guard()
	endevent

	function AddParagraph(string text, string begin_format = "", string end_format = "", int flags = 0x01)
		Guard()
	endfunction
	
	int function SetModName(string name)
		Guard()
		return ERROR
	endfunction
	
	function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
		Guard()
	endfunction
	
	function SetSliderDialog(float value, float range_start, float range_end, float interval, float default)
		Guard()
	endFunction 
	
	function SetMenuDialog(string[] options, int start_i, int default_i = 0)
		Guard()
	endFunction
	
	function RefreshPages()
		Guard()
	endfunction
	
	function ExitMCM(bool fully = false)
		Guard()
	endfunction

	function SetCursorFillMode(int a_fillMode)
		Guard()
	endfunction
	
	int function AddHeaderOption(string a_text, int a_flags = 0)
		Guard()
		return ERROR
	endfunction
	
	int function AddEmptyOption()
		Guard()
		return ERROR
	endfunction
	
	function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
		Guard()
	endfunction
	
	function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0)
		Guard()
	endfunction
	
	function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
		Guard()
	endfunction
	
	function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
		Guard()
	endfunction
	
	function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0)
		Guard()
	endfunction
	
	function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0)	
		Guard()
	endfunction
	
	function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "")
		Guard()
	endfunction
	
	function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
		Guard()
	endfunction
	
	function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "")
		Guard()
	endfunction
	
	function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "")	
		Guard()
	endfunction
	
	function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
		Guard()
	endfunction
	
	function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "")
		Guard()
	endfunction
	
	function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "")
		Guard()
	endfunction
	
	function SetSliderDialogStartValue(float a_value)
		Guard()
	endfunction
	
	function SetSliderDialogDefaultValue(float a_value)
		Guard()
	endfunction
	
	function SetSliderDialogRange(float a_minValue, float a_maxValue)
		Guard()
	endfunction
	
	function SetSliderDialogInterval(float a_value)
		Guard()
	endfunction
	
	function SetMenuDialogStartIndex(int a_value)
		Guard()
	endfunction
	
	function SetMenuDialogDefaultIndex(int a_value)
		Guard()
	endfunction
	
	function SetMenuDialogOptions(string[] a_options)
		Guard()
	endfunction
	
	function SetColorDialogStartColor(int a_color)
		Guard()
	endfunction
	
	function SetColorDialogDefaultColor(int a_color)
		Guard()
	endfunction
	
	function SetCursorPosition(int a_position)
		Guard()
	endfunction
	
	function SetInfoText(string a_text)
		Guard()
	endfunction
	
	function ForcePageReset()
		Guard()
	endfunction
	
	function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0)
		Guard()
	endfunction
	
	function UnloadCustomContent()
		Guard()
	endfunction
	
	bool function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel")
		Guard()
		return ERROR as bool
	endfunction
	
	int function SaveMCMToPreset(string preset_name)
		Guard()
		return ERROR
	endfunction
	
	int function LoadMCMFromPreset(string preset_name, bool no_ext = false)
		Guard()
		return ERROR
	endfunction
	
	int function GetMCMSavedPresets(string[] none_array, string default_fill, bool no_ext = true)
		Guard()
		return ERROR
	endfunction 
	
	int function DeleteMCMSavedPreset(string preset_name)
		Guard()
		return ERROR
	endfunction

;-------\-----\
; MODULE \ API \
;--------------------------------------------------------

	int function KeepTryingToRegister()
		Guard()
		return ERROR
	endfunction
	
	int function StopTryingToRegister()
		Guard()
		return ERROR
	endfunction

	int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")				
		Guard()
		return ERROR
	endfunction
		
	int function UnregisterModule()
		Guard()
		return ERROR
	endfunction
endstate

int function KeepTryingToRegister()
	Guard()
	return ERROR
endfunction

int function StopTryingToRegister()
	Guard()
	return ERROR
endfunction

int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")
	Guard()
	return ERROR
endfunction

int function UnregisterModule()
	Guard()
	return ERROR
endfunction

;--------\-----\
; MCM API \ NEW \
;--------------------------------------------------------

; MODULE CODES
int property OK = 1 autoreadonly
int property ERROR = 0 autoreadonly
int property ERROR_NOT_FOUND = -1 autoreadonly
int property ERROR_MCM_NOT_FOUND = -2 autoreadonly
int property ERROR_MAX_PAGE_REACHED = -3 autoreadonly
int property ERROR_PAGE_NAME_TAKEN = -4 autoreadonly
int property ERROR_NOT_INITIALIZED = -5 autoreadonly
int property ERROR_PAGE_NOT_FOUND = -6 autoreadonly
int property ERROR_PRESET_NOT_FOUND = -7 autoreadonly
int property ERROR_LOADING_DATA = -8 autoreadonly
int property ERROR_BUSY_WITH_DATA = -9 autoreadonly

; PROPERTIES
nl_mcm property UNSAFE_RAW_MCM
    nl_mcm function Get()
        return MCM
    endFunction
endproperty

quest property OWNING_QUEST
	quest function Get()
		return MCM as quest
	endfunction
endproperty

string property COMMON_STORE
	string function Get()
		return MCM.COMMON_STORE
	endfunction

	function Set(string store)
		MCM.COMMON_STORE = store
	endfunction
endproperty

function AddParagraph(string text, string begin_format = "", string end_format = "", int flags = 0x01)
	Guard()
endfunction

int function SetModName(string name)
	Guard()
	return ERROR
endfunction

function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
	Guard()
endfunction

function SetSliderDialog(float value, float range_start, float range_end, float interval, float default)
	Guard()
endFunction 

function SetMenuDialog(string[] options, int start_i, int default_i = 0)
	Guard()
endFunction

function RefreshPages()
	Guard()
endfunction

function ExitMCM(bool fully = false)
	Guard()
endfunction

;--------\----------\
; MCM API \ ORIGINAL \
;--------------------------------------------------------

; PAGE
int property OPTION_FLAG_NONE = 0x00 autoReadonly
int property OPTION_FLAG_DISABLED = 0x01 autoReadonly
int property OPTION_FLAG_HIDDEN	 = 0x02 autoReadonly
int property OPTION_FLAG_WITH_UNMAP	= 0x04 autoReadonly

int property LEFT_TO_RIGHT = 1 autoReadonly
int property TOP_TO_BOTTOM = 2 autoReadonly

; VERSION
int property CurrentVersion hidden
    int function Get()
        return ERROR
    endFunction
endproperty

function SetCursorFillMode(int a_fillMode)
	Guard()
endfunction

int function AddHeaderOption(string a_text, int a_flags = 0)
	Guard()
	return ERROR
endfunction

int function AddEmptyOption()
	Guard()
	return ERROR
endfunction

function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
	Guard()
endfunction

function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0)
	Guard()
endfunction

function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
	Guard()
endfunction

function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
	Guard()
endfunction

function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0)
	Guard()
endfunction

function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0)	
	Guard()
endfunction

function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "")
	Guard()
endfunction

function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
	Guard()
endfunction

function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "")
	Guard()
endfunction

function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "")	
	Guard()
endfunction

function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
	Guard()
endfunction

function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "")
	Guard()
endfunction

function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "")
	Guard()
endfunction

function SetSliderDialogStartValue(float a_value)
	Guard()
endfunction

function SetSliderDialogDefaultValue(float a_value)
	Guard()
endfunction

function SetSliderDialogRange(float a_minValue, float a_maxValue)
	Guard()
endfunction

function SetSliderDialogInterval(float a_value)
	Guard()
endfunction

function SetMenuDialogStartIndex(int a_value)
	Guard()
endfunction

function SetMenuDialogDefaultIndex(int a_value)
    Guard()
endfunction

function SetMenuDialogOptions(string[] a_options)
	Guard()
endfunction

function SetColorDialogStartColor(int a_color)
	Guard()
endfunction

function SetColorDialogDefaultColor(int a_color)
	Guard()
endfunction

function SetCursorPosition(int a_position)
	Guard()
endfunction

function SetInfoText(string a_text)
	Guard()
endfunction

function ForcePageReset()
	Guard()
endfunction

function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0)
	Guard()
endfunction

function UnloadCustomContent()
	Guard()
endfunction

bool function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel")
	Guard()
	return ERROR
endfunction

int function SaveMCMToPreset(string preset_name)
	Guard()
	return ERROR
endfunction

int function LoadMCMFromPreset(string preset_name)
	Guard()
	return ERROR
endfunction

int function GetMCMSavedPresets(string[] none_array, string default, string dir_path = ".")
	Guard()
	return ERROR
endfunction 

int function DeleteMCMSavedPreset(string preset_name)
	Guard()
	return ERROR
endfunction

;-------------\
; OVERRIDE API \
;--------------------------------------------------------

int function GetVersion()
	return ERROR
endfunction

int function SaveData()
	Guard()
	return ERROR
endfunction

function LoadData(int jObj)
	Guard()
endfunction

event OnVersionUpdateBase(int a_version)
	Guard()
endevent

event OnVersionUpdate(int a_version)
	Guard()
endevent

event OnConfigClose()
	Guard()
endevent

event OnPageInit()
	Guard()
endevent

event OnPageDraw()
	Guard()
endevent

event OnDefaultST()
	Guard()
endevent

event OnHighlightST()
	Guard()
endevent

event OnSelectST()
	Guard()
endevent

event OnSliderOpenST()
	Guard()
endevent

event OnMenuOpenST()
	Guard()
endevent

event OnColorOpenST()
	Guard()
endevent

event OnSliderAcceptST(float f)
	Guard()
endevent

event OnMenuAcceptST(int i)
	Guard()
endevent

event OnColorAcceptST(int col)
	Guard()
endevent

event OnInputOpenST()
	Guard()
endevent

event OnInputAcceptST(string str)
	Guard()
endevent

event OnKeyMapChangeST(int keycode)
	Guard()
endevent

;------\
; GUARD \
;--------------------------------------------------------

function Guard()
	Debug.MessageBox("SKI_ConfigBase: Don't recompile this script!")
endFunction

