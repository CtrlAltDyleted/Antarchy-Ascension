# Antarchy - Ascension Changelog

## Alpha 1.0

### 2026-09-14

#### Added

- Added Better Tooltips and Better Advanced Tooltips
- Added Gallery
- Added Logistics Networks
- Added No See No Tick
- Added KubeJS Studio and MezzConfig
- Added the "Chapter 1: Introduction" FTB Quests chapter group

#### Fixed

- Fixed Engineer's Goggles also appearing in the generic Curios Head slot
- Fixed the duplicate Create and Immersive Engineering steel plate pressing recipe
- Fixed Better Lib's malformed English language resource
- Fixed the stale Expanded AE JEI blacklist entry

#### Changed

- Changed 84 existing mod versions to their current installed versions
- Changed the Time in a Bottle recipe to use the GAG Time Sand Pouch
- Changed the FancyMenu title, pause, and universal menu layouts
- Changed Antarchy KubeJS scripts into consolidated recipe, tag, recipe-viewer, and tooltip scripts
- Changed JEI configuration to the current MezzConfig-backed layout

#### Removed

- Removed KubeJS Tweaks
- Removed the old one-purpose Antarchy KubeJS scripts after consolidation
- Removed the obsolete ByePregen configuration
- Removed the old FancyMenu options screen layout

### 2026-08-30

#### Added

- Added targeted Log Begone filters for recurring harmless warnings from installed mods
- Added JEI blacklist cleanup through Antarchy - Ascension Companion

#### Fixed

- Fixed remaining broken blockstates, models, textures, language files, recipes, loot tables, tags, and worldgen data
- Fixed Regions Unexplored invalid oak revival trades
- Fixed Actually Additions Engineer's Goggles using incorrect Curios item IDs
- Fixed Evolved Mekanism silver resources
- Fixed remaining references to removed materials and content

#### Changed

- Updated Antarchy - Ascension Companion to Alpha 0.1.0
- Updated JEI to 19.51.0.417
- Finalized the six OpenLoader fix packs for data, loot tables, recipes, resources, tags, and worldgen
- Cleaned obsolete OpenLoader overrides and stale compatibility files
- Completed final Alpha log cleanup and launch validation
- Finalized the Alpha mod manifest at 598 active mod JARs

#### Removed

- Removed the experimental Companion working-set trim and its client config
- Removed stale configs from mods that are no longer installed
- Removed obsolete Patchouli overrides
- Removed obsolete FTB face resource workarounds
- Removed obsolete BetterLib language overrides
- Removed unused Design n' Decor sound overrides
- Removed JEI Optimizer
- Removed Saturn
- Removed ByePregen
- Removed Advanced Peripherals
- Removed CC:Tweaked
- Removed Classic Peripherals
- Removed DecoCraft and DecoCraft Nature
- Removed Mahou Tsukai and Mahou Tsukai Combat
- Removed Nether Wart Block

### 2026-08-22

#### Added

- Added validated OpenLoader fixes for Sawmill, Expanded Combat, Dye The World, Stella Arcanum, and additional loot tables
- Added Configured Defaults source tracking for the Modern Lucky Block addon

#### Fixed

- Fixed the Advanced Memory Card guide page
- Fixed Advanced Peripherals AE disk cell models
- Fixed unwanted Evolved Mekanism processing recipes for uranium ore variants that do not generate in the pack

#### Changed

- Updated the manifest and changelog tools to use PowerShell 7
- Improved manifest comparison and mod change detection
- Disabled unnecessary update checks, analytics, profiling, and debug behavior where appropriate
- Consolidated the old one-purpose OpenLoader packs into six organized Antarchy - Ascension fix packs

### 2026-08-20

#### Fixed

- Fixed the ME Gearbox GUI overlap
- Fixed FancyMenu scaling on the options and pause screens

#### Changed

- Enabled the Above the Clouds enchantment for Create Stuff 'N Additions jetpacks
- Updated mods, configs, and Antarchy - Ascension Companion

### 2026-08-19

#### Added

- Added Omnitools
- Added Companion-driven Curios support for jetpacks and tanks

#### Fixed

- Fixed the Accessories inventory button overlapping the Apothic Attributes button
- Fixed broken recipes, loot tables, and tags found during material cleanup

#### Changed

- Moved Minecraft to the front of JEI
- Finished the main material and ore cleanup pass
- Cleaned repository filenames

#### Removed

- Removed Create SA Curios Jetpacks after the Companion added dedicated Jetpack and Tank slots

### 2026-08-18

#### Added

- Added Dense Uranium through Antarchy - Ascension Companion
- Added Antarchy Broodstone Uranium as the Cavaryn uranium source

#### Fixed

- Fixed pause menu scaling

#### Changed

- Unified normal uranium progression around AllTheOres Uranium
- Unified titanium progression around Antarchy Titanium
- Changed Extreme Reactors to use Uranium instead of solid Yellorium items
- Changed Almost Unified and Cucumber to prefer Antarchy Titanium
- Sorted JEI mods alphabetically
- Cleaned JEI ingredients and recipe categories
- Changed fluid tank display so JEI only shows useful empty variants
- Hid removed Uranium, Titanium, and Yellorite content from JEI

#### Removed

- Removed Marvel Titanium from progression
- Removed duplicate Uranium and Yellorite ore generation
- Removed solid Yellorium progression while keeping required Yellorium fluid support
- Removed unused AllTheOres alternate ore variants and material paths

### 2026-08-17

#### Added

- Expanded the active mod set from 428 to 575 mods with 153 additions
- Added major new technology, magic, exploration, dimension, utility, compatibility, and performance mods
- Added Compact Machines room templates, recipes, advancements, localization, and datapack fixes
- Added KubeJS Compact Machines tooltips
- Added Drippy Loading Screen
- Added the initial Log Begone configuration
- Added Almost Unified configuration with AllTheOres preferred for common materials

#### Changed

- Replaced Stellaris and Perspatium with the unofficial Ad Astra 1.21.1 port and Ad Astra: Giselle Addon for development
- Replaced Polymorph with Polymorph Plus
- Increased Explorer's Compass and Nature's Compass search limits
- Removed biome entries from JEI Ores
- Disabled Aether random trivia and Better Lib loading tips
- Updated Antarchy - Ascension Companion to its development 0.1.1 build
- Refreshed generated registry, JEI, Jade, Apotheosis, Sophisticated Core, and Sound Physics data
- Moved repository helper BAT files into the tools folder
- Updated the mod manifest for the 575-mod baseline

#### Removed

- Removed obsolete Iris/Flywheel compatibility
- Removed third-party OpenLoader ZIPs from repository tracking

### 2026-08-14

#### Added

- Added custom FancyMenu backgrounds to additional menus and first-load screens

#### Fixed

- Fixed title screen scaling at higher GUI scales

#### Changed

- Continued refining the Antarchy - Ascension menus and loading screens
- Updated mods and configs

### 2026-08-13

#### Added

- Expanded the Alpha 1.0 mod set to 428 active mods
- Added Twilight Forest and its integrations
- Added Iron's Spells 'n Spellbooks and its integrations
- Added Better Combat and Expanded Combat
- Added End Remastered with all 16 End Eyes enabled
- Added Gobber and Gobber Delight
- Added Aquaculture and Aquaculture Delight
- Added Refurbished Furniture
- Added Incendium and additional Nether and End structures
- Added Overlapless
- Added Prefab, Ambient Sounds, Chef's Delight, Followers Teleport Too, JEI Ores, and other supporting mods
- Added AttributeFix definitions for Expanded Combat, Iron's Lib, Iron's Spells, and Twilight Forest
- Added Alpha and Beta release expectations to the README
- Added permanent `MOD_CHANGELOG.md` tracking

#### Fixed

- Improved mod manifest version detection
- Improved added, removed, and updated mod reporting

#### Changed

- Updated JEI ordering and recipe categories for the expanded mod set
- Updated Jade integration for Twilight Forest
- Updated Apotheosis enchantment configuration
- Updated Relics, Crash Assistant, and Supplementaries configs
- Replaced the previous Morph mod with CraisinLord's Morph
- Replaced the old Morph server config with the current Morph config
- Reduced Faster Climbing speed from 2.0x to 1.5x
- Changed SecurityCraft reinforced block tinting to owned blocks only
- Disabled Quark's Q button
- Disabled Aether starting loot and Patreon messages
- Updated the mod manifest for the 428-mod Alpha baseline
- Reworked `.gitignore` for generated and local runtime files

#### Removed

- Removed C2ME after worldgen compatibility problems
- Removed Deeper and Darker
- Removed Dungeons and Villages: Deeper and Darker
- Removed JEI Worldgen
- Removed Resonant Synthesis
- Removed Morph Extended
- Removed stale configs from removed mods

### 2026-08-12

#### Added

- Added configs for newly installed mods
- Added `MOD_MANIFEST.csv`
- Added the PowerShell mod manifest updater

#### Changed

- Reduced unnecessary startup messages
- Updated Xaero's Minimap and HUD configuration

#### Removed

- Removed stale configs from removed mods

### 2026-08-11

#### Added

- Created the Antarchy - Ascension repository
- Added the initial NeoForge 1.21.1 modpack configuration
- Added configs for more than 200 mods
- Added FTB Quests, KubeJS, and default server configs
- Added the README, license, `.gitignore`, and `.gitattributes`
