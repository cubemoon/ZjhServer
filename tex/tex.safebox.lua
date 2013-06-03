tTexSafeBoxSqlTemplete =
{
    --�õ��������������
    getsafeboxagoldbout = "call sp_getuser_safebox_info(%d,%d,%d)",

    --�õ��������
    getsafeboxpwabout = "call sp_getuser_safebox_pwinfo(%d,%s,%s,%d)",

    --�����emailд�����ݿ�
    updateuseremail = "update users set email = %s where id = %d;commit;",
    --��ȡ�û�email
    getuseremail = "select email from users where id = %d;",
    --���±������������
    get_safebox_num = "select box_num from user_safebox_info where user_id = %d",
    --���±������������
    update_safebox_num = "update user_safebox_info set box_num = box_num + %d where user_id = %d and box_num <= 20- %d;",
}
tTexSafeBoxSqlTemplete = newStrongTable(tTexSafeBoxSqlTemplete)

texSafeBoxCfg = _S{
    EXCHANGERADIO = 10000;--�һ�����
    GETMINGOLD = 1,--ȡ������СǮ��
    STOREMINGOLD = 1,--�������СǮ��
    BOXNUM = 1,--�����������
    PERBOXGOLD = 5000,--ÿ������������Ǯ��
}

--������ӿڣ��Ժ����������¼���Ĵ��붼д������ӿ�
if (safebox_lib == nil) then
    safebox_lib = 
    {
        add_safebox_num = NULL_FUNC,
        MAX_BOX_NUM = 20,   --����������������
    }
end

--����һ�������������
function safebox_lib.add_safebox_num(user_id, box_num)
    if (box_num <= 0) then
        TraceError("���󣬱��������ΪʲôҪ����")
    end
    local sql = ""
    local user_info = usermgr.GetUserById(user_id)
    if not user_info.safeboxnum then return end
    if (user_info ~= nil) then --��֤��������������ᳬ��20��
        if (user_info.safeboxnum + box_num > 20) then
            box_num = 20 - user_info.safeboxnum
        end
        user_info.safeboxnum = user_info.safeboxnum + box_num
        sql = string.format(tTexSafeBoxSqlTemplete.update_safebox_num, box_num, user_id, box_num)
        dblib.execute(sql, nil, user_id)
    else
        local sql2 = string.format(tTexSafeBoxSqlTemplete.get_safebox_num, user_id)
        dblib.execute(sql2, function(dt)
            if (dt and #dt > 0) then
                if (dt[1].box_num + box_num > 20) then
                    box_num = 20 - dt[1].box_num
                end
                sql = string.format(tTexSafeBoxSqlTemplete.update_safebox_num, box_num, user_id, box_num)
                dblib.execute(sql, nil, user_id)
            end 
        end)
    end
    
end

--�������������Ϣ
function onrecvclicksafebox(buf)    
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    --����������㲻����,������
    if userinfo.desk and userinfo.desk > 0 then
        return
    end

    dblib.execute(string.format(tTexSafeBoxSqlTemplete.getsafeboxagoldbout,userinfo.userId,0,0),
        function(dt)
            if dt and #dt > 0 then
                if dt[1]["result"] == 0 or dt[1]["result"] == 1 then
                    if not userinfo.safeboxnum then
                        userinfo.safeboxnum = dt[1]["box_num"]        --texSafeBoxCfg.BOXNUM
                    end
                end

                if dt[1]["result"] == 0 then--û����ӹ��������һ��
                    userinfo.safegold = 0--д���ڴ�
                    net_send_user_safebox_case(userinfo,1)
                elseif dt[1]["result"] == 1 then--�Ѿ����˱�����
                    userinfo.safegold = dt[1]["safe_gold"]--д���ڴ�

                    dblib.execute(format(tTexSafeBoxSqlTemplete.getuseremail, userinfo.userId), function(dt1)
                		if not dt1 or #dt1 <= 0 then return end
                		userinfo.email = dt1[1]["email"]

                        if not userinfo.email or userinfo.email == "" then
                            --3 û�����ù���������û�
                            net_send_user_safebox_case(userinfo,3,dt[1]["safe_gold"])   
                        else
                            --2 ���������û�
                            net_send_user_safebox_case(userinfo,2,dt[1]["safe_gold"])
                        end
                	end)
                    eventmgr:dispatchEvent(Event("on_get_safebox_info", _S{user_info=userinfo}));
                elseif dt[1]["result"] == -1 then--���ݿ�û�и��˵ļ�¼
                    net_send_user_safebox_case(userinfo,0)
                end
            else
                TraceError("��ѯ�û����������ݳ���")
            end
        end)
end
--��ȡ����ڹ�ȥ30��������Ӯ��Ǯ��
function gethalfhourwintotal(userinfo)
    local totalwin = 0
    local lists = userinfo.extra_info["F09"] or {}
    local interval = userinfo.extra_info["F09"].interval or 0  --ʱ����
    for _, item in pairs(lists) do
        if(type(item) == "table") then
            if(os.time() - item.gametime < interval) then
                totalwin = totalwin + item.wingold
            end
        end
    end

    return totalwin
end
--�����ȡ��Ϸ��
function onrecvchangesafeboxgold(buf)
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    if not userinfo.safegold then return end
    if not userinfo.safeboxnum then return end

    --����������㲻����,������
    if userinfo.desk and userinfo.desk > 0 then
        return
    end  

    if userinfo.iscuning then--�Ѿ��ڰ����Ǯ���Ժ���ܴ�ȡ
        TraceError(format("���������ڴ�ȡ�����Ժ�...userid[%d]",userinfo.userId))
        return
    end

    userinfo.iscuning = 1--����������ڴ�ȡǮ
    
    local nType = buf:readByte()

    if nType ~= 0 and nType ~= 1 then
        TraceError("�Ƿ������ִ���" .. nType)
        userinfo.iscuning = nil
        return
    end

    local gold = buf:readInt()--�������Ǹ�������Ľ��
    gold = math.floor(math.abs(gold))

    local pwd = ""
    if nType == 1 then
        pwd = buf:readString()
    end

    if nType == 0 then --��Ǯ
        if userinfo.desk and userinfo.desk > 0 then
            TraceError("������ڷ������Ǯ?������?")
            userinfo.iscuning = nil
            return
        end

        if gold * texSafeBoxCfg.EXCHANGERADIO > userinfo.gamescore then
            TraceError(format("���Դ��������Ǯ���Ǯ,userid[%d]", userinfo.userId))
            userinfo.iscuning = nil
            return
        end
        
        if userinfo.safegold + gold > userinfo.safeboxnum * texSafeBoxCfg.PERBOXGOLD then
            TraceError("�Ѿ�������������,����ˡ���")
            userinfo.iscuning = nil
            return
        end
        local extra_info = userinfo.extra_info
        local lasttime = extra_info["F09"] and extra_info["F09"].last_time or 0
        local interval = extra_info["F09"].interval or 1800
        local lefttime = lasttime + interval - os.time()
        --��ȥӮ�˵ĳ��룬�����ĳ��붼�ܹ�����
        local cansavegold = userinfo.gamescore - gethalfhourwintotal(userinfo)
        if(lefttime > 0 and cansavegold < gold * 10000 ) then
            net_send_lefttime_cansave(userinfo, lefttime)
            userinfo.iscuning = nil
            return
        end
        docheckandchangegold(userinfo,gold,nType)
    else--ȡǮ
        if gold > userinfo.safegold then
            TraceError(format("����ȡ�߱��Լ���������Ǯ,userid[%d]", userinfo.userId))
            userinfo.iscuning = nil
            return
        end

        dblib.execute(string.format(tTexSafeBoxSqlTemplete.getsafeboxpwabout,userinfo.userId,dblib.tosqlstr(pwd),dblib.tosqlstr(''),2),
            function(dt)
                if #dt > 0 then
                    if dt[1]["success"] == 1 then
                        docheckandchangegold(userinfo,gold,nType)                   
                    else
                        net_send_getgoldpw_case(userinfo)--�����������
                        userinfo.iscuning = nil
                    end
                else
                    TraceError("��֤�û�����ʧ��")
                    net_send_getgoldpw_case(userinfo)
                    userinfo.iscuning = nil
                end
           end, userinfo.userId)
    end
end

--�жϱ����������Ƿ���ȷ
function check_safebox_pwd(user_id,password,call_back)
	if(call_back==nil)then return end;
	local sql=string.format(tTexSafeBoxSqlTemplete.getsafeboxpwabout,user_id,dblib.tosqlstr(password),dblib.tosqlstr(''),2)
    dblib.execute(sql,
        function(dt)
            if dt and #dt > 0 then
                if dt[1]["success"] == 1 then
                    call_back(user_id,1)--���߻ص��ķ���������У��ͨ����
                else
                	call_back(user_id,-1)--���߻ص��ķ������������
                end                                       
            else
            	call_back(user_id,-2)--���߻ص��ķ���������û��ͨ������
            end
       end, user_id)	
end

--���͸�����ҽ��
function docheckandchangegold(userinfo,gold,nType)
    dblib.execute(string.format(tTexSafeBoxSqlTemplete.getsafeboxagoldbout,userinfo.userId,gold,nType + 1),
        function(dt)
            if dt and #dt > 0 then
                if dt[1]["success"] == 1 then
                    --�Ӽ�Ǯ���ŵ��洢������ȥֱ�Ӵ���
                    if nType == 1 then
                        userinfo.safegold = userinfo.safegold - gold
                        userinfo.gamescore = userinfo.gamescore + gold*texSafeBoxCfg.EXCHANGERADIO
                        --֪ͨ�Լ�
        				
                        --usermgr.addgold(userinfo.userId,(gold * texSafeBoxCfg.EXCHANGERADIO), 0, 80, -1, 1)
                    else
                        userinfo.safegold = userinfo.safegold + gold
                        userinfo.gamescore = userinfo.gamescore - gold*texSafeBoxCfg.EXCHANGERADIO
                        --usermgr.addgold(userinfo.userId,-(gold * texSafeBoxCfg.EXCHANGERADIO),0, 80, -1, 1)
                    end
        			net_send_user_new_gold(userinfo, userinfo.gamescore)
                    net_send_user_getsetgold_case(userinfo,1,userinfo.safegold)
                else
                    TraceError("���ִ�ȡǮ�����쳣,����ȡ�߱��Լ���������Ǯ")
                    net_send_user_getsetgold_case(userinfo,0,0)
                end
            else
                TraceError("��ȡǮ����")
            end
            userinfo.iscuning = nil
            --ץ����Ҫͬ��һ�����ݿ⣬����Ҫ��һ���¼�
            eventmgr:dispatchEvent(Event("on_safebox_sq", _S{userinfo=userinfo,nType=nType,gold=gold}));
            
        end, userinfo.userId)
end

--���������������
function onrecvsafeboxpassword(buf)
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;
    if not userinfo.safeboxnum then return end

    --����������㲻����,������
    if userinfo.desk and userinfo.desk > 0 then
        return
    end

    local nType = buf:readByte();

    if nType ~= 0 and nType ~= 1 and nType ~= 2 then--0��һ����������,1�޸�����,2.��������
        TraceError("�Ƿ������ִ���" .. nType)
        return
    end

    local oldpassword = buf:readString()
    local newpassword = ""
    local email = ""
    if nType == 1 then--1�޸�����,0��һ����������,2.��������
        newpassword = buf:readString()
    elseif nType == 0 or nType == 2 then
        email = buf:readString()
    end

    dblib.execute(string.format(tTexSafeBoxSqlTemplete.getsafeboxpwabout,userinfo.userId,dblib.tosqlstr(oldpassword),dblib.tosqlstr(newpassword),nType),
        function(dt)
            if dt and #dt > 0 then
                local flag = dt[1]["success"]
                if flag then
                    --��һ����������ʱ��¼������־
                    if nType == 0 then
                         --��emailд�����ݿ�
                        do_save_user_email(userinfo, email)
                        dblib.execute(string.format("insert into log_user_setpw_info(user_id,user_pw,sys_time) values(%d,%s,now())",userinfo.userId,dblib.tosqlstr(oldpassword)))
                    elseif nType == 1 then
                        dblib.execute(string.format("insert into log_user_setpw_info(user_id,user_pw,sys_time) values(%d,%s,now())",userinfo.userId,dblib.tosqlstr(newpassword)))
                    elseif nType == 2 then
                        flag = 3
                         --��emailд�����ݿ�
                        do_save_user_email(userinfo, email)
                    end
                    net_send_setpw_case(userinfo, flag)
                else
                    TraceError("���ݿⷵ��ֵ����") 
                end
            else
                TraceError("�����������ʧ��")
            end
        end)
end

--������ҵ������ַ
function onrecvgetuseremail(buf)
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return end;

    dblib.execute(format(tTexSafeBoxSqlTemplete.getuseremail, userinfo.userId), function(dt1)
        if not dt1 or #dt1 <= 0 then return end

        netlib.send(function(buf1)
            buf1:writeString("TXSBFE")
            buf1:writeString(dt1[1]["email"])--�������
        end,userinfo.ip,userinfo.port)

    end)
   
end

--����ҵ�emailд�����ݿ�
function do_save_user_email(userinfo,email)
    dblib.execute(string.format(tTexSafeBoxSqlTemplete.updateuseremail,dblib.tosqlstr(email),userinfo.userId),function(dt)end,userinfo.userId)
end
