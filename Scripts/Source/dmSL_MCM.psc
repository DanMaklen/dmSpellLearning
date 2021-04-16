scriptname dmSL_MCM extends SKI_ConfigBase

; Toggle states
bool aVal = false
bool bVal = false
bool cVal = false
bool dVal = false

event OnPageReset(string page)
	dmSL_SpellLearning.LearnSpell()
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0) ; Can be removed because it starts at 0 anyway
	AddHeaderOption("Group 5")
	AddToggleOption("A", aVal)
	
	AddEmptyOption()
	
	AddHeaderOption("Group 2")
	AddToggleOption("B", bVal)
	AddToggleOption("C", cVal)
	
	SetCursorPosition(1) ; Move cursor to top right position
	
	AddHeaderOption("Group 3")
	AddToggleOption("D", dVal)
endevent

event OnOpetionSelect()
endevent

state ABC

endstate