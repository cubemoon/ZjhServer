TraceError("init super_cow_db_lib...")

if super_cow_db_lib and super_cow_db_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", super_cow_db_lib.on_after_user_login);
end

if not super_cow_db_lib then
    super_cow_db_lib = _S
    {    	   
        on_after_user_login = NULL_FUNC,--��½��������
		init_supercow_db = NULL_FUNC, --��ʼ�����ݿ�
		add_cowgamegold = NULL_FUNC, --����Ϸ��
		log_supercow_history = NULL_FUNC, --д�н���־
		update_last_betid = NULL_FUNC, --�������һ����Ϸʱ����ϷID�����ݿ�
		update_db_bet_info = NULL_FUNC,
		get_sys_win_from_db = NULL_FUNC,
        update_sys_win = NULL_FUNC,
        update_user_bet_to_db = NULL_FUNC,
		cfg_game_name = {      --��Ϸ���� 
		    ["soha"] = "soha",
		    ["cow"] = "cow",
		    ["zysz"] = "zysz",
		    ["mj"] = "mj",
		    ["tex"] = "tex",
		},
		

    }    
end

--��½��������
function super_cow_db_lib.on_after_user_login(e)
	local user_info = e.data.userinfo
	if(user_info==nil)then return end
	local user_id=user_info.userId	
	super_cow_db_lib.init_supercow_db(user_id)
end

--�Ӽ�ţţ��Ϸ��
--gold_type:1��Ϸ��Ӯ 2�һ�
function super_cow_db_lib.add_cowgamegold(user_id,add_cowgamegold,gold_type,bet_info,call_back)	
	if(add_cowgamegold==0)then return end --Ϊ0ʱ���仯Ǯ
	if(user_id==nil)then return end --user_idΪ��ʱ���仯Ǯ
	
	if (super_cow_lib.is_valid_room()~=1) then return end
	
	--�ȿ�������ϵ�Ǯ
	local before_cowgamegold=super_cow_lib.user_list[user_id].cowgamegold_count or -1
	
	--�����ݿ����Ǯ	
	local sql="update user_supercow_info set cowgamegold_count=cowgamegold_count+%d where user_id=%d;select cowgamegold_count from user_supercow_info where user_id=%d"
	sql=string.format(sql,add_cowgamegold,user_id,user_id)
	dblib.execute(sql,function (dt)	
		if(dt and #dt>0)then
			local ret_gamegold_count=dt[1].cowgamegold_count
			if(dt[1].cowgamegold_count<0)then 
				ret_gamegold_count=0
				sql="update user_supercow_info set cowgamegold_count=0 where user_id=%d;"
				sql=string.format(sql,user_id)
				dblib.execute(sql,function(dt) end,user_id)				
			end
		
			if(call_back~=nil)then
				call_back(user_id,ret_gamegold_count or -1)
			end
			local user_info=usermgr.GetUserById(user_id)
			if(user_info~=nil)then
				super_cow_lib.send_supercow_gold (user_info,ret_gamegold_count)
			end
			--Ⱥ����Ϣ��֪ͨ�µ�����
			super_cow_lib.send_all_users_flag = 1	
			--��ұ仯��Ҫ������ť�ǲ����ܵ�
			super_cow_lib.send_btn_status(user_id)
		else			
			TraceError(debug.traceback())
			TraceError(dt or -1)
			TraceError("error sql="..sql)
		end
		
	end,user_id)
	

	--д��־
	super_cow_db_lib.log_user_supercow(user_id,before_cowgamegold,add_cowgamegold,gold_type,bet_info)	
end

function super_cow_db_lib.log_supercow_history(zhongjiang_num1,zhongjiang_num2,bet_id)
	local sql="insert into log_supercow_history(zhongjiang_num1,zhongjiang_num2,bet_id,sys_time) value (%d,%d,'%s',now());commit;";
	sql=string.format(sql,zhongjiang_num1,zhongjiang_num2,bet_id);
	dblib.execute(sql);
end

--��¼�����Ϸ�ұ仯
function super_cow_db_lib.log_user_supercow(user_id,before_cowgamegold,add_cowgamegold,goldtype,bet_info)
	local sql="insert into log_user_supercow(user_id,before_cowgamegold,add_cowgamegold,goldtype,bet_info,bet_id,sys_time) value(%d,%d,%d,%d,'%s','%s',now());commit;"
	sql=string.format(sql,user_id,before_cowgamegold,add_cowgamegold,goldtype,bet_info,super_cow_lib.bet_id)
	dblib.execute(sql)    
end

--��¼�����ע���ݵ����ݿ�
function super_cow_db_lib.update_user_bet_to_db(user_id, bet_gold)
    local sql = "insert into user_supercow_temp_bet(user_id, gold, sys_time) value(%d, %d, now()) ON DUPLICATE KEY update gold = gold + %d, sys_time = now();commit;"
    sql = string.format(sql, user_id, bet_gold, bet_gold)
    dblib.execute(sql, function(dt) end, user_id)
end

--ɾ����ʱ��ע����
function super_cow_db_lib.clear_user_temp_bet()
    local sql = "delete from user_supercow_temp_bet;commit;"    
    dblib.execute(sql)
end

--�����ϴ�����ǰ����µ�ע
function super_cow_db_lib.rollback_user_bet()
    local sql = "update user_supercow_info a, user_supercow_temp_bet b set a.cowgamegold_count = a.cowgamegold_count + b.gold where a.user_id = b.user_id"    
    dblib.execute(sql, function(dt) 
        super_cow_db_lib.clear_user_temp_bet()
    end)
end

--��ʼ�����ţţ�����ݲ�����
function super_cow_db_lib.init_supercow_db(user_id,call_back)
	
	local user_info = usermgr.GetUserById(user_id)
	if(user_info==nil)then return end
	
	local sql="call sp_init_supercow(%d,'%s');"	
	sql=string.format(sql,user_id,super_cow_lib.bet_id)
	dblib.execute(sql,function(dt) 
		if(dt and #dt>0)then		
			if(dt[1].cowgamegold_count==nil or (dt[1].cowgamegold_count==0 and dt[1].bet_info==super_cow_lib.CFG_INIT_BET))then
				super_cow_lib.user_list[user_id]={}
				super_cow_lib.user_list[user_id].user_id=user_id
				super_cow_lib.user_list[user_id].nick_name=user_info.nick or ""
				super_cow_lib.user_list[user_id].face=user_info.imgUrl or ""
				super_cow_lib.user_list[user_id].bet_info=super_cow_lib.CFG_INIT_BET
				super_cow_lib.user_list[user_id].bet_id=super_cow_lib.bet_id
				super_cow_lib.user_list[user_id].cowgamegold_count=0
				sql="insert ignore into user_supercow_info(user_id,cowgamegold_count,bet_info,bet_id,user_nick,sys_time) value (%d,%d,'%s','%s','%s',now());"
				sql=string.format(sql,user_id,0,super_cow_lib.CFG_INIT_BET,super_cow_lib.bet_id,string.trans_str(user_info.nick))
				dblib.execute(sql,function(dt) end,user_id)
			else
				super_cow_lib.user_list[user_id]={}
				super_cow_lib.user_list[user_id].user_id=user_id
				super_cow_lib.user_list[user_id].nick_name=user_info.nick
				super_cow_lib.user_list[user_id].face=user_info.imgUrl
				super_cow_lib.user_list[user_id].bet_info=dt[1].bet_info
				super_cow_lib.user_list[user_id].bet_id=super_cow_lib.bet_id			
				super_cow_lib.user_list[user_id].cowgamegold_count=dt[1].cowgamegold_count	
			end
			
		end
		
	end,user_id)
end

function super_cow_db_lib.update_db_bet_info(user_id,bet_info,bet_id)
		--������ע�����
		local sql="update user_supercow_info set bet_info='%s',bet_id='%s' where user_id=%d;commit; "
		sql=string.format(sql,bet_info,bet_id,user_id)
		dblib.execute(sql)
end		

--���������һ��betid
function super_cow_db_lib.update_last_betid(betid)
	--�������ݿ�
	local sql = "insert into cfg_param_info (param_key,param_str_value,room_id) value('SUPERCOW_BETID','-1',%d) on duplicate key update param_str_value = '%s'";
	sql=string.format(sql, groupinfo.groupid,betid)
	dblib.execute(sql)
end

--����ϵͳ��Ӯ�Ľ��
function super_cow_db_lib.update_sys_win(gold)
    --�������ݿ�, ��¼���ַ�������Ϊ�����׳���21��
    local sql = "update supercow_sys_info set gold = '%s', sys_time = now()";
    sql=string.format(sql, tostring(gold))
    dblib.execute(sql)
end

--��ȡϵͳ��Ӯ�Ľ��
function super_cow_db_lib.get_sys_win_from_db(call_back)
    --�������ݿ�
    local sql = "select gold from supercow_sys_info";
    dblib.execute(sql, function(dt) 
        if(dt and #dt>0)then
            call_back(tonumber(dt[1].gold))
        else
            call_back(0)
        end
    end)
end


eventmgr:addEventListener("h2_on_user_login", super_cow_db_lib.on_after_user_login);


 