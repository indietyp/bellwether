# Generated by Django 2.1.1 on 2019-01-30 21:25

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('log', '0015_auto_20190107_2232'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='serverchat',
            name='ip',
        ),
    ]
