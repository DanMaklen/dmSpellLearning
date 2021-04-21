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
		AddStudySessionConditions()
	EndFunction

	State ConsumeTomeOnLearn
		Event OnSetToggleValue(bool newValue)
			dmSL_Config.SetConsumeTomeOnLearn(newValue)
			SetToggleOptionValueST(newValue)
		EndEvent
		Event OnSelectST()
			OnSetToggleValue(!dmSL_Config.GetConsumeTomeOnLearn())
		EndEvent
		Event OnHighlightST()
			string infoText = "If enabled, Spell Tome will be consumed when the spell is learned succesfully."
			SetInfoTextWithDefaultToggle(infoText, dmSL_Config.GetDefaultConsumeTomeOnLearn())
		EndEvent
		Event OnDefaultST()
			OnSetToggleValue(dmSL_Config.GetDefaultConsumeTomeOnLearn())
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
			string infoText = \
				"Controls the base progress done per hour to learn a new spell before any modifiers are applied.\n" + \
				"The higher amount the faster spell is learned."
			SetInfoTextWithDefaultFloat(infoText, dmSL_Config.GetDefaultBaseLearnRate())
		EndEvent
		Event OnDefaultST()
			OnSliderAcceptST(dmSL_Config.GetDefaultBaseLearnRate())
		EndEvent
	EndState


	; Study Session Conditions
		Function AddStudySessionConditions()
			AddHeaderOption("Study Session Conditions")
			AddToggleOptionST("StudyConditionsAllowOutdoor", "Allow Outdoor", dmSL_Config.GetStudyConditionsAllowOutdoor())
			AddToggleOptionST("StudyConditionsAllowTresspassing", "Allow While Tresspassing", dmSL_Config.GetStudyConditionsAllowTresspassing())
			AddToggleOptionST("StudyConditionsAllowSneaking", "Allow While Sneaking", dmSL_Config.GetStudyConditionsAllowSneaking())
			AddToggleOptionST("StudyConditionsLimitToSitting", "Limit To Sitting", dmSL_Config.GetStudyConditionsLimitToSitting())
			AddToggleOptionST("StudyConditionsAllowShelfStudying", "Allow Shelf Studying", dmSL_Config.GetStudyConditionsAllowShelfStudying())
		EndFunction
		State StudyConditionsAllowOutdoor
			Event OnSetToggleValue(bool newValue)
				dmSL_Config.SetStudyConditionsAllowOutdoor(newValue)
				SetToggleOptionValueST(newValue)
			EndEvent
			Event OnSelectST()
				OnSetToggleValue(!dmSL_Config.GetStudyConditionsAllowOutdoor())
			EndEvent
			Event OnHighlightST()
				SetInfoTextWithDefaultToggle("If enabled, you can study outdoors.", dmSL_Config.GetDefaultStudyConditionsAllowOutdoor())
			EndEvent
			Event OnDefaultST()
				OnSetToggleValue(!dmSL_Config.GetDefaultStudyConditionsAllowOutdoor())
			EndEvent
		EndState
		State StudyConditionsAllowTresspassing
			Event OnSetToggleValue(bool newValue)
				dmSL_Config.SetStudyConditionsAllowTresspassing(newValue)
				SetToggleOptionValueST(newValue)
			EndEvent
			Event OnSelectST()
				OnSetToggleValue(!dmSL_Config.GetStudyConditionsAllowTresspassing())
			EndEvent
			Event OnHighlightST()
				SetInfoTextWithDefaultToggle("If enabled, you can study while tresspassing.", dmSL_Config.GetDefaultStudyConditionsAllowTresspassing())
			EndEvent
			Event OnDefaultST()
				OnSetToggleValue(!dmSL_Config.GetDefaultStudyConditionsAllowTresspassing())
			EndEvent
		EndState
		State StudyConditionsAllowSneaking
			Event OnSetToggleValue(bool newValue)
				dmSL_Config.SetStudyConditionsAllowSneaking(newValue)
				SetToggleOptionValueST(newValue)
			EndEvent
			Event OnSelectST()
				OnSetToggleValue(!dmSL_Config.GetStudyConditionsAllowSneaking())
			EndEvent
			Event OnHighlightST()
				SetInfoTextWithDefaultToggle("If enabled, You can study while sneaking.", dmSL_Config.GetDefaultStudyConditionsAllowSneaking())
			EndEvent
			Event OnDefaultST()
				OnSetToggleValue(!dmSL_Config.GetDefaultStudyConditionsAllowSneaking())
			EndEvent
		EndState
		State StudyConditionsLimitToSitting
			Event OnSetToggleValue(bool newValue)
				dmSL_Config.SetStudyConditionsLimitToSitting(newValue)
				SetToggleOptionValueST(newValue)
			EndEvent
			Event OnSelectST()
				OnSetToggleValue(!dmSL_Config.GetStudyConditionsLimitToSitting())
			EndEvent
			Event OnHighlightST()
				SetInfoTextWithDefaultToggle("If enabled, you can only study while sitting.", dmSL_Config.GetDefaultStudyConditionsLimitToSitting())
			EndEvent
			Event OnDefaultST()
				OnSetToggleValue(!dmSL_Config.GetDefaultStudyConditionsLimitToSitting())
			EndEvent
		EndState
		State StudyConditionsAllowShelfStudying
			Event OnSetToggleValue(bool newValue)
				dmSL_Config.SetStudyConditionsAllowShelfStudying(newValue)
				SetToggleOptionValueST(newValue)
			EndEvent
			Event OnSelectST()
				OnSetToggleValue(!dmSL_Config.GetStudyConditionsAllowShelfStudying())
			EndEvent
			Event OnHighlightST()
				string infoText = \
					"If enabled, you can study while reading from the book from other containers." + \
					"You can still study while reading from player's inventory"
				SetInfoTextWithDefaultToggle(infoText, dmSL_Config.GetDefaultStudyConditionsAllowShelfStudying())
			EndEvent
			Event OnDefaultST()
				OnSetToggleValue(!dmSL_Config.GetDefaultStudyConditionsAllowShelfStudying())
			EndEvent
		EndState
; Page 2: Progress Status
	Function SetupPage_StudyProgress()
		int count = StateRef.ProgressState_KeyCount()
		AddHeaderOption("Progress Report (" + count + ")")
		AddHeaderOption("")
		Spell spellLearned = StateRef.ProgressSate_FirstKey()
		While (spellLearned)
			float progress = StateRef.ProgressState_GetProgress(spellLearned)
			string progressString = dmSL_Utils.FloatToPercentage(progress)
			AddTextOption(spellLearned.GetName(), progressString, OPTION_FLAG_DISABLED)
			spellLearned = StateRef.ProgressState_NextKey(spellLearned)
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
			SetInfoTextWithDefaultInt("Set page size [10 - 100]", 20)
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
			SetInfoTextWithDefaultInt("Select page", 1)
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
			string infoText = \
				"Filter by spell's school.\n" + \
				"Note: If a spell have multiple magic effects and only of them match the spell will be included in the list."
			SetInfoTextWithDefaultString(infoText, schoolFilterOptions[0])
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
			SetInfoTextWithDefaultString("Filter by known spells.", knownSpellsFilterOptions[0])
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
	Function SetInfoTextWithDefaultString(string info, string defaultVal)
		SetInfoText(info + "\n(Default: " + defaultVal + ")")
	EndFunction
	Function SetInfoTextWithDefaultFloat(string info, float defaultVal)
		SetInfoTextWithDefaultString(info, dmSL_Utils.FloatToString(defaultVal))
	EndFunction
	Function SetInfoTextWithDefaultInt(string info, int defaultVal)
		SetInfoTextWithDefaultString(info, defaultVal)
	EndFunction
	Function SetInfoTextWithDefaultToggle(string info, bool defaultVal)
		If (defaultVal)
			SetInfoTextWithDefaultString(info, "Enabled")
		Else
			SetInfoTextWithDefaultString(info, "Disabled")
		EndIf
	EndFunction

	Event OnSetToggleValue(bool newValue)
	EndEvent