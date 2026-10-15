// priority: -100
// Reviewed equivalent cooking/material providers. No dust priority changes.
// Run after recipe_changes.js. Check existence at runtime so optional-mod conditions
// never remove the only available provider. Antarchy recipes are excluded.
ServerEvents.recipes(event => {
    const groups = [
    [
        "alltheores:smelting/aluminum/dust_blasting",
        "xycraft_machines:compat/mek/processing/aluminum/ingot/from_dust_blasting"
    ],
    [
        "alltheores:smelting/aluminum/dust_smelting",
        "xycraft_machines:compat/mek/processing/aluminum/ingot/from_dust_smelting"
    ],
    [
        "alltheores:smelting/aluminum/raw_blasting",
        "xycraft:blasting/aluminum"
    ],
    [
        "alltheores:smelting/aluminum/raw_smelting",
        "xycraft:smelting/aluminum"
    ],
    [
        "alltheores:smelting/copper/dust_blasting",
        "occultism:blasting/copper_ingot_from_dust"
    ],
    [
        "alltheores:smelting/copper/dust_smelting",
        "occultism:smelting/copper_ingot_from_dust"
    ],
    [
        "alltheores:smelting/gold/dust_blasting",
        "occultism:blasting/gold_ingot_from_dust"
    ],
    [
        "alltheores:smelting/gold/dust_smelting",
        "occultism:smelting/gold_ingot_from_dust"
    ],
    [
        "alltheores:smelting/iron/dust_blasting",
        "occultism:blasting/iron_ingot_from_dust"
    ],
    [
        "alltheores:smelting/iron/dust_smelting",
        "occultism:smelting/iron_ingot_from_dust"
    ],
    [
        "alltheores:smelting/netherite/dust_blasting",
        "occultism:blasting/netherite_ingot_from_dust"
    ],
    [
        "alltheores:smelting/netherite/dust_smelting",
        "occultism:smelting/netherite_ingot_from_dust"
    ],
    [
        "alltheores:smelting/silver/dust_blasting",
        "occultism:blasting/silver_ingot_from_dust"
    ],
    [
        "alltheores:smelting/silver/dust_smelting",
        "occultism:smelting/silver_ingot_from_dust"
    ],
    [
        "alltheores:smelting/silver/ore_blasting",
        "occultism:blasting/silver_ingot_from_ore"
    ],
    [
        "alltheores:smelting/silver/ore_smelting",
        "occultism:smelting/silver_ingot_from_ore"
    ],
    [
        "alltheores:smelting/silver/raw_blasting",
        "occultism:blasting/silver_ingot_from_raw"
    ],
    [
        "alltheores:smelting/silver/raw_smelting",
        "occultism:smelting/silver_ingot_from_raw"
    ],
    [
        "alltheores:smelting/zinc/ore_blasting",
        "create:blasting/zinc_ingot_from_ore"
    ],
    [
        "alltheores:smelting/zinc/ore_smelting",
        "create:smelting/zinc_ingot_from_ore"
    ],
    [
        "alltheores:smelting/zinc/raw_blasting",
        "create:blasting/zinc_ingot_from_raw_ore"
    ],
    [
        "alltheores:smelting/zinc/raw_smelting",
        "create:smelting/zinc_ingot_from_raw_ore"
    ],
    [
        "create:smelting/ingot_aluminium_compat_ic2",
        "create:smelting/ingot_aluminum_compat_immersiveengineering"
    ],
    [
        "create:smelting/ingot_uranium_compat_ic2",
        "create:smelting/ingot_uranium_compat_immersiveengineering",
        "create:smelting/ingot_uranium_compat_mekanism"
    ],
    [
        "create:smelting/ingot_silver_compat_ic2",
        "create:smelting/ingot_silver_compat_immersiveengineering",
        "create:smelting/silver_ingot_compat_galosphere",
        "create:smelting/silver_ingot_compat_iceandfire",
        "create:smelting/silver_ingot_compat_oreganized",
        "create:smelting/silver_ingot_compat_thermal",
        "occultengineering:smelting/silver_ingot"
    ],
    [
        "create:smelting/ingot_lead_compat_immersiveengineering",
        "create:smelting/ingot_lead_compat_mekanism",
        "create:smelting/lead_ingot_compat_oreganized",
        "create:smelting/lead_ingot_compat_thermal"
    ],
    [
        "create:smelting/ingot_nickel_compat_immersiveengineering",
        "create:smelting/nickel_ingot_compat_thermal"
    ],
    [
        "create:smelting/ingot_tin_compat_ic2",
        "create:smelting/ingot_tin_compat_mekanism",
        "create:smelting/tin_ingot_compat_thermal"
    ],
    [
        "create:blasting/ingot_aluminium_compat_ic2",
        "create:blasting/ingot_aluminum_compat_immersiveengineering"
    ],
    [
        "create:blasting/ingot_uranium_compat_ic2",
        "create:blasting/ingot_uranium_compat_immersiveengineering",
        "create:blasting/ingot_uranium_compat_mekanism"
    ],
    [
        "create:blasting/ingot_silver_compat_ic2",
        "create:blasting/ingot_silver_compat_immersiveengineering",
        "create:blasting/silver_ingot_compat_galosphere",
        "create:blasting/silver_ingot_compat_iceandfire",
        "create:blasting/silver_ingot_compat_oreganized",
        "create:blasting/silver_ingot_compat_thermal"
    ],
    [
        "create:blasting/ingot_lead_compat_immersiveengineering",
        "create:blasting/ingot_lead_compat_mekanism",
        "create:blasting/lead_ingot_compat_oreganized",
        "create:blasting/lead_ingot_compat_thermal"
    ],
    [
        "create:blasting/ingot_nickel_compat_immersiveengineering",
        "create:blasting/nickel_ingot_compat_thermal"
    ],
    [
        "create:blasting/ingot_tin_compat_ic2",
        "create:blasting/ingot_tin_compat_mekanism",
        "create:blasting/tin_ingot_compat_thermal"
    ],
    [
        "alltheores:crafting/brass/block_from_ingot",
        "create:crafting/materials/brass_block_from_compacting"
    ],
    [
        "alltheores:crafting/steel/block_from_ingot",
        "ad_astra:steel_block"
    ],
    [
        "alltheores:crafting/steel/ingot_from_nugget",
        "ad_astra:steel_ingot"
    ],
    [
        "alltheores:crafting/brass/ingot_from_block",
        "create:crafting/materials/brass_ingot_from_decompacting"
    ],
    [
        "alltheores:crafting/brass/ingot_from_nugget",
        "create:crafting/materials/brass_ingot_from_compacting"
    ],
    [
        "alltheores:crafting/brass/nugget_from_ingot",
        "create:crafting/materials/brass_nugget_from_decompacting"
    ],
    [
        "alltheores:crafting/copper/nugget_from_ingot",
        "create:crafting/materials/copper_nugget",
        "twilightforest:copper_ingot_to_nuggets",
        "immersiveengineering:crafting/copper_ingot_to_nugget_copper",
        "iceandfire:copper_ingot_to_nuggets",
        "pneumaticcraft:copper_nugget",
        "xycraft:unpacking/copper_nugget",
        "zps:copper_nugget"
    ],
    [
        "alltheores:crafting/silver/block_from_ingot",
        "occultism:crafting/silver_block"
    ],
    [
        "alltheores:crafting/silver/ingot_from_block",
        "occultism:crafting/silver_ingot_from_block"
    ],
    [
        "alltheores:crafting/silver/ingot_from_nugget",
        "occultism:crafting/silver_ingot_from_nuggets"
    ],
    [
        "alltheores:crafting/silver/nugget_from_ingot",
        "occultism:crafting/silver_nugget"
    ],
    [
        "alltheores:crafting/silver/raw_block_from_raw",
        "occultism:crafting/raw_silver_ingot_from_block"
    ],
    [
        "alltheores:crafting/silver/raw_from_raw_block",
        "occultism:crafting/raw_silver_block"
    ],
    [
        "alltheores:crafting/zinc/block_from_ingot",
        "create:crafting/materials/zinc_block_from_compacting"
    ],
    [
        "alltheores:crafting/zinc/ingot_from_block",
        "create:crafting/materials/zinc_ingot_from_decompacting"
    ],
    [
        "alltheores:crafting/zinc/ingot_from_nugget",
        "create:crafting/materials/zinc_ingot_from_compacting"
    ],
    [
        "alltheores:crafting/zinc/nugget_from_ingot",
        "create:crafting/materials/zinc_nugget_from_decompacting"
    ],
    [
        "immersiveengineering:crafting/netherite_ingot_to_nugget_netherite",
        "createdeco:netherite_nugget_from_netherite_ingot"
    ],
    [
        "alltheores:crafting/copper/ingot_from_nugget",
        "create:crafting/materials/copper_ingot",
        "iceandfire:copper_nuggets_to_ingot",
        "twilightforest:copper_nuggets_to_ingot"
    ],
    [
        "alltheores:smelting/brass/dust_smelting",
        "occultengineering:smelting/brass_ingot_from_crushed"
    ],
    [
        "alltheores:smelting/brass/dust_blasting",
        "occultengineering:blasting/brass_ingot_from_crushed"
    ],
    [
        "alltheores:smelting/zinc/dust_smelting",
        "occultengineering:smelting/zinc_ingot_from_crushed"
    ],
    [
        "alltheores:smelting/zinc/dust_blasting",
        "occultengineering:blasting/zinc_ingot_from_crushed"
    ]
];
    // Existing AU-equivalent metal outputs only. Pet food nuggets are deliberately
    // absent: sharing an input does not make a different output interchangeable.
    const equivalentOutputs = [
        ['alltheores:aluminum_ingot', 'xycraft_world:aluminum_ingot', 'immersiveengineering:ingot_aluminum'],
        ['alltheores:brass_ingot', 'create:brass_ingot'],
        ['alltheores:brass_block', 'create:brass_block'],
        ['alltheores:brass_nugget', 'create:brass_nugget'],
        ['alltheores:steel_ingot', 'ad_astra:steel_ingot'],
        ['alltheores:steel_block', 'ad_astra:steel_block'],
        ['alltheores:silver_ingot', 'occultism:silver_ingot', 'immersiveengineering:ingot_silver', 'iceandfire:silver_ingot'],
        ['alltheores:silver_block', 'occultism:silver_block'],
        ['alltheores:silver_nugget', 'occultism:silver_nugget'],
        ['alltheores:raw_silver', 'occultism:raw_silver'],
        ['alltheores:raw_silver_block', 'occultism:raw_silver_block'],
        ['alltheores:zinc_ingot', 'create:zinc_ingot'],
        ['alltheores:zinc_block', 'create:zinc_block'],
        ['alltheores:zinc_nugget', 'create:zinc_nugget'],
        ['alltheores:copper_nugget', 'create:copper_nugget', 'twilightforest:copper_nugget', 'immersiveengineering:nugget_copper', 'iceandfire:copper_nugget', 'pneumaticcraft:copper_nugget', 'xycraft_machines:copper_nugget', 'zps:copper_nugget'],
        ['immersiveengineering:nugget_netherite', 'createdeco:netherite_nugget'],
        ['alltheores:lead_ingot', 'mekanism:ingot_lead', 'immersiveengineering:ingot_lead'],
        ['alltheores:nickel_ingot', 'immersiveengineering:ingot_nickel'],
        ['alltheores:tin_ingot', 'mekanism:ingot_tin'],
        ['alltheores:uranium_ingot', 'mekanism:ingot_uranium', 'immersiveengineering:ingot_uranium']
    ];
    function outputKey(data) {
        const out = data.result || data.output;
        if (!out || typeof out !== 'object' || Array.isArray(out)) return null;
        let id = out.id || out.item;
        if (!id) return null;
        equivalentOutputs.forEach(set => { if (set.indexOf(id) !== -1) id = set[0]; });
        return JSON.stringify([id, out.count === undefined ? 1 : out.count, out.components || {}]);
    }
    groups.forEach(ids => {
        const present = [];
        ids.forEach(id => event.forEachRecipe({ id: id }, recipe => {
            present.push({ id: id, data: JSON.parse(recipe.json.toString()) });
        }));
        if (present.length < 2) return;
        const winner = present[0];
        const winnerKey = outputKey(winner.data);
        if (winnerKey === null) return;
        const duplicates = present.slice(1).filter(entry => outputKey(entry.data) === winnerKey);
        if (duplicates.length === 0) return;
        // Match AU's existing HigherRule for cooking time/XP rather than changing
        // the balance as a side effect of selecting one redundant provider.
        const isCooking = [
            'minecraft:smelting', 'minecraft:blasting',
            'minecraft:smoking', 'minecraft:campfire_cooking'
        ].indexOf(winner.data.type) !== -1;
        if (isCooking) {
            // Rhino reuses the block's const binding across these callback calls.
            // A function-scoped variable avoids a redeclaration on the next group.
            var cookingBeforeMerge = JSON.stringify(winner.data);
            duplicates.forEach(entry => {
                ['cookingtime', 'experience'].forEach(field => {
                    if (typeof entry.data[field] === 'number' &&
                        (winner.data[field] === undefined || entry.data[field] > winner.data[field])) {
                        winner.data[field] = entry.data[field];
                    }
                });
            });
            if (JSON.stringify(winner.data) !== cookingBeforeMerge) {
                event.remove({ id: winner.id });
                event.custom(winner.data).id(winner.id);
            }
        }
        duplicates.forEach(entry => {
            event.remove({ id: entry.id });
        });
    });
});
