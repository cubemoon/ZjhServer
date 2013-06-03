TraceError("init christmas_activity...")
if not christmasLib then
    christmasLib = _S
    {
    	-------------ʥ��-Ԫ���-------
    
        gettable = NULL_FUNC,--�����������ֶ�ת��Ϊ����
        checker_time_valid = NULL_FUNC,--����Ƿ������֤
        onRecvChristmasActivityStat = NULL_FUNC,--����Ƿ��������
        onRecvGetPlayNumAndBox_ChristmasActivity = NULL_FUNC,--�յ�����������������Ϣ
        onRecvOpenBox_ChristmasActivity = NULL_FUNC,--�յ����������
        onRecvGetPrize_ChristmasActivity = NULL_FUNC,--�յ������ӵ���콱
        doGiveUserGift_ChristmasActivity = NULL_FUNC,--����ҷ���
        ongameover_ChristmasActivity = NULL_FUNC,--ÿ����Ϸ�����ۼ�����
        netSendOpenBox_ChristmasActivity = NULL_FUNC, --֪ͨ�����ӵõ�ʲô��Ʒ
        netSendGiftInfo_ChristmasActivity = NULL_FUNC, --֪ͨ�ͻ����쵽ʲô��Ʒ��
        netSendPlaynumAndBoxs_ChristmasActivity = NULL_FUNC,--���������Ϳ��Կ���������ID
        on_after_user_login=NULL_FUNC,--��½��������
        
        box1_num=20,    --����������
        box2_num=40,    --��������
         
  		statime_christmas = "2011-12-23 00:00:00",  --���ʼʱ��
        endtime_christmas = "2011-12-27 00:00:00",  --�����ʱ��
    }    
 end


--��½��������
christmasLib.on_after_user_login = function(userinfo)
	--TraceError("christmasLib.on_after_user_login")
  --  if(tex_gamepropslib ~= nil) then
   --     tex_gamepropslib.get_props_count_by_id(tex_gamepropslib.PROPS_ID.ShipTickets_ID, userinfo, function(ship_ticket_count) end)
   -- end

	local sql = "insert ignore into user_treasurebox_info (user_id, game_name, login_time, box_info) ";
    sql = sql.."values(%d, '%s', '%s', '1:20:0:0|2:40:0:0');commit; "; --"1:30:0:0|2:60:0:0"��������ʼ���ı���
    
    sql = string.format(sql, userinfo.userId, "tex", timelib.lua_to_db_time(os.time()));
	dblib.execute(sql)
	
	local sql_1 = "select login_time,lj_num from user_treasurebox_info where user_id = %d and game_name = '%s'; "
	sql_1 = string.format(sql_1, userinfo.userId, "tex");
	
	dblib.execute(sql_1,
    function(dt)
    	if dt and #dt > 0 then

    		local sys_today = os.date("%Y-%m-%d", os.time()); --ϵͳ�Ľ���
            local db_date = os.date("%Y-%m-%d", timelib.db_to_lua_time(dt[1]["login_time"]));  --���ݿ�Ľ���
            
            if (db_date ~= sys_today) then
            	userinfo.christmasActivity_openNm = 0;

            else
            	userinfo.christmasActivity_openNm = dt[1]["lj_num"];
            
            end
  
    	else
    		userinfo.christmasActivity_openNm = 0;
    	end
    
    end)
end


--�ַ���ת����table
christmasLib.gettable = function(szboxinfo)
    local newtable = split(szboxinfo, "|");
    local retable ={};
    for _,box in pairs(newtable) do
        if box ~= "" then
            local arr = split(box, ":");
            if(#arr == 4) then
                retable[tonumber(arr[1])] = 
                {
                    neednum = tonumber(arr[2]),
                    opened = tonumber(arr[3]), 
                    prizeid = tonumber(arr[4]),
                };
	        end
        end
    end

    return retable;
end

--�Ƿ�����Чʱ����
function christmasLib.checker_time_valid()	
   local isvalide = true
    if gamepkg.name ~= "tex" then
        isvalide = false
    end
	local starttime = timelib.db_to_lua_time(christmasLib.statime_christmas);
	local endtime = timelib.db_to_lua_time(christmasLib.endtime_christmas);
	local sys_time = os.time()
    if(sys_time < starttime or sys_time > endtime) then
        isvalide = false
	end
    return isvalide
end

--ʥ��״̬
function christmasLib.onRecvChristmasActivityStat(buf)
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end;

	--�жϻ��Ч��
	local retcode = 0;	--��Ч����
    if christmasLib.checker_time_valid() then
        retcode = 1;	--���������
    end
    netlib.send(function(buf)
            buf:writeString("TBHDOK");
            buf:writeInt(retcode);
        end,userinfo.ip,userinfo.port);	
	end

--��Ϸ�����ɼ�����
christmasLib.ongameover_ChristmasActivity = function(userinfo,addgold)
   if not userinfo or not userinfo.desk then return end;

    local gamedata = deskmgr.getuserdata(userinfo);
    if not gamedata.playgameinfo then return end;

    if not christmasLib.checker_time_valid() then
        return;
    end
    
 --   TraceError(" ��Ϸ�����ɼ�����")
    
   if(userinfo.christmasActivity_openNm >= 1 and not viplib.check_user_vip(userinfo))then	-- ��VIP�ɿ�����1��ѭ����2������

		return;    
   elseif(userinfo.christmasActivity_openNm >=2  and viplib.get_vip_level(userinfo) < 4)then  --VIP�ɿ�2��ѭ����4������

       return;
   elseif(userinfo.christmasActivity_openNm >=3  and viplib.get_vip_level(userinfo) >= 4)then  --VIP4.5�ɿ�3��ѭ����6������

       return;
   end
 
   if(addgold > 0)then
        netlib.broadcastdesk(
        function(buf)
            buf:writeString("TBHDPLMOV")
            buf:writeInt(userinfo.site); 
        end
    , userinfo.desk, borcastTarget.all);
   end
   
    local play_num = gamedata.playgameinfo.play_num;
    
     --�޸��ڴ�����
    play_num = play_num + 1;
    gamedata.playgameinfo.play_num = play_num;
    gamedata.playgameinfo.is_show = 1; --����δ���꣬��ʾ��δ��״̬
    local need_show = gamedata.playgameinfo.is_show;
 
    --�ж��Ƿ����������������ﵽ��
    local boxs = gamedata.playgameinfo.boxs;
    local limitNum = 0;
    for k,v in pairs(boxs) do
        if(limitNum < v.neednum) then
            limitNum = v.neednum;
        end
    end
    
    
    
    --�ж�play_num > 40
   	if play_num > 40 then
   	
   		if(not viplib.check_user_vip(userinfo))then
   			return;
   		end
   		
   		--�����������δ������������
    	if(boxs[1].opened == 1 and boxs[2].opened == 1)then
   		
	        play_num = 0;
	        need_show=1;
	        gamedata.playgameinfo.play_num = play_num;
	        
	        local szbox_info = ""
	        
	      
	        --VIP�ٿ�һ��
	        if(viplib.get_vip_level(userinfo) < 4 and userinfo.christmasActivity_openNm <= 2)then  --VIP�ɿ�2��ѭ����4������
				
				szbox_info = "1:"..christmasLib.box1_num..":0:0|2:"..christmasLib.box2_num..":0:0";
	        	 
	        	local lj_num =  userinfo.christmasActivity_openNm;
	        	
		        	local sqltemplet = "update user_treasurebox_info ";
		                sqltemplet = sqltemplet.."set login_time = now(), box_info = '"..szbox_info.."', play_num = 0, need_show = 1, lj_num = "..lj_num;
		                sqltemplet = sqltemplet.." where user_id = %d and game_name = '%s'; commit;";
		                
		                dblib.execute(string.format(sqltemplet, userinfo.userId, gamepkg.name))
		       	
	
	    	elseif(viplib.get_vip_level(userinfo) >= 4 and userinfo.christmasActivity_openNm <= 3)then  --VIP4��5�ɿ�3��ѭ����6������
		
		  		szbox_info = "1:"..christmasLib.box1_num..":0:0|2:"..christmasLib.box2_num..":0:0";
		    		
		    		local lj_num =  userinfo.christmasActivity_openNm;
		    		
		    		local sqltemplet = "update user_treasurebox_info ";
		                sqltemplet = sqltemplet.."set login_time = now(), box_info = '"..szbox_info.."', play_num = 0, need_show = 1, lj_num = "..lj_num;
		                sqltemplet = sqltemplet.." where user_id = %d and game_name = '%s'; commit;";
		                
		                dblib.execute(string.format(sqltemplet, userinfo.userId, gamepkg.name))
		                
		    else
		    	return; 
  
	        end
        
        else
	       	return;
          		
    	end
    	
    else

	   --��¼�����ݿ�

	   local sqltemplet = "update user_treasurebox_info set play_num = %d, need_show = %d, lj_num =%d  where user_id = %d and game_name = '%s'; commit;";
	   local sql=string.format(sqltemplet, play_num, need_show,userinfo.christmasActivity_openNm or 0 , userinfo.userId, gamepkg.name);
	   --TraceError(sql)
	   dblib.execute(sql);

	end
	
	
   --֪ͨ�ͻ���
   christmasLib.netSendPlaynumAndBoxs_ChristmasActivity(userinfo, play_num, boxs, need_show);
   
end

--��������������ID
christmasLib.netSendPlaynumAndBoxs_ChristmasActivity = function(userinfo, playnum, boxs, need_show)
    local boxlist = {};
    for k,v in pairs(boxs) do
        local item = {id = k, neednum = v.neednum, opened = v.opened, prizeid = v.prizeid};
        table.insert(boxlist, item);
    end
    netlib.send(function(buf)
            buf:writeString("TBHDPN");
            buf:writeByte(need_show);
            buf:writeInt(playnum);
            buf:writeByte(#boxlist);
            for i=1,#boxlist do
                buf:writeByte(boxlist[i].id);
                buf:writeInt(boxlist[i].neednum);
                buf:writeByte(boxlist[i].opened);
                buf:writeByte(boxlist[i].prizeid);
            end
        end,userinfo.ip,userinfo.port)
end

--�յ���Ҵ�����
christmasLib.onRecvOpenBox_ChristmasActivity = function(buf)
   local userinfo = userlist[getuserid(buf)];
   if not userinfo then return end;
 
 	--TraceError("�յ���Ҵ�����")
 	
   --�жϻ��Ч��
	if not christmasLib.checker_time_valid() then
       return;--��Ч����
   end
 
   local gamedata = deskmgr.getuserdata(userinfo);
   if not gamedata.playgameinfo then return end;
   
   local boxid = buf:readByte();
   
   if(userinfo.christmasActivity_openNm >= 1 and not viplib.check_user_vip(userinfo))then	-- ��VIP�ɿ�����1��ѭ����2������

		return;    
   elseif(userinfo.christmasActivity_openNm >=2  and viplib.get_vip_level(userinfo) < 4)then  --VIP�ɿ�2��ѭ����4������

       return;
   elseif(userinfo.christmasActivity_openNm >=3  and viplib.get_vip_level(userinfo) >= 4)then  --VIP4.5�ɿ�3��ѭ����6������

       return;
   end
   
   --1.������  2.����
   if boxid ~= 1 and boxid ~= 2 then
     --  TraceError("�յ����������id,������")
       return
   end
   local play_num = gamedata.playgameinfo.play_num;
   local need_show = gamedata.playgameinfo.need_show;
   local boxs = gamedata.playgameinfo.boxs;
   if(boxs[boxid] == nil) then
   --  TraceError("���������["..boxid.."]�����ڴ����["..userinfo.userId.."]");
     return;
   end
   if(gamedata.playgameinfo.play_num < boxs[boxid].neednum) then
  --   TraceError("���������["..boxid.."]��Ҫ��Ϸ["..boxs[boxid].neednum.."]��֮��ſ��Կ���");
     return;
   end
   if(boxs[boxid].opened ~= 0) then
  --   TraceError("���������["..boxid.."]�Ѿ�����");
     return;
   end
   local prizeid = boxs[boxid].prizeid
   if(prizeid <= 0) then
        --������ɽ�ƷID
        local sql = format("call sp_get_random_spring_gift(%d, '%s', %d)", userinfo.userId, "tex", boxid)
 
        dblib.execute(sql, function(dt)
            if(dt and #dt > 0)then
                prizeid = dt[1]["gift_id"]
                local prizename = dt[1]["gift_des"] or ""
                if(prizeid <= 0) then
                    return;
                 end       
                local boxname = "";
                if(boxid == 1) then
                    --boxname = "������";
                    boxname = tex_lan.get_msg(userinfo, "treasure_box_type_silver");
                elseif(boxid == 2) then
                    --boxname = "����";
                    boxname = tex_lan.get_msg(userinfo, "treasure_box_type_gold");
                end
                 
                 --�������ӽ�Ʒ
                 boxs[boxid].prizeid = prizeid;
                 
                 local box_info = "";
                 need_show = 2;
                 for k,v in pairs(boxs) do
                     box_info = box_info ..format("%d:%d:%d:%d|", tostring(k), tostring(v.neednum), tostring(v.opened), tostring(v.prizeid));
                     if v.opened == 0 then
                         need_show = 1;
                     end
                 end
   
              	--��¼��һ��
              	if(boxs[1].opened == 1 and boxs[2].opened == 1)then
              		need_show = 2;--��¼��һ��
              	end
              	
                 gamedata.playgameinfo.need_show = need_show;
                 --��¼�����ݿ�
                 local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d,lj_num =%d where user_id = %d and game_name = '%s'; commit;";
                 dblib.execute(string.format(sqltemplet, box_info, need_show,userinfo.christmasActivity_openNm, userinfo.userId, gamepkg.name));
                 --д����־
                 sqltemplet = "insert into log_treasurebox_prize(user_id, game_name, sys_time, box_id, prize_id) "
                 sqltemplet = sqltemplet.."values(%d,'%s',now(),%d,%d);commit; "
                 --֪ͨ��ҵõ�ʲô��Ʒ
                christmasLib.netSendOpenBox_ChristmasActivity(userinfo, boxid, prizeid);
                christmasLib.netSendPlaynumAndBoxs_ChristmasActivity(userinfo, play_num, boxs, need_show);
            else
          --      TraceError(format("�����Ʒʧ�ܣ�sql=%s",sql))
            end
         end)
    else   
        --֪ͨ��ҵõ�ʲô��Ʒ
        christmasLib.netSendOpenBox_ChristmasActivity(userinfo, boxid, prizeid);
        christmasLib.netSendPlaynumAndBoxs_ChristmasActivity(userinfo, play_num, boxs, need_show);
    end;
end
 
--�յ�����콱��
christmasLib.onRecvGetPrize_ChristmasActivity = function(buf)
--   TraceError("�յ�����콱 _ChristmasActivity")
   local userinfo = userlist[getuserid(buf)];
   if not userinfo then return end;
   --�Ϸ��Լ��
   if not christmasLib.checker_time_valid() then
       return;
   end


	if(not viplib.check_user_vip(userinfo) and userinfo.christmasActivity_openNm >= 1)then

		return; --��VIP�û�һ�ַ���
	elseif(viplib.get_vip_level(userinfo) < 4 and userinfo.christmasActivity_openNm >= 2 )then

		return;	--VIP1-3�û����ַ���
		
	elseif(viplib.get_vip_level(userinfo) >= 4 and userinfo.christmasActivity_openNm >= 3 )then

		return;	--VIP4��5�û����ַ���
	end
 
   local boxid = buf:readByte();
  
   if boxid ~= 1 and boxid ~= 2 then
   --    TraceError("�յ����������id,������");
       return;
   end
   
   --֪ͨ��ҵõ�ʲô��Ʒ
   christmasLib.doGiveUserGift_ChristmasActivity(userinfo, boxid);
  
end

--����ҷ���(������Ϳ�����Ϊ�ǺϷ��콱��)
christmasLib.doGiveUserGift_ChristmasActivity = function(userinfo, boxid)
--	TraceError("����ҷ��� _ChristmasActivity")
    if not christmasLib.checker_time_valid() then
        return;
    end
    
  --  TraceError("����ҷ��� _ChristmasActivity1111111111111")
    if not userinfo then return end;
    local gamedata = deskmgr.getuserdata(userinfo);
    if not gamedata.playgameinfo then return end;
    
    local play_num = gamedata.playgameinfo.play_num;
    local boxs = gamedata.playgameinfo.boxs;
    
    if(boxs[boxid] == nil) then
   --     TraceError("���������["..boxid.."]�����ڴ����["..userinfo.userId.."]");
        return;
    end
    if(gamedata.playgameinfo.play_num < boxs[boxid].neednum) then
   --     TraceError("���������["..boxid.."]��Ҫ��Ϸ["..boxs[boxid].neednum.."]��֮��ſ��Կ���");
        return;
    end
 --   TraceError("����ҷ��� _ChristmasActivity22222222222222")
    if(boxs[boxid].opened ~= 0) then
 --       TraceError("���������["..boxid.."]�Ѿ�����");
        return;
    end
  --  TraceError("����ҷ��� _ChristmasActivity3333333333")
    if(boxs[boxid].prizeid <= 0) then
   --     TraceError("�콱�ˣ����ӵĽ�Ʒ��û���ɣ�����");
        return;
    end
    local prizeid = boxs[boxid].prizeid;
    
    --�������ӿ���
    boxs[boxid].opened = 1;
    
    local need_show = 2;
    local box_info = "";
    for k,v in pairs(boxs) do
        box_info = box_info ..format("%d:%d:%d:%d|", tostring(k), tostring(v.neednum), tostring(v.opened), tostring(v.prizeid));
        if v.opened == 0 then
            need_show = 1;
        end
    end
    
     --1:���ǵ�һ�ֿ�����ϣ�2�����ǵڶ��ֿ������;3:�������
	if(boxs[1].opened == 1 and boxs[2].opened == 1)then

		if(userinfo.christmasActivity_openNm==nil)then 
			userinfo.christmasActivity_openNm=1 
		else
			userinfo.christmasActivity_openNm = userinfo.christmasActivity_openNm + 1;		
		end
		
		local vip_lev = viplib.get_vip_level(userinfo);
		if(not viplib.check_user_vip(userinfo)  )then	-- ��VIP�ɿ�����1��ѭ����2������
        	need_show = 2;
        	--��¼�����ݿ�
	    	local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d,lj_num =%d where user_id = %d and game_name = '%s'; commit;";
	    	dblib.execute(string.format(sqltemplet, box_info, need_show,userinfo.christmasActivity_openNm, userinfo.userId, gamepkg.name));
	    	
	    elseif(viplib.get_vip_level(userinfo) < 4 and userinfo.christmasActivity_openNm <= 1 )then  --VIP�ɿ�2��ѭ����4������
		
	        need_show = 1;
	        play_num = 0
	        gamedata.playgameinfo.play_num = play_num;
	        local lj_num = userinfo.christmasActivity_openNm
	        
	        local szbox_info = ""
 	  			szbox_info = "1:"..christmasLib.box1_num..":0:0|2:"..christmasLib.box2_num..":0:0";
	        	 
		        	local sqltemplet = "update user_treasurebox_info ";
	--	        	TraceError("before:"..sqltemplet)
		                sqltemplet = sqltemplet.."set login_time = now(), box_info = '"..szbox_info.."', play_num = 0, need_show = 1, lj_num = "..lj_num;
	--	            TraceError("after1:"..sqltemplet)
		                sqltemplet = sqltemplet.." where user_id = %d and game_name = '%s'; commit;";
	--	            TraceError("after2:"..sqltemplet)
		                dblib.execute(string.format(sqltemplet, userinfo.userId, gamepkg.name))
			 --��ѯ  
			local strsql = "select * from user_treasurebox_info where user_id = %d and game_name = '%s'; ";
		    dblib.execute(strsql,
		    function(dt)
		        if dt and #dt > 0 then

		                gamedata.playgameinfo.boxs = christmasLib.gettable(dt[1]["box_info"]);
		                gamedata.playgameinfo.play_num = dt[1]["play_num"];
		                gamedata.playgameinfo.login_time = timelib.db_to_lua_time(dt[1]["login_time"]);
		                gamedata.playgameinfo.need_show = dt[1]["need_show"];
		         end
		         
		            boxs = gamedata.playgameinfo.boxs;
		     end)
 
	    elseif(viplib.get_vip_level(userinfo) >= 4 and userinfo.christmasActivity_openNm <= 2)then  --VIP4��5�ɿ�3��ѭ����6������
	    	need_show = 1;
	    	play_num = 0
	        gamedata.playgameinfo.play_num = play_num;
	        
	        local lj_num = userinfo.christmasActivity_openNm
	        
	             local szbox_info = ""
 	  			szbox_info = "1:"..christmasLib.box1_num..":0:0|2:"..christmasLib.box2_num..":0:0";
	        	 
		        	local sqltemplet = "update user_treasurebox_info ";
		                sqltemplet = sqltemplet.."set login_time = now(), box_info = '"..szbox_info.."', play_num = 0, need_show = 1, lj_num = "..lj_num;
		                sqltemplet = sqltemplet.." where user_id = %d and game_name = '%s'; commit;";
		                
		                dblib.execute(string.format(sqltemplet, userinfo.userId, gamepkg.name))
		         --��ѯ       
		         local strsql = "select * from user_treasurebox_info where user_id = %d and game_name = '%s'; ";
			    dblib.execute(strsql,
			    function(dt)
			        if dt and #dt > 0 then
	
			                gamedata.playgameinfo.boxs = christmasLib.gettable(dt[1]["box_info"]);
			                gamedata.playgameinfo.play_num = dt[1]["play_num"];
			                gamedata.playgameinfo.login_time = timelib.db_to_lua_time(dt[1]["login_time"]);
			                gamedata.playgameinfo.need_show = dt[1]["need_show"];
			         end
			         
			            boxs = gamedata.playgameinfo.boxs;
			     end)
		 else
		 	need_show = 2;
		 	--��¼�����ݿ�
	    	local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d, lj_num =%d where user_id = %d and game_name = '%s'; commit;";
	    	dblib.execute(string.format(sqltemplet, box_info, need_show,userinfo.christmasActivity_openNm, userinfo.userId, gamepkg.name));
		            
	    end

	else
	
		--��¼�����ݿ�
   
	    local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d, lj_num =%d where user_id = %d and game_name = '%s'; commit;";
	    	dblib.execute(string.format(sqltemplet, box_info, need_show,userinfo.christmasActivity_openNm, userinfo.userId, gamepkg.name));
	    
	end
    
    gamedata.playgameinfo.need_show = need_show;
 
	    
    --�ɷ���Ʒ��
    if(boxid == 1)then		--������
	    --�ɷ���Ʒ��
	    if(prizeid == 1) then  --200����
	    	--��200����
	      	usermgr.addgold(userinfo.userId, 200, 0, g_GoldType.baoxiang, -1);
	 
	    elseif(prizeid == 2) then  --1K����
	      	--��200����
	      	usermgr.addgold(userinfo.userId, 1000, 0, g_GoldType.baoxiang, -1);
	      	
	    elseif(prizeid == 3) then  --С����
	      	--С������ô��
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, userinfo)
	    elseif(prizeid == 4) then  --5W����
			--��5W����
			usermgr.addgold(userinfo.userId, 50000, 0, g_GoldType.baoxiang, -1);
			
	    elseif(prizeid == 5) then  --�����ʸ�֤��
	      	--�ӷ����ʸ�֤��
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.ShipTickets_ID, 1, userinfo)
	    elseif(prizeid == 6) then  --ʥ��������
	    	--��ʥ��������
	      	gift_addgiftitem(userinfo,9012,userinfo.userId,userinfo.nick, false)
	    else
	  --    TraceError("δ֪����!!!!!!");
	      return;
	    end
	elseif(boxid == 2)then	--����
		if(prizeid == 1) then  --1K����
	    	--��1K����
	      	usermgr.addgold(userinfo.userId, 1000, 0, g_GoldType.baoxiang, -1);
	 
	    elseif(prizeid == 2) then  --1W����
	      	--��1W����
	      	usermgr.addgold(userinfo.userId, 10000, 0, g_GoldType.baoxiang, -1);
	      	
	    elseif(prizeid == 3) then  --T�˿�
	      	--T�˿���ô��
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, userinfo)
	    elseif(prizeid == 4) then  --50W����
			--��50W����
			usermgr.addgold(userinfo.userId, 500000, 0, g_GoldType.baoxiang, -1);
			
	    elseif(prizeid == 5) then  --�����ʸ�֤��
	      	--�ӷ����ʸ�֤��
	      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.ShipTickets_ID, 1, userinfo)
	    elseif(prizeid == 6) then  --ʥ��������
	    	--��ʥ��������
			gift_addgiftitem(userinfo,9013,userinfo.userId,userinfo.nick, false)
		else	--����
	--		TraceError("δ֪����!!!");
		    return;
		end

	end
    
    --֪ͨ����쵽ʲô��Ʒ
 --	TraceError("֪ͨ����쵽ʲô��Ʒ,userinfo"..userinfo.userId.."boxid"..boxid.."prizeid"..prizeid..""); 
    christmasLib.netSendGiftInfo_ChristmasActivity(userinfo, boxid, prizeid);
    christmasLib.netSendPlaynumAndBoxs_ChristmasActivity(userinfo, play_num, boxs, need_show);
end

--֪ͨ��ҵõ�ʲô��Ʒ
christmasLib.netSendOpenBox_ChristmasActivity = function(userinfo, boxid, prizeid)
--	TraceError("֪ͨ��ҵõ�ʲô��Ʒ_ChristmasActivity")
    netlib.send(function(buf)
            buf:writeString("TBHDOB");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
        end,userinfo.ip,userinfo.port);
end

--֪ͨ����쵽ʲô��Ʒ
christmasLib.netSendGiftInfo_ChristmasActivity = function(userinfo, boxid, prizeid)
--	TraceError("֪ͨ����쵽ʲôʲôʲô��Ʒ _ChristmasActivity")
    netlib.send(function(buf)
            buf:writeString("TBHDGP");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
            buf:writeByte(userinfo.christmasActivity_openNm or 0);-- : 1:���ǵ�һ�ֿ�����ϣ�2�����ǵڶ��ֿ������;3:�������
        end,userinfo.ip,userinfo.port);
end

--�յ�����������������
christmasLib.onRecvGetPlayNumAndBox_ChristmasActivity = function(buf)
   -- TraceError("�յ����������������� ChristmasActivity");
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    
    if not christmasLib.checker_time_valid() then
        return;
    end
    
    if(not viplib.check_user_vip(userinfo) and userinfo.christmasActivity_openNm >= 1)then
		
		return; --��VIP�û�һ�ַ���
	elseif(viplib.get_vip_level(userinfo) < 4 and userinfo.christmasActivity_openNm >= 2 )then

		return;	--VIP1-3�û����ַ���
		
	elseif(viplib.get_vip_level(userinfo) >= 4 and userinfo.christmasActivity_openNm >= 3 )then

		return;	--VIP4��5�û����ַ���
	end
     
    local szbox_info = ""
  
    szbox_info = "1:"..christmasLib.box1_num..":0:0|2:"..christmasLib.box2_num..":0:0";
 
    sqltemplet = "select login_time,box_info,play_num,need_show,lj_num from user_treasurebox_info where user_id = %d and game_name = '%s'; ";
    
    local userid = userinfo.userId;
    local gamename = gamepkg.name;

    local strsql = string.format(sqltemplet, userid, gamename);
    dblib.execute(strsql,
    function(dt)
        if dt and #dt > 0 then
        --TraceError("�յ����������������� ChristmasActivity1111111111111111");
            local gamedata = deskmgr.getuserdata(userinfo);
            local lj_num = 0
            --д���ڴ�����
            gamedata.playgameinfo = {}
            local sys_today = os.date("%Y-%m-%d", os.time()); --ϵͳ�Ľ���
            local db_date = os.date("%Y-%m-%d", timelib.db_to_lua_time(dt[1]["login_time"]));  --���ݿ�Ľ���
            if (db_date ~= sys_today) then
            --TraceError("�յ����������������� ChristmasActivity22222222222222");
                gamedata.playgameinfo.boxs = {};
                gamedata.playgameinfo.boxs[1] = {neednum = christmasLib.box1_num, opened = 0, prizeid = 0};
                gamedata.playgameinfo.boxs[2] = {neednum = christmasLib.box2_num, opened = 0, prizeid = 0};
                gamedata.playgameinfo.play_num = 0;
                gamedata.playgameinfo.login_time = os.time();
                gamedata.playgameinfo.need_show = 1;

                local sqltemplet = "update user_treasurebox_info ";
                sqltemplet = sqltemplet.."set login_time = now(), box_info = '"..szbox_info.."', play_num = 0, need_show = 1, lj_num = "..lj_num;
                sqltemplet = sqltemplet.." where user_id = %d and game_name = '%s'; commit;";
                
                dblib.execute(string.format(sqltemplet, userid, gamename))
            else
                gamedata.playgameinfo.boxs = christmasLib.gettable(dt[1]["box_info"]);
                gamedata.playgameinfo.play_num = dt[1]["play_num"];
                gamedata.playgameinfo.login_time = timelib.db_to_lua_time(dt[1]["login_time"]);
                gamedata.playgameinfo.need_show = dt[1]["need_show"];
                userinfo.christmasActivity_openNm=dt[1]["lj_num"];
            end
            local playnum = gamedata.playgameinfo.play_num;
            local boxs = gamedata.playgameinfo.boxs;
            local need_show = gamedata.playgameinfo.need_show;
            christmasLib.netSendPlaynumAndBoxs_ChristmasActivity(userinfo, playnum, boxs, need_show);
        else
  --          TraceError(" ��ѯ���ݿ�ʱ����:" .. strsql);
        end
    end)
end


--�����б�
cmdHandler = 
{
    ["TBHDOK"] = christmasLib.onRecvChristmasActivityStat, --��ѯ��Ƿ������
    ["TBHDPN"] = christmasLib.onRecvGetPlayNumAndBox_ChristmasActivity, -- �յ���½�ɹ�
    ["TBHDOB"] = christmasLib.onRecvOpenBox_ChristmasActivity, -- �յ������ӣ������Ʒ
    ["TBHDGP"] = christmasLib.onRecvGetPrize_ChristmasActivity, -- �յ���ȡ����
 
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

