Template.comment.helpers
  submittedText: ->
    new Date(@submitted).toLocaleString()
  ownCommentAndIsLatest: ->
    @userId is Meteor.userId() and not Comments.findOne submitted:
      $gt: @submitted


Template.comment.events
  'click .delete': (e) ->
    do e.preventDefault

    if confirm 'Справді видалити цей коментар?'
      Meteor.call 'remove', @, (error) ->
        throwError error.reason if error