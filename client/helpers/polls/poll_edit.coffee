Template.pollEdit.events
  'submit form': (e) ->
    do e.preventDefault
    currentPollId = @_id;
    pollProperties =
      title: $(e.target).find('[name=title]').val()
      message: $(e.target).find('[name=message]').val()


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