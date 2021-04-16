Scriptname nl_curios_mcm_secret extends nl_mcm_module
{
	@author NeverLost
	@version 1.0
}

;----------\
; DRAW PAGE \
;--------------------------------------------------------

event OnPageDraw()
	SetCursorFillMode(TOP_TO_BOTTOM)
	
	; Left side
	AddHeaderOption(FONT_PRIMARY("Info"))
	AddParagraph("Welcome to the secret section :)!", FONT_INFO())
endevent
