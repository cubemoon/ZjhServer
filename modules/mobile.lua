TraceError("init mobile_lib...��ʼ���ֻ�ģ��")

if not mobile_lib then
	mobile_lib = _S
	{
		
	}
end

--�޸Ŀͻ���ip��һ���ֻ����ô���ģ������Ҳ���ip
function mobile_lib.on_change_ip(buf)    
    local user_info = userlist[getuserid(buf)];
    local client_ip = buf:readString();
    if (user_info ~= nil) then
        local ip, from_city = iplib.get_location_by_ip(client_ip)
        user_info.szChannelNickName = string.toHex(from_city) --�û�Ƶ����
    end
end
--Э������
cmd_tex_match_handler = 
{ 
    ["MBCGIP"] = mobile_lib.on_change_ip, --�����޸�ip
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end


