print("run client.lua ");
local g_sock_num;
function init(sock_num)
	g_sock_num = sock_num;
	local send_obj = {type = "clientinit",info ={}};
	send_obj.info.socknum 	= sock_num;
	server_input(json.encode(send_obj));
	client_send(guestinit_msg);
end

function input(msg)
	--print("input ",msg);
	local msg_json = json.decode(msg);
	local mark  = msg_json.mark;
	local type_ = msg_json.type;
	local info  = msg_json.info;
	--print(mark.."_"..type_);
	local do_fun = g_function_list[mark.."_"..type_];
	if do_fun ~= nil then
		do_fun(info);
	end
end
