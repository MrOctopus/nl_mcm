Scriptname nl_mcm_playerloadalias extends ReferenceAlias
{
	@author NeverLost
	@version 1.1.3
}

quest _owner
string _mod_event

event OnInit()
	_owner = GetOwningQuest()
	_mod_event = "NL_R_" + nl_util.GetFormEditorID(_owner)
endevent

event OnPlayerLoadGame()
	nl_mcm mcm = (_owner as nl_mcm)

	_owner.RegisterForModEvent(_mod_event, "_OnGameReload")
	
	; Will be none if script is attached to external module
	if mcm
		mcm.OnGameReload()
	endif
	
	SendModEvent(_mod_event)
endevent