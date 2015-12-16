--模拟用户登录 并进入小厅
print("run client.lua ");
function tmp_client_send(msg)
--	print("send :",msg);
	client_send(msg);
end
local g_account ;
local g_roleid ;
local g_pwd 			= "0.569958602078259";
local g_password 	= "a2e37594188b9313d75eb4a2fb8ffa0f";

local g_work_state = 0;

local g_roomid_begin ;
local g_gameid ;

local g_sock_num = -1;
local run_times = 0;
local begin_time ;
local login_msg 	= '{"mark":"game","type":"login","info" :{ "type":1}}';
local logout_msg 	= '{"mark":"game","type":"logout","info" :{ }}';

local userinit_msg 	= '{"mark":"login","type":"userinit","info":{}}';
local worldinit_msg = '{"mark":"world","type":"worldinit","info":{"indexid":"10000005","authcode":"0mdH8OzkjozPX3ZteK7F"}}';
local roleuse_msg 	= '{"mark":"world","type":"roleuse","info":{"roleid":14}}';

local heartbeat_msg = '{"mark":"world","type":"heartbeat","info":{}}';


local g_state = "ORIGIN";
local indexid = -1;


local g_rolelist_info = "xxx";
local g_roleuse_info = "xxx";
local g_login_info = "xxx";
local g_worldinit_info = "xxx";
local g_hallin_info = "xxx";
--本客户端需要扮演的工作
local g_work;

local g_roomindex;
local g_pos;
function get_user_account()
	local send_obj = {type = "getaccount",info ={}};	
	send_obj.info.socknum 	= g_sock_num;
	local res  = server_input(json.encode(send_obj));
	assert(res ~= nil);
	return res;
end

--获取角色的工作
function get_client_work()
	local send_obj = {type = "getwork",info ={}};	
	local res = server_input(json.encode(send_obj));
	assert(res ~= nil)
	print(res);
	local result_json = json.decode(res);
	return result_json.work,result_json.roomindex,result_json.roomid_begin,result_json.gameid;
end

--账号登录
function login_init(info)
	g_login_info = json.encode(info);
	assert(g_state == "ORIGIN");
	assert(info.result == 0);
	begin_time = os.time();
	g_state    = "ACCOUNTINIT";
	indexid    = info.indexid;
	client_sock_invert();
	local send_obj = {mark = "world",type = "worldinit",info ={}};
	send_obj.info.indexid 	= info.indexid;
	send_obj.info.authcode 	= info.authcode;
	tmp_client_send(json.encode(send_obj));
end

--世界初始化
function world_worldinit(info)
	g_worldinit_info =  json.encode(info);
	assert(g_state == "ACCOUNTINIT");
	assert(info.result == 0);
	g_state    = "WORLDINIT";
	tmp_client_send('{"mark":"world","type":"rolelist","info":{}}');
end

--获取角色列表反馈，并使用角色
function world_rolelist(info)
	g_rolelist_info = json.encode(info);
	assert(g_state == "WORLDINIT");
	assert(info.result == 0);
	g_state    = "WORLDINIT";
	g_roleid = info.list[1].roleid;
	local send_obj = json.decode(roleuse_msg);
	send_obj.info.roleid = g_roleid;
	g_roleuse_info = json.encode(send_obj);
	tmp_client_send(json.encode(send_obj));
end

--使用角色反馈，并登录游戏大厅
function world_roleuse(info)
	assert(g_state == "WORLDINIT");
	assert(info.result == 0,tostring(g_roleid).." , "..tostring(g_account).." , "..g_login_info.." , "..g_worldinit_info.." , "..g_rolelist_info.." , "..g_roleuse_info);
	g_state    = "ROLEUSE";
	indexid = info.indexid;
	tmp_client_send(login_msg);
end

-------------------------------------------------------------------------------------------
function game_login(info)
	assert(g_state == "ROLEUSE");
	assert(info.res == 1);
	g_state    = "GAMELOGIN";
	local hallin_msg 		= '{"mark":"game","type":"hallin","info":{"gameid":'..g_gameid..'}}';
	tmp_client_send(hallin_msg);
end

function game_logout(info)
	assert(g_state == "GAMELOGIN");
	assert(info.res == 1);
	g_state    = "ROLEUSE";
	local hallin_msg 		= '{"mark":"game","type":"hallin","info":{"gameid":'..g_gameid..'}}';
	tmp_client_send(hallin_msg);	
end

function game_hallin(info)
	g_hallin_info = json.encode(info);
	if info.res ~= 1 then g_state    = "GAMEHALLIN"; return ;end;
	g_state    = "GAMEHALLIN";
	if g_work_state == 1 then
		--如果出于工作状态就退出
		return ;
	end
	if g_work == 1 then
		g_work_state = 1;
	elseif g_work == 2 then
		local sendobj = {};
		sendobj.mark = "game";
		sendobj.type = "roomjoin";
		sendobj.info = {};
		sendobj.info.pswd = "";
		sendobj.info.pos = 0;
		sendobj.info.gameid = g_gameid;
		sendobj.info.roomid = g_roomid_begin + g_roomindex;
		tmp_client_send(json.encode(sendobj));
	else 
		local sendobj = {};
		sendobj.mark = "game";
		sendobj.type = "roomjoin";
		sendobj.info = {};
		sendobj.info.pswd = "";
		sendobj.info.pos = -1;
		sendobj.info.gameid = g_gameid;
		sendobj.info.roomid = g_roomid_begin + g_roomindex;
		--print("xxxxxxxxxxxxxxxxxxxx ",json.encode(sendobj));
		tmp_client_send(json.encode(sendobj));
	end
end

function game_roomjoin(info)
	--print(json.encode(info));
	if g_work_state == 1 then
		--如果出于工作状态就退出
		if info.res == 1 then 
			g_state = "ROOMJOININ";
		end
		return ;
	end
	if info.res ~= 1 then 
		--进入失败就以游客身份进入
		local sendobj = {};
		sendobj.mark = "game";
		sendobj.type = "roomjoin";
		sendobj.info = {};
		sendobj.info.pswd = "";
		sendobj.info.pos = 0;
		sendobj.info.gameid = g_gameid;
		sendobj.info.roomid = g_roomid_begin + g_roomindex;
		tmp_client_send(json.encode(sendobj));
		return ;
	end
	if g_work == 2 then 
		--进入工作状态
		g_state = "ROOMJOININ";
		g_work_state = 1;
		return ;
	end
	if info.res == 1 and info.pos == 0 then
		--禁止不动
		return 
	end;
	if info.res == 1 and info.pos > 0 then
		--进入换组状态
		g_pos					= info.pos;
		g_state				= "ROOMCHANGEGROUPA";
		g_work_state	= 1;
	end
end

function game_roomleave(info)
	if g_work_state == 1 then
		--如果出于工作状态就退出
		if info.res == 1 then 
			g_state = "ROOMJOINOUT";
		end
		return ;
	end
end

function game_roomstate(info)
	if g_work_state == 1 then
		--如果出于工作状态就退出
		if info.res == 1 and info.pos ~= nil then
			if info.pos%10 == 1 then
				g_state = "ROOMCHANGEGROUPA";
			elseif info.pos%10 == 2 then
				g_state = "ROOMCHANGEGROUPB";
			end
		end
		return ;
	end
end

function game_hallout(info)
	if info.res ~= 1 then g_state    = "GAMEHALLIN" return end;
	g_state    = "GAMELOGIN";
end

--local hallout_msg = '{"mark":"game","type":"hallout","info":{"gameid":1}}';
function hallout_go()
	local sendobj = {};
	sendobj.mark = "game";
	sendobj.type = "hallout";
	sendobj.info = {};
	sendobj.info.gameid = g_gameid;
	tmp_client_send(json.encode(sendobj));
end

--local hallin_msg = '{"mark":"game","type":"hallin","info":{"gameid":1}}';
function hallin_go()
	local sendobj = {};
	sendobj.mark = "game";
	sendobj.type = "hallin";
	sendobj.info = {};
	sendobj.info.gameid = g_gameid;
	tmp_client_send(json.encode(sendobj));
end

--{"mark":"game","type": "roomleave" , "info" :{"gameid":1,"roomid":1 }}
function leave_go()
	local sendobj = {};
	sendobj.mark = "game";
	sendobj.type = "roomleave";
	sendobj.info = {};
	sendobj.info.gameid = g_gameid;
	sendobj.info.roomid = g_roomid_begin + g_roomindex;
	tmp_client_send(json.encode(sendobj));
end

function join_go()
	local sendobj = {};
	sendobj.mark = "game";
	sendobj.type = "roomjoin";
	sendobj.info = {};
	sendobj.info.pswd = "";
	sendobj.info.pos = 0;
	sendobj.info.gameid = g_gameid;
	sendobj.info.roomid = g_roomid_begin + g_roomindex;
	tmp_client_send(json.encode(sendobj));
end

-- {"mark":"game","type":"roomstate","info":{"pos":62,"roomid":5065,"flag":3,"gameid":"5"}}
function groupa_go()
	local sendobj = {};
	sendobj.mark = "game";
	sendobj.type = "roomstate";
	sendobj.info = {};
	sendobj.info.flag = 3;
	local pos_pre = math.modf(g_pos/10);
	sendobj.info.pos = pos_pre*10 + 1;
	sendobj.info.gameid = g_gameid;
	sendobj.info.roomid = g_roomid_begin + g_roomindex;
	tmp_client_send(json.encode(sendobj));
end

function groupb_go()
	local sendobj = {};
	sendobj.mark = "game";
	sendobj.type = "roomstate";
	sendobj.info = {};
	sendobj.info.flag = 3;
	local pos_pre = math.modf(g_pos/10);
	sendobj.info.pos = pos_pre*10 + 2;
	sendobj.info.gameid = g_gameid;
	sendobj.info.roomid = g_roomid_begin + g_roomindex;
	tmp_client_send(json.encode(sendobj));
end

--------
--物品处理
--{"mark":"item","type":"iteminfo","info":{"itemid":"100"}}
function getiteminfo()
	local sendobj = {};
	sendobj.mark = "item";
	sendobj.type = "iteminfo";
	sendobj.info = {};
	--物品从12310开始
	--g_account cong 10000开始
	sendobj.info.itemid = g_account + 2310;
	tmp_client_send(json.encode(sendobj));
end

local g_last_iteminfo_time	=	os.time();
local g_last_heartbeattime 	= os.time();
function system_heartbeat(info)
	if os.time() -g_last_iteminfo_time >= 30 then
		g_last_iteminfo_time = os.time();
		--getiteminfo();
		local heartmsg = {mark = "system",type = "heartbeat",info = {}};
		tmp_client_send(json.encode(heartmsg));
	end
	if os.time() - g_last_heartbeattime <= 2 then
		return;
	end
	g_last_heartbeattime = os.time();
	--等待客户端就位后，才能进入工作状态
	if g_work_state ~= 1 then 
		return ;
	end
	if g_work == 1 then
		if g_state == "GAMEHALLIN" then
				hallout_go();
		elseif g_state == "GAMELOGIN" then
				hallin_go();
		end
	elseif g_work == 2 then
			if g_state == "ROOMJOININ" then
				leave_go()
			elseif g_state == "ROOMJOINOUT" then
				join_go()
			end
	elseif g_work == 3 then
		if g_state == "ROOMCHANGEGROUPA" then
			groupb_go();
		elseif g_state == "ROOMCHANGEGROUPB" then
			groupa_go();
		end
	end
end



--协议处理函数列表
g_function_list = {
	system_heartbeat=	system_heartbeat,
	login_init 			= login_init,
	world_worldinit = world_worldinit,
	world_rolelist	=	world_rolelist,
	world_roleuse		=	world_roleuse,
	game_login			=	game_login,
	game_logout			=	game_logout,
	game_hallin			=	game_hallin,
	game_hallout		=	game_hallout,
	game_roomjoin		= game_roomjoin,
	game_roomleave	= game_roomleave,
	game_roomstate	= game_roomstate,
};

function init(sock_num)
	g_sock_num 	= sock_num;
	g_account 	= get_user_account();
	g_work ,g_roomindex ,g_roomid_begin,g_gameid = get_client_work();
	local send_obj = {type = "clientinit",info ={}};
	send_obj.info.socknum 	= sock_num;
	server_input(json.encode(send_obj));
	
	local send_obj = {mark = "login",type = "userinit",info ={}};
	send_obj.info.password 	= g_password;
	send_obj.info.account 	= g_account;
	send_obj.info.pwd 			= g_pwd;
	tmp_client_send(json.encode(send_obj));
end

function input(msg)
--	print("input ",msg);
	local msg_json = json.decode(msg);
	--assert(msg_json ~= nil);
	if msg_json == nil or type(msg_json) ~= "table" then 
		return ;
	end
	local mark  = msg_json.mark;
	local type_ = msg_json.type;
	local info  = msg_json.info;
	if mark == nil  or type_ == nil or info == nil then 
		return ;
	end
	--print(mark.."_"..type_);
	local do_fun = g_function_list[mark.."_"..type_];
	if do_fun ~= nil then
		do_fun(info);
	end
end
