print("run client.lua ");


local g_sock_num;
local run_times = 0;

--协议处理函数列表
g_function_list = {
	
};

function init(sock_num)
	g_sock_num = sock_num;
	
	local send_obj = {type = "clientinit",info ={}};
	send_obj.info.socknum 	= sock_num;
	server_input(json.encode(send_obj));
	
	local send_obj = {type = "clientfinish",info ={}};	
	send_obj.info.socknum 	= g_sock_num;
	send_obj.info.times		 	= 1;
	send_obj.info.secs		 	= 0;
	server_input(json.encode(send_obj));
	return ;
end

function input(msg)
	local msg_json = json.decode(msg);
	local mark  = msg_json.mark;
	local type_ = msg_json.type;
	local info  = msg_json.info;
	local do_fun = g_function_list[mark.."_"..type_];
	if do_fun ~= nil then
		do_fun(info);
	end
end
