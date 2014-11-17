messagesFrequency =
  mouseover: 5
  mousedown: 3
  click: 1

messages =
  mouseover: [
    ->
      "#{@userName} зацікавився результатами опитування"
    ->
      "Тим часом #{@userName} досліджує статистику"
    ->
      "#{@userName} переглядає діаграму"
  ]
  mousedown: [
    ->
      "Голос #{@userName} практично віддано за  \"#{@optionName}\"..."
    ->
      "#{@userName} готується проголосувати за \"#{@optionName}\"..."
    ->
      "#{@userName} вважає варіант \"#{@optionName}\" достойним і от-от його обере..."
    ->
      "#{@userName} до останнього зважує усі переваги \"#{@optionName}\" над іншими варіантами..."
    ->
      "Чи не помиляються #{@optionValue} людей голосуючи за \"#{@optionName}\"? - думає #{@userName}..."
  ]
  click: [
    ->
      "#{@userName} став #{@optionValue + 1} прихильником \"#{@optionName}\"."
    ->
      "#{@optionValue} #{pluralizeComment @optionValue} та #{@userName} обирають \"#{@optionName}\"."
    ->
      "\"Сподіваюся мій голос стане вирішальним\" - подума(в/ла) #{@userName} обираючи \"#{@optionName}\"."
    ->
      "#{@userName} думає, що \"#{@optionName}\" краще, ніж інші варінти."
    ->
      "#{@userName} подобається \"#{@optionName}\"."
  ]


needToStoreActivity = (eventType) ->
  (_.random 1, messagesFrequency[eventType]) % messagesFrequency[eventType] is 0


pollActivityHandler = (e) ->
  do e.preventDefault

  return unless user = Meteor.user()
  segment = theChart.getSegmentsAtEvent e
  return if (e.type is 'click' or e.type is 'mousedown') and segment?.length is 0
  return if (_.include @votedUsers, user._id) and (e.type isnt 'mouseover')

  message =
    eventType: e.type
    userName: user.username
    optionValue: segment?[0]?.value
    optionName: segment?[0]?.label

  if needToStoreActivity e.type
    PollActivities.insert
      pollId: @_id
      message: do messages[e.type][_.random 0, messages[e.type].length - 1].bind message
      submitted: new Date().getTime()
      userId: user._id

  if e.type is 'click'
    pollOption = PollOptions.findOne color: segment[0].fillColor
    Meteor.call 'addVote', @_id, user._id
    Meteor.call 'addVoteForOption', pollOption._id, user

  theChart.update()


Template.pollPage.events
  'click #pollChart': pollActivityHandler
  'mousedown #pollChart': pollActivityHandler
  'mouseover #pollChart': pollActivityHandler

  'click .fixed-size-square': (e) ->
    do e.preventDefault

    poll = Polls.findOne @pollId

    return unless user = Meteor.user()
    return unless poll
    return if _.include poll.votedUsers, user._id

    message =
      eventType: e.type
      userName: user.username
      optionValue: @value
      optionName: @label

    if needToStoreActivity e.type
      PollActivities.insert
        pollId: @pollId
        message: do messages[e.type][_.random 0, messages[e.type].length - 1].bind message
        submitted: new Date().getTime()
        userId: user._id

    Meteor.call 'addVote', @pollId, user._id
    Meteor.call 'addVoteForOption', @_id, user


Template.pollPage.helpers
  comments: ->
    Comments.find {}, sort:
      submitted: -1

  activities: ->
    PollActivities.find {}, sort:
      submitted: 1
    ,
      limit: 7

  options: ->
    PollOptions.find {}, sort:
      value: -1