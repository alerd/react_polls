Template.commentSubmit.events
  'submit form': (e, template) ->
    do e.preventDefault

    $body = $(e.target).find('[name=body]')
    comment =
      body: $body.val(),
      postId: template.data._id

    Meteor.call 'comment', comment, (error) ->
      if error
        throwError error.reason
      else
        $body.val ''