stressclient:main.o stress_server.o stress_client.o stress_engine.o stress_env.o crypt.o comp.o
	gcc -g -Wl,-E -o stressclient main.o stress_client.o stress_server.o stress_engine.o  stress_env.o  crypt.o comp.o liblua.a libjson.a -lm -ldl -lfcgame -lpthread -Wall  
main.o:main.c
	gcc -g -c main.c -Wall 	
stress_server.o:stress_server.c
	gcc -g -c stress_server.c -Wall 
stress_client.o:stress_client.c
	gcc -g -c stress_client.c -Wall 	
stress_engine.o:stress_engine.c
	gcc -g -c stress_engine.c -Wall
stress_env.o:stress_env.c
	gcc -g -c stress_env.c -Wall
crypt.o:crypt.c
	gcc -g -c crypt.c -Wall
comp.o:comp.c
	gcc -g -c comp.c -Wall

clean:
	rm -f main.o stress_server.o stress_client.o stress_engine.o  stress_env.o 


# gcc -g -o main main.c stress_env.c stress_client.c stress_server.c stress_engine.c comp.c crypt.c -I/usr/local/include/ -L/usr/local/lib -l -m -lfcgame -ljson -llua -lpthread
# gcc -g -o main main.c stress_env.c stress_client.c stress_server.c stress_engine.c comp.c crypt.c liblua.a libxjson.a -I/usr/local/include/ -L/usr/local/lib -ldl -lm -lfcgame -ljson  -lpthread