Scriptname nl_mcm_template_page2 extends nl_mcm_module
; Change the script name to whatever you want
; just remember to update the .esp quest script too

; The mod name is set in the Creation Kit on nl_mcm
; The landing page is set in the Creation Kit on nl_mcm
; The persistent mcm preset path is set in the Creation Kit on nl_mcm
; The splash screen is set in the Creation Kit on nl_mcm
; The page name is set in the Creation kit on this script
; PageName  <- The name of the page
; PageOrder <- The order in which the page will be displayed
;              a lower number means it will display higher in the list

event OnConfigClose()
    ; By using the DEBUG_FLAG_T + DEBUG_FLAG_N combination
    ; we will print this message to the trace log (DEBUG_FLAG_T)
    ; and as a notifaction in-game (DEBUG_FLAG_N)
    DEBUG_MSG("We closed this MCM menu!", DEBUG_FLAG_T + DEBUG_FLAG_N)
endevent

event OnGameReload()
    ; OnGameReload triggers when the game reloads
    DEBUG_MSG("We reloaded the game!", DEBUG_FLAG_T + DEBUG_FLAG_N)
endevent

event OnPageDraw()
    ; Let's draw the page top to bottom!
    SetCursorFillMode(TOP_TO_BOTTOM)

    ; Let's give due credits
    AddTextOptionST("unusedtextoption", FONT_SUCCESS("Thanks to:"), "", OPTION_FLAG_DISABLED)
    ; \n means new line. So this will print out as:
    ; Me
    ; You
    ; My Mom
    ; My Dad
    AddParagraph("Me\nYou\nMy Mom\nMy Dad")

    ; Let's start drawing on the right side of the page
    SetCursorPosition(1)

    ; Let's give due credits
    AddTextOptionST("unusedtextoption2", FONT_DANGER("I dislike:"), "", OPTION_FLAG_DISABLED)
    ; \n means new line. So this will print out as:
    ; My Neighbor
    ; Sharks
    AddParagraph("My Neighbor\nSharks", FONT_WARNING())
endevent