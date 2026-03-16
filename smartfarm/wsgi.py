"""
WSGI config for smartfarm project.
"""

import os

from django.core.wsgi import get_wsgi_application

# Use Render settings for production
# Change to 'smartfarm.settings' for local development
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'smartfarm.settings_render')

application = get_wsgi_application()
