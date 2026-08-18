// Hide unused Ice and Fire Sapphire stuff.

const retiredIceAndFireSapphireItems = [
    'iceandfire:sapphire_ore',
    'iceandfire:sapphire_gem',
    'iceandfire:sapphire_block'
]

RecipeViewerEvents.removeEntriesCompletely('item', event => {
    retiredIceAndFireSapphireItems.forEach(id => {
        event.remove(id)
    })
})
