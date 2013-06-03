
--ֻ֧����ȯ ��ƷҪ�Ķ� һЩ�ط���
--������
TraceError("init shop_lib...")
if shop_lib and shop_lib.restart_server then
	eventmgr:removeEventListener("on_server_start", shop_lib.restart_server);
end

if not shop_lib then
    shop_lib = _S
    {    	   
		open_shop_panl = NULL_FUNC,
		buy_gift = NULL_FUNC,
		get_client_info = NULL_FUNC,
		exchange_real_gift = NULL_FUNC,
		set_gift_list = NULL_FUNC,
		check_can_buy = NULL_FUNC,
		restart_server = NULL_FUNC,
		get_gold_type = NULL_FUNC,
		is_today = NULL_FUNC,
		gift_list = {},
		CFG_SHOPGOLD_TYPE = {
			["SHOP_GOLD"] = 0, --����ͨ��Ʒ
			["HUODONG_GOLD"] = 1, --�ڻ���͵�
			["SHOP_SY_GOLD"] = 2, --��ʵ��
				
		}
    }
end

--����Ʒ���
function shop_lib.open_shop_panl(buf)	
	local user_info = userlist[getuserid(buf)]	
	if user_info == nil then return end
	local gift_type = buf:readByte()
	
	local send_result = function(n_count)
		if gift_type == 0 then user_info.diamond_gold = n_count end --���̳�ʱͬ��һ����ȯ��������
		local gift_list = shop_lib.get_gift_list_by_type(gift_type)
		local gift_list_info = shop_lib.get_gift_info_str(gift_list)
		netlib.send(function(buf)
			buf:writeString("SHOPLS")
			buf:writeInt(n_count)
			buf:writeString(gift_list_info or "")
		end, user_info.ip, user_info.port)
	end
	--Ŀǰֻ��2�ֻ��ҵ�λ���������ȯ
	if gift_type == 0 then
		tex_gamepropslib.get_props_count_by_id(tex_gamepropslib.PROPS_ID.DIAMOND, user_info, send_result)
	else
		send_result(user_info.gamescore)
	end	
end

--��������Ʒ
function shop_lib.buy_gift(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local deskno = user_info.desk
	local desk_info =  desklist[deskno]
	local to_user_siteids = buf:readString() --�ͻ��˾ɳ���û��user_id��Ҫ����Ļ���Ҫ��ʱ��ȽϾã����Ա���ԭ���Ľӿڣ��ɷ���������user_id  
	local gift_type = buf:readByte()
	local gift_id = buf:readInt()
	local gift_count = buf:readInt()
    local gift_type_ex = 0;
	
	--��ֹ�ͻ��˴����쳣������
	if gift_count <= 0 then return end
	local to_user_tab_before = split(to_user_siteids, ",")
	if #to_user_tab_before == 0 then return end
	local remain_gift_count = shop_lib.get_remain_gift(gift_type_ex, gift_id)
	local can_buy,to_user_tab = shop_lib.check_can_buy(user_info, gift_type_ex, gift_id, gift_count * #to_user_tab_before, to_user_tab_before)
	
	--��������򣬾�֪ͨ�ͻ��ˣ�Ȼ��ֱ�ӷ���
	if can_buy ~= 1 then
		netlib.send(function(buf)
			buf:writeString("SHOPBUY")
			buf:writeByte(can_buy)
			buf:writeInt(remain_gift_count)
			buf:writeByte(gift_type_ex)
		end, user_info.ip, user_info.port)
		return
    end
	local to_user_sites = table.clone(to_user_tab);
    local failedusers = {};
    if(shop_lib.is_gift_item(gift_type_ex, gift_id) == 1) then
    	for i = 1, #to_user_sites do
    		local touserinfo = nil
    		local tosite = tonumber(to_user_sites[i]);
    		if(tosite and tosite ~= 0 and deskno and deskno > 0) then
    			touserinfo = deskmgr.getsiteuser(deskno, tosite)
    		else
    			--�͸��Լ�
    			touserinfo = user_info
            end
    
    		if touserinfo then
    			if gift_getgiftcount(touserinfo) + gift_count >= 100 and gift_id < 100000 then
    				if(user_info.userId == touserinfo.userId) then  --�Լ����Լ�����
                        table.remove(to_user_tab, i);
    					net_send_gift_faild(touserinfo, 5, gift_id, gift_count, gift_type)		--���߿ͻ�����������
    				else
                        table.remove(to_user_tab, i);
    					net_send_gift_faild(touserinfo, 3, gift_id, gift_count, gift_type)		--1=�ɹ���Ǯ 2=Ǯ���� 3=�������� 4=�������� 0=�����쳣				
                        table.insert(failedusers, {site = touserinfo.site or 0, retcode = 4})
    				end
    			end
    		end
        end
    
        if(#failedusers > 0) then
            net_send_gift_faildlist(user_info, failedusers)
        end
    end

    if(#to_user_tab <= 0) then
        return;
    end
		
	local need_gift_count = #to_user_tab * gift_count --��Ҫ����Ʒ����
	
	--�ȿ��ʽ�
	local gold_type = shop_lib.get_gold_type(gift_type_ex)
	local cost = shop_lib.gift_list[gift_type_ex][gift_id].cost
	local change_gold = cost * gift_count * #to_user_tab
	
	local call_back = function (props_count)
		--�������ݿ�
		user_info.update_new_shop = 0
		--�ٸ���Ʒ
		local to_user_id = -1
		for k, v in pairs(to_user_tab) do
			to_user_id = shop_lib.get_user_id_by_siteno(deskno, tonumber(v))
			if to_user_id == -2 then
				to_user_id = user_info.userId --�Ҳ�����Ӧ��ID������Լ���
			end
			shop_lib.give_gift(user_info, to_user_id, gift_type_ex, gift_id, gift_count)
		end
		
	  eventmgr:dispatchEvent(Event("on_user_change_coupon", _S{user_id = user_info.userId, to_user_id = to_user_id, gift_count = gift_count, gools_id = gift_id, coupon_num = change_gold}));
		netlib.send(function(buf)
			buf:writeString("SHOPBUY")
			buf:writeByte(1) --����ɹ� 
			buf:writeInt(remain_gift_count - need_gift_count) --�õ�������Ʒ��ʣ������
			buf:writeByte(gift_type_ex)
		end, user_info.ip, user_info.port)
		
		if gift_type_ex == 0 then user_info.diamond_gold = props_count end --���̳�ʱͬ��һ����ȯ��������
		local gift_list = shop_lib.get_gift_list_by_type(0)--��ȯ����0 ����ĳɼ��ݳ��빺��������
		local gift_list_info = shop_lib.get_gift_info_str(gift_list)
		netlib.send(function(buf)
			buf:writeString("SHOPLS")
			buf:writeInt(props_count)
			buf:writeString(gift_list_info or "")
		end, user_info.ip, user_info.port)
		
	end
	
	--������ݿ������򷵻�
	if user_info.update_new_shop and user_info.update_new_shop == 1 then
		return
	end
	--�������ݿ�
	user_info.update_new_shop = 1
	
	
	--�ٿ�ʣ����Ʒ����,��Ǯ
	shop_lib.add_remain_gift(gift_type_ex, gift_id, need_gift_count)
	shop_lib.add_gold(user_info.userId, gold_type, -1 * change_gold, shop_lib.CFG_SHOPGOLD_TYPE.SHOP_GOLD, call_back, gift_count)
end

function shop_lib.send_duihuan_result(user_info, result, remain_gift, gift_type)
	netlib.send(function(buf)
		buf:writeString("SHOPDH2")
		buf:writeByte(result)
		buf:writeInt(remain_gift)
		buf:writeByte(gift_type)
	end, user_info.ip, user_info.port)
end

--�õ�֮ǰ�Ĺ�����Ϣ
--����û��ʵ�ｱ����Ԥ�ڵ����Ҳ��ֻ���ٲ���ʵ�ｱ��������ֱ�Ӷ����ݿ⣬���ʵ�ｱ���кܶ��˶һ�ʱ���Ż�һ����memocache
function shop_lib.get_client_info(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	local gift_type = buf:readByte()
	local gift_id = buf:readInt()
	local gift_count = buf:readInt()
	

	--���һ���ܲ��ܶһ�
	local can_buy = shop_lib.check_can_buy(user_info, gift_type, gift_id, gift_count)
	if can_buy ~= 1 then
		local remain_gift = shop_lib.get_remain_gift(gift_type, gift_id)
		shop_lib.send_duihuan_result(user_info, can_buy, remain_gift, gift_type)
		return
	end
	
	local send_func = function(before_info)
		netlib.send(function(buf)
			buf:writeString("SHOPDH")
			buf:writeString(before_info.real_name or "")
			buf:writeString(before_info.tel or "")
			buf:writeString(before_info.yy_num or "")
			buf:writeString(before_info.real_address or "")			
		end, user_info.ip, user_info.port)
		
	end
	shop_db_lib.get_before_buy_info(user_id, send_func)
	
end

--����һ�ʵ����Ʒ
function shop_lib.exchange_real_gift(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local gift_type = buf:readByte()
	local gift_id = buf:readInt()
	local gift_count = buf:readInt()
	--���һ���ܲ��ܶһ�
	local can_buy = shop_lib.check_can_buy(user_info, gift_type, gift_id, gift_count)
	local remain_gift = shop_lib.get_remain_gift(gift_type, gift_id)
	if can_buy ~= 1 then
		shop_lib.send_duihuan_result(user_info, can_buy, remain_gift, gift_type)
		return
	end
	
	--�ȿ��ʽ�
	local gold_type = shop_lib.get_gold_type(gift_type)
	local cost = shop_lib.gift_list[gift_type][gift_id].cost
	local change_gold = cost * gift_count
	shop_lib.add_gold(user_info.userId, gold_type, -1* change_gold, shop_lib.CFG_SHOPGOLD_TYPE.SHOP_SY_GOLD)
	--�ٿ�ʣ����Ʒ����
	shop_lib.add_remain_gift(gift_type, gift_id, gift_count)	
	
	local real_user_info = {
		["user_id"] = user_info.userId,
		["real_name"] = buf:readString(),
		["tel"] = buf:readString(),
		["yy_num"] = buf:readString(),
		["real_address"] = buf:readString(),
	}
	local gift_des =  shop_lib.gift_list[gift_type][gift_id].gift_des or ""
	shop_db_lib.save_real_gift_info(gift_type, gift_id, gift_count, gift_des, real_user_info)
	--֪ͨ�ͻ��˶һ��ɹ�
	shop_lib.send_duihuan_result(user_info, 1, remain_gift, gift_type)
end

--�õ��ʽ�����
function shop_lib.get_gold_type(gift_type)
	if gift_type == 0 then
		return 0
	else
		return 1
	end
end

--�õ�ĳһ����Ʒ���б�
function shop_lib.get_gift_list_by_type(gift_type)
	if shop_lib.gift_list == nil then return end
	return shop_lib.gift_list[gift_type]
end

--�õ���||�ָ����ַ���
function shop_lib.get_gift_info_str(gift_list)
	if not gift_list then return end
	local tmp_str = ""
	for k, v in pairs(gift_list) do
		tmp_str = tmp_str .. "||" ..v.gift_type --��Ʒ���� 0 ��� 1���� 2 һ�� 3ͼֽ
		tmp_str = tmp_str.."||"..v.ex_type --��ȯ�����ɵ�����
		if v.gift_type == 0 and v.ex_type==4 then
			tmp_str = tmp_str .. "||1" --�Ƿ�ʵ�0���ǣ�1��)
		else
			tmp_str = tmp_str .. "||0" --�Ƿ�ʵ�0���ǣ�1��)
		end
		tmp_str = tmp_str .. "||" ..v.gift_id --��Ʒ���
		tmp_str = tmp_str .. "||" ..v.cost --��Ʒ�۸�
		local remain_num = shop_lib.get_remain_gift(v.gift_type, v.gift_id)
		tmp_str = tmp_str .. "||" ..remain_num --ʣ������
		tmp_str = tmp_str .. "||" ..v.can_give    --�Ƿ������
		if tonumber(v.valid_time) == -999 then
			tmp_str = tmp_str .. "||" .._U("����")  --��Ч��
		else
			tmp_str = tmp_str .. "||" ..v.valid_time.._U("��")  --��Ч��
		end
		tmp_str = tmp_str.."||"..v.gift_des
		
	end
	tmp_str=string.sub(tmp_str, 3) --ȥ����һ��||
	return tmp_str
end

--�ṩ�ӿڣ���������ĳһ����Ʒ��Ϣ
function shop_lib.set_gift_list_by_type(gift_type, gift_list_tab)
	shop_lib.gift_list[gift_type] = {}
	for k, v in pairs(gift_list_tab) do
		shop_lib.gift_list[gift_type][v.gift_id] = v
	end
end

--�ж��ǲ�������
--���� -1���Ҳ��� -2��Ʒ���� -3�������� 1�ܹ���
function shop_lib.check_can_buy(user_info, gift_type, gift_id, gift_count, to_user_tab)
	if user_info == nil then return -3 end
	local deskno = user_info.desk
	
	local cost = shop_lib.gift_list[gift_type][gift_id].cost
	local need_gold = cost * gift_count
	local can_use_gold = get_canuse_gold(user_info);
	if gift_type == 0 and  need_gold > user_info.diamond_gold then
		return -1
	end
	if gift_type ~= 0 and need_gold > can_use_gold then
		return -1
	end
	
	local remain_count = shop_lib.get_remain_gift(gift_type, gift_id)
	if gift_count > remain_count then
		return -2
	end
	
	if to_user_tab then
		for k, v in pairs(to_user_tab)do
			if tonumber(v) ~= 0 then
				local to_user_info = shop_lib.get_user_id_by_siteno(deskno, tonumber(v))
				if to_user_info == -1 then 
					table.remove(to_user_tab,k) 
				end
			end
		end
		return 1,to_user_tab
	end
	return 1
end

--��Ʒ�Ӽ�Ǯ�Ľӿ�
--gold_type==0 ��ȯ  gold_type==1 ���� 
--change_gold �仯���ʽ�����
--change_result �仯��ԭ��
--�������������ȷ���жϣ�����Ǯ��������ҪԤ���жϺ�
function shop_lib.add_gold(user_id, gold_type, change_gold, change_result, call_back, gift_count)
	local before_change = 0
	if not gift_count then gift_count = 1  end
	--�Ӽ�Ǯ
    local user_info = usermgr.GetUserById(user_id)
	if gold_type == 0 then
		if user_info == nil then return end --Ŀǰ��ȯֻ�����߲�����
		before_change = user_info.diamond_gold
		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.DIAMOND, change_gold, user_info, call_back)
		
	else
		before_change = user_info.gamescore
		usermgr.addgold(user_id, change_gold, 0, new_gold_type.NEW_SHOP, -1);
	end
	
	--д��־
	shop_db_lib.add_gold_log(user_id, gold_type, change_gold, before_change, change_result)
end

--����Ʒ
function shop_lib.give_gift(from_user_info, to_user_id, gift_type, gift_id, gift_count)
	local to_user_info = usermgr.GetUserById(to_user_id)
	if to_user_info == nil then return end --��ʱ��֧���������� 
	local read_gift_type = gift_type
	if gift_type == 0 then
		read_gift_type = shop_lib.gift_list[0][gift_id].ex_type
	end

	if read_gift_type == 1 then --��Ʒ
		for i=1, gift_count do
			gift_addgiftitem(to_user_info, gift_id, from_user_info.userId, from_user_info.nick, true)
		end
		if from_user_info.site then
			tex_gamepropslib.net_broadcast_togive_props(from_user_info.desk, from_user_info.site, to_user_info.site, gift_id, 1, gift_count)
		end
	elseif read_gift_type == 2 then --���ߺ�ͼֽ
		tex_gamepropslib.set_props_count_by_id(gift_id, gift_count, to_user_info)
		if from_user_info.site then
			tex_gamepropslib.net_broadcast_togive_props(from_user_info.desk, from_user_info.site, to_user_info.site, gift_id, 2, gift_count)
		end
	elseif read_gift_type == 3 then --��
		for i=1, gift_count do
			car_match_db_lib.add_car(to_user_info.userId, gift_id, 0, 1)
		end
		if from_user_info.site then
			tex_gamepropslib.net_broadcast_togive_props(from_user_info.desk, from_user_info.site, to_user_info.site, gift_id, 3, gift_count)
		end
	end 
end

--�仯����ʣ������
function shop_lib.add_remain_gift(gift_type, gift_id, change_count)
	if shop_lib.is_today(timelib.db_to_lua_time(shop_lib.gift_list[gift_type][gift_id].sys_time)) == 1 then
		shop_lib.gift_list[gift_type][gift_id].today_num = shop_lib.gift_list[gift_type][gift_id].today_num + change_count
	else
		shop_lib.gift_list[gift_type][gift_id].today_num = change_count
	end
	
	shop_lib.gift_list[gift_type][gift_id].sys_time = timelib.lua_to_db_time(os.time())
	--�޸����ݿ�
	shop_db_lib.save_today_num(gift_type, gift_id, change_count)
end

-- �õ�ʣ����Ʒ����
function shop_lib.get_remain_gift(gift_type, gift_id)
	if gift_type == nil or gift_id == nil then
		TraceError(debug.traceback())
		return -1
	end
	if shop_lib.gift_list[gift_type][gift_id].sys_time ~= nil and shop_lib.is_today(timelib.db_to_lua_time(shop_lib.gift_list[gift_type][gift_id].sys_time)) == 1 then
		return shop_lib.gift_list[gift_type][gift_id].gift_num - shop_lib.gift_list[gift_type][gift_id].today_num
	else
		return shop_lib.gift_list[gift_type][gift_id].gift_num
	end
end

function shop_lib.is_gift_item(gift_type, gift_id)
    if(shop_lib.gift_list[gift_type][gift_id].ex_type == 1) then
        return 1;
    end
    return 0;
end

function shop_lib.get_user_id_by_siteno(deskno, siteno)
	if siteno == 0 then return -2 end
	if deskno==nil or siteno == nil then return -1 end
	local desk_info =  desklist[deskno]
	if not desk_info then return -1 end
	local user_info = userlist[desk_info.site[siteno].user]
	if user_info == nil then
		return -1
	else
		return user_info.userId
	end
end

function shop_lib.restart_server()
	shop_db_lib.init_coupon_list()
end

--�ǲ�����ͬһ��
function shop_lib.is_today(time1, time2)
	if time1==nil  or time1=="" then return 0 end
	if time2 == nil  or time2=="" then time2 = os.time() end
	local table_time1 = os.date("*t",time1);
	local year1  = table_time1.year;
	local month1 = table_time1.month;
	local day1 = table_time1.day;
	local time1 = year1.."-"..month1.."-"..day1.." 00:00:00"
	
	local table_time2 = os.date("*t",time2);
	local year2  = tonumber(table_time2.year);
	local month2 = tonumber(table_time2.month);
	local day2 = tonumber(table_time2.day);
	local time2 = year2.."-"..month2.."-"..day2.." 00:00:00"

	--�ݴ������ʱ���õ��յģ���õ�1970��
	if (tonumber(year1)<2012 or tonumber(year2)<2012) then 
		return 0 
	end
	if (time1 ~= time2) then
		return 0
	end
	return 1
end

--Э������
cmd_shop_handler = 
{
	["SHOPLS"] = shop_lib.open_shop_panl,
	["SHOPBUY"] = shop_lib.buy_gift,
	["SHOPDH"] = shop_lib.get_client_info,
	["SHOPDH2"] = shop_lib.exchange_real_gift,
}

--���ز���Ļص�
for k, v in pairs(cmd_shop_handler) do 
	cmdHandler_addons[k] = v
end
eventmgr:addEventListener("on_server_start", shop_lib.restart_server)