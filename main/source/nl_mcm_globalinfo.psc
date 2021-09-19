Scriptname nl_mcm_globalinfo
{
	This documents useful global functions to check the nl_mcm api version/state.
	@author NeverLost
	@version 1.0.3
}

bool function IsInstalled() global
	return true
endfunction

int function CurrentVersion() global
	return 103
endfunction