// Remove unused Ice and Fire Sapphire stuff.

const retiredIceAndFireSapphireRecipes = [
    'iceandfire:sapphire_block_to_sapphire_gem',
    'iceandfire:sapphire_gem_to_sapphire_block',
    'iceandfire:furnace/sapphire',
    'iceandfire:furnace/sapphire_blasting'
]

ServerEvents.recipes(event => {
    retiredIceAndFireSapphireRecipes.forEach(id => {
        event.remove({ id: id })
    })
})
