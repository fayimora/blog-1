import logging
from google.appengine.ext import db
from google.appengine.api import users


class Model(db.Model):

    date = db.DateTimeProperty(auto_now=True)

    @property
    def readable(self):
        return True
  
    @property
    def writable(self):
        return users.is_current_user_admin()

class User(Model):
    
    name = db.StringProperty()
    is_admin = db.BooleanProperty(default=False)
    email = db.UserProperty(auto_current_user_add=True)


def get_current_user():
    user = users.get_current_user()
    return User.gql('WHERE email = :1', user).get()

class Model(Model):
    author = db.UserProperty(auto_current_user=True)

class Post(Model):
    title = db.StringProperty()
    content = db.TextProperty()
    comments = db.ListProperty(str)
    tags = db.ListProperty(str)

    @property
    def _comments_(self):
        return Comment.gql('WHERE post = :1', self)

    @property
    def _tags_(self):
        return Tag.gql('WHERE post = :1', self)

    def rm(self):
        db.delete(self._comments_)
        db.delete(self._tags_)

    @property
    def comments_keys(self):
        return [str(c.key()) for c in self.comments]

class Comment(Model):
    post = db.ReferenceProperty(Post)
    content = db.TextProperty()

    def put(self, *args, **kwargs):
        super(Comment, self).put(*args, **kwargs)
        key = str(self.key())

        # add key from post's comments
        if key not in self.post.comments:
            self.post.comments.append(key)
        self.post.put()

    def rm(self):
        key = str(self.key())
        logging.warning(self.post.comments)
        logging.warning('\n')
        logging.warning(key)
        # remove key from post's comments
        self.post.comments.remove(key)
        self.post.put()
        db.delete(self) #?

class Tag(Model):
    post = db.ReferenceProperty(Post)
    name = db.StringProperty()
