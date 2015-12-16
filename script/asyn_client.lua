print("run client.lua ");

local g_account ;
local g_roleid ;
local g_gameid;
local g_pwd = "0.569958602078259";
local g_password = "a2e37594188b9313d75eb4a2fb8ffa0f";

local g_sock_num = -1;
local run_times = 0;
local begin_time ;
local login_msg 	= '{"mark":"game","type":"login","info" :{ "type":1}}';
local logout_msg 	= '{"mark":"game","type":"logout","info" :{ }}';

local userinit_msg = '{"mark":"login","type":"userinit","info":{}}';
local worldinit_msg = '{"mark":"world","type":"worldinit","info":{"indexid":"10000005","authcode":"0mdH8OzkjozPX3ZteK7F"}}';
local roleuse_msg 	= '{"mark":"world","type":"roleuse","info":{"roleid":14}}';

local hallin_msg = '{"mark":"game","type":"hallin","info":{"gameid":1}}';
local hallout_msg = '{"mark":"game","type":"hallout","info":{"gameid":1}}';

local heartbeat_msg = '{"mark":"world","type":"heartbeat","info":{}}';


local g_state = "ORIGIN";
local indexid = -1;

function check_final()
	if run_times >= 100 then 
		local send_obj = {type = "clientfinish",info ={}};	
		send_obj.info.socknum 	= g_sock_num;
		send_obj.info.times		 	= 1;
		send_obj.info.secs		 	= os.time() - begin_time;
		server_input(json.encode(send_obj));
		return;
	end
	run_times = run_times + 1;
end

function get_user_account()
	local res = server
	local send_obj = {type = "getaccount",info ={}};	
	send_obj.info.socknum 	= g_sock_num;
	local res  = server_input(json.encode(send_obj));
	assert(res ~= nil);
	return res;
end

function get_game_id()
	local res = server
	local send_obj = {type 	= "getgameid",info ={}};	
	send_obj.info.socknum 	= g_sock_num;
	local res  = server_input(json.encode(send_obj));
	assert(res ~= nil);
	return tonumber(res);
end

function login_init(info)
	assert(g_state == "ORIGIN");
	assert(info.result == 0);
	begin_time = os.time();
	g_state    = "ACCOUNTINIT";
	indexid    = info.indexid;
	client_sock_invert();
	local send_obj = {mark = "world",type = "worldinit",info ={}};
	send_obj.info.indexid 	= info.indexid;
	send_obj.info.authcode 	= info.authcode;
	client_send(json.encode(send_obj));
end

function world_worldinit(info)
	assert(g_state == "ACCOUNTINIT");
	assert(info.result == 0);
	g_state    = "WORLDINIT";
	--[[
	local send_obj = '{"mark":"world","type":"rolenew","info":{"show":{"data":{"tz":"t1.swf"},"class":"BitmapPeople"},"gender":"1","nickname":"10000"}} '
	send_obj = json.decode(send_obj);
	send_obj.info.nickname = "name"..g_account;
	client_send(json.encode(send_obj));
	--]]
	client_send('{"mark":"world","type":"rolelist","info":{}}');
	--client_send(roleuse_msg);
end

function world_rolelist(info)
	assert(g_state == "WORLDINIT");
	assert(info.result == 0);
	g_state    = "WORLDINIT";
	g_roleid = info.list[1].roleid;
	local send_obj = json.decode(roleuse_msg);
	send_obj.info.roleid = g_roleid;
	client_send(json.encode(send_obj));
end

function world_roleuse(info)
	assert(g_state == "WORLDINIT");
	assert(info.result == 0);
	g_state    = "ROLEUSE";
	indexid = info.indexid;
	client_send(login_msg);
end

function game_login(info)
	assert(g_state == "ROLEUSE");
	assert(info.res == 1);
	g_state    = "GAMELOGIN";
end

function game_hallin(info)
	check_final();
	if info.res == 1 then
		g_state    = "GAMEHALLIN";
	else
		g_state    = "GAMEHALLIN";
	end
end

function game_hallout(info)
	if info.res == 1 then
		g_state    = "GAMELOGIN";
	else
		g_state    = "GAMELOGIN";
	end
end

local g_last_heartbeattime 	= os.time();
local g_last_hall_time 			= os.time();
local g_last_operate_time		=	os.time();
function system_heartbeat(info)
	if os.time() - g_last_heartbeattime > 15 then
		g_last_heartbeattime = os.time();
		client_send(heartbeat_msg);
	end
	if os.time() - g_last_operate_time > 1 then
		if g_state == "GAMELOGIN" then
			local send_obj = {mark = "game",type = "hallin",info ={}};
			send_obj.info.gameid 		= g_gameid;
			client_send(json.encode(send_obj));
		end
		if g_state == "GAMEHALLIN" then
			local send_obj = {mark = "game",type = "hallout",info ={}};
			send_obj.info.gameid 		= g_gameid;
			client_send(json.encode(send_obj));
		end
		g_last_operate_time = os.time();
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
};

function init(sock_num)
	g_sock_num = sock_num;
	g_account = get_user_account();
	g_gameid  = get_game_id();
	local send_obj = {type = "clientinit",info ={}};
	send_obj.info.socknum 	= sock_num;
	server_input(json.encode(send_obj));
	
	local send_obj = {mark = "login",type = "userinit",info ={}};
	send_obj.info.password 	= g_password;
	send_obj.info.account 	= g_account;
	send_obj.info.pwd 			= g_pwd;
	client_send(json.encode(send_obj));
end

function input(msg)
--	print("input ",msg);
	local msg_json = json.decode(msg);
	--assert(msg_json ~= nil);
	if msg_json == nil then 
		return ;
	end
	local mark  = msg_json.mark;
	local type_ = msg_json.type;
	local info  = msg_json.info;
	--print(mark.."_"..type_);
	local do_fun = g_function_list[mark.."_"..type_];
	if do_fun ~= nil then
		do_fun(info);
	end
end
