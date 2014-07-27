module.exports = App.Router.map ->
  @route('home', path: '/')
  @route('sign-in')

  @resource('plates', path: '/plates', ->
    @route('new')
  )

  @resource('plate', path: '/plates/:plate_id', ->
    @route('edit')
    @resource('link', path: '/link/:link_id')
  )

  # temporary -- for ethan
  @resource('templates', ->
    @route('plates')
    @route('plate')
    @route('link')
    @route('sign-in')
  )
