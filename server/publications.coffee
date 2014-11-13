Meteor.publish 'polls', (criteria, projection)->
  Polls.find criteria, projection

Meteor.publish 'comments', (pollId) ->
  Comments.find pollId: pollId

Meteor.publish 'notifications', ->
  Notifications.find userId: @userId, read: false

Meteor.publish 'pollActivities', (criteria, projection) ->
  PollActivities.find criteria, projection