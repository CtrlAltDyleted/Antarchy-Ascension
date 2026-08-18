ServerEvents.recipes(event => {
  // scrap only gives dense uranium now
  const obsoleteAntarchyScrapRecipes = [
    'antarchy:uranium/raw_uranium_from_scrap',
    'antarchy:uranium/uranium_nugget_from_raw_uranium_scrap_smelting',
    'antarchy:uranium/uranium_nugget_from_raw_uranium_scrap_blasting'
  ]

  obsoleteAntarchyScrapRecipes.forEach(id => {
    event.remove({ id: id })
  })

  // these are the Antarchy recipes that actually need dense uranium
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
      'antarchy_ascension_companion:dense_uranium_ingot'
    )
  })

  event.replaceInput(
    { id: 'antarchy:attitude_adjuster' },
    'antarchy:uranium_block',
    'antarchy_ascension_companion:dense_uranium_block'
  )

  event.replaceInput(
    { id: 'antarchy:rainbow_sugar' },
    'antarchy:uranium_nugget',
    'antarchy_ascension_companion:dense_uranium_nugget'
  )

  // Extreme Reactors still hardcodes yellorium in these
  const fluidizerMachineRecipes = [
    'bigreactors:fluidizer/casing',
    'bigreactors:fluidizer/controller',
    'bigreactors:fluidizer/solidinjector'
  ]

  fluidizerMachineRecipes.forEach(id => {
    event.replaceInput(
      { id: id },
      '#c:ingots/yellorium',
      '#c:ingots/uranium'
    )
  })

  // remove the old solid yellorium recipes. the fluid stays.
  const retiredYelloriumRecipeIds = [
    // Extreme Reactors
    'bigreactors:blasting/yellorium_from_ore',
    'bigreactors:blasting/yellorium_from_raw',
    'bigreactors:smelting/yellorium_from_ore',
    'bigreactors:smelting/yellorium_from_raw',

    'bigreactors:crafting/raw_yellorium_component_to_storage',
    'bigreactors:crafting/raw_yellorium_storage_to_component',
    'bigreactors:crafting/yellorium_component_to_storage',
    'bigreactors:crafting/yellorium_storage_to_component',

    // reactor recipes that already have uranium versions
    'bigreactors:reactor/basic/controller_ingots_yellorium',
    'bigreactors:reactor/basic/fuelrod_ingots_yellorium',
    'bigreactors:reactor/reinforced/controller_ingots_yellorium',
    'bigreactors:reactor/reinforced/fuelrod_alt_ingots_yellorium',
    'bigreactors:reactor/reinforced/fuelrod_ingots_yellorium',

    'bigreactors:misc/book/erguide',

    // other mods that can still make yellorium
    'industrialforegoing:laser_drill_ore/ores/yellorite',
    'industrialforegoing:laser_drill_ore/raw_materials/yellorite',
    'industrialforegoing:laser_drill_ore/raw_materials/yellorium',
    'occultism:miner/eldritch/raw_yellorium',

    // yellorium crop stuff
    'mysticalagriculture:essence/extremereactors2/yellorium_ingot',
    'mysticalagriculture:seed/crafting/yellorium',
    'mysticalagriculture:seed/infusion/yellorium',
    'mysticalagriculture:seed/reprocessor/yellorium',
    'botanypots:mysticalagriculture/crop/yellorium_seeds',
    'mysticalengineering:cloche_yellorium_seed',
    'mekmm:compat/mysticalagriculture/yellorium',

    // old thermal compat
    'thermal:machine/pulverizer_yellorite_ore_to_dust',
    'thermal:machine/pulverizer_yellorium_ingot_to_dust'
  ]

  retiredYelloriumRecipeIds.forEach(id => {
    event.remove({ id: id })
  })

  // catch anything else that still spits out one of the old items
  const retiredSolidOutputs = [
    'bigreactors:yellorite_ore',
    'bigreactors:deepslate_yellorite_ore',
    'bigreactors:raw_yellorium',
    'bigreactors:raw_yellorium_block',
    'bigreactors:yellorium_ingot',
    'bigreactors:yellorium_block',
    'mysticalagriculture:yellorium_seeds',
    'mysticalagriculture:yellorium_essence'
  ]

  retiredSolidOutputs.forEach(output => {
    event.remove({ output: output })
  })
})
