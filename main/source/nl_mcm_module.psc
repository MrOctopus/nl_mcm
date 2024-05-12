Scriptname nl_mcm_module extends Quest
{
	This documents the new API functions in nl_mcm. \
	For the original mcm Api, see [link](https://github.com/schlangster/skyui/wiki/MCM-API-Reference). \
	Only STATE api functions are supported as part of the new api.
	@author NeverLost
	@version 1.1.3
}

; ------\-------\
; MODULE \ DEBUG \
;--------------------------------------------------------

int property DEBUG_FLAG_E = 0x00 autoreadonly
{ Empty debug flag }
int property DEBUG_FLAG_T = 0x01 autoreadonly
{ Trace debug flag }
int property DEBUG_FLAG_N = 0x02 autoreadonly
{ Notification debug flag}

string function DEBUG_MSG(string msg = "", int flag = 0x01)
{
	Debug helper function for error messages. \
	Prints to a given debug channel in the format "NL_MCM(ModName, ScriptName, PageName): msg".
	@param msg - Error message
	@param flag - Which debug channel to use. \
	Use either [Empty](#DEBUG_FLAG_E), [Trace](#DEBUG_FLAG_T), [Notifications](#DEBUG_FLAG_N), or combinations (just add the flags together) FLAG_T + FLAG_N
	@return The concatted error message
}
	msg = "NL_MCM(" + nl_util.GetFormModName(self) + ", " + nl_util.GetFormScriptName(self) + ", " + _page_name + "): " + msg

	if flag == DEBUG_FLAG_T
		Debug.Trace(msg)
	elseif flag == DEBUG_FLAG_N
		Debug.Notification(msg)
	elseif flag == DEBUG_FLAG_T + DEBUG_FLAG_N
		Debug.Trace(msg)
		Debug.Notification(msg)
	endif

	return msg
endfunction

;-------\----------\
; MODULE \ INTERNAL \ - ALSO KNOWN AS, IGNORE THIS SECTION
;--------------------------------------------------------

; WTF
string[] _none_string_ptr

nl_mcm _MCM

string _page_name
string _quest_editorid

int _current_version
int _font
int _z

bool _recursive_failsafe

event OnInit()
	if _page_name == ""
		return
	endif

	quest nl_quest_var = self as quest
	nl_mcm nl_script_var = nl_quest_var as nl_mcm

	if nl_script_var == None			
		DEBUG_MSG("Quest with EditorID [" + nl_util.GetFormEditorID(self) + "] has no nl_mcm attached.", DEBUG_FLAG_T + DEBUG_FLAG_N)
		RegisterForModEvent("SKICP_configManagerReady", "_OnConfigManagerReady")
		return
	endif

	int error_code = nl_script_var._RegisterModule(self, _page_name, _z)

	if error_code == OK
		_current_version = GetVersion()
		_MCM = nl_script_var
		GoToState("")
		_recursive_failsafe = true
		OnPageInit()
		_recursive_failsafe = false
	endif
endevent

event _OnConfigManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
endevent

event _OnGameReload(string eventName, string strArg, float numArg, Form sender)
	int version = GetVersion()
	
	if _current_version < version
		OnVersionUpdate(version)
		_current_version = version
	endIf

	OnGameReload()
endevent

event _OnPageDraw(int font)
	_font = font
	OnPageDraw()
endevent

event _OnPageEvent(string state_name, int event_id, float f, string str)
	int index = StringUtil.Find(state_name, "___")
	string state_id = ""

	if index != -1
		GoToState(StringUtil.Substring(state_name, 0, index))
		state_id = StringUtil.Substring(state_name, index + 3)
	else
		GoToState(state_name)
	endif

	if event_id == 0
		OnDefaultST(state_id)
		_MCM.PlayerUpdatedOptions = true
	elseif event_id == 1
		OnHighlightST(state_id)
	elseif event_id == 2
		OnSelectST(state_id)
		_MCM.PlayerUpdatedOptions = true
	elseif event_id == 3
		OnSliderOpenST(state_id)
		OnMenuOpenST(state_id)
		OnColorOpenST(state_id)
		OnInputOpenST(state_id)
	elseif event_id == 4
		OnSliderAcceptST(state_id, f)
		OnMenuAcceptST(state_id, f as int)
		OnColorAcceptST(state_id, f as int)
		OnInputAcceptST(state_id, str)
		_MCM.PlayerUpdatedOptions = true
	elseif event_id == 5
		OnKeyMapChangeST(state_id, f as int)
		_MCM.PlayerUpdatedOptions = true
	endif
endevent

auto state _inactive
	event _OnConfigManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)		
		RegisterModule(_page_name, _z, _quest_editorid)
	endevent

	event _OnPageDraw(int font)
		DEBUG_MSG("_OnPageDraw has been called in an invalid state.")
	endevent

	event _OnPageEvent(string state_name, int event_id, float f, string str)
		DEBUG_MSG("_OnPageEvent has been called in an invalid state.")
	endevent
		
	string function GetCommonStore(bool lock)
		DEBUG_MSG("GetCommonStore has been called in an invalid state.")
		return ""
	endfunction
		
	function SetCommonStore(string new_value)
		DEBUG_MSG("SetCommonStore has been called in an invalid state.")
	endfunction

	function SetModName(string name)
		DEBUG_MSG("SetModName has been called in an invalid state.")
	endfunction

	function SetLandingPage(string page_name)
		DEBUG_MSG("SetLandingPage has been called in an invalid state.")
	endfunction

	function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
		DEBUG_MSG("SetSplashScreen has been called in an invalid state.")
	endfunction

	function SetFont(int font = 0x00)
		DEBUG_MSG("SetFont has been called in an invalid state.")
	endfunction

	function SetPersistentMCMPreset(string preset_path)
		DEBUG_MSG("SetPersistentMCMPreset has been called in an invalid state.")
	endfunction

	function AddParagraph(string text, string format = "", int flags = 0x01)
		DEBUG_MSG("AddParagraph has been called in an invalid state.")
	endfunction
	
	function SetSliderDialog(float value, float range_start, float range_end, float interval, float default = 0.0)
		DEBUG_MSG("SetSliderDialog has been called in an invalid state.")
	endFunction 
	
	function SetMenuDialog(string[] options, int start_i, int default_i = 0)
		DEBUG_MSG("SetMenuDialog has been called in an invalid state.")
	endFunction
	
	function ForcePageListReset(bool stay = true)
		DEBUG_MSG("ForcePageListReset has been called in an invalid state.")
	endfunction

	function GoToPage(string page_name)
		DEBUG_MSG("GoToPage has been called in an invalid state.")
	endfunction

	function OpenMCM(string landing_page_name = "")
		DEBUG_MSG("OpenMCM has been called in an invalid state.")
	endfunction
	
	function CloseMCM(bool close_journal = false)
		DEBUG_MSG("CloseMCM has been called in an invalid state.")
	endfunction

	function SaveMCMToPreset(string preset_path)
		DEBUG_MSG("SaveMCMToPreset has been called in an invalid state.")
	endfunction
	
	function LoadMCMFromPreset(string preset_path)
		DEBUG_MSG("LoadMCMFromPreset has been called in an invalid state.")
	endfunction

	int function GetNumMCMSavedPresets(string dir_path = "")
		DEBUG_MSG("GetNumMCMSavedPresets has been called in an invalid state.")
		return ERROR
	endfunction
		
	string[] function GetMCMSavedPresets(string default, string dir_path = "")
		DEBUG_MSG("GetMCMSavedPresets has been called in an invalid state.")
		return _none_string_ptr
	endfunction 
		
	function DeleteMCMSavedPreset(string preset_path)
		DEBUG_MSG("DeleteMCMSavedPreset has been called in an invalid state.")
	endfunction

	function SetCursorFillMode(int a_fillMode)
		DEBUG_MSG("SetCursorFillMode has been called in an invalid state.")
	endfunction
	
	int function AddHeaderOption(string a_text, int a_flags = 0)
		DEBUG_MSG("AddHeaderOption has been called in an invalid state.")
		return ERROR_MODULE_INIT
	endfunction
	
	int function AddEmptyOption()
		DEBUG_MSG("AddEmptyOption has been called in an invalid state.")
		return ERROR_MODULE_INIT
	endfunction
	
	function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
		DEBUG_MSG("AddTextOptionST has been called in an invalid state.")
	endfunction
	
	function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0)
		DEBUG_MSG("AddToggleOptionST has been called in an invalid state.")
	endfunction
	
	function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
		DEBUG_MSG("AddSliderOptionST has been called in an invalid state.")
	endfunction
	
	function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
		DEBUG_MSG("AddMenuOptionST has been called in an invalid state.")
	endfunction
	
	function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0)
		DEBUG_MSG("AddColorOptionST has been called in an invalid state.")
	endfunction
	
	function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0)
		DEBUG_MSG("AddKeyMapOptionST has been called in an invalid state.")
	endfunction

	function AddInputOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
		DEBUG_MSG("AddInputOptionST has been called in an invalid state.")
	endfunction
	
	function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetOptionFlagsST has been called in an invalid state.")
	endfunction
	
	function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetTextOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetToggleOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetSliderOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetMenuOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetColorOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetKeyMapOptionValueST has been called in an invalid state.")
	endfunction

	function SetInputOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
		DEBUG_MSG("SetInputOptionValueST has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogStartValue(float a_value)
		DEBUG_MSG("SetSliderDialogStartValue has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogDefaultValue(float a_value)
		DEBUG_MSG("SetSliderDialogDefaultValue has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogRange(float a_minValue, float a_maxValue)
		DEBUG_MSG("SetSliderDialogRange has been called in an invalid state.")
	endfunction
	
	function SetSliderDialogInterval(float a_value)
		DEBUG_MSG("SetSliderDialogInterval has been called in an invalid state.")
	endfunction
	
	function SetMenuDialogStartIndex(int a_value)
		DEBUG_MSG("SetMenuDialogStartIndex has been called in an invalid state.")
	endfunction
	
	function SetMenuDialogDefaultIndex(int a_value)
		DEBUG_MSG("SetMenuDialogDefaultIndex has been called in an invalid state.")
	endfunction
	
	function SetMenuDialogOptions(string[] a_options)
		DEBUG_MSG("SetMenuDialogOptions has been called in an invalid state.")
	endfunction
	
	function SetColorDialogStartColor(int a_color)
		DEBUG_MSG("SetColorDialogStartColor has been called in an invalid state.")
	endfunction
	
	function SetColorDialogDefaultColor(int a_color)
		DEBUG_MSG("SetColorDialogDefaultColor has been called in an invalid state.")
	endfunction

	function SetInputDialogStartText(string a_value)
		DEBUG_MSG("SetInputDialogStartText has been called in an invalid state.")
	endfunction
	
	function SetCursorPosition(int a_position)
		DEBUG_MSG("SetCursorPosition has been called in an invalid state.")
	endfunction
	
	function SetInfoText(string a_text)
		DEBUG_MSG("SetInfoText has been called in an invalid state.")
	endfunction
	
	function ForcePageReset()
		DEBUG_MSG("ForcePageReset has been called in an invalid state.")
	endfunction
	
	function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0)
		DEBUG_MSG("LoadCustomContent has been called in an invalid state.")
	endfunction
	
	function UnloadCustomContent()
		DEBUG_MSG("UnloadCustomContent has been called in an invalid state.")
	endfunction
	
	bool function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel")
		DEBUG_MSG("ShowMessage has been called in an invalid state.")
		return false
	endfunction

;-------\-----\
; MODULE \ API \
;--------------------------------------------------------

	int function RenameModule(string page_name)
		DEBUG_MSG("RenameModule has been called in an invalid state.")
		return ERROR
	endfunction

	nl_mcm_module function GetOtherModule(string page_name)
		DEBUG_MSG("GetOtherModule has been called in an invalid state.")
		return None
	endfunction

	int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")
	{
		Register the module/page to a mcm.
		@param page_name - The page name to display in the mcm
		@param z - The z index of the module/page in the mcm page list. Lower values will appear first
		@param quest_editorid - The editor id of the quest containing the nl_mcm script. Defaults to the same quest as the module is attached to
		@return The error code
	}
		if _recursive_failsafe
			DEBUG_MSG("Recursive call to RegisterModule detected, aborting call.", DEBUG_FLAG_T + DEBUG_FLAG_N)
			return ERROR
		endif

		; Internal
		quest nl_quest_var = self as quest
		nl_mcm nl_script_var = nl_quest_var as nl_mcm

		; External
		if quest_editorid != ""
			nl_quest_var = Quest.GetQuest(quest_editorid)
			nl_script_var = nl_quest_var as nl_mcm
		endif

		; Cache data
		_quest_editorid = quest_editorid
		_page_name = page_name
		_z = z

		if nl_quest_var == None || nl_script_var == None			
			if quest_editorid == ""
				quest_editorid = nl_util.GetFormEditorID(self)
			endif

			if nl_quest_var == None
				DEBUG_MSG("Quest with EditorID [" + quest_editorid + "] could not be found.", DEBUG_FLAG_T + DEBUG_FLAG_N)
				RegisterForModEvent("SKICP_configManagerReady", "_OnConfigManagerReady")
				return ERROR_MCM_NONEQUEST
			else
				DEBUG_MSG("Quest with EditorID [" + quest_editorid + "] has no nl_mcm attached.", DEBUG_FLAG_T + DEBUG_FLAG_N)
				RegisterForModEvent("SKICP_configManagerReady", "_OnConfigManagerReady")
				return ERROR_MCM_NONE
			endif
		endif

		int error_code = nl_script_var._RegisterModule(self, page_name, z)

		if error_code == OK
			_current_version = GetVersion()
			_MCM = nl_script_var
			GoToState("")
			_recursive_failsafe = true
			OnPageInit()
			_recursive_failsafe = false
		endif
		
		return error_code
	endfunction
		
	int function UnregisterModule()
		DEBUG_MSG("UnregisterModule has been called in an invalid state.")
		return ERROR
	endfunction

	int function UnregisterAllModules()
		DEBUG_MSG("UnregisterAllModules has been called in an invalid state.")
		return ERROR
	endfunction
endstate

function _ResetModuleState()
	GoToState("_inactive")
	_MCM = None
	_page_name = ""
	_font = FONT_TYPE_DEFAULT
	_z = 0
endfunction

int function RenameModule(string page_name)
{
	Rename the module's page name in the attached mcm.
	@param page_name - The new page name
	@return The error code
}
	if _page_name == page_name
		return OK
	endif

	int error_code = _MCM._RenameModule(_page_name, page_name)

	if error_code == OK
		_page_name = page_name
	endif

	return error_code
endfunction

nl_mcm_module function GetOtherModule(string page_name)
{
	Get another module/page from the attached mcm.
	@return The nl_mcm_module script. Remember to cast this value to your own extending script type
}
	_MCM._GetOtherModule(page_name)
endfunction

int function RegisterModule(string page_name, int z = 0, string quest_editorid = "")
	return ERROR
endfunction

int function UnregisterModule()
{
	Unregister the module/page from the attached mcm.
	@return The error code
}
	int error_code = _MCM._UnregisterModule(_page_name)
	_ResetModuleState()

	return error_code
endfunction

int function UnregisterAllModules()
{
	Unregister all modules/pages from the attached mcm.
	@return The error code
}
	return _MCM._UnregisterAllModules()
endfunction

;--------\-----\
; MCM API \ NEW \
;--------------------------------------------------------

; NONE POINTER TO STRING ARRAY
; will stay undocumented because wtf
string[] property NONE_STRING_PTR hidden
	string[] function Get()
		return _none_string_ptr
	endfunction
endproperty

; ERROR CODES
int property OK = 1 autoreadonly
{ Error return code for general success }
int property ERROR = 0 autoreadonly
{ Error return code for general errors }

int property ERROR_MODULE_FULL = -1 autoreadonly
{ Error return code for max module/page limit being reached }
int property ERROR_MODULE_TAKEN = -2 autoreadonly
{ Error return code for module/page name being taken }
int property ERROR_MODULE_INIT = -3 autoreadonly
{ Error return code for the mcm not being initialized }
int property ERROR_MODULE_NONE = -4 autoreadonly
{ Error return code for the mcm not containing the given module/page name }

int property ERROR_MCM_NONEQUEST = -10 autoreadonly
{ Error return code for the mcm quest editorid not being found }
int property ERROR_MCM_NONE = -20 autoreadonly
{ Error return code for the mcm quest not having a nl_mcm script attached }

; FONTS
int property FONT_TYPE_DEFAULT = 0x00 autoreadonly
{ Default type font }
int property FONT_TYPE_PAPER = 0x01 autoreadonly
{ Paper type font }

string function FONT_PRIMARY(string text = "")
{
	Wraps a string in the FONT_PRIMARY type formatting. \
	Switches automatically depending on the installed UI skin.
	@param text - The string to wrap in color
}
	if _font == FONT_TYPE_PAPER
		return "<font color='#005500'>" + text + "</font>"
	endif
	return "<font color='#EDDA87'>" + text + "</font>"
endfunction

string function FONT_SECONDARY(string text = "")
{
	Wraps a string in the FONT_SECONDARY type formatting. \
	Switches automatically depending on the installed UI skin.
	@param text - The string to wrap in color
}
	if _font == FONT_TYPE_PAPER
		return "<font color='#412600'>" + text + "</font>"
	endif
	return "<font color='#6B7585'>" + text + "</font>"
endfunction

string function FONT_SUCCESS(string text = "")
{
	Wraps a string in the FONT_SUCCESS type formatting. \
	Switches automatically depending on the installed UI skin.
	@param text - The string to wrap in color
}
	if _font == FONT_TYPE_PAPER
		return "<font color='#006D00'>" + text + "</font>"
	endif
	return "<font color='#51DB2E'>" + text + "</font>"
endfunction

string function FONT_DANGER(string text = "")
{
	Wraps a string in the FONT_DANGER type formatting. \
	Switches automatically depending on the installed UI skin.
	@param text - The string to wrap in color
}
	if _font == FONT_TYPE_PAPER
		return "<font color='#5E000E'>" + text + "</font>"
	endif
	return "<font color='#C73636'>" + text + "</font>"
endfunction

string function FONT_WARNING(string text = "")
{
	Wraps a string in the FONT_WARNING type formatting. \
	Switches automatically depending on the installed UI skin.
	@param text - The string to wrap in color
}
	if _font == FONT_TYPE_PAPER
		return "<font color='#FFFF00'>" + text + "</font>"
	endif
	return "<font color='#EAAB00'>" + text + "</font>"
endfunction

string function FONT_INFO(string text = "")
{
	Wraps a string in the FONT_INFO type formatting. \
	Switches automatically depending on the installed UI skin.
	@param text - The string to wrap in color
}
	if _font == FONT_TYPE_PAPER
		return "<font color='#121C4A'>" + text + "</font>"
	endif
	return "<font color='#A2BEFF'>" + text + "</font>"
endfunction

string function FONT_CUSTOM(string text = "", string color)
{
	Wraps a string in a custom font type formatting. \
	Does not switch automatically depending on the installed UI skin.
	@param text - The string to wrap in color
	@param color - The color code, RGB format (#FFFFFF)
}
	return "<font color='" + color + "'>" + text + "</font>"
endfunction

; PROPERTIES
nl_mcm property UNSAFE_RAW_MCM hidden
{
	Grab the pointer to the main mcm script. \
	Note: You can speed up your script by using this, but you better know what you are doing.
	@get The nl_mcm script
}
    nl_mcm function Get()
        return _MCM
	endfunction
endproperty

bool property IsMCMInitialized hidden
{
	Check if the mcm has actually finished initializing.
	@get Get the initialized status of the mcm
}
	bool function Get()
		return _MCM.IsMCMInitialized
	endfunction
endproperty

bool property IsModuleRegistered hidden
{
	Check if the module is registered to a mcm.
	@get Get the module's state
}
	bool function Get()
		return GetState() != "_inactive"
	endfunction
endproperty

bool property PlayerUpdatedOptions hidden
{
	Check if the user has changed any of the mcm options.
	@get Get the update state for the current session
}
	bool function Get()
		return _MCM.PlayerUpdatedOptions
	endfunction
endproperty

int property QuickHotkey hidden
{
	If this hotkey is set, it allows the user to immediately open or close the mcm menu \
	by pressing the defined hotkey.
	@get Get the current quickhotkey for the mcm
	@set Set the new quickhotkey for the mcm
}
	int function Get()
		return _MCM.QuickHotkey
	endfunction

	function Set(int keycode)
		_MCM.QuickHotkey = keycode
	endfunction
endproperty

string property PageName 
{
	Get the current page name assigned to the module.
	@get Get the current page name assigned to the module
	@set !!!!DO NOT SET THIS PROPERTY OUTSIDE OF THE CREATION KIT!!!!
}
	string function Get()
		return _page_name
	endfunction

	function Set(string page_name)
		_page_name = page_name
	endfunction
endproperty

int property PageOrder
{
	Get the current display order of the module's page name.
	@get Get the current display order of the module's page name
	@set !!!!DO NOT SET THIS PROPERTY OUTSIDE OF THE CREATION KIT!!!!
}
	int function Get()
		return _z
	endfunction

	function Set(int z)
		_z = z
	endfunction
endproperty

int property CurrentMCMID hidden
{
	Useful to get the mcm's currently assigned mod id. \
	Note: Don't cache this, as it might change on gamereloads.
	@get Mcm id
}
	int function Get()
		_MCM.CurrentMCMID
	endfunction
endproperty	

int property CurrentFont hidden
{
	Useful to check for the current font.
	@get Get the current font
}
	int function Get()
		if _font > FONT_TYPE_PAPER
			return FONT_TYPE_DEFAULT
		endif
		return _font
	endfunction
endproperty

string function GetCommonStore(bool lock)
{
	Get the shared common store string. \
	NOTE: Always lock the storage if you are planning on using SetCommonStore afterwards.
	@param lock - If the shared common store should lock changes from other pages
	@return The common store string
}
	return _MCM.GetCommonStore(_page_name, lock)
endfunction

function SetCommonStore(string new_value)
{
	Set the shared common store string. \
	NOTE: This will always unlock the common store
	@param new_value - The new string
}
	_MCM.SetCommonStore(_page_name, new_value)
endfunction

function SetModName(string name)
{
	Set the mod page name. Can only be used before the mcm has been initialized.
	@param name - The mod's name
}
		_MCM.SetModName(name)
endfunction

function SetLandingPage(string page_name)
{
	Set the mcm landing page.
	@param page_name - The landing page's name
}
	_MCM.SetLandingPage(page_name)
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

function SetFont(int font = 0x00)
{
	Set font type. \
	See: [Default Color](#FONT_TYPE_DEFAULT) and [Paper Color](#FONT_TYPE_PAPER).
	@param font - The new font type
}
	_MCM.SetFont(font)
endfunction

function SetPersistentMCMPreset(string preset_path)
{
	Set the preset file path that will be used to persist user settings across save games.
	@param preset_path - The path to the preset to save and load settings to/from
}
	_MCM.SetPersistentMCMPreset(preset_path)
endfunction

function AddParagraph(string text, string format = "", int flags = 0x01)
{
	A convenience function to add a paragraph of text to the mcm page. \
	Text splitting occurs when the max line length is reached,or when a newline character (\n) is encountered. \
	NOTE: You need to use the format parameter for fonts
	@param text - The text to add as a paragraph to the page
	@param format - The format/font to wrap the text in.
	@param flags - The default flag of the added text options 
}
	_MCM.AddParagraph(text, format, flags)
endfunction

function SetSliderDialog(float value, float range_start, float range_end, float interval, float default = 0.0)
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

function ForcePageListReset(bool stay = true)
{
	Refreshes the mod's mcm page list. \
	Useful for situations where new pages/modules have been registered whilst the player is still in the mod's mcm menu, \
	which will require the page list to be refreshed.
	@param stay - Should the user stay on the page
}
	_MCM.ForcePageListReset(stay)
endfunction

function GoToPage(string page_name)
{
	Go to a given mcm page.
	@param page_name - The page to go to
}
	_MCM.GoToPage(page_name)
endfunction

function OpenMCM(string landing_page_name = "")
{
	Open the attached mcm.
	@param landing_page_name - If set to a valid page name, it will open the mcm at this page
}
	_MCM.OpenMCM(landing_page_name)
endfunction

function CloseMCM(bool close_journal = false)
{
	Close the attached mcm.
	@param close_journal - If set to true, it will close the quest journal too
}
	_MCM.CloseMCM(close_journal)
endfunction

string function GetFullMCMPresetPath(string preset_path)
{
	Gets the full path for a given preset_path
	@param preset_path - The local path to the stored preset
	@return The full preset path
}
	return _MCM.MCM_PATH_SETTINGS + preset_path + _MCM.MCM_EXT
endfunction

function SaveMCMToPreset(string preset_path)
{
	Calls the local SaveData function on all module scripts, storing the resulting JObjects under the given file name.
	@param preset_path - The path to the preset to store the settings under
}
	_MCM.SaveMCMToPreset(preset_path)
endfunction
	
function LoadMCMFromPreset(string preset_path)
{
	Calls the local LoadData function on all module scripts, using the JObjects loaded from the given file.
	@param preset_path - The path to the preset to load settings from
}
	_MCM.LoadMCMFromPreset(preset_path)
endfunction

int function GetNumMCMSavedPresets(string dir_path = "")
{
	Get the number of saved presets.
	@param dir_path - The directory path of the presets. Defaults to current mcm menu directory 
	@return Number of saved presets at given path
}
return _MCM.GetNumMCMSavedPresets(dir_path)
endfunction
	
string[] function GetMCMSavedPresets(string default, string dir_path = "")
{
	Get an array containing the name of all saved presets.
	@param default - A default string to fill the list with. Used to create a "fake exit" button for mcm menus
	@param dir_path - The directory path of the presets. Defaults to current mcm menu directory 
	@return Saved preset names at given path
}
	return _MCM.GetMCMSavedPresets(default, dir_path)
endfunction 
	
function DeleteMCMSavedPreset(string preset_path)
{
	Delete a given preset from the settings folder. 
	@param preset_path - The path to the preset to delete
}
	_MCM.DeleteMCMSavedPreset(preset_path)
endfunction

;--------\----------\
; MCM API \ ORIGINAL \
;--------------------------------------------------------

; PAGE FLAGS
int property OPTION_FLAG_NONE = 0x00 autoReadonly
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}
int property OPTION_FLAG_DISABLED = 0x01 autoReadonly
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}
int property OPTION_FLAG_HIDDEN = 0x02 autoReadonly
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}
int property OPTION_FLAG_WITH_UNMAP = 0x04 autoReadonly
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}

int property LEFT_TO_RIGHT = 1 autoReadonly
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}
int property TOP_TO_BOTTOM = 2 autoReadonly
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}

; VERSION
int property CurrentVersion hidden
{ 
	NL_MCM's page based version of CurrentVersion. \
	See the original [SkyUI Advanced Features](https://github.com/schlangster/skyui/wiki/MCM-Advanced-Features).
	@get Refer to the SkyUI API
}
    int function Get()
        return _current_version
    endFunction
endproperty

function SetCursorFillMode(int a_fillMode)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_fillMode - Refer to the SkyUI API
}
	_MCM.SetCursorFillMode(a_fillMode)
endfunction

int function AddHeaderOption(string a_text, int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_text - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
	@return Refer to the SkyUI API
}
	return _MCM.AddHeaderOption(a_text, a_flags)
endfunction

int function AddEmptyOption()
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@return Refer to the SkyUI API
}
	return _MCM.AddEmptyOption()
endfunction

function AddTextOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_stateName - Refer to the SkyUI API
	@param a_text - Refer to the SkyUI API
	@param a_value - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
}
	_MCM.AddTextOptionST(a_stateName, a_text, a_value, a_flags)
endfunction

function AddToggleOptionST(string a_stateName, string a_text, bool a_checked, int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_stateName - Refer to the SkyUI API
	@param a_text - Refer to the SkyUI API
	@param a_checked - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
}
	_MCM.AddToggleOptionST(a_stateName, a_text, a_checked, a_flags)
endfunction

function AddSliderOptionST(string a_stateName, string a_text, float a_value, string a_formatString = "{0}", int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_stateName - Refer to the SkyUI API
	@param a_text - Refer to the SkyUI API
	@param a_value - Refer to the SkyUI API
	@param a_formatString - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
}
	_MCM.AddSliderOptionST(a_stateName, a_text, a_value, a_formatString, a_flags)
endfunction

function AddMenuOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_stateName - Refer to the SkyUI API
	@param a_text - Refer to the SkyUI API
	@param a_value - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
}
	_MCM.AddMenuOptionST(a_stateName, a_text, a_value, a_flags)
endfunction

function AddColorOptionST(string a_stateName, string a_text, int a_color, int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_stateName - Refer to the SkyUI API
	@param a_text - Refer to the SkyUI API
	@param a_color - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
}
	_MCM.AddColorOptionST(a_stateName, a_text, a_color, a_flags)
endfunction

function AddKeyMapOptionST(string a_stateName, string a_text, int a_keyCode, int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_stateName - Refer to the SkyUI API
	@param a_text - Refer to the SkyUI API
	@param a_keyCode - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
}
	_MCM.AddKeyMapOptionST(a_stateName, a_text, a_keyCode, a_flags)
endfunction

function AddInputOptionST(string a_stateName, string a_text, string a_value, int a_flags = 0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_stateName - Refer to the SkyUI API
	@param a_text - Refer to the SkyUI API
	@param a_value - Refer to the SkyUI API
	@param a_flags - Refer to the SkyUI API
}
	_MCM.AddInputOptionST(a_stateName, a_text, a_value, a_flags)
endfunction

function SetOptionFlagsST(int a_flags, bool a_noUpdate = false, string a_stateName = "")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_flags - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetOptionFlagsST(a_flags, a_noUpdate, a_stateName)
endfunction

function SetTextOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetTextOptionValueST(a_value, a_noUpdate, a_stateName)
endfunction

function SetToggleOptionValueST(bool a_checked, bool a_noUpdate = false, string a_stateName = "")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_checked - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetToggleOptionValueST(a_checked, a_noUpdate, a_stateName)
endfunction

function SetSliderOptionValueST(float a_value, string a_formatString = "{0}", bool a_noUpdate = false, string a_stateName = "")	
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
	@param a_formatString - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetSliderOptionValueST(a_value, a_formatString, a_noUpdate, a_stateName)
endfunction

function SetMenuOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetMenuOptionValueST(a_value, a_noUpdate, a_stateName)
endfunction

function SetColorOptionValueST(int a_color, bool a_noUpdate = false, string a_stateName = "")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_color - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetColorOptionValueST(a_color, a_noUpdate, a_stateName)
endfunction

function SetKeyMapOptionValueST(int a_keyCode, bool a_noUpdate = false, string a_stateName = "")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_keyCode - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetKeyMapOptionValueST(a_keyCode, a_noUpdate, a_stateName)
endfunction

function SetInputOptionValueST(string a_value, bool a_noUpdate = false, string a_stateName = "")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
	@param a_noUpdate - Refer to the SkyUI API
	@param a_stateName - Refer to the SkyUI API
}
	_MCM.SetInputOptionValueST(a_value, a_noUpdate, a_stateName)
endfunction

function SetSliderDialogStartValue(float a_value)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
}
	_MCM.SetSliderDialogStartValue(a_value)
endfunction

function SetSliderDialogDefaultValue(float a_value)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
}
	_MCM.SetSliderDialogDefaultValue(a_value)
endfunction

function SetSliderDialogRange(float a_minValue, float a_maxValue)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_minValue - Refer to the SkyUI API
	@param a_maxValue - Refer to the SkyUI API
}
	_MCM.SetSliderDialogRange(a_minValue, a_maxValue)
endfunction

function SetSliderDialogInterval(float a_value)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
}
	_MCM.SetSliderDialogInterval(a_value)
endfunction

function SetMenuDialogStartIndex(int a_value)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
}
	_MCM.SetMenuDialogStartIndex(a_value)
endfunction

function SetMenuDialogDefaultIndex(int a_value)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
}
    _MCM.SetMenuDialogDefaultIndex(a_value)
endfunction

function SetMenuDialogOptions(string[] a_options)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_options - Refer to the SkyUI API
}
	_MCM.SetMenuDialogOptions(a_options)
endfunction

function SetColorDialogStartColor(int a_color)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_color - Refer to the SkyUI API
}
	_MCM.SetColorDialogStartColor(a_color)
endfunction

function SetColorDialogDefaultColor(int a_color)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_color - Refer to the SkyUI API
}
	_MCM.SetColorDialogDefaultColor(a_color)
endfunction

function SetInputDialogStartText(string a_value)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_value - Refer to the SkyUI API
}
	_MCM.SetInputDialogStartText(a_value)
endfunction

function SetCursorPosition(int a_position)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_position - Refer to the SkyUI API
}
	_MCM.SetCursorPosition(a_position)
endfunction

function SetInfoText(string a_text)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_text - Refer to the SkyUI API
}
	_MCM.SetInfoText(a_text)
endfunction

function ForcePageReset()
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}
	_MCM.ForcePageReset()
endfunction

function LoadCustomContent(string a_source, float a_x = 0.0, float a_y = 0.0)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_source - Refer to the SkyUI API
	@param a_x - Refer to the SkyUI API
	@param a_y - Refer to the SkyUI API
}
	_MCM.LoadCustomContent(a_source, a_x, a_y)
endfunction

function UnloadCustomContent()
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
}
	_MCM.UnloadCustomContent()
endfunction

bool function ShowMessage(string a_message, bool a_withCancel = true, string a_acceptLabel = "$Accept", string a_cancelLabel = "$Cancel")
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param a_message - Refer to the SkyUI API
	@param a_withCancel - Refer to the SkyUI API
	@param a_acceptLabel - Refer to the SkyUI API
	@param a_cancelLabel - Refer to the SkyUI API
	@return Refer to the SkyUI API
}
	return _MCM.ShowMessage(a_message, a_withCancel, a_acceptLabel, a_cancelLabel)
endfunction

;-------------\
; OVERRIDE API \
;--------------------------------------------------------

; VERSIONING

int function GetVersion()
{ 
	NL_MCM's page based version of GetVersion(). \
	See the original [SkyUI Advanced Features](https://github.com/schlangster/skyui/wiki/MCM-Advanced-Features).
	@return Refer to the SkyUI API
	@override
}
	return 1
endfunction

event OnVersionUpdate(int new_version)
{ 
	NL_MCM's page based version of OnVersionUpdate(). \
	See the original [SkyUI Advanced Features](https://github.com/schlangster/skyui/wiki/MCM-Advanced-Features).
	@param new_version - Refer to the SkyUI API
	@override
}
endevent

; PRESETS

int function SaveData()
{
	Requires JContainers to function. \
	Function to save the page's/module's data to a MCM preset. Use jContainers to create a object type of your choice and store the data in it.
	@return Your jContainer object id
	@override
}
	return 0
endfunction

function LoadData(int jObj)
{
	Requires JContainers to function. \
	Function to load the page's/module's data from a MCM preset. Use jContainers to load the object data you previously stored in SaveData().
	@param jObj - The jContainer object id returned from loading the preset data
	@override
}
endfunction

; PAGE

event OnGameReload()
{ 
	NL_MCM's page based version of OnGameReload. \
	Does not require you to call parent.OnGameReload() as with SkyUI. \
	See the original [SkyUI Advanced Features](https://github.com/schlangster/skyui/wiki/MCM-Advanced-Features).
	@override
}
endevent

event OnConfigClose()
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@override
}
endevent

event OnPageInit()
{ 
	NL_MCM's page based version of OnConfigInit. \
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@override
}
endevent

event OnPageDraw()
{ 
	NL_MCM's page based version of OnPageReset. \
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@override
}
endevent

; OPTIONS

event OnDefaultST(string state_id)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@override
}
endevent

event OnHighlightST(string state_id)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@override
}
endevent

event OnSelectST(string state_id)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@override
}
endevent

event OnSliderOpenST(string state_id)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@override
}
endevent

event OnMenuOpenST(string state_id)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@override
}
endevent

event OnColorOpenST(string state_id)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@override
}
endevent

event OnSliderAcceptST(string state_id, float f)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@param f - Refer to the SkyUI API
	@override
}
endevent

event OnMenuAcceptST(string state_id, int i)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@param i - Refer to the SkyUI API
	@override
}
endevent

event OnColorAcceptST(string state_id, int col)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@param col - Refer to the SkyUI API
	@override
}
endevent

event OnInputOpenST(string state_id)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@override
}
endevent

event OnInputAcceptST(string state_id, string str)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@param str - Refer to the SkyUI API
	@override
}
endevent

event OnKeyMapChangeST(string state_id, int keyCode)
{ 
	See the original [SkyUI API](https://github.com/schlangster/skyui/wiki/MCM-API-Reference).
	@param state_id - The nl_mcm advanced state id. Ignore this variable if you are not using advanced states
	@param keycode - Refer to the SkyUI API
	@override
}
endevent