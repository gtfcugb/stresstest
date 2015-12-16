#ifndef _STRESS_ENGINE_H_
#define _STRESS_ENGINE_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "stress_structs.h"

Engine_Config*engine_config_init(char*	content);
void engine_config_destroy(Engine_Config*p_config);

Stress_Engine*stress_engine_init(Engine_Config*p_config);
void stress_engine_destroy(Stress_Engine*p_engine);
void stress_engine_work(Stress_Engine*p_engine);
void stress_engine_put_msg(Stress_Engine*p_engine,Stress_Client * p_client,char*msg,int len);
void stress_server_send_msg(Stress_Engine*p_engine,Stress_Client * p_client,char*msg);
void stress_engine_finish(Stress_Engine*p_engine);
#ifdef __cplusplus
}
#endif
#endif/*_STRESS_ENGINE_H_*/
