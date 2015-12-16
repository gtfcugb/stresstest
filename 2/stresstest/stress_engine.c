#include "stress_engine.h"
#include "stress_server.h"
#include "stress_client.h"
#include "stress_env.h"
#include <json/json.h>
extern F_Thread_Pool* g_pool;
extern F_Hashtable *		g_client_hash;

static int engine_init_client(Stress_Engine*p_engine);
static void *msg_parser(void *arg);
static void *msg_send_parser(void *arg);
static void *finish_parser(void *arg);

struct packet_st{
	Stress_Client *p_client;
	char msg[MSG_RECV_LEN]	;
};

static int get_file_content(char*dir_name,char *content){
	FILE *fd = fopen(dir_name,"r");
	if(fd == NULL){
		return -1;
	}
	int cur =	0;
	char c;
	while((c = fgetc(fd)) != EOF){
		if(cur >= FILE_LEN_MAX){
			fclose(fd);
			return -1;
		}
		content[cur] = c;
		++cur;
	}
	fclose(fd);
	return 0;
}

Engine_Config*engine_config_init(char*	dir_name){
	char *file_content = (char*)malloc(FILE_LEN_MAX);
	memset(file_content,0,FILE_LEN_MAX);
	int res = get_file_content(dir_name,file_content);
	assert(res == 0);
	Engine_Config *p_config =  (Engine_Config*)malloc(sizeof(Engine_Config));
	assert(p_config != NULL);
	struct json_object* json_config = json_tokener_parse(file_content);
	free(file_content);
	if(json_config == NULL || is_error(json_config) ){
		free(p_config);
		return NULL;		
	}
	struct json_object*	ip_obj = json_object_object_get(json_config,"ip");
	if(ip_obj == NULL){
		json_object_put(json_config);
		free(p_config);
		return NULL;
	}
	strncpy(p_config->server_ip,json_object_get_string(ip_obj),IP_LEN - 1);
	p_config->server_ip[IP_LEN-1] = '\0';
	
	struct json_object*	sd_obj = json_object_object_get(json_config,"server_address");
	if(sd_obj == NULL){
		json_object_put(json_config);
		free(p_config);
		return NULL;
	}
	strncpy(p_config->server_path,json_object_get_string(sd_obj),PATH_LEN - 1);
	p_config->server_path[PATH_LEN-1] = '\0';
	
	struct json_object*	cd_obj = json_object_object_get(json_config,"client_address");
	if(cd_obj == NULL){
		json_object_put(json_config);
		free(p_config);
		return NULL;
	}
	strncpy(p_config->client_path,json_object_get_string(cd_obj),PATH_LEN - 1);
	p_config->client_path[PATH_LEN-1] = '\0';
	
	struct json_object*	port_obj = json_object_object_get(json_config,"port");
	if(port_obj == NULL){
		json_object_put(json_config);
		free(p_config);
		return NULL;
	}
	p_config->server_port = json_object_get_int(port_obj);
	struct json_object*	num_obj = json_object_object_get(json_config,"client_num");
	if(num_obj == NULL){
		json_object_put(json_config);
		free(p_config);
		return NULL;
	}
	p_config->client_num = json_object_get_int(num_obj);
	json_object_put(json_config);
	return p_config;
}

void engine_config_destroy(Engine_Config*p_config){
	free(p_config);
}

Stress_Engine*stress_engine_init(Engine_Config*p_config){
	Stress_Engine *p_engine =  (Stress_Engine*)malloc(sizeof(Stress_Engine));
	assert(p_engine != NULL);
	p_engine->life 		= 1;
	p_engine->p_msg		=	f_msg_queue_create(NULL,NULL,NULL,1024,MSG_RECV_LEN);
	assert(p_engine->p_msg != NULL);
	p_engine->p_msg_s		=	f_msg_queue_create(NULL,NULL,NULL,1024,MSG_RECV_LEN);
	assert(p_engine->p_msg_s != NULL);
	
	strncpy(p_engine->server_path,p_config->server_path,PATH_LEN - 1);
	p_engine->server_path[PATH_LEN - 1] = '\0';
	strncpy(p_engine->client_path,p_config->client_path,PATH_LEN - 1);
	p_engine->client_path[PATH_LEN - 1] = '\0';	
	p_engine->p_config 	= p_config;
	p_engine->p_sets		= stress_client_sets_init(p_config->client_num);
	p_engine->p_server  =	stress_server_init(p_config->server_path);
	p_engine->p_server->p_engine  = p_engine;
	stress_server_init_do(p_engine->p_server);
	
	int i = 0;
	for(i = 0;i < 20; ++i){
		int res = f_thread_pool_process_job(g_pool,msg_parser,p_engine);
		assert(res == 0);
	}
	f_msleep(100);
	i = 0;
	for(i = 0;i < 20; ++i){
		int res = f_thread_pool_process_job(g_pool,msg_send_parser,p_engine);
		assert(res == 0);
	}
	
	assert(engine_init_client(p_engine) == 0);
	return p_engine;
}

void stress_engine_destroy(Stress_Engine*p_engine){
	f_msg_queue_destroy(p_engine->p_msg_s);
	f_msg_queue_destroy(p_engine->p_msg);
	stress_client_sets_destroy(p_engine->p_sets);
	engine_config_destroy(p_engine->p_config);
	stress_server_destroy(p_engine->p_server);
	free(p_engine);
}

static int engine_init_client(Stress_Engine*p_engine){
	int size = p_engine->p_config->client_num;
	int i ;
	for(i = 0;i < size;++i){
		Stress_Client * p_client = stress_client_init(p_engine->client_path,p_engine->p_config->server_port,p_engine->p_config->server_ip);
		assert(p_client != NULL);
		p_client->p_engine = p_engine;
		stress_env_register_cfun(p_client);
		stress_client_sets_add(p_engine->p_sets,p_client);
	}	
	return 0;
}

void stress_engine_put_msg(Stress_Engine*p_engine,Stress_Client * p_client,char*msg,int len){
	struct packet_st*p_packet = (struct packet_st*)malloc(sizeof(struct packet_st));
	assert(p_packet != NULL);
	p_packet->p_client = p_client;
	memset(p_packet->msg,0,MSG_RECV_LEN);
	memcpy(p_packet->msg,msg,len);
	f_msg_queue_put(p_engine->p_msg,p_packet);
}

void stress_server_send_msg(Stress_Engine*p_engine,Stress_Client * p_client,char*msg){
	struct packet_st*p_packet = (struct packet_st*)malloc(sizeof(struct packet_st));
	assert(p_packet != NULL);
	p_packet->p_client = p_client;
	memset(p_packet->msg,0,MSG_RECV_LEN);
	strcpy(p_packet->msg ,msg);
	f_msg_queue_put(p_engine->p_msg_s,p_packet);
}

void stress_engine_work(Stress_Engine*p_engine){
	//stress_client_sets_work(p_engine->p_sets);
	//f_sleep(1);
	F_H_Iter iter = f_hashtable_begin(g_client_hash);
	while(f_hashtable_end(g_client_hash,iter) != true){
		Stress_Client * p_client= (Stress_Client*)f_hashtable_def(iter);
		assert(stress_client_init_do(p_client) == 0);
		iter = f_hashtable_next(g_client_hash,iter);
	}
	///避免init input同时执行，导致程序崩溃
	stress_client_sets_work(p_engine->p_sets);
}

void stress_engine_finish(Stress_Engine*p_engine){
	int res = f_thread_pool_process_job(g_pool,finish_parser,p_engine);
	assert(res == 0);
}

static void *msg_parser(void *arg){
	Stress_Engine*p_engine = (Stress_Engine*)(arg);
	F_Msg_Queue			*p_msg = p_engine->p_msg;
	struct packet_st *p_packet;
	while(p_engine->life == 1){
		p_packet = f_msg_queue_get_timeout(p_msg,10000);
		if(p_packet != NULL){	
			stress_client_input(p_packet->p_client,p_packet->msg);
			free(p_packet);
		}
		else{
		}
	}
	printf("msg_parser exit \n");
	return NULL;	
}

static void *msg_send_parser(void *arg){
	Stress_Engine*p_engine = (Stress_Engine*)(arg);
	F_Msg_Queue			*p_msg = p_engine->p_msg_s;
	struct packet_st *p_packet;
	while(p_engine->life == 1){
		p_packet = f_msg_queue_get_timeout(p_msg,10000);
		if(p_packet != NULL){	
			stress_client_send(p_packet->p_client,p_packet->msg);
			free(p_packet);
		}
		else{
		}
	}
	printf("msg_send_parser exit \n");
	return NULL;	
}


static void *finish_parser(void *arg){
	Stress_Engine*p_engine = (Stress_Engine*)(arg);
	f_msleep(500);
	p_engine->life = 0;
	printf("finish_parser exit \n");
	return NULL;	
}
