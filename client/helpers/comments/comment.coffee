Template.comment.helpers
  submittedText: ->
    new Date(@submitted).toString()
  ownCommentAndIsLatest: ->
    @userId is Meteor.userId() and not Comments.findOne submitted:
      $gt: @submitted


Template.comment.events
  'click .delete': (e) ->
    do e.preventDefault

    if confirm 'Remove this comment?'
      Meteor.call 'remove', @, (error) ->
        throwError error.reason if error