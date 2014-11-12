Comments.allow
  update: ownDocument
  remove: ownDocument

Meteor.methods
  comment: (commentAttributes) ->
    user = Meteor.user()
    poll = Polls.findOne commentAttributes.pollId

    throw new Meteor.Error 401, "Увійдіть в систему щоб залишати коментарі" unless user
    throw new Meteor.Error 422, 'Будь ласка, введіть коментар' unless commentAttributes.body
    throw new Meteor.Error 422, 'Ви повинні прокоментувати' unless poll

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

    throw new Meteor.Error 401, "Увійдіть в систему щоб залишати коментарі" unless user
    throw new Meteor.Error 423, 'Коментар, який Ви намагаєтеся видалити заблоковано' if fresherComment

    Comments.remove commentAttributes._id
    Polls.update commentAttributes.pollId, $inc:
      commentsCount: -1