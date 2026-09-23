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

const wirelessTerminals = [
    'ae2:wireless_terminal',
    'ae2:wireless_crafting_terminal',
    'ae2wtlib:wireless_pattern_access_terminal',
    'ae2wtlib:wireless_pattern_encoding_terminal',
    'ae2wtlib:wireless_universal_terminal',
    'advanced_ae:wireless_quantum_crafter_terminal',
    'ae2driveterminal:wireless_drive_terminal'
]

ServerEvents.tags('item', event => {
    removedAllTheOresOtherOres.forEach(id => {
        event.removeAllTagsFrom(id)
    })

    // Engineer's Goggles Head Slot Removals
    event.remove('curios:head', [
        'create:goggles',
        'actuallyadditions:engineers_goggles',
        'actuallyadditions:engineers_goggles_advanced',
        'occultengineering:combined_goggles'
    ])

    // Wireless Terminal Curios Tag Correction
    event.remove('curios:curio', wirelessTerminals)
    event.add('curios:wireless_terminal', wirelessTerminals)
})

ServerEvents.tags('block', event => {
    removedAllTheOresOtherOres.forEach(id => {
        event.removeAllTagsFrom(id)
    })
})
