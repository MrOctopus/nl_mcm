Scriptname nl_mcm_module extends Quest
{
	This documents the new API functions in nl_mcm. \
	For the original MCM Api, view [link](https://github.com/schlangster/skyui/wiki/MCM-API-Reference). \
	Only the original STATE api functions are still supported as part of the new api.
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

string property MENU_ROOT = "_root.ConfigPanelFader.configPanel" autoreadonly
string property JOURNAL_MENU = "Journal Menu" autoreadonly

string property DEBUG_MSG
	string function Get()
		return "NL_MCM(" + _page_name + "): "
	endfunction
endproperty

nl_mcm _MCM
string _quest_editorid
string _page_name
int _z
int _current_version

event _OnPageDraw()
	int version = GetVersion()
	
	if _current_version < version
		_MCM.ShowMessage("$nl_mcm_update{" + _current_version + "}{" + version + "}", false, "$nl_mcm_ok", "")
		OnVersionUpdateBase(version)
		OnVersionUpdate(version)
		_current_version = version
	endIf
	
	OnPageDraw()
endevent

event _OnPageEvent(string state_name, int event_id, float f, string str)
	GoToState(state_name)

	if event_id == EVENT_DEFAULT
		OnDefaultST()
	elseif event_id == EVENT_HIGHLIGHT
		OnHighlightST()
	elseif event_id == EVENT_SELECT
		OnSelectST()
	elseif event_id == EVENT_OPEN
		OnSliderOpenST()
		OnMenuOpenST()
		OnColorOpenST()
		OnInputOpenST()
	elseif event_id == EVENT_ACCEPT
		OnSliderAcceptST(f)
		OnMenuAcceptST(f as int)
		OnColorAcceptST(f as int)
		OnInputAcceptST(str)
	elseif event_id == EVENT_CHANGE
		OnKeyMapChangeST(f as int)
	endif
endevent

auto state _inactive
	event OnMenuOpen(string name)
		int return_code = RegisterModule(_page_name, _z, _quest_editorid)
		
		if return_code == OK || return_code == ERROR_MCM_NOT_FOUND
			StopTryingToRegister()
		endif
	endevent	

	event _OnPageDraw()
		Trace(DEBUG_MSG + "_OnPageDraw has been called in an invalid state.")
	endevent

	event _OnPageEvent(string state_name, int event_id, float f, string str)
		Trace(DEBUG_MSG + "_OnPageEvent has been called in an invalid state.")
	endevent

	function AddParagraph(string text, string begin_format = "", string end_format = "", int flags = 0x01)
		Trace(DEBUG_MSG + "AddParagraph has been called in an invalid state.")
	endfunction
	
	int function SetModName(string name)
		Trace(DEBUG_MSG + "SetModName has been called in an invalid state.")
		return ERROR
	endfunction
	
	function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
		Trace(DEBUG_MSG + "SetSplashScreen has been called in an invalid state.")
	endfunction
	
	function SetSliderDialog(float value, float range_start, float range_end, float interval, float default)
		Trace(DEBUG_MSG + "SetSliderDialog has been called in an invalid state.")
	endFunction 
	
	function SetMenuDialog(string[] options, int start_i, int default_i = 0)
		Trace(DEBUG_MSG + "SetMenuDialog has been called in an invalid state.")
	endFunction
	
	function RefreshPages()
		Trace(DEBUG_MSG + "RefreshPages has been called in an invalid state.")
	endfunction
	
	function ExitMCM(bool fully = false)
		Trace(DEBUG_MSG + "ExitMCM has been called in an invalid state.")
	endfunction

	function SetCursorFillMode(int a_fillMode)
		Trace(DEBUG_MSG + "SetCursorFillMode has been called in an invalid state.")
	endfunction
	
	int function AddHeaderOption(string a_text, int a_flags = 0)
		Trace(DEBUG_MSG + "AddHeaderOption has been called in an invalid state.")
		return ERROR
	endfunction
	
	int function AddEmptyOption()
		Trace(DEBUG_MSG + "AddEmptyOption has been called in an invalid state.")
		return ERROR
	endfunction
	
	function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
		Trace(DEBUG_MSG + "AddTextOptionST has been called in an invalid state.")
	endfunction
	
	function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0)
		Trace(DEBUG_MSG + "AddToggleOptionST has been called in an invalid state.")
	endfunction
	
	function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
		Trace(DEBUG_MSG + "AddSliderOptionST has been called in an invalid state.")
	endfunction
	
	function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
		Trace(DEBUG_MSG + "AddMenuOptionST has been called in an invalid state.")
	endfunction
	
	function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0)
		Trace(DEBUG_MSG + "AddColorOptionST has been called in an invalid state.")
	endfunction
	
	function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0)	
		Trace(DEBUG_MSG + "AddKeyMapOptionST has been called in an invalid state.")
	endfunction
	
	function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "")
		Trace(DEBUG_MSG + "SetOptionFlagsST has been called in an invalid state.")
	endfunction
	
	function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
		Trace(DEBUG_MSG + "SetTextOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "")
		Trace(DEBUG_MSG + "SetToggleOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "")	
		Trace(DEBUG_MSG + "SetSliderOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
		Trace(DEBUG_MSG + "SetMenuOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "")
		Trace(DEBUG_MSG + "SetColorOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "")
		Trace(DEBUG_MSG + "SetKeyMapOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogStartValue(float a_value)
		Trace(DEBUG_MSG + "SetSliderDialogStartValue has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogDefaultValue(float a_value)
		Trace(DEBUG_MSG + "SetSliderDialogDefaultValue has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogRange(float a_minValue, float a_maxValue)
		Trace(DEBUG_MSG + "SetSliderDialogRange has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogInterval(float a_value)
		Trace(DEBUG_MSG + "SetSliderDialogInterval has been called in an invalid state.")
	endfunction
	
	function SetMenuDialogStartIndex(int a_value)
		Trace(DEBUG_MSG + "SetMenuDialogStartIndex has been called in an invalid state.")
	endfunction
	
	function SetMenuDialogDefaultIndex(int a_value)
		Trace(DEBUG_MSG + "SetMenuDialogDefaultIndex has been called in an invalid state.")
	endfunction
	
	function SetMenuDialogOptions(string[] a_options)
		Trace(DEBUG_MSG + "SetMenuDialogOptions has been called in an invalid state.")
	endfunction
	
	function SetColorDialogStartColor(int a_color)
		Trace(DEBUG_MSG + "SetColorDialogStartColor has been called in an invalid state.")
	endfunction
	
	function SetColorDialogDefaultColor(int a_color)
		Trace(DEBUG_MSG + "SetColorDialogDefaultColor has been called in an invalid state.")
	endfunction
	
	function SetCursorPosition(int a_position)
		Trace(DEBUG_MSG + "SetCursorPosition has been called in an invalid state.")
	endfunction
	
	function SetInfoText(string a_text)
		Trace(DEBUG_MSG + "SetInfoText has been called in an invalid state.")
	endfunction
	
	function ForcePageReset()
		Trace(DEBUG_MSG + "ForcePageReset has been called in an invalid state.")
	endfunction
	
	function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0)
		Trace(DEBUG_MSG + "LoadCustomContent has been called in an invalid state.")
	endfunction
	
	function UnloadCustomContent()
		Trace(DEBUG_MSG + "UnloadCustomContent has been called in an invalid state.")
	endfunction
	
	bool function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel")
		Trace(DEBUG_MSG + "ShowMessage has been called in an invalid state.")
		return ERROR as bool
	endfunction
	
	int function SaveMCMToPreset(string preset_path)
		Trace(DEBUG_MSG + "SaveMCMToPreset has been called in an invalid state.")
		return ERROR
	endfunction
	
	int function LoadMCMFromPreset(string preset_path)
		Trace(DEBUG_MSG + "LoadMCMFromPreset has been called in an invalid state.")
		return ERROR
	endfunction
	
	int function GetMCMSavedPresets(string[] none_array, string default, string dir_path = ".")
		Trace(DEBUG_MSG + "GetMCMSavedPresets has been called in an invalid state.")
		return ERROR
	endfunction 
	
	int function DeleteMCMSavedPreset(string preset_path)
		Trace(DEBUG_MSG + "DeleteMCMSavedPreset has been called in an invalid state.")
		return ERROR
	endfunction

;-------\-----\
; MODULE \ API \
;--------------------------------------------------------

	int function KeepTryingToRegister()
		if _page_name == ""
			return ERROR
		endif
		RegisterForMenu(JOURNAL_MENU)
		
		return OK
	endfunction
	
	int function StopTryingToRegister()
		UnregisterForMenu(JOURNAL_MENU)
		_quest_editorid = ""
		_page_name = ""
		_z = 0
		
		return OK
	endfunction

	int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")				
		_quest_editorid = quest_editorid
		_page_name = page_name
		_z = z
		
		if quest_editorid == ""
			_MCM = (self as quest) as nl_mcm
		else
			quest mcm_quest = Quest.GetQuest(quest_editorid)
			
			if !mcm_quest
				Notification(DEBUG_MSG + "Quest with editor id " + _quest_editorid + " could not be found.")
				return ERROR_NOT_FOUND
			endif
		
			_MCM = mcm_quest as nl_mcm
		endif
		
		if !_MCM
			Notification(DEBUG_MSG + "Quest with editor id " + _quest_editorid + " has no nl_mcm attached.")
			return ERROR_MCM_NOT_FOUND
		endif
		
		int error_code = _MCM._RegisterModule(self, page_name, z)
		
		if error_code == OK
			_current_version = GetVersion()
			OnPageInit()
			GoToState("")
		elseif error_code == ERROR_MAX_PAGE_REACHED
			Notification(DEBUG_MSG + "The hooked MCM has already reached the page limit.")
		elseif error_code == ERROR_PAGE_NAME_TAKEN
			Notification(DEBUG_MSG + "The hooked MCM already has a page with the same name.")
		endif
		
		return error_code
	endfunction
		
	int function UnregisterModule()
		return ERROR
	endfunction
endstate

int function KeepTryingToRegister()
	return ERROR
endfunction

int function StopTryingToRegister()
	return ERROR
endfunction

int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")
	return ERROR
endfunction

int function UnregisterModule()
	int error_code = _MCM._UnregisterModule(_page_name)
	
	if error_code == OK
		GoToState("_inactive")
		_quest_editorid = ""
		_page_name = ""
		_z = 0
	elseif error_code == ERROR_NOT_INITIALIZED
		Notification(DEBUG_MSG + "The hooked MCM is not initialized.")
	elseif error_code == ERROR_PAGE_NOT_FOUND
		Notification(DEBUG_MSG + "The hooked MCM has no matching page name.")
	endif
	
	return error_code
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
{
	Grab the pointer to the main mcm script. \
	Note: You can speed up your script by using this, but you better know what you are doing.
	@get The nl_mcm script
}
    nl_mcm function Get()
        return _MCM
	endfunction
endproperty

quest property OWNING_QUEST
{
	Grab the owning quest of the main mcm script. \
	This is identical to casting "UNSAFE_RAW_MCM as quest".
	@get The nl_mcm quest
}
	quest function Get()
		return _MCM as quest
	endfunction
endproperty

string property COMMON_STORE
{
	A string common storage usable by all mod pages. \
	Useful to know: The string type is able to store all other types \
	NOT SAFE TO USE ATM
	@get The common storage
	@set store - The new string to update the common store to
}
	string function Get()
		return _MCM.COMMON_STORE
	endfunction

	function Set(string store)
		_MCM.COMMON_STORE = store
	endfunction
endproperty

function AddParagraph(string text, string begin_format = "", string end_format = "", int flags = 0x01)
{
	A convenience function to add a paragraph of text to the mcm page. \
	Text splitting occurs when the [max line length](#LINE_LENGTH) is reached,or when a newline character (\n) is encountered.
	@param text - The text to add as a paragraph to the page
	@param begin_format - The format string to append at the start of each paragraph line. \
	Can be used to for example add html coloring to the paragraph text
	@param end_format - The format string to append at the end of each paragraph line. \
	Can be used to for example add html coloring to the paragraph text
	@param flags - The default flag of the added text options 
}
	_MCM.AddParagraph(text, begin_format, end_format, flags)
endfunction

int function SetModName(string name)
{
	Set the mod page name. Can only be used before the MCM has been initialized.
	@param name - The mod's name
	@return Error Code
}
	return _MCM.SetModName(name)
endfunction

function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
{
	Set a splash screen to use for the "" page of the mcm menu.
	@param path - File path of the splash screen
	@param x - The x position of the splash screen
	@param y - The y position of the splash screen
}
	_MCM.SetSplashScreen(path, x, y)
endfunction

function SetSliderDialog(float value, float range_start, float range_end, float interval, float default)
{
	A convenience function to set all of the slider data using only 1 function.
	@param value - The value the slider is set at
	@param range_start - The start value of the slider
	@param range_end - The end value of the slider
	@param interval - The interval at which increments/decrements are done to the value
	@param default - The default value of the slider
}
	_MCM.SetSliderDialog(value, range_start, range_end, interval, default)
endFunction 

function SetMenuDialog(string[] options, int start_i, int default_i = 0)
{
	A convenience function to set all of the menu data using only 1 function.
	@param options - The array containig the options for the menu
	@param start_i - The start selection/index of the menu
	@param default_i - The default selection/index for the menu
}
	_MCM.SetMenuDialog(options, start_i, default_i)
endFunction

function RefreshPages()
{
	Refreshes the mod's mcm pages. \
	Useful for situations where new pages/modules have been registered whilst the player is still in the mod's mcm menu. \
	Thus requiring the page list to be reset. \
	Use it when you need to refresh the mcm flash page list
}
	_MCM.RefreshPages()
endfunction

function ExitMCM(bool fully = false)
	if GetString(JOURNAL_MENU, MENU_ROOT + ".titlebar.textField.text") != _page_name
		return
	endif
	
	InvokeInt(JOURNAL_MENU, MENU_ROOT + ".changeFocus", 0)
	Invoke(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.showList")
	
	if fully
		Invoke(JOURNAL_MENU, "_root.QuestJournalFader.Menu_mc.ConfigPanelClose")
		InvokeBool(JOURNAL_MENU, "_root.QuestJournalFader.Menu_mc.CloseMenu", true)
	endif
endfunction

;--------\----------\
; MCM API \ ORIGINAL \
;--------------------------------------------------------

; PAGE_FLAGS
int property OPTION_FLAG_NONE = 0x00 autoReadonly
int property OPTION_FLAG_DISABLED = 0x01 autoReadonly
int property OPTION_FLAG_HIDDEN	 = 0x02 autoReadonly
int property OPTION_FLAG_WITH_UNMAP	= 0x04 autoReadonly

int property LEFT_TO_RIGHT = 1 autoReadonly
int property TOP_TO_BOTTOM = 2 autoReadonly

; VERSION
int property CurrentVersion hidden
    int function Get()
        return _current_version
    endFunction
endproperty

function SetCursorFillMode(int a_fillMode)
	_MCM.SetCursorFillMode(a_fillMode)
endfunction

int function AddHeaderOption(string a_text, int a_flags = 0)
	return _MCM.AddHeaderOption(a_text, a_flags)
endfunction

int function AddEmptyOption()
	return _MCM.AddEmptyOption()
endfunction

function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
	_MCM.AddTextOptionST(a_stateName, a_text, a_value, a_flags)
endfunction

function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0)
	_MCM.AddToggleOptionST(a_stateName, a_text, a_checked, a_flags)
endfunction

function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
	_MCM.AddSliderOptionST(a_stateName, a_text, a_value, a_formatString, a_flags)
endfunction

function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
	_MCM.AddMenuOptionST(a_stateName, a_text, a_value, a_flags)
endfunction

function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0)
	_MCM.AddColorOptionST(a_stateName, a_text, a_color, a_flags)
endfunction

function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0)	
	_MCM.AddKeyMapOptionST(a_stateName, a_text, a_keyCode, a_flags)
endfunction

function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "")
	if a_stateName == ""
		a_stateName = GetState()
	endif
	_MCM.SetOptionFlagsST(a_flags, a_noUpdate, a_stateName)
endfunction

function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
	if a_stateName == ""
		a_stateName = GetState()
	endif
	_MCM.SetTextOptionValueST(a_value, a_noUpdate, a_stateName)
endfunction

function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "")
	if a_stateName == ""
		a_stateName = GetState()
	endif
	_MCM.SetToggleOptionValueST(a_checked, a_noUpdate, a_stateName)
endfunction

function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "")	
	if a_stateName == ""
		a_stateName = GetState()
	endif
	_MCM.SetSliderOptionValueST(a_value, a_formatString, a_noUpdate, a_stateName)
endfunction

function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
	if a_stateName == ""
		a_stateName = GetState()
	endif
	_MCM.SetMenuOptionValueST(a_value, a_noUpdate, a_stateName)
endfunction

function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "")
	if a_stateName == ""
		a_stateName = GetState()
	endif
	_MCM.SetColorOptionValueST(a_color, a_noUpdate, a_stateName)
endfunction

function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "")
	if a_stateName == ""
		a_stateName = GetState()
	endif
	_MCM.SetKeyMapOptionValueST(a_keyCode, a_noUpdate, a_stateName)
endfunction

function SetSliderDialogStartValue(float a_value)
	_MCM.SetSliderDialogStartValue(a_value)
endfunction

function SetSliderDialogDefaultValue(float a_value)
	_MCM.SetSliderDialogDefaultValue(a_value)
endfunction

function SetSliderDialogRange(float a_minValue, float a_maxValue)
	_MCM.SetSliderDialogRange(a_minValue, a_maxValue)
endfunction

function SetSliderDialogInterval(float a_value)
	_MCM.SetSliderDialogInterval(a_value)
endfunction

function SetMenuDialogStartIndex(int a_value)
	_MCM.SetMenuDialogStartIndex(a_value)
endfunction

function SetMenuDialogDefaultIndex(int a_value)
    _MCM.SetMenuDialogDefaultIndex(a_value)
endfunction

function SetMenuDialogOptions(string[] a_options)
	_MCM.SetMenuDialogOptions(a_options)
endfunction

function SetColorDialogStartColor(int a_color)
	_MCM.SetColorDialogStartColor(a_color)
endfunction

function SetColorDialogDefaultColor(int a_color)
	_MCM.SetColorDialogDefaultColor(a_color)
endfunction

function SetCursorPosition(int a_position)
	_MCM.SetCursorPosition(a_position)
endfunction

function SetInfoText(string a_text)
	_MCM.SetInfoText(a_text)
endfunction

function ForcePageReset()
	_MCM.ForcePageReset()
endfunction

function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0)
	_MCM.LoadCustomContent(a_source, a_x, a_y)
endfunction

function UnloadCustomContent()
	_MCM.UnloadCustomContent()
endfunction

bool function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel")
	return _MCM.ShowMessage(a_message, a_withCancel, a_acceptLabel, a_cancelLabel)
endfunction

int function SaveMCMToPreset(string preset_path)
	return _MCM.SaveMCMToPreset(preset_path)
endfunction

int function LoadMCMFromPreset(string preset_path)
	return _MCM.LoadMCMFromPreset(preset_path)
endfunction

int function GetMCMSavedPresets(string[] none_array, string default, string dir_path = ".")
	return _MCM.GetMCMSavedPresets(none_array, default, dir_path)
endfunction 

int function DeleteMCMSavedPreset(string preset_path)
	return _MCM.DeleteMCMSavedPreset(preset_path)
endfunction

;-------------\
; OVERRIDE API \
;--------------------------------------------------------

int function GetVersion()
	return 1
endfunction

int function SaveData()
endfunction

function LoadData(int jObj)
endfunction

event OnVersionUpdateBase(int a_version)
endevent

event OnVersionUpdate(int a_version)
endevent

event OnConfigClose()
endevent

event OnPageInit()
endevent

event OnPageDraw()
endevent

event OnDefaultST()
endevent

event OnHighlightST()
endevent

event OnSelectST()
endevent

event OnSliderOpenST()
endevent

event OnMenuOpenST()
endevent

event OnColorOpenST()
endevent

event OnSliderAcceptST(float f)
endevent

event OnMenuAcceptST(int i)
endevent

event OnColorAcceptST(int col)
endevent

event OnInputOpenST()
endevent

event OnInputAcceptST(string str)
endevent

event OnKeyMapChangeST(int keycode)
endevent
