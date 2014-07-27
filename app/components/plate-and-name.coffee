module.exports = App.PlateAndNameComponent = Ember.Component.extend
  isEditable: false
  showName: true

  setupListeners: (->
    @$('.plate-image').on('click', =>
      @get('plate').randomizeColorsAndName() if @get('isEditable')
    )
  ).on('didInsertElement')

  destroyListeners: (->
    @$('.plate-image').off('click')
  ).on('willDestroyElement')

  observesPlateColors: (->
    plate = @get('plate')
    return if !plate?
    { color1, color2 } = plate.getProperties('color1', 'color2')

    @$('.plate-image').find('#outer').attr('fill', color1)
    @$('.plate-image').find('#inner').attr('fill', color2)
    @$('.plate-hero--title').css(color: color1)
  ).observes('plate.color1', 'plate.color2').on('didInsertElement')
