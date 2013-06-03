TraceError("init duokai_gc_lib...��ʼ���࿪ģ��")
dofile("games/modules/duokai/lua_buf.lua")
if (duokai_gc_lib and duokai_gc_lib.on_after_user_login) then
    eventmgr:removeEventListener("user2_on_user_login", duokai_gc_lib.on_after_user_login)
end

if (duokai_gc_lib and duokai_gc_lib.on_user_exit) then
    eventmgr:removeEventListener("user2_on_user_exit", duokai_gc_lib.on_user_exit); 
end

if (duokai_gc_lib and duokai_gc_lib.on_timer_second) then
    eventmgr:removeEventListener("timer_second", duokai_gc_lib.on_timer_second)
end

if not duokai_gc_lib then
	duokai_gc_lib = _S
	{
		user_list = {}
	}
end


--------------------------------------------------------
--�����ش���
function duokai_gc_lib.need_process_msg(ip, port)
    return 0
end

function duokai_gc_lib.pre_process_send_msg(lua_buf)
    return ip, port
end
--------------------------------------------------------

--��ʱ��������echo����
function duokai_gc_lib.on_timer_second(e)
    
end

--�û��˳�
function duokai_gc_lib.on_user_exit(e)
    local user_id  = e.data.user_id
    duokai_gc_lib.user_list[user_id] = nil;
end

--�û���¼
function duokai_gc_lib.on_after_user_login(e)
    local user_info = e.data.user_info
    if (duokai_gc_lib.user_list[user_info.userId] == nil) then
        return
    end
    duokai_gc_lib.user_list[user_info.userId].user_info = user_info
    local gs_id = duokai_gc_lib.user_list[user_info.userId].gs_id
    --֪ͨgs�û���¼�ɹ�
    netlib.send_to_gs_ex("tex", gs_id, function(buf)
        buf:writeString("DKLGGC")
        buf:writeInt(user_info.userId)
        buf:writeString(user_info.szGameKey)        
    end)
    
end

--��ʼ�����û�
function duokai_gc_lib.init_sub_user(sub_user_id, parent_id, gs_id)
    duokai_gc_lib.user_list[sub_user_id] = {parent_id = parent_id, gs_id = gs_id, user_info = {}}    
end

--�յ�������û�
function duokai_gc_lib.on_recv_add_user(buf)
    local user_id = buf:readInt()
    local sub_user_id = buf:readInt()
    local sub_user_name = buf:readString()
    local gs_id = buf:readInt()
    local sub_user_info = usermgr.GetUserById(sub_user_id)
    if (sub_user_info ~= nil) then --������˺��Ѿ���½�ˣ�ֱ�ӷ��ص�½�ɹ�
        --֪ͨgs�û���¼�ɹ�
        netlib.send_to_gs_ex("tex", gs_id, function(buf)
            buf:writeString("DKLGGC")
            buf:writeInt(sub_user_info.userId)
            buf:writeString(sub_user_info.szGameKey)        
        end)
    else --ģ��һ���û���¼
        local buf = lua_buf:new()
        TraceError(sub_user_name)
        buf:writeString(sub_user_name)
        buf:writeString("11")
        buf:writeByte(0)
        buf:writeString("0")
        onrecvlogin(buf, sub_user_id)
        duokai_gc_lib.init_sub_user(sub_user_id, user_id, gs_id)
    end
end
--Э������
cmd_tex_match_handler = 
{ 
    ["DKADDUSER"] = duokai_gc_lib.on_recv_add_user, --����ĳһ���û���¼
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end
eventmgr:addEventListener("timer_second", duokai_gc_lib.on_timer_second)
eventmgr:addEventListener("user2_on_user_login", duokai_gc_lib.on_after_user_login)
eventmgr:addEventListener("user2_on_user_exit", duokai_gc_lib.on_user_exit)

