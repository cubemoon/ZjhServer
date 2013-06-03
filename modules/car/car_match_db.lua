TraceError("init car_match_db_lib...")

if not car_match_db_lib then
    car_match_db_lib = _S
    {
		--����
  		on_after_user_login = NULL_FUNC, --��½���������
  		add_car = NULL_FUNC, --�ӳ��ӵĽӿ�
		del_car = NULL_FUNU, --�����Ľӿ�
		get_car_info = NULL_FUNC, --ͨ��car_id�õ�������Ϣ
		update_bet_info = NULL_FUNC, --������ע��Ϣ
		add_king_count = NULL_FUNC, --�ӹھ�����
        set_is_using = NULL_FUNC,   --�Ƿ���Ϊ����
		get_bet_gold = NULL_FUNC, --�õ�����Ҫ�˶���Ǯ
		get_return_baoming_gold = NULL_FUNC, --�˱�����
		backup_baoming_table = NULL_FUNC, --���ݱ�����
		query_carinfo_by_type = NULL_FUNC, --�ó������Ͳ鳵����Ϣ
		get_car_list = NULL_FUNC, --ȡ���ӵ���Ϣ
		need_notify_chadui = NULL_FUNC, --��Ҫ֪ͨ���
		record_car_xiazhu_log = NULL_FUNC, --��¼��ע��־
		record_car_car_match_log = NULL_FUNC, --��¼������־
		send_return_gold = NULL_FUNC, --֪ͨ�ͻ�����Ǯ
		car_need_notify_msg = NULL_FUNC, --֪ͨ�ͻ���Ҫ������ӵ���ʾ
		get_bet_count = NULL_FUNC, --������ע����õ���ע�ܶ�
		update_last_matchid = NULL_FUNC, --�������һ�ο��ֵ�match_id
		init_restart_match_id = NULL_FUNC, --��ʼ������ǰ��match_id���ڴ���
		init_today_king_list = NULL_FUNC,
		init_kingcar_list = NULL_FUNC,
		add_kingcar_list = NULL_FUNC,
		clear_week_minren = NULL_FUNC,
		clear_today_minren = NULL_FUNC,
		add_today_minren = NULL_FUNC,
		init_today_minren = NULL_FUNC,
		add_week_minren = NULL_FUNC,
		init_week_minren = NULL_FUNC,
		record_log_match_fajiang = NULL_FUNC,
		record_log_xiazhu_fajiang = NULL_FUNC,
        get_minren_info = NULL_FUNC,        --ȡ������Ϣ
		
		--����

    }
end


------------------------------------�ⲿ�ӿ�------------------------------------------

--�����ֻ��16�����ݣ����Է���lua�ﱸ�ݣ�Ӧ�úܿ�
function car_match_db_lib.backup_baoming_table()
	if(gamepkg.name == "tex" and car_match_lib.CFG_GAME_ROOM ~= tonumber(groupinfo.groupid))then
		return
	end
	local sql="INSERT IGNORE INTO car_back_baoming_info (area_id,car_id,user_id,baoming_num,match_type,match_id,already_return) SELECT area_id,car_id,user_id,baoming_num,match_type,match_id,0 AS already_return FROM car_baoming_info where user_id > 0 and match_type < 3;"
	dblib.execute(sql, function(dt)
        car_match_db_lib.clear_baoming()
        end)
end

function car_match_db_lib.clear_baoming()
	local sql="update car_baoming_info set user_id = 0 where match_type < 3;"
	dblib.execute(sql)
end

--������ע����õ���ע�ܶ�
function car_match_db_lib.get_bet_count(bet_info)
	local tmp_bet_tab = split(bet_info,",")
	local bet_count = 0
	for k,v in pairs(tmp_bet_tab) do
		bet_count = bet_count + tonumber(v)
	end
	return bet_count or 0
end

function car_match_db_lib.init_user_info(user_id)
    --��ʼ��������Ϣ
	 if car_match_lib.user_list==nil then car_match_lib.user_list={} end
	 if car_match_lib.user_list[user_id]==nil then car_match_lib.user_list[user_id]={} end     
	 car_match_lib.user_list[user_id].user_id = user_id
	 
	 local user_info = usermgr.GetUserById(user_id)
     if (user_info ~= nil) then
         car_match_lib.user_list[user_id].nick_name = user_info.nick
         car_match_lib.user_list[user_id].img_url = user_info.imgUrl
     end
	 if car_match_lib.user_list[user_id].match_info == nil then 
            car_match_lib.user_list[user_id].match_info = {{},{}} 
     end
     if (car_match_lib.user_list[user_id].match_info == nil) then
        car_match_lib.user_list[user_id].match_info = {{},{}}
     end
end

function car_match_db_lib.init_user_match(user_id,match_type)
    car_match_db_lib.get_minren_info(user_id, match_type, function(dt)
        if car_match_lib.user_list[user_id].match_info[match_type] == nil then  
            car_match_lib.user_list[user_id].match_info[match_type] = {} 
        end
        local match_id = ""
        if car_match_lib.match_list[match_type] ~= nil then
            match_id = car_match_lib.match_list[match_type].match_id or ""
        end
        car_match_lib.user_list[user_id].match_info[match_type].bet_num_count = 0
        car_match_lib.user_list[user_id].match_info[match_type].bet_info = car_match_lib.CFG_BET_INIT
        car_match_lib.user_list[user_id].match_info[match_type].match_id = match_id 
        car_match_lib.user_list[user_id].match_info[match_type].match_type = match_type
        local today_win_gold = 0
        local week_win_gold = 0
        if dt and #dt>0 then
            today_win_gold = dt[1].today_win_gold
            week_win_gold = dt[1].week_win_gold
        end
        car_match_lib.user_list[user_id].match_info[match_type].today_win_gold = today_win_gold
        car_match_lib.user_list[user_id].match_info[match_type].week_win_gold = week_win_gold
    end)
end

--��½���ʼ��������Ϣ
function car_match_db_lib.on_after_user_login(user_info)
	 if user_info == nil then return end
	 local user_id = user_info.userId
	 --��ʼ����ҵĳ�����Ϣ
	 local reslut = car_match_db_lib.init_car_list(user_id, nil, 0)
	 if reslut == 1 then
	  eventmgr:dispatchEvent(Event("finish_init_car", _S{user_id=user_id}));
	 end
	if (car_match_sj_db_lib) then
	        car_match_sj_db_lib.init_car_list(user_id)
	end
end

function car_match_db_lib.tui_fei(user_info)
    if user_info == nil then return end
	local user_id = user_info.userId
    local return_gold = 0
    local sql = "select user_id,bet_info,match_id,match_type,sys_time from user_car_xiazhu where user_id=%d order by match_type"
    sql = string.format(sql,user_id)
    dblib.execute(sql,function(dt)
        if dt and #dt>0 then
            for i=1,#dt do
                --�����עʱ��match_id�뵱ǰ������match_id��������Ҫ�˱��ٳ�ʼ�� 
                if car_match_lib.match_list[dt[i].match_type] ~= nil and tonumber(dt[i].match_id) ~= tonumber(car_match_lib.match_list[dt[i].match_type].match_id) then
                    return_gold = return_gold + car_match_db_lib.get_bet_gold(dt[i].bet_info,dt[i].match_type, dt[i].sys_time) --����ע��Ǯ
                    car_match_db_lib.init_user_match(user_id,dt[i].match_type)
                else
                    car_match_lib.user_list[user_id].match_info[dt[i].match_type] = {}
                    car_match_lib.user_list[user_id].match_info[dt[i].match_type].bet_info = dt[i].bet_info
                    car_match_lib.user_list[user_id].match_info[dt[i].match_type].match_id = dt[i].match_id
                    car_match_lib.user_list[user_id].match_info[dt[i].match_type].match_type = i
                    car_match_lib.user_list[user_id].match_info[dt[i].match_type].bet_num_count = car_match_db_lib.get_bet_count(dt[i].bet_info)
                    car_match_lib.user_list[user_id].match_info[dt[i].match_type].today_win_gold = dt[i].today_win_gold
                    car_match_lib.user_list[user_id].match_info[dt[i].match_type].week_win_gold = dt[i].week_win_gold
                end
            end
        else
            for i = 1, #car_match_lib.CFG_MATCH_NAME do
                car_match_db_lib.init_user_match(user_id, i)
            end
        end
        if return_gold>0 then
            sql = "update user_car_xiazhu set bet_info='%s' where user_id=%d"
            sql = string.format(sql, car_match_lib.CFG_BET_INIT, user_id)
            dblib.execute(sql, function(dt) end, user_id)
        end
        
        --�����match_id�������ڵģ����˱�����
	    sql = "select baoming_num,match_id,area_id,match_type from car_back_baoming_info where user_id=%d and already_return = 0 and match_type < 3"
        sql = string.format(sql,user_id)
        dblib.execute(sql,function(dt)
                if dt and #dt>0 then
                    for i=1,#dt do
                        local baoming_num = dt[i].baoming_num
                        local match_type = dt[i].match_type
                        if dt[i].match_id ~= car_match_lib.match_list[dt[i].match_type].match_id then
                            return_gold = return_gold + car_match_db_lib.get_return_baoming_gold(match_type,baoming_num)
	 					sql = "delete from car_back_baoming_info where user_id=%d and match_id=%d and match_type < 3"
                            sql = string.format(sql, user_id, dt[i].match_id)
                            dblib.execute(sql, function(dt) end, user_id)
                        end
                    end
                end
                if return_gold>0 then
                    usermgr.addgold(user_id, return_gold, 0, new_gold_type.CAR_MATCH, -1);
                    car_match_db_lib.send_return_gold(user_info,return_gold)
                end
        end,user_id)
    end,user_id)
end

--��ʼ������ǰ��match_id���ڴ���
function car_match_db_lib.init_restart_match_id()
	local sql = "SELECT param_str_value FROM cfg_param_info WHERE param_key = 'CAR_BET1' or param_key = 'CAR_BET2' and room_id=%d order by param_key"
	sql = string.format(sql,groupinfo.groupid);
	dblib.execute(sql,
    function(dt)
    	if dt and #dt > 0 then    		
    		car_match_lib.restart_match_id[1] = dt[1]["param_str_value"]
    		car_match_lib.restart_match_id[2] = dt[2]["param_str_value"]
    	else
    		car_match_lib.restart_match_id[1] = "-1"
    		car_match_lib.restart_match_id[2] = "-1"
		end
	end)
end

--���������һ��betid
function car_match_db_lib.update_last_matchid(match_id, match_type)
	--�������ݿ�
	--TraceError("daxiao_lib.update_last_betid")
	local sql = "insert into cfg_param_info (param_key,param_str_value,room_id) value('CAR_BET%d','-1',%d) on duplicate key update param_str_value = '%s'";
	sql=string.format(sql, match_type, groupinfo.groupid, match_id)
	dblib.execute(sql)
end

--��ѯ��Ƿ���Чʱ��˳�㿴һ��Ҫ��Ҫ��������ʾ��ұ����
function car_match_db_lib.car_need_notify_msg(user_id)
	 --�������ұ���Ӿ͵�һ�´���
	 local sql = "select user_id,match_type from car_notify_msg where user_id=%d and already_notify=0"
	 sql = string.format(sql,user_id)
	 dblib.execute(sql,function(dt)
	 	if dt and #dt>0 then
	 		for i = 1,#dt do
	 			car_match_lib.send_chadui(user_id,dt[i].match_type)
	 		end
	 		sql = "update car_notify_msg set already_notify=1 where user_id=%d"
	 		sql = string.format(sql,user_id)
	 		dblib.execute(sql,function(dt) end,user_id)
	 	end
	 end,user_id) 

end

--���±�����Ϣ
function car_match_db_lib.update_car_baoming(area_id, car_id, user_id, baoming_num, match_type, match_id)
	local sql = "insert into car_baoming_info(area_id, car_id, user_id, baoming_num, match_type, match_id) value(%d,%d,%d,%d,%d,%d) on duplicate key update car_id=%d,user_id=%d,baoming_num=%d,match_id=%d"
	sql = string.format(sql,area_id, car_id, user_id, baoming_num, match_type, match_id, car_id, user_id, baoming_num, match_id)
	dblib.execute(sql,function(dt) end,user_id)
end

--�õ���ע��Ǯ
function car_match_db_lib.get_bet_gold(bet_info, match_type, sys_time)
	local bet_count_tab = split(bet_info,",")

    --���ﴦ����һ���˷ѱ�����2012-11-15���������ߺ��ʻ����������10��
	local user_time = timelib.db_to_lua_time(sys_time)
    local shangxian_time = timelib.db_to_lua_time("2012-11-15 00:00:00")

    local bei_lv = car_match_lib.CFG_BET_RATE[match_type]
    if (user_time < shangxian_time) then
        bei_lv = 100
    end
    local need_gold = 0
	for k,v in pairs (bet_count_tab) do
		need_gold = need_gold + tonumber(v) * bei_lv
	end
	return need_gold
end

--�õ������˵�Ǯ
function car_match_db_lib.get_return_baoming_gold(match_type,return_chadui)
	--���ݱ������ͺ�λ�ü���ع�ʽ��������λ��Ҫ���ٱ�����
	return_chadui = return_chadui - 1
	local baoming_gold = car_match_lib.CFG_BAOMING_GOLD[match_type]
	local chadui_gold = baoming_gold * math.pow(2,return_chadui)
	if return_chadui == 0 then chadui_gold = 0 end
	local add_gold = baoming_gold + chadui_gold
	if chadui_num == 0 then
		add_gold = baoming_gold
	end

    return add_gold
end

--֪ͨ����˱���
function car_match_db_lib.send_return_gold(user_info,return_gold)
 	netlib.send(function(buf)
    	buf:writeString("CARREST");
    	buf:writeInt(return_gold)
    end,user_info.ip,user_info.port);	
end

function car_match_db_lib.update_is_using(user_id, car_id, is_using) 
    local sql = "update user_car_info set is_using = %d where user_id=%d and car_id=%d";
    sql = string.format(sql, is_using, user_id, car_id);
    dblib.execute(sql, function(dt) end, user_id)
    --�ӳ�������һ����ʱ�ᷢ2�θ��ͻ��ˣ��Ժ�һ��Ϊ׼����ΪҪ���ǳ����ɳ��������������ȡ��ʹ���������������Ҫ����һ��������
    car_match_lib.refresh_using_king_count(user_id)
end

--����Ҽ�һ��ָ�����͵ĳ���
function car_match_db_lib.add_car(user_id,car_type, is_using, can_sale)
	local org_car_cost = 0
	if car_match_lib.CFG_CAR_INFO[car_type] ~= nil then 
		org_car_cost = car_match_lib.CFG_CAR_INFO[car_type].cost
	end
	--Ĭ���ǿ����۵�
	if can_sale == nil then
		can_sale = 1
	end
	local sql = "insert into user_car_info(user_id,car_type,nick_name, is_using,car_prize,cansale) value(%d,%d,'%s', %d,%d,%d);"
	local user_info = usermgr.GetUserById(user_id)
	local nick_name = ""
	if user_info ~= nil then
		nick_name = string.trans_str(user_info.nick)
	end
	sql = string.format(sql,user_id,car_type,nick_name, is_using or 0,org_car_cost,can_sale);
	dblib.execute(sql,function(dt) end,user_id)

	--д��־
	sql = "insert into log_car_change(user_id,car_type,change_type,sys_time)value(%d,%d,1,now())"
	sql = string.format(sql,user_id,car_type)
	dblib.execute(sql,function(dt) end,user_id)
	
	
	--���˳����޸��ڴ��car
	car_match_db_lib.init_car_list(user_id, nil, 1)
end

--�ӵ��ھ��б�
function car_match_db_lib.add_king_list(match_type, king_info)
	local nick_name = string.trans_str(king_info.nick_name)
	local sql = "insert into car_king_list(match_type, user_id,nick_name,car_id,car_type,area_id,sys_time) value(%d,%d,'%s',%d,%d,%d,now())"
	sql = string.format(sql, match_type, king_info.user_id, nick_name, king_info.car_id, king_info.car_type, king_info.area_id)			
	dblib.execute(sql,function(dt) end,user_id)
end

--��ʼ��king_list
function car_match_db_lib.init_king_list()
	if car_match_lib.king_list[1] == nil then car_match_lib.king_list[1] = {} end
	if car_match_lib.king_list[2] == nil then car_match_lib.king_list[2] = {} end
	
	local sql = "select match_type, user_id,nick_name,car_id,car_type,area_id from car_king_list where match_type < 3 order by id desc limit "..car_match_lib.CFG_KING_LEN
	dblib.execute(sql,function(dt) 
		if dt and #dt>0 then
			for k,v in pairs(dt)do
				local buf_tab = {
					["user_id"] = v.user_id,
					["nick_name"] = v.nick_name,
					["car_id"] = v.car_id,
					["car_type"] = v.car_type,
					["area_id"] = v.area_id
				}
				table.insert(car_match_lib.king_list[v.match_type], buf_tab)
			
			end
		end
	end)
end

--��ʼ��king_list
function car_match_db_lib.init_today_king_list()
	if car_match_lib.today_king_list[1] == nil then car_match_lib.today_king_list[1] = {} end
	if car_match_lib.today_king_list[2] == nil then car_match_lib.today_king_list[2] = {} end
	
   	local sql = "SELECT a.*,b.king_count,b.car_prize FROM car_king_list a,user_car_info b WHERE a.car_id=b.car_id and match_type < 3 ORDER BY id DESC limit "..car_match_lib.CFG_TODAY_KING_LEN
	dblib.execute(sql,function(dt)
		if dt and #dt>0 then
			for k,v in pairs(dt)do
				local buf_tab = {
                    ["id"] = v.id,
					["user_id"] = v.user_id,
					["nick_name"] = v.nick_name,
					["car_id"] = v.car_id,
					["car_type"] = v.car_type,
					["area_id"] = v.area_id,
					["king_count"] = v.king_count,
					["car_prize"] = v.car_prize,
				}
				table.insert(car_match_lib.today_king_list[v.match_type], buf_tab)
            end
            table.sort(car_match_lib.today_king_list[1], function(a, b) 
                    return a.id < b.id
                end)
            table.sort(car_match_lib.today_king_list[2], function(a, b) 
                    return a.id < b.id
                end)
			--ɾ��7��ǰ�����ݷ�ֹ����̫��
			sql = "DELETE FROM car_king_list WHERE match_type < 3 and sys_time< DATE(DATE_SUB(NOW(),INTERVAL 7 DAY));"
			dblib.execute(sql)
		end
	end)
end

--ɾ��ĳ����ҵĳ�
function car_match_db_lib.del_car(user_id,car_id)
	local sql = "delete from user_car_info where car_id=%d;"
	sql = string.format(sql,car_id)
	dblib.execute(sql,function(dt) end,user_id)
	if car_match_lib.user_list[user_id]~=nil and car_match_lib.user_list[user_id].car_list~=nil then
		car_match_lib.user_list[user_id].car_list[car_id] = nil
	end
	
	--д��־
	sql = "insert into log_car_change(user_id,car_id,change_type,sys_time)value(%d,%d,2,now())"
	sql = string.format(sql,user_id,car_id)
	dblib.execute(sql,function(dt) end,user_id)
	
	--���˳����޸��ڴ��car
	car_match_db_lib.init_car_list(user_id, nil, 1)
end

--ͨ��car_idȡ������Ϣ����������ѷ���������ʹ��
function car_match_db_lib.get_car_info(car_id,call_back)
	if call_back == nil then return end
	local buf_tab = {}
	local sql = "select * from user_car_info where car_id=%d"
	sql = string.format(sql,car_id)
	dblib.execute(sql,function(dt)
		if dt and #dt>0 then            
			buf_tab.car_id = dt[1].car_id
			buf_tab.car_type = dt[1].car_type
			buf_tab.hui_xin = dt[1].hui_xin
			buf_tab.king_count = dt[1].king_count
			buf_tab.is_using = dt[1].is_using
			buf_tab.cansale = dt[1].cansale
			buf_tab.car_prize = dt[1].car_prize
			--���س�����Ϣ
			call_back(buf_tab)
			
		end
	 	
	 end,user_id)
end

--ͨ�� "car_id,car_id,car_id.......car_id"ȡ������Ϣ
function car_match_db_lib.get_car_list(car_info,call_back)
	if call_back == nil then return end
	if car_info==nil or car_info=="" then return end
	local buf_tab_list = {}
	local sql = "select car_id,user_id,nick_name,car_type,hui_xin,king_count,is_using,cansale,car_prize from user_car_info where car_id in (%s)"
	sql = string.format(sql,car_info)
	dblib.execute(sql,function(dt)
		if dt and #dt>0 then
			for i=1,#dt do
				local buf_tab = {}
				buf_tab.user_id = dt[i].user_id	
				buf_tab.nick_name = dt[i].nick_name				
				buf_tab.car_id = dt[i].car_id
				buf_tab.car_type = dt[i].car_type
				buf_tab.hui_xin = dt[i].hui_xin
				buf_tab.king_count = dt[i].king_count
				buf_tab.is_using = dt[i].is_using
				buf_tab.cansale = dt[i].cansale
				buf_tab.car_prize = dt[i].car_prize
                buf_tab.jiacheng = car_match_lib.get_jiacheng(dt[i].user_id, dt[i].car_id)
				table.insert(buf_tab_list,buf_tab)
			end
			--���س�����Ϣ
			call_back(buf_tab_list)
			
		end
	 	
	 end,user_id)
end


--ͨ��user_idȡ������Ϣ
function car_match_db_lib.init_car_list(user_id,call_back, refresh)
	 if car_match_lib.user_list==nil then car_match_lib.user_list={} end
	 if car_match_lib.user_list[user_id]==nil then 
         car_match_lib.user_list[user_id]={}
     elseif (car_match_lib.user_list[user_id].car_list ~= nil and (refresh == nil or refresh == 0)) then
        if (call_back) then
            call_back(car_match_lib.user_list[user_id].car_list or {})
        end
        return 1--�����Ѿ���ʼ�����ˣ������ٳ�ʼ����
     end
     --����Ѿ���ʼ������
     if (car_match_lib.user_list[user_id] ~= nil) then
         if (car_match_lib.user_list[user_id].init_from_db == 1 and (refresh == nil or refresh == 0)) then
            if (call_back ~= nil) then
                call_back(car_match_lib.user_list[user_id].car_list or {})
            end
            return 1
         end
         if (car_match_lib.user_list[user_id].init_from_db == nil) then
            car_match_lib.user_list[user_id].init_from_db = 1
         end
     end
	 --��ʼ���û�������Ϣ
     car_match_db_lib.init_user_info(user_id)

	 local sql = "select car_id,car_type,hui_xin,king_count,is_using,cansale,car_prize from user_car_info where user_id=%d"
	 sql = string.format(sql,user_id)
	 dblib.execute(sql,function(dt)
		if dt and #dt>0 then
			car_match_lib.user_list[user_id].car_list = {}
			for i=1,#dt do	
                if (dt[i].car_type > 0) then
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id] = {}
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id].car_id = dt[i].car_id
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id].car_type = dt[i].car_type
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id].hui_xin = dt[i].hui_xin
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id].king_count = dt[i].king_count
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id].is_using = dt[i].is_using
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id].cansale = dt[i].cansale
    				car_match_lib.user_list[user_id].car_list[dt[i].car_id].car_prize = dt[i].car_prize
			    end
			end
			
		else
			-- һ������û�еĵ�˿
			car_match_lib.user_list[user_id].car_list = {}
		end	
		
		--��ʼ��һ����ҵùھ�����Ϣ
		car_match_lib.init_user_king_info(user_id)	
		--���û��������仯ʱ�ɷ�
		eventmgr:dispatchEvent(Event("already_init_car", _S{user_id=user_id}));
        --������Ϣ��ʼ�����ĵ��ã���init_car_list�����õ�ʱ��͵���
        eventmgr:dispatchEvent(Event("finish_init_car", _S{user_id=user_id}));
		if call_back~=nil then
			call_back(car_match_lib.user_list[user_id].car_list)
		end
	 	
	 end,user_id)
end

--������ע��Ϣ
function car_match_db_lib.update_bet_info(user_id,bet_info,match_id,match_type)
    local sql="insert into user_car_xiazhu(user_id,bet_info,match_id,match_type,sys_time) value(%d,'%s',%d,%d,now()) on duplicate key update bet_info='%s',match_id=%d,sys_time=now();commit; "
    sql=string.format(sql,user_id,bet_info,match_id,match_type,bet_info,match_id)
    dblib.execute(sql,function(dt) end,user_id)
end

--���ھ�����һ�ιھ�����
function car_match_db_lib.add_king_count(car_id)
	local sql = "update user_car_info set king_count = king_count+1,hui_xin=0 where car_id=%d"
	sql = string.format(sql, car_id )
	dblib.execute(sql)
end

--�����˵ĳ��ӻ���ֵ
--����ֵ�����ֵ��10
function car_match_db_lib.add_hui_xin(car_id)
	local sql = "update user_car_info set hui_xin=hui_xin+1 where car_id=%d and hui_xin<%d"
	sql = string.format(sql,car_id,car_match_lib.CFG_MAX_HUIXIN)
	dblib.execute(sql)
end

--��¼��ұ���ӵ���Ϣ
function car_match_db_lib.need_notify_chadui(user_id,match_type)
	local sql = "insert into car_notify_msg(user_id,match_type,already_notify,sys_time) value(%d,%d,0,now()) on duplicate key update user_id=%d,match_type=%d,already_notify=0,sys_time=now()"
	sql = string.format(sql, user_id, match_type, user_id, match_type)
	dblib.execute(sql,function(dt) end,user_id)
end

--�ó������Ͳ鳵����Ϣ
function car_match_db_lib.query_carinfo_by_type(user_id, car_type, site, call_back)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	if call_back == nil then return end
	local sql = "select car_id,car_type,king_count,car_prize from user_car_info where user_id=%d and car_type=%d and is_using=1 limit 1"
	sql = string.format(sql,user_id,car_type)

	dblib.execute(sql,function(dt)
		if dt and #dt>0 then
			local buf_tab = {}
			buf_tab.car_id = dt[1].car_id
			buf_tab.car_type = dt[1].car_type
			buf_tab.king_count = dt[1].king_count
			buf_tab.car_prize = dt[1].car_prize
			call_back(user_info, buf_tab, site)
		end
	end,user_id)
	
end

function car_match_db_lib.record_car_xiazhu_log(user_id,area_id,yinpiao,match_id,match_type,bet_info)
	local sql = "insert into log_car_xiazhu(user_id,area_id,yinpiao,match_id,match_type,bet_info,sys_time) value(%d,%d,%d,%d,%d,'%s',now())"
	sql = string.format(sql,user_id,area_id,yinpiao,match_id,match_type,bet_info)
	dblib.execute(sql,function(dt) end,user_id)
end

function car_match_db_lib.record_car_car_match_log(user_id, area_id, match_id, match_type, car_id)
	local sql = "insert into log_car_match(user_id,area_id,match_id, match_type,car_id,sys_time) value(%d,%d,%d,%d,%d,now())"
	sql = string.format(sql, user_id, area_id, match_id, match_type, car_id)
	dblib.execute(sql,function(dt) end,user_id)
end

function car_match_db_lib.record_car_baoming_log(area_id,car_id,user_id,match_id,match_type,baoming_gold)
	local sql = "insert into log_car_baoming_info(area_id,car_id,user_id,match_id,match_type,baoming_gold,sys_time) value(%d,%d,%d,%d,%d,%d,now())"
	sql = string.format(sql,area_id,car_id,user_id,match_id,match_type,baoming_gold)
	
	dblib.execute(sql,function(dt) end,user_id)
end



--����֮����ʼ��
function car_match_db_lib.init_kingcar_list()
	car_match_lib.king_car_list = {}
	car_match_lib.king_car_list[1] = {}
	car_match_lib.king_car_list[2] = {}
	local sql = "select * from t_king_car order by king_count desc limit 10"
	dblib.execute(sql, function(dt)
		if dt and #dt>0 then
			for i = 1, #dt do
				local buf_tab = {
					["user_id"] = dt[i].user_id,
					["nick_name"] = dt[i].nick_name,
					["car_id"] = dt[i].car_id,
					["car_type"] = dt[i].car_type,
					["king_count"] = dt[i].king_count,
					["car_prize"] = dt[i].car_prize,
				}
				table.insert(car_match_lib.king_car_list[dt[i].match_type], buf_tab)
			end
		
		end
		
		--ɾ��7��ǰ�����ݷ�ֹ����̫��,����֮��һֱ���������Բ���������
		--sql = "DELETE FROM t_king_car WHERE sys_time< DATE(DATE_SUB(NOW(),INTERVAL 7 DAY));"
		--dblib.execute(sql)
	end)
end

--����֮��
function car_match_db_lib.add_kingcar_list(match_type, buf_tab)
	local user_id = buf_tab.user_id
	local nick_name = string.trans_str(buf_tab.nick_name)
	local car_id = buf_tab.car_id
	local car_type = buf_tab.car_type
	local king_count = buf_tab.king_count
	local car_prize = buf_tab.car_prize
	local area_id = buf_tab.area_id
	local sql = "insert into t_king_car(user_id, match_type, nick_name, car_id, car_type,area_id, king_count, car_prize,sys_time) value(%d,%d,'%s',%d,%d,%d,%d,%d,now()) on duplicate key update user_id=%d,nick_name='%s',king_count=%d,car_prize=%d,area_id=%d,sys_time = now();"
	sql = string.format(sql, user_id, match_type, nick_name, car_id, car_type, area_id, king_count, car_prize, user_id, nick_name, king_count, car_prize, area_id)
	dblib.execute(sql, function(dt) end, user_id)
	
end

function car_match_db_lib.init_week_minren()
	car_match_lib.history_minren_list = {}
	car_match_lib.history_minren_list[1] = {}
	car_match_lib.history_minren_list[2] = {}
	local sql = "select * from t_minren_info where week_win_gold > 0 order by week_win_gold desc limit 10"
	dblib.execute(sql, function(dt)
		if dt and #dt>0 then
			for i = 1, #dt do
				local buf_tab = {
					["user_id"] = dt[i].user_id,
					["nick_name"] = dt[i].nick_name,
					["img_url"] = dt[i].img_url,
					["week_win_gold"] = dt[i].week_win_gold
				}
				table.insert(car_match_lib.history_minren_list[dt[i].match_type], buf_tab)
			end
		
		end
		
		--ɾ��7��ǰ�����ݷ�ֹ����̫��
		sql = "DELETE FROM t_minren_info WHERE sys_time< DATE(DATE_SUB(NOW(),INTERVAL 7 DAY));"
		dblib.execute(sql)
	end)
end

function car_match_db_lib.add_week_minren(match_type, buf_tab)
	local user_id = buf_tab.user_id
	local nick_name = string.trans_str(buf_tab.nick_name)
	local img_url = buf_tab.img_url
	local week_win_gold = buf_tab.week_win_gold

	local sql = "insert into t_minren_info(user_id, match_type, nick_name, img_url, week_win_gold, sys_time) value(%d,%d,'%s','%s',%d,now()) on duplicate key update nick_name='%s',img_url='%s',week_win_gold=%d,sys_time = now();"
	sql = string.format(sql, user_id, match_type, nick_name,img_url, week_win_gold, nick_name, img_url,week_win_gold)
	dblib.execute(sql, function(dt) end, user_id)
	
end
function car_match_db_lib.init_today_minren()
	car_match_lib.today_minren_list = {}
	car_match_lib.today_minren_list[1] = {}
	car_match_lib.today_minren_list[2] = {}
	local sql = "select * from t_minren_info where today_win_gold > 0 order by today_win_gold desc limit 10"
	dblib.execute(sql, function(dt)
		if dt and #dt>0 then
			for i = 1, #dt do
				local buf_tab = {
					["user_id"] = dt[i].user_id,
					["nick_name"] = dt[i].nick_name,
					["img_url"] = dt[i].img_url,
					["today_win_gold"] = dt[i].today_win_gold
				}
				table.insert(car_match_lib.today_minren_list[dt[i].match_type], buf_tab)
			end
		end
	end)
end

--��Ϊ7�����һ�����ݣ���������ֱ��ȫ�滻��������Ӧ�ò���
function car_match_db_lib.clear_today_minren()
	local sql = "update t_minren_info set today_win_gold = 0"
	dblib.execute(sql)	

end

--��Ϊ7�����һ�����ݣ���������ֱ��ȫ�滻��������Ӧ�ò���
function car_match_db_lib.clear_week_minren()
	local sql = "update t_minren_info set week_win_gold = 0"
	dblib.execute(sql)	

end

function car_match_db_lib.add_today_minren(match_type, buf_tab)
	local user_id = buf_tab.user_id
	local nick_name = string.trans_str(buf_tab.nick_name)
	local img_url = buf_tab.img_url
	local today_win_gold = buf_tab.today_win_gold

	local sql = "insert into t_minren_info(user_id, match_type, nick_name, img_url, today_win_gold, sys_time) value(%d,%d,'%s','%s',%d,now()) on duplicate key update nick_name='%s',img_url='%s',today_win_gold=%d,sys_time = now();"
	sql = string.format(sql, user_id, match_type, nick_name,img_url, today_win_gold, nick_name, img_url,today_win_gold)
	dblib.execute(sql, function(dt) end, user_id)
	
end

function car_match_db_lib.record_log_match_fajiang(user_id, add_gold, match_type)
	local sql = "insert into log_match_fajiang(user_id,add_gold,match_type,sys_time) value(%d,%d,%d,now())"
	sql = string.format(sql,user_id, add_gold, match_type)	
	dblib.execute(sql,function(dt) end, user_id)
end

function car_match_db_lib.record_log_xiazhu_fajiang(user_id, add_gold, match_type, bet_info)
	local sql = "insert into log_xiazhu_fajiang(user_id,add_gold,match_type,bet_info, sys_time) value(%d,%d,%d,'%s',now())"
	sql = string.format(sql,user_id, add_gold, match_type, bet_info)	
	dblib.execute(sql,function(dt) end, user_id)
end

function car_match_db_lib.get_minren_info(user_id, match_type, callback)
    local sql = "select today_win_gold, week_win_gold from t_minren_info where match_type = %d and user_id = %d"
    sql = string.format(sql, match_type, user_id)
    dblib.execute(sql, function(dt) callback(dt) end, user_id)
end

cmdHandler = 
{


}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end


