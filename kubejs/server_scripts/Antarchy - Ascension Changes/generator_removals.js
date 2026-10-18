// Overlapping generator removals
ServerEvents.recipes(event => {
    event.remove({ output: 'actuallyadditions:coal_generator' });
    event.remove({ output: 'integrateddynamics:coal_generator' });
    event.remove({ output: 'industrialforegoing:pitiful_generator' });
    event.remove({ output: 'zps:coal_burner' });
    event.remove({ output: 'oritech:bio_generator_block' });
});
