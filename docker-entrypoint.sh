#!/bin/bash
# ========================================
# Docker Entrypoint Script สำหรับ Render
# รัน migrations และ start Gunicorn
# ========================================

set -e  # Exit on error

echo "🔍 Waiting for database to be ready..."

# รอให้ database พร้อม (retry 30 ครั้ง = 30 วินาที)
python << END
import os
import sys
import time
import psycopg2
from urllib.parse import urlparse

max_retries = 30
retry_count = 0

database_url = os.environ.get('DATABASE_URL')
if not database_url:
    print("❌ DATABASE_URL not set!")
    sys.exit(1)

# Parse DATABASE_URL
result = urlparse(database_url)
username = result.username
password = result.password
database = result.path[1:]
hostname = result.hostname
port = result.port

while retry_count < max_retries:
    try:
        conn = psycopg2.connect(
            dbname=database,
            user=username,
            password=password,
            host=hostname,
            port=port
        )
        conn.close()
        print("✅ Database is ready!")
        break
    except psycopg2.OperationalError:
        retry_count += 1
        print(f"⏳ Database not ready yet... ({retry_count}/{max_retries})")
        time.sleep(1)
else:
    print("❌ Could not connect to database after 30 seconds")
    sys.exit(1)
END

echo "📦 Collecting static files..."
python manage.py collectstatic --noinput --clear || {
    echo "⚠️  Static files collection failed, continuing anyway..."
}

echo "🔄 Running database migrations..."
python manage.py migrate --noinput || {
    echo "❌ Migration failed!"
    exit 1
}

echo "✅ Migrations completed successfully"

# แสดง migration status
echo "📊 Current migration status:"
python manage.py showmigrations | head -n 20

echo "🚀 Starting Gunicorn server..."
exec gunicorn smartfarm.wsgi:application \
    --bind 0.0.0.0:${PORT:-8000} \
    --workers ${WEB_CONCURRENCY:-3} \
    --timeout 120 \
    --access-logfile - \
    --error-logfile - \
    --log-level info \
    --capture-output \
    --enable-stdio-inheritance
