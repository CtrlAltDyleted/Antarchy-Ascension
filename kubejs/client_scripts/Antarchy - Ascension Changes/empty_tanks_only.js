// Only show empty fluid and chemical tanks in jei.

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
