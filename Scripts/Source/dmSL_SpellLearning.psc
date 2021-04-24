Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

; Script Instance Injection
dmSL_State Property StateRef Auto
dmSL_UX Property UXRef Auto

; Player Attributes
dm_BasePlayerAttribute Property CooldownMult Auto
dm_BasePlayerAttribute Property Exhaustion Auto

; Auto Set Properties
Actor Property PlayerRef Auto

Auto State Idle
    Event OnBeginState()
        StateRef.StudySession_SetState(StateRef.StudySessionState_Idle)
    EndEvent
    Event OnSpellTomeRead(Book spellTome, Spell spellLearned, ObjectReference spellTomeContainer)
        If (!spellTomeContainer)
            spellTomeContainer = PlayerRef
        EndIf

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
        If (!dmSL_Config.GetStudyConditionsAllowShelfStudying() && spellTomeContainer != PlayerRef)
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_ShelfReading)
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
        If (dmSL_Config.GetStudyConditionsLimitToSitting() && PlayerRef.GetSitState() != 3)
            UXRef.NotifyStudyConditionNotMet(spellLearned, UXRef.ConditionNotMetReason_NotSitting)
            return
        EndIf
        
        float sessionDuration = GetStudySessionDuration(spellLearned)
        If (sessionDuration <= 0.0)
            return  ; Cancle
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
        StateRef.StudySession_SetState(StateRef.StudySessionState_Studying)
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
            GoToState("Cooldown")
        EndIf
    EndEvent
    Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
        UXRef.NotifyStudySessionInProgress()
    EndEvent
    Event OnEndState()
        UXRef.EndStudyAnimation()
        Spell spellLearned = StateRef.StudySession_GetSpellLearned()
        float sessionDuration = StateRef.StudySession_GetDuration()

        float proficiency = CalculateSpellProficiency(spellLearned)
        float exhaustionIncrease = sessionDuration * dmSL_Config.GetExhaustionBaseFactor() * (1 + proficiency)
        Exhaustion.Mod(exhaustionIncrease)

        float spellTomeLossProbability = dmSL_Config.GetSpellTomeLossRate() * sessionDuration
        float randomNumber = Utility.RandomFloat()

        If (randomNumber < spellTomeLossProbability)
            RemoveSpellTome()
            StateRef.StudySession_SetDidLoseSpellTome(true)
        EndIf
    EndEvent
EndState

State LearnSpell
    Event OnBeginState()
        StateRef.StudySession_SetState(StateRef.StudySessionState_LearnSpell)

        Spell spellLearned = StateRef.StudySession_GetSpellLearned()
        bool didLoseSpellTome = StateRef.StudySession_GetDidLoseSpellTome()

        PlayerRef.AddSpell(spellLearned, false)
        StateRef.ProgressState_RemoveSpellEntry(spellLearned)
        UXRef.NotifyLearnedNewSpell(spellLearned)

        If (!didLoseSpellTome && dmSL_Config.GetSpellTomeLossOnLearn())
            RemoveSpellTome()
        EndIf

        GoToState("Cooldown")
    EndEvent
    Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
        UXRef.NotifyStudySessionInProgress()
    EndEvent
EndState

State Cooldown
    Event OnBeginState()
        StateRef.StudySession_SetState(StateRef.StudySessionState_Cooldown)

        Spell spellLearned = StateRef.StudySession_GetSpellLearned()
        float sessionDuration = StateRef.StudySession_GetDuration()

        float cooldown = sessionDuration * dmSL_Config.GetCooldownBaseFactor() * CooldownMult.GetValue()
        cooldown = PapyrusUtil.ClampFloat(cooldown, 1.0, 48.0)
        StateRef.StudySession_SetCooldownEndAt(dm_Utils.GetGameTimeInHours() + cooldown)
        
        RegisterForSingleUpdateGameTime(cooldown)
    EndEvent
    Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
        float cooldownEndAt = StateRef.StudySession_GetCooldownEndAt()
        float remCooldown = dm_Utils.MaxFloat(0, cooldownEndAt - dm_Utils.GetGameTimeInHours())
        UXRef.NotifyCooldown(remCooldown)
    EndEvent
    Event OnUpdateGameTime()
        GoToState("Idle")
    EndEvent
EndState

; Sleep Events
float recovery
Event OnSleepStart(float startTime, float endTime)
    float sleepDuration = endTime - startTime
    recovery = sleepDuration * 24 * dmSL_Config.GetExhaustionSleepRecoveryRate()
EndEvent
Event OnSleepStop(bool isInterrupted)
    If (!isInterrupted)
        Exhaustion.Mod(-recovery)
    EndIf
    recovery = 0.0
EndEvent

; Spell Tome Loss
Function RemoveSpellTome()
    Book spellTome = StateRef.StudySession_GetSpellTome()
    ObjectReference spellTomeContainer = StateRef.StudySession_GetSpellTomeContainer()
    spellTomeContainer.RemoveItem(spellTome, 1)
EndFunction

; Calculations
float Function GetStudySessionDuration(Spell spellLearned)
    float learRate = CalculateLearnRate(spellLearned)
    float progress = StateRef.ProgressState_GetProgress(spellLearned)
    float estimatedTimeToLearn = (1.0 - progress) / learRate
    return UXRef.ShowStudyDurationInputPrompt(estimatedTimeToLearn)
EndFunction
float Function CalculateLearnRate(Spell spellLearned)
    return dmSL_Config.GetBaseLearnRate() * (1 + CalculateSpellProficiency(spellLearned))
EndFunction
float Function CalculateSpellProficiency(Spell spellLearned)
    float proficiencyMod = 0.0
    MagicEffect[] effectList = spellLearned.GetMagicEffects()
    int i = 0
    While (i < effectList.Length)
        proficiencyMod += CalculateMagicEffectProficiency(effectList[i]) / effectList.Length
        i += 1
    EndWhile
    return proficiencyMod
EndFunction
float Function CalculateMagicEffectProficiency(MagicEffect effect)
    return (PlayerRef.GetAV(effect.GetAssociatedSkill()) - effect.GetSkillLevel()) / 100
EndFunction

; Setup
Function RegisterEvent()
    DEST_ReferenceAliasExt.RegisterForSpellTomeReadEvent(self)
    RegisterForSleep()
EndFunction
Function UnregisterEvent()
    DEST_ReferenceAliasExt.UnregisterForSpellTomeReadEvent(self)
    UnregisterForUpdateGameTime()
    UnregisterForSleep()
EndFunction

; Empty State
Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
EndEvent
