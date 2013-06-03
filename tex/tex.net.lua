---------------------------------����ӿ�-------------------------------------------------------------
--�㲥�������� 
function net_broadcastdesk_jiesuan(desk, sitewininfo, sitelist, deskpools, iscomplete)
	trace("net_broadcastdesk_jiesuan()")
	local sendFun = function(userinfo)
		local userbetgold = 0
		local userwingold = 0
		local userpoke5 = {}
		if(userinfo.site ~= nil) then
			local sitedata = deskmgr.getsitedata(desk, userinfo.site)
			if(sitedata ~= nil) then
				if(sitedata.betgold ~= nil) then userbetgold = sitedata.betgold end
				if(sitedata.pokes5 ~= nil) then userpoke5 = sitedata.pokes5 end
			end
			local winsitedata = sitewininfo[userinfo.site]
			if(winsitedata ~= nil and winsitedata.wingold ~= nil) then
				userwingold = winsitedata.wingold
			end
		end
		netlib.send(
			function(buf)
				buf:writeString("TXNTGO")
				local count = 0
				for k, v in pairs(sitewininfo) do
					count = count + 1
                end
                buf:writeByte(iscomplete and 1 or 0)
				buf:writeInt(count);
				for siteno, wininfo in pairs(sitewininfo) do
					buf:writeByte(siteno)				--��λ��
					buf:writeInt(wininfo.wingold)		--Ӯ�˶���Ǯ
					buf:writeString(wininfo.weight)		--���ж���Ǹ����֡���һλ�������͡�1-9���������ʼ�ͬ��˳��
					buf:writeInt(#wininfo.poollist)		--��ȡ���Ĳʳ���Ϣ
					for i = 1, #wininfo.poollist do
						buf:writeByte(wininfo.poollist[i].poolindex)		--1=���� 2=�ʳ�1 3=�ʳ�2 ...
						buf:writeInt(wininfo.poollist[i].poolgold)		--��ϸ
					end
				end
				buf:writeInt(userbetgold)							--������ҵ�����ע
				buf:writeInt(userwingold)	--������ҷֵ���Ǯ
				buf:writeInt(#userpoke5)			--�Լ����������ƣ�ӦΪ5��
				for i = 1, #userpoke5 do		
					buf:writeByte(userpoke5[i])	
                end

                --����Э��
    			buf:writeByte(#sitelist)  --�������û��������
    			for i = 1, #sitelist do
    				local sitedata = deskmgr.getsitedata(desk, sitelist[i])
                    buf:writeByte(sitelist[i])	
    				buf:writeByte(#sitedata.pokes)	
    				for j = 1, #sitedata.pokes do  --����
    					buf:writeByte(sitedata.pokes[j])
    				end
    				buf:writeString(sitedata.pokeweight)
    				buf:writeByte(#sitedata.pokes5)	
    				for j = 1, #sitedata.pokes5 do --�������
    					buf:writeByte(sitedata.pokes5[j])	
    				end
    			end
    			
    			--�ʳ���Ϣ
    			buf:writeByte(#deskpools)
    			for i = 1, #deskpools do --ÿ���ʳ�
    				buf:writeInt(deskpools[i].chouma)  --�ʳؽ��
                    buf:writeByte(#deskpools[i].winlist)
    				for j =1, #deskpools[i].winlist do	--��Ǯ����
    					buf:writeByte(deskpools[i].winlist[j].siteno)
    					buf:writeInt(deskpools[i].winlist[j].winchouma)
    				end
                end
			end
		, userinfo.ip, userinfo.port);
	end

	--�㲥����
    for i = 1, room.cfg.DeskSiteCount do
        local tempuserkey = hall.desk.get_user(desk,i);
        if(tempuserkey) then
            local playingUserinfo = userlist[hall.desk.get_user(desk,i) or ""]
            if (playingUserinfo and playingUserinfo.offline ~= offlinetype.tempoffline) then
                sendFun(playingUserinfo)
            end
            if(playingUserinfo == nil) then
                TraceError("�û������������и��û���userlist��ϢΪ��")
                hall.desk.clear_users(deskno,i)
            end
        end
	end
	local deskinfo = desklist[desk] or {}
    for k,watchinginfo in pairs(deskinfo.watchingList) do
        if (watchinginfo and watchinginfo.offline ~= offlinetype.tempoffline) then
            sendFun(watchinginfo) 
        end
        if(watchinginfo == nil) then
            deskinfo.watchingList[k] = nil
        end
    end
    --�㲥����(����)
end

--�㲥ĳ��Ͷ��
function net_broadcastdesk_giveup(desk, siteno)
	trace("net_broadcastdesk_giveup()")
    local user_info = deskmgr.getsiteuser(desk, siteno);
	netlib.broadcastdeskex(
		function(buf)
			buf:writeString("TXNTTX")
			buf:writeByte(siteno);	--��λ��
            buf:writeString(user_info ~= nil and user_info.nick or "");
		end
	, desk, borcastTarget.all);
end

--��ʾ���
function net_showpanel(userinfo, rule)
	--TraceError("net_showpanel(" .. userinfo.site .. ")")
	--TraceError(rule)
	netlib.send(
		function(buf)
			buf:writeString("TXNTPN")
			buf:writeByte(rule.gen)
			buf:writeByte(rule.jia)
			buf:writeByte(rule.allin)
			buf:writeByte(rule.fangqi)
			buf:writeByte(rule.buxiazhu)
			buf:writeByte(rule.xiazhu)
			buf:writeInt(rule.min)
			buf:writeInt(rule.max)
			buf:writeInt(rule.gengold)
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--��ʾ�Զ����
function net_show_autopanel(userinfo, rule)
	--TraceError("net_show_autopanel(" .. userinfo.site .. ")")
	--TraceError(rule)
	netlib.send(
		function(buf)
			buf:writeString("TXNTAP")
			buf:writeByte(rule.guo)
			buf:writeByte(rule.guoqi)
			buf:writeByte(rule.genrenhe)
			buf:writeByte(rule.gen)
			buf:writeInt(rule.gengold)
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--�㲥ĳ��ĳ��λ��Ǯ
function net_broadcastdesk_goldchange(userinfo)
    --TraceError(format("�㲥ĳ��ĳ��λ��Ǯ"))
    if not userinfo then return end
    local deskno = userinfo.desk
    local siteno = userinfo.site
    if not deskno or not siteno then return end
    local usergold = userinfo.chouma
    if usergold == 0 then
        local sitedata = deskmgr.getsitedata(deskno, siteno)
        usergold = sitedata.gold
    end
    --TraceError(format("�㲥ĳ��ĳ��λ��Ǯ,site%d,gold:%d", siteno, usergold))
	netlib.broadcastdesk(
		function(buf)
			buf:writeString("TXNTGC")
			buf:writeByte(siteno);	--��λ��
			buf:writeInt(usergold);	--��Ǯ��
		end
	, deskno, borcastTarget.all);
end

--��һ���˷���������Ϣ
function OnSendDeskInfo(userinfo, deskno)
	if not deskno or not desklist[deskno] then return end
	local deskinfo = desklist[deskno]
	local showsitbutton = 1  --�Ƿ���ʾ���°�ť
    if tex.getGameStart(deskno) == true then
        if (deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then showsitbutton = 0 end
    end
    if (deskinfo.playercount >= deskinfo.max_playercount) then showsitbutton = 0 end
    if userinfo.site ~= nil then showsitbutton = 0 end
    --TraceError("�Ƿ���ʾ["..userinfo.userId.."]���°�ť:"..showsitbutton)
    local to_desk_type = deskinfo.desktype
     local to_noble_gold = 0
    if to_desk_type == g_DeskType.nobleroom and viproom_lib then
		if viproom_lib.get_room_spec_type(deskno) == 1 then 
			to_desk_type = g_DeskType.VIP
		end
		to_noble_gold = viproom_lib.get_to_noble_gold(deskinfo.smallbet)
		room_level = viproom_lib.get_room_spec_level(deskno)
    end
	netlib.send(
		function(buf)
            buf:writeString("TXNINF")
            buf:writeInt(deskno)
            --����
            buf:writeString(deskinfo.name)
            --��������:1��ͨ,2������,3VIP 10���峡
            buf:writeByte(to_desk_type)
            --�Ƿ������
            buf:writeByte(deskinfo.fast)
            --���������
            buf:writeInt(deskinfo.betgold)
            --���ӵ���ҳ���
            buf:writeInt(deskinfo.usergold)
            --�����ȼ�
            buf:writeInt(deskinfo.needlevel)
            --Сä
            buf:writeInt(deskinfo.smallbet)
            --��ä
            buf:writeInt(deskinfo.largebet)
            --��Ǯ����
            buf:writeInt(deskinfo.at_least_gold)
            --��Ǯ����
            buf:writeInt(deskinfo.at_most_gold)
            --��ˮ
            buf:writeInt(deskinfo.specal_choushui)
            --���ٿ�������
            buf:writeByte(deskinfo.min_playercount)
            --��󿪾�����
            buf:writeByte(deskinfo.max_playercount)
            --��ǰ��������
            buf:writeByte(deskinfo.playercount)
            --�Ƿ���ʾ���°�ť
            buf:writeByte(showsitbutton)
            --���ӵ�Ƶ��ID
            buf:writeInt(deskinfo.channel_id or -1)
            --���巿��Ҫ�ĵ�ע��
            buf:writeInt(to_noble_gold)
            --���巿�ĵȼ�
            buf:writeInt(room_level or 0)
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--����ҷ��ͽ�����ϸ
function net_send_todaydetail(userinfo, dt)
    if not userinfo then return end;
    --֪ͨ�ͻ��˷������
    local NoticeEnd = function(userinfo)
        netlib.send(
            function(buf)
                buf:writeString("TXNTDTEND");
            end,userinfo.ip,userinfo.port);
    end
    --û�м�¼
    if not dt or #dt <= 0 then
        netlib.send(
            function(buf)
                buf:writeString("TXNTDT");
                buf:writeInt(0);
            end,userinfo.ip,userinfo.port);
        NoticeEnd(userinfo);
        return;
    end
    --�����¼���࣬��Ҫ�ְ�����
    local packlimit = 20;  --ÿ����20����¼
    local packlist = {};
    for i=1, #dt do
        local packindex = math.floor(i/packlimit) + 1;
        if not packlist[packindex] then packlist[packindex] = {} end;
        table.insert(packlist[packindex], dt[i]);
    end
    --TraceError(packlist)
    for i = 1, #packlist do
        local sendlist = packlist[i];
        netlib.send(
            function(buf)
                buf:writeString("TXNTDT");
                buf:writeInt(#sendlist);
                for i = 1, #sendlist do
                    buf:writeString(sendlist[i]["sys_time"]);
                    buf:writeInt(sendlist[i]["smallbet"]);
                    buf:writeInt(sendlist[i]["largebet"]);
                    buf:writeInt(sendlist[i]["betgold"]);
                    buf:writeInt(sendlist[i]["wingold"]);
                    buf:writeInt(sendlist[i]["betflag"]);
                    buf:writeString(sendlist[i]["pokeweight"]);
                    buf:writeString(sendlist[i]["pokes5"]);
                end;
            end,userinfo.ip,userinfo.port);
    end;
    NoticeEnd(userinfo);
end
--����ҷ��͵�������ϸ
function net_send_detailrecord(userinfo, record)
    if not userinfo or not record then return end;
    netlib.send(
        function(buf)
            buf:writeString("TXNTSGDT");
            buf:writeString(record["sys_time"]);
            buf:writeInt(record["smallbet"]);
            buf:writeInt(record["largebet"]);
            buf:writeInt(record["betgold"]);
            buf:writeInt(record["wingold"]);
            buf:writeInt(record["betflag"]);
            buf:writeString(record["pokeweight"]);
            buf:writeString(record["pokes5"]);
        end,userinfo.ip,userinfo.port);
end
--���ڹ㲥������Ϣ
function net_broadcast_deskinfo(deskno)
    if not deskno or not desklist[deskno] then return end

    --֪ͨ������������
    for i = 1, room.cfg.DeskSiteCount do
        local tempuserkey = hall.desk.get_user(deskno,i);
        if(tempuserkey) then
            local playingUserinfo = userlist[hall.desk.get_user(deskno, i) or ""]
            if (playingUserinfo and playingUserinfo.offline ~= offlinetype.tempoffline) then
                OnSendDeskInfo(playingUserinfo, deskno)
            end
            if(playingUserinfo == nil) then
                TraceError("�쳣��Ϣ,�㲥������Ϣʱ�������и��û���userlist��ϢΪ��2")
                hall.desk.clear_users(deskno, i)
            end
        end
    end
    
    local deskinfo = desklist[deskno] 
    for k,watchinginfo in pairs(deskinfo.watchingList) do
        if (watchinginfo and watchinginfo.offline ~= offlinetype.tempoffline) then
            OnSendDeskInfo(watchinginfo, deskno)
        end
        if(watchinginfo == nil) then
            deskinfo.watchingList[k] = nil
        end
    end
end

--���͵ý�����̭����Ϣ
function net_send_prizeorlost(userinfo, mingci, givegold, addexp)
    --TraceError(format("���͵ý�����̭����Ϣ:mingci[%d], givegold[%d], addexp[%d]", mingci, givegold, addexp))
    if not userinfo then return end
    netlib.send(
        function(buf)
            buf:writeString("TXNTPZ")
            buf:writeInt(userinfo.userId)
            buf:writeByte(userinfo.site or 0)
            buf:writeByte(mingci)
            buf:writeInt(givegold)
            buf:writeInt(addexp)
        end
    , userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--�������쾭�����
function net_send_daygiveexp(userinfo, addexp)
    if not userinfo then return end
    netlib.send(
        function(buf)
            buf:writeString("TXNTXP")
            buf:writeInt(userinfo.userId);
            buf:writeByte(userinfo.site or 0);	--��Ӧ��λ��
            buf:writeInt(usermgr.getlevel(userinfo));	--�ȼ�
            buf:writeInt(addexp)  
        end
    , userinfo.ip, userinfo.port);
end

--����ѧϰ�̳��콱�ɹ�
function net_send_study_prize(userinfo, addgold)
    if not userinfo then return end
    netlib.send(
        function(buf)
            buf:writeString("STOV")
            buf:writeInt(userinfo.userId);
            buf:writeInt(addgold)  
        end
    , userinfo.ip, userinfo.port);
end

--�����������½Ǵ�����Ϣ
function net_sendsystemmsg(userinfo, msgtype, msg)
	--TraceError("net_sendsystemmsg()"..msgtype)
    --TraceError("net_sendsystemmsg()"..msg)
    if not msgtype or not msg then return end
	netlib.send(
		function(buf)
			buf:writeString("TXNTMG")
			buf:writeInt(tonumber(msgtype))
            buf:writeInt(userinfo.userId)
			buf:writeString(_U(msg))
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--����Ͷע���� ,defaultgold��Ĭ�Ϲ�����
function net_sendbuychouma(userinfo, deskno, timeout)
    local eventdata = {handle=0, userinfo=userinfo};
    eventmgr:dispatchEvent(Event("on_send_buy_chouma", eventdata));

    if(eventdata.handle == 1) then
        return;
    end

    --TraceError("net_sendbuychouma()")
    if not userinfo or not deskno then return end
    local siteno = userinfo.site or 1		--��dobuychouma����ԭ����λ���ϻ��Զ�ȥ����λ
    local gold = 0
    local deskinfo = desklist[deskno]
    local retarr = tex.getdeskdefaultchouma(userinfo, deskno, timeout)
    local defaultchouma = retarr.defaultchouma 
    if not defaultchouma then return end
    local halfhour = retarr.halfhour or 0
    local mingold = retarr.mingold or deskinfo.at_least_gold
    local maxgold = retarr.maxgold or deskinfo.at_most_gold
    local usergold = get_canuse_gold(userinfo, 1);
    local is_auto_buy_chouma=false
    if(maxgold > usergold) then
        maxgold = usergold
    end

    --��ֹ30���������Ӯ�˺ܶ�Ǯ��վ�������º�������������ڷ�������������������
   --[[ TraceError(retarr.mingold..":::"..deskinfo.at_least_gold..":::"..retarr.maxgold..":::"..deskinfo.at_most_gold)
    if(mingold>deskinfo.at_least_gold)then
        halfhour=0
        mingold=deskinfo.at_least_gold
        retarr.mingold=mingold
    end

    if(maxgold>deskinfo.at_most_gold)then
        halfhour=0
        maxgold=deskinfo.at_most_gold
        retarr.maxgold=maxgold
    end
    --]]
    if(userinfo.gameinfo==nil)then 
        userinfo.gameinfo={}
        userinfo.gameinfo.is_auto_buy=0
        userinfo.gameinfo.is_auto_addmoney=0
    end
    --�õ���������ϵ�Ǯ
    if(buy_chouma_limit(userinfo)==1)then
            if(userinfo.gameinfo.is_auto_buy==1 and userinfo.gameinfo.is_auto_addmoney==0)then --�Զ��������
                gold = userinfo.gameinfo.auto_buy_gold or retarr.defaultchouma --�Զ������ϴ����Ǯ����Ĭ�ϳ���
                if(usergold>=gold)then  --�û���Ǯ����Ҫ����Ĭ�ϳ���
                    dobuychouma(userinfo, deskno, siteno, gold)
                    is_auto_buy_chouma=true
                end
            elseif(userinfo.gameinfo.is_auto_buy==1 and userinfo.gameinfo.is_auto_addmoney==1 )then --ͬʱѡ���Զ�������Զ���ע�����⣬��ѡ�Զ���ע����������Ϸ����ʱ����ȥ����ġ�
                if(usergold>=deskinfo.at_most_gold)then
                    gold = deskinfo.at_most_gold
                else
                    gold = usergold
                end
                dobuychouma(userinfo, deskno, siteno, gold)
                is_auto_buy_chouma=true
            end
            if(is_auto_buy_chouma==false)then --����Ĵ���
                	netlib.send(
            		function(buf)
            			buf:writeString("TXNTBC")
                        buf:writeInt(deskno)
            			buf:writeInt(mingold)
            			buf:writeInt(maxgold)
            			buf:writeInt(usergold)
                        buf:writeInt(defaultchouma)
                        buf:writeInt(timeout or 0)  --�Ƿ���ʾ��ʱ
                        buf:writeByte(0)  --�Ƿ����Ѱ�Сʱǰ����
            		end
            	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
            end
    end 
 
end

--�㲥ĳ���û�����ע
function net_broadcastdesk_buxiazhu(desk, siteno)
	trace("net_broadcastdesk_buxiazhu()")
    local user_info = deskmgr.getsiteuser(desk, siteno);
	netlib.broadcastdeskex(
		function(buf)
			buf:writeString("TXNTBX")
			buf:writeByte(siteno);	--������
            buf:writeString(user_info ~= nil and user_info.nick or "");
		end
	, desk, borcastTarget.all);
end

--��һ���˷������Ӳʳ���Ϣ
function OnSendDeskPoolsInfo(userinfo, pools)
	if not userinfo then return end
	if not pools or #pools <= 0 then return end
	netlib.send(
		function(buf)
			buf:writeString("TXNTDM")
			buf:writeInt(#pools)
			for i = 1, #pools do
				buf:writeInt(pools[i])
			end
		end
	, userinfo.ip, userinfo.port)
end

--���ڹ㲥���Ӳʳ���Ϣ
function net_broadcast_deskpoolsinfo(deskno, pools)
    if not deskno or not desklist[deskno] then return end
    if not pools or #pools <= 0 then return end

    --֪ͨ������������
    for i = 1, room.cfg.DeskSiteCount do
        local tempuserkey = hall.desk.get_user(deskno,i);
        if(tempuserkey) then
            local playingUserinfo = userlist[hall.desk.get_user(deskno, i) or ""]
            if (playingUserinfo and playingUserinfo.offline ~= offlinetype.tempoffline) then
                OnSendDeskPoolsInfo(playingUserinfo, pools)
            end
            if(playingUserinfo == nil) then
                TraceError("�쳣��Ϣ,�㲥������Ϣʱ�������и��û���userlist��ϢΪ��2")
                hall.desk.clear_users(deskno, i)
            end
        end
    end
    
    local deskinfo = desklist[deskno] 
    for k,watchinginfo in pairs(deskinfo.watchingList) do
        if (watchinginfo and watchinginfo.offline ~= offlinetype.tempoffline) then
            OnSendDeskPoolsInfo(watchinginfo, pools)
        end
        if(watchinginfo == nil) then
            deskinfo.watchingList[k] = nil
        end
    end
end

--�㲥ĳ���û���ע
function net_broadcastdesk_xiazhu(deskno, siteno, ntype)
	trace("net_broadcastdesk_xiazhu()")
    if not deskno or not siteno then return end

    local deskdata = deskmgr.getdeskdata(deskno)
    local sitedata = deskmgr.getsitedata(deskno, siteno)

	local userinfo = deskmgr.getsiteuser(deskno, siteno)
    local usersex = 0
    local user_nick = "";
    if(userinfo ~= nil) then 
        usersex = userinfo.sex
        user_nick = userinfo.nick;
    end --վ����

    local betgold = sitedata.betgold
    local currbet = sitedata.betgold - sitedata.roundbet
	netlib.broadcastdeskex(
		function(buf)
			buf:writeString("TXNTXZ")
			buf:writeByte(siteno);		--��Ǯ��λ
			buf:writeInt(betgold);		--�ܵ���ע
            buf:writeInt(currbet);	    --������ע
			buf:writeByte(usersex); 	--�Ա�
			buf:writeByte(ntype); 		--��ע����  ��ע 2=��ע 3=��ע 4=��� 5=��ע 6=�ص�¼
            buf:writeString(user_nick);
		end
	, deskno, borcastTarget.all);
end

--��ȡׯ����Сä��Ϣ
function get_relogin_sitelist(deskno)
	local deskdata = deskmgr.getdeskdata(deskno)
	local siteinfolist = {}
	for k, v in pairs(deskdata.playinglist) do
		local siteinfo = {}
		local sitedata = deskmgr.getsitedata(deskno, v)
		siteinfo.siteno = v
		siteinfo.betgold = sitedata.betgold  --����ע����
		siteinfo.islose = sitedata.islose
		siteinfo.isallin = sitedata.isallin
        siteinfo.currbet = sitedata.betgold - sitedata.roundbet  --������ע����
		siteinfolist[k] = siteinfo
	end
	return siteinfolist
end

--��ĳ���û��ָ�����
function net_send_resoredesk(userinfo)
	--TraceError("net_send_resoredesk()" .. tostringex(userinfo.userId))
    if not userinfo or not userinfo.desk then return end

    local deskno = userinfo.desk
    local siteno = userinfo.site or 0
	local deskdata = deskmgr.getdeskdata(deskno)
    local sitedata = {}
    if(siteno > 0) then
        sitedata = deskmgr.getsitedata(deskno, siteno)
    end
	local siteinfolist = get_relogin_sitelist(deskno)
    local zhuangsite = deskdata.zhuangsite
	local deskpokes = deskdata.deskpokes
	local gold = sitedata.gold or 0
	local betgold = sitedata.betgold or 0
	local sitepokes = sitedata.pokes or {}
	local mybean = userinfo.gamescore

	netlib.send(
		function(buf)
			buf:writeString("TXNTRD")
            buf:writeByte(zhuangsite)
			buf:writeInt(#deskpokes)
			for i = 1, #deskpokes do
				buf:writeByte(deskpokes[i])
			end
			buf:writeInt(#sitepokes)
			for i = 1, #sitepokes do
				buf:writeByte(sitepokes[i])
			end
			buf:writeInt(gold)
			buf:writeInt(betgold)
			buf:writeInt(mybean)

			buf:writeInt(#siteinfolist)
			for i = 1, #siteinfolist do
				buf:writeByte(siteinfolist[i].siteno)
				buf:writeInt(siteinfolist[i].betgold)
				buf:writeByte(siteinfolist[i].islose)
				buf:writeByte(siteinfolist[i].isallin)
                buf:writeInt(siteinfolist[i].currbet)
			end

		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly);
end

--�����û����ݶ�
function net_sendmybean(userinfo, gold)
	netlib.send(
		function(buf)
			buf:writeString("TXREMYB");
			buf:writeInt(gold);	--������
		end
	, userinfo.ip, userinfo.port, borcastTarget.all)
end
--TODO:��ʾ������ҹ���
function get_user_extra_data(userid)
    local userinfo = usermgr.GetUserById(userid)
    if(userinfo ~= nil) then
        local retdata = {}
        retdata.userid     = userinfo.userId              --�û�ID
        retdata.nick       = userinfo.nick                --�ǳ�
        retdata.sex        = userinfo.sex                 --�Ա�
        retdata.from       = userinfo.szChannelNickName   --����
        retdata.gold       = userinfo.gamescore           --���
        retdata.exp        = usermgr.getexp(userinfo)
        retdata.face       = userinfo.imgUrl
        retdata.extra_info = userinfo.extra_info
        return retdata
    else
       --�����ݿ��ȡ
        return get_user_extradata_from_db(userid)
    end
end

--������ҵ�extrainfo��achieveinfo
function net_send_user_extrainfo_achieveinfo(userinfo, request_userinfo)
    if not userinfo or not request_userinfo then return end
    local userid     = request_userinfo.userId              --�û�ID
    local nick       = request_userinfo.nick                --�ǳ�
    local sex        = request_userinfo.sex                 --�Ա�
    local from       = request_userinfo.szChannelNickName   --����
    local gold       = request_userinfo.gamescore           --���
    local exp        = usermgr.getexp(request_userinfo)
    local face       = request_userinfo.imgUrl
    local charmlevel = request_userinfo.charmlevel or 0  --ũ�������ȼ�
    local charmvalue = request_userinfo.charmvalue or 0  --ũ������ֵ
    local charmgold = request_userinfo.charmgold or 0    --����ֵ�������ӵĳ���
    local channel_id = request_userinfo.short_channel_id or -1 --Ĭ����ʾƵ���̺�

    --�ж�����(���ǽ��վ͵�����)
    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    if(sys_today ~= userinfo.dbtoday) then --���ڲ���
		--���ò�ͬ��
		userinfo.dbtoday = sys_today
		dblib.cache_set(gamepkg.table, {today = sys_today}, "userid", userinfo.userId)
		userinfo.gameInfo.todayexp = 0
		dblib.cache_set(gamepkg.table, {todayexp = 0}, "userid", userinfo.userId)

		userinfo.extra_info["F07"] = 0
        save_extrainfo_to_db(request_userinfo)
    end

    local extra_info = request_userinfo.extra_info
    local reg_date = string.sub(extra_info["F00"],1,10)
    local max_win = extra_info["F01"]
    local pokes5 = {}
    --��ϣ�Ų�����ֻ������
    for k,v in pairs(extra_info["F02"].pokes5) do
        pokes5[k] = v
    end
    local pokeweight = extra_info["F02"].pokeweight
    local sortbypokenum = function(poke1, poke2)
        local pokenum1 = tex.pokenum[poke1] or 0
        local pokenum2 = tex.pokenum[poke2] or 0
        return pokenum1 < pokenum2
    end
    table.sort(pokes5, sortbypokenum)
    local play_count = extra_info["F03"]
    local win_count = extra_info["F04"]
    local max_gold = extra_info["F05"]
    local friend_count = extra_info["F06"]
    local today_winlost = extra_info["F07"]
    local deskmatchwin = extra_info["F08"]

    --------------------�õ���ɳɾ͵���Ϣ-----
    local completetable = achievelib.getcompleteachieve(request_userinfo)
    -------------------------------------------

    -------------------�õ�VIP��Ϣ-------------
    --local isvip = viplib.get_user_vip_info(request_userinfo) and 1 or 0
    local vip_level = viplib.get_vip_level(request_userinfo)
    --TraceError("����������Ϣvip�ȼ�:"..vip_level)
    -------------------------------------------

    --ÿ�մ�����ɵĴ���
    local success
    local tex_daren_count=0
    if(tex_dailytask_lib)then
         success, tex_daren_count = xpcall(function() return tex_dailytask_lib.get_tex_daren_count(request_userinfo) end, throw)
    end
    
    local kick_card_count = 0
    local speaker_count = 0
    if(request_userinfo.propslist ~= nil) then 
        kick_card_count = request_userinfo.propslist[tex_gamepropslib.PROPS_ID.KICK_CARD_ID] or 0
        speaker_count = request_userinfo.propslist[tex_gamepropslib.PROPS_ID.SPEAKER_ID] or 0
    end

	netlib.send(
		function(buf)
    	    buf:writeString("RQPEXT");
    	    --������Ϣ
    	    buf:writeInt(userid)    --�û�ID
    	    buf:writeString(nick)   --�ǳ�
    	    buf:writeByte(sex)      --�Ա�
    	    
			if(request_userinfo.mobile_mode~=nil and request_userinfo.mobile_mode==2)then 
				buf:writeString(string.HextoString(from).._U("���ֻ��ͻ��ˣ�")) 
			else 
				buf:writeString(string.HextoString(from)) --���� 
			end
    	    buf:writeInt(gold)      --���
            buf:writeInt(exp)       --���� 
    	    buf:writeString(face)   --ͷ��
    
    	    buf:writeString(reg_date)
    	    buf:writeInt(max_win)
    	    --�������
            buf:writeString(pokeweight)
    	    buf:writeByte(#pokes5)
            for i = 1, #pokes5 do
    	        buf:writeByte(pokes5[i])
    	    end
    	    buf:writeInt(play_count)
    	    buf:writeInt(win_count)
    	    buf:writeInt(max_gold)
    	    buf:writeInt(friend_count)
    	    buf:writeInt(today_winlost)
            buf:writeInt(deskmatchwin)
            buf:writeString(os.time())--ϵͳ��ǰʱ��
            buf:writeInt(#completetable)--�ɾ�ID����
            for i = 1,#completetable do
                buf:writeInt(tonumber(completetable[i]["id"]))
                buf:writeString(completetable[i]["time"])
            end
            buf:writeByte(vip_level)--VIP�ȼ�
            buf:writeInt(charmlevel)
            buf:writeInt(charmvalue)
            buf:writeInt(charmgold)
            buf:writeInt(channel_id)
            buf:writeInt(tex_daren_count or 0)--���Ӳ�����ÿ��������ɴ�����int
            buf:writeInt(request_userinfo.home_status or 0) --��԰�Ŀ�ͨ���
            buf:writeInt(kick_card_count)--���˿�����
            buf:writeInt(request_userinfo.safeboxnum or 0)--���������
            buf:writeInt(speaker_count)--С��������
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--������ҵ�extrainfo
function net_send_user_extrainfo(userinfo, request_userinfo)
    if not userinfo or not request_userinfo then return end

    local userid     = request_userinfo.userId              --�û�ID
    local nick       = request_userinfo.nick                --�ǳ�
    local sex        = request_userinfo.sex                 --�Ա�
    local from       = request_userinfo.szChannelNickName   --����
    local gold       = request_userinfo.gamescore           --���
    local exp        = usermgr.getexp(request_userinfo)
    local face       = request_userinfo.imgUrl 
    local charmlevel = request_userinfo.charmlevel or 0  --ũ�������ȼ�
    local charmvalue = request_userinfo.charmvalue or 0  --ũ������ֵ
    local charmgold  = request_userinfo.charmgold or 0    --����ֵ�������ӵĳ���
    local channel_id = request_userinfo.short_channel_id or -1; --Ĭ����ʾƵ���̺�

    --�ж�����(���ǽ��վ͵�����)
    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    if(sys_today ~= userinfo.dbtoday) then --���ڲ���
		--���ò�ͬ��
		userinfo.dbtoday = sys_today
		dblib.cache_set(gamepkg.table, {today = sys_today}, "userid", userinfo.userId)
		userinfo.gameInfo.todayexp = 0
		dblib.cache_set(gamepkg.table, {todayexp = 0}, "userid", userinfo.userId)

		userinfo.extra_info["F07"] = 0
        save_extrainfo_to_db(request_userinfo)
    end

    local extra_info = request_userinfo.extra_info
    if not extra_info then return end
    local reg_date = string.sub(extra_info["F00"],1,10)
    local max_win = extra_info["F01"]
    local pokes5 = {}
    --��ϣ�Ų�����ֻ������
    for k,v in pairs(extra_info["F02"].pokes5) do
        pokes5[k] = v
    end
    local pokeweight = extra_info["F02"].pokeweight
    local sortbypokenum = function(poke1, poke2)
        local pokenum1 = tex.pokenum[poke1] or 0
        local pokenum2 = tex.pokenum[poke2] or 0
        return pokenum1 < pokenum2
    end
    table.sort(pokes5, sortbypokenum)
    local play_count = extra_info["F03"]
    local win_count = extra_info["F04"]
    local max_gold = extra_info["F05"]
    local friend_count = extra_info["F06"]
    local today_winlost = extra_info["F07"]
    local deskmatchwin = extra_info["F08"]
    
    -------------------�õ�VIP��Ϣ-------------
    --local isvip = viplib.get_user_vip_info(request_userinfo) and 1 or 0
    local vip_level = viplib.get_vip_level(request_userinfo)
    -------------------------------------------
    local tex_daren_count = 0
    if(request_userinfo.wdg_huodong ~= nil) then
        tex_daren_count = request_userinfo.wdg_huodong.daren_count or 0
    end

    local kick_card_count = 0
    local speaker_count = 0
    if(request_userinfo.propslist ~= nil) then 
        kick_card_count = request_userinfo.propslist[tex_gamepropslib.PROPS_ID.KICK_CARD_ID] or 0
        speaker_count = request_userinfo.propslist[tex_gamepropslib.PROPS_ID.SPEAKER_ID] or 0
    end

    
	netlib.send(
		function(buf)
    	    buf:writeString("RQMIXT");
    	    --������Ϣ
    	    buf:writeInt(userid)    --�û�ID
    	    buf:writeString(nick)   --�ǳ�
    	    buf:writeByte(sex)      --�Ա�
    	    if(request_userinfo.mobile_mode~=nil and request_userinfo.mobile_mode==2)then

    	    	buf:writeString(string.HextoString(from).._U("���ֻ��ͻ��ˣ�"))
    	    else
    	    	buf:writeString(string.HextoString(from))   --����
    	    end
    	    buf:writeInt(gold)      --���
            buf:writeInt(exp)       --���� 
    	    buf:writeString(face)   --ͷ��
    
    	    buf:writeString(reg_date)
    	    buf:writeInt(max_win)
    	    --�������
            buf:writeString(pokeweight)
    	    buf:writeByte(#pokes5)
            for i = 1, #pokes5 do
    	        buf:writeByte(pokes5[i])
    	    end
    	    buf:writeInt(play_count)
    	    buf:writeInt(win_count)
    	    buf:writeInt(max_gold)
    	    buf:writeInt(friend_count)
    	    buf:writeInt(today_winlost)
            buf:writeInt(deskmatchwin)
            buf:writeByte(vip_level)--�Ƿ���VIP��־
            buf:writeInt(charmlevel)
            buf:writeInt(charmvalue)
            buf:writeInt(charmgold)
            buf:writeInt(channel_id)
            buf:writeInt(tex_daren_count)--ÿ��������ɴ���
            buf:writeInt(kick_card_count)--���˿�����
            buf:writeInt(request_userinfo.safeboxnum or 0)--���������
            buf:writeInt(request_userinfo.home_status or 0)--��԰��ͨ����״̬
            buf:writeInt(speaker_count)--С��������
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--�㲥ĳ����ҵ���������
function net_broadcastdesk_charmchange(userinfo)
    if not userinfo then return end
    local site = userinfo.site or 0
    local charmlevel = userinfo.charmlevel or 0
    local charmvalue = userinfo.charmvalue or 0
    local charmgold = userinfo.charmgold or 0
    local sendFun = function(buf)
        buf:writeString("CHARMINFO")
        buf:writeInt(userinfo.userId)
        buf:writeByte(site)
        buf:writeInt(charmlevel)
        buf:writeInt(charmvalue)
        buf:writeInt(charmgold)
    end
    --�㲥����������
    if(userinfo.desk and userinfo.site)then
        netlib.broadcastdesk(sendFun, userinfo.desk, borcastTarget.all)
    end
end

--֪ͨĳ����ҵ�����������
function net_send_charmchange(myuserinfo, touserinfo)
    if not myuserinfo or not touserinfo then return end
    local site = myuserinfo.site or 0
    local charmlevel = myuserinfo.charmlevel or 0
    local charmvalue = myuserinfo.charmvalue or 0
    local charmgold = myuserinfo.charmgold or 0
    netlib.send(function(buf)
                    buf:writeString("CHARMINFO")
                    buf:writeInt(myuserinfo.userId)
                    buf:writeByte(site)
                    buf:writeInt(charmlevel)
                    buf:writeInt(charmvalue)
                    buf:writeInt(charmgold)
                end, touserinfo.ip, touserinfo.port)
end


--�㲥ĳ��ҵ��˿�ʼ
function net_broadcastdesk_ready(desk, sitenowhostart)
	trace("net_broadcastdesk_ready()")
	netlib.broadcastdesk(
		function(buf)
			buf:writeString("TXREST")
			buf:writeByte(sitenowhostart);
		end
	, desk, borcastTarget.all);
end

--�㲥��Ϸ��ʼ
function net_broadcastdesk_gamestart(desk)
	trace("net_broadcastdesk_gamestart()")
	netlib.broadcastdesk(
		function(buf)
			buf:writeString("TXNTGT")
		end
	, desk, borcastTarget.all);
end

--�㲥������
function net_broadcast_deskpokes(deskno)
	--TraceError("net_broadcast_deskpokes()")
	local deskdata = deskmgr.getdeskdata(deskno)
	local deskpokes = deskdata.deskpokes
	netlib.broadcastdeskex(
		function(buf)
			buf:writeString("TXNTDP")
			buf:writeInt(#deskpokes)
			for i = 1, #deskpokes do
				buf:writeByte(deskpokes[i])
			end
		end
	, deskno, borcastTarget.all);
end

--�����û�
function net_send_BBS_URL(userinfo, bbs_auth)
	netlib.send(
		function(buf)
			buf:writeString("TXNBBS");
            buf:writeString(bbs_auth);
		end
	, userinfo.ip, userinfo.port)
end

--�����û�
function net_kickuser(userinfo)    
	netlib.send(
		function(buf)
			buf:writeString("REKU");
		end
	, userinfo.ip, userinfo.port)
    eventmgr:dispatchEvent(Event("on_user_kicked", {user_info = userinfo}));
end

--�㲥������״̬
function net_broadcastdesk_playerinfo(desk)
	trace("net_broadcastdesk_playerinfo()")
	netlib.broadcastdesk(
		function(buf)
			local len = 0;
			local data = {};
			for _, player in pairs(deskmgr.getplayers(desk)) do
				local state = hall.desk.get_site_state(desk, player.siteno)
				local statecode = 0
				if state == SITE_STATE.NOTREADY then statecode = 2 end
				if state == SITE_STATE.READYWAIT then statecode = 1 end
				if state == SITE_STATE.LEAVE then statecode = 4 end
                if state == SITE_STATE.PANEL then statecode = 5 end
                if state == SITE_STATE.BUYCHOUMA then statecode = 6 end
               
				local timeout, delay = hall.desk.get_site_timeout(desk, player.siteno)

                --delay�����������¼�����������²�׼����Ҫ���¶�ȡ����ʱ�䣬�����ܿ��ƻ�����API��ȡ����ʱ��
                local delay = SITE_STATE.PANEL[3]
                local deskinfo = desklist[desk]
		        if deskinfo.fast == 1 then delay = tex.cfg.fastdelay end

                 --��2���ǿ��ǵ�������ʱ���¿ͻ��˼�ʱδ�����ͱ�ǿ�ƴ�����
                --timeout = timeout - 2
				if timeout < 0 then
                    timeout = 0
                    delay = 0
                end
				table.insert(data, {site = player.siteno, state = statecode, time = timeout, delay = delay});
				len = len + 1
				--trace("siteno,statecode,timeout=".. player.siteno .. "," .. statecode .. "," .. timeout)
			end
			buf:writeString("TXNTZT")
			buf:writeInt(len)
			for i = 1, #data do
				buf:writeByte(data[i].site);		--��λ��
				buf:writeByte(data[i].state)		--״̬��
				buf:writeByte(data[i].time)		--��ʱʱ��
                buf:writeByte(data[i].delay)	--��ʱʱ��
			end
		end
	, desk, borcastTarget.all);
end

--���ŷ��ƶ���
function net_send_fapai(userinfo, sitelist, siteno, pokes)
	netlib.send(
		function(buf)
			buf:writeString("TXREFP")
            buf:writeByte(siteno)
            buf:writeInt(#sitelist)
			for i = 1, #sitelist do
				buf:writeByte(sitelist[i])
			end
			buf:writeInt(#pokes)
			local prevpokeid = -1
			for i = 1, #pokes do
				buf:writeByte(pokes[i])
				if(prevpokeid == pokes[i] or pokes[i]<=0 or pokes[i] > 52) then
					TraceError(format("���Ӻ�:%d�������쳣", userinfo.desk or 0))
					TraceError(desklist[userinfo.desk])
				end
				prevpokeid = pokes[i]
			end
		end
	, userinfo.ip, userinfo.port)
end

--���ŷ��ƶ���(����ս�û�)
function net_send_fapai_forwatching(deskno, sitelist)
    local pokes = {55, 55}
    local desk_info = desklist[deskno]
    for k, v in pairs(desk_info.watchingList) do
        local send = 1;
        if(duokai_lib) then
            local sub_user_id = duokai_lib.get_cur_sub_user_id(v.userId);
            if(sub_user_id > 0) then
                local sub_user_info = usermgr.GetUserById(sub_user_id)
                if(sub_user_info.desk and sub_user_info.site and sub_user_info.desk == deskno) then
                    send = 0;
                end
            end
        end
        if (duokai_lib == nil or  --û�ж࿪ģ��
            (duokai_lib and duokai_lib.is_sub_user(v.userId) == 0) and send == 1) then  --�������˺�
            netlib.send(function(buf)
                buf:writeString("TXREFP")
                buf:writeByte(-1)
                buf:writeInt(#sitelist)
                for i = 1, #sitelist do
                    buf:writeByte(sitelist[i])
                end
                buf:writeInt(#pokes)
                for i = 1, #pokes do
                    buf:writeByte(pokes[i])
                end
            end, v.ip, v.port)
       end
    end
end

--��������ҵ�ǰ�������
function net_send_bestpokes(userinfo, weight, pokes)
    if not userinfo then return end
	netlib.send(
		function(buf)
			buf:writeString("TXREBP")
			buf:writeString(weight)		--���ж���Ǹ����֡���һλ�������͡�1-9���������ʼ�ͬ��˳��
			buf:writeInt(#pokes)
			for i = 1, #pokes do
				buf:writeByte(pokes[i])
			end
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end
-----------------------------------------------�������------------------------------
--��ʾ�̵�ĵ������б�
function net_send_gift_shop(userinfo, giftlist)
    if not userinfo or type(giftlist) ~= "table" then return end
	netlib.send(
		function(buf)
			buf:writeString("TXGFSP")
			buf:writeInt(#giftlist)
			for _, gift_item in pairs(giftlist) do
				buf:writeInt(gift_item.id or 0)				--��ƷID������ʱ����ID����
				buf:writeInt(gift_item.price or 0)			--��Ʒ�۸�
			end
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end


--��ʾĳ��ҵ������ʶ
function net_send_gift_icon(userinfo, site, giftid)
    if(not userinfo.desk) then return end
    local deskinfo = desklist[userinfo.desk]

    netlib.send(
		function(buf)
			buf:writeString("TXSPBZ")
			buf:writeByte(site)
			buf:writeInt(giftid or 0)
		end
	, userinfo.ip, userinfo.port)
end

--���������ﶯ��
function net_broadcast_give_gift(deskno, fromsite, tositeno, giftid, typenumber, props_number)
    local deskinfo = desklist[deskno]
    local from_user_id = 0;
    local to_user_id = 0;
    local from_user_nick = "";
    local to_user_nick = "";
    if deskinfo.site[fromsite].user ~= nil then
        local from_user_info = userlist[deskinfo.site[fromsite].user];
        from_user_id = from_user_info ~= nil and from_user_info.userId or 0;
        from_user_nick = from_user_info ~= nil and from_user_info.nick or "";
    end

    if deskinfo.site[tositeno].user ~= nil then
        local to_user_info = userlist[deskinfo.site[tositeno].user];
        to_user_id = to_user_info ~= nil and to_user_info.userId or 0;
        to_user_nick = to_user_info ~= nil and to_user_info.nick or 0;
    end

    if not typenumber then
    	typenumber = 0
    end
    if not props_number then
    	props_number = 1
    end

	netlib.broadcastdeskex(
		function(buf)
			buf:writeString("TXZSLW")
			buf:writeByte(fromsite);	--from��λ��
			buf:writeByte(tositeno);	--to��λ��
			buf:writeInt(giftid);	    --��Ǯ��
            buf:writeByte(typenumber);           --���ͣ�0,�������9����ʾҪ���ŵĶ����ǵ���
			buf:writeInt(props_number);
            buf:writeInt(from_user_id or 0);
            buf:writeInt(to_user_id or 0);
            buf:writeString(from_user_nick or "");
            buf:writeString(to_user_nick or "");
		end
	, deskno, borcastTarget.all);
end

--���ŷ����鶯��
function net_broadcast_emot(deskno, fromsite, emotid)
    local deskinfo = desklist[deskno]

	netlib.broadcastdesk(
		function(buf)
			buf:writeString("TXPLEM")
			buf:writeByte(fromsite);	--from��λ��
			buf:writeInt(emotid);		--����ID
		end
	, deskno, borcastTarget.all);
end

--��������ʧ��
function net_send_gift_faild(userinfo, retcode, gift_id, gift_num, gift_type)
    local deskinfo = desklist[userinfo.desk]

	netlib.send(
		function(buf)
			buf:writeString("TXBGFD")
			buf:writeByte(retcode)	--1=�ɹ���Ǯ 2=Ǯ���� 0=�����쳣 3=�Է���������
            buf:writeInt(gift_id or 0);
            buf:writeInt(gift_num or 0);
            buf:writeInt(gift_type or 0);
		end
	, userinfo.ip, userinfo.port, borcastTarget.playingOnly)
end

--������������ʧ��(����ʧ��)
function net_send_gift_faildlist(userinfo, failedlist)
    if(not userinfo or not failedlist) then
        return
    end
	netlib.send(
		function(buf)
			buf:writeString("TXBGFF")
            buf:writeInt(#failedlist)
            for i = 1, #failedlist do
                buf:writeByte(failedlist[i].site)	
                buf:writeInt(failedlist[i].retcode) --1=�ɹ���Ǯ 2=Ǯ���� 3=���쳬���޶��� 4=�������� 0=�����쳣
            end
		end
	, userinfo.ip, userinfo.port)
end

--������Ʒ���
--recode:1�ɹ�������ʧ��
function net_send_sale_gift(userinfo, retcode, addgold)
	netlib.send(
		function(buf)
			buf:writeString("TXGFSL")
			buf:writeInt(retcode)
			buf:writeInt(addgold)
		end
	, userinfo.ip, userinfo.port);
end

--��ʾĳ��ҵ������б�
function net_send_gift_list(userinfo, giftinfo, touserinfo)
    local deskinfo = desklist[userinfo.desk]
    --���˳�
    local newgiftinfo = {};
    local totalcount = 0;
    for index, gift_item in pairs(giftinfo) do
        totalcount = totalcount + 1;
        if(parkinglib.is_parking_item(gift_item.id) == 0) then
            newgiftinfo[index] = gift_item;
        end
    end
    giftinfo = newgiftinfo;
	netlib.send(
		function(buf)
			buf:writeString("TXGLST")
			local len = 0
			for index, gift_item in pairs(giftinfo) do
				len = len + 1
            end
            buf:writeInt(totalcount);
			buf:writeInt(len)
			for index, gift_item in pairs(giftinfo) do
				buf:writeInt(gift_item.index)				--��������һ�������������б�ʱ�����������
				buf:writeInt(gift_item.id)					--������  ��������ʾɶͼƬ
				buf:writeByte(gift_item.isusing)			--�Ƿ�����ʹ�� 1=�ǣ�0=����
                buf:writeByte(gift_item.cansale)			--�Ƿ���Գ��� 1=�ǣ�0=����
                buf:writeInt(gift_item.salegold)			--���ռ۸�
        if (not gift_item.fromuserid) or (touserinfo.userId == gift_item.fromuserid) then
        	buf:writeString("")	
        else
					buf:writeString(gift_item.fromuser)			--�����˵�����
				end
			end
		end
	, userinfo.ip, userinfo.port)
end
--������Ʒ���а����ݵ��ͻ���
function net_send_giftrank(userinfo, ranklist)
    if not userinfo or not ranklist then return end
	netlib.send(
		function(buf)
			buf:writeString("TXGFPH")
			buf:writeInt(#ranklist)
			for i=1, #ranklist do
				buf:writeInt(ranklist[i].userid)			--���ID
                buf:writeString(ranklist[i].nick)			--����ǳ�
				buf:writeInt(ranklist[i].counts)			--ӵ������֮�ĸ���
                buf:writeInt(ranklist[i].paiming)			--����
			end
		end
	, userinfo.ip, userinfo.port)
end

function net_broadcast_gift_response(deskno, fromsite, tositeno, response_id)
    if not fromsite or not tositeno then return end
	netlib.broadcastdesk(
		function(buf)
			buf:writeString("TXGFRP")
			buf:writeInt(fromsite);	--from��λ��
			buf:writeInt(tositeno);	--to��λ��
			buf:writeInt(response_id);	--��Ǯ��
		end
	, deskno, borcastTarget.all);
end
-------------------

--�㲥������Ϸ��Ϣ
function net_broadcast_chat_message(deskno, msg)
	netlib.broadcastdesk(
		function(buf)
			buf:writeString("REDC")
			buf:writeByte(8)      					--game chat
			buf:writeString(msg)     				--text
			buf:writeInt(0)         				--user id
			buf:writeString("") 					--user name
		end
	, deskno, borcastTarget.all);
end 

-------------------------------------------------������ģ�����-----------------------------------
--���ظ��ͻ��˵���������Ľ��
function net_send_user_safebox_case(userinfo,nType,safegold)
	netlib.send(
		function(buf)
			buf:writeString("TXSBIF")
			buf:writeByte(nType)--0��ʾ����VIP,1��ʾ��һ�ο�ͨ,2�ѿ�ͨ�鿴
            if nType > 0 then
                buf:writeByte(userinfo.safeboxnum or 0)--����ҿ���ӵ�е�������
            end
			if safegold then
				buf:writeInt(safegold) --�������е�Ǯ
			end
		end,userinfo.ip,userinfo.port)
end

function net_send_user_getsetgold_case(userinfo,result,nowgold)
	netlib.send(
		function(buf)
			buf:writeString("TXSBSG")
			buf:writeByte(result)--0��ʾ���ɹ�,1�ɹ��������
			buf:writeInt(nowgold)--��ҵ�ǰ�ı������е�Ǯ
		end,userinfo.ip,userinfo.port)
end

--֪ͨ�ͻ��˻��ж�����ſ��Խ�Ǯ���뱣����
function net_send_lefttime_cansave(userinfo, lefttime)
	netlib.send(
		function(buf)
			buf:writeString("TXSBSE")
			buf:writeInt(math.floor(lefttime))
		end,userinfo.ip,userinfo.port)
end

--���������Ľ������
function net_send_setpw_case(userinfo,result)
	netlib.send(
		function(buf)
			buf:writeString("TXSBPW")
			buf:writeByte(result)--0��ʾ���ɹ�,1�ɹ��������
		end,userinfo.ip,userinfo.port)
end

--ȡǮʱ��������������
function net_send_getgoldpw_case(userinfo)
    netlib.send(
		function(buf)
			buf:writeString("TXSBGP")
		end,userinfo.ip,userinfo.port)
end
---------------------------------------------�������ֽ̳����---------------------------------
--֪ͨ�ͻ�����ʾ��ӭ����
function net_send_welcome_tex(userinfo)
    netlib.send(
        function(buf)
            buf:writeString("TXWELCM")
    end, userinfo.ip, userinfo.port)
end
----------------------------------------------------------------------------------------------


