Scriptname nl_mcm extends SKI_ConfigBase
{
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
{
	Concats the standard file path and mod name.
	@get Path to local mod settings folder
}
	string function get()
		return "Data/NL_MCM/" + ModName + "/"
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
		return _common_store
	endfunction

	function Set(string store)
		_common_store = store
	endfunction
endproperty

; MISC CONSTANTS
float property SPINLOCK_TIMER = 0.4 autoreadonly
float property BUFFER_TIMER = 2.0 autoreadonly
int property LINE_LENGTH = 47 autoreadonly
{Max line length for a mcm column}

; ERROR CODES
int property OK = 1 autoreadonly
int property ERROR = 0 autoreadonly
int property ERROR_MAX_PAGE_REACHED = -3 autoreadonly
int property ERROR_PAGE_NAME_TAKEN = -4 autoreadonly
int property ERROR_NOT_INITIALIZED = -5 autoreadonly
int property ERROR_PAGE_NOT_FOUND = -6 autoreadonly
int property ERROR_PRESET_NOT_FOUND = -7 autoreadonly
int property ERROR_LOADING_DATA = -8 autoreadonly
int property ERROR_BUSY_WITH_DATA = -9 autoreadonly

; EVENT CODES
int property EVENT_DEFAULT = 0 autoreadonly
int property EVENT_HIGHLIGHT = 1 autoreadonly
int property EVENT_SELECT = 2 autoreadonly
int property EVENT_OPEN = 3 autoreadonly
int property EVENT_ACCEPT = 4 autoreadonly
int property EVENT_CHANGE = 5 autoreadonly

;----\----------\
; MCM \ INTERNAL \
;--------------------------------------------------------

nl_mcm_module[] _modules
int[] _pages_z

quest _owning_quest
form _missing_form

string _key_store = ""
string _common_store = ""
string _splash_path

float _splash_x
float _splash_y

int _buffered

bool _initialized
bool _busy_jcontainer
bool _mutex_modules
bool _mutex_store
bool _mutex_page

;---------\--------\
; CRITICAL \ EVENTS \
;--------------------------------------------------------

; TODO: If common store lock is added
; we need to release the lock here if a module is unloaded
event OnGameReload()
	; Imagine F is a valid form and I is an invalid form
	; --------
	; If a module is unloaded the _modules array might look like this:
	; FFFFIIIFFIIFFI
	; This function will shift the array on encountering invalid _modules,
	; compacting it in the process. After the array has been compacted
	; the array will be resized to equal the remaining active_modules
	
	if !_initialized
		return
	endif
	
	while _mutex_modules
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	int i
	int active_modules = Pages.Length
	
	_mutex_modules = True
	
	; If _missing_form is not None, it means that we have cached the _missing form pointer.
	; All unloaded forms use the same _missing_form pointer. Variable access is quicker than
	; GetFormID()
	if _missing_form
		while i < active_modules && _modules[i] != _missing_form
			i += 1
		endwhile
	else
		; Cast is faster than GetFormID for local pages
		while i < active_modules && (_modules[i] as quest == _owning_quest || _modules[i].GetFormID() != 0)
			i += 1
		endwhile
	endif
	
	; If i != active_modules, an invalid form exists
	if i != active_modules
		int j = i + 1
		active_modules -= 1
		_missing_form = _modules[i]
		
		while _mutex_store
			Utility.WaitMenuMode(SPINLOCK_TIMER)
		endwhile
		
		_mutex_store = True
		_key_store = nl_util.DelGroup(_key_store, Pages[i])
		
		; Compact array
		while j < Pages.Length
			if _modules[j] != _missing_form
				Pages[i] = Pages[j]
				_pages_z[i] = _pages_z[j]
				_modules[i] = _modules[j]
				
				i += 1
			else
				active_modules -= 1
				_key_store = nl_util.DelGroup(_key_store, Pages[j])
			endif
			
			j += 1
		endwhile
		
		_mutex_store = False

		if active_modules == 0
			Pages = None
			_pages_z = None
		else
			Pages = Utility.ResizeStringArray(Pages, active_modules)
			_pages_z = Utility.ResizeIntArray(_pages_z, active_modules)
		endif
	endif
	
	_mutex_modules = False
	
	; Call parent to check for version updates
	parent.OnGameReload()
endevent

event OnUpdate()	
	_mutex_modules = True

	Pages = Utility.ResizeStringArray(Pages, _buffered)
	_pages_z = Utility.ResizeIntArray(_pages_z, _buffered)

	parent.OnGameReload()
	
	_buffered = 0
	_initialized = True
	
	_mutex_modules = False
endevent

event OnConfigClose()
	while _mutex_modules
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	_mutex_modules = True
	
	int i
	while i < Pages.Length
		_modules[i].OnConfigClose()
		i += 1
	endwhile
	
	_mutex_modules = False
endevent

event OnDefaultST()
	string current_page = CurrentPage
	string current_state = GetState()

	; We need to check the option type first.
	; If keymap type, get old keycode
	Ui.SetInt(JOURNAL_MENU, MENU_ROOT + ".optionCursorIndex", GetStateOptionIndex(current_state))
	if Ui.GetInt(JOURNAL_MENU, MENU_ROOT + ".optionCursor.optionType") == OPTION_TYPE_KEYMAP
		; Get old keycode
		int old_keycode = Ui.GetFloat(JOURNAL_MENU, MENU_ROOT + ".optionCursor.numValue") as int
		
		while _mutex_store
			Utility.WaitMenuMode(SPINLOCK_TIMER)
		endwhile  
		
		; Delete old value if possible
		_mutex_store = True
		_key_store = nl_util.DelGroupVal(_key_store, current_page, old_keycode as string)
		_mutex_store = False
	endif
	
    RelayPageEvent(current_state, EVENT_DEFAULT)
endEvent

event OnKeyMapChangeST(int keycode, string conflict_control, string conflict_name)	
	string current_page = CurrentPage
	string current_state = GetState()
	
	; Get old keycode
	ui.SetInt(JOURNAL_MENU, MENU_ROOT + ".optionCursorIndex", GetStateOptionIndex(current_state))
	int old_keycode = Ui.GetFloat(JOURNAL_MENU, MENU_ROOT + ".optionCursor.numValue") as int

	if conflict_control != "" && keycode != -1
		if old_keycode == keycode
			return
		endif

		string msg = ""
		
		; Mod conflict
		if conflict_name != ""
			msg = "$nl_mcm_keyconflict_mod{" + conflict_name + "}"
		; Vanilla conflict
		else
			msg = "$nl_mcm_keyconflict_vanilla{" + conflict_control + "}"
        endIf
		
		if !ShowMessage(msg, true, "$Yes", "$No")
			return
		endIf
	endIf
	
	while _mutex_store
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	; Delete old value if possible
	_mutex_store = True
	_key_store = nl_util.DelGroupVal(_key_store, current_page, old_keycode as string)
	_mutex_store = False
	
	RelayPageEvent(current_state, EVENT_CHANGE, keycode)
endEvent

;---------\-----------\
; CRITICAL \ FUNCTIONS \
;--------------------------------------------------------

int function _RegisterModule(nl_mcm_module module, string page_name, int z)		
{
	Internal register module function. \
	Please opt for using the official api in the nl_mcm_module script instead.
	@param module - Reference pointer to a module script
	@param page_name - The page name which the module will be stored under
	@param z - The Z-Index of the page. Pages are sorted in an ascending order
	@return Error code
}		
	while _mutex_modules
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	int i
	
	; We buffer _modules at init to avoid multiple external resize calls
	if !_initialized
		; First module 
		if !Pages
			_modules = new nl_mcm_module[128]
			Pages = new string[128]
			_pages_z = new int[128]
			
		; Maximum _modules exceeded
		elseif _buffered == 128
			return ERROR_MAX_PAGE_REACHED
			
		; Page name must be unique
		elseif Pages.Find(page_name) != -1
			return ERROR_PAGE_NAME_TAKEN
			
		endif
	
		_buffered += 1
		
		while i < _buffered && _pages_z[i] <= z
			i += 1
		endwhile
		
		; Append
		if i == _buffered
			i = _buffered - 1
		; Insert
		else
			int j = _buffered
			
			while i < j
				int k = j - 1
				
				Pages[j] = Pages[k]
				_pages_z[j] = _pages_z[k]
				_modules[j] = _modules[k]
				
				j = k
			endwhile
		endif
		
		RegisterForSingleUpdate(BUFFER_TIMER)
		
		Pages[i] = page_name
		_pages_z[i] = z
	
	; - REGULAR -
	; No need to buffer, as overlapping registers are unlikey to occur	
	else
		; First module
		if !Pages
			Pages = new string[1]
			_pages_z = new int[1]
			
			Pages[0] = page_name
			_pages_z[0] = z
			_modules[0] = module
			return OK
			
		; Maximum _modules exceeded
		elseif Pages.Length == 128
			return ERROR_MAX_PAGE_REACHED
			
		; Page name must be unique
		elseif Pages.Find(page_name) != -1
			return ERROR_PAGE_NAME_TAKEN
			
		endif

		while i < Pages.Length && _pages_z[i] <= z
			i += 1
		endwhile
		
		int j = Pages.Length
		
		; Append
		_mutex_modules = True
		
		Pages = Utility.ResizeStringArray(Pages, j + 1, page_name)
		_pages_z = Utility.ResizeIntArray(_pages_z, j + 1 , z)
		
		_mutex_modules = False
		
		; Insert
		if i != j
			while i < j
				int k = j - 1
				
				Pages[j] = Pages[k]
				_pages_z[j] = _pages_z[k]
				_modules[j] = _modules[k]
				
				j = k
			endwhile
		
			Pages[i] = page_name
			_pages_z[i] = z
		endif
	endif

	_modules[i] = module
	return OK
endfunction

int function _UnregisterModule(string page_name)
{
	Internal unregister module function. \
	Please opt for using the official api in the nl_mcm_module script instead.
	@param page_name - The page name of the module we want to unregister
	@return Error code
}	
	while _mutex_modules
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	if !_initialized
		return ERROR_NOT_INITIALIZED
	endif
	
	int i = Pages.Find(page_name)
	
	if i == -1
		return ERROR_PAGE_NOT_FOUND
	endif
	
	int j = Pages.Length - 1
	_mutex_modules = True
	
	if j == 0
		Pages = None
		_pages_z = None
	else
		while i < j
			int k = i + 1
			
			Pages[i] = Pages[k]
			_pages_z[i] = _pages_z[k]
			_modules[i] = _modules[k]
			
			i = k
		endwhile
	
		Pages = Utility.ResizeStringArray(Pages, j)
		_pages_z = Utility.ResizeIntArray(_pages_z, j)
	endif
	
	_mutex_modules = False
	
	while _mutex_store
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	_mutex_store= True
	_key_store = nl_util.DelGroup(_key_store, page_name)
	_mutex_store = False
	
	return OK
endfunction

int function SaveMCMToPreset(string preset_path)
{
	Calls the local SaveData function on all module scripts, storing the resulting JObjects under the given file name.
	@param preset_path - The path to the preset to store the settings under
	@return Error code
}
	if !JContainers.isInstalled()
		return ERROR
	endif
	
	if preset_path == ""
		return ERROR_PRESET_NOT_FOUND
	endif
	
	if _busy_jcontainer
		return ERROR_BUSY_WITH_DATA
	endif
	
	_busy_jcontainer = true
	
	int jPreset = JMap.object()
	
	while _mutex_modules
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	_mutex_modules = true
	
	int i = 0
	while i < Pages.Length
		int jData = _modules[i].SaveData()
		if jData > 0
			JMap.setObj(jPreset, Pages[i], jData)
		endif
		i += 1
	endwhile
	
	_mutex_modules = false
	
	if JMap.count(jPreset) > 0
		JValue.writeTofile(jPreset, MCM_PATH_SETTINGS + preset_path + MCM_EXT)
	endif
	
	_busy_jcontainer = false
	
	JValue.zeroLifetime(jPreset)
	
	return OK
endFunction

int function LoadMCMFromPreset(string preset_path)
{
	Calls the local LoadData function on all module scripts, using the JObjects loaded from the given file.
	@param preset_path - The path to the preset to load settings from
	@return Error code
}
	if !JContainers.isInstalled()
		return ERROR
	endif
	
	if preset_path == ""
		return ERROR_PRESET_NOT_FOUND
	endif
	
	if _busy_jcontainer
		return ERROR_BUSY_WITH_DATA
	endif

	_busy_jcontainer = True
	
	int jPreset
	
	jPreset = JValue.readFromFile(MCM_PATH_SETTINGS + preset_path + MCM_EXT)
	
	if jPreset == 0
		_busy_jcontainer = false
		return ERROR_LOADING_DATA
	endif
	
	_mutex_modules = true
	
	int i = 0
	while i < Pages.Length
		int jData = JMap.getObj(jPreset, Pages[i])
		if jData > 0
			_modules[i].LoadData(jData)
		endif
		i += 1
	endwhile
	
	_mutex_modules = false	
	_busy_jcontainer = false
	
	JValue.zeroLifetime(jPreset)
	
	return OK
endFunction

function AddKeyMapOptionST(String a_stateName, String a_text, Int a_keycode, Int a_flags = 0)
	if a_keyCode != -1
		string current_page = CurrentPage
	
		while _mutex_store
			Utility.WaitMenuMode(SPINLOCK_TIMER)
		endwhile
		
		_mutex_store = True
		if !nl_util.HasVal(_key_store, a_keyCode as string)
			_key_store = nl_util.InsertGroupVal(_key_store, current_page, a_keycode as string)
		endif
		_mutex_store = False
	endif
	
	parent.AddKeyMapOptionST(a_stateName, a_text, a_keycode, a_flags)
endfunction

function SetKeyMapOptionValueST(int a_keycode, bool no_update = false, string a_stateName = "")
	if a_keyCode != -1
		string current_page = CurrentPage
	
		while _mutex_store
			Utility.WaitMenuMode(SPINLOCK_TIMER)
		endwhile
		
		_mutex_store = True
		if !nl_util.HasVal(_key_store, a_keyCode as string)
			_key_store = nl_util.InsertGroupVal(_key_store, current_page, a_keycode as string)
		endif
		_mutex_store = False
	endif
	
	parent.SetKeyMapOptionValueST(a_keycode, no_update, a_stateName)
endfunction

string function GetCustomControl(int a_keycode)
	while _mutex_store
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile 

	if nl_util.HasVal(_key_store, a_keyCode as string)
		return "!"
	endif

	return ""
endfunction

function SetPage(String a_page, Int a_index)	
	while _mutex_page
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	_mutex_page = True
	parent.SetPage(a_page, a_index)
	_mutex_page = False
endFunction

;-------------\--------\
; NON-CRITICAL \ EVENTS \
;--------------------------------------------------------

event OnInit()
	_owning_quest = self as quest
endevent

; Possible thrown exception
event OnPageReset(string page)
	if page != ""
		UnloadCustomContent()
	
		int i = Pages.Find(page)
		_modules[i]._OnPageDraw()
	elseif _splash_path != ""
		LoadCustomContent(_splash_path, _splash_x, _splash_y)
	endif
endevent

event OnHighlightST()
    RelayPageEvent(GetState(), EVENT_HIGHLIGHT)
endEvent

event OnSelectST()
    RelayPageEvent(GetState(), EVENT_SELECT)
endEvent

event OnSliderOpenST()
    RelayPageEvent(GetState(), EVENT_OPEN)
endEvent

event OnMenuOpenST()
    RelayPageEvent(GetState(), EVENT_OPEN)
endEvent

event OnColorOpenST()
    RelayPageEvent(GetState(), EVENT_OPEN)
endEvent

event OnSliderAcceptST(float f)
    RelayPageEvent(GetState(), EVENT_ACCEPT, f)
endEvent
    
event OnMenuAcceptST(int i)
    RelayPageEvent(GetState(), EVENT_ACCEPT, i)
endEvent
    
event OnColorAcceptST(int col)
    RelayPageEvent(GetState(), EVENT_ACCEPT, col)
endEvent

event OnInputOpenST()
	RelayPageEvent(GetState(), EVENT_ACCEPT)
endEvent

event OnInputAcceptST(string str)
    RelayPageEvent(GetState(), EVENT_ACCEPT, -1.0, str)
endEvent

;-------------\-----------\
; NON-CRITICAL \ FUNCTIONS \
;--------------------------------------------------------

; Possible thrown exception
function RelayPageEvent(string state_name, int event_id, float f = -1.0, string str = "")
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(state_name, event_id, f, str)
endfunction

int function GetMCMSavedPresets(string[] presets, string default, string dir_path)
{
	Get an array containing the name of all saved presets.
	@param presets - An empty/none list to store the results in
	@param default - A default string to fill the list with. Used to create a "fake exit" button for mcm menus
	@param dir_path - The directory path of the presets. Defaults to current mcm menu directory 
	@return Error code
}
	if !JContainers.isInstalled()
		return ERROR
	endif
	
	string[] dir_presets = JContainers.contentsOfDirectoryAtPath(MCM_PATH_SETTINGS + dir_path, MCM_EXT)	
	
	if dir_presets.Length == 0
		return ERROR_PRESET_NOT_FOUND
	endif
	
	presets = Utility.CreateStringArray(dir_presets.length + 1, default)
	int i
	
	while i < dir_presets.length
		presets[i + 1] = StringUtil.Substring(dir_presets[i], 0, StringUtil.Find(dir_presets[i], MCM_EXT))
		i += 1
	endwhile
	
	return OK
endfunction

int function DeleteMCMSavedPreset(string preset_path)
{
	Delete a given preset from the settings folder. 
	@param preset_path - The path to the preset to delete
	@return Error code
}
	if !JContainers.isInstalled()
		return ERROR
	endif
	
	if preset_path == ""
		return ERROR_PAGE_NOT_FOUND
	endif
	
	if _busy_jcontainer
		return ERROR_BUSY_WITH_DATA
	endif
	
	_busy_jcontainer = True
	JContainers.removeFileAtPath(MCM_PATH_SETTINGS + preset_path + MCM_EXT)
	_busy_jcontainer = False
	
	return OK
endfunction

function AddParagraph(string text, string begin_format = "", string end_format = "", int flags = 0x01)
{
	A convenience function to add a paragraph of text to the mcm page. \
	Text splitting occurs when the [max line length](#LINE_LENGTH) is reached, or when a newline character (\n) is encountered.
	@param text - The text to add as a paragraph to the page
	@param begin_format - The format string to append at the start of each paragraph line. \
	Can be used to for example add html coloring to the paragraph text
	@param end_format - The format string to append at the end of each paragraph line. \
	Can be used to for example add html coloring to the paragraph text
	@param flags - The default flag of the added text options 
}
	int i = 0
	int j = StringUtil.GetLength(text)
	
	while i < j
		string line
		int i_nl = StringUtil.Find(text, "\n")
		
		; New line found
		if i_nl != -1 && i_nl < i + LINE_LENGTH
			line = StringUtil.SubString(text, i, i_nl - i)
			i = i_nl + 1
		
		else
			i_nl = i + LINE_LENGTH
			
			; Remaining length is below limit
			if i_nl >= j
				line = StringUtil.SubString(text, i, j - i)
				i = j
				
			else
				; Find furthest away space
				while i_nl > i && StringUtil.GetNthChar(text, i_nl) != " "
					i_nl -= 1
				endwhile
				
				; No space found
				if i_nl == i
					line = StringUtil.SubString(text, i, LINE_LENGTH)
					i += LINE_LENGTH
					
				else
					line = StringUtil.SubString(text, i, i_nl - i)
					i = i_nl + 1
					
				endif
			endif
		endif
		
		AddTextOption(begin_format + line + end_format, "", flags)
	endwhile
endfunction

int function SetModName(string name)
{
	Set the mod page name. Can only be used before the MCM has been initialized.
	@param name - The mod's name
	@return Error Code
}
	if _initialized
		return ERROR
	endif
	
	ModName = name

	return OK
endfunction

function SetSplashScreen(string path, float x, float y)
{
	Set a splash screen to use for the "" page of the mcm menu.
	@param path - File path of the splash screen
	@param x - The x position of the splash screen
	@param y - The y position of the splash screen
}
	_splash_path = path
	_splash_x = x
	_splash_y = y
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
	SetSliderDialogRange(range_start, range_end)
    SetSliderDialogStartValue(value)
    SetSliderDialogInterval(interval)
    SetSliderDialogDefaultValue(default)
endFunction 

function SetMenuDialog(string[] options, int start_i, int default_i)
{
	A convenience function to set all of the menu data using only 1 function.
	@param options - The array containig the options for the menu
	@param start_i - The start selection/index of the menu
	@param default_i - The default selection/index for the menu
}
    SetMenuDialogOptions(options)
	SetMenuDialogStartIndex(start_i)
    SetMenuDialogDefaultIndex(default_i)
endFunction

function RefreshPages()
{
	Refreshes the mod's mcm pages. \
	Useful for situations where new pages/modules have been registered whilst the player is still in the mod's mcm menu. \
	Thus requiring the page list to be reset. \
	Use it when you need to refresh the mcm flash page list
}
	SetPage("", -1)
	Ui.InvokeStringA(JOURNAL_MENU, MENU_ROOT + ".setPageNames", Pages)
endFunction
