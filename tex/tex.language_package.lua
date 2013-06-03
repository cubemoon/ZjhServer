dofile("games/tex/lanpack/language_package_cn.lua")
dofile("games/tex/lanpack/language_package_big5.lua")

--lan="lan_cn"
--userinfo.lan="lan_big5"
if not tex_lan then
	tex_lan = _S
	{
		on_recv_set_lan = NULL_FUNC, --Ԥ����������Ҫ�����Լ������ԣ���Ҫʵ��������ܡ�
        on_after_user_login = NULL_FUNC,		--��ҵ�½�����õķ���
        set_msg = NULL_FUNC,
        get_msg = NULL_FUNC,			--�õ���Ӧ������

	}
end
--lan="lan_cn"
local msg=""

--���ö�Ӧ�����֣�Ԥ������ʱ���á�
function tex_lan.on_after_user_login(userinfo)
	if (userinfo==nil) then return  end
	if(userinfo.nRegSiteNo>=200 and userinfo.nRegSiteNo<300)then
		
		userinfo.lan="lan_big5"
	else
		--userinfo.lan="lan_big5"
		userinfo.lan="lan_cn"
	end
end

function tex_lan.set_msg(tmpStr)
    msg=tmpStr
end

--�õ���Ӧ������
function tex_lan.get_msg(userinfo,msg_key)
	local lan="lan_cn";
	if(userinfo~=nil and userinfo.lan~=nil and userinfo.lan=="lan_big5")then
		lan="lan_big5";
	end
	
	local aa = "tex_lan.set_msg("..lan.."."..msg_key..")"
	--TraceError(aa)	
	local f=loadstring(aa);
	f()
	return msg
end

--Ԥ����������Ҫ�����Լ������ԣ���Ҫʵ��������ܡ�
function tex_lan.on_recv_set_lan(userinfo)
	return
end

--�����б�
cmd_texlan_handler = 
{
   ["SETLAN"] = tex_lan.on_recv_set_lan, --�ͻ��˸��߷����������ʲô����
}

--���ز���Ļص�
for k, v in pairs(cmd_texlan_handler) do 
	cmdHandler_addons[k] = v
end