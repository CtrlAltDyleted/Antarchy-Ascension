const compactMachineRooms = [
    ['tiny',     '3x3x3'],
    ['small',    '5x5x5'],
    ['normal',   '7x7x7'],
    ['large',    '9x9x9'],
    ['giant',    '11x11x11'],
    ['colossal', '13x13x13'],
    ['farming',  '21x11x21'],
    ['soaryn',   '45x45x45']
]

ItemEvents.modifyTooltips(event => {
    compactMachineRooms.forEach(([template, size]) => {
        const machine = `compactmachines:new_machine[compactmachines:room_template="compactmachines:${template}"]`

        // Remove "New Machine" and replace it with the dimensions.

        event.modify(machine, { shift: false }, tooltip => {
            tooltip.removeLine(1)
            tooltip.insert(1, Text.gray(`Internal Size: ${size}`))
        })

        // Remove the tooltip when holding shift, since the tooltip is already displayed.

        event.modify(machine, { shift: true }, tooltip => {
            tooltip.removeLine(1) // New Machine
            tooltip.removeLine(1) // Size
            tooltip.removeLine(1) // compactmachines:tiny/etc.

            tooltip.insert(1, Text.gray(`Internal Size: ${size}`))
        })
    })
})
