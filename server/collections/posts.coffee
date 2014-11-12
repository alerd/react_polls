Polls.allow
  update: ownDocument
  remove: ownDocument


Polls.deny
  update: (userId, poll, fieldNames) ->
    _.without(fieldNames, 'url', 'title').length > 0


Meteor.methods
  poll: (pollAttributes) ->
    user = do Meteor.user
    pollWithSameLink = Polls.findOne url: pollAttributes.url

    throw new Meteor.Error 401, "You need to login to poll new stories" unless user
    throw new Meteor.Error 422, 'Please fill in a headline' unless pollAttributes.title
    if pollAttributes.url and pollWithSameLink
      throw new Meteor.Error 302, 'This link has already been polled', pollWithSameLink._id

    poll = _.extend _.pick(pollAttributes, 'url', 'title', 'message'),
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
      commentsCount: 0
      upvoters: []
      votes: 0

    Polls.insert poll


  upvote: (pollId) ->
    user = Meteor.user()

    throw new Meteor.Error 401, "Надо залогиниться чтобы голосовать" unless user

    Polls.update
      _id: pollId
      upvoters:
        $ne: user._id
    ,
      $addToSet:
        upvoters: user._id
      $inc:
        votes: 1

