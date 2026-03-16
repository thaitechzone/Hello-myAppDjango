# 🌱 Smart Farm AIOTs - Landing Page

ระบบ Landing Page สำหรับ Smart Farm AIOTs (เกษตรอัจฉริยะด้วย Internet of Things)  
พัฒนาด้วย Django Framework 5.0

---

## 📋 สารบัญ

1. [เกี่ยวกับโปรเจค](#เกี่ยวกับโปรเจค)
2. [ฟีเจอร์](#ฟีเจอร์)
3. [เทคโนโลยีที่ใช้](#เทคโนโลยีที่ใช้)
4. [การติดตั้งและรันโปรเจค](#การติดตั้งและรันโปรเจค)
5. [โครงสร้างโปรเจค](#โครงสร้างโปรเจค)
6. [การใช้งาน](#การใช้งาน)
7. [การพัฒนาต่อยอด](#การพัฒนาต่อยอด)

---

## 🎯 เกี่ยวกับโปรเจค

**Smart Farm AIOTs Landing Page** เป็นเว็บไซต์หน้าแรกสำหรับนำเสนอระบบจัดการฟาร์มอัจฉริยะที่ใช้เทคโนโลยี IoT (Internet of Things) และ AI (Artificial Intelligence)

### วัตถุประสงค์:
- นำเสนอฟีเจอร์และความสามารถของระบบ Smart Farm
- รับข้อมูลการติดต่อจากลูกค้าที่สนใจ
- สร้างภาพลักษณ์ที่ทันสมัยและน่าเชื่อถือ
- แสดงสถิติความสำเร็จและผลลัพธ์

---

## ✨ ฟีเจอร์

### 1. **หน้าแรก (Hero Section)**
   - ข้อความต้อนรับที่น่าสนใจ
   - ปุ่มเริ่มต้นใช้งานและเรียนรู้เพิ่มเติม
   - ออกแบบ Responsive รองรับทุกอุปกรณ์

### 2. **ส่วนแสดงฟีเจอร์ (Features)**
   - 🌱 ระบบตรวจวัดดิน
   - 💧 ระบบรดน้ำอัตโนมัติ
   - 🌡️ ตรวจสอบสภาพอากาศ
   - 📊 วิเคราะห์ข้อมูล
   - 📱 ควบคุมผ่านมือถือ
   - 🔔 แจ้งเตือนอัจฉริยะ

### 3. **เกี่ยวกับเรา (About Section)**
   - ข้อมูลบริษัทและวิสัยทัศน์
   - สถิติความสำเร็จ (500+ ฟาร์ม, ประหยัด 30%, เพิ่มผลผลิต 40%)

### 4. **ติดต่อเรา (Contact Section)**
   - ฟอร์มส่งข้อความ
   - ข้อมูลการติดต่อ (ที่อยู่, โทรศัพท์, อีเมล)
   - บันทึกข้อมูลลงฐานข้อมูล

### 5. **ระบบ Admin**
   - จัดการข้อความติดต่อจากลูกค้า
   - ระบบค้นหาและกรองข้อมูล

---

## 🛠️ เทคโนโลยีที่ใช้

### Backend:
- **Django 5.0** - Web Framework
- **SQLite** - ฐานข้อมูล (สามารถเปลี่ยนเป็น PostgreSQL/MySQL ได้)

### Frontend:
- **HTML5** - โครงสร้างหน้าเว็บ
- **CSS3** - การออกแบบและ Styling
- **JavaScript** - Interactivity และ Animation
- **Font Awesome** - Icons

### คุณสมบัติพิเศษ:
- Responsive Design (รองรับมือถือ, แท็บเล็ต, คอมพิวเตอร์)
- Smooth Scrolling
- Animation on Scroll
- Modern Gradient Design

---

## 📦 การติดตั้งและรันโปรเจค

### ขั้นตอนที่ 1: ติดตั้ง Python
ตรวจสอบว่าคุณมี Python 3.8+ ติดตั้งแล้ว:
```bash
python --version
```

### ขั้นตอนที่ 2: สร้าง Virtual Environment
เปิด Terminal/Command Prompt และรันคำสั่ง:

**Windows:**
```bash
python -m venv venv
venv\Scripts\activate
```

**macOS/Linux:**
```bash
python3 -m venv venv
source venv/bin/activate
```

### ขั้นตอนที่ 3: ติดตั้ง Dependencies
```bash
pip install -r requirements.txt
```

### ขั้นตอนที่ 4: สร้างฐานข้อมูล
```bash
python manage.py makemigrations
python manage.py migrate
```

### ขั้นตอนที่ 5: สร้าง Superuser (Admin)
```bash
python manage.py createsuperuser
```
- กรอก Username, Email, และ Password ตามที่ระบบถาม

### ขั้นตอนที่ 6: รัน Development Server
```bash
python manage.py runserver
```

### ขั้นตอนที่ 7: เปิดเว็บไซต์
เปิดเบราว์เซอร์และไปที่:
- **หน้าแรก:** http://127.0.0.1:8000/
- **Admin Panel:** http://127.0.0.1:8000/admin/

---

## 📁 โครงสร้างโปรเจค

```
Hello myAppDjango/
│
├── smartfarm/                 # โฟลเดอร์หลักของ Django Project
│   ├── __init__.py
│   ├── settings.py           # การตั้งค่าโปรเจค
│   ├── urls.py               # URL Configuration หลัก
│   ├── wsgi.py               # WSGI สำหรับ Production
│   └── asgi.py               # ASGI สำหรับ Async
│
├── landing/                   # Django App สำหรับ Landing Page
│   ├── migrations/           # Database Migrations
│   ├── static/landing/       # ไฟล์ Static (CSS, JS, Images)
│   │   ├── css/
│   │   │   └── style.css    # Stylesheet หลัก
│   │   └── js/
│   │       └── main.js      # JavaScript หลัก
│   │
│   ├── templates/landing/    # HTML Templates
│   │   └── index.html       # หน้าแรก
│   │
│   ├── __init__.py
│   ├── admin.py             # Admin Panel Configuration
│   ├── apps.py              # App Configuration
│   ├── models.py            # Database Models
│   ├── views.py             # View Functions
│   ├── urls.py              # URL Patterns
│   └── tests.py             # Unit Tests
│
├── manage.py                 # Django Management Script
├── requirements.txt          # Python Dependencies
└── README.md                 # คู่มือนี้
```

---

## 💻 การใช้งาน

### 1. การดูหน้าเว็บ Landing Page
- เปิดเบราว์เซอร์ไปที่ `http://127.0.0.1:8000/`
- สามารถ Scroll ดูส่วนต่างๆ ได้
- คลิกที่เมนูเพื่อเลื่อนไปยังส่วนที่ต้องการ (Smooth Scroll)

### 2. การใช้งานฟอร์มติดต่อ
1. Scroll ลงมาที่ส่วน "ติดต่อเรา"
2. กรอกข้อมูลในฟอร์ม:
   - ชื่อ (จำเป็น)
   - อีเมล (จำเป็น)
   - เบอร์โทรศัพท์ (ไม่จำเป็น)
   - ข้อความ (จำเป็น)
3. กดปุ่ม "ส่งข้อความ"
4. ระบบจะบันทึกข้อมูลและแสดงข้อความยืนยัน

### 3. การดูข้อความติดต่อใน Admin Panel
1. เข้าสู่ระบบ Admin: `http://127.0.0.1:8000/admin/`
2. ใช้ Username/Password ที่สร้างไว้ใน `createsuperuser`
3. คลิกที่ "ข้อความติดต่อทั้งหมด"
4. สามารถดู, ค้นหา, กรองข้อมูลได้

---

## 🎨 การปรับแต่ง

### เปลี่ยนสี Theme:
แก้ไขไฟล์ `landing/static/landing/css/style.css`

```css
:root {
    --primary-color: #10b981;      /* สีหลัก */
    --secondary-color: #059669;    /* สีรอง */
    --dark-color: #1f2937;         /* สีเข้ม */
    --light-color: #f3f4f6;        /* สีอ่อน */
}
```

### เปลี่ยนข้อความ:
แก้ไขไฟล์ `landing/templates/landing/index.html`

### เพิ่มฟีเจอร์:
แก้ไขไฟล์ `landing/views.py` ในส่วน:
```python
'features': [
    {
        'icon': '🌱',
        'title': 'ฟีเจอร์ใหม่',
        'description': 'คำอธิบายฟีเจอร์'
    },
]
```

---

## 🚀 การพัฒนาต่อยอด

### 1. เพิ่มระบบสมัครสมาชิก
```bash
python manage.py startapp accounts
```

### 2. เชื่อมต่อกับระบบ Payment
- เพิ่ม Package: `stripe`, `omise`
- สร้าง View สำหรับชำระเงิน

### 3. เพิ่ม Dashboard
- สร้าง App ใหม่สำหรับ Dashboard
- แสดงข้อมูลเซ็นเซอร์แบบเรียลไทม์

### 4. เชื่อมต่อกับ IoT Devices
- ใช้ MQTT Protocol
- เพิ่ม Package: `paho-mqtt`

### 5. Deploy ไปยัง Production
**ใช้ Heroku:**
```bash
pip install gunicorn
heroku create smartfarm-aiots
git push heroku main
```

**ใช้ AWS/Azure:**
- ตั้งค่า Nginx + Gunicorn
- ใช้ PostgreSQL แทน SQLite

---

## 🧪 การทำ Unit Testing

รัน Tests:
```bash
python manage.py test
```

สร้าง Test ใหม่ในไฟล์ `landing/tests.py`

---

## 📝 คำสั่ง Django ที่ใช้บ่อย

| คำสั่ง | คำอธิบาย |
|--------|----------|
| `python manage.py runserver` | รัน Development Server |
| `python manage.py makemigrations` | สร้างไฟล์ Migration |
| `python manage.py migrate` | ใช้งาน Migrations กับฐานข้อมูล |
| `python manage.py createsuperuser` | สร้าง Admin User |
| `python manage.py collectstatic` | รวบรวมไฟล์ Static |
| `python manage.py shell` | เปิด Django Shell |
| `python manage.py test` | รัน Unit Tests |

---

## 🔒 Security Checklist (สำหรับ Production)

- [ ] เปลี่ยน `SECRET_KEY` ในไฟล์ `settings.py`
- [ ] ตั้งค่า `DEBUG = False`
- [ ] กำหนด `ALLOWED_HOSTS`
- [ ] ใช้ HTTPS
- [ ] ใช้ฐานข้อมูล PostgreSQL/MySQL
- [ ] ตั้งค่า CSRF Protection
- [ ] เพิ่ม Security Headers
- [ ] สำรองข้อมูลสม่ำเสมอ

---

## 📚 เอกสารอ้างอิง

- [Django Official Documentation](https://docs.djangoproject.com/)
- [Django Tutorial (Thai)](https://docs.djangoproject.com/th/5.0/)
- [Bootstrap Documentation](https://getbootstrap.com/)
- [Font Awesome Icons](https://fontawesome.com/)

---

## 👨‍💻 ผู้พัฒนา

พัฒนาโดย: Smart Farm AIOTs Team  
วันที่สร้างโปรเจค: มีนาคม 2026  
Framework: Django 5.0  
License: MIT

---

## 🆘 การแก้ปัญหา (Troubleshooting)

### ปัญหา: ImportError - No module named 'django'
**วิธีแก้:** ติดตั้ง Django
```bash
pip install Django
```

### ปัญหา: Port 8000 ถูกใช้งานแล้ว
**วิธีแก้:** ใช้ Port อื่น
```bash
python manage.py runserver 8080
```

### ปัญหา: Static files ไม่แสดง
**วิธีแก้:** รัน collectstatic
```bash
python manage.py collectstatic
```

### ปัญหา: Database locked
**วิธีแก้:** ปิดโปรแกรมที่เปิดไฟล์ `db.sqlite3` อยู่

---

## 📞 ติดต่อสอบถาม

หากมีคำถามหรือต้องการความช่วยเหลือ:
- 📧 Email: support@smartfarm.com
- 📱 LINE: @smartfarm
- 🌐 Website: https://smartfarm.com

---

**Happy Coding! 🌱💚**
