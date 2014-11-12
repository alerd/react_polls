Template.pollsList.helpers
  polls: Polls.find {}, @projection

  pollsWithRank: ->
    do @polls.rewind

    @polls.map (poll, index) ->
      poll._rank = index
      poll
