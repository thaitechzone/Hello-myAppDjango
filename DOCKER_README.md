# 🐳 คู่มือการใช้งาน Docker สำหรับ Smart Farm AIOTs

คู่มือฉบับสมบูรณ์สำหรับการ Deploy Django Application ด้วย Docker Desktop แบบ Production

---

## 📋 สารบัญ

1. [ข้อกำหนดเบื้องต้น](#ข้อกำหนดเบื้องต้น)
2. [โครงสร้างไฟล์ Docker](#โครงสร้างไฟล์-docker)
3. [การติดตั้ง Docker Desktop](#การติดตั้ง-docker-desktop)
4. [การรัน Production Environment](#การรัน-production-environment)
5. [การรัน Development Environment](#การรัน-development-environment)
6. [คำสั่ง Docker ที่ใช้บ่อย](#คำสั่ง-docker-ที่ใช้บ่อย)
7. [การแก้ไขปัญหา](#การแก้ไขปัญหา)
8. [Best Practices](#best-practices)

---

## 🎯 ข้อกำหนดเบื้องต้น

### Software ที่ต้องติดตั้ง:
- ✅ Docker Desktop for Windows (version 4.0+)
- ✅ Git (optional)

### ความรู้พื้นฐานที่ควรมี:
- คำสั่ง Command Line พื้นฐาน
- Docker และ Docker Compose พื้นฐาน
- Django Framework พื้นฐาน

---

## 📁 โครงสร้างไฟล์ Docker

```
Hello myAppDjango/
│
├── Dockerfile                    # Production Dockerfile (Multi-stage)
├── Dockerfile.dev                # Development Dockerfile
├── docker-compose.yml            # Production Docker Compose
├── docker-compose.dev.yml        # Development Docker Compose
├── .dockerignore                 # ไฟล์ที่ไม่ต้อง copy เข้า Docker
├── nginx.conf                    # Nginx Configuration
├── .env.example                  # ตัวอย่าง Environment Variables
│
├── smartfarm/
│   └── settings_docker.py        # Django Settings สำหรับ Docker
│
└── requirements.txt              # Python Dependencies (อัพเดตแล้ว)
```

---

## 🔧 การติดตั้ง Docker Desktop

### ขั้นตอนที่ 1: ดาวน์โหลด Docker Desktop

1. ไปที่ https://www.docker.com/products/docker-desktop
2. ดาวน์โหลด Docker Desktop for Windows
3. รันไฟล์ติดตั้ง `Docker Desktop Installer.exe`
4. ติดตามขั้นตอนการติดตั้ง (เลือก WSL 2 backend ถ้าเป็นไปได้)

### ขั้นตอนที่ 2: ตรวจสอบการติดตั้ง

เปิด Command Prompt หรือ PowerShell และรันคำสั่ง:

```bash
docker --version
docker-compose --version
```

ถ้าเห็นเวอร์ชันแสดงว่าติดตั้งสำเร็จแล้ว!

### ขั้นตอนที่ 3: เปิด Docker Desktop

1. เปิดโปรแกรม Docker Desktop
2. รอจนกว่า Docker Engine จะเริ่มทำงาน (ดูที่ status bar ล่าง)
3. เมื่อเห็นว่า Docker is running ✅ ก็พร้อมใช้งานแล้ว

---

## 🚀 การรัน Production Environment

### ขั้นตอนที่ 1: เตรียม Environment Variables

สร้างไฟล์ `.env` จาก `.env.example`:

```bash
copy .env.example .env
```

แก้ไขไฟล์ `.env` ให้เหมาะสม:

```env
DEBUG=False
SECRET_KEY=your-very-secret-key-min-50-characters-for-production-security
ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0
POSTGRES_PASSWORD=your-strong-database-password
```

⚠️ **สำคัญ:** อย่าใช้ค่า default ใน production จริง!

### ขั้นตอนที่ 2: Build Docker Images

```bash
docker-compose build
```

คำสั่งนี้จะ:
- Build Docker image จาก Dockerfile
- ติดตั้ง dependencies ทั้งหมด
- สร้าง optimized image สำหรับ production

### ขั้นตอนที่ 3: เริ่มต้น Services ทั้งหมด

```bash
docker-compose up -d
```

Options:
- `-d` = Detached mode (รันใน background)
- ไม่ใส่ `-d` = ดู logs แบบ real-time

### ขั้นตอนที่ 4: สร้าง Database และ Superuser

```bash
# รัน migrations
docker-compose exec web python manage.py migrate

# สร้าง superuser
docker-compose exec web python manage.py createsuperuser
```

### ขั้นตอนที่ 5: เข้าใช้งานเว็บไซต์

เปิดเบราว์เซอร์:
- **ผ่าน Nginx:** http://localhost
- **ตรงไปที่ Django:** http://localhost:8000
- **Admin Panel:** http://localhost/admin

---

## 💻 การรัน Development Environment

สำหรับการพัฒนาที่มี Hot Reload:

```bash
# Build และ Start
docker-compose -f docker-compose.dev.yml up --build

# หรือแบบ background
docker-compose -f docker-compose.dev.yml up -d

# ดู logs
docker-compose -f docker-compose.dev.yml logs -f
```

คุณสมบัติพิเศษใน Dev mode:
- ✅ Hot reload เมื่อแก้ไขโค้ด
- ✅ Debug mode เปิดอยู่
- ✅ Source code mount เป็น volume
- ✅ ไม่ต้อง rebuild ทุกครั้งที่แก้โค้ด

---

## 📝 คำสั่ง Docker ที่ใช้บ่อย

### 1. การจัดการ Containers

```bash
# ดู containers ที่ทำงานอยู่
docker-compose ps

# ดู logs
docker-compose logs -f

# ดู logs ของ service เฉพาะ
docker-compose logs -f web
docker-compose logs -f db

# หยุด services
docker-compose stop

# เริ่ม services
docker-compose start

# รีสตาร์ท service
docker-compose restart web

# หยุดและลบ containers
docker-compose down

# หยุดและลบ containers + volumes
docker-compose down -v
```

### 2. การรันคำสั่งใน Container

```bash
# รัน Django management commands
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
docker-compose exec web python manage.py collectstatic

# เข้า Django shell
docker-compose exec web python manage.py shell

# เข้า container แบบ interactive
docker-compose exec web bash

# เข้า PostgreSQL shell
docker-compose exec db psql -U smartfarm_user -d smartfarm
```

### 3. การจัดการ Database

```bash
# Backup database
docker-compose exec db pg_dump -U smartfarm_user smartfarm > backup.sql

# Restore database
cat backup.sql | docker-compose exec -T db psql -U smartfarm_user smartfarm

# ดูข้อมูลในตาราง
docker-compose exec db psql -U smartfarm_user -d smartfarm -c "SELECT * FROM landing_contactmessage;"
```

### 4. การดู Resource Usage

```bash
# ดูการใช้ทรัพยากร
docker stats

# ดูเฉพาะโปรเจคนี้
docker stats smartfarm_web smartfarm_db smartfarm_nginx
```

### 5. การทำความสะอาด

```bash
# ลบ containers ที่หยุดแล้ว
docker container prune

# ลบ images ที่ไม่ได้ใช้
docker image prune

# ลบทุกอย่างที่ไม่ได้ใช้
docker system prune -a

# ลบ volumes ที่ไม่ได้ใช้
docker volume prune
```

---

## 🔍 การตรวจสอบสถานะ

### ตรวจสอบว่า Services ทำงานปกติ

```bash
# ดูสถานะทั้งหมด
docker-compose ps

# ตรวจสอบ health check
docker inspect --format='{{json .State.Health}}' smartfarm_web | python -m json.tool
```

### ตรวจสอบการเชื่อมต่อ Database

```bash
docker-compose exec web python manage.py dbshell
```

### ทดสอบเข้าถึง Static Files

```bash
curl http://localhost/static/landing/css/style.css
```

---

## 🛠️ การแก้ไขปัญหา

### ปัญหา 1: Container ไม่สามารถเริ่มได้

**อาการ:** `Error: Cannot start service web`

**วิธีแก้:**
```bash
# ดู logs ละเอียด
docker-compose logs web

# ลบและสร้างใหม่
docker-compose down -v
docker-compose up --build
```

### ปัญหา 2: Database Connection Failed

**อาการ:** `django.db.utils.OperationalError: could not connect to server`

**วิธีแก้:**
```bash
# ตรวจสอบว่า database container ทำงานอยู่
docker-compose ps db

# รอให้ database พร้อม
docker-compose exec db pg_isready -U smartfarm_user

# ลองเชื่อมต่อด้วยตนเอง
docker-compose exec db psql -U smartfarm_user -d smartfarm
```

### ปัญหา 3: Port Already in Use

**อาการ:** `Error: bind: address already in use`

**วิธีแก้:**

**Option 1:** หยุด process ที่ใช้ port อยู่
```bash
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

**Option 2:** เปลี่ยน port ใน docker-compose.yml
```yaml
ports:
  - "8001:8000"  # เปลี่ยนจาก 8000:8000
```

### ปัญหา 4: Static Files ไม่แสดง

**วิธีแก้:**
```bash
# Collect static files ใหม่
docker-compose exec web python manage.py collectstatic --noinput

# รีสตาร์ท nginx
docker-compose restart nginx
```

### ปัญหา 5: Permission Denied

**อาการ:** `PermissionError: [Errno 13] Permission denied`

**วิธีแก้:**
```bash
# ตรวจสอบ ownership ของ volumes
docker-compose exec web ls -la /app

# Fix permissions (ถ้าจำเป็น)
docker-compose exec --user root web chown -R django:django /app
```

### ปัญหา 6: Out of Memory

**วิธีแก้:**
1. เปิด Docker Desktop
2. ไปที่ Settings → Resources
3. เพิ่ม Memory Limit (แนะนำ 4GB+)
4. คลิก Apply & Restart

---

## 📊 การ Monitor และ Logs

### ดู Real-time Logs

```bash
# Logs ทั้งหมด
docker-compose logs -f --tail=100

# เฉพาะ web service
docker-compose logs -f web

# เฉพาะ error logs
docker-compose logs web | grep ERROR
```

### Monitor Resource Usage

```bash
# Real-time monitoring
docker stats

# ดูเฉพาะโปรเจคนี้
docker stats smartfarm_web smartfarm_db
```

---

## 🔐 Best Practices สำหรับ Production

### 1. Security

✅ **ใช้ Strong Passwords**
```env
POSTGRES_PASSWORD=VeryStr0ng&SecureP@ssw0rd!2026
SECRET_KEY=django-insecure-CHANGE-THIS-TO-50+-random-characters
```

✅ **ไม่ commit ไฟล์ .env**
```bash
# ตรวจสอบว่า .env อยู่ใน .gitignore
cat .gitignore | grep .env
```

✅ **ใช้ Environment Variables**
```bash
# ไม่ hardcode sensitive data ในโค้ด
SECRET_KEY = os.environ.get('SECRET_KEY')
```

### 2. Performance

✅ **ใช้ Multi-stage Build**
- Dockerfile ของเรามี 2 stages (builder + runtime)
- ลดขนาด image ได้มาก

✅ **Enable Caching**
```yaml
# ใน docker-compose.yml
volumes:
  - static_volume:/app/staticfiles
```

✅ **Optimize Gunicorn Workers**
```bash
# Formula: (2 x CPU cores) + 1
# 4 cores = 9 workers
gunicorn --workers 9 --threads 2 smartfarm.wsgi:application
```

### 3. Backup

✅ **สำรอง Database ทุกวัน**
```bash
# สคริปต์ backup
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec db pg_dump -U smartfarm_user smartfarm > backup_$DATE.sql
```

✅ **สำรอง Media Files**
```bash
docker cp smartfarm_web:/app/media ./media_backup
```

### 4. Monitoring

✅ **ตั้งค่า Health Checks**
- มีอยู่ใน Dockerfile และ docker-compose.yml แล้ว

✅ **Enable Logging**
```python
# ใน settings_docker.py มี logging config แล้ว
```

---

## 🚀 Deploy to Production Server

### ขั้นตอนที่ 1: เตรียม Server

```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# ติดตั้ง Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# ติดตั้ง Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### ขั้นตอนที่ 2: Clone โปรเจค

```bash
git clone <repository-url>
cd Hello\ myAppDjango
```

### ขั้นตอนที่ 3: ตั้งค่า Environment

```bash
cp .env.example .env
nano .env  # แก้ไขค่าให้เหมาะสม
```

### ขั้นตอนที่ 4: Deploy

```bash
docker-compose up -d --build
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
```

---

## 📱 การใช้งาน Docker Desktop UI

### 1. ดู Containers
- เปิด Docker Desktop
- คลิก Containers/Apps
- จะเห็น stack ของโปรเจค

### 2. ดู Logs
- คลิกที่ container
- เลือกแท็บ Logs
- ดู real-time logs ได้

### 3. เข้า Terminal
- คลิกที่ container
- เลือกแท็บ Terminal
- รันคำสั่งได้เหมือน `docker exec`

### 4. ดู Stats
- คลิกแท็บ Stats
- ดูการใช้ CPU, Memory, Network

---

## 🧪 การทดสอบ

### ทดสอบว่า Services ทำงาน

```bash
# Test database
docker-compose exec db psql -U smartfarm_user -d smartfarm -c "SELECT version();"

# Test Django
docker-compose exec web python manage.py check

# Test static files
curl -I http://localhost/static/landing/css/style.css

# Test application
curl http://localhost/
```

---

## 📞 ข้อมูลเพิ่มเติม

### Services และ Ports

| Service | Internal Port | External Port | URL |
|---------|--------------|---------------|-----|
| Nginx | 80 | 80 | http://localhost |
| Django | 8000 | 8000 | http://localhost:8000 |
| PostgreSQL | 5432 | 5432 | localhost:5432 |

### Docker Volumes

| Volume | Purpose |
|--------|---------|
| `postgres_data` | ข้อมูล Database |
| `static_volume` | Static files (CSS, JS) |
| `media_volume` | Uploaded files |

### Environment Variables สำคัญ

| Variable | Description | Example |
|----------|-------------|---------|
| `DEBUG` | โหมด Debug | `False` |
| `SECRET_KEY` | Django Secret Key | `abc123...` |
| `ALLOWED_HOSTS` | Hosts ที่อนุญาต | `localhost,example.com` |
| `DATABASE_URL` | URL ฐานข้อมูล | `postgresql://user:pass@db/name` |

---

## 🎓 เรียนรู้เพิ่มเติม

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Django Deployment Checklist](https://docs.djangoproject.com/en/5.0/howto/deployment/checklist/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)
- [Nginx Documentation](https://nginx.org/en/docs/)

---

## ✅ Checklist ก่อน Deploy Production

- [ ] เปลี่ยน `SECRET_KEY` เป็นค่าที่เป็นความลับ
- [ ] ตั้งค่า `DEBUG=False`
- [ ] เปลี่ยน `POSTGRES_PASSWORD` เป็น strong password
- [ ] กำหนด `ALLOWED_HOSTS` ให้ถูกต้อง
- [ ] ทดสอบ Database backup & restore
- [ ] ตั้งค่า HTTPS/SSL
- [ ] Configure firewall
- [ ] Setup monitoring และ logging
- [ ] ทำ load testing
- [ ] เตรียม disaster recovery plan

---

**สร้างโดย:** Smart Farm AIOTs Team  
**อัพเดตล่าสุด:** มีนาคม 2026  
**Docker Version:** 24.0+  
**Docker Compose Version:** 2.20+

---

**Happy Dockerizing! 🐳💚**
