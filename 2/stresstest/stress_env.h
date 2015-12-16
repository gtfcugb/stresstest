#ifndef _STRESS_ENV_H_
#define _STRESS_ENV_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "stress_structs.h"
#include <lua.h>

int  stress_env_init();
void stress_env_destroy();
void stress_env_register_cfun(Stress_Client*p_client);
void stress_env_register_cfun_server(Stress_Server*p_server);
#ifdef __cplusplus
}
#endif
#endif/*_STRESS_ENV_H_*/
