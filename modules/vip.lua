TraceError("init vip....")

if not viplib then
	viplib = _S
	{
		load_user_vip_info_from_db 				= NULL_FUNC,			--�����ݿ��ж�ȡvip��Ϣ
		get_user_vip_info						= NULL_FUNC,			--��ȡ���vip��Ϣ
		set_user_vip_info						= NULL_FUNC,			--�������vip��Ϣ
		check_user_vip							= NULL_FUNC,			--��ȡ����ǲ���vip
		get_vip_level                           = NULL_FUNC,			--��ȡ��ҵ����VIP�ȼ�
		check_user_vip_case						= NULL_FUNC,			--������VIP״̬�Լ�д���ڴ�
		on_reve_load_user_vip_info_from_db		= NULL_FUNC,			--���������µ�VIP��Ϣ

		give_user_vip						    = NULL_FUNC,			--�ⲿ�ӿڣ��������VIP�ʸ�

		on_meet_event							= NULL_FUNC,			--�����¼�

		net_send_my_vip_info					= NULL_FUNC,			--�����Լ���vip��Ϣ
		net_send_vip_info						= NULL_FUNC,			--����,˵ĳ����λ��VIP״̬
		net_send_vip_case						= NULL_FUNC,			--֪ͨ�ͻ��˻�Ա��ֵ�Ƿ�ɹ����Ƿ����
		add_user_vip						= NULL_FUNC,			--��VIP
		--��ͬVIP���ÿ���콱�ļӳ�:ͭ��888������1888������3888,��ʯ5888,�׽�8888,�ѽ�
		add_day_gold ={888,1888,3888,5888,8888, 88888},
	}
end

function viplib.add_user_vip(userinfo,vip_level,vip_days)
		--��VIP
		local sql = "";
		sql = "insert into user_vip_info values(%d,%d,DATE_ADD(now(),INTERVAL %d DAY),0,0)";
		sql = sql.." ON DUPLICATE KEY UPDATE over_time = case when over_time > now() then DATE_ADD(over_time,INTERVAL %d DAY) else DATE_ADD(now(),INTERVAL %d DAY) end,notifyed = 0,first_logined = 0; ";
		sql = string.format(sql,userinfo.userId,vip_level,vip_days,vip_days,vip_days);
		dblib.execute(sql);
end

--�����ݿ��ж�ȡvip��Ϣ
viplib.load_user_vip_info_from_db = function(user_id, call_back)
	--TraceError("viplib.load_user_vip_info_from_db()")
	local userinfo = usermgr.GetUserById(user_id)
    if not userinfo then  return end
	dblib.execute(string.format("select * from user_vip_info where user_id = %d;", user_id),
		function(dt)
			if dt and #dt > 0 then
				viplib.check_user_vip_case(userinfo,dt)
				--�õ����˿�����
                if (tex_buf_lib) then
                    xpcall(function() tex_buf_lib.load_kick_card_from_db(userinfo) end, throw)
                end
				--ˢ�������¼�
                eventmgr:dispatchEvent(Event("on_after_refresh_info", userinfo));

            end
            --֪ͨ�����Ƿ���ʾÿ�յ�½��Ǯ
	        xpcall(
	            function()
	                give_daygold_check(userinfo)
	            end,throw)
          
            --vip��½�ͽ�ȯ
            if (tex_dailytask_lib) then
                xpcall(function() tex_dailytask_lib.on_after_user_login(userinfo, viplib.get_vip_level(userinfo)) end, throw)

            end
            if (call_back ~= nil) then
                call_back()
            end            
		end, user_id)
end

viplib.on_reve_load_user_vip_info_from_db = function(buf)
    --TraceError("ˢϴvip info")
	local userinfo = userlist[getuserid(buf)]
	if not userinfo then  return end
	viplib.load_user_vip_info_from_db(userinfo.userId)
end

--������VIP״̬�Լ�д���ڴ�
viplib.check_user_vip_case = function(userinfo,dt)
	if not userinfo or not dt or #dt <=0 then return end
	local user_id = userinfo.userId		
	local vip_info = {}
	for i = 1, #dt do
		local sql = ""
        local over_time = timelib.db_to_lua_time(dt[i].over_time) or 0
		local is_over = over_time < os.time() and 1 or 0
		if is_over == 1 or dt[i].vip_level <= 0 then	--����
			if dt[i].notifyed == 0 then
				sql = "update user_vip_info set notifyed = 1 where user_id = %d and vip_level = %d;commit;"
				viplib.net_send_vip_case(userinfo,dt[i],0)--�������״ε�½
			end
		else
			if dt[i].first_logined == 0 then
				sql = "update user_vip_info set first_logined = 1 where user_id = %d and vip_level = %d;commit;"
				dt[i].first_logined = 1
				viplib.net_send_vip_case(userinfo,dt[i],1)--�ճ�ֵ���״ε�½
			end
			table.insert(vip_info, dt[i])
		end
		if(sql ~= "") then
			dblib.execute(format(sql, user_id, dt[i].vip_level))
		end
	end
	
	if(#vip_info > 0)then
		viplib.set_user_vip_info(userinfo, vip_info)
		viplib.net_send_my_vip_info(userinfo, vip_info)
	else
		viplib.set_user_vip_info(userinfo, nil)
	end
end

--������Ƿ���vip
viplib.check_user_vip = function(userinfo)
	local vip_info = viplib.get_user_vip_info(userinfo)
	if not vip_info then return false end

	local is_VIP = false
	for k,v in pairs(vip_info) do
		if(timelib.db_to_lua_time(v.over_time) > os.time() and v.vip_level > 0) then
			is_VIP = true
			break
		end
	end
	return is_VIP
end

--��ȡ���VIP�ȼ�
viplib.get_vip_level = function(userinfo)
    local max_level = 0
	local vip_info = viplib.get_user_vip_info(userinfo)
	if not vip_info then return max_level end
    --��ȡ��ߵĵȼ�
	for k,v in pairs(vip_info) do
		if(timelib.db_to_lua_time(v.over_time) > os.time()) then
			if(max_level < v.vip_level) then
                max_level = v.vip_level
            end
		end
	end
	return max_level
end

--��ȡ���vip��Ϣ
viplib.get_user_vip_info = function(userinfo)
	return userinfo.vip_info
end

--�������vip��Ϣ
viplib.set_user_vip_info = function(userinfo, vip_info)
	userinfo.vip_info = vip_info
end

--�����һ��VIP�ʸ�͸��ͳ���
--ntype:�����VIP���ͣ�1ͭ�ƣ�2���ƣ�3����
viplib.give_user_vip = function(userinfo, ntype)
    if(not userinfo) then return end
    if(ntype < 1 or ntype > 6) then return end --������VIP6�ˣ������VIP6����û�ĵ���
    --��VIP
    local sql = ""
    sql = "insert into user_vip_info(user_id, vip_level, over_time, notifyed, first_logined) values(%d,%d,DATE_ADD(now(),INTERVAL %d DAY),0,0)";
    sql = sql.." ON DUPLICATE KEY UPDATE over_time = case when over_time > now() then DATE_ADD(over_time,INTERVAL %d DAY) else DATE_ADD(now(),INTERVAL %d DAY) end,notifyed = 0,first_logined = 0;commit; ";
    sql = string.format(sql,userinfo.userId, ntype, 30, 30, 30);
    dblib.execute(sql, function(dt) viplib.load_user_vip_info_from_db(userinfo.userId) end);
end
----------------------------------------�¼�����-----------------------------------

if viplib.on_meet_event and viplib.on_meet_event ~= NULL_FUNC then
	eventmgr:removeEventListener("meet_event", viplib.on_meet_event);
end

--�����¼�
viplib.on_meet_event = function(e)
    local time1 = os.clock() * 1000
	local userinfo = e.data.subject
	local vip_info = viplib.get_user_vip_info(userinfo)
	if vip_info then
		viplib.net_send_vip_info(e.data.observer, userinfo.userId, userinfo.site,  vip_info, e.data.relogin)	
    end
    local time2 = os.clock() * 1000
    if (time2 - time1 > 50)  then
        TraceError("VIP�����¼�,ʱ�䳬��:"..(time2 - time1))
    end
end

eventmgr:addEventListener("meet_event", viplib.on_meet_event);

----------------------------------------����------------------------------------

--�����Լ���vip��Ϣ
viplib.net_send_my_vip_info = function(userinfo, vip_info)
	netlib.send(
		function(buf)
			buf:writeString("VIPMYI")
			buf:writeInt(#vip_info)
			for i=1,#vip_info do
				buf:writeInt(vip_info[i].vip_level)
				buf:writeString(vip_info[i].over_time)
			end
		end
	, userinfo.ip, userinfo.port)
end

--����,˵ĳ����λ��VIP״̬
viplib.net_send_vip_info = function(userinfo, userid, site, vip_info, relogin)
	netlib.send(
		function(buf)
			buf:writeString("VIPINF")
			buf:writeInt(userid)
			buf:writeByte(site or 0)
			buf:writeInt(#vip_info)
			for i=1,#vip_info do
				buf:writeInt(vip_info[i].vip_level)
				buf:writeString(vip_info[i].over_time)
			end
            buf:writeByte(relogin)
		end
	, userinfo.ip, userinfo.port)
end

--֪ͨ�ͻ��˻�Ա��ֵ�Ƿ�ɹ����Ƿ����
viplib.net_send_vip_case = function(userinfo,vip_item,nType)
	if not userinfo or not vip_item then return end
	netlib.send(
		function(buf)
			buf:writeString("VIPOVR")
			buf:writeByte(nType)
			buf:writeByte(vip_item["vip_level"])
			if nType == 1 then
				buf:writeString(vip_item["over_time"])
			end
		end
	, userinfo.ip, userinfo.port)
end

--�����б�
cmdHandler = 
{
	["RQVIPIF"] = viplib.on_reve_load_user_vip_info_from_db,--���������µ�VIP��Ϣ
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end
