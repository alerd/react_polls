Polls.allow
  update: ownDocument
  remove: ownDocument


Meteor.methods
  post: (pollAttributes) ->
    user = do Meteor.user
    pollWithSameTitle = Polls.findOne title: pollAttributes.title

    throw new Meteor.Error 401, "Увійдіть в систему щоб створити нове опитування" unless user
    throw new Meteor.Error 422, 'Будь ласка, введіть назву опитування' unless pollAttributes.title
    if pollAttributes.title and pollWithSameTitle
      throw new Meteor.Error 302, 'Таке голосування вже було опубліковано', pollWithSameTitle._id

    poll = _.extend _.pick(pollAttributes, 'title', 'message'),
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
      commentsCount: 0
      uplikers: []
      likes: 0
      votesNumber: 0

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

  addVote: (pollId, userId) ->
    Polls.update
      _id: pollId
    ,
      $addToSet:
        votedUsers: userId
      $inc:
        votesNumber: 1

