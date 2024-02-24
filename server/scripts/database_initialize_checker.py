import sys

from django.contrib.auth import get_user_model


def run():
    if get_user_model().objects.all().count() > 0:
        sys.exit(0)
    sys.exit(1)
