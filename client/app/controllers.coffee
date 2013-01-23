Em.ArrayController.reopen require 'ember-list'

App.UserMixin = Em.Mixin.create

  needs: 'user'
  userController: Em.computed ->
    @controllerFor 'user'