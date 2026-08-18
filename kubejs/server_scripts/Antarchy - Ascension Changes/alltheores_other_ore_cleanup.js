// Remove unused Ancient Stone ore variants.

const retiredAllTheOresOtherOres = [
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
    retiredAllTheOresOtherOres.forEach(id => {
        event.removeAllTagsFrom(id)
    })
})

ServerEvents.tags('block', event => {
    retiredAllTheOresOtherOres.forEach(id => {
        event.removeAllTagsFrom(id)
    })
})