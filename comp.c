#include <fcalg/fcalg.h>

#include "comp.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include <json/json.h>
#define DICT_TABLE_ENUM_BEGIN "dict_table_enum_begin"
#define DICT_TABLE_ENUM_NEXT "dict_table_enum_next"

//#define KEY_LEN 	512
#define BITS_LEN 	14

typedef struct key_bits{
	char *key;
	char bits[BITS_LEN];
}Key_Bits;

/*用于压缩*/
typedef F_Hashtable Dict_Table;
/*用于解压*/
typedef F_Hashtable Dict_Map;

static Dict_Table *s_p_dict = 0;
static Dict_Map 	*s_p_map = 0;
static F_Doublelist *s_find = 0;
static Key_Bits s_find_key ;

static int find_op_compare(void *data_one,void*data_two);
static void list_destoy(void *a );
static int list_compare(void *data_one,void*data_two);
static void my_destroy(void *a );
static int my_compare(void *data_one,void*data_two);
static int deal_key_bits(char*key,char *value);
static void key_bits_sort();
static char *find_code(char *src,int *pos,int len);
static char *form_01char(char *src,int len,int *out_len,int *out_0_num);
static char *deal_0hide(char *src,int len,int *out_len,int );
static char *deal_0appear(char *src,int len,int *out_len,int *);
static char * form_01bit(char *src,int len,int *out_len);
static char * restore_string(char *src,int len,int *out_len);

static void list_destoy(void *a ){
	free(((Key_Bits*)a)->key);
	free((Key_Bits*)a);
}

static int list_compare(void *data_one,void*data_two){
	Key_Bits *p_key_one = (Key_Bits*)data_one;
	Key_Bits *p_key_two = (Key_Bits*)data_two;
	return strlen(p_key_two->key) - strlen(p_key_one->key)  ;
}

static void op_destoy(void *a ){
}

static int op_compare(void *data_one,void*data_two){
	Key_Bits *p_key_one = (Key_Bits*)data_one;
	Key_Bits *p_key_two = (Key_Bits*)data_two;	
	return strcmp(p_key_one->bits,p_key_two->bits);
}

static int find_op_compare(void *data_one,void*data_two){
	Key_Bits *p_key_one = (Key_Bits*)data_one;
	return strcmp(p_key_one->bits,(char*)data_two);
}

static unsigned int find_op_hash(void *p_key,unsigned int bucket_num){	
	return ((unsigned int)f_hashlittle(p_key,strlen(p_key),1))%bucket_num;
}

static unsigned int op_hash(void *p_key,unsigned int bucket_num){
	Key_Bits *p_key_ = (Key_Bits*)p_key;
	return ((unsigned int)f_hashlittle(p_key_->bits,strlen(p_key_->bits),1))%bucket_num;
}

static void my_destroy(void *a ){
	F_Doublelist *p_list = (F_Doublelist*)a;	
	f_doublelist_destroy(p_list);
}

static int find_compare(void *data_one,void*data_two){
	F_Doublelist *p_list_one = (F_Doublelist*)data_one;
	Key_Bits *p_head_one = f_doublelist_front(p_list_one);
	int ret;
	if(strlen(p_head_one->key) == 1 && strlen((char*)data_two) == 1 ){
		ret = strncmp(p_head_one->key,(char*)data_two,1);
	}
	else if(strlen(p_head_one->key) != 1 && strlen((char*)data_two) != 1 ){
		ret = strncmp(p_head_one->key,(char*)data_two,3);
	}else{
		ret = 1;
	}
	return ret ;	
}

static unsigned int find_hash(void *p_key,unsigned int bucket_num){
	char *key = (char*)p_key;
	int index;
	if(strlen(key) < 3){//处理单个字母的情况
		index = f_hashlittle(key,strlen(key),1);
	}
	else{
		index = f_hashlittle(key,3,1);
	}		
	return ((unsigned int)index)%bucket_num;
}

static int my_compare(void *data_one,void*data_two){
	F_Doublelist *p_list_one = (F_Doublelist*)data_one;
	Key_Bits *p_head_one = f_doublelist_front(p_list_one);
	F_Doublelist *p_list_two = (F_Doublelist*)data_two;
	Key_Bits *p_head_two = f_doublelist_front(p_list_two);		
	int ret;
	if(strlen(p_head_one->key) == 1 && strlen(p_head_two->key) == 1 ){
		ret = strncmp(p_head_one->key,p_head_two->key,1);
	}
	else if(strlen(p_head_one->key) != 1 && strlen(p_head_two->key) != 1 ){
		ret = strncmp(p_head_one->key,p_head_two->key,3);
	}else{
		ret = 1;
	}
	return ret ;
}

static unsigned int my_hash(void *p_key,unsigned int bucket_num){
	F_Doublelist *p_list = (F_Doublelist*)p_key;
	Key_Bits *p_head = f_doublelist_front(p_list);
	char *key = p_head->key;
	int index;
	//printf("key |%s| |%d| len %d\n",key,key[0],strlen(key));
	if(strlen(key) < 3){//处理单个字母的情况
		index = f_hashlittle(key,strlen(key),1);	
	}
	else{
		index = f_hashlittle(key,3,1);
	}		
	return ((unsigned int)index)%bucket_num;
}

static int deal_key_bits(char*key,char *value){
	if(key == NULL || value == NULL){
		return -1;
	}
	if( strlen(value) >= BITS_LEN){
		return -1;
	}
	Key_Bits *p_key = (Key_Bits*)malloc(sizeof(Key_Bits));
	assert(p_key != NULL);
	p_key->key = (char*)malloc(strlen(key)+1);
	strcpy(p_key->key ,key);	
	strcpy(p_key->bits ,value);
	/*用于解压*/
	f_hashtable_insert(s_p_map,p_key);
	s_find_key.key = (char*)malloc(strlen(key) + 1);
	assert(s_find_key.key!=0);
	strcpy(s_find_key.key ,key);
	F_Doublelist *p_find_list = f_hashtable_find(s_p_dict,s_find);
	if(p_find_list == NULL){
		p_find_list = f_doublelist_create(list_destoy,NULL,NULL,NULL,list_compare);
		assert(p_find_list != NULL);
		f_doublelist_push_back(p_find_list,p_key);
		f_hashtable_insert(s_p_dict,p_find_list);
	}
	else{
		f_doublelist_push_back(p_find_list,p_key);
	}	
	free(s_find_key.key);
	return 0;
}

/* 
前3个字符相同的的node，进行自身链表的排序
*/
static void key_bits_sort(){
	F_Doublelist *p_list;
	F_H_Iter iter = f_hashtable_begin(s_p_dict);
	while(f_hashtable_end(s_p_dict,iter) != true){		
		//printf("---------key_bits_sort while...\n");
		p_list = (F_Doublelist*)f_hashtable_def(iter);
		f_doublelist_sort(p_list);
		iter = f_hashtable_next(s_p_dict,iter);
	}
}

//------------------------------------------------------------------------------------------------------------
/**/
static char *find_code(char *src,int *pos,int len){
	int i = *pos;
	char find_key[4];
	if( i > len - 3){//快到字符串末尾	
		find_key[0] = src[i];
		find_key[1] = '\0';
		F_Doublelist *p_find_list = f_hashtable_find(s_p_dict,find_key);
		assert(p_find_list != 0);
		++i;
		*pos = i;
		Key_Bits *p_key = f_doublelist_front(p_find_list);	//p_find_list 肯定不为0'=
		//printf("*********\n%s\n%s",p_key->key,p_key->bits);
		return p_key->bits;
	}
	find_key[0] = src[i];
	find_key[1] = src[i + 1];
	find_key[2] = src[i + 2];
	find_key[3] = '\0';

	F_Doublelist *p_find_list = f_hashtable_find(s_p_dict,find_key);
	if(p_find_list != NULL){
		F_Dl_Iter	iter = f_doublelist_begin(p_find_list);
		while(f_doublelist_end(p_find_list,iter) == false ){
			//printf("---------find_code while...\n");
			Key_Bits *p_key = (Key_Bits*)f_doublelist_def(iter);

			int key_len = strlen(p_key->key);
			if(i + key_len <= len){//bug < 				
				if(strncmp(src + i,p_key->key,key_len) == 0){//找到最长的
//					printf("*********\n%s\n%s",p_key->key,p_key->bits);
					*pos = i + key_len;
					return p_key->bits;	
				}
			}			
			iter = f_doublelist_next(p_find_list,iter);
		}		
		//都没有找到，则只编码一个字符	
	}	
	find_key[1] = '\0';
	p_find_list = f_hashtable_find(s_p_dict,find_key);
	++i;
	*pos = i;
	assert(p_find_list != 0);
	Key_Bits *p_key = f_doublelist_front(p_find_list);	//p_find_list 肯定不为0'=
	
//	printf("*********\n%d\n%s",p_key->key[0],p_key->bits);
	return p_key->bits;	
}

static char *form_01char(char *src,int len,int *out_len,int *out_0_num){
	int max_size = 1024;
	int size = 0;
	char *des = (char*)malloc(max_size);
	memset(des,0,max_size);
	if(des == NULL)
		return NULL;
	int i  = 0;
	while( i < len ){
		//printf("---------form_01char while 1...\n");
		char *code = find_code(src,&i,len);
		size	+= strlen( code );
		while(max_size <= size){
			//printf("---------form_01char while 2...\n");
			max_size*=2;
			char *temp = (char*)malloc(max_size);
			if(temp == NULL){
				free(des);
				return NULL;
			}
			memset(temp,0,max_size);
			memcpy(temp,des,max_size/2);
			free(des);
			des = temp;
		}		
		strcat(des,code);		
	}	
	//printf("des %s\n",des);
	int _out_len = 0;
	int c = 0;
	int k = 0;
	for(i = 0;i	< size;++i){
		++k;
		c += ldexp((des[i] - 48), (8 - k));
		if(k == 8){
			des[_out_len] = c;
			k = 0;
			c = 0;
			++_out_len;
		} 	
	}
	if(k != 0){
		des[_out_len] = c;
		*out_len = _out_len + 1;
		*out_0_num = 8 - k ;
	}else{
		*out_len = _out_len ;
		*out_0_num = 0;
	}
//	printf("补0 %d\n",*out_0_num);
	return des;
}


static char *deal_0hide(char *src,int len,int *out_len,int out_0_num){
	char num_char[67];
	int max_size = 1024;
	int cur_len = 0;
	int size = 0;
	char *des = (char*)malloc(max_size);
	memset(des,0,max_size);
	if(des == NULL)
		return NULL;	
	while(cur_len < len){
		//printf("---------deal_0hide while 1...\n");
		if(src[cur_len] != '\0'){
			++cur_len;
			continue;
		}
		src[cur_len] = '1';
		sprintf(num_char,"%d*",len - cur_len);
		size	+= strlen(num_char);
		while(max_size <= size + 2){
			//printf("---------deal_0hide while 2...\n");
			max_size	*=	2;
			char *temp = (char*)malloc(max_size);
			if(temp == NULL){
				free(des);
				return NULL;
			}
			memset(temp,0,max_size);
			memcpy(temp,des,max_size/2);
			free(des);
			des = temp;
		}		
		strcat(des,num_char);
		++cur_len;
	}
	des[size] = 31 + out_0_num;
	++size;
	char *final_des = (char*)malloc(size + len + 1);
	if(final_des == NULL){
		free(des);
		return NULL;
	}
	memset(final_des,0,size + len  + 1);
	memcpy(final_des,des,size);
	memcpy(final_des + size,src,len);
	free(des);
	*out_len = size + len;
	return final_des;
}

static int GET_FIRST_3BIT(int ch){
	int res = 0;
	int b = 128;
	res += ((ch&b)?1:0) * 4;
	ch <<= 1;
	res += ((ch&b)?1:0) * 2;
	ch <<= 1;
	res += ((ch&b)?1:0);
	return res;
}

static char *deal_0appear(char *src,int len,int *out_len,int *out_0_num){
	char *des = (char*)malloc(len);
	if(des == NULL){
		return NULL;
	}
	memset(des,0,len);
	if((src[0]&31) == 31){
		*out_0_num = GET_FIRST_3BIT(src[0]);
		memcpy(des,src+1,len-1);		
		*out_len = len - 1;
		return des;
	}
	int i = 0;
	while(i < len){
		//printf("---------deal_0appear while 1...\n");
		int k = 0;
		char temp_num[64];
		while(src[i] != '*'){
			//printf("---------deal_0appear while 2...\n");
			temp_num[k] = src[i] ;
			++k;
			++i;
			if(i >= len - 1 || k >= 64){//确保数组不越界
				free(des);
				return NULL;
			}
		}
		temp_num[k] = '\0';
		int pos = len -  atoi(temp_num);//如果temp_num不是数字，将返回0，则出错
		if(pos < 0 || pos >= len){
			free(des);
			return NULL;
		}
		src[pos] = '\0';
		++i;
		if( (src[i]&31) == 31)
			break;
	}
	*out_0_num = GET_FIRST_3BIT(src[i]);
	memcpy(des,src+i+1,len - i - 1);
	*out_len = len - i -1;
	return des;
}


static char * form_01bit(char *src,int len,int *out_len){
	int max_size = 1024;
	int size = 0;
	char *des = (char*)malloc(max_size);
	memset(des,0,max_size);
	if(des == NULL)
		return NULL;
	int i ;
	for(i = 0; i < len; ++i){
		while(max_size <= size + 9){//保证9个剩余，防止数组越界
			//printf("---------form_01bit while...\n");
			max_size*=2;
			char *temp = (char*)malloc(max_size);
			if(temp == NULL){
				free(des);
				return NULL;
			}
			memset(temp,0,max_size);
			memcpy(temp,des,max_size/2);
			free(des);
			des = temp;
		}		
		char ch = src[i];
		int b = 128;
		int j ;
		for(j = 0;j < 8;++j){
			des[size] = (ch & b )? '1' : '0';
			++size ;
			ch <<= 1;
		}
	}	
	*out_len = size;
	return	des;
}

static char * restore_string(char *src,int len,int *out_len){
	char find_key[14];
	Key_Bits *p_key ;
	char	*key;
	int max_size = 1024;
	int size = 0;
	char *des = (char*)malloc(max_size);
	memset(des,0,max_size);
	if(des == NULL)
		return NULL;
	int i = 0;
	while(i < len){
		//printf("---------restore string while 1...\n");
		if(src[i] == '1' && len - i >= 5){
			if(src[i+1] == '0'){
				if(src[i+2] == '0'){
					memcpy(find_key,src + i,5);
					find_key[5] = '\0';
					i	+= 5;	
				}else if(src[i+2] == '1' &&len - i >= 7){
					memcpy(find_key,src + i,7);
					find_key[7] = '\0';
					i	+= 7;	
				}
				else{
			//		printf("error oout 5\n");
					free(des);
					return NULL;
				}						
			}
			else if(src[i+1] == '1' && len - i >= 9){
				if(src[i+2] == '0'){
					memcpy(find_key,src + i,9);
					find_key[9] = '\0';
					i	+= 9;	
				}
				else if(src[i+2] == '1'&& len - i >= 10){
					memcpy(find_key,src + i,10);
					find_key[10] = '\0';
					i	+= 10;	
				}
				else{
			//		printf("error oout 6\n");
					free(des);
					return NULL;
				}	
				
			}
			else{
		//		printf("error oout 7\n");
				free(des);
				return NULL;
			}	
		}
		else if(src[i] == '0' && len - i >= 13 ){
			memcpy(find_key,src + i,13);
			find_key[13] = '\0';
			i	+= 13;			
		}
		else{
			free(des);
			return NULL;
		}
		p_key = f_hashtable_find(s_p_map,find_key);
		if(p_key == NULL){
			free(des);
//			printf("error oout 8\n");
			return NULL;
		}
		key = p_key->key;
		size	+= strlen(key);
		while(max_size <= size + 1){
			//printf("---------restore string while 2...\n");
			max_size	*=	2;
			char *temp = (char*)malloc(max_size);
			if(temp == NULL){
				free(des);
//				printf("error oout 9\n");
				return NULL;
			}
			memset(temp,0,max_size);
			memcpy(temp,des,max_size/2);
			free(des);
			des = temp;
		}		
		strcat(des,key);
	}
	return des;
}

//--------------------------------------------------------------------------------------------
int comp_init(char * path){

	s_p_dict = f_hashtable_create(10240,my_destroy,NULL,NULL,NULL,my_compare,my_hash);
	if(s_p_dict == NULL)
		return -1;
	s_p_map	= f_hashtable_create(10240,op_destoy,NULL,NULL,NULL,op_compare,op_hash);
	if(s_p_map == NULL)
		return -1;	
	s_find 	= f_doublelist_create(list_destoy,NULL,NULL,NULL,list_compare);
	if(s_find == NULL){
		f_hashtable_destroy(s_p_dict);
		return -1;
	}		
	f_doublelist_push_back(s_find,&s_find_key);
	
	FILE*	fp = fopen(path,"r");
	if(fp == NULL){
		f_hashtable_destroy(s_p_dict);
		return -1;
	}
	char * content = (char *)malloc(204800);
	memset(content , 0 ,204800);
	assert(content != NULL);
	int c;
	int i = 0;
	while((c = fgetc(fp) )!= EOF){
		//printf("---------comp_init while...\n");
		if(i >= 204800 - 1){
			free(content);
			f_hashtable_destroy(s_p_dict);
			fclose(fp);
			return -1;
		}
		content[i]=c;
		i++;
	}
	fclose(fp);
	struct json_object *obj;
	obj = json_tokener_parse(content);
	if (obj == NULL || is_error(obj)){
		free(content);
		f_hashtable_destroy(s_p_dict);
		return -1;		
	}
	if( json_object_is_type(obj, json_type_object ) != 1){
		json_object_put(obj);
		free(content);
		f_hashtable_destroy(s_p_dict);
		return -1;	
	}	
	char *key = NULL;
	struct json_object *push_next = NULL;
	struct lh_entry *entry = NULL;
	enum json_type get_type;
	for(entry = json_object_get_object(obj)->head;({if(entry){key = (char *)entry->k; push_next = (struct json_object *)entry->v;}entry;}); entry = entry->next)
	{
		get_type = json_object_get_type(push_next);
		switch(get_type)
		{
			case json_type_string:
				deal_key_bits(key,(char*)json_object_get_string(push_next));
				break;
			default:
				break;			
		}
	}
	key_bits_sort();
	json_object_put(obj);
	free(content);
	/*重新设置比较函数，方便查找
	*hash表只用于读	
	*/
	f_hash_compare_set(s_p_dict,find_compare);
	f_hash_compare_set(s_p_map,find_op_compare);
	f_hash_hashfun_set(s_p_dict,find_hash);
	f_hash_hashfun_set(s_p_map,find_op_hash);
	return 0;
}

void comp_destroy(){
	if(s_p_dict != NULL){
		f_hashtable_destroy(s_p_dict);
	}	
	if(s_p_map != NULL){
		f_hashtable_destroy(s_p_map);
	}			
	if(s_find != NULL){
		f_doublelist_pop_front(s_find);
		f_doublelist_destroy(s_find);		
	}
}

void show_dict_table(){
	F_Doublelist *p_list;
	F_H_Iter iter = f_hashtable_begin(s_p_dict);
	while(f_hashtable_end(s_p_dict,iter) != true){		
		p_list = (F_Doublelist*)f_hashtable_def(iter);
		{
			F_Dl_Iter	iter = f_doublelist_begin(p_list);
			while(f_doublelist_end(p_list,iter) == false ){
				//printf("---------show_dict_table while 2...\n");
				//Key_Bits *p_key = (Key_Bits*)f_doublelist_def(iter);
				iter = f_doublelist_next(p_list,iter);
			}
		}
		iter = f_hashtable_next(s_p_dict,iter);
	}
}

char *do_compress(char*src ,int len,int *des_len){
	if(len <= 0)//不处理空字符串
		return NULL;
	char * temp_01 ;
	int out_len 	= 0;
	int out_0_num = 0;
	temp_01 = form_01char(src,len,&out_len,&out_0_num);
	if(temp_01 == NULL){
		return NULL;
	}	
	/*补0个数*/
	out_0_num = out_0_num << 5;
	int final_len;
	/*隐藏字符'\0'*/
	char *final_des = deal_0hide(temp_01,out_len,&final_len,out_0_num);
	if(final_des == NULL){
		free(temp_01);
		return NULL;
	}		
	free(temp_01);
	*des_len	 = final_len;
	return final_des;
}

char *do_decompress(char*src ,int len,int *des_len){
	if(len <= 0)
		return NULL;
	int temp_len = 0;
	int out_0_num;
	char *temp_src = deal_0appear(src,len,&temp_len,&out_0_num);
	if(temp_src == NULL){
		printf("error oout 1\n");
		return NULL;
	}
	int out_len;
	char *temp_des = form_01bit(temp_src,temp_len,&out_len);	
	if(temp_des == NULL || out_len - out_0_num < 0){
		printf("error oout 2\n");
		free(temp_src);
		return NULL;
	}
	free(temp_src);
	temp_des[out_len - out_0_num] = '\0';
	char *des;
	int des_len_ = 0;
	des = restore_string(temp_des,out_len - out_0_num,&des_len_);
	if(des == NULL){
		printf("error oout 3\n");
		free(temp_des);
		return NULL;
	}
	free(temp_des);
	*des_len = des_len_;
	return des;
}
