-------------------------------------------------------
-- �ļ�������end_world_db.lua
-- �����ߡ���lgy
-- ����ʱ�䣺2012-12-13 18��00��00
-- �ļ�����������ĩ�մ������
-------------------------------------------------------
TraceError("init end_world_db...")
if end_world_db and end_world_db.restart_server then
	eventmgr:removeEventListener("on_server_start", end_world_db.restart_server);
end

if not end_world_db then
    end_world_db = _S
    {
    	--�����Ƿ���
        --�����Ǳ�����������Ϣ
    }    
end

function end_world_db.init_user_info(user_id)
	if end_world.user_list[user_id] == nil then
		end_world.user_list[user_id] = {}
    end
    local current_time = os.time()
	local sql = "select * from  user_mori_info where user_id =%d"
	sql = string.format(sql, user_id)
	dblib.execute(sql, function(dt) 
		--��ֹ��������ݿ�ܿ�����ʼ����һ��ʱ����
		local user_info = usermgr.GetUserById(user_id)
		if user_info == nil then return end
		if dt and #dt > 0 then
			end_world.user_list[user_id].area_id = dt[1].area_id
            end_world.user_list[user_id].death = dt[1].death
            end_world.user_list[user_id].chance_num = dt[1].chance_num
			end_world.user_list[user_id].play_pan_fresh = dt[1].play_pan_fresh
			end_world.user_list[user_id].play_pan_other = dt[1].play_pan_other
            end_world.user_list[user_id].task_type1 = dt[1].task_type1
            end_world.user_list[user_id].task_type2 = dt[1].task_type2
            end_world.user_list[user_id].task_type3 = dt[1].task_type3
            end_world.user_list[user_id].times = dt[1].times
            end_world.user_list[user_id].end_online_time = dt[1].end_online_time
		else
			end_world.user_list[user_id].area_id = 0
            end_world.user_list[user_id].death = 1
            end_world.user_list[user_id].chance_num = 0
			end_world.user_list[user_id].play_pan_fresh = 0
			end_world.user_list[user_id].play_pan_other = 0
            end_world.user_list[user_id].task_type1 = 0
            end_world.user_list[user_id].task_type2 = 0
            end_world.user_list[user_id].task_type3 = 0
            end_world.user_list[user_id].times= 0
				
			sql = "insert into user_mori_info(user_id,end_online_time) value(%d,%d)"
			sql = string.format(sql, user_id, current_time)
			dblib.execute(sql, function(dt) end, user_id)
        end
        if end_world.is_today(end_world.user_list[user_id].end_online_time,current_time)~=1 then
            --TraceError("����ͬһ���¼�����������Ϣ���Ƿ񸴻�")
            end_world_db.clear_day_info(user_id)
            end_world_db.update_end_online_time(user_id)
            if end_world.user_list[user_id].death ~= 1 then
                --TraceError("����")
		        end_world.restart_game(user_id)
		    end
        end
	end, user_id)
end

function end_world_db.clear_day_info(user_id)
    if end_world.user_list[user_id] then
        end_world.user_list[user_id].play_pan_fresh = 0
        end_world.user_list[user_id].play_pan_other = 0
        end_world.user_list[user_id].task_type1 = 0
        end_world.user_list[user_id].task_type2 = 0
        end_world.user_list[user_id].task_type3 = 0
    end					
	local sql = "update user_mori_info set play_pan_fresh = 0, play_pan_other = 0, task_type1 = 0, task_type2 = 0, task_type3 = 0 where user_id = %d; commit;"
	sql = string.format(sql, user_id)
	dblib.execute(sql, function(dt) end, user_id)
end
function end_world_db.update_end_online_time(user_id)
    if end_world.user_list[user_id] then
        end_world.user_list[user_id].end_online_time = os.time()
    end
    local sql = "update user_mori_info set end_online_time=%d where user_id = %d; commit;"
	sql = string.format(sql, end_world.user_list[user_id].end_online_time, user_id)
	dblib.execute(sql, function(dt) end, user_id)
end

--�����������
function end_world_db.update_task(user_id, type_id, num)
	local name = "task_type"..type_id
	local sql = "update user_mori_info set %s = %d where user_id = %d; commit;"
	sql = string.format(sql, name, num, user_id)
	dblib.execute(sql, function(dt) end, user_id)
end
--���¾���
function end_world_db.update_pan(user_id, play_pan_fresh, play_pan_other)
	local sql = "update user_mori_info set play_pan_fresh = %d, play_pan_other = %d where user_id = %d; commit;"
	sql = string.format(sql, play_pan_fresh, play_pan_other, user_id)
	dblib.execute(sql, function(dt) end, user_id)
end
--����ҡ���ӻ���
function end_world_db.update_chance_num(user_id, chance_num)
	local sql = "update user_mori_info set chance_num = %d where user_id = %d; commit;"
	sql = string.format(sql, chance_num, user_id)
	dblib.execute(sql, function(dt) end, user_id)
end
--���µ�ͼ����
function end_world_db.update_area(user_id, user_new_area_id)
	local sql = "update user_mori_info set area_id = %d where user_id = %d; commit;"
	sql = string.format(sql, user_new_area_id, user_id)
	dblib.execute(sql,function(dt) end, user_id)
end
--��������״̬ 
function end_world_db.update_death(user_id, death)
	local sql = "update user_mori_info set death = %d where user_id = %d; commit;"
	sql = string.format(sql, death, user_id)
	dblib.execute(sql,function(dt) end, user_id)
end
--���������Ӵ���
function end_world_db.update_times(user_id)
    local sql = "update user_mori_info set times = times + 1 where user_id = %d; commit;"
	sql = string.format(sql, user_id)
	dblib.execute(sql,function(dt) end, user_id)
end

function end_world_db.restart_server(e)
end
--��¼��õ�����¼�
function end_world_db.record_mori_event_log(user_id,item_gift_id,type_id,item_number,times,area_id)
    local sql = "insert into log_mori_event_info(user_id,item_gift_id,type_id,item_number,times,area_id,sys_time) value(%d,%d,%d,%d,%d,%d,now());"
	sql = string.format(sql, user_id, item_gift_id, type_id, item_number, times, area_id)
	dblib.execute(sql,function(dt) end, user_id)
end
--��¼��õĻ���
function end_world_db.record_mori_chance_log(user_id,reason)
    local sql = "insert into log_mori_chance_info(user_id,reason,sys_time) value(%d,%d,now());"
	sql = string.format(sql, user_id, reason)
	dblib.execute(sql,function(dt) end, user_id)
end
--����������ҵĻ�������
function end_world_db.update_offline_chance(user_id)
		if user_id <= 0 then return end
    local sql = "select * from  user_mori_info where user_id = %d"
    sql = string.format(sql, user_id)
    local task_type1 = nil
    local chance_num = nil
    dblib.execute(sql, function(dt) 
			if dt and #dt > 0 then
	            chance_num = dt[1].chance_num
	            task_type1 = dt[1].task_type1
			else	
				sql = "insert into user_mori_info(user_id,end_online_time) value(%d,%d)"
				local current_time = os.time()
				sql = string.format(sql, user_id, current_time)
				dblib.execute(sql, function(dt) end, user_id)
	            task_type1 = 0
	            chance_num = 0
	    end
	    if task_type1 and task_type1 < 2 then
				end_world_db.update_chance_num(user_id, chance_num + 1)
				end_world_db.update_task(user_id,1,task_type1 + 1)
				end_world_db.record_mori_chance_log(user_id,1)
   	 end
		end, user_id)
    
end
--�����б�
cmdHandler = 
{

}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end
eventmgr:addEventListener("on_server_start", end_world_db.restart_server);