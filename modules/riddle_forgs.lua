TraceError("init riddle_forgs....")

if not gsriddlelib then
	gsriddlelib = _S
	{
        checker_datevalid           = NULL_FUNC,			--ʱ��У��
        ontimecheck                 = NULL_FUNC,			--�Զ���ʱ
        sendToGameCenter            = NULL_FUNC,			--������Ϣ��gamecenter
        OnRecvQueryTimeFromClient   = NULL_FUNC,			--�յ��ͻ��˲�ѯʣ��ʱ��
        OnRecvQueryRiddleFromClient = NULL_FUNC,			--�յ��ͻ��˲�ѯ��Ŀ����
        OnRecvAnswerFromClient	    = NULL_FUNC,			--�յ��ͻ��˵Ĵ�����
        OnSendAnswerResultToClient  = NULL_FUNC,			--���ʹ��������ͻ���
        OnRecvRiddleFromGC          = NULL_FUNC,			--�յ����µ�������Ϣ
		OnRecvAnswerRiddleFromGC	= NULL_FUNC,			--�յ�У����
        OnRecvRiddleOverFromGC      = NULL_FUNC,			--�յ��㲥���˴����
		riddlelist = {},--�����б�
        curr_riddle = {},
        prize_gold = 5000,  --��Խ���
        --�����ݿ��ж�ȡ������Ϣ
        timelib.createplan(function()
            dblib.execute("select * from configure_riddles_info order by id asc; ",
                function(dt)
                    if not dt or #dt <= 0 then return end;
                    local riddlelist = gsriddlelib.riddlelist;
                    for i = 1, #dt do
                        local riddle_item = {};
                        riddle_item["id"] = dt[i]["id"];
                        riddle_item["riddles_name"] = dt[i]["riddles_name"];
                        riddle_item["riddles_answer"] = dt[i]["riddles_answer"];
                        riddle_item["is_over"] = dt[i]["is_over"];
                        riddle_item["sys_time"] = dt[i]["sys_time"];
                        riddle_item["user_id"] = dt[i]["user_id"];
                        riddle_item["user_nick"] = dt[i]["user_nick"];
                        riddle_item["left_time"] = 0;
                        table.insert(riddlelist, riddle_item);
                    end
                    --��ѯĿǰ��������Ϣ
                    gsriddlelib.sendToGameCenter(
                        function(buf)
                            buf:writeString("RQRIDDL");
                        end);
                end
            )
        end,
    3);
	}
end
--�ж�ʱ��ĺϷ���
gsriddlelib.checker_datevalid = function()
	local starttime = os.time{year = 2011, month = 2, day = 17,hour = 0};
	local endtime = os.time{year = 2011, month = 2, day = 19,hour = 0};
	local sys_time = os.time()
    if(sys_time < starttime or sys_time > endtime) then
        return false
	end
    return true
end
--�Զ��ݼ���Ŀ��ʣ��ʱ��
gsriddlelib.ontimecheck = function()
    --���ʱ��Ϸ���
    if not gsriddlelib.checker_datevalid() then
        return
    end
    local riddle_item = gsriddlelib.curr_riddle;
    if not riddle_item or not riddle_item["left_time"] then return end;

    --���ٴ���ʱ��
    if(riddle_item["left_time"] >= 1) then
        riddle_item["left_time"] = riddle_item["left_time"] - 1;
    else
        --����û��ɵ���Ŀ��Ҫ������gamecenter��ѯ
        local riddlelist = gsriddlelib.riddlelist;
        for i = 1, #riddlelist do
            if(riddlelist[i]["is_over"] == 0) then  
                gsriddlelib.sendToGameCenter(
                    function(buf)
                        buf:writeString("RQRIDDL");
                    end);
                break;
            end
        end
    end
end

--������Ϣ��gamecenter
gsriddlelib.sendToGameCenter = function(func_send)
    cmdHandler["SENDTOGAMECENTER"] = nil;
    cmdHandler["SENDTOGAMECENTER"] = func_send;
    tools.SendBufToGameCenter(getRoomType(), "SENDTOGAMECENTER");
end

--�յ�gamecenter���صĵ�ǰ����
gsriddlelib.OnRecvRiddleFromGC = function(buf)
    --TraceError("OnRecvRiddleFromGC")
    --���ʱ��Ϸ���
    if not gsriddlelib.checker_datevalid() then
        return
    end
    local riddle_item = {};
    riddle_item["id"] = buf:readInt();
    riddle_item["left_time"] = buf:readInt();
    riddle_item["is_over"] = buf:readInt();
    if(riddle_item["is_over"] == 2)then  --�����ȴ����
        riddle_item["user_id"] = buf:readInt();
        riddle_item["user_nick"] = buf:readString();
        riddle_item["sys_time"] = buf:readString();
    end

    gsriddlelib.curr_riddle = nil; --���赱ǰ��Ŀ
    local riddlelist = gsriddlelib.riddlelist;
    for i = 1, #riddlelist do
        if(riddlelist[i]["id"] == riddle_item["id"]) then
            riddlelist[i]["left_time"] = riddle_item["left_time"];
            riddlelist[i]["is_over"] = riddle_item["is_over"];
            if(riddle_item["is_over"] == 2)then  --�����ȴ����
                riddlelist[i]["user_id"] = riddle_item["user_id"];
                riddlelist[i]["user_nick"] = riddle_item["user_nick"];
                riddlelist[i]["sys_time"] = riddle_item["sys_time"];
            end
            gsriddlelib.curr_riddle = riddlelist[i];
            break;
        end
    end
end

--�յ�gamecenter����������֤���
gsriddlelib.OnRecvAnswerRiddleFromGC = function(buf)
    --TraceError("OnRecvAnswerRiddleFromGC")
    --���ʱ��Ϸ���
    if not gsriddlelib.checker_datevalid() then
        return
    end
    local userid = buf:readInt();
    local retcode = buf:readInt();  --1����ɹ���2��Ŀ���ڣ�3�����ȴ���
    local riddle_item = {};
    riddle_item["id"] = buf:readInt();
    riddle_item["is_over"] = buf:readInt();
    if(riddle_item["is_over"] == 2)then  --�����ȴ����
        riddle_item["user_id"] = buf:readInt();
        riddle_item["user_nick"] = buf:readString();
        riddle_item["sys_time"] = buf:readString();
    end

    --ˢ����Ŀ״̬
    local riddlelist = gsriddlelib.riddlelist;
    for i = 1, #riddlelist do
        if(riddlelist[i]["id"] == riddle_item["id"]) then
            riddlelist[i]["is_over"] = riddle_item["is_over"];
            if(riddle_item["is_over"] == 2)then  --�����ȴ����
                riddlelist[i]["user_id"] = riddle_item["user_id"];
                riddlelist[i]["user_nick"] = riddle_item["user_nick"];
                riddlelist[i]["sys_time"] = riddle_item["sys_time"];
            end
            break;
        end
    end

    local userinfo = usermgr.GetUserById(userid);
    if not userinfo then return end;  --������������ſ��Դ���
    --���������
    if(retcode == 1)then
        local addgold = gsriddlelib.prize_gold or 5000 --����1�����
        gsriddlelib.OnSendAnswerResultToClient(userinfo, 1, riddle_item, addgold);
        usermgr.addgold(userinfo.userId, addgold, 0, g_GoldType.riddleprize or 1026, -1);
    elseif(retcode == 2)then
        --֪ͨ�����Ŀ������
        gsriddlelib.OnSendAnswerResultToClient(userinfo, 2, riddle_item, 0);
    elseif(retcode == 3)then
        --֪ͨ����������˴����
        gsriddlelib.OnSendAnswerResultToClient(userinfo, 3, riddle_item, 0);
    else
        TraceError("�����retcode="..tostring(riddle_item["retcode"]));
    end
end

--�յ�gamecenter�㲥���˴����
gsriddlelib.OnRecvRiddleOverFromGC = function(buf)
    --TraceError("OnRecvRiddleOverFromGC")
    --���ʱ��Ϸ���
    if not gsriddlelib.checker_datevalid() then
        return
    end
    local riddle_item = {};
    riddle_item["id"] = buf:readInt();
    riddle_item["user_id"] = buf:readInt();
    riddle_item["user_nick"] = buf:readString();
    riddle_item["sys_time"] = buf:readString();

    --ˢ����Ŀ״̬
    local riddlelist = gsriddlelib.riddlelist;
    for i = 1, #riddlelist do
        if(riddlelist[i]["id"] == riddle_item["id"]) then
            riddlelist[i]["is_over"] = 2;
            riddlelist[i]["user_id"] = riddle_item["user_id"];
            riddlelist[i]["user_nick"] = riddle_item["user_nick"];
            riddlelist[i]["sys_time"] = riddle_item["sys_time"];
            --�㲥������,��ϲXXX��һ�����е��գ����XX��ҽ�����������ȷ��Ϊ"XX
            --BroadcastMsg(_U("��ϲ ")..riddle_item["user_nick"].._U(" ��һ�����е��գ���� "..gsriddlelib.prize_gold.." ���뽱����������ȷ��Ϊ�� ")..riddlelist[i]["riddles_answer"],0);
            BroadcastMsg(_U(tex_lan.get_msg(userinfo, "riddle_forgs_msg_1"))..riddle_item["user_nick"].._U(tex_lan.get_msg(userinfo, "riddle_forgs_msg_2")..gsriddlelib.prize_gold..tex_lan.get_msg(userinfo, "riddle_forgs_msg_3"))..riddlelist[i]["riddles_answer"],0);
            break;
        end
    end
end

--�յ���Ҳ�ѯ��Ŀ����
gsriddlelib.OnRecvQueryRiddleFromClient = function(buf)
    --TraceError("OnRecvQueryRiddleFromClient")
    --���ʱ��Ϸ���
    if not gsriddlelib.checker_datevalid() then
        return
    end
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;

    local riddle_item = gsriddlelib.curr_riddle;
    if not riddle_item then return end;
    netlib.send(function(buf)
        buf:writeString("RIDINFO");
        buf:writeInt(riddle_item["id"]);
        buf:writeInt(riddle_item["left_time"] + 1);
        buf:writeString(riddle_item["riddles_name"]);
        buf:writeInt(riddle_item["is_over"]);
        if(riddle_item["is_over"] == 2)then  --�����ȴ����
            buf:writeInt(riddle_item["user_id"]);
            buf:writeString(riddle_item["user_nick"] or "");
            buf:writeString(riddle_item["sys_time"] or "");
            buf:writeString(riddle_item["riddles_answer"]);
            buf:writeInt(gsriddlelib.prize_gold);
        end
    end,userinfo.ip,userinfo.port);
end

--�յ���Ҳ�ѯʣ��ʱ��
gsriddlelib.OnRecvQueryTimeFromClient = function(buf)
    --TraceError("OnRecvQueryTimeFromClient")
    --���ʱ��Ϸ���
    if not gsriddlelib.checker_datevalid() then
        return
    end
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;

    local riddle_item = gsriddlelib.curr_riddle;
    if not riddle_item or not riddle_item["id"] then return end;
    netlib.send(function(buf)
        buf:writeString("RIDQETM");
        buf:writeInt(riddle_item["id"]);
        buf:writeInt(riddle_item["left_time"] + 1);
    end,userinfo.ip,userinfo.port);
end

--�յ���Ҵ���
gsriddlelib.OnRecvAnswerFromClient = function(buf)
    --TraceError("OnRecvAnswerFromClient")
    --���ʱ��Ϸ���
    if not gsriddlelib.checker_datevalid() then
        return
    end
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end; 

    --��ֹ�����ҷ����ݰ�
    if(userinfo.lastanswer and os.time() - userinfo.lastanswer < 10)then
        --TraceError(format("���[%d]����%d��֮�󷽿ɼ�������!", userinfo.userId, userinfo.lastanswer + 10 - os.time()));
        return;
    else
        userinfo.lastanswer = os.time();
    end

    local user_answer = buf:readString();
    local riddle_item = gsriddlelib.curr_riddle;
    if not riddle_item then return end;
    --TraceError(format("�յ����[%d]�Ĵ�:%s,��ȷ��:%s", userinfo.userId, user_answer, riddle_item["riddles_answer"]));
    --TraceError(format("���Ƿ���ȷ:%s", tostring(user_answer == riddle_item["riddles_answer"])));
    if(user_answer == riddle_item["riddles_answer"])then
        if(riddle_item["is_over"] == 0) then
            gsriddlelib.sendToGameCenter(
                        function(buf)
                            buf:writeString("RQRIDAS");
                            buf:writeInt(riddle_item["id"]);
                            buf:writeInt(userinfo.userId);
                            buf:writeString(userinfo.nick);
                        end);
        elseif(riddle_item["is_over"] == 1)then
            gsriddlelib.OnSendAnswerResultToClient(userinfo, 2, riddle_item, 0);
        elseif(riddle_item["is_over"] == 2)then
            gsriddlelib.OnSendAnswerResultToClient(userinfo, 3, riddle_item, 0);
        end
    else
        gsriddlelib.OnSendAnswerResultToClient(userinfo, 4, riddle_item, 0);
    end
end

--���ʹ��������ͻ���
--retcode:1����ɹ���2��Ŀ�����ˣ�3���������ˣ�4����ˣ�5��������
gsriddlelib.OnSendAnswerResultToClient = function(userinfo, retcode, riddle_item, addgold)
    if not userinfo then return end;

    local riddles_answer = "";
    if(riddle_item["is_over"] ~= 0) then
        riddles_answer = riddle_item["riddles_answer"];
    end
    netlib.send(function(buf)
        buf:writeString("RIDANSW");
        buf:writeInt(retcode);
        buf:writeInt(addgold);
        buf:writeInt(riddle_item["id"]);
        buf:writeInt(riddle_item["is_over"]);
        buf:writeInt(riddle_item["user_id"] or 0);
        buf:writeString(riddle_item["user_nick"] or "");
        buf:writeString(riddle_item["sys_time"] or "");
        buf:writeString(riddles_answer);
        buf:writeInt(addgold or 0);
    end,userinfo.ip,userinfo.port);
end

--�����б�
cmdHandler = 
{
    --gamecenter
    ["RERIDDL"] = gsriddlelib.OnRecvRiddleFromGC,--�յ����ڴ��������ID
	["RERIDAS"] = gsriddlelib.OnRecvAnswerRiddleFromGC,--�յ���֤������
    ["BCRIDOV"] = gsriddlelib.OnRecvRiddleOverFromGC,--�յ����˴������

    --client
    ["RIDQETM"] = gsriddlelib.OnRecvQueryTimeFromClient, --�յ���Ҳ�ѯʣ��ʱ��
    ["RIDINFO"] = gsriddlelib.OnRecvQueryRiddleFromClient, --�յ���Ҳ�ѯ��Ŀ����
    ["RIDANSW"] = gsriddlelib.OnRecvAnswerFromClient, --�յ���Ҵ���
    
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end
