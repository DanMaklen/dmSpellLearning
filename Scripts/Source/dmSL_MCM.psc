scriptname dmSL_MCM extends SKI_ConfigBase

; Script Instance Injection
dmSL_State Property StateRef Auto

Event OnConfigInit()
	ModName = "[DM] Spell Learning"
	Pages = new string[2]
	Pages[0] = "Config"
	Pages[1] = "Progress State"
EndEvent

event OnPageReset(string page)
	If (page == "Config")
		SetupPageConfig()
	ElseIf (page == "Progress State")
		AddHeaderOption("Filters")
		AddHeaderOption("")
		SetCursorFillMode(TOP_TO_BOTTOM)

	EndIf
endevent

; Page 1: Config
	Function SetupPageConfig()
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Basic Configuration")
		AddToggleOptionST("ConsumeTomeOnLearn", "Consume Spell Tome on Learn", dmSL_Config.GetConsumeTomeOnLearn())
		AddSliderOptionST("BaseLearnRate", "Base Learning Rate", dmSL_Config.GetBaseLearnRate(), "{2}")
	EndFunction

	State ConsumeTomeOnLearn
		Event OnSelectST()
			bool newValue = !dmSL_Config.GetConsumeTomeOnLearn()
			dmSL_Config.SetConsumeTomeOnLearn(newValue)
			SetToggleOptionValueST(newValue)
		EndEvent
		Event OnHighlightST()
			string info = \
				"Enabled: Spell Tome WILL be consumed when the spell is learned succesfully.\n" + \
				"Disabled: Spell Tome WILL NOT be consumed when the spell is learned sucessfully.\n" + \
				BuildDefaultValueInfoTextBool(dmSL_Config.GetDefaultConsumeTomeOnLearn())
			SetInfoText(info)
		EndEvent
		Event OnDefaultST()
			SetToggleOptionValueST(dmSL_Config.GetDefaultConsumeTomeOnLearn())
		EndEvent
	EndState

	State BaseLearnRate
		Event OnSliderOpenST()
			SetSliderDialogStartValue(dmSL_Config.GetBaseLearnRate())
			SetSliderDialogDefaultValue(dmSL_Config.GetDefaultBaseLearnRate())
			SetSliderDialogRange(1.00, 100.00)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(float val)
			dmSL_Config.SetBaseLearnRate(val)
			SetSliderOptionValueST(val, "{2}")
		EndEvent
		Event OnHighlightST()
			string info = \
				"The base progress done per hour to learn a new spell before any modifiers are applied.\n" + \
				"The higher amount the faster spell is learned.\n" + \
				BuildDefaultValueInfoTextFloat(dmSL_Config.GetDefaultBaseLearnRate())
			SetInfoText(info)
		EndEvent
		Event OnDefaultST()
			SetSliderOptionValueST(dmSL_Config.GetDefaultBaseLearnRate(), "{2}")
		EndEvent
	EndState

; Utilities
	string Function BuildDefaultValueInfoTextString(string val)
		return "(Default: " + val + ")"
	EndFunction
	string Function BuildDefaultValueInfoTextFloat(float val)
		return BuildDefaultValueInfoTextString(dmSL_Utils.FloatToString(val))
	EndFunction
	string Function BuildDefaultValueInfoTextBool(bool val)
		If (val)
			return BuildDefaultValueInfoTextString("Enabled")
		Else
			return BuildDefaultValueInfoTextString("Disabled")
		EndIf
	EndFunction