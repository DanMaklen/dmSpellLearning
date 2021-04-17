Scriptname dmSL_State hidden
{Handles the state of the mod}

float Function GetProgress(Spell spellLearned) global
    return JDB.solveFlt(JDBKey(".progress[__"+spellLearned+"]"), 0.0)
EndFunction
Function SetProgress(Spell spellLearned, float progress) global
    JDB.solveFltSetter(JDBKey(".progress["+spellLearned+"]"), progress, true)
EndFunction

string Function JDBKey(string relPath) global
    Return ".dmSL_JDBRoot" + relPath
EndFunction