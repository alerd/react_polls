Template.postEdit.events
  'submit form': (e) ->
    do e.preventDefault
    currentPostId = @_id;
    postProperties =
      url: $(e.target).find('[name=url]').val(),
      title: $(e.target).find('[name=title]').val()

    Posts.update currentPostId, $set: postProperties, (error) ->
      if error
        throwError error.reason
      else
        Router.go 'postPage', _id: currentPostId


  'click .delete': (e) ->
    do e.preventDefault

    Posts.remove @_id, (error) ->
      if error
        throwError error.reason
    Router.go 'home'