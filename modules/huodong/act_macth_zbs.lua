TraceError("init act_macth_lib...��ʼ����������Ϣ")
if act_macth_lib and act_macth_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", act_macth_lib.on_after_user_login);
end

if act_macth_lib and act_macth_lib.ontimecheck then
	eventmgr:removeEventListener("timer_minute", act_macth_lib.ontimecheck);
end

if act_macth_lib and act_macth_lib.ongameover then 
	eventmgr:removeEventListener("game_event", act_macth_lib.ongameover);
end
 
--����ר��
if act_macth_lib and act_macth_lib.ongamebegin then  
	eventmgr:removeEventListener("game_begin_event", act_macth_lib.ongamebegin);
end

if not act_macth_lib then
	act_macth_lib = _S
	{ 
		on_after_user_login = NULL_FUNC,	--�û���½���ʼ������
		check_datetime = NULL_FUNC,		--�����Чʱ�䣬��ʱ���� 
		can_join_invite_match = NULL_FUNC,		--�ж��ǲ�����Ч�ı���
		ongameover = NULL_FUNC,		--��Ϸ�����ɼ�����
		ontimecheck = NULL_FUNC,		--��ʱˢ���¼�
	 	update_invite_db = NULL_FUNC,	--���±�����Ϣ
	 	update_play_count = NULL_FUNC, 	--�����������
		init_invite_ph = NULL_FUNC,		--��ʼ�����а�
	 	on_recv_invite_ph_list = NULL_FUNC,		--���󾺼��������а�
	 	--on_recv_invite_dj = NULL_FUNC,		--��д���������콱������°汾�в���ʹ���ˣ��ȱ�������ֹ�Ժ�Ҫ��ʵ�ｱ
	 	--init_invate_match = NULL_FUNC,		--���ɱ���ID������¼��α�����������ÿ��������ͬһʱ�̣�ֻ����һ������������ֱ�������Ӻ�+ʱ�����Ψһ��
	 	--get_invate_match_id = NULL_FUNC,		--�õ���������ID
	 	get_invate_match_count = NULL_FUNC,		--�����������
	 	on_recv_refresh_timeinfo = NULL_FUNC,	--��������ֺͽ������������
	 	on_recv_already_know_reward = NULL_FUNC,		--�ͻ���֪ͨ�Ѿ�����콱��ť��(��������ʱ��ʹ�ã���ֹ�߼����ֻ��ң�
	 	invite_update_user_play_count = NULL_FUNC,		--�û���¼���ʼ������
	 	consider_screen = NULL_FUNC,	--����ڼ���
	 	invite_match_fajiang = NULL_FUNC,		--����ҷ���    ����������ٴ�һ�̾ͷ��������ص�½ʱ�ŷ���
	 	on_recv_activity_stat = NULL_FUNC,	--����ʱ��״̬
	 	on_recv_sign = NULL_FUNC,		--����������
	 	sign_succes = NULL_FUNC,	--�����ɹ�
	 	inster_invite_db = NULL_FUNC,	--����д���ݿ�
	 	on_recv_buy_ticket = NULL_FUNC,		--���������ȯ
	 	send_buy_ticket_result = NULL_FUNC,	--���͹������ȯ��� 
		chaxun_add_items = NULL_FUNC,		--����  ��ѯ  �ͼ�   ���߹��÷��� 
		send_pm_list = NULL_FUNC,		--�������а� 
		init_invate_match = NULL_FUNC,			--��ʼ����������Ҫ������
	 	ongamebegin = NULL_FUNC, 		--���ݣ����� ר�ã�
		ontimer_broad = NULL_FUNC,		-- ȫ�����㲥(����ר��)
		send_fajiang_msg = NULL_FUNC,		--���ͷ�����Ϣ 
	 	
	 	start_baoming_date = "2012-05-31",	--�������ʼʱ��
		statime = "2012-05-31 02:00:00",  --���ʼʱ��
	    endtime = "2012-06-06 23:00:00",  --�����ʱ�� 
	    rank_endtime = "2012-06-08 00:00:00",	--���а����ʱ��
	      
	    start_day = 20120530,	--���ڼ���ڼ��� ��ʼʱ��
	 --   exttime = "2011-11-14 00:00:00",  --ֻ���콱ʱ��
	  
	    cfg_qp_game_name = {      --������Ϸ����  
        	["zysz"] = "zysz",
        	["mj"] = "mj", 
    					},
    				
    	cfg_tex_game_name = {      --������Ϸ����   
        	["tex"] = "tex",
    					},
    	
    	room_smallbet1 = -50,
	    room_smallbet2 = -50,
	    room_smallbet3 = 50000,
	    room_smallbet4 = -50,
	    room_smallbet5 = -50,
	    refresh_invate_time = -1,  --��һ��ˢ�����а��ʱ��
		last_msg_time = -1, --��һ�η���Ϣ��ʱ��
		
		zysz_gs_id = 62022,                      --  �������Ŷ�����id
		
		mj_yk_id = 3350,				--	�齫�οͳ�id
		mj_xunlian_id = 3001,			--  �齫��ϰ��id
		mj_xs_id = 3002,				--  �齫���ֳ�id
		mj_gs_id = 3003,				--  �齫���ֳ�id
		mj_8f_id = 3091,				--  �齫8�������id
		mj_super_id = 3005,				--  �齫�������ֳ�id
		
		qp_mp_id  = 8003,                         -- ��Ʊ
		  
	    invite_ph_list_zj = {}, --ר�ҳ�����
	    invite_ph_list_zy = {}, --ְҵ������
	    invite_ph_list_yy = {}, --ҵ�ೡ����
	    
	    invite_qp_mj_ph_list = {}; --�齫����
		invite_qp_zysz_ph_list = {};	--������������
		
		OP_MENPIAO_PRIZE={			--��Ʊ�ļ۸�
    		["qp"]=20000,
    		["tex"]=5000,
    		},
	}
end

--����ר��(����  ����)
function act_macth_lib.ongamebegin(e)
	local deskno=e.data.deskno
	if(deskno==nil)then return end
	act_macth_lib.init_invate_match(deskno)
	
end
 
--�����Чʱ��
--3 ���Ա���,2���Ա����ͱ���,3�����콱, 0����
function act_macth_lib.check_datetime()
	local statime = timelib.db_to_lua_time(act_macth_lib.statime);
	local endtime = timelib.db_to_lua_time(act_macth_lib.endtime);
	local lj_time = timelib.db_to_lua_time(act_macth_lib.rank_endtime); 
	local sys_time = os.time();
	--�����콱��������Ϸʱ��
	if(sys_time >= statime and sys_time <= endtime) then
		    local tdate = os.date("*t", sys_time);		    
	        if (tdate.hour >= 20 and tdate.hour < 23)  then
	            return 2;
			else
				return 3
	        end	        
	end	
	
	--ֻ���콱
	if(sys_time > endtime and sys_time <= lj_time) then
        return 1;
	end	
	 
	--�ʱ���ȥ��
	return 0;
end

--�ж��ǲ�����Ч�ı���
function act_macth_lib.can_join_invite_match(user_info,deskinfo,match_num)
	--TraceError("--�ж��ǲ�����Ч�ı���, userId:"..user_info.userId.." match_num:"..match_num)
	
	--1.ʱ���ж� 
	if(act_macth_lib.check_datetime()~= 2)then
	   
    	--TraceError("--�ж��ǲ�����Ч�ı���->>>>ʱ���ж�    ʧ��")
		return false
	end

	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		--�ж�ʱ��ĺϷ���,0���Ϸ���1ֻ�����콱��Ϣ��2�����콱��Ϣ�ͱ���
		if(deskinfo ~= nil and deskinfo.smallbet ~= act_macth_lib.room_smallbet1 and deskinfo.smallbet ~= act_macth_lib.room_smallbet2 and deskinfo.smallbet ~= act_macth_lib.room_smallbet3 and deskinfo.smallbet ~= act_macth_lib.room_smallbet4 and deskinfo.smallbet ~= act_macth_lib.room_smallbet5)then
			--TraceError("--�ж��ǲ�����Ч�ı���->>>deskinfo,room_smallbet1,room_smallbet2")
			return false
		end
		
		--�ж�3�����ϲ�����Ч��������¼����
	    if(match_num < 3)then
	   		--TraceError("--�жϲ�����Ч�ı���-->>>����      ������"..match_num)
	    	return false
	    end
	end
     
    --����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	--TraceError("--�жϲ�����Ч�ı���-->>>����    ")

    	--�齫  ���ж�  4�˶���
    	
    	
    	--��������  ���ֳ�3�˼������ж�
    	--��ȡ���� 
	--	local desk_nu = user_info.desk
	--	local deskinfo = desklist[desk_nu] 
	--	local playercount = deskinfo.playercount 
    	if(gamepkg.name == "zysz" and tonumber(groupinfo.groupid) ~= act_macth_lib.zysz_gs_id)then
    		--TraceError("--�жϲ�����Ч�ı���-->>>����     ��������  ���Ǹ��ֳ� ����")
	    	return false  
    	end
    	
    	--�ж�3�����ϲ�����Ч��������¼����
	    if(match_num < 3)then
	   		--TraceError("--�жϲ�����Ч�ı���-->>> ����  ����  ������"..match_num)
	    	return false
	    end
    end
     
    return true
end

--��Ϸ�����ɼ�����
function act_macth_lib.ongameover(gameeventdata)
	
	--�ʱ����Ч��
	local check_time = act_macth_lib.check_datetime()
    if(check_time == 0 or check_time == 1) then
    	--TraceError(" ��Ϸ�����¼�����->ʱ����Ч��,ʧЧ->if(check_time == 0 and check_time == 5)-- userid:"..user_info.userId)
        return;
    end
    
	if gameeventdata == nil then return end
	
	--��Ϸ�¼���֤
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("��Ϸ�����ɼ�����    gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("��Ϸ�����ɼ�����->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end

    local userid = 0
    local match_gold = 0
    --���������û�
    for k,v in pairs(gameeventdata.data) do
      
    	userid = v.userid
    	match_gold = v.wingold
    	
    	--TraceError("��Ϸ�����ɼ�����      �û�id: "..userid.."   ��Ӯ���: "..match_gold.." gamepkg.name = "..gamepkg.name)
     
	    --��ȡuserinfo
		local user_info = usermgr.GetUserById(userid or 0); 
		if (user_info == nil) then return end
	    
		local deskno = user_info.desk
		local deskinfo = desklist[deskno]
		local match_num = act_macth_lib.get_invate_match_count(deskno)		--�����������
		local match_type = 1
 
		--TraceError("��Ϸ�����ɼ�����,match_num:"..match_num.." �û�id��"..userid.." ��Ϸ����"..gamepkg.name)
		--�ж��Ƿ�����ɼ�����  (���� ְҵ�� ר�ҳ�   ���� >= 4) (�齫  ���ж�  4�˶���) (��������  ���ֳ�4�˼�����)
		if(act_macth_lib.can_join_invite_match(user_info,deskinfo,match_num))then
			
			--����
			if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
				if(deskinfo.smallbet == act_macth_lib.room_smallbet1)then		--ҵ�ೡ
					match_type = 1;
				elseif(deskinfo.smallbet == act_macth_lib.room_smallbet2 or deskinfo.smallbet == act_macth_lib.room_smallbet4)then		--ְҵ��
					match_type = 2;
					
					--�ж��û���ְҵ������ר�ҳ�����
					if(user_info.sign_ruslt == "1" or user_info.sign_ruslt == "3")then
						--TraceError("��Ϸ�����ɼ�����  ����  ����ְҵ���ɼ���������      match_type "..match_type.." match_gold "..match_gold.."  �û�id: "..user_info.userId.."   sign: "..user_info.sign_ruslt)
						act_macth_lib.update_invite_db(user_info,match_gold,match_type, 0)
					end
					 
				elseif(deskinfo.smallbet == act_macth_lib.room_smallbet3 or deskinfo.smallbet == act_macth_lib.room_smallbet5)then		--ר�ҳ�
					match_type = 3;
					--�ж��û���ְҵ������ר�ҳ�����
					if(user_info.sign_ruslt == "2" or user_info.sign_ruslt == "3")then
						--TraceError("��Ϸ�����ɼ�����  ����  ����ר�ҳ��ɼ���������      match_type "..match_type.." match_gold "..match_gold.."  �û�id: "..user_info.userId.."   sign: "..user_info.sign_ruslt)
						act_macth_lib.update_invite_db(user_info,match_gold,match_type, 0)
					end 
				end 
			end
			
			 --����
    		if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    		 
    			--�������� ��Ӯ�������
    			if(gamepkg.name == "zysz")then
    				
    				--�ж��û� ���� 
    				if(user_info.qp_sign_ruslt == "2" or user_info.qp_sign_ruslt == "3")then
    					 
						match_type = 3;		--�������� 
	    				--TraceError("��Ϸ�����ɼ�����  ���� ��������  ����ר�ҳ��ɼ���������      match_type "..match_type.." match_gold "..match_gold.."  �û�id: "..user_info.userId.."   sign: "..user_info.sign_ruslt)
						act_macth_lib.update_invite_db(user_info,match_gold,match_type, 0)
					end
					
    				
				else--�齫��ϰ���������� ÿʤ1�ּ�1�֣���������ÿʤ1�ּ�2�֣�8������ͳ�������ÿʤ1�ּ�3�֣����з���ӷ�֮��Ϊ���˱����ܷ֡�
					
					if(match_gold > 0)then		--�齫ֻ��¼Ӯ��
						--�ж��û� ���� 
						if(user_info.qp_sign_ruslt == "1" or user_info.qp_sign_ruslt == "3")then
							match_type = 2;		--�齫 
							--TraceError("��Ϸ�����ɼ�����  ���� �齫  match_type "..match_type.." ת��ǰmatch_gold:"..match_gold.." ʲô����"..tonumber(groupinfo.groupid))
							
							if(tonumber(groupinfo.groupid) ~= act_macth_lib.mj_yk_id)then	--�ο���������ӷ�
								if(tonumber(groupinfo.groupid) == act_macth_lib.mj_xunlian_id or tonumber(groupinfo.groupid) == act_macth_lib.mj_xs_id)then	--��ϰ���������� ÿʤ1�ּ�1��
									match_gold = 1
								elseif(tonumber(groupinfo.groupid) == act_macth_lib.mj_gs_id)then		--��������ÿʤ1�ּ�2��
									match_gold = 2
								elseif(tonumber(groupinfo.groupid) == act_macth_lib.mj_8f_id or tonumber(groupinfo.groupid) == act_macth_lib.mj_super_id)then		--8������ͳ�������ÿʤ1�ּ�3��
									match_gold = 3
								end
						 		
								--TraceError("��Ϸ�����ɼ�����  ���� �齫  match_type "..match_type.." ת����match_gold:"..match_gold)
								--TraceError("��Ϸ�����ɼ�����  ���� ��������  ����ר�ҳ��ɼ���������      match_type "..match_type.." match_gold "..match_gold.."  �û�id: "..user_info.userId.."   sign: "..user_info.sign_ruslt)
								act_macth_lib.update_invite_db(user_info,match_gold,match_type, 0)
							end 
						end
					end 
				end
    		end
		end	 
	end
end

--��Ϸ�����ɼ����� д�ɼ������ݿ�� �����������
function act_macth_lib.update_invite_db(user_info,match_gold,match_type, sign)
	--TraceError("��Ϸ�����ɼ����� д���ݿ�� �����������  sign->"..sign.." match_gold:"..match_gold.."  match_type:"..match_type)
	local nick = string.trans_str(user_info.nick)
	if(sign == 0)then
		local sql = "insert into t_invite_pm(user_id,nick_name,win_gold,play_count,match_type,sys_time) value(%d,'%s',%d,1,%d,now()) on duplicate key update win_gold=win_gold+%d,play_count=play_count+1,sys_time=now();commit;";
		sql = string.format(sql,user_info.userId,nick,match_gold,match_type,match_gold);
		dblib.execute(sql)
		act_macth_lib.update_play_count(user_info,match_type)
	else
		local sql = "insert into t_invite_pm(user_id,nick_name,win_gold,match_type,sys_time,sign) value(%d,'%s',%d,%d,now(),%d) ON DUPLICATE KEY UPDATE sys_time=NOW()";
		sql = string.format(sql,user_info.userId,nick,match_gold,match_type,sign);
		dblib.execute(sql)
		act_macth_lib.update_play_count(user_info,match_type)
	end
	
	if(match_type == 2)then
		user_info.score_2 = user_info.score_2 + match_gold
	end
	
	if(match_type == 3)then
		user_info.score_3 = user_info.score_3 + match_gold
	end
end	


--��Ϸ�����ɼ�����  �����������
act_macth_lib.update_play_count=function(user_info,match_type)
 
	--TraceError("��Ϸ�����ɼ����� ����������� userID->"..user_info.userId.."match_type->"..match_type.." ��Ϸ����"..gamepkg.name)
 
 	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		if(match_type == 1)then
		
			if(user_info.yy_play_count == nil)then
				user_info.yy_play_count = 1
				return
			end
			
			user_info.yy_play_count = user_info.yy_play_count + 1 or 1
			
		elseif(match_type == 2)then
		
			if(user_info.zy_play_count == nil)then
				user_info.zy_play_count = 1
				--TraceError("��Ϸ�����ɼ����� �����������-> ���� user_info.zy_play_count->"..user_info.zy_play_count.." ��Ϸ����"..gamepkg.name)
				return
			end
			
			user_info.zy_play_count = user_info.zy_play_count + 1 or 1
			--TraceError("��Ϸ�����ɼ�����  �����������-> ����  user_info.zy_play_count->"..user_info.zy_play_count.." ��Ϸ����"..gamepkg.name)
			
		elseif(match_type == 3)then
			if(user_info.zj_play_count == nil)then
				user_info.zj_play_count = 1
				--TraceError("��Ϸ�����ɼ�����  �����������-> ���� user_info.zj_play_count->"..user_info.zj_play_count.." ��Ϸ����"..gamepkg.name)
				return
			end
			user_info.zj_play_count = user_info.zj_play_count+1 or 1
			--TraceError("��Ϸ�����ɼ����� �����������-> ���� user_info.zj_play_count->"..user_info.zj_play_count.." ��Ϸ����"..gamepkg.name)
		end
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	
    	if(user_info.qp_play_count == nil)then
			user_info.qp_play_count = 1
			--TraceError("��Ϸ�����ɼ����� �����������-> ����  user_info.qp_play_count->"..user_info.qp_play_count.." ��Ϸ����"..gamepkg.name)
			return
		end
		
		user_info.qp_play_count = user_info.qp_play_count + 1 or 1
		--TraceError("��Ϸ�����ɼ����� ����������� -> ����  user_info.qp_play_count->"..user_info.qp_play_count.." ��Ϸ����"..gamepkg.name)
    end
end

 
--��ʱˢ���¼�
act_macth_lib.ontimecheck = function()
  	--10����Ҫˢһ�� 
  	if(act_macth_lib.check_datetime() == 0)then	--�жϻʱ�����
  		--TraceError("��ʱˢ���¼�   �ʱ�����")
  		return
  	end
  	
	if(act_macth_lib.refresh_invate_time == -1 or os.time() > act_macth_lib.refresh_invate_time + 60*1)then
		--TraceError("��ʱˢ���¼�  10����Ҫˢһ�� ");
    	act_macth_lib.refresh_invate_time = os.time();
    	act_macth_lib.init_invite_ph();
    end
  
    --20:00,20:20,20:40,21:00,21:20,21:40,22:00 ����ȫ��7�ι㲥
    
    local tableTime = os.date("*t",os.time());
    local nowYear = tonumber(tableTime.year);
    local nowMonth = tonumber(tableTime.month);
    local nowDay = tonumber(tableTime.day);
    
    local nowHour = tonumber(tableTime.hour);
    local nowMin = tonumber(tableTime.min);
    local nowSec = tonumber(tableTime.sec);
    
    local tmp_time="'"..nowYear.."-"..nowMonth.."-"..nowDay.." "..nowHour..":"..nowMin..":00"
    if ((nowHour == 20 and nowMin == 0)
    	or (nowHour == 20 and nowMin == 20)
    	or (nowHour == 20 and nowMin == 40)
    	or (nowHour == 21 and nowMin == 0)
    	or (nowHour == 21 and nowMin == 20)
    	or (nowHour == 21 and nowMin == 40)
    	or (nowHour == 22 and nowMin == 0)) then
		 
		if(act_macth_lib.last_msg_time < timelib.db_to_lua_time(tmp_time))then
			--����
			if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		    	broadcast_by_msgtype("match_msg_noti2",0)
		    	act_macth_lib.last_msg_time = os.time();
		    end
		    
		    --����
    		if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    			local msg = "�������ѻ��ȿ������Ͽ����Ӯȡ�ر�ͼ�ڱ���" 
		    	BroadcastMsg(_U(msg),0)
		    	act_macth_lib.last_msg_time = os.time();
    		end
		end
	end 
	
	  --��ʱ����ǰ3��������Ϣ
	if ((nowHour == 23 and nowMin == 05)
		or (nowHour == 23 and nowMin == 10)
		or (nowHour == 23 and nowMin == 15)
		or (nowHour == 23 and nowMin == 20))then
		
		--���ͷ�����Ϣ
		act_macth_lib.send_fajiang_msg()
	end
end

--��ʼ�����а�
function act_macth_lib.init_invite_ph()
	--TraceError("-->>>>��ʼ�����а�")
	
	--��ʼ������
	local init_match_ph = function(ph_list,match_type)
		local sql = "select user_id,nick_name,win_gold,match_king_count,play_count,sign from t_invite_pm where match_type=%d and play_count>=1 order by win_gold desc LIMIT 20"
		sql = string.format(sql,match_type) 
		dblib.execute(sql,function(dt)	
				if(dt ~= nil and  #dt > 0)then
					for i = 1,#dt do
						local bufftable ={
						  	    mingci = i, 
			                    user_id = dt[i].user_id,
			                    nick_name = dt[i].nick_name,
			                    win_gold = dt[i].win_gold,
			                    match_king_count = dt[i].match_king_count,
			                    play_count = dt[i].play_count,
			                    sign = dt[i].sign,
		                }
		                
						table.insert(ph_list,bufftable)
					end
				end
	    end)
    end
    
    --����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
	    act_macth_lib.invite_ph_list_zj = {}; --ר�ҳ�����
		act_macth_lib.invite_ph_list_yy = {};	--ҵ�ೡ����
		act_macth_lib.invite_ph_list_zy = {};	--ְҵ������
		
		
	    --��ʼ��ҵ�ೡ����
	    init_match_ph(act_macth_lib.invite_ph_list_yy,1)
	    --��ʼ��ְҵ������
	    init_match_ph(act_macth_lib.invite_ph_list_zy,2)
	    --��ʼ��ר�ҳ�����
	    init_match_ph(act_macth_lib.invite_ph_list_zj,3)
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	act_macth_lib.invite_qp_mj_ph_list = {}; --�齫����
		act_macth_lib.invite_qp_zysz_ph_list = {};	--������������
 
		--��ʼ���齫����
	    init_match_ph(act_macth_lib.invite_qp_mj_ph_list,2)
	    --��ʼ��������������
	    init_match_ph(act_macth_lib.invite_qp_zysz_ph_list,3)
    end
	
end

--���󾺼��������а�
function act_macth_lib.on_recv_invite_ph_list(buf)
	
	local user_info = userlist[getuserid(buf)]; 
	local mc = -1; --���ڼ����Լ�������
	local win_gold = 0; --���ڼ����Լ��ĳɼ�
	local match_king_count = 0; --���ڼ����Լ������ߴ���
	local play_count = 0; --���ڼ����Լ�����Ĵ���
	
	local invite_paimin_list = {};
	local send_len = 20;--Ĭ�Ϸ�20����Ϣ
	if(user_info == nil)then return end
	--TraceError("���󾺼��������а�  �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
	
	--��ѯ�Լ������Σ����û�����ξͷ���-1
	--�������Σ��ɼ�����Ϊ���ߵĴ�������Ĵ���
	local my_mc=-1;
	local my_win_gold=0;
	local my_king_count=0;
	local my_play_count=0;
	
	local get_my_pm = function(ph_list,user_info)
		local mc = -1
		if (ph_list == nil) then return -1,0,0,0 end
		
		for i = 1,#ph_list do
			if(ph_list[i].user_id == user_info.userId)then
				return i,ph_list[i].win_gold,ph_list[i].match_king_count,ph_list[i].play_count
			end
		end

		return -1,0,0,0;--û���ҵ���Ӧ��ҵļ�¼����Ϊ��û�гɼ�
	end
	
	--�õ��Լ����˶�����
	local get_my_real_play_count=function(user_info,match_type)
		
		 --����
		if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
			if(match_type==3)then
				return user_info.zj_play_count or 0
			end
			
			if(match_type==2)then
				return user_info.zy_play_count or 0
			end
	
			if(match_type==1)then
				return user_info.yy_play_count or 0						
			end
		end	
		
		--����
    	if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	 
    		return user_info.qp_play_count or 0		
    	end
    
	end
	
	--����   1��ҵ�ೡ��2��ְҵ����3��ר�ҳ�
	--����  1���齫 ��2����������
	local query_match_type = buf:readByte(); 
	--TraceError("���󾺼��������а�  �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name.." �������ͣ�"..query_match_type)
	
	local my_real_play_count = get_my_real_play_count(user_info,query_match_type) or 0
	 
	
	
	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		--���ݺ�����      �жϱ���    0��δ����    1��ְҵ��      2��ר�ҳ�       3��ְҵ����ר�ҳ�
		local baoming_sign = user_info.sign_ruslt or "0"	--���Ϳͻ��ˣ�ֻ��0��δ������1���ѱ���
		--TraceError("baoming_sign : "..baoming_sign)
		--��ȡ���а�
		if(query_match_type == 1)then		--1��ҵ�ೡ
			invite_paimin_list = act_macth_lib.invite_ph_list_yy
		elseif(	query_match_type == 2) then		--2��ְҵ��
			invite_paimin_list = act_macth_lib.invite_ph_list_zy
		elseif(	query_match_type == 3) then		--3��ר�ҳ�
			invite_paimin_list = act_macth_lib.invite_ph_list_zj
		end
		
		--����Լ�����
		my_mc,my_win_gold,my_king_count,my_play_count = get_my_pm(invite_paimin_list,user_info)	
		if(query_match_type == 2)then
			my_win_gold = user_info.score_2
		elseif(query_match_type == 3)then
			my_win_gold = user_info.score_3
		end 
		
		--��baoming_signת��  0��δ������1���ѱ���
		if(query_match_type == 2)then		--ְҵ��
			
			if(baoming_sign == "0")then			--��û����
				baoming_sign = "0"
			elseif(baoming_sign=="1")then		--ֻ��ְҵ��
			
				baoming_sign = "1"
			elseif(baoming_sign=="2")then		--û��ְҵ��
			
				baoming_sign = "0"
			elseif(baoming_sign=="3")then		--ְҵ��ר�ҳ�����
				
				baoming_sign = "1"
			end
		
		elseif(	query_match_type==3) then 		--ר�ҳ�
			if(baoming_sign == "0")then 		--��û����
				baoming_sign = "0"
			elseif(baoming_sign == "1")then 	--û��ר�ҳ�
				baoming_sign = "0"
			elseif(baoming_sign == "2")then 	--ֻ��ר�ҳ�
				baoming_sign = "1"
			elseif(baoming_sign == "3")then 	--ְҵ��ר�ҳ�����
				baoming_sign = "1"
			end
			
		end
		
		local map_values = user_info.propslist[9] or 0
		
		--�������а� 
		act_macth_lib.send_pm_list(user_info, baoming_sign, my_win_gold, my_mc, my_king_count, my_real_play_count, send_len, invite_paimin_list, map_values)
		
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	--���ݺ�����      �жϱ���    0��δ����    1��ְҵ��      2��ר�ҳ�       3��ְҵ����ר�ҳ�
    	local baoming_sign = user_info.qp_sign_ruslt or "0"	--���Ϳͻ��ˣ�ֻ��0��δ������1���ѱ���
    	
    	--��ȡ���а�
    	if(query_match_type == 2)then		--�齫
			invite_paimin_list = act_macth_lib.invite_qp_mj_ph_list
		elseif(	query_match_type == 3) then		--��������
			invite_paimin_list = act_macth_lib.invite_qp_zysz_ph_list 
		end
		
		--����Լ�����
		my_mc,my_win_gold,my_king_count,my_play_count = get_my_pm(invite_paimin_list,user_info)	
		if(query_match_type == 2)then
			my_win_gold = user_info.score_2
		elseif(query_match_type == 3)then
			my_win_gold = user_info.score_3
		end 
		
		--��baoming_signת��  0��δ������1���ѱ���
		if(query_match_type == 2)then		--�齫��
			
			if(baoming_sign == "0")then		--��û����
				baoming_sign = "0"
			elseif(baoming_sign=="1")then		--ֻ���齫��
			
				baoming_sign = "1"
			elseif(baoming_sign=="2")then		--û���齫
			
				baoming_sign = "0"
			elseif(baoming_sign=="3")then		--�齫���������Ŷ�����
				
				baoming_sign = "1"
			end
		
		elseif(query_match_type == 3) then 		--�������ų�
			if(baoming_sign == "0")then 		--��û����
				baoming_sign = "0"
			elseif(baoming_sign == "1")then 	--û����������
				baoming_sign = "0"
			elseif(baoming_sign == "2")then 	--ֻ����������
				baoming_sign = "1"
			elseif(baoming_sign == "3")then 	--�齫���������Ŷ�����
				baoming_sign = "1"
			end
			
		end
		
		local map_values = user_info.bag_items[8005] or 0
		
		--�������а�
		act_macth_lib.send_pm_list(user_info, baoming_sign, my_win_gold, my_mc, my_king_count, my_real_play_count, send_len, invite_paimin_list, map_values)
		
    end 
	 
end

--�������а�
function act_macth_lib.send_pm_list(user_info, baoming_sign, my_win_gold, my_mc, my_king_count, my_real_play_count, send_len, invite_paimin_list, map_values)
	--TraceError("�������а�")
	
	netlib.send(function(buf)
		buf:writeString("INVITEPHLIST")
		
		if(baoming_sign == "1")then
			buf:writeByte(1)	--�Ƿ��ѱ�����0��δ������1���ѱ���
		else
			buf:writeByte(0)	--�Ƿ��ѱ�����0��δ������1���ѱ���
	
		end
		
	    --�Ƿ���ʾ�콱��ť
	    buf:writeByte(0) --Ŀǰû���콱���ܣ����õ����Ĵ����ˡ��Ժ����ټ���
	    buf:writeInt(my_win_gold or 0)
	    buf:writeInt(my_mc or 0)
	    buf:writeInt(my_king_count or 0)
	
	    buf:writeInt(60- my_real_play_count)--��60�ֻ�����پ�
	    buf:writeString(tostring(my_real_play_count))--��Ҫ������ô�Ż�����ľ��� e.g. 10|20|32
	    buf:writeInt(map_values or 0)	--�����ڱ�ͼ����
		if send_len > #invite_paimin_list then send_len = #invite_paimin_list end --��෢20����Ϣ
		----TraceError("send_len:"..send_len)
		
		 buf:writeInt(send_len)
			--�ٷ������˵�
	        for i = 1,send_len do
		        buf:writeInt(invite_paimin_list[i].mingci)	--����
		        buf:writeInt(invite_paimin_list[i].user_id) --���ID
		        buf:writeString(invite_paimin_list[i].nick_name) --�ǳ�
		        buf:writeInt(invite_paimin_list[i].win_gold) --��ҳɼ�
		  
	        end
	    end,user_info.ip,user_info.port)  
end

--[[
--��д���������콱������°汾�в���ʹ���ˣ��ȱ�������ֹ�Ժ�Ҫ��ʵ�ｱ
function act_macth_lib.on_recv_invite_dj(buf)
	----TraceError("--��д���������콱������°汾�в���ʹ���ˣ��ȱ�������ֹ�Ժ�Ҫ��ʵ�ｱ")
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	local real_name=buf:readString();
	local tel=buf:readString();
	local yy_num=buf:readInt();
	local address=buf:readString();
	local sql="update t_invite_pm set real_name='%s',tel='%s',yy_num=%d,address='%s' where user_id=%d;commit;"
	sql=string.format(sql,real_name,tel,yy_num,address,user_info.userId)
	
	dblib.execute(sql)
	netlib.send(function(buf)
		    buf:writeString("INVITEDJ")
		    buf:writeByte(1)		    
	        end,user_info.ip,user_info.port)   
end
]]


--���ɱ���ID������¼��α�����������ÿ��������ͬһʱ�̣�ֻ����һ������������ֱ�������Ӻ�+ʱ�����Ψһ��
function act_macth_lib.init_invate_match(deskno)
	----TraceError("--���ɱ���ID������¼��α�����������ÿ��������ͬһʱ�̣�ֻ����һ������������ֱ�������Ӻ�+ʱ�����Ψһ��")
	local deskinfo = desklist[deskno];
	if deskinfo==nil then return -1 end;
	if(deskinfo ~= nil and deskinfo.smallbet ~= act_macth_lib.room_smallbet1 and deskinfo.smallbet ~= act_macth_lib.room_smallbet2 and deskinfo.smallbet ~= act_macth_lib.room_smallbet3 and deskinfo.smallbet ~= act_macth_lib.room_smallbet4 and deskinfo.smallbet ~= act_macth_lib.room_smallbet5)then
		return -1
	end
	local playinglist=deskmgr.getplayers(deskno)
	
	deskinfo.invate_match_id = deskno..os.time();
	deskinfo.invate_match_count=#playinglist;
	
	local flag=0;--0��Ч��1��Ч
	local match_time_status = act_macth_lib.check_datetime();
	if(match_time_status ==2)then
	----TraceError("--���ɱ���ID������¼��α�����������ÿ��������ͬһʱ�̣�ֻ����һ������������ֱ�������Ӻ�+ʱ�����Ψһ��")
		if(deskinfo.invate_match_count~=nil and deskinfo.invate_match_count>2)then
			flag=1;
		end
		for _, player in pairs(playinglist) do
		local user_info = player.userinfo
			if(#playinglist>1)then
			
				--���߿ͻ�����γɼ�����Ч������Ч��
				netlib.send(function(buf)
				    buf:writeString("INVITEREC")
				    buf:writeByte(flag)		    
			        end,user_info.ip,user_info.port)   
			end
		end
	end
	
	return deskinfo.invate_match_id;
end


--[[
--�õ���������ID
function act_macth_lib.get_invate_match_id(deskno)
	----TraceError("--�õ���������ID")
	local deskinfo = desklist[deskno];
	if deskinfo==nil then return -1 end;
	return deskinfo.invate_match_id or -1;
end
]]

--����������ݣ����ݺ�����   ���ã�
function act_macth_lib.get_invate_match_count(deskno)
	
	local deskinfo = desklist[deskno];
	if deskinfo==nil then return -1 end;
	
	local player_valuet = 0
	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		player_valuet = deskinfo.invate_match_count or 0;
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	player_valuet = deskinfo.playercount or 0;
    end
	
	return player_valuet
end

--��������ֺͽ�����������루���ݺ�����  ���ã�
function act_macth_lib.on_recv_refresh_timeinfo(buf)
	--�������������û���ã�����ֱ�ӷ��� 
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	local match_time_status = act_macth_lib.check_datetime();--��Ч��1 ��Ч��0
	--��Ч���������ʱ��1�����뿪��ʱ��0
	--��Ч���������ʱ��0�����뿪��ʱ��1
	local flag1=0;
	local flag2=0;
	if(match_time_status == 0 or match_time_status == 1 or match_time_status == 3)then
		flag1=0
		flag2=1
	else 
		flag1=1
		flag2=0
	end
	--TraceError("��������ֺͽ������������   flag1:"..flag1.."  flag2:"..flag2)
	netlib.send(function(buf)
	    buf:writeString("INVITEBTN")
	    buf:writeInt(flag1)  --�����������ʱ��		
	    buf:writeInt(flag2)  --�����������ʱ��
	    buf:writeInt(-1)  --�������˶�����		    
	end,user_info.ip,user_info.port)   
end

--�ͻ���֪ͨ�Ѿ�����콱��ť�ˣ����ݺ�����  ���ã�
function act_macth_lib.on_recv_already_know_reward(buf)
	--TraceError("--�ͻ���֪ͨ�Ѿ�����콱��ť��  match_type��"..match_type.." ��Ϸ����"..gamepkg.name)
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	local match_type = buf:readByte()
	local sql = "update t_invite_pm set get_reward_time=now() where user_id=%d and match_type=%d;commit;"
	sql = string.format(sql,user_info.userId,match_type);
	dblib.execute(sql)
end

--�û���¼���¼������ݺ�����  ���ã�
act_macth_lib.on_after_user_login = function(e)
	 
	--��Ϸ������֤
	--����	--���� 
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("�û���¼���¼�     gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("�û���¼���¼�->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end
	 
    local userinfo = e.data.userinfo
	
	if(userinfo == nil)then 
		--TraceError("����  �û���¼���¼������û���½���ʼ������,if(user_info == nil)then")
	 	return
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--������ʼ������
		if(userinfo.bag_items == nil)then 
			bag.get_all_item_info(userinfo,function() end ,nil)
		end
	end
 
	--���ʱ����Ч��
	local match_time_status = act_macth_lib.check_datetime();--��Ч��1 ��Ч��0
	if(match_time_status == 1 or match_time_status == 3)then 
		--TraceError("-- �û���¼���¼�    match_time_status->"..match_time_status.."  ����") 
		act_macth_lib.invite_match_fajiang(userinfo)
	elseif(match_time_status == 0)then
		--TraceError("-- �û���¼���¼�     match_time_status->"..match_time_status.."  ʱ����Ч")
		return
	end
	 
	--��ʼ���������ɼ�
	if(userinfo.score_2 == nil)then
		userinfo.score_2 = 0
	end
	if(userinfo.score_3 == nil)then
		userinfo.score_3 = 0
	end
	
	act_macth_lib.invite_update_user_play_count(userinfo)
	
end

--�û���¼���ʼ������
function act_macth_lib.invite_update_user_play_count(user_info)

		--���ݱ�����־
		if(user_info.sign_ruslt == nil)then
			user_info.sign_ruslt = "0"
		end
		
		--���Ʊ�����־
		if(user_info.qp_sign_ruslt == nil)then
			user_info.qp_sign_ruslt = "0"
		end
 
		local sql = "SELECT play_count,match_type,win_gold FROM t_invite_pm where user_id=%d order by match_type"
		sql = string.format(sql,user_info.userId)
		dblib.execute(sql,function(dt)
			if(dt ~= nil and #dt > 0)then			
				for i=1,#dt do
 
 					--����
					if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
						if(dt[i].match_type == 1)then
							user_info.yy_play_count=dt[i].play_count or 0
		
						elseif(dt[i].match_type == 2)then
							user_info.zy_play_count=dt[i].play_count or 0
							user_info.score_2 = dt[i].win_gold or 0
				
						elseif(dt[i].match_type == 3)then
							user_info.zj_play_count=dt[i].play_count or 0
							user_info.score_3 = dt[i].win_gold or 0
						end
					end
					
					--����
    				if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    					
    					if(dt[i].match_type == 1)then
							user_info.qp_play_count = dt[i].play_count or 0
		
						elseif(dt[i].match_type == 2)then
							user_info.qp_play_count = dt[i].play_count or 0
							user_info.score_2 = dt[i].win_gold or 0
							
						elseif(dt[i].match_type == 3)then
							user_info.qp_play_count = dt[i].play_count or 0
							user_info.score_3 = dt[i].win_gold or 0
						end
						
						--�ж��Ƿ��в���
						if(user_info.bag_items == nil)then
							----TraceError("����Ϊ��")
							bag.get_all_item_info(user_info,function() end ,nil)
						end			
    				end
				
				end
			end
		end)
		 
		--sql="SELECT SUM(sign) AS sign FROM t_invite_pm where user_id=%d AND DATE(baoming_time) = DATE(NOW()) and hour(baoming_time)<23 "
		--sql="SELECT SUM(sign) AS sign FROM t_invite_pm WHERE user_id=%d AND !(DATE(baoming_time) != DATE(NOW()) OR  ((HOUR(NOW())<23 AND baoming_time='1900-01-01 00:00:00') OR ( HOUR(NOW())>=23 AND HOUR(baoming_time)<23)));"
		--���ӵ�SQL,��1���жϵ����ڱ��������2���жϵ���23��00������23��00���������3���ж�31����1�������4���ж��ޱ��������
		sql = "SELECT SUM(sign) AS sign FROM t_invite_pm WHERE user_id=%d AND (!(DATE(baoming_time) != DATE(NOW()) OR  ((HOUR(NOW())<23 AND baoming_time='1900-01-01 00:00:00') OR ( HOUR(NOW())>=23 AND HOUR(baoming_time)<23))) OR (DATE(baoming_time)=DATE_SUB(DATE(NOW()), INTERVAL 1 DAY) AND HOUR(baoming_time)>=23))"
		
		sql = string.format(sql,user_info.userId) 
		dblib.execute(sql,function(dt)
			if(dt~=nil and #dt>0)then	
				
				--����
				if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
					user_info.sign_ruslt = dt[1].sign or "0"  --ȡ��ֵ��0��δ���� 1��ְҵ��  2��ר�ҳ�  3��ְҵ����ר�ҳ�
					 
					if(user_info.sign_ruslt == "" )then
						user_info.sign_ruslt = "0"
					end
				end
				
				--����
    			if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    				user_info.qp_sign_ruslt = dt[1].sign or "0"  --ȡ��ֵ��0��δ���� 1��ְҵ��  2��ר�ҳ�  3��ְҵ����ר�ҳ�
					 
					if(user_info.qp_sign_ruslt == "" )then
						user_info.qp_sign_ruslt = "0"
					end
    			end
			end
		end)
end

--����ڼ��������ݺ�����  ���ã�
function act_macth_lib.consider_screen()
	 
	local t1 = act_macth_lib.start_day
	local now_time = os.date("%Y%m%d", os.time())
	
	local day1 = {}
	day1.year,day1.month,day1.day = string.match(t1,"(%d%d%d%d)(%d%d)(%d%d)")
	
	local day2 = {}
	day2.year,day2.month,day2.day = string.match(now_time,"(%d%d%d%d)(%d%d)(%d%d)")
	
	local numDay1 = os.time(day1)
	
	local numDay2 = os.time(day2)
	 
	local total_day = (numDay2 - numDay1)/(3600*24) + 1
	
	return total_day
end

--����ҷ���
--����������ٴ�һ�̾ͷ��������ص�½ʱ�ŷ���
function act_macth_lib.invite_match_fajiang(user_info)
	--TraceError("����ҷ������û�id��"..user_info.userId)
 
	local mc = -1;
 
	local screen_n = act_macth_lib.consider_screen()	--����ڼ���
	
	local send_result = function(user_info,mc,match_type)
		--TraceError("����ҷ��� ���ͽ�� ����:"..mc.."  �û�userid:"..user_info.userId.."  ����match_type"..match_type.." ��Ϸ����"..gamepkg.name)
		netlib.send(function(buf)
		    buf:writeString("INVITEGIF")
		    buf:writeInt(mc)  --����	
		    buf:writeByte(match_type)
		    buf:writeInt(screen_n)  --�ڼ���	    
		end,user_info.ip,user_info.port)  
	end
	
	--���巢��
	local jutifajiang = function(i,user_info,reward,match_type)
		 
		--����
		if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
			--������ �Ӳر�ͼ
			--tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.wabao_map_id, reward, user_info)
			
			--��¼������־
			local sql = "INSERT INTO log_treasurebox_prize(user_id, game_name, sys_time, box_id, prize_id)VALUES(%d, '%s', now(), %d, %d);commit;"
			sql = string.format(sql,user_info.userId,gamepkg.name,match_type,reward);
			dblib.execute(sql)  
			
			--ϵͳ���ھ��㲥��Ϣ    ���ö�ʱ����    ���ﴦ��
		end
		
		--����
    	if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    		--������ �Ӳر�ͼ 
			local add_items_result = act_wabao_lib.chaxun_add_items(user_info, 8005, reward, 1)
			 
			--��¼������־
			local sql = "INSERT INTO log_treasurebox_prize(user_id, game_name, sys_time, box_id, prize_id)VALUES(%d, '%s', now(), %d, %d);commit;"
			sql = string.format(sql,user_info.userId,gamepkg.name,match_type,reward);
			dblib.execute(sql) 
			
			--ϵͳ���ھ��㲥��Ϣ    ���ö�ʱ����    ���ﴦ��  
    	end 
	end
 
 
 	
	--����
	local fajiang = function(user_info,match_type,reward1,reward2,reward3,reward4,reward5,reward6)
	 	--TraceError("����ҷ������û�id��"..user_info.userId.."  match_type:"..match_type.." ��Ϸ����"..gamepkg.name)
		local sql = "select user_id,get_reward_time from t_invite_pm where match_type=%d and play_count>=1  order by win_gold desc limit 20";
		sql = string.format(sql,match_type)
		 
		dblib.execute(sql,function(dt)	
				if(dt ~= nil and  #dt > 0)then
					--local fajiang_flag=0;
					local len = 20
					if(#dt < 20)then
						len = #dt
					end
					
					for i = 1,len do
						local get_reward_time = 0;
						if(dt[i].get_reward_time ~= nil)then
							get_reward_time = timelib.db_to_lua_time(dt[i].get_reward_time) or 0
						end
					  	if(dt[i].user_id == user_info.userId and get_reward_time < timelib.db_to_lua_time('2010-11-11'))then
	     			  			if(i == 1)then
					  				jutifajiang(i,user_info,reward1,match_type)
					  			elseif(i == 2)then
					  				jutifajiang(i,user_info,reward2,match_type)
					  				 
					  			elseif(i == 3)then
					  				jutifajiang(i,user_info,reward3,match_type)
					  				 
					  			elseif(i == 4 or i == 5)then
					  				jutifajiang(i,user_info,reward4,match_type)
					  				 
					  			elseif(i >= 6 and i <= 10)then
					  				jutifajiang(i,user_info,reward5,match_type)
					  			
					  			elseif(i >= 11 and i <= 20)then
					  				jutifajiang(i,user_info,reward6,match_type)
					  				 
					  			end
					  			
					  			--��2��21��û��ʹ�������������֪ͨ��Ϣ
					      		--send_result(user_info,i,match_type)
					    end
					end
					
					--�����콱��Ϣ,����������εģ��͸��������콱ʱ�䣬�����û���εģ���ֱ����0
					sql = "update t_invite_pm set get_reward_time=now() where user_id=%d and match_type=%d;commit;";
					sql = string.format(sql,user_info.userId,match_type)
					dblib.execute(sql)
				end
		end)  
	end
 
 	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		--[[
		ר�ҳ�����һ��200�ţ��ڶ���100�ţ�������50�ţ�4-5��20�ţ�6-10��10�ţ�11-20��5��
 		 ְҵ������һ��100�ţ��ڶ���50�ţ�������20�ţ�4-5��10�ţ�6-10��5�ţ�11-20��2��
]]
		
		--��ҵ�ೡ�Ľ� 
		--fajiang(userinfo,1,10000,2000,1000,500,500);
		
		--��ְҵ���Ľ�
		fajiang(user_info,2,100,50,20,10,5,2);
		
		--��ר�ҳ��Ľ�
		fajiang(user_info,3,200,100,50,20,10,5);
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    --[[
      	�������ţ���һ��200�ţ��ڶ���100�ţ�������50�ţ�4-5��20�ţ�6-10��10�ţ�11-20��5��
  		�齫����һ��100�ţ��ڶ���50�ţ�������20�ţ�4-5��10�ţ�6-10��5�ţ�11-20��2��
    ]]
    	--TraceError("����ҷ���������    ����ǰ     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
    	--���齫�Ľ� 
    	if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == "mj")then
			fajiang(user_info,2,100,50,20,10,5,2);
		end
	 
		--���������ŵĽ�
		if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == "zysz")then
			fajiang(user_info,3,200,100,50,20,10,5);
		end 
    end 
end

--����ʱ��״̬�����ݺ�����   ���ã�
function act_macth_lib.on_recv_activity_stat(buf)

	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	
	--0�����Ч������ʾ���UI��2�����Ч�������׶�
	local check_stat = act_macth_lib.check_datetime()
	
	local endtime = timelib.db_to_lua_time(act_macth_lib.endtime);
	local ranktime =  timelib.db_to_lua_time(act_macth_lib.rank_endtime);
	local sys_time = os.time();
	if(sys_time > endtime) then
		check_stat = 5 --��������������а�ͼ�걣��1�����ʧ��
	end
	
	if(sys_time > ranktime) then
		check_stat = 0 --���������
	end
	
	--Ϊ�˼�����ǰ�Ĵ���
	if(check_stat==3)then
		check_stat=1
	end
	
	--TraceError("--����ʱ��״̬-->>"..check_stat)
	
	netlib.send(function(buf)
		    buf:writeString("INVITEPHDATE")
		    buf:writeByte(check_stat)		    
	        end,user_info.ip,user_info.port)   
end

--����������
function act_macth_lib.on_recv_sign(buf)
	
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	
	--TraceError("--����������  �û�id��"..user_info.userId)
	
	--����  ������һ������ 2��ְҵ����3��ר�ҳ�
	--����  ������һ������ 1���齫��2��	��������
	local sign = buf:readByte()
	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end
	
	if(vip_level<3)then
		netlib.send(function(buf)
		    buf:writeString("INVITESIGNUP")
		    buf:writeByte(5)		    
	    end,user_info.ip,user_info.port)
	    return 
	end
	
	--1�������ɹ���2������ʧ�ܣ������ʸ�֤��3������ڣ�4�������쳣���
	local sign_ruslt = 0
	local check_time=act_macth_lib.check_datetime()
	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		--��ѯ��Ʊ����
		local shiptickets_count = user_info.propslist[7]
	    
		if(sign == 2)then	--2��ְҵ��
			if(check_time == 0 or check_time==1 )then	--�жϻ��Ч��
				sign_ruslt = 3
				--TraceError(" ���������� ְҵ��  �ʱ��ʧЧ  3  �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			elseif(shiptickets_count < 2)then	--�жϱ����ʸ�
				sign_ruslt = 2
		 		--TraceError("����������   ְҵ��   ��Ʊ����     2   �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			else--�����ɹ�����۳��ʸ�֤����
				sign_ruslt = 1
				act_macth_lib.sign_succes(user_info, 2, sign)
			end
			
		elseif(sign == 3)then	--3��ר�ҳ�
			if(check_time == 0 or check_time==1)then	--�жϻ��Ч��
				sign_ruslt = 3
				--TraceError("����������   ר�ҳ� �ʱ��ʧЧ    3  �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			elseif(shiptickets_count < 10)then	--�жϱ����ʸ�
				sign_ruslt = 2
				--TraceError("����������    ר�ҳ�    ��Ʊ����    2  �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			else--�����ɹ�����۳��ʸ�֤����
				sign_ruslt = 1
				act_macth_lib.sign_succes(user_info, 10, sign)
			end
			
		else
			--TraceError("����������       ��������, �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			return;
		end
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	--��ѯ��Ʊ����
		local shiptickets_count = user_info.bag_items[act_macth_lib.qp_mp_id] or 0;
	    
		if(sign == 2)then	--2���齫
			if(act_macth_lib.check_datetime() == 0)then	--�жϻ��Ч��
				sign_ruslt = 3
				--TraceError(" ���������� �齫  �ʱ��ʧЧ  3  �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			elseif(shiptickets_count < 2)then	--�жϱ����ʸ�
				sign_ruslt = 2
		 		--TraceError("����������  �齫   ��Ʊ����     2   �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			else--�����ɹ�����۳��ʸ�֤����
				sign_ruslt = 1
				act_macth_lib.sign_succes(user_info, 2, sign)
			end
			
		elseif(sign == 3)then	--3����������
			if(act_macth_lib.check_datetime() == 0)then	--�жϻ��Ч��
				sign_ruslt = 3
				--TraceError("����������   �������� �ʱ��ʧЧ      �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			elseif(shiptickets_count < 10)then	--�жϱ����ʸ�
				sign_ruslt = 2
				--TraceError("����������    ��������    ��Ʊ����      �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			else--�����ɹ�����۳��ʸ�֤����
				sign_ruslt = 1
				act_macth_lib.sign_succes(user_info, 10, sign)
			end
			
		else
			--TraceError("����������       ��������, �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			return;
		end
    end
		 
	netlib.send(function(buf)
		    buf:writeString("INVITESIGNUP")
		    buf:writeByte(sign_ruslt)		    
	        end,user_info.ip,user_info.port) 
end

--�����ɹ�
function  act_macth_lib.sign_succes(user_info, k_count, match_type)
	--TraceError("�����ɹ�->>match_type:"..match_type.."k_count:"..k_count.." ��Ϸ����"..gamepkg.name)
	--user_info.sign_ruslt��¼    0��δ����        1��ְҵ��        2��ר�ҳ�          3��ְҵ����ר�ҳ�
	
	local xie_sign = 0
	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		if(match_type == 2)then
			if(user_info.sign_ruslt == "0")then
				user_info.sign_ruslt = "1"
				xie_sign = 1
			elseif(user_info.sign_ruslt == "2")then
				user_info.sign_ruslt = "3"
	 			xie_sign = 1
			end
		elseif(match_type == 3)then
			----TraceError("�����ɹ�user_info.sign_ruslt->>"..user_info.sign_ruslt)
			if(user_info.sign_ruslt == "0")then
				user_info.sign_ruslt = "2"
				xie_sign = 2
			elseif(user_info.sign_ruslt == "1")then
				user_info.sign_ruslt = "3"
	 			xie_sign = 2
			end
		end
		
		user_info.propslist[7] = user_info.propslist[7] - k_count
		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.NewYearTickets_ID, -k_count, user_info)
		--TraceError("--�����ɹ�����۳���Ʊ������"..k_count.." ��Ϸ����"..gamepkg.name)
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	if(match_type == 2)then
			if(user_info.qp_sign_ruslt == "0")then
				user_info.qp_sign_ruslt = "1"
				xie_sign = 1
			elseif(user_info.qp_sign_ruslt == "2")then
				user_info.qp_sign_ruslt = "3"
	 			xie_sign = 1
			end
		elseif(match_type == 3)then
			----TraceError("�����ɹ�user_info.sign_ruslt->>"..user_info.sign_ruslt)
			if(user_info.qp_sign_ruslt == "0")then
				user_info.qp_sign_ruslt = "2"
				xie_sign = 2
			elseif(user_info.qp_sign_ruslt == "1")then
				user_info.qp_sign_ruslt = "3"
	 			xie_sign = 2
			end
		end
		
		--�ӱ���
		local add_items_result = act_macth_lib.chaxun_add_items(user_info, act_macth_lib.qp_mp_id, -k_count, 1)
		 
		--TraceError("--�����ɹ�����۳���Ʊ������"..k_count.." ��Ϸ����"..gamepkg.name)
    end
	 
	--����д���ݿ�
	act_macth_lib.inster_invite_db(user_info,0,match_type,xie_sign)
	
	--д��־	
	local sql = "INSERT INTO log_invite_baoming_info (userid,card_count,card_type,sys_time)	VALUES (%d,%d,%d,now());"
	sql = string.format(sql,user_info.userId,k_count,match_type);
	dblib.execute(sql)
end

--����д���ݿ�
function act_macth_lib.inster_invite_db(user_info,match_gold,match_type, xie_sign)
	--TraceError("����д���ݿ�,sign->"..xie_sign.." �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)

	local sql = "insert into t_invite_pm(user_id,nick_name,win_gold,match_type,baoming_time,sign) value(%d,'%s',%d,%d,now(),%d) ON DUPLICATE KEY UPDATE baoming_time=NOW()";
	local nick = string.trans_str(user_info.nick)
	sql = string.format(sql,user_info.userId,nick,match_gold,match_type,xie_sign);
	dblib.execute(sql) 
end	

--���������ȯ
function act_macth_lib.on_recv_buy_ticket(buf)
	
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	
	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end
	
	if(vip_level<3)then
		act_macth_lib.send_buy_ticket_result(user_info, 5)
	    return 
	end
	--TraceError("���������ȯ     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
	
	local gold = get_canuse_gold(user_info) --����û�����
	local ruslt = 0
	
	--�жϻ��Ч��
	local check_time = act_macth_lib.check_datetime()
	local endtime = timelib.db_to_lua_time(act_macth_lib.endtime);
	local sys_time = os.time();
	if(check_time == 0 or check_time==1 or sys_time > endtime)then
		ruslt = 2
		--TraceError("--111111111111111���������ȯ����  ��ѹ���     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
		 
		--���͹������ȯ���
		act_macth_lib.send_buy_ticket_result(user_info, ruslt)
		return
	end
	
	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		if(act_macth_lib.check_datetime() == 0)then	--�жϻ��Ч��
			ruslt = 2
			--TraceError("--���������ȯ����  ��ѹ���     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			 
			--���͹������ȯ���
			act_macth_lib.send_buy_ticket_result(user_info, ruslt)
			return
			
		elseif(gold < act_macth_lib.OP_MENPIAO_PRIZE["tex"])then	--�жϳ���С��2�����
			ruslt = 0
		 	--TraceError("-- ���������ȯ����  ����С��2�����     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			--���͹������ȯ���
			act_macth_lib.send_buy_ticket_result(user_info, ruslt)
			return
			
		else--�����ɹ�����۳��ʸ�֤����
			--TraceError("���͹������ȯ���,�ɹ�     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			ruslt = 1
	 		--��2�����
		    usermgr.addgold(user_info.userId, -1*act_macth_lib.OP_MENPIAO_PRIZE["tex"], 0, g_GoldType.baoxiang, -1);
		     
		    --�Ӵ��ڴ�������ȯ 
	  		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.NewYearTickets_ID, 1, user_info)
	  	
	  		--���͹������ȯ���
			act_macth_lib.send_buy_ticket_result(user_info, ruslt)
			return
		end
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	--��ѯ�������
		local chaxun_items_result = act_macth_lib.chaxun_add_items(user_info, act_macth_lib.qp_mp_id, 0, 0)
		 
		local desk_no = user_info.desk		-- �����ж��Ƿ���������    ����ڲ��ܹ���
		
    	if(act_macth_lib.check_datetime() == 0)then	--�жϻ��Ч��
			ruslt = 2
			--TraceError("--���������ȯ����  ��ѹ���     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			--���͹������ȯ���
			act_macth_lib.send_buy_ticket_result(user_info, ruslt)
			return
			
		elseif(gold < act_macth_lib.OP_MENPIAO_PRIZE["qp"])then	--�жϳ���С��10����
			ruslt = 0
		 	--TraceError("-- ���������ȯ����  ����С��10����    �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			--���͹������ȯ���
			act_macth_lib.send_buy_ticket_result(user_info, ruslt)
			return
			
		elseif(chaxun_items_result == 3)then		-- ��������
			ruslt = 4
		 	--TraceError("-- ���������ȯ����  ������     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
			
			--���͹������ȯ���
			act_macth_lib.send_buy_ticket_result(user_info, ruslt)
			return
		
		elseif(desk_no ~= nil)then	--�ж��Ƿ���������
			ruslt = 0
		 	--TraceError("-- ���������ȯ����  ��������   ���ܹ���    �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
		 	
		 	--���͹������ȯ���
			act_macth_lib.send_buy_ticket_result(user_info, ruslt)
			return
						
		else--���������ȯ�ɹ�����۳��ʸ�֤����
 			
 			--��10����
		    usermgr.addgold(user_info.userId, -1*act_macth_lib.OP_MENPIAO_PRIZE["qp"], 0, tSqlTemplete.goldType.HD_NEW_YEAR, -1);
		    
			--�ӱ�����Ʊ
			local add_items_result = act_macth_lib.chaxun_add_items(user_info, act_macth_lib.qp_mp_id, 1, 1)
			
			----TraceError("-- ���������ȯ   �ӱ�����Ʊ    ����    �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name.." add_items_result:"..add_items_result)
			
			--�жϼӵ��߽��
			if(add_items_result == 1)then		--�ӵ��߳ɹ�
				
				--TraceError("���͹������ȯ���,�ɹ�     �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
				ruslt = 1
				
				--���͹������ȯ���
				act_macth_lib.send_buy_ticket_result(user_info, ruslt)
				return
			else	
				--֪ͨ�û�������������
				--ruslt = 4
				
				--���͹������ȯ���
				--act_macth_lib.send_buy_ticket_result(user_info, ruslt)
				--return
			end
		end
    end 
end
 
--���͹������ȯ���
function act_macth_lib.send_buy_ticket_result(user_info, ruslt)
	--TraceError("���͹������ȯ���,userId:"..user_info.userId.." ruslt->"..ruslt.." ��Ϸ����"..gamepkg.name)
	netlib.send(function(buf)
		    buf:writeString("INVITEBUYTK")
		    buf:writeByte(ruslt)		    
	        end,user_info.ip,user_info.port) 
end


--����  ��ѯ  �ͼ�   ���߹��÷���          item_id:����id    item_num����������           use_type��ʹ�÷�ʽ��0:��ѯ   1����  ����
function act_macth_lib.chaxun_add_items(user_info, item_id, item_num, use_type)
	--TraceError("����  ��ѯ  �ͼ�   ���߹��÷���,item_id:"..item_id.." item_num->"..item_num.." use_type:"..use_type.." �û�id: "..user_info.userId)
  
  	local ret = 0; 
	bag.get_all_item_info(user_info, function(items)
            local check_items = {[item_id]=1};
            local check_space = 0;
             
            for k, v in pairs(check_items) do
                check_space = bag.check_space(items, {[k]=v}); 
                if(check_space ~= 1) then--��������
                    ret = 3
                end 
            end  
    		
            if (ret == 3) then                      --�������� 
                ret = 3;
                return ret
            end
             
            if(use_type > 0)then                                             --ͨ��������֤ 
                bag.add_item(user_info, {item_id = item_id, item_num = item_num},nil,bag.log_type.NY_HOUDONG);
                ret = 1;	--�ӵ��߳ɹ� 
                return ret
            end 
        end);
    --TraceError("����  ��ѯ  �ͼ�   ���߹��÷���,  �û�id: "..user_info.userId.."  ���ؽ��:"..ret)
	return ret 
end

-- ȫ�����㲥(����ר��)
function act_macth_lib.ontimer_broad(tips,flag)
    --�����ʾ��Ϊnil ȫ�����㲥��
    if(flag == nil or flag~= 1)then
    	
      tips = _U(tips)
    end
    if (tips ~=  nil and tips ~=  "" and groupinfo.groupid == 3005) then
    	
        tools.SendBufToUserSvr("", "SPBC", "", "", tips)
    end
end
 
--���ͷ�����Ϣ
act_macth_lib.send_fajiang_msg = function()
	
	--����
	if(act_macth_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		--ְҵ��
	 	local sql = "SELECT nick_name FROM t_invite_pm WHERE match_type = 2 AND play_count >= 1  ORDER BY win_gold DESC LIMIT 3";
		sql = string.format(sql,match_type)
		 
		dblib.execute(sql,function(dt)	
				if(dt ~= nil and  #dt > 0)then
					local len = 3
					if(#dt < 3)then
						len = #dt
					end
					 
					local msg = ""
					for i = 1,len do
						if(i == 1)then
							msg = _U(tex_lan.get_msg(user_info, "match_msg_awards_1"))..dt[i].nick_name.._U(tex_lan.get_msg(user_info, "match_msg_zbs_awards_type_2"));
							msg = string.format(msg,i);
						elseif(i == 2)then
						 	msg = _U(tex_lan.get_msg(user_info, "match_msg_awards_1"))..dt[i].nick_name.._U(tex_lan.get_msg(user_info, "match_msg_zbs_awards_type_2"));
							msg = string.format(msg,i);
						elseif(i == 3)then
						 	msg = _U(tex_lan.get_msg(user_info, "match_msg_awards_1"))..dt[i].nick_name.._U(tex_lan.get_msg(user_info, "match_msg_zbs_awards_type_2"));
							msg = string.format(msg,i);
						end 
						BroadcastMsg(msg,0)
					end 
				end
			end)
		
		--ר�ҳ�
		local sql = "SELECT nick_name FROM t_invite_pm WHERE match_type = 3 AND play_count >= 1  ORDER BY win_gold DESC LIMIT 3";
		sql = string.format(sql,match_type)
		 
		dblib.execute(sql,function(dt)	
				if(dt ~= nil and  #dt > 0)then
					local len = 3
					if(#dt < 3)then
						len = #dt
					end
					
					local msg = ""
					for i = 1,len do
						if(i == 1)then
							msg = _U(tex_lan.get_msg(user_info, "match_msg_awards_1"))..dt[i].nick_name.._U(tex_lan.get_msg(user_info, "match_msg_zbs_awards_type_3"));
							msg = string.format(msg,i,200);
						elseif(i == 2)then
						 	msg = _U(tex_lan.get_msg(user_info, "match_msg_awards_1"))..dt[i].nick_name.._U(tex_lan.get_msg(user_info, "match_msg_zbs_awards_type_3"));
							msg = string.format(msg,i,100);
						elseif(i == 3)then
						 	msg = _U(tex_lan.get_msg(user_info, "match_msg_awards_1"))..dt[i].nick_name.._U(tex_lan.get_msg(user_info, "match_msg_zbs_awards_type_3"));
							msg = string.format(msg,i,50);
						end 
						BroadcastMsg(msg,0)
					end 
				end
			end)
	end
	
	--����
    if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		
		--�齫
	 	local sql = "SELECT nick_name FROM t_invite_pm WHERE match_type = 2 AND play_count >= 1  ORDER BY win_gold DESC LIMIT 3";
		sql = string.format(sql,match_type)
		 
		dblib.execute(sql,function(dt)	
				if(dt ~= nil and  #dt > 0)then
					local len = 3
					if(#dt < 3)then
						len = #dt
					end
					
					local msg = ""
					
					msg = _U("��ϲ   ")..dt[1].nick_name.._U("  �� ")..dt[2].nick_name.._U("  �� ")..dt[3].nick_name.._U("����˽����齫������ǰ3�������ν����ر�ͼ100 �š�50 �š�20 �ţ�")
					
					act_macth_lib.ontimer_broad(msg,1);
						 
					--ָ���� ��������  ��
					if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == "zysz")then
						BroadcastMsg(msg,0)
					end
				end
			end)
		
		--��������
		local sql = "SELECT nick_name FROM t_invite_pm WHERE match_type = 3 AND play_count >= 1  ORDER BY win_gold DESC LIMIT 3";
		sql = string.format(sql,match_type)
		 
		dblib.execute(sql,function(dt)	
				if(dt ~= nil and  #dt > 0)then
					local len = 3
					if(#dt < 3)then
						len = #dt
					end
					local msg1 = ""
					
					msg1 = _U("��ϲ   ")..dt[1].nick_name.._U("  �� ")..dt[2].nick_name.._U("  �� ")..dt[3].nick_name.._U("����˽����������ž�����ǰ3�������ν����ر�ͼ200 �š�100 �š�50 �ţ�")
					
					act_macth_lib.ontimer_broad(msg1,1);
						 
					--ָ���� ��������  ��
					if(act_macth_lib.cfg_qp_game_name[gamepkg.name] == "zysz")then
						BroadcastMsg(msg1,0)
					end
					
				end
			end)
		
	end 
end
 
--Э������
cmd_tex_match_handler = 
{ 
    --���������Э��
    ["INVITEPHLIST"] = act_macth_lib.on_recv_invite_ph_list,  --���������������а�
   -- ["INVITEDJ"] = act_macth_lib.on_recv_invite_dj,  --��д���������콱���
    ["INVITEBTN"] = act_macth_lib.on_recv_refresh_timeinfo, --����ˢ��ͼ�갴ť��Ϣ
    ["INVITEGIF"] = act_macth_lib.on_recv_already_know_reward, --�ͻ���֪ͨ�Ѿ�����콱��ť��
    
    ["INVITEPHDATE"] = act_macth_lib.on_recv_activity_stat, --����ʱ��״̬
    ["INVITESIGNUP"] = act_macth_lib.on_recv_sign, --����������
    ["INVITEBUYTK"] = act_macth_lib.on_recv_buy_ticket, --���������ȯ
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", act_macth_lib.on_after_user_login);
eventmgr:addEventListener("timer_minute", act_macth_lib.ontimecheck); 
eventmgr:addEventListener("game_event", act_macth_lib.ongameover); 
eventmgr:addEventListener("game_begin_event", act_macth_lib.ongamebegin);  

