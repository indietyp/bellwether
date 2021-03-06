import datetime
import socket
import valve

from MySQLdb import connect
from core.lib.steam import populate
from core.models import Membership, Punishment, Role, Server, ServerPermission, User
from django.utils import timezone
from lib.base import RCONBase
from valve.steam.id import SteamID


class Importer:
  def __init__(self, host, port, user, password, database):
    self.conn = connect(host, user, password, database, port)
    self.now = datetime.datetime.now()

  def sourcemod(self):
    self.conn.query("""SELECT * FROM sm_groups""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    roles = {}
    for raw in result:
      flags = ServerPermission().convert(raw['flags'])
      flags.save()

      role = Role.objects.get_or_create(name=raw['name'], default={'flags': flags,
                                                                   'immunity': raw['immunity_level']})
      role.name = raw['name']
      role.flags = flags
      role.immunity = raw['immunity_level']
      role.save()

      roles[raw['id']] = role

    self.conn.query("""SELECT * FROM sm_admins""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    generated = {}
    for raw in result:
      try:
        steamid = SteamID.from_text(raw['identity']).as_64()
      except:
        print("Could not add admin {}".format(raw['name']))
        continue

      query = User.objects.filter(username=steamid)

      if not query:
        user = User.objects.create_user(username=steamid)
        user.is_active = False
        user.is_steam = True

        populate(user)
      else:
        user = query[0]
        user.namespace = raw['user']
      user.save()

      self.conn.query("""SELECT *
                         FROM sm_admins_groups
                         WHERE admin_id = {}""".format(raw['id']))
      r = self.conn.store_result()
      groups = r.fetch_row(maxrows=0, how=1)

      if not groups and raw['flags']:
        if raw['flags'] in generated:
          role = generated[raw['flags']]
        else:
          role = Role()
          role.name = raw['flags']
          role.flags = ServerPermission().convert(raw['flags'])
          role.flags.save()
          role.immunity = 0
          role.save()

          generated[raw['flags']] = role

        m = Membership()
        m.user = user
        m.role = role
        m.save()

      elif groups:
        for group in groups:
          role = roles[group["group_id"]]

          m = Membership()
          m.user = user
          m.role = role
          m.save()

    return True

  def sourceban(self):
    superuser = User.objects.filter(is_superuser=True)
    superuser = superuser[0] if superuser else None

    # get servers
    self.conn.query("""SELECT * FROM sb_servers""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    servers = {}
    for raw in result:
      if raw['enabled'] != 1:
        continue

      server, _ = Server.objects.get_or_create(ip=raw['ip'], port=raw['port'])
      server.password = raw['rcon']
      server.name = "{}:{}".format(raw['ip'], raw['port'])
      server.save()

      try:
        conn = RCONBase(server, timeout=3)
        conn.connect()
        conn.authenticate(timeout=3)
        conn.close()

        servers[raw['sid']] = server
      except (valve.rcon.RCONTimeoutError,
              valve.rcon.RCONAuthenticationError,
              ConnectionError,
              TimeoutError,
              socket.timeout) as e:

        server.delete()
        print("Warning: Could not connect to server {}:{} ({})".format(raw['ip'], raw['port'], e))
        continue

    # get groups
    self.conn.query("""SELECT * FROM sb_srvgroups""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    for raw in result:
      flags = ServerPermission().convert(raw['flags'])
      flags.save()
      role, _ = Role.objects.get_or_create(name=raw['name'], defaults={'flags': flags,
                                                                              'immunity': raw['immunity']})
      role.immunity = raw['immunity']
      role.flags = flags
      role.save()


    # get admins
    self.conn.query("""SELECT * FROM sb_admins""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    users = {0: User.objects.filter(is_superuser=True)[0]}
    generated = {}
    for raw in result:
      try:
        steamid = SteamID.from_text(raw['authid']).as_64()
      except:
        print("Could not add admin {}".format(raw['user']))
        continue

      query = User.objects.filter(username=steamid)

      if not query:
        user = User.objects.create_user(username=steamid)
        user.is_active = False
        user.is_steam = True

        populate(user)
      else:
        user = query[0]

      user.namespace = raw['user']
      user.save()

      if not raw['srv_group'] and raw['srv_flags']:
        m = Membership()
        m.user = user
        if raw['srv_flags'] in generated:
          m.role = generated[raw['srv_flags']]
        else:
          m.role = Role()
          m.role.immunity = 0
          m.role.name = raw['srv_flags']
          m.role.flags = ServerPermission().convert(raw['srv_flags'])
          m.role.flags.save()
          m.role.save()
          m.save()

          generated[raw['srv_flags']] = m.role

      elif raw['srv_group']:
        m = Membership()
        m.role = Role.objects.get(name=raw['srv_group'])
        m.user = user
        m.save()

      users[raw['aid']] = user


    # get bans
    self.conn.query("""SELECT * FROM sb_bans""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    for raw in result:
      try:
        steamid = SteamID.from_text(raw['authid']).as_64()
      except:
        print("Could not add ban of user {}".format(raw['name']))
        continue

      query = User.objects.filter(username=steamid)

      if not query:
        user = User.objects.create_user(username=steamid)
        user.is_active = False
        user.is_steam = True

        populate(user)
      else:
        user = query[0]

      b = Punishment()
      b.is_banned = True
      b.user = user

      if raw['sid'] in servers:
        b.server = servers[raw['sid']] if raw['sid'] != 0 else None
      else:
        b.server = None

      if raw['aid'] in users:
        b.created_by = users[raw['aid']]
      elif superuser:
        b.created_by = superuser
      else:
        continue

      m.created_at = timezone.make_aware(datetime.datetime.fromtimestamp(raw['created']))
      b.reason = raw['reason'][:255]
      b.length = datetime.timedelta(seconds=raw['length']) if raw['length'] > 0 and raw['length'] < 31540000 else None
      b.resolved = False
      if raw['created'] + raw['length'] < self.now.timestamp() and raw['length'] > 0:
        b.resolved = True

      if raw['RemovedOn']:
        b.resolved = True
      b.save()

    # get comms
    self.conn.query("""SELECT * FROM sb_comms""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    for raw in result:
      try:
        steamid = SteamID.from_text(raw['authid']).as_64()
      except:
        print("Could not add mutegag of user {}".format(raw['name']))
        continue

      query = User.objects.filter(username=steamid)

      if not query:
        user = User.objects.create_user(username=steamid)
        user.is_active = False
        user.is_steam = True

        populate(user)
      else:
        user = query[0]

      m = Punishment()
      m.user = user

      if raw['sid'] in servers:
        m.server = servers[raw['sid']] if raw['sid'] != 0 else None
      else:
        m.server = None

      if raw['aid'] in users:
        m.created_by = users[raw['aid']]
      elif superuser:
        m.created_by = superuser
      else:
        continue

      m.created_at = timezone.make_aware(datetime.datetime.fromtimestamp(raw['created']))
      m.reason = raw['reason'][:255]
      m.length = datetime.timedelta(seconds=raw['length']) if raw['length'] > 0 and raw['length'] < 31540000 else None
      m.is_muted = True if raw['type'] == 1 else False
      m.is_gagged = True if raw['type'] == 2 else False

      m.resolved = False
      if raw['created'] + raw['length'] < self.now.timestamp() and raw['length'] > 0:
        m.resolved = True

      if raw['RemovedOn']:
        m.resolved = True

      m.save()

    return True

  def boompanel(self):
    self.conn.query("""SELECT * FROM bp_players""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    users = {}
    for raw in result:
      query = User.objects.filter(username=raw['steamid'])
      if not query:
        user = User.objects.create_user(username=raw['steamid'])
        user.is_active = False
        user.is_steam = True

        populate(user)
      else:
        user = query[0]
      user.save()

      users[raw["id"]] = user

    self.conn.query("""SELECT * FROM bp_servers""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    servers = {}
    for raw in result:
      server, _ = Server.objects.get_or_create(ip=raw['ip'], port=raw['port'])
      server.password = raw['rcon_pw']
      server.name = raw['name']

      servers[raw['id']] = server
      try:
        conn = RCONBase(server, timeout=3)
        conn.connect()
        conn.authenticate(timeout=3)
        conn.close()
      except (valve.rcon.RCONTimeoutError,
              valve.rcon.RCONAuthenticationError,
              ConnectionError,
              TimeoutError,
              socket.timeout) as e:

        print("Warning: Could not connect to server {}:{} ({})".format(raw['ip'], raw['port'], e))
        continue

      server.save()

    self.conn.query("""SELECT * FROM bp_admin_groups""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    roles = {}
    for raw in result:
      role, _ = Role.objects.get_or_create(name=raw['name'])
      role.immunity = raw['immunity']
      role.flags = ServerPermission().convert(raw['flags'])
      role.usetime = None if raw['usetime'] == 0 else raw['usetime']
      role.save()

      roles[raw['id']] = role

    self.conn.query("""SELECT * FROM bp_admins""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    admins = {}
    for raw in result:
      m = Membership()
      m.role = roles[raw['sid']]
      m.user = roles[raw['pid']]
      m.save()

      admins[raw['aid']] = m

    self.conn.query("""SELECT * FROM bp_mutegag""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    for raw in result:
      if raw['aid'] not in users or raw['pid'] not in users or raw['sid'] not in servers:
        continue

      m = Punishment()
      m.user = users[raw["pid"]]
      m.server = servers[raw['sid']] if raw['sid'] != 0 and raw['sid'] in servers else None
      m.created_by = users[raw['aid']]
      m.created_at = timezone.make_aware(datetime.datetime.fromtimestamp(raw['time']))
      m.reason = raw['reason'][:255]
      m.length = datetime.timedelta(seconds=raw['length'] * 60) if raw['length'] > 0 else None
      m.is_muted = True if raw['type'] == 1 else False
      m.is_gagged = True if raw['type'] == 2 else False

      m.resolved = False
      if raw['time'] + raw['length'] < self.now.timestamp() and raw['length'] > 0:
        m.resolved = True

      if raw['unbanned'] == 1:
        m.resolved = True
      m.save()

    self.conn.query("""SELECT * FROM bp_bans""")
    r = self.conn.store_result()
    result = r.fetch_row(maxrows=0, how=1)

    for raw in result:
      if raw['aid'] not in users or raw['pid'] not in users or raw['sid'] not in servers:
        continue

      b = Punishment()
      b.is_banned = True
      b.user = users[raw["pid"]]
      b.server = servers[raw['sid']] if raw['sid'] != 0 and raw['sid'] in servers else None
      b.created_by = users[raw['aid']]
      m.created_at = timezone.make_aware(datetime.datetime.fromtimestamp(raw['time']))
      b.reason = raw['reason'][:255]
      b.length = datetime.timedelta(seconds=raw['length']) if raw['length'] > 0 else None
      b.resolved = False
      if raw['time'] + raw['length'] < self.now.timestamp() and raw['length'] > 0:
        b.resolved = True

      if raw['unbanned'] == 1:
        b.resolved = True
      b.save()

    return True
