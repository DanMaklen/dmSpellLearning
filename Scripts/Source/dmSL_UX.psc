Scriptname dmSL_UX extends ReferenceAlias
{Handles and UX elements like messages, prompt & animations}

Actor Property PlayerRef Auto

; UI Elements
Sound Property UISpellLearnedSound Auto
Message Property dmSL_StudySessionDurationPrompt Auto

Function NotifyAlreadyKnowSpell(Spell spellLearned)
    Debug.Notification("Known spell: " + spellLearned.GetName() + ".")
EndFunction

Function NotifyLearnedNewSpell(Spell spellLearned)
    Debug.Notification("Learned spell: " + spellLearned.GetName() + ".")
    UISpellLearnedSound.Play(PlayerRef)
EndFunction

Function NotifyProgress(Spell spellLearned, float progress, float progressDelta)
    Debug.Notification("Learning spell: " + spellLearned.GetName() + ". Progress: " + progress as int + "% (+" + progressDelta as int + "%)")
EndFunction

float Function ShowStudyDurationInputPrompt(float estimatedTimeToLearn)
    int btnHit = dmSL_StudySessionDurationPrompt.Show(estimatedTimeToLearn)
    If (btnHit == 0)
        Return 0.0
    EndIf
    Return Math.pow(2, btnHit - 1)
EndFunction