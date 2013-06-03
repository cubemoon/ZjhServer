------------------------------------�¼��Ƴ�----------------------------------------
if signinlib and signinlib.on_after_user_login then
	eventmgr:removeEventListener("user_login_already_get_sign_db", signinlib.on_after_user_login)
end

if signinlib and signinlib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", signinlib.on_user_exit)
end

if signinlib and signinlib.on_timer_second then
    eventmgr:removeEventListener("timer_minute", signinlib.on_timer_minute)
end


--------------------------------------------------------------------------------------

--�µı�����
if not signinlib then
signinlib = 
{
    l_check_today_is_signed = NULL_FUNC,        --�õ������Ƿ���ǩ��
    l_get_last_month_day = NULL_FUNC,           --�õ�����µ����һ��
    l_check_time_is_this_month = NULL_FUNC,           --�õ�ͨ�����ݿ�ʱ������·�
    l_get_user_is_full_duty = NULL_FUNC,           --�õ��û��Ƿ�ȫ��
    l_set_user_sign_info = NULL_FUNC,           --�����û�ǩ����Ϣ

    set_OP_SIGNIN_TASK_LIST = NULL_FUNC,            --�޸�ǩ����������
    
    on_after_user_login = NULL_FUNC,            --��¼�¼�
    on_user_exit = NULL_FUNC,            --�û��˳�
    on_timer_minute = NULL_FUNC,            --����ʱ
    is_new_sign_day = NULL_FUN,             --2���ǲ��ǳ���1����
    on_recv_do_sign_in = NULL_FUNC,             --����ǩ��
    on_recv_sign_task_list = NULL_FUNC,          --�����ǩ�����

    net_send_do_sign_in = NULL_FUNC,      --����ǩ�����
    net_send_sign_in_info = NULL_FUNC,    --����ǩ����Ϣ
    send_OP_SIGNIN_TASK_LIST = NULL_FUNC, --���ͽ�������

    reloadUserDataFromDB = NULL_FUNC, --���ͽ�������
	get_date_from_time = NULL_FUNC,   --�õ����������
	
    --todo:cjzǩ��ϵͳ���Ҹı�������б�
    STATIC_ADD_GOLD_TYPE_SIGNIN_TASK_JIANGJUAN = 8,
    STATIC_ADD_GOLD_TYPE_SIGNIN_TASK_MATCH_GOLD = 9,

    MIN_MATCH_LAST_DAY = 28,
    SIGNIN_TASK_LIST_LEN = 0,

    user_list   = {},       --�û�������ԡ�
    


--------------------��Ӫ�ɵ�������ʼ��------------------------------------------------------------------------ 
    OP_SIGNIN_TASK_LIST = {
        [1] = { }, [2] = { }, [3] = { }, [4] = { }, [5] = { }, [6] = { },[7]={},
    },
    
    item_config ={
    	[4] = "С����",
    	[10] = "VIP3 �����鿨3��",
    	[11] = "T�˿�",
    	[21] = "������λ",
    	[22] = "�м���λ",
    	[23] = "�߼���λ",
    	[5012] = "�׿ǳ�",
    	[5013] = "����",

    	
    }
    
    
}
end

------------------------------------����----------------------------------------
--�������
signinlib.l_check_time_is_this_month = function(db_time)
    local ret = 0
    local lua_time = os.time()
    if db_time ~= nil and db_time ~= "" then
        lua_time = timelib.db_to_lua_time(db_time)
    end

    local month = tonumber(os.date("%m",os.time()))
    local year = tonumber(os.date("%Y",os.time()))
    if lua_time >= os.time({year=year, month=month, day=1, hour=0, minute=0, second=0}) then
        ret = 1
    end
    return ret
end

signinlib.l_check_today_is_signed = function(user_info)
	
	if signinlib.user_list[user_info.userId].last_sign_reward_time==nil or signinlib.user_list[user_info.userId].last_sign_reward_time=="" then return 0 end
    local last_sign_reward_time=timelib.db_to_lua_time(signinlib.user_list[user_info.userId].last_sign_reward_time) or 0
    local table_time1 = os.date("*t",last_sign_reward_time);
	local year1  = table_time1.year;
	local month1 = table_time1.month;
	local day1 = table_time1.day;
	local time1 = year1.."-"..month1.."-"..day1
	
	local table_time2 = os.date("*t",os.time());
	local year2  = tonumber(table_time2.year);
	local month2 = tonumber(table_time2.month);
	local day2 = tonumber(table_time2.day);
	local time2 = year2.."-"..month2.."-"..day2
	
	if time1==time2 then
		return 1
	else
    	return 0
    end
end

signinlib.l_get_last_month_day = function()
    local ret = 0
    local month = tonumber(os.date("%m",os.time()))
    local year = tonumber(os.date("%Y",os.time()))
    if month >= 12 then
        year = year + 1
        month = 0
    end
    month = month + 1
    ret = tonumber(os.date("%d", os.time({year = year, month = month, day = 1}) - 3600 * 24))
    return ret
end

signinlib.l_get_user_is_full_duty = function(user_id)
    local ret = 0
    local last_month_day = signinlib.l_get_last_month_day()
    if signinlib.user_list[user_id] ~= nil and signinlib.user_list[user_id].last_sign_day == last_month_day and signinlib.user_list[user_id].signin_count == last_month_day then
        ret = 1
    end
    return ret
end

signinlib.l_set_user_sign_info = function(user_id, last_sign_day, signin_count, last_sign_reward_time, isThisMonth, today)

    if signin_count == nil then signin_count = 0 end

    --��ʱ���ж�һ�£����ǩ������7�죬���ߵ���7�쵫���ǽ���ǩ�ģ�����һ������
    if signin_count > 7 or (signin_count == 7 and signinlib.user_list[user_id].last_sign_day~=today) then
        signinlib.user_list[user_id] = {};
        signinlib.user_list[user_id].signin_count = 0
        signinlib.user_list[user_id].last_sign_day = 0
        signinlib.user_list[user_id].is_full_duty = 0
        signinlib.user_list[user_id].last_sign_reward_time = ""
        --TraceError("�ÿ�ǩ����Ϣuserid:"..user_id)
        user_sign_db.clear_sign_info(user_id)
    end
end


signinlib.set_OP_SIGNIN_TASK_LIST = function(day, jiangjuan, match_gold, item_1, item_2, item_3)
    if jiangjuan ~= nil then
        signinlib.OP_SIGNIN_TASK_LIST[day].jiangjuan = jiangjuan
    end

    if match_gold ~= nil then
        signinlib.OP_SIGNIN_TASK_LIST[day].match_gold = match_gold
    end

    if item_1 ~= nil then
        signinlib.OP_SIGNIN_TASK_LIST[day].item_1 = item_1
    end

    if item_2 ~= nil then
        signinlib.OP_SIGNIN_TASK_LIST[day].item_2 = item_2
    end

    if item_3 ~= nil then
        signinlib.OP_SIGNIN_TASK_LIST[day].item_3 = item_3
    end

end

signinlib.get_date_from_time=function(db_time)
	if db_time==nil or db_time=="" then return "" end
	return string.sub(db_time,1,10)
end

--�����ݿ�ˢ���û���Ϣ
--����2���û���ǰ����ǩ��������
--��ȡ�����û���������б�
signinlib.reloadUserDataFromDB = function(user_info,signin_info,last_sign_reward_time,sys_time)
    --ֻ��Ӧ��������Ϣ
    if (gamepkg.name ~= "tex" and gamepkg.name ~= "commonsvr")  then
       return;
    end

    --TraceError("signinlib.l_check_time_is_this_month(sys_time):"..signinlib.l_check_time_is_this_month(sys_time))
    signinlib.user_list[user_info.userId] = {};
    
        --���ǩ������
        local last_sign_day = tonumber(signin_info[1]) or 0
        signinlib.user_list[user_info.userId].last_sign_day = last_sign_day
        --����ǩ����
        local signin_count = 0
        
        if(last_sign_reward_time==nil or last_sign_reward_time=="")then
            signin_count = 0
        elseif user_sign_db.is_next_day(timelib.db_to_lua_time(last_sign_reward_time),os.time())==1 then
            signin_count = #signin_info or 0
        end
        
        local today=timelib.lua_to_db_time(os.time())
        if signin_count > 7 or (signin_count == 7 and signinlib.get_date_from_time(last_sign_reward_time)~=signinlib.get_date_from_time(today)) then
	        signinlib.user_list[user_info.userId].signin_count = 0
	        signinlib.user_list[user_info.userId].last_sign_day = 0
	        signinlib.user_list[user_info.userId].is_full_duty = 0
	        signinlib.user_list[user_info.userId].last_sign_reward_time = ""
	        --TraceError("�ÿ�ǩ����Ϣuserid:"..user_info.userId)
	        user_sign_db.clear_sign_info(user_info.userId)
        
        else
	        signinlib.user_list[user_info.userId].signin_count = signin_count
	        --����Ƿ��Ѿ�ȫ��
	        local is_full_duty = 0
	        if signin_count == 7 then
	        	is_full_duty = 1
	        end
	        signinlib.user_list[user_info.userId].is_full_duty = is_full_duty
	        --����Ļ�ʱ��
	        signinlib.user_list[user_info.userId].last_sign_reward_time = last_sign_reward_time or ""
        end

end

signinlib.removeUserMatchDataFromMem = function(user_id)
    --����û�����
    signinlib.user_list[user_id] = nil;
end


------------------------------------�������ڲ��¼���Ӧ----------------------------------------
signinlib.on_after_user_login = function(e)
    --ֻ��Ӧ�»��ֶ���������������Ϣ
    -- [[
    if (gamepkg.name ~= "tex" and gamepkg.name ~= "commonsvr") then
        return;
    end

    local user_info;
    if e == nil then return end 
    if e.data ~= nil then
        user_info = e.data.userinfo
    else
        return;
    end
    
    --����ǩ����Ϣ
    signinlib.net_send_sign_in_info(user_info)
end

signinlib.on_user_exit = function(e)
    --ֻ��Ӧ�»��ֶ���������������Ϣ
    if (gamepkg.name ~= "tex" and gamepkg.name ~= "commonsvr") then
        return;
    end

    --TraceError("clear");
    --����ڴ�����
    signinlib.removeUserMatchDataFromMem(e.data.user_id);
end

signinlib.on_timer_minute = function(e)
    local tableTime = os.date("*t",os.time())
    local nowHour  = tonumber(tableTime.hour)
    if(nowHour == 0 and  e.data.min == 0) then
        --��ʱ�����˵�ǩ����Ϣ
        local today = tonumber(os.date("%d",os.time()))
        local this_month = tonumber(os.date("%m",os.time()))
        local isThisMonth = signinlib.l_check_time_is_this_month()

        for k,v in pairs(signinlib.user_list) do
            local user_info = usermgr.GetUserById(k)
            if user_info ~= nil and v ~= nil then
                signinlib.l_set_user_sign_info(k, v.last_sign_day, v.signin_count, v.last_sign_reward_time, isThisMonth, today)
                signinlib.net_send_sign_in_info(user_info, this_month, today)
            end
        end
    end
end

------------------------------------������----------------------------------------
--ȡ2��ʱ���0��0��0�룬���2�ߵĲ�ֵ����1��ͷ���1�����򷵻�0
signinlib.is_new_sign_day = function(time1,time2)
    if time1==nil or time2==nil or time1=="" or time2=="" then return 1 end
	local table_time1 = os.date("*t",time1);
	local year1  = table_time1.year;
	local month1 = table_time1.month;
	local day1 = table_time1.day;
	local time1 = year1.."-"..month1.."-"..day1.." 00:00:00"
	
	local table_time2 = os.date("*t",time2);
	local year2  = tonumber(table_time2.year);
	local month2 = tonumber(table_time2.month);
	local day2 = tonumber(table_time2.day);
	local time2 = year2.."-"..month2.."-"..day2.." 00:00:00"
	
	--�ݴ������ʱ���õ��յģ���õ�1970��
	if tonumber(year1)<2012 or tonumber(year2)<2012 then 
		return 1 
	end
	if timelib.db_to_lua_time(time2)-timelib.db_to_lua_time(time1) > 60*60*24 then
		return 1
	end
	return 0
end
--����ǩ��
signinlib.on_recv_do_sign_in = function(buf)
    local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	if  signinlib.user_list==nil then return end
	if  signinlib.user_list[user_info.userId]==nil then return end
	
    local sign_status = 0
     local last_reward_day = 0
    if signinlib.user_list[user_info.userId].last_sign_reward_time ~= nil and signinlib.user_list[user_info.userId].last_sign_reward_time ~= "" then
        last_reward_day = timelib.db_to_lua_time(signinlib.user_list[user_info.userId].last_sign_reward_time)
    end
    
    --����������һֱ���ţ�������һ�죬����Ϊ���µ�һ��ǩ������0��ʼ
    if signinlib.is_new_sign_day(last_reward_day,os.time()) == 1 then
    	signinlib.user_list[user_info.userId].signin_count = 0        
        signinlib.user_list[user_info.userId].is_full_duty = 0        
    end
    
    --begin--------------------------
    --��֤�Ƿ�Ҫ�������Ϣ
    --ע��1��ȫ��д�������Ҫ�·�װ����
    --ע��2��signinlib.user_list[user_info.userId].last_daily_reward_time��¼�����һ�ε��콱ʱ�䣬ʹ��ǰ�ǵ��ж��Ƿ�Ϊ��
	
    --���ü�Ǯ�ӿڼ�Ǯ��l_add_user_match_gold_db�����Ͳ���ʹ��signinlib.STATIC_ADD_GOLD_TYPE_DAILY_REWARD,�����������͵�Ǯ��ע����Ӧ����ֵ��

    if signinlib.l_check_today_is_signed(user_info) ~= 1 then --����δǩ��
        local today = tonumber(os.date("%d",os.time()))
        
        
        sign_status = 1--ǩ��
		signinlib.user_list[user_info.userId].signin_count = signinlib.user_list[user_info.userId].signin_count + 1
        signinlib.user_list[user_info.userId].last_sign_day = today
        signinlib.user_list[user_info.userId].is_full_duty = signinlib.l_get_user_is_full_duty(user_info.userId)
        
        local signin_count = signinlib.user_list[user_info.userId].signin_count
        if signinlib.user_list[user_info.userId].is_full_duty == 1 then
            signin_count = 7
        end
        
        if signinlib.OP_SIGNIN_TASK_LIST[signin_count] ~= nil then
        
        local table_time = os.date("*t",os.time());
	    local now_year  = table_time.year;
	    local now_month = table_time.month;
	    local now_day = table_time.day;
	    local now_date_time = timelib.db_to_lua_time(now_year.."-"..now_month.."-"..now_day.." 00:00:00")
	


            
            if last_reward_day >= now_date_time then --��������ȡ�������ˣ�
                sign_status = -2
            else
                --��¼��ǩ��
        		user_sign_db.record_sign_info(user_info.userId)
                local signin_task_info = signinlib.OP_SIGNIN_TASK_LIST[signin_count]
                local item_count = 1
                sign_status = 2--ǩ�����н���
                --�콱
                if signinlib ~= nil then
                    --����ȯ
                    if signin_task_info.jiangjuan > 0 then
                   		usermgr.addgold(user_info.userId, signin_task_info.jiangjuan, 0, new_gold_type.SIGNIN, -1);
                    end
    
                end
    
                --��item����....
                --if bag ~= nil then
                    local item_Id = 0
                    if signin_task_info.item_1 > 0 then
                        item_Id = signin_task_info.item_1
                        item_count = signin_task_info.item_count_1
                        for i=1,item_count do
	                        if(item_Id==4)then
	                        	--С����
	                        	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info);
	                        elseif(item_Id==10)then
	                        	--VIP3 �����鿨
	                        	add_user_vip(user_info, 3, 3);
	                         elseif(item_Id==11)then
	                        	--T�˿�
	                        	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info)
	                        elseif(item_Id==21)then
	                        	--������λ
	                        	parkinglib.add_parking(user_info, 1, 1);
	                        	parkinglib.on_add_gift_item(user_info, item_Id)	                        	
	                        elseif(item_Id==22)then
	                        	--�м���λ
	                        	parkinglib.add_parking(user_info, 2, 1)
	                        	parkinglib.on_add_gift_item(user_info, item_Id)
						    else
						    	car_match_db_lib.add_car(user_info.userId, item_Id, 0)
	                        	--gift_addgiftitem(user_info,item_Id,user_info.userId,user_info.nick, false)
	                    	end
                    	end
                    end
                    
                    if signin_task_info.item_2 > 0 then
                        item_Id = signin_task_info.item_2
                        item_count = signin_task_info.item_count_2
                         for i=1,item_count do
	                        if(item_Id==4)then
	                        	--С����
	                        	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info);
	                        elseif(item_Id==10)then
	                        	--VIP3 �����鿨
	                        	add_user_vip(user_info, 3, 3);
	                         elseif(item_Id==11)then
	                        	--T�˿�
	                        	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info)
	                        elseif(item_Id==21)then
	                        	--������λ
	                        	parking_db_lib.add_user_parking_db(user_info.userId, 1, 1)
	                        	parkinglib.on_add_gift_item(user_info, item_Id)	                        	
	                        elseif(item_Id==22)then
	                        	--�м���λ
	                        	parking_db_lib.add_user_parking_db(user_info.userId, 2, 1)
	                        	parkinglib.on_add_gift_item(user_info, item_Id)
						    else
						    	car_match_db_lib.add_car(user_info.userId, item_Id, 0)
	                        	--gift_addgiftitem(user_info,item_Id,user_info.userId,user_info.nick, false)
	                    	end
                    	end
                    end
        
                    if signin_task_info.item_3 > 0 then
                        item_Id = signin_task_info.item_3
                        item_count = signin_task_info.item_count_3
                        for i=1,item_count do
	                        if(item_Id==4)then
	                        	--С����
	                        	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info);
	                        elseif(item_Id==10)then
	                        	--VIP3 �����鿨
	                        	add_user_vip(user_info, 3, 3);
	                         elseif(item_Id==11)then
	                        	--T�˿�
	                        	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info)
	                        elseif(item_Id==21)then
	                        	--������λ
	                        	parking_db_lib.add_user_parking_db(user_info.userId, 1, 1)
	                        	parkinglib.on_add_gift_item(user_info, item_Id)	                        	
	                        elseif(item_Id==22)then
	                        	--�м���λ
	                        	parking_db_lib.add_user_parking_db(user_info.userId, 2, 1)
	                        	parkinglib.on_add_gift_item(user_info, item_Id)
						    else
						    	car_match_db_lib.add_car(user_info.userId, item_Id, 0)
	                        	--gift_addgiftitem(user_info,item_Id,user_info.userId,user_info.nick, false)
	                    	end
                    	end
                    end
                --end
                
                --ÿ�������VIP����Ǯ
                --signinlib.give_daily_gold(user_info)
                
                --�ڴ��м�¼����ʱ��
                signinlib.user_list[user_info.userId].last_sign_reward_time = timelib.lua_to_db_time(os.time());
                user_sign_db.log_user_sign_reward(user_info.userId, signin_count)
            end
        end
    else
		sign_status = -1 --������ǩ����
	end

   
    
    --֪ͨ�ͻ��˽�����Ѿ�д�ýӿڣ�������Լ���
	signinlib.net_send_do_sign_in(user_info,sign_status)
    --end---------------------------------
end

--�����ǩ�����
signinlib.on_recv_sign_task_list = function(buf)
    local user_info = userlist[getuserid(buf)]
    if user_info == nil then return end
     
    signinlib.send_OP_SIGNIN_TASK_LIST(user_info)
end

------------------------------------���͵��ͻ��˵�Э�麯��----------------------------------------
signinlib.net_send_do_sign_in = function(user_info,sign_status)
    if signinlib.user_list[user_info.userId] == nil then
        return
    end

    if sign_status > 0 then
        signinlib.net_send_sign_in_info(user_info)
    end

    netlib.send(function(buf_out)
        buf_out:writeString("SIGNIN")
        buf_out:writeByte(sign_status or 0)--�ɹ����
    end, user_info.ip, user_info.port)
end

signinlib.net_send_sign_in_info = function(user_info, this_month, this_day)
    if signinlib.user_list[user_info.userId] == nil then
        return
    end

    if this_month == nil then
        this_month = tonumber(os.date("%m",os.time()))
    end

    if this_day == nil then
        this_day = tonumber(os.date("%d",os.time()))
    end
    
    local is_signed = signinlib.l_check_today_is_signed(user_info)
    local is_full_duty = 0
    if signinlib.user_list[user_info.userId].signin_count>=7 then
    	is_full_duty =1
    end

    netlib.send(function(buf_out)
        buf_out:writeString("SIGNINFO")
        buf_out:writeInt(this_month or 0)--����
        buf_out:writeInt(this_day or 0)--����
        buf_out:writeByte(is_signed or 0)--�Ƿ���ǩ��
        buf_out:writeInt(signinlib.user_list[user_info.userId].signin_count or 0)--����ǩ������
        buf_out:writeInt(is_full_duty)--�Ƿ�ȫ��
    end, user_info.ip, user_info.port)
end

signinlib.send_OP_SIGNIN_TASK_LIST = function(user_info)
    if signinlib.SIGNIN_TASK_LIST_LEN == 0 then
        local len = 0
        for k,v in pairs(signinlib.OP_SIGNIN_TASK_LIST) do
            len = len + 1
        end
        signinlib.SIGNIN_TASK_LIST_LEN = len
    end

    netlib.send(function(buf_out)
        buf_out:writeString("SIGNTASK")
        buf_out:writeInt(signinlib.SIGNIN_TASK_LIST_LEN)
        for k,v in pairs(signinlib.OP_SIGNIN_TASK_LIST) do 
            local key = k
            local item_name=""
            local item_name2=""
            local item_name3=""
            if key >= 7 then
                key = 7
            end
            buf_out:writeInt(key)
            --todo:�Ľ�Ʒ
            buf_out:writeInt(v.jiangjuan)--�����Ľ���
            --buf_out:writeInt(v.match_gold)--����������
            buf_out:writeInt(v.item_1)--��������Ʒ1            
            if (v.item_1~=0) then item_name=_U(signinlib.item_config[v.item_1]) or "" end
            buf_out:writeString(item_name)--��������Ʒ1            
            buf_out:writeInt(v.item_count_1)--��������Ʒ1����
            buf_out:writeInt(v.item_2)--��������Ʒ2
      		if (v.item_2~=0) then item_name2=_U(signinlib.item_config[v.item_2]) or "" end
            buf_out:writeString(item_name2)--��������Ʒ2  
            buf_out:writeInt(v.item_count_2)--��������Ʒ1����            
            buf_out:writeInt(v.item_3)--��������Ʒ3
            if (v.item_3~=0) then item_name3=_U(signinlib.item_config[v.item_3]) or "" end
            buf_out:writeString(item_name3)--��������Ʒ3  
            buf_out:writeInt(v.item_count_3)--��������Ʒ1����
        end
    end, user_info.ip, user_info.port)
end

------------------------------------�¼����----------------------------------------
--����ʱ��¼������
eventmgr:addEventListener("user_login_already_get_sign_db", signinlib.on_after_user_login)

--�û��˳�
eventmgr:addEventListener("on_user_exit", signinlib.on_user_exit);

--����ʱ
eventmgr:addEventListener("timer_minute", signinlib.on_timer_minute);


------------------------------------������Ӧ----------------------------------------
--�����б�
cmdHandler = 
{
    --����ǩ��
    ["SIGNTASK"] = signinlib.on_recv_sign_task_list, --����������
    ["SIGNIN"] = signinlib.on_recv_do_sign_in, --����ǩ��
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

