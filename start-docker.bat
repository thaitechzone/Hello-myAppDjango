@echo off
REM ========================================
REM Quick Start Script for Smart Farm AIOTs
REM Production Deployment with Docker
REM ========================================

echo.
echo ========================================
echo  Smart Farm AIOTs - Docker Deployment
echo ========================================
echo.

REM ตรวจสอบว่า Docker Desktop ทำงานอยู่หรือไม่
docker info > nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Desktop ไม่ได้เปิดใช้งาน!
    echo กรุณาเปิด Docker Desktop แล้วรันสคริปต์นี้อีกครั้ง
    pause
    exit /b 1
)

echo [OK] Docker Desktop กำลังทำงาน
echo.

REM ตรวจสอบว่ามีไฟล์ .env หรือไม่
if not exist .env (
    echo [WARN] ไม่พบไฟล์ .env
    echo กำลังสร้างจาก .env.example...
    copy .env.example .env
    echo.
    echo [IMPORTANT] กรุณาแก้ไขไฟล์ .env ก่อนใช้งาน Production!
    echo - เปลี่ยน SECRET_KEY
    echo - เปลี่ยน POSTGRES_PASSWORD
    echo - ตั้งค่า ALLOWED_HOSTS
    echo.
    pause
)

echo.
echo เลือกโหมดการทำงาน:
echo.
echo 1. Production (Nginx + Gunicorn + PostgreSQL)
echo 2. Development (Django Dev Server + PostgreSQL)
echo 3. หยุด Services ทั้งหมด
echo 4. ลบ Containers และ Volumes
echo 5. ดู Logs
echo 6. รัน Database Migrations
echo 7. สร้าง Superuser
echo 8. เปิด Django Shell
echo 9. Backup Database
echo 0. ออกจากโปรแกรม
echo.

set /p choice="เลือกตัวเลข (0-9): "

if "%choice%"=="1" goto production
if "%choice%"=="2" goto development
if "%choice%"=="3" goto stop
if "%choice%"=="4" goto clean
if "%choice%"=="5" goto logs
if "%choice%"=="6" goto migrate
if "%choice%"=="7" goto superuser
if "%choice%"=="8" goto shell
if "%choice%"=="9" goto backup
if "%choice%"=="0" goto end
goto invalid

:production
echo.
echo [1] Starting Production Environment...
echo.
docker-compose up -d --build
echo.
echo [OK] Services started!
echo.
echo URLs:
echo - Website: http://localhost
echo - Direct Django: http://localhost:8000
echo - Admin: http://localhost/admin
echo.
echo รันคำสั่งเหล่านี้ครั้งแรก:
echo   start-docker.bat (เลือก 6 - Migrate Database)
echo   start-docker.bat (เลือก 7 - Create Superuser)
echo.
pause
goto end

:development
echo.
echo [2] Starting Development Environment...
echo.
docker-compose -f docker-compose.dev.yml up --build
pause
goto end

:stop
echo.
echo [3] Stopping all services...
echo.
docker-compose stop
docker-compose -f docker-compose.dev.yml stop
echo.
echo [OK] Services stopped
echo.
pause
goto end

:clean
echo.
echo [4] WARNING! This will delete all containers and data!
set /p confirm="Are you sure? (yes/no): "
if not "%confirm%"=="yes" goto end
echo.
echo Cleaning up...
docker-compose down -v
docker-compose -f docker-compose.dev.yml down -v
echo.
echo [OK] Cleanup complete
echo.
pause
goto end

:logs
echo.
echo [5] Viewing logs (Ctrl+C to exit)...
echo.
docker-compose logs -f --tail=50
pause
goto end

:migrate
echo.
echo [6] Running database migrations...
echo.
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate
echo.
echo [OK] Migrations complete
echo.
pause
goto end

:superuser
echo.
echo [7] Creating Django superuser...
echo.
docker-compose exec web python manage.py createsuperuser
echo.
pause
goto end

:shell
echo.
echo [8] Opening Django shell...
echo.
docker-compose exec web python manage.py shell
pause
goto end

:backup
echo.
echo [9] Backing up database...
echo.
set timestamp=%date:~10,4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%
set filename=backup_%timestamp%.sql
docker-compose exec db pg_dump -U smartfarm_user smartfarm > %filename%
echo.
echo [OK] Database backed up to: %filename%
echo.
pause
goto end

:invalid
echo.
echo [ERROR] Invalid choice!
echo.
pause
goto end

:end
echo.
echo Thank you for using Smart Farm AIOTs!
echo.
