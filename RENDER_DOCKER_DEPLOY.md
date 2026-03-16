# 🐳 Deploy Smart Farm AIOTs บน Render ด้วย Docker

คู่มือการ Deploy Django Application แบบ Docker Container บน Render.com พร้อม PostgreSQL Database

---

## 📋 สารบัญ

1. [ทำไมต้อง Deploy ด้วย Docker?](#ทำไมต้อง-deploy-ด้วย-docker)
2. [เตรียมโปรเจคก่อน Deploy](#เตรียมโปรเจคก่อน-deploy)
3. [Deploy ด้วย Blueprint (แนะนำ)](#deploy-ด้วย-blueprint-แนะนำ)
4. [Deploy แบบ Manual](#deploy-แบบ-manual)
5. [ตั้งค่า Environment Variables](#ตั้งค่า-environment-variables)
6. [ทดสอบและตรวจสอบ](#ทดสอบและตรวจสอบ)
7. [Troubleshooting](#troubleshooting)
8. [เปรียบเทียบ Docker vs Native Build](#เปรียบเทียบ-docker-vs-native-build)

---

## 🤔 ทำไมต้อง Deploy ด้วย Docker?

### ข้อดีของ Docker Deployment:

✅ **Reproducible Builds**
- Build environment เหมือนกันทุกที่ (local, staging, production)
- ไม่มีปัญหา "It works on my machine"

✅ **Dependency Isolation**
- Dependencies ทั้งหมดอยู่ใน Container ไม่ขึ้นกับ host system
- ไม่มีปัญหา Python version หรือ system libraries conflict

✅ **Easy Rollback**
- เก็บ Docker images เป็น version ย้อนกลับได้ง่าย
- Rebuild และ redeploy เร็วกว่า

✅ **Better Resource Control**
- ควบคุม memory, CPU ของ container ได้ชัดเจน
- Monitor container health ได้ง่ายกว่า

✅ **Multi-stage Builds**
- ลดขนาด final image (ใช้แค่ runtime dependencies)
- Build เร็วขึ้นจาก layer caching

### ข้อควรระวัง:

⚠️ **Build Time**
- Docker build อาจช้ากว่า native build ครั้งแรก
- แต่ build ครั้งต่อไปเร็วขึ้นจาก cache

⚠️ **Image Size**
- Docker image จะใหญ่กว่า native deployment (~200-500 MB)
- แต่ใช้ multi-stage build แล้วช่วยลดขนาดได้มาก

---

## 🔧 เตรียมโปรเจคก่อน Deploy

### 1. ตรวจสอบไฟล์ที่จำเป็น

```bash
# ตรวจสอบว่ามีไฟล์เหล่านี้ครบหรือไม่
ls -la

# ไฟล์ที่ต้องมี:
✓ Dockerfile.render          # Docker configuration สำหรับ Render
✓ render-docker.yaml          # Blueprint configuration
✓ requirements.txt            # Python dependencies
✓ smartfarm/settings_render.py # Production settings
✓ smartfarm/wsgi.py           # WSGI application
✓ .dockerignore               # ไฟล์ที่ไม่ต้องการใน Docker image
```

### 2. ตรวจสอบ .dockerignore

ไฟล์ `.dockerignore` ช่วยลดขนาด Docker image โดยไม่คัดลอกไฟล์ที่ไม่จำเป็น:

```gitignore
# .dockerignore
*.pyc
__pycache__/
venv/
.env
.git/
.github/
*.md
.vscode/
.idea/
db.sqlite3
```

### 3. Test Build Docker Image Locally (แนะนำ)

ทดสอบสร้าง Docker image ก่อน deploy:

```bash
# Build Docker image
docker build -f Dockerfile.render -t smartfarm-test .

# ทดสอบรัน container
docker run -p 8000:8000 \
  -e SECRET_KEY="test-secret-key-only" \
  -e DEBUG=True \
  -e ALLOWED_HOSTS="localhost,127.0.0.1" \
  smartfarm-test

# เปิดเว็บบราวเซอร์ไปที่ http://localhost:8000
```

### 4. Push Code ขึ้น GitHub

```bash
# เพิ่มไฟล์ใหม่
git add Dockerfile.render render-docker.yaml

# Commit
git commit -m "🐳 Add Docker deployment config for Render"

# Push ขึ้น GitHub
git push origin master
```

---

## 🚀 Deploy ด้วย Blueprint (แนะนำ)

Blueprint เป็นวิธีที่ง่ายที่สุด - ตั้งค่าทุกอย่างอัตโนมัติผ่าน YAML file

### ขั้นตอนการ Deploy:

#### 1️⃣ สร้าง Account Render

- ไปที่ https://render.com
- คลิก **Sign Up**
- เลือก **Sign up with GitHub** (แนะนำ)
- Authorize Render เพื่อเข้าถึง GitHub repositories

#### 2️⃣ Deploy from Blueprint

1. ที่ Render Dashboard คลิก **"New +"** → **"Blueprint"**

2. **Connect Repository:**
   - เลือก **"Connect GitHub"** (ถ้ายังไม่ได้ connect)
   - เลือก repository: `thaitechzone/Hello-myAppDjango`
   - Branch: `master`

3. **Blueprint Detection:**
   - Render จะค้นหาไฟล์ `render-docker.yaml` อัตโนมัติ
   - จะแสดงรายละเอียด services ที่จะสร้าง:
     * Web Service: `smartfarm-aiots-docker`
     * Database: `smartfarm-db` (PostgreSQL)

4. **Review Configuration:**
   ```yaml
   Services to create:
   - ✓ Web Service (Docker runtime)
   - ✓ PostgreSQL Database (Free tier)
   
   Environment Variables:
   - ✓ DATABASE_URL (from database)
   - ✓ SECRET_KEY (auto-generated)
   - ✓ DEBUG=False
   - ✓ DJANGO_SETTINGS_MODULE=smartfarm.settings_render
   ```

5. **Apply Blueprint:**
   - คลิก **"Apply"**
   - รอ Render สร้าง services (ประมาณ 5-10 นาที)

#### 3️⃣ Monitor Deployment

ดู deployment logs:

```
# Build Process:
[1/5] Building Docker image...
[2/5] Running pip install...
[3/5] Collecting static files...
[4/5] Starting container...
[5/5] Health check passed ✓

==> Your service is live at:
    https://smartfarm-aiots-docker.onrender.com
```

---

## 🔨 Deploy แบบ Manual

ถ้าไม่ใช้ Blueprint สามารถสร้างทีละ service ได้:

### ส่วนที่ 1: สร้าง PostgreSQL Database

1. ไปที่ Render Dashboard
2. คลิก **"New +"** → **"PostgreSQL"**
3. กรอกข้อมูล:
   - **Name:** `smartfarm-db`
   - **Database:** `smartfarm`
   - **User:** `smartfarm_user`
   - **Region:** Singapore (Southeast Asia)
   - **Plan:** Free
4. คลิก **"Create Database"**
5. รอสร้าง database (1-2 นาที)
6. **คัดลอก Internal Database URL** (จะใช้ในขั้นตอนถัดไป)

### ส่วนที่ 2: สร้าง Web Service (Docker)

1. คลิก **"New +"** → **"Web Service"**

2. **Connect Repository:**
   - เลือก `thaitechzone/Hello-myAppDjango`
   - Branch: `master`

3. **Configure Service:**
   ```
   Name: smartfarm-aiots-docker
   Region: Singapore (Southeast Asia)
   Branch: master
   Runtime: Docker
   
   Dockerfile Path: ./Dockerfile.render
   Docker Context: .
   
   Instance Type: Free
   ```

4. **Advanced Settings:**
   - **Auto-Deploy:** Yes (deploy เมื่อ push code)
   - **Health Check Path:** `/`

5. คลิก **"Create Web Service"** แต่**ยังไม่กด Deploy**

### ส่วนที่ 3: ตั้งค่า Environment Variables

ไปที่ **"Environment"** tab และเพิ่ม:

| Variable | Value | Note |
|----------|-------|------|
| `DATABASE_URL` | `postgres://...` | จาก Internal Database URL |
| `SECRET_KEY` | `[Generated]` | Generate ด้วย Python (ดูด้านล่าง) |
| `DEBUG` | `False` | Production mode |
| `DJANGO_SETTINGS_MODULE` | `smartfarm.settings_render` | ใช้ Render settings |
| `ALLOWED_HOSTS` | `.onrender.com` | อนุญาต Render domains |
| `PORT` | `8000` | Port ที่ container ใช้ |

### ส่วนที่ 4: Deploy

1. คลิก **"Manual Deploy"** → **"Deploy latest commit"**
2. ดู logs ตอน build Docker image
3. รอจนกว่า status จะเป็น **"Live"** (5-10 นาที)

---

## ⚙️ ตั้งค่า Environment Variables

### การ Generate SECRET_KEY ที่ปลอดภัย

```python
# วิธีที่ 1: ใช้ Python secrets module (แนะนำ)
python -c "import secrets; print(secrets.token_urlsafe(50))"

# วิธีที่ 2: ใช้ Django
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"

# ตัวอย่างผลลัพธ์:
# XyZ123-aBc456_DeF789-GhI012_JkL345-MnO678_PqR901
```

### Environment Variables ที่จำเป็น

```bash
# Required (ต้องมี)
DATABASE_URL=postgres://user:pass@host:5432/dbname  # จาก Render Database
SECRET_KEY=your-generated-50-character-secret-key   # Generate ใหม่ทุกครั้ง
DEBUG=False                                         # Production = False
DJANGO_SETTINGS_MODULE=smartfarm.settings_render   # ใช้ Render settings
ALLOWED_HOSTS=.onrender.com                        # Domain ที่อนุญาต
PORT=8000                                           # Container port

# Optional (ถ้าต้องการ)
CORS_ALLOWED_ORIGINS=https://yourdomain.com        # CORS origins
```

---

## 🧪 ทดสอบและตรวจสอบ

### 1. ทดสอบเว็บไซต์

เปิด browser ไปที่:
```
https://smartfarm-aiots-docker.onrender.com
```

ควรเห็น:
- ✅ หน้า Landing Page โหลดปกติ
- ✅ Static files (CSS, JS, รูปภาพ) โหลดได้
- ✅ ไม่มี SSL/HTTPS warning (🔒 สีเขียว)

### 2. ทดสอบ Admin Panel

```
https://smartfarm-aiots-docker.onrender.com/admin
```

ถ้ายังไม่ได้สร้าง superuser:

```bash
# ไปที่ Render Dashboard → Web Service → Shell
python manage.py createsuperuser

# กรอกข้อมูล:
Username: admin
Email: admin@example.com
Password: [strong-password]
```

### 3. ตรวจสอบ Logs

ใน Render Dashboard → **"Logs"** tab:

```log
✓ Container started
✓ Running migrations...
✓ Collecting static files...
✓ Starting Gunicorn...
✓ Listening on 0.0.0.0:8000
✓ Health check passed
```

### 4. ทดสอบ Contact Form

1. ไปที่ Contact Form บนเว็บ
2. กรอกข้อมูลและส่ง
3. ตรวจสอบใน Admin Panel → Contact Messages
4. ควรเห็นข้อมูลที่ส่งมา → Database connection ✓

### 5. ตรวจสอบ Health Check

Render จะเรียก health check endpoint อัตโนมัติ:

```bash
# ทดสอบ manual
curl -I https://smartfarm-aiots-docker.onrender.com/

# ควรได้ HTTP 200 OK
```

---

## 🐛 Troubleshooting

### ปัญหา 1: Docker Build Failed

**อาการ:** Build ล้มเหลวตอน `docker build`

**สาเหตุที่เป็นไปได้:**
- `Dockerfile.render` มี syntax error
- `requirements.txt` missing dependencies
- Python version ไม่ตรง

**วิธีแก้:**

```bash
# 1. ทดสอบ build locally
docker build -f Dockerfile.render -t test .

# 2. ตรวจสอบ Render build logs
# ดูว่าขั้นตอนไหนล้มเหลว

# 3. ตรวจสอบ requirements.txt
cat requirements.txt | grep -E "gunicorn|psycopg2-binary|whitenoise|dj-database-url"

# ควรมี:
gunicorn>=21.2.0
psycopg2-binary>=2.9.9
whitenoise>=6.6.0
dj-database-url>=2.1.0
```

### ปัญหา 2: Container Start Failed

**อาการ:** Docker image build สำเร็จ แต่ container ไม่ start

**วิธีแก้:**

```bash
# ตรวจสอบ logs
# Dashboard → Logs → ดูข้อความ error

# ปัญหาที่พบบ่อย:
- ModuleNotFoundError → เพิ่ม package ใน requirements.txt
- Database connection error → ตรวจ DATABASE_URL
- Migration error → รัน python manage.py migrate manual
- Port binding error → ตรวจ PORT environment variable
```

### ปัญหา 3: Health Check Failed

**อาการ:** Container running แต่ health check ล้มเหลว

**วิธีแก้:**

```dockerfile
# ตรวจสอบ HEALTHCHECK ใน Dockerfile.render
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8000}/ || exit 1

# ปัญหา:
- curl ไม่ได้ติดตั้งใน container → เพิ่ม curl ใน apt-get install
- Start time ไม่พอ → เพิ่ม --start-period=90s
- Port ไม่ตรง → ตรวจ PORT environment variable
```

### ปัญหา 4: Static Files ไม่โหลด

**อาการ:** CSS/JS หาย, รูปภาพไม่แสดง

**วิธีแก้:**

```python
# ตรวจสอบ smartfarm/settings_render.py
STATIC_ROOT = BASE_DIR / 'staticfiles'
STATIC_URL = '/static/'

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',  # ต้องอยู่ตำแหน่งที่ 2
    # ...
]

STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# ตรวจสอบใน Dockerfile.render
RUN python manage.py collectstatic --noinput || true
```

### ปัญหา 5: Database Connection Error

**อาการ:** `django.db.utils.OperationalError: could not connect to server`

**วิธีแก้:**

```bash
# 1. ตรวจสอบ DATABASE_URL
# Dashboard → Environment → DATABASE_URL
# รูปแบบ: postgres://user:password@host:5432/dbname

# 2. ตรวจสอบใน settings_render.py
DATABASES = {
    'default': dj_database_url.config(
        default=os.environ.get('DATABASE_URL'),
        conn_max_age=600,
        conn_health_checks=True,
    )
}

# 3. ตรวจสอบ Database status
# Dashboard → Database → Status ต้องเป็น "Available"
```

### ปัญหา 6: Slow Cold Start

**อาการ:** Free tier หลับไปแล้ว ใช้เวลา 30-60 วินาทีในการ wake up

**คำอธิบาย:**
- Render free tier จะ sleep หลัง 15 นาทีไม่มีการใช้งาน
- Docker containers ต้องใช้เวลา start มากกว่า native deployment

**วิธีแก้ (ถ้ารบกวนจริงๆ):**
1. **Upgrade to Starter plan** ($7/เดือน) - ไม่มี sleep
2. **Keep-alive ping** - ใช้ service ping เว็บทุก 10 นาที (ฟรี)
   ```bash
   # ใช้ external service เช่น:
   - UptimeRobot (https://uptimerobot.com)
   - Cronitor (https://cronitor.io)
   ```
3. **Accept delay** - ในโปรเจคส่วนตัว/พัฒนา cold start ยอมรับได้

### ปัญหา 7: Image Size Too Large

**อาการ:** Docker image ใหญ่เกิน 1 GB, upload/deploy ช้า

**วิธีแก้:**

```dockerfile
# ใช้ multi-stage build (Dockerfile.render ใช้อยู่แล้ว)
# Stage 1: Builder (build dependencies)
FROM python:3.11-slim as builder
# ... install build dependencies

# Stage 2: Runtime (รันแค่ production)
FROM python:3.11-slim
COPY --from=builder /opt/venv /opt/venv
# ไม่คัดลอก build tools มา

# ลดขนาดเพิ่ม:
# 1. ใช้ alpine image (แต่อาจมีปัญหา compatibility)
FROM python:3.11-alpine

# 2. ลบ apt cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. เพิ่มใน .dockerignore
*.md
.git/
.github/
venv/
*.pyc
__pycache__/
```

---

## 🔄 เปรียบเทียบ Docker vs Native Build

| คุณสมบัติ | Docker Deployment | Native Build |
|-----------|-------------------|--------------|
| **Build Time** | 🐢 ช้ากว่า (5-10 นาที) | 🐇 เร็วกว่า (3-5 นาที) |
| **Image Size** | 📦 ใหญ่กว่า (~400 MB) | 📦 เล็กกว่า (~100 MB) |
| **Reproducibility** | ✅ สูงมาก (same everywhere) | ⚠️ ปานกลาง (depend on host) |
| **Debugging** | 🐛 ยากกว่า (container layer) | 🐛 ง่ายกว่า (direct access) |
| **Rollback** | ✅ ง่าย (image versioning) | ⚠️ ยากกว่า (rebuild needed) |
| **Cold Start** | 🐢 ช้ากว่า (30-60s) | 🐇 เร็วกว่า (20-30s) |
| **Dependencies** | ✅ Isolated ใน container | ⚠️ ขึ้นกับ host system |
| **Scalability** | ✅ ง่าย (orchestration) | ⚠️ ยากกว่า (manual config) |
| **Best For** | Production, Teams, CI/CD | Solo projects, Prototypes |

### แนะนำการใช้งาน:

#### ใช้ Docker เมื่อ:
- ✅ Deploy production แบบจริงจัง
- ✅ ทีมมีหลายคน (environment consistency)
- ✅ ต้องการ rollback ง่าย
- ✅ มี CI/CD pipeline
- ✅ Scale ขึ้น-ลง บ่อย

#### ใช้ Native Build เมื่อ:
- ✅ โปรเจคส่วนตัว/ทดลอง
- ✅ ต้องการ deploy เร็วที่สุด
- ✅ Resources จำกัด (free tier)
- ✅ Debug บ่อย

---

## 📝 Checklist สำหรับ Production

### ก่อน Deploy:

- [ ] ทดสอบ build Docker image locally สำเร็จ
- [ ] ตรวจสอบ `.dockerignore` ครบถ้วน
- [ ] Generate `SECRET_KEY` ใหม่ (ห้ามใช้ default)
- [ ] `DEBUG=False` ใน production
- [ ] ตั้งค่า `ALLOWED_HOSTS` ถูกต้อง
- [ ] Database backup strategy พร้อม (free tier หมดอายุ 90 วัน)
- [ ] ทดสอบ migrations ใน local environment
- [ ] ทดสอบ collectstatic ใน Docker container

### หลัง Deploy:

- [ ] เว็บไซต์โหลดได้ปกติ (https://)
- [ ] Static files โหลดครบ (CSS/JS/images)
- [ ] Admin panel เข้าได้
- [ ] สร้าง superuser แล้ว
- [ ] Contact form ใช้งานได้
- [ ] Database connection ใช้งานได้
- [ ] Health check passed
- [ ] Logs ไม่มี error

### Maintenance:

- [ ] ตั้ง monitoring/alerting (UptimeRobot)
- [ ] Backup database ทุก 1 สัปดาห์
- [ ] ตรวจสอบ logs เป็นประจำ
- [ ] วางแผน upgrade หลัง 90 วัน (database expiry)
- [ ] Update dependencies ทุก 1-2 เดือน

---

## 🎯 Quick Start (TL;DR)

เริ่มต้นเร็วๆ ใน 5 ขั้นตอน:

```bash
# 1. Push code to GitHub
git add Dockerfile.render render-docker.yaml
git commit -m "🐳 Add Docker deployment for Render"
git push origin master

# 2. Render Dashboard → New + → Blueprint

# 3. Connect GitHub → Select repo → Apply Blueprint

# 4. ตั้งค่า SECRET_KEY
python -c "import secrets; print(secrets.token_urlsafe(50))"
# Copy และตั้งใน Environment Variables

# 5. Create superuser
# Dashboard → Shell:
python manage.py createsuperuser

# ✅ Done! เปิด https://smartfarm-aiots-docker.onrender.com
```

---

## 💡 Tips & Best Practices

### Docker Layer Caching

```dockerfile
# ❌ ไม่ดี - ถ้า code เปลี่ยน ต้อง rebuild ทุกอย่าง
COPY . .
RUN pip install -r requirements.txt

# ✅ ดี - pip install cached ถ้า requirements.txt ไม่เปลี่ยน
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

### Security Best Practices

```dockerfile
# ใช้ non-root user
USER django

# ไม่เก็บ secrets ใน image
# ❌ ENV SECRET_KEY=hardcoded-key
# ✅ ให้ Render inject ผ่าน environment variables

# Pin Python version ชัดเจน
FROM python:3.11-slim  # ไม่ใช้ :latest
```

### Multi-Environment Support

```dockerfile
# รองรับทั้ง Render และ Docker Desktop
ENV DJANGO_SETTINGS_MODULE=${DJANGO_SETTINGS_MODULE:-smartfarm.settings_render}
ENV PORT=${PORT:-8000}

# CMD ที่ flexible
CMD gunicorn smartfarm.wsgi:application --bind 0.0.0.0:${PORT}
```

---

## 📚 Resources & Links

- **Render Docker Documentation:** https://render.com/docs/docker
- **Render Environment Variables:** https://render.com/docs/environment-variables
- **Django Production Checklist:** https://docs.djangoproject.com/en/stable/howto/deployment/checklist/
- **Docker Best Practices:** https://docs.docker.com/develop/dev-best-practices/
- **Multi-stage Builds:** https://docs.docker.com/build/building/multi-stage/

---

## 🆘 ต้องการความช่วยเหลือ?

ถ้าติดปัญหาหรือมีคำถาม:

1. ตรวจสอบ **Logs** ใน Render Dashboard ก่อน
2. ดู **Troubleshooting** section ด้านบน
3. ทดสอบ build Docker locally: `docker build -f Dockerfile.render .`
4. เปรียบเทียบกับ `RENDER_DEPLOY.md` (native build) ว่าปัญหาเฉพาะ Docker หรือไม่

---

**สร้างเมื่อ:** มีนาคม 2026  
**เวอร์ชัน:** 1.0  
**อัปเดทล่าสุด:** มีนาคม 2026

🚀 Happy Deploying with Docker! 🐳
