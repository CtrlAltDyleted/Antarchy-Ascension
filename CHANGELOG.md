# Antarchy - Ascension Changelog

All notable changes are documented here. The format follows [Keep a Changelog 1.1.0](https://keepachangelog.com/en/1.1.0/); new versions use [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html). Historical release names are retained as published.

Ongoing **0.3.0-alpha** development is listed under Unreleased, not as a published release. Alpha world compatibility is not guaranteed.

Individual mod additions, removals, and version updates are tracked separately in [MOD_CHANGELOG.md](MOD_CHANGELOG.md).

## [Unreleased]

### Added

- Early progression quests covering survival, Create, exploration, and entry into the Nether.
- Connected Nether progression and early AE2 manufacturing.
- Post-Nether electronics recipes for the Basic Circuit Press and Calculation Microchip.
- Ixeris to address stuttering with high mouse polling rates.

### Changed

- **Progression change:** Early electrical generation now begins with Immersive Engineering's Kinetic Dynamo.
- **Progression change:** Reworked silica and silicon processing, keeping different mods' silicon separate.
- **Progression change:** Coke Dust manufacturing now uses only Immersive Engineering's Crusher.
- Questbook progression is flexible by default, allowing tasks to count before their quests become available.
- Dig Site seal rewards now come from two Lootr archaeology blocks instead of the legacy reward barrel.
- Burning Arena chest rewards now supply Dying Embers for post-Nether electronics.
- Organized pack fixes by purpose.
- **World generation change:** Disabled natural ice and fire dragon generation - they were destroying my stuff :/ (they will return but not to the overworld)

### Removed

- Rainbow Sugar, as Infinite Dimensions is impossible to balance in a progression based modpack. It will be a super late game item.
- Time in a Bottle Entity Fix following machine compatibility problems.

### Fixed

- Engineer's Goggles appearing in the generic Head Curios slot and dedicated slot instead of just their dedicated slot.
- Integrated Strongholds portal-room compatibility with End Remastered.
- Certus Quartz Block solidifying costs, silicon processing bypasses, and duplicate silicon decompression recipes.
- AE2 and ID facade recipe visibility and Pigmee crafting-screen labels.

## 0.2.0 Alpha - 2026-09-23

### Added

- Added the Antarchy - Ascension 0.2.0 Alpha mod and updated the mod manifest.
- Added animated End Remastered eye textures and an ancient portal frame resource override.
- Added in-game guide pages for Not Enough Patterns integrations and updated compass display names.

### Changed

- Enabled the Ars Zero Amplify II/III and Area of Effect II/III augments.
- Updated structure generation settings and removed the obsolete Overlapless configuration.
- Organized JEI's mod list and updated pack configuration for the current mod set.

### Fixed

- Fixed AE2 Crystal Science machines stalling at zero progress with Time in a Bottle Entity Fix installed.
- Fixed the raw redstone recipe loop.
- Fixed small blimp structures so the blimp and island generate together.
- Fixed End Remastered portal rooms in Integrated Strongholds.
- Fixed overlapping Pattern Provider upgrade slots and removed the disabled Not Enough Patterns Import Card from recipes and compatible upgrades.
- Fixed Not Enough Patterns guide navigation.
- Fixed shaders being enabled by default.

## Alpha 1.1 - 2026-09-14

### Added

- Added Better Tooltips and Better Advanced Tooltips.
- Added Gallery.
- Added Logistics Networks.
- Added No See No Tick.
- Added KubeJS Studio and MezzConfig.
- Added the "Chapter 1: Introduction" FTB Quests chapter group.

### Changed

- Changed 84 existing mod versions to their current installed versions.
- Changed the Time in a Bottle recipe to use the GAG Time Sand Pouch.
- Changed the FancyMenu title, pause, and universal menu layouts.
- Changed Antarchy KubeJS scripts into consolidated recipe, tag, recipe-viewer, and tooltip scripts.
- Changed JEI configuration to the current MezzConfig-backed layout.

### Removed

- Removed KubeJS Tweaks.
- Removed the old one-purpose Antarchy KubeJS scripts after consolidation.
- Removed the obsolete ByePregen configuration.
- Removed the old FancyMenu options screen layout.

### Fixed

- Fixed Engineer's Goggles also appearing in the generic Curios Head slot.
- Fixed the duplicate Create and Immersive Engineering steel plate pressing recipe.
- Fixed Better Lib's malformed English language resource.
- Fixed the stale Expanded AE JEI blacklist entry.

## Alpha 1.0 - 2026-08-30

Earlier dated development notes are retained with their original dates; they are not separate releases.

### Added

- Added targeted Log Begone filters for recurring harmless warnings from installed mods.
- Added JEI blacklist cleanup through Antarchy - Ascension Companion.
- Added validated OpenLoader fixes for Sawmill, Expanded Combat, Dye The World, Stella Arcanum, and additional loot tables. (Development note: 2026-08-22.)
- Added Configured Defaults source tracking for the Modern Lucky Block addon. (Development note: 2026-08-22.)
- Added Omnitools. (Development note: 2026-08-19.)
- Added Companion-driven Curios support for jetpacks and tanks. (Development note: 2026-08-19.)
- Added Dense Uranium through Antarchy - Ascension Companion. (Development note: 2026-08-18.)
- Added Antarchy Broodstone Uranium as the Cavaryn uranium source. (Development note: 2026-08-18.)
- Expanded the active mod set from 428 to 575 mods with 153 additions. (Development note: 2026-08-17.)
- Added major new technology, magic, exploration, dimension, utility, compatibility, and performance mods. (Development note: 2026-08-17.)
- Added Compact Machines room templates, recipes, advancements, localization, and datapack fixes. (Development note: 2026-08-17.)
- Added KubeJS Compact Machines tooltips. (Development note: 2026-08-17.)
- Added Drippy Loading Screen. (Development note: 2026-08-17.)
- Added the initial Log Begone configuration. (Development note: 2026-08-17.)
- Added Almost Unified configuration with AllTheOres preferred for common materials. (Development note: 2026-08-17.)
- Added custom FancyMenu backgrounds to additional menus and first-load screens. (Development note: 2026-08-14.)
- Expanded the Alpha 1.0 mod set to 428 active mods. (Development note: 2026-08-13.)
- Added Twilight Forest and its integrations. (Development note: 2026-08-13.)
- Added Iron's Spells 'n Spellbooks and its integrations. (Development note: 2026-08-13.)
- Added Better Combat and Expanded Combat. (Development note: 2026-08-13.)
- Added End Remastered with all 16 End Eyes enabled. (Development note: 2026-08-13.)
- Added Gobber and Gobber Delight. (Development note: 2026-08-13.)
- Added Aquaculture and Aquaculture Delight. (Development note: 2026-08-13.)
- Added Refurbished Furniture. (Development note: 2026-08-13.)
- Added Incendium and additional Nether and End structures. (Development note: 2026-08-13.)
- Added Overlapless. (Development note: 2026-08-13.)
- Added Prefab, Ambient Sounds, Chef's Delight, Followers Teleport Too, JEI Ores, and other supporting mods. (Development note: 2026-08-13.)
- Added AttributeFix definitions for Expanded Combat, Iron's Lib, Iron's Spells, and Twilight Forest. (Development note: 2026-08-13.)
- Added Alpha and Beta release expectations to the README. (Development note: 2026-08-13.)
- Added permanent `MOD_CHANGELOG.md` tracking. (Development note: 2026-08-13.)
- Added configs for newly installed mods. (Development note: 2026-08-12.)
- Added `MOD_MANIFEST.csv`. (Development note: 2026-08-12.)
- Added the PowerShell mod manifest updater. (Development note: 2026-08-12.)
- Created the Antarchy - Ascension repository. (Development note: 2026-08-11.)
- Added the initial NeoForge 1.21.1 modpack configuration. (Development note: 2026-08-11.)
- Added configs for more than 200 mods. (Development note: 2026-08-11.)
- Added FTB Quests, KubeJS, and default server configs. (Development note: 2026-08-11.)
- Added the README, license, `.gitignore`, and `.gitattributes`. (Development note: 2026-08-11.)

### Changed

- Updated Antarchy - Ascension Companion to Alpha 0.1.0.
- Updated JEI to 19.51.0.417.
- Finalized the six OpenLoader fix packs for data, loot tables, recipes, resources, tags, and worldgen.
- Cleaned obsolete OpenLoader overrides and stale compatibility files.
- Completed final Alpha log cleanup and launch validation.
- Finalized the Alpha mod manifest at 598 active mod JARs.
- Updated the manifest and changelog tools to use PowerShell 7. (Development note: 2026-08-22.)
- Improved manifest comparison and mod change detection. (Development note: 2026-08-22.)
- Disabled unnecessary update checks, analytics, profiling, and debug behavior where appropriate. (Development note: 2026-08-22.)
- Consolidated the old one-purpose OpenLoader packs into six organized Antarchy - Ascension fix packs. (Development note: 2026-08-22.)
- Enabled the Above the Clouds enchantment for Create Stuff 'N Additions jetpacks. (Development note: 2026-08-20.)
- Updated mods, configs, and Antarchy - Ascension Companion. (Development note: 2026-08-20.)
- Moved Minecraft to the front of JEI. (Development note: 2026-08-19.)
- Finished the main material and ore cleanup pass. (Development note: 2026-08-19.)
- Cleaned repository filenames. (Development note: 2026-08-19.)
- Unified normal uranium progression around AllTheOres Uranium. (Development note: 2026-08-18.)
- Unified titanium progression around Antarchy Titanium. (Development note: 2026-08-18.)
- Changed Extreme Reactors to use Uranium instead of solid Yellorium items. (Development note: 2026-08-18.)
- Changed Almost Unified and Cucumber to prefer Antarchy Titanium. (Development note: 2026-08-18.)
- Sorted JEI mods alphabetically. (Development note: 2026-08-18.)
- Cleaned JEI ingredients and recipe categories. (Development note: 2026-08-18.)
- Changed fluid tank display so JEI only shows useful empty variants. (Development note: 2026-08-18.)
- Hid removed Uranium, Titanium, and Yellorite content from JEI. (Development note: 2026-08-18.)
- Replaced Stellaris and Perspatium with the unofficial Ad Astra 1.21.1 port and Ad Astra: Giselle Addon for development. (Development note: 2026-08-17.)
- Replaced Polymorph with Polymorph Plus. (Development note: 2026-08-17.)
- Increased Explorer's Compass and Nature's Compass search limits. (Development note: 2026-08-17.)
- Disabled Aether random trivia and Better Lib loading tips. (Development note: 2026-08-17.)
- Updated Antarchy - Ascension Companion to its development 0.1.1 build. (Development note: 2026-08-17.)
- Refreshed generated registry, JEI, Jade, Apotheosis, Sophisticated Core, and Sound Physics data. (Development note: 2026-08-17.)
- Moved repository helper BAT files into the tools folder. (Development note: 2026-08-17.)
- Updated the mod manifest for the 575-mod baseline. (Development note: 2026-08-17.)
- Continued refining the Antarchy - Ascension menus and loading screens. (Development note: 2026-08-14.)
- Updated mods and configs. (Development note: 2026-08-14.)
- Updated JEI ordering and recipe categories for the expanded mod set. (Development note: 2026-08-13.)
- Updated Jade integration for Twilight Forest. (Development note: 2026-08-13.)
- Updated Apotheosis enchantment configuration. (Development note: 2026-08-13.)
- Updated Relics, Crash Assistant, and Supplementaries configs. (Development note: 2026-08-13.)
- Replaced the previous Morph mod with CraisinLord's Morph. (Development note: 2026-08-13.)
- Replaced the old Morph server config with the current Morph config. (Development note: 2026-08-13.)
- Reduced Faster Climbing speed from 2.0x to 1.5x. (Development note: 2026-08-13.)
- Changed SecurityCraft reinforced block tinting to owned blocks only. (Development note: 2026-08-13.)
- Disabled Quark's Q button. (Development note: 2026-08-13.)
- Disabled Aether starting loot and Patreon messages. (Development note: 2026-08-13.)
- Updated the mod manifest for the 428-mod Alpha baseline. (Development note: 2026-08-13.)
- Reworked `.gitignore` for generated and local runtime files. (Development note: 2026-08-13.)
- Reduced unnecessary startup messages. (Development note: 2026-08-12.)
- Updated Xaero's Minimap and HUD configuration. (Development note: 2026-08-12.)

### Removed

- Removed biome entries from JEI Ores. (Development note: 2026-08-17.)
- Removed the experimental Companion working-set trim and its client config.
- Removed stale configs from mods that are no longer installed.
- Removed obsolete Patchouli overrides.
- Removed obsolete FTB face resource workarounds.
- Removed obsolete BetterLib language overrides.
- Removed unused Design n' Decor sound overrides.
- Removed JEI Optimizer.
- Removed Saturn.
- Removed ByePregen.
- Removed Advanced Peripherals.
- Removed CC:Tweaked.
- Removed Classic Peripherals.
- Removed DecoCraft and DecoCraft Nature.
- Removed Mahou Tsukai and Mahou Tsukai Combat.
- Removed Nether Wart Block.
- Removed Create SA Curios Jetpacks after the Companion added dedicated Jetpack and Tank slots. (Development note: 2026-08-19.)
- Removed Marvel Titanium from progression. (Development note: 2026-08-18.)
- Removed duplicate Uranium and Yellorite ore generation. (Development note: 2026-08-18.)
- Removed solid Yellorium progression while keeping required Yellorium fluid support. (Development note: 2026-08-18.)
- Removed unused AllTheOres alternate ore variants and material paths. (Development note: 2026-08-18.)
- Removed obsolete Iris/Flywheel compatibility. (Development note: 2026-08-17.)
- Removed third-party OpenLoader ZIPs from repository tracking. (Development note: 2026-08-17.)
- Removed C2ME after worldgen compatibility problems. (Development note: 2026-08-13.)
- Removed Deeper and Darker. (Development note: 2026-08-13.)
- Removed Dungeons and Villages: Deeper and Darker. (Development note: 2026-08-13.)
- Removed JEI Worldgen. (Development note: 2026-08-13.)
- Removed Resonant Synthesis. (Development note: 2026-08-13.)
- Removed Morph Extended. (Development note: 2026-08-13.)
- Removed stale configs from removed mods. (Development note: 2026-08-13.)
- Removed stale configs from removed mods. (Development note: 2026-08-12.)

### Fixed

- Fixed remaining broken blockstates, models, textures, language files, recipes, loot tables, tags, and worldgen data.
- Fixed Regions Unexplored invalid oak revival trades.
- Fixed Actually Additions Engineer's Goggles using incorrect Curios item IDs.
- Fixed Evolved Mekanism silver resources.
- Fixed remaining references to removed materials and content.
- Fixed the Advanced Memory Card guide page. (Development note: 2026-08-22.)
- Fixed Advanced Peripherals AE disk cell models. (Development note: 2026-08-22.)
- Fixed unwanted Evolved Mekanism processing recipes for uranium ore variants that do not generate in the pack. (Development note: 2026-08-22.)
- Fixed the ME Gearbox GUI overlap. (Development note: 2026-08-20.)
- Fixed FancyMenu scaling on the options and pause screens. (Development note: 2026-08-20.)
- Fixed the Accessories inventory button overlapping the Apothic Attributes button. (Development note: 2026-08-19.)
- Fixed broken recipes, loot tables, and tags found during material cleanup. (Development note: 2026-08-19.)
- Fixed pause menu scaling. (Development note: 2026-08-18.)
- Fixed title screen scaling at higher GUI scales. (Development note: 2026-08-14.)
- Improved mod manifest version detection. (Development note: 2026-08-13.)
- Improved added, removed, and updated mod reporting. (Development note: 2026-08-13.)


Comparison links use the recorded post-0.2.0 changelog snapshot because no 0.2.0 release tag is available. They cover committed changes; Unreleased also includes pending working-tree changes.

[Unreleased]: https://github.com/CtrlAltDyleted/Antarchy-Ascension/compare/f63186596f1fca208b175b22c78f6d81a8f68d71...HEAD
