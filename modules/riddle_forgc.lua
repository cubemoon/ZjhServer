TraceError("init riddle_forgc....")

if not gcriddlelib then
	gcriddlelib = _S
	{
        checker_datevalid           = NULL_FUNC,			--ʱ��У��
        ontimecheck                 = NULL_FUNC,			--�Զ���ʱˢ��
        sendToGameServer            = NULL_FUNC,			--������Ϣ������gameserver
        sendToAllGameServer         = NULL_FUNC,			--������Ϣ��ȫ��gameserver
        OnRecvQueryRiddle           = NULL_FUNC,			--���������µ�������Ϣ
		OnRecvAnswerRiddle			= NULL_FUNC,			--����У���������ȷ��
        SendRiddleToGameServer      = NULL_FUNC,			--����һ�����⵽gameserver
		riddlelist = {},--�����б�
        curr_riddle = {},
        --�����ݿ��ж�ȡ������Ϣ
        timelib.createplan(function()
            dblib.execute("select * from configure_riddles_info order by id asc; ",
                function(dt)
                    if not dt or #dt <= 0 then return end;
                    local riddlelist = gcriddlelib.riddlelist;
                    for i = 1, #dt do
                        local riddle_item = {};
                        riddle_item["id"] = dt[i]["id"];
                        riddle_item["riddles_name"] = dt[i]["riddles_name"];
                        riddle_item["riddles_answer"] = dt[i]["riddles_answer"];
                        riddle_item["is_over"] = dt[i]["is_over"];
                        riddle_item["sys_time"] = dt[i]["sys_time"];
                        riddle_item["user_id"] = dt[i]["user_id"];
                        riddle_item["user_nick"] = dt[i]["user_nick"];
                        if(riddle_item["is_over"] == 0)then
                        	riddle_item["left_time"] = 600;  --TODO��600������
                        else
                        	riddle_item["left_time"] = 0;
                        end
                        table.insert(riddlelist, riddle_item);
                    end
                    table.disarrange(riddlelist);  --���ҵ��մ���
                    for i = 1, #riddlelist do
                        if(riddlelist[i]["is_over"] == 0) then
                            gcriddlelib.curr_riddle = riddlelist[i];
                            break;
                        end
                    end
                end
            )
        end,
    3);
	}
end
--�ж�ʱ��ĺϷ���
gcriddlelib.checker_datevalid = function()
	local starttime = os.time{year = 2011, month = 2, day = 17,hour = 0};
	local endtime = os.time{year = 2011, month = 2, day = 19,hour = 0};
	local sys_time = os.time()
    if(sys_time < starttime or sys_time > endtime) then
        return false
	end
    return true
end
--��ʱˢ������
gcriddlelib.ontimecheck = function()
    --���ʱ��Ϸ���
    if not gcriddlelib.checker_datevalid() then
        return
    end
    local riddle_item = gcriddlelib.curr_riddle;
    if not riddle_item or not riddle_item["left_time"] then return end;

    --�ݼ�����ʱ��
    riddle_item["left_time"] = riddle_item["left_time"] - 1;
    if(riddle_item["left_time"] > 0) then return end;

    if(riddle_item["is_over"] == 0) then
        --�����������
        riddle_item["is_over"] = 1;
        riddle_item["sys_time"] = os.date("%Y-%m-%d %X", os.time());
        --��¼���ݿ�
        local sql = "update configure_riddles_info set is_over = %d, sys_time = '%s' where is_over = 0 and id = %d; commit;";
        sql = format(sql, 1, riddle_item["sys_time"], riddle_item["id"]);
        dblib.execute(sql);
        --֪ͨ���еķ��������������
        for game, list in pairs(gamegroups) do
            for id,server in pairs(list) do
                gcriddlelib.SendRiddleToGameServer(tostring(game), tostring(id), riddle_item);
            end
        end
    end

    --ˢ�µ���һ��
    gcriddlelib.curr_riddle = nil;
    local riddlelist = gcriddlelib.riddlelist;
    for i = 1, #riddlelist do
        if(riddlelist[i]["is_over"] == 0) then
            gcriddlelib.curr_riddle = riddlelist[i];
            break;
        end
    end

    --֪ͨ���еķ���������ˢ����
    if(gcriddlelib.curr_riddle ~= nil)then
        for game, list in pairs(gamegroups) do
            for id,server in pairs(list) do
                gcriddlelib.SendRiddleToGameServer(tostring(game), tostring(id), gcriddlelib.curr_riddle);
            end
        end
    end
end

--����Ϣ��ָ������Ϸ������
gcriddlelib.sendToGameServer = function(func_send, szGameName, szGameSvrId)
    cmdHandler["SENDTOGAMESERVER"] = nil;
    cmdHandler["SENDTOGAMESERVER"] = func_send;
    local tGameSvrInfo = GetGameSvrInfoById(szGameName, szGameSvrId);
    if (tGameSvrInfo ~= nil) then
        tools.SendBufToGameSvr("SENDTOGAMESERVER", szGameSvrId, tGameSvrInfo.szSvrIp, tGameSvrInfo.nSvrPort);
    end
end

--����Ϣ��������Ϸ������
gcriddlelib.sendToAllGameServer = function(func_send)
    for game, list in pairs(gamegroups) do
        for id,server in pairs(list) do
            gcriddlelib.sendToGameServer(func_send, tostring(game), tostring(id));
        end
    end
end

--�յ�gameserver����������֤����������Ϣ
gcriddlelib.OnRecvAnswerRiddle = function(szGameName, szGameSvrId, buf)
    --TraceError("OnRecvAnswerRiddle")
    --���ʱ��Ϸ���
    if not gcriddlelib.checker_datevalid() then
        return
    end
	local tGameSvrInfo = GetGameSvrInfoById(szGameName, szGameSvrId);
    if not tGameSvrInfo then return end;
	local nId = buf:readInt();  --��ĿID
	local nUserId = buf:readInt();--���ID
	local sUserNick = buf:readString();--����ǳ�
	
	--�ҵ���Ӧ������
	local riddle_item = nil;
    local riddlelist = gcriddlelib.riddlelist;
	for k,v in pairs(riddlelist) do
		if(v.id == nId) then
			riddle_item = v;
			break;
		end
    end

    --û���ҵ�������
    if(not riddle_item)then return end;

    local retcode = -1;
    if(riddle_item["is_over"] == 0) then
        retcode = 1;
    elseif(riddle_item["is_over"] == 1)then
        retcode = 2;
    elseif(riddle_item["is_over"] == 2)then
        retcode = 3;
    else
        TraceError("�����is_over="..tostring(riddle_item["is_over"]));
    end

	--���ؽ��
    gcriddlelib.sendToGameServer(function(buf)
            buf:writeString("RERIDAS");
            buf:writeInt(nUserId);   --���ID
            buf:writeInt(retcode);   --�����Ƿ�ɹ�
            buf:writeInt(riddle_item["id"]);   --��Ŀ���
            buf:writeInt(riddle_item["is_over"]);--��Ŀ״̬
            if(riddle_item["is_over"] == 2)then  --�����ȴ����
                buf:writeInt(riddle_item["user_id"]);
                buf:writeString(riddle_item["user_nick"]);
                buf:writeString(riddle_item["sys_time"]);
            end
        end, szGameName, szGameSvrId);

    --���������Ƿ��ѹ��ڻ򱻲³�
	if(riddle_item["is_over"] ~= 0)then
        return;
    end

    --��һ��������ȷ�𰸵����
    riddle_item["is_over"] = 2;
    riddle_item["user_id"] = nUserId;
    riddle_item["user_nick"] = sUserNick;
    riddle_item["sys_time"] = os.date("%Y-%m-%d %X", os.time());
    --��¼���ݿ�
    local sql = "update configure_riddles_info set is_over = %d, user_id = %d, user_nick = '%s', sys_time = '%s' where id = %d; commit;";
    sql = format(sql, 2, nUserId, sUserNick, riddle_item["sys_time"], nId);
    dblib.execute(sql);

    --ȫ���㲥
    gcriddlelib.sendToAllGameServer(function(buf)
            buf:writeString("BCRIDOV");
            buf:writeInt(riddle_item["id"]);   --��Ŀ���
            buf:writeInt(riddle_item["user_id"]);
            buf:writeString(riddle_item["user_nick"]);
            buf:writeString(riddle_item["sys_time"]);
        end);
end

--�յ�gameserver��ѯ��ǰ����
gcriddlelib.OnRecvQueryRiddle = function(szGameName, szGameSvrId, buf)
    --TraceError("OnRecvQueryRiddle")
    --���ʱ��Ϸ���
    if not gcriddlelib.checker_datevalid() then
        return
    end
    local tGameSvrInfo = GetGameSvrInfoById(szGameName, szGameSvrId);
    if not tGameSvrInfo then return end;
    if not gcriddlelib.curr_riddle then return end;

    local riddle_item = gcriddlelib.curr_riddle;

	--���ؽ��
    gcriddlelib.SendRiddleToGameServer(szGameName, szGameSvrId, riddle_item);
end

--����һ�����⵽gameserver
gcriddlelib.SendRiddleToGameServer = function(szGameName, szGameSvrId, riddle_item)
    if (not riddle_item or not riddle_item["id"]) then return end;
    local tGameSvrInfo = GetGameSvrInfoById(szGameName, szGameSvrId);
    if not tGameSvrInfo then return end;

    gcriddlelib.sendToGameServer(function(buf)
            buf:writeString("RERIDDL");
            buf:writeInt(riddle_item["id"]);   --��Ŀ���
            buf:writeInt(riddle_item["left_time"]);   --ʣ�����ʱ��
            buf:writeInt(riddle_item["is_over"]);--��Ŀ״̬
            if(riddle_item["is_over"] == 2)then  --�����ȴ����
                buf:writeInt(riddle_item["user_id"]);
                buf:writeString(riddle_item["user_nick"]);
                buf:writeString(riddle_item["sys_time"]);
            end
        end, szGameName, szGameSvrId)
end
--�����б�
cmdHandler = 
{
    ["RQRIDDL"] = gcriddlelib.OnRecvQueryRiddle,--�������ڴ��������ID
	["RQRIDAS"] = gcriddlelib.OnRecvAnswerRiddle,--������֤������
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end
