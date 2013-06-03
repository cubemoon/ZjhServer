TraceError("init treasure_box...")
if zadanlib and zadanlib.ongameover then 
	eventmgr:removeEventListener("on_game_over_event", zadanlib.ongameover);
end

if zadanlib and zadanlib.restart_server then
	eventmgr:removeEventListener("on_server_start", zadanlib.restart_server);
end

if zadanlib and zadanlib.timer then
	eventmgr:removeEventListener("timer_second", zadanlib.timer);
end

if zadanlib and zadanlib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", zadanlib.on_user_exit);
end
if not zadanlib then
    zadanlib = _S
    {
    	--�����Ƿ���
        gettable = NULL_FUNC,--�����������ֶ�ת��Ϊ����
        checker_time_valid = NULL_FUNC,--����Ƿ������֤
        On_Recv_Check_HuoDong = NULL_FUNC,--����Ƿ��������
        On_Recv_Get_PlayNumAndBox = NULL_FUNC,--�յ�����������������Ϣ
        On_Recv_Open_Box = NULL_FUNC,--�յ����������
        On_Recv_Get_Prize = NULL_FUNC,--�յ������ӵ���콱
        do_give_user_gift = NULL_FUNC,--����ҷ���
        ongameover = NULL_FUNC,--ÿ����Ϸ�����ۼ�����
        net_send_open_box = NULL_FUNC, --֪ͨ�����ӵõ�ʲô��Ʒ
        net_send_gift_info = NULL_FUNC, --֪ͨ�ͻ����쵽ʲô��Ʒ��
        net_send_playnum_and_boxs = NULL_FUNC,--���������Ϳ��Կ���������ID
        count_pan = NULL_FUNC, --ͳ������
        is_valid_site = NULL_FUNC, --�ж��ǲ��Ǻ��ʵ�վ��
        add_zw = NULL_FUNC, --������ֵ
        init_zw_info = NULL_FUNC, --��ʼ��������Ϣ
        timer = NULL_FUNC, --��ʱ��
        send_zw_list = NULL_FUNC, --�������б��������
        send_user_zw_info = NULL_FUNC, --�������б��ĳ����
        update_zw_list = NULL_FUNC, --���¸��������ϵ�����
        restart_server = NULL_FUNC, --����������ʱ��֮ǰ���������ж�����
        zw_fajiang = NULL_FUNC, --��������
        init_zw_pm_from_db = NULL_FUNC, --��ʼ����������
        on_user_exit = NULL_FUNC, --����뿪��
        
        --�����Ǳ�����������Ϣ
        box1_num=20,    --����������
        box2_num=40,    --��������
        CFG_PLAY_COUNT = 5, --Ҫ������һ�������ɼ�
        
        valid_site_no = -1, --��360�ϸ����������-1����ȫ��  360��104
        
        smallbet = 100,  --Сäע����
        start_time = "2012-07-28 09:00:00",
        end_time = "2012-08-12 23:59:59",
        CFG_FAJIANG_TIME = "2012-08-12 23:59:59",
        CFG_ZW_REWARD = { --����ֵ����
        	[1] = 1,
        	[2] = 2,
        	[3] = 5,
        	[4] = 4,
        	[5] = 3,
        	[6] = 6,
        	[7] = 7,
        	[8] = 9,
        	[9] = 10,
        	[10] = 8,
        	
        },
        CFG_GAME_ROOM = 18001,
        user_list = {},
        king_zw_list = {},--�������а��ϰ����
        CFG_ZW_LEN = 10, --�������а�ĳ���
        notify_zw_info = 0, --ˢ��������Ϣ
        CFG_JP_DESC = { --��Ʒ����
        	[1] = "��ɯ����",
        	[2] = "�µ�A8L",
        	[3] = "�׿ǳ�",
        	[4] = "��������ʿ",
        	[5] = "��������ʿ",
        	[6] = "������",
        	[7] = "������",
        	[8] = "������",
        	[9] = "������",
        	[10] = "������",
        },
        CFG_JP = { --��Ʒ
        	[1] = 5021,
        	[2] = 5011,
        	[3] = 5012,
        	[4] = 5030,
        	[5] = 5030,
        	[6] = 5031,
        	[7] = 5031,
        	[8] = 5031,
        	[9] = 5031,
        	[10] = 5031,
        },
    }    
 end
 
 --���ĸ�վ���
 zadanlib.is_valid_site = function(user_info)
 	if(zadanlib.valid_site_no~=-1 and user_info.nRegSiteNo~=zadanlib.valid_site_no)then
 		return false
 	end
 	return true
 end
 
--�ж���Ϸ��ʱ��Ϸ���
zadanlib.checker_time_valid = function()
	
    local isvalide = true
    if gamepkg.name ~= "tex" then
        isvalide = false
    end
	local starttime = timelib.db_to_lua_time(zadanlib.start_time);
	local endtime = timelib.db_to_lua_time(zadanlib.end_time);
	local sys_time = os.time()
    if(sys_time < starttime or sys_time > endtime) then
        isvalide = false
	end
    return isvalide
end

--�ַ���ת����table
zadanlib.gettable = function(szboxinfo)
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
	        else
	            TraceError("ʲô����ѽ����?"..box);
	        end
        end
    end

    return retable;
end

--�յ���ѯ��Ƿ������,0û�н���,1������
zadanlib.On_Recv_Check_HuoDong = function(buf)
    --TraceError("On_Recv_Check_HuoDong");
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    local user_id = userinfo.userId

    local retcode = 0;
    if zadanlib.checker_time_valid() and zadanlib.is_valid_site(userinfo) then
        retcode = 1;
    end
    
    zadanlib.init_zw_info(user_id)
    netlib.send(function(buf)
            buf:writeString("TBHDOK");
            buf:writeInt(retcode);
        end,userinfo.ip,userinfo.port);
end

--�յ�����������������
zadanlib.On_Recv_Get_PlayNumAndBox = function(buf)
    --TraceError("On_Recv_Get_PlayNumAndBox");
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    
    --if not zadanlib.checker_time_valid() then
    --    return;
    --end
    
    if not zadanlib.is_valid_site(userinfo) then
        return;
    end
    
    if(not userinfo.desk) then return end;
    --500��������
    --if(desklist[userinfo.desk].smallbet < zadanlib.smallbet) then return end;
    --��VIPֻ�ܿ�������
    local szbox_info = "1:"..zadanlib.box1_num..":0:0|2:"..zadanlib.box2_num..":0:0";
    --if(not viplib.check_user_vip(userinfo))then
   --     szbox_info = "1:"..zadanlib.box1_num..":0:0|2:"..zadanlib.box2_num..":0:0";
   -- else
    --    szbox_info = "1:"..zadanlib.box1_num..":0:0|2:"..zadanlib.box2_num..":0:0";
    --end
   
    local sqltemplet = "insert ignore into user_treasurebox_info (user_id, game_name, login_time, box_info) ";
    sqltemplet = sqltemplet.."values(%d, '%s', now(), '"..szbox_info.."');commit; ";
    sqltemplet = sqltemplet.."select * from user_treasurebox_info where user_id = %d and game_name = '%s'; ";
    
    local userid = userinfo.userId;
    local gamename = gamepkg.name;

    local strsql = string.format(sqltemplet, userid, gamename, userid, gamename);
    dblib.execute(strsql,
    function(dt)
        if dt and #dt > 0 then
            local gamedata = deskmgr.getuserdata(userinfo);
            --д���ڴ�����
            gamedata.playgameinfo = {}
            local sys_today = os.date("%Y-%m-%d", os.time()); --ϵͳ�Ľ���
            local db_date = os.date("%Y-%m-%d", timelib.db_to_lua_time(dt[1]["login_time"]));  --���ݿ�Ľ���
            if (db_date ~= sys_today) then
                gamedata.playgameinfo.boxs = {};
                gamedata.playgameinfo.boxs[1] = {neednum = zadanlib.box1_num, opened = 0, prizeid = 0};
                gamedata.playgameinfo.boxs[2] = {neednum = zadanlib.box2_num, opened = 0, prizeid = 0};
                gamedata.playgameinfo.play_num = 0;
                gamedata.playgameinfo.login_time = os.time();
                gamedata.playgameinfo.need_show = 1;
                --if(not viplib.check_user_vip(userinfo))then
                --gamedata.playgameinfo.boxs[2].opened = 1;
                --end
                local sqltemplet = "update user_treasurebox_info ";
                sqltemplet = sqltemplet.."set login_time = now(), box_info = '"..szbox_info.."', play_num = 0, need_show = 1 ";
                sqltemplet = sqltemplet.."where user_id = %d and game_name = '%s'; commit;";
                
                dblib.execute(string.format(sqltemplet, userid, gamename))
            else
                gamedata.playgameinfo.boxs = zadanlib.gettable(dt[1]["box_info"]);
                gamedata.playgameinfo.play_num = dt[1]["play_num"];
                gamedata.playgameinfo.login_time = timelib.db_to_lua_time(dt[1]["login_time"]);
                gamedata.playgameinfo.need_show = dt[1]["need_show"];
            end
            local playnum = gamedata.playgameinfo.play_num;
            local boxs = gamedata.playgameinfo.boxs;
            local need_show = gamedata.playgameinfo.need_show;
            zadanlib.net_send_playnum_and_boxs(userinfo, playnum, boxs, need_show);
        else
            TraceError(" ��ѯ���ݿ�ʱ����:" .. strsql);
        end
    end)
    zadanlib.send_user_zw_info(userinfo)
end

--��Ϸ�����ɼ�����
zadanlib.count_pan = function(userinfo)
    if not userinfo or not userinfo.desk then return end;
    local gamedata = deskmgr.getuserdata(userinfo);
    if not gamedata.playgameinfo then return end;
    if not zadanlib.checker_time_valid() then
        return;
    end
    local play_num = gamedata.playgameinfo.play_num;
    --���������vip������
    --if (play_num >= 30 and viplib.check_user_vip(userinfo) ~= true) then return end

    --Сä���ڵ���500�������湻5���˾Ϳ����ۼƱ�������
	--TODO:���߸ĳ�9����
    local deskinfo = desklist[userinfo.desk]
    local play_count = deskinfo.playercount
	--if(play_count < 5 or deskinfo.smallbet < zadanlib.smallbet) then
	if(play_count < zadanlib.CFG_PLAY_COUNT) then
		return
    end
    --�ж��Ƿ����������������ﵽ��
    local boxs = gamedata.playgameinfo.boxs;
    local limitNum = 0;
    for k,v in pairs(boxs) do
        if(limitNum < v.neednum) then
            limitNum = v.neednum;
        end
    end
    if play_num >= limitNum then
        return;
    end

    --�޸��ڴ�����
    play_num = play_num + 1;
    gamedata.playgameinfo.play_num = play_num;
    gamedata.playgameinfo.is_show = 1; --����δ���꣬��ʾ��δ��״̬
    local need_show = gamedata.playgameinfo.is_show;

   --��¼�����ݿ�
   local sqltemplet = "update user_treasurebox_info set play_num = %d, need_show = %d where user_id = %d and game_name = '%s'; commit;";
   dblib.execute(string.format(sqltemplet, play_num, need_show, userinfo.userId, gamepkg.name));

   --֪ͨ�ͻ���
   zadanlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
end

zadanlib.ongameover = function(e)
	local userinfo = e.data.user_info
	zadanlib.count_pan(userinfo) 
end

--��������������ID
zadanlib.net_send_playnum_and_boxs = function(userinfo, playnum, boxs, need_show)
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
zadanlib.On_Recv_Open_Box = function(buf)
   local userinfo = userlist[getuserid(buf)];
   if not userinfo then return end;
   --�Ϸ��Լ��
   if not zadanlib.checker_time_valid() then
       return;
   end

   if(not userinfo.desk) then return end;
    --100/200��������
    --Сä���ڵ���100�������湻9���˾Ϳ����ۼƱ�������
	--TODO:���߸ĳ�9����
    local deskinfo = desklist[userinfo.desk]
	--if(deskinfo.smallbet < zadanlib.smallbet) then
	--	return
    --end

   local gamedata = deskmgr.getuserdata(userinfo);
   if not gamedata.playgameinfo then return end;
   
   local boxid = buf:readByte();
    --��VIPֻ�ܿ�������
    --if(boxid > 1 and not viplib.check_user_vip(userinfo))then
    --    return;
   -- end
   if boxid ~= 1 and boxid ~= 2 then
       TraceError("�յ����������id,������")
       return
   end
   local play_num = gamedata.playgameinfo.play_num;
   local need_show = gamedata.playgameinfo.need_show;
   local boxs = gamedata.playgameinfo.boxs;
   if(boxs[boxid] == nil) then
     TraceError("���������["..boxid.."]�����ڴ����["..userinfo.userId.."]");
     return;
   end
   if(gamedata.playgameinfo.play_num < boxs[boxid].neednum) then
     TraceError("���������["..boxid.."]��Ҫ��Ϸ["..boxs[boxid].neednum.."]��֮��ſ��Կ���");
     return;
   end
   if(boxs[boxid].opened ~= 0) then
     TraceError("���������["..boxid.."]�Ѿ�����");
     return;
   end
   local prizeid = boxs[boxid].prizeid
   if(prizeid <= 0) then
        --������ɽ�ƷID
        local sql = format("call sp_get_random_zadan_gift(%d, '%s', %d)", userinfo.userId, "tex", boxid)
        dblib.execute(sql, function(dt)
            if(dt and #dt > 0)then
                --TraceError(dt)
                --TraceError(sql)
                prizeid = dt[1]["gift_id"]
                local prizename = dt[1]["gift_des"] or ""
                if(prizeid <= 0) then
                    TraceError(format("���ɽ�Ʒʧ��!prizeid=%d", prizeid));
                    return;
                 end       
                local boxname = "";
                if(boxid == 1) then
                    --boxname = "�����ʵ�";
                    boxname = tex_lan.get_msg(userinfo, "za_dan_type_primary");
                elseif(boxid == 2) then
                    --boxname = "�߼��ʵ�";
                    boxname = tex_lan.get_msg(userinfo, "za_dan_type_advance");
                end

                
                --�õ�vip�ĲŹ㲥
                --if(prizeid == 4 or prizeid == 8 or prizeid==9) then                
                --    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "za_dan_msg_1"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "za_dan_msg_2")..boxname..tex_lan.get_msg(userinfo, "za_dan_msg_3"))..prizename.._U(tex_lan.get_msg(userinfo, "za_dan_msg_4")),0);
                --end
                 
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
                 --��VIPֻ�ܿ�������
                 --if(boxs[boxid].opened == 1 and not viplib.check_user_vip(userinfo))then
                 --    need_show = 2;
                 --end
                 gamedata.playgameinfo.need_show = need_show;
                 --��¼�����ݿ�
                 local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d where user_id = %d and game_name = '%s'; commit;";
                 dblib.execute(string.format(sqltemplet, box_info, need_show, userinfo.userId, gamepkg.name));
                 --д����־
                 sqltemplet = "insert into log_treasurebox_prize(user_id, game_name, sys_time, box_id, prize_id) "
                 sqltemplet = sqltemplet.."values(%d,'%s',now(),%d,%d);commit; "
                 --dblib.execute(string.format(sqltemplet, userinfo.userId, gamepkg.name, boxid, prizeid));
                 --֪ͨ��ҵõ�ʲô��Ʒ
                zadanlib.net_send_open_box(userinfo, boxid, prizeid, zadanlib.CFG_ZW_REWARD[prizeid]);
                zadanlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
            else
                TraceError(format("�����Ʒʧ�ܣ�sql=%s",sql))
            end
         end)
    else   
        --֪ͨ��ҵõ�ʲô��Ʒ
        zadanlib.net_send_open_box(userinfo, boxid, prizeid, zadanlib.CFG_ZW_REWARD[prizeid]);
        zadanlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
    end;
end

--�յ�����콱��
zadanlib.On_Recv_Get_Prize = function(buf)
   --TraceError("On_Recv_Get_Prize")
   local userinfo = userlist[getuserid(buf)];
   if not userinfo then return end;
   --�Ϸ��Լ��
   if not zadanlib.checker_time_valid() then
       return;
   end

   if(not userinfo.desk) then return end;
   --100/200��������
  -- if(desklist[userinfo.desk].smallbet < zadanlib.smallbet) then return end;

   local gamedata = deskmgr.getuserdata(userinfo);
   if not gamedata.playgameinfo then return end;
   
   local boxid = buf:readByte();

   if boxid ~= 1 and boxid ~= 2 then
       TraceError("�յ����������id,������");
       return;
   end
   
   --֪ͨ��ҵõ�ʲô��Ʒ
   zadanlib.do_give_user_gift(userinfo, boxid);
   --ˢ������������״̬
   local play_num = gamedata.playgameinfo.play_num;
   local need_show = gamedata.playgameinfo.need_show;
   local boxs = gamedata.playgameinfo.boxs;
   zadanlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
end

--����ҷ���(������Ϳ�����Ϊ�ǺϷ��콱��)
zadanlib.do_give_user_gift = function(userinfo, boxid)
    if not zadanlib.checker_time_valid() then
        return;
    end
    
    if not userinfo then return end;
    local gamedata = deskmgr.getuserdata(userinfo);
    if not gamedata.playgameinfo then return end;
    
    local play_num = gamedata.playgameinfo.play_num;
    local boxs = gamedata.playgameinfo.boxs;
    
    if(boxs[boxid] == nil) then
        TraceError("���������["..boxid.."]�����ڴ����["..userinfo.userId.."]");
        return;
    end
    if(gamedata.playgameinfo.play_num < boxs[boxid].neednum) then
        TraceError("���������["..boxid.."]��Ҫ��Ϸ["..boxs[boxid].neednum.."]��֮��ſ��Կ���");
        return;
    end
    
    if(boxs[boxid].opened ~= 0) then
        --TraceError("���������["..boxid.."]�Ѿ�����");
        return;
    end
    
    if(boxs[boxid].prizeid <= 0) then
        TraceError("�콱�ˣ����ӵĽ�Ʒ��û���ɣ�����");
        return;
    end
    local prizeid = boxs[boxid].prizeid;
    
    --�������ӿ���
    boxs[boxid].opened = 1;
    
    local need_show = 2;
    local box_info = "";
    for k,v in pairs(boxs) do
        box_info = box_info ..format("%d:%d:%d:%d|", tostring(k), tostring(v.neednum), tostring(v.opened), tostring(v.prizeid));
        --if v.opened == 0 and viplib.check_user_vip(userinfo) then
        if v.opened == 0 then
            need_show = 1;
        end
    end
    
    gamedata.playgameinfo.need_show = need_show;
    --��¼�����ݿ�
    local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d where user_id = %d and game_name = '%s'; commit;";
    dblib.execute(string.format(sqltemplet, box_info, need_show, userinfo.userId, gamepkg.name));
    local sql = ""
    --�ɷ���Ʒ��
    if(prizeid == 1) then  --100����
      	usermgr.addgold(userinfo.userId, 100, 0, g_GoldType.baoxiang, -1);
    elseif(prizeid == 2) then  --300����
      	usermgr.addgold(userinfo.userId, 300, 0, g_GoldType.baoxiang, -1);
    elseif(prizeid == 3) then  --3000����
      	usermgr.addgold(userinfo.userId, 3000, 0, g_GoldType.baoxiang, -1);
    elseif(prizeid == 4) then  --ͭ����Ա��3��
    	viplib.add_user_vip(userinfo,1,3)
    elseif(prizeid == 5) then  --����ҩˮ20��
    	usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), 20, g_ExpType.jhm_huodong, groupinfo.groupid);
    elseif(prizeid == 6) then  --500����
      usermgr.addgold(userinfo.userId, 500, 0, g_GoldType.baoxiang, -1);
    elseif(prizeid == 7) then  --10000����
      usermgr.addgold(userinfo.userId, 10000, 0, g_GoldType.baoxiang, -1);
    elseif(prizeid == 8) then  --ͭ����Ա��10��
    	viplib.add_user_vip(userinfo,1,10)
    elseif(prizeid == 9) then	-- ������Ա��5��
    	viplib.add_user_vip(userinfo,2,5)	  	
	elseif(prizeid == 10) then	--��С����
		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, userinfo);
    else
      TraceError("δ֪��prizeid["..prizeid.."]!!!");
      return;
    end
    
    if prizeid >= 1 and prizeid <= 10 then
    	zadanlib.add_zw(userinfo, zadanlib.CFG_ZW_REWARD[prizeid])
    end
    --֪ͨ����쵽ʲô��Ʒ
    zadanlib.net_send_gift_info(userinfo, boxid, prizeid, zadanlib.CFG_ZW_REWARD[prizeid]);
end

--֪ͨ��ҵõ�ʲô��Ʒ
--//1:100����,2:300����,3:500����,4:3000����,5:1W����,6:ͭ��VIP,7:��VIP,8:С����X1,9:С����X3��10:���˿�X2
zadanlib.net_send_open_box = function(userinfo, boxid, prizeid, zw_count)
    netlib.send(function(buf)
            buf:writeString("TBHDOB");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
            buf:writeInt(zw_count);
        end,userinfo.ip,userinfo.port);
end

--֪ͨ����쵽ʲô��Ʒ
--//1:100����,2:300����,3:500����,4:3000����,5:1W����,6:ͭ��VIP,7:��VIP,8:С����X1,9:С����X3��10:���˿�X2
zadanlib.net_send_gift_info = function(userinfo, boxid, prizeid, zw_count)
    netlib.send(function(buf)
            buf:writeString("TBHDGP");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
            buf:writeInt(zw_count);
        end,userinfo.ip,userinfo.port);
end

--��ĳ����Ҽ�����ֵ
function zadanlib.add_zw(user_info, zw_count)
    local send_to_gs = function(buf)
		buf:writeString("TBHDGS")
        buf:writeInt(user_id)
        buf:writeString(nick_name)
      	buf:writeInt(zw_count)
    end
    
    --ʱ�䵽�˾Ͳ�Ҫ�ټ�������
	if os.time() > timelib.db_to_lua_time(zadanlib.end_time) then return end
	local user_id = user_info.userId
	local nick_name = string.trans_str(user_info.nick)
	zadanlib.user_list[user_id].zw_count = zadanlib.user_list[user_id].zw_count + zw_count
	local sql = "insert into user_olympic_info(user_id, zw_count, nick_name, sys_time) value (%d, %d, '%s', now()) on duplicate key update zw_count = zw_count + %d, nick_name = '%s', sys_time=now();"
	sql = string.format(sql, user_id, zw_count, nick_name, zw_count, nick_name)
	dblib.execute(sql, function(dt) end, user_id)
	
	--���¸��������ϵ�����
	--zadanlib.update_zw_list(user_id, nick_name, zadanlib.user_list[user_id].zw_count)
	--local min_zw = 0
	--if #zadanlib.king_zw_list > 0 then
	--	min_zw = zadanlib.king_zw_list[#zadanlib.king_zw_list].zw_count --���һ��������ֵ
	--end
	zadanlib.update_zw_list(user_id, nick_name, zadanlib.user_list[user_id].zw_count)
end

--��������
function zadanlib.update_zw_list(user_id, nick_name, zw_count)

	--���������б��ǰ15��
	local min_zw = 0
	if #zadanlib.king_zw_list > 0 then
		min_zw = zadanlib.king_zw_list[#zadanlib.king_zw_list].zw_count --���һ��������ֵ
	end
	
	if zw_count > min_zw or  #zadanlib.king_zw_list < zadanlib.CFG_ZW_LEN then
		local buf_tab = {
			["user_id"] = user_id,
			["nick_name"] = nick_name,
			["zw_count"] = zw_count,
		}
		local is_finder = 0
		for k,v in pairs (zadanlib.king_zw_list) do 
			if v.user_id == user_id then
				is_finder = 1
				v.nick_name = nick_name
				v.zw_count = zw_count
				break
			end
		end
		if is_finder == 0 then
			table.insert(zadanlib.king_zw_list, buf_tab)
		end
		table.sort(zadanlib.king_zw_list,
			function(a, b)
				     return a.zw_count > b.zw_count		                   
			end)

		 
		if #zadanlib.king_zw_list > zadanlib.CFG_ZW_LEN then
			table.remove(zadanlib.king_zw_list, #zadanlib.king_zw_list)
		end 
		zadanlib.notify_zw_info = 1
	end
end

--��ʼ����ҵ�������Ϣ
function zadanlib.init_zw_info(user_id, call_back)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	if zadanlib.user_list[user_id] == nil then zadanlib.user_list[user_id] = {} end
	local sql = "select zw_count, already_notify from user_olympic_info where user_id = %d"
	sql = string.format(sql, user_id)
	dblib.execute(sql, function(dt)
	
		zadanlib.user_list[user_id].user_id = user_id
		if dt and #dt > 0 then
			zadanlib.user_list[user_id].zw_count = dt[1].zw_count
			zadanlib.user_list[user_id].already_notify = dt[1].already_notify
		else
			zadanlib.user_list[user_id].zw_count = 0 
			zadanlib.user_list[user_id].already_notify = 0
		end
		
		if os.time() > timelib.db_to_lua_time(zadanlib.end_time) then
			local mc = -1
			for i=1, #zadanlib.king_zw_list do
				if zadanlib.king_zw_list[i].user_id == user_id then
					mc = i
					break
				end
			end 
			if mc > 0 and zadanlib.user_list[user_id].already_notify ==0 then
				zadanlib.send_reward_msg(user_id, mc)
			end
		end
		if call_back~= nil then
			call_back(user_info, zadanlib.user_list[user_id].zw_count)
		end
	end, user_id)
end

function zadanlib.timer(e)
	local now_time = timelib.lua_to_db_time(e.data.time)
	
	if now_time == zadanlib.CFG_FAJIANG_TIME then
		--�����ݿ�����������һ����������ֹ��С����ʱ�����ҵ�����ֵ��ͬ����ʱҪ�����ʱ��������˭�ϰ�
		if zadanlib.CFG_GAME_ROOM == tonumber(groupinfo.groupid) then
			zadanlib.init_zw_pm_from_db(1)

		end
	end
	
	--�������б�
	if zadanlib.notify_zw_info == 1 then
		zadanlib.notify_zw_info = 0
		zadanlib.send_zw_list()
	end
end

----�������б��������
function zadanlib.send_zw_list()
	for k, v in pairs (zadanlib.user_list) do
		local user_info = usermgr.GetUserById(v.user_id)
		if user_info ~= nil then
			zadanlib.send_user_zw_info(user_info)		
		end
	end
end

--"TBHDZW" ��ĳ����ҷ���������
--int my_zw 
--int len
--for 
--String �ǳ�
--int ����ֵ
--end
function zadanlib.send_user_zw_info(user_info)
	local send_result = function(user_info, my_zw_count)
		netlib.send(function(buf)
		    buf:writeString("TBHDZW")
		    buf:writeInt(my_zw_count or 0)
		    buf:writeInt(zadanlib.CFG_ZW_LEN)
		    		
		    for i = 1, zadanlib.CFG_ZW_LEN do
		    	local nick_name = "--"
		    	local zw_count = 0
		    	if zadanlib.king_zw_list[i] ~= nil then
		    		nick_name = zadanlib.king_zw_list[i].nick_name
		    		zw_count = zadanlib.king_zw_list[i].zw_count
		    	end
		    	
		    	buf:writeString(nick_name)
		    	buf:writeInt(zw_count)	
				buf:writeString(_U(zadanlib.CFG_JP_DESC[i]))	
		    end
    	end,user_info.ip,user_info.port)   
	end
	
	local user_id = user_info.userId
	local zw_count = 0
	if zadanlib.user_list[user_id] == nil or zadanlib.user_list[user_id].zw_count == nil then
		zadanlib.init_zw_info(user_id, send_result)
	else
		zw_count = zadanlib.user_list[user_id].zw_count
		send_result(user_info, zw_count)
	end
	
end

--����������
function zadanlib.restart_server()
	zadanlib.init_zw_pm_from_db(0)
end

function zadanlib.init_zw_pm_from_db(need_fajiang)
	zadanlib.king_zw_list = {}
	local sql = "select user_id,zw_count,nick_name from user_olympic_info order by zw_count desc,sys_time limit %d"
	sql = string.format(sql, zadanlib.CFG_ZW_LEN)
	dblib.execute(sql,function(dt)
		if dt and #dt > 0 then
			for i = 1, #dt do
				local buf_tab = {
					["user_id"] = dt[i].user_id,
					["nick_name"] = dt[i].nick_name,
					["zw_count"] = dt[i].zw_count,
				}
				table.insert(zadanlib.king_zw_list, buf_tab)
			end
			if need_fajiang == 1 then
				zadanlib.zw_fajiang()
				zadanlib.send_zw_list()
			end
		end
	end)
end

--
--TBHDJP
--byte ����
--string ��Ʒ
function zadanlib.send_reward_msg(user_id, mc)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	
	netlib.send(function(buf)
        buf:writeString("TBHDJP");
        buf:writeByte(mc);
        buf:writeString(_U(zadanlib.CFG_JP_DESC[mc]));
	end, user_info.ip, user_info.port)
	
	local sql = "update user_olympic_info set already_notify = 1 where user_id = %d"
	sql = string.format(sql, user_id)
	dblib.execute(sql, function(dt) end, user_id)
end

--����
function zadanlib.zw_fajiang()
	
	local sql = "select user_id,zw_count,nick_name from user_olympic_info order by zw_count desc,sys_time limit %d"
	sql = string.format(sql, zadanlib.CFG_ZW_LEN)
	dblib.execute(sql, function(dt)
		if dt and #dt > 0 then
			for i = 1, #dt do
				car_match_db_lib.add_car(dt[i].user_id, zadanlib.CFG_JP[i], 0)
				zadanlib.send_reward_msg(dt[i].user_id, i)
			end
		end
	end)	
end

--����뿪��
function zadanlib.on_user_exit(e)
	local user_id = e.data.user_id
	if zadanlib.user_list[user_id] ~= nil then
		zadanlib.user_list[user_id] = nil
	end
end


--�����б�
cmdHandler = 
{
    ["TBHDOK"] = zadanlib.On_Recv_Check_HuoDong, --��ѯ��Ƿ������
    ["TBHDPN"] = zadanlib.On_Recv_Get_PlayNumAndBox, -- �յ���½�ɹ�
    ["TBHDOB"] = zadanlib.On_Recv_Open_Box, -- �յ������ӣ������Ʒ
    ["TBHDGP"] = zadanlib.On_Recv_Get_Prize, -- �յ���ȡ����

}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("timer_second", zadanlib.timer); 
eventmgr:addEventListener("on_game_over_event", zadanlib.ongameover); 
eventmgr:addEventListener("on_server_start", zadanlib.restart_server); 
eventmgr:addEventListener("on_user_exit", zadanlib.on_user_exit); 