from django.db import models


class ContactMessage(models.Model):
    """
    Model สำหรับเก็บข้อความติดต่อจากลูกค้า
    """
    name = models.CharField(max_length=100, verbose_name='ชื่อ')
    email = models.EmailField(verbose_name='อีเมล')
    phone = models.CharField(max_length=20, verbose_name='เบอร์โทร', blank=True)
    message = models.TextField(verbose_name='ข้อความ')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='วันที่ส่ง')
    
    class Meta:
        verbose_name = 'ข้อความติดต่อ'
        verbose_name_plural = 'ข้อความติดต่อทั้งหมด'
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.name} - {self.email}"
