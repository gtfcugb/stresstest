--定义大配置
--游戏相关数据定义
local gameinfo={
		[1]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=100,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{0,82},{1,4},{2,3},{3,2},{4,1},{7,8}}},
		[2]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=100,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{0,82},{1,4},{2,3},{3,2},{4,1},{7,8}}},
		[3]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=60,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{0,82},{1,4},{2,3},{3,2},{4,1},{7,8}}},
		[4]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=20,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{0,82},{1,4},{2,3},{3,2},{4,1},{7,8}}},
		[5]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=40,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{0,82},{1,4},{2,3},{3,2},{4,1},{7,8}}},
		[6]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=60,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{0,82},{1,4},{2,3},{3,2},{4,1},{7,8}}},
		[7]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=20,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[8]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=40,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[9]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=60,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[10]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=20,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[11]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=40,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[12]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=60,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[13]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=20,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[14]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=40,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[15]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=60,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[16]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=80,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[17]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=20,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[18]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=40,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[19]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=60,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
		[20]={costhp=5,costmp=5,mintime=60,role_level=1,role_type=1,costmoney=10,maxlevel=80,minlevel=1,class=1,baseexp=50,basescore=10,pickitem={{0,95},{348,2},{349,1},{350,1},{351,1}},dropcoin={{0,90},{32,4},{64,3},{320,2},{540,1}},gameitem={{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5}}},
	}

--角色身份等级功能匹配列表
local featureinfo={
	guest ={rolecreate=0, relationincrease=0,  chat=0,trade=0,specialitem=0,shop=0,sell=0,sharpen=0,refine=0,bekicked=1,kickout=0,ask=1,beask=1,addfriend=0,  blacklist=0,rankboard=0,onlinelist=0,playerinfo=1,bigspeeker=0,smallspeeker=0,specialitendity=0,task=0,perdayaward={}},
	player={rolecreate=3, relationincrease=100,chat=1,trade=6,specialitem=0,shop=1,sell=1,sharpen=1,refine=0,bekicked=1,kickout=0,ask=1,beask=1,addfriend=100,blacklist=1,rankboard=1,onlinelist=1,playerinfo=1,bigspeeker=1,smallspeeker=1,specialitendity=0,task=1,perdayaward={380,382}},
	admin   ={rolecreate=5, relationincrease=120,chat=0,trade=3,specialitem=1,shop=0.8,sell=1,sharpen=1,refine=0,bekicked=0,kickout=1,ask=1,beask=1,addfriend=200,blacklist=1,rankboard=1,onlinelist=1,playerinfo=1,bigspeeker=1,smallspeeker=1,specialitendity=1,task=1,perdayaward={381,383}},
	supadmin   ={rolecreate=5, relationincrease=120,chat=1,trade=3,specialitem=1,shop=0.2,sell=1,sharpen=1,refine=0,bekicked=0,kickout=1,ask=1,beask=1,addfriend=200,blacklist=1,rankboard=1,onlinelist=1,playerinfo=1,bigspeeker=1,smallspeeker=1,specialitendity=1,task=1,perdayaward={381,383}},
	
}

--角色身份与id对应信息
local idtoroletype={[90]="guest",[1]="player",[89]="admin",[88]="supadmin"}

--亲密度等级与加成数据信息
local relationinfo={
	[1] ={1,100,0.01},
	[2] ={101,400,0.05},
	[3] ={401,900,0.05},
	[4] ={901,1600,0.1},
	[5] ={1601,2500,0.1},
	[6] ={2501,3600,0.15},
	[7] ={3601,4900,0.15},
	[8] ={4901,6400,0.20},
	[9] ={6401,8100,0.25},
	[10]={8101,10000,0.30}
}

local getPercentByRelation=function(relation)

	if relation<relationinfo[1][2] then
		return relationinfo[1][3]
	elseif relation<relationinfo[2][2] then
		return relationinfo[2][3]
	elseif relation<relationinfo[3][2] then
		return relationinfo[3][3]
	elseif relation<relationinfo[4][2] then
		return relationinfo[4][3]
	elseif relation<relationinfo[5][2] then
		return relationinfo[5][3]
	elseif relation<relationinfo[6][2] then
		return relationinfo[6][3]
	elseif relation<relationinfo[7][2] then
		return relationinfo[7][3]
	elseif relation<relationinfo[8][2] then
		return relationinfo[8][3]
	elseif relation<relationinfo[9][2] then
		return relationinfo[9][3]
	else 
		return relationinfo[10][3]
	end
end

BIGCONFIG = {
	

----------------------------------------------------------------------------------------------------------------------------------------------
	--体力配置
	HP	=	{
		--消耗
		SUB = {
			--某款游戏会消耗体力——根据游戏收益的不同消耗不同的体力（一次性消耗或按游戏的时间消耗）
			GAME = {
				--PARAM gameid:游戏id
				--RETURN 两个值 1、类型（0：无限定 1： 为一次性消耗 2：按游戏的时间消耗） 2、消耗值
				go=function(gameid)
					local cls=gameinfo[gameid].class;
					local val=gameinfo[gameid].costhp;
					return cls,val;
				end
			},
			--强化会消耗体力——根据强化物品（或卷轴）的等级消耗不同的体力
			SHARPEN = {
				--配置函数
				--PARAM item_level:物品的等级
				--RETURN number 消耗的体力
				go = function(item_level)
					return math.modf(item_level*0.6)+5
				end
			}
		},
		--恢复		
		ADD	=	{
			--每小时恢复量
			TIMERETSTORE 		= {
				--value = 3600,
				value = 60,
			},
			--下线恢复
			OFFLINERESTORE 	= {
				value = 120,
			}
			--游戏中奖励另外配置
			--升级时，数值自动补满到升级后的最大值
		}	
	},

----------------------------------------------------------------------------------------------------------------------------------------------
	--技力配置
	MP	=	{
		--消耗
		SUB = {
			--某款游戏会消耗技力——根据游戏收益的不同消耗不同的技力（一次性消耗或按游戏时间消耗）
			GAME = {
				--PARAM gameid:游戏id
				--RETURN 两个值 1、类型（0：无限定 1： 为一次性消耗 2：按游戏的时间消耗） 2、消耗值
				go=function(gameid)
					local cls=gameinfo[gameid].class;
					local val=gameinfo[gameid].costmp;
					return cls,val;
				end	
	
			},
			-- 精炼会消耗技力——根据精炼物品（或卷轴）的等级消消耗不同的体力
			REFINE = {
				--配置函数
				go = function(item_level) 
					return math.modf(item_level*0.6)+5
				end
			}
		},
		--恢复
		ADD	=	{
			--每小时恢复量
			TIMERETSTORE 	= {
				value	=60,
			},
			--下线每小时恢复
			OFFLINERESTORE 	= {
				value = 120,
			}
			--游戏中奖励另外配置
			--升级时，数值自动补满到升级后的最大值
		}	
	},
----------------------------------------------------------------------------------------------------------------------------------------------
	--幸运配置
	LUCKY	=	{		
		SHARPENOKRATE = {
			--传入角色的lucky值，返回强化成功率
			go=function(lucky)
				return lucky/5*100;
			end
		},
		REFINEOKRATE = {
			--传入角色的lucky值，返回精炼成功率
			go=function(lucky)
				return lucky/5*100;
			end
		},
	},
----------------------------------------------------------------------------------------------------------------------------------------------
	--等级配置
	LEVEL = {
		HP = {
			--相应的等级，相应的体力
			--传入当前的角色等级
			--这里只返回对应等级应该增长的体力
			go = function(level)
				local val=(level-1)*10+100
				return val;
			end
		},
		MP = {
			--相应的等级，相应的技力
			--这里只返回对应等级应该增长的技力
			go = function(level)
				local val=(level-1)*10+100
				return val;
			end
		},
		--某些游戏是否可玩受等级限制
		GAME= {
			--PARAM gameid:游戏id role_level:玩家等级 role_type:账号级别
			--RETURN 1 可以 0 不可以
			go=function(gameid,role_level,role_type)
				if gameid == 1 or gameid == 4 or gameid == 7 or gameid == 13 then 
					--测试 大于以及不可以进入
					if role_level > 1 then 
						return 0;
					end
				end
				local rl=gameinfo[gameid].role_level;
				local rt=gameinfo[gameid].role_type;
				if role_level>=rl and role_type>=rt then
					return 1;
				else
					return 0;
				end
					
			end
		},
		--交易的等级需求
		TRADE = {
			--PARAM role_level:玩家等级 role_type:账号级别
			--RETURN 两个值 1、是否可交易 （0 不可交易 1可交易） 2、可交易等级
			go=function(role_level,role_type)
				local tmp=featureinfo[idtoroletype[role_type]].trade;
				local iscan=0;
				if tmp>0 then
					iscan=1
				end

				return iscan,tmp;
			end
		}		
	},
----------------------------------------------------------------------------------------------------------------------------------------------
	--金钱
	MONEY = {
		--增加
		ADD = {
			GAME ={
				--详见游戏配置表
			},
			--创建角色奖励金钱
			CREATEROLE={
				value = 500,
			},
		},
		SUB = {
			GAMEIN = {
				--进入的游戏，需要消耗金钱
				--PARAM gameid:游戏id
				--RETURN 消耗铜币值
				go=function(gameid)
					local tmp=gameinfo[gameid].costmoney;
					return tmp;
				end	
			},
			--玩家间的交易会消耗金钱（系统会收取交易的中间费用）
			TRADE = {
				--交易的金额
				--亲密度
				--返回收取的费用
				go=function(coin,relation)
					local tmp=coin*0.01;
					if relation>0 then
						local tmprel=getPercentByRelation(relation);
						local a,b=math.modf(tmp*(1-tmprel))
						if b>0 then
							tmp=a+1;
						end
					end
					local c,d=math.modf(tmp);
					if d>0 then
						tmp=c+1;
					end

					return tmp;
						

				end
			},
		},

		RELATION ={
			--根据亲密度，加成金钱
			--返回加成后的金钱
			go 	= 	function(money,relation)
				local tmp=money*(1+getPercentByRelation(relation));
				return tmp;
			end
		}
	},
----------------------------------------------------------------------------------------------------------------------------------------------
	--亲密度
	RELATION = {
		
		FRIENDINIT = {
			--加为好友初始值
			value = 5,
		},
		--私聊（每天一次）
		CHATDAYINIT = {
			value = 5,
		},		
	},
----------------------------------------------------------------------------------------------------------------------------------------------	
	--每日奖励
	PERDAYAWARD = {
		go = function(roletype)
			local tmp=featureinfo[idtoroletype[roletype]].perdayaward;
			
			return tmp;
		end
	},
----------------------------------------------------------------------------------------------------------------------------------------------	
	--经验值
	EXPERIENCE = {
		RELATION ={
			--根据亲密度，加成经验,exp:基础经验 relation 数组
			--返回加成后的经验
			go 	= function(exp,relation)
				local i=1;
				local rel=0;
				while relation[i] do
					rel=rel+getPercentByRelation(relation[i]);
					i=i+1;
				end
				local relPercent=rel/#relation;

				local tmp=exp*(1+relPercent);
				local a,b=math.modf(tmp);
				if b>0 then
					tmp=a+1;
				end
				return tmp;
			end
		}	
	},
----------------------------------------------------------------------------------------------------------------------------------------------	
	--功能等级需求
	CANDO = {
		--创建角色
		ROLECREATE = {
			--	roletype 角色类别 游客	普通玩家	Vip
			--	90为游客 1为普通玩家 89为GM 88 为超级GM
			--	返回 可以创建角色数量，0，表示不可以创建角色
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].rolecreate;
				return tmp;
			end
		},
		--亲密度每天增长上限
		RELATIONINCREASE = {
			--返回 0 表示不可以增长
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].relationincrease;
				return tmp;
			end
		},
		--商店购买
		SHOP={
			--返回两个值
			--第一个：是否可以购买物品 1，可以 0 ，不可以
			--购买折扣（0.8 表示8折）
			go	=	function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].shop;
				local iscan=0;
				if tmp>0 then
					iscan=1
				end

				return iscan,tmp
			end
		},
		SPECIALITEM = {
			--使用专属道具
			--1，可以使用 0 不可以使用
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].specialitem;
				return tmp;
			end
		},
		REFINE={
			--精炼
			--1，可以使用 0 不可以使用
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].refine;
				return tmp;
			end
		},
		SHARPEN={
			--强化
			--1，可以使用 0 不可以使用
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].sharpen;
				return tmp;
			end
		},
		SELL={
			--出售
			--1，可以使用 0 不可以使用
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].sell;
				return tmp;
			end
		},
		BEKICKED={
			--被踢
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].bekicked;
				return tmp;
			end
		},
		KICKOUT={
			--踢人
			--1，可以使用 0 不可以使用
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].kickout;
				return tmp;
			end
		},
		ASK={
			--邀请
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].ask;
				return tmp;
			end
		},
		BEASK={
			--被邀请
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].beask;
				return tmp;
			end
		},
		ADDFRIEND={
			--加好友
			--第一个参数：1，可以 0 不可以
			--第二个参数：好友上限
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].addfriend;
				local iscan=0;
				if tmp>0 then
					iscan=1;
				end
				return iscan,tmp;
			end
		},
		BLACKLIST={
			--加入黑名单
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].blacklist;
				return tmp;
			end
		},
		RANKBOARD={
			--参看排行榜
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].rankboard;
				return tmp;
			end
		},
		ONLINELIST={
			--参看在线列表
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].onlinelist;
				return tmp;
			end
		},
		PLAYERINFO={
			--参看玩家信息
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].playerinfo;
				return tmp;
			end
		},
		BIGSPEEKER={
			--是否可以使用大喇叭
			--RETURN：1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].bigspeeker;
				return tmp;
			end
		},
		SMALLSPEEKER={
			--是否可以使用小喇叭
			--RETURN：1，可以：1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].smallspeeker;
				return tmp;
			end
		},
		SPECIALITENDITY={
			--参看玩家专属标志
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].specialitendity;
				return tmp;
			end
		},
		TASK={
			--是否可以交接任务
			--1，可以 0 不可以
			go = function(roletype)
				local tmp=featureinfo[idtoroletype[roletype]].task;
				return tmp;
			end
		},
		PLAYGAME={
			--是否可以玩游戏
			--1,可  0不饿可以
			go=function(roletype,rolelevel,gameid)
				local tmpmax=gameinfo[gameid].maxlevel;
				local tmpmin=gameinfo[gameid].minlevel;
				if rolelevel<tmpmin or rolelevel>tmpmax then
					return 0;
				else
					return 1;
				end
			end
		}
	},
----------------------------------------------------------------------------------------------------------------------------------------------
	--扫雷游戏配置
	--备注：以下只列出了扫雷游戏的配置，其他游戏等方案成熟后拟定
	LANDMINE = {
		--经验配置
		EXP = {
			--基础经验
			base = {
				--PARAM gameid 游戏编号,playernum:参加游戏的玩家数量，groupnum:分组数量，secs：游戏持续的时间
				--RETURN 基础点数
				go	= function(gameid,playernum,groupnum,secs,role_level)
					local bexp=gameinfo[gameid].baseexp;
					local mintime=gameinfo[gameid].mintime;
					local mlevel=gameinfo[gameid].maxlevel;
					local baseExp=0;
					if secs>=mintime then
					
						baseExp=bexp*(1+playernum/100+groupnum/100-secs/10000+role_level/mlevel);
					end
					return baseExp;
				end
			},
			--名次奖励 
			rank ={
				--PARAM rank :名次
				--RETURN 名次奖励的经验
				go = function(gameid,playernum,groupnum,secs,rank,role_level)
					local bexp=gameinfo[gameid].baseexp;
					local mlevel=gameinfo[gameid].maxlevel;
					local mintime=gameinfo[gameid].mintime;
					local rankExp=0
					if secs>=mintime then
						rankExp=bexp*(1-rank/groupnum+playernum/100+groupnum/100-secs/10000+role_level/mlevel);
					end
					return rankExp;
				end
			},
			--使用道具
			item={
				--PARAM num：使用道具成功次数
				--RETURN 使用道具成功的经验
				go = function(gameid,num,role_level)
					local bexp=gameinfo[gameid].baseexp;
					local mlevel=gameinfo[gameid].maxlevel;
					local itemExp=bexp*(num/100+role_level/mlevel);
					return itemExp;
				end
			},
			--所在组挖雷个数，奖励经验
			GROUPDIGNUM = {
				--PARAM gnum:组挖雷数 dnum：玩家挖雷数
				go = function(gameid,gnum,dnum)
					--local bexp=gameinfo[gameid].baseexp;
					--local groupdignumExp=bexp*(dnum/gnum);
					local groupdignumExp=dnum;
					return groupdignumExp;
				end
			}
		},
		--积分配置
		SCORE = {
			--名次得分
			rank ={
				--PARAM rank :名次
				go = function(gameid,playernum,groupnum,secs,rank,role_level)
					local rscore=gameinfo[gameid].basescore;
					local mlevel=gameinfo[gameid].maxlevel;
					local rankScore=0;
					local mintime=gameinfo[gameid].mintime;
					if secs>=mintime then
						if rank<=(groupnum/2) then
							rankScore=rscore*(1+1-rank/groupnum+playernum/10+groupnum/10-secs/10000+role_level/mlevel);
						else
							rankScore=rscore*(-rank/groupnum-playernum/10-groupnum/10-secs/10000+role_level/mlevel);
						end
					end
					return rankScore;
				end
			},
			--逃跑扣分
			CUTOFF={
				--PARAM gameid:游戏id
				go = function(gameid)
					local cscore=gameinfo[gameid].basescore;
					return cscore;
				end
			},
			--被炸次数扣分
			BLOOD = {
				--PARAM gameid:游戏id bnum:被炸次数,
				go = function(gameid,bnum)
					local bscore=gameinfo[gameid].basescore;
					local bloodScore=bscore*bnum*0.25;
					return bloodScore;
				end
			},
			--所在组挖雷个数，奖励得分
			GROUPDIGNUM = {
				--PARAM gnum:组挖雷数 dnum：玩家挖雷数
				go = function(gameid,gnum,dnum)
					--local gscore=gameinfo[gameid].basescore;
					--local groupdignumScore=gscore*(dnum/gnum)*10;
					local groupdignumScore=dnum;
					return groupdignumScore;
				end
			}
		},
		--可拾取掉落物品配置
		--挖雷一次触发一次掉落机会
		PICKITEM  = {
			FREQUENT = {
				
					--第一个元素表示物品outputid（0，表示不掉落）
					--第二个元素表示此物品掉落的概率
					--比如outputid为348掉落的概率为 2/(95+2+1+1+1);
					--[[value = {
					{0,	95},
					{348,	2},
					{349,	1},
					{350,	1},
					{351,	1},
					}--]]
					go=function(gameid)
						local value=gameinfo[gameid].pickitem;
						return value;
					end
			}
		},
		--游戏中道具掉落配置
		GAMEITEM = {
			FREQUENT = {
				
					--第一个元素表示道具id（0，表示不掉落）
					--第二个元素表示此道具掉落的概率
					--[[
					{type = 1 ,game = 1,name = "小型地雷",describer="点击道具，放入地图中。踩中此雷的玩家会掉血。只能炸一个人。"};
					{type = 2 ,game = 1,name = "大型地雷",describer="点击道具，放入地图中。踩中此雷的玩家所在的组都会掉血。"};
					{type = 3 ,game = 1,name = "防雷面罩",describer="只能防御一个人"};
					{type = 4 ,game = 1,name = "防雷帐篷",describer="给同一组人加一次防御"};
					{type = 7 ,game = 1,name = "冰冻三尺",describer="冰冻一轮 冰冻三尺非一日之寒"};

					--比如小型地雷掉落的概率为 4/(82+4+3+2+1+8);
					value = {
					{0,82},{1,4},{2,3},{3,2},{4,1},{7,8},
					}
					--]]
					go=function(gameid)
						local value=gameinfo[gameid].gameitem;
						return value;
					end
					
			}
		},
		--游戏中掉落金币，挖到雷时会触发
		DROPCOIN = {
			FREQUENT={
				
					--第一个元素表示铜币个数
					--第二个元素表示此物品掉落的概率
					--比如32掉落的概率为 2/(50+20+15+10+5);
					--[[value = {{0,50},{32,20},{64,15},{320,10},{540,5},
					}
					--]]
					go=function(gameid)
						local value=gameinfo[gameid].dropcoin;
						return value;
					end
			}
		}
	},
----------------------------------------------------------------------------------------------------------------------------------------------
	--俄罗斯方块游戏配置
	TETRIS = {
		--经验配置
		EXP = {
			--基础经验
			base = {
				--PARAM gameid 游戏编号,playernum:参加游戏的玩家数量，groupnum:分组数量，secs：游戏持续的时间
				--RETURN 基础点数
				go	= function(gameid,playernum,groupnum,secs,role_level) 
					local bexp=gameinfo[gameid].baseexp;
					local mlevel=gameinfo[gameid].maxlevel;
					local mintime=gameinfo[gameid].mintime;
					local baseExp=0
					if secs>=mintime then
						baseExp=bexp*(1+playernum/100+groupnum/100-secs/10000+role_level/mlevel);
					end
					return baseExp;
				end
			},
			--名次奖励 
			rank ={
				--PARAM rank :名次
				go = function(gameid,playernum,groupnum,secs,rank,role_level)
					local bexp=gameinfo[gameid].baseexp;
					local mlevel=gameinfo[gameid].maxlevel;
					local mintime=gameinfo[gameid].mintime;
					local rankExp=0;
					if secs>=mintime then
						rankExp=bexp*(1-rank/groupnum+playernum/100+groupnum/100-secs/10000+role_level/mlevel);
					end
					return rankExp;
				end
			},
			--使用道具
			item={
				--PARAM num：使用道具成功次数
				go = function(gameid,num,role_level)
					local bexp=gameinfo[gameid].baseexp;
					local mlevel=gameinfo[gameid].maxlevel;
					local itemExp=bexp*(num/100+role_level/mlevel);
					return itemExp;
				end
			},
			--一次消多行
			clear = {
				--num为3，4
				go = function(gameid,num,role_level)
					local bexp=gameinfo[gameid].baseexp;
					local mlevel=gameinfo[gameid].maxlevel;
					local itemExp=bexp*(num/100+role_level/(mlevel*10));
					return itemExp;
				end
			}
		},
		--积分配置
		SCORE = {
			--名次得分
			rank ={
				--PARAM rank :名次
				go = function(gameid,playernum,groupnum,secs,rank,role_level)
					local rscore=gameinfo[gameid].basescore;
					local mlevel=gameinfo[gameid].maxlevel;
					local rankScore=0;
					local mintime=gameinfo[gameid].mintime;

					--if secs>=mintime then
					if rank<=(groupnum/2) then
						if secs>=mintime then
							rankScore=rscore*(1+1-rank/groupnum+playernum/10+groupnum/10-secs/10000+role_level/mlevel);
						end
					else
						rankScore=rscore*(-rank/groupnum-playernum/10-groupnum/10-secs/10000+role_level/mlevel);
					end
					return rankScore;
				end
			},
			--逃跑扣分
			CUTOFF={
				go = function(gameid)
					local cscore=gameinfo[gameid].basescore;
					return cscore;
				end
			},
			--消行数量奖励得分
			CLEARNUM = {
				--PARAM gnum:组挖雷数 dnum：玩家挖雷数
				go = function(gameid,num)
					local bscore=gameinfo[gameid].basescore;
					local clearScroe=bscore*(num/100);
					return clearScroe;
				end
			}
		},
		--可拾取掉落物品配置
		--消行三行以上
		PICKITEM  = {
			FREQUENT = {
				--第一个元素表示物品outputid（0，表示不掉落）
				--第二个元素表示此物品掉落的概率
				--[[比如outputid为348掉落的概率为 2/(95+2+1+1+1);
				{0,	95},
				{348,	2},
				{349,	1},
				{350,	1},
				{351,	1},
				--]]
				go=function(gameid)
					local value=gameinfo[gameid].pickitem;
					return value;
				end
				
			}
		},
		--游戏中掉落金币，消行时触发
		DROPCOIN = {
			FREQUENT = {
				
					--第一个元素表示铜币个数
					--第二个元素表示此物品掉落的概率
					--比如32掉落的概率为 2/(50+20+15+10+5);
					--[[value = {{0,50},{32,20},{64,15},{320,10},{540,5},
					--]]
					go=function(gameid)
						local value=gameinfo[gameid].dropcoin;
						return value;
					end
				
			}
		},
		--游戏中道具掉落配置
		--[[
			降速: 	"A"
			升速: 	"B"
			减3行: 	"C"
			减2行: 	"D"
			减1行: 	"E"
			增3行: 	"F"
			增2行: 	"G"
			增1行: 	"H"
			清屏:  	"I"
		--]]
		GAMEITEM = {
			FREQUENT ={
				--第一个元素代表道具类型 11对应降速 12对应升速 依次类推
				--[[value = {
						{11,12},{12,12},{13,8},{14,11},{15,19},{16,7},{17,9},{18,17},{19,5},
				--]]
				go=function(gameid)
					local value=gameinfo[gameid].gameitem;
					return value;
				end
			}
		}
	},
};
----------------------------------------------------------------------------------------------------------------------------------------------
--函数包装
