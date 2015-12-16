#include "stress_client.h"
#include "stress_env.h"
#include "stress_engine.h"
#include "crypt.h"
#include "comp.h"

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
extern F_Thread_Pool* g_pool;
static void *recv_parser(void *arg);
static void client_recv_msg(Stress_Client * p_client);
static char heartbeart_buf[1024] = "{\"mark\":\"system\",\"type\":\"heartbeat\",\"info\":{}}";

Stress_Client_Sets*stress_client_sets_init(int client_num){
	Stress_Client_Sets *p_sets =  (Stress_Client_Sets*)malloc(sizeof(Stress_Client_Sets));
	assert(p_sets != NULL);
	int size = client_num / 500 + 1;
	p_sets->p_vector = f_vector_create(size,NULL,NULL,NULL,NULL);
	assert(p_sets->p_vector != NULL);
	int i = 0;
	for( i = 0;i < size ; ++i){
			F_Doublelist *p_s = f_doublelist_create(NULL,NULL,NULL,NULL,NULL);
			assert(p_s != NULL);	
			assert(f_vector_push_back(p_sets->p_vector,p_s) != FELIX_FAILED);
	}
	p_sets->next_index = 0;
	p_sets->p_mutex = f_thread_mutex_init();
	assert(p_sets->p_mutex != NULL);
	return p_sets;
}

void stress_client_sets_destroy(Stress_Client_Sets*p_sets){
	int size = f_vector_size(p_sets->p_vector);
	int i = 0;
	for( i = 0;i < size ; ++i){
			F_Doublelist *p_list = f_vector_at(p_sets->p_vector,i);
			assert(p_list != NULL);
			F_Dl_Iter	iter = f_doublelist_begin(p_list);
			while(f_doublelist_end(p_list,iter) == false ){		
				Stress_Client * p_client = (Stress_Client *)f_doublelist_def(iter);		
				stress_client_destroy(p_client);
				iter = f_doublelist_next(p_list,iter);
			}
			f_doublelist_destroy(p_list);			
	}
	f_vector_destroy(p_sets->p_vector);
	f_thread_mutex_destroy(p_sets->p_mutex);
	free(p_sets);
}

void stress_client_sets_add(Stress_Client_Sets*p_sets,Stress_Client*p_client){
	int size = f_vector_size(p_sets->p_vector);
	F_Doublelist *p_list = f_vector_at(p_sets->p_vector,p_sets->next_index);
	f_doublelist_push_back(p_list,p_client);
	p_sets->next_index ++ ;
	if(p_sets->next_index == size){
		p_sets->next_index = 0;
	}
}

Stress_Client *stress_client_init(char *client_path,int port,char*ip){
	Stress_Client * p_client = (Stress_Client*)malloc(sizeof(Stress_Client));
	assert(p_client != NULL);
	memset(p_client->keywords,0,KEYWORDS_LEN + 1);
	p_client->sock = -1;
	p_client->invert_flag = 1;
	p_client->rp   = (Recv_P*)malloc(sizeof(Recv_P));
	memset(p_client->rp->left_buf,0,MSG_RECV_LEN);
	p_client->rp->left_len = 0;
	p_client->L					=	luaL_newstate();
	assert(p_client->L != NULL);
	luaL_openlibs(p_client->L);
	if (luaL_loadfile(p_client->L, client_path) || lua_pcall(p_client->L, 0, 0, 0)) {
		assert(false);	
	}
	p_client->p_mutex = f_thread_mutex_init();
	assert(p_client->p_mutex != NULL);
	p_client->p_addr = f_inet_addr_init(port,ip,NULL);
	assert(p_client->p_addr  != NULL);
	p_client->p_sock = 	f_sock_stream_init(NULL);
	assert(p_client->p_sock != NULL);
	F_Sock_Connect*	p_con = f_sock_connect_init(NULL);
	assert(p_con != NULL);
	int ret = f_sock_connect_open(p_con);
	assert(ret != FELIX_FAILED);
	ret = f_sock_connect_work(p_con,p_client->p_addr,p_client->p_sock,0);
	assert(ret != FELIX_FAILED);
	p_client->p_con = p_con;
	p_client->sock = f_sock_stream_get(p_client->p_sock);

    /*
	char buf_key[KEYWORDS_LEN+1];
	memset(buf_key,0,KEYWORDS_LEN+1);
	ret = f_sock_stream_recv(p_client->p_sock,buf_key,KEYWORDS_LEN,0);
	keyGenerate(p_client->keywords,buf_key);
	*/

#ifdef WIN32
	/**由于WIN32 不能设置MSG_DONTWAIT 故采用非阻塞模式*/
	f_sock_set_nonblock(p_client->p_sock);
#endif
	
	/*
	p_client->p_sock_invert = 	f_sock_stream_init(NULL);
	assert(p_client->p_sock_invert != NULL);
	F_Sock_Connect*	p_con_invert = f_sock_connect_init(NULL);
	assert(p_con_invert != NULL);
	ret = f_sock_connect_open(p_con_invert);
	assert(ret != FELIX_FAILED);
	ret = f_sock_connect_work(p_con_invert,p_client->p_addr,p_client->p_sock_invert,0);
	assert(ret != FELIX_FAILED);
	p_client->p_con_invert 	= p_con_invert;
	p_client->sock_invert 	= f_sock_stream_get(p_client->p_sock_invert);

	memset(buf_key,0,KEYWORDS_LEN+1);
	ret = f_sock_stream_recv(p_client->p_sock_invert,buf_key,KEYWORDS_LEN,0);
	keyGenerate(p_client->keywords_invert,buf_key);*/
	
#ifdef WIN32
	/**由于WIN32 不能设置MSG_DONTWAIT 故采用非阻塞模式*/
	f_sock_set_nonblock(p_client->p_sock_invert);
#endif
	return p_client;	
}

void stress_client_destroy(Stress_Client*p_client){
	lua_close(	p_client->L );
	free(p_client->rp);
	f_thread_mutex_destroy(p_client->p_mutex);
	f_sock_stream_destroy(p_client->p_sock,NULL);
	f_sock_stream_destroy(p_client->p_sock_invert,NULL);
	f_inet_addr_destroy(p_client->p_addr,NULL);
	f_sock_connect_close(p_client->p_con);
	f_sock_connect_destroy(p_client->p_con,NULL);
    /*
	f_sock_connect_close(p_client->p_con_invert);
	f_sock_connect_destroy(p_client->p_con_invert,NULL);*/
	free(p_client);
}

int stress_client_init_do(Stress_Client*p_client){
	lua_State* L =p_client->L;
	lua_getglobal(L,"init");	
	lua_pushinteger(L, p_client->sock);
    lua_pushinteger(L, (unsigned short)pthread_self());
	if(lua_pcall(L, 2, 0, 0)){
		printf("init pcall %s\n",lua_tostring(L,-1));
		assert(false);
		return -1;
	}
	return 0;
}

void stress_client_sock_invert(Stress_Client* p_client){
	strcpy(p_client->keywords,p_client->keywords_invert);;
	p_client->invert_flag = 2;
}

F_Sock_Stream* stress_client_get_current_sock(Stress_Client* p_client){
	if(p_client->invert_flag == 2){
		return p_client->p_sock_invert;
	}
	return p_client->p_sock;
}

int stress_client_send(Stress_Client* p_client,char *info ){
	int ret = 0;
	int total = strlen(info)+1;
	LABEL_SEND: ret = f_sock_stream_send(stress_client_get_current_sock(p_client),info + ret,total - ret,0);
	if (ret <= 0) {
		printf("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \n");
		return -1;
		ret = 0;
		assert(false);
		goto LABEL_SEND;
	}
	if (ret < total) {
		printf("yyyyyyyyyyyyyyyyyyyyyyyyyyyyy \n");
		return -1;
		assert(false);
		goto LABEL_SEND;
	}
	return 0;
}

int stress_client_input(Stress_Client* p_client,char *info){
	/*struct timeval tv;
	gettimeofday(&tv, NULL);*/
	f_thread_mutex_lock(p_client->p_mutex);
	lua_State* L =p_client->L;

    /*
	if(strcmp(info,heartbeart_buf) != 0){
		int readlen 		= strlen(info);
		if(readlen	<	2){
			f_thread_mutex_unlock(p_client->p_mutex);
			return 0;
		}
		char realkey[KEYWORDS_LEN + 1];
		strcpy(realkey, p_client->keywords);
		realkey[0] 			=	info[0];
		realkey[1] 			=	info[1];
		bitDecode(info + 2, readlen - 2, realkey, KEYWORDS_LEN);
		readlen 				= strlen(info);
		int declen 			= 0;
		char *protoinfo = do_decompress(info + 2, readlen - 2, &declen);
		if(protoinfo == NULL){
			printf("xxxxxx------------ do_decompress error %s \n", info);
			f_thread_mutex_unlock(p_client->p_mutex);
			return 0;
		}
		strncpy(info,protoinfo,MSG_RECV_LEN - 1);
		free(protoinfo);
	}
    */
	lua_getglobal(L,"input");	
	lua_pushstring(L, info);
	if(lua_pcall(L, 1, 0, 0)){
		printf("error input pcall %s %s\n",lua_tostring(L,-1),info);
		f_thread_mutex_unlock(p_client->p_mutex);
		//assert(false);
		return -1;
	}
	f_thread_mutex_unlock(p_client->p_mutex);
	/*struct timeval tv1;
	gettimeofday(&tv1, NULL);
	printf("--------- time %d %d \n",tv1.tv_sec - tv.tv_sec,tv1.tv_usec - tv.tv_usec);*/
	return 0;
}

void stress_client_sets_work(Stress_Client_Sets*p_sets){
	int size = f_vector_size(p_sets->p_vector);
	int i = 0;
	for( i = 0;i < size ; ++i){
		F_Doublelist *p_list = f_vector_at(p_sets->p_vector,i);
		int res = f_thread_pool_process_job(g_pool,recv_parser,p_list);
		assert(res == 0);			
	}
}

static void *recv_parser(void *arg){
	Stress_Engine *p_engine = NULL;
	int cur_tick = 0;
	struct timeval lastTv,currentTv;
	gettimeofday(&lastTv,0);
	F_Doublelist*p_list = (F_Doublelist*)(arg);
	while(true){
		gettimeofday(&currentTv,0);
		//至少一秒会通知客户程序
		if(cur_tick++ == 1000 || (currentTv.tv_sec-lastTv.tv_sec) * 1000000 + (currentTv.tv_usec-lastTv.tv_usec) >= 500000){
			cur_tick = 0;
			lastTv	= currentTv;
		}		
		F_Dl_Iter	iter = f_doublelist_begin(p_list);
		while(f_doublelist_end(p_list,iter) == false ){		
			Stress_Client * p_client = (Stress_Client *)f_doublelist_def(iter);		
			if(p_engine == NULL){
				p_engine = p_client->p_engine;
			}
			if(cur_tick == 0 ){//每秒触发客户端一次
				//printf("stress_engine_put_msg cur_tick %d currentTime %d *********\n",cur_tick,GetTickCount());
				stress_engine_put_msg(p_client->p_engine,p_client,heartbeart_buf,strlen(heartbeart_buf));
			}
			client_recv_msg(p_client);
			iter = f_doublelist_next(p_list,iter);
		}
		if(p_engine != NULL && p_engine->life == 0){
			break;
		}
		//不同机器睡眠时间不同 
		f_msleep(1);
	}
	printf("recv_parser exit \n");
	return NULL;	
}

static void client_recv_msg(Stress_Client * p_client){
	Recv_P *rp = p_client->rp;
	if(rp == NULL)
		return ;
	char *left_buf = rp->left_buf;
	int left_len 	=  rp->left_len;
	char rbuf[MSG_RECV_LEN];
	int pro_len;
	char *pos;
	char *pCur;
	bool flag = true;
	while(flag){
		flag = false;
		int res = f_sock_stream_recv(stress_client_get_current_sock(p_client),rbuf,MSG_RECV_LEN,MSG_DONTWAIT);
		pCur = rbuf;
		if (res <= 0){
			return;
		}
		else {
			if(res == MSG_RECV_LEN)//当接受到的数据长度小于请求的长度时，则无数据可读，无需再次循环
				flag = true;
			while(res > 0&&(pos = (char *)memchr(pCur,'\0',res)) != 0){//是否含有 分隔符
				pro_len = pos - pCur+1;
				if(left_len+pro_len <= MSG_RECV_LEN){//未超过最大长度
					memcpy(left_buf+left_len,pCur,pro_len);	
					stress_engine_put_msg(p_client->p_engine,p_client,left_buf,left_len+pro_len);
				}
				left_len = 0;
				pCur = pCur + pro_len;
				res = res -	pro_len;
			}
			if(left_len + res >= MSG_RECV_LEN){//超过最大长度
				left_len = 0;
				continue;
			}
			memcpy(left_buf+left_len,pCur,res);
			left_len += res;			
		}
	}
	rp->left_len = left_len;
}
