// removes AllTheOres Ancient Stone ore variants
const removedAllTheOresOtherOres = [
    'alltheores:other_aluminum_ore',
    'alltheores:other_cinnabar_ore',
    'alltheores:other_fluorite_ore',
    'alltheores:other_iridium_ore',
    'alltheores:other_lead_ore',
    'alltheores:other_nickel_ore',
    'alltheores:other_osmium_ore',
    'alltheores:other_peridot_ore',
    'alltheores:other_platinum_ore',
    'alltheores:other_ruby_ore',
    'alltheores:other_salt_ore',
    'alltheores:other_sapphire_ore',
    'alltheores:other_silver_ore',
    'alltheores:other_sulfur_ore',
    'alltheores:other_tin_ore',
    'alltheores:other_uranium_ore',
    'alltheores:other_zinc_ore'
]

// removes unused AllTheOres materials
// The six "other_*_ore" Ancient Stone variants are already covered above, so they are omitted here
const removedAllTheOresItems = [
    "create:crushed_raw_platinum",
    "alltheores:cinnabar",
    "alltheores:cinnabar_block",
    "alltheores:cinnabar_dust",
    "alltheores:cinnabar_ore",
    "alltheores:deepslate_cinnabar_ore",
    "alltheores:deepslate_iridium_ore",
    "alltheores:deepslate_peridot_ore",
    "alltheores:deepslate_platinum_ore",
    "alltheores:deepslate_ruby_ore",
    "alltheores:deepslate_sapphire_ore",
    "alltheores:end_cinnabar_ore",
    "alltheores:end_iridium_ore",
    "alltheores:end_peridot_ore",
    "alltheores:end_platinum_ore",
    "alltheores:end_ruby_ore",
    "alltheores:end_sapphire_ore",
    "alltheores:enderium_block",
    "alltheores:enderium_dust",
    "alltheores:enderium_gear",
    "alltheores:enderium_ingot",
    "alltheores:enderium_nugget",
    "alltheores:enderium_plate",
    "alltheores:enderium_rod",
    "alltheores:iridium_block",
    "alltheores:iridium_clump",
    "alltheores:iridium_crystal",
    "alltheores:iridium_dust",
    "alltheores:iridium_gear",
    "alltheores:iridium_ingot",
    "alltheores:iridium_nugget",
    "alltheores:iridium_ore",
    "alltheores:iridium_plate",
    "alltheores:iridium_rod",
    "alltheores:iridium_shard",
    "alltheores:lumium_block",
    "alltheores:lumium_dust",
    "alltheores:lumium_gear",
    "alltheores:lumium_ingot",
    "alltheores:lumium_nugget",
    "alltheores:lumium_plate",
    "alltheores:lumium_rod",
    "alltheores:molten_enderium_bucket",
    "alltheores:molten_iridium_bucket",
    "alltheores:molten_lumium_bucket",
    "alltheores:molten_platinum_bucket",
    "alltheores:molten_signalum_bucket",
    "alltheores:nether_cinnabar_ore",
    "alltheores:nether_iridium_ore",
    "alltheores:nether_peridot_ore",
    "alltheores:nether_platinum_ore",
    "alltheores:nether_ruby_ore",
    "alltheores:nether_sapphire_ore",
    "alltheores:peridot",
    "alltheores:peridot_block",
    "alltheores:peridot_dust",
    "alltheores:peridot_ore",
    "alltheores:platinum_block",
    "alltheores:platinum_clump",
    "alltheores:platinum_crystal",
    "alltheores:platinum_dust",
    "alltheores:platinum_gear",
    "alltheores:platinum_ingot",
    "alltheores:platinum_nugget",
    "alltheores:platinum_ore",
    "alltheores:platinum_ore_hammer",
    "alltheores:platinum_plate",
    "alltheores:platinum_rod",
    "alltheores:platinum_shard",
    "alltheores:raw_iridium",
    "alltheores:raw_iridium_block",
    "alltheores:raw_platinum",
    "alltheores:raw_platinum_block",
    "alltheores:ruby",
    "alltheores:ruby_block",
    "alltheores:ruby_dust",
    "alltheores:ruby_ore",
    "alltheores:sapphire",
    "alltheores:sapphire_block",
    "alltheores:sapphire_dust",
    "alltheores:sapphire_ore",
    "alltheores:signalum_block",
    "alltheores:signalum_dust",
    "alltheores:signalum_gear",
    "alltheores:signalum_ingot",
    "alltheores:signalum_nugget",
    "alltheores:signalum_plate",
    "alltheores:signalum_rod"
]

const removedAllTheOresFluids = [
    "alltheores:molten_enderium",
    "alltheores:molten_iridium",
    "alltheores:molten_lumium",
    "alltheores:molten_platinum",
    "alltheores:molten_signalum"
]

// Only show empty fluid and chemical tanks in jei
const emptyOnlyTanks = [
    'evilcraft:dark_tank',

    'mekanism:basic_fluid_tank',
    'mekanism:advanced_fluid_tank',
    'mekanism:elite_fluid_tank',
    'mekanism:ultimate_fluid_tank',
    'mekanism:creative_fluid_tank',

    'mekanism:basic_chemical_tank',
    'mekanism:advanced_chemical_tank',
    'mekanism:elite_chemical_tank',
    'mekanism:ultimate_chemical_tank',
    'mekanism:creative_chemical_tank'
]

// removes Marvel titanium ore
const removedMarvelTitaniumItems = [
    'marvel:titanium_ore',
    'marvel:deepslate_titanium_ore'
]

// removes Uranium ores that don't generate anymore
const hiddenUraniumOres = [
    'alltheores:nether_uranium_ore',
    'alltheores:end_uranium_ore',

    'antarchy:uranium_ore',
    'antarchy:deepslate_uranium_ore',

    'mekanism:uranium_ore',
    'mekanism:deepslate_uranium_ore',

    'immersiveengineering:ore_uranium',
    'immersiveengineering:deepslate_ore_uranium'
]

// removes Dense uranium / yellorium items
const hiddenYelloriumItems = [
    'bigreactors:yellorite_ore',
    'bigreactors:deepslate_yellorite_ore',

    'bigreactors:raw_yellorium',
    'bigreactors:raw_yellorium_block',

    'bigreactors:yellorium_ingot',
    'bigreactors:yellorium_block',

    'mysticalagriculture:yellorium_seeds',
    'mysticalagriculture:yellorium_essence'
]

// removes unused Ice and Fire Sapphire stuff.
const removedIceAndFireSapphireItems = [
    'iceandfire:sapphire_ore',
    'iceandfire:sapphire_gem',
    'iceandfire:sapphire_block'
]

// removes unused compatibility content from jei.
const removedMaterialIntegrationItems = [
    "allthecompressed:cinnabar_block_1x",
    "allthecompressed:cinnabar_block_2x",
    "allthecompressed:cinnabar_block_3x",
    "allthecompressed:cinnabar_block_4x",
    "allthecompressed:cinnabar_block_5x",
    "allthecompressed:cinnabar_block_6x",
    "allthecompressed:cinnabar_block_7x",
    "allthecompressed:cinnabar_block_8x",
    "allthecompressed:cinnabar_block_9x",
    "allthecompressed:enderium_block_1x",
    "allthecompressed:enderium_block_2x",
    "allthecompressed:enderium_block_3x",
    "allthecompressed:enderium_block_4x",
    "allthecompressed:enderium_block_5x",
    "allthecompressed:enderium_block_6x",
    "allthecompressed:enderium_block_7x",
    "allthecompressed:enderium_block_8x",
    "allthecompressed:enderium_block_9x",
    "allthecompressed:iridium_block_1x",
    "allthecompressed:iridium_block_2x",
    "allthecompressed:iridium_block_3x",
    "allthecompressed:iridium_block_4x",
    "allthecompressed:iridium_block_5x",
    "allthecompressed:iridium_block_6x",
    "allthecompressed:iridium_block_7x",
    "allthecompressed:iridium_block_8x",
    "allthecompressed:iridium_block_9x",
    "allthecompressed:lumium_block_1x",
    "allthecompressed:lumium_block_2x",
    "allthecompressed:lumium_block_3x",
    "allthecompressed:lumium_block_4x",
    "allthecompressed:lumium_block_5x",
    "allthecompressed:lumium_block_6x",
    "allthecompressed:lumium_block_7x",
    "allthecompressed:lumium_block_8x",
    "allthecompressed:lumium_block_9x",
    "allthecompressed:peridot_block_1x",
    "allthecompressed:peridot_block_2x",
    "allthecompressed:peridot_block_3x",
    "allthecompressed:peridot_block_4x",
    "allthecompressed:peridot_block_5x",
    "allthecompressed:peridot_block_6x",
    "allthecompressed:peridot_block_7x",
    "allthecompressed:peridot_block_8x",
    "allthecompressed:peridot_block_9x",
    "allthecompressed:platinum_block_1x",
    "allthecompressed:platinum_block_2x",
    "allthecompressed:platinum_block_3x",
    "allthecompressed:platinum_block_4x",
    "allthecompressed:platinum_block_5x",
    "allthecompressed:platinum_block_6x",
    "allthecompressed:platinum_block_7x",
    "allthecompressed:platinum_block_8x",
    "allthecompressed:platinum_block_9x",
    "allthecompressed:raw_iridium_block_1x",
    "allthecompressed:raw_iridium_block_2x",
    "allthecompressed:raw_iridium_block_3x",
    "allthecompressed:raw_iridium_block_4x",
    "allthecompressed:raw_iridium_block_5x",
    "allthecompressed:raw_iridium_block_6x",
    "allthecompressed:raw_iridium_block_7x",
    "allthecompressed:raw_iridium_block_8x",
    "allthecompressed:raw_iridium_block_9x",
    "allthecompressed:raw_platinum_block_1x",
    "allthecompressed:raw_platinum_block_2x",
    "allthecompressed:raw_platinum_block_3x",
    "allthecompressed:raw_platinum_block_4x",
    "allthecompressed:raw_platinum_block_5x",
    "allthecompressed:raw_platinum_block_6x",
    "allthecompressed:raw_platinum_block_7x",
    "allthecompressed:raw_platinum_block_8x",
    "allthecompressed:raw_platinum_block_9x",
    "allthecompressed:ruby_block_1x",
    "allthecompressed:ruby_block_2x",
    "allthecompressed:ruby_block_3x",
    "allthecompressed:ruby_block_4x",
    "allthecompressed:ruby_block_5x",
    "allthecompressed:ruby_block_6x",
    "allthecompressed:ruby_block_7x",
    "allthecompressed:ruby_block_8x",
    "allthecompressed:ruby_block_9x",
    "allthecompressed:sapphire_block_1x",
    "allthecompressed:sapphire_block_2x",
    "allthecompressed:sapphire_block_3x",
    "allthecompressed:sapphire_block_4x",
    "allthecompressed:sapphire_block_5x",
    "allthecompressed:sapphire_block_6x",
    "allthecompressed:sapphire_block_7x",
    "allthecompressed:sapphire_block_8x",
    "allthecompressed:sapphire_block_9x",
    "allthecompressed:signalum_block_1x",
    "allthecompressed:signalum_block_2x",
    "allthecompressed:signalum_block_3x",
    "allthecompressed:signalum_block_4x",
    "allthecompressed:signalum_block_5x",
    "allthecompressed:signalum_block_6x",
    "allthecompressed:signalum_block_7x",
    "allthecompressed:signalum_block_8x",
    "allthecompressed:signalum_block_9x",
    "mysticalagriculture:enderium_essence",
    "mysticalagriculture:enderium_seeds",
    "mysticalagriculture:iridium_essence",
    "mysticalagriculture:iridium_seeds",
    "mysticalagriculture:lumium_essence",
    "mysticalagriculture:lumium_seeds",
    "mysticalagriculture:peridot_essence",
    "mysticalagriculture:peridot_seeds",
    "mysticalagriculture:platinum_essence",
    "mysticalagriculture:platinum_seeds",
    "mysticalagriculture:ruby_essence",
    "mysticalagriculture:ruby_seeds",
    "mysticalagriculture:sapphire_essence",
    "mysticalagriculture:sapphire_seeds",
    "mysticalagriculture:signalum_essence",
    "mysticalagriculture:signalum_seeds"
]

RecipeViewerEvents.removeEntriesCompletely('item', event => {
    removedAllTheOresOtherOres.forEach(id => {
        event.remove(id)
    })

    removedAllTheOresItems.forEach(id => {
        event.remove(id)
    })

    removedMarvelTitaniumItems.forEach(id => {
        event.remove(id)
    })

    hiddenUraniumOres.forEach(id => {
        event.remove(id)
    })

    hiddenYelloriumItems.forEach(id => {
        event.remove(id)
    })

    removedIceAndFireSapphireItems.forEach(id => {
        event.remove(id)
    })

    removedMaterialIntegrationItems.forEach(id => {
        event.remove(id)
    })
})

RecipeViewerEvents.removeEntriesCompletely('fluid', event => {
    removedAllTheOresFluids.forEach(id => {
        event.remove(id)
    })
})

RecipeViewerEvents.removeEntries('item', event => {
    emptyOnlyTanks.forEach(id => {
        event.remove(id)
    })
})

RecipeViewerEvents.addEntries('item', event => {
    emptyOnlyTanks.forEach(id => {
        event.add(id)
    })
})
