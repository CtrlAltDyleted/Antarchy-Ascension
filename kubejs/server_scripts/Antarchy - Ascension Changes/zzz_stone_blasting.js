// priority: -200
// Preserve Wishful's stonecuttable-item blasting without interpreting compressed
// raw ores as stone. Raw-metal blocks have explicit 45s/90s pack recipes instead.
ServerEvents.recipes(event => {
    var config = JSON.parse(JsonIO.readString('config/wishfulrecipes.json'));
    var cuttable = {};
    var existing = {};
    var candidates = {};
    // Caches the ingredient item lists
    var cachedInputs = {};

    function itemIds(input) {
        var key = JSON.stringify(input);
        if (cachedInputs[key] !== undefined) return cachedInputs[key];
        var ids = [];
        // Gets ingredient stacks through KubeJS
        var stacks = Ingredient.of(input).getStackArray();
        for (var i = 0; i < stacks.length; i++) {
            var id = String(stacks[i].getId());
            if (ids.indexOf(id) === -1) ids.push(id);
        }
        ids.sort();
        cachedInputs[key] = ids;
        return ids;
    }

    function resultKey(data) {
        var result = data.result;
        if (!result || !(result.id || result.item)) return null;
        return JSON.stringify([result.id || result.item,
            result.count === undefined ? 1 : result.count, result.components || {}]);
    }

    function recipeKey(data) {
        // Keeps custom ingredient restrictions in the recipe key
        var predicate = data.ingredient.type ? JSON.stringify(data.ingredient) : '';
        return JSON.stringify(itemIds(data.ingredient)) + '|' + predicate + '|' + resultKey(data);
    }

    event.forEachRecipe({ type: 'minecraft:stonecutting' }, recipe => {
        var data = JSON.parse(recipe.json.toString());
        itemIds(data.ingredient).forEach(id => { cuttable[id] = true; });
    });
    event.forEachRecipe({ type: 'minecraft:blasting' }, recipe => {
        var data = JSON.parse(recipe.json.toString());
        if (resultKey(data) !== null) existing[recipeKey(data)] = true;
    });

    // Deimos can insert these configured recipes after the KubeJS event. Reserve
    // their keys too so the replacement does not duplicate Wishful's explicit list.
    if (config.extra_blasting_enable) {
        config.extra_blasting_list.forEach(value => {
            var fields = String(value).replace(/\s/g, '').split(',');
            var input = fields[0].indexOf('#') === 0 ? { tag: fields[0].substring(1) } : { item: fields[0] };
            existing[recipeKey({ ingredient: input, result: { id: fields[1], count: 1 } })] = true;
        });
    }
    if (config.blast_to_glass_enable) {
        existing[recipeKey({ ingredient: { tag: 'minecraft:smelts_to_glass' },
            result: { id: 'minecraft:glass', count: 1 } })] = true;
    }

    event.forEachRecipe({ type: 'minecraft:smelting' }, recipe => {
        var data = JSON.parse(recipe.json.toString());
        if (resultKey(data) === null) return;
        var ids = itemIds(data.ingredient);
        if (ids.length === 0) return;
        // Check both shared tags and expanded items, including the pack's dense
        // uranium and mod-specific raw blocks. Never infer a five-second batch.
        if (data.ingredient.tag && data.ingredient.tag.indexOf('c:storage_blocks/raw_') === 0) return;
        if (ids.some(id => /:(raw_.+_block|block_raw_.+)$/.test(id))) return;
        var output = data.result.id || data.result.item;
        if (!cuttable[output] && !ids.some(id => cuttable[id])) return;
        if (config.blast_to_glass_enable && output === 'minecraft:glass') return;
        var key = recipeKey(data);
        if (existing[key]) return;
        data.type = 'minecraft:blasting';
        data.category = 'misc';
        // Sets the cooking time to five seconds
        data.cookingtime = 100;
        var previous = candidates[key];
        if (!previous) {
            candidates[key] = { id: String(recipe.id), data: data };
        } else if ((data.experience || 0) > (previous.data.experience || 0)) {
            previous.data.experience = data.experience;
        }
    });
    // Adds the generated recipes in a stable order
    Object.keys(candidates).sort().forEach(key => {
        var candidate = candidates[key];
        var source = candidate.id.replace(':', '/');
        event.custom(candidate.data).id('antarchyascension:stone_blasting/' + source);
    });
});
