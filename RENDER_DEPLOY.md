# 🚀 คู่มือ Deploy Django บน Render

## 📋 สารบัญ
1. [เกี่ยวกับ Render](#เกี่ยวกับ-render)
2. [เตรียมโปรเจค](#เตรียมโปรเจค)
3. [สร้าง Account Render](#สร้าง-account-render)
4. [Deploy ด้วย Blueprint (render.yaml)](#deploy-ด้วย-blueprint)
5. [Deploy แบบ Manual](#deploy-แบบ-manual)
6. [ตั้งค่า Environment Variables](#ตั้งค่า-environment-variables)
7. [ตั้งค่า Custom Domain](#ตั้งค่า-custom-domain)
8. [Troubleshooting](#troubleshooting)

---

## 🌟 เกี่ยวกับ Render

**Render** คือ Cloud Platform สำหรับ deploy web applications ที่:
- ✅ มี **Free Tier** (750 ชั่วโมง/เดือน)
- ✅ รองรับ **PostgreSQL ฟรี** (90 วันแล้วต้องต่ออายุ)
- ✅ **Auto Deploy** จาก Git (push แล้ว deploy อัตโนมัติ)
- ✅ มี **SSL/HTTPS ฟรี**
- ✅ ใช้งาน**ง่ายกว่า AWS/GCP**

**ข้อจำกัดของ Free Tier:**
- Web Service จะ **sleep หลังไม่มีการใช้งาน 15 นาที**
- เปิดครั้งแรกจะ **ใช้เวลา 30-50 วินาที** (cold start)
- Database ฟรี **90 วัน** (หลังจากนั้นต้องต่ออายุหรืออัปเกรด)

---

## 📦 เตรียมโปรเจค

### ไฟล์ที่จำเป็น (สร้างให้แล้ว ✅)

1. **`build.sh`** - Script สำหรับ build โปรเจค
2. **`render.yaml`** - Blueprint config (deploy อัตโนมัติ)
3. **`smartfarm/settings_render.py`** - Django settings สำหรับ production
4. **`requirements.txt`** - Python dependencies

### ตรวจสอบ requirements.txt

ตรวจสอบว่ามีแพ็คเกจเหล่านี้ครบ:

```txt
Django>=5.0,<6.0
Pillow>=10.0.0
gunicorn>=21.2.0
psycopg2-binary>=2.9.9
whitenoise>=6.6.0
dj-database-url>=2.1.0
python-dotenv>=1.0.0
```

### แก้ไข wsgi.py

แก้ไขไฟล์ `smartfarm/wsgi.py` ให้ใช้ settings_render:

```python
import os
from django.core.wsgi import get_wsgi_application

# Use Render settings for production
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'smartfarm.settings_render')

application = get_wsgi_application()
```

### ตั้งค่า build.sh ให้ Run ได้

```bash
# Windows: แปลง line endings (ถ้าใช้ Git Bash)
dos2unix build.sh

# หรือใน Git
git add build.sh
git update-index --chmod=+x build.sh
```

---

## 🎯 สร้าง Account Render

1. ไปที่ https://render.com
2. คลิก **"Get Started for Free"**
3. Sign up ด้วย:
   - GitHub Account (แนะนำ)
   - GitLab Account
   - Email

4. ยืนยัน Email

---

## 🚀 Deploy ด้วย Blueprint (วิธีที่ 1 - แนะนำ)

### ขั้นตอน

#### 1. Push โค้ดขึ้น GitHub

```bash
# เพิ่มไฟล์ใหม่
git add .

# Commit
git commit -m "🚀 Add Render deployment config"

# Push
git push origin master
```

#### 2. เชื่อมต่อ GitHub กับ Render

1. เข้า Render Dashboard: https://dashboard.render.com
2. คลิก **"New +"** → **"Blueprint"**
3. เลือก **"Connect GitHub"** (หรือ GitLab ถ้าใช้ GitLab)
4. Authorize Render เข้าถึง GitHub
5. เลือก Repository: **`Hello-myAppDjango`**

#### 3. Deploy จาก Blueprint

1. Render จะอ่านไฟล์ `render.yaml` อัตโนมัติ
2. ตรวจสอบค่าต่างๆ:
   - **Web Service**: `smartfarm-aiots`
   - **Database**: `smartfarm-db` (PostgreSQL)
3. คลิก **"Apply"**

#### 4. รอ Deploy เสร็จ

- Progress bar จะแสดงสถานะ
- ใช้เวลาประมาณ **5-10 นาที**
- ดู Logs ได้ที่ **"Logs"** tab

#### 5. เปิดเว็บไซต์

URL จะเป็น: `https://smartfarm-aiots.onrender.com`

---

## 🛠️ Deploy แบบ Manual (วิธีที่ 2)

### A. สร้าง PostgreSQL Database ก่อน

1. ใน Render Dashboard คลิก **"New +"** → **"PostgreSQL"**
2. กรอกข้อมูล:
   - **Name**: `smartfarm-db`
   - **Database**: `smartfarm`
   - **User**: `smartfarm_user`
   - **Region**: `Singapore` (ใกล้ไทยที่สุด)
   - **Plan**: **Free**
3. คลิก **"Create Database"**
4. รอจน Status = **"Available"** (1-2 นาที)
5. **คัดลอก Internal Database URL** (ขึ้นต้นด้วย `postgresql://`)

### B. สร้าง Web Service

1. คลิก **"New +"** → **"Web Service"**
2. เลือก **"Build and deploy from a Git repository"**
3. Connect Repository:
   - คลิก **"Connect GitHub"**
   - เลือก **`Hello-myAppDjango`**
4. กรอกข้อมูล:
   - **Name**: `smartfarm-aiots`
   - **Region**: `Singapore`
   - **Branch**: `master`
   - **Runtime**: **Python 3**
   - **Build Command**: `./build.sh`
   - **Start Command**: `gunicorn smartfarm.wsgi:application`
   - **Plan**: **Free**

5. คลิก **"Advanced"** และเพิ่ม Environment Variables:

```
PYTHON_VERSION=3.11.0
DATABASE_URL=<paste internal database URL>
SECRET_KEY=<generate random 50+ characters>
DEBUG=False
ALLOWED_HOSTS=.onrender.com
DJANGO_SETTINGS_MODULE=smartfarm.settings_render
```

6. คลิก **"Create Web Service"**

### C. รอ Deploy

- ดู Logs แบบ realtime
- Deploy สำเร็จจะแสดง **"Your service is live 🎉"**

---

## 🔐 ตั้งค่า Environment Variables

### สร้าง SECRET_KEY

```python
# รันใน Python shell
import secrets
print(secrets.token_urlsafe(50))
# คัดลอกค่าที่ได้
```

### Environment Variables ที่จำเป็น

| Key | Value | คำอธิบาย |
|-----|-------|----------|
| `PYTHON_VERSION` | `3.11.0` | Python version |
| `DATABASE_URL` | `postgresql://...` | Database connection (Render จะใส่ให้อัตโนมัติ) |
| `SECRET_KEY` | `<random-50-chars>` | Django secret key |
| `DEBUG` | `False` | ปิด debug mode |
| `ALLOWED_HOSTS` | `.onrender.com` | Allowed domains |
| `DJANGO_SETTINGS_MODULE` | `smartfarm.settings_render` | Settings file |

### เพิ่ม Environment Variables (Manual)

1. ไปที่ Web Service Dashboard
2. คลิก **"Environment"** tab
3. คลิก **"Add Environment Variable"**
4. กรอก Key และ Value
5. คลิก **"Save Changes"**

---

## 🌐 ตั้งค่า Custom Domain

### ใช้ Domain ของตัวเอง

1. ซื้อ Domain (Namecheap, GoDaddy, Cloudflare)
2. ใน Render Dashboard → **"Settings"** → **"Custom Domains"**
3. คลิก **"Add Custom Domain"**
4. กรอก Domain: `www.yourdomain.com`
5. Render จะให้ **CNAME Record**:
   ```
   CNAME: www → smartfarm-aiots.onrender.com
   ```
6. ไปที่ DNS Provider ของคุณ เพิ่ม CNAME Record
7. รอ DNS propagate (5-30 นาที)
8. Render จะออก **SSL Certificate อัตโนมัติ**

### อัปเดต ALLOWED_HOSTS

แก้ไข Environment Variable:
```
ALLOWED_HOSTS=.onrender.com,yourdomain.com,www.yourdomain.com
```

---

## 🔧 จัดการโปรเจคหลัง Deploy

### สร้าง Superuser

1. ไปที่ Web Service Dashboard
2. คลิก **"Shell"** tab
3. รันคำสั่ง:
```bash
python manage.py createsuperuser
```
4. กรอก username, email, password

### รัน Migrations

```bash
# ใน Shell tab
python manage.py migrate
```

### Collect Static Files

```bash
python manage.py collectstatic --no-input
```

### ดู Logs

- คลิก **"Logs"** tab
- ดู logs แบบ real-time
- กรอง log levels: Info, Warning, Error

### Redeploy

```bash
# Push โค้ดใหม่
git add .
git commit -m "Update code"
git push

# Render จะ Auto Deploy อัตโนมัติ
```

### Manual Deploy

- ใน Dashboard คลิก **"Manual Deploy"** → **"Deploy latest commit"**

---

## 🐛 Troubleshooting

### ปัญหา: Build Failed

**สาเหตุ:**
- `build.sh` ไม่มีสิทธิ์ execute

**แก้ไข:**
```bash
git update-index --chmod=+x build.sh
git commit -m "Fix build.sh permissions"
git push
```

### ปัญหา: ModuleNotFoundError

**สาเหตุ:**
- ขาดแพ็คเกจใน `requirements.txt`

**แก้ไข:**
```bash
# เพิ่มแพ็คเกจที่ขาด
echo "package-name>=1.0.0" >> requirements.txt
git add requirements.txt
git commit -m "Add missing package"
git push
```

### ปัญหา: Static Files ไม่โหลด

**สาเหตุ:**
- ไม่ได้รัน collectstatic

**แก้ไข:**
```bash
# ใน Shell tab
python manage.py collectstatic --no-input
```

**ตรวจสอบ settings:**
```python
# ใน settings_render.py
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
MIDDLEWARE = [
    ...
    'whitenoise.middleware.WhiteNoiseMiddleware',  # ต้องมี
    ...
]
```

### ปัญหา: Database Connection Error

**สาเหตุ:**
- DATABASE_URL ไม่ถูกต้อง

**แก้ไข:**
1. ไปที่ PostgreSQL Dashboard
2. คัดลอก **Internal Database URL**
3. ไปที่ Web Service → Environment
4. อัปเดต `DATABASE_URL`

### ปัญหา: DisallowedHost Error

**สาเหตุ:**
- Domain ไม่อยู่ใน ALLOWED_HOSTS

**แก้ไข:**
```python
# อัปเดต Environment Variable
ALLOWED_HOSTS=.onrender.com,*.onrender.com,yourdomain.com
```

### ปัญหา: Service ช้า (Cold Start)

**สาเหตุ:**
- Free tier จะ sleep หลังไม่ใช้งาน 15 นาที

**แก้ไข:**
- อัปเกรดเป็น Paid plan ($7/month)
- หรือใช้ **UptimeRobot** ping ทุก 5 นาที (อาจถูก Render แบน)

### ปัญหา: Database หมดอายุ 90 วัน

**สาเหตุ:**
- PostgreSQL Free tier หมดอายุทุก 90 วัน

**แก้ไข:**
1. ก่อนหมดอายุ: Export database
```bash
pg_dump $DATABASE_URL > backup.sql
```
2. สร้าง Database ใหม่
3. Import ข้อมูลกลับ
```bash
psql $NEW_DATABASE_URL < backup.sql
```

---

## 📊 เปรียบเทียบ Render Plans

| Feature | Free | Starter ($7/mo) |
|---------|------|-----------------|
| RAM | 512 MB | 512 MB |
| Storage | - | - |
| Sleep | ✅ Yes (15 min) | ❌ No |
| Build Minutes | 500/mo | Unlimited |
| Bandwidth | 100 GB/mo | 100 GB/mo |
| Custom Domain | ✅ | ✅ |
| SSL | ✅ | ✅ |

---

## 🎯 Checklist หลัง Deploy

- [ ] เว็บไซต์เปิดได้: `https://smartfarm-aiots.onrender.com`
- [ ] Admin panel เข้าได้: `/admin`
- [ ] Static files โหลดสมบูรณ์
- [ ] Contact form บันทึกข้อมูลได้
- [ ] Database ทำงานปกติ
- [ ] SSL/HTTPS ทำงาน (ไอคอน🔒)
- [ ] ไม่มี error ใน Logs
- [ ] สร้าง superuser แล้ว

---

## 🚀 ขั้นตอนสรุป (TL;DR)

```bash
# 1. Push โค้ดขึ้น GitHub
git add .
git commit -m "🚀 Add Render config"
git push

# 2. ไปที่ Render Dashboard
# https://dashboard.render.com

# 3. New + → Blueprint

# 4. Connect GitHub → เลือก Repository

# 5. Apply Blueprint

# 6. รอ 5-10 นาที

# 7. เปิด https://smartfarm-aiots.onrender.com

# 8. สร้าง Superuser (ใน Shell tab)
python manage.py createsuperuser

# ✅ เสร็จสิ้น!
```

---

## 📚 Resources

- [Render Docs](https://render.com/docs)
- [Django Deployment](https://docs.djangoproject.com/en/5.0/howto/deployment/)
- [Render Community](https://community.render.com/)

---

## 💡 Tips

1. **ใช้ Blueprint (`render.yaml`)** - Deploy อัตโนมัติและจัดการง่าย
2. **Monitor Logs** - เช็คใน Logs tab เป็นประจำ
3. **Backup Database** - Export ก่อนหมดอายุ 90 วัน
4. **Environment Variables** - เก็บใน Render ไม่ต้อง commit `.env`
5. **Custom Domain** - ใช้ Cloudflare เป็น DNS (ฟรีและเร็ว)

---

**พร้อม Deploy แล้ว!** 🚀 ลองทำตามขั้นตอนดูครับ

หากมีปัญหาหรือข้อสงสัย แจ้งได้เลยครับ!
