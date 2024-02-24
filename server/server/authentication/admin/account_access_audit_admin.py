from django.contrib import admin

from server.authentication.models import AccountAccessLog


@admin.register(AccountAccessLog)
class AccountAccessAuditAdmin(admin.ModelAdmin):
    list_display = ("account", "access_type", "created")
    list_filter = ["access_type"]
    fieldsets = (
        [None, {"fields": ["account", "access_type"]}],
        ["Additional Details", {"fields": ["id", "created"]}],
    )
    readonly_fields = ["id", "created"]
    raw_id_fields = ["account"]

    def has_add_permission(self, request):
        return False

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False
