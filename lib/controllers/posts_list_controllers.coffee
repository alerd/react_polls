@PollsListController = RouteController.extend
  template: 'pollsList'
  increment: 5

  limit: ->
    parseInt @params.pollsLimit or @increment

  findOptions: ->
    sort: @sort
    limit: @limit()

  onBeforeAction: ->
    @pollsSub = Meteor.subscribe 'polls', {}, @findOptions()
    do @next

  polls: ->
    Polls.find {}, @findOptions()

  data: ->
    hasMore = @polls().fetch().length is @limit()
    polls: @polls()
    ready: @pollsSub?.ready or yes
    nextPath: if hasMore then @nextPath() else null
    projection: @findOptions()


@NewPollsListController = PollsListController.extend
  sort:
    submitted: -1
    id: -1

  nextPath: ->
    Router.routes.newPolls.path pollsLimit: @limit() + @increment


@BestPollsListController = PollsListController.extend
  sort:
    votes: -1
    submitted: -1
    polls: -1

  nextPath: ->
    Router.routes.bestPolls.path pollsLimit: @limit() + @increment
