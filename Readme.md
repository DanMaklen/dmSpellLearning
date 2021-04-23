# [DM] Spell Learning
This is a Skyrim Mod. It's a personal take on how I invision learning new spells should have been.

## Features
- Learn spells gradually through study sessions
- Almost all variables are configurable in the MCM
- MCM Checklist for learning all spells (wil Spell Tome) in the game
- No compatbility patch required for mods adding new spell tomes
- Does not touch any spell tome or spell records. So should be compatible with any mods that alter those records.

## Mechanics
### Study Session
If you have a book, you can study it. Go have a sit somewhere and start a study session.
- For immersion, you cannot study in various conditions like combat.
- The effeciency of the study session scales with the complexity of the spell and your profiecency in it's school.
- You can study multiple spells in parralel, but only one per study session.
- There is a cooldown between sessions. (min 1 hour, max. 48 hours)

### Exhaustion
If you have just finished a study session, you must rest a bit.
- The exhaustion parameter scales with:
  - *Session duration*: Longer sessions leads to more exhaustion.
  - *Spell complexity*: More complex spells leads to more exhaustion.
  - *School Proficency*: More proficency in the spell's school leads to less exhaustion.
- Sleeping reduces portion of the accumlated exhaustion.

## Ideas & Future Improvements
- Tome loss:
    - Learning in Water Chance
    - Random chance during study session
    - Scale with session duration
- Focus Mechanic:
    - More focus while sitting
    - More focus when rested
    - Less focus while riding horse
    - Focus Potions
    - Focus buff if learned a new spell recently
        - Scales with School Proficiency and Spell Complexity
    - Location Based Focus
        - Inns give slight focus boost
        - Player home give focus boost
        - College of winterhoold give major focus boost
        - Libraries give major focus boost
        - Loose focus in city outdoors
    - Loose focus with surrounding actor count
    - More focus during morning/night time (Configurable)
- Race Based Buff
- Perk Based Buff
- College of Winterhold Quest based Buffs