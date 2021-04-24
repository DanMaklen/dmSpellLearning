Scriptname dmSL_State extends ReferenceAlias
{Handles the state of the mod}

Function InitState()
    self.progressState = JFormMap.object()
    self.studySession = JMap.object()
EndFunction
Function DeleteState()
    self.progressState = 0
    self.studySession = 0
EndFunction

; Progress State
    int _progressStateContainer
    int Property progressState Hidden
        int Function Get()
            return _progressStateContainer
        EndFunction
        Function Set(int value)
            _progressStateContainer = JValue.releaseAndRetain(_progressStateContainer, value, "dmSL_ProgressState")
        EndFunction
    EndProperty

    ; Getters & Setters
        int Function ProgressState_GetSpellEntry(Spell spellLearned)
            If (!JFormMap.hasKey(self.progressState, spellLearned))
                JFormMap.setObj(self.progressState, spellLearned, JMap.Object())
            EndIf
            JFormMap.getObj(self.progressState, spellLearned)
            return JFormMap.getObj(self.progressState, spellLearned)
        EndFunction
        Function ProgressState_RemoveSpellEntry(Spell spellLearned)
            If(JFormMap.hasKey(self.progressState, spellLearned))
                JFormMap.removeKey(self.progressState, spellLearned)
            EndIf
        EndFunction
        bool Function ProgressState_HasSpellEntry(Spell spellLearned)
            return JFormMap.hasKey(self.progressState, spellLearned)
        EndFunction

        float Function ProgressState_GetProgress(Spell spellLearned)
            If (!ProgressState_HasSpellEntry(spellLearned))
                return 0.0
            EndIf
            return JValue.solveFlt(ProgressState_GetSpellEntry(spellLearned), ".Progress", 0.0)
        EndFunction
        Function ProgressState_SetProgress(Spell spellLearned, float progress)
            JValue.solveFltSetter(ProgressState_GetSpellEntry(spellLearned), ".Progress", progress, true)
        EndFunction

    ; Iterators
        Spell Function ProgressSate_FirstKey()
            return JFormMap.nextKey(self.progressState) as Spell
        EndFunction
        Spell Function ProgressState_NextKey(Spell previousKey)
            return JFormMap.nextKey(self.progressState, previousKey) as Spell
        EndFunction
        int Function ProgressState_KeyCount()
            return JFormMap.count(self.progressState)
        EndFunction

; Study Session
    int _studySessionContainer
    int Property studySession Hidden
        int Function Get()
            return _studySessionContainer
        EndFunction
        Function Set(int value)
            _studySessionContainer = JValue.releaseAndRetain(_studySessionContainer, value, "dmSL_Session")
        EndFunction
    EndProperty

    ; Study Session State Enum
        int Property StudySessionState_Idle = 0 Auto Hidden
        int Property StudySessionState_Studying = 1 Auto Hidden
        int Property StudySessionState_LearnSpell = 2 Auto Hidden
        int Property StudySessionState_Cooldown = 3 Auto Hidden

    ; Getters & Setters
        int Function StudySession_GetState()
            return JValue.solveInt(self.studySession, ".State", StudySessionState_Idle)
        EndFunction
        Function StudySession_SetState(int sessionState)
            JValue.solveIntSetter(self.studySession, ".State", sessionState, true)
        EndFunction

        Spell Function StudySession_GetSpellLearned()
            return JValue.solveForm(self.studySession, ".SpellLearned", none) as Spell
        EndFunction
        Function StudySession_SetSpellLearned(Spell spellLearned)
            JValue.solveFormSetter(self.studySession, ".SpellLearned", spellLearned, true)
        EndFunction

        Book Function StudySession_GetSpellTome()
            return JValue.solveForm(self.studySession, ".SpellTome", none) as Book
        EndFunction
        Function StudySession_SetSpellTome(Book spellTome)
            JValue.solveFormSetter(self.studySession, ".SpellTome", spellTome, true)
        EndFunction

        ObjectReference Function StudySession_GetSpellTomeContainer()
            return JValue.solveForm(self.studySession, ".SpellTomeContainer", none) as ObjectReference
        EndFunction
        Function StudySession_SetSpellTomeContainer(ObjectReference spellTomeContainer)
            JValue.solveFormSetter(self.studySession, ".SpellTomeContainer", spellTomeContainer, true)
        EndFunction

        float Function StudySession_GetDuration()
            return JValue.solveFlt(self.studySession, ".Duration", 0.0)
        EndFunction
        Function StudySession_SetDuration(float duration)
            JValue.solveFltSetter(self.studySession, ".Duration", duration, true)
        EndFunction

        float Function StudySession_GetCooldownEndAt()
            return JValue.solveFlt(self.studySession, ".CooldownEndAt", 0.0)
        EndFunction
        Function StudySession_SetCooldownEndAt(float cooldownEndAt)
            JValue.solveFltSetter(self.studySession, ".CooldownEndAt", cooldownEndAt, true)
        EndFunction

        bool Function StudySession_GetDidLoseSpellTome()
            return JValue.solveInt(self.studySession, ".DidLoseSpellTome", false as int) as bool
        EndFunction
        Function StudySession_SetDidLoseSpellTome(bool didLoseSpellTome)
            JValue.solveIntSetter(self.studySession, ".DidLoseSpellTome", didLoseSpellTome as int, true)
        EndFunction