Template.pollEdit.events
  'submit form': (e) ->
    do e.preventDefault
    currentPollId = @_id;
    pollProperties =
      url: $(e.target).find('[name=url]').val(),
      title: $(e.target).find('[name=title]').val()

    Polls.update currentPollId, $set: pollProperties, (error) ->
      if error
        throwError error.reason
      else
        Router.go 'pollPage', _id: currentPollId


  'click .delete': (e) ->
    do e.preventDefault

    Polls.remove @_id, (error) ->
      if error
        throwError error.reason
    Router.go 'home'