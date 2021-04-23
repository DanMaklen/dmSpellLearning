Scriptname dmSL_Config Hidden
{Central unit to handle all config}

; Study Session
    ; Base Learn Rate
        float Function GetDefaultBaseLearnRate() global
            return 0.10
        EndFunction
        float Function GetBaseLearnRate() global
            return GetFloatValue(".Config.BaseLearnRate", GetDefaultBaseLearnRate())
        EndFunction
        Function SetBaseLearnRate(float value) global
            SetFloatValue(".Config.BaseLearnRate", value)
        EndFunction
    ; Consume Tome on Learn
        bool Function GetDefaultConsumeTomeOnLearn() global
            return true
        EndFunction
        bool Function GetConsumeTomeOnLearn() global
            return GetBoolValue(".Config.ConsumeTomeOnLearn", GetDefaultConsumeTomeOnLearn())
        EndFunction
        Function SetConsumeTomeOnLearn(bool value) global
            SetBoolValue(".Config.ConsumeTomeOnLearn", value)
        EndFunction
    ; Cooldown Base Factor
        float Function GetDefaultCooldownBaseFactor() global
            return 1.5
        EndFunction
        float Function GetCooldownBaseFactor() global
            return GetFloatValue(".Config.CooldownBaseFactor", GetDefaultCooldownBaseFactor())
        EndFunction
        Function SetCooldownBaseFactor(float value) global
            SetFloatValue(".Config.CooldownBaseFactor", value)
        EndFunction
; Study Session Conditions:
    ; Allow Outdoor
        bool Function GetDefaultStudyConditionsAllowOutdoor() global
            return false
        EndFunction
        bool Function GetStudyConditionsAllowOutdoor() global
            return GetBoolValue(".Config.StudyConditions.AllowOutdoor", GetDefaultStudyConditionsAllowOutdoor())
        EndFunction
        Function SetStudyConditionsAllowOutdoor(bool value) global
            SetBoolValue(".Config.StudyConditions.AllowOutdoor", value)
        EndFunction
    ; Allow Tresspassing
        bool Function GetDefaultStudyConditionsAllowTresspassing() global
            return false
        EndFunction
        bool Function GetStudyConditionsAllowTresspassing() global
            return GetBoolValue(".Config.StudyConditions.AllowTresspassing", GetDefaultStudyConditionsAllowTresspassing())
        EndFunction
        Function SetStudyConditionsAllowTresspassing(bool value) global
            SetBoolValue(".Config.StudyConditions.AllowTresspassing", value)
        EndFunction
    ; Allow Sneaking
        bool Function GetDefaultStudyConditionsAllowSneaking() global
            return true
        EndFunction
        bool Function GetStudyConditionsAllowSneaking() global
            return GetBoolValue(".Config.StudyConditions.AllowSneaking", GetDefaultStudyConditionsAllowSneaking())
        EndFunction
        Function SetStudyConditionsAllowSneaking(bool value) global
            SetBoolValue(".Config.StudyConditions.AllowSneaking", value)
        EndFunction
    ; LimitTo Sitting
        bool Function GetDefaultStudyConditionsLimitToSitting() global
            return true
        EndFunction
        bool Function GetStudyConditionsLimitToSitting() global
            return GetBoolValue(".Config.StudyConditions.LimitToSitting", GetDefaultStudyConditionsLimitToSitting())
        EndFunction
        Function SetStudyConditionsLimitToSitting(bool value) global
            SetBoolValue(".Config.StudyConditions.LimitToSitting", value)
        EndFunction
    ; Allow Shelf Studying
        bool Function GetDefaultStudyConditionsAllowShelfStudying() global
            return false
        EndFunction
        bool Function GetStudyConditionsAllowShelfStudying() global
            return GetBoolValue(".Config.StudyConditions.AllowShelfStudying", GetDefaultStudyConditionsAllowShelfStudying())
        EndFunction
        Function SetStudyConditionsAllowShelfStudying(bool value) global
            SetBoolValue(".Config.StudyConditions.AllowShelfStudying", value)
        EndFunction
; Exhaustion
    ; Exhaustion Base Factor
        float Function GetDefaultExhaustionBaseFactor() global
            return 2.5
        EndFunction
        float Function GetExhaustionBaseFactor() global
            return GetFloatValue(".Config.Exhaustion.BaseFactor", GetDefaultExhaustionBaseFactor())
        EndFunction
        Function SetExhaustionBaseFactor(float value) global
            SetFloatValue(".Config.Exhaustion.BaseFactor", value)
        EndFunction
    ; Sleep Recovery Rate
        float Function GetDefaultExhaustionSleepRecoveryRate() global
            return 2.5
        EndFunction
        float Function GetExhaustionSleepRecoveryRate() global
            return GetFloatValue(".Config.Exhaustion.SleepRecoveryRate", GetDefaultExhaustionSleepRecoveryRate())
        EndFunction
        Function SetExhaustionSleepRecoveryRate(float value) global
            SetFloatValue(".Config.Exhaustion.SleepRecoveryRate", value)
        EndFunction

; Utility
    ; Getters
        bool Function GetBoolValue(string path, bool default) global
            return JDB.solveInt(dmSL_JDBPrefix() + path, default as int) as bool
        EndFunction
        int Function GetIntValue(string path, int default) global
            return JDB.solveInt(dmSL_JDBPrefix() + path, default)
        EndFunction
        float Function GetFloatValue(string path, float default) global
            return JDB.solveFlt(dmSL_JDBPrefix() + path, default)
        EndFunction
        string Function GetStringValue(string path, string default) global
            return JDB.solveStr(dmSL_JDBPrefix() + path, default)
        EndFunction
    ; Setters
        Function SetBoolValue(string path, bool value) global
            JDB.solveIntSetter(dmSL_JDBPrefix() + path, value as int, true)
        EndFunction
        Function SetIntValue(string path, int value) global
            JDB.solveIntSetter(dmSL_JDBPrefix() + path, value, true)
        EndFunction
        Function SetFloatValue(string path, float value) global
            JDB.solveFltSetter(dmSL_JDBPrefix() + path, value, true)
        EndFunction
        Function SetStringValue(string path, string value) global
            JDB.solveStrSetter(dmSL_JDBPrefix() + path, value, true)
        EndFunction

    string Function dmSL_JDBPrefix() global
        return ".dmSL"
    EndFunction