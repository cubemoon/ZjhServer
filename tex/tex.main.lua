--�������дӶ���->�߼����� �Լ� �߼�����->���� ��ĳ���
--trace = netbuf.trace
trace("svrgamesohainit.lua loaded!!!")
dofile("games/tex/logic/rule.lua")
dofile("games/tex/tex.gift.lua")
dofile("games/tex/tex.safebox.lua")
dofile("games/tex/tex.achievement.lua")
dofile("games/tex/tex.suanpaiqi.lua")
dofile("games/tex/tex.gameprops.lua")
dofile("games/tex/tex.speaker.lua")
dofile("games/tex/tex.userdiy.lua")
dofile("games/tex/tex.ipprotect.lua")
dofile("games/tex/tex.channelyw.lua")
dofile("games/tex/tex.dhome.lua")
--dofile("games/modules/duokai/duokai.lua")  --ע��࿪ģ��һ��Ҫ������ģ������ļ���
--dofile("games/modules/duokai/duokai_data_merge.lua")
--dofile("games/tex/tex.match.lua")
--math.randomseed(os.clock())
--math.randomseed(math.random(1, 65536)+os.clock())

--tex.pokechar Ӧ���� preinit ��

tex.name = "tex"
tex.table = "user_tex_info"
gamepkg = tex

tTexSqlTemplete =
{
    --���������־
    insertLogRound = "call sp_tex_insert_log_round(%s)",
}
tTexSqlTemplete = newStrongTable(tTexSqlTemplete)

-----------------------------------
--δ׼��-��ʱ
function ss_notready_timeout(userinfo)
	local deskno, siteno = userinfo.desk, userinfo.site
	if(not deskno or not siteno) then return end
	local deskinfo = desklist[deskno]
	hall.desk.set_site_state(deskno, siteno, SITE_STATE.READYWAIT)
	
	if deskmgr.get_game_state(deskno) == gameflag.notstart then
		trystartgame(deskno) 
	end
end

--δ׼��-����
function ss_notready_offline(userinfo)
	local deskno, siteno = userinfo.desk, userinfo.site
	local deskinfo = desklist[deskno]
	if(deskinfo.desktype == g_DeskType.tournament or 
       deskinfo.desktype == g_DeskType.channel_tournament or 
       deskinfo.desktype == g_DeskType.match)then
		hall.desk.set_site_state(deskno, siteno, SITE_STATE.LEAVE)
		if deskmgr.get_game_state(deskno) == gameflag.notstart then
			trystartgame(deskno) 
		end
	else
		hall.desk.set_site_state(userinfo.desk, userinfo.site, NULL_STATE)
	end
end

--׼����ʼǰ-����
function ss_readywait_offline(userinfo)
	local deskno, siteno = userinfo.desk, userinfo.site
	local deskinfo = desklist[deskno]
	if(deskinfo.desktype == g_DeskType.tournament or 
       deskinfo.desktype == g_DeskType.channel_tournament or 
       deskinfo.desktype == g_DeskType.match)then
		hall.desk.set_site_state(deskno, siteno, SITE_STATE.LEAVE)
		if deskmgr.get_game_state(deskno) == gameflag.notstart then
			trystartgame(deskno) 
		end
	else
		hall.desk.set_site_state(userinfo.desk, userinfo.site, NULL_STATE)
	end
end

--���-����
function ss_panel_offline(userinfo)
	local deskno = userinfo.desk
	local siteno = userinfo.site
	if(not deskno or not siteno) then return end
	local deskinfo = desklist[deskno]

    if(deskinfo.desktype == g_DeskType.tournament or 
       deskinfo.desktype == g_DeskType.channel_tournament or
       deskinfo.desktype == g_DeskType.match)then
        --�Զ�����
    	letusergiveup(userinfo)
        hall.desk.set_site_state(deskno, siteno, SITE_STATE.LEAVE)
   --[[
    elseif(deskinfo.desktype == g_DeskType.match) then
        auto_chu_pai(userinfo);
    --]]
    else
        hall.desk.set_site_state(deskno, siteno, NULL_STATE)
    end
end

--���-��ʱ
function ss_panel_timeout(userinfo)
	local deskno = userinfo.desk
	local siteno = userinfo.site
	if(not deskno or not siteno) then return end
	local deskinfo = desklist[deskno]
	
	--�Զ�����
	letusergiveup(userinfo)
	local deskinfo =  desklist[deskno]
	--�Ǿ�����������֮���Զ�վ��
	if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and deskinfo.desktype ~= g_DeskType.match) then
		--վ�𲢼����ս
		doStandUpAndWatch(userinfo)
		net_sendbuychouma(userinfo, deskno);
	end
end

--�ȴ�-����
function ss_wait_offline(userinfo)
	local deskno = userinfo.desk
	local siteno = userinfo.site
	local deskinfo = desklist[deskno]
	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament)then
		hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.LEAVE)
	else
		hall.desk.set_site_state(deskno, siteno, NULL_STATE)
	end
end

--���߳�ʱ
function ss_leave_timeout(userinfo)
	local deskno = userinfo.desk
	local siteno = userinfo.site
	local deskinfo = desklist[deskno]
	--ֻ�б���������Ҫ����������ң������������һ������ߵ�˲�䱻����
	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament)then
		hall.desk.set_site_state(deskno, siteno, NULL_STATE)
		tex.forceGameOverUser(userinfo)

		DoKickUserOnNotGame(userinfo.key, false)
	end
end

--�õ���ˮ
function get_specal_choushui(deskinfo,userinfo)
	local choushui = deskinfo.specal_choushui;
	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(userinfo)
    end
	
	if(deskinfo.smallbet==1000)then
		if(vip_level<2)then
			choushui=500
		end
	elseif(deskinfo.smallbet==2000)then
		if(vip_level<2)then
			choushui=900
		end
	elseif(deskinfo.smallbet==5000)then
		if(vip_level>=2 and vip_level<=3)then
			choushui=3500
		elseif(vip_level<=1)then
			choushui=4000
		end
	elseif(deskinfo.smallbet==10000)then
		if(vip_level>=2 and vip_level<=3)then
			choushui=6500
		elseif(vip_level<=1)then
			choushui=7000
		end	
	elseif(deskinfo.smallbet==20000)then
		if(vip_level>=2 and vip_level<=3)then
			choushui=8500
		elseif(vip_level<=1)then
			choushui=9000
		end
	elseif(deskinfo.smallbet==25000)then
		if(vip_level>=2 and vip_level<=3)then
			choushui=11000
		elseif(vip_level<=1)then
			choushui=12000
		end		
	elseif(deskinfo.smallbet==40000)then
		if(vip_level>=2 and vip_level<=3)then
			choushui=17000
		elseif(vip_level<=1)then
			choushui=18000
		end	
	elseif(deskinfo.smallbet==50000)then
		if(vip_level>=2 and vip_level<=3)then
			choushui=26000
		elseif(vip_level<=1)then
			choushui=27000
		end										
	end
	return choushui
	
end

--�����-����
function ss_buychouma_offline(userinfo)
	local deskno, siteno = userinfo.desk, userinfo.site
	if not deskno or not siteno then return end
	local deskinfo = desklist[deskno]
	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament or deskinfo.desktype == g_DeskType.match)then
		return
	else
		hall.desk.set_site_state(userinfo.desk, userinfo.site, NULL_STATE)
		doStandUpAndWatch(userinfo)
		DoKickUserOnNotGame(userinfo.key, false)
	end
end

--�����-��ʱ
function ss_buychouma_timeout(userinfo)
	local deskno, siteno = userinfo.desk, userinfo.site
	if not deskno or not siteno then return end
	local deskinfo = desklist[deskno]
	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament or deskinfo.desktype == g_DeskType.match)then
		return
	else
		hall.desk.set_site_state(userinfo.desk, userinfo.site, NULL_STATE)
		doStandUpAndWatch(userinfo)
	end
end

--��λ״̬�ı�
function ss_onstatechange(deskno, siteno, oldstate, newstate)
	trace("ss_statechanged()")
	local userinfo = deskmgr.getsiteuser(deskno, siteno)
	if userinfo ~= nil then
		if userinfo.desk and newstate ~= SITE_STATE.NOTREADY then
			net_broadcastdesk_playerinfo(userinfo.desk)
		end
	end
end

function doStandUpAndWatch(userinfo,retcode)
	if not userinfo or not userinfo.desk or not userinfo.site then return end
	local deskno = userinfo.desk
	local siteno = userinfo.site


	--����(ʹ��վ��)
	hall.desk.set_site_state(deskno, siteno, NULL_STATE)
	--TraceError("doStandUpAndWatch:::::ret:"..retcode);
	doUserStandup(userinfo.key, false,retcode)
	--��Ϊ��ս
	DoUserWatch(deskno, userinfo,retcode)
end
---------------------------

-- ʵ��״̬����ӿ�
tex.TransSiteStateValue = function(state)
	local state_value
	if state == NULL_STATE then
		state_value = SITE_UI_VALUE.NULL
	elseif state == SITE_STATE.NOTREADY then
		state_value = SITE_UI_VALUE.NOTREADY
	elseif state == SITE_STATE.READYWAIT then
		state_value = SITE_UI_VALUE.READY
	elseif (state == SITE_STATE.PANEL) or
			(state == SITE_STATE.WAIT) or
			(state == SITE_STATE.LEAVE) then
		state_value = SITE_UI_VALUE.PLAYING
	else
		state_value = SITE_UI_VALUE.NULL
	end

	return state_value
end

--�û�����
tex.AfterUserSitDown = function(userid, desk, site, sit_type)  --�û����º�
	trace("�������£�������`````" .. "desk=" .. desk .. "site=" .. site)
	local userinfo = deskmgr.getsiteuser(desk, site) 
	if not userinfo then return end
	local deskinfo = desklist[desk]

	if deskinfo.playercount == 1 then
		deskmgr.initdeskdata(desk)
	end
	if (sit_type == g_sittype.relogin) then
		deskinfo.gamedata.rounddata.sitecount[site] = 0  --���ô���λ�������������Ϊ0
	end
	if (deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) and 
		userinfo.gamescore < deskinfo.at_least_gold + deskinfo.specal_choushui then
		--վ�𲢹�ս
		doStandUpAndWatch(userinfo)
	end

	if (deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then
		--�������Ķ����������
		deskinfo.betgold = 0
	end

	--��ͨ���»��Ŷӣ������Ƕ�������
	if(sit_type == g_sittype.normal or sit_type == g_sittype.queue) then
		if hall.desk.get_site_state(desk, site) ~= NULL_STATE then
			TraceError("������״̬����ΪNULL_STATE")
		end

		--�Ŷӽ������Զ������
		if(sit_type == g_sittype.queue) then
			local retarr = tex.getdeskdefaultchouma(userinfo, desk)
			local defaultchouma = retarr.defaultchouma or 0
			dobuychouma(userinfo, desk, site, defaultchouma)
		end

		--����ʱ��������벻��������Ҫ���͹��������ʾ
		local user_chouma = userinfo.chouma or 0
		local at_least_gold = deskinfo.at_least_gold
		local at_most_gold = deskinfo.at_most_gold
		if (deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament) and user_chouma < deskinfo.at_least_gold then
			net_sendbuychouma(userinfo, desk);
		end

		--------------�ɾ�ϵͳ�ɼ�-----------------
		if userinfo.friends then
			if userinfo.extra_info["F06"] >= 20 then
				achievelib.updateuserachieveinfo(userinfo,1001);--������
			end
			if userinfo.extra_info["F06"] >= 50 then
				achievelib.updateuserachieveinfo(userinfo,2005);--��������
			end
			if userinfo.extra_info["F06"] >= 100 then
				achievelib.updateuserachieveinfo(userinfo,3004);--����������
			end
		end

		achievelib.updateuserachieveinfo(userinfo,1005);--��ӭ����

		if userinfo.chouma >= 1000000 then
			achievelib.updateuserachieveinfo(userinfo,3008)--���򸻺�
		end
		-------------------------------------------

		--�����жϣ��������ʱ��Ϸ�Ѿ�����������Ϊ�ȴ�
		local gamestate = deskmgr.get_game_state(desk)
		if gamestate == gameflag.notstart then
			hall.desk.set_site_state(desk, site, SITE_STATE.READYWAIT)
        else
            if(hall.desk.get_site_state(desk, site) ~= SITE_STATE.NOTREADY)then
			    hall.desk.set_site_state(desk, site, SITE_STATE.NOTREADY)
            end
		end
	end
end

--�û����µ���Ϣ������֮��
tex.AfterUserSitDownMessage = function(userid, desk, site, bRelogin)  --�û����º�
	--TraceError("AfterUserSitDownMessage "..bRelogin)
	if(not desk or not site) then return end
	net_broadcast_deskinfo(desk)
	local userinfo = deskmgr.getsiteuser(desk, site) 
	if not userinfo then return end
	local gamestate = deskmgr.get_game_state(desk)
	net_broadcastdesk_goldchange(userinfo)
	net_broadcastdesk_playerinfo(desk)

	if gamestate == gameflag.notstart then
		letusergamestart(userinfo)
	end

	--ÿ���һ�������;��鿩
	if(userinfo.gameInfo.todayexp and userinfo.gameInfo.todayexp == 0) then
		local level = usermgr.getlevel(userinfo)
		if(level >= 3 and level < room.cfg.MaxLevel) then
			--TraceError("ÿ���һ�������;��鿩")
			local addexp = level * 2
			--ٛ�͵Ľ��� lv * 2 ���Ē�����
			addexp = math.floor(addexp / 10 + 0.5) * 10	
			usermgr.addexp(userinfo.userId, level, addexp, g_ExpType.firstsit, groupinfo.groupid)
			net_send_daygiveexp(userinfo, addexp)
			local sendmsg = format("��ϲ���ÿ�쾭�����[%d]���ù��ܽ�3�ȼ������������!", addexp)
			--net_sendsystemmsg(userinfo, tex.msgtype.firstsit, sendmsg)
			--TraceError(sendmsg)
		end
	end
	if (tex_buf_lib) then
		xpcall( function() tex_buf_lib.on_after_user_sitdown(userinfo, desk, site) end, throw)
	end
end

--�Ƿ���Ϸ������
tex.CanEnterGameGroup = function(szPlayingGroupName, nPlayingGroupId, nScore)
    --�ж��Ƿ�����Ϸ������
    if nPlayingGroupId ~= nil and nPlayingGroupId ~= 0 then
		if tonumber(groupinfo.groupid) == nPlayingGroupId then
			return 1, ""
		else
			return -102, "���� "..szPlayingGroupName.." ����Ϸ���ڽ�����,�޷�����÷��䡣"
		end
    else
      trace("��ǰû�����ڽ�����Ϸ��id")
    end
end

--�ж��û��Ƿ�����Ŷ�
tex.CanUserQueue = function(userKey, deskno)
	return 1, 0
end

--�ж��û�����Ϸ���ܲ��������ĳ�ּ۸����Ʒ
tex.CanAfford = function(userinfo, paygold, pay_limit)
	local gold = get_canuse_gold(userinfo)--userinfo.gamescore
	local deskno = userinfo.desk
	local siteno = userinfo.site

	if deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament then
        --[[
		if deskno and siteno then 
			local min = pay_limit or groupinfo.pay_limit 
			local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)
			if userinfo.chouma and userinfo.chouma > 0 then
				min = userinfo.chouma
			else
				if sitedata then
					min = sitedata.gold + sitedata.betgold
				end
			end
			gold = gold - min
		end
        --]]
	else
		--�����������ж���Ϸ�Ƿ�ʼ��û��ʼ���������˾�Ҫ����������
		local gamestart = tex.getGameStart(deskno)
		local deskinfo = desklist[deskno]
		if deskno and siteno and not gamestart then
			gold = gold - deskinfo.at_least_gold - deskinfo.specal_choushui
		end
	end

	return gold - paygold >= 0
end

tex.getGameStart = function(deskno,siteno)
	local isStart  = false
	local deskinfo = desklist[deskno]
	if not deskinfo then return false end
    if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then
        --������ֻ�б�������֮�����û�п�ʼ
        local deskdata = deskmgr.getdeskdata(deskno)
        isStart = deskdata.rounddata.roundcount > 0
    else
    	local gamestate = deskmgr.get_game_state(deskno)
    	if gamestate ~= gameflag.notstart then
    		isStart = true
    		if(siteno and siteno > 0) then
    			local sitedata = deskmgr.getsitedata(deskno, siteno)
    			if(sitedata.isinround ~= 1 or sitedata.islose == 1) then
    				isStart = false
    			end
    		end
        end
    end
	
	return isStart
end

tex.forceGameOverUser = function(userinfo)
	if not userinfo then return end
	douserforceout(userinfo)
end

tex.OnUserStandup = function(userid, desk, site)
	local userinfo = usermgr.GetUserById(userid)
	local sitedata = deskmgr.getsitedata(desk, site)
	local deskinfo = desklist[desk]
	deskinfo.gamedata.rounddata.sitecount[site] = 0  --���ô���λ�������������Ϊ0
    sitedata.gold = 0
	--�п�����ʱ������Ѿ�����
    if(not userinfo) then
        return
    end


    --��¼�������ĳ��룬����ʱʹ�ô�Ĭ��ֵ
	tex.setdeskdefaultchouma(userinfo, desk)
    --��������Ϊ0
	userinfo.chouma = 0
	--���û��ʼ��Ϸ
	if tex.getGameStart(desk, site) then
		if userinfo and sitedata.isinround == 1 and sitedata.islose == 0 then
			--------------------��ʤȡ��-----------------------------------
			xpcall(function()
				----------------------------ͭ�ɾ�-----------------------------
				achievelib.updateuserachieveinfo(userinfo,1016,1);--����ʤ
	
				---------------------------���ɾ�-------------------------------
				achievelib.updateuserachieveinfo(userinfo,2011,1);--����ʤ
	
				achievelib.updateuserachieveinfo(userinfo,2022,1);--5��ʤ
	
				---------------------------��ɾ�-------------------------------
				achievelib.updateuserachieveinfo(userinfo,3016,1);--10��ʤ
	
				achievelib.updateuserachieveinfo(userinfo,3026,1);--15��ʤ
				
				----------------------------��������ȡ��------------------
				achievelib.updateuserachieveinfo(userinfo,2015,1);--֪��

				achievelib.updateuserachieveinfo(userinfo,3009,1);--����
			end,throw)
			-----------------------------------------------------
			if deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and deskinfo.desktype ~= g_DeskType.match then
				letusergiveup(userinfo)
			end
		end
	end
end

--�û�վ��
tex.AfterOnUserStandup = function(userid, desk, site)
    
	local userinfo = usermgr.GetUserById(userid)
	if not userinfo then return end
	local deskinfo = desklist[desk]
	if not deskinfo then return end

	if deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament then
		--�������Ķ����������
		deskinfo.betgold = 0
	end
    if(userinfo.gameinfo==nil)then
        userinfo.gameinfo={}
    end
    userinfo.gameinfo.is_auto_buy=0
    userinfo.gameinfo.is_auto_addmoney=0

	--�����û�״̬
	hall.desk.set_site_state(desk, site, NULL_STATE)

	--���û��ʼ��Ϸ
	if deskmgr.get_game_state(desk) == gameflag.notstart then
		if deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament then
			if deskmgr.get_game_state(desk) ~= gameflag.notstart then 
				trystartgame(desk)
			end
		end
	end
	if (tex_buf_lib) then
		xpcall(function() tex_buf_lib.on_after_user_standup(userinfo, desk, site) end, throw)
    end

    --�����վ��ʱ��Ҫ��������������Ϊ�ر�״̬��ֹ�������������
    if(userinfo.gameInfo.suan)then
        userinfo.gameInfo.suan.suan_switch=0
        userinfo.gameInfo.suan.is_use_suan=0
    end
	net_broadcast_deskinfo(desk)
end

--�յ�����ĳ�û���ʱ���ߵ���Ϣ��ͨ�����û����̱�������ֹ��������һ��ʱ��û����Ӧ
tex.OnTempOffline = function(userinfo)
	--TraceError("OnTempOffline!")
	auto_chu_pai(userinfo);
end

function auto_chu_pai(userinfo)
    local deskno = userinfo.desk
	local siteno = userinfo.site
	if not deskno or not siteno then return end

    --����ֵ��Լ������Զ����ƻ�����
    local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)
	if deskmgr.get_game_state(userinfo.desk) ~= gameflag.notstart then
        local result = do_bu_xia_zhu(userinfo);
		if result == nil or result == 0 and userinfo and sitedata.isinround == 1 and sitedata.islose == 0 then
			letusergiveup(userinfo)
		end
	end
end

tex.AfterUserLogin = function(userinfo)
    --TraceError("AfterUserLogin!")	
end

--��Ҹս����սʱ�ĳ��� userinfo����ս�� 		desk������ս����
tex.AfterUserWatch = function(deskno, userinfo)
	if not deskno or not userinfo then return end
	--TraceError(format("���[%d]��������[%d]��ս��",userinfo.userId, deskno))
	for _, player in pairs(deskmgr.getplayers(deskno)) do
		net_broadcastdesk_goldchange(player.userinfo)
	end
	local deskdata = deskmgr.getdeskdata(deskno)
	local deskpokes = deskdata.deskpokes
	local gold = 0
	local betgold = 0
	local sitepokes = {}
	local mybean = userinfo.gamescore
	OnSendDeskInfo(userinfo, deskno)    
	net_send_resoredesk(userinfo)    
	net_broadcastdesk_playerinfo(deskno)
	--ˢ�²ʳ���Ϣ
	OnSendDeskPoolsInfo(userinfo, deskdata.pools)
    --[[
    --�������ڽ������Ϣ�����ڽ���ʱ���û��������ӳ������ڽ������ʾ
    local jiesuanwait = deskdata.jiesuanwait
    if (jiesuanwait ~= nil and jiesuanwait.startplan ~= nil) then
        --TraceError("jiesuanwait.startplan.getdelaytime:"..jiesuanwait.startplan.getlefttime())
        netlib.send(
                function(buf)
                    buf:writeString("TXJSWAIT")
                    buf:writeInt(jiesuanwait.startplan.getlefttime() or -1)
                end,userinfo.ip,userinfo.port)
    end
    --]]
end

--�ж������Ƿ���Թ�ս
tex.CanWatch = function(userinfo, deskno)
	if not userinfo then return fasle end
	local deskinfo = desklist[deskno]
	if not deskinfo then return false end

	local bvalid = true
	--TODO:�����Զ��������
    return bvalid
end

--��С�Ʋ���Ǯ���
tex.GetMinGold = function()
	return groupinfo.min_gold
	--return 200
end

--�Ʋ���Ǯ�����
tex.GetAddGold = function()
	return groupinfo.add_gold
	--return 200
end

--ȡ���Ŷ�ʱ
tex.OnCancelQueue = function(userinfo)
	userinfo.chouma = 0
end

--ȡ���Ŷ�ʱ
tex.OnSitDownFailed = function(userinfo)
	userinfo.chouma = 0
end
------------------�����հ�--------------------------------------------------------------
--�յ���Ϸ��ʼ
function onrecvgamestart(buf)
	--TraceError("onrecvgamestart()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; 
	if not userinfo.desk or userinfo.desk <= 0 then return end;
	if not userinfo.site or userinfo.site <= 0 then return end;
	local deskno = userinfo.desk
	local siteno = userinfo.site

    --�жϺϷ���
	if hall.desk.get_site_state(userinfo.desk, userinfo.site) ~= SITE_STATE.NOTREADY then return end;
	local deskinfo = desklist[userinfo.desk]
    if(deskinfo.desktype ~= g_DeskType.match) then
    	if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament) then
    		if not userinfo.chouma or userinfo.chouma < deskinfo.largebet + deskinfo.specal_choushui + 1 then
    			--������ֲ����������ң������䵯������
    			net_sendbuychouma(userinfo, deskno)
    			return
    		end
    	else
    		if not userinfo.chouma or userinfo.chouma < deskinfo.largebet then
    			--վ�𲢼����ս
    			doStandUpAndWatch(userinfo)
    			return
    		end
        end
    end

	letusergamestart(userinfo)
end

--���û���ʼ
function letusergamestart(userinfo)
	hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.READYWAIT)	

	--�㲥���������˵���˵㿪ʼ��
	net_broadcastdesk_ready(userinfo.desk, userinfo.site); 

	--�㲥����״̬
	net_broadcastdesk_playerinfo(userinfo.desk);

	--���Կ�ʼ��Ϸ
	trystartgame(userinfo.desk)
end

--�յ��������extrainfo��achieveinfo
function onrecvgetextrainfo_achieveinfo(buf)
	--TraceError("onrecvgetextrainfo_achieveinfo()")
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end; 
	local userid = buf:readInt()
    if (duokai_lib and duokai_lib.is_sub_user(userid) == 1) then
        userid = duokai_lib.get_parent_id(userid)
    end    
	local request_userinfo = usermgr.GetUserById(userid);
    if(not request_userinfo) then
		--֪ͨ�ͻ�����Ҳ�����
		local msgtype = userinfo.desk and 1 or 0 --1��ʾ����Ϸ�ﴦ���Э��,0�Ǵ���
		local msg = format("������Ϣ��ȡʧ�ܣ������Ŀǰ������!")
		OnSendServerMessage(userinfo, msgtype, _U(msg))
		return
	end
	net_send_user_extrainfo_achieveinfo(userinfo, request_userinfo)
end

--�յ��������extrainfo
function onrecvgetextrainfo(buf)
	--TraceError("onrecvgetextrainfo()")
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end; 
	local userid = buf:readInt()
    if (duokai_lib and duokai_lib.is_sub_user(userid) == 1) then
        userid = duokai_lib.get_parent_id(userid)
    end    
	local request_userinfo = usermgr.GetUserById(userid)
	if(not request_userinfo) then
		--֪ͨ�ͻ�����Ҳ�����
		local msgtype = userinfo.desk and 1 or 0 --1��ʾ����Ϸ�ﴦ���Э��,0�Ǵ���
		local msg = format("������Ϣ��ȡʧ�ܣ������Ŀǰ������!")
		OnSendServerMessage(userinfo, msgtype, _U(msg))
		return 
	end
	net_send_user_extrainfo(userinfo, request_userinfo)
end


--�յ�������̳��֤��
function onrecvgetbbsurl(buf)
	--TraceError("onrecvgetbbsurl()")
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end; 
	local sys_time = os.time()
	local password = "11"
	local bbs_auth = "username="..userinfo["userName"]
	bbs_auth = bbs_auth .. '&password='..password
	bbs_auth = bbs_auth .. '&site_no='..userinfo["nRegSiteNo"]
	bbs_auth = bbs_auth .. '&time='..sys_time
	bbs_auth = bbs_auth .. '&key='..string.md5(userinfo["nRegSiteNo"]..userinfo["userName"]..password..sys_time..'97CfiDV3-92F2-ZKDd-FE8X-58X4ZAA3389')
	net_send_BBS_URL(userinfo, bbs_auth)
end

--�յ����������ϸ
function onrecvtodaydetail(buf)
	--TraceError("onrecvtodaydetail()");
	do return end; --�ͻ����Լ����棬������������
	local userinfo = userlist[getuserid(buf)]; if not userinfo then return end; 

	local sqltmplet = "select * from user_tex_todaydetail where userid=%d and Date(sys_time)=Date(now()) order by sys_time desc;";
	local sql = format(sqltmplet, userinfo.userId);
	dblib.execute(sql,
		function(dt)
			net_send_todaydetail(userinfo, dt);
		end);
end

--�����ǿ�˳���Ϸ
function douserforceout(userinfo)
	if (userinfo == nil) then
		return
	end

	local deskno = userinfo.desk
	local siteno = userinfo.site
	--pre_process_back_to_hall(userinfo);
	-- [[
	if (deskno == nil) then
        return
    end


    if (siteno == nil) then
	    DoUserExitWatch(userinfo) 
        net_kickuser(userinfo)
		return
    end
	local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)
	if deskmgr.get_game_state(userinfo.desk) ~= gameflag.notstart then
		if userinfo and sitedata.isinround == 1 and sitedata.islose == 0 then
			letusergiveup(userinfo)
		end
	end

    
    --վ������
	hall.desk.set_site_state(deskno, siteno, NULL_STATE)
	doUserStandup(userinfo.key, false)
	DoUserExitWatch(userinfo) 
	net_kickuser(userinfo)
	--]]

	local deskinfo = desklist[deskno]
	local deskdata = deskmgr.getdeskdata(deskno)
	--����Ǳ�������Ҫ�ж�ʣ�µ����Ƿ�ֳ�����
	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then
		--ֻʣ��һ����ң���Ȼ�ǵ�һ��
        if(deskinfo.playercount == 1 and deskdata.rounddata.roundcount > 0) then
			--��Ϸ����
			deskmgr.set_game_state(deskno, gameflag.notstart)
			for _, player in pairs(deskmgr.getplayers(deskno)) do
				if player.userinfo then
					set_lost_or_prize(deskno, {player.siteno})
					break
				end
			end
        end
    end
end

--�����
function onrecvgiveup(buf)
	--TraceError("onrecvgiveup()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end;
	if not userinfo.desk or userinfo.desk <= 0 then return end;
	if not userinfo.site or userinfo.site <= 0 then return end;

	--���û��ʼ��Ϸ
	local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)
	if deskmgr.get_game_state(userinfo.desk) ~= gameflag.notstart then
		if userinfo and sitedata.isinround == 1 and sitedata.islose == 0 then
			letusergiveup(userinfo)
		end
	end
end

--���û�����
function letusergiveup(userinfo)
	--TraceError(format("site:%d, ID[%d]��ʼ����", userinfo.site, userinfo.userId))
	if(not userinfo.desk or not userinfo.site) then
		--TraceError(format("��û��������ô������deskno[%s],siteno[%s]",tostring(userinfo.desk), tostring(userinfo.site)))
		return
	end

	if deskmgr.get_game_state(userinfo.desk) == gameflag.notstart then
		--TraceError("��Ϸ��û��ʼ��ô�ܷ���??"..debug.traceback())
	end

    local oldstate = hall.desk.get_site_state(userinfo.desk, userinfo.site)
	if oldstate ~= SITE_STATE.LEAVE then
		hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.WAIT)
	end

	local deskdata = deskmgr.getdeskdata(userinfo.desk)
	local deskinfo = desklist[userinfo.desk]
    local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)
	if(sitedata.islose == 1) then return end
	--�û�����
	sitedata.islose = 1

	--������������
	local userid = userinfo.userId
	local betgold = -sitedata.betgold
	local nSid = userinfo.nSid
	local curgold = userinfo.gamescore
	local level = usermgr.getlevel(userinfo)
	local joinfee = deskinfo.at_least_gold
	local choushui = get_specal_choushui(deskinfo,userinfo)
	local safegold = userinfo.safegold or 0
    local channel_id = userinfo.channel_id or -1;
	
    if(deskinfo.desktype ~= g_DeskType.match) then
        if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament) then
            --+Ǯ 
            usermgr.addgold(userinfo.userId, -sitedata.betgold, 0, g_GoldType.normalwinlost, -1, 1)
    		record_today_detail(userinfo, -sitedata.betgold)
    		--�������棬��ˮ�ӱ�
    		if(deskinfo.playercount <= 2) then
    			choushui = choushui * 2
    		end
        else
            userinfo.tour_point = userinfo.tour_point - sitedata.betgold
    		--������ֻ�ڱ�����ʼ�ĵ�һ����ȡ�����Ѻͳ�ˮ
            if(deskdata.rounddata.roundcount > 1) then
    			joinfee = 0
    			choushui = 0
    		end
        end
    end


	local user_level = usermgr.getlevel(userinfo)
    local addexp = 0
	if user_level < 2 then
        addexp = 1
		usermgr.addexp(userinfo.userId, user_level, 1, g_ExpType.lost, groupinfo.groupid);
	end
	if (duokai_lib and duokai_lib.is_sub_user(userid) == 1) then
		sitedata.logsql = format("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d", 
							 duokai_lib.get_parent_id(userid), betgold, addexp, nSid, curgold, level, joinfee, choushui, safegold, channel_id);--����Ƶ��id
	else
		sitedata.logsql = format("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d", 
							 userid, betgold, addexp, nSid, curgold, level, joinfee, choushui, safegold, channel_id);--����Ƶ��id
	end
	
	--֪ͨ�������ˢ��
	--net_send_user_new_gold(userinfo, userinfo.gamescore)
    -----------------------------------------------
	--�����´���ע��� todo cw �������˲���Ǯ��Ҫ�����
    --TODO:�����Ƿ����ˣ���עʱ�����Ѿ��۹�Ǯ
	userinfo.chouma = sitedata.gold -- - sitedata.betgold
	
	--֪ͨ�ͻ���
	net_broadcastdesk_giveup(userinfo.desk, userinfo.site)

	--����ʣ�¶������ڼ���
	local aliveplayers = 0
	for siteno, sitedata in pairs(deskmgr.getallsitedata(userinfo.desk)) do
		if sitedata.isinround == 1 and sitedata.islose == 0 then
			aliveplayers = aliveplayers + 1
		end
	end

	--��һ���˳����
	local nextsite = deskmgr.getnextsite(userinfo.desk, userinfo.site)
	if not nextsite then return end
	local deskno = userinfo.desk
	local siteno = nextsite

	if userinfo.site == deskdata.leadersite then
		deskdata.leadersite = siteno		--�����˷��������¸��˰�
	end
	--TraceError(format("site:%d, ID[%d]�����󣬻���[%d]��������", userinfo.site, userinfo.userId, aliveplayers))
	
	--ֻʣ��һ���˽�ֱ�ӵ��½���
	if aliveplayers == 1 then
		jiesuan(deskno, false)    
		return
	end

	--����������״̬�·����Ͳ����Զ���һ����
	--TraceError(format("oldstate = [%s]", tostring(oldstate)))
	if oldstate ~= SITE_STATE.PANEL and oldstate ~= SITE_STATE.LEAVE then return end;

	process_site(deskno, siteno)
end

function process_dizhu(deskno, gold)
	for _, player in pairs(deskmgr.getplayers(deskno)) do
		local user_info = player.userinfo;
		if(user_info and user_info.desk and user_info.site) then
			add_bet_gold(user_info, gold, 7);
		end
	end
end

function add_bet_gold(user_info, gold, ntype)
    local deskinfo = desklist[user_info.desk];
	local deskdata, sitedata = deskmgr.getdeskdata(user_info.desk), deskmgr.getsitedata(user_info.desk, user_info.site)
    --TraceError(user_info.userId..'sitedata.betgold'..sitedata.betgold.." gold"..gold);
    sitedata.betgold = sitedata.betgold + gold
    deskinfo.betgold = deskinfo.betgold + gold
    deskdata.totalbetgold = deskdata.totalbetgold + gold
    deskdata.roundaddgold = gold - sitedata.panelrule.gengold			--�´μ�ע����Сֵ
    if(deskdata.maxbetgold < sitedata.betgold) then
        deskdata.maxbetgold = sitedata.betgold
    end

    net_broadcastdesk_xiazhu(user_info.desk, user_info.site, ntype)
    net_sendmybean(user_info, user_info.gamescore);			--�Լ��ĵ��ݶ�
    --TraceError(sitedata.betgold);

    useraddviewgold(user_info, -gold, true);
end

--����ע/��ע
function onrecvxiazhu(buf)
	local gold, ntype = buf:readInt(), buf:readByte()
	trace("onrecvxiazhu()")	
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;
	if not userinfo.site or userinfo.site <= 0 then return end;
	local deskdata, sitedata = deskmgr.getdeskdata(userinfo.desk), deskmgr.getsitedata(userinfo.desk, userinfo.site)
	--�жϺϷ���	
	if hall.desk.get_site_state(userinfo.desk, userinfo.site) ~= SITE_STATE.PANEL then return end;
	if sitedata.panelrule.jia + sitedata.panelrule.xiazhu ~= 1 then return end

	local oldgold = gold
	gold = gold - (sitedata.betgold - sitedata.roundbet)		--gold����ת��Ϊʵ��Ҫ����Ǯ��

	--���ֻ���³ɸ�����ڶ������һ��
	if gold > sitedata.panelrule.max then
		--TraceError("������ע��Χ>")
		gold = sitedata.panelrule.max
	end
	if gold < sitedata.panelrule.min then
		--TraceError("������ע��Χ<")
		gold = sitedata.panelrule.min
    end

    local deskinfo = desklist[userinfo.desk]
    --��ע����ʼ
    if(deskinfo.limit ~= nil and deskinfo.limit == 1) then
        local smallbet, largebet = getLimitXiazhu(deskinfo, deskdata, sitedata);
        gold = smallbet; 
    end
    --��ע�������

	if (ntype ~= 1 and ntype ~= 2) then return end

	--����Ǯ��ȥ���������
	ASSERT(gold > 0 or (gold == 0 and sitedata.gold == 0) ,"��עΪ"..gold.." and sitedata.gold ="..sitedata.gold.."????")

	--TraceError(userinfo.nick .. " ʵ�ʼ�ע��" .. gold .. " Ҫ�ӵ���" .. (gold + sitedata.betgold - sitedata.roundbet))
	--��ʼ��ע/��ע
	sitedata.betgold = sitedata.betgold + gold
	deskinfo.betgold = deskinfo.betgold + gold
	deskdata.totalbetgold = deskdata.totalbetgold + gold
	deskdata.roundaddgold = gold - sitedata.panelrule.gengold			--�´μ�ע����Сֵ
	sitedata.isbet = 1
	deskdata.maxbetgold = sitedata.betgold
    deskdata.rounddata.xiazhucount = deskdata.rounddata.xiazhucount + 1;--��ע����ͳ��

	--�ӵ��͵��ȫ��
	if gold == sitedata.panelrule.max then
		sitedata.isallin = 1
		ntype = 4
	end

    local can_use_gold = get_canuse_gold(userinfo, 1);
	if(sitedata.betgold > can_use_gold and deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and deskinfo.desktype ~= g_DeskType.match) then
		TraceError(format("�쳣�������ע���������ϵĳ���...oldgold[%d], sitedata.betgold[%d], userinfo.gamescore[%d]", oldgold, sitedata.betgold, can_use_gold))
		sitedata.betgold = can_use_gold
	end

	--֪ͨ�ͻ���
	net_broadcastdesk_xiazhu(userinfo.desk, userinfo.site, ntype)
	net_sendmybean(userinfo, userinfo.gamescore);			--�Լ��ĵ��ݶ�
	useraddviewgold(userinfo, -gold, true)

	hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.WAIT)

	--��һ���˳����
	local next_site = deskmgr.getnextsite(userinfo.desk, userinfo.site)
	if(next_site ~= nil) then
		process_site(userinfo.desk, deskmgr.getnextsite(userinfo.desk, userinfo.site))
	else
		jiesuan(userinfo.desk, false)
	end
end

--���ע
function onrecvgenzhu(buf)
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; 
	if not userinfo.desk or userinfo.desk <= 0 then return end;
	if not userinfo.site or userinfo.site <= 0 then return end;
	local deskdata, sitedata = deskmgr.getdeskdata(userinfo.desk), deskmgr.getsitedata(userinfo.desk, userinfo.site)
	--�жϺϷ���
	if hall.desk.get_site_state(userinfo.desk, userinfo.site) ~= SITE_STATE.PANEL then return end;
	if sitedata.panelrule.gen ~= 1 then return end	
	local notifytype = 5
	--��ʼ��ע��ȫ�£�
	local gold = deskdata.maxbetgold  - sitedata.betgold		--��Ҫ����Ǯ
	ASSERT(gold > 0)
	if gold >= sitedata.gold then	--û��ô��Ǯ�����Ǿ�ȫ�°�
		gold = sitedata.gold
		sitedata.isallin = 1
		deskdata.maxbetgold = math.max(sitedata.betgold + gold, deskdata.maxbetgold)
		notifytype = 4
	end
	sitedata.betgold = sitedata.betgold + gold
	local deskinfo = desklist[userinfo.desk]
	deskinfo.betgold = deskinfo.betgold + gold
	deskdata.totalbetgold = deskdata.totalbetgold + gold
	sitedata.isbet = 1
    local can_use_gold = get_canuse_gold(userinfo, 1);

	if(sitedata.betgold > can_use_gold and deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and deskinfo.desktype ~= g_DeskType.match) then
		TraceError(format("�쳣�������ע���������ϵĳ���...gold[%d], sitedata.betgold[%d], userinfo.gamescore[%d]", gold, sitedata.betgold, can_use_gold))
		sitedata.betgold = can_use_gold
	end
	
	--֪ͨ�ͻ���
	net_broadcastdesk_xiazhu(userinfo.desk, userinfo.site, notifytype)
	net_sendmybean(userinfo, userinfo.gamescore);			--�Լ��ĵ��ݶ�
	useraddviewgold(userinfo, -gold, true)

	hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.WAIT)

	--��һ���˳����
	local next_site = deskmgr.getnextsite(userinfo.desk, userinfo.site)
	if(next_site ~= nil) then
		process_site(userinfo.desk, deskmgr.getnextsite(userinfo.desk, userinfo.site))
	else
		jiesuan(userinfo.desk, false)
	end
end

function do_bu_xia_zhu(userinfo)
    if not userinfo then return 0 end; 
	if not userinfo.desk or userinfo.desk <= 0 then return 0 end;
	if not userinfo.site or userinfo.site <= 0 then return 0 end;

	local deskdata, sitedata = deskmgr.getdeskdata(userinfo.desk), deskmgr.getsitedata(userinfo.desk, userinfo.site)
	--�жϺϷ���
	if hall.desk.get_site_state(userinfo.desk, userinfo.site) ~= SITE_STATE.PANEL then return 0 end;
	if sitedata.panelrule.buxiazhu ~= 1 then return 0 end
	
	--֪ͨ�ͻ���
	net_broadcastdesk_buxiazhu(userinfo.desk, userinfo.site)

	hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.WAIT)

	sitedata.isbet = 1	--�����Ѿ�ѡ��������
	--��һ���˳����
	local next_site = deskmgr.getnextsite(userinfo.desk, userinfo.site)
	if(next_site ~= nil) then
		process_site(userinfo.desk, deskmgr.getnextsite(userinfo.desk, userinfo.site))
	else
		jiesuan(userinfo.desk, false)
    end
    return 1;
end

--�㲻��ע
function onrecvbuxiazhu(buf)
	trace("onrecvbuxiazhu()")
	local userinfo = userlist[getuserid(buf)]; 
	do_bu_xia_zhu(userinfo);
end

--��ȫ��
function onrecvallin(buf)
	trace("onrecvallin()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; 
	if not userinfo.desk or userinfo.desk <= 0 then return end;
	if not userinfo.site or userinfo.site <= 0 then return end;
	local deskdata, sitedata = deskmgr.getdeskdata(userinfo.desk), deskmgr.getsitedata(userinfo.desk, userinfo.site)
	--�жϺϷ���
	if hall.desk.get_site_state(userinfo.desk, userinfo.site) ~= SITE_STATE.PANEL then return end;
	if sitedata.panelrule.allin ~= 1 then return end

	--��ʼȫ��
	local gold = sitedata.gold
	sitedata.betgold = sitedata.betgold + gold
	local deskinfo = desklist[userinfo.desk]
	deskinfo.betgold = deskinfo.betgold + gold
	deskdata.totalbetgold = deskdata.totalbetgold + gold;
	sitedata.isbet = 1
	sitedata.isallin = 1

	deskdata.maxbetgold = math.max(sitedata.betgold, deskdata.maxbetgold)
    local can_use_gold = get_canuse_gold(userinfo, 1);
	if(sitedata.betgold > can_use_gold and deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and deskinfo.desktype ~= g_DeskType.match) then
		TraceError(format("�쳣�����ȫ�����������ϵĳ���...gold[%d], sitedata.betgold[%d], userinfo.gamescore[%d]", gold, sitedata.betgold, can_use_gold))
		sitedata.betgold = can_use_gold
	end
	--֪ͨ�ͻ���
	net_broadcastdesk_xiazhu(userinfo.desk, userinfo.site, 4)
	net_sendmybean(userinfo, userinfo.gamescore);
	useraddviewgold(userinfo, -gold, true)

	hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.WAIT)

	--��һ���˳����
	local next_site = deskmgr.getnextsite(userinfo.desk, userinfo.site)
	if(next_site ~= nil) then
		process_site(userinfo.desk, deskmgr.getnextsite(userinfo.desk, userinfo.site))
	else
		jiesuan(userinfo.desk, false)
	end
end

--�ͻ��˲�ѯʥ������Ϣ
--[[
function on_recve_quest_farmtree(buf)
	--TraceError("on_recve_quest_farmtree()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end

	local sql = format("call yysns_farm.sp_get_textree_info('%s', %d)", userinfo["userName"], userinfo["nRegSiteNo"])
	dblib.dofarmsql(sql,
		function(dt)
			if dt and #dt > 0 then
				--TraceError(dt)
				netlib.send(
					function(buf)
						buf:writeString("TXMTREE")
						buf:writeString(dt[1]["sys_time"])
						buf:writeInt(dt[1]["farm_level"])
						buf:writeInt(dt[1]["charm_level"])
						buf:writeInt(dt[1]["charm_value"])
						buf:writeString(dt[1]["start_time"])
						buf:writeInt(dt[1]["online_time"])
						buf:writeString(dt[1]["total_grow_point"])
						buf:writeInt(dt[1]["tree_level"])
						buf:writeInt(dt[1]["fruits_1"])
						buf:writeInt(dt[1]["fruits_2"])
						buf:writeInt(dt[1]["fruits_3"])
						buf:writeInt(dt[1]["fruits_4"])
						buf:writeInt(dt[1]["fruits_5"])
						buf:writeInt(dt[1]["fruits_6"])
						buf:writeInt(dt[1]["fruits_7"])
						buf:writeInt(dt[1]["fruits_8"])
						buf:writeInt(dt[1]["fruits_9"])
						buf:writeInt(dt[1]["fruits_10"])
						buf:writeInt(dt[1]["fruits_11"])
					end,userinfo.ip,userinfo.port)
                    userinfo.charmlevel = tonumber(dt[1]["charm_level"])
                    userinfo.charmvalue = tonumber(dt[1]["charm_value"])
                    --ÿ���콱����ӳ�
                    userinfo.charmgold = tonumber(dt[1]["give_gold"])

                    --�㲥����������
                    net_broadcastdesk_charmchange(userinfo)
                
				--��ũ������ҵı�־
				if(not userinfo.farmtree) then
                    --�ϴ���������ʱ��(��ֹ�ص�¼���ʱ��)
                    userinfo.lastaddtime = os.time()
				    userinfo.farmtree = 1
				end
			end
		end)
end

--�ͻ��˲�ѯ�������һ������ʱ��
function on_recve_query_delaytime(buf)
	--TraceError("on_recve_query_delaytime()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end
    if not userinfo.farmtree then return end --ũ����Ҳŷ�����Ϣ

    local delaytime = tex.farm_delaytime or 300
    netlib.send(
            function(buf)
                buf:writeString("TXMTIME")
                buf:writeInt(delaytime)
            end,userinfo.ip,userinfo.port)
end

--�ͻ�����������һ������ʱ��
function on_recve_add_onlinetime(buf)
	--TraceError("on_recve_add_onlinetime()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end

    if not userinfo.farmtree then return end --ũ����Ҳŷ�����Ϣ

    local delaytime = tex.farm_delaytime or 300

    if(userinfo.lastaddtime and os.time() - userinfo.lastaddtime < delaytime)then
        return
    end

    --��¼�������ӵ�ʱ��
    userinfo.lastaddtime = os.time()

    --����Ϣ��ũ��������������������ʱ��
    send_online_message_tofarm(userinfo, delaytime) 
end
--]]
--�ͻ��˲�ѯ�Ƿ�Ҫ��ʾ���ֽ̳�
function on_recve_quest_welcome(buf)
	--TraceError("on_recve_quest_welcome()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end

	if userinfo.gotwelcome and userinfo.gotwelcome > 0 then return end

	--������ʾ���ֽ̳���ʾ
	net_send_welcome_tex(userinfo)
end

--�ͻ�������Ҫ��Ҫ��ʾ���ֽ̳�
function on_recve_notshow_welcome(buf)
	--TraceError("on_recve_notshow_welcome()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end

	local userid = userinfo.userId
	if(userinfo.gotwelcome == 0) then
		--��¼���ڴ�
        save_new_user_process(userinfo, 1)
	end
end

--�ͻ���֪ͨ�Ѿ�����һ��̳�
function on_recve_study_over(buf)
	--TraceError("on_recve_study_over()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end

	local userid = userinfo.userId
    local welcome = userinfo.gotwelcome
	if(userinfo.gotwelcome == 0) then
		welcome = 2
	elseif(userinfo.gotwelcome == 1) then
		welcome = 3
	else
		--TraceError(format("���%d��ȡ�̳̽���ʱ��gotwelcome=%s",userinfo.userId, tostring(userinfo.gotwelcome)))
		return
	end

	local givegold = 800
	usermgr.addgold(userinfo.userId, givegold, 0, g_GoldType.studyprize, -1)
	net_send_study_prize(userinfo, givegold)

	--��¼�����ݿ�
    save_new_user_process(userinfo, welcome)	
end

--�o������ڵ���ҹ㲥������Ϣ
function onrecnquestdeskinfo(buf)
	--TraceError("onrecnquestdeskinfo()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end
	local deskno = buf:readInt()
	local deskinfo = desklist[deskno]
	if not deskinfo then return end
	OnSendDeskInfo(userinfo, deskno)
end

--�o��ҵ����������Ի���
function onrecvquestbuychouma(buf)	
	--TraceError("�o��ҵ����������Ի��� ..onrecvquestbuychouma()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; 
	if not userinfo.desk or userinfo.desk <= 0 then return end;
    local desk = userinfo.desk
    local deskinfo = desklist[desk]
    if(deskinfo==nil) then return end
    --ֻ������ʱ����������ƣ����Դ�buy_chouma_limit���ó�����
	local freshman_limit = 3000;
	if((deskinfo.desktype == g_DeskType.normal or deskinfo.desktype==g_DeskType.channel or deskinfo.desktype==g_DeskType.channel_world) and deskinfo.smallbet == 1 and userinfo.gamescore > freshman_limit) then
        --���ֳ�����
		local msgtype = userinfo.desk and 1 or 0 --1��ʾ����Ϸ�ﴦ���Э��,0�Ǵ���
            netlib.send(function(buf) 
                buf:writeString("TEXXST")
                end, userinfo.ip, userinfo.port, borcastTarget.playingOnly);
		return -2
	end
    --ͨ��������������
    net_sendbuychouma(userinfo, desk);
end

--�ж��Ƿ��������������
function buy_chouma_limit(userinfo)
	local desk = userinfo.desk

	local deskinfo = desklist[desk]

    if(deskinfo == nil) then
        return;
    end

	--�ȼ�������������ͨ�����ѹ����ߺ��Ž����ģ�����������
	if(usermgr.getlevel(userinfo) < deskinfo.needlevel) then
		--TraceError(format("��ҵȼ�[%d]��������Ҫ�ȼ�[%d]", usermgr.getlevel(userinfo), deskinfo.needlevel))
		local sendmsg = ""
		sendmsg = format("������Ҫ�ȼ�%d���ϲſ�����Ϸ����ȼ������!", deskinfo.needlevel)
		net_sendsystemmsg(userinfo, tex.msgtype.systips, sendmsg)
		return -1
    end

	--��������ʼ���������������
	if deskinfo.playercount < deskinfo.max_playercount+1 then
		if (deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament) or not tex.getGameStart(desk) then
			return 1
		else
			net_sendsystemmsg(userinfo, tex.msgtype.systips, "�Բ��𣬱�����������;������Ϸ!")
            return -3
		end
    else
		net_sendsystemmsg(userinfo, tex.msgtype.systips, "���������������������ȴ�������һ�����ٵ�����!")
        return -4
	end
end

--����һ�����
function onrecvbuychouma(buf)
	--TraceError("onrecvbuychouma()")
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;

	--�жϺϷ���
	local gold = buf:readInt()
	local deskno = buf:readInt()
	local siteno = buf:readByte()		--�����û���£�����λӦ���ȿ���
    if(userinfo.gameinfo==nil)then
        userinfo.gameinfo={}
    end
    userinfo.gameinfo.is_auto_addmoney=  buf:readByte() or 0 --�Ƿ��Զ���ע��0��1��
    userinfo.gameinfo.is_auto_buy= buf:readByte() or 0   --�Ƿ��Զ����루0��1��
    userinfo.gameinfo.auto_buy_gold=gold    --�ͻ��˴�����Ҫ��ĳ��룬�Զ�����ʱҪ��
	dobuychouma(userinfo, deskno, siteno, gold)
end

--����һ�����
function dobuychouma(in_userinfo, in_deskno, in_siteno, in_buygold)
	local userinfo = in_userinfo
	if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;

    local eventdata = {userinfo = in_userinfo, buygold = 0, handle = 0};
    eventmgr:dispatchEvent(Event('on_buy_chouma', eventdata));

	if(eventdata.handle == 1) then
		return;
	end

    if(eventdata.buygold > 0) then
        in_buygold = eventdata.buygold;
    end

	--�жϺϷ���
	local gold = in_buygold or 0
	local deskno = userinfo.desk or in_deskno
	local siteno = userinfo.site or in_siteno
	local deskinfo = desklist[deskno]
	--TraceError(format("���Ӻ�[%d]����λ��[%d], gold[%d]",deskno, siteno, gold))

    --������һ����ʼ�Ͳ�������;����
    if (deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) and tex.getGameStart(deskno) then
        return
    end
	
	--��Ч����λ��
	if(not userinfo.site and (siteno <= 0 or siteno > room.cfg.DeskSiteCount)) then siteno = 1 end
	
	if gold == 0 then					--�����0��ʾȡ���һ�����
		--TraceError("ȡ���һ�����")
		userinfo.chouma = 0
		return
	end	
    local can_use_gold = get_canuse_gold(userinfo, 1);
    if(deskinfo.desktype ~= g_DeskType.match) then
    	if deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament then 
    		if gold < deskinfo.at_least_gold then
    			gold = deskinfo.at_least_gold
    		end
    		if gold > deskinfo.at_most_gold then
    			--gold = deskinfo.at_most_gold
            end
    		if can_use_gold < gold then
    			gold = can_use_gold			
    			if(userinfo.site ~= nil and gold < deskinfo.at_least_gold) then
    				if(userinfo.site ~= nil) then 
    					--վ�𲢼����ս
    					doStandUpAndWatch(userinfo)
    				end
    				--OnSendServerMessage(userinfo, 1, _U("�Բ������ĳ��벻��֧����������ʹ�������׼!"))
    				return
    			end
    		end
    		--ʵ�ֶһ�����
    		userinfo.chouma = gold
    	else
            if(can_use_gold < deskinfo.at_least_gold + deskinfo.specal_choushui) then
                if(userinfo.site ~= nil) then 
                    hall.desk.set_site_state(deskno, siteno, NULL_STATE)
                    doUserStandup(userinfo.key, false) 
                    DoUserExitWatch(userinfo)
                    net_kickuser(userinfo)
                end
                OnSendServerMessage(userinfo, 1, _U("�Բ������ĳ��벻��֧�����������ı����ͷ������!"))
                return
            else
                userinfo.chouma = 1000
            end
        end
    else
        userinfo.chouma = gold
    end
	--���Ƿ�Ҫ����(��λ��Ϊ��˵����Ҫ����)
	if(not userinfo.site) then
		--����ǰ�ȼ���Ƿ���������λ��(�о�����ڸ���������һ��)
		local siteuserinfo = userlist[hall.desk.get_user(deskno, siteno) or ""]
		if siteuserinfo ~= nil then
            if(siteuserinfo.userId == userinfo.userId)then
                TraceError("��ô���?���˷�����!!!"..debug.traceback())
                userinfo.chouma = 0
        		return 
            else
    			local newsiteno = hall.desk.get_empty_site(deskno)
    			--û�п���λ����ǿ��ԭ���Ǹ���λ��ʹ����ʾ������λ�����ˡ�
    			if newsiteno > 0 then siteno = newsiteno end
            end
		end
		--��������ʼ����������
		if deskinfo.playercount < deskinfo.max_playercount then
            local FunDoSitdown = function()
                doSitdown(userinfo.key, userinfo.ip, userinfo.port, deskno, siteno, g_sittype.normal)
            end
            getprocesstime(FunDoSitdown, "buychoumadoSitdown", 500)
		end
	end
	--û����λ��˵������ʧ����
	if(not userinfo.site) then
		--TraceError(userinfo.site)
		userinfo.chouma = 0
		
		if(viproom_lib.get_room_spec_type(deskno) == 0)then
			OnSendServerMessage(userinfo, 1, _U("��ʱû�п�λ�������Ե�һ��!"))
		end
		return 
    end

    --��¼���뵽������ʷ���ĳ���
    local smallbet = deskinfo.smallbet
    local extra_info = userinfo.extra_info
    local defaulttb = {gametime = 0, bringgold = gold, bringout = 0, wingold = 0}
    if(extra_info["F09"][smallbet] == nil or type(extra_info["F09"][smallbet]) ~= "table")then 
        extra_info["F09"][smallbet] = defaulttb
    else
        local gametime = extra_info["F09"][smallbet]["gametime"] or 0
        local interval = extra_info["F09"].interval or 1800
        local wingold = extra_info["F09"][smallbet]["wingold"] or 0
        --������Сʱ��ûӮǮ�Ͳ�������
        if(os.time() - gametime > interval or wingold <= 0) then
            extra_info["F09"][smallbet] = defaulttb
        elseif(gold >= wingold)then
            extra_info["F09"][smallbet]["bringgold"] = gold - wingold
            extra_info["F09"][smallbet]["bringout"] = 0
        else
            --TraceError(format("�쳣:��Ҵ������[%d],С��֮ǰӮ�ĳ���[%d]����ô������?", gold, wingold))
            extra_info["F09"][smallbet] = defaulttb
        end
    end
    userinfo.extra_info = extra_info
    local FunSaveExtraInfo = function()
        save_extrainfo_to_db(userinfo)
    end
    getprocesstime(FunSaveExtraInfo, "buychoumasave_extrainfo_to_db", 500)

	if(hall.desk.get_site_state(deskno, userinfo.site) == SITE_STATE.BUYCHOUMA) then
		net_broadcastdesk_goldchange(userinfo)
		hall.desk.set_site_state(deskno, userinfo.site, SITE_STATE.READYWAIT)
		net_broadcastdesk_playerinfo(deskno)
		if deskmgr.get_game_state(deskno) == gameflag.notstart then
            local FunTryStartGame = function()
                trystartgame(deskno)
            end
            getprocesstime(FunTryStartGame, "buychoumatrystartgame", 500)
		end
	end
	
	--����������������Ǯ
	--userinfo.canbuygold = can_use_gold -userinfo.chouma
end

--���Կ�ʼ��Ϸ
function trystartgame(deskno, onplan)
	--TraceError("trystartgame()")
	
	
	if deskmgr.get_game_state(deskno) ~= gameflag.notstart then return end
	local deskdata = deskmgr.getdeskdata(deskno)

	local jiesuanwait = deskdata.jiesuanwait
	if not onplan and (os.time() - jiesuanwait.jiesuantime < jiesuanwait.needwait) then
		--TraceError("jiesuanwait.startplan ��ֹ��Ϸ��ʼ, curr = "..os.time() - jiesuanwait.jiesuantime)
		--TraceError(jiesuanwait)
		jiesuanwait.someonestart = 1
		return
	end

	local deskinfo = desklist[deskno]
	local readysite = 0			--׼���õ�����	

    deskdata.playinglist = {}
	deskdata.deskpokes = {}

	local sitelist = {}

	--��ʼ��Ϸʱ��Ҫ�����������ı���ID������¼����α���������
	--��Ϊ���Ĳ�������ÿ�ֱ���������ID������¼��������һ�����ط���Ҫ�Ļ������Ե��á�
	--[[if(tex_match)then
		xpcall(function() tex_match.init_invate_match(deskno) end, throw)
	end
	--]]
	eventmgr:dispatchEvent(Event("game_begin_event",	_S{deskno = deskno}))

	--���׼���˵���û����룬���䵯���������״̬��Ϊδ׼���������˳��Կ�ʼ��Ϸ
	for _, player in pairs(deskmgr.getplayers(deskno)) do
		local userinfo = player.userinfo
		local state = hall.desk.get_site_state(deskno, player.siteno)
		local user_chouma = userinfo.chouma or 0
        local can_use_gold = get_canuse_gold(userinfo, 1);

		--������
		if deskinfo.desktype == g_DeskType.match then
            if(state ~= SITE_STATE.READYWAIT and state ~= SITE_STATE.LEAVE) then
                hall.desk.set_site_state(deskno, player.siteno, SITE_STATE.READYWAIT)
            end
		elseif deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament then
			if(user_chouma < deskinfo.largebet) then  --û����������̭�򷢽�
				--��¼��̭����λ��
				table.insert(sitelist, player.siteno)
			else
				--��������
				if(state ~= SITE_STATE.READYWAIT and state ~= SITE_STATE.LEAVE) then
					hall.desk.set_site_state(deskno, player.siteno, SITE_STATE.READYWAIT)
				end
			end
		--��ͨ��
		else
			local needgold = deskinfo.largebet + deskinfo.specal_choushui + 1
			if (user_chouma < needgold) then
				if can_use_gold >= deskinfo.at_least_gold then
					if(state ~= SITE_STATE.NOTREADY and state ~= SITE_STATE.BUYCHOUMA) then
						hall.desk.set_site_state(deskno, player.siteno, SITE_STATE.BUYCHOUMA)
                        tex.setdeskdefaultchouma(userinfo, deskno)
						net_sendbuychouma(userinfo, deskno, 30);
					end
				else
					--վ�𲢼����ս
					doStandUpAndWatch(userinfo)
					trystartgame(deskno)
					return
				end
			else
				hall.desk.set_site_state(deskno, player.siteno, SITE_STATE.READYWAIT)
			end
		end
	end

	if ((deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) and #sitelist > 0) then
		set_lost_or_prize(deskno, sitelist)
	end
	
    --��¼���һ�����������������λ���Ա�ʣ�����һ��ʱ����
    local siteno = 0
	for i = 1, room.cfg.DeskSiteCount do
		local state = hall.desk.get_site_state(deskno, i)
		if state == SITE_STATE.READYWAIT or 
			((deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) and state == SITE_STATE.LEAVE) then
			readysite = readysite + 1
            siteno = i
		end
	end
	--��������������̭һ����
	if((deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) and 
	   siteno > 0 and 
	   deskdata.rounddata.roundcount > 0 and 
	   deskinfo.playercount == 1) then
		set_lost_or_prize(deskno, {siteno})
		return
	end

	local eventdata = {handle=0, deskno=deskno};
	eventmgr:dispatchEvent(Event("on_try_start_game", eventdata));

	if(eventdata.handle == 1) then
		return;
	end

	--TraceError("readysite = "..readysite)
	if readysite >= 2 then
        --��������һ�ֱ���������״̬����
    	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament)then
    		if(deskdata.rounddata.roundcount == 0 and readysite ~= deskinfo.max_playercount) then
    			return
    		end
		end

		--TraceError("��Ϸ��ʼ��~~")
		local old_zhuangsite = deskdata.zhuangsite or 0
		if(old_zhuangsite <= 0) then old_zhuangsite = 1 end

		--��ʼ����������
		deskinfo.betgold = 0
		local rounddata = table.clone(deskdata.rounddata)
		deskmgr.initdeskdata(deskno)
		deskdata = deskmgr.getdeskdata(deskno)		
		if(rounddata.roundcount > 0) then
			deskdata.rounddata = rounddata
		end

		--��ʼ����λ����
		for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
			deskmgr.initsitedata(deskno, siteno)
		end

		for _, player in pairs(deskmgr.getplayers(deskno)) do
			local site_state = hall.desk.get_site_state(deskno, player.siteno)
			--׼���õ���ҿ��Կ�ʼ��ʣ�µļ�������������
			if site_state == SITE_STATE.READYWAIT then
				hall.desk.set_site_state(deskno, player.siteno, SITE_STATE.WAIT)
				local userinfo = player.userinfo
				local sitedata = deskmgr.getsitedata(deskno, player.siteno)
				sitedata.isinround = 1
				sitedata.roundplayer = userinfo
				sitedata.gold = userinfo.chouma
				userinfo.chouma = 0
			elseif (deskinfo.desktype == g_DeskType.tournament or 
                    deskinfo.desktype == g_DeskType.channel_tournament or
                    deskinfo.desktype == g_DeskType.match) and site_state == SITE_STATE.LEAVE then
				local userinfo = player.userinfo
				local sitedata = deskmgr.getsitedata(deskno, player.siteno)
				sitedata.isinround = 1
				sitedata.roundplayer = userinfo
				sitedata.gold = userinfo.chouma
				userinfo.chouma = 0
			end
		end

        --Ѱ����һ��ׯ�ҵ�λ��
        local startsite = old_zhuangsite
        if(not startsite or startsite <= 0 or startsite > room.cfg.DeskSiteCount) then
            startsite = 1
        end
        while true do
            local newzhuangsite = deskmgr.getnextsite(deskno, startsite)
            if newzhuangsite and newzhuangsite > 0 then
                deskdata.zhuangsite = newzhuangsite
                break
            end
            startsite = startsite + 1
            if startsite > room.cfg.DeskSiteCount then startsite = 1 end
            if(startsite == old_zhuangsite) then
                TraceError("�쳣���:��Ϸ��ʼ����ôû������ׯ�ˣ�")
                return
            end
        end

		deskdata.gamestart_playercount = readysite  --��¼ÿ�ֿ�ʼʱ�������,
		
		--��Ϸ��ʼ��־
		deskmgr.set_game_state(deskno, gameflag.start)

		--��ʼ���ƺ�
		do
			deskdata.pokebox = {}
			for i = 1, #tex.pokenum do
				table.insert(deskdata.pokebox, i)
			end
			table.disarrange(deskdata.pokebox)
			table.disarrange(deskdata.pokebox)--��Ʒ��Ϊ�Ƶ�˳�򲻹��ң������ٴ���һ��
		end

		--������1
		deskdata.rounddata.roundcount = deskdata.rounddata.roundcount + 1
        deskdata.rounddata.xiazhucount = 0;

		--�㲥����״̬�ı�
		net_broadcast_deskinfo(deskno)
		
		--�㲥��Ϸ��ʼ
		net_broadcastdesk_gamestart(deskno);		

		--����
		fapai(deskno)
	end
end

--���ƺ���һ����
function getpokefrombox(deskno)
	trace("getpokefrombox("..deskno..")")
	local deskdata = deskmgr.getdeskdata(deskno)
	if #deskdata.pokebox == 0 then
		TraceError("�ƺ������������,����ô����")
		return 
	end
	local ret = deskdata.pokebox[1]
	table.remove(deskdata.pokebox, 1)
	return ret
end


--����, �Զ����ݵ�ǰ����������ʲô
function fapai(deskno)
	trace("fapai("..deskno..")")
	local deskdata = deskmgr.getdeskdata(deskno)
	local deskinfo = desklist[deskno]

    --��ÿ���˷�2����
    local sitelist = {}
    for _, player in pairs(deskmgr.getplayingplayers(deskno)) do
        local sitedata = deskmgr.getsitedata(deskno, player.siteno)
        if deskdata.zhuangsite == 0 then deskdata.zhuangsite = player.siteno end		--���ѡһ����ׯ
        table.insert(sitelist, player.siteno)
        for i = 1, 2 do
            local pokeid = getpokefrombox(deskno)
            table.insert(sitedata.pokes, pokeid)
		end
		
		--�۳�ˮ
		local choushui = get_specal_choushui(deskinfo,player.userinfo)
        if deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and deskinfo.desktype ~= g_DeskType.match then
			--�������棬��ˮ�ӱ�
			if(deskinfo.playercount <= 2) then
				choushui = choushui * 2
			end
            usermgr.addgold(player.userinfo.userId, -choushui, -choushui, g_GoldType.normalchoushui, g_GoldType.normalchoushui, 1)
            net_sendmybean(player.userinfo, player.userinfo.gamescore)
    		sitedata.gold = sitedata.gold - choushui
    		net_broadcastdesk_goldchange(player.userinfo)
        --������ֻ�ڵ�һ�ֳ�ˮ
        elseif (deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) and deskdata.rounddata.roundcount == 1 then
			--------------------�ɾ�---------------------
			xpcall(function()
					achievelib.updateuserachieveinfo(player.userinfo,1007) --�μӵ�����
				end,throw)
			--------------------------------------------
            if(deskinfo.at_least_gold ~= deskinfo.at_most_gold) then
                TraceError("��������������Ӧ�������������ͳ������߳���һ��......")
            end
            local joinfee = deskinfo.at_least_gold
            --�۳�ˮ
            usermgr.addgold(player.userinfo.userId, -choushui, 0, g_GoldType.deskmatchchoushui, -1, 1)
            --�۱�����
            usermgr.addgold(player.userinfo.userId, -joinfee, 0, g_GoldType.deskmatchjoin, -1, 1)
            net_sendmybean(player.userinfo, player.userinfo.gamescore)
        end
	end

	--��sitelist����,����ׯ��Сä����ä������˳������
	local tmpsitelist = {}
	for k, v in pairs(sitelist) do if v >= deskdata.zhuangsite then table.insert(tmpsitelist, v) end end
	for k, v in pairs(sitelist) do if v < deskdata.zhuangsite then table.insert(tmpsitelist, v) end end
	sitelist = tmpsitelist
	deskdata.playinglist = sitelist

	--���ô�Сäλ��
	deskdata.smallbetsite = deskmgr.getnextsite(deskno, deskdata.zhuangsite)
	deskdata.lagrebetsite = deskmgr.getnextsite(deskno, deskdata.smallbetsite)

	
	--�Զ��´�Сä(��ע)
	local siteno = deskmgr.getnextsite(deskno, deskdata.zhuangsite)
	
	--���⴦�������˵������ׯΪСä����Ϊ��ä
	if(deskinfo.playercount == 2) then
		siteno = deskdata.zhuangsite
		deskdata.smallbetsite = deskdata.zhuangsite --Сä
		deskdata.lagrebetsite = deskmgr.getnextsite(deskno, deskdata.smallbetsite) --��ä
	end

	local index = 1
	local startsite = siteno
	local tmp_num = 1 --��ֹ��ѭ�������������9�Σ��������20�λ�û�����϶�����
	while true and tmp_num < 20 do
		-----------------------------------------
		tmp_num = tmp_num + 1
		local sitedata = deskmgr.getsitedata(deskno, siteno)
		local userinfo = deskmgr.getsiteuser(deskno, siteno)
		local setbet = false

		if siteno == deskdata.smallbetsite then
			sitedata.betgold = deskinfo.smallbet
			setbet = true
		elseif siteno == deskdata.lagrebetsite then
			sitedata.betgold = deskinfo.largebet
			setbet = true
		end
		
		--[[if deskdata.rounddata.sitecount[siteno] == 0 and deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament then 
			sitedata.betgold = deskinfo.largebet
			setbet = true
		else
			if index == 1 then
				sitedata.betgold = deskinfo.smallbet
				setbet = true
			elseif index == 2 then
				sitedata.betgold = deskinfo.largebet
				setbet = true
			end
		end
		--]]
		if(setbet) then
			deskdata.maxbetgold = sitedata.betgold
			deskinfo.betgold = deskinfo.betgold + sitedata.betgold
			deskdata.totalbetgold = deskdata.totalbetgold + sitedata.betgold
		end
		
		--֪ͨ�ͻ���
		if userinfo then
			net_broadcastdesk_xiazhu(deskno, siteno, 3)
			net_sendmybean(userinfo, userinfo.gamescore);			--�Լ��ĵ��ݶ�
			useraddviewgold(userinfo, -sitedata.betgold, true)
			deskdata.rounddata.sitecount[siteno] = deskdata.rounddata.sitecount[siteno] + 1
		end
		-----------------------------------------
		index = index + 1
		siteno = deskmgr.getnextsite(deskno, siteno)
		if siteno == startsite then break end
	end
	
	--���߿ͻ��˲��ŷ��ƶ������Լ�2��������
	for _, player in pairs(deskmgr.getplayers(deskno)) do
		local sitedata = deskmgr.getsitedata(deskno, player.siteno)
		net_send_fapai(player.userinfo, sitelist, player.siteno, sitedata.pokes)
	end
	--����ս���˲��ŷ���
	net_send_fapai_forwatching(deskno, sitelist)

    eventmgr:dispatchEvent(Event("on_after_fapai", {deskno=deskno}));

	fadeskpai(deskno)
end

--���㲻���Ƿ�round�Ƿ�Ϊ0������ʳ�
function getcurrdeskpools(deskno, isjiesuan)
	--���㵱ǰ�ʳ����
	local deskdata = deskmgr.getdeskdata(deskno)
	local roundsitedatalist = {}
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		if sitedata.isinround == 1 then
			table.insert(roundsitedatalist, 
				{
					siteno		= siteno, 
					betgold		= sitedata.betgold, 
					isgiveup	= sitedata.islose, 
					isallin 	= sitedata.isallin,
				})
			if deskdata.round <= 0 then
				sitedata.roundbet = 0
			else
				sitedata.roundbet = sitedata.betgold
			end
		end
	end
	if isjiesuan or deskdata.round > 0 then
		local deskpools = getroundpool(roundsitedatalist)
		if isjiesuan and deskdata.round ==0 then  --����ʱֻ�д�Сä�ͱ������������һ������
			deskdata.pools = {}
			deskdata.pools[1] = 0
			for k, v in pairs(deskpools) do
				deskdata.pools[1] = deskdata.pools[1] + v
			end
		else
			deskdata.pools = deskpools
		end
	end

	return deskdata.pools
end
--�㲥������Ƶ�������
function notify_player_beatpoke(deskno)
    local deskdata = deskmgr.getdeskdata(deskno)
    for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		if sitedata.isinround == 1 then
			local newtable = table.mergearray(deskdata.deskpokes, sitedata.pokes)
			local userinfo = deskmgr.getsiteuser(deskno, siteno)
			local pokeweight, bestpokes = gettypeex(newtable)
			local pokestr = ""
			for k,v in pairs(bestpokes) do
				pokestr = pokestr .. tex.pokechar[v]
			end
			if userinfo ~= nil then
				--TraceError(format("���[%d]��pokeweight:%s, pokestr:%s", userinfo.userId, pokeweight, pokestr))
				net_send_bestpokes(userinfo, pokeweight, bestpokes)
			end
		end
	end
end

function fadeskpai(deskno)
	local deskdata = deskmgr.getdeskdata(deskno)
	local deskinfo = desklist[deskno]

	--ÿ�η������Ժ��������Ӧ�ö�����Ϊδ��ע
	for _, player in pairs(deskmgr.getplayingplayers(deskno)) do
		local sitedata = deskmgr.getsitedata(deskno, player.siteno)
		sitedata.isbet = 0
		eventmgr:dispatchEvent(Event("ongame_having_sitegold", {user_info = player.userinfo, deskno = deskno, round=deskdata.round}));
	end
   
	--��ǰ�����ټ�ע Ĭ��Ϊ��äע
	deskdata.roundaddgold = desklist[deskno].largebet

    if deskdata.round == 0 then
		deskdata.leadersite = deskmgr.getnextsite(deskno, deskdata.lagrebetsite)  --��ע��
		
	elseif deskdata.round == 1 then
		local newleader = deskmgr.getnextsite(deskno, deskdata.lagrebetsite)
		if newleader then			--�п��ܵ�һ�־����˷�����
			deskdata.leadersite = newleader
		end
		--��3����
		for i = 1, 3 do
			local pokeid = getpokefrombox(deskno)
            table.insert(deskdata.deskpokes, pokeid)
		end
	elseif deskdata.round == 2 or deskdata.round == 3 then
		local pokeid = getpokefrombox(deskno)
        table.insert(deskdata.deskpokes, pokeid)
	else
		jiesuan(deskno, true)
		return
	end

	if(deskdata.round > 0) then
		net_broadcast_deskpokes(deskno)
	end

	--��һ��
	process_site(deskno, deskdata.leadersite)

	--���㵱ǰ�ʳ�
	local currdeskpools = getcurrdeskpools(deskno, false)
	net_broadcast_deskpoolsinfo(deskno, currdeskpools)

	--�㲥������Ƶ�������
    	notify_player_beatpoke(deskno)
end


--����ĳ����� startsite ����
function process_site(deskno, siteno, startsite)
	--TraceError("process_site(" .. deskno .. ", " .. siteno .. ")")
	
	local deskdata = deskmgr.getdeskdata(deskno)
	local userinfo = deskmgr.getsiteuser(deskno, siteno)
	local sitedata = deskmgr.getsitedata(deskno, siteno)

	if not startsite then startsite = siteno end
	local nextsite = deskmgr.getnextsite(deskno, siteno)

	--�����ʣ�Լ��ˣ�����һ��ת������,�ͷ��ư�
	if (not nextsite) or startsite == nextsite then
		deskdata.round = deskdata.round + 1
        deskdata.rounddata.xiazhucount = 0;
		fadeskpai(deskno)
		return
	end

	--������˶�ȫ���ˣ��Լ�Ҳ��ƽ�ģ�Ҳ�ٷ���
	--���˴���Ϊ����ʽ���룬�����д������getnextsite�͹��˵�allin�˵ģ��������ڲ��Ҹģ����ò⣩
	local isnototherallin = 0
	for _, player in pairs(deskmgr.getplayingplayers(deskno)) do
		local userinfo = player.userinfo
		local sitedata = deskmgr.getsitedata(deskno, player.siteno)
		if sitedata.isinround == 1 then
			if sitedata.isallin ~= 1 and player.siteno ~= siteno then
				isnototherallin = 1
				break
			end
		end
	end
	--TraceError("isnototherallin=" .. isnototherallin)
	if sitedata.betgold == deskdata.maxbetgold and isnototherallin == 0 then
		deskdata.round = deskdata.round + 1
        deskdata.rounddata.xiazhucount = 0;
		fadeskpai(deskno)
		return
	end

	--ȫ�¹����ز�����壻 ûȫ�¹�����ƽ��û�¹��������Ҫ�����
	if sitedata.isallin == 0 and (sitedata.isbet == 0 or sitedata.betgold < deskdata.maxbetgold) then
		--��������������Զ�����
		if userinfo and hall.desk.get_site_state(deskno, siteno) == SITE_STATE.LEAVE then
			letusergiveup(userinfo)
			return
		end
		show_panel(deskno, siteno, isnototherallin)		--��ʾ�������
		show_auto_panel(deskno, siteno)		--��ʾ�Զ����
	else
		--�����¸���
		return process_site(deskno, nextsite, startsite)
	end
end

--��ʾ�Զ����
function show_auto_panel(deskno, siteno)
	--TraceError("show_auto_panel(" .. deskno .. ", " .. siteno .. ")")
	local deskdata = deskmgr.getdeskdata(deskno)
	local sitedata = deskmgr.getsitedata(deskno, siteno)
	local rule = sitedata.panelrule
	local panelsite = siteno

	local autocount = 0
	for i = 1, 9 do
		panelsite = deskmgr.getnextsite(deskno, panelsite)
		if panelsite and panelsite ~= siteno then
			local panelsitedata = deskmgr.getsitedata(deskno, panelsite)
			local paneluserinfo = deskmgr.getsiteuser(deskno, panelsite)
			if paneluserinfo then
				if autocount < 9 and 
                   panelsitedata.isallin == 0 and 
                   (panelsitedata.isbet == 0 or panelsitedata.betgold < deskdata.maxbetgold) then
					local autodata = _S
					{
						guo 		= 0, 
						guoqi 		= 1,
						genrenhe 	= 1, 
						gen 		= 0, 
						gengold 	= 0,
					}
					if deskdata.maxbetgold > panelsitedata.betgold then
						if panelsitedata.gold + panelsitedata.betgold <= deskdata.maxbetgold then	--Ǯ���������͸��ǻҵ�
							autodata.guo		= 0
							autodata.gen		= 0
							autodata.gengold	= 0
						else																		--ֻ�й��ǻҵ�
							autodata.guo		= 0
							autodata.gengold 	= deskdata.maxbetgold - panelsitedata.betgold
							autodata.gen		= 1
						end
					else
						autodata.guo 			= 1													--���Թ������˼�û��ע�Ļ������ǻҵ�
						autodata.gengold 		= 0
						autodata.gen			= 0
					end
					net_show_autopanel(paneluserinfo, autodata)
					autocount = autocount + 1
				else
					if paneluserinfo then
						local autodata = _S
						{
							guo 		= 0, 
							guoqi 		= 0,
							genrenhe 	= 0, 
							gen 		= 0, 
							gengold 	= 0,
						}
						net_show_autopanel(paneluserinfo, autodata)
					end
				end
			end
		else
			break
		end
	end

	--���������˳���������
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		local userinfo = deskmgr.getsiteuser(deskno, siteno)
		if userinfo and sitedata.isinround and sitedata.islose == 1 then
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
	end
end

--�ָ����
function restore_panel(user_info, desk_no, site_no)
	local site_data = deskmgr.getsitedata(desk_no, site_no)
	local desk_data = deskmgr.getdeskdata(desk_no)
	local desk_info = desklist[desk_no]
	if (hall.desk.get_site_state(desk_no, site_no) == SITE_STATE.PANEL) then
		local rule = site_data.panelrule
		rule = table.clone(rule)
		process_panel_limit(rule, site_data, desk_info, desk_data)
		net_showpanel(user_info, rule);
	end
end

--�����������
function process_panel_limit(rule, site_data, desk_info, desk_data)
	--rule.gengold = rule.gengold + (sitedata.betgold - sitedata.roundbet)
	rule.max = rule.max + (site_data.betgold - site_data.roundbet)
	rule.min = rule.min + (site_data.betgold - site_data.roundbet)

	if(desk_info.limit ~= nil and desk_info.limit == 1) then
		--������ע��ʼ
		local smallbet, largebet = getLimitXiazhu(desk_info, desk_data, site_data);
		--ǰ����
		rule.min = smallbet + (site_data.betgold >= desk_data.maxbetgold and 0 or (site_data.betgold - site_data.roundbet));
		rule.max = rule.min; 
		rule.allin = 0;	
		if(desk_data.rounddata.xiazhucount >= 3) then
			--�Ѿ���ע��������
			if(rule.jia == 1) then--���ϻ���Ǯ�����Լ�ע�������޼�ע��
				rule.jia = 0;
				rule.gengold = desk_data.maxbetgold - site_data.betgold;
				rule.gen = 1;
				rule.allin = 0;
			end
		end
	end
end

--��ʾ���
function show_panel(deskno, siteno, isnototherallin)
	--TraceError("show_panel(" .. deskno .. ", " .. siteno .. ")")
	local deskdata = deskmgr.getdeskdata(deskno)
	local deskinfo = desklist[deskno]
	local userinfo = deskmgr.getsiteuser(deskno, siteno)
	local sitedata = deskmgr.getsitedata(deskno, siteno)

	if not userinfo then return end

	--��ѯ���Լ��������˵���߸�ƽ���ʣ�����
	local allowMaxGold = 0
	for k, v in pairs(deskmgr.getallsitedata(deskno)) do
		if k ~= siteno and v.isinround == 1 and v.islose == 0 then
			local gold = v.gold + v.betgold - deskdata.maxbetgold --����˸�ƽ���ʣ�����
			if(allowMaxGold < gold) then
				allowMaxGold = gold
			end
		end
	end

	local rule = sitedata.panelrule
	if deskdata.maxbetgold > sitedata.betgold then
		if sitedata.gold + sitedata.betgold <= deskdata.maxbetgold then
			--��ȫ��/������
			rule.gengold 	= sitedata.gold
			rule.gen		= 1
			rule.buxiazhu	= 0
			rule.xiazhu		= 0
			rule.jia 		= 0
			rule.allin		= 0		--ȫ��
			rule.fangqi		= 1		--����
			rule.max		= sitedata.gold
			rule.min 		= sitedata.gold
		else
			--�������ӣ�������
			rule.gengold 	= deskdata.maxbetgold - sitedata.betgold	--������Ǯ
			rule.gen		= 1		--��
			rule.buxiazhu	= 0
			rule.xiazhu		= 0
			rule.jia 		= 1		--��
			rule.allin		= 1 
			rule.fangqi		= 1		--����
			rule.max		= math.min(rule.gengold + allowMaxGold, sitedata.gold)		--���Ӷ���Ǯ
			rule.min 		= rule.gengold + deskdata.roundaddgold		--���ټӶ���Ǯ
			if rule.min >= rule.max then
				--rule.jia 		= 0		--��
				--rule.allin		= 0		--allin
				rule.min = rule.max
			end
			if isnototherallin == 0 then  --������ȫ��,�Ͳ����ټ���
				rule.jia = 0
			end
		end
	else
		--������/��ע/������
		rule.gengold 	= 0
		rule.gen		= 0
		rule.buxiazhu	= 1		--����
		rule.xiazhu		= 0		--��ע
		rule.jia 		= 1
		rule.allin		= 1 
		rule.fangqi		= 1		--����
		rule.max		= math.min(allowMaxGold, sitedata.gold)
		rule.min 		= deskdata.roundaddgold
		if rule.min >= rule.max then
			--rule.xiazhu 	= 0		--��
			--rule.jia		= 1		--allin
			rule.min = rule.max
		end
	end
	--TraceError("rule source:" .. tostringex(rule))
	rule = table.clone(rule)
	process_panel_limit(rule, sitedata, deskinfo, deskdata)	
	if sitedata.panellefttime > 0 then			
		--�����ʾ������鹦�ܵ�����״̬���¼��㣬ʱ��Ҫ����ط�����ǰ��ʣ��ʱ��
		hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.PANEL, sitedata.panellefttime)
	elseif(deskinfo.fast == 1) then 
		hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.PANEL, tex.cfg.fastdelay)
	else
		hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.PANEL)
	end

	net_showpanel(userinfo, rule);

    eventmgr:dispatchEvent(Event("on_show_panel", {deskno = deskno, siteno = siteno}));
end

function getLimitXiazhu(deskinfo, deskdata, sitedata) 
    local smallbet = 0;
    local largebet = 0;

    if(deskdata.round < 2) then
        smallbet = deskdata.maxbetgold - sitedata.betgold + deskinfo.smallbet;
    elseif(deskdata.round >= 2) then
        smallbet = deskdata.maxbetgold - sitedata.betgold + deskinfo.largebet;
    end
    largebet = smallbet; 
    return smallbet, largebet;
end

--ͨ����Ҽӳɺ����Ӵ�Сä���㾭��ֵ,
function getAddexp(deskno, addgold)
	if not deskno then return end
	local deskinfo = desklist[deskno]

	local addexp = 0
	local addtype = -1
	if deskinfo.desktype == g_DeskType.normal or deskinfo.desktype == g_DeskType.channel or deskinfo.desktype == g_DeskType.channel_world then
		if addgold and addgold > 0 then
			--TraceError("Ӯ��")
			addtype = g_ExpType.win
			if addgold < 1000 then
				addexp = 4
			elseif addgold < 5000 then
				addexp = 8
			elseif addgold < 10000 then  --1w
				addexp = 12
			elseif addgold < 50000 then  --5w
				addexp = 16
			elseif addgold < 100000 then  --10w
				addexp = 20
			elseif addgold < 500000 then --50w
				addexp = 24
			elseif addgold < 1000000 then --100w
				addexp = 28
			elseif addgold < 5000000 then --500w
				addexp = 32
			elseif addgold < 10000000 then --1000w
				addexp = 36
			elseif addgold < 50000000 then --50000w
				addexp = 40
			elseif addgold < 100000000 then --10000w
				addexp = 44
			else --10000w+
				addexp = 48
			end
		else
			--TraceError("����")
			addtype = g_ExpType.lost
			local largebet = deskinfo.largebet
			if largebet < 10 then
				addexp = 1
			elseif largebet < 20 then
				addexp = 2
			elseif addgold < 100 then
				addexp = 3
			elseif largebet < 500 then
				addexp = 4
			elseif largebet < 5000 then
				addexp = 5
			elseif largebet < 50000 then
				addexp = 6
			elseif largebet < 200000 then
				addexp = 7
			elseif largebet < 1000000 then
				addexp = 8
			elseif largebet < 2000000 then
				addexp = 9
			else 
				addexp = 10
			end
		end

		if deskinfo.desktype == g_DeskType.VIP then
			addexp = addexp * 2
		end
	elseif deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament then
		local joinfee = deskinfo.at_least_gold
		if addgold and addgold > 0 then
			--TraceError("Ӯ��")
			addtype = g_ExpType.deskmatchwin
			if joinfee < 500 then
				addexp = 3
			elseif joinfee < 5000 then
				addexp = 6
			elseif joinfee < 50000 then 
				addexp = 9
			elseif joinfee < 250000 then 
				addexp = 12
			elseif joinfee < 500000 then  
				addexp = 15
			elseif joinfee >= 500000 then 
				addexp = 18
			end
		else
			--TraceError("����")
			addtype = g_ExpType.deskmatchlost
			if joinfee < 500 then
				addexp = 1
			elseif joinfee < 5000 then
				addexp = 2
			elseif joinfee < 50000 then 
				addexp = 3
			elseif joinfee < 250000 then 
				addexp = 4
			elseif joinfee < 500000 then  
				addexp = 5
			elseif joinfee >= 500000 then 
				addexp = 6
			end
		end
	end
	return addtype, addexp
end

function setextrainfo(userinfo, deskno, sitedata, addgold)
	--ǿ��֮��������Ϣ
	--F00:�����[��r�g,F01:����Aȡ�[���,F02:�������,F03:���^�֔�,F04:�A�^�֔�,
	--F05:��ߓ����[���,F06:���є���,F07:����ݔ�A,��þ���,F08:Ӯ���ĵ�����������
    --F09:�ڸ������ʷ������Ӯ��¼
	local extra_info = userinfo.extra_info
    local deskinfo = desklist[deskno]
	--�ܾ���
	extra_info["F03"] = extra_info["F03"] + 1

	--�ж�����(���ǽ��վ͵�����)
	local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
	if(sys_today ~= userinfo.dbtoday) then --���ڲ���
		--���ò�ͬ��
		userinfo.dbtoday = sys_today
		dblib.cache_set(gamepkg.table, {today = sys_today}, "userid", userinfo.userId)
		userinfo.gameInfo.todayexp = 0
		dblib.cache_set(gamepkg.table, {todayexp = 0}, "userid", userinfo.userId)

		userinfo.extra_info["F07"] = addgold
	else
		extra_info["F07"] = extra_info["F07"] + addgold
	end

	--���Ӯȡ
	if(addgold > extra_info["F01"]) then extra_info["F01"] = addgold end

	--Ӯ������
	if(addgold > 0) then extra_info["F04"] = extra_info["F04"] + 1 end

	--���ӵ�й���Ϸ��
	if(userinfo.gamescore > extra_info["F05"]) then extra_info["F05"] = userinfo.gamescore end

	--�������
	if(sitedata.pokeweight > extra_info["F02"].pokeweight) then
		extra_info["F02"].pokeweight = sitedata.pokeweight
		extra_info["F02"].pokes5 = sitedata.pokes5
    end

    --������������ʷ�������һ����Ϸʱ��
    local smallbet = deskinfo.smallbet
    if(addgold > 0 and type(extra_info["F09"][smallbet]) == "table") then
        local currtime = os.time()

        extra_info["F09"]["last_time"] = currtime
        extra_info["F09"][smallbet]["gametime"] = currtime
    end
 
	userinfo.extra_info = extra_info
	save_extrainfo_to_db(userinfo)
end
--�ж��Ǹ÷���������̭
--�콱�������ͬʱ����̭����Ϊ��̭ʱ�����һ��
--�磺3����̭�����������˶�Ϊ������
function set_lost_or_prize(deskno, sitelist)
	if not deskno then return end
	if not sitelist or #sitelist <= 0 then return end

	local deskinfo = desklist[deskno]
	if deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament then 
		TraceError("���Ǳ�������ʲô������")
		return 
	end
	local deskdata = deskmgr.getdeskdata(deskno)
	local rounddata = deskdata.rounddata

	local mingci = deskinfo.playercount
	--�ʳص�����
	local bonus = deskinfo.at_least_gold * deskinfo.max_playercount

	for i = 1, #sitelist do
		local addgold = 0
		local addexp = 0
		local userinfo = deskmgr.getsiteuser(deskno, sitelist[i])
		if userinfo ~= nil then
			userinfo.chouma = 0
			userinfo.tour_point = 0
            if (tex_dailytask_lib) then
			    xpcall(function()tex_dailytask_lib.set_mingci(userinfo,mingci) end,throw)
            end

			if (mingci > 3) then
				--TraceError(format("���ź������Ѿ��ڱ��ֱ�������̭���֣������������:��%d��", mingci))
			elseif(mingci == 3) then
				addgold = math.floor(bonus * 0.2)
				addexp = 5
				--TraceError(format("��ϲ�����ڱ��ֱ����з��ӳ�ɫ����õ�%d������òʳؽ���%d��ң�����%d", mingci, addgold, addexp))
			elseif(mingci == 2) then
				addgold = math.floor(bonus * 0.3)
				addexp = 10
				--TraceError(format("��ϲ�����ڱ��ֱ����з��ӳ�ɫ����õ�%d������òʳؽ���%d��ң�����%d", mingci, addgold, addexp))
			elseif(mingci == 1) then
				addgold = math.floor(bonus * 0.5)
				addexp = 15
				--TraceError(format("��ϲ�����ڱ��ֱ����з��ӳ�ɫ����õ�%d������òʳؽ���%d��ң�����%d", mingci, addgold, addexp))
				--------------------�ɾ�---------------------
				xpcall(function()
						achievelib.updateuserachieveinfo(userinfo,2017) --��̭������
					end,throw)
				--------------------------------------------
			end
			if(addgold > 0) then
				usermgr.addgold(userinfo.userId, addgold, 0, g_GoldType.deskmatchprize, -1, 1)
			end
			if(addexp > 0) then
				usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), addexp, g_ExpType.deskmatchprize, groupinfo.groupid)
			end
			net_send_prizeorlost(userinfo, mingci, addgold, addexp)
			if addgold > 0 then
				local extra_info = userinfo.extra_info
				extra_info["F08"] = extra_info["F08"] + 1
				userinfo.extra_info = extra_info
				save_extrainfo_to_db(userinfo)
			end

			doStandUpAndWatch(userinfo)
		end
	end

	if deskinfo.playercount <= 0 then
		--�ó���һ��֮��Ҫ������Ϸ����
		rounddata.roundcount = 0
		deskinfo.betgold = 0
		deskinfo.usergold = 0
		if deskmgr.get_game_state(deskno) ~= gameflag.notstart then
			deskmgr.set_game_state(deskno, gameflag.notstart)
		end
	end
end

--��ȡ����ʳص���Ӯ��ϸ
--����һ����ԭ�Ĺ��̣����ÿ���ʳ��ܽ����ȷ������֮ǰ�ļ�����
function getdeskpools(sitewininfo)
	local deskpools = {}
	for siteno, wininfo in pairs(sitewininfo) do
		for i = 1, #wininfo.poollist do
			local poolindex = wininfo.poollist[i].poolindex		--�ʳ�ID
			local winchouma = wininfo.poollist[i].poolgold		--�����ڱ���Ӯ�ó�����
			if(deskpools[poolindex] == nil) then
				deskpools[poolindex] = {chouma = 0,winlist = {}}
			end
			table.insert(deskpools[poolindex].winlist, {siteno = siteno, winchouma = winchouma})
			deskpools[poolindex].chouma = deskpools[poolindex].chouma + winchouma  --��ԭ�ʳ��ܳ���
		end
	end
	return deskpools
end

--��ũ����������ʱ����Ϣ
function send_online_message_tofarm(userinfo, addtime)
    --�Ϸ��Լ��
    --TraceError("��ũ����������ʱ����Ϣ")
    if gamepkg.name ~= 'tex' or not userinfo then return end
    if not userinfo.farmtree then return end
    
    if addtime == nil or addtime <= 0 then return end
    local tmpstr = "call yysns_farm.sp_insert_tex_message('%s', %d, %d, '%s', '%s')"
    local sql = format(tmpstr, userinfo["userName"], userinfo["nRegSiteNo"], g_FarmType.online, tostring(addtime), '')
    xpcall(function() 
        dblib.dofarmsql(sql, function(dt) trace("��ũ������SQL�󣬷�����Ϣ") end) 
        end,throw)
end

--��ũ���������̾���Ϣ�����ӹ�ʵ�ɳ���
--PaiXing 1:����,2:һ��,3:����,4:����,5:˳��,6:ͬ��,7:��«,8:����,9:ͬ��˳,10:�ʼ�ͬ��˳
function send_fruits_message_tofarm(userinfo, paixing)
    --TraceError("��ũ���������ӹ�ʵ�ɳ�����Ϣ")
    if not userinfo then return end
	if not userinfo.desk or not userinfo.site then return end
	local smallbet = desklist[userinfo.desk].smallbet

    if not userinfo.farmtree then return end --ũ����Ҳŷ�����Ϣ
    if paixing == nil or paixing < 0 or paixing > 10 then return end
    local tmpstr = "call yysns_farm.sp_insert_tex_message('%s', %d, %d, '%s', '%s')"
	local roundstr = format("|%s|%s",tostring(paixing), tostring(smallbet))  --ũ��1.5���ɳ���
	--local roundstr = format("%s",tostring(paixing))
    local sql = format(tmpstr, userinfo["userName"], userinfo["nRegSiteNo"], g_FarmType.fruits, roundstr, '')
	xpcall(function()
			dblib.dofarmsql(sql, function(dt) trace("��ũ������SQL�󣬷�����Ϣ") end)
		end,throw)
end

--��¼������Ӯ��ϸ
function record_today_detail(userinfo, wingold)
	if not userinfo.desk or not userinfo.site then return end
	local deskno = userinfo.desk
	local siteno = userinfo.site

	local deskinfo = desklist[deskno]
	local sitedata = deskmgr.getsitedata(deskno, siteno)

	local userid = userinfo.userId
	local smallbet = deskinfo.smallbet
	local largebet = deskinfo.largebet
	local betgold = sitedata.betgold
	local betfalg = 0
	if(sitedata.isallin == 1) then betfalg = 1 end
	if(sitedata.islose == 1) then betfalg = -1 end
	local pokeweight = sitedata.pokeweight
	local strpokes5 = ""
	for k,v in pairs(sitedata.pokes5) do
		strpokes5 = strpokes5 .."|".. v 
	end
	local sys_time = os.date("%Y-%m-%d %X", os.time())	--ʱ��
	local sqltmplet = "call sp_add_tex_todaydetail(%d,'%s',%d,%d,%d,%d,%d,'%s','%s','%s');"
	local sql = format(sqltmplet, userid, sys_time, smallbet, largebet, betgold, wingold, betfalg, tostring(pokeweight), strpokes5, '')
	--TraceError(sql)
	--dblib.execute(sql) --��Ҫ��¼���ݿ⣬�Ῠ��
	--ͬ���ͻ���
	local record = {}
	record["sys_time"] = sys_time
	record["smallbet"] = smallbet
	record["largebet"] = largebet
	record["betgold"] = betgold
	record["wingold"] = wingold
	record["betflag"] = betfalg
	record["pokeweight"] = tostring(pokeweight)
	record["pokes5"] = strpokes5
    if(betgold > 0)then
	    net_send_detailrecord(userinfo, record)
    end

	--��¼��ʤ��,��ʤ������3���ҿ�ʼ���ˣ�������ʤ������10
	local winningstreak = userinfo.winningstreak or {count = 0, begintime = os.date("%Y-%m-%d %X", os.time())}
	if wingold > 0 then
		winningstreak.count = winningstreak.count + 1
	else
    	if (wingold < 0 and winningstreak.count >= 3) then
    		sqltmplet = "insert into log_winning_streak (`user_id`,`win_count`,`bigin_time`,`end_time`,`remark`) values(%d, %d, '%s', '%s','');commit;" 
    		sql = format(sqltmplet, userid, winningstreak.count, winningstreak.begintime, sys_time)
    		dblib.execute(sql)
    		winningstreak = {count = 0, begintime = sys_time} --���ü�����
        end
    end
	userinfo.winningstreak = winningstreak
end

--����
function jiesuan(deskno, complete)
	--TraceError("jiesuan() ��ʼ������~,complete = "..tostring(complete))
	local deskdata = deskmgr.getdeskdata(deskno);
	local deskinfo = desklist[deskno]

	--���㵱ǰ�ʳ����
	local currdeskpools = getcurrdeskpools(deskno, true)
	net_broadcast_deskpoolsinfo(deskno, currdeskpools)

	--�㲥������Ƶ�������
	notify_player_beatpoke(deskno)

	--����ÿ����ҵ��������
	local iscomplete = complete or false
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		if sitedata.isinround == 1 and iscomplete then
			sitedata.pokeweight, sitedata.pokes5 = gettypeex(table.mergearray(deskdata.deskpokes, sitedata.pokes))
		else
			sitedata.pokeweight, sitedata.pokes5 = 0, {}
		end
	end

	--���ˢǮ����
	local needTrace = false  --��ӡ������Ϣ
	for _, player in pairs(deskmgr.getplayingplayers(deskno)) do
		local sitedata = deskmgr.getsitedata(deskno, player.siteno)
        local can_use_gold = get_canuse_gold(player.userinfo, 1);
		if (deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament and deskinfo.desktype ~= g_DeskType.match) and sitedata.betgold > can_use_gold then
			TraceError("��["..deskno.."]����������ˢǮ betgold=" .. sitedata.betgold .. "��gamescore=" .. can_use_gold)
			sitedata.betgold = can_use_gold  --ǿ�Ʊ��ʵ�ʳ�����
			--��ʱ��ǿ�����������
			--forceGameOver(player.userinfo)
			--return
			needTrace = true
		end
	end
	if needTrace then TraceError(tostringex(desklist[deskno])) end
	
	--��ȡ��������
	local roundsitedatalist = {}
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		if sitedata.isinround == 1 then
			local jiesuandata = {}
			jiesuandata["siteno"] = siteno
			jiesuandata["betgold"] = sitedata.betgold
			jiesuandata["isgiveup"] = sitedata.islose
			jiesuandata["weight"] = sitedata.pokeweight
			table.insert(roundsitedatalist, jiesuandata)
		end
	end

	local pools, sitewininfo = getjiesuandata(roundsitedatalist)
	
	--���������в�����������
	for k_site, v in pairs(sitewininfo) do
		local sitedata = deskmgr.getsitedata(deskno, k_site)
		v.pokes5 = sitedata.pokes5
		v.pokes = sitedata.pokes
		v.weight = sitedata.pokeweight
	end

	--����б�
	local sitelist = {}
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		if sitedata.isinround == 1 and sitedata.islose == 0 then
			table.insert(sitelist, siteno)
		end
	end

	--����ʳ�
	local deskpools = getdeskpools(sitewininfo)

	--�쳣������ֹ�����ڽ�����;������Ϸ
	local jiesuanwait = deskdata.jiesuanwait --{jiesuantime = 0, needwait = 0, someonestart = 0, startplan = nil}
	jiesuanwait.jiesuantime = os.time()
	if complete then
		jiesuanwait.needwait = #deskpools * 5 + 7  --�Ʋ�ƽ��ÿ���ʳ���Ҫ5���ӣ�����ʱ��7��
	else
		jiesuanwait.needwait = 8  --���Ƶ��µĽ���
	end
	--TraceError("jiesuanwait.needwait���Ʋ�ƽ�ֲʳص�ʱ��:"..jiesuanwait.needwait)
	jiesuanwait.someonestart = 0
	if(jiesuanwait.startplan ~= nil) then
		jiesuanwait.startplan.cancel()
		jiesuanwait.startplan = nil
	end
	jiesuanwait.startplan = timelib.createplan(
        function()
	        --��ʼ��Ϸ
			--TraceError("jiesuanwait.startplan ��Ϸ��ʼ~~")
			trystartgame(deskno, true)
			jiesuanwait.startplan = nil
        end
    , jiesuanwait.needwait)

	--�㲥����Э��
	net_broadcastdesk_jiesuan(deskno, sitewininfo, sitelist, deskpools, iscomplete)

	local sitewininfoex = table.clone(sitewininfo)    
    local userinfo=nil
    local playinglist = deskmgr.getdeskdata(deskno).playinglist;
	--�Ӽ�Ǯ(�������в����˵��û����������µĺ��Ѿ����˵ģ�������ͬһ����λ��������������)
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
        if sitedata.isinround == 1 then		
            userinfo = sitedata.roundplayer
			local addgold = -sitedata.betgold
			local wingold = 0
			if sitewininfo[siteno] then
				wingold = sitewininfo[siteno].wingold
			end
			addgold = addgold + wingold

            --�����ƾֵ�ӮǮ���ܶ�
            if addgold > 0 then
                xpcall(function() dblib.execute(string.format(tSqlTemplete.update_gold_system, addgold, 2, 3, 90)) end,throw);
            end

			--��¼extra_info
			setextrainfo(userinfo, deskno, sitedata, addgold)

			--���ڡ�����
			if(newyear_lib) then
				xpcall(function() newyear_lib.ongameover(userinfo,addgold,#playinglist) end, throw)
			end
			

			--�һ��,������Ϸʱ��
			if(onlineprizelib) then
				local starttime = timelib.db_to_lua_time(deskdata.starttime) or os.time()
				local addtime = os.time() - starttime
				if(addtime > 0) then
				    xpcall(function() onlineprizelib.onGameOver(userinfo, addtime) end, throw)
				end
			end 
			
			-----------------------------------���ӵĲ��------------------------------------

			--���㾭��
			local nType, addexp = getAddexp(deskno, addgold)
			--ͬһ����λ����ң�վ�������²��ܻ�þ���(chouma > 0˵����վ����)
			if(deskmgr.getsiteuser(deskno, siteno) == userinfo and userinfo.chouma == 0) then
				usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), addexp, nType, groupinfo.groupid)
			end

			--���ӽ�����Ϣ
			sitewininfoex[siteno] = sitewininfoex[siteno] or _S{win_real_gold = 0, wingold = 0}
			sitewininfoex[siteno].win_real_gold = addgold

			if sitedata.islose == 0 then   --û�������˲Ÿ�Ǯ�;���
                if(deskinfo.desktype ~= g_DeskType.match) then
                    if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament) then
        				--+Ǯ 
        				usermgr.addgold(userinfo.userId, addgold, 0, g_GoldType.normalwinlost, -1, 1)
    					record_today_detail(userinfo, addgold)
                    else
                        userinfo.tour_point = userinfo.tour_point + addgold
                    end
                end
	
				local userid = userinfo.userId
				local betgold = -sitedata.betgold
				local nSid = userinfo.nSid
				local curgold = userinfo.gamescore
				local level = usermgr.getlevel(userinfo)
				local joinfee = deskinfo.at_least_gold
				local choushui = get_specal_choushui(deskinfo,userinfo)
                local safegold = userinfo.safegold or 0
                local channel_id = userinfo.channel_id or -1;
                if(deskinfo.desktype ~= g_DeskType.match) then
    				if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament) then
    					--�������棬��ˮ�ӱ�
    					if(deskinfo.playercount <= 2) then
    						choushui = choushui * 2
    					end
    					betgold = betgold - choushui
    				else
    					userinfo.tour_point = userinfo.tour_point - sitedata.betgold
    					--������ֻ�ڱ�����ʼ�ĵ�һ����ȡ�����Ѻͳ�ˮ
    					if(deskdata.rounddata.roundcount > 1) then
    						joinfee = 0
    						choushui = 0
    					end
                    end
                end
                if (duokai_lib and duokai_lib.is_sub_user(userid) == 1) then
                    sitedata.logsql = format("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d ", 
    										 duokai_lib.get_parent_id(userid), addgold, addexp, 
                                             nSid, curgold, level, joinfee, choushui, safegold, channel_id);--����Ƶ��id
                else
    				sitedata.logsql = format("%d, %d, %d, %d, %d, %d, %d, %d, %d, %d ", 
    										 userid, addgold, addexp, nSid, curgold, level, 
                                             joinfee, choushui, safegold, channel_id);--����Ƶ��id
                end
			end
			
			--������֪ͨ�ͻ����ˣ�������Ĺ㲥����Э�飬�������ͻ���ˢ�����
			if deskmgr.getsiteuser(deskno, siteno) == userinfo and userinfo.chouma == 0 then  --�û������ڱ����Ļ�
				--Ӯ���޸��´ε���ע��
				userinfo.chouma = sitedata.gold + wingold
				net_broadcastdesk_goldchange(userinfo)

				if userinfo.chouma >= 1000000 then
					achievelib.updateuserachieveinfo(userinfo,3008)--���򸻺�
				end
            end
            --�������ӿ�
            if (tex_suanpaiqilib) then
                xpcall(function() tex_suanpaiqilib.on_user_game_over(userinfo) end, throw)
            end

            --��ս���ˣ��������10���ӻ������£����߳�������
            xpcall(function() kick_timeout_user_from_watchlist(deskinfo) end, throw)   
            --�����״��棬Ҫ�ͻ��˷���Ӧ����ʾ
            xpcall(function() new_user_process(userinfo,addgold) end, throw)

            --����趨���Զ���ע����Ҫ������Զ�����뵽���Я��
            --����ֵ����ֹ����
            if(userinfo.gameinfo==nil)then
                userinfo.gameinfo={}
                userinfo.gameinfo.is_auto_addmoney=0
                userinfo.gameinfo.is_auto_buy=0
            end

            --���Ӯ��Ǯ��������Ӯ��Ǯ+���Я�������������Я��
            local auto_buy_gold=deskinfo.at_most_gold
            if(userinfo.gameinfo.is_auto_addmoney==1)then
                if(userinfo.chouma>=deskinfo.largebet and userinfo.chouma<=deskinfo.at_most_gold)then
                    local can_use_gold = get_canuse_gold(userinfo, 1);
                    if(can_use_gold>=deskinfo.at_most_gold)then
                        dobuychouma(userinfo, deskno, siteno, deskinfo.at_most_gold)
                    else
                        dobuychouma(userinfo, deskno, siteno, can_use_gold)
                    end
                end
            end

        end
        
	end

	--�������������0
	deskinfo.betgold = 0

	--todo cw ����־
	do
		local sql = format("%d, %d, %d, '%s', '%s', ",
						   deskno, desklist[deskno].smallbet, desklist[deskno].desktype, deskdata.starttime, os.date("%Y-%m-%d %X", os.time()))
		for i = 1, 9 do
			local userinfo = deskmgr.getsiteuser(deskno, i)
			local sitedata = deskmgr.getsitedata(deskno, i)
			if sitedata.isinround == 1 then
				sql = sql .. sitedata.logsql .. ","
			else
				sql = sql .. "0,0,0,0,0,0,0,0,0,0,";--����Ƶ��id
			end
			sitedata.isinround = 0
		end
		sql = string.sub(sql, 1, string.len(sql) - 1)
		sql = string.format(tTexSqlTemplete.insertLogRound, sql);
		dblib.execute(sql);
	end

	if deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament then
		--����
		xpcall(function() dispatch_quest_data_jiesuan(deskno, sitewininfoex)  end,throw)
    end

    if(channellib) then
        xpcall(function() channellib.on_game_over(deskno, sitewininfoex) end, throw);
    end

	--��Ϸ����
	deskmgr.set_game_state(deskno, gameflag.notstart)

    --��Ϸ��ʼʱ�����ֵ�����״̬
    if (tex_buf_lib) then
        xpcall(function() tex_buf_lib.set_aleady_kick(deskno,0) end,throw)
    end

	--��ʼ����λ����
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		deskmgr.initsitedata(deskno, siteno)
	end
	deskdata.playinglist = {}
	deskdata.deskpokes = {}
	deskdata.pools = {}

	--��ʼ����λ����
	for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
		deskmgr.initsitedata(deskno, siteno)
	end
	deskdata.playinglist = {}
	deskdata.deskpokes = {}
	deskdata.pools = {}
	--������λ״̬
	local sitelist = {}	
	for _, player in pairs(deskmgr.getplayers(deskno)) do
		local site_state = hall.desk.get_site_state(deskno, player.siteno)
		local playerinfo = player.userinfo
        local sitedata = deskmgr.getsitedata(deskno, player.siteno)
		local needgold = deskinfo.largebet + deskinfo.specal_choushui + 1

		if ((deskinfo.desktype ~= g_DeskType.match and deskinfo.desktype ~= g_DeskType.tournament and 
             deskinfo.desktype ~= g_DeskType.channel_tournament) and playerinfo.chouma < needgold) then
            local can_use_gold = get_canuse_gold(playerinfo, 1);
			if can_use_gold >= deskinfo.at_least_gold then
				if(site_state ~= SITE_STATE.NOTREADY and site_state ~= SITE_STATE.BUYCHOUMA) then
					hall.desk.set_site_state(deskno, player.siteno, SITE_STATE.BUYCHOUMA, jiesuanwait.needwait + 30)
                end
                tex.setdeskdefaultchouma(playerinfo, deskno)
				net_sendbuychouma(playerinfo, deskno, jiesuanwait.needwait + 30);
			else
				--վ�𲢼����ս
				doStandUpAndWatch(playerinfo,0);
				net_sendbuychouma(playerinfo, deskno);
				--DoUserExitWatch(playerinfo)
				--net_kickuser(playerinfo)
				OnSendUserAutoJoinError(playerinfo, 0, deskinfo.at_least_gold)  --����һ�´����ķ�������ʧ��Э��
			end
		end
		if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then
			--��ʾ��ұ���̭��
			if playerinfo.chouma < deskinfo.largebet then
                --TraceError(format("site[%d] �ĳ���[%d]�����ä[%d]��,��̭!", player.siteno, playerinfo.chouma, deskinfo.largebet))
				table.insert(sitelist, player.siteno)
			end
		end

		--������ȡ״̬
		site_state = hall.desk.get_site_state(deskno, player.siteno)
		if(site_state ~= NULL_STATE and 
		   site_state ~= SITE_STATE.NOTREADY and 
		   site_state ~= SITE_STATE.READYWAIT and
		   site_state ~= SITE_STATE.BUYCHOUMA and
		   site_state ~= SITE_STATE.LEAVE) then
			hall.desk.set_site_state(deskno, player.siteno, SITE_STATE.NOTREADY)
		end
	end

	if((deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) and #sitelist > 0) then
		--���ͱ���̭��Ϣ
		set_lost_or_prize(deskno, sitelist)
	end
    if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then
		--ֻʣ��һ����ң���Ȼ�ǵ�һ��
        if(deskinfo.playercount == 1 and deskdata.rounddata.roundcount > 0) then
            local thefirst = 0
            for k_site, v in pairs(sitewininfo) do
                if(v.wingold > 0) then
                    thefirst = k_site
                    break
                end
			end
			--���ͱ��ý���Ϣ
            set_lost_or_prize(deskno, {thefirst})
        end
	end

	OnGameOver(deskno, false, false)
	--�㲥����״̬�ı�
	net_broadcast_deskinfo(deskno)
    --TraceError("jiesuan() ��ɽ��㿩~")
	if (tex_buf_lib) then
		xpcall( function() tex_buf_lib.on_after_gameover(deskno) end, throw)
    end
end

function save_new_user_process(userinfo, process)
    userinfo.gotwelcome = process
    --��¼�����ݿ�
    dblib.cache_set(gamepkg.table, {integral = userinfo.gotwelcome}, "userid", userinfo.userId)
end

function new_user_process(userinfo,wingold)
    --1.�ж��ǲ�������
    --2.�ж��ǲ��ǽ�����ĵ�һ��

    if(userinfo==nil)then return end
    if(userinfo.gotwelcome==4)then return end
    --todo�����ж�
    --userinfo.reg
    local wingold_tips=0
    if(wingold>0)then wingold_tips=1 end
    --���ָ�����200��������Ϣ���ͻ���
    --usermgr.addgold(userinfo.userId, 200, 0, g_GoldType.new_user_gold, -1, 1);
    --�趨����˲�����������
    save_new_user_process(userinfo, 4)

    --[[
    netlib.send(
            function(buf)
                buf:writeString("GREENGOLD")
                buf:writeByte(wingold_tips)
            end,userinfo.ip,userinfo.port)
    --]]
end

--�ɷ���������
function dispatch_quest_data_jiesuan(deskno, sitewininfoex)
    --��ʼ������ο�����.
    local gameeventdata = {}
    
    local deskdata = deskmgr.getdeskdata(deskno)
    --��¼Ӯ�Ҳο�����
    for siteno, wininfo in pairs(sitewininfoex) do
        local sitedata = deskmgr.getsitedata(deskno, siteno)
        local userinfo = deskmgr.getsiteuser(deskno, siteno)
        local paixing = getpokepaixin(sitedata.pokeweight)
        if userinfo then 	
            --սʤ�˶�����
            local wincount = 0
            if wininfo.wingold > 0 then
                for k, v in pairs(sitewininfoex) do
                    local sub_sitedata = deskmgr.getsitedata(deskno, k)
                    if v.wingold == 0 or sub_sitedata.pokeweight < sitedata.pokeweight then wincount = wincount + 1 end
                end
            end
    
            --���˱���
            local mul_count = 0
            local myfrienfsnum = 0--����ҵĺ�������
            for k, v in pairs(sitewininfoex) do
                local sub_sitedata = deskmgr.getsitedata(deskno, k)
                if sub_sitedata.islose == 0 then mul_count = mul_count + 1 end
    
                local siteuserinfo = deskmgr.getsiteuser(deskno,k)
                if siteuserinfo and userinfo.friends and userinfo.friends[tonumber(siteuserinfo.userId)] then
                    myfrienfsnum = myfrienfsnum + 1
                end
            end
    
            --------------------------���ѳɾ�---------------------------
            if myfrienfsnum >= 1 then
                achievelib.updateuserachieveinfo(userinfo,1017);--һ����Ϸ
    
                achievelib.updateuserachieveinfo(userinfo,2015,0);--֪��
                
                achievelib.updateuserachieveinfo(userinfo,3009,0);--����
    
                if myfrienfsnum >= 4 then
                    achievelib.updateuserachieveinfo(userinfo,2016);--ͬѧ��
    
                    achievelib.updateuserachieveinfo(userinfo,2023);--һ���پ�
    
                    achievelib.updateuserachieveinfo(userinfo,3010);--�ٿ�����
                end
            else
                achievelib.updateuserachieveinfo(userinfo,2015,1);--֪��
    
                achievelib.updateuserachieveinfo(userinfo,3009,1);--����
            end
            -------------------------------------------------------------
    
            --����A
            local has_heitaoA = 0
            for k, v in pairs(sitedata.pokes) do
                if v == 40 then has_heitaoA = 1 end
            end
    
            --TraceError("wininfo:" .. tostringex(wininfo))
            local iswin = 0
            if wininfo.win_real_gold > 0 then
            	iswin = 1
            end
            table.insert(gameeventdata, 
            {
                userid 	= userinfo.userId, 
                iswin 	= iswin,
                wingold = wininfo.win_real_gold,
                smallbet = desklist[deskno].smallbet,
                deskno = deskno,
                data	=
                {
                    [tex.gameref.REF_GOLD]				= wininfo.win_real_gold,
                    [tex.gameref.REF_EXP]				= wininfo.win_real_gold,
                    [tex.gameref.REF_PLAY]				= 1,
                    [tex.gameref.REF_WIN]  				= wininfo.wingold > 0 and 1 or 0,
                    [tex.gameref.REF_ALLIN]  			= sitedata.isallin,
                    [tex.gameref.REF_ZHUANG]  			= deskdata.zhuangsite == siteno and 1 or 0,
    
                    [tex.gameref.REF_DUIZI]  			= paixing == 2 and 1 or 0,
                    [tex.gameref.REF_HULU]  			= paixing == 7 and 1 or 0,
                    [tex.gameref.REF_TONGHUA]  			= paixing == 6 and 1 or 0,
                    [tex.gameref.REF_SHUNZI]  			= paixing == 5 and 1 or 0,
                    [tex.gameref.REF_SANTIAO]  			= paixing == 4 and 1 or 0,
                    [tex.gameref.REF_LIANGDUI]  		= paixing == 3 and 1 or 0,
                    [tex.gameref.REF_DANZHANG]  		= paixing == 1 and 1 or 0,
                    [tex.gameref.REF_HJTONGHUASHUN]  	= paixing == 10 and 1 or 0,
                    [tex.gameref.REF_TONGHUASHUN]  		= paixing == 9 and 1 or 0,
                    [tex.gameref.REF_BOMB]  			= paixing == 8 and 1 or 0,
    
                    [tex.gameref.REF_SANTIAO_FAIED]  	= wininfo.wingold == 0 and paixing >=4  and 1 or 0,
                    [tex.gameref.REF_SHUNZI_FAIED]  	= wininfo.wingold == 0 and paixing >=5  and 1 or 0,
                    
                    [tex.gameref.REF_WIN_COUNT]  		= wincount,
                    [tex.gameref.REF_HEITAOA]  			= has_heitaoA,
                    [tex.gameref.REF_GOLD2000]  		= wininfo.win_real_gold >= 2000 and 1 or 0,
                }
            })
            
            ------------------------�ɷ��ɾͲο�����---------------------
            if wininfo.wingold > 0 then
                ------------------------ͭ�ɾ�----------------------------------------
                achievelib.updateuserachieveinfo(userinfo,1002);--ͨͨ�н�
    
                achievelib.updateuserachieveinfo(userinfo,1016,0);--����ʤ
    
                if wininfo.win_real_gold >= desklist[deskno].largebet * 100 then
                    achievelib.updateuserachieveinfo(userinfo,1003);--�˿˺���
                end
    
                if wininfo.win_real_gold >= 5000 then
                    achievelib.updateuserachieveinfo(userinfo,1010);--Ӯ��ǧ
                end
    
                if wininfo.win_real_gold >= 20000 then
                    achievelib.updateuserachieveinfo(userinfo,1015);--Ӯ����
                end
                
                if getpokechar(sitedata.pokes) == "AK" then
                    achievelib.updateuserachieveinfo(userinfo,1009);--�ϻ�ͷ
                elseif getpokechar(sitedata.pokes) == "AJ" then
                    achievelib.updateuserachieveinfo(userinfo,1013);--�ڽܿ�
                elseif getpokechar(sitedata.pokes) == "QX" then
                    achievelib.updateuserachieveinfo(userinfo,1014);--������
                elseif getpokechar(sitedata.pokes) == "88" then
                    achievelib.updateuserachieveinfo(userinfo,1018);--һ·��
                end
    
                if sitedata.isallin == 1 then
                    achievelib.updateuserachieveinfo(userinfo,1012);--ȫ��ȫӮ
                end
                
                ---------------------------���ɾ�-------------------------------
                if wininfo.win_real_gold >= desklist[deskno].largebet * 100 then
                    achievelib.updateuserachieveinfo(userinfo,2008);--�˿˸���
                end
    
                if paixing == 4 then
                    achievelib.updateuserachieveinfo(userinfo,2001);--����
                elseif paixing == 5 then
                    achievelib.updateuserachieveinfo(userinfo,2002);--˳��
    
                    achievelib.updateuserachieveinfo(userinfo,2024);--�Ұ�˳��
                elseif paixing == 6 then
                    achievelib.updateuserachieveinfo(userinfo,2007);--ͬ��
                elseif paixing == 7 then
                    achievelib.updateuserachieveinfo(userinfo,2006);--��«
                end
    
                if getpokechar(sitedata.pokes) == "J5" then
                    achievelib.updateuserachieveinfo(userinfo,2004);--�ܿ�������
                elseif getpokechar(sitedata.pokes) == "JJ" then
                    achievelib.updateuserachieveinfo(userinfo,2013);--һ���㹳
                elseif getpokechar(sitedata.pokes) == "AA" then
                    achievelib.updateuserachieveinfo(userinfo,2014);--һ�ɳ���
                elseif getpokechar(sitedata.pokes) == "KK" then
                    achievelib.updateuserachieveinfo(userinfo,2019);--ţ������
                elseif getpokechar(sitedata.pokes) == "K9" then
                    achievelib.updateuserachieveinfo(userinfo,2021);--�Ϲ�����
                end
    
                achievelib.updateuserachieveinfo(userinfo,2011,0);--����ʤ
    
                achievelib.updateuserachieveinfo(userinfo,2022,0);--5��ʤ
            
                if wininfo.win_real_gold >= 50000 then
                    achievelib.updateuserachieveinfo(userinfo,2012);--Ӯ����
                end
    
                if wininfo.win_real_gold >= 250000 then
                    achievelib.updateuserachieveinfo(userinfo,2020);--Ӯ25��
                end
                --------------------------��ɾ�-----------------------------
                if wininfo.win_real_gold >= desklist[deskno].largebet * 100 then
                    achievelib.updateuserachieveinfo(userinfo,3018);--���ֱ�Ӯ
    
                    achievelib.updateuserachieveinfo(userinfo,3027);--Ӯ�Ҿ�����
                end
    
                if paixing == 10 then
                    achievelib.updateuserachieveinfo(userinfo,3005);--�ʼ�ͬ��˳
                elseif paixing == 9 then
                    achievelib.updateuserachieveinfo(userinfo,3003);--ͬ��˳
                elseif paixing == 8 then
                    achievelib.updateuserachieveinfo(userinfo,3001);--����
                elseif paixing == 7 then
                    achievelib.updateuserachieveinfo(userinfo,3015);--�Ұ���«
                    achievelib.updateuserachieveinfo(userinfo,3023);--��«������
                    achievelib.updateuserachieveinfo(userinfo,3025);--��«����ɽ
                elseif paixing == 6 then
                    achievelib.updateuserachieveinfo(userinfo,3014);--�Ұ�ͬ��
                    achievelib.updateuserachieveinfo(userinfo,3021);--ͬ��������
                    achievelib.updateuserachieveinfo(userinfo,3022);--ͬ������ɽ
                elseif paixing == 5 then
                    achievelib.updateuserachieveinfo(userinfo,3013);--˳��������
                    achievelib.updateuserachieveinfo(userinfo,3020);--˳�Ӷ���ɽ
                elseif paixing == 4 then
                    achievelib.updateuserachieveinfo(userinfo,3011);--�Ұ�����
                    achievelib.updateuserachieveinfo(userinfo,3012);--����������
                    achievelib.updateuserachieveinfo(userinfo,3024);--��������ɽ
                end
    
                if getpokechar(sitedata.pokes) == "72" then 
                    achievelib.updateuserachieveinfo(userinfo,3002);--����ת
                elseif getpokechar(sitedata.pokes) == "X2" then 
                    achievelib.updateuserachieveinfo(userinfo,3007);--�ھ�����
                end
    
                achievelib.updateuserachieveinfo(userinfo,3016,0);--10��ʤ
    
                achievelib.updateuserachieveinfo(userinfo,3026,0);--15��ʤ
    
                if wininfo.win_real_gold >= 500000 then
                    achievelib.updateuserachieveinfo(userinfo,3017);--Ӯ50��
                end
    
                if wininfo.win_real_gold >= 1000000 then
                    achievelib.updateuserachieveinfo(userinfo,3028);--Ӯ100��
				end

				---------------------------������Ϸ�¼�------------------
				if(dhomelib) then
					local share_data = {};
					share_data.smallbet = desklist[deskno].smallbet 
					share_data.largebet = desklist[deskno].largebet 
					share_data.winchouma = wininfo.win_real_gold 
					share_data.paixing = paixing
					--��Ӯ����


					if wininfo.win_real_gold >= desklist[deskno].largebet * 200 and paixing>0 then

						xpcall(function() dhomelib.update_share_info(userinfo, 4001, share_data) end, throw)
					end
				end
            else
                ----------------------------ͭ�ɾ�-----------------------------
                achievelib.updateuserachieveinfo(userinfo,1016,1);--����ʤ
    
                if paixing >= 5 and sitedata.islose == 0 then
                    achievelib.updateuserachieveinfo(userinfo,2003);--������
                end
    
                ---------------------------���ɾ�-------------------------------
                achievelib.updateuserachieveinfo(userinfo,2011,1);--����ʤ
    
                achievelib.updateuserachieveinfo(userinfo,2022,1);--5��ʤ
    
                ---------------------------��ɾ�-------------------------------
                achievelib.updateuserachieveinfo(userinfo,3016,1);--10��ʤ
    
                achievelib.updateuserachieveinfo(userinfo,3026,1);--15��ʤ
            end
            if (tex_dailytask_lib) then
                xpcall(function() tex_dailytask_lib.on_game_over(userinfo, paixing,deskno,wininfo.wingold) end, throw)
            end
            -------------------------------------------------------------			
        end
    end
    --gameeventdata ������bug���û�������һ�ֺͱ������û����ˣ�����ԭ�����
    local gameeventdata_ex = {}
    --������;�˳����û�����game_event��
    for siteno, sitedata in pairs(deskmgr.getallsitedata(deskno)) do
        local split_info = split(sitedata.logsql, ",")
        local split_user_id = tonumber(split_info[1])
        local split_add_gold = tonumber(split_info[2])
        local split_iswin = 0
        if (split_add_gold > 0) then
            split_iswin = 1
        end
        if (split_add_gold ~= 0) then
            table.insert(gameeventdata_ex, 
            {
                userid 	= split_user_id, 
                iswin 	= split_iswin,
                wingold = split_add_gold,
                smallbet = desklist[deskno].smallbet,
                deskno = deskno,
            })
        end
    end
    eventmgr:dispatchEvent(Event("game_event_ex", gameeventdata_ex));
	--�ɷ��ο�����
	eventmgr:dispatchEvent(Event("game_event", gameeventdata));
end

function getpokechar(pokelist)
	local pokestr = ""
	table.sort(pokelist,function(a,b) return tex.pokenum[a] > tex.pokenum[b] end)

	for k,v in pairs(pokelist) do
		pokestr = pokestr .. tex.pokechar[v]
	end

	return pokestr
end
--��ȡ����:10(�ʼ�ͬ��˳)��9(ͬ��˳)��8(����)��7(��«)��6(ͬ��)��5(˳��)��4(����)��3(����)��2(һ��)��1(����)
function getpokepaixin(pokeweight)
	if tonumber(pokeweight) == 90001576012 then
		return 10
	else
		return math.floor(pokeweight / (10 ^ 10))
	end
end

--�Ŀͻ�����ʾ�Ľ��
function useraddviewgold(userinfo, gold, notifyclient)
	local sitedata = deskmgr.getsitedata(userinfo.desk, userinfo.site)
	sitedata.gold = sitedata.gold + gold
	ASSERT(sitedata.gold >= 0)
	--֪ͨ�ͻ��˵������û�
	if notifyclient and userinfo.desk then
		--net_broadcastdesk_goldchange(userinfo.desk, userinfo.site, sitedata.gold)
		net_broadcastdesk_goldchange(userinfo)
	end
end

------------------------------------------------------------------------------------------------------------------------------------
dofile("games/tex/tex.net.lua")
------------------------------------------------------------------------------------------------------------------------------------


--����������У���������������ȡ��������Э�����������
function gameonrecv(cmd, recvbuf)
	--cmd = netbuf.readString(inbuf)
	trace("game onrecv "..cmd)
    gamedispatch(cmd, recvbuf)
end

--������������ݣ�������뵽�������
function gameonsend(sCommand, sendbuf)
    trace("game onsend ".. sCommand)
    gamedispatch(sCommand, sendbuf)
end

function gamedispatch(sCommand, buf)
	local f = cmdGameHandler[sCommand]
	if f ~= nil then        
        local ret, errmsg = xpcall(function() return f(buf) end, throw)
		if (ret) then
			trace("**"..sCommand.. " call command ok ")
		else
			trace("** call ��Ϸ command faild ".. sCommand)
		end
	else
		trace("** not found ��Ϸ command ->".. sCommand)
	end
end

-------------------------------------------------------------------------------------------------------

tex.ontimecheck = function()
	if timelib.time % 10 ~= 0 then return end
	for deskno = 1, #desklist do
		local deskinfo = desklist[deskno]
		local deslaytime = 180
        --����������Сä������ʼ��ÿ3���ӷ���һ��
        if(deskinfo and (deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament)) then
            local deskdata = deskmgr.getdeskdata(deskno);
            if deskdata.rounddata.roundcount > 0 then
                deskdata.rounddata.timecheck = deskdata.rounddata.timecheck + 10
                if(deskdata.rounddata.timecheck >= deslaytime) then
                    deskdata.rounddata.timecheck = 0
                    --TODO:������Ҫ֪ͨ�ͻ�����?
                    deskinfo.smallbet = deskinfo.smallbet * 2
                    deskinfo.largebet = deskinfo.largebet * 2
					net_broadcast_deskinfo(deskno)
					local sendmsg = ""
					sendmsg = format("������ȥ%d���ӣ��Զ�����С��äΪ%d/%d����Ϸ����ʹ������ֵ", math.floor(deslaytime / 60), deskinfo.smallbet, deskinfo.largebet)
                end
			else
                deskdata.rounddata.timecheck = 0
                deskinfo.smallbet = deskinfo.staticsmallbet
                deskinfo.largebet = deskinfo.staticlargebet
            end
		end
		if(deskinfo and deskinfo.playercount <= 0) then
			local deskdata = deskmgr.getdeskdata(deskno)
			deskdata.rounddata.roundcount = 0
			deskinfo.betgold = 0
			deskinfo.usergold = 0
		end
		--tex.getGameStart(deskno) == true
		if(deskinfo and deskinfo.state_list ~= nil and #deskinfo.state_list ~= 0 and 
		   deskmgr.get_game_state(deskno) ~= gameflag.notstart) then
			   --�쳣����ʼ
			   local all_wait = true
			   local userinfo = nil
			   for i = 1, room.cfg.DeskSiteCount do	
 					if  userlist[hall.desk.get_user(deskno, i)] ~= nil then
						userinfo = userlist[hall.desk.get_user(deskno, i)]
					end
					if  hall.desk.get_site_state(deskno, i) ~= SITE_STATE.WAIT and
						hall.desk.get_site_state(deskno, i) ~= SITE_STATE.READYWAIT and
						hall.desk.get_site_state(deskno, i) ~= SITE_STATE.LEAVE and 
						hall.desk.get_site_state(deskno, i) ~= NULL_STATE then
						all_wait = false
						break
					end	
				end
				if all_wait == true then --�����˶����ȶ�״̬
					TraceError("��" .. tostring(deskno) .. "��������")					
					TraceError(deskinfo.state_list)
					deskinfo.state_list = {}
					forceGameOver(userinfo)
				end
		end
	end
end

--ǿ�ƽ����ƾ�,�����ĸ��˶��й�֮���
function forceGameOver(userinfo)
    if not userinfo then return end
    TraceError("ǿ�ƽ����ƾ�,�����ĸ��˶��й�֮���")
	local deskno = userinfo.desk
	local deskinfo = desklist[deskno]

	local deskdata = deskmgr.getdeskdata(deskno)
	deskdata.pools = {}
	--������������roundcount=0������²��ܽ���
	if(deskinfo.desktype == g_DeskType.tournament or deskinfo.desktype == g_DeskType.channel_tournament) then
		deskinfo.betgold = 0
		deskinfo.usergold = 0
		deskdata.rounddata.roundcount = 0
	end
	--�����Զ�����,�����ƾְ�
	for i = 1, room.cfg.DeskSiteCount do
		local user = userlist[hall.desk.get_user(userinfo.desk or 0, i) or ""]
		if user then 
			letusergiveup(user)
			doUserStandup(user.key, true)
			DoUserExitWatch(user)
			net_kickuser(user)
		end
    end
    tex.OnAbortGame(userinfo.key)
    eventmgr:dispatchEvent(Event("on_force_game_over", {desk_no = deskno}));
end

--���������ĳ���ӵ�Ĭ�Ϲ��������
tex.setdeskdefaultchouma = function(userinfo, deskno)
	local groupsdata = userinfo.groupsdata or {}
	if not groupsdata[groupinfo.groupid] then 
		groupsdata[groupinfo.groupid] ={} 
	end

	local deskchouma = groupsdata[groupinfo.groupid][deskno] or {}
    local deskinfo = desklist[deskno]
    local userchouma = userinfo.chouma or 0
    userinfo.chouma = 0
	--��ֵ
	deskchouma.chouma = userchouma
	deskchouma.savetime = os.time()
	groupsdata[groupinfo.groupid][deskno] = deskchouma
	userinfo.groupsdata = groupsdata

    --������������ʷ������Ӯ��¼
    local extra_info = userinfo.extra_info
    local currtime = deskchouma.savetime
    local smallbet = deskinfo.smallbet

    if(extra_info["F09"][smallbet] == nil or type(extra_info["F09"][smallbet]) ~= "table")then 
        extra_info["F09"][smallbet] = {gametime = 0, bringgold = 0, bringout = 0, wingold = 0}
    else
        --��ס���վ��ʱӮ��Ǯ
        local bringgold = extra_info["F09"][smallbet]["bringgold"] or 0
        local wingold = userchouma - bringgold
        --TraceError(format("bringgold[%d], userchouma[%d], wingold[%d]",bringgold, userchouma, wingold))
        if(wingold < 0)then wingold = 0 end
        extra_info["F09"][smallbet]["wingold"] = wingold
        extra_info["F09"][smallbet]["bringout"] = userchouma
    end
    userinfo.extra_info = extra_info
	save_extrainfo_to_db(userinfo)
end

--��ȡ�����ĳ���ӵ�Ĭ�Ϲ��������
tex.getdeskdefaultchouma = function(userinfo, deskno, timeout)
	local deskinfo = desklist[deskno]
	if not deskinfo then return {} end

	local extra_info = userinfo.extra_info
	local smallbet = deskinfo.smallbet
	local mingold = deskinfo.at_least_gold
	local maxgold = deskinfo.at_most_gold
	local usergold = get_canuse_gold(userinfo, 1)
	local retarr = {}
	retarr.defaultchouma = -1
	retarr.halfhour = 0  --��Сʱǰ��������

	local groupsdata = userinfo.groupsdata or {}
	if not groupsdata[groupinfo.groupid] then 
		groupsdata[groupinfo.groupid] ={} 
	end

	local deskchouma = groupsdata[groupinfo.groupid][deskno] or {}

	--����ʹ��֮ǰ�������ӵ���ֵ
--[[
    if(deskchouma.savetime and os.time() - deskchouma.savetime < 1800) then
		--TIMEOUT������Ϸ������˻�ûվ���������
		if(not timeout or timeout == 0) then
			retarr.halfhour = 1
			retarr.defaultchouma = deskchouma.chouma or maxgold
		end
	end
]]--

	--���ж��Ƿ����������ʵ�������Ӯ��Ǯ
    --[[
	if(type(extra_info["F09"][smallbet]) == "table")then
		local gametime = extra_info["F09"][smallbet]["gametime"] or 0
		local interval = extra_info["F09"].interval or 1800
		local wingold = extra_info["F09"][smallbet]["wingold"] or 0
        local bringout = extra_info["F09"][smallbet]["bringout"] or 0
		--��������:Ӯ��Ǯ��ʱ�䲻������Сʱ�����ϻ����㹻��Ǯ����(��ʯ��Ǯ����ʱ������)
		if(wingold > 0 and os.time() - gametime < interval and usergold >= mingold) then
		    retarr.halfhour = 2
            retarr.defaultchouma = bringout
		    mingold = mingold + wingold
            if(retarr.defaultchouma > mingold) then mingold = retarr.defaultchouma end
            if(mingold > usergold) then mingold = usergold end
		    if(mingold > maxgold) then maxgold = mingold end
        end
        --TraceError(format("ID:%d, wingold:%d, mingold:%d, maxgold:%d, deskchouma:%d", userinfo.userId, wingold, mingold, maxgold, deskchouma.chouma or 0))
	end
    ]]--
	--Ĭ�Ϲ���
	if(retarr.defaultchouma < mingold or retarr.defaultchouma > maxgold) then
		--1.��������ϵĳ��볬���ø�����������Ƶ���������Ĭ��Ϊ�����ʾ
		if usergold >= maxgold * 2 then
			retarr.defaultchouma = maxgold
		--2.��������ϵĳ��������С���Ƶ�������С��������Ƶ���������Ĭ����ʾ���ϵĳ���/2
		elseif usergold > mingold * 2 and usergold < maxgold * 2 then
			retarr.defaultchouma = math.floor(usergold / 2)
		--3.��������ϵĳ��������С��ʾ��С����С���Ƶ���������Ĭ����ʾ��С���������
		else
			retarr.defaultchouma = mingold
		end
	end

	--�Ϸ��Լ��
	if(retarr.defaultchouma < mingold) then
		retarr.defaultchouma = mingold
	end
	if(retarr.defaultchouma > maxgold) then
		retarr.defaultchouma = maxgold
	end
	if(retarr.defaultchouma > usergold) then retarr.defaultchouma = usergold end
    
	if(retarr.defaultchouma < 0) then retarr.defaultchouma = 0 end
    retarr.maxgold = maxgold
    retarr.mingold = mingold

	return retarr
end

--�����˶����ߣ�ֱ�ӽ����ƾ�
tex.OnAbortGame = function(userKey)
    local userinfo = userlist[userKey]
    local deskno = userinfo.desk
	if (deskno == nil) then
		TraceError("��Ϸǿ�ƽ�����Ϊɶ����Ϊ����"..debug.traceback())
		return
	end
    deskmgr.set_game_state(deskno, gameflag.notstart)  --ֱ��תΪδ��ʼ״̬
	
    --��ʼ�����Ӻ���λ������
    deskmgr.initdeskdata(deskno)
    hall.desk.set_site_state(deskno, NULL_STATE)
    for j = 1, room.cfg.DeskSiteCount do
        deskmgr.initsitedata(deskno, j)
	end

	for i = 1, room.cfg.DeskSiteCount do
		local userKey = hall.desk.get_user(deskno, i)
		local siteUserInfo = userlist[userKey]
        if (siteUserInfo ~= nil) then
			doUserStandup(userKey, false)
			DoKickUserOnNotGame(siteUserInfo.key, false)
		end
	end

	--�㲥����״̬�ı�
	net_broadcast_deskinfo(deskno)
    --OnGameOver(deskno, false) 
end

tex.OnUserReLogin = function(userinfo)
    TraceError('OnUserReLogin');
    --ȡ���Զ��йܳ���״̬
    userinfo.gamerobot = false

    --������״̬���ͻ��ˣ�֪ͨ���µ�¼�Ŀͻ��˵�ǰ��������Ϣ
    tex.arg.reloginuserinfo = userinfo

    --�����û�״̬Ϊready״̬
    hall.desk.set_site_start(userinfo.desk, userinfo.site, startflag.ready)

    --ͬ���û�״̬
    --usermgr.setUserState(userinfo,deskmgr.get_game_state(userinfo.desk),true)

    --���������˵�ʣ����
    --net_send_pokes_and_playerinfo(userinfo)
    net_send_resoredesk(userinfo);

    --֪ͨ�����ͻ������û��Ѿ��ɹ����ٴε�¼����Ҫ����ͷ��
    --broadcast_lib.borcast_desk_event_ex_old('NTGR', userinfo.desk)
end

--�õ��û���Ϸ��Ϣ
tex.OnBeforeUserLogin = function(userinfo, data, alldata)
    local userdata = deskmgr.getuserdata(userinfo)

	local giftstr = data["icon_info"] or ""	--����ͼ��

	userdata.giftinfo, userdata.using_gift_item = gift_str2tbl(userinfo, giftstr)		--using_gift_itemΪnil��ʾδװ������    
    eventmgr:dispatchEvent(Event("already_init_gift", {user_id=userinfo.userId}));

	local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
	if(userinfo.gift_today ~= sys_today) then --���ڲ���
		userinfo.gift_today = sys_today	--���½�������
		userinfo.buygiftgold = 0	--���칺���
		userinfo.salegiftgold = 0	--�������۶�
        update_giftinfo_db(userinfo)
	end
	userinfo.winningstreak = {count = 0, begintime = os.date("%Y-%m-%d %X", os.time())} --��ʤ��¼

	userinfo.upgradetime = data["upgradetime"] or os.time()

	--ǿ��֮��������Ϣ
	--F00:�����[��r�g,F01:����Aȡ�[���,F02:�������,F03:���^�֔�,F04:�A�^�֔�,
	--F05:��ߓ����[���,F06:���є���,F07:����ݔ�A,��þ���,F08:Ӯ���ĵ�����������
    --F09:�ڸ������ʷ������Ӯ��¼
	local extra_info = nil
	local sz_extra_info = data["extra_info"]
	--memchched������˫������,����ȥ����Ȼ�޷���ԭ
	if(string.sub(data["extra_info"], 1, 1) == "\"") then
		sz_extra_info = string.sub(data["extra_info"], 2, string.len(data["extra_info"]) - 1)
	end
	--�滻��\
	sz_extra_info = string.gsub (sz_extra_info, "\\", "")
	extra_info = table.loadstring(sz_extra_info) or {}

	--�����[��r�g(���������ֵ������)
	extra_info["F00"] = data["reg_time"]
	--����Aȡ�[���
	if(extra_info["F01"] == nil) then extra_info["F01"] = 0 end
	--�������
	if(extra_info["F02"] == nil) then
		extra_info["F02"] = {pokeweight = 0, pokes5 = {}}
	end
	--���^�֔�
	if(extra_info["F03"] == nil) then extra_info["F03"] = 0 end
	--�A�^�֔�
	if(extra_info["F04"] == nil) then extra_info["F04"] = 0 end
	--��ߓ����[���
	if(extra_info["F05"] == nil) then extra_info["F05"] = 0 end
	--���є���
	if(extra_info["F06"] == nil) then extra_info["F06"] = 0 end
	--����ݔ�A
	if(extra_info["F07"] == nil) then extra_info["F07"] = 0 end
	--Ӯ��������������
	if(extra_info["F08"] == nil) then extra_info["F08"] = 0 end
    --�ڸ������ʷ������Ӯ��¼
	if(extra_info["F09"] == nil) then extra_info["F09"] = {last_time = 0, interval = 1800} end

	userinfo.extra_info = extra_info

	local dbtoday = data["today"] 	--���ݿ�Ľ�������
	userinfo.dbtoday = dbtoday
	local todayexp = data["todayexp"] or 0	--�����þ���
	userinfo.gameInfo.todayexp = todayexp

	--�ж�����(���ǽ��վ͵�����)
	if(sys_today ~= dbtoday) then --���ڲ���
        userinfo.dbtoday = sys_today
		dblib.cache_set(gamepkg.table, {today = sys_today}, "userid", userinfo.userId)
        userinfo.gameInfo.todayexp = 0
		dblib.cache_set(gamepkg.table, {todayexp = 0}, "userid", userinfo.userId)

		userinfo.extra_info["F07"] = 0
		save_extrainfo_to_db(userinfo)
    end

    
    --���������Ϸ�в��Ҳ��Ǳ�����������ǿ���˳���Ϸ
    if(userinfo.desk and userinfo.site)then
        local deskinfo = desklist[userinfo.desk]
        --[[
        if(deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament)then
            douserforceout(userinfo)
            --��Ϊ�����ص�¼
            userinfo.nRet = 1
        end
        --]]
    end    
end

--���������
deskmgr = 
{
	--�õ���Ϸ״̬
	get_game_state = function(deskno)
		ASSERT(deskno)
		--trace("getgamestate(" .. deskno .. ")")
		local deskdata = deskmgr.getdeskdata(deskno);
		if not deskdata then
			return gameflag.notstart
		end
		return deskdata.state;
	end,
	
	--������Ϸ״̬
	set_game_state = function(deskno, gamestate)
		ASSERT(deskno)
		ASSERT(gamestate)
		local deskdata = deskmgr.getdeskdata(deskno);
		deskdata.state = gamestate;
	end,
	--��ȡ��������
	getdeskdata = function(deskno)
		return desklist[deskno].gamedata
	end,

	--��ȡ��λ����
	getsitedata = function(deskno, siteno)
		if desklist[deskno] and desklist[deskno].site[siteno] then
			return desklist[deskno].site[siteno].gamedata
		else
			TraceError(format("��Ч��λ��deskno[%d], siteno[%d]", deskno, siteno))
			return {}
		end
	end,
	--��ȡ�������
	getuserdata = function(userinfo)
		return userinfo.gameInfo
	end,
	--��ȡ��λuserinfo
	getsiteuser = function(deskno, siteno)
		return userlist[hall.desk.get_user(deskno, siteno) or ""]
	end,

	--��ʼ����������
	initdeskdata = function(deskno)
		trace("initdeskdata()")
		--������ƾ�û�й�ϵû�й�ϵ,���˿������Ҫ
		local org_kickinfo = desklist[deskno].gamedata.kickinfo
		local org_kickedlist = desklist[deskno].gamedata.kickedlist
		desklist[deskno].gamedata = tex.init_desk_info()
		if (org_kickinfo ~= nil) then
			desklist[deskno].gamedata.kickinfo = org_kickinfo	
		end
		if (org_kickedlist ~= nil) then
			desklist[deskno].gamedata.kickedlist = org_kickedlist	
		end
		for i = 1, room.cfg.DeskSiteCount do
			desklist[deskno].gamedata.rounddata.sitecount[i] = 0
		end
	end,

	--��ʼ����λ����
	initsitedata = function(deskno, siteno)
		desklist[deskno].site[siteno].gamedata = tex.init_site_info()
	end,

	--��ȡ������λ���б�, ����valueΪ{siteno, userinfo}��table, ˳����λ��, [*����*]�������û�
	getplayers = function(deskno)
		local ret = {}
		for i = 1, room.cfg.DeskSiteCount do
			local userinfo = userlist[hall.desk.get_user(deskno, i)]
			if userinfo then
				table.insert(ret, newStrongTable({ siteno=i, userinfo=userinfo }))
			end
		end
		return ret
	end,

	--��ȡ���е���λ��Ϣ����������λ
	getallsitedata = function(deskno)
		local ret = {}
		for i = 1, room.cfg.DeskSiteCount do
			local siteinfo = deskmgr.getsitedata(deskno, i)
			if siteinfo then
				ret[i] = siteinfo
			end
		end
		return ret
	end,

	--��ȡ������λ���б�, ����valueΪ{siteno, userinfo}��table, ˳����λ��, [*������*]�������û�
	getplayingplayers = function(deskno)
		local ret = {}
		local players = deskmgr.getplayers(deskno)
		for i = 1, #players do
			local sitedata = deskmgr.getsitedata(deskno, players[i].siteno)
			if(sitedata.isinround == 1 and sitedata.islose == 0) then
				table.insert(ret, players[i])
			end
		end
		return ret
	end,

	--��ȡǰһ�����û�����λ��(���������򷵻ؿ�), �������������û�
	getprevsite = function(deskno, siteno)
		ASSERT(siteno and siteno > 0 and siteno <= room.cfg.DeskSiteCount, "getnextsite��ȡsiteno�Ƿ�"..tostring(siteno))
		local currsite = siteno
		local userinfo, sitedata
		repeat
			if currsite == 1 then 
				currsite = room.cfg.DeskSiteCount 
			else
				currsite = currsite - 1
			end
			if currsite == siteno then
				return nil
			end
			userinfo = userlist[hall.desk.get_user(deskno, currsite)]
			sitedata = deskmgr.getsitedata(deskno, currsite) or {}
		until userinfo and sitedata.islose == 0 and sitedata.isinround == 1
		return currsite
	end,

	--��ȡ��һ���������λ��(���������򷵻ؿ�), �������������û�
	getnextsite = function(deskno, siteno)
		ASSERT(siteno and siteno > 0 and siteno <= room.cfg.DeskSiteCount, "getnextsite��ȡsiteno�Ƿ�"..tostring(siteno))
		local currsite = siteno
		local userinfo, sitedata
		repeat
			if currsite == room.cfg.DeskSiteCount then 
				currsite = 1
			else
				currsite = currsite + 1
			end
			if currsite == siteno then
				return nil
			end
			userinfo = userlist[hall.desk.get_user(deskno, currsite)]
			sitedata = deskmgr.getsitedata(deskno, currsite) or {}
		until userinfo and sitedata.islose == 0 and sitedata.isinround == 1
		return currsite
	end,
}

deskmgr = _S(deskmgr)
--[[function on_meet_event_charm(e)
    --TraceError("����ũ��ļ����¼�����")
    local time1 = os.clock() * 1000
    local touserinfo = e.data.observer
    if(not touserinfo) then return end
    local meet_userinfo = e.data.subject
    --��ʱֻ֧������λ�ϼ���
    if(not meet_userinfo.site)then return end

    net_send_charmchange(meet_userinfo, touserinfo)
    local time2 = os.clock() * 1000
    if (time2 - time1 > 50)  then
        TraceError("����ũ������¼�,ʱ�䳬��:"..(time2 - time1))
    end
end
--]]
tex.on_start_server = function()    
    --------------------����ũ��ļ����¼�����----------------------------
   -- eventmgr:removeEventListener("meet_event", on_meet_event_charm);
    --eventmgr:addEventListener("meet_event", on_meet_event_charm);
    --------------------����ũ��ļ����¼�����----------------------------	
end

-----------------------------------------------------------------------------------------------------------
---------------------------�������ݺ�������-----------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
--��λ״̬��  https://docs.google.com/Doc?id=dd4q9wgh_16dgzx9hvc
tex.init_state = function()
	hall.desk.register_site_states(newStrongTable(
	{
		NOTREADY 	= {ss_notready_offline,		ss_notready_timeout,	60},
		READYWAIT 	= {ss_readywait_offline,	NULL_FUNC, 				0},
		PANEL 		= {ss_panel_offline, 		ss_panel_timeout, 		21},
		WAIT 		= {ss_wait_offline, 		NULL_FUNC,				0},
		BUYCHOUMA 	= {ss_buychouma_offline, 	ss_buychouma_timeout,	30},
		LEAVE		= {NULL_FUNC, 				ss_leave_timeout,		180},
	}))
	hall.desk.register_site_state_change(ss_onstatechange)
end

--[[
	to wangyu
	���˿�ʵ�ִ���
	��ȡ�����ϵ��û���Ϣ��������
						deskmgr.getplayers(deskno)
	�������ݽṹ����	{{ siteno=i, userinfo=userinfo },{ siteno=i, userinfo=userinfo }...}	

--]]

--�յ�����룬�Զ�����
function onrecvautosite(buf)
    local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;

    --�жϺϷ���
    local gold = buf:readInt()
    local deskno = userinfo.desk
    local siteno = 1		--��dobuychouma�Զ�ȥ����λ
    local deskinfo = desklist[deskno]

    --ֻ������ʱ����������ƣ����Դ�buy_chouma_limit���ó�����
	local freshman_limit = 3000;
    if(userinfo.gameinfo==nil)then
        userinfo.gameinfo={}
        userinfo.gameinfo.is_auto_buy=0
        userinfo.gameinfo.is_auto_addmoney=0
    end
    --��Ϊ������Ϸʱ��������Զ�������Զ���ע���Ͳ���Ҫ���������ƣ���ֹ����Ϸʱ����
    if(userinfo.gameinfo.is_auto_buy==0 and userinfo.gameinfo.is_auto_addmoney==0)then
    	if((deskinfo.desktype == g_DeskType.normal or deskinfo.desktype==g_DeskType.channel or deskinfo.desktype==g_DeskType.channel_world) and deskinfo.smallbet == 1 and userinfo.gamescore > freshman_limit) then
            --���ֳ�����
    		local msgtype = userinfo.desk and 1 or 0 --1��ʾ����Ϸ�ﴦ���Э��,0�Ǵ���
                netlib.send(function(buf) 
                    buf:writeString("TEXXST")
                    end, userinfo.ip, userinfo.port, borcastTarget.playingOnly);
    		return -2
        end
     end
    --ͨ��������������
    if(buy_chouma_limit(userinfo)==1)then
        dobuychouma(userinfo, deskno, siteno, gold)
    end
end


--�յ��ֻ��������ж���������״̬�����٣�
function onrecv_check_net(buf)
    local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;
    --�жϺϷ���
    local str_time = buf:readString()
    netlib.send(function(buf) 
                    buf:writeString("CHECK_NET")
                    buf:writeString(str_time)
                    end, userinfo.ip, userinfo.port);
end


--�յ��ֻ���ˢ����Ļʱ�ָ�
function onrecv_mobile_refresh(buf)
	if true then return end; --���Э�鲻���ˣ���һ�յ��Ļ�����������
    local userinfo = userlist[getuserid(buf)]; 
    local user_states=0
	

    if not userinfo then  
   		user_states=1   --���µ�½
    end; 

    if not userinfo.desk or userinfo.desk <= 0 then 
    	user_states=2   --�ڴ�����������
    end;

    if(user_states==0)then --���������ڹ�ս

        hall.desk.set_site_state(userinfo.desk, userinfo.site, SITE_STATE.WAIT)
		local deskdata, sitedata = deskmgr.getdeskdata(userinfo.desk), deskmgr.getsitedata(userinfo.desk, userinfo.site)
		
		local deskpokes = deskdata.deskpokes
		local gold = sitedata.gold
		local betgold = sitedata.betgold
		local sitepokes = sitedata.pokes
		local mybean = userinfo.gamescore
		OnSendDeskInfo(userinfo, userinfo.desk)
		net_send_resoredesk(userinfo)
		--net_broadcastdesk_playerinfo(userinfo.desk)
		--ˢ�²ʳ���Ϣ
		OnSendDeskPoolsInfo(userinfo, deskdata.pools)
	    	
    	return
    end        

    --�жϺϷ���
    local str_time = buf:readString()
 	netlib.send(function(buf) 
            buf:writeString("MO_REFRESH")
            buf:writeByte(user_states or 0) 
            end, userinfo.ip, userinfo.port);
end

--������ҵ�GPS��Ϣ�����Ҹ���������������ҵ�GPS��Ϣ
function onrecv_user_gpsinfo(buf)
    local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
    
    --���»��½��û�gps��Ϣ
   	local function update_user_gps_info(userinfo)
   		local sql="insert into user_gps_info (user_id,latitude,longitude,last_login_time) value (%d,'%s','%s',now()) ON DUPLICATE KEY UPDATE latitude='%s',longitude='%s',last_login_time=now();";
   		sql=string.format(sql,userinfo.userId,userinfo.xpos,userinfo.ypos,userinfo.xpos,userinfo.ypos);
   		--TraceError("sql="..sql)
   		dblib.execute(sql);
   	end
   	
   	--�ж��Ƿ�����
   	local function is_online(user_id)
        if (usermgr.GetUserById(user_id) == nil) then
            return 0
        else
            return 1
        end
   	end
   	
   	--��������GPS�û���Ϣ
   	local function send_user_gps_info(userinfo)
 
   		local sql="select user_id,latitude,longitude,face,nick_name,gold,sex,user_gps_info.last_login_time AS last_login_time from user_gps_info LEFT JOIN users ON user_gps_info.user_id=users.id";
   		dblib.execute(sql,
	        function(dt)
	            if dt and #dt > 0 then
	                netlib.send(function(buf) 
					buf:writeString("GPSPOSI")
					buf:writeInt(#dt)
					local len=100
					if (#dt<len) then len=#dt end
                    for i = 1,len do					   
		   			    	buf:writeInt(dt[i].user_id)	
							buf:writeString(dt[i].latitude)	
			            	buf:writeString(dt[i].longitude)
						    buf:writeString(dt[i].face)
						    buf:writeString(dt[i].nick_name)							
						    buf:writeInt(dt[i].gold)
						    buf:writeInt(is_online(dt[i].user_id))
						    buf:writeInt(dt[i].sex)						    
						    buf:writeString(dt[i].last_login_time)						  
				    end
					
				 end, userinfo.ip, userinfo.port);
	            end
	       end)	
   	end
   	
   	local x_pos = buf:readString();
   	local y_pos = buf:readString();
   	local stat = buf:readByte();
   	
   	userinfo.xpos=x_pos;
   	userinfo.ypos=y_pos;
   	--�����û�GPS��Ϣ
   	update_user_gps_info(userinfo);
   	--������û����������˵�GPS��Ϣ
   	if(stat==1)then
   		send_user_gps_info(userinfo)
   	end
   	
end

--�õ���ҵ�ǰ���ó���
--[[
@param is_include_self_chouma 0:�������Լ�������õĽ��
                            1:�����Լ�������õĽ��
--]]
function get_canuse_gold(user_info, is_include_self_chouma)
	if not user_info then return 0 end
	--�õ���������ϵ�Ǯ

    local usergold = 0; 
	--�࿪
	if(duokai_lib ~= nil)then
		local parent_id = user_info.userId; 
		if(duokai_lib.is_sub_user(user_info.userId) == 1) then
			parent_id = duokai_lib.get_parent_id(user_info.userId);
		end

		local all_sub_user_arr = duokai_lib.get_all_sub_user(parent_id);
		if(all_sub_user_arr ~= nil) then
			for user_id, v in pairs(all_sub_user_arr) do
                if(is_include_self_chouma == nil or is_include_self_chouma == 0 or (is_include_self_chouma == 1 and user_id ~= user_info.userId)) then
    				local sub_user_info = usermgr.GetUserById(user_id);
    				if(sub_user_info ~= nil and sub_user_info.desk and sub_user_info.site) then
                        local deskinfo = desklist[sub_user_info.desk];
                        if(deskinfo.desktype ~= g_DeskType.match) then
        					local sitedata = deskmgr.getsitedata(sub_user_info.desk, sub_user_info.site);
        					if(sitedata.gold + sitedata.betgold > 0) then
        						usergold = usergold + sitedata.gold + sitedata.betgold;
        					elseif(sub_user_info.chouma ~= nil)then
        						usergold = usergold + sub_user_info.chouma;
                            end
                        end
                    end
                end
			end
		end

		if(usergold > user_info.gamescore) then
			usergold = user_info.gamescore;
		end

		if(usergold > 0) then
			return user_info.gamescore - usergold;
		else
			return user_info.gamescore
		end
	else
		if user_info.site~=nil and (is_include_self_chouma == nil or is_include_self_chouma == 0) then 	
            local deskinfo = desklist[user_info.desk];
            if(deskinfo.desktype ~= g_DeskType.match) then
    			local sitedata = deskmgr.getsitedata(user_info.desk, user_info.site)
    			usergold = sitedata.gold + sitedata.betgold
    			if usergold == 0 and user_info.chouma then
    				return user_info.gamescore - user_info.chouma
    			else
    				return user_info.gamescore - usergold
                end
            else
                return user_info.gamescore
            end
		else
			return user_info.gamescore
		end
	end
end


tex.init_map = function()
	cmdGameHandler = {
		["TXNINF"] = onrecnquestdeskinfo,		--��֪�����Ӆ���
		["TXNTBC"] = onrecvquestbuychouma,      --�������
		["TXRQBC"] = onrecvbuychouma,			--��һ�����
		["TXRQST"] = onrecvgamestart,			--�û�����ʼ
		["TXRQFQ"] = onrecvgiveup,				--�����
		["TXRQXZ"] = onrecvxiazhu,				--����ע
		["TXRQGZ"] = onrecvgenzhu,				--���ע
		["TXRQBX"] = onrecvbuxiazhu,			--�㲻��ע�����ƣ�
		["TXRQAI"] = onrecvallin,				--��ȫ��
		["RQPEXT"] = onrecvgetextrainfo_achieveinfo, --����ĳ���˵�extra_info��achieve_info
		["RQMIXT"] = onrecvgetextrainfo,		--����ĳ���˵�extra_info
		["TXNBBS"] = onrecvgetbbsurl,		--������̳��֤��
		["TXNTDT"] = onrecvtodaydetail,		--���������ϸ
        ["TXAUSI"] = onrecvautosite,      --�յ�����룬�Զ�����


		----------������Ʒģ��----------
		["TXGFSP"] = onrecvopenshop,			--������Ʒ�б�
		["TXEMOT"] = onrecvsendemot,			--�㷢����
        ["TXPROPNUM"] = onrecvpresendgift,      --������Ԥ����
		["TXGIFT"] = onrecvsendgift,			--��������
		["TXGFLT"] = onrecvgetgiftinfo,			--����ĳ�˵���������
		["TXGFUS"] = onrecvusinggift,			--����ĳ����
		["TXGFDP"] = onrecvdropgift,			--������ĳ����
		["TXGFSL"] = onrecvsalegift,			--��������ĳ����
		["TXGFRS"] = onrecvgiftresponse,		--�����������Ӧ
		["TXGFPH"] = onrecvgetgiftrank,			--������Ʒ���а�


		----------������ģ��----------
		["TXSBIF"] = onrecvclicksafebox,		--�������������Ϣ
		["TXSBSG"] = onrecvchangesafeboxgold,	--�����ȡ��Ϸ��
		["TXSBPW"] = onrecvsafeboxpassword,		--�����������
        ["TXSBFE"] = onrecvgetuseremail,        --����õ���ҵ�email

		-----------�ɾ�ģ��-----------
		["TXAMWC"] = achievelib.onrecvgetcompleteachieve,--�õ�����˵ĳɾ�ID
		["TXAMZJ"] = achievelib.onrecvgetlastcompleteachieve,--�õ������ɵĳɾ�ID
		["TXAMFJ"] = achievelib.onrecvgetprize,--����������ɺ󷢽�

		---------���������--------------
		["RQGIFT"] = on_reve_give_betagife,--���������

		---------����ӭ�ͽ̳�--------------
		["TXWELCM"] = on_recve_quest_welcome,--������ʾ��ӭ����
		["TXNOSHOW"] = on_recve_notshow_welcome,--�����Ժ�Ҫ��ʾ��ӭ����
		["STOV"] = on_recve_study_over,--ѧϰ��һ��̳̣������Ƿ�Ҫ����800����

		---------�ֻ����--------------
		["CHECK_NET"] = onrecv_check_net,--�ֻ���ѯ������������
		["MO_REFRESH"] = onrecv_mobile_refresh,--�ֻ���ѯ������������
		["GPSPOSI"] = onrecv_user_gpsinfo,		--�ֻ��û���ʼ��gps��Ϣ
		
		---------����ũ��ʥ������Ϣ--------------
        --[[
        ["TXMTREE"] = on_recve_quest_farmtree,
        ["TXMTIME"] = on_recve_query_delaytime,  --�����ѯ��ü�һ������ʱ��
        ["TXADDTM"] = on_recve_add_onlinetime, --��������ʱ��
        --]]
		--[[
			to wangyu
			���˿�Э���������
				
		--]]
	}
    --���ز���Ļص�
	for k, v in pairs(cmdHandler_addons) do
		ASSERT(not cmdHandler[k])
		cmdHandler[k] = v
	end
end
tex.init_state();

tex.init_map();




