RecipeViewerEvents.removeEntriesCompletely('item', event => {
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

  hiddenYelloriumItems.forEach(id => {
    event.remove(id)
  })
})
