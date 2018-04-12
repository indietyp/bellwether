# Generated by Django 2.0.3 on 2018-03-12 22:04

import uuid

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):
  dependencies = [
    migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ('log', '0002_auto_20180312_2135'),
  ]

  operations = [
    migrations.CreateModel(
      name='UserNamespace',
      fields=[
        ('id', models.UUIDField(auto_created=True, default=uuid.uuid4, editable=False, primary_key=True,
                                serialize=False, unique=True)),
        ('created_at', models.DateTimeField(auto_now_add=True)),
        ('updated_at', models.DateTimeField(auto_now=True)),
        ('namespace', models.CharField(max_length=128)),
        ('connections', models.IntegerField(default=0)),
        ('last_used', models.DateTimeField(auto_now=True)),
        ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
      ],
      options={
        'abstract': False,
      },
    ),
    migrations.RemoveField(
      model_name='userusername',
      name='user',
    ),
    migrations.DeleteModel(
      name='UserUsername',
    ),
  ]