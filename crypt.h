/*! \file cryp.h

 *  \brief 数据解密加密
 *  \author gtf
 *  \version 1.1
 *  \date    2008—09-05
 */

#ifndef CRYP_H_
#define CRYP_H_

/** 数据加密，经过此函数处理后，内存数据编程加密后的数据
		加密方法依赖与传入的key
		这里数据和key均不能包含\0
 *@param char*data   	 	[in][out] 待加密的数据 
 *@param int orgLen  	 	[in]待加密数据的长度
 *@param char*key				[in]加密方法的参数
 *@param int keyLen  		[in]加密方法的参数的长度
 *@sa bitDecode
 */
void bitDecode(char*origin, int orgLen, char*key,int keyLen);

/** 数据解密，经过此函数处理后，内存数据编程加密后的数据
		解密方法依赖与传入的key
		这里数据和key均不能包含\0
 *@param char*data   			[in][out] 待解密的数据 
 *@param int orgLen   		[in]待解密数据的长度
 *@param char*key					[in]解密方法的参数
 *@param int keyLen   		[in]解密方法的参数的长度
 *@sa bitEncode
 */
void bitEncode(char*origin, int orgLen, char*key,int keyLen);

/** 产生加密解密的key
 *@param char*realKey   		[out] 用于加密解密的key
 *@param char* transitKey  	[out]传送给客户端的key
 客户程序必须保证realKey,transitKey有17个字节可用
 */
void keyGenerate(char* realKey,char* transitKey);

#endif /* CRYP_H_ */
