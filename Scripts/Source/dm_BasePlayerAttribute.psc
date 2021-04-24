ScriptName dm_BasePlayerAttribute extends ReferenceAlias
{Base script for attributes.}

GlobalVariable Property PAValue Auto

float Function GetValue()
    return PAValue.Value
EndFunction

Function SetValue(float val)
    PAValue.Value = val
    OnValueChanged(val)
EndFunction

Function Mod(float val)
    OnValueChanged(PAValue.Mod(val))
EndFunction

Event OnValueChanged(float newVal)
    Debug.Notification("NOOOOOO: " + newVal)
EndEvent