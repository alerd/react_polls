Meteor.publish 'posts', (criteria, projection)->
  Posts.find criteria, projection

Meteor.publish 'comments', (postId) ->
  Comments.find postId: postId

Meteor.publish 'notifications', ->
  Notifications.find userId: @userId, read: false