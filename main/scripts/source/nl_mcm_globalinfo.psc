Scriptname nl_mcm_globalinfo
{!!!!!!DO NOT RECOMPILE!!!!!!
	@author NeverLost
	@version 1.0.8
}

bool function IsInstalled() global
	Guard()
endfunction

int function CurrentVersion() global
    Guard()
endfunction

;------\
; GUARD \
;--------------------------------------------------------

function Guard() global
	Debug.MessageBox("nl_mcm_globalinfo: Don't recompile this script!")
endfunction