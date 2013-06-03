-------------------------------------------------------
-- �ļ�������new_year.lua
-- �����ߡ���lgy
-- ����ʱ�䣺2013-1-13 17��00��00
-- �ļ����������ݴ��ڻ
-------------------------------------------------------
TraceError("init new_year...")

if new_year and new_year.on_user_exit then
    eventmgr:removeEventListener("on_user_exit", new_year.on_user_exit)
end
if new_year and new_year.ongameover then 
	eventmgr:removeEventListener("on_game_over_event", new_year.ongameover);
end
if new_year and new_year.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", new_year.on_after_user_login);
end
if new_year and new_year.after_car_match_event then
    eventmgr:removeEventListener("after_car_match_event", new_year.after_car_match_event);
end
--if new_year and new_year.daxiao_round_jiesun then
--    eventmgr:removeEventListener("daxiao_round_jiesun", new_year.daxiao_round_jiesun);
--end
if new_year and new_year.ongamebegin then 
	eventmgr:removeEventListener("game_begin_event", new_year.ongamebegin)
end
if new_year and new_year.restart_server then 
	eventmgr:removeEventListener("on_server_start", new_year.restart_server)
end
if new_year and new_year.bag_change_event then 
	eventmgr:removeEventListener("bag_change_event", new_year.bag_change_event)
end
--if new_year and new_year.on_match_user_taotai then 
--eventmgr:removeEventListener("on_match_user_taotai", new_year.on_match_user_taotai)
--end
if new_year and new_year.timer then 
	eventmgr:removeEventListener("timer_minute", new_year.timer)
end

--��Чʱ�䷵��1,0���ڣ�2Ϊ���а�ʱ��
function new_year.check_time()
	local current_time = os.time()

	if  current_time >= timelib.db_to_lua_time(new_year.CFG_RANK_START_TIME)
	  and current_time <= timelib.db_to_lua_time(new_year.CFG_RANK_KEEP_TIME) then
		return 2
	end
	
	if current_time >= timelib.db_to_lua_time(new_year.CFG_START_TIME)
		and current_time <= timelib.db_to_lua_time(new_year.CFG_END_TIME) then
		return 1
	end
	
	if current_time > timelib.db_to_lua_time(new_year.CFG_END_TIME) 
		and current_time < timelib.db_to_lua_time(new_year.CFG_RANK_START_TIME) then
		return 3
	end
		
	return 0 
end

--�յ���Ϸ״̬����
function new_year.on_query_status(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end 
	new_year.send_new_year_status(user_info)
end

function new_year.send_new_year_status(user_info)
	local user_id = user_info.userId
	local status = new_year.check_time()
	local wishes = new_year.user_list[user_id].wishes
	wishes = math.modf(wishes%200)
	netlib.send(function(buf)
		buf:writeString("NYSTATE")
		buf:writeByte(status)
		buf:writeByte(new_year.user_list[user_id].make_new_flower or 0)--���ֹ���Ƕ�̬
		buf:writeInt(wishes) --��Ըֵ/200����
	end, user_info.ip, user_info.port)
end

--����buff
function new_year.on_query_buff(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end 
	new_year.send_user_buff(user_info)
end

--������Ըֵ
function new_year.on_query_wishes(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	new_year.send_user_wishes(user_info) 
end

--����ժ��
function new_year.on_query_pick(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	local flower_id = buf:readByte()
	if flower_id > 5 or flower_id < 1 then return end
	if not new_year.user_list[user_id] then return end
	local name = "flower"..flower_id
	if new_year.user_list[user_id][name] < 1 then
		TraceError("��ҷǷ�Э�飬�޻���ժ")
		return
	end
	if new_year.check_time() ~= 1 then
		netlib.send(function(buf)
			buf:writeString("NYPICK")
			buf:writeByte(0)
			buf:writeByte(flower_id)
		end, user_info.ip, user_info.port) 
		return 
	end
	--�ۻ�
	new_year.add_flower(user_id, flower_id, -1)
	--����Ӧ�ĵ���
	tex_gamepropslib.set_props_count_by_id(new_year.FLOWER_ITEM[flower_id], 1, user_info, nil)
	--ˢ�����
	new_year.send_main_windows(user_info,nil,1)
	--
	netlib.send(function(buf)
			buf:writeString("NYPICK")
			buf:writeByte(1)
			buf:writeByte(flower_id)
		end, user_info.ip, user_info.port) 
end

function new_year.add_flower(user_id, flower_id, add_flower)
	local name = "flower"..flower_id
	new_year.user_list[user_id][name] = new_year.user_list[user_id][name] + add_flower
	new_year_db.update_flowers(user_id, flower_id, add_flower)
	--��¼����仯
	new_year_db.record_new_year_flower_info(user_id,flower_id,add_flower)
	--���»�������
	local user_info = usermgr.GetUserById(user_id)
	new_year.send_main_windows(user_info, nil ,1)
	if add_flower > 0 then
			--û����һ�仨�ͱ��һ��
			new_year.user_list[user_id].make_new_flower = 1
			new_year.send_new_year_status(user_info)
	end
end

--�����
function new_year.on_open_panel(buf)
	if tonumber(groupinfo.groupid) ~= 18001 then return end
	if new_year.check_time() == 0 then return end
	local user_id = buf:readInt();
	local user_info_from = nil
	local user_info_to = nil
	local to_myself = nil 
	if user_id == 0 then 
		user_info_from = userlist[getuserid(buf)]
		user_info_to = user_info_from
		to_myself = 1
	else
		user_info_to = usermgr.GetUserById(user_id)
		user_info_from = userlist[getuserid(buf)]
		to_myself = 0
	end
	if user_info_to == nil then return end
	local user_id_to   = user_info_to.userId
	local user_id_from = user_info_from.userId
	if user_id_to == nil then return end 
	if user_id_from == nil then return end
		--�������Э��
		--1��HISTORYALLЭ��	
		--2��HISTORYMEЭ��
		--3) NYBUFF--����buffʱ��
		--4��NYWISH--������Ըֵ	
		new_year.send_user_history_me(user_info_to, user_info_from)
		new_year.send_user_history_all(user_info_from)
		if new_year.check_time() == 1 or new_year.check_time() == 2 then
		  new_year.send_user_buff(user_info_to, user_info_from)
	  end
	  if (to_myself == 1) and (new_year.check_time() == 2) then
  		local rank,already_reward = new_year.get_final_reward_info(user_info_to)
  		--��ұ�������ʵ�ｱƷ����д����
  		if rank > 0  and rank <= new_year.CFG_RANK_PHONE and already_reward ==0 then
  			new_year.send_final_reward_info(user_info_to,rank)
  		end
  	end

	if (to_myself == 1) then
		new_year.send_user_water(user_info_to)
		new_year.user_list[user_id_to].make_new_flower = nil
		if new_year.user_list[user_id_to] then
			new_year.user_list[user_id_to].open_new_year_panel = 1
		end
	end
	
	new_year.send_main_windows(user_info_to, user_info_from, to_myself)
	new_year.send_user_wishes(user_info_to, user_info_from)
	
	
end

--�������Э��1��1,2,3,4,5,6,��Ӧ�����ҹ,�����ڼ�֡��4��12|89|98|45|78|54|56| -- ���ֻ�������
function new_year.send_main_windows(user_info, user_info_from, to_myself)
	if user_info == nil then return end
	local user_id = user_info.userId
	local qiegao_num = 0
	local flower_num = new_year.get_flowers_str(user_id)
	local moon = new_year.get_date_moon()
	
	if user_info_from then
		netlib.send(function(buf)
			buf:writeString("NYOPENPANEL")
			buf:writeByte(moon)
			buf:writeString(flower_num)--5�ֻ�������
			buf:writeByte(to_myself or 0)--�ǲ���Ϊ�鿴�Լ�����Ը��
		end, user_info_from.ip, user_info_from.port)
		return
	end
	netlib.send(function(buf)
		buf:writeString("NYOPENPANEL")
		buf:writeByte(moon)
		buf:writeString(flower_num)--5�ֻ�������
		buf:writeByte(to_myself or 0)--�ǲ���Ϊ�鿴�Լ�����Ը��
	end, user_info.ip, user_info.port)
end

--�õ������ҹ���Լ�������λ��
function new_year.get_date_moon()
	local sys_time = os.time()
	local moon = 0
	local table_time = os.date("*t",sys_time)
	local day = table_time.day
	local hour = table_time.hour
	if day == 24 then
		moon = 6
	elseif day < 24 and day > 20 then
		moon = 5
	elseif day < 21 and day > 16 then
		moon = 4
	elseif day < 17 and day > 12 then
		moon = 3
	else
		moon = 2
	end
	if hour <= 18 and hour > 6 then
		moon = 1
	end
	return moon  
end

--�ô�ĳ����ҵ��ܻ������� 
function new_year.get_flowers_str(user_id)
	local str = ""
	for i=1,5 do
		local name = "flower"..i
		str = str..new_year.user_list[user_id][name].."|"
	end
	str = string.sub(str,1,string.len(str)-1)
	return str
end

--���Ϳͻ��˸���buffʱ��
function new_year.send_user_buff(user_info, user_info_from)
	local user_id = user_info.userId
	local buff = new_year.user_list[user_id].buff - os.time()
	if user_info_from then
		netlib.send(function(buf)
			buf:writeString("NYBUFF")			
			buf:writeInt(buff)
		end, user_info_from.ip, user_info_from.port) 
		return
	end
	netlib.send(function(buf)
		buf:writeString("NYBUFF")			
		buf:writeInt(buff)
	end, user_info.ip, user_info.port) 
end

--���Ϳͻ��˸�����Ըֵ
function new_year.send_user_wishes(user_info, user_info_from)
	local user_id = user_info.userId
	local wishes = new_year.user_list[user_id].wishes
	if user_info_from then
		netlib.send(function(buf)
			buf:writeString("NYWISH")			
			buf:writeInt(wishes)
		end, user_info_from.ip, user_info_from.port)
		return
	end
	netlib.send(function(buf)
		buf:writeString("NYWISH")			
		buf:writeInt(wishes)
	end, user_info.ip, user_info.port)
end

--���Ϳͻ���Ȫˮ����
function new_year.send_user_water(user_info)
	local user_id = user_info.userId
	local get_quanshui_num = function(nCount)
		netlib.send(function(buf)
			buf:writeString("NYWATER")			
			buf:writeInt(nCount)
		end, user_info.ip, user_info.port)
	end
	tex_gamepropslib.get_props_count_by_id(200008, user_info, get_quanshui_num)	
end

function new_year.on_close_panel(buf)
		local user_info = userlist[getuserid(buf)]
		if user_info == nil then return end 
		if new_year.user_list[user_info.userId] then
			new_year.user_list[user_info.userId].open_new_year_panel = nil
		end
end

function new_year.on_user_exit(e)
    if e.data ~= nil and new_year.user_list[e.data.user_id] ~= nil then
        new_year.user_list[e.data.user_id] = nil;
    end
    --��������ʱ��
    new_year_db.update_exit_time(e.data.user_id)  
end

--������������keep�У�����ȡ�����а�
function new_year.restart_server(e)
		--new_year_db.get_final_history()
end

--timer
function new_year.timer(e)
	if new_year.aready_int_final == 1 then
		return
	end
	local current_time = os.time()
	local start_time = timelib.db_to_lua_time(new_year.CFG_RANK_START_TIME)
	if current_time > start_time then
		new_year_db.get_final_history()
		new_year.aready_int_final = 1
		return
	end
	
	if new_year.is_today(new_year.clear_data_time ,current_time - 3600)==0 then
		new_year_db.get_final_history()
		new_year.clear_data_time=current_time
  end
  
  if new_year.is_today(new_year.clear_wishes_time ,current_time)==0 then
    for k,v in pairs (new_year.user_list) do
  		local user_info = usermgr.GetUserById(k)
  		--��һ���ڴ��������ߵ��˵����ݣ��������������ҵ�����ʱ�䣬������
  		if user_info==nil then
  		  new_year.user_list[k] = nil 
  		elseif new_year.user_list[k] then
  		  for i = 1, 7 do
  		    new_year.user_list[k].bet_wishes[i] = 0
  			end
  		end
  		new_year_db.clear_task_proc(k)
  	end
  	new_year.clear_wishes_time=current_time	
  end

end

--�������仯�����Ҵ������ˣ�ˢ��ȪˮЭ��
function new_year.bag_change_event(e)
	local user_id = e.data.user_id
	local user_info = usermgr.GetUserById(user_id)
	if not new_year.user_list[user_id] then return end
	if new_year.user_list[user_id].open_new_year_panel == 1 then
		new_year.send_user_water(user_info)
	end
end

--��������Ϣtodo
function new_year.on_match_user_taotai(e)
	 local user_id     = e.data.user_id
	 local rank        = e.data.rank  
	 local match_type  = e.data.match_type
	 local match_count = e.data.match_count
	 if not new_year.CFG_MATCH_COEFFICIENT[match_type] then
	 		TraceError("��������ϵ������")
	 	return
	 end
	local wishes = (e.data.match_count - rank)/4 * new_year.CFG_MATCH_COEFFICIENT[match_type]
	new_year.add_wishes(user_id, wishes)
end


--������ʼ������5���˲���
function new_year.ongamebegin(e)
		local deskno = e.data.deskno
		local deskinfo = desklist[deskno]
		if new_year.check_time() ~= 1 then return end
		if deskinfo.playercount >= new_year.number_min then
			deskinfo.cangetwishes_newyear = 1
		else
			deskinfo.cangetwishes_newyear = nil
		end
end

--��������
function new_year.ongameover(e)
	local user_info = e.data.user_info
	if(user_info==nil)then return end
	local user_id = user_info.userId
	local win_gold = e.data.win_gold
	if new_year.check_time() ~= 1 then return end
	if new_year.user_list[user_id] == nil then return end
	local deskinfo = desklist[user_info.desk]
	if not deskinfo then return end
	if not new_year.CFG_WISHES_CONFIG[deskinfo.smallbet] then
		TraceError("����������Ϣ��û�и�����äע��Ӧ������Ϣ")
		return
	end
	if not deskinfo.cangetwishes_newyear then
		return
	end
	--����Ըֵ	
	if win_gold > 0 then
		local result = 1
		local success, ret = xpcall(function() return new_year.check_give_wishes(user_id,deskinfo.smallbet) end, throw)
	  if success == true then
	    result = ret
	  end
	  if (result == 1) then
	    new_year.add_wishes(user_id, new_year.CFG_WISHES_CONFIG[deskinfo.smallbet], 1, nil, deskinfo.smallbet)
	  end
	end
end

function new_year.check_give_wishes(user_id,smallbet)
  if new_year.user_list[user_id] then
  	if new_year.bet_wishes_game[smallbet] then
	    local num = new_year.bet_wishes_game[smallbet]
		    if new_year.user_list[user_id].bet_wishes  and 
		     new_year.user_list[user_id].bet_wishes[num] and
		     new_year.bet_wishes_up[smallbet] then
		      
  		    if  new_year.user_list[user_id].bet_wishes[num]  >  new_year.bet_wishes_up[smallbet] then
  		      return 0
  		    else
  		      new_year.user_list[user_id].bet_wishes[num] = new_year.user_list[user_id].bet_wishes[num] + new_year.CFG_WISHES_CONFIG[smallbet]
  		      new_year_db.set_bet_wishes_up(user_id, num, new_year.user_list[user_id].bet_wishes[num])
  		    end
		    end	    
  	end
  end
  return 1
end


--�յ���������¼�
function new_year.after_car_match_event(e)
	if new_year.check_time() ~= 1 then return end
	local car_list = e.data.car_list
	local open_num = e.data.open_num
	local match_type = e.data.match_type
    for k,v in pairs (car_list) do
        if v.match_user_id and v.match_user_id > 0 then
            if new_year.user_list[v.match_user_id] then
            	if k == open_num then
								--����Ըֵ
								new_year.add_wishes(v.match_user_id, new_year.CFG_CAR_MATCH[match_type]*2,3)
            	else
            		--����Ըֵ
								new_year.add_wishes(v.match_user_id, new_year.CFG_CAR_MATCH[match_type],3)
            	end
            end
            --�����ұ����˾�����
            --if not new_year.user_list[v.match_user_id] and v.match_user_id > 0 then
            --	if k == open_num then
            --    new_year_db.update_offline_wishes(v.match_user_id, new_year.CFG_CAR_MATCH[match_type]*2)
            --  else
            --  	new_year_db.update_offline_wishes(v.match_user_id, new_year.CFG_CAR_MATCH[match_type])
            --  end
            --end
        end
		end
		
		local all_bet_info = e.data.all_bet_info
		for k,v in pairs(all_bet_info) do
			if new_year.user_list[k] then
				new_year.add_wishes(k, math.abs(v.add_gold - v.bet)/10000*new_year.CFG_BET_COEFFICIENT,4)
			else
				new_year_db.update_offline_wishes(k, math.abs(v.add_gold - v.bet)/10000 *new_year.CFG_BET_COEFFICIENT)
			end
		end
end

--�������¼�
function new_year.daxiao_round_jiesun(e)
	if new_year.check_time() ~= 1 then return end
	local bet_info = e.data.bet_info
	if not bet_info then return end
	for k,v in pairs(bet_info) do
			if new_year.user_list[tonumber(k)] then
			  if v.win_num > 0 then
				  new_year.add_wishes(tonumber(k), v.win_num/10000*new_year.CFG_BET_COEFFICIENT,2)
			  else
			    new_year.add_wishes(tonumber(k), v.bet_num/10000*new_year.CFG_BET_COEFFICIENT,2)
			  end
			--else
			--  TraceError("�����Ӳ�����")
			--	new_year_db.update_offline_wishes(k, math.abs(v.win_num - v.bet_num)/10000*new_year.CFG_BET_COEFFICIENT)
			end
	end
end

--��¼�¼�
function new_year.on_after_user_login(e)
	local user_info = e.data.userinfo;
	if user_info == nil then return end
	local user_id = user_info.userId	
	new_year_db.init_user_info(user_id)
	--todo
--	if new_year.check_time() ~= 2 then
--			new_year.get_self_info_history_final(user_info)
--	end
end

--ʹ��Ȫˮ
function new_year.use_water_onpanel(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	if new_year.check_time() ~= 1 then
		 	netlib.send(function(buf)
				buf:writeString("NYUSEWATER")
				buf:writeByte(-1)
			end, user_info.ip, user_info.port)
		 return 
	end
	--���ñ����ӿڲ���Ȫˮ���еĻ�������-1
	local set_count_box = function(nCount)
		if nCount >= 1 then
				local call_back = function ()
					--�������ݿ����
					user_info.update_use_water_update_db = 0				
					--��¼һ��ʹ��Ȫˮ
					--new_year_db.record_mori_chance_log(user_id,4)
					--������Ըֵ�͸���buffʱ��
					new_year.add_wishes(user_id, new_year.CFG_WATER_NUMBER, 5, 1)
					new_year.add_buff_time(user_id)
					netlib.send(function(buf)
						buf:writeString("NYUSEWATER")
						buf:writeByte(1)
					end, user_info.ip, user_info.port)
					--����Ȫˮ����
					new_year.send_user_water(user_info)
				end 
				local call_back_failed = function()
					--�������ݿ����
					user_info.update_use_water_update_db = 0
					return
				end
				tex_gamepropslib.set_props_count_by_id(200008, -1, user_info, call_back, 11, call_back_failed)		
		else
			user_info.update_use_water_update_db = 0
			return
		end
	end
	--������ݿ������򷵻�
	if user_info.update_use_water_update_db == 1 then
		TraceError("���ݿ��������޷�ʹ��Ȫˮ")
		--TraceError("user_info.update_open_box_update_db"..user_info.update_open_box_update_db)
		return
	end
	--�������ݿ�
	user_info.update_use_water_update_db = 1
	tex_gamepropslib.get_props_count_by_id(200008, user_info, set_count_box)	--todo Ȫˮid
end


--ʹ��Ȫˮ
function new_year.use_water(user_info)
	if user_info == nil then return end
	local user_id = user_info.userId
	if new_year.check_time() ~= 1 then
		 --�����
		 return 
	end
	--���ñ����ӿڲ���Ȫˮ���еĻ�������-1
	local set_count_box = function(nCount)
		if nCount >= 1 then
				local call_back = function ()
					--�������ݿ����
					user_info.update_use_water_update_db = 0				
					--��¼һ��ʹ��Ȫˮ
					--new_year_db.record_mori_chance_log(user_id,4)
					--������Ըֵ�͸���buffʱ��
					new_year.add_wishes(user_id, new_year.CFG_WATER_NUMBER, 5, 1)
					new_year.add_buff_time(user_id)
					new_year.send_openbox(user_info, 200008, 0, 0, 0)
				end 
				local call_back_failed = function()
					--�������ݿ����
					user_info.update_use_water_update_db = 0
					return
				end
				tex_gamepropslib.set_props_count_by_id(200008, -1, user_info, call_back, 11, call_back_failed)		
		else
			user_info.update_use_water_update_db = 0
			return
		end
	end
	--������ݿ������򷵻�
	if user_info.update_use_water_update_db == 1 then
		--TraceError("user_info.update_open_box_update_db"..user_info.update_open_box_update_db)
		return
	end
	--�������ݿ�
	user_info.update_use_water_update_db = 1
	tex_gamepropslib.get_props_count_by_id(200008, user_info, set_count_box)	-- Ȫˮid
end

--�����ֱ���
function new_year.use_box(user_info, item_id)
	if not new_year.BOX_PORBABILITY_LIST[item_id] then
		TraceError("����������������")
		return
	end
	--�����Ʒ�����򷵻�֪ͨ�ͻ���--
	if gift_getgiftcount(user_info) >= 93 and item_id == 200010 then
		net_send_gift_faild(user_info, 5, nil, 8)		--���߿ͻ�����������
		TraceError("���߿ͻ�����������")
		return
	end
	--�����Ʒ�����򷵻�֪ͨ�ͻ���--
	if gift_getgiftcount(user_info) >= 100 and item_id == 200011 then
		net_send_gift_faild(user_info, 5, nil, 1)		--���߿ͻ�����������
		TraceError("���߿ͻ�����������")
		return
	end		
	if not user_info then return end
	local set_count_box = function(nCount)
		if nCount >= 1 then
					local call_back = function ()
						--�������ݿ����
						user_info.update_use_newyear_box = 0				
							math.randomseed(os.time())
							math.randomseed(os.time() + math.random(1, 10000000))
							--�������
							local find = 0;
							local add = 0;
							local rand = math.random(1, 10000);
							for i = 1, #new_year.BOX_PORBABILITY_LIST[item_id] do
										add = add + new_year.BOX_PORBABILITY_LIST[item_id][i]
										if add >= rand then
												find = i;
											break;
										end
							end
							if find == 0 then
								return
							end
							local gift_name = nil
							if new_year.BOX_ITEM_GIFT_NAME[item_id] then
								gift_name = new_year.BOX_ITEM_GIFT_NAME[item_id][find] or ""
							else
								gift_name = ""
							end
							--�Ӻ��
							local money_luck = nil
							local item_gift_id = nil
							local item_gift_num = nil
							local car_id = nil
							
							if item_id == 200009 then
								money_luck = math.random(new_year.BOX_ITEM_GIFT_ID[item_id][find][1], new_year.BOX_ITEM_GIFT_ID[item_id][find][2])
								gift_name = "���"..money_luck.."����"
								usermgr.addgold(user_info.userId, money_luck, 0, new_gold_type.NEW_YEAR2013, -1, 1)
								new_year.send_openbox(user_info,item_id,5,0,money_luck)
							elseif item_id == 200010 then -- ������ ��ʯ��
								--������
								item_gift_id = new_year.BOX_ITEM_GIFT_ID[item_id][find][1]
								item_gift_num = math.random(new_year.BOX_ITEM_GIFT_ID[item_id][find][2], new_year.BOX_ITEM_GIFT_ID[item_id][find][3])
								for i=1,item_gift_num do
									gift_addgiftitem(user_info, item_gift_id, user_info.userId, user_info.nick, 0)
								end
								gift_name = gift_name.."*"..item_gift_num
								new_year.send_openbox(user_info,item_id,2,item_gift_id,item_gift_num)
							elseif item_id == 200011 then -- �ӵ���
								item_gift_id = new_year.BOX_ITEM_GIFT_ID[item_id][find][1]
								item_gift_num = math.random(new_year.BOX_ITEM_GIFT_ID[item_id][find][2], new_year.BOX_ITEM_GIFT_ID[item_id][find][3])
								if item_gift_id == -1 then --����Ʊ
									--����Ʊ
									daxiao_adapt_lib.add_exyinpiao(user_info.userId,item_gift_num,0,daxiao_adapt_lib.add_yinpiao_type.NEW_YEAR2013)
									new_year.send_openbox(user_info,item_id,4,0,item_gift_num)
								elseif item_gift_id == 5020 then --��lv��
									gift_addgiftitem(user_info, item_gift_id, user_info.userId, user_info.nick, 0)
									new_year.send_openbox(user_info,item_id,2,item_gift_id,item_gift_num)
								else
									tex_gamepropslib.set_props_count_by_id(item_gift_id, item_gift_num, user_info, nil)
									if item_gift_id == 200001 then 
										new_year.send_openbox(user_info, item_id,7, item_gift_id, item_gift_num)
									else
										new_year.send_openbox(user_info, item_id,1, item_gift_id, item_gift_num)
									end
								end
								gift_name = gift_name.."*"..item_gift_num
							elseif item_id == 200012 then -- �Ӿ���
								item_gift_id = new_year.BOX_ITEM_GIFT_ID[item_id][find][1]
								tex_gamepropslib.set_props_count_by_id(item_gift_id, 1, user_info, nil)
								new_year.send_openbox(user_info,item_id,7,item_gift_id,1)
							elseif item_id == 200013 then -- ������
								car_id = new_year.BOX_ITEM_GIFT_ID[item_id][find][1]
								car_match_db_lib.add_car(user_info.userId, car_id, 0)
								gift_name = car_match_lib.CFG_CAR_INFO[car_id]["name"]
								new_year.send_openbox(user_info,item_id,3,car_id,1)
							end
							--log
							new_year_db.record_new_year_box_info(user_info.userId,item_gift_id or car_id or 0, item_id, money_luck or item_gift_num or 1)
							
							--guangbo
							new_year.broadcast_msg(user_info, gift_name, item_id, find, money_luck)	
							--��ȫ�����а�
							local nick_name = string.trans_str(user_info.nick)
							new_year.add_history_all(user_info.userId, nick_name, gift_name, item_id, find, money_luck)
							--���Լ����а�
							new_year.add_history_me(user_info.userId,gift_name)
		
				
					end
					local call_back_failed = function()
						--�������ݿ����
						user_info.update_use_newyear_box = 0
						return
					end
					tex_gamepropslib.set_props_count_by_id(item_id, -1, user_info, call_back, 11, call_back_failed)		
			else
				user_info.update_use_newyear_box = 0
				return
			end
	end
	if user_info.update_use_newyear_box == 1 then
		TraceError("���ݿ��������޷�ʹ�ú��")
		return
	end
	--�������ݿ�
	user_info.update_use_newyear_box = 1
	tex_gamepropslib.get_props_count_by_id(item_id, user_info, set_count_box)	
end

--֪ͨ�û��ٱ���ʹ�õ��ߺ�Ľ��
function new_year.send_openbox(user_info, item_id, type_id, item_gift_id, item_number)
	--֪ͨ�ͻ���
	netlib.send(function(buf)
		buf:writeString("TXOPENBOX")
				buf:writeByte(1)									
				buf:writeInt(item_id or 0)
				buf:writeByte(type_id or 0)
				buf:writeInt(item_gift_id or 0)
				buf:writeInt(item_number or 0)
	end, user_info.ip, user_info.port)
end

--�����Լ���ʷ��¼
function new_year.add_history_me(user_id,gift_name)
	if new_year.check_time() ~= 1 then return end 
	--�Ӷһ���¼�б�	
	local buf_tab={}
	buf_tab.gift_name = _U(gift_name)
	buf_tab.sys_time = os.time()
	if not (new_year.user_list[user_id].history) or
	  (#new_year.user_list[user_id].history < new_year.CFG_HISTORY_ME) then
		table.insert(new_year.user_list[user_id].history,buf_tab)
	else
		table.remove(new_year.user_list[user_id].history,1)
		table.insert(new_year.user_list[user_id].history,buf_tab)
	end
	new_year_db.update_history_me(user_id)
	local user_info = usermgr.GetUserById(user_id)
	new_year.send_user_history_me(user_info)
end

--����ȫ���һ���¼
function new_year.add_history_all(user_id, nick_name, gift_name, box_id, find, money_luck)
	if new_year.check_time() ~= 1 then return end 
	--�Ӷһ���¼�б�	
	local buf_tab={}
	buf_tab.user_id = user_id
	buf_tab.nick_name = nick_name
	buf_tab.gift_name = gift_name
	buf_tab.sys_time = os.time()
	if new_year.LEVEL_ITEM_GIFT[box_id] then
		buf_tab.level = money_luck or new_year.LEVEL_ITEM_GIFT[box_id][find]
	end
	if box_id == 200013 then
		local car_id = new_year.BOX_ITEM_GIFT_ID[box_id][find][1]
		buf_tab.level = car_match_lib.CFG_CAR_INFO[car_id]["cost"]
		if buf_tab.level == -3 then
		  buf_tab.level = new_year.CAR_VALUE_3[car_id]
		end
	end
	
	if #new_year.history_list < new_year.CFG_HISTORY_ALL then
		table.insert(new_year.history_list,buf_tab)
	else
		table.remove(new_year.history_list,new_year.CFG_HISTORY_ALL)
		table.insert(new_year.history_list,buf_tab)
	end
	
	for i=1,#new_year.history_list do
	  for j=1,#new_year.history_list - i do
	  	if new_year.history_list[j].level and new_year.history_list[j + 1].level then
	      if new_year.history_list[j].level < new_year.history_list[j + 1].level then
	          local temp = new_year.history_list[j]
	          new_year.history_list[j] = new_year.history_list[j + 1]
	          new_year.history_list[j + 1] = temp
	      end
	    end
	  end
  end	
	new_year.send_history()
end

--�㲥
function new_year.broadcast_msg(user_info, gift_name, box_id, find, money_luck)	
	local value_num = 0
	if new_year.LEVEL_ITEM_GIFT[box_id] then
		value_num = money_luck or new_year.LEVEL_ITEM_GIFT[box_id][find]	
	end
	if box_id == 200013 then
		local car_id = new_year.BOX_ITEM_GIFT_ID[box_id][find][1]
		value_num = car_match_lib.CFG_CAR_INFO[car_id]["cost"]
		if value_num == -3 then
		  value_num = new_year.CAR_VALUE_3[car_id]
		end
	end
	if value_num < 50000 then return end
	if value_num >= 50000 and value_num < 1000000 then
			local msg = "�������������Ը�����%s"
			msg = string.format(msg, gift_name)
			tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
			return
	end
	
		local msg = "�������������Ը����%s���%s"
		local current_time = os.time()
		local db_time = timelib.lua_to_db_time(current_time)
		msg = string.format(msg, db_time, gift_name)
		tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
		--�㲥3�ε�
		if value_num >= 1000000 and value_num < 5000000 then
			for i=1,2 do
				timelib.createplan(function()
					tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
				end,i*40*60)
			end
		--�㲥6��
		elseif value_num >= 5000000 and value_num < 20000000 then
			for i=1,5 do
				timelib.createplan(function()
					tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
				end,i*24*60)
			end
		elseif value_num >= 20000000 then
			for i=1,23 do
				timelib.createplan(function()
					tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
				end,i*60*60)
			end
		end
end
--�һ��ض���¼�б�me
function new_year.send_user_history_me(user_info, user_info_from)
		local user_id = user_info.userId
		
		if user_info_from then
			netlib.send(function(buf)
			    buf:writeString("NYHISTORYME")
			    buf:writeInt(#new_year.user_list[user_id].history)
				for k,v in pairs(new_year.user_list[user_id].history)do
					buf:writeString(v.gift_name)
				end
		  end,user_info_from.ip,user_info_from.port)
		  return
		end
		
		if user_info ~= nil then
			netlib.send(function(buf)
			    buf:writeString("NYHISTORYME")
			    buf:writeInt(#new_year.user_list[user_id].history)
				for k,v in pairs(new_year.user_list[user_id].history)do
					buf:writeString(v.gift_name)
				end
		  end,user_info.ip,user_info.port)
		end
end


--����ȫ���������˸������а��б�
function new_year.send_history()
	if new_year.check_time() ~= 1 then return end 
	for k,v in pairs(new_year.user_list) do
		local user_info = nil
		if k then
				user_info = usermgr.GetUserById(k)
		end
		if not v.open_end_world_panel then
		end
		if user_info ~= nil and v.open_new_year_panel ~= nil then
			new_year.send_user_history_all(user_info)
		end
   end
end


--�һ��ض���¼�б�all
function new_year.send_user_history_all(user_info)
		if user_info ~= nil then
			netlib.send(function(buf)
			    buf:writeString("NYHISTORYALL")
			    buf:writeInt(#new_year.history_list)
				for k,v in pairs(new_year.history_list) do
					buf:writeString(v.nick_name)
					buf:writeString(_U(v.gift_name))
				end
		  end,user_info.ip,user_info.port)
		end
end


function new_year.on_final_history(buf)
  local user_info = userlist[getuserid(buf)]
  new_year.send_user_history_final(user_info)
end
--�������Ĵ����а�
function new_year.send_user_history_final(user_info)
		if user_info ~= nil then
		  local num_rank = 0
			netlib.send(function(buf)
			    buf:writeString("NYHISTORYFINAL")
			    buf:writeInt(#new_year.history_final_list)
				for k,v in pairs(new_year.history_final_list) do
					buf:writeString(v.nick_name)
					buf:writeInt(v.flowers)
					buf:writeInt(v.wishes)
					if v.user_id == user_info.userId then
				    num_rank = k
				  end
				end
					buf:writeInt(num_rank)--����
					buf:writeByte(new_year.check_time())
		  end,user_info.ip,user_info.port)
		end
end


--�ж��Ƿ����м���
function new_year.get_final_reward_info(user_info)
	for k,v in pairs(new_year.history_final_list) do
		if v.user_id == user_info.userId then
			return k,v.already_reward
		end
	end
	return 0,0
end

--�����Ѿ���д����
function new_year.set_final_info(user_info)
	for k,v in pairs(new_year.history_final_list) do
		if v.user_id == user_info.userId then
			v.already_reward = 1
			return 1;
		end
	end
	return 0;
end

--֪ͨ�ͻ����д���Ϣ
function new_year.send_final_reward_info(user_info,number)
		netlib.send(function(buf)
			buf:writeString("NYWRITEINFO")
			buf:writeInt(number)
		end, user_info.ip, user_info.port) 
end

--����ύ�û��ý���Ϣ
function new_year.on_final_writein(buf)
	local user_info = userlist[getuserid(buf)]
	local realname = buf:readString()
	local tel = buf:readString()
	local yy = buf:readString()
	local address = buf:readString()
	local rank_number,reward_not = new_year.get_final_reward_info(user_info)
	if reward_not == 1 then 
		TraceError("����Ѿ���д��������")
		return
	end
	if rank_number == 0 or  rank_number > new_year.CFG_RANK_PHONE then
		TraceError("���û����ʵ�ｱ")
		return
	end
	new_year.set_final_info(user_info)
	new_year_db.set_final_info(user_info.userId)
	new_year_db.add_user_contact(user_info.userId, rank_number, realname, yy, address, tel)
end

--����һ�仨
function new_year.make_flower(user_id)
	math.randomseed(os.time())
	math.randomseed(os.time() + math.random(1, 10000000))
	local find = 0;
	local add = 0;
	local rand = math.random(1, 10000);
	for i = 1, #new_year.FLOWER_PORBABILITY_LIST do
				add = add + new_year.FLOWER_PORBABILITY_LIST[i]
				if add >= rand then
						find = i
					break
				end
	end
	if find == 0 then
		TraceError("�漴ʧ��û���漴��������������ø���")
		return
	end
	new_year.add_flower(user_id, find, 1)
end

--�ж��Ƿ����һ�仨
function new_year.can_make_flower(user_id, wishes_now)
	local left = new_year.user_list[user_id].wishes % 200
	if wishes_now + left >= 200 then
		--TraceError("(wishes_now + left)/200"..(wishes_now + left)/200)
		return math.floor((wishes_now + left)/200)
	else
		return 0
	end                                                                                         
end

--������Ըֵ,���жϲ�������
function new_year.add_wishes(user_id, wishes_now, where, water_yes_no, small_bet)
	--�ж��Ƿ���buff
	if not small_bet then small_bet = -1 end
	if not water_yes_no then
		if new_year.user_list[user_id].buff - os.time() > 0 then
			wishes_now = wishes_now*new_year.CFG_BUFF_COEFFICIENT
		end
	end
	--�ж��Ƿ������
	local result = new_year.can_make_flower(user_id, wishes_now)
	if result >= 1 then
		for i = 1, result do 
			new_year.make_flower(user_id)
		end	
	end
	new_year.user_list[user_id].wishes = new_year.user_list[user_id].wishes + wishes_now
	--�޸����ݿ�
	new_year_db.update_wishes(user_id, wishes_now)
	--log
	new_year_db.update_wishes_log(user_id, wishes_now, where, small_bet)
	--������Ըֵˢ�����
	local user_info = usermgr.GetUserById(user_id)
	new_year.send_new_year_status(user_info)
end

--����buffʱ��
function new_year.add_buff_time(user_id)
	local time = os.time() + new_year.CFG_BUFF_TIME
	new_year.user_list[user_id].buff = time
	new_year_db.update_buff(user_id, time)
end


--�ǲ�����ͬһ��
function new_year.is_today(time1,time2)
	if time1==nil or time2==nil or time1=="" or time2=="" then return 0 end
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
		return 0 
	end
	if time1~=time2 then
		return 0
	end
	return 1
end

--�����б�
cmdHandler = 
{
		["NYOPENPANEL"]    = new_year.on_open_panel,--�����
    ["NYSTATE"]        = new_year.on_query_status,--��Ƿ���Ч
    ["NYCLOSEPANEL"]   = new_year.on_close_panel,
		["NYUSEWATER"]     = new_year.use_water_onpanel,--�ڽ������Զ�ʹ��Ȫˮ
		["NYBUFF"]         = new_year.on_query_buff,
		["NYWISH"]         = new_year.on_query_wishes,
		["NYPICK"]         = new_year.on_query_pick, --����ժ��
		["NYFINAL"]        = new_year.on_final_writein,
		["NYHISTORYFINAL"] = new_year.on_final_history, --��������а�
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("on_user_exit", new_year.on_user_exit)
eventmgr:addEventListener("on_game_over_event", new_year.ongameover)
eventmgr:addEventListener("game_begin_event", new_year.ongamebegin)
eventmgr:addEventListener("h2_on_user_login", new_year.on_after_user_login)
eventmgr:addEventListener("after_car_match_event", new_year.after_car_match_event)
--eventmgr:addEventListener("daxiao_round_jiesun", new_year.daxiao_round_jiesun)
eventmgr:addEventListener("on_server_start", new_year.restart_server)
eventmgr:addEventListener("bag_change_event", new_year.bag_change_event)
--eventmgr:addEventListener("on_match_user_taotai", new_year.on_match_user_taotai)
eventmgr:addEventListener("timer_minute", new_year.timer)


