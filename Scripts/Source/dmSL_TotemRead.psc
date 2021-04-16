scriptname dmSL_TotemRead extends ObjectReference

Spell Property SpellLearned Auto

event OnRead()
	int learnProgress = dmSL_SpellLearning.LearnSpell(SpellLearned)
	
	float progress = JMap.getFlt(learnProgress, ".progress")
	float increase = JMap.getFlt(learnProgress, ".increase")
	Debug.Notification("Learning Spell2: " + spellLearned.GetName() + ". Progress: " + progress as int + "% (+" + increase as int + "%)")
endEvent