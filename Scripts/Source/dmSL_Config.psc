Scriptname dmSL_Config
{Central unit to handle all config}

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