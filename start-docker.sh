#!/bin/bash
# ========================================
# Quick Start Script for Smart Farm AIOTs
# Production Deployment with Docker (Linux/Mac)
# ========================================

set -e

echo ""
echo "========================================"
echo " Smart Farm AIOTs - Docker Deployment"
echo "========================================"
echo ""

# ตรวจสอบว่า Docker ทำงานอยู่หรือไม่
if ! docker info > /dev/null 2>&1; then
    echo "[ERROR] Docker ไม่ได้เปิดใช้งาน!"
    echo "กรุณาเปิด Docker แล้วรันสคริปต์นี้อีกครั้ง"
    exit 1
fi

echo "[OK] Docker กำลังทำงาน"
echo ""

# ตรวจสอบว่ามีไฟล์ .env หรือไม่
if [ ! -f .env ]; then
    echo "[WARN] ไม่พบไฟล์ .env"
    echo "กำลังสร้างจาก .env.example..."
    cp .env.example .env
    echo ""
    echo "[IMPORTANT] กรุณาแก้ไขไฟล์ .env ก่อนใช้งาน Production!"
    echo "- เปลี่ยน SECRET_KEY"
    echo "- เปลี่ยน POSTGRES_PASSWORD"
    echo "- ตั้งค่า ALLOWED_HOSTS"
    echo ""
    read -p "กด Enter เพื่อดำเนินการต่อ..."
fi

echo ""
echo "เลือกโหมดการทำงาน:"
echo ""
echo "1. Production (Nginx + Gunicorn + PostgreSQL)"
echo "2. Development (Django Dev Server + PostgreSQL)"
echo "3. หยุด Services ทั้งหมด"
echo "4. ลบ Containers และ Volumes"
echo "5. ดู Logs"
echo "6. รัน Database Migrations"
echo "7. สร้าง Superuser"
echo "8. เปิด Django Shell"
echo "9. Backup Database"
echo "0. ออกจากโปรแกรม"
echo ""

read -p "เลือกตัวเลข (0-9): " choice

case $choice in
    1)
        echo ""
        echo "[1] Starting Production Environment..."
        echo ""
        docker-compose up -d --build
        echo ""
        echo "[OK] Services started!"
        echo ""
        echo "URLs:"
        echo "- Website: http://localhost"
        echo "- Direct Django: http://localhost:8000"
        echo "- Admin: http://localhost/admin"
        echo ""
        echo "รันคำสั่งเหล่านี้ครั้งแรก:"
        echo "  ./start-docker.sh (เลือก 6 - Migrate Database)"
        echo "  ./start-docker.sh (เลือก 7 - Create Superuser)"
        echo ""
        ;;
    2)
        echo ""
        echo "[2] Starting Development Environment..."
        echo ""
        docker-compose -f docker-compose.dev.yml up --build
        ;;
    3)
        echo ""
        echo "[3] Stopping all services..."
        echo ""
        docker-compose stop
        docker-compose -f docker-compose.dev.yml stop
        echo ""
        echo "[OK] Services stopped"
        echo ""
        ;;
    4)
        echo ""
        echo "[4] WARNING! This will delete all containers and data!"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            echo ""
            echo "Cleaning up..."
            docker-compose down -v
            docker-compose -f docker-compose.dev.yml down -v
            echo ""
            echo "[OK] Cleanup complete"
            echo ""
        fi
        ;;
    5)
        echo ""
        echo "[5] Viewing logs (Ctrl+C to exit)..."
        echo ""
        docker-compose logs -f --tail=50
        ;;
    6)
        echo ""
        echo "[6] Running database migrations..."
        echo ""
        docker-compose exec web python manage.py makemigrations
        docker-compose exec web python manage.py migrate
        echo ""
        echo "[OK] Migrations complete"
        echo ""
        ;;
    7)
        echo ""
        echo "[7] Creating Django superuser..."
        echo ""
        docker-compose exec web python manage.py createsuperuser
        echo ""
        ;;
    8)
        echo ""
        echo "[8] Opening Django shell..."
        echo ""
        docker-compose exec web python manage.py shell
        ;;
    9)
        echo ""
        echo "[9] Backing up database..."
        echo ""
        timestamp=$(date +%Y%m%d_%H%M%S)
        filename="backup_${timestamp}.sql"
        docker-compose exec db pg_dump -U smartfarm_user smartfarm > $filename
        echo ""
        echo "[OK] Database backed up to: $filename"
        echo ""
        ;;
    0)
        echo ""
        echo "Thank you for using Smart Farm AIOTs!"
        echo ""
        exit 0
        ;;
    *)
        echo ""
        echo "[ERROR] Invalid choice!"
        echo ""
        exit 1
        ;;
esac
