RecipeViewerEvents.removeEntriesCompletely('item', event => {
  // these uranium ores don't generate anymore
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

  hiddenUraniumOres.forEach(id => {
    event.remove(id)
  })
})
