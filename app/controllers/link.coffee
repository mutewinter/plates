module.exports = App.LinkController = Ember.ObjectController.extend
  setupComment: (->
    return unless @get('model')
    @resetComment()
  ).on('init').observes('model')

  resetComment: ->
    @set('comment', @get('store').createRecord('comment'))

  commentsWithUser: (->
    @get('comments').map (comment) =>
      if comment.get('user.id') is @get('session.user.id')
        comment.set('isMe', true)
      comment
  ).property('comments.@each', 'session.user.id')

  actions:
    addComment: ->
      comment = @get('comment')
      link = @get('model')
      return @resetComment() if @get('comment.isEmpty')
      comment.set('user', @get('session.user'))
      link.get('comments').pushObject(comment)
      link.save().then => @resetComment()
