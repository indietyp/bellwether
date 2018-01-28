// Generated by CoffeeScript 2.1.1
(function() {
  // view controller
  var ajax, change;

  change = function(destination = 'home') {
    var data, method, url;
    method = 'POST';
    switch (destination) {
      case 'home':
        url = '/';
        break;
      case 'player':
        url = '/players';
        break;
      case 'admin':
        url = '/admins';
        break;
      case 'server':
        url = '/servers';
        break;
      case 'ban':
        url = '/bans';
        break;
      case 'mutegag':
        url = '/mutegags';
        break;
      case 'announcements':
        url = '/announcements';
        break;
      case 'chat':
        url = '/chat';
        break;
      case 'settings':
        url = '/settings';
        break;
      default:
        return false;
    }
    data = {
      csrfmiddlewaretoken: $("[name=csrfmiddlewaretoken]").val()
    };
    $(data).ajax(url, method, function(data, status) {
      if (status === 200) {
        $("#content").css('opacity', '0');
        setTimeout(function() {
          $("#content").html(data);
          eval($("#content script.execution").html());
          feather.replace();
          return $("#content").css('opacity', '');
        }, 200);
      } else {
        return false;
      }
      window.history.pushState("", "", url);
      return true;
    });
    return true;
  };

  ajax = function(destination, module) {
    return true;
  };

  window.vc = {
    change: change
  };

}).call(this);
