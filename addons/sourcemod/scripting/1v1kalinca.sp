#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "alikoc77"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma newdecls required

Handle g_timer = null;

public Plugin myinfo = 
{
	name = "",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = "https://steamcommunity.com/id/alikoc77"
};

public void OnPluginStart(){
	 HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	 HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	 RegConsoleCmd("sm_rrr", comrrr);
}
public Action comrrr(int client, int args){
	if(g_timer){
		PrintToConsole(client, "Zamanlayici Açık");
	}else{
		PrintToConsole(client, "Zamanlayici Kapalı");
	}
}
public void Event_PlayerDeath(Event hEvent, const char[] sEvName, bool bDontBroadcast){
	if (GetAliveTeamCount(2) == 1 && GetAliveTeamCount(3) == 1){
		if(!g_timer){
			g_timer = CreateTimer(30.0, timer_1v1);
		}
	}
}
public void Event_RoundEnd(Event hEvent, const char[] sEvName, bool bDontBroadcast){
	if (g_timer){
		CloseHandle(g_timer);
		g_timer = null;
	}
}
public Action timer_1v1(Handle Timer){
	CS_TerminateRound(3.0, CSRoundEnd_Draw, true);
}
stock int GetAliveTeamCount(int team){
    int number = 0;
    for (int i = 1; i <= MaxClients; i++){
        if (IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == team) 
            number++;
    }
    return number;
} 
