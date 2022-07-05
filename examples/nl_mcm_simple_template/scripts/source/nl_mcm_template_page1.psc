Scriptname nl_mcm_template_page1 extends nl_mcm_module
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

string[] food_types

int favorite_food_type = 0
int number_of_clicks = 0

event OnPageInit()
    food_types = new string[4]
    food_types[0] = "I don't know"
    food_types[1] = "Fruit"
    food_types[2] = "Vegetables"
    food_types[3] = "Meat"
endevent

event OnPageDraw()
    ; Let's draw the page top to bottom!
    SetCursorFillMode(TOP_TO_BOTTOM)

    AddHeaderOption("My very first nl_mcm menu")
	AddParagraph("Hello there! This is my very first mcm menu. I hope you like it")

    ; Let's start drawing on the right side of the page
    SetCursorPosition(1)
    
    ; Some simple options :)
    AddTextOptionST("option1", "Click me", number_of_clicks)
    AddMenuOptionST("option2menu", "Favorite food type", food_types[favorite_food_type])
endevent

state option1
    event OnDefaultST(string state_id)
        number_of_clicks = 0
        SetTextOptionValueST(number_of_clicks)
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("By clicking this option you will increase the displayed number :)")
    endevent

    event OnSelectST(string state_id)
        number_of_clicks += 1
        SetTextOptionValueST(number_of_clicks)
    endevent
endstate

state option2menu
    event OnDefaultST(string state_id)
        favorite_food_type = 0
        SetMenuOptionValueST(food_types[favorite_food_type])
    endevent

    event OnHighlightST(string state_id)
        SetInfoText("You can choose your favorite type of food by clicking this option")
    endevent

    event OnMenuOpenST(string state_id)
        SetMenuDialog(food_types, favorite_food_type)
    endevent

    event OnMenuAcceptST(string state_id, int i)
        favorite_food_type = i
        SetMenuOptionValueST(food_types[favorite_food_type])
    endevent
endstate

