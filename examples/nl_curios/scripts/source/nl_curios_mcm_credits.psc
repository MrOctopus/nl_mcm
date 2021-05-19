Scriptname nl_curios_mcm_credits extends nl_mcm_module
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
	AddHeaderOption(FONT_PRIMARY("Mod goal"))
	AddParagraph("Placeholder for some high and lofty goal description.", FONT_INFO())
	
	AddEmptyOption()
    AddTextOptionST("return_page", FONT_INFO("Return to main page"), "")

	; Right side
	SetCursorPosition(1)
    AddHeaderOption(FONT_PRIMARY("Thanks to"))
	AddParagraph("Dunc001\nKojak747\nFireundubh", FONT_INFO())
endevent

state return_page
	event OnHighlightST()
		SetInfoText("Return to the main page")
	endevent

	event OnSelectST()
		GoToPage("Core")
	endevent
endstate
