TraceError("init newyear_activity...")
if newyear_lib and newyear_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", newyear_lib.on_after_user_login);
end

if newyear_lib and newyear_lib.ontimecheck then
	eventmgr:removeEventListener("timer_minute", newyear_lib.ontimecheck);
end
		
if not newyear_lib then
    newyear_lib = _S
    {
        on_after_user_login = NULL_FUNC,--�û���½���ʼ������
 
		check_datetime = NULL_FUNC,	--�����Чʱ�䣬��ʱ����
		ongameover = NULL_FUNC,	--��Ϸ�����ɼ�����
		net_send_playnum = NULL_FUNC,	--����������ʱ��״̬
		ontimecheck = NULL_FUNC,	--��ʱˢ���¼�
		on_recv_monster_info = NULL_FUNC,	--������������
		on_recv_attack_monster = NULL_FUNC,	--��������
		send_attack_monster_result = NULL_FUNC,--���͹������޽��
		init_attack_ph = NULL_FUNC,	--��ʼ�����а�
		on_recv_attack_ph_list = NULL_FUNC,	--�������а�
		get_my_pm = NULL_FUNC,	--���Լ������а�
		send_ph_list = NULL_FUNC,	--�������а�
		on_recv_activity_stat = NULL_FUNC,	--����ʱ��״̬
		on_recv_activation = NULL_FUNC,	--����򿪻���
		send_monster_stat = NULL_FUNC,	--֪ͨ�û�,����״̬
		on_recv_buy_fire = NULL_FUNC,	--��������
		send_buy_gun_result = NULL_FUNC,	--���͹������ڽ��
		on_recv_gun_info = NULL_FUNC,	--֪ͨ�ͻ��ˣ����ر��ڡ��̻������ڵ���Ϣ
		send_gun_info = NULL_FUNC,	--���ͱ��ڡ��̻������ڵ���Ϣ
		on_recv_exorcist_packs = NULL_FUNC,	--֪ͨ����ˣ�������ȡ����ħ�����
 		send_exorcist_packs_result = NULL_FUNC,	--����������ȡ����ħ��������
 		sync_dragon_blood = NULL_FUNC,		--ͬ����������ֵ
		read_dragon_blood = NULL_FUNC,			--��ȡ��������ֵ
		write_dragon_blood = NULL_FUNC,			--������������ֵ
		send_my_hurt = NULL_FUNC,		--�����ҵ��˺�
		query_db = NULL_FUNC,		--��ѯ������Լ�����
 		autoNotifyClientForStart = NULL_FUNC,  --�Զ�֪ͨ�ͻ��˻ʱ�䵽��
        refresh_invate_time = -1,  --��һ��ˢ��ʱ��
        
        play1_num = 20,    --��������
        play2_num = 40,    --�̻�����
        
        blood = 600000,	--��Ѫ����gs�ϵ�ȫ�ֱ��� 
		last_blood = 0,	-- �ϴ�ͬ��ʱѪ����ֵ 
		add_blood = 0,	-- ��Ѫ���仯��ֵ 
        
        attack_ph_list = {}, --������������
 		
 		player_count = 3,		--ÿ�����������
 		
        activ1_statime = "2012-06-21 09:00:00",  --���ʼʱ��
    	activ1_endtime = "2012-06-27 24:00:00",  --�����ʱ��
    	rank_endtime = "2012-06-29 00:00:00",	--���а����ʱ��
    }    
 end
 
 --ͬ����������ֵ
 --
function newyear_lib.sync_dragon_blood() 
	local function set_this_gameserver_blood(tmp_blood) 
		newyear_lib.last_blood = tmp_blood; 
		--TraceError("ͬ����������ֵ,֮ǰ,newyear_lib.blood:"..newyear_lib.blood.." newyear_lib.last_blood:"..newyear_lib.last_blood.." newyear_lib.add_blood:"..newyear_lib.add_blood)
		newyear_lib.blood = newyear_lib.last_blood - newyear_lib.add_blood; 
		set_param_value("DRAGON_BLOOD",newyear_lib.blood);
		--TraceError("ͬ����������ֵ,֮ǰ,newyear_lib.blood:"..newyear_lib.blood.." newyear_lib.last_blood:"..newyear_lib.last_blood.." newyear_lib.add_blood:"..newyear_lib.add_blood) 
		newyear_lib.add_blood=0; 
	end 
	get_param_value("DRAGON_BLOOD",set_this_gameserver_blood) 
end 

--��ȡ��������ֵ
function newyear_lib.read_dragon_blood()
	local monster_value = 0
	local sql = "SELECT param_value FROM cfg_param_info WHERE param_key = 'DRAGON_BLOOD'"
	sql = string.format(sql);
	dblib.execute(sql,
    function(dt)
    	if dt and #dt > 0 then
    		monster_value = dt[1]["param_value"] or 0
    		if(monster_value > newyear_lib.blood)then
    			--TraceError("��ȡ��������ֵ,monster_value > newyear_lib.blood,,monster_value:"..monster_value.." newyear_lib.blood:"..newyear_lib.blood)
    			return
    		end
    		--TraceError("��ȡ��������ֵ,monster_value С�� newyear_lib.blood,,monster_value:"..monster_value.." newyear_lib.blood:"..newyear_lib.blood)
    		newyear_lib.blood = monster_value
		end
	end)
end

--������������ֵ
function newyear_lib.write_dragon_blood(monster_value)
	--�������ݿ�
	local sqltemplet = "update cfg_param_info set param_value = %d WHERE param_key = 'DRAGON_BLOOD'";             
	dblib.execute(string.format(sqltemplet, monster_value))
end

 
--�û���½���ʼ������
newyear_lib.on_after_user_login = function(e)
	local user_info = e.data.userinfo
	--TraceError("�û���½���ʼ������,userid:"..user_info.userId)
	if(user_info == nil)then 
		--TraceError("�û���½���ʼ������,if(user_info == nil)then")
	 	return
	end
	
	local check_result = newyear_lib.check_datetime()	--���ʱ��
	
	
	--���ر��ڡ��̻�������
--	if(tex_gamepropslib ~= nil) then
 --       tex_gamepropslib.get_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_1_ID, user_info, function(tool_count) end)
 --       tex_gamepropslib.get_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_2_ID, user_info, function(tool_count) end)
 --       tex_gamepropslib.get_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_3_ID, user_info, function(tool_count) end)
 --   end
  
     --��ʼ���û�����
    if(user_info.newyear_play_count == nil)then
    	user_info.newyear_play_count = 0
    end
    
    --��ʼ���û��˺�ֵ
    if(user_info.newyear_attack_value == nil)then
    	user_info.newyear_attack_value = 0
    end
    
    --��ʼ���û���ħ�����ȡ���
    if(user_info.newyear_libao_sign == nil)then
    	user_info.newyear_libao_sign = 0
    end
    --���ʱ��ź�����Ϊ�˻ʱ�䵽�˿�����Ӧ�����û�������
	if(check_result == 0 or check_result == 5)then
		--TraceError("�û���½���ʼ������,if(check_result == 0 and check_result == 5)then")
		return
	end
	--��ѯ������Լ�����
	newyear_lib.query_db(user_info)
    
end

--��ѯ������Լ�����
function newyear_lib.query_db(user_info)
	local _tosqlstr = function(s) 
		s = string.gsub(s, "\\", " ") 
		s = string.gsub(s, "\"", " ") 
		s = string.gsub(s, "\'", " ") 
		s = string.gsub(s, "%)", " ") 
		s = string.gsub(s, "%(", " ") 
		s = string.gsub(s, "%%", " ") 
		s = string.gsub(s, "%?", " ") 
		s = string.gsub(s, "%*", " ") 
		s = string.gsub(s, "%[", " ") 
		s = string.gsub(s, "%]", " ") 
		s = string.gsub(s, "%+", " ") 
		s = string.gsub(s, "%^", " ") 
		s = string.gsub(s, "%$", " ") 
		s = string.gsub(s, ";", " ") 
		s = string.gsub(s, ",", " ") 
		s = string.gsub(s, "%-", " ") 
		s = string.gsub(s, "%.", " ") 
		return s 
	end
	
	local user_nick=user_info.nick
	user_nick=_tosqlstr(user_nick).."   "
	
	--��ѯ��������ݿ�
	local sql = "insert ignore into t_attack_monster_rank (user_id, user_nick, sys_time) values(%d, '%s', now());commit;";
    sql = string.format(sql, user_info.userId, user_nick);
	dblib.execute(sql)
	
	local sql_1 = "select sys_time,attack_value,libao_sign,play_count from t_attack_monster_rank where user_id = %d"
	sql_1 = string.format(sql_1, user_info.userId);
	
	dblib.execute(sql_1,
    function(dt)
    	if dt and #dt > 0 then

    		local sys_today = os.date("%Y-%m-%d", os.time()); --ϵͳ�Ľ���
            local db_date = os.date("%Y-%m-%d", timelib.db_to_lua_time(dt[1]["sys_time"]));  --���ݿ�Ľ���
            user_info.newyear_attack_value = dt[1]["attack_value"] or 0
            user_info.newyear_libao_sign = dt[1]["libao_sign"] or 0
            
            if (db_date ~= sys_today) then
				user_info.newyear_play_count = 0
            else
            	user_info.newyear_play_count = dt[1]["play_count"] or 0
            
            end
  
    	else
			--TraceError("�û���½���ʼ������,��ѯ��������ݿ�->ʧ��")
    	end
    
    end)
end
 	
--�����Чʱ�䣬��ʱ����
function newyear_lib.check_datetime()
	local sys_time = os.time();
	
	--�1ʱ��
	--if(activ_type == 1)then
		local statime = timelib.db_to_lua_time(newyear_lib.activ1_statime);
		local endtime = timelib.db_to_lua_time(newyear_lib.activ1_endtime);
		local rank_endtime = timelib.db_to_lua_time(newyear_lib.rank_endtime);
		----TraceError("statime->"..statime.." endtime->"..endtime.." rank_endtime->"..rank_endtime.." sys_time->"..sys_time)
		if(sys_time >= statime and sys_time <= endtime) then
		    return 1;
		end
		
		if(sys_time > endtime and sys_time <= rank_endtime) then
			return 5; --��������������а�ͼ�걣��1�����ʧ��
		end
	--end
 
	--�ʱ���ȥ��
	return 0;
end


--��Ϸ�����ɼ�����
newyear_lib.ongameover = function(user_info,addgold,player_count)
--�һ������FUN��
--[[
�������̣�
1��ÿ����20�̵õ����ڣ�����VIP1-3��������ͨVIP���ƽ�VIP����ñ���*2������VIP4-5��������ʯVIP����ñ���*3

2��ÿ���湻40�̵õ��̻�������VIP1-3��������ͨVIP���ƽ�VIP������̻�*2������VIP4-5��������ʯVIP������̻�*3



5����ʾ������������������ʽΪ�����ڡ�1�� 

6������Ƶ������Ϸ�����ʾ������TIPS,�������ơ���������Ʒ���˺�
 
]]

 	--TraceError(play_count.." ��Ϸ�����ɼ�����,userId:"..user_info.userId)
	if not user_info or not user_info.desk or player_count < newyear_lib.player_count  then return end;
	 
	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError(" ��Ϸ�����ɼ�����->ʱ����Ч��->if(check_time == 0 and check_time == 5)-- userid:"..user_info.userId)
        return;
    end
  
    --�ж��û��ܿ�����
    if(user_info.newyear_play_count > 40 )then 
		--TraceError(" ��Ϸ�����ɼ�����,> 40  userid:"..user_info.userId)
		return;    
    
    end    
 
    local play_count = user_info.newyear_play_count or 0
    --�ۼӾ���
    play_count = play_count + 1;
	--gamedata.playgameinfo.play_num = play_count;
	user_info.newyear_play_count = play_count
  
   --֪ͨ�ͻ���
   newyear_lib.net_send_playnum(user_info, check_time, play_count);
   
   --�����20�̵õ����ڣ�����VIP1-3 ��ñ���*2������VIP4-5 ��ñ���*3
   --ÿ���湻40�̵õ��̻�������VIP1-3 ����̻�*2������VIP4-5 ����̻�*3
   	--���ͱ��ڡ��̻������ڵ���Ϣ   	
   	local gun1_value = 0	--����
	local gun2_value = 0	--�̻�
	local gun3_value = 0	--����
	local vip_level = viplib.get_vip_level(user_info);
	
   	if(play_count == newyear_lib.play1_num)then	--��20��
  		
  		gun2_value = user_info.propslist[5]	--�̻�
	   	gun3_value = user_info.propslist[6]	--����
	   	
	   	local complete_callback_func = function(tools_count)
       	 	gun1_value = user_info.propslist[4]	--����
	   	 	--TraceError(" ��Ϸ�����ɼ�����,= 20 --��VIP userid:"..user_info.userId.."����:"..gun1_value.."�̻�:"..gun2_value.."����"..gun3_value)
			newyear_lib.send_gun_info(user_info, gun1_value, gun2_value, gun3_value)
    	end
	   	
   		if(not viplib.check_user_vip(user_info))then	--��VIP
   			--�ӱ���
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_1_ID, 1, user_info, complete_callback_func)
   		 
   		elseif(vip_level < 4)then  --VIP
   			--�ӱ���
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_1_ID, 2, user_info, complete_callback_func)
   			 
   		elseif(vip_level == 4 or vip_level == 5)then  --VIP4��5
   			--�ӱ���
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_1_ID, 3, user_info, complete_callback_func)
   		elseif(vip_level == 6) then
	   		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_1_ID, 6, user_info, complete_callback_func)	 
   		end
   		 
	elseif(play_count == newyear_lib.play2_num)then	--��40��
		gun1_value = user_info.propslist[4]	--����
	   	gun3_value = user_info.propslist[6]	--����
	   	
	   	local complete_callback_func = function(tools_count)
       		gun2_value = user_info.propslist[5]	--�̻�
	   		--TraceError(" ��Ϸ�����ɼ�����,= 40 --VIP4��5 userid:"..user_info.userId.." ����:"..gun1_value.." �̻�:"..gun2_value.." ����"..gun3_value)
			newyear_lib.send_gun_info(user_info, gun1_value, gun2_value, gun3_value)
   		
    	end
    	
		if(not viplib.check_user_vip(user_info))then	--��VIP
  			--���̻�
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_2_ID, 1, user_info, complete_callback_func)
	    
   		elseif(vip_level < 4)then  --VIP
  			--���̻�
	   	 	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_2_ID, 2, user_info, complete_callback_func)
   		elseif(vip_level == 4 or vip_level == 5 )then  --VIP4��5
  			--���̻�
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_2_ID, 3, user_info, complete_callback_func)
	   	elseif(vip_level == 6) then
	   		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_2_ID, 6, user_info, complete_callback_func)
   		end
   		
   	else
   		--TraceError(" ��Ϸ�����ɼ�����, userid:"..user_info.userId.." ����:"..gun1_value.." �̻�:"..gun2_value.." ����"..gun3_value.." play_count:"..play_count)
   		gun1_value = user_info.propslist[4] or 0	--����
		gun2_value = user_info.propslist[5]	or 0	--�̻�
		gun3_value = user_info.propslist[6]	or 0	--����
   		 	
	end
	
	--��¼�����ݿ�
    local sqltemplet = "INSERT IGNORE INTO t_attack_monster_rank(user_id,user_nick) VALUE (%d,'%s');update t_attack_monster_rank set play_count = %d, gun1_attack_num = %d, gun2_attack_num = %d, gun3_attack_num = %d, sys_time = now() where user_id = %d;commit;";
    local sql=string.format(sqltemplet,user_info.userId,string.trans_str(user_info.nick), play_count, gun1_value,gun2_value,gun3_value,user_info.userId);
    dblib.execute(sql);
	
end

newyear_lib.autoNotifyClientForStart = function(min)
	local now_time = os.date("*t",os.time());
	local hd_start_time = os.date("*t",timelib.db_to_lua_time(newyear_lib.activ1_statime));
	
	if(now_time.year == hd_start_time.year and now_time.month == hd_start_time.month and now_time.day == hd_start_time.day and now_time.hour == hd_start_time.hour and min == hd_start_time.min ) then
		--֪ͨ�ͻ���
		for k, v in pairs(userlist) do
   			newyear_lib.net_send_playnum(v, 1, 0);
   		end
	end
end

--��ʱˢ���¼�
newyear_lib.ontimecheck = function(e)
 
 	--��鲢����֪ͨ�ͻ��˻����
 	newyear_lib.autoNotifyClientForStart(e.data.min);
 	
  	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
        return;
    end
  
  	
  	
  	--10����Ҫˢһ������ ��  ������������
	if(newyear_lib.refresh_invate_time == -1 or os.time() > newyear_lib.refresh_invate_time+60*10)then
	--if(newyear_lib.refresh_invate_time == -1 or os.time() > newyear_lib.refresh_invate_time+10*1)then
		--TraceError("��ʱˢ���¼���10����Ҫˢһ������ ");
    	newyear_lib.refresh_invate_time = os.time();
    	newyear_lib.init_attack_ph();
    	
    	--newyear_lib.sync_dragon_blood() --������������
    	newyear_lib.read_dragon_blood()		--��ȡ��������ֵ
    end
   
   local now_time = os.date("*t",os.time());
   if(now_time.hour == 0 and e.data.min == 0) then --ÿ���賿���������
   		for k,v in pairs(userlist) do
   			newyear_lib.net_send_playnum(v,check_time,0);
   			v.newyear_play_count = 0;
   		end
   end
end

--������������
function newyear_lib.on_recv_monster_info(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("������������,USERID:"..user_info.userId)
   
   	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("������������,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
     
    --֪ͨ�û�,����״̬
    local monster_now_value = newyear_lib.blood
	newyear_lib.send_monster_stat(user_info, 600000, monster_now_value)
	
end

--��������
function newyear_lib.on_recv_attack_monster(buf)
--[[
1��������ڡ��̻�����������������������������ʣ������-1
 

3�������˺�ֵ��Ѫ���ֶ������硰-13��������������ֵ��Ӧ����

4����ǰ�����������ʹ��������Ӧ�������������������ʾ���ȡһ����̫�����ˣ����600��ң���/�����������1���ң���/�����������1���ң���,3����ʧ

5�����1����/1��������ϵĽ���ϵͳ�㲥����XXXXϮ�����ޣ����1���ҽ�������

��������

1����������Ϊ0ʱ������Ϊ��ɫ���ܵ��

�����Ʒ�� 
1.���ڴ�������ȯ 
2.200���� 
3.1K���� 
4.1����� 
5.5����� 
6.10����� 
7.20����� 
8.50����� 
9.100����� 
10.10����ҩˮ 
11.С���� 
12.T�� 
13.���֣���� 
14.������������� 
15.888����ͧ
16.���ڴ�������ȯ *5
17.T��*2
18.С����*3

]]	
	local _tosqlstr = function(s) 
		s = string.gsub(s, "\\", " ") 
		s = string.gsub(s, "\"", " ") 
		s = string.gsub(s, "\'", " ") 
		s = string.gsub(s, "%)", " ") 
		s = string.gsub(s, "%(", " ") 
		s = string.gsub(s, "%%", " ") 
		s = string.gsub(s, "%?", " ") 
		s = string.gsub(s, "%*", " ") 
		s = string.gsub(s, "%[", " ") 
		s = string.gsub(s, "%]", " ") 
		s = string.gsub(s, "%+", " ") 
		s = string.gsub(s, "%^", " ") 
		s = string.gsub(s, "%$", " ") 
		s = string.gsub(s, ";", " ") 
		s = string.gsub(s, ",", " ") 
		s = string.gsub(s, "%-", " ") 
		s = string.gsub(s, "%.", " ") 
		return s 
	end

	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("��������,USERID:"..user_info.userId)
   
   	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("��������,ʱ����ڣ� USERID:"..user_info.userId)
    	newyear_lib.send_attack_monster_result(user_info, -1, -1)
        return;
    end
     
    --�յ��Ĺ���id
    local attack_id = buf:readByte();
    
	local gun1_value = user_info.propslist[4] or 0	--����
	local gun2_value = user_info.propslist[5] or 0	--�̻�
	local gun3_value = user_info.propslist[6] or 0	--����
  
  	local result = 0
  	local award_id = 0  --�����ƷID
  	
  
    --�����˺���+1
	--�̻��˺���+3
	--�����˺���+10
 
 	--TraceError("��������֮ǰ   newyear_lib.add_blood��"..newyear_lib.add_blood.."  newyear_lib.blood:"..newyear_lib.blood.." attack_id:"..attack_id);
	local monster_life_value = newyear_lib.blood	--��������ֵ
	local attack_value = 0	--����ֵ
	
	--������ɽ�ƷID
	local function spring_gift(user_info, attack_id)
		 
        	local sql = format("call sp_get_random_spring_gift(%d, '%s', %d)", user_info.userId, "tex", attack_id)
        	dblib.execute(sql, function(dt)
            	if(dt and #dt > 0)then
            		local prizeid = dt[1]["gift_id"]
	               -- local award_name = dt[1]["gift_des"] or ""
	                --TraceError("��������,������������ɽ�ƷID:"..prizeid.." USERID:"..user_info.userId)
	                if(prizeid == nil or prizeid <= 0) then
	                	--TraceError("��������,������������ɽ�ƷID,ʧ��")
	                    return 
	                end 
 	 
 					--����
		 			if(attack_id == 1)then
			   			--ת����Ӧ��ƷID
			            if(prizeid == 1)then	--200����
			            	award_id = 2	
			            	--��200����
			  				usermgr.addgold(user_info.userId, 200, 0, g_GoldType.baoxiang, -1);
			  				
			            elseif(prizeid == 2)then	--1K����
			            	award_id = 3	
			            	--��1K����
			  				usermgr.addgold(user_info.userId, 1000, 0, g_GoldType.baoxiang, -1);
			  				
			            elseif(prizeid == 3)then	--���ڴ�������ȯ 
			            	award_id = 1	
			            	--�Ӵ��ڴ�������ȯ 
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.NewYearTickets_ID, 1, user_info)
			  	
			            elseif(prizeid == 4)then	--С����
			            	award_id = 11	
			            	--С������ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info)
			  	
			            elseif(prizeid == 5)then	--����������
			            	award_id = 13	
			            	--�ӡ���������
			  				gift_addgiftitem(user_info,9014,user_info.userId,user_info.nick, false)
			  				
			            elseif(prizeid == 6)then	--5�����
			            	award_id = 5
			            	--��5�����
			  				usermgr.addgold(user_info.userId, 50000, 0, g_GoldType.baoxiang, -1);
			  				
			  				--ϵͳ�㲥����XXXXϮ�����ޣ����***��������
			  				local user_nick=user_info.nick
							user_nick=_tosqlstr(user_nick).."   "
							local msg = tex_lan.get_msg(user_info, "newyear_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "lz_activity_msg_awards"); 
							msg1 = string.format(msg1,5); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			  				
			  			elseif(prizeid == 0)then	--�쳣
			  				--TraceError("��������,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
			  				return
			            end	
			        elseif(attack_id == 2)then
			        	--ת����Ӧ��ƷID
			            if(prizeid == 1)then	--1K����
			            	award_id = 3	
			            	--��1K����
			  				usermgr.addgold(user_info.userId, 1000, 0, g_GoldType.baoxiang, -1);
			  				
			            elseif(prizeid == 2)then	--1W����
			            	award_id = 4	
			            	--��1W����
			  				usermgr.addgold(user_info.userId, 10000, 0, g_GoldType.baoxiang, -1);
			  				
			            elseif(prizeid == 3)then	--���ڴ�������ȯ 
			            	award_id = 1	
			            	--�Ӵ��ڴ�������ȯ 
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.NewYearTickets_ID, 1, user_info)
			  	
			            elseif(prizeid == 4)then	--T�˿�
			            	award_id = 12
			            	--T�˿���ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info)
			  	
			            elseif(prizeid == 5)then	--�������������
			            	award_id = 14
			            	--�ӡ������������
			  				gift_addgiftitem(user_info,9015,user_info.userId,user_info.nick, false)
			  				
			            elseif(prizeid == 6)then	--50�����
			            	award_id = 8
			            	--��50�����
			  				usermgr.addgold(user_info.userId, 500000, 0, g_GoldType.baoxiang, -1);
			  				local user_nick=user_info.nick
							user_nick=_tosqlstr(user_nick).."   "
							local msg = tex_lan.get_msg(user_info, "newyear_activity_msg_awards_1");
							local msg1 = tex_lan.get_msg(user_info, "lz_activity_msg_awards"); 
							msg1 = string.format(msg1,50); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			  				
			  			elseif(prizeid == 0)then	--�쳣
			  				--TraceError("��������,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
			  				return
			            end	
			   		elseif(attack_id == 3)then
			   			--ת����Ӧ��ƷID
			            if(prizeid == 1)then	--���ڴ�������ȯ 
			            	award_id = 16  --16.���ڴ�������ȯ *5  	
			            	--�Ӵ��ڴ�������ȯ 
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.NewYearTickets_ID, 5, user_info)
			          
			            elseif(prizeid == 2)then	--5�����
			            	award_id = 5	
			            	--��5�����
			  				usermgr.addgold(user_info.userId, 50000, 0, g_GoldType.baoxiang, -1);
			  				
			  				--ϵͳ�㲥����XXXXϮ�����ޣ����***��������
			  				local user_nick = user_info.nick
							user_nick=_tosqlstr(user_nick).."   "
			  				local msg = tex_lan.get_msg(user_info, "newyear_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "lz_activity_msg_awards"); 
							msg1 = string.format(msg1,5); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			  				 
			            elseif(prizeid == 3)then	--20�����
			            	award_id = 7	
			            	--��20�����
			  				usermgr.addgold(user_info.userId, 200000, 0, g_GoldType.baoxiang, -1);
			  				
			  				--ϵͳ�㲥����XXXXϮ�����ޣ����***��������
			  				local user_nick = user_info.nick
							user_nick=_tosqlstr(user_nick).."   "
							local msg = tex_lan.get_msg(user_info, "newyear_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "lz_activity_msg_awards"); 
							msg1 = string.format(msg1,20); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			  	
			  			elseif(prizeid == 4)then	--100�����
			            	award_id = 9	
			            	--��100�����
			  				usermgr.addgold(user_info.userId, 1000000, 0, g_GoldType.baoxiang, -1);
			  				
			  				--ϵͳ�㲥����XXXXϮ�����ޣ����***��������
			  				local user_nick = user_info.nick
							user_nick=_tosqlstr(user_nick).."   "
							local msg = tex_lan.get_msg(user_info, "newyear_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "lz_activity_msg_awards"); 
							msg1 = string.format(msg1,100); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			  				
			  			elseif(prizeid == 5)then	--����ͧ
			            	award_id = 15	
			            	--����ͧ
							gift_addgiftitem(user_info,5023,user_info.userId,user_info.nick, false)	
							local user_nick=user_info.nick
							user_nick=_tosqlstr(user_nick).."   "
							local msg = tex_lan.get_msg(user_info, "newyear_activity_msg_awards_1");
							local msg1 = tex_lan.get_msg(user_info, "lz_activity_msg_awards1"); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
						elseif(prizeid == 6)then	--T�˿�
			            	award_id = 17	--17.T��*2
			            	--T�˿���ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 2, user_info)
			 
			            elseif(prizeid == 7)then	--С����
			            	award_id = 18		--18.С����*3
			            	--С������ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 3, user_info)
			  	 
			  			elseif(prizeid == 0)then	--�쳣
			  				--TraceError("��������,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
			  				return
			            end	
				    end
				   
				   --���͹������޳ɹ����
			    	result = attack_value
			    	--TraceError("�������޳ɹ�,--�� USERID:"..user_info.userId.." result:"..result.." award_id:"..award_id.." monster_life_value:"..monster_life_value.." gun1_value:"..gun1_value.." gun2_value:"..gun2_value.." gun3_value:"..gun3_value.." attack_id:"..attack_id)
					newyear_lib.send_attack_monster_result(user_info, result, award_id)
					
					--֪ͨ�ͻ��ˣ����±��ڡ��̻������ڵ���Ϣ
 					newyear_lib.send_gun_info(user_info, gun1_value, gun2_value, gun3_value)
	            end
	        end)
	   
	end
  	
   	if(attack_id == 1)then	--����
   		
   		if(gun1_value > 0)then
   			attack_value = 1	--�����˺���+1
   			
   			--������������ֵ
   			monster_life_value = monster_life_value - attack_value	  
   			newyear_lib.blood = newyear_lib.blood - attack_value
   			if(monster_life_value <= 0)then
   				monster_life_value = 0
   			end
   			if(newyear_lib.blood <= 0)then
   				newyear_lib.blood = 0
   			end
   			newyear_lib.write_dragon_blood(monster_life_value)	--д���ݿ�
   			
   			--�����û�����ֵ
   			user_info.newyear_attack_value = user_info.newyear_attack_value + attack_value
 
   			--������
   			gun1_value = gun1_value -1
   			user_info.propslist[4] = gun1_value
   			
   			local complete_callback_func = function(tools_count)
      			--������ɽ�ƷID
   				spring_gift(user_info, attack_id)
    		end
   			tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_1_ID, -1, user_info, complete_callback_func)
     
   		else
   			--TraceError("��������,--���ڲ��㣬 USERID:"..user_info.userId)
   			--���͹�������ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			newyear_lib.send_attack_monster_result(user_info, result, award_id)
	        return;
   		end
       
    elseif(attack_id == 2)then	--�̻�
    
    	if(gun2_value > 0)then
   			attack_value = 3	--�̻��˺���+3
   			
   			--������������ֵ
   			monster_life_value = monster_life_value - attack_value	  
   			newyear_lib.blood = newyear_lib.blood - attack_value
   			if(monster_life_value <= 0)then
   				monster_life_value = 0
   			end
   			if(newyear_lib.blood <= 0)then
   				newyear_lib.blood = 0
   			end
   			newyear_lib.write_dragon_blood(monster_life_value)	--д���ݿ�	
   			
   			--�����û�����ֵ
   			user_info.newyear_attack_value = user_info.newyear_attack_value + attack_value
 
   			--���̻�
   			gun2_value = gun2_value -1
   			user_info.propslist[5] = gun2_value
   			
   			local complete_callback_func = function(tools_count)
      	 		--������ɽ�ƷID
   				spring_gift(user_info, attack_id)
   			end
   			tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_2_ID, -1, user_info, complete_callback_func)
     
   		else
   			--TraceError("��������,--�̻����㣬 USERID:"..user_info.userId)
   			--���͹�������ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			newyear_lib.send_attack_monster_result(user_info, result, award_id)
	        return;
   		end
    elseif(attack_id == 3)then	--����
    	if(gun3_value > 0)then
   			attack_value = 10	--�����˺���+10
   			 
   			--������������ֵ
   			monster_life_value = monster_life_value - attack_value	  
   			newyear_lib.blood = newyear_lib.blood - attack_value
   			if(monster_life_value <= 0)then
   				monster_life_value = 0
   			end
   			if(newyear_lib.blood <= 0)then
   				newyear_lib.blood = 0
   			end
   			newyear_lib.write_dragon_blood(monster_life_value)	--д���ݿ�
   			
   			--�����û�����ֵ
   			user_info.newyear_attack_value = user_info.newyear_attack_value + attack_value
 
   			--������
   			gun3_value = gun3_value -1
   			user_info.propslist[6] = gun3_value
   			
   			local complete_callback_func = function(tools_count)
      	 		--������ɽ�ƷID
   				spring_gift(user_info, attack_id)
	 
    		end
   			tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_3_ID, -1, user_info, complete_callback_func)
     
   		else
   			--TraceError("��������,--���ڲ��㣬 USERID:"..user_info.userId)
   			--���͹�������ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			newyear_lib.send_attack_monster_result(user_info, result, award_id)
	        return;
   		end
    else
    	
    	--TraceError("�������ޣ��յ�����Ĺ���id");
    	--���͹������޽��
    	result = 0
    	award_id = -1
		newyear_lib.send_attack_monster_result(user_info, result, award_id)
        return;
   	end
   
   	--TraceError("�������޽��   newyear_lib.add_blood��"..newyear_lib.add_blood.."  newyear_lib.blood:"..newyear_lib.blood.." newyear_attack_value:"..user_info.newyear_attack_value);
 
	--���¹���,��������
    local sqltemplet = "update t_attack_monster_rank set attack_value = %d, gun1_attack_num = %d, gun2_attack_num = %d, gun3_attack_num = %d where user_id = %d;commit;";
    local sql=string.format(sqltemplet, user_info.newyear_attack_value, gun1_value,gun2_value,gun3_value,user_info.userId);
    dblib.execute(sql);
 	
 	newyear_lib.send_my_hurt(user_info,user_info.newyear_attack_value);
end

--��ʼ�����а�
function newyear_lib.init_attack_ph()
--[[
�鿴�˺�����

�������̣�
1������������ʾǰ50����ҵ��˺�����

2��������ǩΪ �������ǳƣ�֧�����16�ַ������˺�ֵ��֧��6λ���֣������������10���ַ���

4���������·���ʾ�Լ��˺�ֵ��������Ӧ�ý�������

 4.1 �ϰ���ʾΪ����X����

 4.2 û�ϰ���ʾΪ��δ�ϰ�

 4.3 �н�����ȡǰ50������

 4.4 �޽�������ʾ���ޡ�

��������

1���˺�ֵ=ȼ���̻�����*20+ȼ�ű�������*10+ȼ����������*100

2��ͬ�˺���ʱ����

3��ǰ50�������ڻ�������˹�����

4������10���Ӹ���1��


]]
 
	--TraceError("-->>>>��ʼ�����а�")
 
	--��ʼ������
	
	local sql="select user_id,user_nick,attack_value from t_attack_monster_rank where attack_value >= 1 order by attack_value desc LIMIT 50"
	sql=string.format(sql)
	dblib.execute(sql,function(dt)	
			if(dt~=nil and  #dt>0)then
				newyear_lib.attack_ph_list = {}
				for i=1,#dt do
					local bufftable ={
					  	    mingci = i, 
		                    user_id = dt[i].user_id,
		                    nick_name=dt[i].user_nick,
		                    attack_value=dt[i].attack_value,   
	                }	                
					table.insert(newyear_lib.attack_ph_list,bufftable)
				end
			end
    end)
   
    
    --��ʼ��������������
    --init_ph(newyear_lib.attack_ph_list)
 
end

--�������а�
function newyear_lib.on_recv_attack_ph_list(buf)
	local user_info = userlist[getuserid(buf)]; 
	if not user_info then return end;
	--TraceError("--�������а�,userid:"..user_info.userId)
 
   	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0) then
    	--TraceError("�������а�,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
 
	local mc = -1; --���ڼ����Լ�������
	local attack_value = 0; --���ڼ����Լ��Ĺ����ɼ�
 
	local attack_paimin_list = newyear_lib.attack_ph_list
	
	if(user_info == nil)then return end
	
	--��ѯ�Լ������Σ����û�����ξͷ���-1
	--�������Σ��ҵĹ����ɼ�
	local my_mc = -1;
	local my_attack_value = 0;
 
	--���Լ������а�
	my_mc,my_attack_value = newyear_lib.get_my_pm(attack_paimin_list,user_info)
	
	local libao_sign = user_info.newyear_libao_sign		----�Ƿ���ȡ�ˡ���ħ��������
 
 	--�������а�
	newyear_lib.send_ph_list(user_info, libao_sign, my_attack_value, my_mc, attack_paimin_list)  
end

--���Լ������а�
newyear_lib.get_my_pm = function(ph_list,user_info)

		local mc=-1
		if (ph_list==nil) then return -1,0 end
		
		for i=1,#ph_list do
			if(ph_list[i].user_id==user_info.userId)then
				return i,ph_list[i].attack_value
			end
		end

		return -1,0;--û���ҵ���Ӧ��ҵļ�¼����Ϊ��û�гɼ�
end

--����ʱ��״̬
function newyear_lib.on_recv_activity_stat(buf)
	
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
 
	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
	
	--TraceError("--����ʱ��״̬-->>"..check_time)
	
	if(check_time == 0)then
		return
	end
	
	--�ж��Ƿ�������
	local gun1_value = user_info.propslist[4] or 0	--����
	local gun2_value = user_info.propslist[5] or 0	--�̻�
	local gun3_value = user_info.propslist[6] or 0	--����
	if(gun1_value > 0 or gun2_value > 0 or gun3_value >0)then
		check_time = 2;		--���Ч,������
	end
	
	local play_count = 0
	--�û�����
    if(user_info.newyear_play_count == nil)then
    	user_info.newyear_play_count = 0	
    	play_count = 0
    else
    	play_count = user_info.newyear_play_count
    end
 
 	--֪ͨ�ͻ���
   newyear_lib.net_send_playnum(user_info, check_time, play_count);
  
end

--����򿪻���
function newyear_lib.on_recv_activation(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	local _tosqlstr = function(s) 
		s = string.gsub(s, "\\", " ") 
		s = string.gsub(s, "\"", " ") 
		s = string.gsub(s, "\'", " ") 
		s = string.gsub(s, "%)", " ") 
		s = string.gsub(s, "%(", " ") 
		s = string.gsub(s, "%%", " ") 
		s = string.gsub(s, "%?", " ") 
		s = string.gsub(s, "%*", " ") 
		s = string.gsub(s, "%[", " ") 
		s = string.gsub(s, "%]", " ") 
		s = string.gsub(s, "%+", " ") 
		s = string.gsub(s, "%^", " ") 
		s = string.gsub(s, "%$", " ") 
		s = string.gsub(s, ";", " ") 
		s = string.gsub(s, ",", " ") 
		s = string.gsub(s, "%-", " ") 
		s = string.gsub(s, "%.", " ") 
		return s 
	end
	
   	--TraceError("����򿪻���,USERID:"..user_info.userId)
   
   	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time ~= 1 and check_time ~= 5) then
    	--TraceError("����򿪻���,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
    
    --��ʼ������¹�����
 	
	local user_nick=user_info.nick
	user_nick=_tosqlstr(user_nick)
	local sql = "insert ignore into t_attack_monster_rank (user_id, user_nick, attack_value) ";
    sql = sql.."values(%d, '%s   ', %d);commit;";   
    sql = string.format(sql, user_info.userId, user_nick, 0);
	dblib.execute(sql)
	
	--֪ͨ�û�,����״̬
	local monster_now_value = newyear_lib.blood	--��������ֵ
	newyear_lib.send_monster_stat(user_info, 600000, monster_now_value)
	
	--�����û����ڡ��̻������ڵ���Ϣ
	local gun1_value = user_info.propslist[4] or 0	--����
	local gun2_value = user_info.propslist[5] or 0	--�̻�
	local gun3_value = user_info.propslist[6] or 0	--����
	newyear_lib.send_gun_info(user_info, gun1_value, gun2_value, gun3_value)
	
	
	--�������а�
	--���Լ������а�
	local attack_paimin_list = newyear_lib.attack_ph_list	--���а�����
	local my_mc = -1;
	local my_attack_value = 0;
	my_mc,my_attack_value = newyear_lib.get_my_pm(attack_paimin_list,user_info)
	local libao_sign = user_info.newyear_libao_sign		----�Ƿ���ȡ�ˡ���ħ��������
	newyear_lib.send_ph_list(user_info, libao_sign, user_info.newyear_attack_value or my_attack_value, my_mc, attack_paimin_list)
	
	--��ѯ������Լ�����
	newyear_lib.query_db(user_info)
end

--��������
function newyear_lib.on_recv_buy_fire(buf)
--[[
3��������Ҫ����Ϸ��ֱ�ӹ��򣬵�������Եġ����򡿰�ť����

   3.1 Ǯ������ť�Ϸ����ֶ�����ʾ������ɹ����������*1������10000���롱

   3.2 Ǯ��������ťΪ��ɫ���������ȥTIP��ʾ����Ҳ��㡱/�����벻�㡱

   3.3 ����ʹ��������ĳ��빺�� �������в��ܹ��򣬹���ťΪ��ɫ���������ȥTIP��ʾ�����˳���������
 
  ]]
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("��������,USERID:"..user_info.userId)
   	
   	local gun3_value = 0
 	local result = 0
    local gold = get_canuse_gold(user_info)--����û�����

	gun3_value = user_info.propslist[6]	--����
	
   	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("��������,ʱ����ڣ� USERID:"..user_info.userId)
    	
    	--���͹������ڽ��
    	result = 2
		newyear_lib.send_buy_gun_result(user_info, gun3_value, result)
        return;
    end
 
    if(gold < 100000)then
    	--TraceError("��������,Ǯ������ USERID:"..user_info.userId)
    	
    	--���͹������ڽ��
    	result = 0
		newyear_lib.send_buy_gun_result(user_info, gun3_value, result)
    	return
    end
    
    --������
	usermgr.addgold(user_info.userId, -100000, 0, g_GoldType.baoxiang, -1);
	
	--������
	local complete_callback_func = function(tools_count)
      	--���͹������ڽ��
		gun3_value = user_info.propslist[6]	--����
		result = 1
		newyear_lib.send_buy_gun_result(user_info, gun3_value, result)
	 
    end
    
	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.GUN_3_ID, 1, user_info, complete_callback_func)
	
	
end

--֪ͨ�ͻ��ˣ����ر��ڡ��̻������ڵ���Ϣ
function newyear_lib.on_recv_gun_info(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("���ر��ڡ��̻������ڵ���Ϣ,USERID:"..user_info.userId)
   
   	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("���ر��ڡ��̻������ڵ���Ϣ,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
    
    --�����û����ڡ��̻������ڵ���Ϣ
	local gun1_value = user_info.propslist[4]	--����
	local gun2_value = user_info.propslist[5]	--�̻�
	local gun3_value = user_info.propslist[6]	--����
	newyear_lib.send_gun_info(user_info, gun1_value, gun2_value, gun3_value)
 
end

--֪ͨ����ˣ�������ȡ����ħ�����
function newyear_lib.on_recv_exorcist_packs(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("������ȡ����ħ�����,USERID:"..user_info.userId)
   
   	--�һ��ʱ����Ч��
	local check_time = newyear_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("������ȡ����ħ�����,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
    
    if(user_info.newyear_libao_sign == 1)then
    	--TraceError("������ȡ����ħ�����,������� USERID:"..user_info.userId)
    	return
    end
    
    local attack_value = user_info.newyear_attack_value
    local result = 0
    
    --�ҵĹ���ֵ����300ʱ����ȡ��ħ���
    if(attack_value > 300)then
    	--TraceError("������ȡ����ħ����� ��ȡ�ɹ�,USERID:"..user_info.userId.." attack_value:"..attack_value)
    	--�����ȡ
	    user_info.newyear_libao_sign = 1
	    
	    --�������ݿ�
	    local sqltemplet = "update t_attack_monster_rank set libao_sign = 1 where user_id = %d;commit;";             
		dblib.execute(string.format(sqltemplet, user_info.userId))
		
		--�ӻ��10����
		usermgr.addgold(user_info.userId, 100000, 0, g_GoldType.baoxiang, -1);
	 
		--����������ȡ����ħ��������
		result = 1
    	newyear_lib.send_exorcist_packs_result(user_info, result)
    	
    	--ϵͳ�㲥����XXXX��ȡ��ħ��������10���ң���
		local msg = tex_lan.get_msg(user_info, "newyear_activity_msg_awards_1"); 
		local msg1=tex_lan.get_msg(user_info, "newyear_activity_msg"); 
		msg1 = string.format(msg1); 
		BroadcastMsg(_U(msg)..user_info.nick.._U(msg1),0)
    else
    	--TraceError("������ȡ����ħ����� ʧ��,USERID:"..user_info.userId.." attack_value:"..attack_value)
    	--����������ȡ����ħ��������
    	newyear_lib.send_exorcist_packs_result(user_info, result)
    end
   
end


--����������ʱ��״̬
newyear_lib.net_send_playnum = function(user_info, check_time, play_count)
  	--TraceError(" ����������ʱ��״̬,userid:"..user_info.userId.." check_time->"..check_time.." play_count:"..play_count)
	netlib.send(function(buf)
	    buf:writeString("HDNYNSDATE")
	    buf:writeByte(check_time)	 --0�����Ч�������Ҳ�ɲ�������1�����Ч��5�������������һ��
	    buf:writeInt(play_count)	--����������
	    end,user_info.ip,user_info.port) 
end
 
--���͹������޽��
function newyear_lib.send_attack_monster_result(user_info, result, award_id)
	--TraceError("���͹������޽����userid:"..user_info.userId.." result:"..result.." award_id:"..award_id);
	netlib.send(function(buf)
            buf:writeString("HDNYNSKILL");
            buf:writeInt(result);
            buf:writeInt(award_id);
        end,user_info.ip,user_info.port);
end
 
--�������а�
function newyear_lib.send_ph_list(user_info, libao_sign, my_attack_value, my_mc, attack_paimin_list)
	--TraceError("�������а�libao_sign:"..libao_sign.." my_attack_value"..my_attack_value.." my_mc:"..my_mc.." attack_paimin_list...")
	--TraceError(attack_paimin_list)
	local send_len=50;--Ĭ�Ϸ�50����Ϣ
	netlib.send(function(buf)
    	buf:writeString("HDNYNSLIST")
    	buf:writeByte(libao_sign or 0)		--�Ƿ���ȡ�ˡ���ħ�������0��δ��ȡ��1������ȡ��
	    buf:writeInt(my_attack_value or 0)	--����ɵ��˺�
	    buf:writeInt(my_mc or 0)	--�ҵ�����
 
		if send_len>#attack_paimin_list then send_len=#attack_paimin_list end --��෢50����Ϣ
		--TraceError("�������а�send_len:"..send_len)
		
		 buf:writeInt(send_len)
			--�ٷ������˵�
	        for i=1,send_len do
		        buf:writeInt(attack_paimin_list[i].mingci)	--����
		        buf:writeInt(attack_paimin_list[i].user_id) --���ID
		        buf:writeString(attack_paimin_list[i].nick_name) --�ǳ�
		        buf:writeInt(attack_paimin_list[i].attack_value) --��ҹ����ɼ�
              
	        end
     	end,user_info.ip,user_info.port) 
end
 
--��������״̬
function newyear_lib.send_monster_stat(user_info, monster_value, monster_now_value)
	--TraceError("��������״̬�� USERID:"..user_info.userId.." monster_value:"..monster_value.." monster_now_value:"..monster_now_value)
	netlib.send(function(buf)
            buf:writeString("HDNYNSBLOOD");
            buf:writeInt(monster_value);		--������Ѫ��
            buf:writeInt(monster_now_value);		--���޵�ǰѪ��
        end,user_info.ip,user_info.port);
end
 

--���͹������ڽ��
function newyear_lib.send_buy_gun_result(user_info, gun3_value, result)
	--TraceError("���͹������ڽ��,USERID:"..user_info.userId.." gun3_value:"..gun3_value.." result"..result)
	netlib.send(function(buf)
            buf:writeString("HDNYNSBUYLP");
            buf:writeInt(result);		--0������ʧ�ܣ����벻�㣻1������ɹ���2������ʧ�ܣ���ѹ��ڣ�3������ʧ�ܣ�����ԭ��
            buf:writeInt(gun3_value);		--���ڵ�����
        end,user_info.ip,user_info.port);
end


--���ͱ��ڡ��̻������ڵ���Ϣ
function newyear_lib.send_gun_info(user_info, gun1_value, gun2_value, gun3_value)
	  --TraceError("���ͱ��ڡ��̻������ڵ���Ϣ,USERID:"..user_info.userId.." gun1_value:"..gun1_value.." gun2_value:"..gun2_value.." gun3_value:"..gun3_value)
	  netlib.send(function(buf)
            buf:writeString("HDNYNSVALUE");
            buf:writeInt(gun1_value);		--��������
            buf:writeInt(gun2_value);		--�̻�����
            buf:writeInt(gun3_value);		--��������
        end,user_info.ip,user_info.port);
end
 
--����������ȡ����ħ��������
function newyear_lib.send_exorcist_packs_result(user_info, result)
	--TraceError("����������ȡ����ħ��������,USERID:"..user_info.userId.." result:"..result)
	 netlib.send(function(buf)
            buf:writeString("HDNYNSGIFTEX");
            buf:writeByte(result);		--0����ȡʧ�ܣ�δ�ﵽ�˺�������1����ȡ�ɹ���2������ȡ��3����ȡʧ�ܣ�����ԭ��
        end,user_info.ip,user_info.port);
end

--�����ҵ��˺�
function newyear_lib.send_my_hurt(user_info, hurt)
	 netlib.send(function(buf)
            buf:writeString("HDNYNSMH");
            buf:writeInt(hurt);
        end,user_info.ip,user_info.port);
end


--Э������
cmd_tex_match_handler = 
{
	["HDNYNSDATE"] = newyear_lib.on_recv_activity_stat, --����ʱ��״̬
    ["HDNYNSPANEL"] = newyear_lib.on_recv_activation, -- ����򿪻���
    ["HDNYNSLIST"] = newyear_lib.on_recv_attack_ph_list, -- --���󹥻��������а� 
    ["HDNYNSBLOOD"] = newyear_lib.on_recv_monster_info, -- ���������������
    ["HDNYNSVALUE"] = newyear_lib.on_recv_gun_info, 	--֪ͨ�ͻ��ˣ����ر��ڡ��̻������ڵ���Ϣ
    ["HDNYNSKILL"] = newyear_lib.on_recv_attack_monster, -- ��������/�������� 
    ["HDNYNSBUYLP"] = newyear_lib.on_recv_buy_fire,--��������
    ["HDNYNSGIFTEX"] = newyear_lib.on_recv_exorcist_packs ,--֪ͨ����ˣ�������ȡ����ħ�����
  
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", newyear_lib.on_after_user_login);
eventmgr:addEventListener("timer_minute", newyear_lib.ontimecheck);