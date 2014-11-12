Comments.allow
  update: ownDocument
  remove: ownDocument

Meteor.methods
  comment: (commentAttributes) ->
    user = Meteor.user()
    poll = Polls.findOne commentAttributes.pollId

    throw new Meteor.Error 401, "You need to login to make comments" unless user
    throw new Meteor.Error 422, 'Please write some content' unless commentAttributes.body
    throw new Meteor.Error 422, 'You must comment on a poll' unless poll

    comment = _.extend _.pick(commentAttributes, 'pollId', 'body'),
      userId: user._id,
      author: user.username,
      submitted: new Date().getTime()


    Polls.update comment.pollId, $inc:
      commentsCount: 1

    comment._id = Comments.insert comment
    createCommentNotification comment
    comment._id;

  remove: (commentAttributes) ->
    user = Meteor.user()
    fresherComment = Comments.findOne
      pollId: commentAttributes.pollId
      submitted:
        $gt: commentAttributes.submitted

    throw new Meteor.Error 401, "You need to login to make comments" unless user
    throw new Meteor.Error 423, 'The comment that is being deleted is locked' if fresherComment

    Comments.remove commentAttributes._id
    Polls.update commentAttributes.pollId, $inc:
      commentsCount: -1