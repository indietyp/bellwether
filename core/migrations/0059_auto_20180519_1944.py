# Generated by Django 2.0.3 on 2018-05-19 19:44

from django.db import migrations, models
import uuid


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0058_auto_20180516_2145'),
    ]

    operations = [
        migrations.CreateModel(
            name='Tag',
            fields=[
                ('id', models.UUIDField(auto_created=True, default=uuid.uuid4, editable=False, primary_key=True, serialize=False, unique=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('chat', models.CharField(choices=[('default', 'Default Color'), ('teamcolor', 'Current Team Color'), ('red', 'Red'), ('lightred', 'Lighter Red'), ('darkred', 'Darker Red'), ('bluegrey', 'Blueish Grey'), ('blue', 'Blue'), ('darkblue', 'Darker Blue'), ('purple', 'Purple'), ('orchid', 'Orchid'), ('yellow', 'Yellow'), ('gold', 'Gold'), ('lightgreen', 'Lighter Green'), ('green', 'Green'), ('lime', 'Lime'), ('grey', 'Grey'), ('darkgrey', 'Darker Grey')], default='default', max_length=10)),
                ('name', models.CharField(choices=[('default', 'Default Color'), ('teamcolor', 'Current Team Color'), ('red', 'Red'), ('lightred', 'Lighter Red'), ('darkred', 'Darker Red'), ('bluegrey', 'Blueish Grey'), ('blue', 'Blue'), ('darkblue', 'Darker Blue'), ('purple', 'Purple'), ('orchid', 'Orchid'), ('yellow', 'Yellow'), ('gold', 'Gold'), ('lightgreen', 'Lighter Green'), ('green', 'Green'), ('lime', 'Lime'), ('grey', 'Grey'), ('darkgrey', 'Darker Grey')], default='default', max_length=10)),
                ('base', models.CharField(choices=[('default', 'Default Color'), ('teamcolor', 'Current Team Color'), ('red', 'Red'), ('lightred', 'Lighter Red'), ('darkred', 'Darker Red'), ('bluegrey', 'Blueish Grey'), ('blue', 'Blue'), ('darkblue', 'Darker Blue'), ('purple', 'Purple'), ('orchid', 'Orchid'), ('yellow', 'Yellow'), ('gold', 'Gold'), ('lightgreen', 'Lighter Green'), ('green', 'Green'), ('lime', 'Lime'), ('grey', 'Grey'), ('darkgrey', 'Darker Grey')], default='default', max_length=10)),
            ],
            options={
                'abstract': False,
            },
        ),
        migrations.AddField(
            model_name='user',
            name='tag',
            field=models.CharField(max_length=255, null=True),
        ),
    ]
