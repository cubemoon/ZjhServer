TraceError("init super_cow_lib...")

if not chat_tools_lib then
    chat_tools_lib = _S
    {    	   
		on_recv_chat=NULL_FUNC, --�ͻ��˷�������Ϣ
		send_chat_msg=NULL_FUNC,  --����˷�������Ϣ
    }    
end


chat_tools_lib.on_recv_chat=function(buf)
	local user_info = userlist[getuserid(buf)];	
	if(user_info==nil)then return end;
	local huodong_type=buf:readByte();
	local chat_msg=buf:readString();
	local from_user_id=buf:readInt();
	local chat_type=1; --С��Ϸ��������1������
	local chat_user_list={}
	if(huodong_type==1)then
		chat_user_list=super_cow_lib.user_list
	end
	
	chat_msg = string.gsub(chat_msg, "\r", "")
    chat_msg = string.gsub(chat_msg, "\n", "")
    if(texfilter)then
		chat_msg = texfilter.change_string_by_pingbikey(chat_msg);
		for k,v in pairs(chat_user_list)do
			local user_info=usermgr.GetUserById(v.user_id)
			chat_tools_lib.send_chat_msg(user_info,chat_msg,huodong_type,chat_type,from_user_id)	
		end
	end
end

--��������Ϣ 
--huodong_type С��Ϸ��ʶ��1�����ţ��
--chat_type �������ͣ�1����ǰ��Ϸ��2��������Ϸ��3����ǰ��Ϸϵͳ��Ϣ��4��������Ϸϵͳ��Ϣ��
--�統ǰС��Ϸ�������������1��������˳���3��
chat_tools_lib.send_chat_msg=function(user_info,chat_msg,huodong_type,chat_type,from_user_id)
	if (user_info==nil) then return end
	local from_user_info=usermgr.GetUserById(from_user_id)
	if(from_user_info==nil) then return end
	netlib.send(function(buf)
            buf:writeString("TJDCHAT");
            buf:writeByte(huodong_type);
            buf:writeByte(chat_type);
            buf:writeString(chat_msg);
            buf:writeInt(from_user_info.userId);
            buf:writeString(from_user_info.imgUrl or "");
            buf:writeString(from_user_info.nick or "");
            
        end,user_info.ip,user_info.port);	

end

--Э������
cmd_chattools_handler = 
{
        ["TJDCHAT"] = chat_tools_lib.on_recv_chat, --�ͻ��ˣ��������Ƿ���Ч
}

--���ز���Ļص�
for k, v in pairs(cmd_chattools_handler) do 
	cmdHandler_addons[k] = v
end
