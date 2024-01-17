import os
import sys
BASE_DIR =os.path.abspath(__file__)
django_project_path = os.path.abspath(os.path.join(BASE_DIR, 'xxx'))
print(django_project_path)
sys.path.append(django_project_path)
print(sys.path)
os.environ['DJANGO_SETTINGS_MODULE'] = 'xxx.settings'
os.environ['DJANGO_ALLOW_ASYNC_UNSAFE'] = 'True'
import django
django.setup()

