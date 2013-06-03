TraceError("init quest....")
--[[
questlib.ForceRefreshQuest()
--]]

if not questlib then 
    questlib =
    {
		ToQuestInfoString			= NULL_FUNC,		--���л������ַ���
		LoadQuestInfo				= NULL_FUNC,		--�����л������ַ���
    	GetUserQuestList 			= NULL_FUNC,		--�õ��û��Ѿ��ӵ�������Ϣ
        DoPrizeRequest              = NULL_FUNC,        --�յ���ȡ������
        DoProcessUserEveryDayQuest  = NULL_FUNC,        --�յ��û�����������Ϣ
        RefreshAllUserEDQuest       = NULL_FUNC,        --��շ������������û�ÿ��������Ϣ
        DoCheckUserQuest            = NULL_FUNC,        --����û�������ɶ�        
        AddEveryQuestList           = NULL_FUNC,        --��ӽ����ճ�����
        GetEveryQuestList           = NULL_FUNC,        --�õ������ճ������б�   
        isToday                     = NULL_FUNC,        --�Ƿ�Ϊ��������
        ClearUserEDQuest            = NULL_FUNC,        --����û�ÿ��������Ϣ
        AddUserEDQuest              = NULL_FUNC,        --���û�ÿ������ֵ
        InitUserEveryDayQuest       = NULL_FUNC,        --ͬ��ϵͳ���ճ�������Ϣ���û����ճ������б�
        AddAndFinishedProcess       = NULL_FUNC,        --���������ۼ���,����ж���,�ۼӵ��û����������
        GetQuestInfo                = NULL_FUNC,        --�õ�ĳ������ϸ��Ϣ
        GetDailyQuestList           = NULL_FUNC,        --��ȡÿ������
        GetRoomNanDuXiShu           = NULL_FUNC,        --�õ�������Ѷ�ϵ��
        initquestfromdb             = NULL_FUNC,        --�첽�����ݿ��ж������������Ϣ
        OnTimeCheckQuest            = NULL_FUNC,        --ˢ�º�֪ͨ�Ĵ���
        do_extra_nanduxishu         = NULL_FUNC,        --�Ѷ�ϵ������ӳ��ж�
        
        update_completed_quest      = NULL_FUNC,        --����������ɶȵĸ�����Ϣ

		on_game_event				= NULL_FUNC,        --���յ����Բɼ���������ʱ

        db_UpdateUserEDQuest        = NULL_FUNC,        --д���û��ճ��������ݿ�
        db_InitQuestList            = NULL_FUNC,        --��ʼ������
        db_RefreshEveryDayQuest     = NULL_FUNC,        --ˢ���ճ����񣬲���д�����ݿ�
        db_OnRecvToDayQuestList     = NULL_FUNC,        --�յ������ճ�������Ϣ
    
    	net_OnRecvEveryDayQuest		= NULL_FUNC,		--�յ�����ˢ���ճ�����
        net_OnRecvEDQuestPrize      = NULL_FUNC,        --�յ���ȡ������
        net_OnRecvQuestPhase        = NULL_FUNC,        --�յ���������״̬  
    
        net_OnSendEveryDayQuestInfo = NULL_FUNC,        --�����ճ����������Ϣ
        net_OnSendEDQuestPrizeOK    = NULL_FUNC,        --������ȡ�����ɹ�
        net_OnBrocastEDQuestPrizeOK = NULL_FUNC,      --������ȡ�����ɹ�(���ڹ㲥��
        net_OnSendQuestPhase        = NULL_FUNC,        --�����������ͣ��������������ճ�����
    
    
        --�����Ѷ�ϵ�����ã��Ѿ������ݿ��configure_quest_nanduxishu�н������ã��˴��ᱻ����
        ROOM_NANDUXISHU = {
            [2]     = 1,        --2��
            [100]   = 1.5,      --100�� ...
            [2000]  = 2,
            [10000] = 3,
            [60000] = 4,
        },
    
        --ÿ���ճ������ű�
        EveryDayQuestList = {},
    
    
        --��������
        QUEST_TYPE = 
        {
            ["EVERYDAY"] = 1,       --�ճ�����
            ["XXX"]      = 2,
        },
    
        --��ʼ����������
        questList = {},
    
        --����������ͣ����ۼӻ���һ�����
        QUEST_CONDITION_TYPE = 
        {
            ["SUM"] = 1,
            ["ONCE"] = 2,
            ["CONTINOUS"] = 3,    --����������
        },
    
        --�������׶�
        DIFFICULTY = 
        {
            ["EASY"] = 1,
            ["NORMAL"] = 2,
            ["HARD"] = 3,
            ["FREEGIVE"] = 0,
            ["RAID"] = 4,   --�Ŷ�����
        },

        --ÿ�ձ����е��ճ������б�
        EVERY_DAY_MUST_SHOW = {},
    
        --ÿ�ձ���û���е��ճ������б�
        EVERY_DAY_NOT_SHOW = {},
    
        --����ɶԳ��ֵ����񼯺�,���磺�������� = ��������ʾ�������֣���������������
        EVERY_DAY_FACE_TO_FACE_CLASS = {},

        --���벻�ɶԳ��ֵ�
        EVERY_DAY_NOT_IN_TOGETHER = {},

		--����ѡ���������
		quest_num_cfg = {},

        SQL = {
            --�õ��ճ�������Ϣ
            getEveryDayQuestInfo = "insert IGNORE into quest_daily_info(game_name)VALUES(%s);select quest_Id_list from quest_daily_info where game_name = %s",
            --д���ճ�������Ϣ
            updateEveryDayQuestInfo = "update quest_daily_info set quest_id_list = %s where game_name = %s",
            --�����ճ�������־
            insertLogEveryDay = "insert into log_quest_every_day (user_id,game_name,sys_time,xishu,quest_id,prizetype,prizevalue,remark) values(%d, %s, %s, %d, %d, '%s', %d, '%s')",
        }
    }

     --�첽�����ݿ��ж������������Ϣ��
    --��䣺questlib.EVERY_DAY_MUST_SHOW�� 
    --		questlib.EVERY_DAY_NOT_IN_TOGETHER 
    --		questlib.EVERY_DAY_FACE_TO_FACE_CLASS 
    --		questlib.questList
    --��ɺ� dispatchEvent "questlib_init_complete"
    local initquestfromdb = function()
        timelib.createplan(function()
			--�����Ѷ�ϵ����
			local loadquestnanduxishu = function()
				dblib.execute(string.format("select * from configure_quest_nanduxishu where game_name= %s ",dblib.tosqlstr(gamepkg.name)) , function(dt)
                    questlib.ROOM_NANDUXISHU = {}
                    for k, v in pairs(dt) do
						local peilv = v["peilv"]
						local nanduxishu = tonumber(v["nanduxishu"]) or TraceError("nanduxishu not number in peilv " .. tostring(peilv))
						questlib.ROOM_NANDUXISHU[peilv] = nanduxishu
                    end
                    eventmgr:dispatchEvent(Event("questlib_init_complete", 1))
                    trace(questlib)
                end)
			end

			--������������
            local totalquestcount = 0
			local loadquestcount = function()
				dblib.execute(string.format("select * from configure_quest_count where game_name= %s ",dblib.tosqlstr(gamepkg.name)) , function(dt)
                    questlib.quest_num_cfg	= {}
                    for k, v in pairs(dt) do
						local type_str = v["prize_calc_type_str"]
						local type_count = v["count"]
                        totalquestcount = totalquestcount + type_count  --����������
						questlib.quest_num_cfg[questlib.DIFFICULTY[type_str]] = type_count
                    end
					loadquestnanduxishu()

                    --��������������
                    set_room_totalquestcount(totalquestcount)
                end)
            end

            --��������������
            local loadquestclass = function()
                dblib.execute(string.format("select * from configure_quest_relation where game_name= %s ",dblib.tosqlstr(gamepkg.name)) , function(dt)
                    questlib.EVERY_DAY_FACE_TO_FACE_CLASS 	= {}
                    questlib.EVERY_DAY_NOT_IN_TOGETHER 		= {}
                    for k, v in pairs(dt) do
                        if v["relation_type"] 		== 1 then --����
                            questlib.EVERY_DAY_FACE_TO_FACE_CLASS[v["class1"]] = v["class2"]
                        elseif v["relation_type"] 	== 2 then --����
                            questlib.EVERY_DAY_NOT_IN_TOGETHER[v["class1"]] = v["class2"]
                        end
                    end
					loadquestcount()
                end)
            end
    
            --��ҳ�������������б�questList
            local alldatareached = function(dt)
                TraceError("alldatareached")
                local everydaymustshow = {}
                local questlist = {}
                questlist[questlib.QUEST_TYPE.EVERYDAY] = {}		--questlib.QUEST_TYPE.EVERYDAY
                for k, v in pairs(dt) do
                    local data = {}
                    data.difficulty =  v["prize_calc_type"] 		--questlib.DIFFICULTY.*
                    data.prize = {}
                    for i = 1, 3 do
                        local priobj = {}
                        priobj["prizetype"] = string.upper(v["prize_type" .. i])
                        if priobj["prizetype"] and priobj["prizetype"] ~= "" then
                            priobj["prizevalue"] = v["prize_type_arg" .. i]
                            data.prize[i] = priobj
                        end
                    end
                    data.condition = {}
                    data.condition.class = v["class"]				-- string
                    data.condition.type = v["calc_type"]			-- questlib.QUEST_CONDITION_TYPE.*  SUM/ONCE
                    data.condition.count = v["count"]
                    data.condition.condition = {}
                    for i = 1, 5 do
                        local gameref = v["game_ref" .. i]
                        if gameref ~= "" then data.condition.condition[gamepkg.gameref[gameref]] = 1 end
                    end
                    local quest_id = v["quest_id"]
                    ASSERT(not questlist[questlib.QUEST_TYPE.EVERYDAY][quest_id], "����ID���ظ���")
                    questlist[questlib.QUEST_TYPE.EVERYDAY][quest_id] = data
                    if v["is_must_show"] == 1 then
                        table.insert(everydaymustshow, v["quest_id"])
                    end
                end
                questlib.EVERY_DAY_MUST_SHOW = everydaymustshow
                questlib.questList = questlist
    
                --��������������
                loadquestclass()			
            end
    
            --���������б�
            local loadquestlist = function()
                local sqlwhere = string.format("from configure_quest where game_name=%s and is_disabled = 0", dblib.tosqlstr(gamepkg.name))
                dblib.execute("select count(id) as count " .. sqlwhere, function(dtc)
                    local sqlstr = "select * " .. sqlwhere
                    local reached = 0
                    local dtall = {}
                    for i = 1, dtc[1]["count"] do
                        dblib.execute(string.format(sqlstr .. " limit 1 offset %d" , i - 1), function(dt)
                            if dt and #dt == 1 then
                                dtall[i] = dt[1]
                            else
                                TraceError("���ز���һ����")
                            end
                            reached = reached + 1
                            if reached == dtc[1]["count"] then
                                alldatareached(dtall)
                            end
                        end)
                        --for i
                    end 
                    --dblib.execute
                end)
            end
    
            loadquestlist()
        end, 2)
    end

    --���ݿ�����÷���ɹ���ȥˢ����
    eventmgr:addEventListener("questlib_init_complete", 
    	function()
    		questlib.db_InitQuestList()
    	end)
    initquestfromdb()
end
---------------------------------- �¼�ģ�� --------------------------------------

--�û���¼��ʱ��
if questlib.onuser_login then
	eventmgr:removeEventListener("h2_on_user_login", questlib.onuser_login);
end
questlib.onuser_login = function(e)
	if(not gamepkg.GetBeginnerGuideRate or gamepkg.GetBeginnerGuideRate(e.data.userinfo) == 0) then
		--TraceError("not beginner")	
		local questdata = e.data.data["quest_info"] or ""
		questlib.DoProcessUserEveryDayQuest(e.data.userinfo, questdata)
	end
end
eventmgr:addEventListener("h2_on_user_login", questlib.onuser_login);

--�û��������������¼�
if questlib.user_finished_guide then
	eventmgr:removeEventListener("game_user_finished_guide", questlib.user_finished_guide);
end
questlib.user_finished_guide = function(e)
    --��ʼ���ճ�����
    local edlist = questlib.InitUserEveryDayQuest(e.data.userinfo)
    --��userinfo�е�����ֵ
    questlib.AddUserEDQuest(e.data.userinfo, edlist)
    --���߿ͻ���ˢ����
    questlib.net_OnSendQuestPhase(e.data.userinfo, 1)
end
eventmgr:addEventListener("game_user_finished_guide", questlib.user_finished_guide);

--�û�������ȱ仯��
if questlib.on_game_event then
	eventmgr:removeEventListener("game_event", questlib.on_game_event);
end
questlib.on_game_event = function(e)
	--TraceError("questlib.on_game_event()")
	local datalist = e.data
	for i = 1, #datalist do
		local userid = tonumber(datalist[i].userid)
		local data = datalist[i].data
		local userinfo = usermgr.GetUserById(userid)
        local single_event = datalist[i].single_event

		questlib.DoCheckUserQuest(userinfo, data , single_event)
	end
end
eventmgr:addEventListener("game_event", questlib.on_game_event);

--ÿ����һ�ε�ʱ�䣬����ˢ�������֪ͨ
if questlib.ontimer_minute then
	eventmgr:removeEventListener("timer_minute", questlib.ontimer_minute);
end
questlib.ontimer_minute = function(e)
    questlib.OnTimeCheckQuest(e.data.min)
end
eventmgr:addEventListener("timer_minute", questlib.ontimer_minute);

questlib.ForceRefreshQuest = function()
    TraceError("ǿ��ˢ������")
    questlib.db_RefreshEveryDayQuest()
    timelib.createplan(
        function()
            questlib.db_InitQuestList()
        end
    , 2)
    TraceError("��������ֶ����ԣ���������Ϣ�뱨������")
end

------------------------------------------------------------------------------
--��ʱ��飬�����������
questlib.OnTimeCheckQuest = function(flagmin) 
    local tableTime = os.date("*t",os.time())
    local nowHour  = tonumber(tableTime.hour)

    local tips = "�ճ�������%s���Ӻ����ã�������������Ҽ�ʱ��ȡ������"
    --ִ��4���Ӷ�ʱ����
    if(nowHour == 4 and flagmin == 0) then
        --��ʱˢ��ÿ������
        questlib.db_InitQuestList()
    end

    --���㲥����ˢ�µ���ʱ lch

    -- [[����������1Сʱˢ��]]
    if(nowHour == 3 and flagmin == 0) then
        --BroadcastMsg(_U(format(tips, "60")),0);
    end

    -- [[����������30����ˢ��]]
    if(nowHour == 3 and flagmin == 30) then
        --BroadcastMsg(_U(format(tips, "30")),0);
    end

    --[[����������10����ˢ��]]
    if(nowHour == 3 and flagmin == 50) then
        --BroadcastMsg(_U(format(tips, "10")),0);

        --3��50 ���µ������ȷŵ����ݿ�
        questlib.db_RefreshEveryDayQuest()
    end

     --[[����������5����ˢ��]]
    if(nowHour == 3 and flagmin == 55) then
        --BroadcastMsg(_U(format(tips, "5")), 0);
    end
end
--------------------------------------------------------------------------------------
--------------------------------- ����net ----------------------------------------

--�����������ͣ��������������ճ�����
questlib.net_OnSendQuestPhase = function(userinfo, quest_phase)
    netlib.send(
		function(buf)
			buf:writeString("REQP")
            buf:writeByte(quest_phase)
		end
	, userinfo.ip, userinfo.port)
end

--�����ճ����������Ϣ[����]
questlib.net_OnSendEDQuestPrizeOK = function(touserinfo, userinfo, userQuestInfo, getAllQuestPrize)
    if not touserinfo or not userinfo then return end
	netlib.send(
		function(buf)
			buf:writeString("RETC")
            buf:writeByte(userinfo.site or 0)
            buf:writeInt(userinfo.userId)
            buf:writeByte(#userQuestInfo.prize)
            for i=1, #userQuestInfo.prize do
                buf:writeString(userQuestInfo.prize[i].prizetype) --����
                buf:writeInt(userQuestInfo.prize[i].prizevalue) --����
            end
            buf:writeByte(getAllQuestPrize) --�Ƿ�ȫ������
		end
	, touserinfo.ip, touserinfo.port)
end

--�����ճ����������Ϣ�����Ӱ�����ս��
questlib.net_OnBrocastEDQuestPrizeOK = function(userinfo, userQuestInfo, getAllQuestPrize)
    if not userinfo then return end
    --֪ͨ�������
    local deskno = userinfo.desk
    --û�����Ӻţ�ֻ�����Լ�
    if(not deskno) then
        questlib.net_OnSendEDQuestPrizeOK(userinfo, userinfo, userQuestInfo, getAllQuestPrize)
        return
    end

    --֪ͨ������������
    for i = 1, room.cfg.DeskSiteCount do
        local tempuserkey = hall.desk.get_user(deskno,i);
        if(tempuserkey) then
            local playingUserinfo = userlist[hall.desk.get_user(deskno, i) or ""]
            if (playingUserinfo and playingUserinfo.offline ~= offlinetype.tempoffline) then
                questlib.net_OnSendEDQuestPrizeOK(playingUserinfo, userinfo, userQuestInfo, getAllQuestPrize)
            end
            if(playingUserinfo == nil) then
                TraceError("�û�����ʱ�������и��û���userlist��ϢΪ��2")
                hall.desk.clear_users(deskno, i)
            end
        end
    end
    
    local deskinfo = desklist[deskno] 
    for k,watchinginfo in pairs(deskinfo.watchingList) do
        if (watchinginfo and watchinginfo.offline ~= offlinetype.tempoffline) then
            questlib.net_OnSendEDQuestPrizeOK(watchinginfo, userinfo, userQuestInfo, getAllQuestPrize)
        end
        if(watchinginfo == nil) then
            deskinfo.watchingList[k] = nil
        end
    end
end

--�����ճ����������Ϣ
questlib.net_OnSendEveryDayQuestInfo = function(userinfo, questList, questRefreshed)
    --�õ���������
    local num = 0
    for k, v in pairs(questList) do
        if(k ~= nil and v ~= nil) then
            num = num + 1
        end
    end
	netlib.send(
		function(buf)
			buf:writeString("RERG")
            --����ÿ��������ϸ��Ϣ
            buf:writeInt(num)
            for k, v in pairs(questList) do
                buf:writeInt(k)               --id
                buf:writeByte(v.isComplete)   --�Ƿ����
                buf:writeByte(v.isGetPrize)   --�Ƿ��콱
                buf:writeByte(v.difficulty)   --�Ѷ�
                buf:writeString(tostring(v.nanDuXiShu))  --�Ѷ�ϵ��
                buf:writeInt(v.condition)   --�������
                --TraceError(v.prize)
                buf:writeByte(#v.prize)   --������������
                for i=1, #v.prize do
                    buf:writeString(v.prize[i].prizetype) --����������
                    buf:writeInt(v.prize[i].prizevalue) --�����͵Ľ�������
                end
            end
            buf:writeByte(questRefreshed) --�����Ƿ�����ˢ����
		end
	, userinfo.ip, userinfo.port)
end

--------------------------------- �ͻ���Э�鲿�� ---------------------------------
--�յ�����ˢ���ճ�����
questlib.net_OnRecvEveryDayQuest = function(buf)
    local userKey = getuserid(buf)
    local userinfo = userlist[userKey]
    local questList = questlib.GetUserQuestList(userinfo)

    --�쳣���������ʱ��û�õ�����Ͳ�����
    if( questList == nil or
        questList[questlib.QUEST_TYPE.EVERYDAY] == nil) then
        return
    end

    local questList = questList[questlib.QUEST_TYPE.EVERYDAY]
    local questRefreshed = 0  --�����Ƿ�����ˢ��ʱ��
    questlib.net_OnSendEveryDayQuestInfo(userinfo, questList, questRefreshed)
end

--�յ���ȡ������
questlib.net_OnRecvEDQuestPrize = function(buf)
    local userKey = getuserid(buf)
    local userinfo = userlist[userKey]
    local questId = buf:readInt() --��Ҫ��ȡ������ID

    --�����ȡ�����Ϸ���,�콱
    questlib.DoPrizeRequest(userinfo,questId)
end

--�����ȡ�����Ϸ���
questlib.DoPrizeRequest = function(userinfo,questId)
     --���Ƿ���������
    local edlist = questlib.GetUserQuestList(userinfo)

    if( edlist == nil or
        edlist[questlib.QUEST_TYPE.EVERYDAY] == nil or
        edlist[questlib.QUEST_TYPE.EVERYDAY][questId] == nil) then

        TraceError("�û�û���������ȴ����ȡ�����������׿���, ������")
        return
    end

    local userQuestInfo = edlist[questlib.QUEST_TYPE.EVERYDAY][questId]
    if(userQuestInfo.isComplete == 0) then
        TraceError("�û�û���������ȴ����ȡ�����������׿���, ������")
        return
    end

    --���Ƿ���ȡ���ý����ˣ���ֹ����
    if(userQuestInfo.isGetPrize == 1) then
        trace("�û�������������׿���, ������")
        return
    end

    --ִ���콱
    userQuestInfo.isGetPrize = 1 --�����콱��ʶ
    for i = 1, #userQuestInfo.prize do
        local prizeitem = userQuestInfo.prize[i]
        if(prizeitem.prizetype == "GOLD") then
            usermgr.addgold(userinfo.userId, prizeitem.prizevalue, 0, g_GoldType.quest, -1)
        elseif(prizeitem.prizetype == "PRESTIGE") then
            usermgr.addprestige(userinfo.userId, prizeitem.prizevalue) --�����û�����
        elseif(prizeitem.prizetype == "EXPERIENCE") then
             --�����û�����
            usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), prizeitem.prizevalue, g_ExpType.quest, questId)
        else
            TraceError("δ֪�������ͣ�������ֱ���ʾ��������id=["..questId.."]������")
        end
    end

    local nGiveGoldType = 6

    --�������ݿ��û�������Ϣ
    questlib.db_UpdateUserEDQuest(userinfo,edlist[questlib.QUEST_TYPE.EVERYDAY], 3, questId)

    --�������������Ϣ
    questlib.update_completed_quest(userinfo, edlist[questlib.QUEST_TYPE.EVERYDAY])

    local questList = edlist[questlib.QUEST_TYPE.EVERYDAY]
    local questRefreshed = 0  --�����Ƿ�����ˢ��ʱ��

    questlib.net_OnSendEveryDayQuestInfo(userinfo, questList, questRefreshed)

    local getAllQuestPrize = 1
    --�Ƿ�ȫ�������콱��
    for k, v in pairs(edlist[questlib.QUEST_TYPE.EVERYDAY]) do
        if v.isGetPrize == 0 then
            getAllQuestPrize = 0
            break
        end
    end
    xpcall(function()
        local getAllNormlQuest = 1
        for k, v in pairs(edlist[questlib.QUEST_TYPE.EVERYDAY]) do
            if v.isGetPrize == 0 and v.difficulty == questlib.DIFFICULTY["NORMAL"] then
                getAllNormlQuest = 0
                break
            end
        end
    
        if getAllNormlQuest == 1 then
            achievelib.updateuserachieveinfo(userinfo,2009)--�е��ճ�
        end
    
        local getAllHardQuest = 1
        for k, v in pairs(edlist[questlib.QUEST_TYPE.EVERYDAY]) do
            if v.isGetPrize == 0 and v.difficulty == questlib.DIFFICULTY["HARD"] then
                getAllHardQuest = 0
                break
            end
        end
    
        if getAllHardQuest == 1 then
            achievelib.updateuserachieveinfo(userinfo,2018)--�ۺ��ճ�
        end
    end,throw)
    --�õ���Ϸ��������
    local new_prestige = usermgr.getprestige(userinfo)

    --�㲥�콱�¼�
    questlib.net_OnBrocastEDQuestPrizeOK(userinfo, userQuestInfo, getAllQuestPrize)
    --���������
    --if(userinfo.site ~= nil and userinfo.site > 0) then
        -------------------------------�ɾͲɼ�-------------------------
        xpcall(function()
             achievelib.updateuserachieveinfo(userinfo,1006)--�ճ�����

             achievelib.updateuserachieveinfo(userinfo,1011)--�ճ�����

             achievelib.updateuserachieveinfo(userinfo,1019)--�ճ�����

             achievelib.updateuserachieveinfo(userinfo,2025)--�ճ�����

             achievelib.updateuserachieveinfo(userinfo,3019)--�ճ�����

             achievelib.updateuserachieveinfo(userinfo,3029)--�ճ���ʦ
        end,throw)
        ----------------------------------------------------------------
    --end
    
    
end

---------------------------------------------------------------------------
----------------  �û���¼�� ���� -----------------------------------------
--���ַ�������table
function questlib.LoadQuestInfo(strData)
	if not strData or strData == "" then return nil end
	if string.sub(strData, 1, 2) == "do" then
		return table.loadstring(strData)
	else
		local retTable = {}
		local data = split(strData, ";")
		for i = 1, #data do
            local lines = split(data[i], "|")
			if (lines and #lines >= 8) then
				local t = {}
				t.condition 	= tonumber(lines[2])
				t.date 			= tonumber(lines[3])
				t.difficulty 	= tonumber(lines[4])
				t.isComplete 	= tonumber(lines[5])
				t.isGetPrize 	= tonumber(lines[6])
				t.nanDuXiShu 	= tonumber(lines[7])
                t.prize = {}
                local prize_count = tonumber(lines[8]) or 0
                local offset = 8
                for j = 1, prize_count do
                    t.prize[j] = {}
                    t.prize[j].prizetype 	= tostring(lines[offset + 1])
                    t.prize[j].prizevalue = tonumber(lines[offset+ 2])
                    offset = offset + 2
                end
				retTable[tonumber(lines[1])] = t
			end
        end
       
		return retTable
	end
end

--����tableת��Ϊ�ַ���
function questlib.ToQuestInfoString(tblData)
	local keys = {}
	local strRet = ""
	for k, v in pairs(tblData) do
		table.insert(keys, k)
	end
	table.sort(keys)
	for i = 1, #keys do
		local strLine = keys[i] .. "|"
		local t = tblData[keys[i]]
		strLine = strLine .. t.condition .. "|"
		strLine = strLine .. t.date .. "|"
		strLine = strLine .. t.difficulty .. "|"
		strLine = strLine .. t.isComplete .. "|"
		strLine = strLine .. t.isGetPrize .. "|"
		strLine = strLine .. t.nanDuXiShu .. "|"
        strLine = strLine .. #t.prize .. "|"
        for j = 1, #t.prize do
    		strLine = strLine .. t.prize[j].prizetype .. "|"
    		strLine = strLine .. t.prize[j].prizevalue
            if j == #t.prize then
                strLine = strLine .. ";"
            else
                strLine = strLine .. "|"
            end
        end
		strRet = strRet .. strLine
    end
	return strRet
end


--�յ��û�����������Ϣ
questlib.DoProcessUserEveryDayQuest = function(userinfo, szRet)
	local edlist = nil
    --���ݿ�������Ϣ
    if(string.len(szRet) ~= 0) then
		--TraceError(szRet)
        edlist = questlib.LoadQuestInfo(szRet)
		--TraceError(edlist)
        --��������ˣ����ڴ��ã�Ȼ��д�����ݿ�
        if(edlist ~= nil) then
            local key, edItem = next(edlist)
            if not edItem then
            	return
            end 
						local eddate = edItem.date
            --�û������ǽ���ģ�ȥˢ��
            if(questlib.isToday(eddate) == false) then
                edlist = questlib.InitUserEveryDayQuest(userinfo)
            end
        else
            edlist = questlib.InitUserEveryDayQuest(userinfo)
        end
    --���ݿ�û�У����ɣ�Ȼ��д�����ݿ�
    else
        edlist = questlib.InitUserEveryDayQuest(userinfo)
    end

    --��userinfo�е�����ֵ
    questlib.AddUserEDQuest(userinfo,edlist)
end

--д���û��ճ��������ݿ�
questlib.db_UpdateUserEDQuest = function(userinfo, list, rate, questId)
    dblib.cache_set(gamepkg.table, {quest_info=questlib.ToQuestInfoString(list)}, "userid", userinfo.userId)
	--����û���ճ�����
	if (isguildroom() == true) then
		return
	end
    if(rate == 1) then      --ˢ�³��µ�

    elseif(rate == 2) then  --���ȷ����ı�

    elseif(rate == 3) then  --��ȡ����
        --��¼�콱��־
        local userQuestInfo = list[questId]

        if(userQuestInfo ~= nil) then
            for i = 1, #userQuestInfo.prize do
                local szSql = format(questlib.SQL.insertLogEveryDay,
                    userinfo.userId,
    				dblib.tosqlstr(gamepkg.name),
                    "'"..os.date("%Y-%m-%d %X", os.time()).."'",
                    userQuestInfo.nanDuXiShu,
                    questId,
                    userQuestInfo.prize[i].prizetype,
                    userQuestInfo.prize[i].prizevalue,
                    "")
    			dblib.execute(szSql)
            end
        end
	end
end

--��շ������������û�ÿ��������Ϣ
questlib.RefreshAllUserEDQuest = function()
    for k, v in pairs(userlist) do
        local bFlag = questlib.ClearUserEDQuest(v)
        --���߿ͻ����µ�������Ϣ
        if(bFlag == true) then
            local list = questlib.InitUserEveryDayQuest(v) --ˢ���û��ڴ���������Ϣ
            questlib.AddUserEDQuest(v, list) --���������Ϣ���û�

            --�����Ӯ״̬
            if(questlib.GetUserQuestList(v) ~= nil and
               questlib.GetUserQuestList(v)[questlib.QUEST_TYPE.EVERYDAY] ~= nil) then

                local questList = questlib.GetUserQuestList(v)[questlib.QUEST_TYPE.EVERYDAY]
                local questRefreshed = 1  --�����Ƿ�����ˢ��ʱ��
                if (v.key == k and v.offline == nil) then
                    questlib.net_OnSendEveryDayQuestInfo(v, questList, questRefreshed)
                end
            end
        end
    end
end

-------------------- ��������ʼ������ˢ�����񲿷� --------------
--�յ������ճ�������Ϣ
questlib.db_OnRecvToDayQuestList = function(dataTable)
    local everyDayList = nil

    --���ݿ����н���������Ϣ
    if(#dataTable ~= 0 and dataTable[1][1] ~= nil and dataTable[1][1] ~= "") then
        everyDayList = table.loadstring(dataTable[1]["quest_Id_list"])

    --���ݿ�û�У����ɣ�Ȼ��д�����ݿ�
    else
        --TraceError("���ݿ�û�У����ɣ�Ȼ��д�����ݿ�")
        everyDayList = questlib.db_RefreshEveryDayQuest()
    end
    questlib.AddEveryQuestList(everyDayList)

    --����û�������Ϣ
    questlib.RefreshAllUserEDQuest()
end

--��ʼ������
questlib.db_InitQuestList = function()
    --�����ݿ���10������
	local szSql = string.format(questlib.SQL.getEveryDayQuestInfo, dblib.tosqlstr(gamepkg.name), dblib.tosqlstr(gamepkg.name))
	dblib.execute(szSql, questlib.db_OnRecvToDayQuestList)
end

--ˢ���ճ����񣬲���д�����ݿ�
questlib.db_RefreshEveryDayQuest = function()
    local everyDayList = questlib.GetDailyQuestList()
    local szSql = format(
        questlib.SQL.updateEveryDayQuestInfo,
        dblib.tosqlstr(table.tostring(everyDayList)),
		dblib.tosqlstr(gamepkg.name)
    )
    --�ѵõ���list�ŵ�ϵͳ������
	dblib.execute(szSql)
    return everyDayList
end
--------------------------------------------------------------------

--����û�������ɶ�
questlib.DoCheckUserQuest = function(userinfo, questCondInfo, single_event)
    --ɸѡ�������������
    --gamepkg.process_condition_to_quest �����ֱ�ӵ��ø���Ϸ���
    --TODO:�ĳɲɼ��㷽ʽ
    --local questCondInfo = gamepkg.process_condition_to_quest(userRoundInfo)

    --����ʲô��������˻���ȱ仯��
    local result = questlib.AddAndFinishedProcess(userinfo,questCondInfo,single_event)

    --������ʱֻ֧���ճ�����
    --�õ��û��Ѿ��ӵ��ճ�������Ϣ
    local userQuestInfo = questlib.GetUserQuestList(userinfo)
    if(userQuestInfo ~= nil) then
        userQuestInfo = userQuestInfo[questlib.QUEST_TYPE.EVERYDAY]
    end

    if(userQuestInfo == nil) then
        return
    end

    --�õ��仯�������ع��û������
    local bNeedUpdate = false

    --ѭ��������ȷ����ı������
    for k, v in pairs(result) do
        bNeedUpdate = true

        --�����Ƿ����
        userQuestInfo[k].isComplete = v.isComplete

        --�������ʱ��ͳ�Ƴ��Ѷ�ϵ����������
        if(userQuestInfo[k].isComplete == 1) then
            --���ʱ�Ѷ�ϵ��
            local questInto = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, k)
            for i =1, #userQuestInfo[k].prize do
                userQuestInfo[k].prize[i].prizevalue = userQuestInfo[k].prize[i].prizevalue * userQuestInfo[k].nanDuXiShu
            end
        end
    end

    for k, v in pairs(userQuestInfo) do
        userQuestInfo[k].date = os.time()
    end

    --��Ҫ������Ϣ
    if(bNeedUpdate) then
        questlib.db_UpdateUserEDQuest(userinfo,userQuestInfo, 2, 0) -- ���µ����ݿ�
        local questRefreshed = 0  --�����Ƿ�����ˢ��ʱ��
        local questList = userQuestInfo
        questlib.net_OnSendEveryDayQuestInfo(userinfo, questList, questRefreshed)
    end
end

--��ӽ����ճ�����
questlib.AddEveryQuestList = function(questList)
    questlib.EveryDayQuestList = questList
end

--�õ������ճ������б�
questlib.GetEveryQuestList = function()
    return questlib.EveryDayQuestList
end

--�Ƿ�Ϊ��������
questlib.isToday = function(sec)
	ASSERT(sec and tonumber(sec), "sec error")
    local tbNow  = os.date("*t",os.time())
    local today = os.time({year = tbNow.year,month = tbNow.month,day = tbNow.day,hour = 4,min = 0,sec = 0})

    local tbSec = os.date("*t",sec)
    if(tbNow.hour < 4) then
        today = os.time({year = tbNow.year,month = tbNow.month,day = tbNow.day - 1,hour = 4,min = 0,sec = 0})
    end

    return sec >= today
end

--����û�ÿ��������Ϣ
questlib.ClearUserEDQuest = function(userinfo)
    if(userinfo == nil or userinfo.questinfo == nil) then
       return false
    end
    userinfo.questinfo[questlib.QUEST_TYPE.EVERYDAY] = {}
    return true
end

--���û�ÿ������ֵ
questlib.AddUserEDQuest = function(userinfo, questList)
    if(userinfo == nil) then
        return
    end
	--����û��ÿ������
	if(isguildroom() == true) then
		return
	end

    if(userinfo.questinfo == nil) then
        userinfo.questinfo = {}
    end

    if(userinfo.questinfo[questlib.QUEST_TYPE.EVERYDAY] == nil) then
        userinfo.questinfo[questlib.QUEST_TYPE.EVERYDAY] = {}
    end
    userinfo.gameInfo.winpoint = nil    --�����Ӯ״̬
    userinfo.questinfo[questlib.QUEST_TYPE.EVERYDAY] = questList

    --֪ͨh2����Ϸ����ɵ������б�
    questlib.update_completed_quest(userinfo, questList)
end

--����������ɶȵĸ�����Ϣ
questlib.update_completed_quest = function(userinfo, questlist)
    --֪ͨh2����Ϸ����ɵ������б�
    local completed_quest = {} --��ɵ������б�
    for k, v in pairs(questlist) do
        if(v.isGetPrize == 1) then
            table.insert(completed_quest, k)
        end
    end

    usermgr.update_user_completed_quest(userinfo,completed_quest)
end

--ͬ��ϵͳ���ճ�������Ϣ���û����ճ������б�
questlib.InitUserEveryDayQuest = function(userinfo)
    if userinfo == nil then
        TraceError("ERROR:USERINFOΪ��")
        return nil
    end

    local everyDayQuest = questlib.GetEveryQuestList()

    if(everyDayQuest == nil) then
        return nil
    end

    --���������ճ����񣬽����Ƿŵ�userinfo��
    local list = {}
    for k, v in pairs(everyDayQuest) do
        --������ϸ��Ϣ
        local questInto = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, v)
        if(questInto ~= nil) then
            list[v] = {}
            list[v].condition = 0  --����
            list[v].nanDuXiShu = 0 --�Ѷ�ϵ��
            list[v].isComplete = 0 --�Ƿ����
            list[v].date = os.time() --ʱ��
            list[v].isGetPrize = 0 --�Ƿ��콱
            list[v].difficulty = questInto.difficulty   --�����Ѷ�
            list[v].prize = {}
            for i =1, #questInto.prize do
                list[v].prize[i] = questInto.prize[i]
            end
        end
    end
    return list
end

--���������ۼ���,����ж���,�ۼӵ��û����������
--return: �����仯�������б�
questlib.AddAndFinishedProcess = function(userinfo, conditionInfo, single_event)
    --�쳣����
    if(conditionInfo == nil or userinfo == nil) then
        --TraceError("ERROR:ִ��questlib.AddAndFinishedProcess,�������ݰ���������")
        return
    end

    --�õ��û���������Ϣ
    local userQuestList = questlib.GetUserQuestList(userinfo)
    if(userQuestList == nil) then
        return
    end

    local result = {}

    --�����Ѷ�ϵ��
	local roomXiShu = questlib.GetRoomNanDuXiShu()

    --ȷ���Ѷ�ϵ���Ƿ���BUFF�ļӳ�
    roomXiShu= questlib.do_extra_nanduxishu(userinfo, roomXiShu)

    --ѭ���û��ӵ�ÿ�����񣬸����������ɶ�
    --[[
        k: ��ʾ�������ͣ����磺everyday
        v: ���Ӧ���������͵������б�
    ]]
    for k, v in pairs(userQuestList) do
        --ѭ��ѭ��ÿ�����͵�ÿ������
        --[[
            m: ��ʾ����Id
            n: ��ʾ�û�����������
        ]]
        for m, n in pairs(v) do
            local questInfo = questlib.GetQuestInfo(k, m) --�õ�����������Ϣ

            if(questInfo ~= nil) then
                local questCondInfo = questInfo.condition --�������������Ϣ
                local needCond  = questCondInfo.condition --������������
                local needCount = questCondInfo.count     --�������貽��
                local needType  = questCondInfo.type      --���������������               
                    

                --�������Ƿ������
                local isAllComplate = true
                local finishedStep = 0
                for i, j in pairs(needCond) do
                    if(conditionInfo[i] == nil or conditionInfo[i] == 0) then
                        isAllComplate = false
                    else
                        questInfo.single_event = single_event
                         --�����������ʱȡ���ģ����磺3��1 �� Ӯ��ȡ����һ
                        if(conditionInfo[i] > finishedStep) then
                            finishedStep = conditionInfo[i] --�������
                        end
                    end
                end

                --��Ҫһ����ɵ�����ÿ�����
                if(needType == questlib.QUEST_CONDITION_TYPE.ONCE and (n.isComplete == nil or n.isComplete == 0)) then
                     result[m] = {}
                     result[m].isComplete = 0
                     n.condition = 0
                     n.nanDuXiShu = 0
                --��Ҫ������ɵ�������;û��ɾ����
                elseif(needType == questlib.QUEST_CONDITION_TYPE.CONTINOUS and (n.isComplete == nil or n.isComplete == 0)) then
                    --if((not isAllComplate) and (questInfo.single_event and questInfo.single_event == single_event)) then
                    if((not isAllComplate) and (questInfo.single_event == nil or (questInfo.single_event and questInfo.single_event == single_event))) then
                         result[m] = {}
                         result[m].isComplete = 0
                         n.condition = 0
                         n.nanDuXiShu = 0
                    end
                end

                --���񳬹���ȡʤ�µ�step������ 8 + 3 =10
                if(n.condition + finishedStep > needCount) then
                    finishedStep = needCount - n.condition
                end

                --�ﵽ��������ˣ������ۼ�[������ȷ����仯]
                if(isAllComplate == true) then
                    --���Ƿ�����ۼ�
                    if(needType == questlib.QUEST_CONDITION_TYPE.ONCE) then
                        n.condition = finishedStep
                    else
                        n.condition = n.condition + finishedStep   --�ۼ��������
                    end
                    
                    if(n.condition > needCount) then
                        finishedStep = finishedStep - (n.condition - needCount)
                        n.condition = needCount
                    end
                    --�Ѷ�ϵ��
                    if finishedStep > 0 then
                        if(n.nanDuXiShu == 0) then
                            n.nanDuXiShu = math.round((roomXiShu * finishedStep) /  (finishedStep) * 10) / 10
                        else
                            n.nanDuXiShu = math.round((n.nanDuXiShu * (n.condition - finishedStep) + roomXiShu * finishedStep) /  n.condition * 10) / 10
                        end
                    end

                    --����ɴ�����ȥ����������Ƿ�����ˣ���ɾͼӽ���
                    --��������ɣ��������
                    if(n.isComplete == 0) then
                        result[m] = {}
                        --���������
                        if(n.condition >= needCount) then
                            result[m].isComplete = 1
                        else
                            result[m].isComplete = 0
                        end
                    end
                end
            end
        end
    end

    return result
end

--ȷ���Ѷ�ϵ������ӳɷ�ʽ
questlib.do_extra_nanduxishu = function(userinfo, nanduxishu)
    local using_buff = bufflib.get_user_using_buff(userinfo)
    local bfind = false
    for k, v in pairs(using_buff) do
        if(v == bufflib.CLASS_INFO["DOUBLE_PRESTIGE"]) then
            bfind = true
        end
    end
    
    if(bfind) then
        nanduxishu = nanduxishu * 2
    end
    return nanduxishu
end

--�õ�ĳ������ϸ��Ϣ
questlib.GetQuestInfo = function(questType,questId)
    if(questlib.questList[questType] == nil) then
        return nil
    end
    return questlib.questList[questType][questId]
end

--�õ��û��Ѿ��ӵ�������Ϣ
questlib.GetUserQuestList = function(userinfo)
    --Ϊ�յ��쳣����
    if(userinfo == nil or userinfo.questinfo == nil) then
        return nil
    end
    return userinfo.questinfo
end

--�����õõ������10������
questlib.get_random_quest_list = function()
     --���´���һ����ʱquestlist������ˢ������,�������ð�˳����
    local questlist_origin = questlib.questList[questlib.QUEST_TYPE.EVERYDAY]
    local questidlist = {}

	for k, v in pairs(questlib.DIFFICULTY) do
		questidlist[v] = {}
	end

	--v��ʾ������ϸ��Ϣ��k��ʾ����ID
    for k, v in pairs(questlist_origin) do
        for k1, v1 in pairs(questlib.DIFFICULTY) do
            if(v.difficulty == v1 and v ~= nil) then    
                table.insert(questidlist[v1], k)
            end        
        end
    end

    --�����ø���ѡ������
    local tSelectQuest = {}
	local quest_num_cfg = questlib.quest_num_cfg --��������ѡ�����ֵ

    --kΪ�Ѷȣ�vΪ���Ѷ���Ҫ��������ĸ���
    for k, v in pairs(quest_num_cfg) do
        local nSelectCount = 0
		if(#questidlist[k] > 0 and v > 0) then
			while(true) do
				local nSelectItem = questidlist[k][math.random(1, #questidlist[k])]
				local bFind = false
				for k, v in pairs(tSelectQuest) do
					if (nSelectItem == v) then
						bFind = true
						break
					end
				end
				if (bFind == false) then
					nSelectCount = nSelectCount + 1
					tSelectQuest[table.getn(tSelectQuest) + 1] = nSelectItem
				end
				if (nSelectCount == v or nSelectCount == #questidlist[k]) then
					break
				end
			end
		end
    end
    return tSelectQuest
end

--��ȡÿ������
questlib.GetDailyQuestList = function()
   
    --�õ���ʼ10������
    local tSelectQuest = questlib.get_random_quest_list()
    -----------------------------------------------------------------------
    --��ʱ��������һ������ϵ���Ƿ��ù���
    local findUsedClass = function(classId,usedClass)
        local bFind = false
        for m, n in pairs(usedClass) do
            if(n == classId) then
                bFind = true
                break
            end
        end
        return bFind
	end

    --�Ƿ�Ϊ�����������
    local findIsMust = function(questId)
        for i, j in pairs(questlib.EVERY_DAY_MUST_SHOW) do
            if(j == questId) then
                return true
            end
        end
        return false
    end

    --�Ƿ�Ϊ���벻��������
    local findIsMustNot = function(questId)
        for i, j in pairs(questlib.EVERY_DAY_NOT_SHOW) do
            if(j == questId) then
                return true
            end
        end
        return false
    end

    --��ʱ���������Ѷ�����滻
    local replaceByDifficulty = function(difficulty,questId)
        for k, v in pairs(tSelectQuest) do
            local questInfo = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, v)
            if(questInfo ~= nil) then
                if(questInfo.difficulty == difficulty) then
                    if(findIsMust(v) == false and findIsMustNot(questId) == false) then
                        trace("���Ѷ�����滻:"..tSelectQuest[k].." ����:"..questId);
                        tSelectQuest[k] = questId
                        break
                    end
                end
            end
        end
    end

    --�������Ƿ���ֹ�
    local findIsExists = function(questId)
        for k, v in pairs(tSelectQuest) do
            if(v == questId) then
                return true
            end
        end
        return false
    end
	---------------- ���⴦����֤ÿ�����ε����� -----------
    --��֤ÿ���б������ε�����
    --[[
        j:����id
    ]]
    for i, j in pairs(questlib.EVERY_DAY_NOT_SHOW) do
        --�õ������Ѷ�
        local needDifficulty = questlib.DIFFICULTY.EASY --Ĭ��Ϊ��
        local needQuestInfo = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, j)
        if(needQuestInfo ~= nil) then
            needDifficulty = needQuestInfo.difficulty
        end

        --��ѡ�����ճ�������û�б���Ҫ������
        local bFind = false
        for k, v in pairs(tSelectQuest) do
            if v == j then
                bFind = true
                break;
            end
        end

        --�������������������滻һ��û���ֹ���ͬ�Ѷȵĸ���
        if bFind then
            for k, v in pairs(tSelectQuest) do
                if(v == j) then
                    for x, y in pairs(questlib.questList[questlib.QUEST_TYPE.EVERYDAY]) do
                        if y.difficulty  == needDifficulty then
                              if(findIsMustNot(x) == false and findIsExists(x) == false) then
                                --TraceError("��֤ÿ���б������ε�����,��"..tSelectQuest[k].."�滻��"..x);
                                tSelectQuest[k] = x
                                break
                            end
                        end
                    end
                end
            end
        end
    end


    --��֤ÿ��ı�������
    --[[
        j:����id
    ]]
    for i, j in pairs(questlib.EVERY_DAY_MUST_SHOW) do
        --�õ���������������Ѷ�
        local needDifficulty = questlib.DIFFICULTY.EASY --Ĭ��Ϊ��
        local needQuestInfo = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, j)
        if(needQuestInfo ~= nil) then
            needDifficulty = needQuestInfo.difficulty
        end

        --��ѡ�����ճ�������û�б���Ҫ������
        local bFind = false
        for k, v in pairs(tSelectQuest) do
            if v == j then
                bFind = true
            end
        end

        --���û��10����������������滻һ��ͬ�Ѷȵĸ���
        if bFind == false then
            replaceByDifficulty(needDifficulty, j)
        end
    end

    ---------------- ���⴦����֤��ͬ�Ѷ�����������Ͷ���һ�� ---------
    --[[
        k: ��ţ�������
        v: ����ID
    -]]
    local usedClass = {}
    for k, v in pairs(tSelectQuest) do
        local questInfo = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, v)

        --���õ��������ͷŵ�һ����ʱ��
        if(questInfo ~= nil) then
            --ѭ��3�������Ѷȣ��Ӽ򵥵���
            for i = 1, 5 do
                if(questInfo.difficulty == i) then

                    --����ϵ���Ƿ��ù���
                    local bFind = findUsedClass(questInfo.condition.class,usedClass)

                    --֮ǰ������û�ù�����ӵ��Ѿ�����
                    if(bFind == false) then
                        usedClass[k] = questInfo.condition.class

                    --֮ǰ�������Ѿ����ˣ��滻��û�ù�������
                    else
                        --ѭ�����������б���һ��û�ù��������滻
                        --[[
                            m: ����id
                            n����������
                        ]]
                        for m, n in pairs(questlib.questList[questlib.QUEST_TYPE.EVERYDAY]) do
                            local questClass = n.condition.class     --����Class
                            --ƥ����ͬ���Ѷ�
                            if(n.difficulty == i) then
                                local bFind2 = findUsedClass(questClass,usedClass)
                                --������û�ù����滻��֮ǰ��
                                if(bFind2 == false) then
                                    if(findIsMust(m) == false and findIsMustNot(m) == false) then
                                        --��Ҫ�ж��Ƿ�Ϊ�س�����
                                        --TraceError("�滻"..tSelectQuest[k].." ��"..m);
                                        tSelectQuest[k] = m
                                        usedClass[k] = questClass
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    ---------------- ���⴦��ʵ�ֱ���ɶԳ��ֵ����񼯺�----------
    --[[
        k: class1
        v: class2
    -]]
    for k, v  in pairs(questlib.EVERY_DAY_FACE_TO_FACE_CLASS) do
        --����ҵ���k,ȥ��v
        --����ҵ���v,ȥ��k
        --���ҵ��Ͳ�����
        --[[
            m: ��ţ�������
            n: ����ID
        -]]
        local bFindK = false
        local bFindV = false
        for m, n in pairs(tSelectQuest) do
            local questInfo = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, n)
            if(questInfo ~= nil) then
                if(k == questInfo.condition.class) then
                    bFindK = true
                end
                if(v == questInfo.condition.class) then
                    bFindV = true
                end
                if(bFindK == true and bFindV == true) then
                    break
                end
            end
        end

        --ֻ�ҵ�����һ����ȥ�滻��һ��
        if(bFindK and bFindV == false) or (bFindV and bFindK ==false) then
            --ѭ�����������б�
            --[[
                i: ����id
                j����������
            ]]
            for i, j in pairs(questlib.questList[questlib.QUEST_TYPE.EVERYDAY]) do
                local questClass = j.condition.class     --����Class
                local difficulty = j.difficulty          --�����Ѷ�
                --�滻V
                if(bFindK) then
                    --������������Vϵ��
                    if(questClass == v) then
                        replaceByDifficulty(difficulty, i)
                        break
                    end
                --�滻K
                elseif(bFindV) then
                    --������������kϵ��
                    if(questClass == k) then
                        replaceByDifficulty(difficulty, i)
                        break
                    end
                end
            end
        end
    end

    -----------------------------------------------------------------------
    ---------------- ���⴦��ʵ�ֱ��벻�ܳɶԳ��ֵ����񼯺�----------
    --[[
        k: class1
        v: class2
    -]]
    for k, v  in pairs(questlib.EVERY_DAY_NOT_IN_TOGETHER) do
        --����ҵ���k,ȥ��v
        --����ҵ���v,ȥ��k
        --���ҵ��Ͳ�����
        --[[
            m: ��ţ�������
            n: ����ID
        -]]
        local bFindK = false
        local bFindV = false
        local idxV = 0
        local diffV = 0
        for m, n in pairs(tSelectQuest) do
            local questInfo = questlib.GetQuestInfo(questlib.QUEST_TYPE.EVERYDAY, n)
            if(questInfo ~= nil) then

                if(bFindK == false) then
                    if(k == questInfo.condition.class) then
                        bFindK = true
                    end
                end

                if(bFindV == false) then
                    if(v == questInfo.condition.class) then
                        idxV = m
                        diffV = questInfo.difficulty
                        bFindV = true
                    end
                end

                if(bFindK == true and bFindV == true) then
                    break
                end
            end
        end

        --ͬʱ���ڣ�ȥ�滻�ڶ���
        if(bFindK == true and bFindV == true) then
            --ѭ�����������б�
            --[[
                i: ����id
                j����������
            ]]
            for i, j in pairs(questlib.questList[questlib.QUEST_TYPE.EVERYDAY]) do
                local questClass = j.condition.class     --����Class
                local difficulty = j.difficulty          --�����Ѷ�

                --ƥ����ͬ���Ѷ�
                if(j.difficulty == diffV) then
                    local bFind2 = findUsedClass(questClass,usedClass)
                    --������û�ù����滻��֮ǰ��
                    if(bFind2 == false and findIsExists(i) == false) then
                        if(findIsMustNot(i) == false) then
                            tSelectQuest[idxV] = i
                            usedClass[idxV] = questClass
                            break
                        end
                    end
                end
            end
        end
    end
	return tSelectQuest
end

--�õ�������Ѷ�ϵ��
questlib.GetRoomNanDuXiShu = function()
    local peilv = groupinfo.gamepeilv

    if(questlib.ROOM_NANDUXISHU[peilv] == nil) then
        --TraceError("ERROR�������Ѷ�ϵ��δ�ҵ���Ӧ��������ֵ��ȡĬ��ֵ 1")
        return 1
    end
    return questlib.ROOM_NANDUXISHU[peilv]
end

-------------------------------------------------------------------------------
--�յ���������״̬
questlib.net_OnRecvQuestPhase = function(buf)
    local userKey = getuserid(buf)
    local userinfo = userlist[userKey]

    --������������������ճ�
    local quest_phase = 0
    if(not gamepkg.GetBeginnerGuideRate or gamepkg.GetBeginnerGuideRate(userinfo) == 0) then
        quest_phase = 1
    end
    
    --֪ͨ�Ƿ���ʾ�ճ����������������δ��ɾͲ���ʾ
    questlib.net_OnSendQuestPhase(userinfo, quest_phase)
end


--�����б�
cmdHandler = 
{
	------------------------- �ճ����� ----------------------------
    ["RQRG"] = questlib.net_OnRecvEveryDayQuest,         --�յ�����ˢ������ [from client]
    ["RQQP"] = questlib.net_OnRecvQuestPhase,            --�յ�������������
    ["RQTC"] = questlib.net_OnRecvEDQuestPrize,          --�յ���ȡ�������� [from client]
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end
