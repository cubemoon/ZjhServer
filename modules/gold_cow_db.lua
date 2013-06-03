TraceError("init gold_cow_db_lib...")

if gold_cow_db_lib and gold_cow_db_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", gold_cow_db_lib.on_after_user_login);
end

if gold_cow_db_lib and gold_cow_db_lib.on_safebox_sq then
	eventmgr:removeEventListener("on_safebox_sq", gold_cow_db_lib.on_safebox_sq);
end

if not gold_cow_db_lib then
    gold_cow_db_lib = _S
    {    	   
        on_after_user_login = NULL_FUNC,--��½��������	
		record_user_cowgold_info=NULL_FUNC,
		record_cowgamegold_rewardcount=NULL_FUNC,
		record_user_zj_info=NULL_FUNC,--д�н���¼
		log_user_goldcow=NULL_FUNC, --д���˱���־
		log_goldcow_history=NULL_FUNC, --д�����н��ŵ���ʷ����
		on_safebox_sq=NULL_FUNC,
		cfg_game_name = {      --��Ϸ���� 
		    ["soha"] = "soha",
		    ["cow"] = "cow",
		    ["zysz"] = "zysz",
		    ["mj"] = "mj",
		    ["tex"] = "tex",
		},
    }    
end

--
function gold_cow_db_lib.on_after_user_login(e)
	local user_info = e.data.userinfo
	if(user_info==nil)then return end
	if (gold_cow_lib.is_valid_room()~=1) then return end
	
	local user_id=user_info.userId
	gold_cow_db_lib.init_user_safebox_gold(user_id)	
end

function gold_cow_db_lib.on_safebox_sq(e)
	
	local user_info = e.data.userinfo
	if(user_info==nil)then return end
	if (gold_cow_lib.is_valid_room()~=1) then return end
	
	local user_id=user_info.userId
	gold_cow_db_lib.init_user_safebox_gold(user_id)	
end

function gold_cow_db_lib.init_user_safebox_gold(user_id,call_back)
	if gold_cow_lib.check_datetime() == 0 then return end
	local sql="call sp_init_goldcow(%d);"
	sql=string.format(sql,user_id)

	dblib.execute(sql,function(dt)
		if(dt and #dt>0)then
			local user_cowgold_info={}
			user_cowgold_info.user_id=user_id
			user_cowgold_info.lastplay_date=dt[1].last_play_time
			user_cowgold_info.play_count=dt[1].play_count
			user_cowgold_info.cowgamegold_count=dt[1].cowgamegold_count
			user_cowgold_info.cowgamegold_rewardcount=dt[1].cowgamegold_rewardcount
			user_cowgold_info.bet_id=dt[1].bet_id
			if(user_cowgold_info.bet_id~=gold_cow_lib.bet_id)then
				user_cowgold_info.bet_info=gold_cow_lib.org_bet_info
				user_cowgold_info.bet_id=gold_cow_lib.bet_id
			else
				user_cowgold_info.bet_info=dt[1].bet_info
			end

			gold_cow_lib.set_user_cowgold_info(user_cowgold_info)
			
			if(call_back~=nil)then
				local user_info=usermgr.GetUserById(user_id)
				call_back(user_info)
			end
			
		end
	end,user_id)
end

--��¼�������Ϸ����Ϣ�������ж��ǲ��Ǵ�15����
function gold_cow_db_lib.record_user_cowgold_info(user_id,play_count)
	local sql="update user_goldcow_info set play_count=%d,last_play_time=now() where user_id=%d"
	sql=string.format(sql,play_count,user_id)
	dblib.execute(sql,function(dt) end,user_id)
end

--��¼�������Ϸ����Ϣ�������ж��ǲ��Ǵ�15����
function gold_cow_db_lib.record_cowgamegold_rewardcount(user_id,cowgamegold_rewardcount)
	local sql="update user_goldcow_info set cowgamegold_rewardcount=%d where user_id=%d"
	sql=string.format(sql,cowgamegold_rewardcount,user_id)
	dblib.execute(sql,function(dt) end,user_id)
end

--��¼�������Ϸ����Ϣ�������ж��ǲ��Ǵ�15����
function gold_cow_db_lib.log_user_goldcow(user_id,before_cowgamegold,add_cowgamegold,goldtype,bet_info)
	local sql="insert into log_user_goldcow(user_id,before_cowgamegold,add_cowgamegold,goldtype,bet_info,bet_id,sys_time) value(%d,%d,%d,%d,'%s','%s',now());commit;"
	sql=string.format(sql,user_id,before_cowgamegold,add_cowgamegold,goldtype,bet_info,gold_cow_lib.bet_id)
	dblib.execute(sql,function(dt) end,user_id)
end

--д��ʷ������־
function gold_cow_db_lib.log_goldcow_history(zhongjiang_num,bet_id)
 	sql="insert into log_goldcow_history(open_num,bet_id,room_id,sys_time) value (%d,'%s',%d,now());commit;";
 	sql=string.format(sql,zhongjiang_num,bet_id,groupinfo.groupid);
 	dblib.execute(sql);
end

eventmgr:addEventListener("h2_on_user_login", gold_cow_db_lib.on_after_user_login);
eventmgr:addEventListener("on_safebox_sq", gold_cow_db_lib.on_safebox_sq);

 