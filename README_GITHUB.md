# 🌱 Smart Farm AIOTs - Landing Page

<div align="center">

![Django](https://img.shields.io/badge/Django-5.0-green?style=for-the-badge&logo=django)
![Docker](https://img.shields.io/badge/Docker-Ready-blue?style=for-the-badge&logo=docker)
![Python](https://img.shields.io/badge/Python-3.11+-yellow?style=for-the-badge&logo=python)
![License](https://img.shields.io/badge/License-MIT-red?style=for-the-badge)

Landing page สำหรับระบบ Smart Farm AIOTs - เทคโนโลยี IoT เพื่อการเกษตรอัจฉริยะ

[Demo](#) • [Documentation](README.md) • [Docker Guide](DOCKER_README.md)

</div>

---

## 📖 เกี่ยวกับโปรเจค

Smart Farm AIOTs เป็นแพลตฟอร์มการเกษตรอัจฉริยะที่ใช้เทคโนโลยี Internet of Things (IoT) ในการติดตามและควบคุมฟาร์มแบบ Real-time ระบบนี้ช่วยเพิ่มผลผลิต ลดการใช้น้ำ และอำนวยความสะดวกให้เกษตรกรในการจัดการฟาร์ม

### ✨ Features

- 🌡️ **ตติดตามความชื้นในดิน** - เซ็นเซอร์วัดความชื้นแบบ Real-time
- 💧 **ระบบรดน้ำอัตโนมัติ** - เปิด-ปิดน้ำอัตโนมัติตามความต้องการของพืช
- 🌦️ **ติดตามสภาพอากาศ** - พยากรณ์อากาศและการวางแผนการทำงาน
- 📊 **วิเคราะห์ข้อมูล** - Dashboard แสดงข้อมูลและแนวโน้ม
- 📱 **ควบคุมผ่านมือถือ** - Web Application ที่ใช้งานง่ายทุกที่ทุกเวลา
- 🔔 **แจ้งเตือนอัจฉริยะ** - แจ้งเตือนเมื่อมีสถานการณ์ผิดปกติ

---

## 🚀 Quick Start

### ตัวเลือกที่ 1: รันด้วย Docker (แนะนำ)

```bash
# 1. Clone repository
git clone https://github.com/yourusername/smartfarm-aiots.git
cd smartfarm-aiots

# 2. สร้างไฟล์ .env
copy .env.example .env
# แก้ไขค่า SECRET_KEY และ POSTGRES_PASSWORD

# 3. รัน Docker Compose
docker-compose up -d --build

# 4. รัน migrations และสร้าง superuser
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser

# 5. เปิดเบราว์เซอร์
# http://localhost
```

### ตัวเลือกที่ 2: รันแบบ Traditional

```bash
# 1. Clone repository
git clone https://github.com/yourusername/smartfarm-aiots.git
cd smartfarm-aiots

# 2. สร้าง virtual environment
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # Linux/Mac

# 3. ติดตั้ง dependencies
pip install -r requirements.txt

# 4. รัน migrations
python manage.py migrate

# 5. สร้าง superuser
python manage.py createsuperuser

# 6. รัน development server
python manage.py runserver

# 7. เปิดเบราว์เซอร์
# http://127.0.0.1:8000
```

---

## 📁 โครงสร้างโปรเจค

```
smartfarm-aiots/
│
├── smartfarm/              # Django project settings
│   ├── settings.py         # Main settings
│   ├── settings_docker.py  # Docker production settings
│   ├── urls.py            # URL routing
│   └── wsgi.py            # WSGI application
│
├── landing/               # Landing page app
│   ├── models.py          # ContactMessage model
│   ├── views.py           # View logic
│   ├── admin.py           # Admin configuration
│   ├── templates/         # HTML templates
│   └── static/            # CSS, JS, images
│
├── Dockerfile             # Production Docker image
├── docker-compose.yml     # Production services
├── nginx.conf             # Nginx configuration
├── requirements.txt       # Python dependencies
├── .gitignore            # Git ignore rules
└── README.md             # Thai documentation
```

---

## 🛠️ Tech Stack

### Backend
- **Django 5.0** - Python Web Framework
- **Gunicorn** - WSGI HTTP Server
- **PostgreSQL 15** - Production Database
- **SQLite** - Development Database

### Frontend
- **HTML5** - Structure
- **CSS3** - Styling (Responsive Design)
- **JavaScript (Vanilla)** - Interactivity
- **Font Awesome 6** - Icons

### DevOps
- **Docker & Docker Compose** - Containerization
- **Nginx** - Reverse Proxy & Static Files
- **WhiteNoise** - Static Files Serving

---

## 📊 Database Schema

### ContactMessage Model
```python
class ContactMessage(models.Model):
    name = CharField(max_length=100)       # ชื่อผู้ติดต่อ
    email = EmailField()                   # อีเมล
    phone = CharField(max_length=20)       # เบอร์โทร
    message = TextField()                  # ข้อความ
    created_at = DateTimeField(auto_now_add=True)  # วันที่ส่ง
```

---

## 🌐 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | หน้า Landing Page |
| `/` | POST | ส่งข้อความติดต่อ |
| `/admin/` | GET | Django Admin Panel |

---

## 🐳 Docker Deployment

### Production Environment (Nginx + PostgreSQL)

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Development Environment

```bash
# Start dev server with hot reload
docker-compose -f docker-compose.dev.yml up

# Access at http://localhost:8000
```

รายละเอียดเพิ่มเติม: [DOCKER_README.md](DOCKER_README.md)

---

## 📱 Screenshots

### Landing Page
- Hero Section พร้อม CTA
- Features Grid (6 ความสามารถหลัก)
- About Section (สถิติและข้อมูล)
- Contact Form (บันทึกลง Database)

---

## 🔐 Security

### Production Checklist

- ✅ Change `SECRET_KEY` to random 50+ characters
- ✅ Set `DEBUG=False`
- ✅ Use strong `POSTGRES_PASSWORD`
- ✅ Configure `ALLOWED_HOSTS` correctly
- ✅ Enable HTTPS/SSL
- ✅ Use environment variables for secrets
- ✅ Regular security updates
- ✅ Database backups

---

## 📝 Environment Variables

สร้างไฟล์ `.env` จาก `.env.example`:

```env
# Django
DEBUG=False
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,yourdomain.com

# Database
POSTGRES_DB=smartfarm
POSTGRES_USER=smartfarm_user
POSTGRES_PASSWORD=your-strong-password
```

---

## 🧪 Testing

```bash
# Run tests
python manage.py test

# With Docker
docker-compose exec web python manage.py test
```

---

## 📦 Dependencies

Main packages:
- `Django>=5.0,<6.0` - Web framework
- `Pillow>=10.0.0` - Image processing
- `gunicorn>=21.2.0` - WSGI server
- `psycopg2-binary>=2.9.9` - PostgreSQL adapter
- `whitenoise>=6.6.0` - Static files
- `dj-database-url>=2.1.0` - Database configuration

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team

**Smart Farm AIOTs Development Team**

- GitHub: [@yourusername](https://github.com/yourusername)
- Email: contact@smartfarm-aiots.com

---

## 🙏 Acknowledgments

- Django Community
- Docker Community
- Font Awesome
- Bootstrap (inspiration)

---

## 📞 Support

ถ้ามีคำถามหรือปัญหา:

- 📧 Email: support@smartfarm-aiots.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/smartfarm-aiots/issues)
- 📖 Documentation: [README.md](README.md) (ภาษาไทย)
- 🐳 Docker Guide: [DOCKER_README.md](DOCKER_README.md) (ภาษาไทย)

---

<div align="center">

**Made with ❤️ for Thai Farmers**

⭐ Star this repo if you find it helpful!

</div>
