"""
URL configuration for smartfarm project.
"""
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('landing.urls')),  # Landing page เป็นหน้าแรก
]
