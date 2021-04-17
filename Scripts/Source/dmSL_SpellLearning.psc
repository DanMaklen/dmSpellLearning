Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

; Global Variables
GlobalVariable Property dmSL_ConsumeBookOnLearn Auto
GlobalVariable Property dmSL_BaseSessionProgress Auto

; Auto Set Properties
Sound Property UISpellLearnedSound Auto
Actor Property playerRef Auto

Event OnInit()
    DEST_ReferenceAliasExt.RegisterForSpellTomeReadEvent(self)
EndEvent

Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
    If (playerRef.HasSpell(spellLearned))
        PrintAlreadyKnowSpell(spellLearned)
        Return
    EndIf
    
    If (StudySpell(spellLearned))
        LearnSpell(spellLearned)

        If (dmSL_ConsumeBookOnLearn.GetValue())
            ConsumeSpellBook(spellBook, bookContainer)
        EndIf
    EndIf

    JDB.writeToFile("HelloJDB")
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
    float progress = dmSL_State.GetProgress(spellLearned)
    progress += sessionProgress
    dmSL_State.SetProgress(spellLearned, progress)
    PrintProgress(spellLearned, progress, sessionProgress)
    return progress >= 100.0
EndFunction

Function LearnSpell(Spell spellLearned)
    playerRef.AddSpell(spellLearned, false)
    UISpellLearnedSound.Play(playerRef)
EndFunction

Function ConsumeSpellBook(Book spellBook, ObjectReference bookContainer = none)
    If !bookContainer
        bookContainer = playerRef
    EndIf

    bookContainer.RemoveItem(spellBook, 1, true)
EndFunction

; Progress Calculation
float Function CalculateSessionProgress(Spell spellLearned)
    float proficiencyMod = CalculateProficiencyModifier(spellLearned)
    Return dmSL_BaseSessionProgress.GetValue() * (1 + proficiencyMod)
EndFunction

float Function CalculateProficiencyModifier(Spell spellLearned)
    string school = none
    int maxEffectLevel = 0

    MagicEffect[] effectList = spellLearned.GetMagicEffects()
    int i = 0
    While (i < effectList.Length)
        MagicEffect effect = effectList[i]
        string effectSchool = effect.GetAssociatedSkill()
        int effectLevel = effect.GetSkillLevel()

        If (!school)
            school = effectSchool
        EndIf
        
        If (maxEffectLevel < effectLevel)
            maxEffectLevel = effectLevel
        EndIf
        i += 1
    EndWhile

    float schoolLevel = playerRef.GetAV(school)
    Return (schoolLevel - maxEffectLevel) / 100
EndFunction