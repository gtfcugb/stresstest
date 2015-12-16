#include <time.h>
#include <stdlib.h>
#include <string.h>
#include "crypt.h"


/** 产生加密解密的key
 *@param char*realKey   		[out] 用于加密解密的key
 *@param char* transitKey  	[out]传送给客户端的key
 客户程序必须保证realKey,transitKey有17个字节可用
 */
void keyGenerate(char* realKey,char* transitKey){
	char tempKey[17];
	transitKey[16] = '\0';
	realKey[16] = '\0';
	tempKey[16] = '\0';
	int i;
	/*
	srand( (unsigned)time( NULL ) ); 
	for( i = 0; i < 16;i++ ){
		int d  = rand()%126+1;
		transitKey[i] = d;
	}*/
	strcpy(tempKey,transitKey);
	for( i = 0; i < 16;i++ ){
		realKey[i] = ((tempKey[i]  + tempKey[(i+1)%16] )*2 + i)%126 + 1;
	}
	strcpy(tempKey,realKey);
	for( i = 0; i < 16;i++ ){
		realKey[i] = ((tempKey[i]  + tempKey[(i+2)%16] )*3 + i)%126 + 1;
	}
	strcpy(tempKey,realKey);
	for( i = 0; i < 16;i++ ){
		realKey[i] = ((tempKey[i]  + tempKey[(i+3)%16] )*4 + i)%126 + 1;
	}
}


/** 数据加密，经过此函数处理后，内存数据编程加密后的数据
		加密方法依赖与传入的key
		这里数据和key均不能包含\0
 *@param char*data   	 	[in][out] 待加密的数据 
 *@param int orgLen  	 	[in]待加密数据的长度
 *@param char*key				[in]加密方法的参数
 *@param int keyLen  		[in]加密方法的参数的长度
 *@sa bitDecode
 */
void bitEncode(char*data, int orgLen, char*key, int keyLen) {
	if(keyLen <= 0 ||	orgLen <= 0 )
		return;
	int i;
	int k;
	char c;
	int temp;
	for (i = 0; i < orgLen; i++) {
		k = i % keyLen;
		c = data[i];
		temp = (key[k / 3] + key[k / 2] + key[k] + key[keyLen - k - 1]) % 4 + 1;
		c = (c << (8 - temp));
		data[i] = data[i] ^ c;
	}
}

/** 数据解密，经过此函数处理后，内存数据编程加密后的数据
		解密方法依赖与传入的key
		这里数据和key均不能包含\0
 *@param char*data   			[in][out] 待解密的数据 
 *@param int orgLen   		[in]待解密数据的长度
 *@param char*key					[in]解密方法的参
 *@param int keyLen   		[in]解密方法的参数的长度
 *@sa bitEncode
 */
void bitDecode(char*data, int orgLen, char*key, int keyLen) {
	if(keyLen <= 0 ||	orgLen <= 0 )
		return;
	int i;
	int k;
	char c;
	int temp;
	for (i = 0; i < orgLen; i++) {
		k = i % keyLen;
		c = data[i];
		temp = (key[k / 3] + key[k / 2] + key[k] + key[keyLen - k - 1]) % 4 + 1;
		c = (c << (8 - temp));
		data[i] = data[i] ^ c;
	}
}
