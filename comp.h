#ifndef _COMP_
#define _COMP_

/** 
*@brief 压缩解压缩模块初始化
*@param 字典文件路径
*@return 0 成功 -1 失败
*/
int comp_init(char * path);

/** 
*@brief 压缩解压缩模块销毁
*/
void comp_destroy();

/** 
*@brief 压缩数据
*@param src 输入数据
*@param len 输入数据长度
*@param des_len 压缩后的数据长度
*@return 失败 NULL 成功 ; 压缩后的数据
*/
char *do_compress(char*src ,int len,int *des_len);

/** 
*@brief 解压缩数据
*@param src 输入数据
*@param len 输入数据长度
*@param des_len 解压后的数据长度
*@return 失败 NULL ;成功 解压缩后的数据
*/
char *do_decompress(char*src ,int len,int *des_len);

#endif

