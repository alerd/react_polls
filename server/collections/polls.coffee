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

    throw new Meteor.Error 401, "Увійдіть в систему щоб створити нове опитування" unless user
    throw new Meteor.Error 422, 'Будь ласка, введіть назву опитування' unless pollAttributes.title
    if pollAttributes.url and pollWithSameLink
      throw new Meteor.Error 302, 'Це посилання вже було опубліковано', pollWithSameLink._id

    poll = _.extend _.pick(pollAttributes, 'url', 'title', 'message'),
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
      commentsCount: 0
      uplikers: []
      likes: 0

    Polls.insert poll


  uplike: (pollId) ->
    user = Meteor.user()

    throw new Meteor.Error 401, "Потрібно залогінитись щоб голосувати" unless user

    Polls.update
      _id: pollId
      uplikers:
        $ne: user._id
    ,
      $addToSet:
        uplikers: user._id
      $inc:
        likes: 1

  dislike: (pollId) ->
    user = Meteor.user()

    throw new Meteor.Error 401, "Потрібно залогінитись щоб голосувати" unless user

    Polls.update
      _id: pollId
      uplikers:
        $gte: user._id
    ,
      $pop:
        uplikers: user._id
      $inc:
        likes: -1

