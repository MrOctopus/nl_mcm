Scriptname nl_mcm_playerloadalias extends ReferenceAlias

quest _owner
string _mod_event

event OnInit()
	_owner = GetOwningQuest()
	_mod_event = "NL_R_" + nl_util.GetFormModName(_owner)
endevent

event OnPlayerLoadGame()
	_owner.RegisterForModEvent(_mod_event, "_OnGameReload")
	(_owner as nl_mcm).OnGameReload()
	SendModEvent(_mod_event)
endevent