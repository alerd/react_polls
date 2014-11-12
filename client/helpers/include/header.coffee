Template.header.helpers
  activeRouteClass: ->
    args = Array::slice.call arguments, 0
    do args.pop

    active = _.any args, (name) ->
      Router.current() and Router.current().route.getName() is name

    active and 'active'