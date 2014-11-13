@PollPageController = RouteController.extend
  waitOn: ->
    Meteor.subscribe 'comments', @params._id
    Meteor.subscribe 'polls', _id: @params._id
    Meteor.subscribe 'pollActivities',
      pollId: @params._id
    ,
      sort:
        submitted: -1
      limit: 7

  data: ->
    Polls.findOne @params._id
