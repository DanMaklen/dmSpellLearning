# [DM] Spell Learning
This is a Skyrim Mod. It's a personal take on how I invision learning new spells should have been.

## Features
- Learn spells gradually through study sessions
- Almost all variables are configurable in the MCM
- MCM Checklist for learning all spells (wil Spell Tome) in the game

## Mechanics
### Study Session
If you have a book, you can study it. Go have a seat somewhere and start a study session.
- For immersion, you cannot study in various conditions like combat.
- The effeciency of the study session scales with the complexity of the spell and your profiecency in it's school.
- You can study multiple spells in parralel, but only one per study session.
- There is a cooldown between sessions. (min 1 hour, max. 48 hours)

### Spell Tome Loss
While studying, you may over use the spell tome. Torn out pages, spill drinks on others, ... The spell tome may be unusable anymore!
- A chance to lose the the spell tome after studying.
  - The chance increase for longer study sessions.
- After learning everything the spell tome has to offer you may decide to throw it away.

### Exhaustion
If you have just finished a study session, you must rest a bit.
- The exhaustion parameter scales with:
  - *Session duration*: Longer sessions leads to more exhaustion.
  - *Spell complexity*: More complex spells leads to more exhaustion.
  - *School Proficency*: More proficency in the spell's school leads to less exhaustion.
- Sleeping reduces portion of the accumlated exhaustion.
- Increased exhausion can give various debuffs:
  - Increase study cooldown.
  - Decrease focus

### Focus
Some times you are more focused than others. If you are more focused you study the spell more effeciently.
- Your focus may slightly increase or decrease randomly.
- You focus better while sitting.
- You focus better when you are rested.
- You focus better if you learned a new spell recently
- You focus less if there are a lot of people around you.
- You focus less if you are studying multiple spells in parralel.
- You focus better if you focus your study on few spells.
- Your focus is affected by where you study:
  - Some locations give various amounts of boosts to your focus. Classified under 3 tierd (lesser, minor and major).
  - Some locations give various amounts of debuff to your focus. Classified under 3 tierd (lesser, minor and major).
  - Inns count as lesser boost location.
  - Player houses count as minor boost location.
- *Warning*! If you are too focused you get more exhausted.

- Focus Potions
- Where you study affects your focus:
    - Inns give slight focus boost
    - Player home give focus boost
    - College of winterhoold give major focus boost
    - Libraries give major focus boost
    - Loose focus in city outdoors

## Compatability
- No compatbility patch required for new spell tomes added by other mods mods
- Does not touch any spell tome or spell records. So should be compatible with any mods that alter those records.
- This mod uses various keywords to do calclate the modifiers. It shouldn't be much of an issue compatability wise though.

## Ideas & Future Improvements
- College of Winterhold Quest based Buffs