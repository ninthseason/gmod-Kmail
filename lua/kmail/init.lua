print("Loading sv_init...")

util.AddNetworkString("KmailQuery")
util.AddNetworkString("KmailQueryRes")

if not sql.TableExists("kmail_emails") then
	print("[INFO] 初始化邮件数据库邮件表")
	sql.Query("create table kmail_emails(title varchar(50), text varchar(1000), money int, name varchar(50))")
end

if not sql.TableExists("kmail_players") then
	print("[INFO] 初始化邮件数据库玩家表")
	sql.Query("create table kmail_players(id varchar(100) not null, record varchar(10000))")
end


include("kmail/sv_query.lua")
