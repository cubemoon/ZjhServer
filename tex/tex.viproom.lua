TraceError("init viproom_lib...")
if viproom_lib and viproom_lib.ongamebegin then 
	eventmgr:removeEventListener("game_begin_event", viproom_lib.ongamebegin)
end
if viproom_lib and viproom_lib.ongame_having_sitegold then 
	eventmgr:removeEventListener("ongame_having_sitegold", viproom_lib.ongame_having_sitegold)
end
--wing_lib.get_wing_level(user_id)
--����ǵõ��ǲ��ǹ��壨0��ƽ��1��9����Խ��Խ�ߣ�
if not viproom_lib then
    viproom_lib = _S
    {
    	------------------------------------------------------------
    	--�����Ƿ���
		on_sitedown_check = NULL_FUNC, --����ʱ���
		on_enter_check = NULL_FUNC,	   --����ʱ���
        on_before_user_enter_desk = NULL_FUNC, 
        on_before_user_site = NULL_FUNC,
        add_vip_to_list = NULL_FUNC,
        ------------------------------------------------------------
        --�����Ǳ���
        CFG_VIP_ROOM_NUM = {},
        CFG_DESK_LIST = {},
        desk_list = {},
        --room_type=1 VIP���� =2ʱ�ǹ��巿
 	}
end

viproom_lib.CFG_VIP_ROOM_PEILV = {
            [1] = {
            	["small_bet"] = 25000,
            	["room_name"] = _U("VIPר������1"),
            	["room_type"] = 1,
            	["desk_list"] = {},
            },
            [2] = {
            	["small_bet"] =20000,
            	["room_name"] = _U("VIPר������2"),
            	["room_type"] = 1,
            	["desk_list"] = {},
            },
            [3] = {
            	["small_bet"] =10000,
            	["room_name"] = _U("VIPר������3"),
            	["room_type"] = 1,
            	["desk_list"] = {},
            	
            },
            [4] = {
            	["small_bet"] =40000,
            	["room_name"] = _U("������峡"),
            	["room_type"] = 2,
            	["room_level"]  = 6, --����ǹ���ȼ�
            	["desk_list"] = {},
            },
            [5] = {
            	["small_bet"] =20000,
            	["room_name"] = _U("�������峡"),
            	["room_type"] = 2,
            	["room_level"]  = 5, --����ǹ���ȼ�
            	["desk_list"] = {},
            },
            
            [6] = {
            	["small_bet"] =10000,
            	["room_name"] = _U("�Ӿ����峡"),
            	["room_type"] = 2,
            	["room_level"]  = 4, --����ǹ���ȼ�
            	["desk_list"] = {},
            },
            [7] = {
            	["small_bet"] =5000,
            	["room_name"] = _U("�о����峡"),
            	["room_type"] = 2,
            	["room_level"]  = 3, --����ǹ���ȼ�
            	["desk_list"] = {},
            },
        }
        
        viproom_lib.CFG_GZ_GOLD = {
        	[5000] = 120000,
        	[10000] = 240000,
        	[20000] = 580000,
        	[40000] = 1280000,
        }
        viproom_lib.CFG_ERROR_CODE = {
          ["VIP_EN_LEVEL_ERROR"] = 1,     --VIP���뷿��ȼ�������
        	["VIP_SIT_LEVEL_ERROR"] = 2,     --VIP���µȼ�������
        	["NOBLE_GOLD_ERR"] = 3,    --�����巿ʱ���µ�Ǯ����
        }
	viproom_lib.CFG_DESK_LIST = {
		[40000] = {
			["desktype"] = 1,
		}, 
		[40001] = {
			["desktype"] = 1,
		},  
		[40002] = {
			["desktype"] = 1,
		},  
		[40003] = {
			["desktype"] =2,
			["room_level"] = 3,
		},  
		[40004] = {
			["desktype"] =2,
			["room_level"] = 4,
		},  
		[40005] = {
			["desktype"] = 2,
			["room_level"] = 5,
		},  
		[40006] = {
			["desktype"] = 2,
			["room_level"] = 6,
		},  
	}

--0 ����VIP��     1��VIP��
function viproom_lib.get_room_spec_type(deskno)
	--�����VIP������1
	local deskinfo = desklist[deskno]
	if deskinfo.desktype == g_DeskType.nobleroom or deskinfo.desktype == g_DeskType.VIP then 		
		return  viproom_lib.get_desktype_by_dbid(deskinfo.db_desk_id)
	end
	--��ͨ������0
	return 0
end

--�õ����巿����Ҫ�ĵ�ע
function viproom_lib.get_to_noble_gold(smallbet)
	if viproom_lib.CFG_GZ_GOLD[smallbet] ~= nil then
		return viproom_lib.CFG_GZ_GOLD[smallbet]
	end
	--��Ӫ��Ա�������ò����ˣ�
	return 0
end

function viproom_lib.get_room_spec_level(deskno)
	--�����VIP������1
	local deskinfo = desklist[deskno]
	if deskinfo.desktype == g_DeskType.nobleroom then 		
		return  viproom_lib.get_roomlevel_by_dbid(deskinfo.db_desk_id)
	end
	--��ͨ������0
	return 0
end

function viproom_lib.get_roomlevel_by_dbid(db_desk_id)
	if viproom_lib.CFG_DESK_LIST[db_desk_id] == nil then return 0 end
	return viproom_lib.CFG_DESK_LIST[db_desk_id].room_level
end

function viproom_lib.get_desktype_by_dbid(db_desk_id)
	if viproom_lib.CFG_DESK_LIST[db_desk_id] == nil then return 0 end
	return viproom_lib.CFG_DESK_LIST[db_desk_id].desktype
end

function viproom_lib.on_before_user_enter_desk(user_info, deskno)
	if user_info == nil or deskno == nil then return 0 end
	local deskinfo = desklist[deskno]
	if deskinfo == nil then return 0 end
	--����VIP����ֱ�Ӳ����ж���
	if viproom_lib.get_room_spec_type(deskno)==0 then return 1 end

	local  room_type = viproom_lib.get_room_spec_type(deskno)
	--�ĳɲ���Ҫ������ʱ�ж���
	local  room_level = viproom_lib.get_room_spec_level(deskno)   --���û�䣬����0�������Խ�
	
	local user_wing_level = 1
	if wing_lib then
	   user_wing_level = wing_lib.get_wing_level(user_info.userId)
	end
	
	local vip_level = 0

    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end	
    --�����VIP������ôVIP�ȼ�����С��3������ǹ��巿���ǹ���ȼ����ܵ��ڷ���Ҫ��ĵȼ�
    if room_type == 1 and vip_level<3 then
    	return 0 
--    elseif room_type ==2 and  user_wing_level < room_level then
--    	return -1
    end   
    return 1

end


function viproom_lib.on_before_user_site(user_info, deskno)
	if user_info == nil or deskno == nil then return 0 end
	local deskinfo = desklist[deskno]
	--����VIP����ֱ�Ӳ����ж���
	if viproom_lib.get_room_spec_type(deskno)==0 then return 1 end
	local  room_type =viproom_lib.get_room_spec_type(deskno)
	local  room_level = viproom_lib.get_room_spec_level(deskno) --���û�䣬����0�������Խ�
	if not wing_lib then return end
	local user_wing_level = wing_lib.get_wing_level(user_info.userId)
	
	local vip_level = 0
    if viplib then
        vip_level = viplib.get_vip_level(user_info)
    end	
    if room_type == 1 and vip_level<5 then
		viproom_lib.send_viproom_msg(user_info, viproom_lib.CFG_ERROR_CODE["VIP_SIT_LEVEL_ERROR"])
    	return 0 
    end
    
    --������ϵ�Ǯ������ֱ������
	--if room_type == 2 and user_info.chouma < deskinfo.largebet + deskinfo.specal_choushui + 1 + viproom_lib.CFG_GZ_GOLD[deskinfo.smallbet] then
	if room_type == 2 and user_info.chouma < deskinfo.at_least_gold then
		viproom_lib.send_viproom_msg(user_info, viproom_lib.CFG_ERROR_CODE["NOBLE_GOLD_ERR"])
    	return 0 
    end
    return 1

end

function viproom_lib.send_viproom_msg(user_info, msg_type)
        netlib.send(function(buf)
        	buf:writeString("VIPROOMMSG");
        	buf:writeByte(msg_type);
    	end,user_info.ip,user_info.port);
end

--�õ���Щ���������ID
function viproom_lib.is_spec_room_id(already_desk_list, deskno)
	--���֮ǰ�Ѿ�ѡ����������ӣ��Ͳ�Ҫ��ѡ��
	for k, v in pairs (already_desk_list) do
		if v == deskno then
			return -1
		end
	end
	--�����VIP������1
	local deskinfo = desklist[deskno]
	if deskinfo.desktype == g_DeskType.nobleroom then 
		return 1
	end
	--��ͨ������0
	return 0
end

function viproom_lib.ongamebegin(e)
	local deskno = e.data.deskno
	local deskinfo = desklist[deskno]
	if viproom_lib.get_room_spec_type(deskno) ~= 2 then
		return 
	end 
	for _, player in pairs(deskmgr.getplayers(deskno)) do
		local userinfo = player.userinfo
		local state = hall.desk.get_site_state(deskno, player.siteno)
		local user_chouma = userinfo.chouma
		--Ҫ�ж����userinfo.chouma < deskinfo.largebet + deskinfo.specal_choushui + 1 +  viproom_lib.CFG_GZ_GOLD[deskinfo.smallbet]
		if (userinfo.chouma < deskinfo.largebet + deskinfo.specal_choushui + 1 +  viproom_lib.CFG_GZ_GOLD[deskinfo.smallbet]) then
			--վ�𲢼����ս
			doStandUpAndWatch(userinfo)
			viproom_lib.send_viproom_msg(userinfo, viproom_lib.CFG_ERROR_CODE["NOBLE_GOLD_ERR"])
		else
			--viproom_lib.add_gold(userinfo, viproom_lib.CFG_GZ_GOLD[deskinfo.smallbet])
			--�����Ȳ���Ǯ�������õ����ӵ�Ǯʱ�ٿ�
		end
	end
end

--��ұ仯
function viproom_lib.add_gold(user_info, change_gold)
	if viproom_lib.get_room_spec_type(user_info.desk) ~= 2 then
		return 
	end 
	add_bet_gold(user_info, change_gold, 8) --�¹��峡��ע
end

function viproom_lib.ongame_having_sitegold(e)
	local user_info = e.data.user_info
	local deskno = e.data.deskno
	local deskinfo = desklist[deskno] 
	local round = e.data.round
	if round ~= 0 then
		return
	end
	viproom_lib.add_gold(user_info, viproom_lib.CFG_GZ_GOLD[deskinfo.smallbet])
end

function viproom_lib.init_vip_desk(deskinfo)
	if deskinfo.desktype == g_DeskType.nobleroom then
		table.insert(viproom_lib.desk_list, deskinfo)
	end
end
--Э������
cmd_viproom_handler = 
{
 
}

--���ز���Ļص�
for k, v in pairs(cmd_viproom_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("game_begin_event", viproom_lib.ongamebegin)

eventmgr:addEventListener("ongame_having_sitegold", viproom_lib.ongame_having_sitegold)
