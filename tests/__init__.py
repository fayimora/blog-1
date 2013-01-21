import logging
import webtest
import unittest

from google.appengine.ext import testbed

import server
from server import models
from helpers.test import TestCase


class TestCase(TestCase):

    def setUp(self, *args, **kwargs):

        super(TestCase, self).setUp(*args, **kwargs)

        # fixtures

        # loggin TJ and register
        self.testbed.setup_env(
            USER_EMAIL='tj@vision-media.ca',
            USER_ID='0000',
            USER_IS_ADMIN='1',
            overwrite=True
        )

        user = models.User(
            name='TJ'
        )
        user.put()

        assert user.is_admin == True

        post = models.Post(
            title= 'An introduction to component(1)',
            content='...'
        )
        post.put()

        comment = models.Comment(
            post=post,
            content='Awesome post'
        )
        comment.put()

        tag = models.Tag(
            label='component',
            post=post
        )
        tag.put()

        tag = models.Tag(
            label='node',
            post=post
        )
        tag.put()

        post = models.Post(
            title= 'Express guide',
            content='...'
        )
        post.put()

        comment = models.Comment(
            post=post,
            content='Great guide'
        )
        comment.put()

        tag = models.Tag(
            label='express',
            post=post
        )
        tag.put()

        tag = models.Tag(
            label='node',
            post=post
        )
        tag.put()
        # loggin Guillermo and register
        self.testbed.setup_env(
            USER_EMAIL='gr@learnboost.ca',
            USER_ID='0000',
            USER_IS_ADMIN='0',
            overwrite=True
        )

        user = models.User(
            name='Guillermo'
        )
        user.put()

        assert user.is_admin == False

        comment = models.Post(
            post=post,
            content='Neat!'
        )
        comment.put()

        # loggin back TJ
        self.testbed.setup_env(
            USER_EMAIL='tj@vision-media.ca',
            USER_ID='0000',
            USER_IS_ADMIN='1',
            overwrite=True
        )

