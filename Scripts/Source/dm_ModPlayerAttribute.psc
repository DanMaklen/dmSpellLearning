Scriptname dm_ModPlayerAttribute extends ActiveMagicEffect
{Generic script that enabled Magic Effects to modify Global Variables similar to Actor Value}

; Player attribute to be modified
dm_BasePlayerAttribute Property PlayerAttribute Auto

; Factor to be multiplied by the effect's magnitued before modifying the attribute
; Mainly used to normalized the display value to the internal attribute value
; e.g. Display value: 10% Internal Value: 0.1
; Another usage is for when the positive values means worse results.
; But with "Detrimental" will make the value negative
float Property MagFactor = 1.0 Auto

; Flag List
int EffectFlag_Hostile = 0x00000001
int EffectFlag_Recover = 0x00000002
int EffectFlag_Detrimental = 0x00000004
int EffectFlag_NoHitEvent = 0x00000010
int EffectFlag_DispelKeywords = 0x00000100
int EffectFlag_NoDuration = 0x00000200
int EffectFlag_NoMagnitude = 0x00000400
int EffectFlag_NoArea = 0x00000800
int EffectFlag_FXPersist = 0x00001000
int EffectFlag_GloryVisuals = 0x00004000
int EffectFlag_HideInUI = 0x00008000
int EffectFlag_NoRecast = 0x00020000
int EffectFlag_Magnitude = 0x00200000
int EffectFlag_Duration = 0x00400000
int EffectFlag_Painless = 0x04000000
int EffectFlag_NoHitEffect = 0x08000000
int EffectFlag_NoDeathDispel = 0x10000000

MagicEffect baseEffect
float mag
bool isRecover

Event OnEffectStart(Actor target, Actor caster)
    GetEffectData()
    PlayerAttribute.Mod(Mag())
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    If (isRecover)
        PlayerAttribute.Mod(-Mag())
    EndIf
EndEvent

float Function Mag()
    return mag * MagFactor
EndFunction

Function GetEffectData()
    baseEffect = GetBaseObject()
    mag = GetMagnitude()
    isRecover = baseEffect.IsEffectFlagSet(EffectFlag_Recover)

    If (baseEffect.IsEffectFlagSet(EffectFlag_Detrimental))
        mag = -mag
    EndIf
EndFunction