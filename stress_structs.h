#ifndef _STRESS_STRUCTS_H_
#define _STRESS_STRUCTS_H_

#include <fcalg/fcalg.h>
#include <lua.h>
#define IP_LEN 64
#define THREAD_POOL_MIN 200
#define THREAD_POOL_MAX 200
#define THREAD_POOL_STACKSIZE 1024000
#define PATH_LEN 256
#define MSG_RECV_LEN 4096
#define FILE_LEN_MAX 409600
#define KEYWORDS_LEN 16

struct engine_config{
	char	server_ip[IP_LEN];
	int		server_port;	
	int 	client_num;
	char server_path[PATH_LEN];
	char client_path[PATH_LEN];
};

typedef struct engine_config Engine_Config;

struct stress_client_sets{
	F_Vector *p_vector;
	int next_index;
	F_Thread_Mutex 	*p_mutex;
};
typedef struct stress_client_sets Stress_Client_Sets;

struct stress_engine;

struct stress_server{
	lua_State *L;
	F_Thread_Mutex 	*p_mutex;
	struct stress_engine*p_engine;
};
typedef struct stress_server  Stress_Server;
struct recv_p{
	char left_buf[MSG_RECV_LEN];
	int left_len;
};
typedef struct recv_p Recv_P;

struct stress_engine{
	int life;
	Engine_Config *p_config;
	Stress_Client_Sets*p_sets;
	Stress_Server *p_server;
	char server_path[PATH_LEN];
	char client_path[PATH_LEN];
	F_Msg_Queue			*p_msg;
	F_Msg_Queue			*p_msg_s;
};
typedef struct stress_engine Stress_Engine;

struct stress_client{
	int sock;
	int sock_invert;
	int invert_flag;
	Recv_P		* rp;
	lua_State *	L;
	F_Thread_Mutex 	*p_mutex;
	/**网络通信地址结构*/
	F_Inet_Addr*p_addr;
	/**网络通信字节流结构*/
	F_Sock_Stream*p_sock;
	/**网络通信主动连接结构*/
	F_Sock_Connect*	p_con;
	F_Sock_Stream*p_sock_invert;
	F_Sock_Connect*	p_con_invert;
	Stress_Engine*p_engine;
	char keywords[KEYWORDS_LEN + 1];
	char keywords_invert[KEYWORDS_LEN + 1];
};
typedef struct stress_client Stress_Client;

#endif/*_STRESS_STRUCTS_H_*/
