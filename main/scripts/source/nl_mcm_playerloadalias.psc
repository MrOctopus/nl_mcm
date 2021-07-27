Scriptname nl_mcm_playerloadalias extends ReferenceAlias
{!!!!!!DO NOT RECOMPILE!!!!!!
	@author NeverLost
	@version 1.0.1
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
	Debug.MessageBox("nl_mcmplayerloadalias: Don't recompile this script!")
endfunction