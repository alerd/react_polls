POST_HEIGHT = 80
Positions = new Meteor.Collection null


Template.postItem.helpers
  domain: ->
    a = document.createElement 'a'
    a.href = @url
    a.hostname

  ownPost: ->
    @userId is do Meteor.userId

  upvotedClass: ->
    userId = Meteor.userId()

    if userId and not _.include @upvoters, userId
      'btn-primary upvotable'
    else
      'disabled'

  attributes: ->
    post = _.extend {}, Positions.findOne(postId: @_id), @
    newPosition = post._rank * POST_HEIGHT
    attributes = {}

    if _.isUndefined post.position
      attributes.class = 'post invisible'
    else
      offset = post.position - newPosition
      attributes.style = "top: " + offset + "px"
      if offset is 0
        attributes.class = "post animate"

    Meteor.setTimeout ->
      Positions.upsert
        postId: post._id
      ,
        $set:
          position: newPosition

    attributes


Template.postItem.events
  'click .upvotable': (e) ->
    do e.preventDefault

    Meteor.call 'upvote', @_id