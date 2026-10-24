// Remove floating-point serialization noise without changing intended XP values.
ServerEvents.recipes(event => {
    const fixes = [];
    ['minecraft:smelting', 'minecraft:blasting', 'minecraft:smoking', 'minecraft:campfire_cooking'].forEach(type => {
        event.forEachRecipe({ type: type }, recipe => {
            const data = JSON.parse(recipe.json.toString());
            if (typeof data.experience !== 'number') return;
            // Rounds small XP serialization errors
            const clean = Math.round(data.experience * 10) / 10;
            const delta = Math.abs(data.experience - clean);
            if (delta > 0 && delta < 0.00001) {
                data.experience = clean;
                fixes.push({ id: String(recipe.id), data: data });
            }
        });
    });
    // Replaces recipes after collecting the changes
    fixes.forEach(fix => {
        event.remove({ id: fix.id });
        event.custom(fix.data).id(fix.id);
    });
});
