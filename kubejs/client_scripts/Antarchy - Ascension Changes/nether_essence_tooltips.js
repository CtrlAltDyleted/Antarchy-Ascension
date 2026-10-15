ItemEvents.modifyTooltips(event => {
    const items = [
        'nether_remastered:bottled_nether_essence'
    ];

    items.forEach(item => {
        event.modify(item, tooltip => {
            tooltip.add(Text.yellow('Defeat a Zombie or Skeleton while holding'));
            tooltip.add(Text.yellow('an empty Obsidian Infused Bottle in your offhand.'));
        });
    });
});
