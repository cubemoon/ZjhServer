TraceError("init zhongqiu_lib...")
if zhongqiu_lib and zhongqiu_lib.ongameover then 
	eventmgr:removeEventListener("on_game_over_event", zhongqiu_lib.ongameover);
end

if zhongqiu_lib and zhongqiu_lib.restart_server then
	eventmgr:removeEventListener("on_server_start", zhongqiu_lib.restart_server);
end

if zhongqiu_lib and zhongqiu_lib.timer then
	eventmgr:removeEventListener("timer_second", zhongqiu_lib.timer);
end

if zhongqiu_lib and zhongqiu_lib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", zhongqiu_lib.on_user_exit);
end

if zhongqiu_lib and zhongqiu_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", zhongqiu_lib.on_after_user_login);
end


if not zhongqiu_lib then
    zhongqiu_lib = _S
    {
    	--�����Ƿ���
  		ongameover = NULL_FUNC,
  		restart_server = NULL_FUNC,
  		timer = NULL_FUNC,
  		on_user_exit = NULL_FUNC,
  		on_after_user_login = NULL_FUNC,
        
      --�����Ǳ�����������Ϣ
			user_list = {},
			--flag_count = 0, --�Ѳ�������
			--notify_flag = 0,
			
			CFG_ROOM_BET = {
			[1] = 10, 
			[2] = 100, --С��100��ҵ��
			[3] = 1000, --С��1000��ְҵ,���ڵ���1000��ר��
			},
			start_time          = "2012-09-27 09:00:01",
			end_zhongqiu_time   = "2012-10-01 00:00:01",
			--qiche_tuzhi_time    = "2012-10-01 09:00:00",
			yuebing_tuzhi_time 	= "2012-10-06 23:59:59",
			end_guoqing_time 	  = "2012-10-07 23:59:59",
			end_qichetuzhi_time = "2012-10-30 23:59:59",
			end_suipian_time    = "2012-10-31 23:59:59",
			
			CQ_PM_LEN  = 10,
			cq_pm_list = {},
			
			
			CFG_PANSHU = 20,  --��Ҫ����
			
			--����
			CFG_GIVE_NAME = {
			[1] = "����A", 
			[2] = "÷��A", 
			[3] = "����A", 
			[4] = "����A",
			[5] = "ˮ���˿�",
			[6] = "�ƽ��˿�",
			},
			
			--����
			CFG_GIVE_ITEMID = {
			[1] = 5001, 
			[2] = 5014, 
			[3] = 5027, 
			[4] = 5040,
			[5] = 5055,
			[6] = 5056,
			
			},
			
			--������ͭ������10�֣���Ƭ������ʣ�1�Ƿ�ƬA��2��÷��A��3�Ǻ���A, 4�Ǻ���A ,5��ˮ���˿�, 6�ǻƽ��˿�
			--��ظ���
			GFG_PORBABILITY_LIST = {
			[1] = {
						[1] = 800;
						[2] = 150;
						[3] = 40;
						[4] = 10;
						},
			[2] = {
						[1] = 650;
						[2] = 130;
						[3] = 150;
						[4] = 50;
						[5] = 20;
						},
			[3] = {	
						[1] = 440;
						[2] = 200;
						[3] = 220;
						[4] = 89;
						[5] = 50;
						[6] = 1;
						}
			},
			--�����±�ͼֽ
			GFG_TUZHI_LIST1 = {
			[1] = 100020;
			[2] = 100021;
			[3] = 100022;
--			[4] = 100023;
--			[5] = 100024;
			},
			
			--��������ͼֽ
			GFG_TUZHI_LIST2 = {
			[1] = 100100;
			[2] = 100101;
			[3] = 100102;
			[4] = 100103;
			[5] = 100104;
			[6] = 100105;
			[7] = 100106;
			},
			GFG_TUZHI_NAME = {
			[100020] = "����ף��ͼֽ";
			[100021] = "����ף��ͼֽ";
			[100022] = "����ף��ͼֽ";
			[100100] = "����ͼֽ";
			[100101] = "ѩ����C2ͼֽ";
			[100102] = "�׿ǳ�ͼֽ";
			[100103] = "��ɯ����ͼֽ";
			[100104] = "������ͼֽ";
			[100105] = "��ʱ��ͼֽ";
			[100106] = "��������ͼֽ";
			
			},
			GFG_BOX_ID = {
				14,15,16,17,18
			},
			
			--������ʣ�13��ľ�����ID
			GUOQING_PORBABILITY_LIST={
				[14] = {1000};
				[15] = {1000};
				[16] = {500,250,250};
				[17] = {500,250,250};
				[18] = {500,250,250};
			},
			
			
			--���ñ��佱���б� ��ʽ����Ʒid,������13��ľ�����ID
			GUOQING_REWARD_LIST = {
			[14] = {
						[1] = {
										{100100,1,"����ͼֽ"};
										{5055,1,"ˮ���˿�"};
									};
						};
			[15] = {
						[1] = {
										{100101,1,"ѩ����C2ͼֽ"};
										{5055,2,"ˮ���˿�"};
									};
						};
			[16] = {
						[1] = {
										{100102,1,"�׿ǳ�ͼֽ"};
										{5055,4,"ˮ���˿�"};
									};
						[2] = {
										{100102,1,"�׿ǳ�ͼֽ"};
										{5055,4,"ˮ���˿�"};
									};
						[3] = {
										{100102,1,"�׿ǳ�ͼֽ"};
										{5055,5,"ˮ���˿�"};
									};
						};
			[17] = {
						[1] = {
										{100103,1,"��ɯ����ͼֽ"};
										{5055,10,"ˮ���˿�"};
									};
						[2] = {
										{100104,1,"������ͼֽ"};
										{5055,11,"ˮ���˿�"};
									};
						[3] = {
										{100105,1,"��ʱ��ͼֽ"};
										{5055,12,"ˮ���˿�"};
									};
						};
			[18] = {
						[1] = {
										{100104,1,"������ͼֽ"};
										{5056,2,"�ƽ��˿�"};
									};
						[2] = {
										{100106,1,"��������ͼֽ"};
										{5056,3,"�ƽ��˿�"};
									};
						[3] = {
										{100105,1,"��ʱ��ͼֽ"};
										{5056,4,"�ƽ��˿�"};
									};
						};
			},
    }
end 

	

--1 ҵ�� 2ְҵ 3ר��
function zhongqiu_lib.get_room_type(small_bet)
	if not small_bet then
		return 0;
	end
	
	if small_bet < zhongqiu_lib.CFG_ROOM_BET[1] then
		return -1;
	elseif small_bet < zhongqiu_lib.CFG_ROOM_BET[2] then
		return 1;
	elseif small_bet < zhongqiu_lib.CFG_ROOM_BET[3] then
		return 2;
	elseif small_bet >= zhongqiu_lib.CFG_ROOM_BET[3] then
		return 3;
	end

end 


--���������̳������б�
function zhongqiu_librestart_server(e)
	gift_list_info[100020] = 500000 --�ƽ��±�ͼֽ
	gift_list_info[100021] = 100000 --�����±�ͼֽ
	gift_list_info[100022] = 10000  --��ͭ�±�ͼֽ
	gift_list_info[100100] = 1000	   --����ͼֽ
	gift_list_info[100101] = 5000	   --ѩ����C2ͼֽ
	gift_list_info[100102] = 30000	   --�׿ǳ�ͼֽ
	gift_list_info[100103] = 250000	 --��ɯ����ͼֽ
	gift_list_info[100104] = 600000	 --������ͼֽ
	gift_list_info[100105] = 1000000	 --��ʱ��ͼֽ
	gift_list_info[100106] = 1500000  --��������ͼֽ
	
end
function zhongqiu_lib.on_after_user_login(e)
	if (not e) and (not e.data.userinfo) then 
		return 0;
	end
	
	local user_info = e.data.userinfo;
	local user_id = user_info.userId;
	
	--�����ݿ��г�ʼ���û��ڸ������е�����
	zhongqiu_db_lib.init_user(user_id);
	
	--�����ݿ��ж�ȡ����ͼֽ��Ϣ���ж�ͼֽ�Ƿ����
	timelib.createplan(function()
			zhongqiu_db_lib.init_user_tuzhi(user_id)
		end,6)
	

end

function zhongqiu_lib.timer(e)
	local start_time         = timelib.db_to_lua_time(zhongqiu_lib.start_time)
	local end_zhongqiu_time  = timelib.db_to_lua_time(zhongqiu_lib.end_zhongqiu_time);
	local yuebing_tuzhi_time = timelib.db_to_lua_time(zhongqiu_lib.yuebing_tuzhi_time)
	local end_guoqing_time   = timelib.db_to_lua_time(zhongqiu_lib.end_guoqing_time)
	local end_qichetuzhi_time   = timelib.db_to_lua_time(zhongqiu_lib.end_qichetuzhi_time)
	
	if start_time < e.data.time and e.data.time < end_zhongqiu_time then
		--��������ͼֽ ɾ���±�ͼֽ
		gift_list_info[100020] = {price = 500000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}--�ƽ��±�ͼֽ
		gift_list_info[100021] = {price = 100000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}  --�����±�ͼֽ
		gift_list_info[100022] = {price = 10000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}   --��ͭ�±�ͼ
	end
	
	
	if end_zhongqiu_time < e.data.time and e.data.time < yuebing_tuzhi_time then
	  --��������ͼֽ ɾ���±�ͼֽ
		gift_list_info[100100] ={price = 1000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}  --����ͼֽ
		gift_list_info[100101] ={price = 5000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}  	   --ѩ����C2ͼֽ
		gift_list_info[100102] ={price = 30000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}    --�׿ǳ�ͼֽ
		gift_list_info[100103] ={price = 250000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}  	 --��ɯ����ͼֽ
		gift_list_info[100104] ={price = 600000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} 	 --������ͼֽ
		gift_list_info[100105] = {price = 1000000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}  --��ʱ��ͼֽ
		gift_list_info[100106] = {price = 1500000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}  --��������ͼֽ
		
		gift_list_info[100020] ={price = 500000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}   --�ƽ��±�ͼֽ
		gift_list_info[100021] ={price = 100000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}   --�����±�ͼֽ
		gift_list_info[100022] ={price = 10000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0}    --��ͭ�±�ͼ
	end
	
	if yuebing_tuzhi_time < e.data.time and e.data.time then
		--��������ͼֽ ɾ���±�ͼֽ
         --����ף��
		gift_list_info[100100] = {price = 1000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} 	   --����ͼֽ
		gift_list_info[100101] = {price = 5000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} 	   --ѩ����C2ͼֽ
		gift_list_info[100102] = {price = 30000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} 	 --�׿ǳ�ͼֽ
		gift_list_info[100103] =  {price = 250000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} 	 --��ɯ����ͼֽ
		gift_list_info[100104] = {price = 600000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} 	 --������ͼֽ
		gift_list_info[100105] = {price = 1000000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} --��ʱ��ͼֽ
		gift_list_info[100106] =  {price = 1500000, everyday_num = 2, valid_time = "", can_sale = 0, is_car = 0} --��������ͼֽ
		
		gift_list_info[100020] = nil --�ƽ��±�ͼֽ
		gift_list_info[100021] = nil --�����±�ͼֽ
		gift_list_info[100022] = nil --��ͭ�±�ͼ	
	end
	
	if end_qichetuzhi_time < e.data.time  then
		--��������ͼֽ ɾ���±�ͼֽ
		gift_list_info[100100] = nil	   --����ͼֽ
		gift_list_info[100101] = nil	   --ѩ����C2ͼֽ
		gift_list_info[100102] = nil	   --�׿ǳ�ͼֽ
		gift_list_info[100103] = nil	 --��ɯ����ͼֽ
		gift_list_info[100104] = nil	 --������ͼֽ
		gift_list_info[100105] = nil	 --��ʱ��ͼֽ
		gift_list_info[100106] = nil	 --��������ͼֽ
		
		gift_list_info[100020] = nil --�ƽ��±�ͼֽ
		gift_list_info[100021] = nil --�����±�ͼֽ
		gift_list_info[100022] = nil  --��ͭ�±�ͼ	
	end

end
--�̳ǹ�����ã��ж��ǲ��������±�ͼֽ
function zhongqiu_lib.is_in_zhongqiu_tuzhi(user_info, to_user_info, giftid, gift_num)
	if (not user_info) or (not to_user_info) or (not giftid) then
		return 0;
	end
	
	local temp_list = {};
	for _, item in ipairs(zhongqiu_lib.GFG_TUZHI_LIST1) do
		temp_list[#temp_list + 1] = item;
	end
	for _, item in ipairs(zhongqiu_lib.GFG_TUZHI_LIST2) do
		temp_list[#temp_list + 1] = item;
	end
	
	for _,v in ipairs(temp_list) do
		if giftid == v then
			--���ӱ������ͼֽ
			zhongqiu_lib.give_item(to_user_info, giftid, gift_num);
			--zhongqiu_lib.send_get_tuzhi(user_info, to_user_info, giftid, zhongqiu_lib.GFG_TUZHI_NAME[giftid]);
			
			--���ºϳ������ڴ�

			--��¼����ͼֽlog
			zhongqiu_db_lib.record_zhongqiu_transaction(user_info,giftid,1);
			return 1;
		end
	end
	
	return 0;
	
end

function zhongqiu_lib.on_user_exit(e)
	if (not e) and (not e.data.userinfo) then 
		return 0;
	end
	local user_id = e.data.user_id

	if zhongqiu_lib.user_list[user_id] ~= nil then
		zhongqiu_db_lib.save_user_info(user_id)
		zhongqiu_lib.user_list[user_id] = nil
	end
end

function zhongqiu_lib.ongameover(e)
	if (not e) and (not e.data.userinfo) then 
		return 0;
	end
	
	--�ʱ���ж�
	if zhongqiu_lib.check_time() == 0 then
		 return 0; 
	end
	local user_info = e.data.user_info;
	local user_id   = user_info.userId;
	local deskno    = user_info.desk;
	local deskinfo  = desklist[deskno];
	local room_type = zhongqiu_lib.get_room_type(deskinfo.smallbet)
	if room_type > 0 then
		zhongqiu_lib.user_list[user_id].play_count[room_type] = zhongqiu_lib.user_list[user_id].play_count[room_type] + 1;
		if zhongqiu_lib.user_list[user_id].play_count[room_type] % zhongqiu_lib.CFG_PANSHU == 0 then
				--�������
				local find = 0;
				local add = 0;
				local rand = math.random(1, 1000);
				for i = 1, #zhongqiu_lib.GFG_PORBABILITY_LIST[room_type] do
						add = add + zhongqiu_lib.GFG_PORBABILITY_LIST[room_type][i];
					if add >= rand then
						find = i;
						break;
					end
				end
				if find ~= 0 then
					zhongqiu_lib.give_item(user_info, zhongqiu_lib.CFG_GIVE_ITEMID[find])
					zhongqiu_lib.send_get_item(user_info, zhongqiu_lib.CFG_GIVE_ITEMID[find], zhongqiu_lib.CFG_GIVE_NAME[find])
					--��¼��Ƭ����log
					zhongqiu_db_lib.record_zhongqiu_transaction(user_info,zhongqiu_lib.CFG_GIVE_ITEMID[find],2);
				end
		end
		
		zhongqiu_lib.send_panshu(user_info)
	end
end

--������
function zhongqiu_lib.give_item(user_info, nItemId, item_num)
	if (not user_info) and (not nItemId) then
			return 0;
	end
	--���ñ����ӿ�
	tex_gamepropslib.set_props_count_by_id(nItemId, item_num or 1, user_info, nil) 
end

--֪ͨ�ͻ��˸�����
function zhongqiu_lib.send_get_item(user_info, nItemId, szItemName)
	if user_info == nil then return end

	netlib.send(function(buf)
		buf:writeString("ZQGVITEM")
		buf:writeInt(nItemId)
		buf:writeString(_U(szItemName))
	end, user_info.ip, user_info.port)
end

--֪ͨ�ͻ��˸����̳ǹ�����ͼֽ
--function zhongqiu_lib.send_get_tuzhi(user_info, to_user_info, nItemId, szItemName)
--	if user_info == nil then return end
--	if to_user_info == nil then return end
--	local user_id = user_info.userId
--	local to_user_id = to_user_info.userId
--
--	
--	netlib.send(function(buf)
--		buf:writeString("ZQGVTUZHI")
--		buf:writeInt(user_id)
--		buf:writeString(user_info.nick)
--		buf:writeInt(to_user_id)
--		buf:writeString(to_user_info.nick)
--		buf:writeInt(nItemId)
--		buf:writeString(_U(szItemName))
--	end, user_info.ip, user_info.port)
--	if user_id ~= to_user_id then
--		netlib.send(function(buf)
--		buf:writeString("ZQGVTUZHI")
--		buf:writeInt(user_id)
--		buf:writeString(user_info.nick)
--		buf:writeInt(to_user_id)
--		buf:writeString(to_user_info.nick)
--		buf:writeInt(nItemId)
--		buf:writeString(_U(szItemName))
--		end, to_user_info.ip, to_user_info.port)
--	end
--	
--end

--֪ͨ�ͻ��˸�������
function zhongqiu_lib.send_panshu(user_info)
	if user_info == nil then return end
	local user_id = user_info.userId
	netlib.send(function(buf)
		buf:writeString("ZQPANSHU")
		buf:writeInt(user_id)
		buf:writeInt(zhongqiu_lib.user_list[user_id].play_count[1])
		buf:writeInt(zhongqiu_lib.user_list[user_id].play_count[2])
		buf:writeInt(zhongqiu_lib.user_list[user_id].play_count[3])
	end, user_info.ip, user_info.port)
end

--�ͻ��������Ƿ���Ч
function zhongqiu_lib.huodong_status(buf)
	if not buf then return end
	if tonumber(groupinfo.groupid) ~= 18001 then return end
	local status = zhongqiu_lib.check_time()
	netlib.send(function(buf)
		buf:writeString("ZQSTATU")
		buf:writeByte(status)
	end, buf:ip(), buf:port()) 	 	 	 	
end


--�ͻ�������򿪱���
function zhongqiu_lib.open_pay_box(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local item_id = buf:readInt()
	if item_id < 14 or item_id > 18 then
		TraceError("�ͻ��˴����ı���ID���󣬲���14��18֮��")
		return
	end
	
	local status = zhongqiu_lib.check_time()
	if status ~= 2 then
		netlib.send(function(buf)
					buf:writeString("ZQOPENBOX")
					buf:writeInt(0)
				end, buf:ip(), buf:port())
		return
	end
	if tonumber(groupinfo.groupid) ~= 18001 then return end
	--���ñ����ӿڲ��ұ��䣬�б���Ļ��ͱ�������-1
	local set_count_box = function(nCount)
		if nCount >= 1 then
			
				--�������
				local call_back = function ()
					--�������ݿ����
					if zhongqiu_lib.user_list[user_info.userId] then
						 zhongqiu_lib.user_list[user_info.userId].update_db = 0 
					end
						local find = 0;
						local add = 0;
						local rand = math.random(1, 1000);
						for i = 1, #zhongqiu_lib.GUOQING_PORBABILITY_LIST[item_id] do
									add = add + zhongqiu_lib.GUOQING_PORBABILITY_LIST[item_id][i];
									if add >= rand then
											find = i;
										break;
									end
						end
					--���ñ����ӿڸ����ߣ����Ϳͻ���Э��
						netlib.send(function(buf)
							buf:writeString("ZQOPENBOX")
							buf:writeInt(#zhongqiu_lib.GUOQING_REWARD_LIST[item_id][find])
							for i = 1,#zhongqiu_lib.GUOQING_REWARD_LIST[item_id][find] do
									local reward_id        = zhongqiu_lib.GUOQING_REWARD_LIST[item_id][find][i][1]
									local reward_number    = zhongqiu_lib.GUOQING_REWARD_LIST[item_id][find][i][2]
									local reward_name      = zhongqiu_lib.GUOQING_REWARD_LIST[item_id][find][i][3]	
									tex_gamepropslib.set_props_count_by_id(reward_id, reward_number, user_info, nil)
									buf:writeInt(reward_id)
									buf:writeInt(reward_number)
									buf:writeString(_U(reward_name))
							end		
						end, user_info.ip, user_info.port)
				end
				tex_gamepropslib.set_props_count_by_id(item_id, -1, user_info, call_back)
		else
				netlib.send(function(buf)
					buf:writeString("ZQOPENBOX")
					buf:writeInt(0)
				end, buf:ip(), buf:port())
				return
		end
	end
	
	--������ݿ������򷵻�
	if zhongqiu_lib.user_list[user_info.userId] and zhongqiu_lib.user_list[user_info.userId].update_db == 1 then
		 return
	end
	--�������ݿ�
	zhongqiu_lib.user_list[user_info.userId].update_db = 1 
	tex_gamepropslib.get_props_count_by_id(item_id, user_info, set_count_box)	
	
	
		
end

function zhongqiu_lib.check_time()
	local status = 1

	local sys_time = os.time()
	
	--�ʱ��
	local start_time = timelib.db_to_lua_time(zhongqiu_lib.start_time);
	local end_zhongqiu_time = timelib.db_to_lua_time(zhongqiu_lib.end_zhongqiu_time);
	local end_guoqing_time = timelib.db_to_lua_time(zhongqiu_lib.end_guoqing_time);
	local end_suipian_time = timelib.db_to_lua_time(zhongqiu_lib.end_suipian_time);
	if(sys_time < start_time or sys_time > end_suipian_time) then
	    status = 0
	end
	if(sys_time > end_zhongqiu_time and sys_time < end_guoqing_time) then
		  status = 2
	end
	if(sys_time > end_guoqing_time and sys_time < end_suipian_time) then
		  status = 3
	end
	return status;
end


--�����б�
cmdHandler = 
{
    ["ZQSTATU"]  = zhongqiu_lib.huodong_status, --��ѯ��Ƿ������
		--["ZQGVITEM"] = zhongqiu_lib.send_get_item,  --������
		--["ZQPANSHU"] = zhongqiu_lib.send_panshu,    --��������
    --["DYDOPPL"] = dyd_lib.open_pl, -- �����
    ["ZQOPENBOX"] = zhongqiu_lib.open_pay_box,  --����򿪳�ֵ����

}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end


eventmgr:addEventListener("timer_second", zhongqiu_lib.timer); 
eventmgr:addEventListener("on_game_over_event", zhongqiu_lib.ongameover); 
eventmgr:addEventListener("on_server_start", zhongqiu_lib.restart_server); 
eventmgr:addEventListener("on_user_exit", zhongqiu_lib.on_user_exit); 
eventmgr:addEventListener("h2_on_user_login", zhongqiu_lib.on_after_user_login); 
