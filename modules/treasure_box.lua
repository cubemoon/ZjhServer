TraceError("init treasure_box...")
if not treasureboxlib then
    treasureboxlib = _S
    {
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
        box1_num=30,    --����������
        box2_num=60,    --��������
        smallbet = 500,  --Сäע����
        start_time = "2011-03-14 08:00:00",
        end_time = "2011-03-21 00:00:00",

    }    
 end
--�ж���Ϸ��ʱ��Ϸ���
treasureboxlib.checker_time_valid = function()
    local isvalide = true
    if gamepkg.name ~= "tex" then
        isvalide = false
    end
	local starttime = timelib.db_to_lua_time(treasureboxlib.start_time);
	local endtime = timelib.db_to_lua_time(treasureboxlib.end_time);
	local sys_time = os.time()
    if(sys_time < starttime or sys_time > endtime) then
        isvalide = false
	end
    return isvalide
end

--�ַ���ת����table
treasureboxlib.gettable = function(szboxinfo)
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
treasureboxlib.On_Recv_Check_HuoDong = function(buf)
    --TraceError("On_Recv_Check_HuoDong");
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;

    local retcode = 0;
    if treasureboxlib.checker_time_valid() then
        retcode = 1;
    end
    netlib.send(function(buf)
            buf:writeString("TBHDOK");
            buf:writeInt(retcode);
        end,userinfo.ip,userinfo.port);
end

--�յ�����������������
treasureboxlib.On_Recv_Get_PlayNumAndBox = function(buf)
    --TraceError("On_Recv_Get_PlayNumAndBox");
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    
    if not treasureboxlib.checker_time_valid() then
        return;
    end
    if(not userinfo.desk) then return end;
    --500��������
    if(desklist[userinfo.desk].smallbet < treasureboxlib.smallbet) then return end;
    --��VIPֻ�ܿ�������
    local szbox_info = ""
    if(not viplib.check_user_vip(userinfo))then
        szbox_info = "1:"..treasureboxlib.box1_num..":0:0|2:"..treasureboxlib.box2_num..":0:0";
    else
        szbox_info = "1:"..treasureboxlib.box1_num..":0:0|2:"..treasureboxlib.box2_num..":0:0";
    end
   
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
                gamedata.playgameinfo.boxs[1] = {neednum = treasureboxlib.box1_num, opened = 0, prizeid = 0};
                gamedata.playgameinfo.boxs[2] = {neednum = treasureboxlib.box2_num, opened = 0, prizeid = 0};
                gamedata.playgameinfo.play_num = 0;
                gamedata.playgameinfo.login_time = os.time();
                gamedata.playgameinfo.need_show = 1;
                if(not viplib.check_user_vip(userinfo))then
                    --gamedata.playgameinfo.boxs[2].opened = 1;
                end
                local sqltemplet = "update user_treasurebox_info ";
                sqltemplet = sqltemplet.."set login_time = now(), box_info = '"..szbox_info.."', play_num = 0, need_show = 1 ";
                sqltemplet = sqltemplet.."where user_id = %d and game_name = '%s'; commit;";
                
                dblib.execute(string.format(sqltemplet, userid, gamename))
            else
                gamedata.playgameinfo.boxs = treasureboxlib.gettable(dt[1]["box_info"]);
                gamedata.playgameinfo.play_num = dt[1]["play_num"];
                gamedata.playgameinfo.login_time = timelib.db_to_lua_time(dt[1]["login_time"]);
                gamedata.playgameinfo.need_show = dt[1]["need_show"];
            end
            local playnum = gamedata.playgameinfo.play_num;
            local boxs = gamedata.playgameinfo.boxs;
            local need_show = gamedata.playgameinfo.need_show;
            treasureboxlib.net_send_playnum_and_boxs(userinfo, playnum, boxs, need_show);
        else
            TraceError(" ��ѯ���ݿ�ʱ����:" .. strsql);
        end
    end)
end

--��Ϸ�����ɼ�����
treasureboxlib.ongameover = function(userinfo)
    --TraceError("treasureboxlib.ongameover")
    if not userinfo or not userinfo.desk then return end;

    local gamedata = deskmgr.getuserdata(userinfo);
    if not gamedata.playgameinfo then return end;

    if not treasureboxlib.checker_time_valid() then
        return;
    end

    local play_num = gamedata.playgameinfo.play_num;
    --���������vip������
    if (play_num >= 30 and viplib.check_user_vip(userinfo) ~= true) then
        return
    end

    --Сä���ڵ���500�������湻5���˾Ϳ����ۼƱ�������
	--TODO:���߸ĳ�5����
    local deskinfo = desklist[userinfo.desk]
    local play_count = 0
	for k, v in pairs(deskmgr.getallsitedata(userinfo.desk)) do
		if v.isinround == 1 then
			play_count = play_count + 1
		end
	end
	if(play_count < 5 or deskinfo.smallbet < treasureboxlib.smallbet) then
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
   treasureboxlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
end

--��������������ID
treasureboxlib.net_send_playnum_and_boxs = function(userinfo, playnum, boxs, need_show)
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
treasureboxlib.On_Recv_Open_Box = function(buf)
   --TraceError("On_Recv_Open_Box")
   local userinfo = userlist[getuserid(buf)];
   if not userinfo then return end;
   --�Ϸ��Լ��
   if not treasureboxlib.checker_time_valid() then
       return;
   end

   if(not userinfo.desk) then return end;
    --100/200��������
    --Сä���ڵ���100�������湻5���˾Ϳ����ۼƱ�������
	--TODO:���߸ĳ�5����
    local deskinfo = desklist[userinfo.desk]
	if(deskinfo.smallbet < treasureboxlib.smallbet) then
		return
    end

   local gamedata = deskmgr.getuserdata(userinfo);
   if not gamedata.playgameinfo then return end;
   
   local boxid = buf:readByte();
    --��VIPֻ�ܿ�������
    if(boxid > 1 and not viplib.check_user_vip(userinfo))then
        return;
    end
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
     --TraceError("���������["..boxid.."]�Ѿ�����");
     return;
   end
   local prizeid = boxs[boxid].prizeid
   if(prizeid <= 0) then
        --������ɽ�ƷID
        local sql = format("call sp_get_random_spring_gift(%d, '%s', %d)", userinfo.userId, "tex", boxid)
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
                    --boxname = "������";
                    boxname = tex_lan.get_msg(userinfo, "treasure_box_type_silver");
                elseif(boxid == 2) then
                    --boxname = "����";
                    boxname = getMeg("treasure_box_type_gold");
                end
                --ͭ��vip���ϵĲŹ㲥
                if(prizeid <= 4) then
                    --BroadcastMsg(_U("��ϲ")..userinfo.nick.._U("������ "..boxname.." �����[")..prizename.._U("]�������Ͽ����äע500/1000���ϵķ��䣬�����������ı���ɡ�"),0);
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "treasure_box_msg_1"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "treasure_box_msg_2")..boxname..tex_lan.get_msg(userinfo, "treasure_box_msg_3"))..prizename.._U(tex_lan.get_msg(userinfo, "treasure_box_msg_4")),0);
                end
                 
                 --�������ӽ�Ʒ
                 boxs[boxid].prizeid = prizeid;
            
                 --ʵ�ｱƷ(50Ԫ�ƶ���ֵ����10ԪQ�ң�5ԪQ��)ֱ�����
                 if(prizeid ==1 or prizeid == 2 or prizeid == 3) then
                    boxs[boxid].opened = 1;
                 end
                 
                 local box_info = "";
                 need_show = 2;
                 for k,v in pairs(boxs) do
                     box_info = box_info ..format("%d:%d:%d:%d|", tostring(k), tostring(v.neednum), tostring(v.opened), tostring(v.prizeid));
                     if v.opened == 0 then
                         need_show = 1;
                     end
                 end
                 --��VIPֻ�ܿ�������
                 if(boxs[boxid].opened == 1 and not viplib.check_user_vip(userinfo))then
                     need_show = 2;
                 end
                 gamedata.playgameinfo.need_show = need_show;
                 --��¼�����ݿ�
                 local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d where user_id = %d and game_name = '%s'; commit;";
                 dblib.execute(string.format(sqltemplet, box_info, need_show, userinfo.userId, gamepkg.name));
                 --д����־
                 sqltemplet = "insert into log_treasurebox_prize(user_id, game_name, sys_time, box_id, prize_id) "
                 sqltemplet = sqltemplet.."values(%d,'%s',now(),%d,%d);commit; "
                 --dblib.execute(string.format(sqltemplet, userinfo.userId, gamepkg.name, boxid, prizeid));
                 --֪ͨ��ҵõ�ʲô��Ʒ
                treasureboxlib.net_send_open_box(userinfo, boxid, prizeid);
                treasureboxlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
            else
                TraceError(format("�����Ʒʧ�ܣ�sql=%s",sql))
            end
         end)
    else   
        --֪ͨ��ҵõ�ʲô��Ʒ
        treasureboxlib.net_send_open_box(userinfo, boxid, prizeid);
        treasureboxlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
    end;
end

--�յ�����콱��
treasureboxlib.On_Recv_Get_Prize = function(buf)
   --TraceError("On_Recv_Get_Prize")
   local userinfo = userlist[getuserid(buf)];
   if not userinfo then return end;
   --�Ϸ��Լ��
   if not treasureboxlib.checker_time_valid() then
       return;
   end

   if(not userinfo.desk) then return end;
   --500/1000��������
   if(desklist[userinfo.desk].smallbet < treasureboxlib.smallbet) then return end;

   local gamedata = deskmgr.getuserdata(userinfo);
   if not gamedata.playgameinfo then return end;
   
   local boxid = buf:readByte();

   if boxid ~= 1 and boxid ~= 2 then
       TraceError("�յ����������id,������");
       return;
   end
   
   --֪ͨ��ҵõ�ʲô��Ʒ
   treasureboxlib.do_give_user_gift(userinfo, boxid);
   --ˢ������������״̬
   local play_num = gamedata.playgameinfo.play_num;
   local need_show = gamedata.playgameinfo.need_show;
   local boxs = gamedata.playgameinfo.boxs;
   treasureboxlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
end

--����ҷ���(������Ϳ�����Ϊ�ǺϷ��콱��)
treasureboxlib.do_give_user_gift = function(userinfo, boxid)
    if not treasureboxlib.checker_time_valid() then
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
        if v.opened == 0 and viplib.check_user_vip(userinfo) then
            need_show = 1;
        end
    end
    
    gamedata.playgameinfo.need_show = need_show;
    --��¼�����ݿ�
    local sqltemplet = "update user_treasurebox_info set box_info = '%s', need_show = %d where user_id = %d and game_name = '%s'; commit;";
    dblib.execute(string.format(sqltemplet, box_info, need_show, userinfo.userId, gamepkg.name));
    
    --�ɷ���Ʒ��
    if(prizeid == 1) then  --100Ԫ�ƶ���ֵ��
      return;
    elseif(prizeid == 2) then  --10ԪQ��
      return;
    elseif(prizeid == 3) then  --5ԪQ��
      return;
    elseif(prizeid == 4) then  --ͭ��VIP
      --��15w����
      usermgr.addgold(userinfo.userId, 150000, 0, g_GoldType.baoxiang, -1);
      --��VIP
      local sql = ""
      sql = "insert into user_vip_info(user_id, vip_level, over_time, notifyed, first_logined) values(%d,1,DATE_ADD(now(),INTERVAL %d DAY),0,0)";
      sql = sql.." ON DUPLICATE KEY UPDATE over_time = case when over_time > now() then DATE_ADD(over_time,INTERVAL %d DAY) else DATE_ADD(now(),INTERVAL %d DAY) end,notifyed = 0,first_logined = 0;commit; ";
      sql = string.format(sql,userinfo.userId, 30, 30, 30);
      dblib.execute(sql);
      --�ͱ�����
      sql = format("insert ignore user_safebox_info(user_id, safe_pw, safe_gold, is_set_pw) values(%d, '', 0, 0); commit;", userinfo.userId);
      dblib.execute(sql);
    elseif(prizeid == 5) then  --500exp
      usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), 500, g_ExpType.baoxiang, groupinfo.groupid);
    elseif(prizeid == 6) then  --100exp
      usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), 100, g_ExpType.baoxiang, groupinfo.groupid);
    else
      TraceError("δ֪��prizeid["..prizeid.."]!!!");
      return;
    end
    
    --֪ͨ����쵽ʲô��Ʒ
    treasureboxlib.net_send_gift_info(userinfo, boxid, prizeid);
end

--֪ͨ��ҵõ�ʲô��Ʒ
--1:100Ԫ���ͳ�ֵ��,2:10ԪQ�ҿ�,3:5ԪQ�ҿ�,4:ͭ��VIP,5:500����ҩˮ,6:100����ҩˮ
treasureboxlib.net_send_open_box = function(userinfo, boxid, prizeid)
    netlib.send(function(buf)
            buf:writeString("TBHDOB");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
        end,userinfo.ip,userinfo.port);
end
--֪ͨ����쵽ʲô��Ʒ
--1:100Ԫ���ͳ�ֵ��,2:10ԪQ�ҿ�,3:5ԪQ�ҿ�,4:ͭ��VIP,5:500����ҩˮ,6:100����ҩˮ
treasureboxlib.net_send_gift_info = function(userinfo, boxid, prizeid)
    netlib.send(function(buf)
            buf:writeString("TBHDGP");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
        end,userinfo.ip,userinfo.port);
end


--�����б�
cmdHandler = 
{
    ["TBHDOK"] = treasureboxlib.On_Recv_Check_HuoDong, --��ѯ��Ƿ������
    ["TBHDPN"] = treasureboxlib.On_Recv_Get_PlayNumAndBox, -- �յ���½�ɹ�
    ["TBHDOB"] = treasureboxlib.On_Recv_Open_Box, -- �յ������ӣ������Ʒ
    ["TBHDGP"] = treasureboxlib.On_Recv_Get_Prize, -- �յ���ȡ����
 
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

