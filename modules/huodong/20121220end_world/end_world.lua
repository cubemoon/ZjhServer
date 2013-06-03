-------------------------------------------------------
-- �ļ�������end_world.lua
-- �����ߡ���lgy
-- ����ʱ�䣺2012-12-13 18��00��00
-- �ļ�����������ĩ�մ������
-------------------------------------------------------


TraceError("init end_world...")
if end_world and end_world.on_user_exit then
    eventmgr:removeEventListener("on_user_exit", end_world.on_user_exit)
end

if end_world and end_world.ongameover then 
	eventmgr:removeEventListener("on_game_over_event", end_world.ongameover);
end

if end_world and end_world.timer then
	eventmgr:removeEventListener("timer_minute", end_world.timer);
end

if end_world and end_world.update_quest_event then
	eventmgr:removeEventListener("update_quest_event", end_world.update_quest_event);
end

if end_world and end_world.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", end_world.on_after_user_login);
end

if end_world and end_world.after_car_match_event then
    eventmgr:removeEventListener("after_car_match_event", end_world.after_car_match_event);
end

--end_world.CFG_GAMEPLAY_ROOM = 66004

--��Чʱ�䷵��1
function end_world.check_time()
	local current_time = os.time()
	if current_time < timelib.db_to_lua_time(end_world.CFG_START_TIME)
		or current_time > timelib.db_to_lua_time(end_world.CFG_END_TIME) then
		return -1
	end
	return 1
end

function end_world.on_query_status(buf)
	local status = end_world.check_time()
	netlib.send(function(buf)
		buf:writeString("MRBOXST")
		buf:writeByte(status)
	end, buf:ip(), buf:port())
end

function end_world.send_main_windows(user_info)
	if user_info == nil then return end
	local user_id = user_info.userId
	local qiegao_num = 0
	local get_qiegao_num = function(nCount)
		qiegao_num = nCount
		netlib.send(function(buf)
			buf:writeString("MRBOXOP")
			buf:writeInt(end_world.user_list[user_id].area_id)
			buf:writeInt(end_world.user_list[user_id].death)
			buf:writeInt(end_world.user_list[user_id].chance_num)
			buf:writeInt(qiegao_num)
		end, user_info.ip, user_info.port)
	end
	tex_gamepropslib.get_props_count_by_id(200007, user_info, get_qiegao_num)	
end

function end_world.on_open_panel(buf)
	if tonumber(groupinfo.groupid) ~= 18001 then return end
	if end_world.check_time() ~= 1 then return end
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end 
	
	end_world.send_main_windows(user_info)
	end_world.send_user_history(user_info)
	end_world.send_user_taskinfo(user_info)
	
	if end_world.user_list[user_info.userId] then
		end_world.user_list[user_info.userId].open_end_world_panel = 1
	end
end

function end_world.on_close_panel(buf)
		local user_info = userlist[getuserid(buf)]
		if user_info == nil then return end 
		if end_world.user_list[user_info.userId] then
			end_world.user_list[user_info.userId].open_end_world_panel = nil
		end
end

function end_world.on_user_exit(e)
    if e.data ~= nil and end_world.user_list[e.data.user_id] ~= nil then
        end_world.user_list[e.data.user_id] = nil;
    end
end

--�յ��ͻ���ҡ����Э��
function end_world.on_recv_cj(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end 
	local user_id = user_info.userId
	end_world.on_game_cj(user_id, 1)
end

--ҡ����
function end_world.on_game_cj(user_id, use_chance_not)
	local user_info = usermgr.GetUserById(user_id)
	local user_area_id = end_world.user_list[user_id].area_id
	local user_new_area_id = user_area_id
	local get_num = math.random(1,6)
	local type_id,reward_id,item_gift_id,item_number = 0,0,0,0
	local send_result = function(ret_code)
		local get_qiegao_num = function(nCount)
			netlib.send(function(buf)
			buf:writeString("MRBOXCJ")
			buf:writeByte(ret_code)
			buf:writeInt(user_new_area_id)
			buf:writeInt(end_world.user_list[user_id].chance_num)
			buf:writeByte(type_id)
			buf:writeInt(reward_id)
			buf:writeInt(item_gift_id)
			buf:writeInt(item_number)
			buf:writeInt(nCount)	
		end, user_info.ip, user_info.port)
		end
		tex_gamepropslib.get_props_count_by_id(200007, user_info, get_qiegao_num)	
	end
	--�Ƿ����
	if end_world.check_time() ~= 1 then 
		send_result(-1)
		TraceError("�����")
		return 
	end
	--�Ƿ��л���
	if use_chance_not then
		if end_world.user_list[user_id].chance_num < 1 then
			TraceError("�Ƿ�Э�飬�û�α��ͻ��ˣ�û�л��ᣬ�û�Id:"..user_id)
			return
		end
	end
	--�Ƿ�����
	if end_world.user_list[user_id].death ~= 1 then
		TraceError("�Ƿ�Э�飬�û�α��ͻ��ˣ��Ѿ��������û�Id:"..user_id)
		return
	end
	--�����Ʒ�����򷵻�֪ͨ�ͻ���--todo
	if gift_getgiftcount(user_info) >= 100 then
		net_send_gift_faild(user_info, 5)		--���߿ͻ�����������
		TraceError("���߿ͻ�����������")
		return
	end	
	
	user_new_area_id = user_area_id + get_num 
	if user_new_area_id >= 26 then
		user_new_area_id = 26
		end_world.user_list[user_id].death = 2
		end_world_db.update_death(user_id, 2)
	end
	
	if use_chance_not then
		--�۳�ҡ���ӻ���
		end_world.user_list[user_id].chance_num = end_world.user_list[user_id].chance_num - 1
		--�������ݿ�
		end_world_db.update_chance_num(user_id, end_world.user_list[user_id].chance_num)
	end
	
	--���������Ӵ���
	end_world.user_list[user_id].times = end_world.user_list[user_id].times + 1
	end_world_db.update_times(user_id)
	
	type_id,reward_id,item_gift_id,item_number = end_world.give_reward(user_id, user_new_area_id, end_world.user_list[user_id].times, send_result)	
	end_world.user_list[user_id].area_id = user_new_area_id
	end_world_db.update_area(user_id, user_new_area_id)
	
	if item_gift_id ~= 200007 then
		send_result(1)
	end
	
end

--�յ��ͻ�����Ϸ����Э��
function end_world.on_recv_cz(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end 
	local user_id = user_info.userId
	end_world.on_game_cz(user_id, 1)
end

--��Ϸ����
function end_world.on_game_cz(user_id, use_chance_not)
	--�Ƿ����
	local user_info = usermgr.GetUserById(user_id)
	if end_world.check_time() ~= 1 then 
			netlib.send(function(buf)
				buf:writeString("MRBOXCJ")
				buf:writeByte(-1)
				buf:writeInt(0)
				buf:writeInt(0)
				buf:writeByte(0)
				buf:writeInt(0)
				buf:writeInt(0)
				buf:writeInt(0)
				buf:writeInt(0)
			end, user_info.ip, user_info.port)
		return 
	end
	if use_chance_not then
		--�Ƿ��л���
		if end_world.user_list[user_id].chance_num < 1 then
			TraceError("�Ƿ�Э�飬�û�α��ͻ��ˣ��û�û��������Ϸ���ᣬ�û�Id:"..user_id)
			return
		end
	end
	--�Ƿ�����
	if end_world.user_list[user_id].death == 1 then
		TraceError("�Ƿ�Э�飬�û�α��ͻ��ˣ��û�û�������û�Id:"..user_id)
		return
	end
	if use_chance_not then
		--�۳�ҡ���ӻ���
		end_world.user_list[user_id].chance_num = end_world.user_list[user_id].chance_num - 1
		--�������ݿ�
		end_world_db.update_chance_num(user_id, end_world.user_list[user_id].chance_num)
	end
	--���������Ӵ���
	end_world.user_list[user_id].times = end_world.user_list[user_id].times + 1
	end_world_db.update_times(user_id)
	--��¼��õ�����¼�
	end_world_db.record_mori_event_log(user_id, 0, 0, 0, end_world.user_list[user_id].times, 0)
	end_world.restart_game(user_id)
end

--��Ϸ����
function end_world.restart_game(user_id)
	end_world.user_list[user_id].area_id = 0
	end_world_db.update_area(user_id, 0)
	end_world.user_list[user_id].death = 1
	end_world_db.update_death(user_id, 1)
	if end_world.user_list[user_id] and end_world.user_list[user_id].open_end_world_panel ~= nil then
		local user_info = usermgr.GetUserById(user_id)
		end_world.send_main_windows(user_info)
	end
	
end

--������
function end_world.give_reward(user_id, user_new_area_id, times, send_result)
	local user_info = usermgr.GetUserById(user_id)
	if not user_info then return end
	local reward_id = 0
	if user_new_area_id > 0 and user_new_area_id < 9 then
		reward_id = 1
	elseif user_new_area_id > 8 and user_new_area_id < 18 then
		reward_id = 2
	elseif user_new_area_id > 17 and user_new_area_id < 26 then
		reward_id = 3
	elseif user_new_area_id == 26 then
		reward_id = 4
	end
	--�������
	local find = 0;
	local add = 0;
	local rand = math.random(1, 10000);
	for i = 1, #end_world.BOX_PORBABILITY_LIST[reward_id] do
				add = add + end_world.BOX_PORBABILITY_LIST[reward_id][i];
				if add >= rand then
						find = i;
					break;
				end
	end
	if find == 0 then
		return
	end
	--���ñ����ӿڸ����ߣ����Ϳͻ���Э��
	local type_id          = 0
	local item_gift_id     = 0
	local item_number      = 0
	if find > 0 then
		type_id          = end_world.BOX_ITEM_GIFT_ID[reward_id][find][1]
		item_gift_id     = end_world.BOX_ITEM_GIFT_ID[reward_id][find][2]
		item_number      = end_world.BOX_ITEM_GIFT_ID[reward_id][find][3]
		--��¼��õ�����¼�
		end_world_db.record_mori_event_log(user_id, item_gift_id, type_id, item_number, times, user_new_area_id)
		
		if type_id == 1 or type_id == 7 then
			local call_back = function()
				send_result(1)
			end	
			tex_gamepropslib.set_props_count_by_id(item_gift_id, item_number, user_info, call_back)
			
		elseif type_id == 2 then
			--������
			gift_addgiftitem(user_info, item_gift_id, user_info.userId, user_info.nick, 0)
		elseif type_id == 3 then
			--������
			car_match_db_lib.add_car(user_info.userId, item_gift_id, 0);
		elseif type_id == 4 then
			--����Ʊ
			daxiao_lib.add_exyinpiao(user_info.userId,item_number,0,3)
		elseif type_id == 8 then
			--�ս��¼�
			end_world.user_list[user_id].death = 0
			end_world_db.update_death(user_id, 0)
		end
				

			
	
--	if (item_id == 200002 or item_id == 200003) and tex_gamepropslib.REWARDMSG_ITEM_NAME[item_gift_id] ~= nil then  
--			msg = string.format(msg, match_name, tex_gamepropslib.REWARDMSG_ITEM_NAME[item_gift_id])
--			tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
--	end
--	msg = "��%s�л��%s��"
--	if (item_id == 200004 or item_id == 200005 or item_id == 200006) and type_id == 3 then  
--			msg = string.format(msg, tex_gamepropslib.BOX_NAME[item_id], car_match_lib.CFG_CAR_INFO[item_gift_id]["name"])
--			tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
--	end

--�����Ҫ�����а�
	if end_world.BOX_ITEM_GIFT_ID[reward_id][find][4] then
		local nick_name = string.trans_str(user_info.nick)
		local gift_name = end_world.BOX_ITEM_GIFT_NAME[reward_id][find]
		end_world.add_history(user_info.userId,nick_name,_U(gift_name),reward_id,find)
		
		--��1�ι㲥��
		if reward_id == 1 then
			local msg = "���������·�����˻��%s"
			msg = string.format(msg, gift_name)
			tex_speakerlib.send_sys_msg( _U("��ϲ")..nick_name.._U(msg))
		--�㲥10�ε�
		elseif (reward_id == 3 and find == 6) or
			(reward_id == 3 and find == 7) or
			(reward_id == 4 and find == 6) or
			(reward_id == 4 and find == 7) then
			local msg = "�����%s������·�ϵ�%s�������˻��%s"
			local current_time = os.time()
			local db_time = timelib.lua_to_db_time(current_time)
			msg = string.format(msg, db_time, user_new_area_id, gift_name)
			tex_speakerlib.send_sys_msg( _U("��ϲ")..nick_name.._U(msg))
			for i=1,9 do
				timelib.createplan(function()
					tex_speakerlib.send_sys_msg( _U("��ϲ")..nick_name.._U(msg))
				end,i*24*60)
			end
		--�㲥5��
		else
			local msg = "�����%s������·�ϵ�%s�������˻��%s"
			local current_time = os.time()
			local db_time = timelib.lua_to_db_time(current_time)
			msg = string.format(msg, db_time, user_new_area_id, gift_name)
			tex_speakerlib.send_sys_msg( _U("��ϲ")..nick_name.._U(msg))
			for i=1,4 do
				timelib.createplan(function()
					tex_speakerlib.send_sys_msg( _U("��ϲ")..nick_name.._U(msg))
				end,i*24*60)
			end
		end
	end
	
		return type_id,reward_id,item_gift_id,item_number
	end
end

function end_world.ongameover(e)
	local user_info = e.data.user_info
	if(user_info==nil)then return end
	local user_id = user_info.userId
	local win_gold = e.data.win_gold
	if end_world.check_time() ~= 1 then return end
	if end_world.user_list[user_id] == nil then return end
	local deskinfo = desklist[user_info.desk]
	if not deskinfo then return end
	
	--���һ���Ѿ�����˴���30����ҡ���Ӿͷ���
	if end_world.user_list[user_id].task_type2  == 1 then 
		return 
	end
	
	--��������ֳ�,�����Ѿ�����ʮ���򷵻�
	if end_world.user_list[user_id].play_pan_fresh >= end_world.CFG_MAX_PAN_FRESH and 
			deskinfo.smallbet == 1 then
				return
	end
	
	if deskinfo.smallbet == 1 then
		end_world.user_list[user_id].play_pan_fresh = end_world.user_list[user_id].play_pan_fresh + 1
	else
		end_world.user_list[user_id].play_pan_other = end_world.user_list[user_id].play_pan_other + 1
	end
	end_world_db.update_pan(user_id, end_world.user_list[user_id].play_pan_fresh, end_world.user_list[user_id].play_pan_other)
	
	--���������ʮ��
	if end_world.user_list[user_id].play_pan_fresh + end_world.user_list[user_id].play_pan_other == end_world.CFG_NEED_PAN then
		end_world.user_list[user_id].task_type2 = 1
		end_world_db.update_task(user_id,2,1)
		--��һ��ҡ���ӵĻ���
		end_world.user_list[user_id].chance_num = end_world.user_list[user_id].chance_num + 1
		end_world_db.update_chance_num(user_id, end_world.user_list[user_id].chance_num)
		end_world_db.record_mori_chance_log(user_id,2)
		--todo֪ͨ�ͻ���ˢ�½��棬������ͬѧˢ��
		end_world.send_user_taskinfo(user_info)
		--֪ͨ��ҵõ�һ��ҡ���ӻ���
		end_world.send_main_windows(user_info)
	end

end

--ÿ���Ӹ���һ������
function end_world.timer(e)
	local current_time = os.time()
	--ÿ�������һ��֮ǰһ�������
	--local table_time = os.date("*t",current_time);
	--local now_hour  = tonumber(table_time.hour);
	--local now_minute  = tonumber(table_time.minute);
	if end_world.clear_data_time == nil or  
	end_world.is_today(end_world.clear_data_time,current_time) == 0 then
		for k,v in pairs (end_world.user_list) do
			local user_info = usermgr.GetUserById(k)
			--��һ���ڴ��������ߵ��˵����ݣ��������������ҵ�����ʱ�䣬������
			if user_info == nil then
				end_world.user_list[k] = nil			
			elseif end_world.user_list[k] then
				end_world_db.clear_day_info(k)
				end_world_db.update_end_online_time(k)
				if end_world.user_list[k].death ~= 1 then
					end_world.restart_game(k)
				end
				if end_world.user_list[k].open_end_world_panel == 1 then
					end_world.send_main_windows(user_info)
					end_world.send_user_history(user_info)
					end_world.send_user_taskinfo(user_info)
				end
			end
		end	
		end_world.clear_data_time=current_time
	end

end
--�յ����ÿ�������¼�
function end_world.update_quest_event(e)
	if end_world.check_time() ~= 1 then return end
	local user_info = e.data.userinfo
	local user_id   = user_info.userId
	local finish_num =  tex_dailytask_lib.get_task_info(user_info)
	if finish_num and finish_num == 4 and end_world.user_list[user_id].task_type3 < 1 then
		end_world.user_list[user_id].task_type3 = 1
		end_world_db.update_task(user_id,3,1)
		--��һ��ҡ���ӵĻ���
		end_world.user_list[user_id].chance_num = end_world.user_list[user_id].chance_num + 1
		end_world_db.update_chance_num(user_id, end_world.user_list[user_id].chance_num)
		end_world_db.record_mori_chance_log(user_id,3)
		--todo֪ͨ�ͻ���ˢ�½��棬������ͬѧˢ��
		end_world.send_user_taskinfo(user_info)
		--֪ͨ��ҵõ�һ��ҡ���ӻ���
		end_world.send_main_windows(user_info)
	end
end
--�յ���������¼�
function end_world.after_car_match_event(e)
	if end_world.check_time() ~= 1 then return end
	local car_list = e.data.car_list
    for k,v in pairs (car_list) do
        if v.match_user_id then
            if end_world.user_list[v.match_user_id] and end_world.user_list[v.match_user_id].task_type1 < 2 then
                end_world.user_list[v.match_user_id].task_type1 = end_world.user_list[v.match_user_id].task_type1 + 1
                end_world_db.update_task(v.match_user_id,1,end_world.user_list[v.match_user_id].task_type1)
                --��һ��ҡ���ӵĻ���
                end_world.user_list[v.match_user_id].chance_num = end_world.user_list[v.match_user_id].chance_num + 1
                end_world_db.update_chance_num(v.match_user_id, end_world.user_list[v.match_user_id].chance_num)
                end_world_db.record_mori_chance_log(v.match_user_id,1)
                --todo֪ͨ�ͻ���ˢ�½��棬������ͬѧˢ��
                local user_info = usermgr.GetUserById(v.match_user_id)
								end_world.send_user_taskinfo(user_info)
								end_world.send_main_windows(user_info)
            end
            --�����ұ����˾�����
            if not end_world.user_list[v.match_user_id] and v.match_user_id > 0 then
                end_world_db.update_offline_chance(v.match_user_id)
            end
        end
          
		end
end
--��¼�¼�
function end_world.on_after_user_login(e)
	local user_info = e.data.userinfo;
	if user_info == nil then return end
	local user_id = user_info.userId
	end_world_db.init_user_info(user_id)
end

--�յ�ʹ���и�
function end_world.use_qiegao(user_info, item_id)
	local user_id = user_info.userId
	if not end_world.user_list[user_id] then 
		return
	end
	if end_world.check_time() ~= 1 then return end
	--���ñ����ӿڲ���ĩ�տ������еĻ�������-1
	local set_count_box = function(nCount)
		if nCount >= 1 then
				local call_back = function ()
					--�������ݿ����
					user_info.update_open_box_update_db = 0
					--����ҡ���ӻ���
					end_world.user_list[user_id].chance_num = end_world.user_list[user_id].chance_num + 1
					--�������ݿ�
					end_world_db.update_chance_num(user_id, end_world.user_list[user_id].chance_num)
					end_world_db.record_mori_chance_log(user_id,4)
					--�������
					end_world.send_main_windows(user_info)
					netlib.send(function(buf)
						buf:writeString("TXOPENBOX")
						buf:writeByte(1)									
						buf:writeInt(item_id)
						buf:writeByte(0)
						buf:writeInt(0)
						buf:writeInt(0)
					end, user_info.ip, user_info.port)
				end 
				tex_gamepropslib.set_props_count_by_id(item_id, -1, user_info, call_back)		
		else
			user_info.update_open_box_update_db = 0
			return
		end
	end
	--������ݿ������򷵻�
	if user_info.update_open_box_update_db == 1 then
		return
	end
	--�������ݿ�
	user_info.update_open_box_update_db = 1
	tex_gamepropslib.get_props_count_by_id(item_id, user_info, set_count_box)	
end

function end_world.use_qiegao_onpanel(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	local type_id = buf:readByte() --1 Ϊҡ���� 2 Ϊ����
	if end_world.check_time() ~= 1 then
		 	netlib.send(function(buf)
				buf:writeString("MRBOXCJ")
				buf:writeByte(-1)
				buf:writeInt(0)
				buf:writeInt(0)
				buf:writeByte(0)
				buf:writeInt(0)
				buf:writeInt(0)
				buf:writeInt(0)
				buf:writeInt(0)
			end, user_info.ip, user_info.port)
		 return 
	end
	if type_id == 1 then 
		--�����Ʒ�����򷵻�֪ͨ�ͻ���--todo
		if gift_getgiftcount(user_info) >= 100 then
			net_send_gift_faild(user_info, 5)		--���߿ͻ�����������
			TraceError("���߿ͻ�����������")
			return
		end	
	end
	--���ñ����ӿڲ���ĩ�տ������еĻ�������-1
	if (type_id ~= 1) and (type_id ~= 2) then return end
	local set_count_box = function(nCount)
		if nCount >= 1 then
				local call_back = function ()
					--�������ݿ����
					user_info.update_open_box_update_db = 0				
					--��¼һ��ʹ���и�
					end_world_db.record_mori_chance_log(user_id,4)
					if type_id == 1 then
						end_world.on_game_cj(user_id)
					elseif  type_id == 2 then
						end_world.on_game_cz(user_id)
					end
					--�������
					--end_world.send_main_windows(user_info)
				end 
				local call_back_failed = function()
					--�������ݿ����
					user_info.update_open_box_update_db = 0
					return
				end
				tex_gamepropslib.set_props_count_by_id(200007, -1, user_info, call_back, 11, call_back_failed)		
		else
			user_info.update_open_box_update_db = 0
			return
		end
	end
	--������ݿ������򷵻�
	if user_info.update_open_box_update_db == 1 then
		TraceError("user_info.update_open_box_update_db"..user_info.update_open_box_update_db)
		return
	end
	--�������ݿ�
	user_info.update_open_box_update_db = 1
	tex_gamepropslib.get_props_count_by_id(200007, user_info, set_count_box)	
end

--�ǲ�����ͬһ��
function end_world.is_today(time1,time2)
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
--������ʷ��¼
function end_world.add_history(user_id,nick_name,gift_name,msg_type,find)
	--�Ӷһ���¼�б�	
	local buf_tab={}
	buf_tab.user_id = user_id
	buf_tab.nick_name = nick_name
	buf_tab.gift_name = gift_name
	buf_tab.msg_type = msg_type
	buf_tab.level = end_world.BOX_ITEM_GIFT_ID[msg_type][find][5] or 7
	if #end_world.history_list < end_world.CFG_HISTORY_LEN then
		table.insert(end_world.history_list,buf_tab)
	else
		table.remove(end_world.history_list,1)
		table.insert(end_world.history_list,buf_tab)
	end
	for i=1,#end_world.history_list do
            for j=1,#end_world.history_list - i do
            	if end_world.history_list[j].level then
                if end_world.history_list[j].level < end_world.history_list[j + 1].level then
                    local temp = end_world.history_list[j]
                    end_world.history_list[j] = end_world.history_list[j + 1]
                    end_world.history_list[j + 1] = temp
                end
              end
            end
  end	
	end_world.send_history()
end
--��¼�б�
function end_world.send_history()
	for k1,v1 in pairs(end_world.user_list) do
		local user_info = nil
		if k1 then
				user_info = usermgr.GetUserById(k1)
		end
		if not v1.open_end_world_panel then
		end
		if user_info ~= nil and v1.open_end_world_panel ~= nil then
			end_world.send_user_history(user_info)
		end
   end
end

--�һ��ض���¼�б�
function end_world.send_user_history(user_info)
		if user_info ~= nil then
			netlib.send(function(buf)
			    buf:writeString("MRHISTORY")
			    buf:writeInt(#end_world.history_list)
				for k,v in pairs(end_world.history_list)do
					buf:writeInt(v.user_id)
					buf:writeString(v.nick_name)
					buf:writeString(v.gift_name)
					buf:writeByte(v.msg_type)
				end
		    end,user_info.ip,user_info.port)
		end
end
function end_world.send_user_taskinfo(user_info)
	local user_id = user_info.userId
	if end_world.user_list[user_id] then
		netlib.send(function(buf)
				buf:writeString("MRBOXTASK")
				buf:writeByte(end_world.user_list[user_id].task_type1)
				buf:writeByte(end_world.user_list[user_id].task_type2)
				buf:writeByte(end_world.user_list[user_id].task_type3)
		end,user_info.ip,user_info.port)
	end
end

--�����б�
cmdHandler = 
{
		["MRBOXOP"] = end_world.on_open_panel,--�����
    ["MRBOXST"] = end_world.on_query_status,--�Ƿ����
  	["MRBOXCJ"] = end_world.on_recv_cj,--ҡ����
  	["MRBOXCZ"] = end_world.on_recv_cz,--������Ϸ
    ["MRBOXCLO"] = end_world.on_close_panel,
		["MRBOXUSE"] = end_world.use_qiegao_onpanel,--�ڽ������Զ�ʹ���и�
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("on_user_exit", end_world.on_user_exit)
eventmgr:addEventListener("on_game_over_event", end_world.ongameover)
eventmgr:addEventListener("timer_minute", end_world.timer)
eventmgr:addEventListener("update_quest_event", end_world.update_quest_event)
eventmgr:addEventListener("h2_on_user_login", end_world.on_after_user_login)
eventmgr:addEventListener("after_car_match_event", end_world.after_car_match_event)

