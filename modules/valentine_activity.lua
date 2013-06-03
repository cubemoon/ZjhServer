TraceError("init valentine_activity...")
if valentine_lib and valentine_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", valentine_lib.on_after_user_login);
end

if valentine_lib and valentine_lib.ontimecheck then
	eventmgr:removeEventListener("timer_minute", valentine_lib.ontimecheck);
end
			
if not valentine_lib then
    valentine_lib = _S
    {
        on_after_user_login = NULL_FUNC,--�û���½���ʼ������
		check_datetime = NULL_FUNC,	--�����Чʱ�䣬��ʱ����
		ongameover = NULL_FUNC,	--��Ϸ�����ɼ�����
		net_send_playnum = NULL_FUNC,	--����������ʱ��״̬
		ontimecheck = NULL_FUNC,	--��ʱˢ���¼�
		on_recv_use = NULL_FUNC,	--ʹ�ú�õ��/�ɿ���/�����ɿ���
		send_use_result = NULL_FUNC,--����ʹ�ý��
		init_charm_ph = NULL_FUNC,	--��ʼ�����а�
		on_recv_ph_list = NULL_FUNC,	--�������а�
		get_my_pm = NULL_FUNC,	--���Լ������а�
		send_ph_list = NULL_FUNC,	--�������а�
		on_recv_activity_stat = NULL_FUNC,	--����ʱ��״̬
		on_recv_activation = NULL_FUNC,	--����򿪻���
 		on_recv_buy = NULL_FUNC,	--������
		send_buy_result = NULL_FUNC,	--���͹�����
		on_recv_items_info = NULL_FUNC,	--�������в��ϵ���Ϣ
		send_item_info = NULL_FUNC,	--���Ͳ��Ϻ͵��ߵ���Ϣ
		on_recv_packs = NULL_FUNC,	--֪ͨ����ˣ�������ȡ�����������
 		send_exorcist_packs_result = NULL_FUNC,	--����������ȡ����ħ��������
		query_db = NULL_FUNC,		--��ѯ������Լ�����
		_tosqlstr = NULL_FUNC,		--�����Ĵ���
		on_recv_composite = NULL_FUNC,	--����ϳɣ�1�������ɿ�����2�������� 6���ɿ�����10����õ�壻
		net_send_composite_result = NULL_FUNC,	--���ͺϳɽ��
		send_random_item = NULL_FUNC,		--���ͷ���ÿ��5��������1�ֺϳɲ���
 
        refresh_invate_time = -1,  --��һ��ˢ��ʱ��
    
        charm_ph_list = {}; --��������
 
        activ1_statime = "2012-02-9 09:00:00",  --���ʼʱ��
    	activ1_endtime = "2012-02-20 00:00:00",  --�����ʱ��
    	rank_endtime = "2012-02-21 00:00:00",	--���а����ʱ��
    }    
end
  
--�û���½���ʼ������
valentine_lib.on_after_user_login = function(e)
	local user_info = e.data.userinfo
	--TraceError("�û���½���ʼ������,userid:"..user_info.userId)
	if(user_info == nil)then 
		--TraceError("�û���½���ʼ������,if(user_info == nil)then")
	 	return
	end
	
	local check_result = valentine_lib.check_datetime()	--���ʱ��
	if(check_result == 0 or check_result == 5)then
		--TraceError("�û���½���ʼ������,�ʱ��ʧЧif(check_result == 0 and check_result == 5)then")
		return
	end
	 
    --��ʼ���û�����
    if(user_info.valentine_play_count == nil)then
    	user_info.valentine_play_count = 0
    end
    
    --��ʼ�����¼ʱ��
    if(user_info.valentine_today == nil)then
    	local sys_today = os.date("%Y-%m-%d", os.time());  
    	user_info.valentine_today = sys_today
    end
     
    --��ʼ���û�����ֵ
    if(user_info.valentine_charm_value == nil)then
    	user_info.valentine_charm_value = 0
    end
  
 	--��ʼ���û��ɿɶ�����
    if(user_info.valentine_cocoa_value == nil)then
    	user_info.valentine_cocoa_value = 0
    end
    
    --��ʼ���û�ţ������
    if(user_info.valentine_milk_value == nil)then
    	user_info.valentine_milk_value = 0
    end
    
    --��ʼ���û���������
    if(user_info.valentine_nuts_value == nil)then
    	user_info.valentine_nuts_value = 0
    end
    
    --��ʼ���û��ɿ�������
    if(user_info.valentine_chocolate_value == nil)then
    	user_info.valentine_chocolate_value = 0
    end
    
    --��ʼ���û�õ�廨��������
    if(user_info.valentine_seeds_value == nil)then
    	user_info.valentine_seeds_value = 0
    end
    
    --��ʼ���û���������
    if(user_info.valentine_soil_value == nil)then
    	user_info.valentine_soil_value = 0
    end
    
    --��ʼ���û���������
    if(user_info.valentine_nourishment_value == nil)then
    	user_info.valentine_nourishment_value = 0
    end
    
    --��ʼ���û���õ������
    if(user_info.valentine_rose_value == nil)then
    	user_info.valentine_rose_value = 0
    end
 
    --��ʼ���û����������ȡ���
    if(user_info.valentine_libao_sign == nil)then
    	user_info.valentine_libao_sign = 0
    end
	
	--��ѯ������Լ�����
	valentine_lib.query_db(user_info)
    
end

--�����Ĵ���
valentine_lib._tosqlstr = function(s) 
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

--��ѯ������Լ�����
function valentine_lib.query_db(user_info)
 
	local user_nick = user_info.nick
	user_nick = valentine_lib._tosqlstr(user_nick).."   "
	
	--��ѯ��������ݿ�
	local sql = "insert ignore into t_valentine_activity (user_id, user_nick, sys_time) values(%d, '%s', now());commit;";
    sql = string.format(sql, user_info.userId, user_nick);
	dblib.execute(sql)
	
	local sql_1 = "select sys_time,charm_value,libao_sign,play_count,cocoa_value,milk_value,nuts_value,chocolate_value,seeds_value,soil_value,nourishment_value,rose_value from t_valentine_activity where user_id = %d"
	sql_1 = string.format(sql_1, user_info.userId);
 
	dblib.execute(sql_1,
    function(dt)
    	if dt and #dt > 0 then

    		local sys_today = os.date("%Y-%m-%d", os.time()); --ϵͳ�Ľ���
            local db_date = os.date("%Y-%m-%d", timelib.db_to_lua_time(dt[1]["sys_time"]));  --���ݿ�Ľ���
            user_info.valentine_charm_value = dt[1]["charm_value"] or 0
            user_info.valentine_libao_sign = dt[1]["libao_sign"] or 0
 			
 			--�ϳɲ���
            user_info.valentine_cocoa_value = dt[1]["cocoa_value"] or 0
            user_info.valentine_milk_value = dt[1]["milk_value"] or 0
            user_info.valentine_nuts_value = dt[1]["nuts_value"] or 0
            user_info.valentine_chocolate_value = dt[1]["chocolate_value"] or 0
            user_info.valentine_seeds_value = dt[1]["seeds_value"] or 0
            user_info.valentine_soil_value = dt[1]["soil_value"] or 0
            user_info.valentine_nourishment_value = dt[1]["nourishment_value"] or 0
            user_info.valentine_rose_value = dt[1]["rose_value"] or 0
            
            if (db_date ~= sys_today) then
				user_info.valentine_play_count = 0
            else
            	user_info.valentine_play_count = dt[1]["play_count"] or 0
            
            end
  
    	else
			--TraceError("�û���½���ʼ������,��ѯ��������ݿ�->ʧ��")
    	end
    
    end)
end
 	
--�����Чʱ�䣬��ʱ����
function valentine_lib.check_datetime()
	local sys_time = os.time();
	
	--�ʱ��
	local statime = timelib.db_to_lua_time(valentine_lib.activ1_statime);
	local endtime = timelib.db_to_lua_time(valentine_lib.activ1_endtime);
	local rank_endtime = timelib.db_to_lua_time(valentine_lib.rank_endtime);
	if(sys_time > statime and sys_time <= endtime) then
	    return 1;
	end
	
	if(sys_time > endtime and sys_time <= rank_endtime) then
		return 5; --��������������а�ͼ�걣��1�����ʧ��
	end
	
	--�ʱ���ȥ��
	return 0;
end


--��Ϸ�����ɼ�����
valentine_lib.ongameover = function(user_info,addgold)
--[[
�������̣�

��ʾÿ�ս��ȣ���ʽΪ0/50��������ʾΪ50/50

ÿ��ÿ�������Ի��10�Σ�������50�ֿɻ��10��

ÿ��5��������1�ֺϳɲ���

VIP���ÿ�οɻ��˫�����ϣ��磺����*2

 
]]
 	--TraceError(" ��Ϸ�����ɼ�����,userId:"..user_info.userId)
	if not user_info or not user_info.desk then return end;
	 
	--�һ��ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError(" ��Ϸ�����ɼ�����->ʱ����Ч��,ʧЧ->if(check_time == 0 and check_time == 5)-- userid:"..user_info.userId)
        return;
    end
  
    --�ж��û��ܿ�����
    if(user_info.valentine_play_count >= 50 )then 
 
    	--���촦��
    	local sys_today = os.date("%Y-%m-%d", os.time()); --ϵͳ�Ľ���
    	local act_date = user_info.valentine_today  --�û���¼����
    	if (act_date ~= sys_today) then
    		--TraceError(" ��Ϸ�����ɼ�����,> 50  ���촦�� userid:"..user_info.userId)
    		user_info.valentine_play_count = 0
    		
    		user_info.valentine_today = sys_today 
    	end
    	
		--TraceError(" ��Ϸ�����ɼ�����,> 50  userid:"..user_info.userId)
		return;    
    end    
 
 	--�ۼӾ���
    local play_count = user_info.valentine_play_count or 0
    play_count = play_count + 1;
	user_info.valentine_play_count = play_count
  
    --֪ͨ�ͻ���
    valentine_lib.net_send_playnum(user_info, check_time, play_count);
   
    local love_chocolate_value = 0	--�����ɿ���
	local flowers_value = 0	--����
	
	local material_id = 0			--�������id
	local material_value = 0		--�����ò�������
 
 	if(play_count % 5 == 0)then		--�ܱ�5����Ϊ1��
 		--ÿ��5��������1�ֺϳɲ���
 		local sql = format("call sp_get_random_spring_gift(%d, '%s', %d)", user_info.userId, "tex", 4)
        	dblib.execute(sql, function(dt)
        		material_id = dt[1]["gift_id"]	or 1	--�ϳɲ���id
        		
        		--TraceError("��Ϸ�����ɼ�����,ÿ��5��������1�ֺϳɲ��ϣ�������ɽ�ƷID:"..material_id.." USERID:"..user_info.userId)
                if(material_id <= 0) then
                	--TraceError("��Ϸ�����ɼ�����,ÿ��5��������1�ֺϳɲ���,ʧ��")
                    return 
                end 
                
                --���ϳɲ��ϼӵ��û�userinfo��
                if(material_id == 1)then		--�ɿɶ�
                	
                	user_info.valentine_cocoa_value = user_info.valentine_cocoa_value + 1
            		material_value = 1
            		
            		--���ͷ���ÿ��5��������1�ֺϳɲ���
					valentine_lib.send_random_item(user_info, 3)
					
                elseif(material_id == 2)then		--ţ��
                
                	user_info.valentine_milk_value = user_info.valentine_milk_value + 1
            		material_value = 1
            		
            		--���ͷ���ÿ��5��������1�ֺϳɲ���
					valentine_lib.send_random_item(user_info, 4)
						
                elseif(material_id == 3)then		--����
                
                	user_info.valentine_nuts_value = user_info.valentine_nuts_value + 1
            		material_value = 1
            		
            		--���ͷ���ÿ��5��������1�ֺϳɲ���
					valentine_lib.send_random_item(user_info, 5)
						
                elseif(material_id == 4)then		--õ�廨����
                
                	user_info.valentine_seeds_value = user_info.valentine_seeds_value + 1
            		material_value = 1
            		
            		--���ͷ���ÿ��5��������1�ֺϳɲ���
					valentine_lib.send_random_item(user_info, 7)
					
                elseif(material_id == 5)then		--����
                
                	user_info.valentine_soil_value = user_info.valentine_soil_value + 1
            		material_value = 1
            		
            		--���ͷ���ÿ��5��������1�ֺϳɲ���
					valentine_lib.send_random_item(user_info, 8)
					
                elseif(material_id == 6)then		--����
                	
            		user_info.valentine_nourishment_value = user_info.valentine_nourishment_value + 1
            		material_value = 1
            		
            		--���ͷ���ÿ��5��������1�ֺϳɲ���
					valentine_lib.send_random_item(user_info, 9)
            	
                end
                
                local item1 = user_info.propslist[8] or 0
 				local item2 = user_info.propslist[9] or 0
			 	local item3 = user_info.valentine_cocoa_value
			 	local item4 = user_info.valentine_milk_value
			 	local item5 = user_info.valentine_nuts_value
			 	local item6 = user_info.valentine_chocolate_value
			 	local item7 = user_info.valentine_seeds_value
			 	local item8 = user_info.valentine_soil_value
			 	local item9 = user_info.valentine_nourishment_value
			 	local item10 = user_info.valentine_rose_value
			
				--��¼�����ݿ�
			    local sqltemplet = "update t_valentine_activity set play_count = %d, cocoa_value = %d, milk_value = %d, nuts_value = %d, seeds_value = %d, soil_value = %d, nourishment_value = %d, sys_time = now() where user_id = %d;commit;";
			    local sql=string.format(sqltemplet, play_count, item3, item4, item5, item7, item8, item9, user_info.userId);
			    dblib.execute(sql);
			    
        	end)
  
 	end
 	
 	--��¼���������ݿ�
    local sqltemplet = "update t_valentine_activity set play_count = %d, sys_time = now() where user_id = %d;commit;";
    local sql=string.format(sqltemplet, play_count, user_info.userId);
    dblib.execute(sql);
 
end

--��ʱˢ���¼�
valentine_lib.ontimecheck = function()
 
  	--�һ��ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
        return;
    end
  
  	--10����Ҫˢһ������ ��  ������������
	if(valentine_lib.refresh_invate_time == -1 or os.time() > valentine_lib.refresh_invate_time+60*10)then
	--if(valentine_lib.refresh_invate_time == -1 or os.time() > valentine_lib.refresh_invate_time+10*1)then
		----TraceError("��ʱˢ���¼���10����Ҫˢһ������ ");
    	valentine_lib.refresh_invate_time = os.time();
    	valentine_lib.init_charm_ph();
 
    end
   
end
 
--ʹ�ú�õ��/�ɿ���/�����ɿ���
function valentine_lib.on_recv_use(buf)
--[[
�������̣�

1�������õ��/�ɿ���/�����ɿ�����ý�Ʒ��ʣ������-1

2����ʾʹ�õĶ���

3�������ö�Ӧ����������������ʾ���ȡһ����̫�����ˣ����600��ң���/�����������1���ң���/�����������1���ң���,3����ʧ

5�����10����/1��������ϵĽ���ϵͳ�㲥����XXXX��{ʲô��/�ɿ���}�����10���ҽ�������

��������

1������Ϊ0ʱ�򣬵������������ʾ ���������㣡�� ,3����ʧ



�����Ʒ�� 
1. 200����
2. 2K����
3. 2�����
4. С����
5. �����ġ�����
6. 1K����
7. 1�����
8. 10�����
9. T�˿�
10.���촽������
11.5K����
12.20�����
13.138����ɯ����
14.588������

]]	
 
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ���,USERID:"..user_info.userId)
   
   	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ���,ʱ����ڣ� USERID:"..user_info.userId)
    	valentine_lib.send_use_result(user_info, -1, -1)
        return;
    end
     
    --�յ���ʹ��id
    local item_id = buf:readByte();
    
    --ת���յ�id
    local change_id = 0
    if(item_id == 1)then	--1�������ɿ���
    	change_id = 3
    	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ��� �յ���ʹ��id:"..item_id.." ת���յ�id:"..change_id)
    elseif(item_id == 6)then	--6���ɿ���
    	change_id = 1
    	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ��� �յ���ʹ��id:"..item_id.." ת���յ�id:"..change_id)
    elseif(item_id == 10)then	--10����õ��
    	change_id = 2
    	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ��� �յ���ʹ��id:"..item_id.." ת���յ�id:"..change_id)
    end
    
    --10����õ�壻6���ɿ�����1�������ɿ���
	local love_chocolate_value = user_info.propslist[8] or 0	--�����ɿ���
	--local flowers_value = user_info.propslist[9] or 0	--����
	local chocolate_value = user_info.valentine_chocolate_value or 0	--�ɿ���
	local rose_value = user_info.valentine_rose_value or 0	--��õ��
  
  	local result = 0
  	local award_id = 0  --�����ƷID
  	
  
    --ʹ���ɿ�������ֵ��+1
	--ʹ�ð����ɿ�������ֵ��+10
	--ʹ�ú�õ������ֵ��+3
	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ���֮ǰ   ����ֵ��"..user_info.valentine_charm_value.."  USERID:"..user_info.userId)
	local charm_value = 0	--����ֵ
	
	--������ɽ�ƷID
	local function spring_gift(user_info, change_id)
		 
        	local sql = format("call sp_get_random_spring_gift(%d, '%s', %d)", user_info.userId, "tex", change_id)
        	dblib.execute(sql, function(dt)
            	if(dt and #dt > 0)then
            		local prizeid = dt[1]["gift_id"]
	                
	                --TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ���,������������ɽ�ƷID:"..prizeid.." USERID:"..user_info.userId)
	                if(prizeid <= 0) then
	                	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ���,������������ɽ�ƷID,ʧ��")
	                    return 
	                end 
 	 
 					--����
		 			if(change_id == 1)then	--�ɿ���
			   			--ת����Ӧ��ƷID
			            if(prizeid == 1)then	--200����
			            	award_id = 1	
			            	--��200����
			  				usermgr.addgold(user_info.userId, 200, 0, g_GoldType.baoxiang, -1);
			  				
			            elseif(prizeid == 2)then	--2K����
			            	award_id = 2	
			            	--��1K����
			  				usermgr.addgold(user_info.userId, 2000, 0, g_GoldType.baoxiang, -1);
			  				
			            elseif(prizeid == 3)then	--2�����
			            	award_id = 3	
			            	--2�����
			  				usermgr.addgold(user_info.userId, 20000, 0, g_GoldType.baoxiang, -1);
			  	
			            elseif(prizeid == 4)then	--С����
			            	award_id = 4	
			            	--С������ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info)
			  	
			            elseif(prizeid == 5)then	--�����ġ�����
			            	award_id = 5	
			            	--�ӡ����ġ�����
			  				gift_addgiftitem(user_info,9016,user_info.userId,user_info.nick, false)
			  				
			         	elseif(prizeid == 0)then	--�쳣
			  				--TraceError("ʹ���ɿ��� ,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
			  				return
			            end	
			        elseif(change_id == 2)then	--��õ��
			        	--ת����Ӧ��ƷID
			            if(prizeid == 1)then	--1K����
			            	award_id = 6	
			            	--��1K����
			  				usermgr.addgold(user_info.userId, 1000, 0, g_GoldType.baoxiang, -1);
			  				
			            elseif(prizeid == 2)then	--1W����
			            	award_id = 7	
			            	--��1W����
			  				usermgr.addgold(user_info.userId, 10000, 0, g_GoldType.baoxiang, -1);
			  				 
			            elseif(prizeid == 3)then	--10�����
			            	award_id = 8	
			            	--��10�����
			  				usermgr.addgold(user_info.userId, 100000, 0, g_GoldType.baoxiang, -1);
			  				
			  				--ϵͳ�㲥����XXXXʹ��{ʲô��/�ɿ���}�����XXX��������
			  				local user_nick = user_info.nick
							user_nick = valentine_lib._tosqlstr(user_nick).."   "
			  				local msg = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "valentine_activity_msg_awards"); 
							msg1 = string.format(msg1,5); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			  	
			            elseif(prizeid == 4)then	--T�˿�
			            	award_id = 9
			            	--T�˿���ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info)
			  	
			            elseif(prizeid == 5)then	--���촽������
			            	award_id = 10
			            	--�ӡ��촽������
			  				gift_addgiftitem(user_info,9017,user_info.userId,user_info.nick, false)
			  		 
			  			elseif(prizeid == 0)then	--�쳣
			  				--TraceError("ʹ�� ��õ�� ,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
			  				return
			            end	
			   		elseif(change_id == 3)then		--�����ɿ���
			   			--ת����Ӧ��ƷID
			            if(prizeid == 1)then	--T�˿�*2
			            	award_id = 15  --T�˿�*2	
			            	--��T�˿�*2
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 2, user_info)
			          
			            elseif(prizeid == 2)then	--С����*2
			            	award_id = 16	
			            	--С����*2
			  				--С������ô��
			  				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 2, user_info)
			  				  
			            elseif(prizeid == 3)then	--1�����
			            	award_id = 7	
			            	--��1�����
			  				usermgr.addgold(user_info.userId, 10000, 0, g_GoldType.baoxiang, -1);
			  				 
			  			elseif(prizeid == 4)then	--2�����
			            	award_id = 3	
			            	--��2�����
			  				usermgr.addgold(user_info.userId, 20000, 0, g_GoldType.baoxiang, -1);
			  				 
			  			elseif(prizeid == 5)then	--20�����
			            	award_id = 12	
			            	--20�����
							usermgr.addgold(user_info.userId, 200000, 0, g_GoldType.baoxiang, -1);
							
							--ϵͳ�㲥����XXXXʹ��{ʲô��/�ɿ���}�����XXX��������
			  				local user_nick = user_info.nick
							user_nick = valentine_lib._tosqlstr(user_nick).."   "
			  				local msg = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_2"); 
							msg1 = string.format(msg1,5); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
							
						elseif(prizeid == 6)then	--138����ɯ����
			            	award_id = 13	--138����ɯ����
			            	--138����ɯ����
			  				gift_addgiftitem(user_info,5021,user_info.userId,user_info.nick, false)	
			  				
			  				--ϵͳ�㲥����XXXXʹ��{ʲô��/�ɿ���}�����XXX��������
			  				local user_nick = user_info.nick
							user_nick = valentine_lib._tosqlstr(user_nick).."   "
			  				local msg = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_3"); 
							msg1 = string.format(msg1,5); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			 
			            elseif(prizeid == 7)then	--588������
			            	award_id = 14		--588������
			            	--588������
			  				gift_addgiftitem(user_info,5024,user_info.userId,user_info.nick, false)	
			  				
			  				--ϵͳ�㲥����XXXXʹ��{ʲô��/�ɿ���}�����XXX��������
			  				local user_nick = user_info.nick
							user_nick = valentine_lib._tosqlstr(user_nick).."   "
			  				local msg = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_1"); 
							local msg1 = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_4"); 
							msg1 = string.format(msg1,5); 
							BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
			  	 
			  			elseif(prizeid == 0)then	--�쳣
			  				--TraceError("ʹ�� �����ɿ���,������������ɽ�ƷID,ʧ��--�쳣 USERID:"..user_info.userId)
			  				return
			            end	
				    end
				   
				   --����ʹ�ú�õ��/�ɿ���/�����ɿ����ɹ����
			    	result = charm_value
			    	--TraceError("ʹ�ú�õ��/�ɿ���/�����ɿ���֮��,--�� USERID:"..user_info.userId.." result:"..result.." award_id:"..award_id)
					valentine_lib.send_use_result(user_info, result, award_id)
					
					--���Ͳ��Ϻ͵��ߵ���Ϣ
				 	local item1 = user_info.propslist[8] or 0
 					local item2 = user_info.propslist[9] or 0
				 	local item3 = user_info.valentine_cocoa_value
				 	local item4 = user_info.valentine_milk_value
				 	local item5 = user_info.valentine_nuts_value
				 	local item6 = user_info.valentine_chocolate_value
				 	local item7 = user_info.valentine_seeds_value
				 	local item8 = user_info.valentine_soil_value
				 	local item9 = user_info.valentine_nourishment_value
				 	local item10 = user_info.valentine_rose_value
				 	valentine_lib.send_item_info(user_info, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10)
	            end
	        end)
	   
	end
  	
   	if(change_id == 1)then	--�ɿ���
   		
   		if(chocolate_value  > 0)then
   			charm_value = 1	--ʹ���ɿ�������ֵ��+1
    	
   			--�����û�����ֵ
   			user_info.valentine_charm_value = user_info.valentine_charm_value + charm_value
 
   			--���ɿ���
   			chocolate_value = chocolate_value - 1
   			user_info.valentine_chocolate_value = chocolate_value
   			 
  			--������ɽ�ƷID
			spring_gift(user_info, change_id)
    	 
   		else
   			--TraceError("ʹ���ɿ���,--�ɿ������㣬 USERID:"..user_info.userId)
   			--����ʹ���ɿ���ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			valentine_lib.send_use_result(user_info, result, award_id)
	        return;
   		end
       
    elseif(change_id == 2)then	--��õ��
    
    	if(rose_value > 0)then
   			charm_value = 3	--ʹ�ú�õ������ֵ��+3
   		 
   			--�����û�����ֵ
   			user_info.valentine_charm_value = user_info.valentine_charm_value + charm_value
 
   			--����õ��
   			rose_value = rose_value - 1
   			user_info.valentine_rose_value = rose_value
   			 
  	 		--������ɽ�ƷID
			spring_gift(user_info, change_id)
     
   		else
   			--TraceError("ʹ�ú�õ��,--��õ�岻�㣬 USERID:"..user_info.userId)
   			--����ʹ�ú�õ��ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			valentine_lib.send_use_result(user_info, result, award_id)
	        return;
   		end
    elseif(change_id == 3)then	--�����ɿ���
    	if(love_chocolate_value  > 0)then
   			charm_value = 10	--ʹ�ð����ɿ�������ֵ��+10
   		 
   			--�����û�����ֵ
   			user_info.valentine_charm_value = user_info.valentine_charm_value + charm_value
 
   			--�������ɿ���
   			love_chocolate_value = love_chocolate_value - 1
   			user_info.propslist[8] = love_chocolate_value
   			
   			local complete_callback_func = function(tools_count)
      	 		--������ɽ�ƷID
   				spring_gift(user_info, change_id)
	 
    		end
   		 	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.love_chocolate_id, -1, user_info, complete_callback_func)
   		else
   			--TraceError("ʹ�ð����ɿ���,--�����ɿ������㣬 USERID:"..user_info.userId)
   			--����ʹ�ð����ɿ���ʧ�ܽ��
	    	result = 0
	    	award_id = -1
			valentine_lib.send_use_result(user_info, result, award_id)
	        return;
   		end
    else
    	
    	--TraceError("ʹ�ð����ɿ��� ��õ�� �ɿ������յ�����Ĺ���id");
    	--���͹������޽��
    	result = 0
    	award_id = -1
		valentine_lib.send_use_result(user_info, result, award_id)
        return;
   	end
   	
   	--TraceError("ʹ�ð����ɿ��� ��õ�� �ɿ���֮��  �û�����ֵ��"..user_info.valentine_charm_value.."  USERID:"..user_info.userId)
   
   --�������а�
	--���Լ������а�
	local charm_paimin_list = valentine_lib.charm_ph_list	--���а�����
	local my_mc = -1;
	local my_attack_value = 0;
	my_mc,my_attack_value = valentine_lib.get_my_pm(charm_paimin_list,user_info)
	if(user_info.valentine_charm_value ~= nil)then
		my_attack_value = user_info.valentine_charm_value
	end
	
	local libao_sign = user_info.valentine_libao_sign		----�Ƿ���ȡ�ˡ�������������
	valentine_lib.send_ph_list(user_info, libao_sign, my_attack_value, my_mc, charm_paimin_list)

	--���� ���ݿ�
    local sqltemplet = "update t_valentine_activity set user_nick = '%s', charm_value = %d, love_chocolate_value = %d, chocolate_value = %d, rose_value = %d where user_id = %d;commit;";
    local tmp_user_nick = valentine_lib._tosqlstr(user_info.nick)
    local sql=string.format(sqltemplet, tmp_user_nick, user_info.valentine_charm_value, love_chocolate_value, chocolate_value, rose_value, user_info.userId);
    dblib.execute(sql);
 
end

--��ʼ�����а�
function valentine_lib.init_charm_ph()
--[[
�鿴��������

�������̣�

1����ʾǰ20����ҵ���������

2��������ǩΪ �������ǳƣ�֧�����16�ַ�����������֧��6λ���֣������������10���ַ���

4���������·���ʾ�Լ��˺�ֵ

��������

1������=���������*1+�򿪻ƽ����*10+���������*3+ʹ�û���*15

2��ͬ������ʱ���Ⱥ���

3��ǰ20�������ڻ�������˹�����

4������10���Ӹ���1��


]]
 
	--TraceError("-->>>>��ʼ�����а�")
	valentine_lib.charm_ph_list = {}; --��������
 
	--��ʼ������
	local init_ph=function(ph_list)
		local sql="select user_id,user_nick,charm_value from t_valentine_activity where charm_value >= 1 order by charm_value desc LIMIT 20"
		sql=string.format(sql)
		dblib.execute(sql,function(dt)	
				if(dt~=nil and  #dt>0)then
					for i=1,#dt do
						local bufftable ={
						  	    mingci = i, 
			                    user_id = dt[i].user_id,
			                    nick_name = dt[i].user_nick,
			                    charm_value = dt[i].charm_value,   
		                }	                
						table.insert(ph_list,bufftable)
					end
				end
	    end)
    end
    
    --��ʼ����������
    init_ph(valentine_lib.charm_ph_list)
 
end

--�������а�
function valentine_lib.on_recv_ph_list(buf)
	local user_info = userlist[getuserid(buf)]; 
	if not user_info then return end;
	--TraceError("--�������а�,userid:"..user_info.userId)
 
   	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0) then
    	--TraceError("�������а�,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
 
	local charm_paimin_list = valentine_lib.charm_ph_list
	
	if(user_info == nil)then return end
	
	--��ѯ�Լ������Σ����û�����ξͷ���-1
	--�������Σ��ҵĹ����ɼ�
	local my_mc = -1;
	local my_charm_value = 0;
 
	--���Լ������а�
	my_mc,my_charm_value = valentine_lib.get_my_pm(charm_paimin_list,user_info)
	
	local libao_sign = user_info.valentine_libao_sign		----�Ƿ���ȡ�ˡ���ħ��������
 
 	--�������а�
	valentine_lib.send_ph_list(user_info, libao_sign, my_attack_value, my_mc, charm_paimin_list)  
end

--���Լ������а�
valentine_lib.get_my_pm = function(ph_list,user_info)

		local mc = -1
		if (ph_list == nil) then return -1,0 end
		
		for i = 1, #ph_list do
			if(ph_list[i].user_id == user_info.userId)then
				return i, ph_list[i].charm_value
			end
		end

		return -1,0;--û���ҵ���Ӧ��ҵļ�¼����Ϊ��û�гɼ�
end

--����ʱ��״̬
function valentine_lib.on_recv_activity_stat(buf)
	
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
 
	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
	
	--TraceError("--����ʱ��״̬-->>"..check_time)
	
	if(check_time == 0)then
		return
	end
	
	--�ж��Ƿ��в���
	local item1 = user_info.propslist[8] or 0
 	local item2 = user_info.propslist[9] or 0
 	local item3 = user_info.valentine_cocoa_value
 	local item4 = user_info.valentine_milk_value
 	local item5 = user_info.valentine_nuts_value
 	local item6 = user_info.valentine_chocolate_value
 	local item7 = user_info.valentine_seeds_value
 	local item8 = user_info.valentine_soil_value
 	local item9 = user_info.valentine_nourishment_value
 	local item10 = user_info.valentine_rose_value
	if(item1 > 0 or item2 > 0 or item3 > 0 or item4 > 0 or item5 > 0 or item6 > 0 or item7 > 0 or item8 > 0 or item9 > 0 or item10 > 0)then
		check_time = 2;		--���Ч,�в���
	end
	 
	--�û�����
	local play_count = 0
    if(user_info.valentine_play_count == nil)then
    	user_info.valentine_play_count = 0	
    	play_count = 0
    else
    	play_count = user_info.valentine_play_count
    end
  
 	--֪ͨ�ͻ���
    valentine_lib.net_send_playnum(user_info, check_time, play_count);
end

--����򿪻���
function valentine_lib.on_recv_activation(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
 
   	--TraceError("����򿪻���,USERID:"..user_info.userId)
   
   	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("����򿪻���,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
    
    --��ʼ����������˽ڱ�
	local user_nick = user_info.nick
	user_nick = valentine_lib._tosqlstr(user_nick)
	local sql = "insert ignore into t_valentine_activity (user_id, user_nick, charm_value) ";
    sql = sql.."values(%d, '%s   ', %d);commit;";   
    sql = string.format(sql, user_info.userId, user_nick, 0);
	dblib.execute(sql)
	 
	
	--��ѯ������Լ�����
	valentine_lib.query_db(user_info)
	
	--���Ͳ��Ϻ͵��ߵ���Ϣ
 	local item1 = user_info.propslist[8] or 0
 	local item2 = user_info.propslist[9] or 0
 	local item3 = user_info.valentine_cocoa_value
 	local item4 = user_info.valentine_milk_value
 	local item5 = user_info.valentine_nuts_value
 	local item6 = user_info.valentine_chocolate_value
 	local item7 = user_info.valentine_seeds_value
 	local item8 = user_info.valentine_soil_value
 	local item9 = user_info.valentine_nourishment_value
 	local item10 = user_info.valentine_rose_value
 	valentine_lib.send_item_info(user_info, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10)
	
	--�������а�
	--���Լ������а�
	local charm_paimin_list = valentine_lib.charm_ph_list	--���а�����
	local my_mc = -1;
	local my_attack_value = 0;
	my_mc,my_attack_value = valentine_lib.get_my_pm(charm_paimin_list,user_info)
	if(user_info.valentine_charm_value ~= nil)then
		my_attack_value = user_info.valentine_charm_value
	end
	
	local libao_sign = user_info.valentine_libao_sign		----�Ƿ���ȡ�ˡ�������������
	valentine_lib.send_ph_list(user_info, libao_sign, my_attack_value, my_mc, charm_paimin_list)
	
end

--������
function valentine_lib.on_recv_buy(buf)
--[[
�������˹��򡿣������������/��ң������Ӧ����

    ����ɹ������ֶ�����ʾ������ɹ�����
 
    Ǯ��������ť��ɫ����
 
    ����ʹ��������ĳ��빺��
 �������ͣ�1���ɿ�����2��õ�廨�� 
  ]]
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   
   	--�յ�����id
    local buy_type_id = buf:readByte();
    	
   	--TraceError("������,USERID:"..user_info.userId.." �յ�����id:"..buy_type_id)
   	
   	--ת��buy_id
   	local buy_id = 0
   	if(buy_type_id == 1)then	--1�������ɿ���
   		buy_id = 3
   	else
   		--TraceError("������  �յ�����id")
   		return
   	end
   	--[[
   	if(buy_type_id == 6)then	--1���ɿ���
   		buy_id = 1
   	elseif(buy_type_id == 10)then		--2��õ�廨
   		buy_id = 2
   	else
   		--TraceError("������  �յ�����id")
   		return
   	end
   	]]
   	
   	--local chocolate_value = 0		--�ɿ���
   	--local rose_value = 0			--��õ��
 	local result = 0
    local gold = get_canuse_gold(user_info)		--����û�����

	--chocolate_value = user_info.valentine_chocolate_value	--�ɿ���
	--rose_value = user_info.valentine_rose_value	--��õ��
	local love_chocolate_value = user_info.propslist[8] or 0	--�����ɿ���
	
   	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("������,ʱ����ڣ� USERID:"..user_info.userId)
    	
    	--���͹�����
    	result = 2
    	if(buy_id == 3)then		--�����ɿ���
    		valentine_lib.send_buy_result(user_info, buy_id, love_chocolate_value, result)
        	return;
        end
    	--[[
    	if(buy_id == 1)then		--�ɿ���
    		valentine_lib.send_buy_result(user_info, buy_id, chocolate_value, result)
        	return;
    	elseif(buy_id == 2)then		--��õ��
    		valentine_lib.send_buy_result(user_info, buy_id, rose_value, result)
        	return;
    	end
		]]
		
    end
 
 	--�ж��Ƿ���Ǯ
 	if(buy_id == 1)then		--�ɿ���
		if(gold < 10000)then
	    	--TraceError("�����ɿ���,Ǯ������ USERID:"..user_info.userId)
	    	
	    	--���͹�����
	    	result = 0
			valentine_lib.send_buy_result(user_info, buy_id, chocolate_value, result)
	    	return
	    else
	    	--���Թ���
	    	--������
			usermgr.addgold(user_info.userId, -10000, 0, g_GoldType.baoxiang, -1);
			
			--���ɿ���
			chocolate_value = chocolate_value + 1
			user_info.valentine_chocolate_value = chocolate_value
			
			--���͹���ɹ�
			result = 1
		  	valentine_lib.send_buy_result(user_info, buy_id, chocolate_value, result)
    	end
	elseif(buy_id == 2)then		--��õ��
		if(gold < 30000)then
	    	--TraceError("�����õ��,Ǯ������ USERID:"..user_info.userId)
	    	
	    	--���͹�����
	    	result = 0
			valentine_lib.send_buy_result(user_info, buy_id, rose_value, result)
	    	return
	    else
	    	--���Թ���
	    	--������
			usermgr.addgold(user_info.userId, -30000, 0, g_GoldType.baoxiang, -1);
			
			--�Ӻ�õ��
			rose_value = rose_value + 1
			user_info.valentine_rose_value = rose_value
			
			--���͹���ɹ�
			result = 1
		  	valentine_lib.send_buy_result(user_info, buy_id, rose_value, result)
    	end
    elseif(buy_id == 3)then		--�����ɿ���
    	if(gold < 100000)then
    		--TraceError("�������ɿ���,Ǯ������ USERID:"..user_info.userId)
	    	
	    	--���͹�����
	    	result = 0
			valentine_lib.send_buy_result(user_info, buy_id, love_chocolate_value, result)
	    	return
	    else
	    	--���Թ���
	    	--������
			usermgr.addgold(user_info.userId, -100000, 0, g_GoldType.baoxiang, -1);
 
			--�Ӱ����ɿ���
			love_chocolate_value = love_chocolate_value + 1
			
    		user_info.propslist[8] = love_chocolate_value
    		
   			local complete_callback_func = function(tools_count)
   				result = 1
      	 		--���͹���ɹ�
				valentine_lib.send_buy_result(user_info, 1, love_chocolate_value, result)
    		end
   		 	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.love_chocolate_id, 1, user_info, complete_callback_func)
    	
    	end
	end
    
    --[[
    --���� ���ݿ�
    local sqltemplet = "update t_valentine_activity set charm_value = %d, chocolate_value = %d, rose_value = %d where user_id = %d;commit;";
    local sql=string.format(sqltemplet, user_info.valentine_charm_value, chocolate_value, rose_value, user_info.userId);
    dblib.execute(sql);
    ]]
    
    --���� ���ݿ�
    local sqltemplet = "update t_valentine_activity set love_chocolate_value = %d where user_id = %d;commit;";
    local sql=string.format(sqltemplet, love_chocolate_value, user_info.userId);
    dblib.execute(sql);
    
end

--�������в��ϵ���Ϣ
function valentine_lib.on_recv_items_info(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("�������в��ϵ���Ϣ,USERID:"..user_info.userId)
   
   	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("�����������в��ϵ���Ϣ,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
    
    --���Ͳ��Ϻ͵��ߵ���Ϣ
 	local item1 = user_info.propslist[8] or 0
 	local item2 = user_info.propslist[9] or 0
 	local item3 = user_info.valentine_cocoa_value
 	local item4 = user_info.valentine_milk_value
 	local item5 = user_info.valentine_nuts_value
 	local item6 = user_info.valentine_chocolate_value
 	local item7 = user_info.valentine_seeds_value
 	local item8 = user_info.valentine_soil_value
 	local item9 = user_info.valentine_nourishment_value
 	local item10 = user_info.valentine_rose_value
 	valentine_lib.send_item_info(user_info, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10)
 
end

--֪ͨ����ˣ�������ȡ�����������
function valentine_lib.on_recv_packs(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--TraceError("������ȡ�����������,USERID:"..user_info.userId)
   
   	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("������ȡ�����������,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
    
    if(user_info.valentine_libao_sign == 1)then
    	--TraceError("������ȡ�����������,������� USERID:"..user_info.userId)
    	return
    end
    
    local charm_value = user_info.valentine_charm_value
    local result = 0
    
    --�ҵ�����ֵ����100ʱ����ȡ�������
    if(charm_value > 99)then
    	--TraceError("������ȡ����������� ��ȡ�ɹ�,USERID:"..user_info.userId.." charm_value:"..charm_value)
    	--�����ȡ
	    user_info.valentine_libao_sign = 1
	    
	    --�������ݿ�
	    local sqltemplet = "update t_valentine_activity set libao_sign = 1 where user_id = %d;commit;";             
		dblib.execute(string.format(sqltemplet, user_info.userId))
		
		--�ӻ��10�����
		usermgr.addgold(user_info.userId, 100000, 0, g_GoldType.baoxiang, -1);
	 
		--����������ȡ��������������
		result = 1
    	valentine_lib.send_exorcist_packs_result(user_info, result)
    	
    	--ϵͳ�㲥����XXXX��ȡ������������10����룡��
    	local user_nick = user_info.nick
		user_nick = valentine_lib._tosqlstr(user_nick).."   "		--�����Ĵ���
		local msg = tex_lan.get_msg(user_info, "valentine_activity_msg_awards_1"); 
		local msg1 = tex_lan.get_msg(user_info, "valentine_activity_msg"); 
		msg1 = string.format(msg1); 
		BroadcastMsg(_U(msg)..user_nick.._U(msg1),0)
    else
    	--TraceError("������ȡ����ħ����� ʧ��,USERID:"..user_info.userId.." charm_value:"..charm_value)
    	--����������ȡ��������������
    	valentine_lib.send_exorcist_packs_result(user_info, result)
    end
   
end

--����ϳɣ�1�������ɿ�����2�������� 6���ɿ�����10����õ�壻
function valentine_lib.on_recv_composite(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   
   	--���ʱ����Ч��
	local check_time = valentine_lib.check_datetime()
    if(check_time == 0 or check_time == 5) then
    	--TraceError("����ϳ�,ʱ����ڣ� USERID:"..user_info.userId)
        return;
    end
    
    --�յ��ϳ�id  �ϳ����ͣ�1�������ɿ�����2�������� 6���ɿ�����10����õ�壻
    local composite_id = buf:readByte();
    	
   	--TraceError("���� �ϳ�,USERID:"..user_info.userId.." �յ��ϳ�id:"..composite_id)
    
    --���в��Ϻ͵��ߵ���Ϣ
 	local item1 = user_info.propslist[8] or 0
 	local item2 = user_info.propslist[9] or 0
 	local item3 = user_info.valentine_cocoa_value
 	local item4 = user_info.valentine_milk_value
 	local item5 = user_info.valentine_nuts_value
 	local item6 = user_info.valentine_chocolate_value
 	local item7 = user_info.valentine_seeds_value
 	local item8 = user_info.valentine_soil_value
 	local item9 = user_info.valentine_nourishment_value
 	local item10 = user_info.valentine_rose_value
 	
 	local result = 0		--�ϳɽ��
  
    --�жϺϳ�id
    if(composite_id == 1)then 		--1�������ɿ���
    	--�ж��ɿ�������
    	if(item6 < 10)then
    		--TraceError("����ϳ�  1�������ɿ���   �ɿ�����������    �û�id��"..user_info.userId)
    		
    		--���ͺϳɽ��
			valentine_lib.net_send_composite_result(user_info, result)
    		return
    	else
    		--���ɿ���
    		item6 = item6 - 10
    		user_info.valentine_chocolate_value = item6
    		
    		--TraceError("1111111111111111���� �ϳ�,USERID:"..user_info.userId.." item6:"..item6)
    		
    		--�Ӱ����ɿ���
    		item1 = item1 + 1
    		user_info.propslist[8] = item1
    		
   			local complete_callback_func = function(tools_count)
   				result = 1
      	 		--���ͺϳɽ��
				valentine_lib.net_send_composite_result(user_info, result)
    		end
   		 	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.love_chocolate_id, 1, user_info, complete_callback_func)
    	end
  	
    elseif(composite_id == 2)then 		--2������
    	--�ж�õ�廨����
    	if(item10 < 10)then
    		--TraceError("����ϳ�  ����   õ�廨��������    �û�id��"..user_info.userId)
    		
    		--���ͺϳɽ��
			valentine_lib.net_send_composite_result(user_info, result)
    		return
    	else
    		--��õ�廨
    		item10 = item10 - 10
    		user_info.valentine_rose_value = item10
    		
    		--�ӻ���
    		item2 = item2 + 1
    		user_info.propslist[9] = item2
    		
    		local complete_callback_func = function(tools_count)
   				result = 1
      	 		--���ͺϳɽ��
				valentine_lib.net_send_composite_result(user_info, result)
    		end
   		 	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.flowers_id, 1, user_info, complete_callback_func)
    	
    	end
    	
    elseif(composite_id == 6)then 		-- 6���ɿ���
    	--�жϿɿɶ���ţ�̡��������� 
    	if(item3 < 1 or item4 < 1 or item5 < 1)then
    		--TraceError("����ϳ�  �ɿɶ���ţ�̡��������� ��������    �û�id��"..user_info.userId)
    		
    		--���ͺϳɽ��
			valentine_lib.net_send_composite_result(user_info, result)
    		return
    	else
    		--���ɿɶ���ţ�̡��������� 
    		item3 = item3 - 1  
    		item4 = item4 - 1 
    		item5 = item5 - 1
    		user_info.valentine_cocoa_value = item3
 			user_info.valentine_milk_value = item4
 			user_info.valentine_nuts_value = item5
 			
    		--���ɿ���
    		item6 = item6 + 1
    		user_info.valentine_chocolate_value = item6
     
     		--���ͺϳɽ��
    		result = 1
      	 	valentine_lib.net_send_composite_result(user_info, result)
    	end
    	
    elseif(composite_id == 10)then 		-- 10����õ�壻
    		--�ж�õ�廨���ӡ���������������
    		if(item7 < 1 or item8 < 1 or item9 < 1)then
    			--TraceError("����ϳ�  õ�廨���ӡ�������������������    �û�id��"..user_info.userId)
    		
	    		--���ͺϳɽ��
				valentine_lib.net_send_composite_result(user_info, result)
	    		return
    		end
    		
    		--��õ�廨���ӡ��������������� 
    		item7 = item7 - 1  
    		item8 = item8 - 1 
    		item9 = item9 - 1
    		user_info.valentine_seeds_value = item7
 			user_info.valentine_soil_value = item8
 			user_info.valentine_nourishment_value = item9
  
    		--�Ӻ�õ��
    		item10 = item10 + 1
    		user_info.valentine_rose_value = item10
     
     		--���ͺϳɽ��
    		result = 1
      	 	valentine_lib.net_send_composite_result(user_info, result)
    
    else
    	--TraceError("����ϳ� ���մ���id �û�id��"..user_info.userId)
    	return
    end
   
    --���� ���ݿ�
    --TraceError("2222222222222222222222222���� �ϳ�,USERID:"..user_info.userId.." item6:"..item6)
    local sqltemplet = "update t_valentine_activity set love_chocolate_value = %d, flowers_value = %d, cocoa_value = %d, milk_value = %d, nuts_value = %d, chocolate_value = %d, seeds_value = %d, soil_value = %d, nourishment_value = %d, rose_value = %d where user_id = %d;commit;";
    local sql=string.format(sqltemplet, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, user_info.userId);
    dblib.execute(sql);
        
    --���Ͳ��Ϻ͵��ߵ���Ϣ
    valentine_lib.send_item_info(user_info, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10)
end

--���ͺϳɽ��
valentine_lib.net_send_composite_result = function(user_info, result)
  	--TraceError("���ͺϳɽ��,userid:"..user_info.userId.." result->"..result)
	netlib.send(function(buf)
	    buf:writeString("HDQRKILL")
	    buf:writeByte(result)	 --0���ϳ�ʧ�ܣ�1���ϳɳɹ�
	    end,user_info.ip,user_info.port) 
end

--����������ʱ��״̬
valentine_lib.net_send_playnum = function(user_info, check_time, play_count)
  	--TraceError(" ����������ʱ��״̬,userid:"..user_info.userId.." check_time->"..check_time.." play_count:"..play_count)
	netlib.send(function(buf)
	    buf:writeString("HDQRDATE")
	    buf:writeByte(check_time)	 --0�����Ч�������Ҳ�ɲ�������1�����Ч��2,�в���   5�������������һ��
	    buf:writeInt(play_count)	--����������
	    end,user_info.ip,user_info.port) 
end
 
--����ʹ�ú�õ��/�ɿ���/�����ɿ������
function valentine_lib.send_use_result(user_info, result, award_id)
	--TraceError("����ʹ�ú�õ��/�ɿ���/�����ɿ��������userid:"..user_info.userId.." result:"..result.." award_id:"..award_id);
	netlib.send(function(buf)
            buf:writeString("HDQRUSE");
            buf:writeInt(result);
            buf:writeInt(award_id);
        end,user_info.ip,user_info.port);
end

 
--�������а�
function valentine_lib.send_ph_list(user_info, libao_sign, my_charm_value, my_mc, charm_paimin_list)
	--TraceError("�������а�libao_sign:"..libao_sign.." my_charm_value"..my_charm_value.." my_mc:"..my_mc)
	----TraceError(charm_paimin_list)
	local send_len = 20; --Ĭ�Ϸ�20����Ϣ
	netlib.send(function(buf)
    	buf:writeString("HDQRLIST")
    	buf:writeByte(libao_sign or 0)		--�Ƿ���ȡ�ˡ������������0��δ��ȡ��1������ȡ��
	    buf:writeInt(my_charm_value or 0)	--�ҵ�����ֵ
	    buf:writeInt(my_mc or 0)	--�ҵ�����
 
		if send_len > #charm_paimin_list then send_len = #charm_paimin_list end --��෢20����Ϣ
		--TraceError("�������а�send_len:"..send_len)
		
		 buf:writeInt(send_len)
			--�ٷ������˵�
	        for i = 1,send_len do
		        buf:writeInt(charm_paimin_list[i].mingci)	--����
		        buf:writeInt(charm_paimin_list[i].user_id) --���ID
		        buf:writeString(charm_paimin_list[i].nick_name) --�ǳ�
		        buf:writeInt(charm_paimin_list[i].charm_value) --��ҹ����ɼ�
              
	        end
     	end,user_info.ip,user_info.port) 
end
 
--���͹�����
function valentine_lib.send_buy_result(user_info, buy_id, items_value, result)
	--TraceError("���͹�����,USERID:"..user_info.userId.." items_value:"..items_value.." result:"..result.." buy_id:"..buy_id)
	netlib.send(function(buf)
            buf:writeString("HDQRBUY");
            buf:writeInt(result);		--0������ʧ�ܣ����벻�㣻1������ɹ���2������ʧ�ܣ���ѹ��ڣ�3������ʧ�ܣ�����ԭ��
            buf:writeByte(buy_id);
            buf:writeInt(items_value);		--���ϵ�����
        end,user_info.ip,user_info.port);
end


--���Ͳ��Ϻ͵��ߵ���Ϣ
function valentine_lib.send_item_info(user_info, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10)
	  --TraceError("���Ͳ��Ϻ͵��ߵ���Ϣ,USERID:"..user_info.userId.." �����ɿ�������:"..item1.." ��������:"..item2.." �ɿɶ�����:"..item3.." ţ������:"..item4.." ��������:"..item5.." �ɿ�������:"..item6.." õ�廨��������:"..item7.." ��������:"..item8.." ��������:"..item9.." ��õ������:"..item10)
	  netlib.send(function(buf)
            buf:writeString("HDQRVALUE");
            buf:writeInt(item1);		--�����ɿ�������
            buf:writeInt(item2);		--��������
            buf:writeInt(item3);		--�ɿɶ�����
            buf:writeInt(item4);		--ţ������
            buf:writeInt(item5);		--��������
            buf:writeInt(item6);		--�ɿ�������
            buf:writeInt(item7);		--õ�廨��������
            buf:writeInt(item8);		--��������
            buf:writeInt(item9);		--��������
            buf:writeInt(item10);		--��õ������
        end,user_info.ip,user_info.port);
end
 
--����������ȡ��������������
function valentine_lib.send_exorcist_packs_result(user_info, result)
	--TraceError("����������ȡ��������������,USERID:"..user_info.userId.." result:"..result)
	 netlib.send(function(buf)
            buf:writeString("HDQRGIFTEX");
            buf:writeByte(result);		--0����ȡʧ�ܣ�δ�ﵽ��ȡ������1����ȡ�ɹ���2������ȡ��3����ȡʧ�ܣ�����ԭ��
        end,user_info.ip,user_info.port);
end

--���ͷ���ÿ��5��������1�ֺϳɲ���
function valentine_lib.send_random_item(user_info, items_id)
	--TraceError("���ͷ���ÿ��5��������1�ֺϳɲ���,USERID:"..user_info.userId.." items_id:"..items_id)
	 netlib.send(function(buf)
            buf:writeString("HDQRRANDOMITEMS");
            buf:writeByte(items_id);		--�ϳɲ������ͣ�3)�ɿɶ�����  4)ţ������	5)��������  7)õ�廨��������  8)��������  9)��������
        end,user_info.ip,user_info.port);
end


--Э������
cmd_tex_match_handler = 
{
	["HDQRDATE"] = valentine_lib.on_recv_activity_stat, --����ʱ��״̬
    ["HDQRPANEL"] = valentine_lib.on_recv_activation, -- ����򿪻���
    ["HDQRLIST"] = valentine_lib.on_recv_ph_list, -- --�������а� 
    ["HDQRVALUE"] = valentine_lib.on_recv_items_info, 	--�������в��ϵ���Ϣ
    ["HDQRUSE"] = valentine_lib.on_recv_use, --ʹ�ú�õ��/�ɿ���/�����ɿ���
    ["HDQRBUY"] = valentine_lib.on_recv_buy,--������
    ["HDQRGIFTEX"] = valentine_lib.on_recv_packs ,--֪ͨ����ˣ�������ȡ�����������
	["HDQRKILL"] = valentine_lib.on_recv_composite, --����ϳɣ�1�������ɿ�����2�������� 6���ɿ�����10����õ�壻
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", valentine_lib.on_after_user_login);
eventmgr:addEventListener("timer_minute", valentine_lib.ontimecheck);