Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

; State
dmSL_State Property dmSL_StateRef Auto

; Global Variables
GlobalVariable Property dmSL_ConsumeBookOnLearn Auto
GlobalVariable Property dmSL_BaseSessionProgress Auto

; Auto Set Properties
Sound Property UISpellLearnedSound Auto
Actor Property playerRef Auto

Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
    If (playerRef.HasSpell(spellLearned))
        PrintAlreadyKnowSpell(spellLearned)
        dmSL_StateRef.SetProgress(spellLearned, 100.0) ; To detect spells learned before mod installation
        Return
    EndIf

    bool isStudyCompleted = StudySpell(spellLearned)

    If (isStudyCompleted && dmSL_ConsumeBookOnLearn.GetValue())
        ConsumeSpellBook(spellBook, bookContainer)
    EndIf
EndEvent

; Notification Messages
Function PrintAlreadyKnowSpell(Spell spellLearned)
    Debug.Notification("Known spell: " + spellLearned.GetName() + ".")
EndFunction
Function PrintLearnedNewSpell(Spell spellLearned)
    Debug.Notification("Learned spell: " + spellLearned.GetName() + ".")
EndFunction
Function PrintProgress(Spell spellLearned, float progress, float sessionProgress)
    Debug.Notification("Learning spell: " + spellLearned.GetName() + ". Progress: " + progress as int + "% (+" + sessionProgress as int + "%)")
EndFunction

; Logic
bool Function StudySpell(Spell spellLearned)
    float sessionProgress = CalculateSessionProgress(spellLearned)
    float progress = dmSL_StateRef.GetProgress(spellLearned)
    progress += sessionProgress
    dmSL_StateRef.SetProgress(spellLearned, progress)
    If (progress >= 100.0)
        LearnSpell(spellLearned)
        Return true
    EndIf
    PrintProgress(spellLearned, progress, sessionProgress)
    Return false
EndFunction

Function LearnSpell(Spell spellLearned)
    playerRef.AddSpell(spellLearned, false)
    UISpellLearnedSound.Play(playerRef)
    PrintLearnedNewSpell(spellLearned)
EndFunction

Function ConsumeSpellBook(Book spellBook, ObjectReference bookContainer = none)
    If !bookContainer
        bookContainer = playerRef
    EndIf

    bookContainer.RemoveItem(spellBook, 1, true)
EndFunction

; Progress Calculation
float Function CalculateSessionProgress(Spell spellLearned)
    Return dmSL_BaseSessionProgress.GetValue() * (1 + CalculateProficiencyModifier(spellLearned))
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
    Return (playerRef.GetAV(school) - spellComplexity) / 100
EndFunction

; Setup
Function RegisterEvent()
    DEST_ReferenceAliasExt.RegisterForSpellTomeReadEvent(self)
EndFunction
Function UnregisterEvent()
    DEST_ReferenceAliasExt.UnregisterForSpellTomeReadEvent(self)
EndFunction