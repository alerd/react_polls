Template.pollSubmit.events
  'submit form': (e) ->
    do e.preventDefault

    poll =
      title: $(e.target).find('[name=title]').val()
      message: $(e.target).find('[name=message]').val()

    pollOptions = $('input[name^=options]').map (idx, elem) ->
      $(elem).val()
    .get()

    if pollOptions.length isnt _.compact(pollOptions).length
      throwError "found empty options"
      return


    Meteor.call 'post', poll, (error, id) ->
      if error
        throwError error.reason
      else
        for pollOption in pollOptions
          PollOptions.insert
            pollId: id
            color: randomColor()
            label: pollOption
            votedUsers: []
            value: 0
        Router.go 'pollPage', _id: id




