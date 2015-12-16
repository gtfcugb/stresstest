print("run client.lua ");

local g_sock_num = -1;

local g_last_heartbeattime 	= os.time();
function system_heartbeat(info)
	if os.time() - g_last_heartbeattime <= 1 then
		return;
	end
	g_last_heartbeattime = os.time();
	client_send(tostring(g_sock_num));
	print("sending",tostring(g_sock_num));
end

--协议处理函数列表
g_function_list = {
	system_heartbeat=	system_heartbeat,
};

function init(sock_num)
	g_sock_num 	= sock_num;
end

function input(msg)
	local msg_json = json.decode(msg);
	if msg_json == nil or type(msg_json) ~= "table" then 
		print("input ",msg);
		return ;
	end
	local mark  = msg_json.mark;
	local type_ = msg_json.type;
	local info  = msg_json.info;
	if mark == nil  or type_ == nil or info == nil then 
		return ;
	end
	local do_fun = g_function_list[mark.."_"..type_];
	if do_fun ~= nil then
		do_fun(info);
	end
end
