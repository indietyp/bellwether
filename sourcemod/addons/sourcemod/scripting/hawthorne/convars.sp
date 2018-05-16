void Hawthorne_InitConVars() {
  MANAGER           = CreateConVar("ht_manager",
                                   "https://example.com",
                                   "management server address including port and protocol",
                                   FCVAR_NONE);

  APITOKEN          = CreateConVar("ht_manager_token",
                                   "",
                                   "management server provided token (required) | use the extended format",
                                   FCVAR_PROTECTED);

  MODULE_BAN        = CreateConVar("ht_ban",
                                   "1",
                                   "Toggle the internal ban module",
                                   FCVAR_NONE,
                                   true, 0.0,
                                   true, 1.0);

  MODULE_ADMIN      = CreateConVar("ht_admin",
                                   "1",
                                   "Toggle the internal admin module",
                                   FCVAR_NONE,
                                   true, 0.0,
                                   true, 1.0);
  MODULE_PUNISH     = CreateConVar("ht_punish",
                                   "1",
                                   "Toggle the internal mute and gag module",
                                   FCVAR_NONE,
                                   true, 0.0,
                                   true, 1.0);

  MODULE_LOG        = CreateConVar("ht_log",
                                   "1",
                                   "Toggle the internal chatlog module",
                                   FCVAR_NONE,
                                   true, 0.0,
                                   true, 1.0);

  MODULE_HEXTAGS    = CreateConVar("ht_hextags",
                                   "1",
                                   "Enables hextag support",
                                   FCVAR_NONE,
                                   true, 0.0,
                                   true, 1.0);


  MODULE_MUTEGAG_GLOBAL   = CreateConVar("ht_global_mutegag",
                                         "0",
                                         "Toggle of serverwide mute & gags",
                                         FCVAR_NONE,
                                         true, 0.0,
                                         true, 1.0);

  MODULE_BAN_GLOBAL       = CreateConVar("ht_global_ban",
                                         "0",
                                         "Toggle of serverwide bans",
                                         FCVAR_NONE,
                                         true, 0.0,
                                         true, 1.0);

  MODULE_ADMIN_MERGE      = CreateConVar("ht_admin_merge",
                                         "0",
                                         "Toggle merging with existing modules",
                                         FCVAR_NONE,
                                         true, 0.0,
                                         true, 1.0);


  AutoExecConfig(true, "hawthorne");
}
