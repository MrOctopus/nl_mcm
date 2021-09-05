Scriptname nl_mcm extends SKI_ConfigBase
{
	@author NeverLost
	@version 1.0.2
}

; This will probably never change
int function GetVersion()
    return 101
endfunction

; ---\-------\
; MCM \ DEBUG \
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
	Prints to a given debug channel in the format "NL_MCM(ModName, ScriptName, ModName): msg".
	@param msg - Error message
	@param flag - Which debug channel to use. \
	Use either [Empty](#DEBUG_FLAG_E), [Trace](#DEBUG_FLAG_T), [Notifications](#DEBUG_FLAG_N), or combinations (just add the flags together) FLAG_T + FLAG_N
	@return The concatted error message
}
	msg = "NL_MCM(" + nl_util.GetFormModName(self) + ", " + nl_util.GetFormScriptName(self) + ", " + ModName + "): " + msg

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

;----\------------\
; MCM \ PROPERTIES \
;--------------------------------------------------------

string property MCM_EXT = ".nlset" autoreadonly
{ Preset file extension }

; MISC CONSTANTS
float property SPINLOCK_TIMER = 0.3 autoreadonly
float property BUFFER_TIMER = 2.0 autoreadonly
int property LINE_LENGTH = 47 autoreadonly

; ERROR CODES
int property OK = 1 autoreadonly
int property ERROR = 0 autoreadonly

int property ERROR_MODULE_FULL = -1 autoreadonly
int property ERROR_MODULE_TAKEN = -2 autoreadonly
int property ERROR_MODULE_INIT = -3 autoreadonly
int property ERROR_MODULE_NONE = -4 autoreadonly

; FONTS
int property FONT_TYPE_DEFAULT = 0x00 autoreadonly
int property FONT_TYPE_PAPER = 0x01 autoreadonly

; ADVANCED
string property MCM_PATH_SETTINGS hidden
{
	Concats the standard file path and mod name.
	@get Path to local mod settings folder
}
	string function Get()
		return "Data/NL_MCM/" + ModName + "/"
	endfunction
endproperty

int property QuickHotkey hidden
	int function Get()
		return _mcm_hotkey
	endfunction

	function Set(int keycode)
		; Unregister
		if keycode == -1
			UnregisterForKey(_mcm_hotkey)
			UnregisterForMenu(JOURNAL_MENU)
		else
			; Reregister
			if _mcm_hotkey != -1
				UnregisterForKey(_mcm_hotkey)
			; Register
			else
				RegisterForMenu(JOURNAL_MENU)
			endif

			RegisterForKey(keycode)
		endif

		_mcm_hotkey = keycode
	endfunction
endproperty

;----\----------\
; MCM \ INTERNAL \
;--------------------------------------------------------

; None array pointers
; workaround for weird Papyrus design choice
string[] _none_string_ptr
int[] _none_int_ptr

; GO ON

nl_mcm_module[] _modules
int[] _pages_z

quest _owning_quest

string _key_store
string _common_store
string _common_store_owner
string _landing_page
string _splash_path

float _splash_x
float _splash_y

int _buffered
int _advanced_modules ; External module
int _id = -1
int _font = -1
int _mcm_hotkey = -1

bool _journal_open
bool _quick_open

bool _initialized
bool _busy_jcontainer
bool _mutex_modules = true
bool _mutex_store
bool _mutex_page
bool _ctd_lock

;---------\--------\
; CRITICAL \ EVENTS \
;--------------------------------------------------------

event OnGameReload()
	; Imagine F is a valid form and I is an invalid form
	; --------
	; If a module is unloaded the _modules array might look like this:
	; FFFFIIIFFIIFFI
	; This function will shift the array on encountering invalid _modules,
	; compacting it in the process. After the array has been compacted
	; the array will be resized to equal the remaining active_modules
	
	if !_initialized || _advanced_modules == 0
		return
	endif
	
	while _mutex_modules
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile
	
	int i
	int active_modules = Pages.Length
	
	_mutex_modules = True
	
	; Cast is faster than GetFormID for local pages
	while i < active_modules && (_modules[i] as quest == _owning_quest || _modules[i].GetFormID() != 0)
		i += 1
	endwhile
	
	; If i != active_modules, an invalid form exists
	if i != active_modules
		int j = i + 1
		active_modules -= 1
		_advanced_modules -= 1
		form _missing_form = _modules[i]
		
		while _mutex_store
			Utility.WaitMenuMode(SPINLOCK_TIMER)
		endwhile
		
		_mutex_store = True

		if _common_store_owner == Pages[i]
			_common_store_owner = ""
		endif

		if _landing_page == Pages[i]
			_landing_page = ""
		endif

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
				_advanced_modules -= 1

				if _common_store_owner == Pages[j]
					_common_store_owner = ""
				endif

				if _landing_page == Pages[j]
					_landing_page = ""
				endif

				_key_store = nl_util.DelGroup(_key_store, Pages[j])
			endif
			
			j += 1
		endwhile
		
		_mutex_store = False

		if active_modules == 0
			Pages = _none_string_ptr
			_pages_z = _none_int_ptr
		else
			Pages = Utility.ResizeStringArray(Pages, active_modules)
			_pages_z = Utility.ResizeIntArray(_pages_z, active_modules)
		endif
	endif
	
	_mutex_modules = False
endevent

event OnUpdate()
	; Registering for single update can fuck everything else up
	; so we need to bulletproof this
	if _initialized
		return
	endif
	
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

	_mutex_modules = true

	nl_mcm_module[] modules_tmp
	int len = Pages.Length
	int i = 0

	if len < 12
		modules_tmp = new nl_mcm_module[12]
	else
		modules_tmp = new nl_mcm_module[128]
	endif

	while i < len
		modules_tmp[i] = _modules[i]
		i += 1
	endwhile

	_mutex_modules = false

	i = 0
	
	while i < len
		modules_tmp[i].OnConfigClose()
		i += 1
	endwhile
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

	; Possible thrown exception
	int i = Pages.Find(current_page)
	_modules[i]._OnPageEvent(current_state, 0, -1.0, "")
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
			msg = "$SKI_MSG2{[" + conflict_name + "]}"
		; Vanilla conflict
		else
			msg = "$SKI_MSG2{[" + conflict_control + "]}"
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
	
	; Possible thrown exception
	int i = Pages.Find(current_page)
	_modules[i]._OnPageEvent(current_state, 5, keycode, "")
endEvent

;---------\-----------\
; CRITICAL \ FUNCTIONS \
;--------------------------------------------------------

; This is ugly and long, but additional splitting will slow it down
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
	
	int i = 0
	
	; We buffer _modules at init to avoid multiple external resize calls
	if !_initialized			
		; Maximum _modules exceeded
		if _buffered == 128
			DEBUG_MSG("The MCM has already reached the page limit.")
			return ERROR_MODULE_FULL
			
		; Page name must be unique
		elseif Pages.Find(page_name) != -1
			DEBUG_MSG("The MCM already has a page named [" + page_name +  "].")
			return ERROR_MODULE_TAKEN
			
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
	elseif Pages			
		; Maximum _modules exceeded
		if Pages.Length == 128
			DEBUG_MSG("The MCM has already reached the page limit.")
			return ERROR_MODULE_FULL
			
		; Page name must be unique
		elseif Pages.Find(page_name) != -1
			DEBUG_MSG("The MCM already has a page named [" + page_name +  "].")
			return ERROR_MODULE_TAKEN
			
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
	; First module
	else
		Pages = new string[1]
		_pages_z = new int[1]
		
		Pages[0] = page_name
		_pages_z[0] = z
		i = 0
	endif

	if module as quest != _owning_quest
		_advanced_modules += 1
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
		DEBUG_MSG("The MCM is not initialized.", DEBUG_FLAG_T + DEBUG_FLAG_N)
		return ERROR_MODULE_INIT
	endif
	
	int i = Pages.Find(page_name)
	
	if i == -1
		DEBUG_MSG("The MCM has no page called [" + page_name + "].", DEBUG_FLAG_T + DEBUG_FLAG_N)
		return ERROR_MODULE_NONE
	endif
	
	int j = Pages.Length - 1
	_mutex_modules = True

	if _modules[i] as quest != _owning_quest
		_advanced_modules -= 1
	endif

	if _common_store_owner == page_name
		_common_store_owner = ""
	endif

	if _landing_page == page_name
		_landing_page = ""
	endif
	
	if j == 0
		Pages = _none_string_ptr
		_pages_z = _none_int_ptr
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

function SaveMCMToPreset(string preset_path)
	if !JContainers.isInstalled() || preset_path == ""
		return
	endif

	if _busy_jcontainer
		ShowMessage("Already busy with saving/loading a preset\nTry again later", false, "$OK")
		return
	endif
	
	_busy_jcontainer = true
	int jPreset = JMap.object()
	
	while _mutex_modules
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile

	_mutex_modules = true

	nl_mcm_module[] modules_tmp = new nl_mcm_module[128]
	int len = Pages.Length
	int i = 0

	while i < len
		modules_tmp[i] = _modules[i]
		i += 1
	endwhile

	_mutex_modules = false

	i = 0
	
	while i < len
		; Possible thrown exception
		int jData = modules_tmp[i].SaveData()

		if jData > 0
			JMap.setObj(jPreset, Pages[i], jData)
		endif

		i += 1
	endwhile
	
	if JMap.count(jPreset) > 0
		JValue.writeTofile(jPreset, MCM_PATH_SETTINGS + preset_path + MCM_EXT)
	endif
	
	_busy_jcontainer = false
	JValue.zeroLifetime(jPreset)
endfunction

string function GetCommonStore(string page_name, bool lock)
	int i = 10

	; Not a true spinlock because users might muck this up
	while _common_store_owner != "" && _common_store_owner != page_name && i > 0
		Utility.WaitMenuMode(SPINLOCK_TIMER)
		i -= 1
	endwhile

	if lock
		_common_store_owner = page_name
	endif

	return _common_store
endfunction

function SetCommonStore(string page_name, string new_value)
	int i = 10

	; Not a true spinlock because users might muck this up
	while _common_store_owner != "" && _common_store_owner != page_name && i > 0
		Utility.WaitMenuMode(SPINLOCK_TIMER)
		i -= 1
	endwhile

	_common_store_owner = ""
	_common_store = new_value
endfunction

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
endfunction

;-------------\--------\
; NON-CRITICAL \ EVENTS \
;--------------------------------------------------------

event OnInit()
	; Cache since this is used often
	_owning_quest = self as quest
	; These will be resized
	_modules = new nl_mcm_module[128]
	Pages = new string[128]
	_pages_z = new int[128]
	; Disable mutex
	_mutex_modules = false
endevent

event OnConfigManagerReset(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	_id = -1
	RegisterForModEvent("SKICP_configManagerReady", "OnConfigManagerReady")
endEvent

event OnConfigManagerReady(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	SKI_ConfigManager newManager = a_sender as SKI_ConfigManager

	if newManager == none || _id >= 0
		return
	endif

	_id = newManager.RegisterMod(self, ModName)

	if _id >= 0
		; Unregister to avoid polling events
		UnregisterForModEvent("SKICP_configManagerReady")
		Debug.Trace(self + ": Registered " + ModName + " at MCM.")
	endif
endEvent

event OnPageReset(string page)
	if page != ""
		UnloadCustomContent()
	
		; Possible thrown exception
		int i = Pages.Find(page)
		_modules[i]._OnPageDraw(_font)
	else
		if _font == -1
			; Hack to check if Dear Diary is installed
			if Ui.GetString(JOURNAL_MENU, MENU_ROOT + ".contentHolder.background._url") == "Interface/deardiary/configpanel/configpanel%5FBG.swf"
				_font = FONT_TYPE_PAPER
			else
				_font = FONT_TYPE_DEFAULT
			endif
		endif

		if _landing_page != ""
			parent.SetPage(_landing_page, Pages.Find(_landing_page))
		elseif _splash_path != ""
			LoadCustomContent(_splash_path, _splash_x, _splash_y)
		endif
	endif
endevent

; Possible thrown exception
event OnHighlightST()
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 1, -1.0, "")
endEvent

; Possible thrown exception
event OnSelectST()
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 2, -1.0, "")
endEvent

; Possible thrown exception
event OnSliderOpenST()
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 3, -1.0, "")
endEvent

; Possible thrown exception
event OnMenuOpenST()
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 3, -1.0, "")
endEvent

; Possible thrown exception
event OnColorOpenST()
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 3, -1.0, "")
endEvent

; Possible thrown exception
event OnInputOpenST()
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 3, -1.0, "")
endEvent

; Possible thrown exception
event OnSliderAcceptST(float f)
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 4, f, "")
endEvent
    
; Possible thrown exception
event OnMenuAcceptST(int index)
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 4, index, "")
endEvent

; Possible thrown exception
event OnColorAcceptST(int col)
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 4, col, "")
endEvent

; Possible thrown exception
event OnInputAcceptST(string str)
	int i = Pages.Find(CurrentPage)
	_modules[i]._OnPageEvent(GetState(), 4, -1.0, str)
endEvent

event OnMenuOpen(string menu_name)
	_journal_open = true

	if !_quick_open
		return
	endif

	_quick_open = false

	if _id < 0
		return
	endif

	while _ctd_lock
		Utility.WaitMenuMode(SPINLOCK_TIMER)
	endwhile

	; Lock
	_ctd_lock = true

	int[] select_type = new int[2]
	select_type[0] = _id
	select_type[1] = 1

	string sort_event = MENU_ROOT + ".contentHolder.modListPanel.modListFader.list.entryList.sortOn"

	; Numeric sortOn
	int handle = UiCallback.Create(JOURNAL_MENU, sort_event)
	
	if !handle
		_ctd_lock = false
		return 
	endif
	
	UiCallback.PushString(handle, "modIndex")
	UiCallback.PushInt(handle, 16)

	; Alphabetic caseinsensitive sortOn
	int handle2 = UiCallback.Create(JOURNAL_MENU, sort_event)

	if !handle2
		_ctd_lock = false
		return 
	endif

	UiCallback.PushString(handle2, "text")
	UiCallback.PushInt(handle2, 1)

	; Wait 0.3 seconds for the ConfigManager to setNames
	Utility.WaitMenuMode(SPINLOCK_TIMER)

	UiCallback.Send(handle)
	Ui.Invoke(JOURNAL_MENU, "_root.QuestJournalFader.Menu_mc.ConfigPanelOpen")
	Ui.InvokeIntA(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.modListFader.list.doSetSelectedIndex", select_type)
	Ui.InvokeIntA(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.modListFader.list.onItemPress", select_type)
	UiCallback.Send(handle2)
	
	; Cooldown
	Utility.WaitMenuMode(SPINLOCK_TIMER)
	_ctd_lock = false
endevent

event OnMenuClose(string menu_name)
	_journal_open = false
	_quick_open = false
endevent

event OnKeyDown(int keycode)
	if keycode != _mcm_hotkey
		return
	endif

	if _journal_open
		CloseMCM(close_journal = true)
	else
		_quick_open = true
		Input.TapKey(Input.GetMappedKey("Journal"))
	endif
endevent

;-------------\-----------\
; NON-CRITICAL \ FUNCTIONS \
;--------------------------------------------------------

int function GetNumMCMSavedPresets(string dir_path = "")
	if !JContainers.isInstalled()
		return 0
	endif

	return JContainers.contentsOfDirectoryAtPath(MCM_PATH_SETTINGS + dir_path, MCM_EXT).length
endfunction

string[] function GetMCMSavedPresets(string default, string dir_path = "")
	if !JContainers.isInstalled()
		return _none_string_ptr
	endif
	
	string[] dir_presets = JContainers.contentsOfDirectoryAtPath(MCM_PATH_SETTINGS + dir_path, MCM_EXT)	
	
	if dir_presets.length == 0
		return _none_string_ptr
	endif
	
	string[] presets = Utility.CreateStringArray(dir_presets.length + 1, default)
	int path_index = StringUtil.GetLength(MCM_PATH_SETTINGS)
	int i
	
	while i < dir_presets.length
		presets[i + 1] = StringUtil.Substring(dir_presets[i], path_index, StringUtil.Find(dir_presets[i], MCM_EXT) - path_index)
		i += 1
	endwhile
	
	return presets
endfunction

function LoadMCMFromPreset(string preset_path)
	if !JContainers.isInstalled() || preset_path == ""
		return
	endif

	if _busy_jcontainer
		ShowMessage("Already busy with saving/loading a preset\nTry again later", false, "$OK")
		return
	endif

	_busy_jcontainer = True
	int jPreset = JValue.readFromFile(MCM_PATH_SETTINGS + preset_path + MCM_EXT)
	
	if jPreset == 0
		_busy_jcontainer = false
		return
	endif

	string[] page_names = JMap.allKeysPArray(jPreset)
	int prev_page_length = Pages.length
	int remaining = page_names.length
	int failed = 0

	while failed < remaining
		while failed < remaining && 0 < remaining
			int jData = JMap.getObj(jPreset, page_names[failed])
			int i = Pages.Find(page_names[failed])

			if i != -1
				remaining -= 1
				page_names[failed] = page_names[remaining]
				_modules[i].LoadData(jData)
			else
				failed += 1
			endif
		endwhile

		if Pages.length != prev_page_length
			prev_page_length = Pages.length
			failed = 0
		endif
	endwhile
	
	_busy_jcontainer = false
	JValue.zeroLifetime(jPreset)
endfunction

function DeleteMCMSavedPreset(string preset_path)
	if !JContainers.isInstalled() || preset_path == ""
		return
	endif
	
	JContainers.removeFileAtPath(MCM_PATH_SETTINGS + preset_path + MCM_EXT)
endfunction

function AddParagraph(string text, string format = "", int flags = 0x01)
	string begin_format = ""
	string end_format = ""

	if format != ""
		string[] formats = StringUtil.Split(format, "</")

		if formats.length == 2
			begin_format = "<" + formats[0]
			end_format = "</" + formats[1]
		endif
	endif

	int i = 0
	int j = StringUtil.GetLength(text)
	
	; This is ugly, but the most efficient method of doing it
	while i < j
		string line
		int i_nl = StringUtil.Find(text, "\n", i)
		
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

int function GetMCMID()
	return _id
endfunction

function SetModName(string name)
	if !_initialized
		ModName = name
	endif
endfunction

function SetLandingPage(string page_name)
	if page_name == "" || Pages.Find(page_name) != -1
		_landing_page = page_name
	endif
endfunction

function SetSplashScreen(string path, float x = 0.0, float y = 0.0)
	_splash_path = path
	_splash_x = x
	_splash_y = y
endfunction

function SetFont(int font = 0x00)
	if _font >= 0
		_font = font
	endif
endfunction

function SetSliderDialog(float value, float range_start, float range_end, float interval, float default = 0.0)
	SetSliderDialogRange(range_start, range_end)
    SetSliderDialogStartValue(value)
    SetSliderDialogInterval(interval)
    SetSliderDialogDefaultValue(default)
endFunction 

function SetMenuDialog(string[] options, int start_i, int default_i = 0)
    SetMenuDialogOptions(options)
	SetMenuDialogStartIndex(start_i)
    SetMenuDialogDefaultIndex(default_i)
endFunction

function ForcePageListReset(bool stay = true)	
	if stay
		Ui.InvokeStringA(JOURNAL_MENU, MENU_ROOT + ".setPageNames", Pages)
		GoToPage(CurrentPage)
	else
		SetPage("", -1)
		Ui.InvokeStringA(JOURNAL_MENU, MENU_ROOT + ".setPageNames", Pages)
	endif
endFunction

function GoToPage(string page_name)
	if Ui.GetString(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.decorTitle.textHolder.textField.text") != ModName
		return
	endif

	int i = Pages.Find(page_name)

	if i == -1
		return
	endif

	int[] select_type = new int[2]
	select_type[0] = i
	select_type[1] = 1

	Ui.InvokeBool(JOURNAL_MENU, MENU_ROOT + ".unlock", true)
	Ui.InvokeIntA(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.subListFader.list.doSetSelectedIndex", select_type)
	Ui.InvokeIntA(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.subListFader.list.onItemPress", select_type)
endfunction

function CloseMCM(bool close_journal = false)
	if _ctd_lock
		return
	endif

	; Lock
	_ctd_lock = true

	if Ui.GetString(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.decorTitle.textHolder.textField.text") != ModName
		_ctd_lock = false
		return
	endif
	
	Ui.InvokeInt(JOURNAL_MENU, MENU_ROOT + ".changeFocus", 0)
	Ui.Invoke(JOURNAL_MENU, MENU_ROOT + ".contentHolder.modListPanel.showList")
	
	if close_journal
		Ui.Invoke(JOURNAL_MENU, "_root.QuestJournalFader.Menu_mc.ConfigPanelClose")
		Ui.InvokeBool(JOURNAL_MENU, "_root.QuestJournalFader.Menu_mc.CloseMenu", true)
	endif

	; Cooldown
	Utility.WaitMenuMode(SPINLOCK_TIMER)
	_ctd_lock = false
endfunction
