// Fix the Create Steel pressing recipe

ServerEvents.recipes(event => {
  event.remove({ id: 'create:pressing/steel_ingot' })

  event.custom({
    type: 'create:pressing',
    ingredients: [
      {
        tag: 'c:ingots/steel'
      }
    ],
    results: [
      {
        id: 'alltheores:steel_plate'
      }
    ]
  }).id('create:pressing/steel_ingot')
})
