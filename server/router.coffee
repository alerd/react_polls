Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    [
      Meteor.subscribe 'notifications'
    ]

Router.map ->
  @route 'home',
    path: '/'
    controller: NewPostsListController

  @route 'newPosts',
    path: '/new/:postsLimit?'
    controller: NewPostsListController

  @route 'bestPosts',
    path: '/best/:postsLimit?'
    controller: BestPostsListController

  @route 'postPage',
    path: '/posts/:_id'
    waitOn: ->
      Meteor.subscribe 'comments', @params._id
      Meteor.subscribe 'posts', _id: @params._id
    data: ->
      Posts.findOne @params._id

  @route 'postEdit',
    path: '/posts/:_id/edit'
    data: ->
      Posts.findOne @params._id

  @route 'postSubmit',
    path: '/submit'
    disableProgress: true


requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'accessDenied'
    do pause
  else
    do @next


Router.before 'loading'
Router.before requireLogin, only: 'postSubmit'
Router.before ->
  do clearErrors
  do @next