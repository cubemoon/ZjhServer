TraceError("init onlineprize....")

if not onlineprizelib then
	onlineprizelib = _S
	{
        CheckeDateValid            = NULL_FUNC,			--ʱ��У��
        InitUserGameTimeInfo       = NULL_FUNC,			--��ʼ���һ�����Ϣ
        onGameOver                 = NULL_FUNC,			--�ۼ������Ϸʱ��
        OnRecvCheckDateValid       = NULL_FUNC,			--�յ��ͻ��˲�ѯ��Ƿ��ڽ����� 
        OnRecvQueryGameTimeInfo    = NULL_FUNC,	        --�յ��ͻ��˲�ѯ��Ϸʱ��
        OnRecvQueryPrize           = NULL_FUNC,			--�յ��ͻ��������콱
        OnSendGameTimeInfo         = NULL_FUNC,			--������Ϸʱ����Ϣ���ͻ���
        OnSendGivePrize            = NULL_FUNC,			--�����콱������ͻ���
        get_prizerate              = NULL_FUNC,         --��ȡÿ���ӽ������ٳ�������
        clear_lastdate             = NULL_FUNC,         --�����������
        get_addgold_by_time        = NULL_FUNC,         --��������ʱ�䣬��ȡҪ���͵ĳ�������
        get_is_step                = NULL_FUNC,         --�Ƿ��ǽ׶ιһ��ۼ�

        HIGH_LEVEL                 = -100,              --���ͳ�����߽׶�ʱ�ı�־

        --ÿ���ӵĽ������ο�get_prizerate
        --[[
        prizerate = 28,   --����0ʱ����ʾ�һ��ÿ���Ӱ�������̶����������ͳ���
        ary_time      = {},    --ʱ��������λ�����ӣ�
        ary_prizerate = {},    --��Ӧʱ�����͵ĳ�������
        ]]--

        prizerate = -1,     --С�ڵ���0ʱ����ʾ�һ�����׶����ͳ���
        ary_time      = {0,  60, 120, 180, 360},    --ʱ��������λ�����ӣ�
        ary_prizerate = {10, 20, 30,  50,  100},    --��Ӧʱ�����͵ĳ�������
        statime = "2012-05-31 00:00:00",  --���ʼʱ��
        endtime = "2099-02-28 00:00:00",  --�����ʱ��
        exttime = "2099-02-29 00:00:00",  --ֻ���콱ʱ��
	}
end
--�ж�ʱ��ĺϷ���,0���Ϸ���1ֻ���콱��2���콱���ۻ�ʱ��
onlineprizelib.CheckeDateValid = function()
	local statime = timelib.db_to_lua_time(onlineprizelib.statime);
	local endtime = timelib.db_to_lua_time(onlineprizelib.endtime);
	local exttime = timelib.db_to_lua_time(onlineprizelib.exttime);
	local sys_time = os.time();
	--�����콱��������Ϸʱ��
	if(sys_time >= statime and sys_time <= endtime) then
        return 2;
	end
	--ֻ���콱
	if(sys_time > endtime and sys_time <= exttime) then
        return 1;
	end
	--�ʱ���ȥ��
	return 0;
end

--�Ƿ��ǽ׶ιһ��ۼƣ�0�����ǣ�1����
onlineprizelib.get_is_step = function()
    if (onlineprizelib.prizerate > 0) then
        return 0
    end
    return 1
end

--��ȡÿ���ӽ������ٳ���������أ�
--[[
    1) ��ǰ�����ĳ�������
    2) ��һ�׶ν����ĳ�������
    3) ����һ�»���Ҫ��ʱ�䣨���ӣ�
--]]
onlineprizelib.get_prizerate = function(total_time)
    --�̶��������ͳ���
    if (onlineprizelib.get_is_step() == 0) then
        return onlineprizelib.prizerate, onlineprizelib.HIGH_LEVEL, 0
    end
    
    
    local ary_time = onlineprizelib.ary_time
    local ary_prizerate = onlineprizelib.ary_prizerate

    local prizerate = ary_prizerate[1]              --��ÿ���͵ĳ�������
    local next_prizerate = ary_prizerate[2]         --��һ����ÿ���͵ĳ�������
    local need_time = ary_time[2] + 1               --�ﵽ��һ���׶�����Ҫ��ʱ��
    
    for k, v in pairs(ary_time) do
        if (total_time > v) then
            prizerate = ary_prizerate[k]
            --���k+1�����˷�Χ����ʾ�ﵽ���ͳ������߽׶�
            next_prizerate = ary_prizerate[k+1] or onlineprizelib.HIGH_LEVEL 
            --�ﵽ��һ���׶�����Ҫ��ʱ��
            if (k == #ary_time) then
    		    need_time = 0   --�Ѿ��ﵽ��߽׶���
    	    else
    		    need_time = ary_time[k+1] - total_time + 1
    	    end
        end
    end
   
    --TraceError("prizerate:"..prizerate.."  next_prizerate:"..next_prizerate.."  need_time:"..need_time)
    return prizerate, next_prizerate, need_time
end

--��������ʱ�䣨��λ�����ӣ�����ȡҪ���͵ĳ�������
onlineprizelib.get_addgold_by_time = function(new_time)
    --TraceError("get_addgold_by_time -> new_time:"..new_time)
    if(onlineprizelib.get_is_step() == 0) then return 0 end

    local ary_time = onlineprizelib.ary_time
    local ary_prizerate = onlineprizelib.ary_prizerate
    

    --�õ�ʱ��ε��±�
	local index = 1
    for k, v in pairs(ary_time) do
		if(new_time > v) then
			index = k			
		end
	end	

	local addchouma = 0
    --����ʱ���±��ۼ�ÿ��ʱ��������͵ĳ�������
	for i = 1, index do
		if(i-1 > 0) then
			addchouma = addchouma + (ary_time[i] - ary_time[i-1]) * ary_prizerate[i-1]
		end
    end
    --����ʣ���ʱ��������͵ĳ�������
	addchouma = addchouma + (new_time - ary_time[index]) * ary_prizerate[index]

	return addchouma
end

--����������ݣ�result = 0��û��գ�1����գ�2���쳣
onlineprizelib.clear_lastdate = function(userinfo)
    local result = 0

    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    local today_add = split(userinfo.gametimeinfo["today_add"],"|");
    local dbtoday = tostring(today_add[1]) or "";
    local todayAdd = tonumber(today_add[2]) or 0;
    --TraceError("dbtoday:"..dbtoday.." sys_today:"..sys_today)
    if(dbtoday ~= sys_today)then
        dbtoday = sys_today
        todayAdd = 0
        userinfo.gametimeinfo["today_add"] = format("%s|%d", dbtoday, todayAdd); 
        dblib.cache_set("user_gametime_info", {today_add=userinfo.gametimeinfo["today_add"]}, "user_id", userinfo.userId);

        result = 1
    end

    --�쳣��飬һ�첻�ܳ���60 * 60 * 24��
    local dayMax = 86400; --60 * 60 * 24 = 86400
    if(todayAdd >= dayMax)then
        TraceError(format("�콱��������..todayAdd=[%d],dayMax=[%d]", todayAdd, dayMax));
        result = 2
    end

    return result
end

--��ʼ����ҹһ���Ϣ
onlineprizelib.InitUserGameTimeInfo = function(userinfo, onResult)
    --TraceError("onlineprizelib.InitGameTimeInfo")
    --��ʼ�����˹һ���Ϣ
    if onlineprizelib.CheckeDateValid() <= 0 then
        return;
    end

    if not userinfo then return end;
    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    local sqltemplet = "insert ignore into user_gametime_info (`user_id`, `today_add`) values(%d, '%s'); commit; ";
    local sql = format(sqltemplet, userinfo.userId, sys_today.."|".."0");
    dblib.execute(sql,
        function(dt1)
            dblib.cache_get("user_gametime_info", "*", "user_id", userinfo.userId,
                function(dt)
                    if not dt or #dt <= 0 then return end;
                    userinfo.gametimeinfo = {};
                    userinfo.gametimeinfo["total_time"] = dt[1]["total_time"];
                    userinfo.gametimeinfo["total_gold"] = dt[1]["total_gold"];
                    userinfo.gametimeinfo["new_time"] = dt[1]["new_time"];
                    userinfo.gametimeinfo["today_add"] = dt[1]["today_add"];
                    userinfo.gametimeinfo["last_time"] = dt[1]["last_time"] or "NULL";
                    userinfo.gametimeinfo["last_give"] = dt[1]["last_give"];
                    userinfo.gametimeinfo["already_gold"] = dt[1]["already_gold"] or 0;
                    --��飬�Ƿ��������
                    onlineprizelib.clear_lastdate(userinfo)

                    if(onResult ~= nil) then
                        xpcall(function() onResult() end,throw)
                    end
                end
            );
        end
    );
end

--������ҵ���Ϸʱ��
onlineprizelib.onGameOver = function(in_userinfo, in_addtime)
    --TraceError("onlineprizelib.onGameOver")
     
    --���ʱ��Ϸ���
    if onlineprizelib.CheckeDateValid() ~= 2 then
        return;
    end
	
	  
    local userinfo = in_userinfo;
    local addtime = tonumber(in_addtime) or 0;
    
    if not userinfo then return end;
    
    local gametimeinfo = userinfo.gametimeinfo;
    
    if not gametimeinfo then return end;
    
    --���������ӹһ�ʱ��
    local deskinfo=desklist[in_userinfo.desk]
    if(deskinfo~=nil and (deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament)) then
    	--TraceError("���������ӹһ�ʱ��");
    	return;
	end
    
    if addtime <= 0 then
    	TraceError(format("��ʲô��Ц?addtime=[%d]", addtime));
    	return;
    end

    --��飬�Ƿ��������
    local result = onlineprizelib.clear_lastdate(userinfo)
    if (result == 2) then return end    --�쳣���
    
    --����λ��Ϣ
	  if wing_lib and wing_lib.check_online_prize(userinfo) == 0 then
	     return 
	  end
	  
    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    local today_add = split(userinfo.gametimeinfo["today_add"],"|");
    local dbtoday = tostring(today_add[1]) or "";
    local todayAdd = tonumber(today_add[2]) or 0;
    local last_gold = onlineprizelib.get_addgold_by_time(math.floor(todayAdd/60));

    todayAdd = todayAdd + addtime;
    gametimeinfo["today_add"] = format("%s|%d", dbtoday, todayAdd); 
    gametimeinfo["total_time"] = gametimeinfo["total_time"] + addtime;
    gametimeinfo["new_time"] = gametimeinfo["new_time"] + addtime;
    
    if (onlineprizelib.get_is_step() == 0) then
        --�������ȡ�̶����룬����new_time������һ�õĳ�������
        local new_time_minute = math.floor(gametimeinfo["new_time"] / 60);
        if new_time_minute <= 0 then
        	--TraceError(format("û����Ϸʱ�䰡��,new_time_minute=[%d]", new_time_minute));
        	return;
        end
        gametimeinfo["total_gold"] = new_time_minute * onlineprizelib.prizerate
    else
        --��һ�����õĳ���
        local now_getgold = onlineprizelib.get_addgold_by_time(math.floor(todayAdd/60)) - last_gold;
        --�ۼ��ܵĳ���
        gametimeinfo["total_gold"] = gametimeinfo["total_gold"] + now_getgold;
    end

    
    dblib.cache_set("user_gametime_info", {total_gold=gametimeinfo["total_gold"]}, "user_id", userinfo.userId);
    dblib.cache_set("user_gametime_info", {today_add=gametimeinfo["today_add"]}, "user_id", userinfo.userId);
    dblib.cache_set("user_gametime_info", {total_time=gametimeinfo["total_time"]}, "user_id", userinfo.userId);
    dblib.cache_set("user_gametime_info", {new_time=gametimeinfo["new_time"]}, "user_id", userinfo.userId);
end

--�յ��ͻ��˲�ѯ��Ƿ��ڽ�����
onlineprizelib.OnRecvCheckDateValid = function(buf)
    --TraceError("onlineprizelib.OnRecvCheckDateValid")
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    local dateflag = onlineprizelib.CheckeDateValid();

    if(userinfo.channel_id ~= nil and userinfo.channel_id > 0) then
        dateflag = 0;
    end

    netlib.send(function(buf)
        buf:writeString("ONPDATE");
        buf:writeInt(dateflag);--����״̬��0��Ч���ڣ�1ֻ���콱����2���������
    end,userinfo.ip,userinfo.port);

    --��ʼ�����˹һ���Ϣ,ֻ��ڼ�ִ��
    if dateflag > 0 then
        onlineprizelib.InitUserGameTimeInfo(userinfo, nil);
    end
end

--�յ���Ҳ�ѯ�Լ���Ϸʱ��
onlineprizelib.OnRecvQueryGameTimeInfo = function(buf)
    --TraceError("onlineprizelib.OnRecvQueryGameTimeInfo")

    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;

    --���ʱ��Ϸ���
    local msgtype = userinfo.desk and 1 or 0; --1��ʾ����Ϸ�ﴦ���Э��,0�Ǵ���
    if onlineprizelib.CheckeDateValid() <= 0 then
        --local msg = format("�Բ��𣬻��û��ʼ�����Ѿ�����!");
        local msg = tex_lan.get_msg(userinfo, "onlineprize_msg_1");
        OnSendServerMessage(userinfo, msgtype, _U(msg));
        return;
    end

    if(not userinfo.gametimeinfo)then
        local onInitOk = function()
            onlineprizelib.OnSendGameTimeInfo(userinfo);
        end
	    onlineprizelib.InitUserGameTimeInfo(userinfo, onInitOk);
    else
        onlineprizelib.clear_lastdate(userinfo)
	  	onlineprizelib.OnSendGameTimeInfo(userinfo);
    end
end

--������Ϸʱ����Ϣ���ͻ���
onlineprizelib.OnSendGameTimeInfo = function(userinfo)
    if not userinfo then return end;

    local gametimeinfo = userinfo.gametimeinfo;
    if not gametimeinfo then return end;
    
    local dateflag = onlineprizelib.CheckeDateValid();
    local addgold = gametimeinfo["total_gold"] - gametimeinfo["already_gold"]
    local new_time = gametimeinfo["new_time"] or 0;
    if addgold < 0 then
    	TraceError(format("������Ϸʱ����Ϣ���ͻ��ˡ�new_time=[%d], addgold=[%d]", gametimeinfo["new_time"], addgold));
    	addgold = 0;
    end

    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    local today_add = split(userinfo.gametimeinfo["today_add"],"|");
    local todayAdd = tonumber(today_add[2]) or 0;
    local curr_prizerate, next_prizerate, need_time = onlineprizelib.get_prizerate(math.floor(todayAdd/60))

    local already_getgold_time = gametimeinfo["total_time"] - gametimeinfo["new_time"] 
    
    local n_type = 1
    if wing_lib then
      n_type = wing_lib.get_online_info(userinfo)
    end
    netlib.send(function(buf)
        buf:writeString("ONPTMIF");
        buf:writeInt(already_getgold_time > 0 and already_getgold_time or 0);
        buf:writeInt(gametimeinfo["already_gold"] or 0);
        buf:writeInt(new_time);
        buf:writeInt(addgold);
        buf:writeString(gametimeinfo["last_time"] or "NULL");
        buf:writeInt(gametimeinfo["last_give"]);
        buf:writeInt(curr_prizerate or 0);
        buf:writeInt(next_prizerate or 0);
        buf:writeInt(need_time or 0);
        buf:writeInt(dateflag);--����״̬��0��Ч���ڣ�1ֻ���콱����2���������
        buf:writeByte(n_type);--1û����0����-1�Ǿ�λ�ȼ�����
    end,userinfo.ip,userinfo.port);
end

--�յ���������콱
onlineprizelib.OnRecvQueryPrize = function(buf)
    --TraceError("onlineprizelib.OnRecvQueryPrize")
    local datefalg = onlineprizelib.CheckeDateValid();
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    local msgtype = userinfo.desk and 1 or 0; --1��ʾ����Ϸ�ﴦ���Э��,0�Ǵ���

    --���ʱ��Ϸ���
    if datefalg <= 0 then
        --local msg = format("��ȡʧ�ܣ����û��ʼ�����Ѿ�����!");
        local msg = tex_lan.get_msg(userinfo, "onlineprize_msg_2");
        OnSendServerMessage(userinfo, msgtype, _U(msg));
        return;
    end
    
    local gametimeinfo = userinfo.gametimeinfo;    
    if not gametimeinfo then return end;

    local curtime = os.clock() * 1000;
    if(gametimeinfo.lastqueryprize and curtime - gametimeinfo.lastqueryprize < 1000) then
        --TraceError(format("���̫����..:%d ms", curtime - gametimeinfo.lastquery));
        return;
    end

    gametimeinfo.lastqueryprize = curtime;
    
    local new_time_minute = math.floor(gametimeinfo["new_time"] / 60);
    if new_time_minute <= 0 then
    	--TraceError(format("û����Ϸʱ����ë��,new_time_minute=[%d]", new_time_minute));
        --local msg = format("��ȡʧ�ܣ�������Ϸʱ�䲻��!ret=-1");
        local msg = tex_lan.get_msg(userinfo, "onlineprize_msg_3");
        OnSendServerMessage(userinfo, msgtype, _U(msg));
    	return;
    end

    --��飬�Ƿ��������
    local result = onlineprizelib.clear_lastdate(userinfo)
    --�쳣���
    if (result == 2) then 
        --local msg = format("��ȡʧ�ܣ�������Ϸʱ�䲻��!ret=-2");
        local msg = tex_lan.get_msg(userinfo, "onlineprize_msg_4");
        OnSendServerMessage(userinfo, msgtype, _U(msg));
        return 
    end
    
    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    local today_add = split(userinfo.gametimeinfo["today_add"],"|");
    local todayAdd = tonumber(today_add[2]) or 0;
    local curr_prizerate, next_prizerate, need_time = onlineprizelib.get_prizerate(math.floor(todayAdd/60))

    --local addgold = curr_prizerate * new_time_minute;
    local addgold = gametimeinfo["total_gold"] - gametimeinfo["already_gold"]
    --TraceError("addgold:"..addgold.."  already_gold:"..gametimeinfo["already_gold"])
    if addgold <= 0 then
        TraceError(format("�����ܵģ�һ�������⡣addgold=[%d]", addgold));
        --local msg = format("��ȡʧ�ܣ�������Ϸʱ�䲻��!ret=-3");
        local msg = tex_lan.get_msg(userinfo, "onlineprize_msg_5");
        OnSendServerMessage(userinfo, msgtype, _U(msg));
        return;
    end
    
    --gametimeinfo["total_gold"] = gametimeinfo["total_gold"] + addgold;
    --dblib.cache_set("user_gametime_info", {total_gold=gametimeinfo["total_gold"]}, "user_id", userinfo.userId);
    gametimeinfo["already_gold"] = gametimeinfo["total_gold"];  --���� �Ѿ���ĳ���
    dblib.cache_set("user_gametime_info", {already_gold=gametimeinfo["already_gold"]}, "user_id", userinfo.userId);
    gametimeinfo["new_time"] = gametimeinfo["new_time"] - new_time_minute * 60;
    dblib.cache_set("user_gametime_info", {new_time=gametimeinfo["new_time"]}, "user_id", userinfo.userId);
    --��¼�콱��־
    local logsql = "insert ignore into log_gametime_pay (`user_id`,`sys_time`,`user_level`,`befor_gold`,`game_time`,`give_gold`) values(%d, now(), %d, %d, %d, %d); commit;";
    logsql = format(logsql, userinfo.userId, usermgr.getlevel(userinfo), userinfo.gamescore, new_time_minute * 60, addgold);
    dblib.execute(logsql);
    --�ӳ���
    usermgr.addgold(userinfo.userId, addgold, 0, g_GoldType.onlineprize or 1027, -1);
    --�����콱���
    onlineprizelib.OnSendGivePrize(userinfo, new_time_minute * 60, addgold);
    
    --ˢ�¿ͻ��˵���Ϸʱ����ʾ
    onlineprizelib.OnSendGameTimeInfo(userinfo);
end

--�����콱������ͻ���
onlineprizelib.OnSendGivePrize = function(userinfo, newtime, addgold)
    if not userinfo then return end;
    if not newtime then return end;
    if not addgold then return end;

    local dateflag = onlineprizelib.CheckeDateValid(); 
    netlib.send(function(buf)
        buf:writeString("ONPGTPR");
        buf:writeInt(newtime);  --����ʹ�õ�ʱ��
        buf:writeInt(addgold);	--��ó�����
        buf:writeInt(dateflag);--����״̬��0��Ч���ڣ�1ֻ���콱����2���������
    end,userinfo.ip,userinfo.port);
end

--�����б�
cmdHandler = 
{
    ["ONPDATE"] = onlineprizelib.OnRecvCheckDateValid, --�յ��ͻ��˲�ѯ��Ƿ��ڽ�����
    ["ONPTMIF"] = onlineprizelib.OnRecvQueryGameTimeInfo, --�յ��ͻ��˲�ѯ��Ϸʱ��
    ["ONPGTPR"] = onlineprizelib.OnRecvQueryPrize, --�յ��ͻ��������콱
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end
