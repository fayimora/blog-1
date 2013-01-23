#import logging
from google.appengine.ext import webapp
from google.appengine.api import users

import models
from helpers import rest, utils

MODELS = {
    'user': models.User,
    'post': models.Post,
    'comment': models.Comment,
    'tag': models.Tag
}


class IndexView(utils.View):

    def get(self):
        user = None
        guser = users.get_current_user()
        if guser:
            user = models.get_current_user()
            if not user:
                user = models.User()
            user._is_admin = users.is_current_user_admin()
            user.put()
        return self.render('index', { 'user': user })

app = webapp.WSGIApplication(
    [
        ('/', IndexView),
        ('/login', utils.LoginView),
        ('/logout', utils.LogoutView),
        ('/users/me', utils.UserView),
        ('/rest/.*', rest.Dispatcher)
    ],
    debug=True
)

rest.Dispatcher.base_url = '/rest'
rest.Dispatcher.output_content_types = [rest.JSON_CONTENT_TYPE]
rest.Dispatcher.add_models(MODELS)
#rest.Dispatcher.authenticator = utils.Authenticator()
rest.Dispatcher.authorizer = utils.Authorizer()
