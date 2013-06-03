

tTexAchieveSqlTemplete =
{
    --�õ��ɾ������������
    getachieveconfigure = "select * from configure_achievement_info",

    --д��־��¼��Ҵ�ɳɾ�
    loguserachieveinfo = "insert into log_user_getachievement_info(userid,achieveid,gettime,currlevel,gamename,getprize) values(%d,%d,now(),%d,%s,%d);commit;",
}

tTexAchieveSqlTemplete = _S(tTexAchieveSqlTemplete)

if not achievelib then
    achievelib = {
        onuser_login = NULL_FUNC, --�û���¼
        dogetuserachieveinfo = NULL_FUNC,--�õ���ҵĳɾ���Ϣ
        inituserachieveinfo = NULL_FUNC,--��ʼ����ҵĳɾ���Ϣ
        loadStrFromTable = NULL_FUNC,--���л���Ϊһ���ַ���
        loadTableFromStr = NULL_FUNC,--���ַ���ת��Ϊһ����
        setuserinfoandcache = NULL_FUNC,--д���ڴ��cache
        getcompleteachieve = NULL_FUNC,--�õ���ǰ��ɵĳɾ�ID
        getlastachieveinfo = NULL_FUNC,--����õ��ĳɾ�ID
        giveuserprize = NULL_FUNC,--���û�����
        onrecvgetcompleteachieve = NULL_FUNC,--�õ�����˵ĳɾ�ID
        onrecvgetlastcompleteachieve = NULL_FUNC,--�õ������ɵĳɾ�ID
        onrecvgetprize = NULL_FUNC,--����������ɺ󷢽�
        getcompleteachievefromdb = NULL_FUNC,--�����ݿ��еõ�����˵ĳɾ�ID

        net_send_user_completeachieve = NULL_FUNC,--�û���ɳɾ�
        net_send_user_lastgetachieve = NULL_FUNC,--����õ��������ɾ�
        net_send_completenum = NULL_FUNC,--��ɳɾ͵ĸ���
        net_send_completeid = NULL_FUNC,--��ɳɾ͵�ID����

        ACHIEVECFG_FROM_DB = {},
    }
    local initachievefromdb = function()
        timelib.createplan(function()
                dblib.execute(tTexAchieveSqlTemplete.getachieveconfigure,function(dt)
                        setAchieveCfg(dt)
                    end)
            end,2)
    end
    
    --�������ж�ȡ�ɾ�����
    initachievefromdb()
end

function setAchieveCfg(dt)
    --TraceError(dt)
    if dt and #dt > 0 then
        TraceError("��ȡ�ɾ�ϵͳ���óɹ�")
        for k,v in pairs(dt) do
            achievelib.ACHIEVECFG_FROM_DB[v["id"]] = v
        end
    else
        TraceError("��ȡ�ɾ�ϵͳ����ʧ��")
        --TraceError(dt)

    end
end

--��ʼ������ҵĳɾ���Ϣ
achievelib.inituserachieveinfo = function(userinfo)
    local tab = {}
    for k,v in pairs(achievelib.ACHIEVECFG_FROM_DB) do
        local cjinfo = {}
        cjinfo["countum"] = 0
        cjinfo["sumnum"] = 0
        cjinfo["isget"] = 0
        cjinfo["iscangive"] = 0
        cjinfo["gettime"] = 0
        tab[tonumber(v["id"])] = cjinfo
    end
    --TraceError(tostringex(tab))

    --д��cache���ڴ�
    achievelib.setuserinfoandcache(userinfo,tab,0)
end


achievelib.loadStrFromTable = function(tab)
    local keys = {}
	local strRet = ""
	for k, v in pairs(tab) do
		table.insert(keys, k)
	end
	table.sort(keys)
	for i = 1, #keys do
		local strLine = keys[i] .. "|"
		local t = tab[keys[i]]
		strLine = strLine .. t.countum .. "|"
		strLine = strLine .. t.sumnum .. "|"
		strLine = strLine .. t.isget .. "|"
        strLine = strLine .. t.iscangive .. "|"
		strLine = strLine .. t.gettime .. ";"
		strRet = strRet .. strLine
	end
	return strRet
end

achievelib.loadTableFromStr = function(str)
    if not str or str == "" then return nil end

    if string.sub(str, 1, 2) == "do" then
		return table.loadstring(str)
	else
		local retTable = {}
		local data = split(str, ";")
		for i = 1, #data do
			if (string.len(data[i]) ~= 0) then
				local lines = split(data[i], "|")
				local t = {}
				t.countum 	= tonumber(lines[2])
				t.sumnum	= tonumber(lines[3])
				t.isget 	= tonumber(lines[4])
                t.iscangive	= tonumber(lines[5])
				t.gettime 	= tonumber(lines[6])
				retTable[tonumber(lines[1])] = t
			end
		end
		return retTable
	end
end

achievelib.dogetuserachieveinfo = function(userinfo,achieveinfo)
    if string.len(achieveinfo) ~= 0 then
        local tAchieveInfo = achievelib.loadTableFromStr(achieveinfo)
        --��½ʱ���iscangive��0        
        for k,v in pairs(tAchieveInfo) do
            tAchieveInfo[k]["iscangive"] = 0
        end
       -- TraceError("achievelib.dogetuserachieveinfo" .. tostringex(tAchieveInfo))

        --д���ڴ��cache
        achievelib.setuserinfoandcache(userinfo,tAchieveInfo,0)
    else
        --TraceError("�״ε�½")
        achievelib.inituserachieveinfo(userinfo)
    end
end

--д��cache���ڴ�
achievelib.setuserinfoandcache = function(userinfo,tInfo,nType)
    if not userinfo then
        TraceError("û���û���Ϣ")
        return 
    end
    
    if not nType then
        TraceError("û������nType����")
        return
    end
    
    --дcache���ڴ�
    if nType == 0 then
        if userinfo.achieveinfo == nil then
            userinfo.achieveinfo = {}
        end
        
        if tInfo then
            userinfo.achieveinfo = table.clone(tInfo)
        end

        if tInfo then
            dblib.cache_set(gamepkg.table,{achieve_info = achievelib.loadStrFromTable(tInfo)},"userid", userinfo.userId)
        end 
    elseif nType == 1 then--д�ڴ�
        if userinfo.achieveinfo == nil then
            userinfo.achieveinfo = {}
        end
        
        if tInfo then
            userinfo.achieveinfo = table.clone(tInfo)
        end
    else--дcache
        if tInfo then
            dblib.cache_set(gamepkg.table,{achieve_info = achievelib.loadStrFromTable(tInfo)},"userid", userinfo.userId)
        end 
    end
end

--�õ���ǰ��ɳɾ�ID���
achievelib.getcompleteachieve = function(userinfo)
    local t = {}
    if userinfo.achieveinfo == nil then
        return t
    end

    for k,v in pairs(userinfo.achieveinfo) do
        if tonumber(v["isget"]) == 1 then
            local ret = {}
            ret["id"] = k
            ret["time"] = v["gettime"]
            table.insert(t,ret)
        end
    end

    table.sort(t,function(a,b)
        if a.time == b.time then
            return a.id > b.id
        end

        return a.time > b.time
    end)

    return t
end

--�õ�����õ�����ҳɾ�ID 
achievelib.getlastachieveinfo = function(userinfo,num)
    local t = {}
    if userinfo.achieveinfo == nil then
        return t
    end
    
    local completetable = achievelib.getcompleteachieve(userinfo)

    for i = 1,num do 
       if i > #completetable then
           table.insert(t,0)
       else
           table.insert(t,completetable[i])
       end
    end

    return t
end

--ĳ���ɾ���ɵĴ���
achievelib.updateuserachieveinfo = function(userinfo,id,isreset)
    if not userinfo or not userinfo.achieveinfo then return end

    if not achievelib.ACHIEVECFG_FROM_DB[id] then
        TraceError("���ݿ���û�����ø�ID ".. id)
        return
    end

    if not userinfo.achieveinfo[id] then
        TraceError("�û���Ϣ��û����Ӧ�ĳɾ�ID " .. id)
        return
    end

    --�õ���ҵȼ�
    local userlevel = usermgr.getlevel(userinfo)
    if userlevel < tonumber(achievelib.ACHIEVECFG_FROM_DB[id]["level"]) then
        --TraceError("�û�û�дﵽ�óɾ͵ĵȼ�,�����ɾ����,�쳣")
        return
    end

    if userinfo.achieveinfo[id].isget == 1 then
        --TraceError("�Ѿ�����˸óɾ�,������")
        return
    end

    --TraceError("ʲô�ɾ�id = " .. id)
    --[[
    if userinfo.achieveinfo[id].iscangive == 1 then
        --TraceError("�������ڷ�����,�ٴ�����һ��?")
        return
    end
    --]]

    --��д�ڴ�
    if tonumber(achievelib.ACHIEVECFG_FROM_DB[id]["count_type"]) == 0 then--�����ۼ�
        userinfo.achieveinfo[id].countum = userinfo.achieveinfo[id].countum + 1

        if tonumber(userinfo.achieveinfo[id].countum) >= tonumber(achievelib.ACHIEVECFG_FROM_DB[id]["count_num"]) then
            --�����һ�θĹ��Ļ���
            userinfo.achieveinfo[id].countum = achievelib.ACHIEVECFG_FROM_DB[id]["count_num"] - 1

            --�ȴ�����콱,���Ը��ɾͽ���
            userinfo.achieveinfo[id].iscangive = 1

            --�ӳٷ���,ֻ�ж���������ϲŻᷢ��
            achievelib.net_send_user_completeachieve(userinfo,id)
             --������Ϸ�¼�
            if(dhomelib) then
                xpcall(function() dhomelib.update_share_info(userinfo, id) end, throw)
            end
        end
    else--�����ۼ�
        if not isreset then
            TraceError("�����ۼƵ�û����������")
            return
        end
        if isreset == 0 then
            userinfo.achieveinfo[id].countum = userinfo.achieveinfo[id].countum + 1
        else
            userinfo.achieveinfo[id].countum = 0
        end

        if tonumber(userinfo.achieveinfo[id].countum) >= tonumber(achievelib.ACHIEVECFG_FROM_DB[id]["count_num"]) then
            userinfo.achieveinfo[id].countum = 0 
            userinfo.achieveinfo[id].sumnum = userinfo.achieveinfo[id].sumnum + 1

            if tonumber(userinfo.achieveinfo[id].sumnum) >= tonumber(achievelib.ACHIEVECFG_FROM_DB[id]["sum_num"]) then
                --�����һ�θĹ��Ļ���
                userinfo.achieveinfo[id].sumnum = achievelib.ACHIEVECFG_FROM_DB[id]["sum_num"] - 1

                --�ȴ�����콱,���Ը��ɾͽ���
                userinfo.achieveinfo[id].iscangive = 1

                --�ӳٷ���,ֻ�ж���������ϲŻᷢ��
                achievelib.net_send_user_completeachieve(userinfo,id)
                 --������Ϸ�¼�
                if(dhomelib) then
                    xpcall(function() dhomelib.update_share_info(userinfo, id) end, throw)
                end
            end
        end     
    end
    
    --д��cache
    achievelib.setuserinfoandcache(userinfo,userinfo.achieveinfo,2)
end

--���û�����
achievelib.giveuserprize = function(userinfo,id)
    if not userinfo or not userinfo.achieveinfo then return end
    
    if userinfo.achieveinfo[id].isget ~= 0 or userinfo.achieveinfo[id].iscangive ~= 1 then
        TraceError("��û�д�ɳɾ��������")
        return
    end

    --��ɳɾ�
    userinfo.achieveinfo[id].isget = 1
    userinfo.achieveinfo[id].iscangive = 0
    userinfo.achieveinfo[id].gettime = tonumber(os.time())

    --����
    local prizenum = math.abs(tonumber(achievelib.ACHIEVECFG_FROM_DB[id]["prize_count"]))
    if tonumber(achievelib.ACHIEVECFG_FROM_DB[id]["prize_type"]) == 0 then
        usermgr.addgold(userinfo.userId, prizenum, 0, g_GoldType.achievegive, -1, 1)
    end
    
    --д��cache
    achievelib.setuserinfoandcache(userinfo,userinfo.achieveinfo,2)

    --���������ɳɾ���Ŀ
    local completetable = achievelib.getcompleteachieve(userinfo)
    achievelib.net_send_completenum(userinfo,#completetable)

    --д����־
    --�õ���ҵȼ�
    local userlevel = usermgr.getlevel(userinfo)
    dblib.execute(string.format(tTexAchieveSqlTemplete.loguserachieveinfo,userinfo.userId,id,userlevel,dblib.tosqlstr(gamepkg.name),prizenum))
end
-----------------------------------�õ��û��ɾ���Ϣ------------------------------------
--�û���¼��ʱ��
if achievelib.onuser_login then
	eventmgr:removeEventListener("h2_on_user_login_forachieve", achievelib.onuser_login);
end

achievelib.onuser_login = function(e)
    --TraceError(e.data.data["achieve_info"])	
    local achievedata = e.data.data["achieve_info"] or ""
    achievelib.dogetuserachieveinfo(e.data.userinfo, achievedata)
end

eventmgr:addEventListener("h2_on_user_login_forachieve", achievelib.onuser_login);

---------------------------------------Э�����---------------------------------------
achievelib.net_send_user_completeachieve = function(userinfo,achieveid)
    netlib.send(
        function(buf)
            buf:writeString("TXAMCA")
            buf:writeInt(achieveid)--�ɾ�ID
        end,userinfo.ip,userinfo.port)
end

achievelib.net_send_user_lastgetachieve = function(userinfo,tab)
    netlib.send(
        function(buf)
            buf:writeString("TXAMZA")
            buf:writeInt(#tab)--�ɾ�ID����
            for i = 1,#tab do
                buf:writeInt(tab[i])
            end
        end,userinfo.ip,userinfo.port)
end

achievelib.net_send_completenum = function(userinfo,num)
    netlib.send(
        function(buf)
            buf:writeString("TXAMCN")
            buf:writeInt(num)--�ɾ�����
        end,userinfo.ip,userinfo.port)
end

achievelib.net_send_completeid = function(userinfo,tabid)
    netlib.send(
        function(buf)
            buf:writeString("TXAMCI")
            buf:writeInt(os.time())--ϵͳ��ǰʱ��
            buf:writeInt(#tabid)--�ɾ�ID����
            for i = 1,#tabid do
                buf:writeInt(tonumber(tabid[i]["id"]))
                buf:writeInt(tonumber(tabid[i]["time"]))
            end
        end,userinfo.ip,userinfo.port)
end

achievelib.onrecvgetcompleteachieve = function(buf)
    local userinfo = userlist[getuserid(buf)]
    if not userinfo or not userinfo.achieveinfo then return end

    local ntype = buf:readByte()
    local curruserid = 0
    if ntype == 1 then
        curruserid = buf:readInt()
    end

    local curruserinfo = usermgr.GetUserById(curruserid)

    local completetable = {}

    if ntype == 0 then
        completetable = achievelib.getcompleteachieve(userinfo)
        achievelib.net_send_completenum(userinfo,#completetable)
    else
        if curruserinfo and curruserinfo.achieveinfo then
            completetable = achievelib.getcompleteachieve(curruserinfo)
            achievelib.net_send_completeid(userinfo,completetable)
        else
            TraceError("������û���Ϣ�ڴ��Ѿ�������,ȥmemcache���")
            dblib.cache_get(gamepkg.table,"achieve_info","userid",curruserid,
                function(dt)
                    if dt and #dt > 0 then
                        local tCmpId = achievelib.getcompleteachievefromdb(dt[1]["achieve_info"])--��ɵĳɾ�ID����
                        achievelib.net_send_completeid(userinfo,tCmpId)
                    else
                        TraceError("��ȥ����ʧ��")
                    end
                end)
        end
    end
end


achievelib.getcompleteachievefromdb = function(str)
    local info = loadTableFromStr(str)

    local tCmpId = {}--��ɵĳɾ�ID����
    for k,v in pairs(info) do
        if tonumber(v["isget"]) == 1 then
            local ret = {}
            ret["id"] = k
            ret["time"] = v["gettime"]
            table.insert(tCmpId,ret)
        end
    end

    return tCmpId
end

achievelib.onrecvgetlastcompleteachieve = function(buf)
    local userinfo = userlist[getuserid(buf)]
    if not userinfo or not userinfo.achieveinfo then return end

    local lastachieves = achievelib.getlastachieveinfo(userinfo,3)--���3��
    if #lastachieves == 0 then
        TraceError("�����쳣,�����ܵ����鷢����")
        return
    end

    achievelib.net_send_user_lastgetachieve(userinfo,lastachieves)
end

achievelib.onrecvgetprize = function(buf)
    local userinfo = userlist[getuserid(buf)]
    if not userinfo or not userinfo.achieveinfo then return end

    local achieveid = buf:readInt()

    if not achievelib.ACHIEVECFG_FROM_DB[achieveid] then
        TraceError("���ݿ���û�����ø�ID " .. achieveid)
        return
    end

    if not userinfo.achieveinfo[achieveid] then
        TraceError("û����Ӧ�ĳɾ�ID " .. achieveid)
        return
    end

    achievelib.giveuserprize(userinfo,achieveid)
end


