ServerEvents.recipes(event => {
  // Marvel titanium ore is gone, so these should be gone too
  const removedRecipes = [
    'occultism:miner/ores/titanium_ore',

    'marvel:titanium_ingot_from_smelting_titanium_ore',
    'marvel:titanium_ingot_from_smelting_deepslate_titanium_ore',
    'marvel:titanium_ingot_from_blasting_titanium_ore',
    'marvel:titanium_ingot_from_blasting_deepslate_titanium_ore'
  ]

  removedRecipes.forEach(id => {
    event.remove({ id: id })
  })
})
