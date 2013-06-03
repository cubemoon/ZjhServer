TraceError("init lottery_activity...")
if lottery_lib and lottery_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", lottery_lib.on_after_user_login);
end


if not lottery_lib then
    lottery_lib = _S
    {
        on_after_user_login = NULL_FUNC,--��½��������
		check_datetime = NULL_FUNC,	--�����Чʱ�䣬��ʱ����
		on_recv_click_award = NULL_FUNC,	--���յ�ȡ��ȡ
		on_recv_activ_stat = NULL_FUNC,		--����ʱ��״̬
		check_bottom_stat = NULL_FUNC,		--�ٴ��жϻ��ť״̬
        
        statime = "2012-01-07 09:00:00",  --���ʼʱ��
    	endtime = "2012-01-10 12:00:00",  --�����ʱ��
    	lottery_time = "2012-01-14 00:00:00",	--�콱���ʱ��
    	
    	activ3_gold = 12000000, 		--�μӻ3��Ҫ����
    	activ4_gold = 36000000,		--�μӻ4��Ҫ����
    	activ5_gold = 20000,		--�μӻ5��Ҫ����
    }    
 end
 

--��½��������
lottery_lib.on_after_user_login = function(e)
	--TraceError("��½��������")
	
	local userinfo = e.data.userinfo
	if(userinfo == nil)then 
		--TraceError("��½��������,if(userinfo == nil)then")
	 	return
	end
	
	--if(tex_gamepropslib ~= nil) then
    --    tex_gamepropslib.get_props_count_by_id(tex_gamepropslib.PROPS_ID.ShipTickets_ID, userinfo, function(ship_ticket_count) end)
   -- end
	
	local check_result = lottery_lib.check_datetime()	--���ʱ��
	if(check_result == 0)then
		--TraceError("��½��������,if(check_result == 0)then")
		return
	end
	
	local lottery1_time = 0
	local lottery2_time = 0
	local lottery3_time = 0
	local lottery4_time = 0
	local lottery5_count = 0
	local recharge = 0
	
	--��ʼ��
	if(userinfo.lottery1_time == nil)then
			userinfo.lottery1_time = 0
	end
	
	if(userinfo.lottery2_time == nil)then
			userinfo.lottery2_time = 0
	end
	
	if(userinfo.lottery3_time == nil)then
			userinfo.lottery3_time = 0
	end
	
	if(userinfo.lottery4_time == nil)then
			userinfo.lottery4_time = 0
	end
	
	if(userinfo.lottery5_count == nil)then
			userinfo.lottery5_count = 0
	end
	
	if(userinfo.recharge == nil)then
			userinfo.recharge = 0
	end
	
	--TraceError("��½��������,��ѯ���ݿ�")
	--��½��ѯ���ݿ�
	local sql="SELECT recharge,lottery1_time,lottery2_time,lottery3_time,lottery4_time,lottery5_count FROM user_huodong_cj_info where user_id=%d"
		sql=string.format(sql,userinfo.userId)
		dblib.execute(sql,function(dt)
			if(dt~=nil and #dt>0)then
			
				lottery1_time = timelib.db_to_lua_time(dt[1].lottery1_time) or 0
				lottery2_time = timelib.db_to_lua_time(dt[1].lottery2_time) or 0
				lottery3_time = timelib.db_to_lua_time(dt[1].lottery3_time) or 0
				lottery4_time = timelib.db_to_lua_time(dt[1].lottery4_time) or 0
				lottery5_count=dt[1].lottery5_count or 0
				recharge = dt[1].recharge or 0
				userinfo.recharge = recharge
				
				--TraceError("��½��ѯ���ݿ�,lottery1_time->"..lottery1_time.."  lottery2_time->"..lottery2_time.."  lottery3_time"..lottery3_time.."  lottery4_time"..lottery4_time)
				--TraceError("��½��ѯ���ݿ�,ueserid-> "..userinfo.userId.."   recharge-> "..recharge)
				
				--�ж��Ƿ����콱ʱ��
				local endtime = timelib.db_to_lua_time(lottery_lib.endtime);
				local lottery_time = timelib.db_to_lua_time(lottery_lib.lottery_time);
				--TraceError("��½��������,�ж��Ƿ����콱ʱ��")
				
				--��1��
				--�ж�ʱ��
 
					if(lottery1_time > endtime and lottery1_time <= lottery_time) then
			        	userinfo.lottery1_time = 1
					end
 
				--��2��
				--�ж�ʱ��
					if(lottery2_time > endtime and lottery2_time <= lottery_time) then
			        	userinfo.lottery2_time = 1
					end
 
				--��3��
				--�ж�ʱ��
					if(lottery3_time > endtime and lottery3_time <= lottery_time) then
			        	userinfo.lottery3_time = 1
					end
	 
				--��4��
				--�ж�ʱ��
					if(lottery4_time > endtime and lottery4_time <= lottery_time) then
			        	userinfo.lottery4_time = 1
					end
 
				--��5��
				userinfo.lottery5_count = lottery5_count
				--TraceError("��½��������,userinfo.lottery5_count->"..userinfo.lottery5_count.."  lottery4_time->"..userinfo.lottery4_time.."  lottery3_time->"..userinfo.lottery3_time.."  lottery2_time->"..userinfo.lottery2_time.."  lottery1_time->"..userinfo.lottery1_time)
				--TraceError("��½��������,ueserid-> "..userinfo.userId.."   recharge-> "..recharge)
			end
		end)
	
	
end


--�����Чʱ�䣬��ʱ����
function lottery_lib.check_datetime()
	local statime = timelib.db_to_lua_time(lottery_lib.statime);
	local endtime = timelib.db_to_lua_time(lottery_lib.endtime);
	local lottery_time = timelib.db_to_lua_time(lottery_lib.lottery_time);
	local sys_time = os.time();
	
	--�ʱ��
	if(sys_time > statime and sys_time <= endtime) then
        return 1;
	end
	
	--�콱ʱ��
	if(sys_time > endtime and sys_time <= lottery_time) then
        return 2;
	end
 
	--�ʱ���ȥ��
	return 0;
end


--���յ�ȡ��ȡ�һ�
lottery_lib.on_recv_click_award = function(buf)
 	--TraceError("���յ�ȡ��ȡ�һ�")
 	
	local type = buf:readByte()   --�1,�2,�3,�4,�5
		
	--�ж��û�	
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
 
	local gold = get_canuse_gold(user_info)--����û�����
	local check_result = lottery_lib.check_datetime()	--���ʱ��
	
	if(type == 1)then	--�1
		--TraceError("���յ�ȡ��ȡ�һ�--�1")
		--1����ڼ��ڣ�����������ȡ������˶һ�����
			--ϵͳ��ʾ �����ڻ������1��10������12:00������������ȡ��ֵ��������
		if(check_result == 0)then
			--TraceError("���յ�ȡ��ȡ�һ�--�1--��ѹ���")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-2)		    --��ѹ���
	        end,user_info.ip,user_info.port) 
	        
			return
		elseif(check_result == 1)then
			--TraceError("���յ�ȡ��ȡ�һ�--�1--���ڻ������1��10������12:00������������ȡ��ֵ����")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-3)		    --���ڻ������1��10������12:00������������ȡ��ֵ����
	        end,user_info.ip,user_info.port) 
	        
			return
		
		end
			
		--4�������ȡʱ����Ӧ��ֵ�ܶ�㣬��ʾ������ȡʧ�ܣ����ڻ�ڼ��ڵĳ�ֵ�ܶ������ȡ��������
		 if(user_info.recharge < 1)then
		 	--TraceError("���յ�ȡ��ȡ�һ�--�1--��ֵ�ܶ��")
		 	netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(0)		    --��ֵ�ܶ��
	        end,user_info.ip,user_info.port) 
	        
			return
		 end
 
		--1�������ȡ���һ���齱�������Ӧ������ϵͳ��ʾ����ϲ����� "����*1��T�˿�*1 ��������ʾ����ʾ��Ӧ��Ʒ
		--����
		if(user_info.lottery1_time == 0)then
			--TraceError("���յ�ȡ��ȡ�һ�--�1--����")
			--��С����*1
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info)
			--��T�˿�*1
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info) 
		    
		    user_info.lottery1_time = 1   --��ʾ�����
		    
		    --д��־
			local sql="insert into user_huodong_cj_info(user_id,lottery1_time) value(%d,now()) ON DUPLICATE KEY UPDATE lottery1_time=NOW()";
			sql=string.format(sql,user_info.userId);
			dblib.execute(sql)
			
			netlib.send(function(buf)
			    buf:writeString("HDDHCJING")
			    buf:writeInt(1)		    --�ɹ������ضԾ��ײͣ�1��2��3��4��ƷID
		        end,user_info.ip,user_info.port)
		     
		     --��鰴ť״̬   
		     lottery_lib.check_bottom_stat(user_info)
		end
		
	elseif(type == 2)then		--�2
		--TraceError("���յ�ȡ��ȡ�һ�--�2")
		--1����ڼ��ڣ�����������ȡ������˶һ�����
			--ϵͳ��ʾ �����ڻ������1��10������12:00������������ȡ��ֵ��������
		if(check_result == 0)then
			--TraceError("���յ�ȡ��ȡ�һ�--�2--��ѹ���")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-2)		    --��ѹ���
	        end,user_info.ip,user_info.port) 
	        
			return
		elseif(check_result == 1)then
			--TraceError("���յ�ȡ��ȡ�һ�--�2--���ڻ������1��10������12:00������������ȡ��ֵ����")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-3)		    --���ڻ������1��10������12:00������������ȡ��ֵ����
	        end,user_info.ip,user_info.port) 
	        
			return
		
		end	
		
		--4�������ȡʱ����Ӧ��ֵ�ܶ�㣬��ʾ������ȡʧ�ܣ����ڻ�ڼ��ڵĳ�ֵ�ܶ������ȡ��������
		 if(user_info.recharge < 99)then
		 	--TraceError("���յ�ȡ��ȡ�һ�--�2--��ֵ�ܶ��")
		 	netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(0)		    --��ֵ�ܶ��
	        end,user_info.ip,user_info.port) 
	        
			return
		 end
			
		--1�������ȡ���һ���齱�������Ӧ������ϵͳ��ʾ����ϲ����� "T�˿�*1������*1������ʯ*1 ��������ʾ����ʾ��Ӧ��Ʒ
		--����
		if(user_info.lottery2_time == 0)then
			--TraceError("���յ�ȡ��ȡ�һ�--�2--����")
			--��С����*1
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info)
			--��T�˿�*1
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info) 
			--������ʯ*1
			gift_addgiftitem(user_info,5001,user_info.userId,user_info.nick, false)
			
			user_info.lottery2_time = 1   --��ʾ�����
			
			--д��־
			local sql="insert into user_huodong_cj_info(user_id,lottery2_time) value(%d,now()) ON DUPLICATE KEY UPDATE lottery2_time=NOW()";
			sql=string.format(sql,user_info.userId);
			dblib.execute(sql)
		
	        netlib.send(function(buf)
			    buf:writeString("HDDHCJING")
			    buf:writeInt(2)		    --�ɹ������ضԾ��ײͣ�1��2��3��4��ƷID
		        end,user_info.ip,user_info.port)
		        
		     --��鰴ť״̬   
		     lottery_lib.check_bottom_stat(user_info)
		end
		        
	elseif(type == 3)then		--�3
		--TraceError("���յ�ȡ��ȡ�һ�--�3")
		--1����ڼ��ڣ�����������ȡ������˶һ�����
			--ϵͳ��ʾ �����ڻ������1��10������12:00������������ȡ��ֵ��������
		if(check_result == 0)then
			--TraceError("���յ�ȡ��ȡ�һ�--�3--��ѹ���")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-2)		    --��ѹ���
	        end,user_info.ip,user_info.port) 
	        
			return
		elseif(check_result == 1)then
			--TraceError("���յ�ȡ��ȡ�һ�--�3--���ڻ������1��10������12:00������������ȡ��ֵ����")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-3)		    --���ڻ������1��10������12:00������������ȡ��ֵ����
	        end,user_info.ip,user_info.port) 
	        
			return
		
		end
		
		--4�������ȡʱ����Ӧ��ֵ�ܶ�㣬��ʾ������ȡʧ�ܣ����ڻ�ڼ��ڵĳ�ֵ�ܶ������ȡ��������
		 if(user_info.recharge < 999)then
		 	--TraceError("���յ�ȡ��ȡ�һ�--�3--��ֵ�ܶ��")
		 	netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(0)		    --��ֵ�ܶ��
	        end,user_info.ip,user_info.port) 
	        
			return
		 end
		
		--�жϳ���
		if(gold < lottery_lib.activ3_gold)then
			--TraceError("���յ�ȡ��ȡ�һ�--�3--��������")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-1)		    --��������
	        end,user_info.ip,user_info.port)
			
			return
		end
		
		
		 
		--1�������ȡ���һ���齱�������Ӧ������ϵͳ��ʾ����ϲ����� "��ͧ��T�˿�*3������*3���̱�ʯ*1 ��������ʾ����ʾ��Ӧ��Ʒ
		--����
		if(user_info.lottery3_time == 0)then
			--TraceError("���յ�ȡ��ȡ�һ�--�3--����")
			--������
	      	usermgr.addgold(user_info.userId, -lottery_lib.activ3_gold, 0, g_GoldType.baoxiang, -1);
	      	
			--��С����*3
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 3, user_info)
			--��T�˿�*3
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 3, user_info)
			--����ͧ
			gift_addgiftitem(user_info,5023,user_info.userId,user_info.nick, false)
			  
			--���̱�ʯ*1
			gift_addgiftitem(user_info,5002,user_info.userId,user_info.nick, false)
			
			user_info.lottery3_time = 1   --��ʾ�����
			
			--д��־
			local sql="insert into user_huodong_cj_info(user_id,lottery3_time) value(%d,now()) ON DUPLICATE KEY UPDATE lottery3_time=NOW()";
			sql=string.format(sql,user_info.userId);
			dblib.execute(sql)
		
	        netlib.send(function(buf)
			    buf:writeString("HDDHCJING")
			    buf:writeInt(3)		    --�ɹ������ضԾ��ײͣ�1��2��3��4��ƷID
		        end,user_info.ip,user_info.port)
		    
		    --��鰴ť״̬   
		    lottery_lib.check_bottom_stat(user_info)
	    end
	        
	elseif(type == 4)then		--�4
		--TraceError("���յ�ȡ��ȡ�һ�--�4")
		--1����ڼ��ڣ�����������ȡ������˶һ�����
			--ϵͳ��ʾ �����ڻ������1��10������12:00������������ȡ��ֵ��������
		if(check_result == 0)then
			--TraceError("���յ�ȡ��ȡ�һ�--�4--��ѹ���")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-2)		    --��ѹ���
	        end,user_info.ip,user_info.port) 
	        
			return
		elseif(check_result == 1)then
			--TraceError("���յ�ȡ��ȡ�һ�--�4--���ڻ������1��10������12:00������������ȡ��ֵ����")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-3)		    --���ڻ������1��10������12:00������������ȡ��ֵ����
	        end,user_info.ip,user_info.port) 
	        
			return
		
		end

		--4�������ȡʱ����Ӧ��ֵ�ܶ�㣬��ʾ������ȡʧ�ܣ����ڻ�ڼ��ڵĳ�ֵ�ܶ������ȡ��������
	 	if(user_info.recharge < 4999)then
		 	 --TraceError("���յ�ȡ��ȡ�һ�--�4--��ֵ�ܶ��")
		 	netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(0)		    --��ֵ�ܶ��
	        end,user_info.ip,user_info.port) 
	        
			return
		 end
		 
		 --�жϳ���
		if(gold < lottery_lib.activ4_gold)then
			 --TraceError("���յ�ȡ��ȡ�һ�--�4--��������")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-1)		    --��������
	        end,user_info.ip,user_info.port)
			 
			return
		end
			
		--1�������ȡ���һ���齱�������Ӧ������ϵͳ��ʾ����ϲ����� "��������T�˿�*5������*10���챦ʯ*1  ��������ʾ����ʾ��Ӧ��Ʒ
		--����
		if(user_info.lottery4_time == 0)then
			 --TraceError("���յ�ȡ��ȡ�һ�--�4--����")
			--������
	      	usermgr.addgold(user_info.userId, -lottery_lib.activ4_gold, 0, g_GoldType.baoxiang, -1);
		
			--��С����10
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 10, user_info)
			--��T�˿�5
		    tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 5, user_info)
			--�ӷ�����
			gift_addgiftitem(user_info,5024,user_info.userId,user_info.nick, false)
			
			--�Ӻ챦ʯ*1  
			gift_addgiftitem(user_info,5004,user_info.userId,user_info.nick, false)
		
			user_info.lottery4_time = 1   --��ʾ�����
			
			--д��־
			local sql="insert into user_huodong_cj_info(user_id,lottery4_time) value(%d,now()) ON DUPLICATE KEY UPDATE lottery4_time=NOW()";
			sql=string.format(sql,user_info.userId);
			dblib.execute(sql)
			
	        netlib.send(function(buf)
			    buf:writeString("HDDHCJING")
			    buf:writeInt(4)		    --�ɹ������ضԾ��ײͣ�1��2��3��4��ƷID
		        end,user_info.ip,user_info.port)
		        
		    --��鰴ť״̬   
		    lottery_lib.check_bottom_stat(user_info)
		    
	    end
	        		
	elseif(type == 5)then		--�5
		--TraceError("���յ�ȡ��ȡ�һ�--�5")
		--�жϻʱ��  4�������1.10 12:00�󣬵������˳齱����ϵͳ��ʾ���齱��ѹ��ڣ���
		if(check_result ~= 1)then
			--TraceError("���յ�ȡ��ȡ�һ�--�5--��ѹ���")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-2)		    --��ѹ���
	        end,user_info.ip,user_info.port)
	         
			return
		end
		
		--�ж��ʸ�֤ 3���齱ʱ���ʸ�֤�鲻����ʾ���ʸ�֤�鲻�㣡"
		--��ѯ�ʸ�֤����
		local shiptickets_count = user_info.propslist[3]
		if(shiptickets_count == nil)then
			--TraceError("���յ�ȡ��ȡ�һ�--�5--�ʸ�֤��Ϊ��")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-4)		    --�ʸ�֤�鲻��
	        end,user_info.ip,user_info.port)
		
			return
		elseif(shiptickets_count < 1)then
			--TraceError("���յ�ȡ��ȡ�һ�--�5--�ʸ�֤�鲻��")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-4)		    --�ʸ�֤�鲻��
	        end,user_info.ip,user_info.port)
		
			return
		end
		
		--5������һ��ͳ齱ʱ����������벻�㣬��ʾ �����������㣬���ֵ�� �������ֵ����ť�� 
		--�����ֵ���ӵ���Ӧ����ƽ̨��ֵҳ��
		--�жϳ���
		if(gold < lottery_lib.activ5_gold)then
			--TraceError("���յ�ȡ��ȡ�һ�--�5--��������")
			netlib.send(function(buf)
		    buf:writeString("HDDHCJING")
		    buf:writeInt(-1)		    --��������
	        end,user_info.ip,user_info.port)
			 
			return
		end
		--TraceError("���յ�ȡ��ȡ�һ�--�5--����")
		--1�������ȡ���һ���齱�������Ӧ������ϵͳ��ʾ����ϲ����� 
			--"����ʯ*1 �� �̱�ʯ*1  �� �Ʊ�ʯ*1 �� �챦ʯ*1 �� �ڱ�ʯ*1 ��������ʾ����ʾ��Ӧ��Ʒ
		--����
		  --������ɽ�ƷID
        local sql = format("call sp_huodong_cj_get_random_gift(%d)", user_info.userId)
 
 		local prizeid = 0
 		
        dblib.execute(sql, function(dt)
            if(dt and #dt > 0)then
            	prizeid = dt[1]["gift_id"]
            	
            	if(prizeid == 1)then
	            	--������ʯ*1  
					gift_addgiftitem(user_info,5001,user_info.userId,user_info.nick, false)
					prizeid = 5001
				elseif(prizeid == 2)then
	            	--���̱�ʯ*1  
					gift_addgiftitem(user_info,5002,user_info.userId,user_info.nick, false)
					prizeid = 5002
				elseif(prizeid == 3)then
	            	--�ӻƱ�ʯ*1  
					gift_addgiftitem(user_info,5003,user_info.userId,user_info.nick, false)
					prizeid = 5003
				elseif(prizeid == 4)then
	            	--�Ӻ챦ʯ*1  
					gift_addgiftitem(user_info,5004,user_info.userId,user_info.nick, false)
					prizeid = 5004
				elseif(prizeid == 5)then
	            	--�Ӻڱ�ʯ*1  
					gift_addgiftitem(user_info,5005,user_info.userId,user_info.nick, false)
					prizeid = 5005
				end
            	
            	user_info.propslist[3] = user_info.propslist[3] - 1
				tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.ShipTickets_ID, -1, user_info)
				--TraceError("--�齱�۳��ʸ�֤1�ţ��ʸ�֤ʣ�ࣺ"..user_info.propslist[3].."��ƷID"..prizeid)
				
	            netlib.send(function(buf)
				    buf:writeString("HDDHCJING")
				    buf:writeInt(prizeid)		    --�ɹ������ضԾ��ײͣ�1��2��3��4��ƷID
		        end,user_info.ip,user_info.port)
		        
			end
        end)
        
        --д��־
		local sql="insert into user_huodong_cj_info(user_id,lottery5_count) value(%d,1) ON DUPLICATE KEY UPDATE lottery5_count = lottery5_count+1";
		sql=string.format(sql,user_info.userId);
		dblib.execute(sql)

		--������
	    usermgr.addgold(user_info.userId, -lottery_lib.activ5_gold, 0, g_GoldType.baoxiang, -1);

	else
		TraceError("���յ�ȡ��ȡ�һ�,����")
		return
	end

end
 
--����ʱ��״̬
lottery_lib.on_recv_activ_stat = function(buf)
	--TraceError("����ʱ��״̬")
	--�ж��û�	
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	
	local check_result = lottery_lib.check_datetime()	--���ʱ��
	if(check_result == 0)then
		--TraceError("����ʱ��״̬--��ѹ���")
--		netlib.send(function(buf)
--	    buf:writeString("HDDHCJDATE")
--	    buf:writeByte(0)		    --��ѹ���
--	  	buf:writeInt(0)		    --������ʾ״̬����ʾ�Ѷһ���������ʾ���� �Ѷһ����ID ���л����㷢����
--        end,user_info.ip,user_info.port) 
        
		return
	elseif(check_result == 1)then
		--TraceError("����ʱ��״̬--������ڼ䣨�ɳ齱ʱ�䣩��")
		netlib.send(function(buf)
	    buf:writeString("HDDHCJDATE")
	    buf:writeByte(1)		    --������ڼ䣨�ɳ齱ʱ�䣩��
	    buf:writeInt(0)		    --������ʾ״̬����ʾ�Ѷһ���������ʾ���� �Ѷһ����ID ���л����㷢����
        end,user_info.ip,user_info.port) 
        
		return
		
	elseif(check_result == 2)then
		
		local result = 0
		if(user_info.lottery1_time == 1)then
			--result = 2
			result = bit_mgr:_or(result, 2)
		end
		
		if(user_info.lottery2_time == 1)then
			--result = 4
			result = bit_mgr:_or(result, 4)
		end
		
		if(user_info.lottery3_time == 1)then
			--result = 8
			result = bit_mgr:_or(result, 8)
		end
		
		if(user_info.lottery4_time == 1)then
			--result = 16
			result = bit_mgr:_or(result, 16)
		end
		
		--TraceError("����ʱ��״̬--��������콱���һ�ʱ�䣩result:"..result)
		
		netlib.send(function(buf)
		    buf:writeString("HDDHCJDATE")
		    buf:writeByte(2)		    --��������콱���һ�ʱ�䣩
		    buf:writeInt(result)		    --������ʾ״̬����ʾ�Ѷһ���������ʾ���� �Ѷһ����ID ���л����㷢����
	        end,user_info.ip,user_info.port) 
        
		return
	
	end
	
end

--�ٴ��жϻ��ť״̬
function lottery_lib.check_bottom_stat(user_info)

	local result = 0
		if(user_info.lottery1_time == 1)then
			--result = 2
			result = bit_mgr:_or(result, 2)
		end
		
		if(user_info.lottery2_time == 1)then
			--result = 4
			result = bit_mgr:_or(result, 4)
		end
		
		if(user_info.lottery3_time == 1)then
			--result = 8
			result = bit_mgr:_or(result, 8)
		end
		
		if(user_info.lottery4_time == 1)then
			--result = 16
			result = bit_mgr:_or(result, 16)
		end
		
		--TraceError("�ٴ��жϻ��ť״̬ result:"..result)
		
		netlib.send(function(buf)
		    buf:writeString("HDDHCJDATE")
		    buf:writeByte(2)		    --��������콱���һ�ʱ�䣩
		    buf:writeInt(result)		    --������ʾ״̬����ʾ�Ѷһ���������ʾ���� �Ѷһ����ID ���л����㷢����
	        end,user_info.ip,user_info.port)
        
end



--Э������
cmd_tex_match_handler = 
{
    ["HDDHCJING"] = lottery_lib.on_recv_click_award, --���յ�ȡ��ȡ�һ�
    ["HDDHCJDATE"] = lottery_lib.on_recv_activ_stat, --����ʱ��״̬

}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", lottery_lib.on_after_user_login);