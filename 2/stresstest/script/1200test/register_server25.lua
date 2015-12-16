local g_index = 14800;
local g_roomid_begin 	= 6201;
local g_gameid 				= 25;


local g_server_point;
local init_client 	=	{};
local finish_client =	{};
local g_client_num = 0;



function clientinit(info)
	table.insert(init_client,info.socknum);
	if table.maxn(init_client) == client_num then
		print("all clients ("..g_client_num..") init ok ");
	end
end

function clientfinish(info) 
	table.insert(finish_client,info);
	print("client : "..info.socknum..",finish work run : "..info.times.." ,cost "..info.secs.." secs");
	print("server finished "..((table.maxn(finish_client)/g_client_num)*100).."% " );
	if table.maxn(finish_client) == g_client_num then
		print("\n");
		print("all clients finished");
		local times_all = 0;
		local secs_all  = 0;		
		for i,v in pairs(finish_client) do
			times_all = times_all + v.times;
			secs_all 	= secs_all 	+ v.secs;
		end
		print("total times :"..times_all);
		print("total secs :"..secs_all);
		server_finish(g_server_point);
	end
end

local g_client_account ={};
function getaccount(info)
	local res = g_index;
	g_index = g_index + 1;
	g_client_account[res] = info.socknum;
	return tostring(res);
end

local g_roomindex 				= 0;
local work_login					= 1;
local work_login_count 		= 0;
local work_roomjoin 			= 2;
local work_roomjoin_count = 0;
local work_changegroup 		= 3;
function get_work()
	--25个选手进出小厅
	if work_login_count <= 25 then
		work_login_count = work_login_count + 1;
		return work_login,-1;
	end
	--25个选手进出房间
	if work_roomjoin_count <= 25 then
		work_roomjoin_count = work_roomjoin_count + 1;
		g_roomindex = g_roomindex + 1;
		if g_roomindex == 50 then
			g_roomindex = 0;
		end
		return work_roomjoin,g_roomindex;
	end
	--其余选手改变分组
	g_roomindex = g_roomindex + 1;
	if g_roomindex == 50 then
		g_roomindex = 0;
	end
	return work_changegroup,g_roomindex;
end

function getwork()
	local work;
	local index;
	work ,index = get_work();
	local result ={};
	result.work = work;
	result.roomindex = index;
	result.roomid_begin = g_roomid_begin;
	result.gameid				= g_gameid;
	return json.encode(result);
end

g_function_list = {
	clientinit = clientinit,
	clientfinish = clientfinish,
	getaccount = getaccount,
	getwork		=	getwork;
};

function init(client_num,port,ip,server_point)
	g_client_num 		= client_num;
	g_server_point 	= server_point;
	print("server port :",port);
	print("server ip :",ip);
	print("server client_num :",g_client_num);
	print("LUA server init ok");	
end

function input(msg)
	local msg_json = json.decode(msg);
	local type_ = msg_json.type;
	local info  = msg_json.info;
	local do_fun = g_function_list[type_];
	if do_fun ~= nil then
		return do_fun(info);
	end
	return nil;
end
