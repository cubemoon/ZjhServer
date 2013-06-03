 TraceError("texwelcom::::::::::::::::")


if not texwelclib then
    texwelclib = _S
    {
        net_send_show_welcome   = NULL_FUNC,
        net_send_rewards   = NULL_FUNC,
        on_recv_show_welcome   = NULL_FUNC,
        on_recv_get_reward   = NULL_FUNC,
        --sql���
        SQL = {
            insert_reward_info = "insert into huodong_tex_welcome_info(user_id, isget,getdate) values(%d,%d,%s)",
            update_reward_info = "update huodong_tex_welcome_info set isget=%d,getdate=%s where user_id = %d",
            select_reward_info = "select isget,getdate from huodong_tex_welcome_info where user_id = %d",
        },
        --����
        MINNUM = 700,
        MAXNUM = 1200,
    }
end

--�������ĵ��ݶ�����
function getRandGolds()
    local first_random = true
    local  random = function(min, max)
        if first_random then
            math.randomseed(os.clock()*1000)
            math.randomseed(math.random(1, 65536) + os.clock()*1000)
            math.random(min, max)
            first_random = false
        end
        return math.random(min, max)
    end

    local random_num = random(texwelclib.MINNUM, texwelclib.MAXNUM) --�õ������
    return random_num
end

--��õ�ǰ������
function getNowDate()
    local tableTime = os.date("*t",os.time())
    local date = tableTime.year.."-"..tableTime.month.."-"..tableTime.day
    TraceError("date:::"..date)
    return date
end

--֪ͨ�ͻ�����ʾ��ӭ����
function texwelclib.net_send_show_welcome(userinfo)
    netlib.send(
        function(buf)
            buf:writeString("TXWEL")
    end, userinfo.ip, userinfo.port)
end

--���������ȡ�ĵ��ݶ���
function texwelclib.net_send_rewards(userinfo,dous)
    TraceError("dous::::::::::"..dous);
    netlib.send(
        function(buf)
            buf:writeString("TXGETRW")
            buf:writeInt(dous)
    end, userinfo.ip, userinfo.port)
end

function texwelclib.on_recv_show_welcome(buf)
    --��ȡuserinfo����Ϊ�գ�ֱ�ӷ���
    local userinfo = userlist[getuserid(buf)]
    if not userinfo then
       return
    end
    --�ж���ҵ����Ƿ��Ѿ���ȡ����������û�У���֪ͨ��ʾ
    dblib.execute(string.format(texwelclib.SQL.select_reward_info, userinfo.userId),
                                function(dt)
                                    TraceError("::::::"..tostringex(dt))
                                    if #dt <= 0 then               --���ǿյģ�������Ϣ
                                         dblib.execute(string.format(texwelclib.SQL.insert_reward_info, userinfo.userId, 0,"0"),
                                          function(dt)
                                              texwelclib.net_send_show_welcome(userinfo)
                                          end)
                                    elseif dt[1]["isget"] == 0 then  --δ��ȡ��
                                         TraceError("δ��ȡ��:::::")
                                         texwelclib.net_send_show_welcome(userinfo)
                                    elseif dt[1]["getdate"] ~= getNowDate() then  --�Ѿ���ȡ���ˣ��ж���Ϣ�Ƿ������
                                         TraceError("��ȡ��������Ϣ�Ѿ�����::::")
                                         texwelclib.net_send_show_welcome(userinfo)
                                    end
                                end)
end

function texwelclib.on_recv_get_reward(buf)
    --��ȡuserinfo����Ϊ�գ�ֱ�ӷ���
    local userinfo = userlist[getuserid(buf)]
    if not userinfo then
       return
    end
    --�ж������ȡ�Ƿ�Ϸ������Ϸ�(δ��ȡ��)
    --��֪ͨ��ȡ����ˢ���ܵĵ��ݶ���������¼������Ѿ���ȡ
    dblib.execute(string.format(texwelclib.SQL.select_reward_info, userinfo.userId),
                            function(dt)
                                if #dt > 0 and (dt[1]["isget"] == 0 or dt[1]["getdate"] ~= getNowDate()) then                
                                    local golds = getRandGolds();
                                    usermgr.addgold(userinfo.userId, golds, 0, g_GoldType.jifenhuodong, -1)
                                    --��¼
                                    dblib.execute(string.format(texwelclib.SQL.update_reward_info, 
                                                                1, 
                                                                dblib.tosqlstr(getNowDate()),
                                                                userinfo.userId))
                                    texwelclib.net_send_rewards(userinfo,golds)
                                else
                                    TraceError("����Ϊ�գ������Ѿ���ȡ��!!!!")
                                end
                            end)
end

----------------------------------------Э��------------------------------------------------
--�����б�
cmdHandler =
{
    ["TXWEL"]   = texwelclib.on_recv_show_welcome, --�յ��ͻ���������ʾ��ӭ����
    ["TXGETRW"] = texwelclib.on_recv_get_reward, --�յ��ͻ��������콱
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do
	cmdHandler_addons[k] = v
end