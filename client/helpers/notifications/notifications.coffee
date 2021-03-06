Template.notifications.helpers
  notifications: ->
    Notifications.find userId: Meteor.userId(), read: false
  notificationCount: ->
    Notifications.find(userId: Meteor.userId(), read: false).count()

Template.notification.helpers
  notificationPollPath: ->
    Router.routes.pollPage.path _id: @pollId

Template.notification.events
  'click a': ->
    Notifications.update @_id, $set:
      read: true