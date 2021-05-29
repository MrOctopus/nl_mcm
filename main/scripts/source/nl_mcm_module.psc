Scriptname nl_mcm_module extends Quest
{!!!!!!DO NOT RECOMPILE!!!!!!
	@author NeverLost
	@version 1.0.0	
}

;-------\----------\
; MODULE \ INTERNAL \ - ALSO KNOWN AS, IGNORE THIS SECTION
;--------------------------------------------------------

int property EVENT_DEFAULT = 0 autoreadonly
int property EVENT_HIGHLIGHT = 1 autoreadonly
int property EVENT_SELECT = 2 autoreadonly
int property EVENT_OPEN = 3 autoreadonly
int property EVENT_ACCEPT = 4 autoreadonly
int property EVENT_CHANGE = 5 autoreadonly

string property DEBUG_MSG
	string function Get()
		Guard()
	endfunction
endproperty

event _OnPageDraw(int font)
	Guard()
endevent

event _OnPageEvent(string state_name, int event_id, float f, string str)
	Guard()
endevent

auto state _inactive
	event _OnConfigManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
		Guard()
	endevent

	event _OnPageDraw(int font)
		Guard()
	endevent

	event _OnPageEvent(string state_name, int event_id, float f, string str)
		Guard()
	endevent

	function AddParagraph(string text, string format = "", int flags = 0x01)
		Guard()
	endfunction
	
	function SetSliderDialog(float value, float range_start, float range_end, float interval, float default = 0.0)
		Guard()
	endFunction 
	
	function SetMenuDialog(string[] options, int start_i, int default_i = 0)
		Guard()
	endFunction
	
	function RefreshPages(bool stay = true)
		Guard()
	endfunction

	function GoToPage(string page_name)
		Guard()
	endfunction
	
	function CloseMCM(bool close_journal = false)
		Guard()
	endfunction

	function SaveMCMToPreset(string preset_path)
		Guard()
	endfunction
	
	function LoadMCMFromPreset(string preset_path)
		Guard()
	endfunction
	
	string[] function GetMCMSavedPresets(string default, string dir_path = ".")
		Guard()
	endfunction 
	
	function DeleteMCMSavedPreset(string preset_path)
		Guard()
	endfunction

	function SetCursorFillMode(int a_fillMode)
		Guard()
	endfunction
	
	int function AddHeaderOption(string a_text, int a_flags = 0)
		Guard()
	endfunction
	
	int function AddEmptyOption()
		Guard()
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

	function AddInputOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
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

	function SetInputOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
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

	function SetInputDialogStartText(string a_value)
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
	endfunction

;-------\-----\
; MODULE \ API \
;--------------------------------------------------------

	function SetModName(string name)
		Guard()
	endfunction

	function SetLandingPage(string page_name)
		Guard()
	endfunction

	function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
		Guard()
	endfunction

	function SetFont(int font = 0x00)
		Guard()
	endfunction

	function KeepTryingToRegister()
		Guard()
	endfunction

	int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")				
		Guard()
	endfunction
		
	int function UnregisterModule()
		Guard()
	endfunction
endstate

function KeepTryingToRegister()
	Guard()
endfunction

function StopTryingToRegister()
	Guard()
endfunction

event _OnConfigManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	Guard()
endevent

int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")
	Guard()
endfunction

int function UnregisterModule()
	Guard()
endfunction

;--------\-----\
; MCM API \ NEW \
;--------------------------------------------------------

; ERROR CODES
int property OK = 1 autoreadonly
int property ERROR = 0 autoreadonly

int property ERROR_MODULE_FULL = -1 autoreadonly
int property ERROR_MODULE_TAKEN = -2 autoreadonly
int property ERROR_MODULE_INIT = -3 autoreadonly
int property ERROR_MODULE_NONE = -4 autoreadonly

int property ERROR_MCM_NONEQUEST = -10 autoreadonly
int property ERROR_MCM_NONE = -20 autoreadonly

; FONTS
int property FONT_TYPE_DEFAULT = 0x00 autoreadonly
int property FONT_TYPE_PAPER = 0x01 autoreadonly

int property CURRENT_FONT
    int function Get()
		Guard()
	endfunction
endproperty

string function FONT_PRIMARY(string text = "")
	Guard()
endfunction

string function FONT_SECONDARY(string text = "")
	Guard()
endfunction

string function FONT_SUCCESS(string text = "")
	Guard()
endfunction

string function FONT_DANGER(string text = "")
	Guard()
endfunction

string function FONT_WARNING(string text = "")
	Guard()
endfunction

string function FONT_INFO(string text = "")
	Guard()
endfunction

string function FONT_CUSTOM(string text = "", string color)
	Guard()
endfunction

; PROPERTIES
nl_mcm property UNSAFE_RAW_MCM
    nl_mcm function Get()
		Guard()
    endfunction
endproperty

quest property MCM_QUEST
	quest function Get()
		Guard()
	endfunction
endproperty

quest property MY_QUEST
	quest function Get()
		Guard()
	endfunction
endproperty

int property MCM_ID
	int function Get()
		Guard()
	endfunction
endproperty

int property MCM_QuickHotkey
	int function Get()
		Guard()
	endfunction

	function Set(int keycode)
		Guard()
	endfunction
endproperty

string function GetCommonStore(bool lock)
	Guard()
endfunction

function SetCommonStore(string new_value)
	Guard()
endfunction

function AddParagraph(string text, string format = "", int flags = 0x01)
	Guard()
endfunction

function SetModName(string name)
	Guard()
endfunction

function SetLandingPage(string page_name)
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

function RefreshPages(bool stay = true)
	Guard()
endfunction

function GoToPage(string page_name)
	Guard()
endfunction

function CloseMCM(bool close_journal = false)
	Guard()
endfunction

function SaveMCMToPreset(string preset_path)
	Guard()
endfunction

function LoadMCMFromPreset(string preset_path)
	Guard()
endfunction

string[] function GetMCMSavedPresets(string default, string dir_path = ".")
	Guard()
endfunction 

function DeleteMCMSavedPreset(string preset_path)
	Guard()
endfunction

;--------\----------\
; MCM API \ ORIGINAL \
;--------------------------------------------------------

; PAGE FLAGS
int property OPTION_FLAG_NONE = 0x00 autoReadonly
int property OPTION_FLAG_DISABLED = 0x01 autoReadonly
int property OPTION_FLAG_HIDDEN	 = 0x02 autoReadonly
int property OPTION_FLAG_WITH_UNMAP	= 0x04 autoReadonly

int property LEFT_TO_RIGHT = 1 autoReadonly
int property TOP_TO_BOTTOM = 2 autoReadonly

; VERSION
int property CurrentVersion hidden
    int function Get()
		Guard()
    endFunction
endproperty

function SetCursorFillMode(int a_fillMode)
	Guard()
endfunction

int function AddHeaderOption(string a_text, int a_flags = 0)
	Guard()
endfunction

int function AddEmptyOption()
	Guard()
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

function AddInputOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
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

function SetInputOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
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

function SetInputDialogStartText(string a_value)
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
endfunction

;-------------\
; OVERRIDE API \
;--------------------------------------------------------

int function GetVersion()
	Guard()
endfunction

int function SaveData()
	Guard()
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

; BASIC

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

; ADVANCED

event OnDefaultST_EX(string state_id)
endevent

event OnHighlightST_EX(string state_id)
endevent

event OnSelectST_EX(string state_id)
endevent

event OnSliderOpenST_EX(string state_id)
endevent

event OnMenuOpenST_EX(string state_id)
endevent

event OnColorOpenST_EX(string state_id)
endevent

event OnSliderAcceptST_EX(string state_id, float f)
endevent

event OnMenuAcceptST_EX(string state_id, int i)
endevent

event OnColorAcceptST_EX(string state_id, int col)
endevent

event OnInputOpenST_EX(string state_id)
endevent

event OnInputAcceptST_EX(string state_id, string str)
endevent

event OnKeyMapChangeST_EX(string state_id, int keycode)
endevent

;------\
; GUARD \
;--------------------------------------------------------

function Guard()
	Debug.MessageBox("SKI_ConfigBase: Don't recompile this script!")
endFunction

