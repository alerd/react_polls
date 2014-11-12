Notifications.allow
  update: (userId, doc, fieldNames) ->
    fieldNames.length is 1 and fieldNames[0] is 'read' and ownDocument userId, doc

@createCommentNotification = (comment) ->
  poll = Polls.findOne comment.pollId
  if comment.userId isnt poll.userId
    Notifications.insert
      userId: poll.userId
      pollId: poll._id
      commentId: comment._id
      commenterName: comment.author
      read: false