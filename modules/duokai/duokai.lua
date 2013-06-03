TraceError("init duokai_lib...��ʼ���࿪ģ��")
dofile("games/modules/duokai/lua_buf.lua")
dofile("games/modules/duokai/duokai_db.lua")
if duokai_lib and duokai_lib.on_after_user_login then
    eventmgr:removeEventListener("h2_on_user_login", duokai_lib.on_after_user_login);
end

if duokai_lib and duokai_lib.on_user_exit then
    eventmgr:removeEventListener("on_user_exit", duokai_lib.on_user_exit);
end

if duokai_lib and duokai_lib.on_timer_second then
    eventmgr:removeEventListener("timer_second", duokai_lib.on_timer_second)
end

if duokai_lib and duokai_lib.on_user_kicked then
    eventmgr:removeEventListener("on_user_kicked", duokai_lib.on_user_kicked)
end

if duokai_lib and duokai_lib.on_user_standup then
    eventmgr:removeEventListener("on_user_standup", duokai_lib.on_user_standup)
end

if duokai_lib and duokai_lib.on_user_exit_watch then
    eventmgr:removeEventListener("on_user_exit_watch", duokai_lib.on_user_exit_watch)
end

if duokai_lib and duokai_lib.on_show_panel then
    eventmgr:removeEventListener("on_show_panel", duokai_lib.on_show_panel)
end

if duokai_lib and duokai_lib.on_game_event then
    eventmgr:removeEventListener("game_event", duokai_lib.on_game_event)
end

if not duokai_lib then
	duokai_lib = _S
	{
        USER_NUM_LIMIT = 2,  --���˺���������
		user_list = {},
        sub_user_list = {},
        temp_add_desk = {},     --��ʱռס��������Ϣ�����ڵ�½ʱ��������Ƿ��Ѿ���ռ����
        back_hall_buf_list = {}, --���ش�������յĻ����б�
        game_over_buf_list = {}, --ÿһ�ֽ��������յĻ����б�
	}
end

------------------------------------------------------------------
--[[
    �����ش��������Ҫ�Ķ�����ѯ��� 
--]]
duokai_lib.need_change_send_cmd =  --���˺ŷ�������Ҫ���͸����˺ŵ�Э�� 
{
    TXNTPN = 1,  --��ʾ���
    TXNTAP = 1,  --��ʾ�Զ����
    TEXXST = 1,  --���ֳ�����Э��
    REMG = 1,  --�ͻ�����ʾ��Ϣ
    RESD = 1,  --����Э��    
    TXREFP = 1,  --����Э��

    RQPEXT = 1,     --����ĳ���˵�extra_info��achieve_info
    RQMIXT = 1,		--����ĳ���˵�extra_info      
    REOT = 1,		--�Ƿ������˳���Ϸ
    TXNTBC = 1,      --�������
    TXNINF = 1,		--��֪�����Ӆ���
    TXNTRD = 1,		--�ָ������Э��
    TXNTZT = 1,		--�ָ�������״̬
    TXNTDM = 1,		--�ʳ���Ϣ    
    TXBTZL = 1,     --֪ͨ���ߵ����Լ�������
    TXNTPZ = 1,     --���͵ý�����̭����Ϣ
    TXNTXP = 1,     --�������쾭�����
    STOV = 1,       --����ѧϰ�̳��콱�ɹ�
    TXNTMG = 1,     --�����������½Ǵ�����Ϣ
    TXREDJNUM = 1,  --֪ͨ�ͻ��ˣ����µ�������TIPS
    --TXZSLW = 1,     --���͵���
    TXSPBZ = 1,


    --����ģ��
    MATCHTTCO = 1,
    MATCHTTTT = 1,
    MATCHTTRLIST = 1,
    MATCHTTRS = 1,
    MATCHTTMYINFO = 1,
    MATCHTTMD = 1,
    MATCHTTGP = 1,
    MATCHTTCJF = 1,
    MATCHTTLIST = 1,
    DKDESKSS = 1,

    --����ģ��
    FDSENDSHOWADD = 1,

    --���˿�
    TXFQTR = 1,
    TXTRID = 1,
    TXTPJG = 1,
    TXKVIP = 1,
    TXVPCS = 1,
    TXKICK = 1,
    TXBTZL = 1,
    TXBFKS = 1,

    --������
    TXBGFD = 1,
    TXBGFF = 1,

    --vip��
    VIPROOMMSG = 1,

    --������ϸ
    TXNTSGDT = 1,

    --vip
    VIPINF = 1,

    --��������
    NTKTASKPG = 1,
    NTKTASKFN = 1,
    NTKTASKFRTIPS = 1,

    --��ȯ����
    SHOPBUY = 1,
    SHOPLS = 1,
    TXGFSL = 1,

    --�
    GBHDPS = 1,
}

duokai_lib.need_notify_cmd =  --���˺ŷ�������Ҫ֪ͨ���˺��в�����Э��
{
    TXNTPN = 1,  --��ʾ���
}

duokai_lib.need_change_recv_cmd =  --���˺��յ��ģ���Ҫ���͸����˺�
{
    RQSU = 1,       --����վ����
    REWT = 1,       --�����ս
    TXNINF = 1,		--��֪�����Ӆ���
    TXNTBC = 1,      --�������
    TXRQBC = 1,		--��һ�����
    TXRQST = 1,		--�û�����ʼ
    TXRQFQ = 1,		--�����
    TXRQXZ = 1,		--����ע
    TXRQGZ = 1,		--���ע
    TXRQBX = 1,		--�㲻��ע�����ƣ�
    TXRQAI = 1,		--��ȫ��
    RQPEXT = 1,     --����ĳ���˵�extra_info��achieve_info
    RQMIXT = 1,		--����ĳ���˵�extra_info
    TXNBBS = 1,		--������̳��֤��
    TXNTDT = 1,		--���������ϸ
    TXAUSI = 1,     --�յ�����룬�Զ����� 
    TXTOUDJ = 1,    --�յ����͵���
    TXGIFT = 1,     --�յ�������
    TXTOUDJ = 1,    --���͵���
    TXEMOT  = 1,    --���ͱ���

    --����
    FDRQTJHY = 1,   --������ʾ�Ӻ��Ѱ�ť
    FDRQWTAD = 1,   --����Ӻ���
    FDRQZJHY = 1,   --ȷ�ϼӺ���

    --���˿�
    TXFQTR = 1,     --��������
    TXTRID = 1,     --����˭
    TXTPXX = 1,     --ͶƱ���
    TXKVIP = 1,     --��ѯvip����
    TXCLICKCANCEL = 1,--ȡ������
    TXBFKS = 1,

    --��ȯ�һ�
    TXGFDP = 1,
    TXGFUS = 1,
    TXGFSL = 1,
    SHOPBUY = 1,    --����

    --����
    MATCHJXGZ = 1,
}

--���ش�����������ʱ�����յĻ����б�
duokai_lib.need_cache_notify_cmd = {
    MATCHTTGP = 1,
    MATCHTTTT = 1,
    FDSENDCANADD = 1,
    TXZSLW = 1,
}

--ÿһ�ֽ�������յĻ����б�
duokai_lib.need_cache_game_notify_cmd = {
    NTKTASKFRTIPS = 1,
    TXTRID = 1,
    TXNTXZ = 1,
    TXNTTX = 1,
    TXNTBX = 1,
    TXNTDP = 1,
    TXNTGO = 1,
}

--������͸������ʺŲ��ǵ�ǰ�ʺţ���ôЭ���Ϊxxx_EX�����������л��ʺ�ʱ�������ʺ�
duokai_lib.need_cache_game_ex_notify_cmd = {
    TXNTXZ = 1,
    TXNTTX = 1,
    TXNTBX = 1,
    TXNTDP = 1,
    TXNTGO = 1,
}

--�Ƿ��͸����˺ŵ�Э��,�������˺������Ե�ǰ���˺���ݴ���
function duokai_lib.need_process_send_msg(ip, port)
    local sub_user_key = format("%s:%s", ip, port)
    if (userlist[sub_user_key] == nil) then
        return 0
    end
    local sub_user_id = userlist[sub_user_key].userId
    if (duokai_lib.sub_user_list[sub_user_id] ~= nil) then 
        return 1
    else
        return 0
    end
end

--�������˺ŵĲ���֪ͨ
function duokai_lib.send_notify_msg(user_info, sub_user_info, cmd)
    if (sub_user_info == nil or sub_user_info.desk == nil) then
        return
    end
    netlib.send(function(buf) 
        buf:writeString("DKNTMSG")
        buf:writeString(cmd)
        buf:writeString(sub_user_info.desk.."")
    end, user_info.ip, user_info.port)
end

--�Ƿ���Ҫ�����Э��
function duokai_lib.pre_process_send_msg(lua_buf)
    local cmd = lua_buf:get_top_item()
    ip = lua_buf:ip()
    port = lua_buf:port()

    local process_buf = function()
        --��ȡ���˺�        
        local sub_user_key = format("%s:%s", lua_buf:ip(), lua_buf:port())
        if (userlist[sub_user_key] == nil) then
            return 1, ip, port
        end
        local sub_user_id = userlist[sub_user_key].userId
        local user_id = duokai_lib.sub_user_list[sub_user_id].parent_id
        --������˺������Ƿ��ڿ���ǰ���˺�
        local user_info = usermgr.GetUserById(user_id)
        if (user_info == nil) then
            return 0, ip, port
        end
        if (duokai_lib.user_list[user_id] ~= nil and 
            duokai_lib.user_list[user_id].cur_user_id == sub_user_id) then           
            return 1, user_info.ip, user_info.port
        else
            --��Ҫ֪ͨ���˺����˺��в�����
            if (duokai_lib.need_notify_cmd[cmd] == 1) then
                duokai_lib.send_notify_msg(user_info, usermgr.GetUserById(sub_user_id), cmd)
            end
            return 0, ip, port, sub_user_id
        end
    end
    --����buf�������л��˺ź�ָ�����֪ͨ
    local cache_buf = function(cmd, sub_user_id)
        if(duokai_lib.need_cache_notify_cmd[cmd] ~= nil) then
            if(duokai_lib.back_hall_buf_list[sub_user_id] == nil) then
                duokai_lib.back_hall_buf_list[sub_user_id] = {};
            end
            table.insert(duokai_lib.back_hall_buf_list[sub_user_id], lua_buf);
        elseif (duokai_lib.need_cache_game_notify_cmd[cmd] ~= nil) then
            if(duokai_lib.game_over_buf_list[sub_user_id] == nil) then
                duokai_lib.game_over_buf_list[sub_user_id] = {};
            end
            table.insert(duokai_lib.game_over_buf_list[sub_user_id], lua_buf);
        end
    end

    if (duokai_lib.need_change_send_cmd[cmd] ~= nil) then
        local ret, ip, port, sub_user_id = process_buf();
        if(sub_user_id ~= nil and ret == 0) then
            cache_buf(cmd, sub_user_id);
        end
        return ret, ip, port
    else
        if(duokai_lib.need_cache_notify_cmd[cmd] ~= nil or
           duokai_lib.need_cache_game_notify_cmd[cmd] ~= nil) then
            local ret, ip, port, sub_user_id = process_buf();
            if(sub_user_id ~= nil) then
                cache_buf(cmd, sub_user_id);
            end
        end
        return 0, ip, port
    end
end

function duokai_lib.send_cache_buf(user_info)
    if(duokai_lib.user_list[user_info.userId] ~= nil) then
        local cur_user_id = duokai_lib.user_list[user_info.userId].cur_user_id;
        
        if(duokai_lib.back_hall_buf_list[cur_user_id] ~= nil) then 
            for k, v in pairs(duokai_lib.back_hall_buf_list[cur_user_id]) do
                local func_internal = function(buf)
                   local cmd = v:get_top_item();
                   if(duokai_lib.need_cache_game_ex_notify_cmd[cmd] == 1) then
                       v.content[1].arg = cmd.."_EX";
                   end
                   v:copy_buf(buf)
                end
                netlib.send(func_internal, user_info.ip, user_info.port);
            end
            duokai_lib.back_hall_buf_list[cur_user_id] = nil;
        end
        if(duokai_lib.game_over_buf_list[cur_user_id] ~= nil) then 
            for k, v in pairs(duokai_lib.game_over_buf_list[cur_user_id]) do
                local func_internal = function(buf)
                   local cmd = v:get_top_item();
                   if(duokai_lib.need_cache_game_ex_notify_cmd[cmd] == 1) then
                       v.content[1].arg = cmd.."_EX";
                   end
                   v:copy_buf(buf)
                end
                netlib.send(func_internal, user_info.ip, user_info.port);
            end
            duokai_lib.game_over_buf_list[cur_user_id] = nil;
        end
    end
end

--�Ƿ���Ҫ�����Э��
function duokai_lib.pre_process_recv_msg(cmd, buf)
    local user_key = format("%s:%s", buf:ip(), buf:port())
    if (userlist[user_key] == nil) then
        return
    end
    --��������˺ŷ������ģ�������Ҫ���͸����˺ţ��ͷ��͸���ǰ���ڹ�ս�����˺�
    local user_id = userlist[user_key].userId
    if (duokai_lib.user_list[user_id] == nil or
        duokai_lib.need_change_recv_cmd[cmd] ~= 1) then
        return
    end
    local sub_user_id = duokai_lib.user_list[user_id].cur_user_id
    local sub_user_info = usermgr.GetUserById(sub_user_id)
    if (sub_user_info ~= nil) then        
        buf:setIp(sub_user_info.ip)
        buf:setPort(sub_user_info.port)
    end
end
------------------------------------------------------------------
-----------------------���ݲ���-------------------------------------------
--�����˺ŵ����ݣ���¡�����˺�
function duokai_lib.clone_user_info_to_sub(sub_user_id, parent_id)
    local user_info = usermgr.GetUserById(parent_id)
    local sub_user_info = usermgr.GetUserById(sub_user_id)
    --�ؼ����ݲ��ܸ��ƣ������޷����������˺���
    for k, v in pairs(user_info) do
        if (k ~= "key" and k ~= "userId" and k ~= "userName" and k ~= "prekey" and 
            k ~= "isrobot" and k ~= "realrobot" and k ~= "nRegSiteNo" and k ~= "session" and 
            k ~= "passport" and k ~= "ip" and k ~= "port" and k ~= "desk" and k ~= "site" and
            k ~= "lastRecvBufTime" and k ~= "networkDelayTime" and k ~= "SendNetworkDelayFlag" and
            k ~= "sockeClosed") then
            sub_user_info[k] = v
        end
    end
end

--��ʼ�����˺�
function duokai_lib.init_sub_user(user_id, user_name, user_key, user_ip, user_port, parent_id)
    --��¡һ�����˺ų���
    local user_info = usermgr.GetUserById(parent_id)
    if (user_info == nil) then
        return -1
    end
    --TraceError("wwww")
    local sub_user_info = table.cloneex(user_info)
    sub_user_info.key = user_key
    sub_user_info.userId = user_id
    sub_user_info.userName = user_name
    sub_user_info.prekey = nil
    sub_user_info.isrobot = false
    sub_user_info.realrobot = false
    sub_user_info.nRegSiteNo = -100
    sub_user_info.session = ""
    sub_user_info.passport = ""
    sub_user_info.ip = user_ip
    sub_user_info.port = user_port
    sub_user_info.is_sub_user = 1
    userlist[user_key] = sub_user_info
    userlistIndexId[user_id] = sub_user_info
    
    if (duokai_lib.sub_user_list[user_id] == nil) then
        duokai_lib.sub_user_list[user_id] = {
            user_name = user_name,     --���˺ŵ�username
            sit_down_after_login = 0,   --�û���¼���Ƿ���Ҫ���£�
            parent_id = parent_id,   --���˺ŵĸ�id
            want_play_desk = -1,     --ϣ�����˺Ž��������
            want_play_site = -1,    --ϣ�����˺Ž����λ��
            is_goto_game = 0,       --���˺ŵ�¼�ɹ������˺��Ƿ�������˺���Ϸ
            start_login_time = 0,   --��ʼ��½ʱ��
            login = 1,  
            call_back_login,   --��½�ɹ��Ļص�
            }        
    end    
    duokai_lib.user_list[parent_id].sub_user_list[user_id] = {sys_time = os.time()}
    eventmgr:dispatchEvent(Event("h2_on_sub_user_login", {user_info = sub_user_info, userinfo = sub_user_info}));
    return 1
end

function duokai_lib.get_user_desk(user_id)
    local user_info = usermgr.GetUserById(user_id)
    if (user_info ~= nil) then
        return user_info.desk or -1
    end
    return -1
end

--��ȡ��ĳһ����Ϸ�����˺�
function duokai_lib.get_sub_user_by_desk_no(user_id, desk_no)
    for k, v in pairs(duokai_lib.user_list[user_id].sub_user_list) do
        if (duokai_lib.get_user_desk(k) == desk_no) then
            return k
        end
    end
    return -1
end

function duokai_lib.get_all_sub_user(parent_id)
    if(duokai_lib.user_list[parent_id] ~= nil) then
        return duokai_lib.user_list[parent_id].sub_user_list;
    end
    return nil;
end

--��ȡ���˺�
function duokai_lib.get_parent_id(user_id)
    if (duokai_lib.sub_user_list[user_id] ~= nil) then
        return duokai_lib.sub_user_list[user_id].parent_id
    else
        return 0
    end
end

function duokai_lib.get_cur_sub_user_id(user_id)
    if(duokai_lib.user_list[user_id] ~= nil) then
        return duokai_lib.user_list[user_id].cur_user_id;
    end
    return 0;
end

--�Ƿ������˺�
function duokai_lib.is_sub_user(user_id)
    if (duokai_lib.sub_user_list[user_id] ~= nil) then
        return 1
    else
        return 0
    end
end

--�Ƿ��Ǹ��˺�
function duokai_lib.is_parent_user(user_id)
    if (duokai_lib.user_list[user_id] ~= nil) then
        return 1
    else
        return 0
    end
end

--��ȡһ��δ�õ����˺�, -1��ʾ���˺�
function duokai_lib.get_one_sub_user_list(user_id, call_back)    
    local user_count = duokai_lib.get_sub_play_num(user_id);
    --TraceError('get_one_sub_user_list'..user_count)
    --������˺��Ƿ񳬹�����
    if (user_count >= duokai_lib.USER_NUM_LIMIT) then
        call_back(-1, 0, 0)
        return
    end
    local user_count = 0
    for k, v in pairs(duokai_lib.user_list[user_id].sub_user_list) do
        if (duokai_lib.get_user_desk(k) == -1) then
            call_back(1, k, duokai_lib.sub_user_list[k].user_name)
            return
        else
            user_count = user_count + 1
        end
    end

    if (user_count >= duokai_lib.USER_NUM_LIMIT) then
        call_back(-1, 0, 0)
        return
    end
    duokai_db_lib.create_sub_user(user_id, os.time(), function(sub_user_id, sub_user_name, sub_user_key, 
                                                                sub_user_ip, sub_user_port)
        --�����ڴ��б���
        local ret = duokai_lib.init_sub_user(sub_user_id, sub_user_name, sub_user_key, 
                                 sub_user_ip, sub_user_port, user_id)

        if(user_count > 0) then
            duokai_db_lib.log_want_duokai_info(user_id, 0, 0, 1);
        end

        if (ret > 0) then
            call_back(1, sub_user_id, sub_user_name)
        else
            call_back(-2, 0, 0)
        end
    end)
end

----------------------------------------------------------------
--�¼���ز���
function duokai_lib.on_timer_second(e)
    --��ʱ����Э�飬��ֹ�˺ű��ǳ�
    local cur_time = os.time()
    if (e.data.time % 10 == 0) then
        for k,  v in pairs(duokai_lib.sub_user_list) do
            if (v.login == 1) then
                local sub_user_info = usermgr.GetUserById(k)
                if (sub_user_info ~= nil) then
                    usermgr.ResetNetworkDelay(sub_user_info.key)
                end
            end
            duokai_lib.reset_user_site(v)
        end
    end
end

--�û���½
function duokai_lib.on_after_user_login(e)
    local user_info = e.data.userinfo
    local user_id = user_info.userId
    local cur_time = os.time()
    --[[if (duokai_lib.sub_user_list[user_id] ~= nil) then --���˺ŵ�¼��
        duokai_lib.sub_user_list[user_id].login = 1
        local parent_id = duokai_lib.sub_user_list[user_id].parent_id
        --duokai_lib.clone_user_info_to_sub(user_id, parent_id)
        if (duokai_lib.sub_user_list[user_id].is_goto_game == 1) then
            duokai_lib.user_list[parent_id].cur_user_id = user_id
            --�ø��˺��뿪��ս�б�          
            DoUserExitWatch(parent_user_info)
        end
        if (duokai_lib.sub_user_list[user_id].call_back_login ~= nil) then
            duokai_lib.sub_user_list[user_id].call_back_login(user_info)
            duokai_lib.sub_user_list[user_id].call_back_login = nil
        end
        --�����ʱռ�õ�λ����Ϣ

        local desk_no = duokai_lib.sub_user_list[user_id].want_play_desk
        local site_no = duokai_lib.sub_user_list[user_id].want_play_site
        if (desk_no ~= nil and site_no ~= nil and site_no > 0) then            
            duokai_lib.temp_remove_user_site(desk_no, site_no)
        end
        --�ø��˺ź����˺��ƶ���ս
        duokai_lib.process_enter_desk(user_info, usermgr.GetUserById(parent_id), desk_no, site_no, 
                                      duokai_lib.sub_user_list[user_id].is_goto_game)           
    else--]]
    if (user_info.ip ~= "-100") then--���˺ŵ�½��, -100��ʾ�������˺�
        duokai_lib.user_list[user_id] = {cur_user_id = -1, sub_user_list = {}}
        --��ȡ���˺�
        --[[duokai_db_lib.get_sub_user_list(user_id, function(dt)
            if (dt and #dt > 0) then
                local sub_user_list = split(dt[1].sub_user_list, "|")            
                for i = 1, #sub_user_list do                    
                    if (sub_user_list[i] ~= "") then
                        local sub_item_info = split(sub_user_list[i], ",")
                        duokai_lib.init_sub_user(tonumber(sub_item_info[1]), sub_item_info[2], user_id)
                    end
                end

                --duokai_lib.user_list[user_id].sub_user_list[user_id] = {sys_time = cur_time}  --���Լ��������˺���
            end
        end)--]]
    end
    
end

--�û��˳�
function duokai_lib.on_user_exit(e)
    local user_id = e.data.user_id
    if (duokai_lib.user_list[user_id] ~= nil) then
        --�����е����˺�ȫ������
        for k, v in pairs (duokai_lib.user_list[user_id].sub_user_list) do
            local user_info = usermgr.GetUserById(k)
            if (user_info ~= nil) then
                eventmgr:dispatchEvent(Event("before_kick_sub_user", {userinfo = user_info, user_info = user_info}));
                local buf = lua_buf:new()
                buf:set_ip(user_info.ip)
                buf:set_port(user_info.port)
                onclientoffline(buf)
            end
            local sub_user = duokai_lib.sub_user_list[k]
            duokai_lib.reset_user_site(sub_user)
            duokai_lib.sub_user_list[k] = nil
            if (userlistIndexId[k] ~= nil) then
                local user_key = userlistIndexId[k].key
                userlist[user_key] = nil
                userlistIndexId[k] = nil
            end
            duokai_lib.back_hall_buf_list[k] = nil;
            duokai_lib.game_over_buf_list[k] = nil;
            --todo��Ҫ�����û���ʱ���ߵ����
        end
        duokai_lib.user_list[user_id] = nil
    end
end

--ǿ�������˺�ռ�õ�λ���˳���
function duokai_lib.reset_user_site(sub_user_info)
    local cur_time = os.time()
    local desk_no = sub_user_info.want_play_desk
    local site_no = sub_user_info.want_play_site
    if (sub_user_info.login == 0 and sub_user_info.start_login_time ~= 0 and 
        cur_time - sub_user_info.start_login_time > 5 and
        desk_no ~= nil and desk_no > 0 and 
        site_no ~= nil and site_no > 0) then
        duokai_lib.temp_remove_user_site(desk_no, site_no)
    end
end

--����λ���Ƿ��Ѿ�������
function duokai_lib.site_have_user(desk_no, site_no)
    if (duokai_lib.temp_add_desk[desk_no..":"..site_no] ~= nil) then
        return 1
    end
    if (desklist[desk_no].site[site_no].user ~= nil) then
        return 1
    end
     return 0
end

--�û����˺��˳���������黹λ��
function duokai_lib.temp_remove_user_site(desk_no, site_no)
    if (duokai_lib.temp_add_desk[desk_no..":"..site_no] ~= nil) then
        duokai_lib.temp_add_desk[desk_no..":"..site_no] = nil        
        local find = 0
        --�ͷ��ڴ�
        for k, v in pairs(duokai_lib.temp_add_desk) do
            find = 1
            break
        end
        if (find == 0) then
            duokai_lib.temp_add_desk = {}
        end
    end
end

--��ʱռסһ��λ�ã��û����˺ŵ�½�����
function duokai_lib.temp_add_user_site(desk_no, site_no)
    if (duokai_lib.temp_add_desk[desk_no] == nil) then
        duokai_lib.temp_add_desk[desk_no] = {}
    end
    duokai_lib.temp_add_desk[desk_no..":"..site_no] = 1
end

--�û�������
function duokai_lib.on_user_kicked(e)
    --֪ͨ�û��˳�һ����   
end

--���û��˳���Ϸ
function duokai_lib.let_user_exit(user_info)
    --�ӿͻ���gobacktohall��������
    --[[local new_buf = lua_buf:new()
    new_buf:set_ip(user_info.ip)
    new_buf:set_port(user_info.port)
    new_buf:writeInt(0);
    new_buf:writeInt(0);
    new_buf:writeByte(0);
    new_buf:writeByte(0);
    new_buf:writeByte(0);
    onrecvbuychouma(new_buf)--]]

    local new_buf2 = lua_buf:new()
    new_buf2:set_ip(user_info.ip)
    new_buf2:set_port(user_info.port)
    onrecvstandup(new_buf2)

    local new_buf3 = lua_buf:new()
    new_buf3:set_ip(user_info.ip)
    new_buf3:set_port(user_info.port)
    OnRecvExitWatch(new_buf3)
end

--�û�����ص�����
function duokai_lib.on_back_to_hall(user_info)    
    local parent_desk_no = user_info.desk;
    --����Ƿ����������˺����ڴ��ƣ�����ڴ��ƣ����л���ȥ
    local sub_user_exit_func = function(org_sub_user_info)
        --֪ͨ�ͻ�����һ���Ѿ��˳���
        duokai_lib.back_hall_buf_list[org_sub_user_info.userId] = nil;
        duokai_lib.game_over_buf_list[org_sub_user_info.userId] = nil;
        duokai_lib.let_user_exit(org_sub_user_info)
        duokai_lib.update_sub_desk_info(user_info)
        eventmgr:dispatchEvent(Event("on_sub_user_back_to_hall", {user_info = org_sub_user_info, userinfo = org_sub_user_info}));
    end
    --��������˺��˳�
    if (duokai_lib.is_sub_user(user_info.userId) == 1) then
        local parent_id = duokai_lib.sub_user_list[user_info.userId].parent_id
        local org_sub_user_info = user_info;
        local org_sub_desk_no = user_info.desk;
        user_info = usermgr.GetUserById(parent_id)
        parent_desk_no = user_info.desk
        sub_user_exit_func(org_sub_user_info)

        if(org_sub_desk_no ~= nil and org_sub_desk_no ~= parent_desk_no) then
            --TraceError("���ʺ��ڹ�ս�������ʺŹ�ս");
            return 0;
        end
    end
    if (user_info ~= nil and parent_desk_no ~= nil) then        
        for k, v in pairs(duokai_lib.user_list[user_info.userId].sub_user_list) do
            --�������˺��ڹ�ս��������
            local sub_play_desk = duokai_lib.get_user_desk(k)
            if (sub_play_desk ~= -1 and sub_play_desk ~= parent_desk_no) then
                local org_sub_user_id = duokai_lib.user_list[user_info.userId].cur_user_id
                --TraceError("�������˺��ڹ�ս��������, ���˺���ǰ��ս������  "..parent_desk_no)
                duokai_lib.join_game(user_info.userId, sub_play_desk, 0, 1)
                --TraceError("���˺����ڹ�ս������  "..user_info.desk.."   "..k)
                --���п��Թ�ս���û������õ�ǰ�û��˵�������ֱ��վ���˳���ս
                local org_sub_user_info = usermgr.GetUserById(org_sub_user_id)
                if (org_sub_user_info ~= nil) then
                    --TraceError("����һ���û��˳���ս�뿪��Ϸ  "..org_sub_user_info.userId)
                     --�����˺�gobacktohall
                    sub_user_exit_func(org_sub_user_info)
                end
                return 0
            end
        end
    end
    --û��һ�������ˣ�ֱ���˳�����
    if (user_info ~= nil and duokai_lib.user_list[user_info.userId] ~= nil) then
        --TraceError("û��һ�������ˣ�ֱ���˳�����")
        local sub_user_id = -1
        if (duokai_lib.user_list[user_info.userId] == nil) then
            TraceError("�쳣��������˺�����Ϊ��")
        else
            sub_user_id = duokai_lib.user_list[user_info.userId].cur_user_id
        end        
        local org_sub_user_info = usermgr.GetUserById(sub_user_id)
        --�ø��˺��˳���ս
        DoUserExitWatch(user_info)
        --�����˺�gobacktohall
        if (org_sub_user_info ~= nil) then
            sub_user_exit_func(org_sub_user_info)
        end
        duokai_lib.user_list[user_info.userId].cur_user_id = -1
    end    
    return 1
end


--�û�������ʾ���
function duokai_lib.on_show_panel(e)
    local deskno = e.data.deskno;
    local cur_site = e.data.siteno;

    --����ÿһ�ˣ����ж������ֵ��Լ�
    local players = deskmgr.getplayingplayers(deskno)
	local deskdata = deskmgr.getdeskdata(deskno)
    local count = 0;
    local status = {};
    local last_num = 0;
    for i = cur_site, room.cfg.DeskSiteCount + cur_site - 1 do
        local siteno = i;
        local timeout = -1;
        local ntype = 0;
        if(i > room.cfg.DeskSiteCount) then
            siteno = i % room.cfg.DeskSiteCount;
        end
        local sitedata = deskmgr.getsitedata(deskno, siteno); 
        if sitedata.isinround == 1 and sitedata.islose == 0 then--and sitedata.isallin == 0 and (sitedata.isbet == 0 or sitedata.betgold < deskdata.maxbetgold) then
            if(siteno ~= cur_site) then
                --���ж��ٸ�����ֵ��Լ�
                status[siteno] = last_num + 1;
                last_num = status[siteno];
                ntype = 1;
            else
                ntype = 2;
                timeout = hall.desk.get_site_timeout(deskno, siteno);
            end
        end

        local userkey = desklist[deskno].site[siteno].user;
        if(userkey ~= nil) then
            local user_info = userlist[userkey];
            if(user_info ~= nil) then
                if(duokai_lib.is_sub_user(user_info.userId) == 1) then
                    user_info = usermgr.GetUserById(duokai_lib.get_parent_id(user_info.userId));
                end

                --[[
                if(user_info ~= nil) then
                    netlib.send(function(buf)
                        buf:writeString("DKDESKSS");
                        buf:writeString(tostring(deskno));
                        buf:writeByte(ntype);--0 û��״̬ 1 δ�ֵ��Լ� 2 �ֵ��Լ�
                        buf:writeInt(status[siteno] or -1);--���м�λ�ֵ��Լ�
                        buf:writeInt(timeout);--�ֵ��Լ������ж���ʱ�䳬��
                    end, user_info.ip, user_info.port);
                end
                --]]
                duokai_lib.net_send_desk_status(user_info, deskno, ntype, status[siteno], timeout);
            end
        end
    end
end

--�û��˳���ս
function duokai_lib.on_user_exit_watch(e)
    local user_info = e.data.user_info
    --����Ǹ��˺��˳���ս���Ͳ����ˣ���Ϊ�϶����������˺ŵ��˳�
    if (duokai_lib.sub_user_list[user_info.userId] == nil) then
        return
    end
    --�ø��˺�Ҳ�˳���ս��
    if (duokai_lib.sub_user_list[user_info.userId] ~= nil) then
        local parent_id = duokai_lib.sub_user_list[user_info.userId].parent_id
        DoUserExitWatch(usermgr.GetUserById(parent_id))
    end
end

--�û�վ����
function duokai_lib.on_user_standup(e)
    --[[local user_info = e.data.user_info
    if (duokai_lib.sub_user_list[user_info.userId] ~= nil) then
        duokai_lib.sub_user_list[user_info.userId].play_desk = -1
    end--]]
    local user_info = e.data.user_info;
    duokai_lib.net_send_desk_status(user_info, user_info.desk);
    --TraceError('on_user_stanup'..user_info.userId);
    duokai_lib.game_over_buf_list[user_info.userId] = nil;
end
----------------------------------------------------------------

function duokai_lib.update_sub_desk_info(user_info)    
    local desk_num = 0    
    local cur_desk_no = "";
    for k, v in pairs(duokai_lib.user_list[user_info.userId].sub_user_list) do
        local desk_no = duokai_lib.get_user_desk(k)
        if (desk_no ~= -1) then
            desk_num = desk_num + 1

            if(duokai_lib.user_list[user_info.userId].cur_user_id == k) then
                cur_desk_no = desk_no;
            end
        end
    end

    local extra_list = {};
    eventmgr:dispatchEvent(Event('on_send_duokai_sub_desk', {user_info = user_info ,extra_list = extra_list}));

    if(#extra_list > 0) then
        desk_num = desk_num + #extra_list;
    end
    netlib.send(function(buf)
        buf:writeString("DKMYDLIST")
        buf:writeInt(desk_num)
        for k, v in pairs(duokai_lib.user_list[user_info.userId].sub_user_list) do
            local desk_no = duokai_lib.get_user_desk(k)
            if (desk_no ~= -1) then            
                local desk_info = desklist[desk_no]
                local desk_name = desk_info.name;
                local match_count = 0;
                local match_start_count = 0;
                local left_time = 0;
                local match_id = "";

                --TODO ����ݴ���ϲ���on_send_duokai_sub_desk����,����Ҫע��sub_user_list�����Ѿ�������Щ����
                if(matcheslib ~= nil) then
                    local match_info = matcheslib.get_match_by_desk_no(desk_no);
                    if(match_info ~= nil and desk_info.desktype == g_DeskType.match) then
                        match_id = match_info.id;
                        desk_name = match_info.match_name;
                        if(match_info.match_type == 2) then
                            match_count = match_info.match_count;
                            match_start_count = match_info.need_user_count;
                            left_time = -1;
                        else
                            left_time = match_info.match_start_time - os.time();
                        end
                    end
                end


                buf:writeString(desk_no.."")  --�����ַ�������Ϊ������Ψһ��ʾ���ַ�����Ϊ����ͳһ
                buf:writeString(desk_name or "")
                buf:writeByte(desk_info.desktype)  --desktype
                buf:writeInt(left_time)  --sec
                buf:writeInt(match_count)  --match_count
                buf:writeInt(match_start_count)  --match_start_count
                buf:writeString(match_id);
            end
        end

        for k, v in pairs(extra_list) do
            buf:writeString(v.desk_no);
            buf:writeString(v.desk_name);
            buf:writeByte(v.desk_type);
            buf:writeInt(v.left_time);
            buf:writeInt(v.match_count);
            buf:writeInt(v.match_start_count);
            buf:writeString(v.match_id);
        end
        buf:writeString(cur_desk_no or "");
    end, user_info.ip, user_info.port)
end

--�������û���սЭ��  �ο�DoUserWatch
function duokai_lib.process_enter_desk(sub_user_info, user_info, desk_no, site_no, is_goto_game)
    if (sub_user_info == nil or user_info == nil) then
        TraceError("�Ƿ��û���Ϣ���޷������˺Ŵ���")
        return
    end
    local desk_info = desklist[desk_no]
    if(desk_info == nil) then return end
    if (is_goto_game == 1) then
        --���߿ͻ�����Ҫ�������˺���
        netlib.send(function(buf) 
            buf:writeString("DKCGSBU")
            buf:writeInt(sub_user_info.userId)
        end, user_info.ip, user_info.port)
    
        addToWatchList(desk_no, user_info)    
    end
    --������˺Ŵ��ڴ���״̬���������£�Ȼ��ָ�����
    if (sub_user_info.desk ~= nil and sub_user_info.site ~= nil) then
        --TraceError("�ָ�����")
        if (sub_user_info.desk ~= desk_no) then
            TraceError("���ش������˺ź���Ҫ��ս���˺�desk��һ��")            
        end
        --����������
        doSitdown(sub_user_info.key, sub_user_info.ip, sub_user_info.port, desk_no, sub_user_info.site, g_sittype.relogin)        
        --�ָ�����Ϣ
        gamepkg.AfterUserWatch(desk_no, sub_user_info)
        net_broadcastdesk_goldchange(sub_user_info)
        --�ָ����
        restore_panel(sub_user_info, desk_no, sub_user_info.site)
        duokai_lib.update_sub_desk_info(user_info)        
        return
    end
     --������˺��Ѿ����ڹ�ս״̬,�Ͳ����ù�ս״̬��
    if (desk_info.watchingList[sub_user_info.userId] == nil) then
        if (user_info.desk == nil) then
            TraceError("���ֲ���������2�����˺��ڹ�ս�����˺�ȥ���˺ŵķ���")            
        end
        --TraceError("�������˺Ź�ս������")
        --����Ƚϴ죬�ڵ�һ����ʱ�����˺���´���rewt��Ϣ��ֻҪ������Ϸ�Ժ�Ͳ��ô�����
        --rewt�����ͻ��ˣ���Ϊ�������˺ſͻ����ܴ����棬Ȼ������
        if (is_goto_game == 1) then
            duokai_lib.need_change_send_cmd["REWT"] = 1
        end
        --���˺��߹�ս���̣���ɺ��ɷ�������Ϣ�����˺ſͻ��ˣ����˺ſͻ��˾Ϳ����л����µ�������
        DoUserWatch(desk_no, sub_user_info)
        --�����Ҫ���������������˺�����������
        if (site_no > 0) then
            doSitdown(sub_user_info.key, sub_user_info.ip, sub_user_info.port, desk_no, site_no, g_sittype.queue)
        end
        duokai_lib.need_change_send_cmd["REWT"] = nil
    else
        --�����ϲ������������������˺��ڹ�ս�����˺�Ҫ��ȥ������䣬
        if (user_info.desk == nil) then
            TraceError("���ֲ���������2�����˺��ڹ�ս�����˺�ȥ���˺ŵķ���")
            return
        end
        DoUserWatch(desk_no, sub_user_info)
    end    
    --[[if (viproom_lib) then
    	local succcess, ret = xpcall( function() 
                                        return viproom_lib.on_before_user_enter_desk(user_info, desk_no) 
                                    end, throw)
    	if (ret == 0) then
    	    return
    	end
    end--]]
    --�㲥�������˽�����ս��
    --[[for i = 1, room.cfg.DeskSiteCount do
        local temp_user_key = hall.desk.get_user(desk_no, i)
        if(temp_user_key) then
            local play_user_info = userlist[hall.desk.get_user(desk_no, i) or ""]
            if (play_user_info and play_user_info.offline ~= offlinetype.tempoffline) then
                OnSendUserSitdown(user_info, play_user_info, 1, g_sittype.normal)  --��������
                --��Ϸ��Ϣ
                OnSendUserGameInfo(user_info, play_user_info, 0)
            end
            if(play_user_info == nil) then
                TraceError("�û���սʱ�������и��û���userlist��ϢΪ��")
                hall.desk.clear_users(desk_no,i)
            end
        end
    end
    for k, watchinginfo in pairs(desk_info.watchingList) do
    	if(userlist[k] == nil) then
    	    deskinfo.watchingList[k] = nil
    	end
    end
    --�ɷ������¼�,�û������������Ϣ
    dispatchMeetEvent(user_info)
    if (gamepkg ~= nil and gamepkg.AfterUserWatch ~= nil) then
    	gamepkg.AfterUserWatch(desk_no, user_info)
    end    
    if(tex_userdiylib)then
    	tex_userdiylib.on_recv_update_userlist(user_info)
    end--]]
    --���������б�
    duokai_lib.update_sub_desk_info(user_info)    
end

--[[
    ����һ����Ϸ
    user_id  ���˺�id,����������˺�id�������˺��߼���һ������
    desk_no  ��Ҫ���������
    site_no  ��Ҫ�����λ�ã����ֻ��ȥ��ս������0
    is_goto_game  �������˺ź����˺��Ƿ�Ҳ���Ź�ȥ�� 1��ȥ��0����ȥ
    call_back_login ���˺ŵ�½�ɹ��Ļص����������������˺ŵ�½�ɹ������˺��˳���ս�����˺Ž���λ��ǰ
--]]
function duokai_lib.join_game(user_id, desk_no, site_no, is_goto_game, call_back_login)
    desk_no = tonumber(desk_no)
    site_no = tonumber(site_no)
    if (user_id == nil or desk_no == nil or desk_no > #desklist or 
        site_no == nil or site_no > 9) then
        TraceError("duokai_lib.join_game��������")
        return
    end
    --����������˺ŷ���Ĺ�ս����,�����˺ŷ����ս��ok��
    if (duokai_lib.user_list[user_id] == nil and duokai_lib.sub_user_list[user_id] ~= nil) then
        local sub_user_info = usermgr.GetUserById(user_id)
        if (sub_user_info == nil) then
            TraceError("���˺�ΪɶΪ�հ�")
            return
        end
        --
        if (sub_user_info.desk == desk_no and sub_user_info.site == site_no) then
            TraceError("join_game �л���ԭ�������ӣ�ΪɶҪ�������ã��������κδ�����")
            return
        end
        local parent_id = duokai_lib.get_parent_id(user_id)
        local user_info = usermgr.GetUserById(parent_id);
        --������˺����ڹ�ս�����˺ţ���ʱ���˺���Ҫ�л����Ǿ������˺�һ������л�
        if (duokai_lib.user_list[parent_id].cur_user_id == user_id) then
            is_goto_game = 1
        end

        --�����û����˳���Ϸ
        duokai_lib.let_user_exit(sub_user_info)
        duokai_lib.sub_user_list[user_id].want_play_desk = desk_no
        duokai_lib.sub_user_list[user_id].want_play_site = site_no
        if (is_goto_game == 1) then
            DoUserExitWatch(user_info)
            duokai_lib.user_list[parent_id].cur_user_id = user_id
            netlib.send(function(buf) 
                buf:writeString("DKCGDSK")
            end, user_info.ip, user_info.port)
        end        
        duokai_lib.process_enter_desk(sub_user_info, user_info, 
                                      desk_no, site_no, is_goto_game)
        duokai_lib.send_cache_buf(user_info);
        return        
    elseif(is_goto_game == 1) then
        --����û���ǰ�ڹ�ս����һ���������˳���Ȼ���ٹ�ս�������        
        local org_sub_user_id = duokai_lib.user_list[user_id].cur_user_id
        if (org_sub_user_id ~= -1) then       
            local org_play_desk = duokai_lib.get_user_desk(org_sub_user_id)
            if (org_play_desk == desk_no) then
                TraceError("�Ѿ��ڹ�ս�����ˣ��������κδ�����")
                return
            elseif (org_play_desk ~= -1) then
                --�ø��˺��뿪��ս״̬
                DoUserExitWatch(usermgr.GetUserById(user_id))
                local org_sub_user_info = usermgr.GetUserById(org_sub_user_id)
                --������˺�ֻ���ڹ�ս�����˳���ս
                if (org_sub_user_info ~= nil and org_sub_user_info.desk ~= nil and org_sub_user_info.site == nil) then
                    DoUserExitWatch(org_sub_user_info)
                end
            end
        end
    end
    --��ȡ���˺ź󣬿�ʼ��½
    local after_get_sub_user_func = function(sub_user_id, sub_user_name)
        --֪ͨ�ͻ�����ս��棬������ʾ���û��Ľ���
        local user_info = usermgr.GetUserById(user_id)    
        if (is_goto_game == 1) then
            netlib.send(function(buf) 
                buf:writeString("DKCGDSK")
            end, user_info.ip, user_info.port)
        end
        if (duokai_lib.sub_user_list[sub_user_id].login == 1) then --�����˺��Ѿ���½��
            --���õ�ǰ���ڹ�ս����Ϸ��Ϣ
            --�ø��˺��뿪��ս�б�
            duokai_lib.sub_user_list[sub_user_id].want_play_desk = desk_no
            duokai_lib.sub_user_list[sub_user_id].want_play_site = site_no
            if (is_goto_game == 1) then
                duokai_lib.user_list[user_id].cur_user_id = sub_user_id
                --TraceError("�ø��˺��뿪��ս�б�  "..desk_no)
                DoUserExitWatch(user_info)
            end
            local sub_user_info = usermgr.GetUserById(sub_user_id)
            if (call_back_login ~= nil) then
                call_back_login(sub_user_info)
            end
            duokai_lib.process_enter_desk(usermgr.GetUserById(sub_user_id), usermgr.GetUserById(user_id), 
                                          desk_no, site_no, is_goto_game)

            duokai_lib.send_cache_buf(user_info);
        else --�û���û�е�½�������ص�½����
            duokai_lib.sub_user_list[sub_user_id].want_play_desk = desk_no
            duokai_lib.sub_user_list[sub_user_id].want_play_site = site_no
            duokai_lib.sub_user_list[sub_user_id].start_login_time = os.time()            
            if (site_no > 0) then
                --��ʱռסһ��λ�ã�����������������
                duokai_lib.temp_add_user_site(desk_no, site_no)
            end
            duokai_lib.sub_user_list[sub_user_id].is_goto_game = is_goto_game
            duokai_lib.sub_user_list[sub_user_id].call_back_login = call_back_login            
            duokai_lib.sub_user_list[sub_user_id].login = 0
            --duokai_lib.sub_user_login(user_id, sub_user_id, sub_user_name);
            --[[
            netlib.send_to_gc(gamepkg.name, function(buf)
                buf:writeString("DKADDUSER")
                buf:writeInt(user_id)
                buf:writeInt(sub_user_id)
                buf:writeString(sub_user_name)  --�½��˺ŵ�ʱ��user_nameҪд��user_id_dzduokai,����103_dzduokai
                buf:writeInt(tonumber(groupinfo.groupid))
            end)
            --]]
        end
    end
    --�����Ҫ��ս�������Ƿ��Ѿ������û��ڴ����ˣ� ����У���ֱ��ʹ�ô����û�
    local sub_user_id = duokai_lib.get_sub_user_by_desk_no(user_id, desk_no)
    if (sub_user_id == -1) then
        duokai_lib.get_one_sub_user_list(user_id, function(ret, new_sub_user_id, new_sub_user_name)
            if (ret == -1) then
                local user_info = usermgr.GetUserById(user_id);
                if(user_info ~= nil) then
                    netlib.send(function(buf)
                        buf:writeString("DKLIMIT");
                        buf:writeInt(duokai_lib.USER_NUM_LIMIT);
                    end, user_info.ip, user_info.port);
                end
                TraceError("�˺������ﵽ����")
                return
            elseif (ret == -2) then
                TraceError("�˺Ŵ���ʧ��")
                return
            end
            after_get_sub_user_func(new_sub_user_id, new_sub_user_name)
        end)
    else
        local sub_user_info = usermgr.GetUserById(sub_user_id)
        if (sub_user_info == nil) then
            TraceError("���˺���ϢΪ�գ����˺ű���ͬ����bug")
            return
        end
        after_get_sub_user_func(sub_user_id, sub_user_name)
    end    
end
--[[
function duokai_lib.sub_user_login(parent_user_id, sub_user_id, sub_user_name)
        local user_info = usermgr.GetUserById(sub_user_id);
        if user_info ~= nil then
            TraceError('���ʺ��Ѿ���¼parent='..parent_user_id..',sub='..sub_user_id);
            return;
        end
        local buf = lua_buf:new()
        local ip = buf:ip();
        local port = buf:port();
        local key = getuserid2(ip, port);
        userlist[key] = {}
        userlist[key].userId = tonumber(sub_user_id) --�û������ݿ�ID
        userlist[key].userName = sub_user_name --�û���
        userlist[key].key  = key
        userlist[key].ip   = ip
        userlist[key].port = port
        userlist[key].lastRecvBufTime = os.time() --��һ���յ���Ϣ��ʱ��
        userlist[key].networkDelayTime = os.time() --�����ӳ�ʱ��
        userlist[key].SendNetworkDelayFlag = 0 --�Ƿ����������ӳٰ�������������յ����ݰ�����Ҫ�������ó�0
        userlist[key].isrobot = false --Ĭ��Ϊ�ǻ�����
        userlist[key].realrobot = false --���ڼ�¼�����Ƿ������,��Ҫ������room.cfg.ignorerobot, Ϊ��ʵ�ַ���,����������һ�������Ļ�����ʶ
        userlist[key].nRegSiteNo = 0;
        userlist[key].sockeClosed = false  --socket�Ƿ񱻹ر���
        userlist[key].visible_page = 0      --���û����뷿��֮��ۿ�������ҳ�ţ���ʼ��Ϊ0����ʾ��û���������Чҳ
        userlist[key].desk_in_page = 0      --���û��ܹ��鿴��ҳ����������
        userlistIndexId[userlist[key].userId] = userlist[key]

        user_info = usermgr.GetUserById(sub_user_id);
        eventmgr:dispatchEvent(Event("h2_on_sub_user_login", {user_info = user_info, userinfo = user_info}));
end
--]]

--�û��˳�һ��
function duokai_lib.exit_game(user_id, desk_no)
    --�˳���ǰ�˺�
    local sub_user_id = duokai_lib.get_sub_user_by_desk_no(user_id, desk_no)
    local sub_user_info = usermgr.GetUserById(sub_user_id);
    if(sub_user_info) then
        --TraceError('sub_user_info'..sub_user_info.userId);
        pre_process_back_to_hall(sub_user_info);
    end
end

function duokai_lib.on_recv_sub_user_login_gc(buf)
    --TraceError("duokai_lib.on_recv_sub_user_login_gc")
    local user_id = buf:readInt()
    local user_game_key = buf:readString()
    --��¼gs
    local buf = lua_buf:new()
    buf:writeInt(user_id)
    buf:writeString(user_game_key)
    buf:writeByte(0)
    buf:writeString("0")
    onrecvlogin(buf)    
end

--����࿪һ��
function duokai_lib.on_recv_join_game(buf)
    local user_info = userlist[getuserid(buf)]	
   	if not user_info then return end;
    local desk_no = buf:readString()  
    local match_id = desk_no;
    if(matcheslib ~= nil) then
        local match_desk_no = matcheslib.get_user_match_desk_no(user_info, match_id);
        if(match_desk_no > 0) then
            desk_no = match_desk_no;
        elseif(match_desk_no == -2) then
            return;
        elseif(match_desk_no == -1 and tonumber(desk_no) == nil) then
            return;
        end
    end
    DoRecvRqWatch(user_info, tonumber(desk_no), 0);
    --duokai_lib.join_game(user_info.userId, tonumber(desk_no), 0, 1)
end

function duokai_lib.get_sub_play_num(user_id)
    --�࿪����
    local join_match_num = 0;
    if(matcheslib ~= nil) then
        local user_info = usermgr.GetUserById(user_id);
        join_match_num = matcheslib.get_user_join_match_num(user_info);
    end
    local num = 0;
    for k, v in pairs(duokai_lib.user_list[user_id].sub_user_list) do
        if (duokai_lib.get_user_desk(k) > 0) then
            num = num + 1;
        end
    end
    num = num + join_match_num;
    return num;
end

--�����˳�һ��
function duokai_lib.on_recv_sub_desk(buf)
    local user_info = userlist[getuserid(buf)]
	if not user_info then return end
    local desk_no = buf:readString()
    duokai_lib.exit_game(user_info.userId, tonumber(desk_no));    
end

--�յ��ҵ������б�
function duokai_lib.on_recv_my_desk_list(buf)
    local user_info = userlist[getuserid(buf)]	
	if not user_info then return end    
    duokai_lib.update_sub_desk_info(user_info)
end

--�յ���ͨ���������б�
function duokai_lib.on_recv_common_desk_list(buf)
    local user_info = userlist[getuserid(buf)]	
	if not user_info then return end
    user_info.open_duokai_match_tab = nil;
    local my_desk_no = user_info.desk
    --���������б�ʼ
    netlib.send(function(buf)
        buf:writeString("DKCOMMONLSTS")
    end, user_info.ip, user_info.port)
    for i = 1, 5 do
        isfast = 0
        if (i == 5) then
            isfast = 1
        end
        DoQuestDeskList(user_info, 1, i, 1, 0, isfast, -1, function(send_list)
            local desk_start = 1
            local desk_end = #send_list
            netlib.send(function(out_buf)
                out_buf:writeString("DKCOMMONLST")
                out_buf:writeInt(desk_end - desk_start + 1)
                for idesk = desk_start, desk_end do
                    local desk_no = send_list[idesk]
                    local desk_info = desklist[desk_no]                 
                    if (desk_no == my_desk_no) then
                        out_buf:writeString("-1")
                    else
                        out_buf:writeString(desk_no)
                    end
                    --���� --todo��Ҫ����vip�������ֵ�����
                    out_buf:writeString(desk_info.name)
                    --��������:1��ͨ,2������
                    out_buf:writeByte(1)
                    --Сä
                    out_buf:writeInt(desk_info.smallbet)
                    --��ä
                    out_buf:writeInt(desk_info.largebet)
                    --��Ǯ����
                    out_buf:writeInt(desk_info.at_least_gold)
                    --��Ǯ����
                    out_buf:writeInt(desk_info.at_most_gold)
                    --��ˮ
                    --out_buf:writeInt(deskinfo.specal_choushui)
                    --���ٿ�������
                    out_buf:writeByte(desk_info.min_playercount)
                    --��󿪾�����
                    out_buf:writeByte(desk_info.max_playercount)
                    --��ǰ��������
                    out_buf:writeByte(hall.desk.get_user_count(desk_no))
                    local watch_count = 0
                    for k,v in pairs(desk_info.watchingList) do
                        watch_count = watch_count + 1
                    end
                    --��ս����
                    out_buf:writeInt(watch_count)
                    --�ǲ���VIP��
                    --out_buf:writeByte(is_vip or 0)
                    end
                end
            , user_info.ip, user_info.port)
        end)
    end
    --���������б����
    netlib.send(function(buf)
        buf:writeString("DKCOMMONLSTE")
    end, user_info.ip, user_info.port)
end

duokai_lib.on_recv_match_desk_list = function(buf)
	local user_info = userlist[getuserid(buf)];
    if not user_info then return end;
    user_info.open_duokai_match_tab = 1;
    duokai_lib.net_send_match_list(user_info);
end

duokai_lib.net_send_match_list = function(user_info)
	if not user_info or not matcheslib or user_info.open_duokai_match_tab == nil then return end;
    local length = 0;
    local user_match_info = matcheslib.user_list[user_info.userId];
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
    for _, v in pairs(tmp_list) do
    	if v.status == 1 then
        	length = length + 1;
        end
    end
    netlib.send(function(buf)
        buf:writeString("DKMATCHLST");
        buf:writeInt(length);
        for k, v in pairs(tmp_list) do
        	if v.status == 1 then
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
            end
        end
    end, user_info.ip, user_info.port);
end

function duokai_lib.net_send_desk_status(user_info, deskno, ntype, left_num, timeout)
    if(user_info ~= nil) then
        netlib.send(function(buf)
            buf:writeString("DKDESKSS");
            buf:writeString(tostring(deskno));
            buf:writeByte(ntype or 0);--0 û��״̬ 1 δ�ֵ��Լ� 2 �ֵ��Լ�
            buf:writeInt(left_num or -1);--���м�λ�ֵ��Լ�
            buf:writeInt(timeout or -1);--�ֵ��Լ������ж���ʱ�䳬��
        end, user_info.ip, user_info.port);
    end
end

function duokai_lib.on_game_event(e)
    --TraceError('on_game_event');
    for k, v in pairs(e.data) do
        local user_info = usermgr.GetUserById(v.userid);
        if(user_info ~= nil) then
            local desk_no = user_info.desk;
            local players = deskmgr.getplayers(desk_no);
            --�ҵ����������й�ս
            for k1, v1 in pairs(players) do
                duokai_lib.net_send_desk_status(v1.userinfo);
            end
            timelib.createplan(function()
                for k1, v1 in pairs(players) do
                    duokai_lib.game_over_buf_list[v1.userinfo.userId] = nil;
                end
            end, 2);
            break;
        end
    end
end

function duokai_lib.on_recv_want_duokai(buf)
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;
    if(user_info.log_want_duokai ~= nil) then
        return;
    end
    local yes_or_no = buf:readByte();
    if(yes_or_no ~= 1) then
        yes_or_no = 0;
    end
    user_info.log_want_duokai = 1;
    duokai_db_lib.log_want_duokai_info(user_info.userId, usermgr.getlevel(user_info), user_info.gamescore, yes_or_no)
end
--Э������
cmd_tex_match_handler = 
{ 
    ["DKJGAME"] = duokai_lib.on_recv_join_game, --��������һ��
    ["DKSUBDESK"] = duokai_lib.on_recv_sub_desk, --�����˳�һ��
    ["DKLGGC"] = duokai_lib.on_recv_sub_user_login_gc, --�յ����˺ŵ�¼��gc
    ["DKMYDLIST"] = duokai_lib.on_recv_my_desk_list, --�յ���ȡ�࿪�������б�
    ["DKCOMMONLST"] = duokai_lib.on_recv_common_desk_list, --�յ���ȡ�࿪�������б�
    ["DKMATCHLST"] = duokai_lib.on_recv_match_desk_list, --�յ���ȡ�࿪�������б�
    ["DKWANTDK"] = duokai_lib.on_recv_want_duokai, --�յ��Ƿ���࿪
    
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("timer_second", duokai_lib.on_timer_second)
eventmgr:addEventListener("h2_on_user_login", duokai_lib.on_after_user_login) 
eventmgr:addEventListener("on_user_exit", duokai_lib.on_user_exit)
eventmgr:addEventListener("on_user_kicked", duokai_lib.on_user_kicked)
eventmgr:addEventListener("on_user_standup", duokai_lib.on_user_standup)
eventmgr:addEventListener("on_user_exit_watch", duokai_lib.on_user_exit_watch)
eventmgr:addEventListener("on_show_panel", duokai_lib.on_show_panel)
eventmgr:addEventListener("game_event", duokai_lib.on_game_event)

