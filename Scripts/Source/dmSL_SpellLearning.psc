Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

; Script Instance Injection
dmSL_State Property StateRef Auto
dmSL_UX Property UXRef Auto

; Global Variables
GlobalVariable Property dmSL_ConsumeBookOnLearn Auto
GlobalVariable Property dmSL_BaseLearnRate Auto

; Auto Set Properties
Actor Property PlayerRef Auto

Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
    If (PlayerRef.HasSpell(spellLearned))
        UXRef.NotifyAlreadyKnowSpell(spellLearned)
        StateRef.SetProgress(spellLearned, 100.0) ; To detect spells learned before mod installation
        Return
    EndIf

    float sessionDuration = GetStudySessionDuration(spellLearned)
    If (sessionDuration <= 0.0)
        Return  ; Cancle
    EndIf

    bool isStudyCompleted = StudyFor(spellLearned, sessionDuration)

    If (isStudyCompleted)
        LearnSpell(spellLearned)
    EndIf

    If (isStudyCompleted && dmSL_ConsumeBookOnLearn.GetValue())
        ConsumeSpellBook(spellBook, bookContainer)
    EndIf
EndEvent

; Logic
bool Function StudyFor(Spell spellLearned, float sessionDuration)
    UXRef.StartStudyAnimation()
    float progressDelta = CalculateLearnRate(spellLearned) * sessionDuration
    float progress = StateRef.GetProgress(spellLearned)
    UXRef.AdvanceGameTime(sessionDuration)
    progress += progressDelta
    If (progress > 100.0)
        progress = 100.0
    EndIf
    StateRef.SetProgress(spellLearned, progress)
    UXRef.NotifyProgress(spellLearned, progress, progressDelta)
    UXRef.EndStudyAnimation()    
    Return progress >= 100.0
EndFunction
Function LearnSpell(Spell spellLearned)
    PlayerRef.AddSpell(spellLearned, false)
    UXRef.NotifyLearnedNewSpell(spellLearned)
EndFunction
Function ConsumeSpellBook(Book spellBook, ObjectReference bookContainer = none)
    If !bookContainer
        bookContainer = PlayerRef
    EndIf
    bookContainer.RemoveItem(spellBook, 1, true)
EndFunction

; Calculations
float Function GetStudySessionDuration(Spell spellLearned)
    float learRate = CalculateLearnRate(spellLearned)
    float progress = StateRef.GetProgress(spellLearned)
    float estimatedTimeToLearn = (100 - progress) / learRate
    return UXRef.ShowStudyDurationInputPrompt(estimatedTimeToLearn)
EndFunction
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