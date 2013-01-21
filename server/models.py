import logging
from google.appengine.ext import db
from google.appengine.api import users


class Model(db.Model):
    author = db.UserProperty(auto_current_user=True)
    _date = db.DateTimeProperty(auto_now=True)

    @property
    def readable(self):
        return True
  
    @property
    def writable(self):
        return users.is_current_user_admin()

class Post(Model):
    title = db.StringProperty()
    content = db.TextProperty()

    @property
    def comments(self):
        return Comment.gql('WHERE post = :1', self)

    @property
    def tags(self):
        return Tag.gql('WHERE post = :1', self)

    def rm(self):
        db.delete(self.comments)
        db.delete(self.tags)

class Comment(Model):
    post = db.ReferenceProperty(Post)
    content = db.TextProperty()

class Tag(Model):
    post = db.ReferenceProperty(Post)
    name = db.StringProperty()

class User(Model):
    name = db.StringProperty()
    #avatar = db.BlopProperty()
    is_admin = db.BooleanProperty(default=False)

    @property
    def email(self):
        return self.author

    def put(self, *args, **kwargs):

        if not self.is_saved():
            # one time set
            self.is_admin = users.is_current_user_admin()

        super(User, self).put(*args, **kwargs)


def get_current_user():
    user = users.get_current_user()
    return User.gql('WHERE author = :1', user).get()

