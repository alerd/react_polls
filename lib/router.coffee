Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ->
    [
      Meteor.subscribe 'notifications'
    ]

Router.map ->
  @route 'newPolls',
    path: '/new/:pollsLimit?'
    controller: NewPollsListController

  @route 'bestPolls',
    path: '/best/:pollsLimit?'
    controller: BestPollsListController

  @route 'pollEdit',
    path: '/polls/:_id/edit'
    waitOn: ->
      Meteor.subscribe 'polls', _id: @params._id
    data: ->
      console.log @params._id
      Polls.findOne @params._id

  @route 'pollPage',
    path: '/polls/:_id'
    waitOn: ->
      Meteor.subscribe 'comments', @params._id
      Meteor.subscribe 'polls', _id: @params._id
    data: ->
      Polls.findOne @params._id

  @route 'pollSubmit',
    path: '/submit'
    disableProgress: true

  @route 'home',
    path: '/'
    controller: NewPollsListController


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
Router.before requireLogin, only: 'pollSubmit'
Router.before ->
  do clearErrors
  do @next