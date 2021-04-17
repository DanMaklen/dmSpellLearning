Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

Sound Property UISpellLearnedSound Auto
GlobalVariable Property dmSL_ConsumeBookOnLearn Auto

Actor playerRef

Event OnInit()
    playerRef = Game.GetPlayer()
    DEST_ReferenceAliasExt.RegisterForSpellTomeReadEvent(self)
    Debug.Notification("[DM] Spell Learning is initialized")
EndEvent

Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
    Debug.Notification("[DM] Reading Spell Tome: (Book: " + spellBook.GetName() + ", Spell: " + spellLearned.GetName() + ", container: " + bookContainer.GetFormId() + ")")

    If (playerRef.HasSpell(spellLearned))
        PrintAlreadyKnowSpell(spellLearned)
        Return
    EndIf
    
    LearnSpell(spellLearned)

    If (dmSL_ConsumeBookOnLearn)
        ConsumeSpellBook(spellBook, bookContainer)
    EndIf
EndEvent

Function PrintAlreadyKnowSpell(Spell spellLearned)
    Debug.Notification("Known spell: " + spellLearned.GetName() + ".")
EndFunction

Function PrintLearnedNewSpell(Spell spellLearned)
    Debug.Notification("Learned spell: " + spellLearned.GetName() + ".")
EndFunction

Function PrintProgress(Spell spellLearned, float progress, float sessionProgress)
    Debug.Notification("Learning spell: " + spellLearned.GetName() + ". Progress: " + progress as int + "% (+" + sessionProgress as int + "%)")
EndFunction

Function ConsumeSpellBook(Book spellBook, ObjectReference bookContainer = none)
    If !bookContainer
        bookContainer = playerRef
    EndIf

    bookContainer.RemoveItem(spellBook, 1, true)
EndFunction

Function LearnSpell(Spell spellLearned)
    playerRef.AddSpell(spellLearned, false)
    UISpellLearnedSound.Play(playerRef)
EndFunction


; int function LearnSpell(Spell spellLearned) global
;     float progress = JDB.solveFlt(JDBKey("progress"), 0.0)
;     float increase = CalculateRate(spellLearned)
;     progress = progress + increase
;     JDB.solveFltSetter(JDBKey("progress"), progress, true)
    
;     int ret = JMap.object()
;     JMap.setFlt(ret, ".progress", progress)
;     JMap.setFlt(ret, ".increase", increase)
;     return ret
; endfunction

; float function CalculateRate(Spell spellLearned) global
;     return 10.0
; endfunction

; string function JDBKey(string relPath) global
;     return ".dmSL_JDBRoot" + relPath
; endfunction