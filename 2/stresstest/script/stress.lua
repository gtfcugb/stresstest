dofile("/sitedata/gs/flashserver/config/config.lua");
datacenter_init();

local indexid = 6;

local i = 0;
while i < 10000 do
	res = interface.get_roleinfo(indexid);
	print(res);
	utility.usleep(10);
	i = i + 1;
end