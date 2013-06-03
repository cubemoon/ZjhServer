-------------------------------------------------------
-- �ļ�������yuandan_lib.lua
-- �����ߡ���lgy
-- ����ʱ�䣺2012-11-12 15��00��00
-- �ļ������������䣬�Ż�ȯ���11��15��
-------------------------------------------------------


TraceError("init yuandan_lib...")

if yuandan_lib and yuandan_lib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", yuandan_lib.on_user_exit)
end

function yuandan_lib.on_recv_huodong_status(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local status = yuandan_lib.check_datetime()
   	netlib.send(function(buf)
            buf:writeString("YDACTIVE");
            buf:writeInt(status or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
	end,user_info.ip,user_info.port);
end


--�����Чʱ�䣬��ʱ����int	0�����Ч�������Ҳ�ɲ�������1�����Ч, 2���ڻ��, 3�����˽�
function yuandan_lib.check_datetime()
	local sys_time = os.time();	
	local startime = timelib.db_to_lua_time(yuandan_lib.startime);
	local endtime = timelib.db_to_lua_time(yuandan_lib.endtime);
	if(sys_time > endtime or sys_time < startime) then
		return 0;
	end
	
	return 1

end


--�����������
function yuandan_lib.on_user_exit(e)
	local user_id = e.data.user_id;
	if yuandan_lib.user_list[user_id] == nil then return end	
	yuandan_lib.user_list[user_id] = nil
end

function yuandan_lib.on_recv_open_panel(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	local ask_tab = buf:readByte()
	if ask_tab > 2 or ask_tab < 1 then return end
	if yuandan_lib.user_list[user_id]==nil then return end
    --��¼��������ң���ʹˢ�����а��ʱ���õ�
    yuandan_lib.user_list[user_id].open_panel = 1 
    --���͵�ǰ���״̬
    yuandan_lib.seng_user_gameinfo(user_info, ask_tab)
    --���Ͷһ���ʷ
    yuandan_lib.send_user_history(user_info)
end


function yuandan_lib.on_recv_ask_gametab(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	if yuandan_lib.user_list[user_id]==nil then return end
	local ask_tab = buf:readByte()
	if ask_tab > 3 or ask_tab < 1 then return end
	--���͵�ǰ���״̬
  yuandan_lib.seng_user_gameinfo(user_info, ask_tab)
end

function yuandan_lib.on_recv_close_panel(buf)
    if yuandan_lib.check_datetime() == 0 then return end
    local user_info = userlist[getuserid(buf)]
    if user_info == nil then return end
    local user_id = user_info.userId
    if yuandan_lib.user_list[user_id] == nil then return end
    --��¼�ر�������ң���ʹˢ�����а��ʱ���õ�
    yuandan_lib.user_list[user_id].open_panel = nil 
end

--���ض�Ӧ��ҵ���Ϸ״̬
function yuandan_lib.seng_user_gameinfo(user_info, ask_tab)
	local user_id = user_info.userId
	if not user_id then return end
	if yuandan_lib.user_list[user_id]==nil then return end
  local n_step  = yuandan_lib.user_list[user_id].now_step[ask_tab] or 1
  local n_state = yuandan_lib.user_list[user_id].now_state[ask_tab] or 1
  local n_card_num = 0
  
  if n_step <= 10 then
  	n_card_num = #yuandan_lib.POKER_ID[ask_tab][n_step]
  else 
  	n_card_num = #yuandan_lib.POKER_ID[ask_tab][10] 
  end
  
	netlib.send(function(buf)
	    buf:writeString("YDGAMEINFO")
	    buf:writeInt(n_step)
	    buf:writeByte(n_card_num + 1)
      buf:writeByte(n_state)
      buf:writeInt(yuandan_lib.CFG_DOZENCOIN_REWARD[ask_tab]*(2^n_step))
  end,user_info.ip,user_info.port)
end

--��ȯ����
function yuandan_lib.on_recv_check_poker(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then  return  end
	local user_id = user_info.userId
	if not yuandan_lib.user_list[user_id] then  return  end
	local duihuan_type = buf:readByte() --1��2��3��ӦԲԲ��������
	local use_type = buf:readByte() --1�Ǵ��˱� 2�ǽ��
	if duihuan_type > 3 or duihuan_type < 1 then return  end
	if use_type > 2 or use_type < 1 then TraceError("�����use_type")return  end
	local n_step  = yuandan_lib.user_list[user_id].now_step[duihuan_type]
  local n_state = yuandan_lib.user_list[user_id].now_state[duihuan_type]
  if n_state ~= 1 then  
  	TraceError("���"..user_id.."���ٿ��Է��Ƶ�״̬")
  	return
  end
  local send_result = function(result, n_money, card_num, tb_reward, luck_quan, quan_type)
  	local qingrenjie = yuandan_lib.check_datetime()
		netlib.send(function(buf)
		    buf:writeString("YDCHECKPOKER")
	    	buf:writeInt(result)
	    	buf:writeInt(n_money or 0)
	    	buf:writeInt(card_num or 0)
	    	if card_num and card_num > 0 then
		    	for i=1, card_num  do 
						buf:writeByte(tb_reward[i][1] or 0) --type��Ʒ���� ��1,Ԫ��ף����2���˱ҷ�������3������
						buf:writeInt(tb_reward[i][2] or 0)  --car_id 
				  end
				end
				buf:writeByte(qingrenjie)--�Ƿ�Ϊ���˽�
			  buf:writeByte(luck_quan or 0) --�н���� 0û�н� 1�н� ����ȯ��
			  buf:writeByte(quan_type or 0) --type��Ʒ���� ��1-8���Ż�ȯ��
    end,user_info.ip,user_info.port)   
	end
	
	--��������
	if (yuandan_lib.check_datetime() ~= 1) and (yuandan_lib.check_datetime() ~= 3) then 
		send_result(-4) 
		return  
	end
	
  local result = 1
  if n_step == 1 then
   		result = yuandan_lib.start_game(user_info, user_id, use_type, duihuan_type)
  end
  
  --���������ԭ�򣬴��˱Ҳ��㣬��Ҳ��㣬����
  if result ~= 1 then
  	send_result(result)
  	return
  end
  --��ʼ�������
  local card_num,tb_reward,luck_quan,quan_type = yuandan_lib.give_reward(user_id, n_step, duihuan_type)	
	send_result(1,yuandan_lib.CFG_DOZENCOIN_REWARD[duihuan_type]*(2^n_step),card_num,tb_reward,luck_quan,quan_type)
	yuandan_lib_db.log_yuandan_play_card(user_id, duihuan_type, n_step, tb_reward[1][1])
end
--�������
function yuandan_lib.give_reward(user_id, n_step, duihuan_type)
	local user_info = usermgr.GetUserById(user_id)
	if not user_info then return end
	if n_step > 8 then n_step = 8 end
	local card_num, luck_card, find_reward, car_id, luck_quan, quan_type
	card_num = #yuandan_lib.POKER_ID[duihuan_type][n_step]
	local t = os.time() + math.random(0, 10000000)
	math.randomseed(t)
	local tb_reward = {}
	for i=1, card_num do
		if yuandan_lib.POKER_ID[duihuan_type][n_step][i] == 1 then
				table.insert(tb_reward,{2,0})
		else
				table.insert(tb_reward,{3,yuandan_lib.POKER_ID[duihuan_type][n_step][i]})
		end
	end
	--�ټ�һ��û�е�
		table.insert(tb_reward,{1,0})
		card_num = card_num + 1
	--�����������
	for i=1,card_num do
		local rand_num = math.random(1, card_num +1 -i)
		local ntemp         = tb_reward[rand_num]
	  tb_reward[rand_num] = tb_reward[card_num +1 -i]
	  tb_reward[card_num +1 -i]  = ntemp
	end
	
	
	--�����Ƭ����
	local find = 0;
	local add = 0;
	local rand = math.random(1, 10000);
	for i = 1, #yuandan_lib.POKER_PORBABILITY_LIST[duihuan_type][n_step] do
				add = add + yuandan_lib.POKER_PORBABILITY_LIST[duihuan_type][n_step][i];
				if add >= rand then
						find = i;
					break;
				end
	end
	if find == 0 then
		--���û�����ף���ŵ�tb_reward�ĵ�һλ����
		for i=1,card_num do
			if tb_reward[i][1] == 1 then
				local ntemp  = tb_reward[1]
			  tb_reward[1] = tb_reward[i]
			  tb_reward[i] = ntemp
			end
		end
		--������Ϸ״̬
		yuandan_lib.restart_game(user_id, duihuan_type)
	end
	
	--����н���
	local type_id          = 0
	local item_gift_id     = 0
	local item_number      = 0
	if find > 0 then
		find_reward          = yuandan_lib.POKER_ID[duihuan_type][n_step][find]
		if find_reward == 1 then
			--���˱ҷ�����
			--���û����Ѵ��˱ҿ��ŵ�tb_reward�ĵ�һλ����
			for i=1,card_num do
				if tb_reward[i][1] == 2 then
					local ntemp  = tb_reward[1]
				  tb_reward[1] = tb_reward[i]
				  tb_reward[i] = ntemp
				end
			end
			yuandan_lib.user_list[user_id].now_state[duihuan_type] = 2
			yuandan_lib_db.set_now_state(user_id, duihuan_type, 2)
			--����ǵ�ʮ����ǿ�ƶԻ�
--			if n_step == 10 then
--				yuandan_lib.exchange_goon(user_id, duihuan_type, 2)
--			end
		else
			--������
			for i=1,card_num do
				if tb_reward[i][2] == find_reward then
					local ntemp  = tb_reward[1]
				  tb_reward[1] = tb_reward[i]
				  tb_reward[i] = ntemp
				end
			end
			--������ �Ͳ��� 
			if find_reward >= 23 and find_reward <= 26 then
				tex_gamepropslib.set_props_count_by_id(find_reward, 1, user_info, nil)
			else
				car_match_db_lib.add_car(user_info.userId, find_reward, 0)
			end
			
			if yuandan_lib.CFG_NAME_REWARD[find_reward] then
				local msg = "����������´���л��%s"
				msg = string.format(msg, yuandan_lib.CFG_NAME_REWARD[find_reward])
				tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
			  yuandan_lib.add_user_history(user_id, user_info.nick, _U(yuandan_lib.CFG_NAME_REWARD[find_reward]))
			end
			--log
			yuandan_lib_db.log_yuandan_reward(user_id, duihuan_type, n_step, find_reward, 0)
			--������Ϸ״̬
			yuandan_lib.restart_game(user_id, duihuan_type)
			--���Ͷһ���todo
			--yuandan_lib.notify_all_msg(user_info.userId,user_info.nick,yuandan_lib.CFG_CAR_NAME[find_reward],find_reward,1)
		end
	end
	return card_num, tb_reward, 0, 0
end

--������Ϸ
function yuandan_lib.restart_game(user_id, duihuan_type)
		if not yuandan_lib.user_list[user_id] then return end
		yuandan_lib.user_list[user_id].now_state[duihuan_type] = 1
		yuandan_lib.user_list[user_id].now_step[duihuan_type] = 1
		--�������ݿ�
		yuandan_lib_db.set_gameinfo(user_id, duihuan_type, 1, 1 )
end

--�һ�����
function yuandan_lib.on_recv_exchange_goon(buf)
	--if yuandan_lib.check_datetime() == 0 then return end
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local user_id = user_info.userId
	if not yuandan_lib.user_list[user_id] then return end
	local duihuan_type = buf:readByte() --1��2��3��ӦԲԲ��������
	local exchangeorgoon = buf:readByte() -- 1,2 1������2�һ�
	if yuandan_lib.user_list[user_id].now_state[duihuan_type] ~= 2 then
		TraceError("�Ƿ�Э��now_state~=2")
		return
	end
	yuandan_lib.exchange_goon(user_id, duihuan_type, exchangeorgoon)
end

function yuandan_lib.exchange_goon(user_id, duihuan_type, exchange_goon)
	local user_info = usermgr.GetUserById(user_id)
	if exchange_goon == 1 then
		yuandan_lib.user_list[user_id].now_step[duihuan_type] = yuandan_lib.user_list[user_id].now_step[duihuan_type] + 1
		yuandan_lib_db.set_now_step(user_id, duihuan_type, yuandan_lib.user_list[user_id].now_step[duihuan_type])
		yuandan_lib.user_list[user_id].now_state[duihuan_type] = 1
		yuandan_lib_db.set_now_state(user_id, duihuan_type, 1)
		yuandan_lib.seng_user_gameinfo(user_info, duihuan_type)
	elseif exchange_goon == 2 then
		--������
		local n_money = yuandan_lib.CFG_DOZENCOIN_REWARD[duihuan_type]
		--������
		usermgr.addgold(user_id, n_money*(2^yuandan_lib.user_list[user_id].now_step[duihuan_type]), 0, new_gold_type.LOVE_DAY2013, -1, 1)
		--�㲥
		if 2^yuandan_lib.user_list[user_id].now_step[duihuan_type] > 1000000  then
				local msg = "����������´���л��"..2^yuandan_lib.user_list[user_id].now_step[duihuan_type].."����"
				tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
		end
		--log
		yuandan_lib_db.log_yuandan_reward(user_id, duihuan_type, yuandan_lib.user_list[user_id].now_step[duihuan_type], 0, n_money*(2^yuandan_lib.user_list[user_id].now_step[duihuan_type])) 
		--֪ͨ�ͻ���
		netlib.send(function(buf)
	    buf:writeString("YDEXCHANGE")
	    buf:writeInt(n_money*(2^yuandan_lib.user_list[user_id].now_step[duihuan_type]))
  	end,user_info.ip,user_info.port)
  	--������Ϸ
		yuandan_lib.user_list[user_id].now_step[duihuan_type] = 1
		yuandan_lib_db.set_now_step(user_id, duihuan_type, 1)
		yuandan_lib.user_list[user_id].now_state[duihuan_type] = 1
		yuandan_lib_db.set_now_state(user_id, duihuan_type, 1)
	end
	
end
--��ʼ��һ����Ϸ����Ǯ���ߴ��˱�1�ɹ�  -1���˱Ҳ��� -2��Ҳ��� -3 ��Ҽ������� 
function yuandan_lib.start_game(user_info, user_id, use_type, duihuan_type)
	if yuandan_lib.check_datetime() ~= 1 then return -4 end
	if use_type == 1 then
		if not user_info.wealth.dzcash or user_info.wealth.dzcash < yuandan_lib.CFG_DOZENCOIN_START[duihuan_type] then 
			return -1
		end
		--�۴��˱�
		usermgr.addcash(user_id, -yuandan_lib.CFG_DOZENCOIN_START[duihuan_type], g_TransType.Buy, "", 1, nil)      
	elseif  use_type == 2 then
		if not user_info.site then
			if not user_info.gamescore or user_info.gamescore < yuandan_lib.CFG_COIN_START[duihuan_type] then
				return -2
			end
			--�۽��
			usermgr.addgold(user_id, -yuandan_lib.CFG_COIN_START[duihuan_type], 0, new_gold_type.LOVE_DAY2013, -1);
		else
			return -3
		end
	end
	yuandan_lib_db.log_start_playcard(user_id, duihuan_type, use_type)
	return 1
end
--�һ���¼�б�
function yuandan_lib.send_history()
	for k1,v1 in pairs(yuandan_lib.user_list) do
		local user_info = nil
		if v1.user_id then
				user_info = usermgr.GetUserById(v1.user_id)
		end
		if user_info ~= nil and v1.open_panel and v1.open_panel == 1 then
			yuandan_lib.send_user_history(user_info)
		end
   end
end

--�һ���¼�б�
function yuandan_lib.send_user_history(user_info)
		if user_info ~= nil then
			netlib.send(function(buf)
			    buf:writeString("YDHISTORY")
			    buf:writeInt(#yuandan_lib.history_list)
				for k,v in pairs(yuandan_lib.history_list)do
					buf:writeInt(v.user_id)
					buf:writeString(v.nick_name)
					buf:writeString(v.gift_name)
				end
		    end,user_info.ip,user_info.port)
		end
end

function yuandan_lib.add_user_history(user_id, nick_name, gift_name)
	--�Ӷһ���¼�б�
	local buf_tab={}
	buf_tab.user_id = user_id
	buf_tab.nick_name = nick_name
	buf_tab.gift_name = gift_name
	if #yuandan_lib.history_list<yuandan_lib.CFG_HISTORY_LEN then
		table.insert(yuandan_lib.history_list,buf_tab)
	else
		table.remove(yuandan_lib.history_list,1)
		table.insert(yuandan_lib.history_list,buf_tab)
	end
	yuandan_lib.send_history()
end


cmdHandler = 
{
    ["YDACTIVE"]    = yuandan_lib.on_recv_huodong_status,    --��Ƿ���Ч
 		["YDOPEN"]      = yuandan_lib.on_recv_open_panel,        --�򿪻���
 		["YDGAMEINFO"]  = yuandan_lib.on_recv_ask_gametab,       --�����Ӧ�����
   -- ["YDOPENJQ"]    = yuandan_lib.on_recv_open_yhq,          --�򿪶һ��Ż�ȯ���
    ["YDCLOSE"]    	= yuandan_lib.on_recv_close_panel,       --�رջ���
    ["YDCHECKPOKER"]= yuandan_lib.on_recv_check_poker,       --�յ�������
    ["YDEXCHANGE"]  = yuandan_lib.on_recv_exchange_goon,          --�յ��һ����Ǽ�������
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("on_user_exit", yuandan_lib.on_user_exit)

