from django.contrib.auth.decorators import login_required, permission_required
from django.views.decorators.http import require_http_methods

from ajax.views import renderer
from log.models import ServerChat


@login_required(login_url='/login')
@permission_required('core.view_chat')
@require_http_methods(['POST'])
def log(request, page, *args, **kwargs):
  obj = ServerChat.objects.filter(command=False).order_by('created_at')
  return renderer(request, 'partials/chat/entry.pug', obj, page)