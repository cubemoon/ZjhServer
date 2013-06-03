TraceError("���� dhomelib ���....")

if not dhomelib then
	dhomelib = _S
	{
        update_share_info           = NULL_FUNC,    --���·�����Ϣ
        net_send_share_info         = NULL_FUNC,    --���ͷ����¼�
        on_recv_check_have_right    = NULL_FUNC,    --����Ƿ����ʸ�ͨ��԰
        notify_add_friend = NULL_FUNC, --��Ӻ���֪ͨ
        update_user_home_status = NULL_FUNC, --���¼�԰��ʶ
        get_user_home_status = NULL_FUNC, --��ȡ��԰��ʶ
        update_user_home_info = NULL_FUNC, --���ü�԰ͷ��
        deal_game_home_message=NULL_FUNC, --ͬ����Ϣ
        first_sync_friends=NULL_FUNC,  --��һ�ο�ͨ��԰Ҫͬ����
        
        ----------------���ݷ���ͳ�ƻ-----------
        onRecvActiveStat = NULL_FUNC,	--��������״̬
		onRecvActiveCount= NULL_FUNC,	--��ѯ�����/���ӵĴ���
		onRecvEvaluate= NULL_FUNC,	--��ݻ����ĳ��
 		on_after_user_login= NULL_FUNC,	--��ʼ����ҷ�����Ϣ 
		net_send_friend_share_info= NULL_FUNC,--֪ͨ�ͻ��ˣ��������Ѷ�̬�����
        sendActiveCount=NULL_FUNC,		--֪ͨ�ͻ��ˣ��µı��޺ͱ��Ӵ���
        isVaildTime=NULL_FUNC,		--�Ƿ�����Чʱ���ڵ�
        
        statime = "2011-12-16 00:00:00",  --���ʼʱ��
        endtime = "2011-12-19 00:00:00",  --�����ʱ��
        
	}
end

--���·�����Ϣ
dhomelib.update_share_info = function(userinfo, share_id, data)
    if not userinfo then return end;
    --TraceError("�ﵽ������԰����share_id��".. share_id)
    dhomelib.net_send_share_info(userinfo, share_id, data)
    
    --֪ͨ�ͻ��ˣ��������Ѷ�̬�����
    if(share_id==4001)then
       	dhomelib.net_send_friend_share_info(userinfo, share_id, data)
    end
end

--���͵��ͻ��ˣ�����ID
dhomelib.net_send_share_info = function(userinfo, share_id, data)
    local smallbet = 0
    local largebet = 0
    local winchouma = 0
    local paixing = -1
    if(data ~= nil) then
        smallbet = data.smallbet and data.smallbet or 0
        largebet = data.largebet and data.largebet or 0
        winchouma = data.winchouma and data.winchouma or 0
        paixing = data.paixing and data.paixing or -1
    end
    if paixing ~= 0 then
    
	    netlib.send(
	        function(buf)
	            buf:writeString("TXSHAREDH")
	            buf:writeInt(share_id)  --����ID
	            buf:writeInt(smallbet)
	            buf:writeInt(largebet)
	            buf:writeInt(winchouma)
	            buf:writeInt(paixing)
	        end,userinfo.ip,userinfo.port)
	 end
end

--����Ƿ����ʸ�ͨ��԰
dhomelib.on_recv_check_have_right = function(buf)
    local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
    
    local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(userinfo)
    end

    local tex_daren_count = 0
    if(userinfo.wdg_huodong ~= nil) then
        tex_daren_count = userinfo.wdg_huodong.daren_count or 0
    end

    local result = 0
    if(usermgr.getlevel(userinfo) >= 60 or vip_level >= 5 or tex_daren_count > 0) then
        result = 1
    end

    netlib.send(
        function(buf)
            buf:writeString("TXCHRIGHT")
            buf:writeByte(result)  --�����0����ʾ�ʸ񲻹���1����ʾ���ʸ�
           
        end,userinfo.ip,userinfo.port)
end

function dhomelib.notify_add_friend(user_id_1, user_id_2)

    usermgr.get_passport_by_user_id(user_id_1, function(passport1)
        if (passport1 == nil) then return end
        usermgr.get_passport_by_user_id(user_id_2, function(passport2)
            if (passport2 == nil) then return end
            local user_info_1 = usermgr.GetUserById(user_id_1)
            local user_info_2 = usermgr.GetUserById(user_id_2)
            if(user_info_1==nil or user_info_2==nil)then
            	return
            end
            local sql = "insert into game_home_message(sys_time, msg_type, arg1, arg2, arg3, arg4)values(now(), 3, '%s', '%s', '%s', '%s')"
            sql = string.format(sql,  passport1, passport2,user_info_1.nick, user_info_2.nick)
            --dblib.execute(sql, function()end, user_id_1, common_db_info.home)            
        end)
    end)
end

function dhomelib.update_user_home_status(user_info)

	if(user_id==nil)then return end
	local sql="update user_homezone_info set home_status=1 where user_id=%d"
	sql=string.format(sql,user_info.userId)
	dblib.execute(sql, nil, user_info.userId)
	user_info.home_status=1;
end

function dhomelib.get_user_home_status(user_info)

	if(user_info==nil)then return end
	local sql="select home_status,home_face from user_homezone_info where user_id=%d"
	sql=string.format(sql,user_info.userId)
	 dblib.execute(sql,function(dt)
	  if(dt and #dt > 0) then
	  	--0����δ��ͨ
	  	user_info.home_face = dt[1].home_face or "";
	  	user_info.home_status = dt[1].home_status or 0;
		--������û���¹�ͷ����ô�Ϳ�����Ϊû��ͨ��԰
	  	if user_info.home_face == nil or user_info.home_face == "" then
	  		user_info.home_status = 0
	  	end
      end

      if(user_info.home_status == nil) then
        user_info.home_status = 0;
      end

      if(user_info.home_face == "") then
          user_info.home_face = "";
      end

      
    end)		
end

--��һ�ο�ͨ��԰ʱҪ��һ��ͬ��
function dhomelib.first_sync_friends(user_id)
	--TraceError("first sync friends")
	local sql="select friends from user_friends where user_id=%d"
	
	sql=string.format(sql,user_id)
	--TraceError("sql="..sql)
	dblib.execute(sql,function(dt)
		if(dt and #dt > 0) then
			local t_friend = split(dt[1].friends, "|")
            
			for k,v in pairs(t_friend) do
			
			    if(tonumber(v) ~= nil)then
			   		--TraceError("t_friend="..tonumber(v))
			        dhomelib.notify_add_friend(user_id, tonumber(v))			        
			    end
			end
		end
	end)
end


--ͬ�����˼�԰����Ϣ
function dhomelib.update_user_home_info(user_id,face)
	if(face==nil) then face="" end;
	if(user_id==nil)then
		TraceError("user_id error")
		return
	end
	local sql="insert into user_homezone_info (user_id,home_face,home_status) value(%d,'%s',1) ON DUPLICATE KEY UPDATE home_face='%s'"
	sql=string.format(sql,user_id,face,face);
	dblib.execute(sql, nil, user_id);
end

--ͬ�����˼�԰����Ϣ
function dhomelib.deal_game_home_message()
	--TraceError("deal_game_home_message")
    --������ڴ�����һ�֣��ͷ���
    if(room.process_game_home_msg_ok == 0) then
        return
    end
    
    local del_msg_by_id=function(id)
    	local sql="INSERT INTO log_game_home_message(msg_id,sys_time,msg_type,arg1,arg2,arg3,arg4,del_time) SELECT id AS msg_id,sys_time,msg_type,arg1,arg2,arg3,arg4,NOW() as del_time FROM game_home_message WHERE id=%d;"
    	sql=sql.."delete from game_home_message where id=%d;commit;";
    	sql=string.format(sql,id,id)
    	dblib.execute(sql)
	end
	
    room.process_game_home_msg_ok = 0
    local process_msg_fun = function(dt)

        if(not dt or #dt <= 0) then 
    		room.process_game_home_msg_ok = 1
    		return 
        end
  
        for i = 1, #dt do

            if (dt[i]["msg_type"] == 1) then  --�޸�ͷ��
            	 if (dt[i]["arg1"] == nil or dt[i]["arg1"] == "") then
                    TraceError("Э12passportΪ��")
                end
		
                usermgr.get_user_id_by_passport(dt[i]["arg1"], function(user_id)
                    if (user_id == nil) then return end
		
                    dblib.cache_set("users",  {face = dt[i]["arg2"]}, "id", user_id)
		   
                    dhomelib.update_user_home_info(user_id,dt[i]["arg2"])   
		
                end)			
    		elseif (dt[i]["msg_type"] == 2) then --�޸��ǳ�
    		
		if (dt[i]["arg1"] == nil or dt[i]["arg1"] == "") then
                    TraceError("Э��2passportΪ��")
                end
    			usermgr.get_user_id_by_passport(dt[i]["arg1"], function(user_id)
                    if (user_id == nil) then return end
                
    				dblib.cache_set("users",  {nick_name = string.trans_str(dt[i]["arg2"])}, "id", user_id)  
			
    				--��һ�ο�ͨ��԰Ҫͬ������
					dhomelib.first_sync_friends(user_id)              
    			end)
				
    		elseif (dt[i]["msg_type"] == 3) then --�Ӻ���
    			local add_gamefriend_sql="update user_friends set friends = concat(friends,%s) where user_id = %d;commit;"
    			usermgr.get_user_id_by_passport(dt[i]["arg1"], function(user_id_1)
    				if (user_id_1 == nil) then return end					
    				usermgr.get_user_id_by_passport(dt[i]["arg2"], function(user_id_2)
    					if (user_id_2 == nil) then return end
    						local usergamestr = tostring(user_id_1) .. "|"
    						local add_friend_sql=string.format(add_gamefriend_sql,dblib.tosqlstr(usergamestr),user_id_2)
    						dblib.execute(add_friend_sql)
    						usergamestr = tostring(user_id_2) .. "|"
    						add_friend_sql=string.format(add_gamefriend_sql,dblib.tosqlstr(usergamestr),user_id_1)
							dblib.execute(add_friend_sql)
    				end)
    			end)
    		elseif (dt[i]["msg_type"] == 4) then --ɾ������
    			usermgr.get_user_id_by_passport(dt[i]["arg1"], function(user_id_1)
    				if (user_id_1 == nil) then return end					
    				usermgr.get_user_id_by_passport(dt[i]["arg2"], function(user_id_2)
    					if (user_id_2 == nil) then return end
    					local sql = "UPDATE user_friends SET friends = REPLACE(friends , '%s', '') WHERE user_id= %d;commit"
                        local sql_temp = string.format(sql, user_id_1.."|", user_id_2)
    					dblib.execute(sql_temp)
    					sql_temp = string.format(sql, user_id_2.."|", user_id_1)
    					dblib.execute(sql_temp)					
    				end)
    			end)
    			
    		elseif (dt[i]["msg_type"] == 5) then --��ͨ�Ļ���ʾV��
    			usermgr.get_user_id_by_passport(dt[i]["arg1"], function(user_id) 
					dhomelib.update_user_home_info(user_id) 
				end)
            end
            --Ĭ��ÿ����Ϣ����ִ�гɹ���
            --ɾ��������Ϣ�����������Ҫ��ߵĻ�����Ҫ��ÿ����Ϣִ��sqlʱ��#dt>0��ɾ����Ϣ��
            del_msg_by_id(dt[i].id) 
        end
        room.process_game_home_msg_ok = 1
    end
    dblib.execute("select * from game_home_message order by id asc limit 0,100", process_msg_fun)
end




----------------���ݷ���ͳ�ƻ-----------

--�Ƿ�����Чʱ����
function dhomelib.isVaildTime()	
    local sys_time = os.time();
    local statime = timelib.db_to_lua_time(dhomelib.statime);
	local endtime = timelib.db_to_lua_time(dhomelib.endtime);
    if(sys_time >= statime and sys_time <= endtime) then
    	return 0
    else
    	return 1
	end
end

--��������״̬
function dhomelib.onRecvActiveStat(buf)
	local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
    
  
    --�жϻ��Ч��
	if(dhomelib.isVaildTime()==0) then
         netlib.send(function(buf)
            buf:writeString("FRACTIVED")
            buf:writeByte(1)		--���������
        end,userinfo.ip,userinfo.port)
    else
    	netlib.send(function(buf)
            buf:writeString("FRACTIVED")
            buf:writeByte(0)		--��Ч����
        end,userinfo.ip,userinfo.port)
	end

end 

--��ѯ�����/���ӵĴ���
function dhomelib.sendActiveCount(userinfo)
	
    if not userinfo then return end;
    
    netlib.send(function(buf)
            buf:writeString("FRACTIVECOUNT")
            buf:writeInt(userinfo.praise_count or 0)		--��ݵĴ���
			buf:writeInt(userinfo.curse_count or 0)		--�����ӵĴ���
        end,userinfo.ip,userinfo.port)
end


--��ѯ�����/���ӵĴ���
function dhomelib.onRecvActiveCount(buf)
	local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
    dhomelib.sendActiveCount(userinfo)
  
end

--��ݻ����ĳ��
function dhomelib.onRecvEvaluate(buf)
	local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
   
    local nUserID = buf:readInt()	--����ݻ���ӵ����ID
    local nEvaluate = buf:readInt()	--�����ͣ�1����ݣ�2������
	local sql=""
	
	--��ͶƱ����Ҽ�100��,���ֻ��ͶƱ11��
	local praise_other_count=userinfo.praise_other_count or 0;
	local curse_other_count=userinfo.curse_other_count or 0;
	
	if(userinfo.praise_other_count==nil)then userinfo.praise_other_count=0 end;
	if(userinfo.curse_other_count==nil)then userinfo.curse_other_count=0 end;
	
	
	--�����ݻ���ӱ��˵���Ϣ			
	if(curse_other_count+praise_other_count<11)then
		if(nEvaluate==1)then
			userinfo.praise_other_count=userinfo.praise_other_count+1
			sql="insert into user_dhomeshare_info(user_id, share_status, share_count) values(%d,%d,1) ON DUPLICATE KEY UPDATE share_count=share_count+1;" 
			sql=string.format(sql,userinfo.userId,3) 
		elseif(nEvaluate==2)then
			userinfo.curse_other_count=userinfo.curse_other_count+1
			sql="insert into user_dhomeshare_info(user_id, share_status, share_count) values(%d,%d,1) ON DUPLICATE KEY UPDATE share_count=share_count+1;" 
			sql=string.format(sql,userinfo.userId,4) 
		end
    	usermgr.addgold(userinfo.userId, 100, 0, g_GoldType.dhome_share_gold, -1, 1);
    	--д��ݻ���ӱ��˵ļ�¼
    	dblib.execute(sql)
    end
    
    --д����ݵļ�¼
    local org_userinfo=usermgr.GetUserById(nUserID)
    if (org_userinfo.praise_count==nil) then org_userinfo.praise_count=0 end
    if (org_userinfo.curse_count==nil) then org_userinfo.curse_count=0 end
    if(nEvaluate==1)then
    	org_userinfo.praise_count=org_userinfo.praise_count+1
    elseif(nEvaluate==2)then
    	org_userinfo.curse_count=org_userinfo.curse_count+1
    end
    --���޺ͱ��ӵĴ����仯�ˣ�����Ҫ����Ϣ���ͻ���
    dhomelib.sendActiveCount(org_userinfo)
    
    --���浽���ݿ�
    sql="insert into user_dhomeshare_info(user_id, share_status, share_count) values(%d,%d,1) ON DUPLICATE KEY UPDATE share_count=share_count+1;" 
	sql=string.format(sql,nUserID,nEvaluate)
	dblib.execute(sql)
 
end

--֪ͨ�ͻ��ˣ��������Ѷ�̬�����
dhomelib.net_send_friend_share_info = function(userinfo, share_id, data)
    local smallbet = 0
    local largebet = 0
    local winchouma = 0
    
    --������Чʱ��Ļ�����ֱ�Ӳ�����
    if(dhomelib.isVaildTime()~=0) then
    	return
    end
    
    --������Ǽ�԰�û���ֱ���˳�
    if(userinfo==nil or userinfo.home_status==nil or userinfo.home_status~=1)then
    	return    	
    end

    
    if(data ~= nil) then
        smallbet = data.smallbet and data.smallbet or 0
        largebet = data.largebet and data.largebet or 0
        winchouma = data.winchouma and data.winchouma or 0
        paixing = data.paixing and data.paixing or -1
    end

    --�ж��Ƿ�����
   	local function is_online(user_id)
        if (usermgr.GetUserById(user_id) == nil) then
            return 0
        else
            return 1
        end
   	end
	   	
	--�����ߺ��ѷ�����Ϣ
	for k, v in pairs(userinfo.friends) do
	   local info = userinfo.friends[tonumber(k)].userinfo
	   if(info~=nil and is_online(info.userid)==1)then
	   		local friend_userinfo=usermgr.GetUserById(info.userid)
	  		 if(friend_userinfo~=nil)then
	  		 
	  		 		--����ܴ�������11�εĺ��ѣ�����Ҫ�����޻������
	  		 		if(friend_userinfo.praise_other_count==nil)then friend_userinfo.praise_other_count=0 end;
					if(friend_userinfo.curse_other_count==nil)then friend_userinfo.curse_other_count=0 end;
					
					
					--�����ݻ���ӱ��˵���Ϣ			
					if(friend_userinfo.curse_other_count+friend_userinfo.praise_other_count<11)then
					    netlib.send(
					        function(buf)
					            buf:writeString("FRPOPACTIVE")
					            buf:writeInt(userinfo.userId)  --����ID
					            buf:writeString(userinfo.nick or "")
					            buf:writeString(userinfo.face or "")
					            buf:writeInt(share_id)
					            buf:writeInt(smallbet)
					            buf:writeInt(largebet)
					            buf:writeInt(winchouma)
					            buf:writeInt(paixing)
					        end,friend_userinfo.ip,friend_userinfo.port)
				    end    
		        end
		end
	end

end

--��ʼ����ҷ�����Ϣ 
dhomelib.on_after_user_login = function(userinfo)

	local sql="select share_status,share_count from user_dhomeshare_info where user_id=%d group by  share_status" 
	sql=string.format(sql,userinfo.userId)--���ͣ�1����ݣ�
	dblib.execute(sql,function(dt)
		if dt==nil or #dt==0 then return end
		for i=1,#dt do
			if(dt[i].share_status==1)then --�����
				userinfo.praise_count = dt[i].share_count or 0;
			elseif(dt[i].share_status==2)then --������
				userinfo.curse_count = dt[i].share_count or 0;
			elseif(dt[i].share_status==3)then --��ݱ���
				userinfo.praise_other_count = dt[i].share_count or 0;
			elseif(dt[i].share_status==4)then --���ӱ���
				userinfo.curse_other_count = dt[i].share_count or 0;
			end			
		end
	end)
	
end

--�����б�
cmd_userdiy_handler = 
{
   ["TXCHRIGHT"] = dhomelib.on_recv_check_have_right, --�յ�����Ƿ����ʸ�ͨ��԰
   
   ----------------���ݷ���ͳ�ƻ-----------
   ["FRACTIVED"] = dhomelib.onRecvActiveStat, --��������״̬
   ["FRACTIVECOUNT"] = dhomelib.onRecvActiveCount, --��ѯ�����/���ӵĴ���
   ["FRACTIVEWHO"] = dhomelib.onRecvEvaluate, --��ݻ����ĳ��
}

--���ز���Ļص�
for k, v in pairs(cmd_userdiy_handler) do 
	cmdHandler_addons[k] = v
end



