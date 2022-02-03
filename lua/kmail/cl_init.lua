print("Loading cl_init...")

kmail_email_list = {}
has_received_emails = {}

net.Receive("KmailQueryRes", function()
		local cmd = net.ReadString()
		if cmd == "email_query" then
			kmail_email_list = net.ReadTable()
		elseif cmd == "player_query" then
			local buffer = net.ReadTable()[1].record
			has_received_emails = string.Split(buffer, ",")
		end
	end)

function kmail_load_all_query()
	net.Start("KmailQuery")
	local query = "select rowid, * from kmail_emails"
	net.WriteString("email_query")
	net.WriteString(query)
	net.SendToServer()
end

function kmail_load_received_query()
	net.Start("KmailQuery")
	local query = "select record from kmail_players where id=\""..LocalPlayer():SteamID().."\""
	net.WriteString("player_query")
	net.WriteString(query)
	net.SendToServer()
end

function kmail_register_query()
	net.Start("KmailQuery")
	local query = "insert into kmail_players(id, record) select \""..LocalPlayer():SteamID().."\",\"-1\" where not exists(select * from kmail_players where id=\""..LocalPlayer():SteamID().."\")"
	net.WriteString("register")
	net.WriteString(query)
	net.SendToServer()
end

function kmail_send_compensate(title, text, money, name)
	local query = "insert into kmail_emails values(\""..title.."\",\""..text.."\","..money..",\""..name.."\")"
	net.Start("KmailQuery")
	net.WriteString("send_compensate")
	net.WriteString(query)
	net.SendToServer()
	kmail_load_all_query()
end
	
function kmail_receive_compansate(id, amount)
	table.insert(has_received_emails, id)
	local query = "update kmail_players set record=\""..table.concat(has_received_emails, ",").."\" where id=\""..LocalPlayer():SteamID().."\""
	net.Start("KmailQuery")
	net.WriteString("receive_compensate:"..id..":"..amount)
	net.WriteString(query)
	net.SendToServer()
	kmail_load_received_query()
end

function kmail_load_all(pnl)
	pnl:Clear()
	kmail_load_all_query()
	for k, v in pairs(kmail_email_list) do
		pnl:AddLine(v.title)
	end
end
