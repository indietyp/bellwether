void Hawthorne_OnPluginStart() {
  Hawthorne_InitConVars();
  Punishment_OnPluginStart();
  RConCommands_OnPluginStart();
}

public void OnMapStart() {
  // AutoBan_OnMapStart();
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
  RegPluginLibrary("hawthorne");
  CreateNatives();
  return APLRes_Success;
}

void OnClientIDReceived(int client) {
  //Push event
  Call_StartForward(forward_client);
  Call_PushCell(client);
  Call_Finish();

  Bans_OnClientIDReceived(client);
}

public void OnClientPutInServer(int client) {
  Punishment_OnClientPutInServer(client);
  Duplicate_OnClientPutInServer(client);
}

public Action Event_Disconnect(Event event, const char[] name, bool dontBroadcast) {
  int client = GetClientOfUserId(event.GetInt("userid"));
  if (client > 0 && !IsFakeClient(client)) {
    Admins_OnClientDisconnect(client);
    // AutoBan_OnClientDisconnect(client);
  }

  return Plugin_Continue;
}

public Action Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
  int client = GetClientOfUserId(event.GetInt("userid"));
  if(client > 0 && !IsFakeClient(client)) {
    if(!MOTD_SEEN[client]) {
      // AutoBan_OnPlayerSpawn(client);
    }
  }
}

public void OnAllPluginsLoaded() {
  hextags = LibraryExists("hextags");
  smac = LibraryExists("smac");
}

public Action SMAC_OnCheatDetected(int client, const char[] module, DetectionType type, Handle info) {
  if (!smac || !MODULE_SMAC.BoolValue) return Plugin_Continue;
  char reason[512];
  Format(reason, sizeof(reason), "[SMAC] %s has detected a cheat.", module);

  selected_action[client] = ACTION_BAN;
  selected_player[client] = client;
  selected_conflict[client] = -1;
  selected_duration[client] = -1;

  strcopy(selected_reason[client], sizeof(selected_reason[]), reason);

  PunishExecution(client);

  return Plugin_Continue;
}
