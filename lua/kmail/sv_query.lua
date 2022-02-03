net.Receive("KmailQuery", function(len, ply)
	local cmd = net.ReadString()
	local query = net.ReadString()

	-- 处理领取补偿操作
	local _cmd = string.Split(cmd, ":")
	if _cmd[1] == "receive_compensate" then
		local query = "select record from kmail_players where id=\""..ply:SteamID().."\""
		local res = string.Split(sql.Query(query)[1].record, ",")
		local compansate_vaild = true
		for k, v in pairs(res) do
			if _cmd[2] == v then
				compansate_vaild = false
				break
			end
		end
		if compansate_vaild then
			ply:addMoney(tonumber(_cmd[3]))
		end
	end

	-- 处理其他操作
	print("[INFO]执行数据库查询指令: "..query)
	local res = sql.Query(query)
	if res == nil then
		print("[INFO]查询完成，无返回值，查询类型:"..cmd)
	elseif res then
		print("[INFO]查询完成，有返回值，查询类型:"..cmd)
		net.Start("KmailQueryRes")
		net.WriteString(cmd)
		net.WriteTable(res)
		net.Send(ply)
	else
		print("[ERROR]查询出错")
	end

end)
