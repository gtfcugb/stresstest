print("run client.lua ");
local g_sock_num    =   0;
local run_times     =   0;
local begin_time    =   0;
local g_sn          =   0;

--{"mark":"account","type":"login","info":{"verify":"3232_dsds","_sn":1}}

local login_msg 	= '{"mark":"game","type":"login","info" :{ "type":1}}';

local heartbeat_msg = '{"mark":"master","type":"heart","info":{}}';

local g_state       = "ORIGIN";


local g_indexid     =   0;
local g_uid         =   0;
local g_chId        =   0;
local g_roomid      =   0;

--登录成功
function account_login(info)
	assert(info.res == 1);
    g_state    =  "LOGIN";

	g_indexid  = info.indexid;
    --{"mark":"room","type":"join","info":{"roomid":0,"roomtype":"bobing_test","_sn":3}}
	local send_obj = {mark = "room",type = "join",info ={roomid=0,roomtype="bobing_test2",_sn=g_sn+1}};
	client_send(json.encode(send_obj));
end
 
--聊天加入
--{"mark":"chat","type":"joinchannelN","info":{"chId":1000004,"channelInfo":{"ctime":1394508013,"base":"gameroom","uname":"root.room.1000002"},"sid":48}}
function chat_joinchannelN(info)
	if info.sid == g_indexid then
        g_chId      =   info.chId;
    end
end

--加入房间
--{"mark":"room","type":"join","info":{"roominfo":{"roomtype":"bobing_test"},"_sn":3,"roomid":1000002,"res":1,"members":[[1,48,"dsds",323232]]}}
function room_join(info)
	assert(info.res == 1);
    g_state     =   "ROOM";
    g_roomid    =   info.roomid;
    print(g_roomid);
end


--
--
local g_next_throw = 0;
function g_bobing_nextN(info)
    g_instid    = info.instid;
    if info.nextinfo.nextid == g_indexid then
        --投掷 随机秒数
        g_next_throw = os.time()+math.random(2,8);
    end
end

local g_last_heartbeat  = os.time();
function system_heartbeat(info)
    if os.time() - g_last_heartbeat > 20 then
        g_last_heartbeat = os.time();
        client_send(heartbeat_msg);
    end
    if g_next_throw < os.time() and g_next_throw ~= 0 then
        g_next_throw = 0;
        local send_obj = {mark = "g_bobing",type = "throw",info ={instid=g_instid,strength=1,_sn=g_sn+1}};
	    client_send(json.encode(send_obj));
    end
end


--协议处理函数列表
g_function_list = {
	account_login           =   account_login,
	chat_joinchannelN       =   chat_joinchannelN,
	room_join               =   room_join,
	system_heartbeat        =   system_heartbeat,
    g_bobing_nextN          =   g_bobing_nextN
};

function init(sock_num,pid)
	g_sock_num = sock_num;
	local send_obj = {type = "clientinit",info ={}};
	send_obj.info.socknum 	= sock_num;
	server_input(json.encode(send_obj));
    --{"mark":"account","type":"login","info":{"verify":"3232_dsds","_sn":1}}
	local send_obj = {mark = "account",type = "login",info ={verify=pid..sock_num.."_nick"..sock_num,_sn =g_sn+1}};
	client_send(json.encode(send_obj));
end

function input(msg)
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
