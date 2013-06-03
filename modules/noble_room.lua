TraceError("init nobleroom_lib...")


if not nobleroom_lib then
    nobleroom_lib = _S
    {
    	------------------------------------------------------------
    	--�����Ƿ���
		is_vip_room = NULL_FUNC,       --�ǲ���VIP��
		on_sitedown_check = NULL_FUNC, --����ʱ���
		on_enter_check = NULL_FUNC,	   --����ʱ���
        on_before_user_enter_desk = NULL_FUNC, 
        on_before_user_site = NULL_FUNC,
        add_vip_to_list = NULL_FUNC,
        ------------------------------------------------------------
        --�����Ǳ���
        CFG_VIP_ROOM_NUM = {},
        CFG_VIP_ROOM_PEILV = {
            [80000]=_U("����ר������1"),
            [40000]=_U("����ר������2"),
            [20000]=_U("����ר������3"),
        },
        
        CFG_NOBLE_ROOM = {
        	[1] = {
        		["name"] = _U("����ר������1"),
        		["description"] = _U("����ר������1"),
        		["needlevel"] = 0,
        		["desktype"] = 0,
        		["smallbet"] = 20000,
        		["largebet"] = 40000,
        		["at_least_gold"] = 40000,
        		["at_least_gold"] = 40000,
        	}
        
        }
 	}
end

--0 ����VIP��     1��VIP��
function nobleroom_lib.is_vip_room(deskno)
	
	for k,v in pairs(nobleroom_lib.CFG_VIP_ROOM_NUM) do
		if k == deskno then
			return 1, v;
		end
	end
	return 0, ""
end

--��VIP���ӵ�Ҫ���صķ����б���
function nobleroom_lib.add_vip_to_list(send_list,vip_list,chosetab)
	--vip������ר�ҳ��ģ���д�������Ҫ֧����������VIP���ٸĽ���
	if chosetab~=4 then return send_list end
	
	for k,v in pairs (nobleroom_lib.CFG_VIP_ROOM_NUM) do
		local find = 0
		for k1,v1 in pairs (send_list) do
			if v1 == v then
				find = 1
				break
			end	
		end
		
		if find==0 then
			table.insert(send_list,v)
		end
	end
	return send_list
end

function nobleroom_lib.on_before_user_enter_desk(user_info, deskno)
	if user_info == nil or deskno == nil then return 0 end
	
	--����VIP����ֱ�Ӳ����ж���
	if nobleroom_lib.is_vip_room(deskno)==0 then return 1 end
	
	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end	
    if vip_level<3 then return 0 end
    
    return 1

end


function nobleroom_lib.on_before_user_site(user_info, deskno)
	if user_info == nil or deskno == nil then return 0 end
	
	--����VIP����ֱ�Ӳ����ж���
	if nobleroom_lib.is_vip_room(deskno)==0 then return 1 end

	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end	
    if vip_level<5 then
        netlib.send(function(buf)
        	buf:writeString("VIPROOMMSG");
        	buf:writeByte(2);
    	end,user_info.ip,user_info.port);
    	return 0 
    end

    return 1

end

function nobleroom_lib.on_enter_check(e)
	local user_info = e.data.userinfo
	local deskno = user_info.desk
	if user_info == nil or deskno == nil then return end
	
	--����VIP����ֱ�Ӳ����ж���
	if nobleroom_lib.is_vip_room(deskno)==0 then return end
	
	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end
    
    if vip_level<3 then
    	netlib.send(function(buf)
            buf:writeString("VIPROOMMSG");
            buf:writeByte(1);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
        end,user_info.ip,user_info.port);
        
        DoUserExitWatch(userinfo)
    end
    
end

function nobleroom_lib.on_sitedown_check(e)
	local user_info = e.data.userinfo
	local deskno = user_info.desk
	if user_info == nil or deskno == nil then return end
	
	--����VIP����ֱ�Ӳ����ж���
	if nobleroom_lib.is_vip_room(deskno)==0 then return end
	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end	
    
   if vip_level<5 then
    	netlib.send(function(buf)
            buf:writeString("VIPROOMMSG");
            buf:writeByte(2);
        end,user_info.ip,user_info.port);
        
        --doUserStandup(user_info.key, false)
    end	
end

--Э������
cmd_nobleroom_handler = 
{
 
}

--���ز���Ļص�
for k, v in pairs(cmd_nobleroom_handler) do 
	cmdHandler_addons[k] = v
end


