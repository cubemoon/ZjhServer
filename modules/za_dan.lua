TraceError("init treasure_box...")
if zadanlib and zadanlib.ongameover then 
	eventmgr:removeEventListener("game_event", zadanlib.ongameover);
end
 
if not zadanlib then
    zadanlib = _S
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
        count_pan = NULL_FUNC, --ͳ������
        is_valid_site = NULL_FUNC, --�ж��ǲ��Ǻ��ʵ�վ��
        
        box1_num=20,    --����������
        box2_num=40,    --��������
        
        valid_site_no = -1, --��360�ϸ����������-1����ȫ��  360��104
        
        smallbet = 100,  --Сäע����
        start_time = "2012-04-19 00:00:00",
        end_time = "2019-05-21 00:00:00",
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

    local retcode = 0;
    if zadanlib.checker_time_valid() and zadanlib.is_valid_site(userinfo) then
        retcode = 1;
    end
  
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
    
    if not zadanlib.checker_time_valid() then
        return;
    end
    
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
	if(play_count < 5) then
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
	local userinfo = e.data.userinfo
 	for k,v in pairs(e.data)do
 		local userinfo=usermgr.GetUserById(v.userid)
 		zadanlib.count_pan(userinfo) 
 	end
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
                zadanlib.net_send_open_box(userinfo, boxid, prizeid);
                zadanlib.net_send_playnum_and_boxs(userinfo, play_num, boxs, need_show);
            else
                TraceError(format("�����Ʒʧ�ܣ�sql=%s",sql))
            end
         end)
    else   
        --֪ͨ��ҵõ�ʲô��Ʒ
        zadanlib.net_send_open_box(userinfo, boxid, prizeid);
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
    
    --֪ͨ����쵽ʲô��Ʒ
    zadanlib.net_send_gift_info(userinfo, boxid, prizeid);
end

--֪ͨ��ҵõ�ʲô��Ʒ
--//1:100����,2:300����,3:500����,4:3000����,5:1W����,6:ͭ��VIP,7:��VIP,8:С����X1,9:С����X3��10:���˿�X2
zadanlib.net_send_open_box = function(userinfo, boxid, prizeid)
    netlib.send(function(buf)
            buf:writeString("TBHDOB");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
        end,userinfo.ip,userinfo.port);
end
--֪ͨ����쵽ʲô��Ʒ
--//1:100����,2:300����,3:500����,4:3000����,5:1W����,6:ͭ��VIP,7:��VIP,8:С����X1,9:С����X3��10:���˿�X2
zadanlib.net_send_gift_info = function(userinfo, boxid, prizeid)
    netlib.send(function(buf)
            buf:writeString("TBHDGP");
            buf:writeInt(boxid);
            buf:writeInt(prizeid);
        end,userinfo.ip,userinfo.port);
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

eventmgr:addEventListener("game_event", zadanlib.ongameover); 