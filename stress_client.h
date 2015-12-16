#ifndef _STRESS_CLIENT_H_
#define _STRESS_CLIENT_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "stress_structs.h"

Stress_Client_Sets*stress_client_sets_init(int client_num);
void stress_client_sets_destroy(Stress_Client_Sets*p_sets);
void stress_client_sets_add(Stress_Client_Sets*p_sets,Stress_Client*p_client);
void stress_client_sets_work(Stress_Client_Sets*p_sets);

Stress_Client *stress_client_init(char *client_path,int port,char*ip);
void stress_client_destroy(Stress_Client*p_client);

int stress_client_init_do(Stress_Client*p_client);
int stress_client_send(Stress_Client* p_client,char *info );
int stress_client_input(Stress_Client* p_client,char *info);
/**转换至角色使用socket*/
void stress_client_sock_invert(Stress_Client* p_client);
#ifdef __cplusplus
}
#endif

#endif/*_STRESS_CLIENT_H_*/
