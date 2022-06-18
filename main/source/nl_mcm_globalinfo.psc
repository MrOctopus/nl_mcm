Scriptname nl_mcm_globalinfo
{
	This documents useful global functions to check the nl_mcm api version/state.
	@author NeverLost
	@version 1.1.0
}

bool function IsInstalled() global
{
	Check if nl_mcm is installed.
	@return The install state of nl_mcm
}
	return true
endfunction

int function CurrentVersion() global
{
	Get the current version of nl_mcm
	@return The current nl_mcm version
}
	return 110
endfunction