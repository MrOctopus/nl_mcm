Scriptname nl_curios_mcm_advanced extends nl_mcm_module
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
	AddParagraph("Welcome to the advanced section :)!", FONT_INFO())
	AddTextOptionST("return_page", FONT_INFO("Return to main page"), "")

	; Right side
	SetCursorPosition(1)
	AddHeaderOption(FONT_PRIMARY("User presets"))
endevent

state return_page
	event OnHighlightST()
		SetInfoText("Return to the main page")
	endevent

	event OnSelectST()
		GoToPage("Core")
	endevent
endstate
