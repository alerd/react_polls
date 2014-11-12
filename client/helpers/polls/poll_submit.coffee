Template.pollSubmit.events
  'submit form': (e) ->
    do e.preventDefault

    poll =
      url: $(e.target).find('[name=url]').val(),
      title: $(e.target).find('[name=title]').val(),
      message: $(e.target).find('[name=message]').val()

    Meteor.call 'poll', poll, (error, id) ->
      if error
        throwError error.reason
      else
        Router.go 'pollPage', _id: id
