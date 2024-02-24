from django.contrib import admin

from server.messaging.models import Chat


@admin.register(Chat)
class ChatAdmin(admin.ModelAdmin):
    pass
