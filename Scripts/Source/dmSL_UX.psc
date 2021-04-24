Scriptname dmSL_UX extends ReferenceAlias
{Handles and UX elements like messages, prompt & animations}

Actor Property PlayerRef Auto
GlobalVariable Property GameHour auto

; UI Elements
ImageSpaceModifier Property FadeToBlackBackImod auto
ImageSpaceModifier Property FadeToBlackImod auto
ImageSpaceModifier Property FadeToBlackHoldImod auto

Idle Property IdleStop_Loose auto
Idle Property IdleBook_Reading auto
Idle Property IdleBook_TurnManyPages auto
Idle Property IdleBookSitting_Reading auto
Idle Property IdleBookSitting_TurnManyPages auto

Sound Property UISpellLearnedSound Auto
Message Property dmSL_StudySessionDurationPrompt Auto

; Message Notifications
Function NotifyStudySessionInProgress()
    Debug.Notification("A study session in please wait...")
EndFunction
Function NotifyLearnedNewSpell(Spell spellLearned)
    Debug.Notification("Learned spell: " + spellLearned.GetName() + ".")
    UISpellLearnedSound.Play(PlayerRef)
EndFunction
Function NotifyProgress(Spell spellLearned, float progress, float progressDelta)
    Debug.Notification("Learning spell: " + spellLearned.GetName() + ". Progress: " + dm_Utils.FloatToPercentage(progress) + " (+" + dm_Utils.FloatToPercentage(progressDelta) + ")")
EndFunction
Function NotifyCooldown(float remCooldown)
    Debug.Notification("Cannot study for the next " + dm_Utils.FloatToHours(remCooldown))
EndFunction

; Study Condition Not Met
    string Property ConditionNotMetReason_SpellKnown = "You already know this spell" Auto Hidden
    string Property ConditionNotMetReason_Tresspassing = "You are tresspassing" Auto Hidden
    string Property ConditionNotMetReason_Outdoor = "You are outdoors" Auto Hidden
    string Property ConditionNotMetReason_InCombat = "You are in combat" Auto Hidden
    string Property ConditionNotMetReason_Swimming = "You are swimming" Auto Hidden
    string Property ConditionNotMetReason_Sneaking = "You are sneaking" Auto Hidden
    string Property ConditionNotMetReason_NotSitting = "You are not sitting" Auto Hidden
    string Property ConditionNotMetReason_ShelfReading = "You are skimming" Auto Hidden
    Function NotifyStudyConditionNotMet(Spell spellLearned, string reason)
        Debug.Notification("Cannot study " + spellLearned.GetName() + ": " + reason + ".")
    EndFunction

; User Input
float Function ShowStudyDurationInputPrompt(float estimatedTimeToLearn)
    int btnHit = dmSL_StudySessionDurationPrompt.Show(Math.Ceiling(estimatedTimeToLearn))
    If (btnHit == 0)
        Return 0.0
    EndIf
    Return Math.pow(2, btnHit - 1)
EndFunction

; Animations
Function StartStudyAnimation()
    Game.DisablePlayerControls()

    Game.ForceThirdPerson()
	if (PlayerRef.IsWeaponDrawn())
		PlayerRef.SheatheWeapon()
		Utility.Wait(1.0)
	endif

    If (PlayerRef.GetSitState() >= 3)
        PlayerRef.PlayIdle(IdleBookSitting_Reading)
        Utility.Wait(2)
        PlayerRef.PlayIdle(IdleBookSitting_TurnManyPages)
    Else
        PlayerRef.PlayIdle(IdleBook_Reading)
        Utility.Wait(2)
        PlayerRef.PlayIdle(IdleBook_TurnManyPages)
    EndIf

    Utility.Wait(2)
    FadeToBlackImod.Apply()
    Utility.Wait(2)
    FadeToBlackHoldImod.Apply()
    Utility.Wait(1)
EndFunction
Function EndStudyAnimation()
    Utility.Wait(1)
    FadeToBlackBackImod.Apply()
    FadeToBlackHoldImod.Remove()
    Utility.Wait(2)
    PlayerRef.PlayIdle(IdleStop_Loose)
    Game.EnablePlayerControls()
EndFunction

; Misc
Function AdvanceGameTime(float duration)
    GameHour.Mod(duration)
EndFunction