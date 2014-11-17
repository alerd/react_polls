Template.pollOption.helpers
  percentage: ->
    poll = Polls.findOne _id: @pollId
    val = @value / poll.votesNumber || 0
    val *= 100
    "#{val.toFixed 2}%"