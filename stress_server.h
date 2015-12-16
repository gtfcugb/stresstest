#ifndef _STRESS_SERVER_H_
#define _STRESS_SERVER_H_
#include "stress_structs.h"

Stress_Server*stress_server_init(char *server_path);
void stress_server_destroy(Stress_Server*p_server);
int stress_server_init_do(Stress_Server*p_server);

int stress_server_input(Stress_Client*p_client,char*info,char *msg);
#endif/*_STRESS_SERVER_H_*/
