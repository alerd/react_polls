POST_HEIGHT = 80
Positions = new Meteor.Collection null


Template.pollItem.helpers
  shortDescription: ->
    "#{@message.slice 0, 20}..."

  ownPoll: ->
    @userId is do Meteor.userId

  uplikedClass: ->
    userId = Meteor.userId()

    if (userId and not _.include @uplikers, userId) or not userId
      'upvotable'
    else 'notvotable'

  attributes: ->
    poll = _.extend {}, Positions.findOne(pollId: @_id), @
    newPosition = poll._rank * POST_HEIGHT
    attributes = {}

    if _.isUndefined poll.position
      attributes.class = 'poll invisible'
    else
      offset = poll.position - newPosition
      attributes.style = "top: " + offset + "px"
      if offset is 0
        attributes.class = "poll animate"

    Meteor.setTimeout ->
      Positions.upsert
        pollId: poll._id
      ,
        $set:
          position: newPosition

    attributes


Template.pollItem.events
  'click .uplike-upvotable': (e) ->
    do e.preventDefault

    Meteor.call 'uplike', @_id

  'click .uplike-notvotable': (e) ->
    do e.preventDefault

    Meteor.call 'dislike', @_id