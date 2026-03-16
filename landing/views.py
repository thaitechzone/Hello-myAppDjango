from django.shortcuts import render, redirect
from django.contrib import messages
from .models import ContactMessage


def index(request):
    """
    View สำหรับหน้า Landing Page หลัก
    """
    if request.method == 'POST':
        # รับข้อมูลจากฟอร์ม
        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone', '')
        message_text = request.POST.get('message')
        
        # บันทึกข้อมูลลงฐานข้อมูล
        ContactMessage.objects.create(
            name=name,
            email=email,
            phone=phone,
            message=message_text
        )
        
        messages.success(request, 'ส่งข้อความสำเร็จ! เราจะติดต่อกลับโดยเร็วที่สุด')
        return redirect('index')
    
    # ข้อมูลสำหรับแสดงในหน้า Landing Page
    context = {
        'features': [
            {
                'icon': '🌱',
                'title': 'ระบบตรวจวัดดิน',
                'description': 'วัดค่า pH, ความชื้น และสารอาหารในดินแบบเรียลไทม์'
            },
            {
                'icon': '💧',
                'title': 'ระบบรดน้ำอัตโนมัติ',
                'description': 'ควบคุมการให้น้ำตามความต้องการของพืชผ่านแอพมือถือ'
            },
            {
                'icon': '🌡️',
                'title': 'ตรวจสอบสภาพอากาศ',
                'description': 'วัดอุณหภูมิ ความชื้น และแสงอาทิตย์ตลอด 24 ชั่วโมง'
            },
            {
                'icon': '📊',
                'title': 'วิเคราะห์ข้อมูล',
                'description': 'Dashboard แสดงสถิติและข้อมูลการเติบโตของพืช'
            },
            {
                'icon': '📱',
                'title': 'ควบคุมผ่านมือถือ',
                'description': 'จัดการฟาร์มได้ทุกที่ทุกเวลาผ่าน Mobile App'
            },
            {
                'icon': '🔔',
                'title': 'แจ้งเตือนอัจฉริยะ',
                'description': 'รับการแจ้งเตือนเมื่อพืชต้องการการดูแล'
            },
        ]
    }
    
    return render(request, 'landing/index.html', context)
