--Compensate module for ULX GUI -- by Kl1nge5!
--Server Compensate System.

local email = xlib.makepanel{ parent=xgui.null }

-- 主页面
local email_tabs = xlib.makepropertysheet{ x=-5, y=6, w=600, h=368, parent=email, offloadparent=xgui.null }

-- 补偿列表
local receive = xlib.makepanel{ parent=xgui.null }
local mails_list = xlib.makelistview{ x=5, y=5, w=175, h=295, multiselect=true, parent=receive, headerheight=0 }
local show_text
local show_money_label
local show_money
local receive_button
local show_receive_tip
mails_list.OnRowSelected = function( self, LineID, Line )
	if show_text then show_text:Remove() end
	if show_money_label then show_money_label:Remove() end
	if show_money then show_money:Remove() end
	if receive_button then receive_button:Remove() end
	if show_receive_tip then show_receive_tip:Remove() end

	show_text = xlib.maketextbox{ x=185, y=5, w=385, h=200, text=kmail_email_list[LineID].text.."\n\n\n处理人: "..kmail_email_list[LineID].name, multiline=true, parent=receive }
	show_text:SetEditable(false)
	show_money_label = xlib.makelabel{ x=185, y=213, label="补偿金额：", parent=receive }
	show_money = xlib.maketextbox{ x=245, y=210, w=100, text=kmail_email_list[LineID].money.."$", parent=receive }
	show_money:SetEditable(false)
	local compansate_vaild = true
	for k, v in pairs(has_received_emails) do
		if kmail_email_list[LineID].rowid == v then
			compansate_vaild = false
			break
		end
	end
	if compansate_vaild then
		receive_button = xlib.makebutton{ x=350, y=210, w=100, label="领取补偿", parent=receive }
		show_receive_tip = xlib.makelabel{ x=460, y=213, label="*补偿可领取", textcolor={r=255, g=0, b=0, a=255}, parent=receive }
		receive_button.DoClick = function()
			receive_button:Remove()
			receive_button = xlib.makebutton{ x=350, y=210, w=100, label="已领取补偿", parent=receive }
			receive_button:SetEnabled(false)
			show_receive_tip:Remove()
			show_receive_tip = xlib.makelabel{ x=460, y=213, label="*补偿已领取", parent=receive }
			kmail_receive_compansate(kmail_email_list[LineID].rowid, kmail_email_list[LineID].money)
		end
	else
		receive_button = xlib.makebutton{ x=350, y=210, w=100, label="已领取补偿", parent=receive }
		receive_button:SetEnabled(false)
		show_receive_tip = xlib.makelabel{ x=460, y=213, label="*补偿已领取", parent=receive }
	end
end

local refresh_button = xlib.makebutton { x=5, y=305, w=175, label="刷新列表", parent=receive }
refresh_button.DoClick = function()
	kmail_load_all(mails_list)
end

mails_list:AddColumn("title")
kmail_load_all(mails_list)

xlib.makelabel{ x=475, y=311, label="Powered by Kl1nge5", parent=receive }

email_tabs:AddSheet( "补偿列表", receive, "icon16/layout_content.png", false, false, nil )

-- 发送补偿
local show_send_panel = false
if LocalPlayer():IsSuperAdmin() then
	show_send_panel = true
end
if show_send_panel then
	local send = xlib.makepanel{ parent=xgui.null }
	local send_title = xlib.maketextbox{ x=5, y=6, w=570, text="文本标题...", selectall=true, parent=send }
	local send_text = xlib.maketextbox{ x=5, y=31, w=570, h=250, text="文本正文...", selectall=true, multiline=true, parent=send }
	local send_money = xlib.maketextbox{ x=5, y=286, w=230, text="补偿金额...", selectall=true, parent=send }
	send_money.AllowInput = function(self, text)
		if text != "0" and text != "1" and text != "2" and text != "3" and text != "4" and text != "5" and text != "6" and text != "7" and text != "8" and text != "9" then
			return true
		end
	end
	local send_name = xlib.maketextbox{ x=240, y=286, w=230, text="署名...", selectall=true, parent=send }
	local send_button = xlib.makebutton{ x=475, y=286, w=100, label="发送", parent=send }
	send_button.DoClick = function()
		local title = send_title:GetValue()
		local text = send_text:GetValue()
		local money = send_money:GetInt()
		local name = send_name:GetValue()
		if not money then
			local send_tip = xlib.makepanel{x=190, y=100, h=100, w=200, parent=send }
			local send_tip_text = xlib.makelabel{ x=50, y=30, label="请输入正确的金额", parent=send_tip }
			local send_tip_button = xlib.makebutton{ x=50, y=50, w=100, label="确定", parent=send_tip }
			send_tip_button.DoClick = function()
				send_tip:Remove()
				send_tip_text:Remove()
				send_tip_button:Remove()
			end
			return
		end
		print("[INFO]补偿标题:"..title)
		print("[INFO]补偿正文:"..text)
		print("[INFO]补偿金额:"..money)
		print("[INFO]补偿署名:"..name)
		local send_tip = xlib.makepanel{x=140, y=100, h=100, w=300, parent=send }
		local send_tip_text = xlib.makelabel{ x=45, y=30, label="请再次核实补偿金额:"..money.."$ 发送后无法撤回", parent=send_tip }
		local send_tip_button = xlib.makebutton{ x=45, y=50, w=100, label="发送", parent=send_tip }
		local send_tip_button2 = xlib.makebutton{ x=155, y=50, w=100, label="取消", parent=send_tip }
		send_tip_button.DoClick = function()
			send_tip_text:Remove()
			send_tip_button:Remove()
			send_tip_button2:Remove()
			send_tip:Remove()
			kmail_send_compensate(title, text, money, name)
		end
		send_tip_button2.DoClick = function()
			send_tip_text:Remove()
			send_tip_button:Remove()
			send_tip_button2:Remove()
			send_tip:Remove()
		end
	end

	xlib.makelabel{ x=5, y=311, label="*发送前请核实补偿金额是否正确", parent=send }
	xlib.makelabel{ x=475, y=311, label="Powered by Kl1nge5", parent=send }
	email_tabs:AddSheet( "发送补偿", send, "icon16/layout_content.png", false, false, nil )
end

email_tabs:Hide()

-- 启动页面
local register_button = xlib.makebutton{ x=190, y=100, w=200, label="打开服务器补偿系统", parent=email }
local register_tip1 = xlib.makelabel{ x=170, y=125, label="服务器补偿系统是一个基于ulx和DarkRP的插件", parent=email}
local register_tip2 = xlib.makelabel{ x=190, y=145, label="其用于在服务器维护后进行全服性补偿", parent=email}

register_button.DoClick = function()
	kmail_register_query()
	register_button:Remove()
	register_tip1:Remove()
	register_tip2:Remove()
	email_tabs:Show()
	kmail_load_received_query()
end

xgui.addModule( "服务器补偿系统", email, "materials/email.png" )
