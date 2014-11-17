if Polls.find().count() is 0
  now = new Date().getTime()

  tomId = Meteor.users.insert
    profile:
      name: 'Tom Coleman'

  tom = Meteor.users.findOne tomId
  sachaId = Meteor.users.insert
    profile:
      name: 'Sacha Greif'

  sacha = Meteor.users.findOne sachaId

  telescopeId = Polls.insert
    title: 'Чи подобається вам цей сайт?'
    userId: sacha._id
    author: sacha.profile.name
    description: 'http://sachagreif.com/introducing-telescope/'
    submitted: now - 7 * 3600 * 1000
    commentsCount: 2
    uplikers: []
    likes: 0
    votesNumber: 0

  Comments.insert
    pollId: telescopeId
    userId: tom._id
    author: tom.profile.name
    submitted: now - 5 * 3600 * 1000
    body: 'Interesting project Sacha, can I get involved?'

  Comments.insert
    pollId: telescopeId
    userId: sacha._id
    author: sacha.profile.name
    submitted: now - 3 * 3600 * 1000
    body: 'You sure can Tom!'

  Polls.insert
    title: 'Meteor'
    userId: tom._id
    author: tom.profile.name
    description: 'http://meteor.com'
    submitted: now - 10 * 3600 * 1000,
    commentsCount: 0
    uplikers: []
    likes: 0
    votesNumber: 0


  Polls.insert
    title: 'The Meteor Book',
    userId: tom._id,
    author: tom.profile.name,
    description: 'http://themeteorbook.com',
    submitted: now - 12 * 3600 * 1000,
    commentsCount: 0
    uplikers: []
    likes: 0
    votesNumber: 0
