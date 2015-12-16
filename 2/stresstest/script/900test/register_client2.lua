--模拟用户登录 并进入小厅
print("run client.lua ",print);

local g_account ;
local g_roleid ;
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

local hallin_msg = '{"mark":"game","type":"hallin","info":{"gameid":6}}';
local hallout_msg = '{"mark":"game","type":"hallout","info":{"gameid":6}}';

local heartbeat_msg = '{"mark":"world","type":"heartbeat","info":{}}';


local g_state = "ORIGIN";
local indexid = -1;


local g_rolelist_info = "xxx";
local g_roleuse_info = "xxx";
local g_login_info = "xxx";
local g_worldinit_info = "xxx";
local g_hallin_info = "xxx";


function get_user_account()
	local res = server
	local send_obj = {type = "getaccount",info ={}};	
	send_obj.info.socknum 	= g_sock_num;
	local res  = server_input(json.encode(send_obj));
	assert(res ~= nil);
	return res;
end

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
	client_send(json.encode(send_obj));
end

function world_worldinit(info)
	g_worldinit_info =  json.encode(info);
	assert(g_state == "ACCOUNTINIT");
	assert(info.result == 0);
	g_state    = "WORLDINIT";
	
	--[[
	local send_obj = '{"mark":"world","type":"rolenew","info":{"show":{"data":{"tz":"t1.swf"},"class":"BitmapPeople"},"gender":"1","nickname":"10000"}} '
	send_obj = json.decode(send_obj);
	send_obj.info.nickname = "name"..g_account;
	client_send(json.encode(send_obj));
	print("new role ");
	--]]
	client_send('{"mark":"world","type":"rolelist","info":{}}');
end

function world_rolelist(info)
	g_rolelist_info = json.encode(info);
	assert(g_state == "WORLDINIT");
	assert(info.result == 0);
	g_state    = "WORLDINIT";
	g_roleid = info.list[1].roleid;
	local send_obj = json.decode(roleuse_msg);
	send_obj.info.roleid = g_roleid;
	g_roleuse_info = json.encode(send_obj);
	client_send(json.encode(send_obj));
end

function world_roleuse(info)
	assert(g_state == "WORLDINIT");
	assert(info.result == 0,tostring(g_roleid).." , "..tostring(g_account).." , "..g_login_info.." , "..g_worldinit_info.." , "..g_rolelist_info.." , "..g_roleuse_info);
	g_state    = "ROLEUSE";
	indexid = info.indexid;
	client_send(login_msg);
end

function game_login(info)
	assert(g_state == "ROLEUSE");
	assert(info.res == 1);
	g_state    = "GAMELOGIN";
	client_send(hallin_msg);
end

function game_logout(info)
	assert(g_state == "GAMELOGIN");
	assert(info.res == 1);
	g_state    = "ROLEUSE";
	client_send(hallin_msg);	
end

function game_hallin(info)
	g_hallin_info = json.encode(info);
	if run_times >= 1 then 
		local send_obj = {type = "clientfinish",info ={}};	
		send_obj.info.socknum 	= g_sock_num;
		send_obj.info.times		 	= 1;
		send_obj.info.secs		 	= os.time() - begin_time;
		server_input(json.encode(send_obj));
		return ;
	end;
	assert(g_state == "GAMELOGIN");
	assert(info.res == 1);
	g_state    = "GAMEHALLIN";
	client_send(hallout_msg);
	run_times = run_times + 1;
end

function game_hallout(info)
	assert(g_state == "GAMEHALLIN");
	assert(info.res == 1,g_hallin_info.."id "..tostring(indexid).."run_times "..run_times);
	g_state    = "GAMELOGIN";
	client_send(hallin_msg);	
end

local g_last_heartbeattime = os.time();
function system_heartbeat(info)
	if os.time() - g_last_heartbeattime > 15 then
		g_last_heartbeattime = os.time();
		client_send(heartbeat_msg);
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
	--print("input ",msg);
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
