Scriptname dmSL_State extends ReferenceAlias
{Handles the state of the mod}

int _stateContainer
int Property stateContainer Hidden
    int Function Get()
        Return _stateContainer
    EndFunction
    Function Set(int value)
        _stateContainer = JValue.releaseAndRetain(_stateContainer, value, "dmSL_SpellLearningState")
    EndFunction
EndProperty

int Function GetSpellEntry(Spell spellLearned)
    If (!JFormMap.hasKey(self.stateContainer, spellLearned))
        JFormMap.setObj(self.stateContainer, spellLearned, JMap.Object())
    EndIf
    JFormMap.getObj(self.stateContainer, spellLearned)
    Return JFormMap.getObj(self.stateContainer, spellLearned)
EndFunction
Function RemoveSpellEntry(Spell spellLearned)
    If(JFormMap.hasKey(self.stateContainer, spellLearned))
        JFormMap.removeKey(self.stateContainer, spellLearned)
    EndIf
EndFunction

float Function GetProgress(Spell spellLearned)
    Return JValue.solveFlt(GetSpellEntry(spellLearned), ".progress", 0.0)
EndFunction
Function SetProgress(Spell spellLearned, float progress)
    JValue.solveFltSetter(GetSpellEntry(spellLearned), ".progress", progress, true)
    Dump()
EndFunction

; Iterators
Spell Function FirstKey()
    return JFormMap.nextKey(self.stateContainer) as Spell
EndFunction
Spell Function NextKey(Spell previousKey)
    return JFormMap.nextKey(self.stateContainer, previousKey) as Spell
EndFunction

float Function Dump(string path = "Data/dmSL_StateDump.json")
    JValue.writeToFile(self.stateContainer, path)
EndFunction
Function InitState()
    self.stateContainer = JFormMap.object()
EndFunction
Function DeleteState()
    self.stateContainer = 0
EndFunction
