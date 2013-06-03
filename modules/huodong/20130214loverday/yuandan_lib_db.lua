-------------------------------------------------------
-- �ļ�������yuandan_lib_db.lua
-- �����ߡ���lgy
-- ����ʱ�䣺2012-11-12 15��00��00
-- �ļ������������䣬�Ż�ȯ���11��15��
-------------------------------------------------------

TraceError("init yuandan_lib_db...")
if yuandan_lib_db and yuandan_lib_db.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", yuandan_lib_db.on_after_user_login);
end

if not yuandan_lib_db then
    yuandan_lib_db = _S
    {
    }
end

------------------------------------�ⲿ�ӿ�------------------------------------------
function yuandan_lib_db.on_after_user_login(e)
  if yuandan_lib.check_datetime() == 0 then return end
	local user_info = e.data.userinfo
	if user_info == nil then return end
	local user_id = user_info.userId
	if yuandan_lib.user_list[user_id] == nil then
		yuandan_lib.user_list[user_id] = {}
	end
	
	local current_time = os.time()
	dblib.cache_get("user_yuandan_info", "*", "user_id", user_id,function(dt)
		if dt and #dt>0 then
			yuandan_lib.user_list[user_id].user_id = user_id
			yuandan_lib.user_list[user_id].now_step = {}
			yuandan_lib.user_list[user_id].now_step[1] = dt[1].now_step1
			yuandan_lib.user_list[user_id].now_step[2] = dt[1].now_step2
			yuandan_lib.user_list[user_id].now_step[3] = dt[1].now_step3		
			yuandan_lib.user_list[user_id].now_state = {}
			yuandan_lib.user_list[user_id].now_state[1] = dt[1].now_state1
			yuandan_lib.user_list[user_id].now_state[2] = dt[1].now_state2
			yuandan_lib.user_list[user_id].now_state[3] = dt[1].now_state3
    else
      yuandan_lib.user_list[user_id].user_id = user_id
			yuandan_lib.user_list[user_id].now_step = {}
			yuandan_lib.user_list[user_id].now_step[1] = 1
			yuandan_lib.user_list[user_id].now_step[2] = 1
			yuandan_lib.user_list[user_id].now_step[3] = 1
			yuandan_lib.user_list[user_id].now_state = {}
			yuandan_lib.user_list[user_id].now_state[1] = 1
			yuandan_lib.user_list[user_id].now_state[2] = 1
			yuandan_lib.user_list[user_id].now_state[3] = 1		
			
			dblib.cache_add("user_yuandan_info",{user_id=user_id,now_step1=1,now_step2=1,now_step3=1,now_state1=1,now_state2=1,now_state3=1},nil,user_id)
    end
	end,user_id)
end

--��¼���ƽ�����¼
function yuandan_lib_db.log_yuandan_play_card(user_id, type_game, now_step, type_id)
	local sql = "insert into log_yuandan_play_card(user_id,type_game,now_step,type_id,sys_time) value(%d,%d,%d,%d,now());"
	sql = string.format(sql,user_id,type_game,now_step,type_id)
	dblib.execute(sql)
end
--��¼�һ�������¼�����������ʹ��˱ң�
function yuandan_lib_db.log_yuandan_reward(user_id, type_game, now_step, car_id, cash_num)
	local sql = "insert into log_yuandan_reward(user_id,type_game,now_step,car_id,cash_num,sys_time) value(%d,%d,%d,%d,%d,now());"
	sql = string.format(sql,user_id,type_game,now_step,car_id,cash_num)
	dblib.execute(sql)
end
--��¼��ʼ��Ϸ��¼��ʹ�ô��˱һ��ǽ�ҿ�ʼ�ģ�
function yuandan_lib_db.log_start_playcard(user_id, type_game, type_id)
	local sql = "insert into log_start_playcard(user_id,type_game,type_id,sys_time) value(%d,%d,%d,now());"
	sql = string.format(sql,user_id,type_game,type_id)
	dblib.execute(sql)
end
--��������
function yuandan_lib_db.set_gameinfo(user_id, duihuan_type, now_step, now_state)
	yuandan_lib_db.set_now_step(user_id, duihuan_type, now_step)
	yuandan_lib_db.set_now_state(user_id, duihuan_type, now_state)
end

--������Ϸ����
function yuandan_lib_db.set_now_step(user_id, duihuan_type, now_step)
	if duihuan_type == 1 then
		dblib.cache_set("user_yuandan_info", {now_step1=now_step}, "user_id", user_id, nil, user_id)
	elseif duihuan_type == 2 then
		dblib.cache_set("user_yuandan_info", {now_step2=now_step}, "user_id", user_id, nil, user_id)
	elseif duihuan_type == 3 then
		dblib.cache_set("user_yuandan_info", {now_step3=now_step}, "user_id", user_id, nil, user_id)
	end
end

--������Ϸ״̬
function yuandan_lib_db.set_now_state(user_id, duihuan_type, now_state)
	if duihuan_type == 1 then
		dblib.cache_set("user_yuandan_info", {now_state1=now_state}, "user_id", user_id, nil, user_id)
	elseif duihuan_type == 2 then
		dblib.cache_set("user_yuandan_info", {now_state2=now_state}, "user_id", user_id, nil, user_id)
	elseif duihuan_type == 3 then
		dblib.cache_set("user_yuandan_info", {now_state3=now_state}, "user_id", user_id, nil, user_id)
	end
end

cmdHandler = 
{



}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", yuandan_lib_db.on_after_user_login);

