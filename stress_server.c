#include "stress_server.h"
#include "stress_env.h"
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

Stress_Server*stress_server_init(char *server_path){
	Stress_Server *p_server =  (Stress_Server*)malloc(sizeof(Stress_Server));
	assert(p_server != NULL);
	p_server->L					=	luaL_newstate();
	assert(p_server->L != NULL);
	luaL_openlibs(p_server->L);
	if (luaL_loadfile(p_server->L, server_path) || lua_pcall(p_server->L, 0, 0, 0)) {
		printf("loadfile %s \n",lua_tostring(p_server->L,-1));
		assert(false);	
	}
	p_server->p_mutex = f_thread_mutex_init();
	assert(p_server->p_mutex != NULL);
	stress_env_register_cfun_server(p_server);
	return p_server;
}

void stress_server_destroy(Stress_Server*p_server){
	lua_close(	p_server->L );
	f_thread_mutex_destroy(p_server->p_mutex);
	free(p_server);
}

int stress_server_init_do(Stress_Server*p_server){
	lua_State* L =p_server->L;
	lua_getglobal(L,"init");	
	lua_pushinteger(L, p_server->p_engine->p_config->client_num);
	lua_pushinteger(L, p_server->p_engine->p_config->server_port);
	lua_pushstring(L, p_server->p_engine->p_config->server_ip);
	lua_pushlightuserdata(L,p_server);
	if(lua_pcall(L, 4, 0, 0)){
		printf("server init pcall %s \n",lua_tostring(L,-1));
		assert(false);
		return -1;
	}
	return 0;
}

int stress_server_input(Stress_Client*p_client,char*info,char *msg){
	Stress_Server*p_server= p_client->p_engine->p_server;
	f_thread_mutex_lock(p_server->p_mutex);	
	lua_State* L =p_server->L;
	lua_getglobal(L,"input");	
	lua_pushstring(L, info);
	if(lua_pcall(L, 1, 1, 0)){
		printf("error p_server input pcall %s %s\n",lua_tostring(L,-1),info);
		f_thread_mutex_unlock(p_server->p_mutex);
		assert(false);
		return -1;
	}
	if(lua_tostring(L,-1) !=NULL){
		strcpy(msg,lua_tostring(L,-1));
	}	
	else{
		f_thread_mutex_unlock(p_server->p_mutex);
		return -1;
	}
	f_thread_mutex_unlock(p_server->p_mutex);
	return 0;
}
