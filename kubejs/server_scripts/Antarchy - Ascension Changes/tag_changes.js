// Removes AllTheOres Ancient Stone ore variants
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

ServerEvents.tags('item', event => {
    // Keeps gliders in the dedicated Elytra slot
    const ornithopterGliders = [
        "createornithopterglider:ornithopterglider",
        "createornithopterglider:ornithopterglider_black",
        "createornithopterglider:ornithopterglider_blue",
        "createornithopterglider:ornithopterglider_brown",
        "createornithopterglider:ornithopterglider_cyan",
        "createornithopterglider:ornithopterglider_gray",
        "createornithopterglider:ornithopterglider_green",
        "createornithopterglider:ornithopterglider_light_blue",
        "createornithopterglider:ornithopterglider_light_gray",
        "createornithopterglider:ornithopterglider_lime",
        "createornithopterglider:ornithopterglider_magenta",
        "createornithopterglider:ornithopterglider_orange",
        "createornithopterglider:ornithopterglider_pink",
        "createornithopterglider:ornithopterglider_purple",
        "createornithopterglider:ornithopterglider_red",
        "createornithopterglider:ornithopterglider_yellow"
    ]
    ornithopterGliders.forEach(id => {
        event.remove('curios:back', id)
        event.remove('curios:curio', id)
    })
    const oxygenTanks = [
        'ad_astra_giselle_addon:oxygen_can',
        'ad_astra_giselle_addon:netherite_oxygen_can',
        'ad_astra_giselle_addon:creative_oxygen_can'
    ]
    // Removes generic-slot access for oxygen tanks
    oxygenTanks.forEach(id => event.remove('curios:curio', id))

    const engineeringGoggles = [
        'create:goggles',
        'actuallyadditions:engineers_goggles',
        'actuallyadditions:engineers_goggles_advanced',
        'occultengineering:combined_goggles'
    ]
    // Moves goggles to their dedicated slot
    engineeringGoggles.forEach(id => {
        event.remove('curios:head', id)
        event.add('curios:engineers_goggles', id)
    })

    removedAllTheOresOtherOres.forEach(id => {
        event.removeAllTagsFrom(id)
    })

})

// Removes the removed ores' block tags
ServerEvents.tags('block', event => {
    removedAllTheOresOtherOres.forEach(id => {
        event.removeAllTagsFrom(id)
    })
})
