Meteor.publish 'polls', (criteria, projection)->
  Polls.find criteria, projection

Meteor.publish 'userPolls', (criteria, projection)->
  Polls.find _.extend(criteria, userId: @userId), projection

Meteor.publish 'pollOptions', (pollId) ->
  PollOptions.find pollId: pollId

Meteor.publish 'comments', (pollId) ->
  Comments.find pollId: pollId

Meteor.publish 'notifications', ->
  Notifications.find userId: @userId, read: false

Meteor.publish 'pollActivities', (criteria, projection) ->
  PollActivities.find criteria, projection