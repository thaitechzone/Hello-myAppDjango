from django.contrib import admin
from .models import ContactMessage


@admin.register(ContactMessage)
class ContactMessageAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'phone', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('name', 'email', 'message')
    readonly_fields = ('created_at',)
    
    def has_add_permission(self, request):
        # ไม่ให้เพิ่มข้อมูลผ่าน admin (เพิ่มได้จาก form เท่านั้น)
        return False
