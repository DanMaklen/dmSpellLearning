Scriptname dmSL_Main extends ReferenceAlias
{Main script. Handles installation and uninstallation}

dmSL_State Property dmSL_StateRef Auto
dmSL_SpellLearning Property dmSL_SpellLearningRef Auto

Event OnInit()
EndEvent

Function Install()
    dmSL_StateRef.InitState()
    dmSL_SpellLearningRef.RegisterEvent()
    Debug.Notification("Installed [DM] Spell Learning Mod.")
EndFunction
Function Uninstall()
    dmSL_StateRef.DeleteState()
    dmSL_SpellLearningRef.UnregisterEvent()
    Debug.Notification("Uninstalled [DM] Spell Learning Mod.")
EndFunction