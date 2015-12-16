#include "stress_engine.h"
#include "stress_server.h"
#include "stress_env.h"
#include	<fcntl.h>
#include	<sys/ioctl.h>
#include <sys/epoll.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>
#include <pthread.h>
#include <errno.h>
#include <signal.h>
#include <syslog.h>
#include <sys/resource.h>
#include <assert.h>
int flag_daemon = 0;


int daemonize(const char* cmd){
	char msg[1024];
  int i,fd0,fd1,fd2;
	pid_t pid;
	struct rlimit rl;
	struct sigaction sa;
	umask(0);
	if( getrlimit(RLIMIT_NOFILE,&rl) < 0){
		sprintf(msg,"%s : can't get file limit",cmd);
		goto ERROR_OUT;
	}
	if((pid = fork() )< 0){
		sprintf(msg,"%s: can not fork",cmd);
		goto ERROR_OUT;
	}
	else if(pid != 0){
		exit(0);
	}	
	setsid();
	sa.sa_handler = SIG_IGN;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	if( sigaction(SIGHUP,&sa,NULL) < 0){
		sprintf(msg,"%s: can not ignore SIGHUP",cmd);
		goto ERROR_OUT;
	}
	if((pid = fork()) < 0){
		sprintf(msg,"%s: can not fork",cmd);
		goto ERROR_OUT;
	}
	else if(pid == 0){
		exit(0);
	}		
	if(chdir("/") < 0){
		sprintf(msg,"%s: can NOt change directory to /",cmd);
		goto ERROR_OUT;
	}	
	if(rl.rlim_max == RLIM_INFINITY)
		rl.rlim_max = 1024;
	rl.rlim_max = 3;
	for(i = 0 ; i < rl.rlim_max ; i++){
		close(i);
	}
	fd0 = open("/dev/null",O_RDWR);
	fd1 = dup(0);
	fd2 = dup(0);
	//int logmask;
	//openlog(cmd,LOG_CONS,LOG_LOCAL1);
	//logmask = setlogmask(LOG_UPTO(LOG_NOTICE));
	if( fd0 != 0 || fd1 != 1||fd2!= 2){
		sprintf(msg,"unexpected file descriptor %d %d %d",fd0,fd1,fd2);
		goto ERROR_OUT;
	}	
	return 0;
ERROR_OUT:
	printf("%s",msg);
	return -1;
}

char CONFIG_PATH[1024];
char CODE_CONFIG_PATH[1024];
int main(int argc,char**argv){
	int i;
	for (i = 1; i < argc; i++) {
		if (strcmp("-d", argv[i]) == 0) {//守护进程启动
			flag_daemon = 1;
		}
		if (strcmp("-c", argv[i]) == 0) {
			sprintf(CONFIG_PATH,"%s",argv[i+1]);
		}
		if (strcmp("-p", argv[i]) == 0) {//压缩文件地址
			sprintf(CODE_CONFIG_PATH,"%s",argv[i+1]);
		} 
	}
	if(flag_daemon == 1){
		daemonize("flashrobot");	
	}
	assert ( stress_env_init() == 0);
	Engine_Config* p_config = engine_config_init(CONFIG_PATH);
	assert(p_config != NULL);
	Stress_Engine* p_engine = stress_engine_init(p_config);
	stress_engine_work(p_engine);
	while(p_engine->life == 1){
		f_sleep(10);
	}
	printf("prepare exit main \n");
	stress_env_destroy();
	printf("stress_env_destroy \n");
	stress_engine_destroy(p_engine);
	printf("stress_engine_destroy \n");
	
	return 0;
}

void* flashgame_malloc(size_t size){
	return malloc(size);
}

void flashgame_free(void*data){
	free(data);
}

void* flashgame_realloc(void*data,size_t size){
	return realloc(data,size);
}

void* flashgame_calloc(size_t nmsize,size_t size){
	return calloc(nmsize,size);
}
