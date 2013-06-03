if not daxiao_hall_lib then
    daxiao_hall_lib = _S
    {
        user_list = {},
    }
end

--�����½
function daxiao_hall_lib.on_recv_login(buf)
    local user_key = getuserid(buf)
    local user_info = daxiao_hall_lib.userlist[user_key]
    if (user_info == nil) then
        daxiao_hall_db_lib.get_user_info(user_id, function(dt)
            daxiao_hall_lib.user_list[user_key] = {}
            daxiao_hall_lib.user_list[user_key].nick = dt[1].nick
            daxiao_hall_lib.user_list[user_key].userId = dt[1].id
        end)
end

--Э������
cmd_daxiao_hall_handler = 
{
	["DXRQLG"] = daxiao_hall_lib.on_recv_login, --�����½
}

--���ز���Ļص�
for k, v in pairs(cmd_daxiao_hall_handler) do 
	cmdHandler_addons[k] = v
end

 