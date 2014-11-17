Meteor.methods
  addVoteForOption: (optionId, user) ->
    PollOptions.update
      _id: optionId
    ,
      $addToSet:
        votedUsers: user
      $inc:
        value: 1