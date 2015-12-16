
package.loadlib("libluasql.so", "init")();
g_db_con = luasql.init("game");
luasql.open(g_db_con,"192.168.1.90",53306,"root","","flashaccount");
assert(luasql.errno(g_db_con) == 0);
local i = 10000 ;
while i < 12000 do
	local sql = 'INSERT INTO user_login (login_account,login_passwd,login_email,login_level,login_rolenum,login_rolemax,login_money) VALUES("'..i..'","af379e6b08ea7405f83ded8e296f0871","'..i..'@126.com",1,0,5,1000);'
	luasql.execute(g_db_con,sql);
	i = i + 1;
end
