import logging
import unittest
import simplejson as json

from google.appengine.api import users
from google.appengine.ext import db

from server import models
import tests


class TestCase(tests.TestCase):

    model_name = 'post'

    def test_post(self):

        data = {
            'title': 'Mocha best practices',
            'content': '...'
        }
        self.assertPost(data)

    def test_put(self):

        post = models.Post.all()[0]

        data = {
            'title': 'Mocha best practices',
            'content': '...'
        }
        self.assertPut(post, data)
    

    def test_delete(self):
        post = models.Post.all()[0]
        self.assertDelete(post, ['comment', 'tag'])

    def test_find_all(self):
        #posts = self.model.gql('WHERE author = :1', users.get_current_user())
        posts = self.model.all()
        self.assertFindAll(posts)

    def test_find_query(self):

        post = models.Post.all()[0]

        # filter by title
        url = '/rest/post?feq_title=%s' % post.title
        res = self.app.get(url)
        assert res.status_int == 200
        # result
        self.assertDataCount(res, self.model.gql('WHERE title = :1', post.title))

    def test_find(self):

        post = models.Post.all()[0]
        data = {
            'key': unicode(post.key()),
            'title': post.title,
            'content': post.content
        }
        self.assertFind(post, data)