
if matcheslib and matcheslib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", matcheslib.on_after_user_login)
end

if matcheslib and matcheslib.on_buy_chouma then
	eventmgr:removeEventListener("on_buy_chouma", matcheslib.on_buy_chouma)
end

if matcheslib and matcheslib.on_timer_second then
	eventmgr:removeEventListener("timer_second", matcheslib.on_timer_second)
end

if matcheslib and matcheslib.on_try_start_game then
    eventmgr:removeEventListener("on_try_start_game", matcheslib.on_try_start_game);
end

if matcheslib and matcheslib.on_server_start then
    eventmgr:removeEventListener("on_server_start", matcheslib.on_server_start);
end

if matcheslib and matcheslib.on_back_to_hall then
    eventmgr:removeEventListener("back_to_hall", matcheslib.on_back_to_hall);
end

if matcheslib and matcheslib.on_user_exit then
	eventmgr:removeEventListener("do_kick_user_event", matcheslib.on_user_exit)
end

if matcheslib and matcheslib.on_send_duokai_sub_desk then
    eventmgr:removeEventListener("on_send_duokai_sub_desk", matcheslib.on_send_duokai_sub_desk);
end

if matcheslib and matcheslib.on_after_fapai then
    eventmgr:removeEventListener("on_after_fapai", matcheslib.on_after_fapai);
end

if(matcheslib and matcheslib.on_sub_user_back_to_hall) then
    eventmgr:removeEventListener("on_sub_user_back_to_hall", matcheslib.on_sub_user_back_to_hall);
end

if(matcheslib and matcheslib.on_user_sitdown) then
    eventmgr:removeEventListener("site_event", matcheslib.on_user_sitdown);
end

if(matcheslib and matcheslib.on_force_game_over) then
    eventmgr:removeEventListener("on_force_game_over", matcheslib.on_force_game_over);
end
--------------------------------------------------------------------------------------
if not matcheslib then
    matcheslib  = _S{
        ---�������
        on_recv_match_list = NULL_FUNC, --�����ͱ����б�
        on_recv_join_match = NULL_FUNC, --����������
        on_recv_join_match_affirm = NULL_FUNC,  --ȷ�ϱ���
        on_recv_match_give_up = NULL_FUNC,   --�յ���������
        on_recv_match_rule = NULL_FUNC,    --�յ���������
        on_recv_continue_watch = NULL_FUNC, --�յ�������ս
        on_recv_tixing = NULL_FUNC, --�յ�gs���ķ�������Ϣ

        ---���緢��
        net_send_match_list = NULL_FUNC, --���ͱ����б�
        net_send_join_match = NULL_FUNC,    --�������������
        net_send_join_match_result = NULL_FUNC, --���ͱ���ȷ�Ͻ��
        net_send_user_match_list = NULL_FUNC,   --�����û��ѱ�����
        net_send_match_give_up = NULL_FUNC, --�����������
        net_send_match_coming = NULL_FUNC,  --����֪ͨ�ͻ��˱���������
        net_send_rule = NULL_FUNC,  --���ͱ�������
        net_send_match_win_list = NULL_FUNC, --���Ϳͻ����������Ӯ��

        --�ⲿ�ӿ�
        get_match_by_desk_no = NULL_FUNC, --���ݻ�ȡ������Ϣ
        get_user_match_desk_no = NULL_FUNC,--��ȡ�û���������

        --�ڲ��ӿ�
        get_blind_info_info = NULL_FUNC, --��ȡ����äע��Ϣ
        init_match = NULL_FUNC,     --��ʼ�������б�
        update_match_list = NULL_FUNC, --���±����б�
        get_all_match_list = NULL_FUNC, --��ȡ�������б�����Ϣ
        get_match_info = NULL_FUNC,     --��ȡ������Ϣ
        auto_join_desk = NULL_FUNC, --�Զ���������
        apply_desks = NULL_FUNC,
        save_user_list_info = NULL_FUNC,    --���汨����Ϣ
        create_manren_match_by_id = NULL_FUNC,      --���ݱ���ID�������˿������ķֳ�
        process_give_up   = NULL_FUNC,      --�����������
        update_match_bet = NULL_FUNC, --���±���äע
        check_time_match = NULL_FUNC, --��鶨����
        clear_match = NULL_FUNC,  --���һ������
        on_match_start  = NULL_FUNC,    --������ʼ
        send_tixing = NULL_FUNC,    --ȫ����������
        on_match_end = NULL_FUNC,
        let_watching_user_join_desk = NULL_FUNC,
        check_match_desk = NULL_FUNC,
        check_match_room = NULL_FUNC, --����Ƿ��������
        set_match_user_watch = NULL_FUNC,
        free_desks = NULL_FUNC,
        kou_fei = NULL_FUNC,    --�����۷�
        tui_fei = NULL_FUNC,    --�����˷�
        check_match = NULL_FUNC,    --������״̬�Ƿ�ɱ���
        check_user_condition = NULL_FUNC,   --�����������Ƿ���Բ���
        check_condition = NULL_FUNC,    --����������
        check_join_cost = NULL_FUNC,    --��鱨�����Ƿ��㹻
        check_duokai_condition = NULL_FUNC, --���࿪���
        join_match = NULL_FUNC,     --��������
        refresh_list = NULL_FUNC,   --ˢ���б�
        go_back_to_hall = NULL_FUNC, --���ش���
        notify_watcher_out = NULL_FUNC, --֪ͨ��ս����뿪

        --ϵͳ�¼�
        on_after_user_login = NULL_FUNC,
        on_buy_chouma = NULL_FUNC,
        on_send_buy_chouma = NULL_FUNC,
        on_timer_second = NULL_FUNC,
        on_try_start_game = NULL_FUNC,
        on_server_start = NULL_FUNC,
        on_back_to_hall = NULL_FUNC,
        on_user_exit = NULL_FUNC,
        
        --ȫ�ֱ���
        match_list_all = {},    ----��ŵ���ÿ�����͵ı���
        match_list = {},        --���ñ����б���Ϣ
        match_award_base = {},       --���н�����Ϣ
        match_award = {},       --���н�����Ϣ
        match_blind = {},       --äע��Ϣ
        desk_list = {},     --���������б���Ϣ
        user_list = {},     --�û��б�
        watch_list = {},    --������ս�б�
        match_win_list = {}, --�������а�
        refresh_match_list_time = 0,   --ˢ�±����б�ʱ��
        is_notify_refresh_match = 0,   --�Ƿ���Ҫ֪ͨ�û�ˢ�±����б�
        
        --���ò���
        CONFIG_REFRESH_TIME = 99999,    --�³�����ʣ���òų����ڿͻ��ˣ���λ:��
        
        CONFIG_WATCHING_COUNT = 50, --�������ӹ�ս��������

        CONFIG_PRE_JOIN_TIME = 120,--��ǰ120���Խ������

        CONDITION = {
            REQUIRE_LEVEL = 1,
            WORLD_POINT = 2,
            DIAMOND = 3,
            CHOUMA = 4,
            VIP = 5,
            SEX = 6,
        },
    }

    timelib.createplan(function()
        matcheslib.init_match();
    end, 2);
end

-----------------------------------------�������----------------------------------------------
function matcheslib.on_recv_match_list(buf)
    --���Դ���
    --[[
    if(os.time() - matcheslib.refresh_match_list_time < 2) then
        return;
    end
    --]]
    local user_info = userlist[getuserid(buf)];
    if not user_info or (user_info.open_match_tab ~= nil and os.time() - user_info.open_match_tab < 2) then return end;
    user_info.open_match_tab = os.time();

    matcheslib.net_send_match_list(user_info);
    matcheslib.net_send_match_win_list(user_info);
end

function matcheslib.on_recv_join_match(buf)
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;

    local id = buf:readString();
    local match_info = matcheslib.get_match_info(id);   --���ݱ�����IDȡ�ó�����Ϣ
    local result = 1;
    local baoming_match_info = nil;

    if(match_info == nil) then
        matcheslib.refresh_list(user_info);
        return;
    end
    
    result = matcheslib.check_match(match_info, result);                        --������״̬
    result = matcheslib.check_user_condition(user_info, match_info, result);    --�����������
    result, baoming_match_info = matcheslib.check_duokai_condition(user_info, match_info, result);
    
    if (result == 2) then   --��ѱ���ֱ�ӱ�����
        matcheslib.join_match(user_info, match_info);
    end

    matcheslib.net_send_join_match_result(user_info, result, match_info);  --�������

    if (result ~= 1) then   --��������߳ɹ�������Ѳ�ˢ��
        matcheslib.refresh_list(user_info);     --ˢ���б�
    end
    
end

function matcheslib.on_recv_join_match_affirm(buf)
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;

    local id = buf:readString();
    local match_info = matcheslib.get_match_info(id);
    local user_match_info = matcheslib.user_list[user_info.userId];
    local result = 3;
    local baoming_match_info = nil;
    
    result = matcheslib.check_match(match_info, result);                        --������״̬
    result = matcheslib.check_user_condition(user_info, match_info, result);    --�����������
    result = matcheslib.check_join_cost(user_info, match_info, result);         --�������Ƿ��㹻
    result, baoming_match_info = matcheslib.check_duokai_condition(user_info, match_info, result);
    
    if (result == 3 or result == 2) then   --����ͨ��������
        matcheslib.join_match(user_info, match_info);
    end

    local baoming_match_name = "";
    if(result == -10 and baoming_match_info ~= nil) then
        baoming_match_name = baoming_match_info.match_name;
    end

    matcheslib.refresh_list(user_info);     --ˢ���б�
    matcheslib.net_send_join_match_result(user_info, result, match_info, baoming_match_name);   --�������
    if(duokai_lib ~= nil and match_info and match_info.match_type == 1) then
        duokai_lib.update_sub_desk_info(user_info);
    end
end

function matcheslib.on_recv_match_give_up(buf)
    --TraceError("on_recv_give_up");
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;
    local match_id = buf:readString();
    matcheslib.process_give_up(user_info, match_id, 1);
end

function matcheslib.on_recv_match_rule(buf)
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;
    local match_id = buf:readString();
    matcheslib.net_send_rule(user_info, match_id);
end

function matcheslib.let_all_watching_user_join_desk(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil and match_info.watch_list ~= nil) then
        for desk_no, _ in pairs(match_info.watch_list) do
            matcheslib.let_watching_user_join_desk(desk_no, match_id);
        end
    end
end

function matcheslib.on_recv_continue_watch(buf)
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;
    local match_id = buf:readString();
    local deskno = user_info.desk;
    if(deskno == nil) then
        return;
    end
    --TraceError("on_recv_continue_watch~"..match_id..' deskno'..user_info.desk..' userId'..user_info.userId);

    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil and match_info.status < 4) then
        matcheslib.set_match_user_watch(match_id, deskno, user_info.userId);
        matcheslib.let_watching_user_join_desk(deskno, match_id);
    else
        --�����Ѿ�������,���ش�����
        matcheslib.go_back_to_hall(user_info);
        --TODO ֪ͨ�����Ѿ�����
    end
end

function matcheslib.on_recv_tixing(buf)
    --TraceError("on_recv_tixing");
    local user_info = usermgr.GetUserById(buf:readInt());
    if (user_info) then
        local match_id = buf:readString();
        local match_name = buf:readString();
        local time = buf:readInt();
        matcheslib.net_send_match_coming(user_info, match_id, match_name, time);
    end
end

-----------------------------------------���緢��----------------------------------------------
function matcheslib.net_send_match_list(user_info)
    if not user_info then return end;
    local length = 0;
    local user_match_info = matcheslib.user_list[user_info.userId];

    if(user_match_info == nil) then
        return;
    end

    local tmp_list = table.clone(matcheslib.match_list);

    --�����û��ı�����Ϣ
    for k, v in pairs(user_match_info.baoming_list) do
        if tmp_list[v.id] ~= nil then                --���������Ϣ�еı��� �� �����б��д���
            if (tmp_list[v.id].status == 1) then       --���ұ���Ϊδ��ʼ״̬
                tmp_list[v.id].status = 2;           --��ʾ�����û�ʱ����Ϊ������״̬
            elseif (tmp_list[v.id].status == 4) then     --�����Ѿ������ˣ���û���ü�ˢ�µ������ڰ���ȥ��
                tmp_list[v.id] = nil;
            end
        end
    end

    for _, _ in pairs(tmp_list) do
        length = length + 1;
    end

    netlib.send(function(buf)
        buf:writeString("MATCHTTLIST");
        buf:writeInt(length);
        for k, v in pairs(tmp_list) do
            buf:writeString(v.id);   --������id
            buf:writeString(v.match_name);--������
            buf:writeString(v.match_time);--������ʼʱ��
            buf:writeString(v.match_logo);--����logo
            buf:writeString(v.join_cost);--������������
            buf:writeInt(v.join_cost_num);--������������
            buf:writeInt(v.match_count);--��������
            buf:writeInt(v.status);--����״̬ 1 ���Ա��� 2 �Ѿ����� 3 ������
            buf:writeInt(v.match_type);--1Ϊ������, 2Ϊ������
            buf:writeInt(v.need_user_count);--��Ҫ����
            buf:writeInt(v.match_start_time - os.time());--����ʣ��ʱ��
            buf:writeInt(matcheslib.CONFIG_PRE_JOIN_TIME);
        end
    end, user_info.ip, user_info.port);
end

--�������
function matcheslib.net_send_join_match_result(user_info, result, match_info, baoming_match_name)
    if not user_info then return end;

    local condition = match_info.match_condition;
    netlib.send(function(buf)
        buf:writeString("MATCHTTJM");
        buf:writeString(match_info ~= nil and match_info.id or "");
        buf:writeString(match_info ~= nil and match_info.client_id or "");
        buf:writeInt(result);
        buf:writeString(match_info ~= nil and match_info.match_name or "");
        buf:writeString(match_info ~= nil and match_info.join_cost or "");
        buf:writeInt(match_info ~= nil and match_info.join_cost_num or 0);
        buf:writeInt(#condition);
        for k, v in pairs(condition) do     --���Ͳ�������
            buf:writeString(v);
        end
        buf:writeInt(match_info.satisfy_conditon);  --�Ƿ��������������ſɲ���
        buf:writeString(baoming_match_name or "");
    end, user_info.ip, user_info.port);
end

--�û��ѱ����б�Ϳɱ����б�
function matcheslib.net_send_user_match_list(user_info)
    if not user_info or not matcheslib.user_list[user_info.userId] then return end;
    --�ѱ���
    local user_match_list = matcheslib.user_list[user_info.userId].baoming_list;
    local length = 0;
    for k, v in pairs(user_match_list) do
        length = length + 1;
    end

    --�ɱ���
    local tmp_match = {};
    local no_length = 0;
    for k, v in pairs(matcheslib.match_list) do
        if (v.baoming_list[user_info.userId] == nil) then
            table.insert(tmp_match,v);
            no_length = no_length + 1;
        end
    end

    netlib.send(function(buf)
        buf:writeString("USERMATCHLIST");
        buf:writeInt(length);
        for k, v in pairs(user_match_list) do
            buf:writeString(length == 0 and "" or v.id);          --����id
            buf:writeString(length == 0 and "" or v.match_name);  --������
            buf:writeString(length == 0 and "" or v.match_time);  --������ʼʱ��
            buf:writeInt(length == 0 and 0 or v.status);          --����״̬
        end
        buf:writeInt(no_length);
        for k, v in pairs(tmp_match) do
            buf:writeString(no_length == 0 and "" or v.id);          --����id
            buf:writeString(no_length == 0 and "" or v.match_name);  --������
            buf:writeString(no_length == 0 and "" or v.match_time);  --������ʼʱ��
            buf:writeInt(no_length == 0 and 0 or v.status);          --����״̬
        end
    end, user_info.ip, user_info.port);
end

--�������
function matcheslib.net_send_match_give_up(user_info, match_info, msg_type)
    if not user_info or match_info == nil then return end;
    --TraceError("net_send_give_up");
    netlib.send(function(buf)
        buf:writeString("MATCHTTGIVEUP");
        buf:writeInt(msg_type);
        buf:writeString(match_info.join_cost);
        buf:writeInt(match_info.join_cost_num);
        buf:writeString(match_info.match_name);
        buf:writeString(match_info.match_time);
        buf:writeString(match_info.client_id or "");
    end,user_info.ip, user_info.port);
end

--֪ͨ�ͻ��˱�������ʱ
function matcheslib.net_send_match_coming(user_info, match_id, match_name, time, msg_type)
    if not user_info then return end;
    --TraceError("send_coming");
    netlib.send(function(buf)
        buf:writeString("MATCHCOMING");
        buf:writeString(match_id);
        buf:writeString(match_name);
        buf:writeInt(time);
        buf:writeInt(msg_type or 0);
    end,user_info.ip, user_info.port);
end

--��������
function matcheslib.net_send_rule(user_info, match_id)
    if not user_info then return end;
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info == nil) then
        matcheslib.refresh_list(user_info);
        return;
    end
    local condition = match_info.match_condition;
    local award = matcheslib.match_award_base[match_info.type_id];
    local award_length = 0;
    for _, _ in pairs(award) do
        award_length = award_length + 1;
    end

    netlib.send(function(buf)
        buf:writeString("MATCHTTRULE");
        buf:writeInt(#condition);
        for k, v in pairs(condition) do     --���Ͳ�������
            buf:writeString(v);
        end
        buf:writeInt(match_info.start_score);       --��ʼ����
        buf:writeInt(match_info.blind_stakes_time); --äע����ʱ��
        buf:writeInt(match_info.need_user_count);   --�����������
        buf:writeInt(match_info.satisfy_conditon);  --�Ƿ��������������ſɲ���
        
        buf:writeInt(award_length);     --���ͽ�������
        for k, v in pairs(award) do
            buf:writeString(k);         --����
            buf:writeInt(v.chouma)      --����
            buf:writeInt(v.diamond)     --��ȯ
            buf:writeString(v.others)   --����
        end

    end, user_info.ip, user_info.port);
end

--���Ӯ��
function matcheslib.net_send_match_win_list(user_info)
    if not user_info then return end;
    netlib.send(function(buf)
        local win_list = matcheslib.match_win_list;
        buf:writeString("MATCHWINLIST");
        buf:writeInt(#win_list);
        for k, v in pairs(win_list) do
            buf:writeInt(v.user_id);
            buf:writeString(v.nick);
            buf:writeString(v.face);
            buf:writeString(v.match_name);
            buf:writeString(v.sys_time);
            buf:writeInt(timelib.db_to_lua_time(v.sys_time));
            local prize_name = "";
            for k, v in pairs(v.prize_list) do
                if(prize_name ~= "") then
                    prize_name = prize_name .. "+";
                end
                if(v.prize_type == 10) then--��ȯ
                    prize_name = prize_name .. v.prize_value .. _U("��ȯ");
                elseif(v.prize_type == 9027) then --������
                    prize_name = prize_name .. v.prize_value .. _U("����");
                end
            end
            buf:writeString(prize_name);
        end
    end, user_info.ip, user_info.port);
end


-----------------------------------------�ⲿ�ӿ�----------------------------------------------

function matcheslib.get_user_join_match_num(user_info)
    local count = 0;
    if(not user_info) then
        return count;
    end
    local user_match_info = matcheslib.user_list[user_info.userId];
    local baoming_list = user_match_info.baoming_list;
    for match_id, v in pairs(baoming_list) do
        local match_info = matcheslib.get_match_info(match_id);
        if(match_info and match_info.match_type == 1 and match_info.status < 3) then
            count = count + 1;
        end
    end
    return count;
end

function matcheslib.get_user_match_desk_no(user_info, match_id)
    local desk_no = -1;--����������
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        if(match_info.match_type == 1 and match_info.status >= 3 or match_info.match_type == 2) then
            --��������������
            if(duokai_lib ~= nil) then
                local match_desk_list = match_info.desk_list;
                if(match_desk_list) then
                    for k, v in pairs(match_desk_list) do
                       local sub_user_id = duokai_lib.get_sub_user_by_desk_no(user_info.userId, k); 
                       if(sub_user_id ~= -1) then
                           desk_no = k;
                           break;
                       end
                    end
                end
            else
                desk_no = user_info.desk;
            end
        else
            --����δ��ʼ
            desk_no = -2;
        end
    end
    return desk_no;
end

function matcheslib.get_match_by_desk_no(desk_no)
    local match_id = matcheslib.desk_list[desk_no];
    if(match_id ~= nil) then
        return matcheslib.get_match_info(match_id);
    end
    return nil;
end


-----------------------------------------�ڲ��ӿ�----------------------------------------------

function matcheslib.get_blind_info(match_id, level)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil and matcheslib.match_blind[match_info.type_id] ~= nil) then
        return matcheslib.match_blind[match_info.type_id][level];
    end
    return nil;
end

function matcheslib.check_match_room()
    return tonumber(groupinfo.groupid) == 18001 and 1 or 0;
end

function matcheslib.init_match()
    matcheslib.get_all_match_list();
end

--���±����б�
function matcheslib.update_match_list()
    --���������б����б�
    matcheslib.get_all_match_list(function()
        local tableTime = os.date("*t",os.time()); --��ǰϵͳ����
        local curr_time = os.time();               --��ǰϵͳʱ��
    
        --�������б���table
        for k, v in pairs(matcheslib.match_list_all) do
            --vΪÿ�����ͱ�����table
            for i=1, #v do
                local id = v[i].id;
                local match_type = v[i].match_type;
                local type_id = v[i].type_id;
                local is_gen = 0;

                if(match_type == 2) then
                    --�������������ɵı������鿴�������Ƿ��Ѿ�����
                    for k1, v1 in pairs(matcheslib.match_list) do
                        if(v1.type_id == type_id) then
                            is_gen = 1;
                            break;
                        end
                    end
                end
                --��������б���û����������list
                if matcheslib.match_list[id] == nil and is_gen == 0 then
                    matcheslib.match_list[id] = v[i];
                end
            end
        end
    
        --������ǰ����table,������������status��Ϊ1
        for k, v in pairs(matcheslib.match_list_all) do
            for i=1, #v do
                local id = v[i].id;
                local match = matcheslib.match_list[id];
                local tmp_time = v[i].match_start_time;
                --��������б����иó�����������Ϊδ���������жϸñ����Ƿ񼴽�������true��״̬��Ϊ1,����break���ò�ѭ��
                if (match ~= nil) then
                    if (match.match_type == 2) then
                        tmp_time = v[i].match_end_time;
                    end
                    if (tmp_time  - curr_time >= 0 and 
                        tmp_time  - curr_time <= matcheslib.CONFIG_REFRESH_TIME) then--��ʱ��,����������ǰ��ʾ
                        if (match.status == 0) then
                            match.status = 1;
                            matcheslib.is_notify_refresh_match = 1;
                        end
                        break;
                    end
                end
            end
        end
    
        --�������б���table ɾ������ɺ�δ��ʼ�ı��� �����˿������ѿ����ټ���һ��
        for k, v in pairs(matcheslib.match_list_all) do
            for i=1, #v do
                local id = v[i].id;
                local match_info = matcheslib.match_list[id];
                if match_info ~= nil then
                    if (match_info.status == 4 or match_info.status == 0)then
                        matcheslib.free_desks(id);
                        matcheslib.match_list[id] = nil;
                        if(match_info.status == 4) then
                            matcheslib.is_notify_refresh_match = 1;
                        end
                    end
                end
            end
        end

        for k, v in pairs(matcheslib.match_list) do 
            if(v.status == 4) then 
                matcheslib.free_desks(k); 
                matcheslib.match_list[k] = nil; 
            end 
        end
    end);
end

function matcheslib.notify_all_refresh_match_list()
    if(matcheslib.is_notify_refresh_match == 1) then
        matcheslib.is_notify_refresh_match = 0;

        for k, v in pairs(userlist) do
            if(v.open_match_tab ~= nil) then
                matcheslib.refresh_list(v);
            end
        end
    end
end

--ȡ�õ�������б�
function matcheslib.get_all_match_list(callback)

    local tableTime = os.date("*t",os.time());          --��ǰϵͳ����
    local currtime = os.date("%y-%m-%d %X",os.time());  --��ǰϵͳʱ��
    matcheslib.match_list_all = {};

    --��ѯäע��Ϣ
    matches_db.get_match_blind(
        function(dt)
            for k, v in pairs(dt) do
                if matcheslib.match_blind[v.type_id] == nil then
                    matcheslib.match_blind[v.type_id] = {};
                end
                if matcheslib.match_blind[v.type_id][v.lv] == nil then
                    matcheslib.match_blind[v.type_id][v.lv] = {}
                end
                matcheslib.match_blind[v.type_id][v.lv].smallbet = v.small_blind;
                matcheslib.match_blind[v.type_id][v.lv].largebet = v.big_blind;
                matcheslib.match_blind[v.type_id][v.lv].ante = v.ante;
            end
        end);

    --��ѯ������Ϣ
    matches_db.get_match_award(
        function(dt)
            for k, v in pairs(dt) do
                local ranks = split(v.rank,"-");
                for i=tonumber(ranks[1]), tonumber(ranks[2]) do
                    if matcheslib.match_award[v.type_id] == nil then
                        matcheslib.match_award[v.type_id] = {};
                    end

                    matcheslib.match_award[v.type_id][i] = {};
                    if(v.chouma > 0) then
                        table.insert(matcheslib.match_award[v.type_id][i], {
                            prize_type = 9027,
                            prize_value = v.chouma,
                        });
                    end

                    if(v.diamond > 0) then
                        table.insert(matcheslib.match_award[v.type_id][i], {
                            prize_type = 10,
                            prize_value = v.diamond,
                        });
                    end
                    
                    if (v.others ~= "") then
                        table.insert(matcheslib.match_award[v.type_id][i], {
                            prize_type = split(v.others,":")[1],
                            prize_value = split(v.others,":")[2],
                        });
                    end
                end
            end

            for k, v in pairs(dt) do
                if (matcheslib.match_award_base[v.type_id] == nil) then
                    matcheslib.match_award_base[v.type_id] = {};
                end
                if (matcheslib.match_award_base[v.type_id][v.rank] == nil) then
                    matcheslib.match_award_base[v.type_id][v.rank] = {};
                end
                matcheslib.match_award_base[v.type_id][v.rank].chouma = v.chouma;
                matcheslib.match_award_base[v.type_id][v.rank].diamond = v.diamond;
                matcheslib.match_award_base[v.type_id][v.rank].others = v.others;
            end

        --���ҷ��ϱ������ڵ�����
            matches_db.get_match_list(
                function(dt)
                    --ȡ�õ������б�����������(dt��ÿһ����¼����һ�ֱ���)
                    for k, v in pairs(dt) do
                        local tmp_match = {};   --���ÿ�ֱ���
            
                        --�ָ����ʱ�䣬ÿ���ֺŴ���һ������
                        local times = split(v.match_time,";");
                        for ks,vs in pairs(times) do
                            local m = {};
                            m.type_id = v.type_id;          --��������id
                            m.id = v.type_id .."_"..os.date("%y-%m-%d",os.time()).."_"..vs;    --����id
                            m.client_id = m.id..os.time();		--�ر�ID ���ڷ�ֹ������������ɿͻ��˼�¼��ID����
                            m.match_name = v.match_name;    --������
                            m.match_time = vs;              --����ʱ��
                            m.match_logo = v.match_logo;    --ͼƬ
                            m.join_cost = split(v.join_cost,":")[1];  --������������
                            m.join_cost_num = #v.join_cost == 0 and 0 or split(v.join_cost,":")[2];    --������������
                            m.match_count = 0;  --��������(��ʼΪ0)
                            m.status = 0;       --����״̬(��ʼΪ0)
                            m.match_type = v.match_type;    --��������
                            m.need_user_count = v.need_user_count;      --��Ҫ������
                            m.is_giveback_cost = v.is_giveback_cost;    --�������㿪���Ƿ��˻�������
                            m.satisfy_conditon = v.satisfy_conditon;    --�Ƿ��������������ſɲ���
                            m.blind_stakes_time = v.blind_stakes_time;  --äע����ʱ��
                            m.blind_stakes_level = v.blind_stakes_level;    --äע��ʼ�ȼ�
                            local tmp_condition = split(v.match_condition,";");
                            m.match_condition = v.match_condition == "" and {} or tmp_condition;   --��������
 				            m.start_score = v.start_score;      --��ʼ����
                            m.ante = 0;

                            m.baoming_list = {};            --�����ó����������
                            m.tixing_list = {};
                            m.watch_list = {};
                            
                            --��ӱ�����os time���� start_time end_time ��������ʼ�ͽ���ʱ����ͬ
                            local d1_time;
                            local d2_time;
                            if(m.match_type == 1) then      
                                d1_time = split(m.match_time, ":");
                                d2_time = d1_time;         
                            elseif (m.match_type == 2) then
                                d1_time = split(split(m.match_time, "-")[1],":");
                                d2_time = split(split(m.match_time, "-")[2],":");
                            else
                                TraceError("�������ͳ���:"..m.match_time.."��"..m.match_name
                                           .."��������:"..m.match_type);
                            end
                            m.match_start_time = os.time{year = tableTime.year, month = tableTime.month,
                                        day = tableTime.day, hour = d1_time[1], min = d1_time[2]};
                            m.match_end_time = os.time{year = tableTime.year, month = tableTime.month,
                                        day = tableTime.day, hour = d2_time[1], min = d2_time[2]};
                                
                            --��������
                            if matcheslib.match_award[v.type_id] ~= nil then
                                m.award = matcheslib.match_award[v.type_id];    
                            else
                                m.award = {};
                            end

                            --äע����
                            if matcheslib.match_blind[v.type_id] ~= nil then
                                m.blind = matcheslib.match_blind[v.type_id];    
                            else
                                m.blind = {};
                            end

                            table.insert(tmp_match,m);
                        end
                        --��������ʱ����絽���������
                        table.sort(tmp_match, function(d1, d2)
                            return  d1.match_start_time < d2.match_start_time;
                        end);
                        --�������б�����table��
                        table.insert(matcheslib.match_list_all,tmp_match);
                    end
          
                    if(callback ~= nil) then
                        callback();
                    end
            end);
        end);
end

--ͨ������IDȡ������Ϣ
function matcheslib.get_match_info(id)
    local match_info = nil;
    for k, v in pairs(matcheslib.match_list) do
        if(v.id == id) then
            match_info = v;
            break;
        end
    end
    return match_info;
end

--[[
@param match_id ����id
@param match_user_list ���������û�
@param desk_list ���������б�
@param is_limit  �Ƿ�����ÿ��6��
@param callback ����֮ǰ�ص�
@param is_goto_game �Ƿ��л���������
@param need_desk_user_count ������������ٵ�����
]]--
function matcheslib.auto_join_desk(match_id, match_user_list, desk_list, 
                                   is_limit, callback, is_goto_game, 
                                   need_desk_user_count)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info == nil) then
        TraceError('�����Ѿ������ˣ�Ϊʲô���Ŷ�');
        return;
    end
    if(need_desk_user_count == nil) then
        need_desk_user_count = 0;
    end
    --��ȡ�û���ǰ���������еȴ�����������
    if(table.maxn(match_user_list) > 0) then
        --�ҵ���Ҫ�Ŷӵ����
        local join_list = {};
        for k, v in pairs(match_user_list) do
            local user_info = usermgr.GetUserById(k);
            if(user_info) then--ͬһ��������������ת����
                if(user_info.desk ~= nil and user_info.desk > 0 and 
                   user_info.site ~= nil and user_info.site > 0) then
                       --�жϷ��俪ʼ��û��
                       if(deskmgr.get_game_state(user_info.desk) == gameflag.notstart) then
                           table.insert(join_list, k);
                       else
                           TraceError("who??"..k);
                       end
                else
                    table.insert(join_list, k);
                end
            else
                --�û�������
                match_user_list[k] = nil; 
                matches_taotai_lib.remove_wait_list(k);
            end
        end

        if(#join_list <= 0) then
            return;
        end

        local table_desk_list = {};
        for k, v in pairs(desk_list) do
            table.insert(table_desk_list, k);
        end
        local join_func = function(is_limit, is_join_one, desk_count, is_least)
            local ret = 0;
            if(#join_list > 0) then
                for k, v in pairs(table_desk_list) do
                    if(#join_list <= 0) then
                        break;
                    end
                    --��������
                    local can_join = 1;
                    local count = 0;
                    local user_id = join_list[1];
                    local players = deskmgr.getplayers(v);
                    local t_user_info = nil;
                    if(players[1] ~= nil) then
                        t_user_info = players[1].userinfo;
                    end
                    count = #players;

                    if(count == 1 and user_id ~= nil 
                       and t_user_info ~= nil and t_user_info.userId == user_id 
                       and desk_count ~= nil and desk_count == 1) then
                        --ֻ��һ���ˣ����������ϵ������Լ�,����Ҫ��һ����һ���˵�����
                        --TraceError("ֻ��һ���ˣ����������ϵ������Լ�,����Ҫ��һ����һ���˵�����");
                        count = 0;
                    end

                    if(is_limit == 1) then
                        --ÿ��ֻ��6��
                        if(count >= 6) then
                            can_join = 0;
                        end
                    end

                    if(is_join_one == 1 and desk_count ~= nil 
                       and (is_least == nil and count ~= desk_count or count < desk_count)) then
                        can_join = 0;
                           --TraceError('ok???'..count..' '..desk_count);
                    end

                    if(can_join == 1) then
                        for i=1, room.cfg.DeskSiteCount do
                            if(#join_list <= 0) then
                                break;
                            end
        
                            --TraceError('pre i'..i);
                            -- [[
                            --if (duokai_lib ~= nil and duokai_lib.site_have_user(v, i) == 0) or
                                --(duokai_lib == nil and desklist[v].site[i].user == nil)) then
                            if(desklist[v].site[i].user == nil) then
                                --]]
                                ret = 1;
                                local user_id = join_list[1];
                                local user_info = usermgr.GetUserById(user_id);
                                match_user_list[user_id] = nil; 
                                table.remove(join_list, 1);
                                --TraceError(v..'site no'..i..' user id'..user_id);

                                local has_join = 0;
                                if(user_info and user_info.desk and user_info.desk == v and user_info.site) then
                                    --�Ѿ������ˣ������������� 
                                    has_join = 1;
                                    trystartgame(v);
                                end

                                if(user_info and has_join == 0) then
                                    user_info.open_match_tab = nil;
                                    --����
                                    --TraceError('���� deskno..'..v..' userid:'..user_info.userId);
                                    if(duokai_lib ~= nil) then--�࿪�߼�
                                        local join_game = 0;
                                        if(duokai_lib.is_sub_user(user_info.userId) == 1) then
                                            local parent_id = duokai_lib.get_parent_id(user_info.userId);
                                            local parent_user_info = usermgr.GetUserById(parent_id);
                                            parent_user_info.open_match_tab = nil;
                                            if(parent_user_info and parent_user_info.desk == user_info.desk) then
                                                --���ʺź����ʺ���һ������
                                                --TraceError("���ʺŸ����ʺ���һ��������");
                                                join_game = 1;
                                            end
                                        end
                                        --ResetUser(user_info.key, false);
                                        duokai_lib.join_game(user_info.userId, v, i, 
                                                             is_goto_game == 1 and 1 or join_game, 
                                                             function(sub_user_info)
                                            if(callback ~= nil) then
                                                callback(match_id, sub_user_info);
                                            end
                                        end);
                                    else
                                        if(callback ~= nil) then
                                            callback(match_id, user_info);
                                        end
                                        ResetUser(user_info.key, false);
                                        -- [[
                                        if user_info.desk and user_info.desk ~= v then
                                            DoUserExitWatch(user_info);
                                        end
                                        --]]
                                        if user_info.desk == nil then
                                            DoUserWatch(v, user_info, 1);
                                        end
                                        doSitdown(user_info.key, user_info.ip, user_info.port, v, i, g_sittype.queue);
                                    end
                                end
                                if(is_join_one == 1) then
                                    break;
                                end
                            end
                        end
                    end
                end
            end
            return ret;
        end

        local sort_func = function(sort_type)
            --�����ӽ�������
            table.sort(table_desk_list, function(d1, d2)
                local count1 = 0;
                for _, player in pairs(deskmgr.getplayers(d1)) do
                    local userinfo = player.userinfo;
                    if(userinfo.desk ~= nil and userinfo.site ~= nil) then
                        count1 = count1 + 1;
                    end
                end

                local count2 = 0;
                for _, player in pairs(deskmgr.getplayers(d2)) do
                    local userinfo = player.userinfo;
                    if(userinfo.desk ~= nil and userinfo.site ~= nil) then
                        count2 = count2 + 1;
                    end
                end

                if(sort_type == 0) then
                    return count1 < count2;
                else
                    return count1 > count2;
                end
            end);
        end

        --����ҷֵ�����������
        local join_one_and_one = function()
            --��ʣ������ƽ���ֵ���������
            sort_func(0);
            local clone_join_list = table.clone(join_list);
            for k, v in pairs(clone_join_list) do
                if(#join_list == 0) then
                    break;
                end
                local ret = 0;
                for i=4, 6 do--�ȴ���4��5��6���˵����Ӽ�
                    if(#join_list > 0 and i >= need_desk_user_count) then
                        ret = join_func(0, 1, i);
                        if(ret == 1) then
                            break;
                        end
                    else
                        break;
                    end
                end

                if(#join_list == 0) then
                    break;
                end

                --��6�������ϵ�����
                ret = join_func(0, 1, 6, 1);

                for i=6, 9 do--�ȴ�������3��2��1��0���˵����Ӽ�
                    if(#join_list > 0 and 9 - i >= need_desk_user_count) then
                        ret = join_func(0, 1, 9-i);
                        if(ret == 1) then
                            break;
                        end
                    else
                        break;
                    end
                end
            end
        end

        if(is_limit ~= nil) then--����δ��ʼ
            join_func(is_limit, 0); --ÿ��6��
            join_one_and_one();--ʣ��ķֵ���ͬ����
        else
            if(#join_list <= 3) then
                join_one_and_one();
            else
                --����4��,�Ѽ������ȷ��䵽����������
                sort_func(0);
                join_func(1, 0) ;  
                join_one_and_one();
            end
        end
    end
end

function matcheslib.apply_desks(match_id, match_count) 
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil and match_info.desk_list == nil) then
        local desk_count = math.floor(match_count / 6);
        if(match_count % 6 > desk_count * (9 - 6)) then
            --ʣ�����Ҳ�������
            desk_count = desk_count + 1;
        end
        match_info.desk_list = {};

        --���ݱ���������������
        for deskno,deskdata in pairs(desklist) do

            if(desk_count <= 0) then
                break;
            end
			if (tonumber(deskno) ~= nil and deskdata.desktype == g_DeskType.match) then
				local players = deskmgr.getplayers(deskno);
	            if(#players == 0 and matcheslib.desk_list[deskno] == nil) then
	                desk_count = desk_count - 1;
	                --�ҵ�������
	                match_info.desk_list[deskno] = 1;
	                matcheslib.desk_list[deskno] = match_id;
	            end
			end
        end

        if(desk_count > 0) then
            TraceError("�������벻��������"..match_id);
        end
    end
end

--������ұ�����Ϣ
function matcheslib.save_user_list_info(user_id, list_info)
    matches_db.save_match_join_info(user_id, list_info);
end

--�������˿����ı���ID����һ���µ����˿���
function matcheslib.create_manren_match_by_id(id)
    local current_time = os.time();
    if matcheslib.match_list[id] ~= nil and matcheslib.match_list[id].match_type == 2 and 
       current_time < matcheslib.match_list[id].match_end_time then
        local new_id;               --�³��ε�id
        local num = split(id,"_");  --�жϸó� �Ƿ񴴽��˷ֳ�
        if #num == 3 then           --��δ�����ֳ�
            new_id = id.."_1";
        else                        --�Ѵ������ֳ��ģ��ѷֳ���+1
            num[4] = tonumber(num[4]) + 1;
            new_id = num[1].."_"..num[2].."_"..num[3].."_"..num[4];
        end
        matcheslib.match_list[new_id] = table.clone(matcheslib.match_list[id])
        matcheslib.match_list[new_id].id = new_id;
        matcheslib.match_list[new_id].client_id = new_id..os.time();
        matcheslib.match_list[new_id].match_count = 0;  --���ò�������
        matcheslib.match_list[new_id].status = 1;       --���ñ���״̬
        matcheslib.match_list[new_id].smallbet = nil;  --���ñ���״̬
        matcheslib.match_list[new_id].largebet = nil;
        matcheslib.match_list[new_id].joinning = nil;
        matcheslib.match_list[new_id].desk_list = nil;
        matcheslib.match_list[new_id].refresh_bet_time = nil;
        matcheslib.match_list[new_id].bet_level = 1;
        matcheslib.match_list[new_id].ante = nil;
        matcheslib.match_list[new_id].baoming_list = {};
        matcheslib.match_list[new_id].watch_list = {};
        matcheslib.is_notify_refresh_match = 1;
    end
end

function matcheslib.get_match_count(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    local count = 0;
    for k, v in pairs(match_info.baoming_list) do
        count = count + 1;
    end
    return count;
end

function matcheslib.clear_user_match_info(user_id, match_id, no_refresh_count)
    local match_info = matcheslib.get_match_info(match_id);
    if (match_info ~= nil and match_info.baoming_list[user_id] ~= nil) then
        match_info.baoming_list[user_id] = nil;
        match_info.tixing_list[user_id] = nil;
        if(match_info.wait_list ~= nil) then
            match_info.wait_list[user_id] = nil;
        end
        matcheslib.remove_wait_list(match_id, user_id);
        if(match_info.status < 3) then
            if(no_refresh_count == nil) then
                match_info.match_count = matcheslib.get_match_count(match_id);
            end
        else
            --�Ѿ���ʼ������,������ڵȴ��Ŷӵ����
           matcheslib.remove_wait_list(match_id, user_id); 
        end
    end
end

--���������¼�
function matcheslib.process_give_up(user_info, match_id, msg_type)
    local user_match_info = matcheslib.user_list[user_info.userId];
    local baoming_list = user_match_info.baoming_list;
    local match_info = matcheslib.get_match_info(match_id);
    matcheslib.clear_user_match_info(user_info.userId, match_id);

    if(baoming_list ~= nil and baoming_list[match_id] ~= nil) then
        --�˱�����
        --TraceError("�˱�����dkdkfjflf");
        matcheslib.tui_fei(user_info, baoming_list[match_id]);
        --���match_infoΪ�գ�������ǰ�ı������ô���
        if (match_info == nil) then
            match_info = table.clone(baoming_list[match_id]);
        end
        baoming_list[match_id] = nil;        --�����Ҹó��ı�����Ϣ
        matcheslib.save_user_list_info(user_info.userId, baoming_list); --����
        matcheslib.net_send_match_give_up(user_info, match_info, msg_type); --�����������
    end

    
    if(duokai_lib ~= nil) then
        local sub_user_id = -1;
        if(match_info ~= nil and match_info.desk_list ~= nil) then
            for deskno, v in pairs(match_info.desk_list) do
                sub_user_id = duokai_lib.get_sub_user_by_desk_no(user_info.userId, deskno);
                if(sub_user_id > 0) then
                    break;
                end
            end
        end
        if(sub_user_id > 0) then
            matches_taotai_lib.process_give_up(sub_user_id);
            matcheslib.go_back_to_hall(usermgr.GetUserById(sub_user_id));
            matcheslib.refresh_list(user_info);
            duokai_lib.update_sub_desk_info(user_info);
        end
    else
        matches_taotai_lib.process_give_up(user_info.userId);
        if(matcheslib.check_match_desk(user_info.desk) == 1 and 
           matcheslib.desk_list[user_info.desk] ~= nil and 
           matcheslib.desk_list[user_info.desk] == match_id) then
            --���ڲμ��ⳡ��������Ҳ��˻ش���
            matcheslib.go_back_to_hall(user_info);
        end
        matcheslib.refresh_list(user_info);
    end
end

function matcheslib.update_match_bet()
    for k, v in pairs(matcheslib.match_list) do
        if(v.status == 3) then
            --������ʼ��äע��ʼ����
            if(v.refresh_bet_time == nil) then
                v.refresh_bet_time = os.time();
                v.bet_level = v.blind_stakes_level;
            end

            if(os.time() - v.refresh_bet_time > v.blind_stakes_time * 60) then
                v.refresh_bet_time = os.time();
                if(v.blind ~= nil) then
                    if(v.blind[v.bet_level] ~= nil and 
                       v.blind[v.bet_level].smallbet ~= nil and 
                       v.blind[v.bet_level].largebet ~= nil and
                       v.blind[v.bet_level].ante ~= nil) then
                        v.smallbet = v.blind[v.bet_level].smallbet;
                        v.largebet = v.blind[v.bet_level].largebet;
                        v.ante = v.blind[v.bet_level].ante;
                    end
                    v.bet_level = v.bet_level + 1;
                end
            end
        end
    end
end

function matcheslib.check_time_match()
    local curr_time = os.time();
    --�ͻ��˵���ʱ����  ȫ����ʽ
    --[[    
    for match_id, match_info in pairs(matcheslib.match_list) do
        if(match_info.match_type == 1 and match_info.status < 3) then --���㿪����û�п�ʼ
            for user_id, _ in pairs(match_info.baoming_list) do      
                local time = match_info.match_start_time - curr_time; --���������ʼʱ��
                if (time >=5 and time <= 120) then
                    if (match_info.tixing_list[user_id] ~= 2) then
                        matcheslib.send_tixing(user_id, match_info, time);
                        match_info.tixing_list[user_id] = 2;
                    end
                elseif (time>=120 and time <= 300) then
                    if (match_info.tixing_list[user_id] ~= 1) then
                        matcheslib.send_tixing(user_id, match_info, time);
                        match_info.tixing_list[user_id] = 1;
                    end
                end
            end
        end
    end
    --]]

    --�ͻ��˵���ʱ���� ������ʽ
    -- [[
    for match_id, match_info in pairs(matcheslib.match_list) do
        if(match_info.match_type == 1 and match_info.status < 3) then       --���㿪����û�п�ʼ
            for user_id, _ in pairs(match_info.baoming_list) do      
                local user_info = usermgr.GetUserById(user_id);
                --�������ϲŹ㲥
                local msg_type = 1;

                if(user_info and user_info.desk and matcheslib.desk_list[user_info.desk] == match_id) then
                    msg_type = 2;
                end

                if (user_info) then
                    local time = match_info.match_start_time - curr_time;   --���������ʼʱ��
                    if (time >5 and time <= 30) then
                        if(msg_type == 1 and match_info.tixing_list[user_id] == 3) then
                            msg_type = 0;
                        end
                        if (match_info.tixing_list[user_id] ~= 4) then
                            matcheslib.net_send_match_coming(user_info, match_info.id, match_info.match_name, time, msg_type);
                            match_info.tixing_list[user_id] = 4;
                        end
                    elseif (time>30 and time <= 60) then
                        if(msg_type == 1 and match_info.tixing_list[user_id] == 2) then
                            msg_type = 0;
                        end
                        if (match_info.tixing_list[user_id] ~= 3) then
                            matcheslib.net_send_match_coming(user_info, match_info.id, match_info.match_name, time, msg_type);
                            match_info.tixing_list[user_id] = 3;
                        end
                    elseif(time>60 and time <= 120) then
                        if (match_info.tixing_list[user_id] ~= 2) then
                            matcheslib.net_send_match_coming(user_info, match_info.id, match_info.match_name, time, msg_type);
                            match_info.tixing_list[user_id] = 2;
                        end
                    elseif (time>120 and time <= 300) then
                        if (match_info.tixing_list[user_id] ~= 1) then
                            matcheslib.net_send_match_coming(user_info, match_info.id, match_info.match_name, time);
                            match_info.tixing_list[user_id] = 1;
                        end
                    end
                end
            end
        end
    end
    --]]
    
    for match_id, v in pairs(matcheslib.match_list) do
        if(v.match_type == 2 and os.time() > v.match_end_time and v.status < 3) then
            --�����Ѿ�����
            for userid, _ in pairs(v.baoming_list) do
                local user_info = usermgr.GetUserById(userid);
                if(user_info ~= nil) then
                    matcheslib.process_give_up(user_info, match_id, 2); --����
                end
                if(duokai_lib ~= nil) then
                    duokai_lib.update_sub_desk_info(user_info);--�Զ���ն࿪
                end
            end
            v.status = 4;
        end
        if(v.match_type == 1 and v.status < 3 and v.match_start_time <= os.time()) then --��������û�п�ʼ

            --����ѱ���������Ƿ����ߣ������ߵ��߳�����
            local count = 0;
            for user_id, _ in pairs(v.baoming_list) do
                local user_info = usermgr.GetUserById(user_id);
                if (user_info == nil or 
                    (duokai_lib == nil and matcheslib.check_match_desk(user_info.desk, match_id) == 0)) then  
                    --����ʱ�ѱ�����Ҳ����� �������Զ�����,���߱��������û�����μ�
                    if(user_info) then
                        matcheslib.process_give_up(user_info, match_id, 3);
                    else
                        matcheslib.clear_user_match_info(user_id, match_id);
                    end
                else
                    count = count + 1;
                end
            end
            
            --������ձ�����������������������ȡ����֪ͨ�������
            if (count < v.need_user_count) then
                v.status = 4;   --��Ǳ����Ѿ�����
                for userid, _ in pairs(v.baoming_list) do
                    local user_info = usermgr.GetUserById(userid);
                    if(user_info ~= nil) then
                        matcheslib.process_give_up(user_info, match_id, 2); --����
                    end
                    if(duokai_lib ~= nil) then
                        duokai_lib.update_sub_desk_info(user_info);--�Զ���ն࿪
                    end
                end
            else
                --������ʼ 
                --TODO�������ϵ������Ҫ�࿪
                --���������ϵ����ֱ��������Ϸ
                v.status = 3;
                v.match_count = matcheslib.get_match_count(match_id);
                if(duokai_lib ~= nil) then
                    --�࿪ֱ������
                    for user_id,_  in pairs(v.baoming_list) do 
                        local user_info = usermgr.GetUserById(user_id);
                        if(user_info ~= nil) then
                            matcheslib.apply_desks(match_id, v.match_count);
                            local match_user_list = {
                                [user_info.userId] = 1;
                            };
                            matcheslib.auto_join_desk(match_id, match_user_list, v.desk_list, 1, matcheslib.on_after_join_desk, user_info.desk == nil and 1 or 0);
                            duokai_lib.update_sub_desk_info(user_info);
                        end
                    end
                else
                    matcheslib.try_start_match(match_id);
                end
            end
        end
    end
end

function matcheslib.on_after_join_desk(match_id, user_info)
    if(user_info ~= nil) then
        --��ʼ�����ʺ�
        local e = {data = {userinfo = user_info}};
        matcheslib.on_after_user_login(e);
        matches_taotai_lib.on_after_user_login(e);


        local user_id = user_info.userId;
        --�����˺ű���
        matches_taotai_lib.on_user_queue(match_id, user_id);
        local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
        user_match_info.notify_continue = 0;
        matches_taotai_lib.remove_wait_list(user_id);
        matches_taotai_lib.set_match_user_play(user_id);
    end
end

function matcheslib.clear_match(match_id)
    matcheslib.match_list[match_id] = nil;
end

--������ʼ
function matcheslib.on_match_start(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    --���ı���״̬
    match_info.status = 3;
    match_info.tixing_list = {};
    --�����ֳ�
    matcheslib.create_manren_match_by_id(match_id);
    --����ó�����ұ�����Ϣ
    for userid, _ in pairs(match_info.baoming_list) do
        local user_match_info = matcheslib.user_list[userid];
        local baoming_list = user_match_info.baoming_list;
        baoming_list[match_id] = nil;       --������Ƕ��������Ͳ�����
        --������ұ�����Ϣ
        matcheslib.save_user_list_info(userid, baoming_list);
    end
    --TODO ����ʲôҪ����
end

function matcheslib.send_tixing(userId, match_info, time)
    local send_func = function(buf)
        buf:writeString("MATCHTTTIXING");
        buf:writeInt(userId);
        buf:writeString(match_info.id);
        buf:writeString(match_info.match_name);
        buf:writeInt(time);
    end
    send_buf_to_all_game_svr(send_func);
end

function matcheslib.on_match_end(match_id, rank_info)
    --TraceError('on_match_end'..match_id);
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        timelib.createplan(function()
            match_info.status = 4;
            matcheslib.notify_watcher_out(match_id, 1);
        end, 10);
        --֪ͨ���й�ս���뿪����
        matcheslib.notify_watcher_out(match_id);

        if(rank_info ~= nil) then
            matches_db.save_match_win_info(match_id, match_info.match_name, 
                                           rank_info.userId, rank_info.jifen, match_info.award[1]);
    
            table.insert(matcheslib.match_win_list, 1, {
                user_id = rank_info.userId,
                nick = rank_info.nick, 
                match_id = match_id,
                match_name = match_info.match_name,
                jifen = rank_info.jifen,
                face = rank_info.imgUrl,
                sys_time = timelib.lua_to_db_time(os.time()),
                prize_list = match_info.award[1],
            });
        else
            TraceError("Ϊʲô����������û��������Ϣ"..tostringex(match_info));
        end

        if(#matcheslib.match_win_list > 5) then
            table.remove(matcheslib.match_win_list, #matcheslib.match_win_list);
        end

        --TODO�ڱ���ҳ�����Ҳ���Ҫ����Ӯ���б�, �л�������ҳ����Ҫ����һ��Ӯ���б�
        for k, v in pairs(userlist) do
            if(v.open_match_tab ~= nil) then
                matcheslib.net_send_match_win_list(v);
            end
        end
        
    end
end
--֪ͨĳ����ս����뿪
matcheslib.notify_watcher_out = function(match_id, is_back_to_hall)
    local match_info = matcheslib.get_match_info(match_id);
    local desk_list = match_info.desk_list;
    for deskno, _ in pairs(desk_list) do
        local desk_watch_list = desklist[deskno].watchingList;
        local watcher_info = nil;
        for k, v in pairs(desk_watch_list) do
			watcher_info = usermgr.GetUserById(v.userId);
            if(watcher_info ~= nil) then
                if(is_back_to_hall ~= nil) then
                    matcheslib.go_back_to_hall(watcher_info);
                    matcheslib.refresh_list(watcher_info);     
                else
                    matcheslib.clear_user_match_info(v.userId, match_id, 1);
                    netlib.send(function(buf)
                        buf:writeString("MATCHOVER");
                        buf:writeString(match_id);
                    end, watcher_info.ip, watcher_info.port);
                end
            end
            --[[
			watcher_match_info = matcheslib.user_list[v.userId];
			--�����ս��һ��ڸ�����ս
			if watcher_info ~= nil and watcher_info.desk == deskno then
				--��ոù�ս��Ҹó�����������Ϣ
				if watcher_match_info ~= nil and watcher_match_info.baoming_list[match_id] ~= nil then
					watcher_match_info.baoming_list[match_id] = nil;
				end
				--�˳�����
	        	matcheslib.go_back_to_hall(watcher_info);
	        	--ˢ���б�
				matcheslib.refresh_list(watcher_info);     
			end
            --]]
		end
    end
    --[[
	local desk_watch_list = desklist[deskno].watchingList;
	local watcher_info = nil;
	local watcher_match_info = nil;
	--10����˳���ս
	timelib.createplan(function()
		for k, v in pairs(desk_watch_list) do
			watcher_info = usermgr.GetUserById(v.userId);
			watcher_match_info = matcheslib.user_list[v.userId];
			--�����ս��һ��ڸ�����ս
			if watcher_info ~= nil and watcher_info.desk == deskno then
				--��ոù�ս��Ҹó�����������Ϣ
				if watcher_match_info ~= nil and watcher_match_info.baoming_list[match_id] ~= nil then
					watcher_match_info.baoming_list[match_id] = nil;
				end
				--�˳�����
	        	matcheslib.go_back_to_hall(watcher_info);
	        	--ˢ���б�
				matcheslib.refresh_list(watcher_info);     
			end
		end
	end,10);
    --]]
end

matcheslib.go_back_to_hall = function(user_info)
    if(user_info == nil) then return end
    pre_process_back_to_hall(user_info);
end

function matcheslib.let_watching_user_join_desk(cur_desk, match_id)
    --�ѵ�ǰ���ӵĹ�ս�ˣ��Ƶ���һ����������
    local match_list = matches_taotai_lib.get_match_list(match_id);
    local rankinfo = match_list.rank_list[1];
    local match_info = matcheslib.get_match_info(match_id);
    if(rankinfo == nil or match_info == nil or match_info.status > 3) then
        --TraceError("�����Ѿ������� TODO ֪ͨ�û�����������");
        matcheslib.notify_watcher_out(match_id, true);
        return;
    end
    local top_user_id = rankinfo.userId;
    --TraceError('top_user_id'..top_user_id);
    local topuserinfo = usermgr.GetUserById(top_user_id);
    local match_info = matcheslib.get_match_info(match_id);

    local count = 0;
    local players = deskmgr.getplayers(cur_desk);
    local count = #players;

    if(count <= 3 and topuserinfo ~= nil and topuserinfo.desk ~= nil and topuserinfo.desk ~= cur_desk) then
        if(match_info.watch_list ~= nil and match_info.watch_list[cur_desk] ~= nil) then
            for k, v in pairs(match_info.watch_list[cur_desk]) do
                local user_info = usermgr.GetUserById(k);
                local watching_count = 0;
                if(user_info ~= nil and user_info.desk == cur_desk and watching_count <= matcheslib.CONFIG_WATCHING_COUNT) then
                    matcheslib.set_match_user_watch(match_id, topuserinfo.desk, user_info.userId);
                    if(duokai_lib ~= nil) then
                        local join_game = 0;
                        if(duokai_lib.is_sub_user(user_info.userId) == 1) then
                            local parent_id = duokai_lib.get_parent_id(user_info.userId);
                            local parent_user_info = usermgr.GetUserById(parent_id);
                            if(parent_user_info and parent_user_info.desk == user_info.desk) then
                                --���ʺź����ʺ���һ������
                                --TraceError("���ʺŸ����ʺ���һ��������");
                                join_game = 1;
                            end
                        end
                        duokai_lib.join_game(user_info.userId, topuserinfo.desk, 0, join_game);
                    else
                        matcheslib.go_back_to_hall(user_info);
                        DoUserWatch(topuserinfo.desk, user_info, 1);
                    end
                else
                    matcheslib.set_match_user_watch(match_id, 0, k);	
                    if user_info ~= nil and user_info.desk ~= nil and watching_count > matcheslib.CONFIG_WATCHING_COUNT then
                    	--֪ͨ�ͻ��˷��ش���
                        
                        matcheslib.clear_user_match_info(user_info.userId, match_id);
                    	matcheslib.go_back_to_hall(user_info);
                    end
                end
            end
        end
    end
end

function matcheslib.check_match_desk(deskno, match_id)
    if(deskno ~= nil) then
        local deskinfo = desklist[deskno];
        if(match_id == nil) then
            return deskinfo.desktype and deskinfo.desktype == g_DeskType.match and 1 or 0;
        else
            return deskinfo.desktype and deskinfo.desktype == g_DeskType.match and 
            matcheslib.desk_list[deskno] ~= nil and
            matcheslib.desk_list[deskno] == match_id and 1 or 0;
        end
    else
        return 0;
    end
end

function matcheslib.set_match_user_watch(match_id, deskno, user_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        if(match_info.watch_list == nil) then
            match_info.watch_list = {};
        end

        if(match_info.watch_list[deskno] == nil) then
            match_info.watch_list[deskno] = {};
        end

        if(matcheslib.watch_list[user_id] ~= nil) then
            local last_deskno = matcheslib.watch_list[user_id];
            if(match_info.watch_list[last_deskno] ~= nil and match_info.watch_list[last_deskno][user_id] ~= nil) then
                match_info.watch_list[last_deskno][user_id] = nil;
            end
        end

        match_info.watch_list[deskno][user_id] = 1;
        matcheslib.watch_list[user_id] = deskno;
    end
end

function matcheslib.free_desks(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info.desk_list ~= nil) then
        for k, v in pairs(match_info.desk_list) do
            match_info.desk_list[k] = nil;
            matcheslib.desk_list[k] = nil;
        end
    end
end

--�����۷�
function matcheslib.kou_fei(user_info, match_info)
    local cost = tonumber(match_info.join_cost_num);    --����
    local cost_type = match_info.join_cost;             --��������

    if (cost_type == "cm") then --������Ϊ����
        usermgr.addgold(user_info.userId, -cost, 0, new_gold_type.TEX_MATCH_JOIN_COST, -1);
    end
    --TODO �۳���������
end

--�����˷�
function matcheslib.tui_fei(user_info, match_info)
    local cost = tonumber(match_info.join_cost_num);    --����
    local cost_type = match_info.join_cost;             --��������

    if (cost_type == "cm" and cost > 0) then --������Ϊ����
        usermgr.addgold(user_info.userId, cost, 0, new_gold_type.TEX_MATCH_EXIT_COST, -1);
    end
    --TODO �˻���������
end

--������״̬�Ƿ�ɱ���
function matcheslib.check_match(match_info, result)
    local tableTime = os.date("*t",os.time()); --��ǰϵͳ����
    local curr_time = os.time();               --��ǰϵͳʱ�� 
    
    if (match_info == nil or match_info.status == 4) then   --�����Ѿ�����
        result = -1;
    elseif (match_info.status == 3) then                    --�����Ѿ���ʼ��
        result = -2;
    elseif(match_info.match_type == 2 and 
           match_info.match_count >= match_info.need_user_count) then
        result = -11;
    elseif (match_info.match_type == 2 and curr_time < match_info.match_start_time) then      --���˿���δ��ʱ��
        result = -3;
    elseif (match_info.join_cost == "" or tonumber(match_info.join_cost_num) == 0) then   --��ѱ���
        result = 2;
    end
    return result;
end

--�����������Ƿ���Ա�������
function matcheslib.check_user_condition(user_info, match_info, result)
    --TODOҪ�ж��������������� ��������һ���Ϳ���
    local condition = match_info.match_condition;   --��������
    for k, v in pairs(condition) do
        local condition_key = tonumber(split(v,":")[1]);    --������
        local condition_value = split(v,":")[2];            --����ֵ

        if (condition_key == 1) then                  --��ҵȼ�Ҫ��
            if  (matcheslib.check_condition(condition_value, user_info.gameInfo.level) == 1) then
                result = -7;
            end
        elseif (condition_key == 2) then              --TODO������������Ҫ��
           
        elseif (condition_key == 3) then              --TODO������н�ȯҪ��

        elseif (condition_key == 4) then              --TODO������г���Ҫ��
            if  (matcheslib.check_condition(condition_value, user_info.gamescore) == 1) then
                result = -7;
            end
        elseif (condition_key == 5) then                    --�Ƿ�VIP
            if (split(condition_value,"-")[1] ~= 0) then    --����ֻ��VIP����
                if (user_info.vip_info == nil) then --��vip
                    result = -7;
                elseif (matcheslib.check_condition(condition_value, user_info.vip_info[1].vip_level) == 1) then
                    result = -7;
                end 
            else                                            --����VIP��Ҳ������
                if (user_info.vip_info ~= nil) then
                    result = -7;
                end
            end
        elseif (condition_key == 6) then                      --�Ա�
            if  user_info.sex ~= condition_value then
                result = -7;
            end
        end
    end
    return result;
end

function matcheslib.check_condition(condition_value, check_value)
    local min = tonumber(split(condition_value,"-")[1]);
    local max = tonumber(split(condition_value,"-")[2]);
    if check_value < min or check_value > max then
        return 1;
    end
    return 0;
end

--��������
function matcheslib.check_join_cost(user_info, match_info, result)
    if match_info.join_cost == "cm" then                         --����
        local can_use_gold = get_canuse_gold(user_info);
        if can_use_gold < tonumber(match_info.join_cost_num) then
            result = -4;
        end
    --TODO ���������������
    --elseif()
    --result = -5;
    end
    return result;
end

function matcheslib.on_match_taotai(match_id, user_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        if(duokai_lib ~= nil) then
            local parent_id = duokai_lib.get_parent_id(user_id);
            match_info.baoming_list[parent_id] = nil;
            local user_match_info = matcheslib.user_list[parent_id];
            if(user_match_info ~= nil) then
                user_match_info.baoming_list[match_id] = nil;
            end
        else
            matcheslib.clear_user_match_info(user_id, match_id);
            local user_match_info = matcheslib.user_list[user_id];
            if(user_match_info ~= nil) then
                user_match_info.baoming_list[match_id] = nil;
            end
        end
    end
end

--���࿪���
matcheslib.check_duokai_condition = function(user_info, match_info, result)
	--�Ƿ��Ǳ�����
	local user_match_info = matcheslib.user_list[user_info.userId];
    local baoming_match_info = nil;
	if user_match_info == nil or match_info == nil then
		return result;
    end

    --�������б���,��������
    -- [[
    for k, v in pairs(matcheslib.match_list) do
        baoming_match_info = matcheslib.get_match_info(k);
        if(v.status < 4) then--����δ�������ж�
            if(v.match_type == 2 and match_info.match_type == 2) then--ֻ���Ա�һ��������
                if(v.baoming_list[user_info.userId] ~= nil) then--������Ҳ�����Ա�
    				result = -8;
                    break;
                end
            elseif(v.match_type == 1 and match_info.match_time == v.match_time) then--ͬһʱ��ֻ���Ա�һ��
                if(v.baoming_list[user_info.userId] ~= nil) then--������Ҳ�����Ա�
                    result = -9;
                    break;
                end
            end
        end
    end
    --]]
    --[[
    --������ڱ���Ҳ���ܼ������
    for k, v in pairs(matcheslib.match_list) do
        if(v.status < 4) then--����δ�������ж�
            if(v.match_type == 2) then
                if(v.baoming_list[user_info.userId] ~= nil) then
                    baoming_match_info = matcheslib.get_match_info(k);
    				result = -10;
                    break;
                end
            elseif(v.match_type == 1) then
                if(v.baoming_list[user_info.userId] ~= nil) then
                    baoming_match_info = matcheslib.get_match_info(k);
                    result = -10;
                    break;
                end
            end
        end
    end
    --]]

    --�����Ѿ���ʼ���
    if(result ~= -10) then
    	for match_id, v in pairs(user_match_info.baoming_list) do
            baoming_match_info = matcheslib.get_match_info(match_id);
            if(baoming_match_info ~= nil and baoming_match_info.status < 4) then--�鿴������û�д��ڻ��߽���û��
                --result = -10;
                --break;
        		--������ֻ�ܱ�һ��
                -- [[
        		if match_info.match_type == 2 then
        		 	if v.match_type == match_info.match_type then
        				result = -8;
        				break;
        			end
        		--������ͬһʱ��ֻ�ܱ�һ��
        		elseif match_info.match_time == v.match_time then
        			result = -9;
        			break;
                end
                --]]
            end
        end
    end
	return result, baoming_match_info;
end

--��������
function matcheslib.join_match(user_info, match_info)
    local user_match_info = matcheslib.user_list[user_info.userId];
    if (user_match_info ~= nil and user_match_info.baoming_list[match_info.id] == nil) then
        user_match_info.baoming_list[match_info.id] = {
            id = match_info.id;                     --����ID
            type_id = match_info.type_id;           --��������
            match_name = match_info.match_name;     --������
            match_time = match_info.match_time;     --����ʱ��
            join_cost = match_info.join_cost;       --����������
            join_cost_num = match_info.join_cost_num;  --����������
            status = 2;                             --�����ı���״̬  2Ϊ�ѱ���
            match_type = match_info.match_type;     --��������
        };
        match_info.tixing_list[user_info.userId] = 0;           --�����ҵı�������
        if(match_info.match_type == 2) then --��鱨��������ڲ�����
            for k, v in pairs(match_info.baoming_list) do
                local userinfo = usermgr.GetUserById(k);
                if(userinfo == nil or matcheslib.check_match_desk(userinfo.desk) == 0) then
                    matcheslib.clear_user_match_info(k, match_info.id, 1);
                end
            end
        end

        match_info.baoming_list[user_info.userId] = 1;          --��ӱ�����Ϣ
        match_info.match_count = matcheslib.get_match_count(match_info.id);   --���¸ó������Ĳ�������
    
        matcheslib.save_user_list_info(user_info.userId, user_match_info.baoming_list); --��������Ϣд�����ݿ�
        matcheslib.kou_fei(user_info, match_info);              --�۷�
    else
        TraceError("�Ѿ������ó�����...");
        return;
    end
    --�������������ֱ�Ӽ�������
    if(match_info.match_type == 2) then
        --TraceError('auto join match match_type'..match_info.match_type);
        --����Ҽ������
        --local result = matches_taotai_lib.on_user_queue(match_info.id, user_info.userId);
        matcheslib.apply_desks(match_info.id, match_info.need_user_count);
        local match_user_list = {
            [user_info.userId] = 1;
        };
        --�Ӵ���ֱ�ӽ���Ϊ���˺� ��Ҫ�л�����ǰ����
        matcheslib.auto_join_desk(match_info.id, match_user_list, match_info.desk_list, 1, matcheslib.on_after_join_desk, (user_info.desk == nil and 1 or 0));
    end
end

function matcheslib.refresh_list(user_info)
    if(duokai_lib and duokai_lib.is_sub_user(user_info.userId) == 1) then
        return;
    end
    matcheslib.net_send_match_list(user_info);      --�����б�
    matcheslib.net_send_user_match_list(user_info); --�ѱ����б�
    if(duokai_lib ~= nil) then
        duokai_lib.net_send_match_list(user_info);
    end
end

-----------------------------------------ϵͳ�¼�----------------------------------------------
--�û���¼�¼�
function matcheslib.on_after_user_login(e)
    local user_info = e.data.userinfo;

    if(matcheslib.user_list[user_info.userId] ~= nil) then
        return;
    end

    local user_match_info = {};
    matcheslib.user_list[user_info.userId] = user_match_info;
    user_match_info.baoming_list = {};

    --ȡ�û�������Ϣ
    matches_db.get_match_join_info_by_userid(user_info.userId, function(dt)
        if (#dt ~= 0) then
            user_match_info.baoming_list = table.loadstring(dt[1].join_info);
            --δ�������ߺ�����
                for k, v in pairs(user_match_info.baoming_list) do
                    local match_info = matcheslib.get_match_info(v.id);
                    if (match_info == nil or match_info.status > 2 or match_info.baoming_list[user_info.userId] == nil) then --�����Ѿ��������Ѿ�����
                         matcheslib.process_give_up(user_info, v.id, 3);
                    end
                end
        end
        --�����ѱ����б��ͻ���
        matcheslib.net_send_user_match_list(user_info);
    end);

end

function matcheslib.update_user_chouma(user_info)
    if(matcheslib.check_match_desk(user_info.desk) == 1) then
        local user_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
        if(user_match_info.match_id ~= nil) then
            local match_info = matcheslib.get_match_info(user_match_info.match_id);
            if(match_info ~= nil and match_info.largebet == nil) then
                matcheslib.update_desk_blind(user_info.desk);
            end
            local result = matches_taotai_lib.check_user_taotai(user_info.userId);
            if(result == 0) then
                user_info.chouma = user_match_info.jifen;
            end
        else
            TraceError("û�вμӱ�����Ϊʲô�������");
        end
        return 1;
    end
    return 0;
end

function matcheslib.on_buy_chouma(e)
    local userinfo = e.data.userinfo;
    if(matcheslib.update_user_chouma(userinfo) == 1) then
         e.data.handle = 1;
    end
end

function matcheslib.on_send_buy_chouma(e)
    if(matcheslib.check_match_desk(e.data.userinfo.desk) == 1) then
        e.data.handle = 1;

        local user_info = e.data.userinfo;
        matches_taotai_lib.check_user_taotai(user_info.userId);
    end
end

function matcheslib.on_timer_second(e)
    if(matcheslib.check_match_room() == 1) then
        if os.time() - matcheslib.refresh_match_list_time > 5 then
            matcheslib.update_match_list();
            matcheslib.refresh_match_list_time = os.time();
        end
        matcheslib.update_match_bet();
        matcheslib.check_time_match();
        matcheslib.check_die_match();
        matcheslib.notify_all_refresh_match_list();
    end
end

function matcheslib.check_die_match()
    for match_id, v in pairs(matcheslib.match_list) do
        if(v.check_die_time == nil) then
            v.check_die_time = os.time();
        end
        if(v.status == 3 and (v.check_die_time ~= nil and os.time() - v.check_die_time > 60)) then --1���Ӽ��һ��
            v.check_die_time = os.time();
            --����������
            for deskno, _ in pairs(v.desk_list) do
                --����������4���˵�
                if(deskmgr.get_game_state(deskno) == gameflag.notstart) then
                    local players = deskmgr.getplayers(deskno);
                    if(#players > 0 and #players <= 4) then
                        trystartgame(deskno);
                    end
                end
            end
            matches_taotai_lib.check_match_end(match_id);
        end

        if(v.status == 3) then
            local list = matches_taotai_lib.get_match_list(match_id);
            local is_join = 0;
            if(list.match_list ~= nil) then
                for k1, v1 in pairs(list.match_list) do
                    local user_info = usermgr.GetUserById(k1);
                    if(user_info ~= nil and (user_info.desk == nil or user_info.site == nil) and 
                       v.wait_list ~= nil and v.wait_list[user_info.userId] == nil) then
                        v.wait_list[user_info.userId] = 1;
                        is_join = 1;
                    end
                end

                if(is_join == 1) then
                    matcheslib.auto_join_desk(match_id, v.wait_list, 
                                                      v.desk_list, nil, 
                                                      nil, nil, 0);
                end
            end
        end
    end
end

--�ж��Ƿ�������
function matcheslib.is_manren_match(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil and match_info.match_type == 2) then
        return 1;
    end
    return 0;
end

--�ж��Ƿ�ʱ��
function matcheslib.is_dingshi_match(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil and match_info.match_type == 1) then
        return 1;
    end
    return 0;
end

--��ȡ�������ٿ�������
function matcheslib.get_need_user_count(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        return match_info.need_user_count;
    end
    return -1;
end

--��ȡ��������
function matcheslib.get_baoming_count(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        return match_info.match_count;
    end
    return -1;
end

function matcheslib.update_desk_blind(deskno)
    local match_id = matcheslib.desk_list[deskno]
    if(match_id ~= nil) then
        local match_info = matcheslib.get_match_info(match_id);
        if(match_info ~= nil) then
            local deskinfo = desklist[deskno];
            if(match_info.smallbet == nil) then
                local blind_info = matcheslib.get_blind_info(match_id, match_info.blind_stakes_level); 
                if(blind_info == nil) then
                    TraceError("�����ˣ�û�д�Сä");
                    blind_info = {smallbet = 25, largebet = 50, ante = 200};
                end
                match_info.smallbet = blind_info.smallbet;
                match_info.largebet = blind_info.largebet;
                match_info.ante = blind_info.ante;
            end
            deskinfo.smallbet = match_info.smallbet;
            deskinfo.largebet = match_info.largebet;
        end
    end
end

function matcheslib.try_start_match(match_id)
    local match_info = matcheslib.get_match_info(match_id);
    local status = 0;
    local match_user_list = {};
    if(match_info ~= nil) then
        match_user_list, status = matches_taotai_lib.try_start_match(match_id);
        if(status == 1) then
            matcheslib.on_match_start(match_id);
            for deskno, _ in pairs(match_info.desk_list) do
                --TraceError("������ʼ��������"..deskno);
                trystartgame(deskno);
            end
        end
    end
    return match_user_list, status;
end

function matcheslib.let_wait_user_join_desk(match_id)
    timelib.createplan(function()
        local match_info = matcheslib.get_match_info(match_id);
        if(match_info ~= nil) then
            match_info.joinning = 1;
            --TraceError('�ȴ����û�'..tostringex(match_info.wait_list));
            --�࿪���¿�ʼ��Ϸ�ı�Ȼ�����˺�
            local wait_count = 0;
            for k, v in pairs(match_info.wait_list) do
                --У���û��Ƿ��ڱ���
                local user_taotai_match_info = matches_taotai_lib.get_user_match_info(k);
                if user_taotai_match_info.match_id == nil or user_taotai_match_info.match_id ~= match_id then
                    match_info.wait_list[k] = nil;
                else
                    wait_count = wait_count + 1;
                end
            end
            xpcall(function()
                matcheslib.auto_join_desk(match_info.id, match_info.wait_list, match_info.desk_list);
            end, throw);
            match_info.joinning = nil;
            matcheslib.let_all_watching_user_join_desk(match_id);
        end
    end, 2);
end

function matcheslib.on_try_start_game(e)
    --TraceError("try_start_game")
    if(matcheslib.check_match_desk(e.data.deskno) == 1) then
        local deskno = e.data.deskno;
        --TraceError("on_try_start_game deskno"..deskno);
        local match_id = matcheslib.desk_list[deskno]
        if(match_id ~= nil) then
            local match_info = matcheslib.get_match_info(match_id);
            --������̭����ʼ
            local match_user_list, status = matcheslib.try_start_match(match_id);

            --TraceError("matches_taotai_lib status"..status);
            if(status == 1) then
                --TraceError("�������Կ�ʼ��,���������ӿ�ʼ��Ϸ��");
                e.data.handle = 1;
            elseif(table.maxn(match_user_list) <= 0 and status ~= 2) then
                --TraceError("��Ϸ�������Կ�ʼ");
                matcheslib.update_desk_blind(deskno);
                e.data.handle = 1;
            else
                if(match_info.joinning == nil) then
                    local count = 0;
                    local wait_list = {};
                    local other_list = table.clone(match_user_list);
                    for _, player in pairs(deskmgr.getplayers(deskno)) do
                        local userinfo = player.userinfo;
                        local is_taotai = matches_taotai_lib.check_user_taotai(userinfo.userId);
                        other_list[userinfo.userId] = nil;
                        if(userinfo.desk ~= nil and userinfo.site ~= nil) then
                           if(is_taotai == 0) then
                               count = count + 1;
                               wait_list[userinfo.userId] = 1;
                               matcheslib.update_user_chouma(userinfo);
                           else
                               --�����վ���
                               doStandUpAndWatch(userinfo, 1);
                           end
                        end
                    end
                    local match_count = matches_taotai_lib.get_match_user_count(match_id, 'match');
                    local is_start = 0;

                    if(match_count <= 1) then
                        return;
                    end

                    if(count > 3 or (match_count <= 3 and count == match_count)) then
                        --�ж���3������Ƿ���ͬһ����,���������ô����Ҫ�Ŷӷ���
                        is_start = 1;
                    end
                    --��������������������ˣ��������Ŷ�
                    if(is_start == 1) then
                        --TraceError('��ʼ����deskno'..deskno..' wait_list'..tostringex(wait_list));
                        --������÷�������ô�͸ı�äע 
                        if(match_count > count and match_count <= 9) then
                            --TraceError("ʣ�಻��9������,Ϊʲô�����˻�������������"..tostringex(other_list));
                            for k, v in pairs(other_list) do
                                match_info.wait_list[k] = 1;
                            end
                            matcheslib.let_wait_user_join_desk(match_id);
                        end
                        matcheslib.update_desk_blind(deskno);
                        matches_taotai_lib.g_on_game_start(deskno);
                    else
                        --���з�������
                        --TraceError("��ʼ������ ���Ӻ�"..deskno.."��������"..count.." ��������"..match_count);
                        e.data.handle = 1;
                        if(match_info.wait_list == nil) then
                            match_info.wait_list = {};
                        end

                        for k, v in pairs(wait_list) do
                            matches_taotai_lib.notify_continue_play(k);
                            match_info.wait_list[k] = v;
                        end

                        for k, v in pairs(match_info.wait_list) do--����������վ�𣬲�Ȼ����ֿ��������
                            local user_info = usermgr.GetUserById(k);
                            if(user_info ~= nil) then
                                doUserStandup(user_info.key, false);
                            end
                        end
                        matcheslib.let_wait_user_join_desk(match_id);
                    end
                end
            end
        end
    end
end

function matcheslib.on_force_game_over(e)
    local desk_no = e.data.desk_no;
    if(matcheslib.check_match_desk(desk_no) == 1) then
        trystartgame(desk_no);
    end
end

function matcheslib.on_user_sitdown(e)
    local userinfo = e.data.userinfo;
    userinfo.open_match_tab = nil;
    --����Ǳ�������ô��Ҫ�������ֹ�����
    if(matcheslib.check_match_desk(userinfo.desk) == 1) then
        if(matches_taotai_lib.check_user_taotai(userinfo.userId) ~= 0) then
            --���û�վ���
            doStandUpAndWatch(userinfo, 1);
        end
    end
end

--�յ����ƺ��µ�ע
function matcheslib.on_after_fapai(e)
    local deskno = e.data.deskno;
    local match_id = matcheslib.desk_list[deskno];
    if(match_id ~= nil) then
        local match_info = matcheslib.get_match_info(match_id);
        if(match_info.status == 3) then
            if(match_info.ante ~= nil and match_info.ante > 0) then
                process_dizhu(deskno, match_info.ante); 
            end
        end
    end
end

function matcheslib.on_server_start(e)
    --��ȡ���а�
    matches_db.get_match_win_info(function(dt)
        if(dt and #dt > 0) then
            for k, v in pairs(dt) do
                if(v.prize_list and v.prize_list ~= "") then
                    v.prize_list = table.loadstring(v.prize_list);
                else
                    v.prize_lsit = {};
                end
            end
            matcheslib.match_win_list = dt;
        end
    end);
end

function matcheslib.on_sub_user_back_to_hall(e)
    local user_info = e.data.user_info;
    if not user_info then return end;
    
    --���ʺ��˳��ˣ���Ҫ������ʺű���
    local user_taotai_match_info = matches_taotai_lib.get_user_match_info(user_info.userId); 
    local match_id = user_taotai_match_info.match_id;
    if(match_id ~= nil) then
        local parent_id = duokai_lib.get_parent_id(user_info.userId);
        local match_info = matcheslib.get_match_info(match_id);

        if(parent_id > 0) then
            if(match_info ~= nil) then
                match_info.baoming_list[parent_id] = nil;
                matcheslib.remove_wait_list(match_id, user_info.userId);
            end
            local user_match_info = matcheslib.user_list[parent_id];    
            user_match_info.baoming_list[match_id] = nil;
            user_info = usermgr.GetUserById(parent_id);
            matcheslib.refresh_list(user_info);
        end
    end
end

function matcheslib.get_match_status(match_id)
    local status = 0;
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        status = match_info.status;
    end
    return status;
end

--��ȡ������ʼʱ��
function matcheslib.get_match_start_time(match_id)
    local match_start_time = 0;
    local match_info = matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        match_start_time = match_info.match_start_time;
    end
    return match_start_time;
end

function matcheslib.on_back_to_hall(e)
    local user_info = e.data.user_info;
    if not user_info then return end;

    --matcheslib.refresh_list(user_info);     --ˢ���б�
end

function matcheslib.on_send_duokai_sub_desk(e)
    local user_info = e.data.user_info;
    local extra_list = e.data.extra_list;

    local user_match_info = matcheslib.user_list[user_info.userId];

    if(user_match_info ~= nil) then
        for match_id, v in pairs(user_match_info.baoming_list) do
            local match_info =  matcheslib.get_match_info(match_id);
            if (match_info.match_type == 1 and match_info.status < 3 and match_info.baoming_list[user_info.userId] ~= nil) then
                --��ʱ������δ��ʼ
                local left_time = match_info.match_start_time - os.time();
                if(left_time > 0) then
                    table.insert(extra_list, {
                        desk_no = match_id, 
                        desk_name = match_info.match_name, 
                        desk_type = g_DeskType.match, 
                        left_time = left_time,
                        match_count = 0,
                        match_start_count = 0,
                        match_id = match_id});
                end
            end
        end
    end
end

function matcheslib.remove_wait_list(match_id, user_id)
    local match_info =  matcheslib.get_match_info(match_id);
    if(match_info ~= nil) then
        if(match_info.wait_list ~= nil) then
            if(duokai_lib ~= nil and duokai_lib.is_sub_user(user_id) == 0) then
                for k, v in pairs(match_info.wait_list) do
                    local parent_id = duokai_lib.get_parent_id(k);
                    if(user_id == parent_id) then
                        match_info.wait_list[k] = nil;
                        break;
                    end
                end
            else
                match_info.wait_list[user_id] = nil;
            end
        end
    end
end

function matcheslib.on_user_exit(e)
    local user_info = e.data.userinfo;
    if not user_info then return end;

    local user_match_info = matcheslib.user_list[user_info.userId];
    --�û��˳��ͻ���ʱ������������˿�������Ҫ������������1
        if (user_match_info ~= nil) then
            for match_id, v in pairs(user_match_info.baoming_list) do
                local match_info =  matcheslib.get_match_info(match_id);
                if (match_info and match_info.match_type == 2 and match_info.baoming_list[user_info.userId] ~= nil) then
                    --TraceError("�û�"..user_info.userId.."�˳��˿ͻ���,�Զ��˳����˿���");
                    matcheslib.clear_user_match_info(user_info.userId, match_id);
                end
            end
        end
    matcheslib.user_list[user_info.userId] = nil;
end

function matcheslib.on_recv_pre_join_match(buf)
    local user_info = userlist[getuserid(buf)];
    if(not user_info) then return end;
    local match_id = buf:readString();
    local result = 1;
    local user_match_info = matcheslib.user_list[user_info.userId];
    local match_info = matcheslib.get_match_info(match_id);
    local current_time = os.time();
    if (match_info ~= nil and user_match_info.baoming_list[match_id] ~= nil and
       match_info.match_type == 1) then
        result = matcheslib.check_match(match_info, result);

        if(result == 1 or result == 2) then
            if(current_time <  match_info.match_start_time - matcheslib.CONFIG_PRE_JOIN_TIME or 
               current_time > match_info.match_start_time) then
                result = -3;
            end
            if(result ~= -3) then
                --������ڱ�����ô����Ҫ����
                local user_taotai_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
                if(user_taotai_match_info.match_id ~= nil) then
                    matcheslib.process_give_up(user_info, user_taotai_match_info.match_id, 1);
                end
                matcheslib.go_back_to_hall(user_info);
                matcheslib.apply_desks(match_info.id, matcheslib.get_match_count(match_id));
                local match_user_list = {
                    [user_info.userId] = 1;
                };
                --�Ӵ���ֱ�ӽ���Ϊ���˺� ��Ҫ�л�����ǰ����
                matcheslib.auto_join_desk(match_info.id, match_user_list, match_info.desk_list, 1, 
                                          matcheslib.on_after_join_desk, (user_info.desk == nil and 1 or 0));
            end
        end

        if(result ~= 1 and result ~= 2) then
            matcheslib.net_send_join_match_result(user_info, result, match_info);  --�������
            matcheslib.refresh_list(user_info);
        end
    else
        matcheslib.refresh_list(user_info);
    end
end

--�����б�
cmdHandler =
{
    ["MATCHTTPREJ"] = matcheslib.on_recv_pre_join_match,
    ["MATCHTTLIST"] = matcheslib.on_recv_match_list,
    ["MATCHTTJM"]   = matcheslib.on_recv_join_match,
    ["MATCHTTAFFIRM"] = matcheslib.on_recv_join_match_affirm,
    ["MATCHJXGZ"]   = matcheslib.on_recv_continue_watch,
    ["MATCHTTGIVEUP"] = matcheslib.on_recv_match_give_up,
    ["MATCHTTRULE"] = matcheslib.on_recv_match_rule,

    --������ͨѶЭ��
    ["MATCHTTTIXING"] = matcheslib.on_recv_tixing,
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end


eventmgr:addEventListener("h2_on_user_login", matcheslib.on_after_user_login)
eventmgr:addEventListener("on_buy_chouma", matcheslib.on_buy_chouma)
eventmgr:addEventListener("on_send_buy_chouma", matcheslib.on_send_buy_chouma);
eventmgr:addEventListener("timer_second", matcheslib.on_timer_second);
eventmgr:addEventListener("on_try_start_game", matcheslib.on_try_start_game);
eventmgr:addEventListener("on_server_start", matcheslib.on_server_start);
eventmgr:addEventListener("back_to_hall", matcheslib.on_back_to_hall);
eventmgr:addEventListener("do_kick_user_event", matcheslib.on_user_exit);
eventmgr:addEventListener("on_send_duokai_sub_desk", matcheslib.on_send_duokai_sub_desk);
eventmgr:addEventListener("on_after_fapai", matcheslib.on_after_fapai);
eventmgr:addEventListener("on_sub_user_back_to_hall", matcheslib.on_sub_user_back_to_hall);
eventmgr:addEventListener("site_event", matcheslib.on_user_sitdown);
eventmgr:addEventListener("on_force_game_over", matcheslib.on_force_game_over);

