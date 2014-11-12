@Errors = new Meteor.Collection null

@throwError = (message) ->
  Errors.insert message: message, seen: no

@clearErrors = ->
  Errors.remove seen: yes

Template.errors.helpers
  errors: ->
    do Errors.find

Template.error.rendered = ->
  error = @data

  Errors.update error._id, $set:
    seen: yes
