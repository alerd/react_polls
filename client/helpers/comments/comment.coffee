Template.comment.helpers
  ownCommentAndIsLatest: ->
    @userId is Meteor.userId() and not Comments.findOne submitted:
      $gt: @submitted


Template.comment.events
  'click .delete': (e) ->
    do e.preventDefault

    Meteor.call 'remove', @, (error) ->
      throwError error.reason if error