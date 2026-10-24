// Removed materials and obsolete integrations

// Remove unused AllTheOres materials
// Removes only the listed recipe IDs
const removedAllTheOresRecipes = [
    // ae2 / matter_cannon
    'ae2:matter_cannon/nuggets/iridium',

    // alltheores / alloy_smelting
    'alltheores:alloy_smelting/enderium_ingot',
    'alltheores:alloy_smelting/lumium_ingot',
    'alltheores:alloy_smelting/signalum_ingot',

    // alltheores / arcfurnace
    'alltheores:arcfurnace/enderium/from_dust',
    'alltheores:arcfurnace/enderium/from_gear',
    'alltheores:arcfurnace/enderium/from_plate',
    'alltheores:arcfurnace/enderium/from_rod',
    'alltheores:arcfurnace/enderium/ingot',
    'alltheores:arcfurnace/iridium/from_dust',
    'alltheores:arcfurnace/iridium/from_gear',
    'alltheores:arcfurnace/iridium/from_plate',
    'alltheores:arcfurnace/iridium/from_raw',
    'alltheores:arcfurnace/iridium/from_raw_block',
    'alltheores:arcfurnace/iridium/from_rod',
    'alltheores:arcfurnace/lumium/from_dust',
    'alltheores:arcfurnace/lumium/from_gear',
    'alltheores:arcfurnace/lumium/from_plate',
    'alltheores:arcfurnace/lumium/from_rod',
    'alltheores:arcfurnace/lumium/ingot',
    'alltheores:arcfurnace/signalum/from_dust',
    'alltheores:arcfurnace/signalum/from_gear',
    'alltheores:arcfurnace/signalum/from_plate',
    'alltheores:arcfurnace/signalum/from_rod',
    'alltheores:arcfurnace/signalum/ingot',

    // alltheores / crafting
    'alltheores:crafting/cinnabar/block_from_gem',
    'alltheores:crafting/cinnabar/gem_from_block',
    'alltheores:crafting/enderium/alloy_blending_from_dust',
    'alltheores:crafting/enderium/block_from_ingot',
    'alltheores:crafting/enderium/gear',
    'alltheores:crafting/enderium/ingot_from_block',
    'alltheores:crafting/enderium/ingot_from_nugget',
    'alltheores:crafting/enderium/nugget_from_ingot',
    'alltheores:crafting/enderium/plate',
    'alltheores:crafting/enderium/rod',
    'alltheores:crafting/hammer/cinnabar/dust_from_gem',
    'alltheores:crafting/hammer/cinnabar/gem_from_ore',
    'alltheores:crafting/hammer/enderium/dust_from_ingot',
    'alltheores:crafting/hammer/iridium/dust_from_ingot',
    'alltheores:crafting/hammer/iridium/dust_from_ore',
    'alltheores:crafting/hammer/iridium/dust_from_raw',
    'alltheores:crafting/hammer/lumium/dust_from_ingot',
    'alltheores:crafting/hammer/peridot/dust_from_gem',
    'alltheores:crafting/hammer/peridot/gem_from_ore',
    'alltheores:crafting/hammer/ruby/dust_from_gem',
    'alltheores:crafting/hammer/ruby/gem_from_ore',
    'alltheores:crafting/hammer/sapphire/dust_from_gem',
    'alltheores:crafting/hammer/sapphire/gem_from_ore',
    'alltheores:crafting/hammer/signalum/dust_from_ingot',
    'alltheores:crafting/iridium/block_from_ingot',
    'alltheores:crafting/iridium/gear',
    'alltheores:crafting/iridium/ingot_from_block',
    'alltheores:crafting/iridium/ingot_from_nugget',
    'alltheores:crafting/iridium/nugget_from_ingot',
    'alltheores:crafting/iridium/plate',
    'alltheores:crafting/iridium/raw_block_from_raw',
    'alltheores:crafting/iridium/raw_from_raw_block',
    'alltheores:crafting/iridium/rod',
    'alltheores:crafting/lumium/alloy_blending_from_dust',
    'alltheores:crafting/lumium/block_from_ingot',
    'alltheores:crafting/lumium/gear',
    'alltheores:crafting/lumium/ingot_from_block',
    'alltheores:crafting/lumium/ingot_from_nugget',
    'alltheores:crafting/lumium/nugget_from_ingot',
    'alltheores:crafting/lumium/plate',
    'alltheores:crafting/lumium/rod',
    'alltheores:crafting/peridot/block_from_gem',
    'alltheores:crafting/peridot/gem_from_block',
    'alltheores:crafting/ruby/block_from_gem',
    'alltheores:crafting/ruby/gem_from_block',
    'alltheores:crafting/sapphire/block_from_gem',
    'alltheores:crafting/sapphire/gem_from_block',
    'alltheores:crafting/signalum/alloy_blending_from_dust',
    'alltheores:crafting/signalum/block_from_ingot',
    'alltheores:crafting/signalum/gear',
    'alltheores:crafting/signalum/ingot_from_block',
    'alltheores:crafting/signalum/ingot_from_nugget',
    'alltheores:crafting/signalum/nugget_from_ingot',
    'alltheores:crafting/signalum/plate',
    'alltheores:crafting/signalum/rod',

    // alltheores / crusher
    'alltheores:crusher/cinnabar/from_gem',
    'alltheores:crusher/cinnabar/from_ore',
    'alltheores:crusher/enderium/from_ingot',
    'alltheores:crusher/iridium/from_ingot',
    'alltheores:crusher/iridium/from_ore',
    'alltheores:crusher/iridium/from_raw',
    'alltheores:crusher/iridium/from_raw_block',
    'alltheores:crusher/lumium/from_ingot',
    'alltheores:crusher/peridot/from_gem',
    'alltheores:crusher/peridot/from_ore',
    'alltheores:crusher/ruby/from_gem',
    'alltheores:crusher/ruby/from_ore',
    'alltheores:crusher/sapphire/from_gem',
    'alltheores:crusher/sapphire/from_ore',
    'alltheores:crusher/signalum/from_ingot',

    // alltheores / crushing
    'alltheores:crushing/cinnabar/from_gem',
    'alltheores:crushing/cinnabar/from_ore',
    'alltheores:crushing/enderium/from_dust',
    'alltheores:crushing/iridium/from_dust',
    'alltheores:crushing/iridium/from_ore',
    'alltheores:crushing/iridium/from_raw',
    'alltheores:crushing/iridium/from_raw_block',
    'alltheores:crushing/lumium/from_dust',
    'alltheores:crushing/peridot/from_gem',
    'alltheores:crushing/peridot/from_ore',
    'alltheores:crushing/ruby/from_gem',
    'alltheores:crushing/ruby/from_ore',
    'alltheores:crushing/sapphire/from_gem',
    'alltheores:crushing/sapphire/from_ore',
    'alltheores:crushing/signalum/from_dust',

    // alltheores / metalpress
    'alltheores:metalpress/enderium/gear',
    'alltheores:metalpress/enderium/plate',
    'alltheores:metalpress/enderium/rod',
    'alltheores:metalpress/iridium/gear',
    'alltheores:metalpress/iridium/plate',
    'alltheores:metalpress/iridium/rod',
    'alltheores:metalpress/lumium/gear',
    'alltheores:metalpress/lumium/plate',
    'alltheores:metalpress/lumium/rod',
    'alltheores:metalpress/signalum/gear',
    'alltheores:metalpress/signalum/plate',
    'alltheores:metalpress/signalum/rod',

    // alltheores / processing
    'alltheores:processing/cinnabar/dust/from_gem',
    'alltheores:processing/cinnabar/dust/from_ore',
    'alltheores:processing/cinnabar/from_dust',
    'alltheores:processing/enderium/dust/from_ingot',
    'alltheores:processing/iridium/clump/from_ore',
    'alltheores:processing/iridium/clump/from_raw',
    'alltheores:processing/iridium/clump/from_raw_block',
    'alltheores:processing/iridium/clump/from_shard',
    'alltheores:processing/iridium/crystal/from_slurry',
    'alltheores:processing/iridium/dirty_dust/from_clump',
    'alltheores:processing/iridium/dust/from_dirty_dust',
    'alltheores:processing/iridium/dust/from_ingot',
    'alltheores:processing/iridium/dust/from_ore',
    'alltheores:processing/iridium/dust/from_raw',
    'alltheores:processing/iridium/dust/from_raw_block',
    'alltheores:processing/iridium/shard/from_crystal',
    'alltheores:processing/iridium/shard/from_ore',
    'alltheores:processing/iridium/shard/from_raw',
    'alltheores:processing/iridium/shard/from_raw_block',
    'alltheores:processing/iridium/slurry/dirty/from_ore',
    'alltheores:processing/iridium/slurry/dirty/from_raw',
    'alltheores:processing/lumium/dust/from_ingot',
    'alltheores:processing/peridot/dust/from_gem',
    'alltheores:processing/peridot/dust/from_ore',
    'alltheores:processing/peridot/from_dust',
    'alltheores:processing/ruby/dust/from_gem',
    'alltheores:processing/ruby/dust/from_ore',
    'alltheores:processing/ruby/from_dust',
    'alltheores:processing/sapphire/dust/from_gem',
    'alltheores:processing/sapphire/dust/from_ore',
    'alltheores:processing/sapphire/from_dust',
    'alltheores:processing/signalum/dust/from_ingot',

    // alltheores / sag_milling
    'alltheores:sag_milling/cinnabar/gem',
    'alltheores:sag_milling/cinnabar/ore',
    'alltheores:sag_milling/enderium/ingot',
    'alltheores:sag_milling/iridium/ingot',
    'alltheores:sag_milling/iridium/ore',
    'alltheores:sag_milling/iridium/raw',
    'alltheores:sag_milling/lumium/ingot',
    'alltheores:sag_milling/peridot/gem',
    'alltheores:sag_milling/peridot/ore',
    'alltheores:sag_milling/ruby/gem',
    'alltheores:sag_milling/ruby/ore',
    'alltheores:sag_milling/sapphire/gem',
    'alltheores:sag_milling/sapphire/ore',
    'alltheores:sag_milling/signalum/ingot',

    // alltheores / smelting
    'alltheores:smelting/enderium/dust_blasting',
    'alltheores:smelting/enderium/dust_smelting',
    'alltheores:smelting/iridium/dust_blasting',
    'alltheores:smelting/iridium/dust_smelting',
    'alltheores:smelting/iridium/ore_blasting',
    'alltheores:smelting/iridium/ore_smelting',
    'alltheores:smelting/iridium/raw_blasting',
    'alltheores:smelting/iridium/raw_block_blasting',
    'alltheores:smelting/iridium/raw_block_smelting',
    'alltheores:smelting/iridium/raw_smelting',
    'alltheores:smelting/lumium/dust_blasting',
    'alltheores:smelting/lumium/dust_smelting',
    'alltheores:smelting/signalum/dust_blasting',
    'alltheores:smelting/signalum/dust_smelting',

    // industrialforegoing / laser_drill_ore
    'industrialforegoing:laser_drill_ore/ores/cinnabar',
    'industrialforegoing:laser_drill_ore/ores/peridot',
    'industrialforegoing:laser_drill_ore/ores/ruby',
    'industrialforegoing:laser_drill_ore/ores/sapphire',
    'industrialforegoing:laser_drill_ore/raw_materials/cinnabar',
    'industrialforegoing:laser_drill_ore/raw_materials/iridium',

    // mysticalagriculture / essence
    'mysticalagriculture:essence/common/iridium_ingot',
    'mysticalagriculture:essence/gems/peridot',
    'mysticalagriculture:essence/gems/ruby',
    'mysticalagriculture:essence/gems/sapphire',
    'mysticalagriculture:essence/thermal/enderium_ingot',
    'mysticalagriculture:essence/thermal/lumium_ingot',
    'mysticalagriculture:essence/thermal/signalum_ingot',

    // mysticalagriculture / seed
    'mysticalagriculture:seed/crafting/enderium',
    'mysticalagriculture:seed/crafting/iridium',
    'mysticalagriculture:seed/crafting/lumium',
    'mysticalagriculture:seed/crafting/peridot',
    'mysticalagriculture:seed/crafting/ruby',
    'mysticalagriculture:seed/crafting/sapphire',
    'mysticalagriculture:seed/crafting/signalum',
    'mysticalagriculture:seed/infusion/enderium',
    'mysticalagriculture:seed/infusion/iridium',
    'mysticalagriculture:seed/infusion/lumium',
    'mysticalagriculture:seed/infusion/peridot',
    'mysticalagriculture:seed/infusion/ruby',
    'mysticalagriculture:seed/infusion/sapphire',
    'mysticalagriculture:seed/infusion/signalum',

    // occultism / crushing
    'occultism:crushing/cinnabar_dust_from_gem',
    'occultism:crushing/cinnabar_dust_from_ore',
    'occultism:crushing/enderium_dust_from_ingot',
    'occultism:crushing/iridium_dirty_dust_from_clump',
    'occultism:crushing/iridium_dust_from_ingot',
    'occultism:crushing/iridium_dust_from_ore',
    'occultism:crushing/iridium_dust_from_raw',
    'occultism:crushing/iridium_dust_from_raw_block',
    'occultism:crushing/lumium_dust_from_ingot',
    'occultism:crushing/peridot_dust_from_gem',
    'occultism:crushing/peridot_dust_from_ore',
    'occultism:crushing/ruby_dust_from_gem',
    'occultism:crushing/ruby_dust_from_ore',
    'occultism:crushing/sapphire_dust_from_gem',
    'occultism:crushing/sapphire_dust_from_ore',
    'occultism:crushing/signalum_dust_from_ingot',

    // occultism / crystallize
    'occultism:crystallize/cinnabar_from_dust',
    'occultism:crystallize/cinnabar_from_ore',
    'occultism:crystallize/peridot_from_dust',
    'occultism:crystallize/peridot_from_ore',
    'occultism:crystallize/ruby_from_dust',
    'occultism:crystallize/ruby_from_ore',
    'occultism:crystallize/sapphire_from_dust',
    'occultism:crystallize/sapphire_from_ore',

    // occultism / miner
    'occultism:miner/eldritch/peridot',
    'occultism:miner/eldritch/ruby',
    'occultism:miner/eldritch/sapphire',
    'occultism:miner/ores/cinnabar_ore',
    'occultism:miner/ores/iridium_ore',
    'occultism:miner/ores/peridot_ore',
    'occultism:miner/ores/ruby_ore',
    'occultism:miner/ores/sapphire_ore',

    // productivebees / centrifuge
    'productivebees:centrifuge/alloys/honeycomb_enderium',
    'productivebees:centrifuge/alloys/honeycomb_lumium',
    'productivebees:centrifuge/alloys/honeycomb_signalum',
    'productivebees:centrifuge/gems/honeycomb_cinnabar',
    'productivebees:centrifuge/gems/honeycomb_cinnabar_dust',
    'productivebees:centrifuge/gems/honeycomb_peridot',
    'productivebees:centrifuge/gems/honeycomb_ruby',
    'productivebees:centrifuge/gems/honeycomb_sapphire',
    'productivebees:centrifuge/raw_materials/honeycomb_iridium',

    // productivebees / ftbic
    'productivebees:ftbic/canning/iridium_bee',

    // replication / matter_values
    'replication:matter_values/c/tags/ingots/iridium',

    // alltheores / processing
    'alltheores:processing/iridium/slurry/dirty/from_raw_block'
]

// Uranium and Yellorium cleanup
function cleanUpUraniumAndYellorium(event) {
    // Uranium scrap produces dense uranium.
    const obsoleteAntarchyScrapRecipes = [
        'antarchy:uranium/raw_uranium_from_scrap',
        'antarchy:uranium/uranium_nugget_from_raw_uranium_scrap_smelting',
        'antarchy:uranium/uranium_nugget_from_raw_uranium_scrap_blasting'
    ]

    obsoleteAntarchyScrapRecipes.forEach(id => {
        event.remove({ id: id })
    })

    // Antarchy recipes that use dense uranium.
    const denseIngotRecipes = [
        'antarchy:gravity_gun',
        'antarchy:shrink_ray',

        'antarchy:ultimate/ultimate_axe',
        'antarchy:ultimate/ultimate_boots',
        'antarchy:ultimate/ultimate_bow',
        'antarchy:ultimate/ultimate_chestplate',
        'antarchy:ultimate/ultimate_crossbow',
        'antarchy:ultimate/ultimate_helmet',
        'antarchy:ultimate/ultimate_hoe',
        'antarchy:ultimate/ultimate_leggings',
        'antarchy:ultimate/ultimate_pickaxe',
        'antarchy:ultimate/ultimate_shovel',
        'antarchy:ultimate/ultimate_sword'
    ]

    denseIngotRecipes.forEach(id => {
        event.replaceInput(
            { id: id },
            'antarchy:uranium_ingot',
            'antarchyascension:dense_uranium_ingot'
        )
    })

    event.replaceInput(
        { id: 'antarchy:attitude_adjuster' },
        'antarchy:uranium_block',
        'antarchyascension:dense_uranium_block'
    )

    event.replaceInput(
        { id: 'antarchy:rainbow_sugar' },
        'antarchy:uranium_nugget',
        'antarchyascension:dense_uranium_nugget'
    )

    // Replace hardcoded Yellorium ingredients in Extreme Reactors fluidizers
    const fluidizerMachineRecipes = [
        'bigreactors:fluidizer/casing',
        'bigreactors:fluidizer/controller',
        'bigreactors:fluidizer/solidinjector'
    ]

    // Replaces Yellorium with uranium
    fluidizerMachineRecipes.forEach(id => {
        event.replaceInput(
            { id: id },
            '#c:ingots/yellorium',
            '#c:ingots/uranium'
        )
    })

    // Remove obsolete solid Yellorium recipes
    const removedYelloriumRecipeIds = [
        // Extreme Reactors
        'bigreactors:blasting/yellorium_from_ore',
        'bigreactors:blasting/yellorium_from_raw',
        'bigreactors:smelting/yellorium_from_ore',
        'bigreactors:smelting/yellorium_from_raw',

        'bigreactors:crafting/raw_yellorium_component_to_storage',
        'bigreactors:crafting/raw_yellorium_storage_to_component',
        'bigreactors:crafting/yellorium_component_to_storage',
        'bigreactors:crafting/yellorium_storage_to_component',

        // Reactor recipes with existing uranium alternatives
        'bigreactors:reactor/basic/controller_ingots_yellorium',
        'bigreactors:reactor/basic/fuelrod_ingots_yellorium',
        'bigreactors:reactor/reinforced/controller_ingots_yellorium',
        'bigreactors:reactor/reinforced/fuelrod_alt_ingots_yellorium',
        'bigreactors:reactor/reinforced/fuelrod_ingots_yellorium',

        'bigreactors:misc/book/erguide',

        // Other Yellorium-producing integrations
        'industrialforegoing:laser_drill_ore/ores/yellorite',
        'industrialforegoing:laser_drill_ore/raw_materials/yellorite',
        'industrialforegoing:laser_drill_ore/raw_materials/yellorium',
        'occultism:miner/eldritch/raw_yellorium',

        // Yellorium crop integrations
        'mysticalagriculture:essence/extremereactors2/yellorium_ingot',
        'mysticalagriculture:seed/crafting/yellorium',
        'mysticalagriculture:seed/infusion/yellorium',
        'mysticalagriculture:seed/reprocessor/yellorium',
        'botanypots:mysticalagriculture/crop/yellorium_seeds',
        'mysticalengineering:cloche_yellorium_seed',
        'mekmm:compat/mysticalagriculture/yellorium',

        // Obsolete Thermal compatibility
        'thermal:machine/pulverizer_yellorite_ore_to_dust',
        'thermal:machine/pulverizer_yellorium_ingot_to_dust'
    ]

    removedYelloriumRecipeIds.forEach(id => {
        event.remove({ id: id })
    })

    // Preserve the existing output filters for obsolete solid items
    const removedSolidOutputs = [
        'bigreactors:yellorite_ore',
        'bigreactors:deepslate_yellorite_ore',
        'bigreactors:raw_yellorium',
        'bigreactors:raw_yellorium_block',
        'bigreactors:yellorium_ingot',
        'bigreactors:yellorium_block',
        'mysticalagriculture:yellorium_seeds',
        'mysticalagriculture:yellorium_essence'
    ]

    // Removes recipes producing retired solid items
    removedSolidOutputs.forEach(output => {
        event.remove({ output: output })
    })
}

// Removed materials and obsolete integrations (continued)
// Marvel titanium ore recipes
const removedMarvelTitaniumRecipes = [
    'occultism:miner/ores/titanium_ore',
    'marvel:titanium_ingot_from_smelting_titanium_ore',
    'marvel:titanium_ingot_from_smelting_deepslate_titanium_ore',
    'marvel:titanium_ingot_from_blasting_titanium_ore',
    'marvel:titanium_ingot_from_blasting_deepslate_titanium_ore'
]

// Unused Ice and Fire sapphire recipes
const removedIceAndFireSapphireRecipes = [
    'iceandfire:sapphire_block_to_sapphire_gem',
    'iceandfire:sapphire_gem_to_sapphire_block',
    'iceandfire:furnace/sapphire',
    'iceandfire:furnace/sapphire_blasting'
]

// Evolved Mekanism uranium ore-processing recipes
const removedEvolvedMekanismUraniumRecipes = [
    'evolvedmekanism:processing/uranium/ore/depthrock_from_raw',
    'evolvedmekanism:processing/uranium/ore/end_stone_from_raw',
    'evolvedmekanism:processing/uranium/ore/holystone_from_raw',
    'evolvedmekanism:processing/uranium/ore/netherrack_from_raw',
    'evolvedmekanism:processing/uranium/ore/shiverstone_from_raw'
]

// Duplicate ore-processing recipes
// Ancient Stone silver/aluminum integrations and unused AllTheOres iridium processing
const antarchyDuplicateOreRecipeIds = [
    // alltheores
    'alltheores:processing/iridium/slurry/from_dirty',

    // iceandfire
    'iceandfire:furnace/deepslate_silver_ingot',
    'iceandfire:furnace/deepslate_silver_ingot_blasting',
    'iceandfire:furnace/silver_ingot',
    'iceandfire:furnace/silver_ingot_blasting',
    'iceandfire:raw_silver_block_to_raw_silver',
    'iceandfire:raw_silver_to_raw_silver_block',
    'iceandfire:silver_block_to_silver_ingot',
    'iceandfire:silver_ingot_from_blasting_raw_silver',
    'iceandfire:silver_ingot_from_smelting_raw_silver',
    'iceandfire:silver_ingot_to_silver_block',
    'iceandfire:silver_ingot_to_silver_nugget',
    'iceandfire:silver_nugget_to_silver_ingot',

    // mekmm
    'mekmm:processing/silver/clump/from_ore',
    'mekmm:processing/silver/clump/from_raw_block',
    'mekmm:processing/silver/clump/from_raw_ore',
    'mekmm:processing/silver/clump/from_shard',
    'mekmm:processing/silver/crystal/from_slurry',
    'mekmm:processing/silver/dirty_dust/from_clump',
    'mekmm:processing/silver/dust/from_dirty_dust',
    'mekmm:processing/silver/dust/from_ingot',
    'mekmm:processing/silver/dust/from_ore',
    'mekmm:processing/silver/dust/from_raw_block',
    'mekmm:processing/silver/dust/from_raw_ore',
    'mekmm:processing/silver/ingot/from_block',
    'mekmm:processing/silver/ingot/from_dust_blasting',
    'mekmm:processing/silver/ingot/from_dust_smelting',
    'mekmm:processing/silver/ingot/from_nuggets',
    'mekmm:processing/silver/ingot/from_ore_blasting',
    'mekmm:processing/silver/ingot/from_ore_smelting',
    'mekmm:processing/silver/ingot/from_raw_blasting',
    'mekmm:processing/silver/ingot/from_raw_smelting',
    'mekmm:processing/silver/nugget/from_ingot',
    'mekmm:processing/silver/ore/deepslate_from_raw',
    'mekmm:processing/silver/ore/from_raw',
    'mekmm:processing/silver/raw_storage_blocks/from_raw',
    'mekmm:processing/silver/raw/from_raw_block',
    'mekmm:processing/silver/shard/from_crystal',
    'mekmm:processing/silver/shard/from_ore',
    'mekmm:processing/silver/shard/from_raw_block',
    'mekmm:processing/silver/shard/from_raw_ore',
    'mekmm:processing/silver/slurry/clean',
    'mekmm:processing/silver/slurry/dirty/from_ore',
    'mekmm:processing/silver/slurry/dirty/from_raw_block',
    'mekmm:processing/silver/slurry/dirty/from_raw_ore',
    'mekmm:processing/silver/storage_blocks/from_ingots',

    // xycraft_machines
    'xycraft_machines:compat/mek/processing/aluminum/clump/from_ore',
    'xycraft_machines:compat/mek/processing/aluminum/clump/from_raw_block',
    'xycraft_machines:compat/mek/processing/aluminum/clump/from_raw_ore',
    'xycraft_machines:compat/mek/processing/aluminum/clump/from_shard',
    'xycraft_machines:compat/mek/processing/aluminum/crystal/from_slurry',
    'xycraft_machines:compat/mek/processing/aluminum/dirty_dust/from_clump',
    'xycraft_machines:compat/mek/processing/aluminum/dust/from_dirty_dust',
    'xycraft_machines:compat/mek/processing/aluminum/dust/from_ingot',
    'xycraft_machines:compat/mek/processing/aluminum/dust/from_ore',
    'xycraft_machines:compat/mek/processing/aluminum/dust/from_raw_block',
    'xycraft_machines:compat/mek/processing/aluminum/dust/from_raw_ore',
    'xycraft_machines:compat/mek/processing/aluminum/ingot/from_dust_blasting',
    'xycraft_machines:compat/mek/processing/aluminum/ingot/from_dust_smelting',
    'xycraft_machines:compat/mek/processing/aluminum/ore/deepslate_from_raw',
    'xycraft_machines:compat/mek/processing/aluminum/ore/from_raw',
    'xycraft_machines:compat/mek/processing/aluminum/shard/from_crystal',
    'xycraft_machines:compat/mek/processing/aluminum/shard/from_ore',
    'xycraft_machines:compat/mek/processing/aluminum/shard/from_raw_block',
    'xycraft_machines:compat/mek/processing/aluminum/shard/from_raw_ore',
    'xycraft_machines:compat/mek/processing/aluminum/slurry/clean',
    'xycraft_machines:compat/mek/processing/aluminum/slurry/dirty/from_ore',
    'xycraft_machines:compat/mek/processing/aluminum/slurry/dirty/from_raw_block',
    'xycraft_machines:compat/mek/processing/aluminum/slurry/dirty/from_raw_ore'
]

// Obsolete crop and bee integrations for removed materials
const removedMaterialIntegrationRecipes = [
    // mysticalagriculture
    'mysticalagriculture:seed/reprocessor/enderium',
    'mysticalagriculture:seed/reprocessor/iridium',
    'mysticalagriculture:seed/reprocessor/lumium',
    'mysticalagriculture:seed/reprocessor/peridot',
    'mysticalagriculture:seed/reprocessor/ruby',
    'mysticalagriculture:seed/reprocessor/sapphire',
    'mysticalagriculture:seed/reprocessor/signalum',

    // productivebees
    'productivebees:bee_breeding/alloys/enderium_bee',
    'productivebees:bee_breeding/alloys/enderium_bee_platinum',
    'productivebees:bee_breeding/alloys/lumium_bee',
    'productivebees:bee_breeding/alloys/signalum_bee',
    'productivebees:bee_breeding/gems/cinnabar_bee',
    'productivebees:bee_breeding/raw_materials/iridium_bee',
    'productivebees:bee_conversion/gems/green_sapphire_bee',
    'productivebees:bee_conversion/gems/peridot_bee',
    'productivebees:bee_conversion/gems/ruby_bee',
    'productivebees:bee_conversion/gems/sapphire_bee',
    'productivebees:bee_produce/alloys/enderium_bee',
    'productivebees:bee_produce/alloys/lumium_bee',
    'productivebees:bee_produce/alloys/signalum_bee',
    'productivebees:bee_produce/gems/cinnabar_bee',
    'productivebees:bee_produce/gems/green_sapphire_bee',
    'productivebees:bee_produce/gems/peridot_bee',
    'productivebees:bee_produce/gems/ruby_bee',
    'productivebees:bee_produce/gems/sapphire_bee',
    'productivebees:bee_produce/raw_materials/iridium_bee',
    'productivebees:centrifuge/gems/honeycomb_green_sapphire'
]

// Removes extra Coke Dust recipes, forcing the use of the IE Crusher
const removedCokeDustRecipes = [
    'create:crushing/compat/immersiveengineering/coal_coke',
    'create:crushing/compat/immersiveengineering/coke_block',
    'occultism:crushing/coal_coke_dust'
]

ServerEvents.recipes(event => {
    // AE2 and silicon progression
    event.remove({ id: 'mekanism:compat/ae2/sand_to_silicon' })
    // StoneWork Factory: keep cobblestone -> gravel -> sand, but stop sand -> silicon
    event.remove({ id: 'industrialforegoing:crusher/sand' })
    // Remove unnecessary silicon block stuff
    // Removes silicon block shortcuts
    event.remove({ id: 'extendedae:silicon_decompress' })
    event.remove({ id: 'oritech:silicon_blockblockinv' })
    event.remove({ id: 'extendedae:quartz_blend' })
    event.remove({ id: 'extendedae:quartz_blend_alt' })
    // Adds the Certus-based Quartz Blend recipe
    event.custom({
        type: 'minecraft:crafting_shapeless',
        category: 'misc',
        ingredients: [
            { item: 'ae2:certus_quartz_dust' },
            [{ item: 'minecraft:coal' }, { item: 'minecraft:charcoal' }],
            [{ item: 'minecraft:coal' }, { item: 'minecraft:charcoal' }],
            { tag: 'c:sands' },
            { tag: 'c:sands' },
            { tag: 'c:sands' },
            { tag: 'c:sands' },
            { tag: 'c:sands' },
            { tag: 'c:sands' }
        ],
        result: { id: 'extendedae:quartz_blend', count: 6 }
    }).id('extendedae:quartz_blend')
    event.remove({ id: 'appliedpneumatics:amadron/emerald_to_certus_quartz_crystal' })
    event.remove({ id: 'appliedpneumatics:amadron/emerald_to_sky_stone_block' })
    // Requires Certus for the Charger
    event.remove({ id: 'ae2:network/blocks/crystal_processing_charger' })
    event.custom({
        type: 'minecraft:crafting_shaped',
        category: 'misc',
        pattern: ['aba', 'ac ', 'aba'],
        key: {
            a: { tag: 'c:ingots/iron' },
            b: { tag: 'c:ingots/copper' },
            c: { item: 'ae2:certus_quartz_crystal' }
        },
        result: { id: 'ae2:charger', count: 1 }
    }).id('ae2:network/blocks/crystal_processing_charger')

    // Uses Mekanism Nether Quartz Dust
    event.remove({ id: 'ae2cs:pulverizer/nether_quartz_dust' })
    event.custom({
        type: 'ae2cs:crystal_pulverizer_recipe_serializer',
        energy_cost: 8000,
        input: { count: 1, tag: 'c:gems/quartz' },
        result: { count: 1, id: 'mekanism:dust_quartz' }
    }).id('ae2cs:pulverizer/nether_quartz_dust')

    // Other progression recipe modifications
    // Replaces breeding with quartz-block conversion
    event.remove({ id: 'productivebees:bee_breeding/appliedenergistics2/spacial_bee' })
    event.custom({
        type: 'productivebees:bee_conversion',
        source: 'productivebees:crystalline',
        result: 'productivebees:spacial',
        item: { item: 'ae2:quartz_block' }
    }).id('productivebees:bee_conversion/appliedenergistics2/spacial_bee_lunar')

    // Final recipe-removal operations
    // Preserve this order, including uranium cleanup before Rainbow Sugar removal
    event.remove({ id: 'nep:import_card' })

    removedAllTheOresRecipes.forEach(id => {
        event.remove({ id: id })
    })

    event.remove({ id: 'create:pressing/compat/immersiveengineering/plate_steel' })

    cleanUpUraniumAndYellorium(event)

    // Removes the recipe without hiding the item
    event.remove({ id: 'antarchy:rainbow_sugar' })

    removedMarvelTitaniumRecipes.forEach(id => {
        event.remove({ id: id })
    })

    removedIceAndFireSapphireRecipes.forEach(id => {
        event.remove({ id: id })
    })

    removedEvolvedMekanismUraniumRecipes.forEach(id => {
        event.remove({ id: id })
    })

    antarchyDuplicateOreRecipeIds.forEach(id => {
        event.remove({ id: id })
    })

    removedMaterialIntegrationRecipes.forEach(id => {
        event.remove({ id: id })
    })

    // Keeps IE Crusher recipes and Coke Dust uses
    removedCokeDustRecipes.forEach(id => {
        event.remove({ id: id })
    })
})
