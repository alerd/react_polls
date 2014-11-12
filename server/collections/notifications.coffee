Notifications.allow
  update: (userId, doc, fieldNames) ->
    fieldNames.length is 1 and fieldNames[0] is 'read' and ownDocument userId, doc

@createCommentNotification = (comment) ->
  post = Posts.findOne comment.postId
  if comment.userId isnt post.userId
    Notifications.insert
      userId: post.userId
      postId: post._id
      commentId: comment._id
      commenterName: comment.author
      read: false