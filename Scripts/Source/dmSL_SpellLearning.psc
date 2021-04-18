Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

; State
dmSL_State Property dmSL_StateRef Auto

; Global Variables
GlobalVariable Property dmSL_ConsumeBookOnLearn Auto
GlobalVariable Property dmSL_BaseLearnRate Auto

; Auto Set Properties
Sound Property UISpellLearnedSound Auto
Actor Property PlayerRef Auto
Message Property dmSL_StudySessionDurationPrompt Auto

Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
    If (PlayerRef.HasSpell(spellLearned))
        PrintAlreadyKnowSpell(spellLearned)
        dmSL_StateRef.SetProgress(spellLearned, 100.0) ; To detect spells learned before mod installation
        Return
    EndIf

    float sessionDuration = GetStudySessionDuration(spellLearned)
    If (sessionDuration <= 0.0)
        Return  ; Cancle
    EndIf

    bool isStudyCompleted = StudyFor(spellLearned, sessionDuration)

    If (isStudyCompleted && dmSL_ConsumeBookOnLearn.GetValue())
        ConsumeSpellBook(spellBook, bookContainer)
    EndIf
EndEvent

; UI
Function PrintAlreadyKnowSpell(Spell spellLearned)
    Debug.Notification("Known spell: " + spellLearned.GetName() + ".")
EndFunction
Function PrintLearnedNewSpell(Spell spellLearned)
    Debug.Notification("Learned spell: " + spellLearned.GetName() + ".")
EndFunction
Function PrintProgress(Spell spellLearned, float progress, float progressDelta)
    Debug.Notification("Learning spell: " + spellLearned.GetName() + ". Progress: " + progress as int + "% (+" + progressDelta as int + "%)")
EndFunction
float Function GetStudyDurationInput(float estimatedTimeToLearn)
    int btnHit = dmSL_StudySessionDurationPrompt.Show(estimatedTimeToLearn)
    If (btnHit == 0)
        Return 0.0
    EndIf
    Return Math.pow(2, btnHit - 1)
EndFunction

; Logic
bool Function StudyFor(Spell spellLearned, float sessionDuration)
    float progressDelta = CalculateLearnRate(spellLearned) * sessionDuration
    float progress = dmSL_StateRef.GetProgress(spellLearned)
    progress += progressDelta
    dmSL_StateRef.SetProgress(spellLearned, progress)
    If (progress >= 100.0)
        LearnSpell(spellLearned)
        Return true
    EndIf
    PrintProgress(spellLearned, progress, progressDelta)
    Return false
EndFunction
Function LearnSpell(Spell spellLearned)
    PlayerRef.AddSpell(spellLearned, false)
    UISpellLearnedSound.Play(PlayerRef)
    PrintLearnedNewSpell(spellLearned)
EndFunction
Function ConsumeSpellBook(Book spellBook, ObjectReference bookContainer = none)
    If !bookContainer
        bookContainer = PlayerRef
    EndIf

    bookContainer.RemoveItem(spellBook, 1, true)
EndFunction
float Function GetStudySessionDuration(Spell spellLearned)
    float learRate = CalculateLearnRate(spellLearned)
    float progress = dmSL_StateRef.GetProgress(spellLearned)
    float estimatedTimeToLearn = (100 - progress) / learRate
    return GetStudyDurationInput(estimatedTimeToLearn)
EndFunction

; Progress Calculation
float Function CalculateLearnRate(Spell spellLearned)
    Return dmSL_BaseLearnRate.GetValue() * (1 + CalculateProficiencyModifier(spellLearned))
EndFunction
float Function CalculateProficiencyModifier(Spell spellLearned)
    float proficiencyMod = 0.0
    MagicEffect[] effectList = spellLearned.GetMagicEffects()
    int i = 0
    While (i < effectList.Length)
        MagicEffect effect = effectList[i]
        proficiencyMod += CalculateSchoolProficiencyModifier(effect.GetAssociatedSkill(), effect.GetSkillLevel()) / effectList.Length
        i += 1
    EndWhile
    Return proficiencyMod
    
EndFunction
float Function CalculateSchoolProficiencyModifier(string School, int spellComplexity)
    Return (PlayerRef.GetAV(school) - spellComplexity) / 100
EndFunction

; Setup
Function RegisterEvent()
    DEST_ReferenceAliasExt.RegisterForSpellTomeReadEvent(self)
EndFunction
Function UnregisterEvent()
    DEST_ReferenceAliasExt.UnregisterForSpellTomeReadEvent(self)
EndFunction