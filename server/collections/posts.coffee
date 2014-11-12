Posts.allow
  update: ownDocument
  remove: ownDocument


Posts.deny
  update: (userId, post, fieldNames) ->
    _.without(fieldNames, 'url', 'title').length > 0


Meteor.methods
  post: (postAttributes) ->
    user = do Meteor.user
    postWithSameLink = Posts.findOne url: postAttributes.url

    throw new Meteor.Error 401, "You need to login to post new stories" unless user
    throw new Meteor.Error 422, 'Please fill in a headline' unless postAttributes.title
    if postAttributes.url and postWithSameLink
      throw new Meteor.Error 302, 'This link has already been posted', postWithSameLink._id

    post = _.extend _.pick(postAttributes, 'url', 'title', 'message'),
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
      commentsCount: 0
      upvoters: []
      votes: 0

    Posts.insert post


  upvote: (postId) ->
    user = Meteor.user()

    throw new Meteor.Error 401, "Надо залогиниться чтобы голосовать" unless user

    Posts.update
      _id: postId
      upvoters:
        $ne: user._id
    ,
      $addToSet:
        upvoters: user._id
      $inc:
        votes: 1

