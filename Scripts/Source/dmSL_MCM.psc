scriptname dmSL_MCM extends SKI_ConfigBase

; Script Instance Injection
dmSL_State Property StateRef Auto

string Page_Config = "Config"
string Page_StudyProgress = "Study Progress"
string Page_SpellChecklist = "Spell Checklist"
Event OnConfigInit()
	ModName = "[DM] Spell Learning"
	Pages = new string[3]
	Pages[0] = Page_Config
	Pages[1] = Page_StudyProgress 
	Pages[2] = Page_SpellChecklist
EndEvent

Event OnConfigOpen()
	InitPage_SpellChecklist()
EndEvent
Event OnConfigClose()
	CleanUpPage_SpellChecklist()
EndEvent

Event OnPageReset(string page)
	If (page == Page_Config)
		SetupPage_Config()
	ElseIf (page == Page_StudyProgress)
		SetupPage_StudyProgress()
	ElseIf (page == Page_SpellChecklist)
		SetupPage_SpellChecklist()
	EndIf
EndEvent

; Page 1: Config
	Function SetupPage_Config()
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
			bool newValue = dmSL_Config.GetDefaultConsumeTomeOnLearn()
			dmSL_Config.SetConsumeTomeOnLearn(newValue)
			SetToggleOptionValueST(newValue)
		EndEvent
	EndState

	State BaseLearnRate
		Event OnSliderOpenST()
			SetSliderDialogStartValue(dmSL_Config.GetBaseLearnRate())
			SetSliderDialogDefaultValue(dmSL_Config.GetDefaultBaseLearnRate())
			SetSliderDialogRange(0.01, 1.0)
			SetSliderDialogInterval(0.01)
		EndEvent
		Event OnSliderAcceptST(float val)
			dmSL_Config.SetBaseLearnRate(val)
			SetSliderOptionValueST(val, "{2}")
		EndEvent
		Event OnHighlightST()
			string info = \
				"Controls the base progress done per hour to learn a new spell before any modifiers are applied.\n" + \
				"The higher amount the faster spell is learned.\n" + \
				BuildDefaultValueInfoTextFloat(dmSL_Config.GetDefaultBaseLearnRate())
			SetInfoText(info)
		EndEvent
		Event OnDefaultST()
			OnSliderAcceptST(dmSL_Config.GetDefaultBaseLearnRate())
		EndEvent
	EndState

; Page 2: Progress Status
	Function SetupPage_StudyProgress()
		int count = StateRef.KeyCount()
		AddHeaderOption("Progress Report (" + count + ")")
		AddHeaderOption("")
		Spell spellLearned = StateRef.FirstKey()
		While (spellLearned)
			float progress = StateRef.GetProgress(spellLearned)
			string progressString = dmSL_Utils.FloatToPercentage(progress)
			AddTextOption(spellLearned.GetName(), progressString, OPTION_FLAG_DISABLED)
			spellLearned = StateRef.NextKey(spellLearned)
		EndWhile	
	EndFunction

; Page 3: Spell Checklist
	; Filter Options
	string[] schoolFilterOptions
	string[] knownSpellsFilterOptions

	Form[] list
	; Pagination
	int curs = 0
	int pageSize = 20
	; Filters
	int schoolFilterIndex
	int knownSpellsFilterIndex

	Function InitPage_SpellChecklist()
		schoolFilterOptions = new string[7]
			schoolFilterOptions[0] = "Any"
			schoolFilterOptions[1] = "Alteration"
			schoolFilterOptions[2] = "Conjuration"
			schoolFilterOptions[3] = "Destruction"
			schoolFilterOptions[4] = "Enchanting"
			schoolFilterOptions[5] = "Illusion"
			schoolFilterOptions[6] = "Restoration"
		knownSpellsFilterOptions = new string[3]
			knownSpellsFilterOptions[0] = "Any"
			knownSpellsFilterOptions[1] = "Known Spells Only"
			knownSpellsFilterOptions[2] = "Unknown Spells Only"
	EndFunction
	Function CleanUpPage_SpellChecklist()
		; Clean up memory
		list = none
		schoolFilterOptions = none
		knownSpellsFilterOptions = none
		curs = 0
	EndFunction
	Function SetupPage_SpellChecklist()
		SetTitleText(Page_SpellChecklist)
		AddHeaderOption("Checklist")
		AddKnowSpellsCount()
		
		AddMenuOptionST("SchoolFilterSelect", "By School", schoolFilterOptions[schoolFilterIndex])
		AddMenuOptionST("KnownSpellsFilterSelect", "By Known Spells", knownSpellsFilterOptions[knownSpellsFilterIndex])
		AddEmptyOption()
		AddTextOptionST("ApplyFilter", "", "Apply Filter")

		AddHeaderOption("Navigation")
		AddHeaderOption("")
		AddSliderOptionST("PageSize", "Page Size", pageSize, "{0} items")
		AddCurrentPage()

		AddHeaderOption("")
		AddHeaderOption("")
		AddChecklist()
	EndFunction

	State PageSize
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pageSize)
			SetSliderDialogDefaultValue(20)
			SetSliderDialogRange(10, 100)
			SetSliderDialogInterval(10)
		EndEvent
		Event OnSliderAcceptST(float val)
			SetPaginationCurs(0, val as int)
		EndEvent
		Event OnHighlightST()
			SetInfoText("Set page size [10 - 100]\n" + BuildDefaultValueInfoTextInt(20))
		EndEvent
		Event OnDefaultST()
			OnSliderAcceptST(20)
		EndEvent
	EndState
	State ApplyFilter
		Event OnSelectST()
			UpdateFormList()
			SetPaginationCurs(0, pageSize)
		EndEvent
		Event OnHighlightST()
			SetInfoText("Apply filter")
		EndEvent
	EndState
	State CurrentPage
		Event OnSliderOpenST()
			SetSliderDialogStartValue(GetCurrentPage())
			SetSliderDialogDefaultValue(1)
			SetSliderDialogRange(1, GetTotalPages())
			SetSliderDialogInterval(1)
		EndEvent
		Event OnSliderAcceptST(float val)
			SetPaginationCurs((val as int - 1) * pageSize, pageSize)
		EndEvent
		Event OnHighlightST()
			SetInfoText("Select page\n" + BuildDefaultValueInfoTextInt(1))
		EndEvent
		Event OnDefaultST()
			OnSliderAcceptST(1)
		EndEvent
	EndState
	State SchoolFilterSelect
		Event OnMenuOpenST()
			SetMenuDialogStartIndex(schoolFilterIndex)
			SetMenuDialogDefaultIndex(0)
			SetMenuDialogOptions(schoolFilterOptions)
		EndEvent
		Event OnMenuAcceptST(int index)
			schoolFilterIndex = index
			SetMenuOptionValueST(schoolFilterOptions[index])
		EndEvent
		Event OnHighlightST()
			SetInfoText("Filter by spell's school.\n" + \
				"Note: If a spell have multiple magic effects and only of them match the spell will be included in the list." + \
				BuildDefaultValueInfoTextString(schoolFilterOptions[0]))
		EndEvent
		Event OnDefaultST()
			OnSliderAcceptST(0)
		EndEvent
	EndState
	State KnownSpellsFilterSelect
		Event OnMenuOpenST()
			SetMenuDialogStartIndex(knownSpellsFilterIndex)
			SetMenuDialogDefaultIndex(0)
			SetMenuDialogOptions(knownSpellsFilterOptions)
		EndEvent
		Event OnMenuAcceptST(int index)
			knownSpellsFilterIndex = index
			SetMenuOptionValueST(knownSpellsFilterOptions[index])
		EndEvent
		Event OnHighlightST()
			SetInfoText("Filter by known spells.\n" + BuildDefaultValueInfoTextString(knownSpellsFilterOptions[0]))
		EndEvent
		Event OnDefaultST()
			OnSliderAcceptST(0)
		EndEvent
	EndState

	Function SetPaginationCurs(int newCurs, int newPageSize)
		; Validation
		If (list.Length != 0 && (newCurs < 0 || newCurs >= list.Length || newCurs % pageSize != 0))
			return
		EndIf
		curs = newCurs
		pageSize = newPageSize
		SetTitleText("Updating Checklist...")
		ForcePageReset()
	EndFunction
	Function AddCurrentPage()
		int flag = OPTION_FLAG_NONE
		string format = "{0}/" + GetTotalPages()
		If (list.Length == 0)
			flag = OPTION_FLAG_DISABLED
			format = "---"
		EndIf
		AddSliderOptionST("CurrentPage", "Current Page", GetCurrentPage(), format, flag)
	EndFunction
	Function AddChecklist()
		int i = 0
		While (i < pageSize && curs + i < list.Length)
			Spell item = list[curs + i] as Spell
			AddToggleOption(item.GetName(), Game.GetPlayer().HasSpell(item))
			i += 1
		EndWhile
	EndFunction
	Function AddKnowSpellsCount()
		int knownCount = 0
		int i = 0
		While (i < list.Length)
			If (Game.GetPlayer().HasSpell(list[i]))
				knownCount += 1
			EndIf
			i += 1
		EndWhile
		AddTextOption("Known Spells", knownCount + "/" + list.Length + " (" + dmSL_Utils.FloatToPercentage(knownCount as float / list.length as float) + ")", OPTION_FLAG_DISABLED)
	EndFunction

	Function UpdateFormList()
		SetTitleText("Filtering spells...")
		Spell[] spellList = PO3_SKSEFunctions.GetAllSpells(abIsPlayable = true)
		int jArr = JArray.Object()
		int i = 0
		While (i < spellList.Length)
			Spell item = spellList[i]
			If (IsPassFilter(item))
				JArray.addForm(jArr, item)
			EndIf
			i += 1
		EndWhile
		list = JArray.asFormArray(jarr)
	EndFunction
	bool Function IsPassFilter(Spell item)
		If (knownSpellsFilterIndex == 1 && !Game.GetPlayer().HasSpell(item))	; By Known Spells
			return false
		EndIf
		If (knownSpellsFilterIndex == 2 && Game.GetPlayer().HasSpell(item))		; By Unknown Spells
			return false
		EndIf
		If (schoolFilterIndex != 0 && !SpellHasSchoolEffect(item, schoolFilterOptions[schoolFilterIndex]))
			return false
		EndIf
		return true
	EndFunction
	bool Function SpellHasSchoolEffect(Spell item, string school)
		MagicEffect[] effectList = item.GetMagicEffects()
		int i = 0
		While (i < effectList.Length)
			MagicEffect effect = effectList[i]
			If (effect.GetAssociatedSkill() == school)
				return true
			EndIf
			i += 1
		EndWhile
		return false
	EndFunction
	int Function GetCurrentPage()
		return curs / pageSize + 1
	EndFunction
	int Function GetTotalPages()
		return (list.Length + pageSize - 1) / pageSize
	EndFunction

; Utilities
	string Function BuildDefaultValueInfoTextString(string val)
		return "(Default: " + val + ")"
	EndFunction
	string Function BuildDefaultValueInfoTextFloat(float val)
		return BuildDefaultValueInfoTextString(dmSL_Utils.FloatToString(val))
	EndFunction
	string Function BuildDefaultValueInfoTextInt(int val)
		return BuildDefaultValueInfoTextString(val)
	EndFunction
	string Function BuildDefaultValueInfoTextBool(bool val)
		If (val)
			return BuildDefaultValueInfoTextString("Enabled")
		Else
			return BuildDefaultValueInfoTextString("Disabled")
		EndIf
	EndFunction