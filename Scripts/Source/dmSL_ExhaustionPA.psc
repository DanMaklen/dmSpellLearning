Scriptname dmSL_ExhaustionPA extends dm_BasePlayerAttribute

Spell Property dmSL_ExhaustionDebuff Auto
Actor Property PlayerRef Auto

Function SetValue(float val)
    parent.SetValue(CorrectedValue(val))
EndFunction

; [[WARNING]] Might not be thread safe!!
Function Mod(float val)
    SetValue(GetValue() + val)
EndFunction

Event OnValueChanged(float newVal)
    If (newVal < 20)
        PlayerRef.RemoveSpell(dmSL_ExhaustionDebuff)
    Else
        PlayerRef.AddSpell(dmSL_ExhaustionDebuff, false)
    EndIf
    Debug.Notification("Study Exhaustion: " + dm_Utils.FloatToString(newVal))
EndEvent

float Function CorrectedValue(float val)
    return PapyrusUtil.ClampFloat(val, 0.0, 100.0)
EndFunction