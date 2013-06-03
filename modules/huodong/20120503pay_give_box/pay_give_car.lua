-------------------------------------------------------
-- �ļ�������pay_give_car.lua
-- �����ߡ���lgy
-- ����ʱ�䣺2013-03-08 18��00��00
-- �ļ���������ֵ��Կ�׵Ļ
-------------------------------------------------------


TraceError("init pay_give_car...")
--if pay_give_car and pay_give_car.on_user_exit then
--    eventmgr:removeEventListener("on_user_exit", pay_give_car.on_user_exit)
--end


--if pay_give_car and pay_give_car.on_after_user_login then
--	eventmgr:removeEventListener("h2_on_user_login", pay_give_car.on_after_user_login);
--end

--if pay_give_car and pay_give_car.restart_server then
--	eventmgr:removeEventListener("on_server_start", pay_give_car.restart_server);
--end

if pay_give_car and pay_give_car.bag_open_box_event then
	eventmgr:removeEventListener("bag_open_box_event", pay_give_car.bag_open_box_event);
end


--��¼�¼�
function pay_give_car.on_after_user_login(e)
	local user_info = e.data.userinfo;
	if user_info == nil then return end
	local user_id = user_info.userId
	
  if pay_give_car.user_list[user_id] == nil then
    pay_give_car.user_list[user_id] = {}
  end
  
end


--��Чʱ�䷵��1
function pay_give_car.check_time()
	local current_time = os.time()
	if current_time < timelib.db_to_lua_time(pay_give_car.CFG_START_TIME)
		or current_time > timelib.db_to_lua_time(pay_give_car.CFG_END_TIME) then
		return -1
	end
	return 1
end

function pay_give_car.on_user_exit(e)
    if e.data ~= nil and pay_give_car.user_list[e.data.user_id] ~= nil then
        pay_give_car.user_list[e.data.user_id] = nil
    end
end


function pay_give_car.restart_server(e)
  local sql  = "SELECT * FROM already_get_carnum_inkey"
	sql = string.format(sql)
	dblib.execute(sql, function(dt) 
		if dt and #dt > 0 then
			 pay_give_car.already_get_car =
        {
          [200016]={
            [5013] = {dt[1].car_getnum1,key=1}, --����*2
            [5018] = {dt[1].car_getnum2,key=2}, --ѩ����
            [5012] = {dt[1].car_getnum3,key=3}, --�׿ǳ�
            [5049] = {dt[1].car_getnum4,key=4}, --����Z4
            [5011] = {dt[1].car_getnum5,key=5}, --�µ�A8
          },
          [200017]={
            [5012] = {dt[1].car_getnum6,key=1}, --�׿ǳ�
            [5049] = {dt[1].car_getnum7,key=2}, --����Z4
            [5011] = {dt[1].car_getnum8,key=3}, --�µ�A8
            [5021] = {dt[1].car_getnum9,key=4}, --��ɯ����
            [5024] = {dt[1].car_getnum10,key=5}, --������
          },
          [200018]={
            [5049] = {dt[1].car_getnum11,key=1}, --����Z4
            [5011] = {dt[1].car_getnum12,key=2}, --�µ�A8
            [5021] = {dt[1].car_getnum13,key=3}, --��ɯ����
            [5024] = {dt[1].car_getnum14,key=4}, --������
            [5026] = {dt[1].car_getnum15,key=5},  --��������
          },                    
        }    
    end
	end)
end

function pay_give_car.on_query_status(buf)
	local status = pay_give_car.check_time()
	netlib.send(function(buf)
		buf:writeString("CARBOXST")
		buf:writeByte(status)
	end, buf:ip(), buf:port())
end


function pay_give_car.on_open_panel(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	pay_give_car.user_list[user_id].open_pay_give_car_panel = 1
	pay_give_car.send_huodong_info(user_info)
end

function pay_give_car.on_close_panel(buf)
		local user_info = userlist[getuserid(buf)]
		if user_info == nil then return end 
		if pay_give_car.user_list[user_info.userId] then
			pay_give_car.user_list[user_info.userId].open_pay_give_car_panel = nil
		end
end

function pay_give_car.send_huodong_info(user_info)
  local current_time = os.time()
  local table_time = os.date("*t",current_time)
  local now_day  = tonumber(table_time.day)
  
  local end_time = timelib.db_to_lua_time(pay_give_car.CFG_END_TIME)
  local table_time_end = os.date("*t",end_time)
  local end_day = tonumber(table_time_end.day)
  
  local left_day = end_day - now_day
  netlib.send(function(buf)
		buf:writeString("CARBOXOP")
		buf:writeInt(left_day)--ʣ������								
--		for i,v1 in pairs (pay_give_car.already_get_car) do
--		  for _,v2 in pairs (v1) do
--		    buf:writeInt(v2[1])
--		  end
--		end
    buf:writeInt(pay_give_car.already_get_car[200016][5013][1]) --����*2
    buf:writeInt(pay_give_car.already_get_car[200016][5018][1]) --ѩ����
    buf:writeInt(pay_give_car.already_get_car[200016][5012][1]) --�׿ǳ�
    buf:writeInt(pay_give_car.already_get_car[200016][5049][1]) --����Z4
    buf:writeInt(pay_give_car.already_get_car[200016][5011][1]) --�µ�A8
    buf:writeInt(pay_give_car.already_get_car[200017][5012][1]) --�׿ǳ�
    buf:writeInt(pay_give_car.already_get_car[200017][5049][1]) --����Z4
    buf:writeInt(pay_give_car.already_get_car[200017][5011][1]) --�µ�A8
    buf:writeInt(pay_give_car.already_get_car[200017][5021][1]) --��ɯ����
    buf:writeInt(pay_give_car.already_get_car[200017][5024][1]) --������
    buf:writeInt(pay_give_car.already_get_car[200018][5049][1]) --����Z4
    buf:writeInt(pay_give_car.already_get_car[200018][5011][1]) --�µ�A8
    buf:writeInt(pay_give_car.already_get_car[200018][5021][1]) --��ɯ����
    buf:writeInt(pay_give_car.already_get_car[200018][5024][1]) --������
    buf:writeInt(pay_give_car.already_get_car[200018][5026][1])  --�������� 
	end, user_info.ip, user_info.port)
end

--�յ��������¼�
function pay_give_car.bag_open_box_event(e)
  local user_id = e.data.user_id
  local box_id  = e.data.box_id
  local type_id = e.data.type_id
  local item_gift_id = e.data.item_gift_id
  local item_number = e.data.item_number
  
  local user_info = usermgr.GetUserById(user_id)
  local msg = "ʹ��%s������%s����ϲ�������μӳ�ֵ�������һ���н��ľ�����Ŷ��"		
	if pay_give_car.need_broadcast[box_id] and
	  pay_give_car.need_broadcast[box_id][item_gift_id] and
	  pay_give_car.need_broadcast[box_id][item_gift_id][1] == 1 then
  	  msg = string.format(msg,pay_give_car.box_name[box_id],pay_give_car.need_broadcast[box_id][item_gift_id][2])
  		tex_speakerlib.send_sys_msg( _U"��ϲ"..user_info.nick.._U(msg))
	end
end



--�����б�
cmdHandler = 
{
		--["CARBOXOP"] = pay_give_car.on_open_panel,--�����
    ["CARBOXST"] = pay_give_car.on_query_status,--�Ƿ����
    --["CARBOXCLO"] = pay_give_car.on_close_panel,--�ر����
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

--eventmgr:addEventListener("on_user_exit", pay_give_car.on_user_exit)
--eventmgr:addEventListener("h2_on_user_login", pay_give_car.on_after_user_login)
eventmgr:addEventListener("bag_open_box_event", pay_give_car.bag_open_box_event)
--eventmgr:addEventListener("on_server_start", pay_give_car.restart_server);


