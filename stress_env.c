#include "stress_env.h"
#include "stress_client.h"
#include "stress_server.h"
#include "stress_engine.h"
#include "crypt.h"
#include "comp.h"

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

extern char CODE_CONFIG_PATH[];

F_Thread_Pool* g_pool;
F_Hashtable *		g_client_hash;

static Stress_Client*stress_env_get_client(lua_State*L);

static int compare(void *data_one,void*data_two){	
	return ((long)((Stress_Client*)data_one)->L )-  (long)(((Stress_Client*)data_two)->L );
}


unsigned int hash(void *p_key,unsigned int bucket_num){
	return (unsigned int)((long)(((Stress_Client*)p_key)->L))%bucket_num;
}

int 	stress_env_init(){
	g_pool = f_thread_pool_create(THREAD_POOL_MIN, THREAD_POOL_MAX,	1,-1,THREAD_POOL_STACKSIZE,1);
	assert(g_pool != NULL);
	g_client_hash = f_hashtable_create(2000,NULL,NULL,NULL,NULL,compare,hash);
	assert(g_client_hash != NULL);
	/*int res = comp_init(CODE_CONFIG_PATH);
	assert(res == 0 );*/
	return 0;
}

void 	stress_env_destroy(){
	//comp_destroy();
	f_thread_pool_destroy(g_pool);
	f_hashtable_destroy(g_client_hash);
}


static int lua_server_input(lua_State *L) {
	Stress_Client* p_client = stress_env_get_client(L);
	char msg[MSG_RECV_LEN];
	memset(msg,0,MSG_RECV_LEN);
	int res = stress_server_input(p_client,(char*)luaL_checkstring(L,1),msg);
	if(res != 0){
		lua_pushnil(L);
	}
	else{
		lua_pushstring(L,msg);
	}
	return 1;
}

static int lua_client_send(lua_State *L) {
	Stress_Client* p_client = stress_env_get_client(L);
	//printf("send : %s\n",(char*)luaL_checkstring(L,1));
	char msginfo[MSG_RECV_LEN];
	char * msginfoconst = (char*)luaL_checkstring(L,1) ;
	/*int readlen 				= strlen(msginfoconst);
	int enclen = 0;
	char *proto_info 		= do_compress(msginfoconst, readlen, &enclen);
	readlen 						= strlen(proto_info);*/
	/*加入扰乱串,防止相同协议，压缩加密后仍为一样的字节
	*加密前，随机改变加密key的前两位，并将扰乱码发送到客户端
	*/
    /*
	char disturbChar[3];
	disturbChar[0]	=	rand()%126+1;
	disturbChar[1]	= rand()%126+1;
	disturbChar[2] 	= '\0';
	char realkey[KEYWORDS_LEN + 1] 	;
	strcpy(realkey, p_client->keywords);
	realkey[0] 					=	disturbChar[0];		
	realkey[1] 					=	disturbChar[1];		
	
	bitEncode(proto_info, readlen, realkey, KEYWORDS_LEN);
	snprintf(msginfo,MSG_RECV_LEN,"%s%s",disturbChar,proto_info);
	free(proto_info);
	
	stress_server_send_msg(p_client->p_engine,p_client,msginfo);*/
    stress_server_send_msg(p_client->p_engine,p_client,msginfoconst);
	return 0;
}

static int lua_client_sock_invert(lua_State *L) {
	Stress_Client* p_client = stress_env_get_client(L);
	stress_client_sock_invert(p_client);
	return 0;
}

static int lua_server_finish(lua_State *L) {
	Stress_Server* p_server = (Stress_Server*)lua_touserdata(L,-1);
	stress_engine_finish(p_server->p_engine);
	return 0;
}

void stress_env_register_cfun(Stress_Client*p_client){
	assert(f_hashtable_insert(g_client_hash,p_client) != FELIX_FAILED);
	lua_pushcfunction(p_client->L,lua_server_input);
	lua_setglobal(p_client->L,"server_input");
	lua_pushcfunction(p_client->L,lua_client_send);
	lua_setglobal(p_client->L,"client_send");	
	lua_pushcfunction(p_client->L,lua_client_sock_invert);
	lua_setglobal(p_client->L,"client_sock_invert");	
	
}

void stress_env_register_cfun_server(Stress_Server*p_server){
	lua_pushcfunction(p_server->L,lua_server_finish);
	lua_setglobal(p_server->L,"server_finish");
}

Stress_Client*stress_env_get_client(lua_State*L){
	Stress_Client client;
	client.L = L;
	Stress_Client*p_client = f_hashtable_find(g_client_hash,&client);
	assert(p_client != NULL);
	return p_client;
}
