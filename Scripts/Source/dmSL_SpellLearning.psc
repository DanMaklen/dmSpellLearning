Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

; Script Instance Injection
dmSL_State Property StateRef Auto
dmSL_UX Property UXRef Auto

; Auto Set Properties
Actor Property PlayerRef Auto

Auto State Idle
    Event OnBeginState()
        StateRef.StudySession_SetState(StateRef.StudySessionState_Idle)
        StateRef.StudySession_SetDuration(0.0)
        StateRef.StudySession_SetSpellLearned(none)
        StateRef.StudySession_SetSpellTome(none)
        StateRef.StudySession_SetSpellTomeContainer(none)
    EndEvent
    Event OnSpellTomeRead(Book spellTome, Spell spellLearned, ObjectReference spellTomeContainer)
        If (PlayerRef.HasSpell(spellLearned))
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_SpellKnown)
            return
        EndIf
        If (PlayerRef.IsSwimming())
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_Swimming)
            return
        EndIf
        If (PlayerRef.IsInCombat())
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_InCombat)
            return
        EndIf
        If (!dmSL_Config.GetStudyConditionsAllowTresspassing() && PlayerRef.IsTrespassing())
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_Tresspassing)
            return
        EndIf
        If (!dmSL_Config.GetStudyConditionsAllowOutdoor() && !PlayerRef.IsInInterior())
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_Outdoor)
            return
        EndIf
        If (!dmSL_Config.GetStudyConditionsAllowSneaking() && PlayerRef.IsSneaking())
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_Sneaking)
            return
        EndIf
        
        float sessionDuration = GetStudySessionDuration(spellLearned)
        If (sessionDuration <= 0.0)
            return  ; Cancle
        EndIf

        If (!spellTomeContainer)
            spellTomeContainer = PlayerRef
        EndIf

        StateRef.StudySession_SetSpellLearned(spellLearned)
        StateRef.StudySession_SetSpellTomeContainer(spellTomeContainer)
        StateRef.StudySession_SetSpellTome(spellTome)
        StateRef.StudySession_SetDuration(sessionDuration)
        GoToState("Studying")
    EndEvent
EndState

State Studying
    Event OnBeginState()
        StateRef.StudySession_SetState(StateRef.StudySessionState_Idle)
        UXRef.StartStudyAnimation()

        Spell spellLearned = StateRef.StudySession_GetSpellLearned()
        float sessionDuration = StateRef.StudySession_GetDuration()

        float progressDelta = CalculateLearnRate(spellLearned) * sessionDuration
        float progress = StateRef.ProgressState_GetProgress(spellLearned)
        progress = PapyrusUtil.ClampFloat(progress + progressDelta, 0.0, 1.0)
        StateRef.ProgressState_SetProgress(spellLearned, progress)
        
        UXRef.NotifyProgress(spellLearned, progress, progressDelta)
        UXRef.AdvanceGameTime(sessionDuration)

        If (progress >= 1.0)
            GoToState("LearnSpell")
        Else
            GoToState("Idle")
        EndIf
    EndEvent
    Event OnEndState()
        UXRef.EndStudyAnimation()
    EndEvent
EndState


State LearnSpell
    Event OnBeginState()
        Spell spellLearned = StateRef.StudySession_GetSpellLearned()
        Book spellTome = StateRef.StudySession_GetSpellTome()
        ObjectReference spellTomeContainer = StateRef.StudySession_GetSpellTomeContainer()

        PlayerRef.AddSpell(spellLearned, false)
        StateRef.ProgressState_RemoveSpellEntry(spellLearned)
        UXRef.NotifyLearnedNewSpell(spellLearned)

        If (dmSL_Config.GetConsumeTomeOnLearn())
            spellTomeContainer.RemoveItem(spellTome, 1, true)
        EndIf

        GoToState("Idle")
    EndEvent
EndState

; Calculations
float Function GetStudySessionDuration(Spell spellLearned)
    float learRate = CalculateLearnRate(spellLearned)
    float progress = StateRef.ProgressState_GetProgress(spellLearned)
    float estimatedTimeToLearn = (1.0 - progress) / learRate
    return UXRef.ShowStudyDurationInputPrompt(estimatedTimeToLearn)
EndFunction
float Function CalculateLearnRate(Spell spellLearned)
    return dmSL_Config.GetBaseLearnRate() * (1 + CalculateProficiencyModifier(spellLearned))
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
    return proficiencyMod
EndFunction
float Function CalculateSchoolProficiencyModifier(string School, int spellComplexity)
    return (PlayerRef.GetAV(school) - spellComplexity) / 100
EndFunction

; Setup
Function RegisterEvent()
    DEST_ReferenceAliasExt.RegisterForSpellTomeReadEvent(self)
EndFunction
Function UnregisterEvent()
    DEST_ReferenceAliasExt.UnregisterForSpellTomeReadEvent(self)
EndFunction

; Empty State
Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
    UXRef.NotifyStudySessionInProgress()
EndEvent