@PostsListController = RouteController.extend
  template: 'postsList'
  increment: 5

  limit: ->
    parseInt @params.postsLimit or @increment

  findOptions: ->
    sort: @sort
    limit: @limit()

  onBeforeAction: ->
    @postsSub = Meteor.subscribe 'posts', {}, @findOptions()
    do @next

  posts: ->
    Posts.find {}, @findOptions()

  data: ->
    hasMore = @posts().fetch().length is @limit()
    posts: @posts()
    ready: @postsSub?.ready or yes
    nextPath: if hasMore then @nextPath() else null
    projection: @findOptions()


@NewPostsListController = PostsListController.extend
  sort:
    submitted: -1
    id: -1

  nextPath: ->
    Router.routes.newPosts.path postsLimit: @limit() + @increment


@BestPostsListController = PostsListController.extend
  sort:
    votes: -1
    submitted: -1
    posts: -1

  nextPath: ->
    Router.routes.bestPosts.path postsLimit: @limit() + @increment
