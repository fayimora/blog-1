import logging
from google.appengine.ext import db
from google.appengine.api import users


class Model(db.Model):

    _date = db.DateTimeProperty(auto_now=True)

    @property
    def readable(self):
        return True
  
    @property
    def writable(self):
        return users.is_current_user_admin()

class User(Model):
    
    name = db.StringProperty()

    _is_admin = db.BooleanProperty(default=False)
    _email = db.UserProperty(auto_current_user_add=True)


def get_current_user():
    user = users.get_current_user()
    return User.gql('WHERE _email = :1', user).get()

class Model(Model):
    _author = db.UserProperty(auto_current_user=True)

class Post(Model):
    title = db.StringProperty()
    content = db.TextProperty()
    _comments = db.ListProperty(str)

    @property
    def comments(self):
        return Comment.gql('WHERE post = :1', self)

    @property
    def tags(self):
        return Tag.gql('WHERE post = :1', self)

    def rm(self):
        db.delete(self.comments)
        db.delete(self.tags)

    @property
    def comments_keys(self):
        return [str(c.key()) for c in self.comments]

class Comment(Model):
    post = db.ReferenceProperty(Post)
    content = db.TextProperty()

    def put(self, *args, **kwargs):
        super(Comment, self).put(*args, **kwargs)
        key = unicode(self.key())
        self.post._comments.append(key)
        self.post.put()

    def rm(self):
        key = unicode(self.key())
        self.post.remove(key)

class Tag(Model):
    post = db.ReferenceProperty(Post)
    name = db.StringProperty()
