# [DM] Spell Learning
This is a Skyrim Mod. It's a personal take on how I envision learning new spells should have been.
This mod is similar to [Better Spell Learning](https://www.nexusmods.com/skyrimspecialedition/mods/4924) and [Immersive Spell Learning](https://www.nexusmods.com/skyrimspecialedition/mods/33375). Actually it is inspired a lot by them. However, I still felt like it is lacking something. So I set out to create my own mod with how I have imagined studying spells should be in Skyrim.

## Mechanics
### Study Session
If you have a book, you can study it. Go have a seat somewhere and start a study session.
- For immersion, you cannot study in various conditions like combat.
- The efficiency of the study session scales with the complexity of the spell and your proficiency in it's school.
- You can study multiple spells in parallel, but only one per study session.
- There is a cooldown between sessions. (min 1 hour, max. 48 hours)

### Spell Tome Loss
While studying, you may over use the spell tome. Torn out pages, spill drinks on others, ... The spell tome may be unusable anymore!
- A chance to lose the the spell tome after studying.
  - The chance increases for longer study sessions.
- After learning everything the spell tome has to offer you may decide to throw it away.

### Exhaustion
If you have just finished a study session, you must rest a bit.
- The exhaustion parameter scales with:
  - *Session duration*: Longer sessions leads to more exhaustion.
  - *Spell complexity*: More complex spells leads to more exhaustion.
  - *School Proficiency*: More proficiency in the spell's school leads to less exhaustion.
- Sleeping reduces portion of the accumulated exhaustion.
- Increased exhaustion can give various debuffs:
  - Increase study cooldown.
  - Decrease focus

### Focus
Some times you are more focused than others. If you are more focused you study the spell more efficiently.
- Your focus may slightly increase or decrease randomly.
- You focus better while sitting.
- You focus better when you are rested.
- You focus better if you learned a new spell recently
- You focus less if there are a lot of people around you.
- You focus less if you are studying multiple spells in parallel.
- You focus better if you focus your study on few spells.
- Your focus is affected by where you study:
  - Some locations give various amounts of boosts to your focus. Classified under 3 tiered (lesser, minor and major).
  - Some locations give various amounts of debuff to your focus. Classified under 3 tiered (lesser, minor and major).
  - Inns count as lesser boost locations.
  - Player houses count as minor boost locations.
  - Hostile interiors count as major debuff locations.
- *Warning*! If you are too focused you get more exhausted.

## Compatibility
- No compatibility patch required for new spell tomes added by other mods mods
- Does not touch any spell tome or spell records. So should be compatible with any mods that alter those records.
- This mod uses various keywords to do calculate the modifiers. It shouldn't be much of an issue compatibility wise though.

## Dependencies
- [SKSE](https://skse.silverlock.org/)
- [SkyUI](https://www.nexusmods.com/skyrimspecialedition/mods/12604)
- [Don't Eat Spell Tomes](https://www.nexusmods.com/skyrimspecialedition/mods/43095)
- [JContainers SE](https://www.nexusmods.com/skyrimspecialedition/mods/16495)
- [powerofthree's Papyrus Extender](https://www.nexusmods.com/skyrimspecialedition/mods/22854)
- [PapyrusUtil SE](https://www.nexusmods.com/skyrimspecialedition/mods/13048)