if not gm_lib then
    gm_lib =
    {
        
        check_gm_cmd = NULL_FUNC, --�Ƿ���gmָ��
        send_gm_ret = NULL_FUNC, --����gmִ�н�����ͻ���
        gm_type = 
        {
            user = 0,   --һ���û�
            admin = 1,  --����Ա
            kefu = 2,   --�ͷ�                        
            
        },
        gm_cmd = 
        {
            micro_speak = 2,  --С����
            add_dx_user = 2,  --�����������˺ŵ�gmָ��
            change_car_rank = 1,  --�޸ĳ�������
        },
        account_info =   --gm�˺���Ϣ
        {
            {user_id = 106, pwd="123", open = 0, gm_type = 2},
            {user_id = 1073, pwd="1q3e2w", open = 0, gm_type = 1},
            {user_id = 26852373, pwd="dozen!*%", open = 0, gm_type = 2},
            
        },
        login_failed_rate = 100,
    }
end

--��ȡ�û��˺�����
gm_lib.get_user_info = function(user_id)
    local gm_info = {user_id = user_id, pwd="dozengame2012", open = 0, gm_type = 0}
    for k, v in pairs(gm_lib.account_info) do
        if (v.user_id == user_id) then
            gm_info = v
            break;
        end
    end
    return gm_info
end
--[[
    ����gmָ����
    user_id : gm�˺�id
    msg : gmִ�н��
--]]
gm_lib.send_gm_ret = function(user_id, msg)
    local user_info = usermgr.GetUserById(user_id)
    if (user_info == nil) then
        return 1
    end
    SendChatToUser(4, user_info, _U(msg), user_id, user_info.nick)
end

--gmָ��
gm_lib.check_gm_cmd = function(user_id, msg)
    local gm_user_info = gm_lib.get_user_info(user_id)
    if (gm_user_info.gm_type <= gm_lib.gm_type.user) then        
        return 0
    end
    local pre, cmd, args = string.match(msg, "(.*):(.*)%((.*)%)")
    if (pre == "gm") then --gmָ��
        if (cmd == "open" and args == gm_user_info.pwd) then
            gm_user_info.open = 1              
            gm_lib.send_gm_ret(user_id, "gm open");
            return 1
        elseif (cmd == "close") then
            gm_lib.send_gm_ret(user_id, "gm close");
            gm_user_info.open = 0
            return 1
        end
        if (gm_user_info.open == 0) then
            gm_lib.send_gm_ret(user_id, "warning! not open");
            return
        end
        if (gm_lib.gm_cmd[cmd] ~= gm_user_info.gm_type) then --���gmָ���Ƿ��ǿ���ʹ���ƶ���gm�˺�����
            gm_lib.send_gm_ret(user_id, "warning! error cmd");
            return
        end
        --��¼gmָ����־
        local sql = "insert into log_gm_record(user_id, cmd, args, sys_time) values(%d,'%s','%s',now())"
        sql = string.format(sql, user_id, cmd, args)
        dblib.execute(sql)
        --�ɷ�gmָ��
        gm_lib.send_gm_ret(user_id, "gm start "..cmd.."(".. args..")");
        eventmgr:dispatchEvent(Event("gm_cmd", {user_id = user_id, gm_type = gm_user_info.gm_type, cmd = cmd, args = split(args, ",")}))
        gm_lib.send_gm_ret(user_id, "gm end "..cmd.."(".. args..")");
        return 1
    end
    return 0
end
