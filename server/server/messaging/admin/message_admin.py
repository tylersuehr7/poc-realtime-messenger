from django.contrib import admin

from server.messaging.models import Message


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    pass
