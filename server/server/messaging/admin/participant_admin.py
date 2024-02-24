from django.contrib import admin

from server.messaging.models import Participant


@admin.register(Participant)
class ParticipantAdmin(admin.ModelAdmin):
    pass
