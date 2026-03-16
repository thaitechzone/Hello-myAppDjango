from django.test import TestCase
from .models import ContactMessage


class ContactMessageTestCase(TestCase):
    def test_create_message(self):
        """ทดสอบการสร้างข้อความติดต่อ"""
        message = ContactMessage.objects.create(
            name='ทดสอบ',
            email='test@example.com',
            phone='0812345678',
            message='ข้อความทดสอบ'
        )
        self.assertEqual(message.name, 'ทดสอบ')
        self.assertEqual(message.email, 'test@example.com')
