TraceError("init spq....")

if not tex_suanpaiqilib then
	tex_suanpaiqilib = _S
	{
        on_recvclick_suan=NULL_FUNC, --�յ�������㡱��ť
        on_user_game_over=NULL_FUNC, --����ʱ��Ǯ
	}
end

function tex_suanpaiqilib.on_recvclick_suan(buf)
   -- TraceError("�յ��������")
	local user_info = userlist[getuserid(buf)]; 

    if(user_info.gameInfo.suan==nil)then
        user_info.gameInfo.suan = {};
    end

    --���������أ�0�أ�1��
    local suan_switch=buf:readByte(); 
    --TraceError("suan_switch="..tostring(suan_switch));
    user_info.gameInfo.suan.suan_switch=suan_switch;
    user_info.gameInfo.suan.is_use_suan=0;--Ĭ��Ϊ����û�ù�����


    --�Ƿ����������ƹ���
    local can_use_suan=1;
	
	--����Ҫ�۵�Ǯ
	local smallbet = 0
	local usespq_money=0
	
	--���˽���ʱû�����Ӻţ�����Ϊ��ֲ�����������
	if (user_info.desk==nil or desklist[user_info.desk]==nil) then 
		can_use_suan=-1
	else
		smallbet = desklist[user_info.desk].smallbet;	
		usespq_money=smallbet/10;
		if(usespq_money<10) then usespq_money=10 end;
	    if(usespq_money>400) then usespq_money=400 end;
	        --�����ܲ��������������ܣ���ֱ�ӷ��ش�����Ϣ
	    if(is_can_usesuan(user_info,usespq_money)==0)then
	        can_use_suan=-1
	    end
	end
	


    --�����ù�������
    if(can_use_suan~=-1)then
        user_info.gameInfo.suan.is_use_suan=1;
    end

    --�ر�������
    if(suan_switch==0)then
         can_use_suan=-2;
    end

    --�����������������
    --��Ǯ       
	--usermgr.addgold(user_info.userId, -usespq_money, 0, g_GoldType.spq_usespq, -1, 1);
    
	--�����ͻ��˸���
	     netlib.send(
            function(buf)
                buf:writeString("SPQCLICKSUAN")
                buf:writeByte(can_use_suan)  --�ܷ�ʹ��
            end,user_info.ip,user_info.port)	
end


function tex_suanpaiqilib.on_user_game_over(user_info)
    --����û�ù����ƣ��������ƿ���Ҳ�ǹصģ�ֱ��return
    if (user_info==nil) then return end;
    if(user_info.gameInfo.suan==nil or user_info.desk==nil)then
        return;
    end

    if( user_info.gameInfo.suan.is_use_suan~=1 and user_info.gameInfo.suan.suan_switch==0)then
        return;
    end

    local user_level=usermgr.getlevel(user_info);


    local smallbet = desklist[user_info.desk].smallbet;	
	local usespq_money=smallbet/10;
	if(usespq_money<10) then usespq_money=10 end;
    if(usespq_money>400) then usespq_money=400 end;
    if(user_level<4)then usespq_money=0 end;--�ȼ�С��4��������û�

    --�������ǿ��Ļ��������ù����ƵĹ��ܣ�ֱ�ӿ�Ǯ
    if(user_info.gameInfo.suan.suan_switch==1 or user_info.gameInfo.suan.is_use_suan==1)then
        --��Ǯ
        if(is_can_usesuan(user_info,usespq_money) == 1) then
            usermgr.addgold(user_info.userId, -usespq_money, 0, g_GoldType.spq_usespq, -1, 1);
        end
    end

    --�������ǹص�,��һ�̿�ʼʱ���޸�״̬ΪĬ����û�ù����ƹ���
    if(user_info.gameInfo.suan.suan_switch==0)then
        user_info.gameInfo.suan.is_use_suan=0;
    end
end


--���ǲ������ʸ���������
function is_can_usesuan(user_info,usespq_money)
    
    --û�õ��û���Ϣ����������
	if not user_info then return 0 end;
	if not user_info.desk or user_info.desk <= 0 then return 0 end;
    local user_level=usermgr.getlevel(user_info);

	--�ȼ�С��4��������û���ֱ������
    if(user_level<4)then
        return 1;
    end

	--����Ǯ�Ƿ�
	if (get_canuse_gold(user_info) < usespq_money) then
		return 0;
	end
	
	--�Ƿ��ǻƽ����ϵ�VIP
	local viplevel = 0
	if(viplib) then
	    viplevel = viplib.get_vip_level(user_info);
	end
	
	if (viplevel<3) then
		return 0;
	end
    
	--���������������㣬�����������������
	return 1;
end


--�����б�
cmd_suan_pan_qi_handler = 
{
	["SPQCLICKSUAN"] = tex_suanpaiqilib.on_recvclick_suan, --�յ�������㡱��ť
   
}

--���ز���Ļص�
for k, v in pairs(cmd_suan_pan_qi_handler) do 
	cmdHandler_addons[k] = v
end






