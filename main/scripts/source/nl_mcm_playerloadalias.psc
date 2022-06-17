Scriptname nl_mcm_playerloadalias extends ReferenceAlias
{!!!!!!DO NOT RECOMPILE!!!!!!
	@author NeverLost
	@version 1.0.9
}

event OnInit()
	Guard()
endevent

event OnPlayerLoadGame()
	Guard()
endEvent

;------\
; GUARD \
;--------------------------------------------------------

function Guard()
	Debug.MessageBox("nl_mcm_playerloadalias: Don't recompile this script!")
endfunction