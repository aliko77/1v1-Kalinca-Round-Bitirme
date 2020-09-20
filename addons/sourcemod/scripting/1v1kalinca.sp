#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "ali<.d"
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <multicolors>

ConVar g_tag, round_finish_time;

char tag1[999];
char finish_time[64];

new Handle:h_timer = INVALID_HANDLE;

public Plugin myinfo = 
{
	name = "1v1 Kalında Round Bitirme",
	author = PLUGIN_AUTHOR,
	description = "Sevmek için sevilmek gerekir.",
	version = PLUGIN_VERSION,
	url = "alikoc77"
};

public void OnPluginStart()
{
	HookEvent("player_death", splayerdeath);
	g_tag = CreateConVar("tags", "leaderclan", "Pluginleri başında olmasını istediğiniz tag", FCVAR_NOTIFY);
	round_finish_time = CreateConVar("sm_rounddraw_time", "35", "Kaç saniye sonra round bitirilsin.", FCVAR_NOTIFY, true, 0.0, true, 60.0);
	AutoExecConfig(true, "1v1Kalinca", "alispw77");
}

public Action:splayerdeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	GetConVarString(round_finish_time, finish_time, sizeof(finish_time));
	GetConVarString(g_tag, tag1, sizeof(tag1));
	int yasayant;
	int yasayanct;
	for (new i = 1; i < MaxClients; i++)
	if (IsClientInGame(i) && IsPlayerAlive(i))
	{
		if (GetClientTeam(i) == CS_TEAM_T)
			yasayant++;
				
		if (GetClientTeam(i) == CS_TEAM_CT)
			yasayanct++;
	}
	if (yasayant == 1 && yasayanct == 1)
	{
		CPrintToChatAll("[%s] {green}1v1 Dolayısıyla Round {darkred}%s {green}Saniye Sonra Otomatik Bitirilecek", tag1, finish_time);
		h_timer = CreateTimer(round_finish_time.FloatValue, timer_roundfinish);
	}
	else
	{
		h_timer = INVALID_HANDLE;
		KillTimer(h_timer);
		CloseHandle(h_timer);
	}
}

public Action:timer_roundfinish(Handle:timer)
{
	if(h_timer)
	{
		h_timer = INVALID_HANDLE;
		CloseHandle(h_timer);
		CloseHandle(timer);
		CS_TerminateRound(3.0, CSRoundEnd_Draw, true);
	}
}

public void OnAutoConfigsBuffered()
{
    CreateTimer(3.0, awpaimcontrol);
}

public Action awpaimcontrol(Handle timer)
{
    char filename[512];
    GetPluginFilename(INVALID_HANDLE, filename, sizeof(filename));
    char mapname[PLATFORM_MAX_PATH];
    GetCurrentMap(mapname, sizeof(mapname));
    if (StrContains(mapname, "awp_", false) == -1)
    {
        ServerCommand("sm plugins unload %s", filename);
    }
    else
    if (StrContains(mapname, "aim", false) == -1)
    {
        ServerCommand("sm plugins unload %s", filename);
    }
    else 
    if (StrContains(mapname, "awp_", false) == 0)
    {
        ServerCommand("sm plugins load %s", filename);
    }
    else
    if (StrContains(mapname, "aim_", false) == 0)
    {
        ServerCommand("sm plugins load %s", filename);
    }
    return Plugin_Stop;
}
