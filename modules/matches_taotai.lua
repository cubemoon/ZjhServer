------------------------------------�¼��Ƴ�----------------------------------------
if matches_taotai_lib and matches_taotai_lib.on_game_over then
	eventmgr:removeEventListener("game_event", matches_taotai_lib.on_game_over)
end
if matches_taotai_lib and matches_taotai_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", matches_taotai_lib.on_after_user_login)
end
if matches_taotai_lib and matches_taotai_lib.on_timer_second then
	eventmgr:removeEventListener("timer_second", matches_taotai_lib.on_timer_second)
end

if matches_taotai_lib and matches_taotai_lib.on_user_exit then
	eventmgr:removeEventListener("do_kick_user_event", matches_taotai_lib.on_user_exit)
end

if matches_taotai_lib and matches_taotai_lib.on_user_exit then
	eventmgr:removeEventListener("before_kick_sub_user", matches_taotai_lib.on_user_exit)
end

if matches_taotai_lib and matches_taotai_lib.on_server_start then
	eventmgr:removeEventListener("on_server_start", matches_taotai_lib.on_server_start)
end

if matches_taotai_lib and matches_taotai_lib.on_watch_event then
    eventmgr:removeEventListener("on_watch_event", matches_taotai_lib.on_watch_event);
end

if matches_taotai_lib and matches_taotai_lib.on_back_to_hall then
    eventmgr:removeEventListener("back_to_hall", matches_taotai_lib.on_back_to_hall);
end

if matches_taotai_lib and matches_taotai_lib.on_user_exit then
    eventmgr:removeEventListener("on_sub_user_back_to_hall", matches_taotai_lib.on_user_exit);
end

if matches_taotai_lib and matches_taotai_lib.on_parent_user_add_watch then
    eventmgr:removeEventListener("on_parent_user_add_watch", matches_taotai_lib.on_parent_user_add_watch);
end
--[[
if matches_taotai_lib and matches_taotai_lib.on_user_queue then
    eventmgr:removeEventListener("on_user_queue", matches_taotai_lib.on_user_queue)
end
--]]


--------------------------------------------------------------------------------------

--�µı�����
if not matches_taotai_lib then
matches_taotai_lib = 
{
-----------------------------�����ӿ�------------------------
    get_user_match_info = NULL_FUNC,--��ȡ�û�������Ϣ 
    get_match_list = NULL_FUNC,--��ȡ�����û��б�
    get_match_user_count = NULL_FUNC,--��ȡ��ǰ����������
    get_current_match_id = NULL_FUNC,--��ȡ��ǰ���ڱ����ı���id
    process_give_up      = NULL_FUNC,--��;��������

-------------------------------���緢��-------------------------------
    net_send_match_all_rank_list = NULL_FUNC,--���������б�
    net_send_match_rank_list = NULL_FUNC,--���������б�
    net_send_match_change_taotai_jifen = NULL_FUNC,--������̭�ָı���
    net_send_match_result = NULL_FUNC,--���͸����ÿһ�̵Ľ��
    net_send_match_all_begin = NULL_FUNC,--���͸���������Զ��Ŷӣ���ʾ������һ�ֱ���
    net_send_match_prize = NULL_FUNC,--���ͱ�������
    net_send_match_user_info = NULL_FUNC,--���͸�����Ϣ
    net_send_match_msg = NULL_FUNC,--���Ͳ���
    net_send_match_user_taotai = NULL_FUNC,--�û�����̭


--------------------------------�����շ�----------------------------------------

    on_recv_match_info = NULL_FUNC,--�յ���ȡ������Ϣ
    on_recv_match_join = NULL_FUNC,--�յ��Զ��Ŷ�����
    on_recv_match_baoming_check = NULL_FUNC,--�յ��������
    on_recv_commonsvr_match_config = NULL_FUNC,--�յ�gs�������ı�������
    on_recv_commonsvr_match_online = NULL_FUNC,--�յ�gs�������ı����������

-----------------------------�ڲ��ӿ�--------------------------------
    set_match_user_wait = NULL_FUNC,--�����û��ȴ�
    set_match_user_taotai = NULL_FUNC,--�����û�����̭
    init_match_config = NULL_FUNC,--��ʼ����������
    count_still_playing_desks = NULL_FUNC,--���㻹�ж�����̨û�д���
    end_first_match = NULL_FUNC,--��������
    end_second_match = NULL_FUNC,--��������
    process_taotai = NULL_FUNC, --������̭����
    send_desk_match_chat = NULL_FUNC,--�������������Ϣ
    process_rank_list = NULL_FUNC,--����ҽ�������
    give_user_prize = NULL_FUNC, --����ҷ���
    check_match_room = NULL_FUNC,--����Ƿ��������
    update_match_to_commonsrv = NULL_FUNC,--���±�����Ϣ������������
   
---------ϵͳ�¼�----------------------------------------------
    on_after_user_login = NULL_FUNC,            --��¼�¼�
    on_game_over = NULL_FUNC,                   --�����¼�
    on_timer_second = NULL_FUNC,                --����ʱ����
    on_user_exit = NULL_FUNC,                   --�û��˳�
    on_server_start = NULL_FUNC,                --��Ϸ����    
    on_parent_user_add_watch = NULL_FUNC,       --�࿪�л�
-----------------------------------ϵͳ���ýӿ�----------------------------  
    g_on_game_start = NULL_FUNC,                 --��Ϸ��ʼ
    g_can_enter_game  = NULL_FUNC,               --�Ƿ���Խ�����Ϸ
    g_check_match_room = NULL_FUNC,
    try_start_match = NULL_FUNC,            --��ȡ�����û����б�
------------------------���͵��ͻ��˵�Э�麯��----------------------------------------
    --�û�������Ϣ
    user_list = {
    },

    --ȫ�ֱ���
    match_list = {
    },

    --�û����ߺ�������
    user_offline_list = {
        
    },

    commonsrv_match_list = {
    },

    refresh_rank_list = {
    },

    --�����ò���,�����뿴config_for_yunyin.lua
    OP_BAOMING_SAIBI = {},
    OP_MATCH_PRIZE = {},
    OP_CHANGE_MATCH_BASE_RATE_TIME = {},
    OP_FIRST_MATCH_BASE_JIFEN = {},
    OP_FIRST_MATCH_BASE_RATE = {},
    OP_FIRST_MATCH_END_COUNT = {},
    OP_FIRST_MATCH_END_JIFEN_RATE = {},
    OP_FIRST_MATCH_END_MATCH_COUNT = {},
    OP_FIRST_MATCH_INC_RATE = {},
    OP_MATCH_START_COUNT={},
    OP_MATCH_TAOTAI_RATE={},
    OP_SECOND_MATCH_END_JIFEN_RATE = {},
    OP_SECOND_MATCH_END_MATCH_COUNT={},
    OP_SECOND_MATCH_BASE_RATE = {},
    OP_MATCH_NAMES = {},
    OP_JINJI_TIMEOUT = {},
    OP_WIN_ADD_MATCH_EXP = {},
    init_config = function()
        local peilv_arr = {1000};
        for k, v in pairs(peilv_arr) do
            if(matches_taotai_lib.OP_MATCH_PRIZE[v] == nil) then
                matches_taotai_lib.OP_SECOND_MATCH_END_MATCH_COUNT[v] = {};
                matches_taotai_lib.OP_MATCH_NAMES[v] = {};
                matches_taotai_lib.OP_MATCH_PRIZE[v] = {};
    
                for i=1, 30 do 
                    --��ʼ��30���Ľ�Ʒ�ṹ
                    matches_taotai_lib.OP_MATCH_PRIZE[v][i] = {};
                end
            end
        end
    end,

    --�ڲ����ñ���
    CONFIG_BAOMING_SAIBI = 0,
    CONFIG_CHANGE_MATCH_BASE_RATE_TIME = 999999999,
    CONFIG_FIRST_MATCH_BASE_JIFEN = 5000,
    CONFIG_FIRST_MATCH_BASE_RATE = 0,
    CONFIG_FIRST_MATCH_END_COUNT = 1,
    CONFIG_FIRST_MATCH_END_JIFEN_RATE = 1,
    CONFIG_FIRST_MATCH_END_MATCH_COUNT = 1,
    CONFIG_FIRST_MATCH_INC_RATE = 0,
    CONFIG_MATCH_START_COUNT=48,
    CONFIG_MATCH_TAOTAI_RATE=0,
    CONFIG_SECOND_MATCH_END_JIFEN_RATE = 1,
    CONFIG_SECOND_MATCH_END_MATCH_COUNT={},
    CONFIG_MATCH_NAMES={},
    CONFIG_SECOND_MATCH_BASE_RATE = 0,
    CONFIG_MATCH_PRIZE={},
    CONFIG_JINJI_TIMEOUT = 5,
    CONFIG_WIN_ADD_MATCH_EXP = 1,
}
end

------------------------------------��������--------------------------------

matches_taotai_lib.log_user_match_record = function(user_id, result)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    if(user_match_info.match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(user_match_info.match_id);
        local rank = 0;
        for k, v in pairs(list.rank_list) do
            if(v.userId == user_id) then
                rank = k;
                break;
            end
        end
        local sql = "insert into log_taotai_match(user_id, match_id, match_result, match_status, panshu, rank, sys_time, group_id, jifen) values(%d, %s, %d, %d, %d, %d, NOW(), %d, %d);commit;";
        if(duokai_lib and duokai_lib.is_sub_user(user_id) == 1) then
            user_id = duokai_lib.get_parent_id(user_id);
        end
        sql = string.format(sql, user_id, dblib.tosqlstr(user_match_info.match_id), result or 0, list.match_info.status, user_match_info.panshu, rank, tonumber(groupinfo.groupid), user_match_info.jifen);
        dblib.execute(sql);
    end
end

matches_taotai_lib.get_current_match_id = function()
    return table.maxn(matches_taotai_lib.match_list); 
end

--[[
@desc ��ȡ�û�������Ϣ
@param user_id �û�id 
--]]
matches_taotai_lib.get_user_match_info = function(user_id) 
    local user_match_info = {
        match_id=nil,--����id
        jifen=0,--����
        begin_time=0,--�������������Ŷ�ʱ��
        user_id=user_id,--�û�id
        panshu=0,--�û�����
        first_jifen = 0,--Ԥ������
        --nRegSiteNo = 0,--�û�regsite
        notify_continue = 0,--֪ͨ�û��Ƿ������
    };
    if(matches_taotai_lib.user_list[user_id] ~= nil) then
        user_match_info = matches_taotai_lib.user_list[user_id];
    else
        matches_taotai_lib.user_list[user_id] = user_match_info;
    end
    return user_match_info;
end

matches_taotai_lib.remove_wait_list = function(user_id)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    if(user_match_info.match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(user_match_info.match_id);
        if(list.wait_list[user_id] ~= nil) then
            list.wait_list[user_id] = nil;
        end
    end
end

--[[
@desc ��ȡ�����б�
@param match_id ������id
--]]
matches_taotai_lib.get_match_list = function(match_id) 
    local match_list = {
        match_list = {},--�����е��û�
        taotai_list = {},--�Ѿ���̭���û�
        taotai_desk_list = {},--��������̭���û�
        wait_list = {},--�ȴ��е��û�
        rank_list = {},--���������б�
        play_list = {},--���ڴ��Ƶ��û�
        match_info = {
            status = 0,--����״̬,0δ��ʼ,1:����,2:����, 3:������2�� 4:������3�� 5:������4��
            base_rate = matches_taotai_lib.CONFIG_FIRST_MATCH_BASE_RATE,--��Ϸ����
            taotai_jifen = matches_taotai_lib.CONFIG_FIRST_MATCH_BASE_RATE * matches_taotai_lib.CONFIG_MATCH_TAOTAI_RATE,--������̭����
            begin_time = 0,--������ʼʱ��
            panshu= 0,--ÿһ������ͳ��
            change_base_rate_time=0,--Ԥ���������ı�ʱ��
            finish_taotai_time=0,--֪ͨ�����̭ʱ��
            end_time = 0,--��һ�ֽ���ʱ��,
            unfinished_desk = {},--û�н��������
            match_count = 0,--��������
            notify_wait_next = 0,
        },
    };

    if(matches_taotai_lib.match_list[match_id] ~= nil) then
        match_list = matches_taotai_lib.match_list[match_id];
    else
        matches_taotai_lib.match_list[match_id] = match_list;
    end

    return match_list;
end

-----------------------------------�����շ�--------------------------------------------------------

matches_taotai_lib.on_recv_match_baoming_check = function(buf) 
     --TraceError('on_recv_match_baoming_check');
    local user_info = userlist[getuserid(buf)];
    if(not user_info) then return end;
    local groupid = buf:readInt();
    local code = 1;
    local sendFunc = function(buf)
        buf:writeString('MATCHTTBMC');
        buf:writeInt(code);
    end
    if matcheslib.user_list[user_info.userId] ~= nil and matches_taotai_lib.commonsrv_match_list[groupid] ~= nil and matcheslib.user_list[user_info.userId].match_gold  < matches_taotai_lib.commonsrv_match_list[groupid].baoming_saibi then
        code = 0;
    end
    netlib.send(sendFunc, user_info.ip, user_info.port);
end

matches_taotai_lib.process_give_up = function(user_id)
    local user_info = usermgr.GetUserById(user_id);
    if(user_info ~= nil) then
        user_info.last_open_match_rank_time = nil;
    end
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    if(user_match_info.match_id ~= nil) then
        local match_id = user_match_info.match_id;
        local list = matches_taotai_lib.get_match_list(match_id);
        if(list.match_info.status == 0 and list.match_list[user_id] ~= nil) then
            --����δ��ʼ,��������
            
            matches_taotai_lib.log_user_match_record(user_id, -3);
            user_match_info.match_id = nil;
            list.match_list[user_id] = nil;
            list.wait_list[user_id] = nil;
            --matcheslib.l_add_user_match_gold_db(user_info,matches_taotai_lib.CONFIG_BAOMING_SAIBI,matcheslib.STATIC_ADD_GOLD_TYPE_TAOTAI_GIVEUP,0);
            --matches_db.record_back_match_gold(user_id, matches_taotai_lib.CONFIG_BAOMING_SAIBI);
            
            matches_taotai_lib.process_rank_list(match_id);
            --matches_taotai_lib.update_match_to_commonsrv(user_match_info, match_id);
	        user_match_info.match_id = nil;
            matches_taotai_lib.net_send_match_all_rank_list(match_id);
        elseif(list.match_info.status > 0) then
            matches_taotai_lib.set_match_user_taotai(match_id, user_id);
            matches_taotai_lib.check_match_end(match_id);
            matches_taotai_lib.net_send_match_all_rank_list(match_id);
        end
    end
end

matches_taotai_lib.on_recv_match_info = function(buf) 
    --TraceError('on_recv_match_info');
    local user_info = userlist[getuserid(buf)];
    if(not user_info) then return end;
    local groupid  = buf:readInt();
    local match_info = matches_taotai_lib.commonsrv_match_list[groupid];

    netlib.send(function(buf)
        buf:writeString("MATCHTTINFO");
        buf:writeInt(groupid);
        buf:writeString(_U(match_info.groupname));
        buf:writeInt(match_info.match_start_count);
        buf:writeInt(match_info.start_time);
        buf:writeInt(match_info.end_time);
        buf:writeInt(match_info.baoming_count or 0);
        buf:writeInt(match_info.total_user_count or 0);
        buf:writeInt(1);
        buf:writeString(_U(match_info.baoming_saibi..'����'));
        buf:writeInt(#match_info.prize_list);
        for k, v in pairs(match_info.prize_list) do
            buf:writeInt(k);
            buf:writeInt(v[1].prize_value);
        end
    end, user_info.ip, user_info.port);
end

--[[
matches_taotai_lib.auto_join_desk = function(match_user_list)
    --��ȡ�û���ǰ���������еȴ�����������
    if(table.maxn(match_user_list) > 0) then
        --�ҵ���Ҫ�Ŷӵ����
        local join_list = {};
        for k, v in pairs(match_user_list) do
            local user_info = usermgr.GetUserById(k);
            if(user_info) then
                if(user_info.desk ~= nil and user_info.desk > 0 and 
                   user_info.site ~= nil and user_info.site > 0) then
                       --�жϷ��俪ʼ��û��
                       local state = hall.desk.get_site_state(user_info.desk, user_info.site);
                       if(state ~= SITE_STATE.PLAYING) then
                           table.insert(join_list, k);
                       else
                           TraceError("who??"..k.." "..tostringex(match_user_list));
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

        if(#join_list > 2) then
            for k, v in pairs(desklist) do
                if(#join_list < 3) then
                    break;
                end
                local nstart = false; 
                local execok, ret = xpcall(function() return gamepkg.getGameStart(k); 
                                    end, throw);
				if execok then
					nstart = ret
                end

                if(nstart == false) then
                    --���������Ϊ�����ӵ�����ȥ
                    local can_join = 1;
                    for i=1, room.cfg.DeskSiteCount do
                        if (desklist[k].site[i].user ~= nil) then
                            can_join = 0; 
                        end
                    end
                    --��������������ȥ
                    if(can_join == 1) then
                        --TraceError('�ҵ�������'..k);
                        for i=1, room.cfg.DeskSiteCount do
                            local user_id = join_list[1];
                            local user_info = usermgr.GetUserById(user_id);
                            local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
                            user_match_info.notify_continue = 0;
                            match_user_list[user_id] = nil; 
                            matches_taotai_lib.remove_wait_list(user_id);
                            matches_taotai_lib.set_match_user_play(user_id);
                            table.remove(join_list, 1);
                            if(user_info) then
                                --����
                                --TraceError('����'..user_info.userId);
                                ResetUser(user_info.key, true);
                                doSitdown(user_info.key, user_info.ip, user_info.port, k, i);
                            end
                        end
                    end
                end
            end
        end
    end
end
--]]

matches_taotai_lib.is_taotai = function(match_id, user_id)
    local match_list = matches_taotai_lib.get_match_list(match_id);
    local ret = 0;
    if(match_list.taotai_list[user_id] ~= nil) then
        ret = 1;
    end
    return ret;
end

matches_taotai_lib.on_recv_match_join = function(buf)
    local user_info = userlist[getuserid(buf)];
    if(not user_info) then return end;
    --TraceError('on_recv_match_join'..user_info.userId);
    local action = buf:readInt();
    if(action == 1) then
        --TraceError("û�не���");
    end

    --�Զ����� 
    matches_taotai_lib.on_user_queue(user_info.userId);
    
    --�Զ���������
    local match_user_list = matches_taotai_lib.try_start_match(user_info.userId, action);
    --TraceError(match_user_list);
    --[[
    if(match_user_list[user_info.userId] ~= nil) then
        matches_taotai_lib.auto_join_desk(match_user_list);
    end
    --]]
end

matches_taotai_lib.on_recv_commonsvr_match_online = function(buf)
    if(gamepkg.name ~= "commonsvr" and groupinfo.match_type ~= 2) then
        return;
    end
    local groupid = buf:readInt();
    local total_user_count = buf:readInt();
    local baoming_count = buf:readInt();
    if(matches_taotai_lib.commonsrv_match_list[groupid] == nil) then
        return;
    end
    matches_taotai_lib.commonsrv_match_list[groupid].total_user_count = total_user_count;
    matches_taotai_lib.commonsrv_match_list[groupid].baoming_count = baoming_count;
end

matches_taotai_lib.on_recv_commonsvr_match_config = function(buf)
    if(gamepkg.name ~= "commonsvr" and groupinfo.match_type ~= 2) then
        return;
    end
    --TraceError("�յ�gs�����ı�������");
    local groupid = buf:readInt();
    local groupname = buf:readString();
    local match_start_count = buf:readInt();
    local baoming_saibi = buf:readInt();
    local start_time = buf:readInt(); 
    local end_time = buf:readInt();
    local len = buf:readInt();
    local prize_list = {};
    local rank = 0;
    local prize_value = 0;
    local prize_type = 0;
    local prize_name = 0;
    for i=1, len do
        rank  = buf:readInt();
        local len2 = buf:readInt();
        prize_list[rank] = {};
        for i=1, len2 do
            prize_value = buf:readInt();
            prize_type = buf:readInt();
            prize_name = buf:readString();
            table.insert(prize_list[rank],{
                prize_value=prize_value,
                prize_type=prize_type,
                prize_name=prize_name});
        end
    end

    matches_taotai_lib.commonsrv_match_list[groupid] = {
        groupname=groupname,
        match_start_count=match_start_count,
        baoming_saibi=baoming_saibi,
        start_time=start_time,
        end_time=end_time,
        prize_list=prize_list,
    };
end

-----------------------------------���緢��--------------------------------------------------

matches_taotai_lib.net_send_match_condition = function(user_info)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
    if(user_match_info.match_id ~= nil) then
        local match_info = matcheslib.get_match_info(user_match_info.match_id);
        if(match_info ~= nil) then
            --TraceError('net_send_match_condition');
            netlib.send(function(buf)
                buf:writeString("MATCHTTCO");
                buf:writeString(user_match_info.match_id);
                buf:writeString(match_info.match_name or "");
            end, user_info.ip, user_info.port);
        end
    end
end

matches_taotai_lib.net_send_match_user_taotai = function(user_info, rank, is_over, match_count, match_name)
    if(rank <= 2) then
        is_over = 1;
    end
    --��������
    if(user_info) then
        netlib.send(function(buf)
            buf:writeString("MATCHTTTT");
            buf:writeInt(rank);
            buf:writeByte(is_over or 0);
            buf:writeInt(match_count or 0);
            buf:writeString(match_name or "");
        end, user_info.ip, user_info.port);
    end
end

--[[
@desc ���Ͳ���
@param user_id �û�id
@param msg_type �������� 1:����������������������󽫵ȴ�������������
]]--
matches_taotai_lib.net_send_match_msg = function(user_id, msg_type)
    local user_info = usermgr.GetUserById(user_id);
    if(user_info) then
        netlib.send(function(buf)
            buf:writeString("MATCHTTBB");
            buf:writeInt(msg_type);
        end, user_info.ip, user_info.port);
    end
end

matches_taotai_lib.net_send_back_match_gold = function(user_info, back_match_gold)
    netlib.send(function(buf)
        buf:writeString("MATCHTTBMG");
        buf:writeInt(back_match_gold);
    end, user_info.ip, user_info.port)
end


matches_taotai_lib.net_send_match_user_info = function(user_id)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    local user_info = usermgr.GetUserById(user_id);
    if(user_match_info.match_id ~= nil and user_info) then
        netlib.send(function(buf)
            buf:writeString("MATCHTTMYINFO");
            buf:writeInt(user_match_info.jifen);
            buf:writeInt(user_match_info.panshu);
            buf:writeInt(user_match_info.first_jifen);
        end, user_info.ip, user_info.port);
    end
end

matches_taotai_lib.net_send_match_prize = function(user_info, rank, prize_list, begin_time, is_over, match_count, match_name)
    if(user_info) then
        netlib.send(function(buf)
            buf:writeString("MATCHTTGP");
            buf:writeInt(rank);
            buf:writeInt(#prize_list);
            for k, v in pairs(prize_list) do
                buf:writeInt(v.prize_type);
                buf:writeInt(v.prize_value);
            end
            buf:writeInt(begin_time);
            buf:writeByte(is_over or 0);
            buf:writeInt(match_count or 0);
            buf:writeString(match_name or "");
        end, user_info.ip, user_info.port);
    end
end

--[[
@desc �����������û�������һ�ֱ���
@param match_id ����id
]]--
matches_taotai_lib.net_send_match_all_begin = function(match_id)
    local list = matches_taotai_lib.get_match_list(match_id);
    for k, v in pairs(list.match_list) do
       matches_taotai_lib.net_send_match_result(k, (list.match_info.status == 1 and 3 or 4), matches_taotai_lib.CONFIG_JINJI_TIMEOUT);
    end
end

--[[
@desc ����ÿһ�̱����Ľ��
@user_info �û���Ϣ
@result ���, 1:����ҵȴ�������� 2��������Զ��Ŷ� 3:������Զ��ŶӲ�����ʾ�û�������,�������Ͽ�ʼ
]]--
matches_taotai_lib.net_send_match_result = function(user_id, result, timeout, unfinished_count, show_timeout)
    local user_info = usermgr.GetUserById(user_id);
    if(user_info) then 
        --����ʱ����
        local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
        if(user_match_info.match_id == nil) then
            return;
        end
        local match_info = matcheslib.get_match_info(user_match_info.match_id);
        --[[
        if(result > 1) then
            --TraceError('result'..result);
            local list = matches_taotai_lib.get_match_list(user_match_info.match_id);
            local match_status = list.match_info.status;
            local match_id = user_match_info.match_id;
            if(timeout ~= nil and timeout > 0) then
                timelib.createplan(function()
                    --������Զ���������
                    local new_user_match_info = matches_taotai_lib.get_user_match_info(user_id);
                    if(list.match_info.status == match_status 
                       and new_user_match_info.match_id == match_id
                       and list.taotai_list[user_id] == nil) then
                        matches_taotai_lib.set_match_user_wait(user_id);
                        matches_taotai_lib.process_wait_list(match_id);
                        matches_taotai_lib.log_user_match_record(user_id, result);


                        local match_count = matches_taotai_lib.get_match_user_count(match_id, "match");
                        local play_count = matches_taotai_lib.get_match_user_count(match_id, "play");
                        local left_count = match_count - play_count;
                        if(left_count < 3 and left_count > 0 
                           and list.match_info.notify_wait_next == 0 
                           and list.match_info.status > 1) then
                            --�ҵ����������ճ�һ�����û�
                            list.match_info.notify_wait_next = 1;
                            for k, v in pairs(list.match_list) do
                                if(list.play_list[k] == nil) then
                                    --����������
                                    timelib.createplan(function()
                                        list.match_info.notify_wait_next = 0;
                                        local user_info = usermgr.GetUserById(k);
                                        if(user_info ~= nil) then
                                            new_user_match_info = matches_taotai_lib.get_user_match_info(user_id);
                                            if(list.match_info.status == match_status 
                                               and new_user_match_info.match_id == match_id
                                               and list.taotai_list[user_id] == nil) then
                                                local unfinished_count = matches_taotai_lib.count_still_playing_desks(match_id, 0, {}, os.time());
                                                netlib.send(function(buf)
                                                    buf:writeString("MATCHTTRS");
                                                    buf:writeInt(list.match_info.status == 1 and 5 or 6);
                                                    buf:writeInt(-1);
                                                    buf:writeInt(unfinished_count or 0);
                                                    buf:writeInt(0);
                                                end, user_info.ip, user_info.port);
                                           end
                                        end
                                    end, 2);
                                end
                            end
                        end
                    end
                end, timeout+5);--������ʱ��Ϊ������ʱ��
            else
                --������Զ���������
                matches_taotai_lib.set_match_user_wait(user_id);
                matches_taotai_lib.process_wait_list(user_match_info.match_id);
                matches_taotai_lib.log_user_match_record(user_id, result);
            end
        else
            matches_taotai_lib.log_user_match_record(user_id, result);
        end
        --]]
        matches_taotai_lib.log_user_match_record(user_id, result);

        netlib.send(function(buf)
            buf:writeString("MATCHTTRS");
            buf:writeInt(result);
            buf:writeInt(timeout or -1);
            buf:writeInt(unfinished_count or 0);
            buf:writeInt(show_timeout or 1);
            buf:writeInt(match_info.smallbet or 0);
            buf:writeInt(match_info.largebet or 0);
        end, user_info.ip, user_info.port);
    end
end

matches_taotai_lib.net_send_match_change_taotai_jifen = function(match_id, match_count)
    local list = matches_taotai_lib.get_match_list(match_id);
    for k, v in pairs(list.match_list) do
        local user_info = usermgr.GetUserById(k);
        matches_taotai_lib.net_send_match_taotai_jifen(user_info, match_id, match_count);
    end
end

matches_taotai_lib.net_send_match_taotai_jifen = function(user_info, match_id, match_count)
    local list = matches_taotai_lib.get_match_list(match_id);
    local match_start_time = matcheslib.get_match_start_time(match_id);
    if(user_info ~= nil) then
        netlib.send(function(buf)
            buf:writeString("MATCHTTCJF");
            buf:writeInt(list.match_info.taotai_jifen);
            buf:writeInt(list.match_info.base_rate);
            buf:writeInt(list.match_info.status);
            local status = list.match_info.status > 1 and 2 or 1;
            buf:writeString(":");
            buf:writeInt(list.match_info.status > 0 and (os.time() - list.match_info.begin_time) or 0);
            buf:writeInt(match_count or -1);
            buf:writeInt(list.match_info.status <= 0 and (match_start_time - os.time()) or 0);
        end, user_info.ip, user_info.port);
    end
end

function matches_taotai_lib.net_send_match_all_rank_info(match_id)
    local list = matches_taotai_lib.get_match_list(match_id);
    local rank_list, left_num = matches_taotai_lib.get_match_rank_list(match_id);
    for k, v in pairs(rank_list) do
        local user_info = usermgr.GetUserById(v.userId);
        if(user_info ~= nil) then
            local user_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
            if((user_match_info.match_id == match_id or user_match_info.match_id == nil) and user_match_info.is_taotai == nil) then
                if(user_info.desk and matcheslib.desk_list[user_info.desk] ~= nil and 
                   matcheslib.desk_list[user_info.desk] == match_id) then
                    if(v.rank == nil) then
                        v.rank = k;
                    end
                    matches_taotai_lib.net_send_match_rank_info(user_info, v, left_num, #rank_list);
                end
            end
        end
    end
end

function matches_taotai_lib.net_send_match_rank_info(user_info, rank_info, left_num, total_num)
    netlib.send(function(buf)
        buf:writeString("MATCHTTRANK");
        buf:writeInt(rank_info.rank);
        buf:writeInt(rank_info.jifen);
        buf:writeInt(left_num);
        buf:writeInt(total_num);
    end, user_info.ip, user_info.port);
end

function matches_taotai_lib.net_send_match_all_rank_list(match_id)
    matches_taotai_lib.refresh_rank_list[match_id] = 1;
end

matches_taotai_lib.net_send_match_all_rank_list_ex = function(match_id)
    local list = matches_taotai_lib.get_match_list(match_id);
    local rank_list = matches_taotai_lib.get_match_rank_list(match_id);
    local count = 0;
    for k, v in pairs(list.match_list) do
        local user_info = usermgr.GetUserById(k);
        if(user_info ~= nil and user_info.open_match_rank_panel ~= nil and 
           user_info.open_match_rank_panel == match_id and count < 24) then --ֻˢ��24���ͻ���
            count = count + 1;
            matches_taotai_lib.net_send_match_rank_list(user_info, rank_list);
        end
    end

    for k, v in pairs(list.taotai_list) do
        local user_info = usermgr.GetUserById(k);
        if(user_info ~= nil and user_info.open_match_rank_panel ~= nil and 
           user_info.open_match_rank_panel == match_id and count < 24) then --ֻˢ��24���ͻ���
            local user_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
            if((user_match_info.match_id == match_id or user_match_info.match_id == nil) and user_match_info.is_taotai == nil) then
                if(user_info.desk and matcheslib.desk_list[user_info.desk] ~= nil and 
                   matcheslib.desk_list[user_info.desk] == match_id) then
                    count = count + 1;
                    matches_taotai_lib.net_send_match_rank_list(user_info, rank_list);
                end
            end
        end
    end
end

matches_taotai_lib.net_send_match_rank_list = function(user_info, all_rank_list)
    matches_taotai_lib.split_start(user_info.ip, user_info.port, "MATCHTTRLISTSTART");
    local send_count = 0
    local max_count = 100
	repeat
        send_count = matches_taotai_lib.split_send("MATCHTTRLISTEX", all_rank_list, function(buf_out, v, k)
            --buf_out:writeString(v);
            -- [[
            local user_match_info = matches_taotai_lib.get_user_match_info(v.userId);
            buf_out:writeString(v.nick or "")--�ǳ�
            buf_out:writeInt(v.userId or 0)--�û�id
            buf_out:writeString(v.imgUrl or "")--�û�ͷ��
            buf_out:writeInt(v.rank == nil and k or v.rank)--����
            buf_out:writeInt(v.jifen or 0)--�û�����
            buf_out:writeInt(user_match_info.panshu or 0);
            buf_out:writeInt(v.is_taotai or 0);
            --]]
        end)
		max_count = max_count - 1
		if max_count <= 0 then
			break
		end
	until(send_count <= 0)
    matches_taotai_lib.split_end("MATCHTTRLISTEND")
    --[[
    netlib.send(function(buf_out)
        buf_out:writeString("MATCHTTRLIST")
        buf_out:writeInt(#all_rank_list)
        for k,v in pairs(all_rank_list) do
            buf_out:writeString(v.nick or "")--�ǳ�
            local user_match_info = matches_taotai_lib.get_user_match_info(v.userId);
            buf_out:writeInt(v.userId or 0)--�û�id
            buf_out:writeString(v.imgUrl or "")--�û�ͷ��
            buf_out:writeInt(v.rank == nil and k or v.rank)--����
            buf_out:writeInt(v.jifen or 0)--�û�����
            buf_out:writeInt(user_match_info.panshu or 0);
            buf_out:writeInt(0);
            buf_out:writeInt(0);
            buf_out:writeInt(v.is_taotai or 0);
        end
        buf_out:writeInt(taotai_line); 
    end, user_info.ip, user_info.port);
    --]]
end

-----------------------------------�ڲ�����---------------------------------------------------------- 

matches_taotai_lib.set_match_user_wait = function(user_id) 
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    local match_id = user_match_info.match_id;
    if(match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(match_id);
        if(list.match_list[user_id] ~= nil) then
            list.wait_list[user_id] = 1;
        end
    end
end

--[[
matches_taotai_lib.update_match_to_commonsrv = function(user_match_info, match_id) 
    local list = matches_taotai_lib.get_match_list(match_id);
    if(list.match_info.status == 0) then
        local count = matches_taotai_lib.get_match_user_count(match_id);
        --֪ͨcommonsrv�ı��˱���������
        local total_count = usermgr.GetTotalUserCount(user_match_info.nRegSiteNo);
        local send_func = function(buf)
            buf:writeString("MATCHTTOL");
            buf:writeInt(groupinfo.groupid);
            buf:writeInt(total_count);
            buf:writeInt(count);
        end;
        send_buf_to_all_game_svr(send_func, "commonsvr");
        send_buf_to_all_game_svr(send_func, "hldz_taotai");
    end
end
--]]

matches_taotai_lib.check_match_room = function()
    return matcheslib.check_match_room();
end

function matches_taotai_lib.do_give_prize(user_info, prize_list)
    local new_prize_list = {};
    if(user_info) then
        --���з���
        for k, v in pairs(prize_list) do
            if(v.prize_type == 10) then--��ȯ
                tex_gamepropslib.set_props_count_by_id(v.prize_type, v.prize_value, user_info);
            elseif(v.prize_type == 9027) then --������
                usermgr.addgold(user_info.userId, v.prize_value, 0, new_gold_type.TAOTAI_MATCH_PRIZE, -1);
            end
            table.insert(new_prize_list, v);
        end
    end
    return new_prize_list;
end

matches_taotai_lib.give_user_prize = function(user_id, rank, prize_list, match_id)
    local has_prize = 0;
    local new_prize_list = {};
    if(prize_list ~= nil) then
        local user_info = usermgr.GetUserById(user_id);
        local list = matches_taotai_lib.get_match_list(match_id);
        has_prize = 1;
        new_prize_list = matches_taotai_lib.do_give_prize(user_info, prize_list);
        matches_taotai_lib.net_send_match_prize(user_info, rank, new_prize_list, list.match_info.begin_time, (list.match_info.status > 1 and 1 or 0), list.match_info.match_count)
    end
    return has_prize;
end

matches_taotai_lib.process_rank_list = function(match_id)
    local list = matches_taotai_lib.get_match_list(match_id);
    local rank_list = {};
    for k, v in pairs(list.match_list) do
        local user_match_info = matches_taotai_lib.get_user_match_info(k);
        local user_info = usermgr.GetUserById(k);
        if(user_info ~= nil and user_match_info.match_id == match_id and match_id ~= nil) then
            table.insert(rank_list, {
                jifen=user_match_info.jifen,
                imgUrl=user_info.imgUrl,    
                nick=user_info.nick,
                userId=user_info.userId,
                deskno=user_info.desk,
                begin_time=user_match_info.begin_time,
            });
        end
    end

    table.sort(rank_list, function(d1, d2)
        if(d1.jifen == d2.jifen) then
            return d1.begin_time < d2.begin_time;
        else
            return d1.jifen > d2.jifen;
        end
    end);

    list.rank_list = rank_list;
end

matches_taotai_lib.send_desk_match_chat = function(desk, msg)
    --TraceError('�������������Ϣ'..desk);
    room.arg.chatType = 0
    room.arg.currchat = msg
    room.arg.currentuser = ""
    room.arg.userId  = 0
    room.arg.siteno  = 0
    --borcastDeskEventEx("REDC", desk);
end

matches_taotai_lib.send_match_chat = function(match_id, msg)
    local list = matches_taotai_lib.get_match_list(match_id);
    for k, v in pairs(list.match_list) do
        local user_info = usermgr.GetUserById(k);
        if(user_info ~= nil) then
            SendChatToUser(4, user_info, msg);
        end
    end
end

matches_taotai_lib.process_taotai = function(match_id, left_num, status)
    --��������
    matches_taotai_lib.process_rank_list(match_id);

    local list = matches_taotai_lib.get_match_list(match_id);
    local rank_list = list.rank_list;

    --local last_taotai_key = 0;
    for k, v in pairs(rank_list) do
        if(k > left_num) then
            --[[
            if(last_taotai_key == 0) then
                last_taotai_key = k;
            end
            --]]
            --������̭
            matches_taotai_lib.set_match_user_taotai(match_id, v.userId, 1, status);
        end
    end

    --[[
    if(last_taotai_key == 0) then
        --ʣ�µ����������Ҫ��̭�������
        last_taotai_key = #rank_list + 1;
    end

    --��ǰʣ�µ����
    local match_count = matches_taotai_lib.get_match_user_count(match_id, 'match');
    --�������һ���Ļ�����̭��
    local taotai_count = match_count % 3;
    if(taotai_count > 0 and match_count < 3) then
        for k, v in pairs(rank_list) do
            if(k < last_taotai_key and k >= (last_taotai_key - taotai_count)) then
                --������̭
                if(list.match_info.status == 2) then--�ս������ͽ�����
                    --TraceError('taotai ??'..k);
                    matches_taotai_lib.set_match_user_taotai(match_id, v.userId, k, status);
                end
            end
        end
    end
    --]]
end

matches_taotai_lib.end_first_match = function(match_id) 
    matches_taotai_lib.end_second_match(match_id);
    --[[
	--������һ������
    local list = matches_taotai_lib.get_match_list(match_id);
    --TraceError('end_first_match'..match_id..' status'..list.match_info.status);
    list.match_info.status = 2;
    list.match_info.base_rate = matches_taotai_lib.CONFIG_SECOND_MATCH_BASE_RATE;
    list.match_info.end_time = 0;
    list.match_info.panshu = 0;
    list.wait_list = {};
    list.play_list = {};

    list.match_info.taotai_jifen = list.match_info.base_rate * matches_taotai_lib.CONFIG_MATCH_TAOTAI_RATE; 

    matches_taotai_lib.process_taotai(match_id, matches_taotai_lib.CONFIG_FIRST_MATCH_END_MATCH_COUNT, 1);

    --���������˽�����ҵĻ���
    for k, v in pairs(list.match_list) do
        local user_match_info = matches_taotai_lib.get_user_match_info(k);
        if(user_match_info.match_id == match_id) then
            user_match_info.first_jifen = user_match_info.jifen;
            user_match_info.jifen = math.floor(math.sqrt(user_match_info.jifen)) * matches_taotai_lib.CONFIG_FIRST_MATCH_END_JIFEN_RATE;
        else
            TraceError("��bug�ˣ��û�����������������??user_id"..k);
        end
    end

    local match_count = matches_taotai_lib.get_match_user_count(match_id, 'match');
    list.match_info.match_count = match_count;
    --֪ͨ�ı������Ϣ
    matches_taotai_lib.net_send_match_change_taotai_jifen(match_id, match_count);

    --֪ͨ�����û���ʼ���������
    matches_taotai_lib.net_send_match_all_begin(match_id);
    --]]
end

matches_taotai_lib.check_user_taotai = function(user_id)
        local user_match_info = matches_taotai_lib.get_user_match_info(user_id);

        if(user_match_info.match_id == nil) then    
            return 3;
        end

        local match_info = matcheslib.get_match_info(user_match_info.match_id);

        if(match_info == nil) then
            TraceError("Ϊʲô���������ˣ�������û���û�б���̭");
            return 2;
        end

        local need_jifen = match_info.ante + match_info.largebet;
        local jifen = user_match_info.jifen - (match_info.ante or 0);

        if(need_jifen > jifen or jifen <= 0) then
            --����̭��
            matches_taotai_lib.set_match_user_taotai(user_match_info.match_id, user_id, 1);
            return 1;
        end
        return 0;
end

matches_taotai_lib.end_second_match = function(match_id) 
    local list = matches_taotai_lib.get_match_list(match_id);

    if(list.match_info.status > 5) then
        return;
    end

    --TraceError('end_second_match'..match_id..' status '..list.match_info.status);
    list.match_info.status = 6;--list.match_info.status + 1;
    list.match_info.end_time = 0;
    list.match_info.panshu = 0;
    list.wait_list = {};
    list.play_list = {};

    --������̭
    --matches_taotai_lib.process_taotai(match_id, matches_taotai_lib.CONFIG_SECOND_MATCH_END_MATCH_COUNT[list.match_info.status - 2]);

    matches_taotai_lib.process_taotai(match_id, 1);

    local match_user_count = matches_taotai_lib.get_match_user_count(match_id, 'match');
    if(match_user_count <= 1) then
        --����������
        --TraceError('����������');
        matches_taotai_lib.process_rank_list(match_id);
        matches_taotai_lib.net_send_match_all_rank_list(match_id);
        --��ձ���������
        local match_info = matcheslib.get_match_info(match_id);
        local rank_info = list.rank_list[1];
        for k, v in pairs(list.match_list) do
            --�������һ����ҵģ���
            local user_match_info = matches_taotai_lib.get_user_match_info(k);
            if(user_match_info.match_id == match_id) then
                --matches_taotai_lib.give_user_prize(k, 1, match_info.award[1], match_id);
                matches_taotai_lib.set_match_user_taotai(match_id, k, 1);
            end
            break;
        end

        --[[
        for k, v in pairs(list.taotai_list) do
            local user_match_info = matches_taotai_lib.get_user_match_info(k);
            if(user_match_info.match_id == match_id) then
                matches_taotai_lib.user_list[k] = nil;
            end
        end
        --]]

        matches_taotai_lib.match_list[match_id] = nil;
        matcheslib.on_match_end(match_id, rank_info);
    else
        --���������˵Ļ���
        if(matches_taotai_lib.CONFIG_SECOND_MATCH_END_JIFEN_RATE ~= 1) then
        	for k, v in pairs(list.match_list) do
        	    local user_match_info = matches_taotai_lib.get_user_match_info(k);
        	    if(user_match_info.match_id == match_id) then
                    user_match_info.jifen = user_match_info.jifen * matches_taotai_lib.CONFIG_SECOND_MATCH_END_JIFEN_RATE;
        	    else
                    TraceError("��bug�ˣ��û�����������������??user_id"..k);
        	    end
        	end
        end

        local match_count = matches_taotai_lib.get_match_user_count(match_id, 'match');
        list.match_info.match_count = match_count;
        matches_taotai_lib.net_send_match_change_taotai_jifen(match_id, match_count);
        matches_taotai_lib.net_send_match_all_begin(match_id);
    end
end

matches_taotai_lib.count_still_playing_desks = function(match_id, deskno, unfinished_desk, end_time)
    --TraceError("count_still_playing_ cur_deskno"..deskno);
    local list = matches_taotai_lib.get_match_list(match_id);
    for user_id,_ in pairs(list.match_list) do
    	local v = usermgr.GetUserById(user_id);
    	if(v ~= nil) then
    		if v.desk ~= nil then   --�Ƿ�������
    		    local desk = desklist[v.desk]
    		    if desk.game.startTime ~= nil and desk.game.startTime ~= 0 then --�Ƿ��п���ʱ��
    			 if timelib.db_to_lua_time(desk.game.startTime) < end_time then  --�Ƿ��ڽ���֮ǰ������
    			     --�Ƿ���ǰ�в����ͬ���ŵ�����
    			     local is_same = 0;
                     local remove_key = 0;
    			     for k1,v1 in pairs(unfinished_desk) do
                         if(v1 == deskno) then
                             remove_key = k1;
                         end
        				 if v.desk == v1 then
        				     is_same = 1;
        				     break;
                         end
                     end

                     if(remove_key > 0) then
                         table.remove(unfinished_desk, remove_key);
                     elseif(v.desk ~= deskno) then
        			     if is_same == 0 then
                            table.insert(unfinished_desk,v.desk)
        			     end
                     end
    			 end
    		    end
    		end
    	end
    end
    return #unfinished_desk;
end

matches_taotai_lib.init_match_config = function()
    TraceError('��ʼ����̭����');
    if groupinfo == nil or groupinfo.gamepeilv == nil then
        return
    end
    local m = matches_taotai_lib;
    local peilv = groupinfo.gamepeilv;
    for k, v in pairs(m) do
        local res = string.match(k, "CONFIG_(.*)");
        if(res and m["OP_"..res][peilv] ~= nil) then
            if(res == "MATCH_PRIZE") then
                TraceError('init match prize');
                for k, v in pairs(m["OP_"..res][peilv]) do
                    for k1, v1 in pairs(v) do
                        local t = split(v1, ":");
                        v[k1] = {prize_value=tonumber(t[1]), prize_type=tonumber(t[2]), prize_name=_U(tostring(t[3]))};
                    end
                end
            end
            m[k] = m["OP_"..res][peilv];
        end
    end

    local send_func = function(buf)
        buf:writeString("MATCHTTCFG");
        buf:writeInt(groupinfo.groupid);
        buf:writeString(groupinfo.groupname);
        buf:writeInt(matches_taotai_lib.CONFIG_MATCH_START_COUNT);
        buf:writeInt(matches_taotai_lib.CONFIG_BAOMING_SAIBI);
        buf:writeInt(0);
        buf:writeInt(24);
        local count = 0;
        for k, v in pairs(matches_taotai_lib.CONFIG_MATCH_PRIZE) do
            count = count + 1;
        end
        buf:writeInt(count);
        for k, v in pairs(matches_taotai_lib.CONFIG_MATCH_PRIZE) do
            buf:writeInt(k);
            local count2 = 0;
            for k1, v1 in pairs(v) do
                count2 = count2 + 1;
            end
            buf:writeInt(count2);--����
            for k1, v1 in pairs(v) do
                buf:writeInt(v1.prize_value);--��ֵ
                buf:writeInt(v1.prize_type);--����
                buf:writeString(v1.prize_name);--����
            end
        end
    end
    --�������õ�commonsvr,���ص�ʱ��Ҳ�ᷢ�͸�commonsrv���������غ���Ҫ1���ŷ�������
    --[[
    timelib.createplan(function()
        send_buf_to_all_game_svr(send_func, "commonsvr");
        send_buf_to_all_game_svr(send_func, "hldz_taotai");
    end, 1);
    
    --��ʼ����һ������
    room.cfg.deskcount = 150;
	gamepkg.init_desk_all();
    --]]
end

matches_taotai_lib.remove_match_user_play = function(user_id)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    local match_id = user_match_info.match_id;
    if(match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(match_id);
        list.play_list[user_id] = nil;
    end
end

matches_taotai_lib.set_match_user_play = function(user_id)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    local match_id = user_match_info.match_id;
    if(match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(match_id);
        if(list.match_list[user_id] ~= nil) then
            list.play_list[user_id] = 1;
        end
    end
end


matches_taotai_lib.set_match_user_taotai = function(match_id, user_id, is_give_prize, status, is_kick) 
    local user_info = usermgr.GetUserById(user_id);
    if(user_info ~= nil) then
        user_info.last_open_match_rank_time = nil;
    end
    local list = matches_taotai_lib.get_match_list(match_id);
    matcheslib.on_match_taotai(match_id, user_id);
    if(list.match_list[user_id] == nil) then
        TraceError("�û����ڱ����б��ˣ�����̭��ʲô?"..user_id.." match_id"..match_id);
        return;
    end

    local match_info = matcheslib.get_match_info(match_id);
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    local old_rank_info = nil;
    
    for k, v in pairs(list.rank_list) do
        if(v.userId == user_id) then
            old_rank_info = v;
            break;
        end
    end

    matches_taotai_lib.log_user_match_record(user_id, -2);

    local last_rank = #list.rank_list;
    if(is_kick ~= nil and is_kick == true or is_give_prize == nil) then
        user_match_info.last_match_id = user_match_info.match_id;
        user_match_info.match_id = nil;
        user_match_info.jifen = 0;
    end

    --��������
    matches_taotai_lib.process_rank_list(match_id);
    
    if(is_kick ~= nil and is_kick == true or is_give_prize == nil) then
        rank = last_rank
    else
        rank = matches_taotai_lib.get_user_rank(user_id); 
    end

    local has_prize = matches_taotai_lib.give_user_prize(user_id, rank, match_info.award[rank], match_id);

    if(has_prize == 0) then
        --û�н��ģ���ʾ����̭
        matches_taotai_lib.net_send_match_user_taotai(user_info, rank, 
                                                      (list.match_info.status > 1 and 1 or 0), 
                                                      list.match_info.match_count);
    end

    if(list.rank_list[rank] == nil) then
        list.taotai_list[user_id] = old_rank_info;
    else
        list.taotai_list[user_id] = table.clone(list.rank_list[rank]);
    end

    --��������
    list.taotai_list[user_id].rank = rank;
    if(is_kick ~= nil and is_kick == true or is_give_prize == nil) then
        --�������߶��ߵģ�ֱ�����һ��
        list.taotai_list[user_id].rank = last_rank;
    end


    list.play_list[user_id] = nil;
    list.match_list[user_id] = nil;
    list.wait_list[user_id] = nil;
    
    if(status ~= nil) then
        list.taotai_list[user_id].status = status;
    else
        list.taotai_list[user_id].status = list.match_info.status;
    end
    user_match_info.last_match_id = user_match_info.match_id;
    user_match_info.match_id = nil;

    --���û�վ��
    local deskno = user_info.desk;
    local site = user_info.site;

    if(deskno ~= nil and site ~= nil and rank > 1) then
        if(list.taotai_desk_list[deskno] == nil) then
            list.taotai_desk_list[deskno] = {};
        end
        list.taotai_desk_list[deskno][site] = list.taotai_list[user_id];
    end

    user_match_info.jifen = 0;
    letusergiveup(user_info)
    doStandUpAndWatch(user_info, 0);
    matches_taotai_lib.broadcast_taotai_list(match_id, deskno);--��������ʾ���û���̭��

    --��¼�ڴ棬�´ε�¼֪ͨ�������
    local parent_user_id = user_id;
    if(duokai_lib and duokai_lib.is_sub_user(user_id) == 1) then
        parent_user_id = duokai_lib.get_parent_id(user_id);
    end
    if((is_kick ~= nil and is_kick == true) or (user_info and user_info.offline == offlinetype.tempoffline)) then
        local offline_list = nil;
        if(matches_taotai_lib.user_offline_list[parent_user_id] ~= nil) then
            offline_list = matches_taotai_lib.user_offline_list[parent_user_id];
        else
            offline_list = {};
            matches_taotai_lib.user_offline_list[parent_user_id] = offline_list;
        end
    
        --�������Σ����� 
        offline_list[match_id] = {rank = rank, is_award = has_prize, prize_list = match_info.award[rank], time = os.time(), begin_time = list.match_info.begin_time, match_name = match_info.match_name, match_count = list.match_info.match_count};
    end

    matches_taotai_lib.check_match_end(match_id);
    matcheslib.refresh_list(user_info);
    eventmgr:dispatchEvent(Event("on_match_user_taotai", {user_id = user_id, rank = list.taotai_list[user_id].rank, match_type = 1, match_count = list.match_info.match_count}));
end

matches_taotai_lib.broadcast_taotai_list = function(match_id, deskno, user_info)
    --�㲥��������֪��������̭��
    if(deskno ~= nil) then
        local list = matches_taotai_lib.get_match_list(match_id);
        local send_func = nil;
        if(list.taotai_desk_list ~= nil and list.taotai_desk_list[deskno] ~= nil) then
            send_func = function(buf)
                buf:writeString("MATCHTTMD")
                for k, v in pairs(list.taotai_desk_list[deskno]) do
                    if(desklist[deskno].site[k].user == nil) then
                        buf:writeInt(k);--��λ
                        buf:writeInt(v.userId);--�û�id
                        buf:writeString(v.nick);--�û��ǳ�
                        buf:writeString(v.imgUrl);--�û�ͷ��
                        buf:writeInt(v.jifen);--�û�����
                    end
                end
                buf:writeInt(0);
            end
            
        else
            send_func = function(buf)
                buf:writeString("MATCHTTMD")
                buf:writeInt(0);
            end
        end
        if(user_info == nil) then
            netlib.broadcastdesk(send_func, deskno, borcastTarget.all);
        else
            netlib.send(send_func, user_info.ip, user_info.port);
        end
    end
end

matches_taotai_lib.get_user_rank = function(user_id)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    local rank = 0;
    if(user_match_info.match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(user_match_info.match_id);
        --TraceError(list.rank_list);
        for k, v in pairs(list.rank_list) do
            if(v.userId == user_id) then
                rank = k;
                break;
            end
        end
    end
    --TraceError('rank'..rank);
    return rank;
end

matches_taotai_lib.get_match_user_count = function(match_id, list_type)
    if(list_type == nil) then
        list_type = 'all';
    end

    local list = matches_taotai_lib.get_match_list(match_id);
    local count = 0;

    if(list_type == 'wait') then
        for k, v in pairs(list.wait_list) do
            count = count + 1;
        end
        return count;
    end

    if(list_type == "play") then
        for k, v in pairs(list.play_list) do
            count = count + 1;
        end
        return count;
    end

    if(list_type == 'all' or list_type == 'match') then
        for k, v in pairs(list.match_list) do
            count = count + 1;
        end
    end

    if(list_type == 'all' or list_type == 'taotai') then
        for k, v in pairs(list.taotai_list) do 
            count = count + 1;
        end
    end

    return count; 
end

--�����û�������Ϣ�������û�
matches_taotai_lib.send_jifen_info_desk = function(user_info)
    local desk_no = user_info.desk
    if desk_no ~= nil and desk_no > 0 then
        for i = 1, room.cfg.DeskSiteCount do
            local site_user_info = userlist[desklist[desk_no].site[i].user]
            if (site_user_info) then
                matches_taotai_lib.net_send_jifen_info(site_user_info,user_info);--����user_info����Ϣ��ͬ�������
                matches_taotai_lib.net_send_jifen_info(user_info,site_user_info);--����ͬ������ҵ���Ϣ��user_info
            end
        end
    end
end

--����������Ϣ
matches_taotai_lib.net_send_jifen_info = function(user_info, from_user_info, site)
    netlib.send(function(buf_out)
        buf_out:writeString("MATCHSAIBIINFO")
        	buf_out:writeInt(from_user_info.userId)   --�û�ID
            local user_match_info = matches_taotai_lib.get_user_match_info(from_user_info.userId);
        	buf_out:writeInt(user_match_info.jifen)  --����
            buf_out:writeInt(site == nil and from_user_info.site or site)  --��λ��
    end, user_info.ip, user_info.port)
end


-----------------------------------ϵͳ�¼���Ӧ-----------------------------------------------------------------

function matches_taotai_lib.on_parent_user_add_watch(e) 
    local user_info = e.data.user_info;
    local desk_no = user_info.desk;
    if(matcheslib.check_match_desk(desk_no) == 0) then
        do return end;
    end
    local sub_user_id = duokai_lib.get_sub_user_by_desk_no(user_info.userId, desk_no);
    if(sub_user_id > -1) then
        local sub_user_info = usermgr.GetUserById(sub_user_id);
        if(sub_user_info ~= nil) then
            local user_match_info = matches_taotai_lib.get_user_match_info(sub_user_info.userId);
            if(user_match_info.match_id ~= nil) then
                local match_id = user_match_info.match_id;
                matches_taotai_lib.on_watch_event({
                    data = {
                        userinfo = sub_user_info
                    },
                });
        
        
                matches_taotai_lib.net_send_match_taotai_jifen(sub_user_info, match_id);
                matches_taotai_lib.net_send_match_condition(sub_user_info);
                matches_taotai_lib.net_send_match_user_info(sub_user_id);
                matches_taotai_lib.net_send_match_rank_list(sub_user_info, matches_taotai_lib.get_match_rank_list(match_id));
            end
        end
    end
end

function matches_taotai_lib.get_match_rank_list(match_id)
    local list = matches_taotai_lib.get_match_list(match_id);
    local rank_list = list.rank_list;
    local taotai_list = list.taotai_list;
    local taotai_line = list.match_info.status < 2 and #rank_list or -1;
    local all_rank_list = table.clone(rank_list); 
    local left_num = #all_rank_list;
    for k, v in pairs(taotai_list) do
        v.is_taotai = 1;
        if(list.match_info.status == 1) then
            table.insert(all_rank_list, v);
        elseif(v.status > 1) then
            table.insert(all_rank_list, v);
        end
    end
    --[[
    local t_list = {};
    local str = "";
    for k, v in pairs(all_rank_list) do
        if(str ~= "") then
            str = str .. "';'";
        end
        local user_match_info = matches_taotai_lib.get_user_match_info(v.userId);
        local rank = v.rank == nil and k or v.rank;
        str = str .. v.userId.."|"..v.jifen.."|"..(v.is_taotai or 0).."|"..rank.."|"..user_match_info.panshu.."|"..v.imgUrl.."|"..v.nick;
        if(k % 50 == 0 or k >= #all_rank_list) then
            table.insert(t_list, str);
            str = "";
        end
    end
    --]]
    return all_rank_list, left_num;
end

--�û�������Ϣ�Ѿ���ʼ��
matches_taotai_lib.on_after_user_login = function(e)
    --TraceError('on_after_user_login');
    if(matches_taotai_lib.check_match_room() == 0) then
        return;
    end
    local user_info = e.data.userinfo;

    if(matches_taotai_lib.user_list[user_info.userId] ~= nil) then
        return;
    end

    --TraceError('on_after_user_login'..user_info.userId);
    --��ʼ���û�������Ϣ
    local user_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
    --TraceError(user_match_info);
    if(user_match_info.match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(user_match_info.match_id);
        matches_taotai_lib.net_send_match_user_info(user_info.userId);
        matches_taotai_lib.net_send_match_taotai_jifen(user_info, user_match_info.match_id, list.match_info.match_count);
        matches_taotai_lib.net_send_match_condition(user_info);
        matches_taotai_lib.net_send_match_rank_list(user_info, matches_taotai_lib.get_match_rank_list(user_match_info.match_id));

        --�ص�½���ͻ�����ʾ
        --matches_taotai_lib.send_jifen_info_desk(user_info);
    end

    local match_result_list = matches_taotai_lib.user_offline_list[user_info.userId];
    if(match_result_list ~= nil) then
        for k, v in pairs(match_result_list) do
            if(v.is_award == 1) then
                matches_taotai_lib.net_send_match_prize(user_info, v.rank, v.prize_list, v.begin_time, 1, v.match_count, v.match_name);
            else
                matches_taotai_lib.net_send_match_user_taotai(user_info, v.rank, 1, v.match_count, v.match_name);
            end
        end
        matches_taotai_lib.user_offline_list[user_info.userId] = nil;
    end
end

matches_taotai_lib.on_timer_second = function(e)

    if(matches_taotai_lib.check_match_room() == 0) then
        return;
    end

    if(matches_taotai_lib.refresh_rank_list_ex == nil) then
        matches_taotai_lib.refresh_rank_list_ex = {};
    end

    for match_id, v in pairs(matches_taotai_lib.refresh_rank_list) do
        if(v == 1) then
            matches_taotai_lib.refresh_rank_list[match_id] = 0;
            matches_taotai_lib.net_send_match_all_rank_info(match_id);

            if(matches_taotai_lib.refresh_rank_list_ex[match_id] == nil) then
                matches_taotai_lib.refresh_rank_list_ex[match_id] = os.time();
            end
    
            if(os.time() - matches_taotai_lib.refresh_rank_list_ex[match_id] > 1) then
                matches_taotai_lib.refresh_rank_list_ex[match_id] = os.time();
                matches_taotai_lib.net_send_match_all_rank_list_ex(match_id);
            end
        end
    end

    --24Сʱ�����������һ񽱻���̭֪ͨ
    for user_id, v in pairs(matches_taotai_lib.user_offline_list) do
        local count = 0;
        local remove_count = 0;
        for match_id, v1 in pairs(v) do
            count = count + 1;
            if(os.time() - v1.time > 24 * 3600) then
                v[match_id] = nil;
                remove_count = remove_count + 1;
            end
        end

        if(count == remove_count) then
            v[user_id] = nil;
        end
    end

    local current_match_id = matches_taotai_lib.get_current_match_id();
    --�������б�����������Ϸ����
    for k, v in pairs(matches_taotai_lib.match_list) do
        --��ʱ���û�н����ı���
        local clear = 0;
        if(k ~= current_match_id) then
            local match_count = matches_taotai_lib.get_match_user_count(k, 'match');
            if(match_count == 0) then
                --������û������
                matches_taotai_lib.match_list[k] = nil;
                clear = 1;
            end
        end
        
        --[[
        if(clear == 0) then
            --����״̬ 
            local status = v.match_info.status;
            if(status == 1) then
                --��Ԥ����ʱ�򣬻�������̭�ֻ᲻������
                local begin_time = v.match_info.begin_time;
                local change_base_rate_time = v.match_info.change_base_rate_time;
        
                if(change_base_rate_time == 0) then
                    --��һ�εĸı�ʱ��Ϊ��ʼʱ��
                    change_base_rate_time = begin_time;
                end
        
                if(change_base_rate_time + matches_taotai_lib.CONFIG_CHANGE_MATCH_BASE_RATE_TIME <= os.time()) then
                    --�������д���
                    v.match_info.change_base_rate_time = os.time(); 
                    --���»�����
                    v.match_info.base_rate = v.match_info.base_rate + matches_taotai_lib.CONFIG_FIRST_MATCH_BASE_RATE * matches_taotai_lib.CONFIG_FIRST_MATCH_INC_RATE
                    --������̭����
                    v.match_info.taotai_jifen = v.match_info.base_rate * matches_taotai_lib.CONFIG_MATCH_TAOTAI_RATE;
                    --���͸���ң���̭�ָ���
                    matches_taotai_lib.net_send_match_change_taotai_jifen(k, v.match_info.match_count);
                end
            end

            --�����û�б���������
            local unfinished_desk = v.match_info.unfinished_desk;
            local die_count = 0;
            for _, desk_no in pairs(unfinished_desk) do
    		    local desk = desklist[desk_no];
    		    if desk.game.startTime ~= nil and desk.game.startTime ~= 0 then --�Ƿ��п���ʱ��
                    local lua_start_time = timelib.db_to_lua_time(desk.game.startTime);
                    if lua_start_time < v.match_info.end_time 
                        and os.time() - lua_start_time > 700 then  --�Ƿ��ڽ���֮ǰ������
                        --�ж���û�г�ʱ,10����
                        die_count = die_count + 1;
                    end
                end
            end

            if(die_count > 0 and #unfinished_desk == die_count) then
                --��ʱ�ĺ�û����ɵ�������һ������ô�Ϳ��Խ����ⳡ������
                if(v.match_info.status == 1) then
                    matches_taotai_lib.end_first_match(k);
                elseif(v.match_info.status > 1) then
                    matches_taotai_lib.end_second_match(k);
                end
                TraceError("�����п����ı���match_id"..k);
            end
        end
        --]]
    end
end

--[[
@desc ÿһ����Ϸ����
]]--
matches_taotai_lib.on_game_over = function(e)

    if(matches_taotai_lib.check_match_room() == 0) then
        return;
    end

    local match_id = nil;
    local chat_match_msg = "";
    local deskno = 0;
    for k,v in pairs(e.data) do
        local user_info = usermgr.GetUserById(v.userid or 0);
        if(user_info ~= nil) then
            if(deskno == nil or deskno == 0) then
                deskno = user_info.desk;
            end
            local user_match_info = matches_taotai_lib.get_user_match_info(v.userid);
            if(user_match_info.match_id ~= nil) then

                if(match_id == nil) then
                    match_id = user_match_info.match_id;
                elseif(match_id ~= user_match_info.match_id) then
                    TraceError("�Ŷӳ�bug�ˣ�ͬһ�����˱���id��Ȼ��һ��");
                end

                local list = matches_taotai_lib.get_match_list(user_match_info.match_id);
                local inc_jifen = v.wingold --v.beishu * list.match_info.base_rate * (v.iswin == 1 and 1 or -1);
                user_match_info.panshu = user_match_info.panshu + 1;
                user_match_info.jifen = user_match_info.jifen + inc_jifen;
                matches_taotai_lib.remove_match_user_play(v.userid);
                --��¼������־
                matches_taotai_lib.log_user_match_record(v.userid, 10);

                if(v.iswin == 1) then
                    --matcheslib.l_add_user_match_exp(user_info, matches_taotai_lib.CONFIG_WIN_ADD_MATCH_EXP);
                    --matcheslib.send_match_my_info(user_info);
                end

                --�ж���һ������
                
                --if(list.match_info.status == 1 and user_match_info.jifen < list.match_info.taotai_jifen) then
                if(list.match_info.status == 1) then
                    --����̭��
                    --matches_taotai_lib.set_match_user_taotai(match_id, v.userid);
                    matches_taotai_lib.check_user_taotai(v.userid);
                end
            end
        end
    end

    if(match_id ~= nil) then

        --matches_taotai_lib.send_desk_match_chat(deskno, tools.AnsiToUtf8("���ֽ������ɼ�ͳ��:\n")..chat_match_msg);

        --�����Ƿ�������
        local list = matches_taotai_lib.get_match_list(match_id);
        list.match_info.panshu = list.match_info.panshu + 1;

        local over_callback = nil;
        if(list.match_info.status > 1) then--�����ĵ�n��
            over_callback = matches_taotai_lib.end_second_match;
        elseif(list.match_info.status == 1) then
            --���ڱ������������
    	    local match_user_count = matches_taotai_lib.get_match_user_count(match_id, 'match');
    	    if(match_user_count <= matches_taotai_lib.CONFIG_FIRST_MATCH_END_COUNT) then
    	    --if(match_user_count <= 1) then
                over_callback = matches_taotai_lib.end_first_match;
    	    end
        end
	
    	if(over_callback ~= nil) then
            --�ж����������ɱ���û�У�����˾ͽ�����һ������
    	    if(list.match_info.end_time == 0)  then
                list.match_info.end_time = os.time();
    	    end
    
    	    --���㻹�ж�����̨û�д���
    	    --local unfinish_desk_count = matches_taotai_lib.count_still_playing_desks(match_id, deskno, list.match_info.unfinished_desk, list.match_info.end_time);
    	    local unfinish_desk_count = 0;
    
            --TraceError('unfinish_desk_count'..unfinish_desk_count);
    	    if(unfinish_desk_count <= 0) then
    		    over_callback(match_id);
                --��������������
                for k, v in pairs(list.match_list) do
                    local user_match_info = matches_taotai_lib.get_user_match_info(k);
                    user_match_info.panshu = 0;
                    matches_taotai_lib.net_send_match_user_info(k);
                end
    	    else
        		--���û��ȴ���
        		for k,v in pairs(e.data) do
        			if list.match_list[v.userid] ~= nil then --�����û�б���̭���û���ʾ
                        local user_match_info = matches_taotai_lib.get_user_match_info(v.userid);
                        user_match_info.notify_continue = 0;
                        --���͵ȴ�Э��
                        matches_taotai_lib.net_send_match_result(v.userid, 1, nil, unfinish_desk_count);
        			end
                end

                --�������ȴ��ֻ����û�֪�������Ѿ�������
                for k, v in pairs(list.match_list) do
                    local user_match_info = matches_taotai_lib.get_user_match_info(k);
                    if(user_match_info.notify_continue == 1) then
                        user_match_info.notify_continue = 0;
                        matches_taotai_lib.net_send_match_result(k, 1, nil, unfinish_desk_count);
                    end
                end

                if(list.match_info.finish_taotai_time == 0) then
                    list.match_info.finish_taotai_time = os.time();
                    --֪ͨ��û�д�������
                    for k, v in pairs(list.match_info.unfinished_desk) do
                        --�������ӺŻ�ȡ�û�
                        for i= 1,room.cfg.DeskSiteCount do
                            local siteuserinfo = deskmgr.getsiteuser(v,i); --�õ��û�����Ϣ��
                            matches_taotai_lib.net_send_match_msg(siteuserinfo.userId, 1);
                        end
                    end
                end
    	    end
    	else
    	    --֪ͨ�û������ֻ�����,��û����̭��ָ������
            --[[
            for k,v in pairs(e.data) do
                --TraceError("֪ͨ�û������ֻ�����"..v.userid);
                matches_taotai_lib.notify_continue_play(v.userid);
            end
            --]]
        end

        --���¼�������
        matches_taotai_lib.process_rank_list(match_id);

        --��������
        matches_taotai_lib.net_send_match_all_rank_list(match_id);

        --ˢ�¸�����Ϣ
        for k,v in pairs(e.data) do
            matches_taotai_lib.net_send_match_user_info(v.userid);
        end
    end
end

matches_taotai_lib.notify_continue_play = function(user_id)
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    if(user_match_info.match_id ~= nil) then
        user_match_info.notify_continue = 1;
        matches_taotai_lib.net_send_match_result(user_id, 2, 0, nil, 0);
    end
end

matches_taotai_lib.on_server_start = function(e)
    if(matches_taotai_lib.check_match_room() == 0) then
        return;
    end
    --matches_taotai_lib.init_match_config();
end


------------------------------------����������----------------------------------------

matches_taotai_lib.g_on_game_start = function(deskno)
    --TraceError('on_game_start'..deskno);
    for _, player in pairs(deskmgr.getplayers(deskno)) do
		local user_info = player.userinfo;
        if(user_info) then
            matches_taotai_lib.net_send_match_result(user_info.userId, -1);
        end
    end
end

matches_taotai_lib.g_can_enter_game = function(type, user_info)
    --�������˲��ܰ���ǰ���Ŷӽ�����Ϸ
    local ret = 1;
    return ret;
end

matches_taotai_lib.can_enter_game = function(type, user_info)
    --�������˲��ܰ���ǰ���Ŷӽ�����Ϸ
    local ret = 1;
    if matcheslib.user_list[user_info.userId].match_gold  < matches_taotai_lib.CONFIG_BAOMING_SAIBI then
        ret = 0;
    end
    return ret;
end

matches_taotai_lib.g_check_match_room = function()
    return 1;
end

matches_taotai_lib.process_wait_list = function(match_id)
    --TraceError('process_wait_list');
    --[[
    local list = matches_taotai_lib.get_match_list(match_id);
    for k, v in pairs(list.wait_list) do
        local group = matches_taotai_lib.get_match_group_by_rank(k);
        --TraceError('process_wait_list'..tostringex(group));
        matches_taotai_lib.auto_join_desk(group);
    end
    --]]
end

matches_taotai_lib.get_match_group_by_rank = function(user_id, action)
    local group = {};
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id); 
    local match_id = user_match_info.match_id;
    if(match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(match_id);
        if(list.match_info.end_time == 0 and list.match_info.status > 0) then
            local wait_list = list.wait_list;
            local new_rank_list = {};
    
            for k, v in pairs(list.rank_list) do
                if((list.play_list[v.userId] == nil or (action ~= nil and action == 1)) and list.taotai_list[v.userId] == nil) then
                    table.insert(new_rank_list, v);
                end
            end
    
            --���������,��������ȥ���б���
            local user_rank = 0;
            for k, v in pairs(new_rank_list) do
                if(v.userId == user_id) then
                    user_rank = k;
                end
            end
            local mod = user_rank % 3;
            mod = mod == 0 and 3 or mod;
            local begin_index = user_rank - mod + 1;
            local end_index = user_rank + 3 - mod 
            local count = 0;
            for i = begin_index, end_index do
                local item = new_rank_list[i];
                if(item ~= nil and wait_list[item.userId] ~= nil) then
                    group[item.userId] = 1;
                end
            end
        end
    end
    return group;
end


--[[
@desc ϵͳ�Ŷӵ�ʱ����û�ȡ��ǰ�û����ڱ����û��б�
@param user_id 
--]]
matches_taotai_lib.try_start_match = function(match_id)
    local user_list = {};
    local status = 0;
    if(match_id ~= nil) then
        local list = matches_taotai_lib.get_match_list(match_id);
        --�жϱ����Ƿ�ʼ
        if(list.match_info.status > 0 and list.match_info.end_time == 0) then
            status = 2;
            user_list = list.match_list;
        else
            --�ж������Ƿ��㹻�ˣ��㹻�˾Ϳ�ʼ����
            local count = matches_taotai_lib.get_match_user_count(match_id);
            local need_user_count = matcheslib.get_need_user_count(match_id);
            local baoming_count = matcheslib.get_baoming_count(match_id);
            local match_status = matcheslib.get_match_status(match_id);
            if (matcheslib.is_manren_match(match_id) == 1 and need_user_count > 0 and count >= need_user_count) or 
               (matcheslib.is_dingshi_match(match_id) == 1 and baoming_count > 0 and match_status == 3) then 
                --������     
                user_list = list.match_list;       

                if(list.match_info.status == 0) then
                    list.match_info.status = 1;
                    list.match_info.begin_time = os.time();
                    list.match_info.match_count = count;
                    matches_taotai_lib.net_send_match_change_taotai_jifen(match_id, count);
                    status = 1;
                end
            end
        end
    end
    return user_list, status;
end


------------------------------------ϵͳ�ӿ�----------------------------------------
--[[
@desc �û��Ŷӵ�ʱ��,���п۳���������
@param e �¼� e.data.user_id
--]]
matches_taotai_lib.on_user_queue = function(match_id, user_id)
    if(matches_taotai_lib.check_match_room() == 0) then
        return 0;
    end
    local user_info = usermgr.GetUserById(user_id);
    if(matches_taotai_lib.user_list[user_id] ~= nil) then
        local user_match_info = matches_taotai_lib.get_user_match_info(user_id); 
        if(user_match_info.match_id ~= nil) then
            local list = matches_taotai_lib.get_match_list(user_match_info.match_id);
            if(list.taotai_list[user_id] == nil) then
                matches_taotai_lib.set_match_user_wait(user_id);
            end
            return -1;
        end

        local count = matches_taotai_lib.get_match_user_count(match_id);
        --[[
        if(count >= matches_taotai_lib.CONFIG_MATCH_START_COUNT) then
            return -2;
        end
        --]]

        --��������� 
        local list = matches_taotai_lib.get_match_list(match_id);
        local match_info = matcheslib.get_match_info(match_id);

        --������ұ���id
        user_match_info.match_id = match_id;
        --user_match_info.nRegSiteNo = user_info.nRegSiteNo;
        --����ҷŵ������б�����
        list.match_list[user_id] = 1;
        --��ʼ���û�����
        user_match_info.jifen =  match_info.start_score;
        user_info.chouma = match_info.start_score;
        user_match_info.first_jifen = 0
        user_match_info.panshu = 0;
        user_match_info.last_match_id = nil;
        user_match_info.is_taotai = nil;
        --��������ʱ��
        user_match_info.begin_time = os.time();

        matches_taotai_lib.set_match_user_wait(user_id);
        matches_taotai_lib.net_send_match_taotai_jifen(user_info, match_id);
        matches_taotai_lib.net_send_match_condition(user_info);
        matches_taotai_lib.net_send_match_user_info(user_id);
        matches_taotai_lib.process_rank_list(match_id);
        matches_taotai_lib.net_send_match_all_rank_list(match_id);
        matches_taotai_lib.log_user_match_record(user_info.userId, -1);
        return 1;
    else
        return 0;
    end
end

matches_taotai_lib.on_watch_event = function(e)
    local user_info = e.data.userinfo;
    if(user_info == nil or matcheslib.check_match_desk(user_info.desk) == 0) then 
        return;
    end
    local user_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
    local match_id = user_match_info.match_id;
    if(match_id == nil and user_match_info.last_match_id ~= nil) then
        match_id = user_match_info.last_match_id;
    end
    if(match_id ~= nil) then
        --���±�����Ϣ
        local list = matches_taotai_lib.get_match_list(match_id);
        matches_taotai_lib.broadcast_taotai_list(match_id, user_info.desk, user_info);
        matches_taotai_lib.net_send_match_user_info(user_info.userId);
        matches_taotai_lib.net_send_match_taotai_jifen(user_info, match_id, list.match_count);
        matches_taotai_lib.net_send_match_condition(user_info);
    end
end

--[[
@desc �û��뿪��������
@param e �¼� e.data.user_id
--]]
matches_taotai_lib.on_user_exit = function(e)
    if(matches_taotai_lib.check_match_room() == 0) then
        return;
    end
    local user_id = e.data.userinfo.userId;
    --�û��뿪��������̭��
    local user_match_info = matches_taotai_lib.get_user_match_info(user_id);
    local match_id = user_match_info.match_id;
    if(match_id ~= nil) then
        --���û��ŵ���̭�б�
        local list = matches_taotai_lib.get_match_list(match_id);
        if(list.match_list[user_id] ~= nil 
           and list.match_info.status > 0 
           and list.taotai_list[user_id] == nil) then
                matches_taotai_lib.set_match_user_taotai(match_id, user_id, nil, nil, true);
        else 
            matches_taotai_lib.log_user_match_record(user_id, -9);
        end
        
        list.match_list[user_id] = nil;
        list.wait_list[user_id] = nil;
        user_match_info.match_id = nil;

        --�������û��뿪���±���ֹͣ����
        matches_taotai_lib.check_match_end(match_id);
        --matches_taotai_lib.update_match_to_commonsrv(user_match_info, match_id);
    end
    matches_taotai_lib.user_list[user_id] = nil;
end

function matches_taotai_lib.check_match_end(match_id)
    local list = matches_taotai_lib.get_match_list(match_id);
    if(list.match_info.status >= 1 and list.match_info.status < 5) then
        local match_count = matches_taotai_lib.get_match_user_count(match_id, 'match');
        if(match_count > 0 and match_count < 2) then
            --��������������������ˣ���ֱ�Ӱ佱��
            matches_taotai_lib.end_first_match(match_id);
        else
            matches_taotai_lib.net_send_match_all_rank_list(match_id);
        end
    else
        matches_taotai_lib.net_send_match_all_rank_list(match_id);
    end
end

function matches_taotai_lib.on_back_to_hall(e)
    local user_info = e.data.userinfo;
    matches_taotai_lib.process_give_up(user_info.userId);
end

-- ������η������ݷ�װ
matches_taotai_lib.split_start = function(ip, port, protocol_start, split_num)
    netlib.ip = ip
    netlib.port = port
    netlib.split_num = split_num or 20
    netlib.cur_pos = 1

    netlib.send(
        function(out_buf)
            out_buf:writeString(protocol_start)
        end
    , netlib.ip, netlib.port)
    --TraceError("�ֲ������ݿ�ʼ��"..protocol_start)
end

-- ʹ��ʱ��Ҫ�ش�һ���ص�����������
matches_taotai_lib.split_send = function(protocal_send, data, cb_record)
    local count = #data - netlib.cur_pos + 1
    if count > netlib.split_num then
        count = netlib.split_num
    elseif count <= 0 then
        --TraceError("û�пɷ��͵����ݣ�ֱ�ӷ���")
        return 0
    end
    --TraceError("���η��͵�������:"..tostring(count))
    netlib.send(
        function(out_buf)
            -- ���㵱ǰӦ�����Ͷ�������
            -- ����Э��
            out_buf:writeString(protocal_send)
            -- ���ͱ��μ�¼��
            out_buf:writeInt(count)

            -- ���ÿһ����¼��buf�У����ⲿ�ص���������
            local loop_start = netlib.cur_pos
            local loop_end = netlib.cur_pos + count - 1
            for offset = loop_start, loop_end do
                --TraceError("׼�����͵�"..offset.."������")
                xpcall(function() return cb_record(out_buf, data[offset], offset) end, throw)
                netlib.cur_pos = offset + 1
            end
        end
    , netlib.ip, netlib.port)
    --TraceError("�ֲ������ݣ�"..tostring(count))
    return count
end

matches_taotai_lib.split_end = function(protocol_end)
    netlib.send(
        function(out_buf)
            out_buf:writeString(protocol_end)
        end
    , netlib.ip, netlib.port)	
    --TraceError("�ֲ������ݽ�����"..protocol_end)
end

function matches_taotai_lib.on_recv_get_all_rank_list(buf)
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;

    local is_show = buf:readInt();
    local user_match_info = matches_taotai_lib.get_user_match_info(user_info.userId);
    local match_id = user_match_info.match_id or user_match_info.last_match_id;

    if(is_show == 0) then
        user_info.open_match_rank_panel = nil; 
        return;
    end

    if(user_info.open_match_rank_panel ~= nil or user_info.last_open_match_rank_time ~= nil) then
      --�Ѿ��򿪹����ߴ���3���ٴ򿪲�ˢ��
        user_info.open_match_rank_panel = match_id;
        return;
    end

    user_info.open_match_rank_panel = match_id;
    user_info.last_open_match_rank_time = os.time();

    if(match_id ~= nil) then
        matches_taotai_lib.net_send_match_rank_list(user_info, matches_taotai_lib.get_match_rank_list(match_id));
    end
end


------------------------------------�¼����----------------------------------------
--��Ϸ��ʼ�¼�
eventmgr:addEventListener("on_server_start", matches_taotai_lib.on_server_start);
--������Ϸ�����¼�
eventmgr:addEventListener("game_event", matches_taotai_lib.on_game_over);
--����ʱ��¼������
eventmgr:addEventListener("h2_on_user_login", matches_taotai_lib.on_after_user_login)
--����ʱ
eventmgr:addEventListener("timer_second", matches_taotai_lib.on_timer_second);
--�û��˳�
eventmgr:addEventListener("do_kick_user_event", matches_taotai_lib.on_user_exit);
--�û���ս��ʱ��
eventmgr:addEventListener("on_watch_event", matches_taotai_lib.on_watch_event);
--���ش���ʱ��
eventmgr:addEventListener("back_to_hall", matches_taotai_lib.on_back_to_hall);
--���ʺŷ��ش���
eventmgr:addEventListener("on_sub_user_back_to_hall", matches_taotai_lib.on_user_exit);
--�л���ս
eventmgr:addEventListener("on_parent_user_add_watch", matches_taotai_lib.on_parent_user_add_watch);

eventmgr:addEventListener("before_kick_sub_user", matches_taotai_lib.on_user_exit);
--�û��������
--eventmgr:addEventListener("on_user_queue", matches_taotai_lib.on_user_queue);


------------------------------------������Ӧ----------------------------------------
--�����б�
cmdHandler = 
{
    --�Զ��Ŷ�
    --["MATCHTTJOIN"] = matches_taotai_lib.on_recv_match_join,
    --[[
    ["MATCHTTINFO"] = matches_taotai_lib.on_recv_match_info,
    ["MATCHTTBMC"] = matches_taotai_lib.on_recv_match_baoming_check,

    --�յ���������������������Ϣ
    ["MATCHTTCFG"] = matches_taotai_lib.on_recv_commonsvr_match_config,
    ["MATCHTTOL"] = matches_taotai_lib.on_recv_commonsvr_match_online,
    --]]
    ["MATCHTTRLISTEX"] = matches_taotai_lib.on_recv_get_all_rank_list,
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

