--�������ñ��
config_for_yunying = config_for_yunying or {}
--����Ԥ����

--��������״̬�����������⴦��
function on_panel_buy(userinfo, sitedata)
    sitedata.panellefttime = hall.desk.get_site_timeout(userinfo.desk, userinfo.site)
    if sitedata.panellefttime <= 0 then 
        sitedata.panellefttime = 1 
    end
    hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.WAIT)
    process_site(userinfo.desk, userinfo.site)--���¼������
    --�������㷢�־�Ȼ�������״̬�ˣ��Ǿͳ��������԰�
    if hall.desk.get_site_state(userinfo.desk, userinfo.site) == SITE_STATE.WAIT then
        local autodata = _S
        {
            guo 		= 0, 
            guoqi 		= 0,
            genrenhe 	= 0, 
            gen 		= 0, 
            gengold 	= 0,
        }
        net_show_autopanel(userinfo, autodata)
    end
    sitedata.panellefttime = 0
end

--��ȡ������ϵ�ʯͷ����
function get_texstone_by_userinfo(userinfo)
    local str = "";
    if not userinfo then
        TraceError("get_texstone_by_userinfo,�յ�userinfoΪ��!!!");
        return str;
    end

    local giftinfo = userinfo.gameInfo.giftinfo;
    if not giftinfo then
        TraceError("get_texstone_by_userinfo,�յ�giftinfoΪ��!!!");
        return str;
    end

    local tstones = {};
    for i=1, #giftinfo do
        local item = giftinfo[i];
        if(item ~= nil)then
            --��ʯID��5001 - 6000
            if(item.id > 5000 and item.id <= 6000)then
                if(not tstones[item.id])then
                    tstones[item.id] = 0;
                end
                tstones[item.id] = tstones[item.id] + 1;
            end
        end
    end

    --ʯͷ�����б�
    local stonelist = {};
    for k,v in pairs(tstones) do
        table.insert(stonelist, format("%s:%s", tostring(k), tostring(v)));
    end

    --����
    table.sort(stonelist, 
           function(a,b)
               local id_1 = tonumber(string.sub(a,1,4)) or 0;
               local id_2 = tonumber(string.sub(b,1,4)) or 0;
               return id_1 < id_2;
           end);
    str = "|" .. table.concat(stonelist, "|");
    return str;
end

--��¼��Ʒ������־
function record_gift_transaction(userid, viplevel, beforgold, transtype, giftid, counts, amount, touserid, beforestone, afterstone)
    --TraceError(format("beforstone=%s,\nafterstone=%s", beforestone, afterstone));
    local sqltemple = "INSERT INTO log_texgift_transaction ";
    sqltemple = sqltemple .. "(sys_time, user_id, vip_level, befor_gold, trans_type, gift_id, counts, amount, touser_id, before_stone, after_stone) ";
    sqltemple = sqltemple .. "VALUES(NOW(),%d,%d,%d,%d,%d,%d,%d,%d,'%s','%s');COMMIT;";
    local sql = string.format(sqltemple, userid, viplevel, beforgold, transtype, giftid, counts, amount, touserid, beforestone, afterstone);
    dblib.execute(sql);
end

--�ж��Ƿ����˽�(2011-02-14)
function checker_valentine_Day()
	local starttime = os.time{year = 2011, month = 2, day = 14, hour = 0};
	local endtime = os.time{year = 2011, month = 2, day = 15, hour = 0};
	local sys_time = os.time()
    if(sys_time < starttime or sys_time > endtime) then
        return false
	end
    return true
end

--������̵��б�
function onrecvopenshop(buf)
	--TraceError("onrecvopenshop()")
	local userinfo = userlist[getuserid(buf)];
	if not userinfo then return end;

	local giftlist = {};
    for k,v in pairs(tex.cfg.giftlist) do
        if(k == 5006) then --���˽�����(ֻ�����˽�����)
            if checker_valentine_Day() then
                table.insert(giftlist, {id = k, price = v});
            end
        else
            table.insert(giftlist, {id = k, price = v});
        end
    end

	net_send_gift_shop(userinfo, giftlist);
end

--������Ʒ���а�
function onrecvgetgiftrank(buf)
	--TraceError("onrecvgetgiftrank()")
	local userinfo = userlist[getuserid(buf)];
	if not userinfo then return end;

	local giftrank = tex.giftrank;
    local sys_time = os.time();
    local playerlist = {};
    --1���Ӹ���һ����������(������ͬ�İ�ʱ����������)
    if(sys_time - giftrank.lasttime > 30 and giftrank.refreshing == 0)then
        local sql = "SELECT * FROM user_sweetheart_info ORDER BY counts DESC, update_time ASC LIMIT 0, 10; ";
        giftrank.refreshing = 1;
        dblib.execute(sql,
    		function(dt)
                if(dt and #dt > 0) then
                    giftrank.lasttime = os.time();
                    for i=1, #dt do
                        giftrank.playerlist[i] = {};
                        giftrank.playerlist[i]["paiming"] = i;
                        giftrank.playerlist[i]["userid"] = dt[i]["user_id"];
                        giftrank.playerlist[i]["nick"] = dt[i]["nick_name"];
                        giftrank.playerlist[i]["counts"] = dt[i]["counts"];
                    end
                end
                giftrank.refreshing = 0;
                do_add_user_itself(userinfo, giftrank.playerlist);
    		end);
    else
        do_add_user_itself(userinfo, giftrank.playerlist);
    end
end

--����Ʒ���а��м�������Լ�������
function do_add_user_itself(userinfo, ranklist)
    if not userinfo or not ranklist then return end;
    local templist = {};
    for i=1, #ranklist do
        templist[i] = ranklist[i];
    end
    --��ֹ����������ݿ⣬5�����ظ�����ֱ�ӷ��ͻ����������
    if(userinfo.rankinfo)then
        local userlasttime = userinfo.rankinfo.lasttime;
        local userranklist = userinfo.rankinfo.ranklist;
        if(userlasttime and userranklist and os.time() - userlasttime < 5) then
            net_send_giftrank(userinfo, userinfo.rankinfo.ranklist);
            return
        end
    end

    local len = #templist;
    local sql = "SELECT * FROM user_sweetheart_info WHERE user_id = %d; ";
    sql = format(sql, userinfo.userId);
    dblib.execute(sql,
    		function(dt)
                templist[len + 1] = {};
                templist[len + 1]["paiming"] = 1000000;
                templist[len + 1]["userid"] = userinfo.userId;
                templist[len + 1]["nick"] = userinfo.nick;
                if(dt and #dt > 0) then
                    templist[len + 1]["counts"] = dt[1]["counts"];
                else
                    templist[len + 1]["counts"] = 0;
                end
                userinfo.rankinfo = {lasttime = os.time(), ranklist = templist};
                net_send_giftrank(userinfo, userinfo.rankinfo.ranklist);
    		end);
end

--���ͱ���
function onrecvsendemot(buf)
	local emotid = buf:readInt()
	--TraceError("onrecvsendemot() emotid:" .. emotid)
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end; 
	if not userinfo.desk or userinfo.desk <= 0 then return end;
	if not userinfo.site or userinfo.site <= 0 then return end;

    local lastbuyemottime = userinfo.lastbuyemottime or 0
    if(os.clock()*1000 - lastbuyemottime < 500)then
        TraceError("������飬�����̫����")
        return
    end
    userinfo.lastbuyemottime = os.clock()*1000

	local deskinfo = desklist[userinfo.desk]

	local deskdata = deskmgr.getdeskdata(userinfo.desk)
	local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)

	local smallbet = desklist[userinfo.desk].smallbet
	local emotprice = smallbet
	--1=�ɹ���Ǯ 2=Ǯ���� 0=�����쳣
	local retcode = dobuyemot(userinfo, deskdata, sitedata, emotprice)   

	--����ɹ�
	if retcode == 1 then 
		--�㲥���鶯��
		net_broadcast_emot(userinfo.desk, userinfo.site, emotid)
	else
		net_send_gift_faild(userinfo, retcode)
	end
end

--�������,�����Ѳ�����Ǯ,��ˢ�µ��ͻ��� ������ 1=�ɹ���Ǯ 2=Ǯ���� 0=�����쳣
function dobuyemot(userinfo, deskdata, sitedata, emotprice)
    --TraceError("dobuyemot() emotprice:" .. emotprice)
	local deskinfo = desklist[userinfo.desk]
	local largebet = deskinfo.largebet
	local choushui = get_specal_choushui(deskinfo,userinfo)
	local state = hall.desk.get_site_state(userinfo.desk, userinfo.site)
	local canbuy = 0
	--����ĳ���
	local freezegold = 0
	if(not userinfo.chouma or userinfo.chouma == 0)then
        	freezegold = sitedata.betgold
	end
	--��������û��ʼ��Ҫ���������ѿ�
	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then
        	local gamestart = tex.getGameStart(userinfo.desk)
        	if not gamestart then
            		freezegold = deskinfo.at_least_gold + deskinfo.specal_choushui
        	end
	end
	local usegold = get_canuse_gold(userinfo)--userinfo.gamescore - freezegold  --�۳�����ע�ĳ���
		
	--���ⲻ�ܷ�����
	if state == NULL_STATE then TraceError("������������") return canbuy end
	
	--�������껹�����벻
    if state == SITE_STATE.PANEL or state == SITE_STATE.WAIT then
		--��Ϸ��ʼ������飬���´�äע
		if(usegold - emotprice >= largebet) then
			canbuy = 1
		else
			canbuy = 2
		end
	else
		--û��ʼ��Ϸ���ͱ��飬Ҫ���ǳ�ˮ
		if(usegold - emotprice >= largebet + choushui) then
			canbuy = 1
		else
			canbuy = 2
		end
	end
	
	--�����Ϲ�������
	if(canbuy ~= 1) then
		return canbuy
	end
	
	--��ʼ��Ǯ����Ҫע�⿩
	usermgr.addgold(userinfo.userId, -emotprice, 0, g_GoldType.buyemot, -1, 1)
	--�ͻ��˳�����ʾ,����õ��˴�����룬��Ҫʵʱˢ�¼��ٵ���ֵ
	usegold = usegold - emotprice
	if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and
       deskinfo.desktype ~= g_DeskType.match) then
		if(userinfo.chouma and usegold < userinfo.chouma) then
			userinfo.chouma = usegold
		end
		if(sitedata.gold and usegold < sitedata.gold) then
			sitedata.gold = usegold
			if(sitedata.gold == 0) then
				TraceError("������Ǯ��û�ˣ�����ô��.....")
				sitedata.isallin = 1 
			end
		end
	end
	net_broadcastdesk_goldchange(userinfo)
	
	--�û����״̬��������ˢ����ʾ��ע���
	if state == SITE_STATE.PANEL then
		on_panel_buy(userinfo, sitedata)
	end

	return canbuy
end

function is_no_limit_gift(gift_id) 
    local nolimit_ture = 0;
    for _,v in pairs (config_for_yunying.no_limit_gift) do
        if v == gift_id then
                nolimit_ture = 1;
            break
        end
    end
    return nolimit_ture;
end

function check_buy_gift_gold(user_info) 
    local limitgold = config_for_yunying.buy_gift_limit;
	local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
	if(sys_today ~= user_info.gift_today) then --���ڲ���
		user_info.gift_today = sys_today	--���½�������
		user_info.buygiftgold = 0	--���칺���
		user_info.salegiftgold = 0	--�������۶�
		update_giftinfo_db(user_info)
	end
end

--ִ����������
--����:1=�ɹ� 2=Ǯ���� 3=�������칺��� 0=�����쳣
function dosendgift(userinfo, touserinfo, giftid, gift_num)
	if not userinfo or not touserinfo then
		TraceError("˭�͸�˭����")
		return 0
    end

    if(gift_num <= 0) then
        TraceError("���͵�����Ϊ"..gift_num);
        return 0;
    end

	local giftprice = tex.cfg.giftlist[giftid]
	
	if not giftprice then 
		TraceError("�����giftid:" .. giftid)
		return 0
    end

    giftprice = giftprice * gift_num;

    local limitgold = config_for_yunying.buy_gift_limit;
	--����Ƿ񳬹�ÿ�칺����
	check_buy_gift_gold(userinfo);

	if(not userinfo.buygiftgold) then
	    userinfo.buygiftgold = giftprice
	else
		local nolimit_ture = is_no_limit_gift(giftid);
	    if(userinfo.buygiftgold + giftprice >= limitgold) and (nolimit_ture == 0) then
	        --���칺�򳬹�150����
	        return 3
	    else
	    		if nolimit_ture ==  0 then
	        	userinfo.buygiftgold = userinfo.buygiftgold + giftprice       
	     		end
	    end
	end
	
	--��ά���󣬽�����־
	local userid = userinfo.userId
	local viplevel = 0
	if(viplib) then
	    viplevel = viplib.get_vip_level(userinfo)
	end
	local beforgold = userinfo.gamescore
	local transtype = 0 --��������,����
	
	local amount = -giftprice --��Ҫ��Ǯ���Ǹ���
	local touserid = touserinfo.userId
	
	local retcode = 0
	
	--��Ϸ�и�������
	if(userinfo.desk and userinfo.site and touserinfo.site) then
		local deskdata = deskmgr.getdeskdata(userinfo.desk)
		local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)
		local tosite = touserinfo.site
	
		local tositedata = deskmgr.getsitedata(userinfo.desk, tosite)
		retcode = dobuygift1(userinfo, deskdata, sitedata, giftid, giftprice, touserinfo, gift_num)
		--����ɹ�
		if retcode == 1 then
			if giftid < 2000 and userinfo.userId ~= touserinfo.userId then--������
				tositedata.getgifecount = tositedata.getgifecount + 1
				if tositedata.getgifecount >= 3 then
					achievelib.updateuserachieveinfo(touserinfo,1004);--�ɱ�����
				end
			end
			
			local nolimit_ture = 0;
			for _,v in pairs (config_for_yunying.cannot_puton_gift) do
				if v == giftid then
					nolimit_ture = 1;
					break
				end
			end
			if nolimit_ture ~= 1 then
				--�㲥���������ﶯ��
				net_broadcast_give_gift(userinfo.desk, userinfo.site, tosite, giftid, 1, gift_num)
			else
				--��ͼֽ�Ļ��������� 7
				net_broadcast_give_gift(userinfo.desk, userinfo.site, tosite, giftid, 2)
			end
		end
	else
		retcode = dobuygift2(userinfo, giftid, giftprice, touserinfo, gift_num)
	end
	--����ɹ���������Ʒ����¼��־
	if(retcode == 1)then
		if zhongqiu_lib ~= nil then 
            local bTrue = zhongqiu_lib.is_in_zhongqiu_tuzhi(userinfo, touserinfo, giftid, gift_num)
            if bTrue == 1 then return -10 end
		end
		if tex_gamepropslib then
            local bTrue = tex_gamepropslib.is_gameprops(userinfo, touserinfo, giftid, gift_num)
            if (bTrue == 1) or (bTrue == 2) then return -10 end
		end
		local before_stones = get_texstone_by_userinfo(userinfo)
        for i = 1, gift_num do
            gift_addgiftitem(touserinfo, giftid, userinfo.userId, userinfo.nick)
        end
		local after_stones = get_texstone_by_userinfo(userinfo)
	    if (duokai_lib and duokai_lib.is_sub_user(touserid) == 1) then
            touserid = duokai_lib.get_parent_id(touserid)
        end
		record_gift_transaction(userid, viplevel, beforgold, transtype, giftid, gift_num, amount, touserid, before_stones, after_stones)
	end
	return retcode
end

function onrecvpresendgift(buf)
    local user_info = userlist[getuserid(buf)];
    if(not user_info) then return end;
    local gift_id = buf:readInt();
    local gift_price = tex.cfg.giftlist[gift_id];

    if(not gift_price) then
        return;
    end

    local max = 100;
    local result = 1;
    local can_use_gold = get_canuse_gold(user_info);
    local can_buy_num = math.floor(can_use_gold / gift_price);

    --����������Ƶ���
    if(is_no_limit_gift(gift_id) == 0) then
        check_buy_gift_gold(user_info);

        local buy_gift_limit = config_for_yunying.buy_gift_limit;
        if(user_info.buygiftgold == nil) then
            user_info.buygiftgold = 0;
        end
        if(user_info.buygiftgold + gift_price * can_buy_num >= buy_gift_limit) then
            --����������
            can_use_gold = buy_gift_limit - user_info.buygiftgold;
            can_buy_num = math.floor(can_use_gold / gift_price);
            result = 2;
        end
    end

    --����100����
    if(gift_getgiftcount(user_info) + can_buy_num > 100 and tex_gamepropslib.get_type_pro_gift(gift_id)==2 )then
        can_buy_num = max - gift_getgiftcount(user_info);
        result = 3;
    end

    if(can_buy_num > max) then
        can_buy_num = max;
    end
    if(can_buy_num > 0) then
        local send_func = function(buf)
            buf:writeString("TXPROPNUM");
            buf:writeInt(can_buy_num);
        end
        netlib.send(send_func, user_info.ip, user_info.port);
    else
        if(result == 2) then
            --�õ��߳��������������
			net_send_gift_faild(user_info, 6);
        elseif(result == 3)then
			net_send_gift_faild(user_info, 5);
        else
			net_send_gift_faild(user_info, 2);
        end
    end
end

--�յ���������
function onrecvsendgift(buf)
	--TraceError("onrecvsendgift()")
	local giftid = buf:readInt()
	local len = buf:readInt()
	local tosites = {}
	for i = 1, len do
		tosites[i] = buf:readByte()
    end
    local gift_num = buf:readInt();
    local gift_type = buf:readInt();

    if(gift_num <= 0) then
        return;
    end

    if(giftid == 5006 and not checker_valentine_Day())then
        TraceError("���첻�����˽ڣ��̵겻�������� id=5006")
        return
    end
	
	local userinfo = userlist[getuserid(buf)];
	if not userinfo then return end;

    local lastbuygifttime = userinfo.lastbuygifttime or 0
    if(os.clock()*1000 - lastbuygifttime < 800)then
        TraceError("������������̫����")
        return
    end
    userinfo.lastbuygifttime = os.clock()*1000

	local giftprice = tex.cfg.giftlist[giftid]
	
	if not giftprice then 
		--��ʾ�̳���Ʒ�Ѿ�����
		net_send_gift_faild(userinfo, 99)
		TraceError("�����giftid:" .. giftid)
		return 
    end

    for i = 1, #tosites do
        local touserinfo = nil
		local tosite = tosites[i]
		if(tosite and tosite ~= 0) then
			if(userinfo.desk and userinfo.site) then
				touserinfo = deskmgr.getsiteuser(userinfo.desk, tosite)
			else
				TraceError("��ս��ʱ��������񣿣�����֧��")
			end
		else
			--�͸��Լ�
			touserinfo = userinfo
        end

        if(touserinfo ~= nil and touserinfo.userId ~= userinfo.userId) then
            gift_num = 1;
        end
    end
	
	--��¼����ʧ�ܵ����
	local failedusers = {}
    local retcode = 0
    local flag_full = 0
	for i = 1, #tosites do
		local touserinfo = nil
		local tosite = tosites[i]
		if(tosite and tosite ~= 0) then
			if(userinfo.desk and userinfo.site) then
				touserinfo = deskmgr.getsiteuser(userinfo.desk, tosite)
			else
				TraceError("��ս��ʱ��������񣿣�����֧��")
			end
		else
			--�͸��Լ�
			touserinfo = userinfo
        end

		if touserinfo then
			if gift_getgiftcount(touserinfo) + gift_num > 100 and tex_gamepropslib.get_type_pro_gift(giftid)==2 then
				if(userinfo.userId == touserinfo.userId) then  --�Լ����Լ�����
					net_send_gift_faild(userinfo, 5, giftid, gift_num, gift_type)		--���߿ͻ�����������
					flag_full = 1
				else
					net_send_gift_faild(touserinfo, 3, giftid, gift_num, gift_type)		--1=�ɹ���Ǯ 2=Ǯ���� 3=�������� 4=�������� 0=�����쳣				
				end
				table.insert(failedusers, {site = touserinfo.site or 0, retcode = 4})
      else 
				retcode = dosendgift(userinfo, touserinfo, giftid, gift_num)
				if(retcode ~= 1) and (retcode ~= -10) then
					table.insert(failedusers, {site = touserinfo.site or 0, retcode = retcode})
				end
			end
		end
	end
	--ֻ������Ϸ�в�����������ʧ�ܵ����
	if(userinfo.desk and userinfo.site) then
		net_send_gift_faildlist(userinfo, failedusers)
	else
		--1=�ɹ���Ǯ 2=Ǯ���� 3=���쳬�� 0=�����쳣
		if retcode == -10 then
			net_send_gift_faild(userinfo, 1, giftid, gift_num, gift_type)
		else
			if flag_full == 0 then
				net_send_gift_faild(userinfo, retcode == 3 and 6 or retcode, giftid, gift_num, gift_type)
			end
		end
		
	end
end


--��Ϸ�й�������,�����Ѳ�����Ǯ,��ˢ�µ��ͻ��� ������ 1=�ɹ���Ǯ 2=Ǯ���� 0=�����쳣
function dobuygift1(userinfo, deskdata, sitedata, giftid, giftprice, touserinfo, gift_num)
	--TraceError("dobuygift() giftprice:" .. giftprice)
	local deskinfo = desklist[userinfo.desk]
	local largebet = deskinfo.largebet
	local choushui = get_specal_choushui(deskinfo,userinfo)
	local canbuy = 0
	local state = hall.desk.get_site_state(userinfo.desk, userinfo.site)
	local usegold = get_canuse_gold(userinfo);
	
	--����??
	if state == NULL_STATE then TraceError("������������") return canbuy end
	
	--�������껹�����벻
    if state == SITE_STATE.PANEL or state == SITE_STATE.WAIT then
		--��Ϸ��ʼ�������´�äע
		if(usegold - giftprice >= largebet) then
			canbuy = 1
		else
			canbuy = 2
		end
	else
		--û��ʼ��Ϸ�������Ҫ���ǳ�ˮ
		if(usegold - giftprice >= largebet + choushui) then
			canbuy = 1
		else
			canbuy = 2
		end
	end
	
	if(usegold < giftprice) then
		canbuy = 2
	end	
	
	--�����Ϲ�������
	if(canbuy ~= 1) then
		return canbuy
	end
	
	--��ʼ��Ǯ����Ҫע�⿩
	--TraceError(format("���[%d]������Ʒ����[%d]����",userinfo.userId,giftprice))
    if(giftid == 5006)then --����֮�ģ�����type
	    usermgr.addgold(userinfo.userId, -giftprice, 0, g_GoldType.buysweetheart, -1, 1, nil, giftid, gift_num, touserinfo.userId)
    else
        usermgr.addgold(userinfo.userId, -giftprice, 0, g_GoldType.buy, -1, 1, nil, giftid, gift_num, touserinfo.userId)
    end
	--�ͻ��˳�����ʾ,����õ��˴�����룬��Ҫʵʱˢ�¼��ٵ���ֵ
	usegold = usegold - giftprice
    if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament) then
    	if(userinfo.chouma and usegold < userinfo.chouma) then
    		userinfo.chouma = usegold
    	end
    	if(sitedata.gold and usegold < sitedata.gold) then
    		sitedata.gold = usegold
    		if(sitedata.gold == 0) then
    			TraceError("����Ʒ��Ǯ��û�ˣ�����ô��.....")
    			sitedata.isallin = 1 
    		end
        end
    end
	net_broadcastdesk_goldchange(userinfo)
	
	--�û����״̬��������ˢ����ʾ��ע���
	if state == SITE_STATE.PANEL then
		on_panel_buy(userinfo, sitedata)
    end

	return canbuy
end

--�������սʱ��������,�����Ѳ�����Ǯ,��ˢ�µ��ͻ��� ������ 1=�ɹ���Ǯ 2=Ǯ���� 0=�����쳣
function dobuygift2(userinfo, giftid, giftprice, touserinfo, gift_num)	
	--���������벻	
    local canbuygold = get_canuse_gold(userinfo);
	if(canbuygold - giftprice < 0) then
		return 2
	end
	
	--��ʼ��Ǯ����Ҫע�⿩
	--TraceError(format("���[%d]������Ʒ����[%d]����",userinfo.userId,giftprice))
    if(giftid == 5006)then --����֮�ģ�����type
        usermgr.addgold(userinfo.userId, -giftprice, 0, g_GoldType.buysweetheart, -1, 1, nil, giftid, gift_num, touserinfo.userId)
    else
	    usermgr.addgold(userinfo.userId, -giftprice, 0, g_GoldType.buy, -1, 1, nil, giftid, gift_num, touserinfo.userId)
    end

	return 1
end

--����ĳ�˵���������
function onrecvgetgiftinfo(buf)
	local to_user_id = buf:readInt()
    if (duokai_lib and duokai_lib.is_sub_user(to_user_id) == 1) then
        to_user_id = duokai_lib.get_parent_id(to_user_id)
    end
	--TraceError("onrecvgetgiftinfo()" .. to_user_id)
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end; 
	local touserinfo = usermgr.GetUserById(to_user_id); if not touserinfo then return end; 
	local touserdata = deskmgr.getuserdata(touserinfo)
	net_send_gift_list(userinfo, touserdata.giftinfo, touserinfo)
end


--����ĳ����
function onrecvusinggift(buf)
	local gift_index = buf:readInt()
	--TraceError("onrecvusinggift()" .. gift_index)
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end;
	local userdata = deskmgr.getuserdata(userinfo)
	
	if gift_usegiftitem(userinfo, gift_index) then
		dispatchMeetEvent(userinfo)
	end
end

--������ĳ����
function onrecvdropgift(buf)
	local gift_index = buf:readInt()
	--TraceError("onrecvdropgift()" .. gift_index)
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end;
	local userdata = deskmgr.getuserdata(userinfo)

	--���ɾ����ʱ���ϴ��ģ���Ҫ�ɷ�������Ϣ
	if gift_removegiftitem(userinfo, gift_index) > 0 then
		dispatchMeetEvent(userinfo)
	end
end

--��������ĳ������
--TODO:������ܴ���һ�����������������⣬��Ҫע��
function onrecvsalegift(buf)
	local gift_index = buf:readInt()
	--TraceError("onrecvdropgift()" .. gift_index)
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end;
	local userdata = deskmgr.getuserdata(userinfo)
    local giftinfo = userdata.giftinfo
    local giftitem = giftinfo[gift_index]
	if not giftitem then
		TraceError(format("��ͼ���������ڵ�����,userId[%d],gift_index[%d]", userinfo.userId, gift_index))
        net_send_sale_gift(userinfo, -1, 0)
		return
    end

    --�жϴ������Ƿ���Գ���
    local giftid = giftitem.id
    if giftitem.cansale ~= 1 then 
		TraceError("�������ﲻ�ܻ���,��ͻ��˼��,giftid:" .. giftitem.id)
        net_send_sale_gift(userinfo, 2, 0)
		return 
    end

    --�۸�
    local giftprice = math.floor(giftitem.salegold * 0.95)--���ռ���ԭ�۵�95%
    if not tex.cfg.giftlist[giftid] or not giftprice or giftprice <=0 then 
		TraceError("��������������:giftid:" .. giftitem.id)
        net_send_sale_gift(userinfo, 2, 0)
		return 
    end
    --��˰
    local taxgold = tex.cfg.giftlist[giftid] - giftprice

    --����Ƿ񳬹�ÿ����۽��
    local limitgold = 1500000
	local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
	if(sys_today ~= userinfo.gift_today) then --���ڲ���
		userinfo.gift_today = sys_today	--���½�������
		userinfo.buygiftgold = 0	--���칺���
		userinfo.salegiftgold = 0	--�������۶�
		update_giftinfo_db(userinfo)
	end
    if(not userinfo.salegiftgold) then
        userinfo.salegiftgold = giftprice
    else
        if(userinfo.salegiftgold + giftprice >= limitgold) then
            TraceError(format("���[%d]���������Ʒ��ó���[%d]", userinfo.userId, userinfo.salegiftgold + giftprice))
        end
        userinfo.salegiftgold = userinfo.salegiftgold + giftprice
    end

    if(userinfo.issaleing) then
        TraceError("ǰһ����û�����أ�����"..debug.traceback())
        net_send_sale_gift(userinfo, 3, 0)
		return 
    end
    --ԭ�Ӳ���������ͬʱ������
    userinfo.issaleing = 1

    --��ά���󣬽�����־
    local userid = userinfo.userId
    local viplevel = 0
    if(viplib) then
        viplevel = viplib.get_vip_level(userinfo)  --���vip�ȼ�
    end
    local beforgold = userinfo.gamescore  --����ǰ���
    local transtype = 1 --��������,����

    local ncount = 1 --����
    local amount = giftprice  --���Ǽ�Ǯ�ģ�����
    local touserid = 0  --����ʱû��Ŀ���˵�ID
    
    --һ��Ҫɾ����Ʒ�ɹ����ܼ�ǮŶ 
    local before_stones = get_texstone_by_userinfo(userinfo)
    local after_stones = ""
    local result = 0;
    if gift_removegiftitem(userinfo, gift_index) >= 0 then
        after_stones = get_texstone_by_userinfo(userinfo)
		dispatchMeetEvent(userinfo)
        if(giftid == 5006) then  --����֮��
            usermgr.addgold(userinfo.userId, giftprice, -taxgold, g_GoldType.salesweetheart, g_GoldType.sweethearttax, 1, nil, giftid)
            --usermgr.addgold(userinfo.userId, -taxgold, 0, g_GoldType.sweethearttax, -1, 1)
        else
            
            usermgr.addgold(userinfo.userId, giftprice, -taxgold, g_GoldType.salegift, g_GoldType.salegifttax, 1, nil, giftid)
            --usermgr.addgold(userinfo.userId, -taxgold, 0, g_GoldType.salegifttax, -1, 1)
        end
        record_gift_transaction(userid, viplevel, beforgold, transtype, giftid, ncount, amount, touserid, before_stones, after_stones)
        net_send_sale_gift(userinfo, 1, giftprice)
        result = 1;
    else
        net_send_sale_gift(userinfo, -1, 0)
        result = 0;
    end
    userinfo.issaleing = nil
end

--�յ�������Ӧ
function onrecvgiftresponse(buf)
	local to_user_id, response_id = buf:readInt(), buf:readInt()
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;
	local touserinfo = usermgr.GetUserById(to_user_id); if not touserinfo then return end; if not touserinfo.desk or touserinfo.desk <= 0 then return end;

	net_broadcast_gift_response(userinfo.desk,userinfo.site,touserinfo.site,response_id)
end

-----------------------------------����=====��userinfo�����ݿ�-----------------------------------------
--��������
function gift_remove_using(userinfo)
	local userdata = deskmgr.getuserdata(userinfo)
    if userdata.using_gift_item ~= nil then
		userdata.using_gift_item.isusing = 0
		userdata.using_gift_item = nil
        update_giftinfo_db(userinfo)
	end
end

--��userinfo��һ������
function gift_usegiftitem(userinfo, itemindex)
	local userdata = deskmgr.getuserdata(userinfo)
	local giftinfo = userdata.giftinfo
	if not giftinfo[itemindex] then
		TraceError("��ͼ�������ڵ�����ͻ��˷��˸���index")
		return false
	end

	if userdata.using_gift_item and userdata.using_gift_item.index ~= itemindex then
		userdata.using_gift_item.isusing = 0
		userdata.using_gift_item = nil
	end

	userdata.using_gift_item = giftinfo[itemindex]
	userdata.using_gift_item.isusing = 1
	update_giftinfo_db(userinfo)
    eventmgr:dispatchEvent(Event("on_using_gift", {userinfo=userinfo,iteminfo=userdata.using_gift_item}));
	return true
end

--����ӵ������֮�ĵ�����:ntype 1��1����0��1��
function update_sweetheart_counts(userinfo, ntype)
	--TraceError("update_sweetheart_counts ntype:"..ntype)
	local sql = ""
    if(ntype == 1)then
        sql = "insert ignore into user_sweetheart_info (user_id, nick_name, update_time, counts)";
        sql = sql .." values(%d, '%s', now(), 1) "
        sql = sql .."ON DUPLICATE KEY UPDATE nick_name = '%s', update_time = now(), counts = counts + 1; commit;";
        sql = format(sql, userinfo.userId, userinfo.nick, userinfo.nick);
    else
        sql = "update user_sweetheart_info set nick_name='%s', update_time=now(), counts=counts - 1 where user_id=%d; commit; ";
        sql = format(sql, userinfo.nick, userinfo.userId);
    end
    
	dblib.execute(sql,function(dt)end, userinfo.userId)
end

--��ȡĳ��userinfo������������todo�������£����ñ�����
function gift_getgiftcount(userinfo)
	local userdata = deskmgr.getuserdata(userinfo)
	local giftinfo = userdata.giftinfo 
	local giftcount = 0
	for k, item in pairs(userdata.giftinfo) do
		giftcount = giftcount + 1
	end
	return giftcount
end

--��userinfo����һ��������Զ�����
function gift_addgiftitem(userinfo, itemid, fromuserid, fromusernick, is_useing)
	local _tosqlstr = function(s) 
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
	fromusernick=_tosqlstr(fromusernick)

	local userdata = deskmgr.getuserdata(userinfo)
	local giftinfo = userdata.giftinfo 
	local maxindex = 0
	for k, item in pairs(userdata.giftinfo) do
		if maxindex < k then maxindex = k end
    end

    if (is_useing == true or is_useing == nil) then
	    is_useing = true
    end
    
    
    --�鿴�ǲ�����config_for_yunying�������˲������������Ʒ
    for _,v in pairs (config_for_yunying.cannot_puton_gift) do
			if v == itemid then
				is_useing = false
				break
			end
		end
		
    if (is_useing) then
        if userdata.using_gift_item then userdata.using_gift_item.isusing = 0 end
    end
	local giftitem = _S
	{
		id 			= itemid,
		experiod 	= 0,
		isusing		= is_useing == true and 1 or 0,
		fromuserid 	= fromuserid,			
		fromuser	= fromusernick,
        --��ʱֻ��5000-6000����Ʒ���Գ���
        cansale     = (tonumber(itemid) >5000 and tonumber(itemid) < 6000) and 1 or 0,
        --�����۸�
        salegold    = 0,
		index		= maxindex + 1,
	}
	--�۸�
	local giftprice = gift_get_sale_price(itemid);
	if giftprice and giftprice > 0 then --5006�����˽ڵģ����ñȽϱ���
          giftitem.salegold = giftprice;
	end

	userdata.giftinfo[giftitem.index] = giftitem
    if (is_useing) then
	    userdata.using_gift_item = giftitem
        eventmgr:dispatchEvent(Event("on_using_gift", {userinfo=userinfo,iteminfo=userdata.using_gift_item}));
    end
    --����ӵ�е�����֮������
    if(itemid == 5006)then
        update_sweetheart_counts(userinfo, 1)
    end

	update_giftinfo_db(userinfo)
    xpcall(function() parkinglib.on_add_gift_item(userinfo, itemid); end,throw);
	return giftitem
end

function gift_get_sale_price(itemid)
    local giftprice = tex.cfg.giftlist[itemid]
	if giftprice and giftprice > 0 then --5006�����˽ڵģ����ñȽϱ���
        if(itemid == 5006)then
		    giftprice = 179999
        else            
            --giftprice = math.floor(giftprice * 0.95)
            giftprice = giftprice
        end
    end
    return giftprice;
end

--��userinfoɾ��ĳ��������Զ��ѵ� 
--����-1��ʾû��ɾ����Ʒ��0��ʾɾ���ɹ���1��ʾɾ�����ŵ���Ʒ
function gift_removegiftitem(userinfo, itemindex)
	local userdata = deskmgr.getuserdata(userinfo)
	local giftinfo = userdata.giftinfo
	if not giftinfo[itemindex] then
		TraceError("��ͼɾ�������ڵ�����ͻ��˷��˸���index")
		return -1
    end
	giftinfo[itemindex] = nil

	local ret = 0
	if userdata.using_gift_item and userdata.using_gift_item.index == itemindex then
		userdata.using_gift_item = nil
		ret = 1
    end

	update_giftinfo_db(userinfo)

	return ret
end

--ͬ���ڴ����ݵ����ݿ�
function update_giftinfo_db(userinfo)
	local userdata = deskmgr.getuserdata(userinfo)
	--TraceError("userdata.giftinfo"..tostringex(userdata.giftinfo))
	local dbstr = gift_tbl2str(userinfo, userdata.giftinfo)
	dblib.cache_set(gamepkg.table, {icon_info=dbstr}, "userid", userinfo.userId, function() end, userinfo.userId)
end



--�����ַ���ת �������� �� ʹ���е�����id
--ǰ�漸��:����|��������|��������|������Ϣ|..|..
function gift_str2tbl(userinfo, giftstr)
	local ret = {}
	local dbgiftlist = split(giftstr, "|")
	local using_gift_item = nil
	userinfo.gift_today = ""	--����Ľ�������
	for k, v in pairs(dbgiftlist) do
		if v ~= "" then
			local list = split(v, ";")
			if(tonumber(list[1]) > 0) then
				local item = _S
				{
					id 			= tonumber(list[1]),			--����
					experiod 	= tonumber(list[2]),			--0 ����
					isusing		= tonumber(list[3]),			--�Ƿ���ʹ���� 1/0
					fromuserid 	= tonumber(list[4]),			
					fromuser	= string.HextoString(list[5]),
					--��ʱֻ��5000-6000����Ʒ���Գ���
					cansale     = (tonumber(list[1]) >5000 and tonumber(list[1]) < 6000) and 1 or 0,
					salegold    = 0,
					index		= #ret + 1,
				}
				if not using_gift_item and item.isusing == 1 then
					using_gift_item = item
				else
					item.isusing = 0				--˳�����쳣�����ֹͬʱʹ�ö������
				end
				--�۸�
				local giftprice = tex.cfg.giftlist[item.id]
				if giftprice and giftprice > 0 then 
                    if(item.id == 5006) then
					    item.salegold = 179999 --5006�����˽ڵģ����ñȽϱ���
                    else
                        --item.salegold = math.floor(giftprice * 0.95)
                        item.salegold = giftprice;
                    end
				end
				table.insert(ret, item)
			elseif(tonumber(list[1]) == -1) then  --�����������Ϣ,��¼�������ں͹���������Ʒ���ܽ��
				userinfo.gift_today = list[2]	--��������
				userinfo.buygiftgold = tonumber(list[3])	--���칺���
				userinfo.salegiftgold = tonumber(list[4])	--�������۶�
			end
		end
	end
	return ret, using_gift_item
end

--��������ת�ַ���
function gift_tbl2str(userinfo, giftinfo)
	local strarr = {}
	--��¼���칺����Ʒ��������Ʒ���ܽ��
	table.insert(strarr, format("-1;%s;%d;%d", userinfo.gift_today, userinfo.buygiftgold, userinfo.salegiftgold))
	for _, item in pairs(giftinfo) do
		table.insert(strarr,  
					 item.id .. ";" .. 
					 item.experiod .. ";" .. 
					 item.isusing .. ";" .. 
					 item.fromuserid .. ";" .. 
					 string.toHex(item.fromuser)
		)
	end
	return table.concat(strarr, "|")
end

-----------------------------��ĩ����vip�-----------------------------------
function check_user_beta_gife(userinfo)
	if not userinfo then return end

	local starttime = os.time{year = 2010, month = 12, day = 4,hour = 0};
	local endtime = os.time{year = 2010, month = 12, day = 6,hour = 0};
	local sys_time = os.time()
	local bvalid = true
    if(sys_time < starttime or sys_time > endtime) then
        return
	end

	dblib.execute(string.format("call sp_getuser_weekendVIP_info(%d,%d)",userinfo.userId,0),
		function(dt)
			if dt and #dt > 0 then
				userinfo.cangivebetagife = 0
				if dt[1]["result"] == 1 then
					userinfo.cangivebetagife = 1
					netlib.send(
						function(buf)
							buf:writeString("SHOWBETAGIFE")
						end,userinfo.ip,userinfo.port)
				end
			else
				TraceError("��ȡ��ҹ����������")
			end
		end)
end

function on_reve_give_betagife(buf)
	local userinfo = userlist[getuserid(buf)]
	if not userinfo then return end

	local starttime = os.time{year = 2010, month = 12, day = 4,hour = 0};
	local endtime = os.time{year = 2010, month = 12, day = 6,hour = 0};
	local sys_time = os.time()
	local bvalid = true
    if(sys_time < starttime or sys_time > endtime) then
        return
	end

	if not userinfo.cangivebetagife or userinfo.cangivebetagife ~= 1 then
		TraceError("�յ��Ƿ�����")
		return
	end

	give_user_bate_gife(userinfo)
end

function give_user_bate_gife(userinfo)
	local gifelist = {} --get_random_gifeid_list() --�������ֻ��VIP

	if #gifelist >= 0 then
		--����
		table.disarrange(gifelist)

		for k,v in pairs(gifelist) do
			gift_addgiftitem(userinfo,v,userinfo.userId,userinfo.nick)
		end

		--��VIP
		local sql = ""
		sql = "insert into user_vip_info values(%d,1,DATE_ADD(now(),INTERVAL %d DAY),0,0)"
		sql = sql.." ON DUPLICATE KEY UPDATE over_time = case when over_time > now() then DATE_ADD(over_time,INTERVAL %d DAY) else DATE_ADD(now(),INTERVAL %d DAY) end,notifyed = 0,first_logined = 0; "
		sql = string.format(sql,userinfo.userId,2,2,2)

		dblib.execute(sql,
			function(dt)
				netlib.send(
					function(buf)
						buf:writeString("REGIFT")
						buf:writeByte(#gifelist)
						for i = 1,#gifelist do
							buf:writeInt(gifelist[i])
						end
					end,userinfo.ip,userinfo.port)
			end,userinfo.userId)

		--д�����ݿ�
		dblib.execute(string.format("call sp_getuser_weekendVIP_info(%d,%d)",userinfo.userId,1))
	else
		TraceError("������,����IDû���������")
	end	
end

function get_random_gifeid_list()
	local num = math.random(0,2)--���һ�ַ�ʽ
	local tGifeId = {}

	if num == 0 then
		tGifeId = get_random_giftid(3,1,{4001,4005})
	elseif num == 1 then
		local gifelucky = get_random_giftid(2,1,{4006,4013})
		for i = 1,2 do
			table.insert(tGifeId,gifelucky[i])
		end
		local gifenolucky = get_random_giftid(1,0)
		table.insert(tGifeId,gifenolucky[1])
	else
		local gifeid = math.random(4014,4017)
		table.insert(tGifeId,gifeid)
		local gifenolucky = get_random_giftid(2,0)
		table.insert(tGifeId,gifenolucky[1])
		table.insert(tGifeId,gifenolucky[2])
	end

	return tGifeId
end

--�õ�����ķǼ���������ID,num--ȡ����ID,nType--0�����ˣ�1����
function get_random_giftid(num,nType,limitnum)
	local idlist = {}
	for k,v in pairs(tex.cfg.giftlist) do
		if nType == 1 then
			if k >= limitnum[1] and k <= limitnum[2] then
				table.insert(idlist,k)
			end
		else
			if k < 4001 then
				table.insert(idlist,k)
			end
		end
	end

	local gifeidlist = {}
	for i = 1,num do
		local id = math.random(1,#idlist)
		table.insert(gifeidlist,idlist[id])
		table.remove(idlist,id)
	end

	return gifeidlist
end
-----------------------------��ĩ����vip�(����)-----------------------------------

--�����¼�, ֪ͨ�������ͼ��
if tex.on_meet_event then
	eventmgr:removeEventListener("meet_event", tex.on_meet_event);
end
--�����¼�
tex.on_meet_event = function(e)
	--  e.data.subject      �� ״̬�ı�����
	--  e.data.observer     :  �۲���
	--  ��״̬�ı�������Ϣ֪ͨ���۲���
    local time1 = os.clock() * 1000
	local userdata = deskmgr.getuserdata(e.data.subject)
	if e.data.subject.site then
		local gift_id = 0
		if userdata.using_gift_item then
            gift_id = userdata.using_gift_item.id
        else
            local using_item = parkinglib.get_using_car_info(e.data.subject);
            if(using_item ~= nil) then
                gift_id = using_item.id;
            end
		end
		net_send_gift_icon(e.data.observer, e.data.subject.site, gift_id or 0)
    end
    local time2 = os.clock() * 1000
    if (time2 - time1 > 50)  then
        TraceError("������������¼�,ʱ�䳬��:"..(time2 - time1))
    end
end
eventmgr:addEventListener("meet_event", tex.on_meet_event);

