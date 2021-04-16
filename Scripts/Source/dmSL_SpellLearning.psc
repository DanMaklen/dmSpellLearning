Scriptname dmSL_SpellLearning extends ReferenceAlias
{Core Script that handles Spell Learning}

import DEST_ReferenceAliasExt

Sound Property UISpellLearnedSound Auto
Message Property dmSL_AlreadyLearnedSpellMessage Auto

Actor playerRef

Event OnInit()
    playerRef = Game.GetPlayer()
    RegisterForSpellTomeReadEvent(self)
    Debug.Notification("[DM] Spell Learning is initialized")
EndEvent

Event OnSpellTomeRead(Book spellBook, Spell spellLearned, ObjectReference bookContainer)
    Debug.Notification("[DM] Reading Spell Tome: (Book: " + spellBook.GetName() + ", Spell: " + spellLearned.GetName() + ", container: " + bookContainer.GetFormId() + ")")
    If (playerRef.HasSpell(spellLearned))
        Debug.Notification("Y")
        return
    EndIf
    
    UISpellLearnedSound.Play(playerRef)
    ; if dmSL_GVS_Consume
    ;     consumeSpellBook(spellBook, bookContainer)
    ; endif

    ; if !playerRef.HasSpell(akSpell)
	; 	;/ Don't eat the book
	; 	if akContainer
	; 		akContainer.RemoveItem(akBook, 1, abSilent = true)
	; 	else
	; 		playerRef.RemoveItem(akBook, 1, abSilent = true)
	; 	endif
	; 	/;

	; 	string sSpellAdded = Game.GetGameSettingString("sSpellAdded")
	; 	string sText = sSpellAdded + ": " + akSpell.GetName()
	; 	playerRef.AddSpell(akSpell, abVerbose = false)

	; 	Notification(sText, "UISpellLearned")
	; else
	; 	string sAlreadyKnown = Game.GetGameSettingString("sAlreadyKnown")
	; 	string sText = sAlreadyKnown + " " + akSpell.GetName()

	; 	Notification(sText)
	; endif
endevent

; event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
;     if(akBaseObject.HasKeyword(VendorItemSpellTome))
;         Debug.Notification("Reading: " + akBaseObject.GetName())
;     endif
; endevent

Function consumeSpellBook(Book spellBook, ObjectReference bookContainer = none)
    if !bookContainer
        bookContainer = playerRef
    endif

    bookContainer.RemoveItem(spellBook, 1, false)
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