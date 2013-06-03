TraceError("init hecheng_lib...")

if hecheng_lib and hecheng_lib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", hecheng_lib.on_user_exit);
end

if hecheng_lib and hecheng_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", hecheng_lib.on_after_user_login);
end

if hecheng_lib and hecheng_lib.timer then
	eventmgr:removeEventListener("timer_second", hecheng_lib.timer);
end

if hecheng_lib and hecheng_lib.already_init_gift then
    eventmgr:removeEventListener("already_init_gift", hecheng_lib.already_init_gift);
end

if hecheng_lib and hecheng_lib.already_init_car then
    eventmgr:removeEventListener("already_init_car", hecheng_lib.already_init_car);
end

if hecheng_lib and hecheng_lib.already_init_prop then
    eventmgr:removeEventListener("after_get_props_list", hecheng_lib.already_init_prop)
end



if not hecheng_lib then
    hecheng_lib = _S
    {
    	--�����Ƿ���
        open_panl = NULL_FUNC,
        check_status = NULL_FUNC,
        check_datetime = NULL_FUNC,
        send_tz = NULL_FUNC,
        is_zhong = NULL_FUNC, --��һ�����ʽ�ȥ������û����
        hecheng_item = NULL_FUNC, --�ͻ�������ϳ�
        get_need_peifang = NULL_FUNC, --�õ���Ҫ���䷽
        query_tz = NULL_FUNC,
        query_item = NULL_FUNC,
        get_count = NULL_FUNC,
        send_item = NULL_FUNC,
        check_peifang = NULL_FUNC,
        check_tuzhi   = NULL_FUNC,
        give_hecheng_reward = NULL_FUNC, 
        get_hecheng_count = NULL_FUNC,
        on_user_exit = NULL_FUNC,
        on_after_user_login = NULL_FUNC, 
        
        --�����Ǳ�����������Ϣ
 		user_list = {},
		startime = "2012-11-01 09:00:00",  --���ʼʱ��
    	endtime = "2020-11-20 23:59:59",  --�����ʱ��
    	start_time = "2012-11-01 09:00:00",  --���ʼʱ��
    	end_time = "2020-11-20 23:59:59",  --�����ʱ��
    	start_bike = "2012-11-09 09:00:00",  --���ʼʱ��
    	end_bike   = "2012-11-14 23:59:59",  --�����ʱ��
    
    	CFG_TZ_CLASS = {
    		[1] = "������",
    		[2] = "������",
    		[3] = "���",
    		[4] = "ͼֽ��",
    		
    	},
    	CFG_TZ = {
    		[100001] = {
    			["tz_name"] = "��Ʊͼֽ",
    			["tz_desc"] = "��Ʊͼֽ�����Ժϳ���������Ʊ1�š�\n�ϳ��䷽��ˮ���˿�+÷��A+÷��K+÷��Q+÷��J",
    			["hc_id"] = 5056,
    			["hc_name"] = "��Ʊ*1",
    			["hc_desc"] = "��Ʊ������3���ӻ��ʹ����Ʊ��Ϸ����Ʊ�޷�ȡ���� ",
    			["hc_fy_desc"] = "���Ҫ������Ǯzentao��û�� ",
       			["peifang_desc"] = "ˮ���˿�+÷��A+÷��K+÷��Q+÷��J",
    			["peifang"] = "5055,5014,5024,5025,5026", --�����2����ͬ�ģ�����д2��
    			["gailv"] = "0.5",
    			["class_id"] = 1,
    			
    		},
    		[100002] = {
    			["tz_name"] = "����ͼֽ",
    			["tz_desc"] = "����ͼֽ�����Ժϳɲ���1�ѡ�\n�ϳ��䷽��ˮ���˿�*2+����A+����K+����Q+����J",
    			["hc_id"] = 5057,
    			["hc_name"] = "����*1",
    			["hc_desc"] = "���ӣ������ڱ����ʹ�ã�ʹ�ú�����ڵ���Ʒ��  ",
	 			["hc_fy_desc"] = "���Ҫ������Ǯzentao��û��",
    			["peifang_desc"] = "ˮ���˿�*2+����A+����K+����Q+����J",
    			["peifang"] = "5055|2,5037,5038,5039,5027", 
    			["gailv"] = "0.5",
    			["class_id"] = 1,
    		},    		
    		[100003] = {
    			["tz_name"] = "10���˱�ͼֽ",
    			["tz_desc"] = "10���˱�ͼֽ�����Ժϳ�10�����˱ҡ�\n�ϳ��䷽��ˮ���˿�*10+����A+����K+����Q+����J",
    			["hc_id"] = 100003,
    			["hc_name"] = "���˱�*10",
    			["hc_desc"] = "���˱�*10",
    			["hc_fy_desc"] = "���Ҫ������Ǯzentao��û��",
    			["peifang_desc"] = "ˮ���˿�*10+����A+����K+����Q+����J",
    			["peifang"] = "5055|10,5037,5038,5039,5027", 
    			["gailv"] = "0.5",
    			["class_id"] = 2,
    		},
    	},
    	CFG_ITEM_NAME = {},
    	CFG_HUODONG_TZ = {    --�ʱ��Ҷ��е�ͼֽ����������Ƴ�ʼ��������д��-1
    		[100002] = 3,
    		[100003] = 2,
    	}, 
    	CFG_ALL_CARS = {
        5012,--�׿ǳ�
        5013,--����
        5018,--ѩ����
        5021,--��ɯ����
        5024,--������
        5026,--��������
        5027,--���ӵ�����
        5036,--���ӵ������ƽ��
      },
    }
end
 
 
--��ѯ��Ƿ������
function hecheng_lib.check_status(buf)
	--local user_info = userlist[getuserid(buf)]
	--if user_info == nil then return end

	local status = hecheng_lib.check_datetime()
   	netlib.send(function(buf)
            buf:writeString("HCHACTIVE");
            buf:writeInt(status or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
	end,buf:ip(),buf:port());
end

function hecheng_lib.open_panl(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId

	
	local call_back = function(user_id)
		eventmgr:dispatchEvent(Event("before_open_hecheng",	{user_info = user_info}))
		hecheng_lib.send_tz(user_id)
		hecheng_lib.send_item(user_id)
		hecheng_lib.send_car_info(user_id)
--		hecheng_lib.send_wing_info(user_id)
	end

	--���û��ʼ���������ȳ�ʼ��
--	if hecheng_lib.user_list[user_id] == nil then
		hecheng_db_lib.init_hecheng_info(user_id, call_back)
--	else
--		call_back(user_id)		
--	end
end

--�����Чʱ�䣬��ʱ����int	0�����Ч�������Ҳ�ɲ�������1�����Ч
function hecheng_lib.check_datetime()
	local sys_time = os.time();	
	local startime = timelib.db_to_lua_time(hecheng_lib.startime);
	local endtime = timelib.db_to_lua_time(hecheng_lib.endtime);
	
	if(sys_time > endtime or sys_time < startime) then
		return 0;
	end

	--�ʱ���ȥ��
	return 1;

end

--��ѯͼֽ
function hecheng_lib.query_tz(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	hecheng_lib.send_tz(user_id)
end

--��ѯ������Ĳ���
function hecheng_lib.query_item(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	hecheng_lib.send_item(user_id)
end

--��ѯ����
function hecheng_lib.query_car(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	hecheng_lib.send_car_info(user_id)
end

--�õ�ĳ��list�ж��ٸ�Ԫ��
function hecheng_lib.get_count(tab)
	local count = 0
	for k, v  in pairs(tab) do
		count = count + 1
	end
	return count
end

function hecheng_lib.get_tuzhi_count(user_id, item_id, class_id)
	if not user_id then
		return -1;
	end
	
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return -1; end
	
--	if class_id ~= 4 and class_id ~= 5 then
--		--���Ϊ-2��ͼֽΪ���������
--		return -2;
--	end
	
	if not hecheng_lib.user_list[user_id].tz[item_id] then
		hecheng_lib.user_list[user_id].tz[item_id] ={}
		hecheng_lib.user_list[user_id].tz[item_id].item_id = item_id;
		hecheng_lib.user_list[user_id].tz[item_id].item_count = 0;
	end
	return hecheng_lib.user_list[user_id].tz[item_id].item_count;
end
--��ͼֽ��Ϣ
function hecheng_lib.send_tz(user_id)
	if not user_id then
		return 0;
	end
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	--local tz_count = hecheng_lib.get_count(hecheng_lib.user_list[user_id].tz) --�ж���ͼֽ
  --local tz_count = 13
  --if wing_lib and --���ǹ����ȼ�
  --tz_count = 14
  --end
	local tb_tz_id = {100105,100106,100107,100108,100109,100110,100111,100112,100113,100114,100115,100116,100117,100118,100119}
	if wing_lib and wing_lib.get_wing_level(user_id) >= 0 and wing_lib.get_wing_level(user_id) < 9 then
	  local wing_tz_id = 100120 --��ʿ���
	  wing_tz_id = wing_tz_id + wing_lib.get_wing_level(user_id)
    table.insert(tb_tz_id,wing_tz_id)
  end
	hecheng_lib.send_tz_to_client(user_info, tb_tz_id)

end

function hecheng_lib.get_need_peifang(tz_id)
	local peifang_tab = {}
	local tmp_peifang_tab = split(hecheng_lib.CFG_TZ[tz_id].peifang, ",")
	for i = 1, #tmp_peifang_tab do
		local tmp_tab = split(tmp_peifang_tab[i], "|")
		local cl_id = tonumber(tmp_tab[1]) --����ID
		local cl_count = 1 --��������
		local cl_type  = 1 --Ĭ�ϵ��߲���
		if #tmp_tab > 1 then
			cl_count = tonumber(tmp_tab[2])
		end
		if #tmp_tab > 2 then
			cl_type = tonumber(tmp_tab[3])
		end				
		local tmp_tab = {
			["cl_id"] = cl_id,
			--["cl_name"] = hecheng_lib.CFG_ITEM_NAME[cl_id].item_name,--�������� todo	
			["cl_count"] = cl_count,
			["cl_type"]  = cl_type,	
		}
		
		table.insert(peifang_tab, tmp_tab)				
	end
	return peifang_tab
end

--����������
function hecheng_lib.send_item(user_id)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	local item_num = hecheng_lib.get_count(hecheng_lib.user_list[user_id].sp)
	netlib.send(function(buf)
		buf:writeString("HCHITEM")
		buf:writeInt(item_num)
		
		for k,v in pairs (hecheng_lib.user_list[user_id].sp) do
			buf:writeInt(v.item_id)
			buf:writeInt(v.item_count)
			
		end
	end, user_info.ip, user_info.port)
end

--��������Ϣ
function hecheng_lib.send_car_info(user_id)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	local car_num = hecheng_lib.get_count(hecheng_lib.user_list[user_id].car)
	netlib.send(function(buf)
		buf:writeString("HCHCAR")
		if  car_num > 32*8 then 
			car_num = 32*8
		end
		buf:writeInt(car_num)
		local times = 0;
		for k,v in pairs (hecheng_lib.user_list[user_id].car) do
			if times == 32*8 then
				break
			end	
			buf:writeInt(v.car_id)
			buf:writeInt(v.car_type)
			--buf:writeInt(v.hui_xin)
			--buf:writeInt(v.king_count)
			buf:writeByte(v.is_using)
			--buf:writeInt(v.cansale)
			--buf:writeInt(v.car_prize)
			local bMatch = 0;

			--��������Ѿ��������� �Ͳ����
			if car_match_lib and (car_match_lib.is_match_start(1) == 1 or 
                car_match_lib.is_match_start(2) == 1) then
				for i=1, 2 do
                    for j=1,8 do
						if car_match_lib.match_list[i].match_car_list[j].car_id ~= nil and
                            car_match_lib.match_list[i].match_car_list[j].car_id == hecheng_lib.user_list[user_id].car[v.car_id].car_id then							
							bMatch = 1
                            break
						end
                    end
                    if (bMatch == 1) then
                        break
                    end
				end
			end
			buf:writeByte(bMatch)	
			times = times + 1	
		end
	end, user_info.ip, user_info.port)
end


--��һ�����ʽ�ȥ������û����
function hecheng_lib.is_zhong(gailv)
	local gen_rand_num = function()
		local tmp_tab = {}		
		for i = 1, 50 do
			table.insert(tmp_tab, math.random(1,10000))
		end
		return tmp_tab
	end
	
	local can_num = 10000 * gailv
	local rand_num_tab = gen_rand_num()
	local rand_num = rand_num_tab[math.random(10,50)]
	
	if rand_num <= can_num then
		return 1
	end
	
	return 0
end

function hecheng_lib.hecheng_item(buf)

	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	local tz_id = buf:readInt()
	local do_hc_count = buf:readInt() --�ϳɴ���
	local need_car_number = buf:readInt() --����������Ҫ���ֳ�
	local tb_need_car_id ={}
	if need_car_number > 0 then
		for i=1, need_car_number do
			local car_id = buf:readInt()
			table.insert(tb_need_car_id,car_id)
		end
	end
	if need_car_number > 0 and do_hc_count > 1 then
		TraceError("�г�Ϊ���ϵ�����£��ϳɴ������ܴ���1")
		return
	end
	
	--����ǳ�����жϳ���Ƿ���Ժϳɵ��������ɳ�ֵ��
	if wing_lib and wing_lib.check_wing(tz_id) == 1 then
	  if do_hc_count ~= 1 then return end
	  if wing_lib.check_wing_hengcheng(user_id, tz_id) == 0 then
	    return
	  end
	end
	
	if do_hc_count <= 0 then
		return
	end
	
	if hecheng_lib.check_datetime() ~= 0 then
		eventmgr:dispatchEvent(Event("before_hecheng_event", {user_info = user_info, tz_id = tz_id, do_hc_count = do_hc_count}))
	end
	
	local send_result = function(result)
		local zj_count = 0
		if result == 1 then
			--����۲��ϳɹ��ˣ��ȼ�һ����־������������һ�κϳ�
			hecheng_db_lib.record_hecheng_log(user_id, tz_id, do_hc_count)
			--����۲��ϳɹ��ˣ��ٿ�������Ʒ�ò���
			local gailv = hecheng_lib.CFG_TZ[tz_id].gailv
	
			for i = 1, do_hc_count do
				zj_count = zj_count + hecheng_lib.is_zhong(gailv)
			end
			--��ƷҲ�ã����Է�����
			if zj_count > 0 then
				for i = 1, zj_count do
					hecheng_lib.give_hecheng_reward(user_id, tz_id)
				end
				if (tz_id >= 100109) and (tz_id <= 100112)  then
					local car_name = hecheng_lib.CFG_TZ[tz_id].hc_name
					local msg = _U("��غ�����Ǭ���跨�����")..user_info.nick.._U("�ָ��ϳɵ�").._U(car_name).._U("(")..zj_count.._U("��)").._U("���쳤Ц��")
					tex_speakerlib.send_sys_msg(msg)
				end
				--����ǲ��ӵ����� -- ������������һ��
				if tz_id == 100113 then
				  car_match_db_lib.add_car(user_id,5026,0)
				  local car_name = hecheng_lib.CFG_TZ[tz_id].hc_name
					local msg = _U("��غ�����Ǭ���跨�����")..user_info.nick.._U("�ָ��ϳɵ�").._U(car_name).._U("(")..zj_count.._U("��)").._U("���쳤Ц��ϵͳ����������������һ����")
					tex_speakerlib.send_sys_msg(msg)
				end
				--����ǻƽ�沼�ӵ�--��һ����ʱ�� �� �ƺ� ����֮��
				if tz_id == 100114 then
					car_match_db_lib.add_car(user_id,5027,0)
					local car_name = hecheng_lib.CFG_TZ[tz_id].hc_name
					local msg = _U("��غ�����Ǭ���跨�����")..user_info.nick.._U("�ָ��ϳɵ�").._U(car_name).._U("(")..zj_count.._U("��)").._U("���쳤Ц��ϵͳ�������Ͳ��ӵ�����һ����")
					tex_speakerlib.send_sys_msg(msg)
				end
				if tz_id == 100115 then
					for k,v in ipairs (hecheng_lib.CFG_ALL_CARS) do 
						  car_match_db_lib.add_car(user_id,v,0)
          end
          local car_name = hecheng_lib.CFG_TZ[tz_id].hc_name
					local msg = _U("��غ�����Ǭ���跨�����")..user_info.nick.._U("�ָ��ϳɵ�").._U(car_name).._U("(")..zj_count.._U("��)").._U("���쳤Ц��ϵͳ�������͵���ȫϵ����һ����")
					tex_speakerlib.send_sys_msg(msg)
				end
				--����־���ɹ��ϳ��˶��ٴ�
				hecheng_db_lib.record_hecheng_success_log(user_id, tz_id, zj_count)
			end
			
			--�ϳ�ʧ���˼�¼
			if do_hc_count-zj_count > 0 then
				hecheng_db_lib.record_hecheng_failed_log(user_id, tz_id, do_hc_count-zj_count)
			end
			eventmgr:dispatchEvent(Event("after_hecheng_event", {user_info = user_info, tz_id = tz_id, do_hc_count = do_hc_count, fail_hc_count = do_hc_count-zj_count}))
	
			--ˢ�±���
			--bag.get_all_item_info(user_info, function(bag_items) end, 1)
			--local propslist = tex_gamepropslib.get_props_list(user_info);
			
			
		elseif result < 0 then
			zj_count = result
		end
		netlib.send(function(buf)
			buf:writeString("HCHHC")
			buf:writeInt(zj_count)
		end, user_info.ip, user_info.port)
		
		--�ÿͻ���ˢ��һ�£��ͻ��˴������Ļ�����Щ���⣬�����ÿͻ���������£�����˲�����������
		--hecheng_lib.send_tz(user_id)
		--hecheng_lib.send_item(user_id)
	end	

	if hecheng_lib.check_datetime() == 0 then
		send_result(-1)
		return 0;
	end
	
	
	
	local need_peifang = hecheng_lib.get_need_peifang(tz_id)
	
	if hecheng_lib.user_list[user_id].tz[tz_id].status ~= nil then
		send_result(hecheng_lib.user_list[user_id].tz[tz_id].status)
		return
	end 
	
	--��һ�ºϳɴ����ǲ���������
	if hecheng_lib.user_list[user_id].tz[tz_id].today_can_use ~= nil and hecheng_lib.user_list[user_id].tz[tz_id].today_can_use <= 0 then
		send_result(0)
		return
	end 
	
	--����������ϵĲ��Ϲ�����
	local check_cl = hecheng_lib.check_peifang(user_id, need_peifang, do_hc_count)
	if check_cl == 0 then
		send_result(check_cl)
		return
	end
	
	--����������ϵ�ͼֽ�Ƿ����
	local sys_time = os.time()
	if hecheng_lib.CFG_TZ[tz_id].over_time and timelib.db_to_lua_time(hecheng_lib.CFG_TZ[tz_id].over_time) < sys_time then
				send_result(-1)
				return
	end
	
	--��������Ƿ�ﵽ��Ҫ�ϳɵ�vip�ȼ�
	if hecheng_lib.CFG_TZ[tz_id].need_vip and viplib then
	   local vip_level = viplib.get_vip_level(user_info) or 0
	   if vip_level < hecheng_lib.CFG_TZ[tz_id].need_vip then
	    return
	   end
	end
	
	--����������ϵ�ͼֽ���Ϲ�����
	if hecheng_lib.CFG_TZ[tz_id].class_id ~= 6 then
			local check_tz = hecheng_lib.check_tuzhi(user_id, tz_id, do_hc_count)
			if check_tz <= 0 then
				send_result(0)
				return
			end
	end
	--todo�����ù����������Ļ����ȿ۷��ã��ٿ۲���
	--����ͼ�յķ�����Ϣ�ͺϳɴ���������
	
	--�ȿ۲����ٺϳ�
	for k, v in pairs(need_peifang) do
		if v.cl_type == 1 then
			hecheng_lib.user_list[user_id].sp[v.cl_id].item_count = hecheng_lib.user_list[user_id].sp[v.cl_id].item_count - v.cl_count * do_hc_count
			tex_gamepropslib.set_props_count_by_id(v.cl_id,  -1*v.cl_count*do_hc_count, user_info, nil)
		else
			--ɾ����
			for _,car_id in pairs (tb_need_car_id) do
				hecheng_lib.user_list[user_id].car[car_id] = {}
				car_match_db_lib.del_car(user_id,car_id)
			end
		end
	end
	
	
	--��ͼֽ,�ڴ� �ͱ���
	--if hecheng_lib.CFG_TZ[tz_id].class_id == 4 or hecheng_lib.CFG_TZ[tz_id].class_id == 5 then
		hecheng_lib.user_list[user_id].tz[tz_id].item_count = hecheng_lib.user_list[user_id].tz[tz_id].item_count - do_hc_count
		tex_gamepropslib.set_props_count_by_id(tz_id,  -1*do_hc_count, user_info, nil)
	--end
	
	send_result(1)

	
end

--���һ�²��Ϲ�����
function hecheng_lib.check_peifang(user_id, need_peifang, do_hc_count)
	if do_hc_count == nil then do_hc_count = 1 end --Ĭ��Ϊ����ֻ�ϳ�һ������Ҫ�Ĳ��Ϲ�����
	for k, v in pairs (need_peifang) do
		if v.cl_type == 1 then
			if hecheng_lib.user_list[user_id].sp[v.cl_id] == nil then
				return 0
			end
			
			if hecheng_lib.user_list[user_id].sp[v.cl_id].item_count < v.cl_count * do_hc_count then
				return 0
			end
		elseif v.cl_type == 2 then
			--ѭ����ҳ����Ƿ��и�id�ĳ�
				 local car_number = 0
			   for index,car in pairs (hecheng_lib.user_list[user_id].car) do
			   		if car.car_type == v.cl_id then
			   			car_number = car_number + 1
			   		end
			 	 end
			 	 if car_number < v.cl_count * do_hc_count then
			 	 	return 0
			 	 end
		end
	end
	return 1
	
end

--���һ��ͼֽ������
function hecheng_lib.check_tuzhi(user_id, tz_id, do_hc_count)
	if do_hc_count == nil then do_hc_count = 1 end --Ĭ��Ϊ����ֻ�ϳ�һ������Ҫ�Ĳ��Ϲ�����
			 
		if hecheng_lib.user_list[user_id].tz[tz_id] == nil then
			return 0
		end
		
		if hecheng_lib.user_list[user_id].tz[tz_id].item_count <  do_hc_count then
			return 0
		end

	return 1
	
end

--�õ��ܺϳɶ��ٸ���Ʒ
function hecheng_lib.get_hecheng_count(user_id, tz_id)
	local last_num = -1
	local need_peifang = hecheng_lib.get_need_peifang(tz_id)

	for k, v in pairs (need_peifang) do
		--�����ٵĲ��Ͼ�������ϳ����ٵ���
		if hecheng_lib.user_list[user_id].sp[v.cl_id] == nil then
			return 0 --ȱ��ĳһ�ֲ��ϣ�ֱ����Ϊ1����Ʒ���ϲ�����
		end
	
		local tmp_num = math.floor(hecheng_lib.user_list[user_id].sp[v.cl_id].item_count/v.cl_count)
		if tmp_num < last_num or last_num == -1 then
			last_num = tmp_num
		end
	end
	return last_num
end


--�ϳɳɹ��ˣ�������
function hecheng_lib.give_hecheng_reward(user_id, tz_id)
			if (not user_id) and (not tz_id) then
				return
			end
			local user_info = usermgr.GetUserById(user_id)
			if tz_id<100000 then return end
				
			--�±�
			if tz_id >= 100020 and tz_id <= 100022 then
				
				local nItemId = hecheng_lib.CFG_TZ[tz_id].hc_id;
		
				--���ºϳ��±�(����)
				gift_addgiftitem(user_info, nItemId, user_info.userId, user_info.nick)

			end
			
			--����
			if hecheng_lib.CFG_TZ[tz_id].class_id == 5 then
				local nItemId = hecheng_lib.CFG_TZ[tz_id].hc_id;
				car_match_db_lib.add_car(user_id,nItemId,0)
				if tz_id == 100116 or tz_id == 100117 then
					parkinglib.give_free_parking(user_info)
				end
				--����������ͬʱ���Ǻϳɲ��ϣ���ˢ�ºϳ��ڴ�
				hecheng_db_lib.init_hecheng_info(user_id)
			end
			
			--�ӵ���
			if hecheng_lib.CFG_TZ[tz_id].class_id == 1 or hecheng_lib.CFG_TZ[tz_id].class_id == 6 then
				tex_gamepropslib.set_props_count_by_id(hecheng_lib.CFG_TZ[tz_id].hc_id, 1, user_info, nil)
			end
			
end

--�õ��ϳ�ͼֽ�������˶���
function hecheng_lib.get_hechengtz_use_count(user_id, tz_id)
	if not hecheng_lib.user_list[user_id].tz[tz_id] then
		return -1
	end
	
	local today_can_use = hecheng_lib.user_list[user_id].tz[tz_id].today_can_use
	if today_can_use == nil or today_can_use < 0 then
		return -1
	end
	local item_count = hecheng_lib.user_list[user_id].tz[tz_id].item_count or 0
	local already_used = item_count - today_can_use
	return already_used
end

--�õ�ͼֽÿ��ᱻ��ʼ���ɶ���
function hecheng_lib.get_hechengtz_count(tz_id)
	return hecheng_lib.CFG_HUODONG_TZ[tz_id] or -1
end

--��ʼ����ҵ�ͼֽ
function hecheng_lib.init_hechengtz(user_id, tz_id_tab, status)
	for k, v in pairs(tz_id_tab) do		
		if hecheng_lib.user_list[user_id].tz[v.tz_id] == nil then
			hecheng_lib.user_list[user_id].tz[v.tz_id] = {}
		end
		hecheng_lib.user_list[user_id].tz[v.tz_id].item_id = v.tz_id
		hecheng_lib.user_list[user_id].tz[v.tz_id].item_count = v.tz_count
		hecheng_lib.user_list[user_id].tz[v.tz_id].today_can_use = v.today_can_use
		
		if status ~= nil then
			hecheng_lib.user_list[user_id].tz[v.tz_id].status = status
		end
	end
	
end


function hecheng_lib.on_user_exit(e)
	local user_id = e.data.user_id;
    if(hecheng_lib.user_list[user_id] ~= nil) then
        hecheng_lib.user_list[user_id] = nil;
    end
end

---todo��Ҫ�Ż����ŵ�����
function hecheng_lib.timer(e)
    if (tex == nil) then return end
    local start_time  = timelib.db_to_lua_time(hecheng_lib.start_time)
    local end_time    = timelib.db_to_lua_time(hecheng_lib.end_time)
    local start_bike  = timelib.db_to_lua_time(hecheng_lib.start_bike)
    local end_bike    = timelib.db_to_lua_time(hecheng_lib.end_bike)
  
    if start_bike > e.data.time or e.data.time > end_bike then
        -- ɾ���̳�ͼֽ
        tex.cfg.giftlist[100116] = nil --���
        tex.cfg.giftlist[100117] = nil --����
        tex.cfg.giftlist[4026] = nil   --����˧��
        tex.cfg.giftlist[4027] = nil   --������Ů
    end
    if start_bike < e.data.time and e.data.time < end_bike then	
        tex.cfg.giftlist[100116] = 100 --���
        tex.cfg.giftlist[100117] = 100 --����
        tex.cfg.giftlist[4026] = 11   --����˧��
        tex.cfg.giftlist[4027] = 11   --������Ů
    end
end

function hecheng_lib.on_after_user_login(e)
	if (not e) and (not e.data.userinfo) then 
		return 0;
	end
	
	local user_info = e.data.userinfo;
	local user_id = user_info.userId;
	hecheng_db_lib.init_hecheng_info(user_id, nil)
	--��¼�͵�����
	local sys_time = os.time();	
	local start_bike  = timelib.db_to_lua_time(hecheng_lib.start_bike)
	local end_bike    = timelib.db_to_lua_time(hecheng_lib.end_bike)
	if start_bike < sys_time and sys_time < end_bike then
		local sql = "select already_give from user_guanggun_info where user_id = %d"
		sql = string.format(sql, user_id)
		dblib.execute(sql, function(dt)
			if not dt or #dt == 0 then
				--������
				if  tonumber(user_info.sex) == 1  then-- �е�
					tex_gamepropslib.set_props_count_by_id(19, 1, user_info, nil)
					tex_gamepropslib.set_props_count_by_id(20, 1, user_info, nil)
				else 
					tex_gamepropslib.set_props_count_by_id(21, 1, user_info, nil)
					tex_gamepropslib.set_props_count_by_id(22, 1, user_info, nil)
                end
                
				--д�����ݿ�
				local sql = "insert into user_guanggun_info(user_id,already_give) value(%d,1)"
				sql = string.format(sql,user_id)
				dblib.execute(sql,function(dt)end,user_id)
			end
		end, user_info.userId)
	end
end

function hecheng_lib.already_init_gift(e)
    local user_id = e.data.user_id
    local user_info = usermgr.GetUserById(user_id)
    if (user_info ~= nil) then
        local start_bike  = timelib.db_to_lua_time(hecheng_lib.start_bike)
        local end_bike    = timelib.db_to_lua_time(hecheng_lib.end_bike)
        local gift_info = user_info.gameInfo.giftinfo
        for k, v in pairs(gift_info) do
            --����˧��
            if ((v.id == 4026 or v.id == 4027) and os.time() > end_bike) then                
                gift_removegiftitem(user_info, k)
            end
        end
    end
end

function hecheng_lib.already_init_car(e)
    local user_id = e.data.user_id
    local user_info = usermgr.GetUserById(user_id)
    local sys_time = os.time()
    local end_bike    = timelib.db_to_lua_time(hecheng_lib.end_bike)
    if (user_info ~= nil and sys_time > end_bike) then
        --ȡ����ҵ����б�
        local propslist = tex_gamepropslib.get_props_list(user_info)
        for v1,_  in pairs(propslist) do
            --����й�������Ҳɾ��
            if (car_match_lib.user_list and car_match_lib.user_list[user_id] and 
                car_match_lib.user_list[user_id].car_list) then
                for k,v in pairs (car_match_lib.user_list[user_id].car_list) do
                    if v.car_type == 5044 or v.car_type == 5045 then
                        car_match_db_lib.del_car(user_id, k)
                    end
                end
            end
        end
    end
end

function hecheng_lib.already_init_prop(e)
	local user_id = e.data.user_id
	local user_info = usermgr.GetUserById(e.data.user_id)
	if not user_info then return end
    local user_id = e.data.user_id
    local user_info = usermgr.GetUserById(user_id)
    local sys_time = os.time()
    local end_bike    = timelib.db_to_lua_time(hecheng_lib.end_bike)
    if (user_info ~= nil and sys_time > end_bike) then
        --ȡ����ҵ����б�
        local propslist = tex_gamepropslib.get_props_list(user_info)
        for v1,_  in pairs(propslist) do
            --����Ǻϳɵ����� ɾ��
            if (v1 == 19 or v1 == 20 or v1 == 21 or v1 == 22) then
                --�������ݿ�
                local get_count_daoju = function(nCount)
                    tex_gamepropslib.set_props_count_by_id(v1, -nCount, user_info, nil)
                end
                tex_gamepropslib.get_props_count_by_id(v1, user_info, get_count_daoju)
            end            
        end
    end	   
    hecheng_db_lib.init_user(user_id)
end


function hecheng_lib.send_tz_to_client(user_info, tb_tz_id)
  local sys_time = os.time()
  local user_id = user_info.userId
    netlib.send(function(buf)
  		buf:writeString("HCHTZ")
  		buf:writeInt(#tb_tz_id)
     for k,tz_id in ipairs (tb_tz_id) do
	    local class_id = hecheng_lib.CFG_TZ[tz_id].class_id
			buf:writeByte(class_id)--����ID
			buf:writeString(_U(hecheng_lib.CFG_TZ_CLASS[class_id]))--��������
			buf:writeInt(tz_id) --ͼֽID
			local hc_tz_use_count = hecheng_lib.get_hechengtz_use_count(user_id, tz_id)
			buf:writeInt(hc_tz_use_count) --�����Ѻϳ���Ʒ������
			local hc_tz_count = 0
			if hecheng_lib.user_list[user_id].tz[tz_id] and hecheng_lib.user_list[user_id].tz[tz_id].item_count then
				hc_tz_count = hecheng_lib.user_list[user_id].tz[tz_id].item_count
			end
			buf:writeInt(hc_tz_count) --�ɺϳɶ��ٸ���Ʒ������
			local hc_count = hecheng_lib.get_hecheng_count(user_id, tz_id)
			buf:writeInt(hc_count) --�ɺϳɶ��ٸ���Ʒ�������������ϼ��㣩
			local tuzhi_count = hecheng_lib.get_tuzhi_count(user_id, tz_id, class_id)
			if hecheng_lib.CFG_TZ[tz_id].over_time and timelib.db_to_lua_time(hecheng_lib.CFG_TZ[tz_id].over_time) < sys_time then
				tuzhi_count = -1
			end
			buf:writeInt(tuzhi_count) --ͼֽ��������еĻ�,��ͼֽ�಻�ô˲���
			buf:writeString(_U(hecheng_lib.CFG_TZ[tz_id].tz_name)) --ͼֽ����
			buf:writeString(_U(hecheng_lib.CFG_TZ[tz_id].tz_desc)) --ͼֽ����
			buf:writeInt(hecheng_lib.CFG_TZ[tz_id].hc_id) --�ϳ���ƷID
			buf:writeString(_U(hecheng_lib.CFG_TZ[tz_id].hc_name)) --�ϳ���Ʒ����
			buf:writeString(_U(hecheng_lib.CFG_TZ[tz_id].hc_desc)) --�ϳ���Ʒ����
			buf:writeString(_U(hecheng_lib.CFG_TZ[tz_id].hc_fy_desc)) --�ϳ���Ʒ��������
			if hecheng_lib.CFG_TZ[tz_id].gailv_false then
				buf:writeString(hecheng_lib.CFG_TZ[tz_id].gailv_false) --�ٺϳɸ���
			else
				buf:writeString(hecheng_lib.CFG_TZ[tz_id].gailv) --��ϳɸ���
			end
			local peifang_tab = hecheng_lib.get_need_peifang(tz_id)
			buf:writeInt(#peifang_tab) --�ϳ��䷽����len
			for i = 1, #peifang_tab do
				buf:writeInt(peifang_tab[i].cl_id) --����ID	
				--buf:writeString(peifang_tab[i].cl_name) --��������	
				buf:writeInt(peifang_tab[i].cl_count) --��������
				buf:writeInt(peifang_tab[i].cl_type) --��������				
			end
			buf:writeInt(hecheng_lib.CFG_TZ[tz_id].need_chengzhang or 0)--�ɳ�ֵ
			buf:writeInt(hecheng_lib.CFG_TZ[tz_id].need_vip or 0)--VIP�ȼ�
			local fy_len = #hecheng_lib.CFG_TZ[tz_id].hc_fy
			if fy_len == 1 and hecheng_lib.CFG_TZ[tz_id].hc_fy[1].hc_fy_type == 0 then
				buf:writeInt(0)
			else
				buf:writeInt(fy_len)
				for i = 1, fy_len do
					buf:writeInt(hecheng_lib.CFG_TZ[tz_id].hc_fy[i].hc_fy_type)
					buf:writeInt(hecheng_lib.CFG_TZ[tz_id].hc_fy[i].fy)
				end
			end
		 end
		end, user_info.ip, user_info.port)
end
--�����б�
cmdHandler = 
{
    ["HCHACTIVE"] = hecheng_lib.check_status, --��ѯ��Ƿ������
    ["HCHOPEN"]   = hecheng_lib.open_panl,    --�������
    ["HCHTZ"]     = hecheng_lib.query_tz,     --�ͻ��ˣ�����ͼֽ��Ϣ
	  ["HCHITEM"]   = hecheng_lib.query_item,   --���ر�������
	  ["HCHCAR"]    = hecheng_lib.query_car,     --��������
	  ["HCHHC"]     = hecheng_lib.hecheng_item, -- �ͻ�������ϳ�
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("on_user_exit", hecheng_lib.on_user_exit);

eventmgr:addEventListener("timer_second", hecheng_lib.timer); 
---todo��Ҫ�Ż����ŵ�����
eventmgr:addEventListener("h2_on_user_login", hecheng_lib.on_after_user_login);
eventmgr:addEventListener("after_get_props_list", hecheng_lib.already_init_prop)
eventmgr:addEventListener("already_init_gift", hecheng_lib.already_init_gift)
eventmgr:addEventListener("already_init_car", hecheng_lib.already_init_car)

