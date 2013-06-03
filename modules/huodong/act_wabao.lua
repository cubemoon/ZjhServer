TraceError("init act_wabao_lib...��ʼ���ڱ��")
if act_wabao_lib and act_wabao_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", act_wabao_lib.on_after_user_login);
end 

if not act_wabao_lib then
	act_wabao_lib = _S
	{
		on_after_user_login = NULL_FUNC,--�û���½���ʼ������
		check_datetime = NULL_FUNC,	--�����Чʱ�䣬��ʱ����
		query_db = NULL_FUNC,		--��ѯ������Լ����� 
		chaxun_add_items = NULL_FUNC,	--����  ��ѯ  �ͼ�   ���߹��÷���   
		ontimer_broad = NULL_FUNC,		-- �㲥 
		send_item_info = NULL_FUNC,		--���Ͳ��Ϻ͵��ߵ���Ϣ 
		send_buy_result = NULL_FUNC,	--���͹����� 
		send_use_result = NULL_FUNC,	--����ʹ�ý��/����/ͭ����	 
		net_send_playnum = NULL_FUNC,	--����������ʱ��״̬ 
		on_recv_items_info = NULL_FUNC,		--�������в��ϵ���Ϣ 
		on_recv_buy = NULL_FUNC, 			--������ 
		on_recv_activation = NULL_FUNC,		--����򿪻��� 
		on_recv_activity_stat = NULL_FUNC,		--����ʱ��״̬ 
		on_recv_use = NULL_FUNC,				--ʹ�ý��/����/ͭ�� 
		spring_gift = NULL_FUNC,		--������ɽ�ƷID (����  ����    ����)
		doing_props = NULL_FUNC,		--���ڱ�ͼ (����  ����    ����)
		use_process = NULL_FUNC,		--����ʹ�� �߼�local (����  ����    ����) 
		doing_gold = NULL_FUNC,		--����ӡ������/����
  
	 	cfg_qp_game_name = {      --������Ϸ����  
        	["zysz"] = "zysz",
        	["mj"] = "mj", 
    					},
    				
    	cfg_tex_game_name = {      --������Ϸ����   
        	["tex"] = "tex",
    					},
		act_startime = "2012-06-28 09:00:00",  --���ʼʱ��
    	act_endtime = "2012-07-05 23:59:00",  --�����ʱ��
    	rank_endtime = "2012-07-07 00:00:00",	--���а����ʱ��
	}
end

--�����Чʱ�䣬��ʱ����
function act_wabao_lib.check_datetime()
	local sys_time = os.time();
	
	--�ʱ��
	local statime = timelib.db_to_lua_time(act_wabao_lib.act_startime);
	local endtime = timelib.db_to_lua_time(act_wabao_lib.act_endtime);
	local rank_endtime = timelib.db_to_lua_time(act_wabao_lib.rank_endtime);
	if(sys_time > statime and sys_time <= endtime) then
	    return 1;
	end
	
	if(sys_time > endtime and sys_time <= rank_endtime) then
		return 5; --��������������а�ͼ�걣��1�����ʧ��
	end
	
	--�ʱ���ȥ��
	return 0;
end

--�û���½���ʼ������
act_wabao_lib.on_after_user_login = function(e)
	
	--��Ϸ������֤
    if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("�û���½���ʼ������      gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("�û���¼���¼�->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end
	
	local check_result = act_wabao_lib.check_datetime()	--���ʱ��
	if(check_result == 0 or check_result == 5)then
		--TraceError("�û���½���ʼ������,�ʱ��ʧЧif(check_result == 0 and check_result == 5)then")
		return
	end
	
	local user_info = e.data.userinfo
	--TraceError("�û���½���ʼ������,userid:"..user_info.userId)
	if(user_info == nil)then 
		--TraceError("�û���½���ʼ������,if(user_info == nil)then")
	 	return
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--������ʼ������
		if(user_info.bag_items == nil)then
			----TraceError("������ʼ������")
			bag.get_all_item_info(user_info,function() end ,nil)
		end
	end
	
	--��ʼ���û��ر�ͼ����
    if(user_info.wabao_map_value == nil)then
    	user_info.wabao_map_value = 0
    end
    
    --��ʼ���û��������
    if(user_info.wabao_jin_value == nil)then
    	user_info.wabao_jin_value = 0
    end
    
    --��ʼ���û���������
    if(user_info.wabao_yin_value == nil)then
    	user_info.wabao_yin_value = 0
    end
    
    --��ʼ���û�ͭ������
    if(user_info.wabao_tong_value == nil)then
    	user_info.wabao_tong_value = 0
    end
    
    --��ѯ������Լ�����
	act_wabao_lib.query_db(user_info)
    
end

--��ѯ������Լ�����
function act_wabao_lib.query_db(user_info)
 
	local user_nick = user_info.nick
	user_nick = string.trans_str(user_nick)
	
	--��ѯ��������ݿ�
	local sql = "insert ignore into t_wabao_activity (user_id, user_nick, sys_time) values(%d, '%s', now());commit;";
    sql = string.format(sql, user_info.userId, user_nick);
	dblib.execute(sql)
	
	local sql_1 = "select sys_time,map_value,jin_value,yin_value,tong_value from t_wabao_activity where user_id = %d"
	sql_1 = string.format(sql_1, user_info.userId);
 
	dblib.execute(sql_1,
    function(dt)
    	if dt and #dt > 0 then

    		local sys_today = os.date("%Y-%m-%d", os.time()); --ϵͳ�Ľ���
            local db_date = os.date("%Y-%m-%d", timelib.db_to_lua_time(dt[1]["sys_time"]));  --���ݿ�Ľ���
            user_info.wabao_map_value = dt[1]["map_value"] or 0
            user_info.wabao_jin_value = dt[1]["jin_value"] or 0 
            user_info.wabao_yin_value = dt[1]["yin_value"] or 0
            user_info.wabao_tong_value = dt[1]["tong_value"] or 0 
             
    	else
			--TraceError("�û���½���ʼ������,��ѯ��������ݿ�->ʧ��")
    	end
    
    end)
end


--ʹ�ý��/����/ͭ��
function act_wabao_lib.on_recv_use(buf)
 
	--��Ϸ������֤
    if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("ʹ�ý��/����/ͭ��      gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("ʹ�ý��/����/ͭ��->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end
  
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end; 
   	 
   	--���ʱ����Ч��
	local check_time = act_wabao_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then 
    	--TraceError("ʹ�ý��/����/ͭ��,ʱ����ڣ�     gamepkg.name�� "..gamepkg.name.."  USERID:"..user_info.userId)
    	act_wabao_lib.send_use_result(user_info, -1, -1)
        return;
    end
     
    --�յ���ʹ��id	1:�ر�ͼ   2��ͭ      3����         4����
    local use_id = buf:readByte();
    
    --TraceError("ʹ�ý��/����/ͭ��      gamepkg.name�� "..gamepkg.name.."  USERID:"..user_info.userId.."   �յ���ʹ��id:"..use_id)
    
    --ת���յ�id
    local change_id = 0
    if(use_id == 2)then	--2��ͭ
    	change_id = 1 
    elseif(use_id == 3)then	--3����
    	change_id = 2 
    elseif(use_id == 4)then	--4����
    	change_id = 3 
    end
    
    local jin_value = user_info.wabao_jin_value or 0		--��
    local yin_value = user_info.wabao_yin_value or 0		--��
    local tong_value = user_info.wabao_tong_value or 0 	--ͭ
   
  	local result = 0 
  	
	--��ȡ�û��ر�ͼ����
	--����
	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
	
		local map_value = user_info.propslist[9] or 0;		--�ر�ͼ
		
		--����ʹ�� �߼�local (����  ����    ����)
		act_wabao_lib.use_process(user_info, change_id, map_value)
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    
    	--��ѯ���� �� ����
		local chaxun_items_result = act_wabao_lib.chaxun_add_items(user_info, 4, 0, 0)		--4�����µ��ߣ���Ҫ���жϼ����е��ߣ������Ƿ���
		--TraceError("ʹ�� 2��ͭ      3����         4����       ����        --��ѯ���� �� ����,--�� USERID:"..user_info.userId.." chaxun_items_result:"..chaxun_items_result)
		--�жϼӵ��߽��
		if(chaxun_items_result == 3)then		--���� ��
			--TraceError("ʹ�� 2��ͭ      3����         4����       ����         �û�������,--�� USERID:"..user_info.userId.." result:"..result)
			local result = 4
			act_wabao_lib.send_use_result(user_info, result, 0)
			return 
		end 
	 
    	local map_value = user_info.bag_items[8005] or 0;		--�ر�ͼ
    	
    	--����ʹ�� �߼�local (����  ����    ����)
		act_wabao_lib.use_process(user_info, change_id, map_value)
    end
  	
end

--����ʹ�� �߼�local (����  ����    ����)
function act_wabao_lib.use_process(user_info, change_id, map_value)
  	local result = 0
  	local award_id = 0		--�����ƷID
  	if(change_id == 1)then	--ͭ 
   		if(map_value  >= 1)then 
   			--���ڱ�ͼ 
   			map_value = map_value - 1
   			--user_info.wabao_tong_value = map_value
   			
   			--���ڱ�ͼ 
   			act_wabao_lib.doing_props(user_info, 1, change_id)
   			 
   		else
   			--TraceError("ʹ��    ͭ ,--�ڱ�ͼ  ���㣬 USERID:"..user_info.userId)
   			--����ʹ��ͭ ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			act_wabao_lib.send_use_result(user_info, result, award_id)
	        return;
   		end
       
    elseif(change_id == 2)then	--�� 
    	if(map_value >= 3)then 
   			--����
   			map_value = map_value - 3
   			
   			--���ڱ�ͼ 
   			act_wabao_lib.doing_props(user_info, 3, change_id)
   			  
   		else
   			--TraceError("ʹ����,--�ڱ�ͼ���㣬 USERID:"..user_info.userId)
   			--����ʹ����ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			act_wabao_lib.send_use_result(user_info, result, award_id)
	        return;
   		end
    elseif(change_id == 3)then	--��
    	if(map_value >= 10)then 
   			--����
   			map_value = map_value - 10
   			 
   			 --���ڱ�ͼ 
   			act_wabao_lib.doing_props(user_info, 10, change_id)
   		else
   			--TraceError("ʹ�ý�,--�ڱ�ͼ���㣬 USERID:"..user_info.userId)
   			--����ʹ�ý�ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			act_wabao_lib.send_use_result(user_info, result, award_id)
	        return;
   		end
    else 
    	--TraceError("ʹ��   δ֪ ���� USERID:"..user_info.userId)
    	result = 0
    	award_id = -1
		act_wabao_lib.send_use_result(user_info, result, award_id)
        return;
   	end
     
	--���� ���ݿ�
    local sqltemplet = "update t_wabao_activity set map_value = %d where user_id = %d;commit;";
    local sql=string.format(sqltemplet, map_value, user_info.userId);
    dblib.execute(sql);
    
    
  	--���Ͳ��Ϻ͵��ߵ���Ϣ
 	local item1 = map_value		--�ر�ͼ
	local item2 = user_info.wabao_tong_value or 0		--ͭ
 	local item3 = user_info.wabao_yin_value or 0		--��
 	local item4 = user_info.wabao_jin_value or 0		--�� 
 	act_wabao_lib.send_item_info(user_info, item1, item2, item3, item4)
    
end

--���ڱ�ͼ (����  ����    ����)
function act_wabao_lib.doing_props(user_info, item_values, change_id)
	--����
	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		user_info.propslist[9] = user_info.propslist[9] - item_values
		local complete_callback_func = function(tools_count)
  	 		--������ɽ�ƷID
			act_wabao_lib.spring_gift(user_info, change_id) 
		end
 		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.wabao_map_id, -item_values, user_info, complete_callback_func)
 	end
 	
 	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
     	--�ӱ���
		local add_items_result = act_wabao_lib.chaxun_add_items(user_info, 8005, -item_values, 1)
		--�жϼӵ��߽��
		if(add_items_result == 1)then		--�ӵ��߳ɹ�
			--TraceError("���ڱ�ͼ  , �ɹ�")
			 
			--������ɽ�ƷID
			act_wabao_lib.spring_gift(user_info, change_id) 
		else
			--TraceError("���ڱ�ͼ  , ʧ�ܡ�����������")
			
			--֪ͨ�û�������������
			local result = 4
			--����ʹ�� 	1:�ر�ͼ   2��ͭ      3����         4����ɹ����
	    	--TraceError("ʹ�� 2��ͭ      3����         4����       ����         �û�������,--�� USERID:"..user_info.userId.." result:"..result)
			act_wabao_lib.send_use_result(user_info, result, 0)
		end
    end
end

--������ɽ�ƷID(����  ����    ����)
function act_wabao_lib.spring_gift(user_info, change_id)
 		local result = 0
	 	local award_id = 0			--�����ƷID
	 	
    	local sql = format("call sp_get_random_spring_gift(%d, '%s', %d)", user_info.userId, "tex", change_id)
    	dblib.execute(sql, function(dt)
        	if(dt and #dt > 0)then
        		local prizeid = dt[1]["gift_id"] or 0
                
                --TraceError("ʹ��ʹ�ý��/����/ͭ��,������������ɽ�ƷID:"..prizeid.." USERID:"..user_info.userId.."  change_id: "..change_id)
                if(prizeid <= 0) then
                	--TraceError("ʹ��ʹ�ý��/����/ͭ��,������������ɽ�ƷID,ʧ��")
                    return 
                end 
 
				--����
	 			if(change_id == 1)then	--ͭ 
		   			--ת����Ӧ��ƷID
		            if(prizeid == 1)then	--����:500���		����  :200���� 
		            	award_id = 1	 
		            	result = 1
		            	--����ӡ������/����
						act_wabao_lib.doing_gold(user_info, 500, 200)
		  				
		            elseif(prizeid == 2)then	-- ����:����������		����  :2K����
		            	award_id = 2
		            	result = 1				 
		            	
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
			            	--������������
			  				viploginlib.AddBuffToUser(user_info,user_info,1); 	
			  			else
			  				--����ӡ������/����		����  :2K����
							act_wabao_lib.doing_gold(user_info, 0, 2000)
			  			end 
			  			
		             elseif(prizeid == 3)then	-- ����:С����		����  :2�����
		            	award_id = 7
		            	result = 1	
		            	
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
			            	--С���� ��ô��
							local add_items_result = act_wabao_lib.chaxun_add_items(user_info, 4, 1, 1)
							--�жϼӵ��߽��
							if(add_items_result == 1)then		--�ӵ��߳ɹ�
								--TraceError("ʹ�� ͭ ,���� С���� ��,�ɹ�")
								--֪ͨ�û�
								result = 1
							else
								--TraceError("ʹ�� ͭ ,���� С���� ��,ʧ�ܡ�����������")
								
								--֪ͨ�û�������������
								result = 4
							end	
			  			else
			  				--����ӡ������/����    ����  :2�����
							act_wabao_lib.doing_gold(user_info, 0, 20000)
			  			end 
		  	
		            elseif(prizeid == 4)then	-- ����:1����		����  :С����
		            	award_id = 4
		            	result = 1	
		            	
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    					
			            	 --����ӡ������/����    ����:1����
							act_wabao_lib.doing_gold(user_info, 10000, 0)
			  			else
			  				--�����     ����  :С����
							--С������ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info)
			  			end 
		  				
		            elseif(prizeid == 5)then	-- ����:10����		����  :5000����
		            	award_id = 5
		            	result = 1	
		            	
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    					
			            	 --����ӡ������/����    ����:10����
							act_wabao_lib.doing_gold(user_info, 100000, 0)
			  			else
			  				--�����     ����  :����-->5K��VIP1��Ա3������
			  				
			  				--act_wabao_lib.doing_gold(user_info, 0, 5000)  
			  				add_user_vip(user_info,1,3);
			  				--gift_addgiftitem(user_info,9018,user_info.userId,user_info.nick, false)
			  			end  
		         	elseif(prizeid == 0)then	--�쳣
		         		result = 0
		  				--TraceError("ʹ��ͭ ,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
		  				return
		            end	
		        elseif(change_id == 2)then	--��
		        	--ת����Ӧ��ƷID
		            if(prizeid == 1)then	-- ����:2000���		����  :1K����
		            	award_id = 6
		            	result = 1	
		            	
		            	--����ӡ������/����
						act_wabao_lib.doing_gold(user_info, 2000, 1000)
		  				
		            elseif(prizeid == 2)then	-- ����:����������		����  :1W���� 
		            	result = 1	
		            	
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    						award_id = 2
    						
			            	 --������������
			  				viploginlib.AddBuffToUser(user_info,user_info,1); 
			  			else
			  				award_id = 19
			  				
			  				--����ӡ������/����    ����  :1W���� -->1W��VIP3��Ա3������
			  				add_user_vip(user_info,3,3);
							--act_wabao_lib.doing_gold(user_info, 0, 10000)
			  			end 
		  				 
		            elseif(prizeid == 3)then	-- ����:����������		����  :10����� 
		             
		            	result = 1	 
		            	
		  				--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    						award_id = 7
    						
			            	 --������������
		  					viploginlib.AddBuffToUser(user_info,user_info,2); 
			  			else
			  				award_id = 8
			  				 
			  				--����ӡ������/����    ����  :10�����  
							act_wabao_lib.doing_gold(user_info, 0, 100000)
							
							--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}����
			  				local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick) 
			  				local msg = _U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_5"))..user_nick.._U(tex_lan.get_msg(user_info, "act_wabao_lib_msg")); 
							msg = string.format(msg,10);  
							BroadcastMsg(msg,0)
							 
			  			end 
		  	
		            elseif(prizeid == 4)then	-- ����:С����*2  		����  :T�˿�
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    						award_id = 8
		            	
			            	--С����*2��ô��
							local add_items_result = act_wabao_lib.chaxun_add_items(user_info, 4, 2, 1)
							--�жϼӵ��߽��
							if(add_items_result == 1)then		--�ӵ��߳ɹ�
								--TraceError("ʹ�� �� ,���� С����*2��,�ɹ�")
								--֪ͨ�û�
								result = 1
							else
								--TraceError("ʹ�� �� ,���� С����*2��,ʧ�ܡ�����������")
								
								--֪ͨ�û�������������
								result = 4
							end
						else
							award_id = 9
			            	--����  :T�˿�      
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info)
						end
						
		            elseif(prizeid == 5)then	-- ����:50���� 		����  :����
		            	result = 1	 
		            	
		  				--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    						award_id = 9
    						 
			            	 --������:50���� 
		  					act_wabao_lib.doing_gold(user_info, 500000, 0)
		  					 
		  					--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}���� 
			  		 		local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick)
			  				local tips = user_nick.._U("  �ھ������ڱ������50���ң�");
							act_wabao_lib.ontimer_broad(tips,1);
			  			else
			  				award_id = 10
			  				 
			  				--�����    ����  :����--��OL��Ů
							gift_addgiftitem(user_info,9025,user_info.userId,user_info.nick, false)
			  			end 
		  		  	
		  		  	elseif(prizeid == 6)then	-- ����:500���� 		����  :138����ɯ���� 
		            	result = 1 
		  				--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    						award_id = 10
    						 
			            	 --������:500���� 
		  					act_wabao_lib.doing_gold(user_info, 5000000, 0)
		  					 
		  					--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}���� 
			  		 		local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick)
			  				local tips = user_nick.._U("  �ھ������ڱ������500���ң�");
							act_wabao_lib.ontimer_broad(tips,1);
			  			else
			  				award_id = 11
			  				 
			  				--�����    ����  :С����
							tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info)
			  			end 
						
		  			elseif(prizeid == 0)then	--�쳣
		  				--TraceError("ʹ���� ,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
		  				return
		            end	
		   		elseif(change_id == 3)then		--��
		   			--ת����Ӧ��ƷID
		            if(prizeid == 1)then	-- ����: С����*3		����  :T�˿�*2
		            	
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then 
			            	award_id = 11  --С����*3
			             
			            	--С����*3
			  				local add_items_result = act_wabao_lib.chaxun_add_items(user_info, 4, 3, 1)
							--�жϼӵ��߽��
							if(add_items_result == 1)then		--�ӵ��߳ɹ�
								--TraceError("ʹ�� �� ,���� С����*3��,�ɹ�")
								--֪ͨ�û�
								result = 1
							else
								--TraceError("ʹ�� �� ,���� С����*3��,ʧ�ܡ�����������")
								
								--֪ͨ�û�������������
								result = 4
							end
						else
							result = 1
							award_id = 12 
							--�� ����  : T�˿�*2
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 2, user_info)
						
						end
		          
		            elseif(prizeid == 2)then	-- ����: 5����		����  :С����
		            	result = 1 
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then 
	    					
			            	award_id = 12
			            	
			  				--����ӡ������/���� 
							act_wabao_lib.doing_gold(user_info, 50000, 0)
			  			else
			  				--�����     ����  :С���� *2
			  				award_id = 13
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 2, user_info)
			  			end  
		            elseif(prizeid == 3)then	-- ����: 80����		����  :����girl��1%��
		            	result = 1 
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then 
	    					
			            	award_id = 13
			            	
			  				--����ӡ������/����     ����: 80����
							act_wabao_lib.doing_gold(user_info, 800000, 0)
							
							--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}���� 
			  		 		local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick)
			  				local tips = user_nick.._U("  �ھ������ڱ������80���ң�");
							act_wabao_lib.ontimer_broad(tips,1);
			  			else
			  				--�����     ����  :����girl(9022)�ĳ��Ը���Ů�� 9024��
			  		 		award_id = 14
			  				gift_addgiftitem(user_info,9024,user_info.userId,user_info.nick, false)
			  			end  
		  				 
		  			elseif(prizeid == 4)then	-- ����: 500����		����  :1�����
		            	result = 1 
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then 
	    					
			            	award_id = 10
			            	
			  				--����ӡ������/����     ����: 500����
							act_wabao_lib.doing_gold(user_info, 5000000, 0)
							
							--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}���� 
			  		 		local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick)
			  				local tips = user_nick.._U("  �ھ������ڱ������500���ң�");
							act_wabao_lib.ontimer_broad(tips,1);
			  			else
			   				--�����     ����  :2�����
			  		 		award_id = 7
			  				act_wabao_lib.doing_gold(user_info, 0, 20000)
			  			end
						 
		  			elseif(prizeid == 5)then	-- ����: 2000����		����  :2�����
		            	result = 1 
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then 
	    					
			            	award_id = 14
			            	
			  				--����ӡ������/����     ����: 2000����
							act_wabao_lib.doing_gold(user_info, 20000000, 0)
							
							--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}���� 
			  		 		local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick)
			  				local tips = user_nick.._U("  �ھ������ڱ������2000���ң�");
							act_wabao_lib.ontimer_broad(tips,1);
			  			else
			   				--�����     ����  :10�����
			  		 		award_id = 3
			  				act_wabao_lib.doing_gold(user_info, 0, 100000)
			  			end
					elseif(prizeid == 6)then	-- ����: 1�ڽ��		����  :20�����
		            	result = 1 
		            	--����
    					if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then 
	    					
			            	award_id = 15
			            	
			  				--����ӡ������/����     ����: 1�ڽ��
							act_wabao_lib.doing_gold(user_info, 100000000, 0)
							
							--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}���� 
			  		 		local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick)
			  				local tips = user_nick.._U("  �ھ������ڱ������1�ڽ�ң�");
							act_wabao_lib.ontimer_broad(tips,1);
			  			else
			   				--�����     ����  :20�����
			  		  		award_id = 15
			  				act_wabao_lib.doing_gold(user_info, 0, 200000)
			  				
			  				--ϵͳ�㲥����{XXXX}�ھ������ڱ������{ʲô����}����
			  				local user_nick = user_info.nick
							user_nick = string.trans_str(user_nick)
			  				local msg = _U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_5"))..user_nick.._U(tex_lan.get_msg(user_info, "act_wabao_lib_msg")); 
							msg = string.format(msg,20);  
							BroadcastMsg(msg,0)
			  			end
			  		elseif(prizeid == 7)then	-- ����  :138�򱼳ۺ�������
			  			result = 1 
			  			award_id = 16
			  				 
		  				--�����    ����  :138�򱼳ۺ�������
						gift_addgiftitem(user_info,5017,user_info.userId,user_info.nick, false)	
						
						--ϵͳ�㲥����{XXXX}�ھ������ڱ������138�򱼳ۺ������� ����
		  				local user_nick = user_info.nick
						user_nick = string.trans_str(user_nick) 
		  				local msg = _U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_5"))..user_nick.._U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_1")); 
						BroadcastMsg(msg,0)
						
			  		elseif(prizeid == 8)then	--  ����  :588������
			  			result = 1 
			  			award_id = 17
			  				 
		  				--�����    ����  :588������
						gift_addgiftitem(user_info,5024,user_info.userId,user_info.nick, false)	
						 
						--ϵͳ�㲥����{XXXX}�ھ������ڱ������588������ ����
		  				local user_nick = user_info.nick
						user_nick = string.trans_str(user_nick) 
		  				local msg = _U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_5"))..user_nick.._U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_2")); 				
						BroadcastMsg(msg,0)
			  		
			  		elseif(prizeid == 9)then	-- ����  :1888����������
			  			result = 1 
			  			award_id = 18
			  				 
		  				--�����    ����  :1888����������
						gift_addgiftitem(user_info,5026,user_info.userId,user_info.nick, false)	
						 
						--ϵͳ�㲥����{XXXX}�ھ������ڱ������1888���������� ����
		  				local user_nick = user_info.nick
						user_nick = string.trans_str(user_nick) 
		  				local msg = _U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_5"))..user_nick.._U(tex_lan.get_msg(user_info, "act_wabao_lib_msg_3"));  
						BroadcastMsg(msg,0)
			  		
		  			elseif(prizeid == 0)then	--�쳣
		  				result = 0
		  				----TraceError("ʹ�� �����ɿ���,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
		  				return
		            end	
			    end
			   
			   --����ʹ�� 	1:�ر�ͼ   2��ͭ      3����         4����ɹ����
		    	--TraceError("ʹ�� 2��ͭ      3����         4����֮��,--�� USERID:"..user_info.userId.." result:"..result.." award_id:"..award_id)
				act_wabao_lib.send_use_result(user_info, result, award_id) 
            end
        end)
   
end

--����ӡ������/����
function act_wabao_lib.doing_gold(user_info, qp_gold_value, tex_gold_value)
	--TraceError("����ӡ������/����         �û�id��"..user_info.userId.." qp_gold_value: "..qp_gold_value.."  gamepkg.name�� "..gamepkg.name.." tex_gold_value: "..tex_gold_value)
	--����
	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		 usermgr.addgold(user_info.userId, tex_gold_value, 0, g_GoldType.baoxiang, -1);
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		usermgr.addgold(user_info.userId, qp_gold_value, 0, tSqlTemplete.goldType.HD_NEW_YEAR, -1);
	end
	
end

--����ʱ��״̬
function act_wabao_lib.on_recv_activity_stat(buf)
	
	--��Ϸ������֤
    if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("����ʱ��״̬      gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("����ʱ��״̬   ->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end
    
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
 
	--���ʱ����Ч��
	local check_time = act_wabao_lib.check_datetime()
	
	--TraceError("--����ʱ��״̬-->>"..check_time)
	
	if(check_time == 0 or check_time == 5) then 
		return
	end 
	 
 	local item1 = 0;		--�ر�ͼ
	local item2 = user_info.wabao_tong_value or 0;		--ͭ
 	local item3 = user_info.wabao_yin_value or 0		--��
 	local item4 = user_info.wabao_jin_value or 0		--��  
 	
 	--����
	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		item1 = user_info.propslist[9] or 0
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	item1 = user_info.bag_items[8005] or 0
    end
 	
	if(item1 > 0 or item2 > 0 or item3 > 0 or item4 > 0)then
		check_time = 2;		--���Ч,�в���
	end
	 
	--�û�����     ������û���ã�ֻ�Ƿ���ǰ̨���ı����
	local play_count = 0 
	
 	--֪ͨ�ͻ���
    act_wabao_lib.net_send_playnum(user_info, check_time, play_count);
end


--����򿪻���
function act_wabao_lib.on_recv_activation(buf)

	--��Ϸ������֤
    if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("����򿪻���      gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("����򿪻���   ->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end
    
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
 
   	--TraceError("����򿪻���,USERID:"..user_info.userId)
   
   	--���ʱ����Ч��
	local check_time = act_wabao_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("����򿪻���,ʱ����ڣ� USERID:"..user_info.userId)  
    	--����ʱ�����
		act_wabao_lib.net_send_playnum(user_info, 0, 0) 
        return;
    else
    	--����ʱ�����
		act_wabao_lib.net_send_playnum(user_info, 1, 0) 
    end 
    
	--��ѯ������Լ�����
	act_wabao_lib.query_db(user_info)
	
	--���Ͳ��Ϻ͵��ߵ���Ϣ 
 	local item1 = 0;		--�ر�ͼ
	local item2 = user_info.wabao_tong_value or 0;		--ͭ
 	local item3 = user_info.wabao_yin_value or 0		--��
 	local item4 = user_info.wabao_jin_value or 0		--��  
 	
 	--����
	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		item1 = user_info.propslist[9] or 0
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	item1 = user_info.bag_items[8005] or 0
    end
    
 	act_wabao_lib.send_item_info(user_info, item1, item2, item3, item4) 
end

--������
function act_wabao_lib.on_recv_buy(buf) 
	--��Ϸ������֤
    if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("������      gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("������   ->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end
	
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   
   	--�յ�����id
    local buy_type_id = buf:readByte();
    	
   	--TraceError("������,USERID:"..user_info.userId.." �յ�����id:"..buy_type_id)
   	 
 	local result = 0
    local gold = get_canuse_gold(user_info) --����û�����
  
	local map_value = 0	--�ر�ͼ
	--����
	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		map_value = user_info.propslist[9] or 0
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	map_value = user_info.bag_items[8005] or 0
    end
	
   	--���ʱ����Ч��
	local check_time = act_wabao_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("������,ʱ����ڣ� USERID:"..user_info.userId)
    	
    	--���͹�����
    	result = 2 
		act_wabao_lib.send_buy_result(user_info, buy_type_id, map_value, result)
    	return;  
    end
 
 	--����
 	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
	 	--�ж��Ƿ���Ǯ
	 	if(buy_type_id == 1)then		--�ر�ͼ
	    	if(gold < 100000)then
	    		--TraceError("����ر�ͼ,Ǯ������ USERID:"..user_info.userId)
		    	
		    	--���͹�����
		    	result = 0
				act_wabao_lib.send_buy_result(user_info, buy_type_id, map_value, result)
		    	return
		    else
		    	 
	    		--�Ӳر�ͼ
				--���Թ���
		    	--������
				usermgr.addgold(user_info.userId, -100000, 0, g_GoldType.baoxiang, -1);
	 
				--�Ӳر�ͼ
				map_value = map_value + 10 
				user_info.propslist[9] = map_value
	    		
	   			local complete_callback_func = function(tools_count)
	   				result = 1
	      	 		--���͹���ɹ�
					act_wabao_lib.send_buy_result(user_info, 1, map_value, result)
	    		end 
	   		 	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.wabao_map_id, 10, user_info, complete_callback_func)
	    		 
	    	end
		end
	end
	
	--����
	if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		local result = 0
		--��ѯ������� �������� 
		local chaxun_items_result = act_wabao_lib.chaxun_add_items(user_info, 8005, 0, 0)
		--TraceError("����ر�ͼ,Ǯ������ USERID:"..user_info.userId.."  chaxun_items_result: "..chaxun_items_result)
		
		if(chaxun_items_result == 3)then		--��
	 		--֪ͨ�û�������������
			result = 4 
			act_wabao_lib.send_buy_result(user_info, 1, map_value, result)
			return
	 	end
	 	
	 	local site = user_info.site		-- �����ж��Ƿ���������    ����ڲ��ܹ���
		
		--�ж��Ƿ���Ǯ
	 	if(buy_type_id == 1)then		--�ر�ͼ
	    	if(gold < 500000)then
	    		--TraceError("����ر�ͼ,Ǯ������ USERID:"..user_info.userId)
		     
		    	--���͹�����
		    	result = 0
				act_wabao_lib.send_buy_result(user_info, buy_type_id, map_value, result)
		    	return
		    	
		    elseif(site ~= nil)then	--�ж��Ƿ��� 
				--TraceError("-- ������ر�ͼ����  ������������   ���ܹ���    �û�id��"..user_info.userId.." ��Ϸ����"..gamepkg.name)
				
				result = 5 
		 		act_wabao_lib.send_buy_result(user_info, buy_type_id, map_value, result)
		    	return 
		    else
		    	--���Թ���
			    --������
				usermgr.addgold(user_info.userId, -500000, 0, tSqlTemplete.goldType.HD_NEW_YEAR, -1);
		    	 
	    		--�ӱ��� �ر�ͼ
				local add_items_result = act_wabao_lib.chaxun_add_items(user_info, 8005, 10, 1)
				--�жϼӵ��߽��
				if(add_items_result == 1)then		--�ӵ��߳ɹ�
					--TraceError("  ������ر�ͼ , �ɹ�")
					
					--�Ӳر�ͼ
					map_value = map_value + 10
					
					--֪ͨ�û�
					result = 1
					act_wabao_lib.send_buy_result(user_info, 1, map_value, result)
				else
					--TraceError("������ر�ͼ , ʧ�ܡ����������� add_items_result:"..add_items_result)
					
					--֪ͨ�û�������������
					result = 4
					act_wabao_lib.send_buy_result(user_info, 1, map_value, result)
				end
	    		 
	    	end
		end
	end
    
    --���� ���ݿ�
    local sqltemplet = "update t_wabao_activity set map_value = %d where user_id = %d;commit;";
    local sql=string.format(sqltemplet, map_value, user_info.userId);
    dblib.execute(sql);
    
end
 
--�������в��ϵ���Ϣ
function act_wabao_lib.on_recv_items_info(buf)
	--��Ϸ������֤
    if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name or act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
		--TraceError("�������в��ϵ���Ϣ      gamepkg.name�� "..gamepkg.name)
	else
		--TraceError("�������в��ϵ���Ϣ   ->��Ϸ�¼���֤->���ڻ�� �� ����      gamepkg.name�� "..gamepkg.name)
		return
	end
	
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("�������в��ϵ���Ϣ,USERID:"..user_info.userId)
   
   	--���ʱ����Ч��
	local check_time = act_wabao_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("�����������в��ϵ���Ϣ,ʱ����ڣ� USERID:"..user_info.userId) 
        return;
    end
    
    --���Ͳ��Ϻ͵��ߵ���Ϣ 
 	local item1 = 0;
 	local item2 = user_info.wabao_tong_value or 0
 	local item3 = user_info.wabao_yin_value or 0
 	local item4 = user_info.wabao_jin_value or 0
 	--����
	if(act_wabao_lib.cfg_tex_game_name[gamepkg.name] == gamepkg.name)then
		item1 = user_info.propslist[9] or 0
	end
	
	--����
    if(act_wabao_lib.cfg_qp_game_name[gamepkg.name] == gamepkg.name)then
    	item1 = user_info.bag_items[8005] or 0
    end
 	 
 	act_wabao_lib.send_item_info(user_info, item1, item2, item3, item4)
 
end

--����������ʱ��״̬
act_wabao_lib.net_send_playnum = function(user_info, check_time, play_count)
  	--TraceError(" ����������ʱ��״̬,userid:"..user_info.userId.." check_time->"..check_time.." play_count:"..play_count)
	netlib.send(function(buf)
	    buf:writeString("HDQRDATE")
	    buf:writeByte(check_time)	 --0�����Ч�������Ҳ�ɲ�������1�����Ч��2,�в���   5�������������һ��
	    buf:writeInt(play_count)	--����������
	    end,user_info.ip,user_info.port) 
end

--����ʹ�ý��/����/ͭ����
function act_wabao_lib.send_use_result(user_info, result, award_id)
	--TraceError("����ʹ�ý��/����/ͭ������userid:"..user_info.userId.." result:"..result.." award_id:"..award_id);
	netlib.send(function(buf)
            buf:writeString("HDQRUSE");
            buf:writeInt(result);
            buf:writeInt(award_id);
        end,user_info.ip,user_info.port);
end

--���͹�����
function act_wabao_lib.send_buy_result(user_info, buy_id, items_value, result)
	--TraceError("���͹�����,USERID:"..user_info.userId.." items_value:"..items_value.." result:"..result.." buy_id:"..buy_id)
	netlib.send(function(buf)
            buf:writeString("HDQRBUY");
            buf:writeInt(result);		--0������ʧ�ܣ���Ҳ��㣻1������ɹ���2������ʧ�ܣ���ѹ��ڣ�3������ʧ�ܣ�����ԭ��
            buf:writeByte(buy_id);
            buf:writeInt(items_value);		--���ϵ�����
        end,user_info.ip,user_info.port);
end

--���Ͳ��Ϻ͵��ߵ���Ϣ
function act_wabao_lib.send_item_info(user_info, item1, item2, item3, item4)
	  --TraceError("���Ͳ��Ϻ͵��ߵ���Ϣ,USERID:"..user_info.userId.." �ر�ͼ����:"..item1.." ͭ����:"..item2.." ��������:"..item3.." ������:"..item4)
	  netlib.send(function(buf)
            buf:writeString("HDQRVALUE");
            buf:writeInt(item1);		--�ر�ͼ����
            buf:writeInt(item2);		--ͭ����
            buf:writeInt(item3);		--��������
            buf:writeInt(item4);		--������ 
        end,user_info.ip,user_info.port);
end

-- �㲥
function act_wabao_lib.ontimer_broad(tips,flag)

    --�����ʾ��Ϊnil ȫ�����㲥��
    if(flag == nil or flag~= 1)then
      tips = _U(tips)
    end
    if (tips ~=  nil and tips ~=  "" ) then 
        tools.SendBufToUserSvr("", "SPBC", "", "", tips)
    end
end

--����  ��ѯ  �ͼ�   ���߹��÷���          item_id:����id    item_num����������           use_type��ʹ�÷�ʽ��0:��ѯ   1����  ����
function act_wabao_lib.chaxun_add_items(user_info, item_id, item_num, use_type)
	--TraceError("����  ��ѯ  �ͼ�   ���߹��÷���,item_id:"..item_id.." item_num->"..item_num)
 
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
     return ret
end

--Э������
cmd_tex_match_handler = 
{ 
    ["HDQRDATE"] = act_wabao_lib.on_recv_activity_stat, --����ʱ��״̬
    ["HDQRPANEL"] = act_wabao_lib.on_recv_activation, -- ����򿪻��� 
    ["HDQRVALUE"] = act_wabao_lib.on_recv_items_info, 	--�������в��ϵ���Ϣ
    ["HDQRUSE"] = act_wabao_lib.on_recv_use, --ʹ�ý��/����/ͭ��
    ["HDQRBUY"] = act_wabao_lib.on_recv_buy,--������  
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", act_wabao_lib.on_after_user_login); 