TraceError("init car_match_sj_lib...")

if car_match_sj_lib and car_match_sj_lib.timer then
	eventmgr:removeEventListener("timer_second", car_match_sj_lib.timer);
end

if car_match_sj_lib and car_match_sj_lib.restart_server then
	eventmgr:removeEventListener("on_server_start", car_match_sj_lib.restart_server);
end

if car_match_sj_lib and car_match_sj_lib.on_server_start then
	eventmgr:removeEventListener("on_server_start", car_match_sj_lib.on_server_start); 
end

if not car_match_sj_lib then
    car_match_sj_lib = _S
    {
		--����

        ------------------------------------ϵͳ����--------------------------------
        CFG_TODAY_KING_LEN = 10,    --���10���ھ���¼
		CFG_TOTALMATCH_TIME = 0,    --�೤ʱ��һ������
		CFG_BAOMING_TIME = 0,       --�����׶���Ҫ����ʱ��
		CFG_MATCH_TIME = 0,         --����������ʱ��
		CFG_LJ_TIME = 0,            --�����콱�������ʾʱ��
		CFG_CAR_NUM = 8,            --һ��8��������
		CFG_MAX_TEAM_LEVEL = 100,   --������ߵȼ�
        CFG_TIME_DESC = "",         --����ʱ������
        CFG_GAS_TIME = 30 * 60,      --����ֵ�ָ�ʱ��
		CFG_BAOMING_GOLD ={         --Ĭ�ϵı�������
			[3] = 200,
		},
		CFG_OPEN_TIME = {
            [3] = {},
            },    --����ʱ��
		CFG_MATCH_NAME = {
			[3] = "������",
		},
		CFG_GAME_ROOM = 18001,      --ֻ���ڵ��ݵ��������������Ĳ���
        CFG_WIN_CHANCE = {          --des:��λ��ʤ����
            [3] = {},
        },
        CFG_GAS_USE = 1,            --ÿ������ֵ����
        CFG_GAS_MAX = 5,            --����������ֵ������(�Զ��ָ�)
        temp_race_reward = {},
        race_reward = {             --����
            [20] = {
                {exp=400, chouma=500, flag=3, flag_num=1},
                {exp=300, chouma=300, flag=2, flag_num=1},
                {exp=300, chouma=300, flag=2, flag_num=1},
                {exp=200, chouma=0, flag=1, flag_num=1},
                {exp=200, chouma=0, flag=1, flag_num=1},
                {exp=200, chouma=0, flag=1, flag_num=1},
                {exp=200, chouma=0, flag=1, flag_num=1},
                {exp=200, chouma=0, flag=1, flag_num=1},
            },
            [40] = {
                {exp=400, chouma=500, flag=4, flag_num=1},
                {exp=300, chouma=300, flag=3, flag_num=1},
                {exp=300, chouma=300, flag=3, flag_num=1},
                {exp=200, chouma=0, flag=2, flag_num=1},
                {exp=200, chouma=0, flag=2, flag_num=1},
                {exp=200, chouma=0, flag=2, flag_num=1},
                {exp=200, chouma=0, flag=2, flag_num=1},
                {exp=200, chouma=0, flag=2, flag_num=1},
            },
            [100] = {
                {exp=400, chouma=500, flag=5, flag_num=1},
                {exp=300, chouma=300, flag=4, flag_num=1},
                {exp=300, chouma=300, flag=4, flag_num=1},
                {exp=200, chouma=0, flag=3, flag_num=1},
                {exp=200, chouma=0, flag=3, flag_num=1},
                {exp=200, chouma=0, flag=3, flag_num=1},
                {exp=200, chouma=0, flag=3, flag_num=1},
                {exp=200, chouma=0, flag=3, flag_num=1},
            },
		},
        exp_list = {},
        temp_exp_list = {
            [1] = 200,    [2]  = 400,   [3]  = 600,   [4]  = 800,   [5] = 1000,
            [6] = 1200,   [7]  = 1400,  [8]  = 1600,  [9]  = 1800,  [10] = 2000,
            [11] = 2200,  [12] = 2400,  [13] = 2600,  [14] = 2800,  [15] = 3000,
            [16] = 3200,  [17] = 3400,  [18] = 3600,  [19] = 3800,  [20] = 4000,
            [21] = 4200,  [22] = 4400,  [23] = 4600,  [24] = 4800,  [25] = 5000,
            [26] = 5200,  [27] = 5400,  [28] = 5600,  [29] = 5800,  [30] = 6000,
            [31] = 6200,  [32] = 6400,  [33] = 6600,  [34] = 6800,  [35] = 7000,
            [36] = 7200,  [37] = 7400,  [38] = 7600,  [39] = 7800,  [40] = 8000,
            [41] = 8200,  [42] = 8400,  [43] = 8600,  [44] = 8800,  [45] = 9000,
            [46] = 9200,  [47] = 9400,  [48] = 9600,  [49] = 9800,  [50] = 10000,
            [51] = 10200, [52] = 10400, [53] = 10600, [54] = 10800, [55] = 11000,
            [56] = 11200, [57] = 11400, [58] = 11600, [59] = 11800, [60] = 12000,
            [61] = 12200, [62] = 12400, [63] = 12600, [64] = 12800, [65] = 13000,
            [66] = 13200, [67] = 13400, [68] = 13600, [69] = 13800, [70] = 14000,
            [71] = 14200, [72] = 14400, [73] = 14600, [74] = 14800, [75] = 15000,
            [76] = 15200, [77] = 15400, [78] = 15600, [79] = 15800, [80] = 16000,
            [81] = 16200, [82] = 16400, [83] = 16600, [84] = 16800, [85] = 17000,
            [86] = 17200, [87] = 17400, [88] = 17600, [89] = 17800, [90] = 18000,
            [91] = 18200, [92] = 18400, [93] = 18600, [94] = 18800, [95] = 19000,
            [96] = 19200, [97] = 19400, [98] = 19600, [99] = 19800, [100] = 20000,
        },
        gas_reason = {              --���ͼӼ�ԭ�� 1:���� 2:�Զ��ָ� 3:����
            match = 1,
            huifu = 2,
            buy   = 3,
        },        
        notify_flag = 0,            --֪ͨ�ͻ���ˢ�½���
		need_notify_proc = 0,       --֪ͨ�����б仯
        match_start_status = {[3] = 0},   --�����ǲ��ǿ�ʼ��
        current_time = 0,           --ϵͳ��ǰʱ��
		match_list = {},            --������Ϣ
		user_list = {},             --��������б�
        match_user_list = {},       --�򿪱�����������б�
		today_king_list = {         --�ھ��б�
			[3] = {},
		},
		restart_match_id = {        --���������������¼����ǰ��match_id�Ƕ���
			[3] = 0,
		},
        car_flag_sign = {
            [1] = "flag1_num",       --��ͨ����
            [2] = "flag2_num",       --��������
            [3] = "flag3_num",       --��󳵱�
            [4] = "flag4_num",       --ϡ������
            [5] = "flag5_num",       --���泵��
        },
        npc_num = {
			[3] = {},
		},
        match_reward_list = {},     --��������
        npc_num = {
			[3] = {},
		},
        npc_car ={
			[3] ={
				[1]={
					["user_id"] = -100,
					["nick_name"] = "�����",
					["car_id"] = -100,
					["car_type"] = 5019,
				},
				[2]={
					["user_id"] = -101,
					["nick_name"] = "������",
					["car_id"] = -101,
					["car_type"] = 5022,
				},
				[3]={
					["user_id"] = -102,
					["nick_name"] = "����",
					["car_id"] = -102,
					["car_type"] = 5019,
				},
				[4]={
					["user_id"] = -103,
					["nick_name"] = "��˹����",
					["car_id"] = -103,
					["car_type"] = 5022,
				},
				[5]={
					["user_id"] = -104,
					["nick_name"] = "������",
					["car_id"] = -104,
					["car_type"] = 5019,
				},
				[6]={
					["user_id"] = -105,
					["nick_name"] = "�յٶ�",
					["car_id"] = -105,
					["car_type"] = 5022,
				},
				[7]={
					["user_id"] = -106,
					["nick_name"] = "�ʹ�",
					["car_id"] = -106,
					["car_type"] = 5019,
				},
				[8]={
					["user_id"] = -107,
					["nick_name"] = "Ī˹",
					["car_id"] = -107,
					["car_type"] = 5022,
				},
				[9]={
					["user_id"] = -108,
					["nick_name"] = "����˹��",
					["car_id"] = -108,
					["car_type"] = 5019,
				},
				[10]={
					["user_id"] = -109,
					["nick_name"] = "������",
					["car_id"] = -109,
					["car_type"] = 5022,
				},
				[11]={
					["user_id"] = -110,
					["nick_name"] = "������",
					["car_id"] = -110,
					["car_type"] = 5019,
				},
				[12]={
					["user_id"] = -111,
					["nick_name"] = "��������",
					["car_id"] = -111,
					["car_type"] = 5022,
				},
				[13]={
					["user_id"] = -112,
					["nick_name"] = "��³��",
					["car_id"] = -112,
					["car_type"] = 5019,
				},
				[14]={
					["user_id"] = -113,
					["nick_name"] = "������",
					["car_id"] = -113,
					["car_type"] = 5022,
				},
				[15]={
					["user_id"] = -114,
					["nick_name"] = "������",
					["car_id"] = -114,
					["car_type"] = 5019,
				},
				[16]={
					["user_id"] = -115,
					["nick_name"] = "���ܶ���",
					["car_id"] = -115,
					["car_type"] = 5022,
				},
				[17]={
					["user_id"] = -200,
					["nick_name"] = "���·ƶ���",
					["car_id"] = -200,
					["car_type"] = 5017,
				},
				[18]={
					["user_id"] = -201,
					["nick_name"] = "�����޷�",
					["car_id"] = -201,
					["car_type"] = 5024,
				},
				[19]={
					["user_id"] = -202,
					["nick_name"] = "СƤ����",
					["car_id"] = -202,
					["car_type"] = 5017,
				},
				[20]={
					["user_id"] = -203,
					["nick_name"] = "���ع���",
					["car_id"] = -203,
					["car_type"] = 5024,
				},
				[21]={
					["user_id"] = -204,
					["nick_name"] = "�����",
					["car_id"] = -204,
					["car_type"] = 5024,
				},
				[22]={
					["user_id"] = -205,
					["nick_name"] = "˹ͼ����",
					["car_id"] = -205,
					["car_type"] = 5017,
				},
				[23]={
					["user_id"] = -206,
					["nick_name"] = "����˹��",
					["car_id"] = -206,
					["car_type"] = 5024,
				},
				[24]={
					["user_id"] = -207,
					["nick_name"] = "������ķ",
					["car_id"] = -207,
					["car_type"] = 5017,
				},
				[25]={
					["user_id"] = -208,
					["nick_name"] = "������ɶ�",
					["car_id"] = -208,
					["car_type"] = 5024,
				},
				[26]={
					["user_id"] = -209,
					["nick_name"] = "��˹����",
					["car_id"] = -209,
					["car_type"] = 5017,
				},
				[27]={
					["user_id"] = -210,
					["nick_name"] = "�Ͷ�",
					["car_id"] = -210,
					["car_type"] = 5024,
				},
				[28]={
					["user_id"] = -211,
					["nick_name"] = "ά�ض�",
					["car_id"] = -211,
					["car_type"] = 5017,
				},
				[29]={
					["user_id"] = -212,
					["nick_name"] = "����",
					["car_id"] = -212,
					["car_type"] = 5024,
				},
				[30]={
					["user_id"] = -213,
					["nick_name"] = "��¡��",
					["car_id"] = -213,
					["car_type"] = 5017,
				},
				[31]={
					["user_id"] = -214,
					["nick_name"] = "��˹����",
					["car_id"] = -214,
					["car_type"] = 5024,
				},
				[32]={
					["user_id"] = -215,
					["nick_name"] = "Τ��",
					["car_id"] = -215,
					["car_type"] = 5017,
				},
			},
		},
    }
end

------------------------------------------------��������--------------------------------------------

--�յ�����
function car_match_sj_lib.on_recv_baoming(buf)
    local send_baoming_result = function(user_info,result)
	 	netlib.send(function(buf)
        	buf:writeString("SJCARJOIN");
        	buf:writeInt(result)
        end,user_info.ip,user_info.port);
	end

	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;

   	local car_id = buf:readInt()
   	local area_id = buf:readByte()
   	local match_type = buf:readByte()
   	local car_type = buf:readInt()
   	local user_id = user_info.userId
   	local result = 1

   	--[[����ֵ˵��:
    -1,��λ���������ѱ�������
    -2 ����ʱ�����
    -3 �������ò���
    -4 ������λ���ϱ�������
    -5 ����ֵ����
    -0 ������Ч����
    --]]

    --�������Чʱֱ�Ӳ�������
   	if car_match_sj_lib.match_start_status[match_type] == 0 then return end

    if car_match_sj_lib.match_list[match_type].proccess ~= 1 then
   	   	send_baoming_result(user_info, -2)
   		return
   	end

    --���������λ���Ѿ�������
    if (car_match_sj_lib.match_list[match_type].match_car_list[area_id].match_user_id ~= nil) then
   		send_baoming_result(user_info, -1)
   		return
   	end

    --�������ò���
    local need_gold = car_match_sj_lib.get_baoming_gold(match_type)
    local usergold = get_canuse_gold(user_info)
   	if usergold < need_gold then
   		send_baoming_result(user_info, -3)
   		return
    end

    --����ֵ����
    local user_gas = car_match_sj_lib.user_list[user_info.userId].gas_num
    if (user_gas < 1) then
        send_baoming_result(user_info, -5)
   		return
    end

    --������λ���ϱ�������
   	for k,v in pairs(car_match_sj_lib.match_list[match_type].match_car_list) do
   		if v.match_user_id == user_id then
   			send_baoming_result(user_info,-4)
   			return
   		end
   	end

   	--�������������㣬���б���
    local team_lv = car_match_sj_lib.user_list[user_id].team_lv
    local team_exp = car_match_sj_lib.user_list[user_id].team_exp
   	usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH, -1)    --�۳���
    car_match_sj_lib.add_gas(user_id, -car_match_sj_lib.CFG_GAS_USE, car_match_sj_lib.gas_reason.match)  --������
    
   	car_match_sj_lib.match_list[match_type].match_car_list[area_id].car_id = car_id
   	car_match_sj_lib.match_list[match_type].match_car_list[area_id].match_user_id = user_id
   	car_match_sj_lib.match_list[match_type].match_car_list[area_id].match_nick_name = user_info.nick
   	car_match_sj_lib.match_list[match_type].match_car_list[area_id].match_user_face = user_info.imgUrl or ""
   	car_match_sj_lib.match_list[match_type].match_car_list[area_id].car_type = car_type
    car_match_sj_lib.match_list[match_type].match_car_list[area_id].team_lv = team_lv
    car_match_sj_lib.match_list[match_type].match_car_list[area_id].team_exp = team_exp
   	send_baoming_result(user_info,result)

    --��������Ϣ
    car_match_sj_lib.send_team_info(user_info)
   	--���һ��ˢ��
   	car_match_sj_lib.notify_flag = match_type
    
 	--֪ͨ���ݲ㱣�汨������
 	local baoming_num = 0
 	local match_id = car_match_sj_lib.match_list[match_type].match_id
 	car_match_sj_db_lib.update_car_baoming(area_id, car_id, user_id, baoming_num, match_type, match_id)
end

--�յ��򿪱���ѡ�����
function car_match_sj_lib.on_recv_openjoin(buf)
	local get_car_num = function(car_list)
		local len = 0
		for k,v in pairs(car_list)do
			len = len + 1
		end
		return len
	end
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
   	local user_id = user_info.userId
   	local area_id = buf:readByte()
   	local match_type = buf:readByte()

   	local need_gold = 0
   	need_gold = car_match_sj_lib.get_baoming_gold(match_type)
   	local car_num = get_car_num(car_match_lib.user_list[user_id].car_list)

   	--�õ����Ա����ĳ�
   	local match_car_list = {}
   	for k,v in pairs(car_match_lib.user_list[user_id].car_list) do
   		if v.car_type ~= nil and car_match_lib.CFG_CAR_INFO[v.car_type] ~= nil then
			table.insert(match_car_list,v)
		end
   	end

   	netlib.send(function(buf)
        buf:writeString("SJCAROPJN");
        buf:writeInt(need_gold)
        buf:writeInt(#match_car_list)
        for k,v in pairs (match_car_list) do
        	buf:writeInt(v.car_id)
        	buf:writeInt(v.car_type)
        end
     end, user_info.ip, user_info.port);
end

--�յ������
function car_match_sj_lib.on_recv_openpl(buf)
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
   	local user_id = user_info.userId
   	local match_type = buf:readByte() --�õ�������ID

    --��������������Ϣ
    if (car_match_sj_lib.user_list[user_id] ~= nil) then
        car_match_sj_lib.match_user_list[user_id] = {}
   	    car_match_sj_lib.match_user_list[user_id] = car_match_sj_lib.user_list[user_id]
    end
    --�жϹر������ڼ��Ƿ�Ҫ������
    car_match_sj_lib.add_off_line_gas(user_id)
    --����������Ϣ
    car_match_sj_lib.send_main_box(user_info,match_type)
    --����ʣ��ʱ��
    car_match_sj_lib.send_match_time(user_info,match_type)
	--��������ھ�
    car_match_sj_lib.send_today_king(user_info, match_type)
    --��������Ϣ
    car_match_sj_lib.send_match_reward(user_info, match_type)
	--����һ�ֱ�����ʼ��ʱ��
	car_match_sj_lib.send_next_match_time(user_info, match_type)
end

--�ͻ��˲�ѯ�״̬
--byte 1��Ч -1��������ʱ����� -2������Ч��ʱ�� 0�����쳣
function car_match_sj_lib.on_recv_querystatus(buf)
	local user_info = userlist[getuserid(buf)];
	if not user_info then return end;
	local match_type = buf:readInt()

	local send_result = function(user_info,status)
	   	netlib.send(function(buf)
	        buf:writeString("SJCARSTAT");
	        buf:writeByte(status);
			buf:writeByte(match_type);
    	end,user_info.ip,user_info.port);
	end

    --����δ��ʼ
    if car_match_sj_lib.match_start_status[match_type] == 0 then
    	send_result(user_info,-2)
    	return
    end
    if car_match_sj_lib.check_time(match_type)==1 then
    	send_result(user_info,1)
    	return
    end
   	--������Чʱ��
   	send_result(user_info,-2)
end

--�յ����������
function car_match_sj_lib.on_recv_query_match_mc(buf)
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
   	local match_type = buf:readByte()
	car_match_sj_lib.send_match_mc(match_type)
end

--�յ��رջ���
function car_match_sj_lib.on_recv_closepl(buf)
    local user_info = userlist[getuserid(buf)];
    car_match_sj_lib.match_user_list[user_info.userId] = nil
end

--�յ�����ָ�����
function car_match_sj_lib.on_recv_get_gas(buf)
    local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;

    local send_result = function(user_info, result, over_time)
	 	netlib.send(function(buf)
        	buf:writeString("GETGAS");
        	buf:writeInt(result)
        end, user_info.ip, user_info.port);
	end

    local current_time = os.time()
    local over_time = current_time - car_match_sj_lib.user_list[user_info.userId].gas_time  --�ѹ�CDʱ��
    local result = 1
    local gas_num = car_match_sj_lib.user_list[user_info.userId].gas_num    --���ʣ������

    if (gas_num < car_match_sj_lib.CFG_GAS_MAX) then            --���ʣ������С���������ֵ������
        if (over_time >= car_match_sj_lib.CFG_GAS_TIME) then    --�ѹ�CDʱ����ڵ���30���ӿɻָ�
            local add_gas_num = math.floor(over_time / car_match_sj_lib.CFG_GAS_TIME)
            car_match_sj_lib.add_gas(user_info.userId, add_gas_num, car_match_sj_lib.gas_reason.huifu)
            send_result(user_info, result)
            car_match_sj_lib.send_team_info(user_info)          --��ȷ�ָ��󷢳�����Ϣ���ͻ���
        else        --ʱ��δ��������,���ϴλָ�ʱ���ٷ��ؿͻ��˵���ʱ
            TraceError("���"..user_info.userId.."δ����ȴʱ������ָ�����")
            result = -1
            send_result(user_info, result)
            car_match_sj_lib.send_team_info(user_info)
        end
    else
        TraceError("���"..user_info.userId.."����ֵ����")  --Ӧ�ò�������������
        --car_match_sj_lib.user_list[user_info.userId].gas_time = 0
        result = -2
        send_result(user_info, result)
    end
    
end

------------------------------------���緢��------------------------------------------

--�����׶�ʣ��ʱ��
function car_match_sj_lib.send_match_time(user_info,match_type)
	--������û��ʼ���Ͳ�Ҫ������ʱ����
	if car_match_sj_lib.match_start_status[match_type] == 0 then return end
	local current_time = car_match_sj_lib.current_time
	local match_info = car_match_sj_lib.match_list[match_type]
	local remain_time = car_match_sj_lib.get_remain_time(match_type, current_time)
	netlib.send(function(buf)
       buf:writeString("SJCARTIME"); --֪ͨ�ͻ���
       buf:writeByte(match_info.match_type);
	   buf:writeByte(match_info.proccess);
	   buf:writeInt(remain_time);
	end,user_info.ip,user_info.port)
end

--����������Ϣ
function car_match_sj_lib.send_main_box(user_info, match_type)
	if car_match_sj_lib.match_list[match_type] == nil or car_match_sj_lib.match_list[match_type].proccess == nil then return end
    local user_id = user_info.userId
 	netlib.send(function(buf)
        buf:writeString("SJCAROPPL");
        buf:writeByte(car_match_sj_lib.match_list[match_type].proccess)     --�׶�
        buf:writeInt(car_match_sj_lib.get_remain_time(match_type, car_match_sj_lib.current_time)) --ʣ��ʱ��
        buf:writeInt(car_match_sj_lib.CFG_MATCH_TIME)   --�����׶�ʱ��
        buf:writeByte(car_match_sj_lib.CFG_CAR_NUM)
        for  i = 1,car_match_sj_lib.CFG_CAR_NUM do
        	  buf:writeByte(i)
        	  buf:writeInt(car_match_sj_lib.match_list[match_type].match_car_list[i].car_id)     --��id
              buf:writeInt(car_match_sj_lib.match_list[match_type].match_car_list[i].mc)
        	  --���������ID
              local match_user_team_lv = car_match_sj_lib.match_list[match_type].match_car_list[i].team_lv
        	  local match_user_id = car_match_sj_lib.match_list[match_type].match_car_list[i].match_user_id
        	  local match_nick_name = car_match_sj_lib.match_list[match_type].match_car_list[i].match_nick_name
        	  local match_user_face = car_match_sj_lib.match_list[match_type].match_car_list[i].match_user_face
              buf:writeInt(match_user_team_lv or 0)
        	  buf:writeInt(match_user_id or 0)
        	  buf:writeString(match_nick_name or "")
        	  local car_type = car_match_sj_lib.match_list[match_type].match_car_list[i].car_type or 0
        	  buf:writeInt(car_type)
        	  buf:writeString(match_user_face or "")
        end
        --1��1000����������ƿͻ�����ѡһ����������
        local seed = car_match_sj_lib.match_list[match_type].current_rand_num or 1000
        buf:writeInt(seed)
        buf:writeByte(match_type)
    end, user_info.ip, user_info.port);
end

--���ͳ�����Ϣ
function car_match_sj_lib.send_team_info(user_info)
    if user_info == nil then return end
    local user_id = user_info.userId
    local team_lv = car_match_sj_lib.user_list[user_id].team_lv   --���ӵȼ�
    local next_lv_exp = car_match_sj_lib.exp_list[team_lv + 1] or 0 --��һ�����辭��
    netlib.send(function(buf)
        buf:writeString("CARTEAMINFO");
        buf:writeString(user_info.gamescore)
        buf:writeInt(#car_match_sj_lib.car_flag_sign)  --������������
        for i = 1, #car_match_sj_lib.car_flag_sign do
            buf:writeInt(car_match_sj_lib.user_list[user_id]["flag"..i.."_num"])
        end
        buf:writeInt(car_match_sj_lib.user_list[user_id].gas_num)    --����ֵ
        buf:writeInt(team_lv)               --���ӵȼ�
        buf:writeInt(car_match_sj_lib.user_list[user_id].team_exp)   --���Ӿ���
        buf:writeInt(next_lv_exp)           --��һ�����辭��
        local gas_time = 0
        if (car_match_sj_lib.user_list[user_id].gas_time ~= 0) then
            gas_time = car_match_sj_lib.CFG_GAS_TIME - (os.time() - car_match_sj_lib.user_list[user_id].gas_time)
        end
        buf:writeString(gas_time)   --����ֵ�ָ�ʱ��
    end, user_info.ip, user_info.port)
end

--ʱ�䵽�ˣ�֪ͨ����
function car_match_sj_lib.send_match_status(match_type, current_time)
	local send_result = function(status)
		for k,v in pairs (car_match_sj_lib.match_user_list) do
			local user_info = usermgr.GetUserById(v.user_id)
			if user_info~=nil then
			   	netlib.send(function(buf)
			        buf:writeString("SJCARSTAT");
			        buf:writeByte(status);
					buf:writeByte(match_type);
		    	end,user_info.ip,user_info.port);
		    	car_match_sj_lib.send_match_time(user_info,match_type);
	    	end
    	end
    end

    local total_time = car_match_sj_lib.CFG_TOTALMATCH_TIME / 60;   --һ��������ʱ��
    local table_time = os.date("*t", current_time);
    local now_min = table_time.min
    local times = math.floor(60 / total_time);      --һСʱ�ڿɿ��ĳ���
    for i = 1, times do
        if (now_min == (i * total_time == 60 and 0 or i * total_time)) then
            if (car_match_sj_lib.match_start_status[match_type] == 0 and car_match_sj_lib.check_time(match_type) == 1) then
                car_match_sj_lib.match_start_status[match_type] = 1
                car_match_sj_lib.init_match(match_type, current_time)
                send_result(1)
                return
            end
        end
    end
end

--ʱ�䵽�ˣ�֪ͨ����
function car_match_sj_lib.send_match_status2(current_time, match_type)
	local send_result = function(status)
		for k,v in pairs (car_match_sj_lib.match_user_list) do
			local user_info = usermgr.GetUserById(v.user_id)
			if user_info~=nil then
			   	netlib.send(function(buf)
			        buf:writeString("SJCARSTAT");
			        buf:writeByte(status);
					buf:writeByte(match_type);
		    	end,user_info.ip,user_info.port);
	    	end
    	end
	end
    --�����Ч�����Ч��
	if car_match_sj_lib.match_start_status[match_type] == 1 and
       car_match_sj_lib.check_time(match_type)==0 then
        car_match_sj_lib.match_start_status[match_type] = 0
        send_result(-2)
        return
    end
end

--����һ����ʼʱ����ͻ���
function car_match_sj_lib.send_next_match_time(user_info, match_type)
	--��������Ѿ���ʼ���Ͳ����ٽ����������
	if car_match_sj_lib.match_start_status[match_type] == 1 then
		return
	end
    local total_time = car_match_sj_lib.CFG_TOTALMATCH_TIME / 60;   --һ��������ʱ��
	local table_time = os.date("*t", car_match_sj_lib.current_time);
	local now_hour = table_time.hour
	local now_min = table_time.min
	local start_hour = ""
	local start_min = ""
    local need_calc = 1
	if (car_match_sj_lib.CFG_OPEN_TIME[match_type][now_hour] ~= nil and
        now_min + total_time <= car_match_sj_lib.CFG_OPEN_TIME[match_type][now_hour][2]) then
        local times = math.floor(60 / total_time);      --һСʱ�ڿɿ��ĳ���
        for i = 1, times do
            if (now_min < i * total_time) then
                start_hour = now_hour;
                start_min = i * total_time;
                if (start_min < car_match_sj_lib.CFG_OPEN_TIME[match_type][now_hour][1]) then
                    start_min = car_match_sj_lib.CFG_OPEN_TIME[match_type][now_hour][1]
                end
                if (start_min < 10) then
			        start_min = "0"..start_min
                end
                need_calc = 0
                break;
            elseif (i == times) then
                need_calc = 1
            end
        end
    end
    if (need_calc == 1) then
        for i = 1, 24 do
            local next_time = (now_hour + i) % 24
            if (car_match_sj_lib.CFG_OPEN_TIME[match_type][next_time] ~= nil) then
                start_hour = next_time;
                start_min = car_match_sj_lib.CFG_OPEN_TIME[match_type][next_time][1];
                if (start_min < 10) then
                    start_min = "0"..start_min
                end
                break;
            end
        end
    end

    --��һ���ݴ���
    local msg = ""
    if start_hour ~= "" and start_min ~= "" then
		msg = _U("�³�����"..start_hour.."��"..start_min.."��ʼ")
    else
        msg = _U("�����ѽ����������ڴ������°汾!")
    end
    netlib.send(function(buf)
        buf:writeString("SJCARDES")
        buf:writeString(msg)
        buf:writeInt(match_type)
    end,user_info.ip,user_info.port);
end


--������ھ�����
function car_match_sj_lib.send_today_king(user_info, match_type)
    if (car_match_sj_lib.match_list[match_type] == nil or 
        car_match_sj_lib.match_list[match_type].proccess ~= 1) then return end;
	if car_match_sj_lib.today_king_list[match_type] == nil then car_match_sj_lib.today_king_list[match_type] = {} end
	local len = #car_match_sj_lib.today_king_list[match_type]
	if len > car_match_sj_lib.CFG_TODAY_KING_LEN then
		len = car_match_sj_lib.CFG_TODAY_KING_LEN
    end

	netlib.send(function(buf)
		buf:writeString("SJCARJRGJ")
		buf:writeByte(match_type)
		buf:writeInt(len)
		for i = 1, len do
			buf:writeInt(car_match_sj_lib.today_king_list[match_type][i].user_id)
			buf:writeInt(car_match_sj_lib.today_king_list[match_type][i].area_id)
			buf:writeString(car_match_sj_lib.today_king_list[match_type][i].nick_name)
			buf:writeInt(car_match_sj_lib.today_king_list[match_type][i].car_id)
			buf:writeInt(car_match_sj_lib.today_king_list[match_type][i].car_type)
		end
	end,user_info.ip, user_info.port)
end

--���ͱ�������
function car_match_sj_lib.send_match_reward(user_info, match_type)
    if (car_match_sj_lib.match_list[match_type] == nil or 
        car_match_sj_lib.match_list[match_type].proccess ~= 4) then return end;
    local send_func = function(buf_tab, match_type)
        if (user_info ~= nil) then
            local car_type = car_match_sj_lib.match_list[match_type].match_car_list[buf_tab.area_id].car_type
            netlib.send(function(buf)
                buf:writeString("SJCARREWARD")
                buf:writeString(buf_tab.nick_name or "")
                buf:writeString(buf_tab.img_url or "")
                buf:writeInt(buf_tab.area_id)
                buf:writeInt(car_type)
                buf:writeInt(buf_tab.add_gold)
                buf:writeInt(buf_tab.add_exp)
                buf:writeInt(buf_tab.flag_lv)
                buf:writeInt(buf_tab.flag_num)
                buf:writeInt(buf_tab.add_gas)
                buf:writeInt(buf_tab.mingci)
                buf:writeInt(match_type)
            end, user_info.ip, user_info.port)
        end
    end
    --��һ�������id
    local open_num = car_match_sj_lib.match_list[match_type].open_num
    local open_num_user_id = car_match_sj_lib.match_list[match_type].match_car_list[open_num].match_user_id
    local buf_tab = car_match_sj_lib.match_reward_list[open_num_user_id]   --Ĭ�Ϸ���һ����
    --���б��������ID˵������ǲ����ģ�Ҫ�����Լ��Ĳ�������
    if (car_match_sj_lib.match_reward_list[user_info.userId] ~= nil) then  
        buf_tab = car_match_sj_lib.match_reward_list[user_info.userId]
    end
    send_func(buf_tab, match_type)
end

--֪ͨ�ͻ������ͱ仯��
function car_match_sj_lib.send_gas_chenge(user_info, num)
    if not user_info then return end
    netlib.send(function(buf)
        buf:writeString("CARGASCHANGE")
        buf:writeInt(num)
    end, user_info.ip, user_info.port)
end
------------------------------------�ڲ��ӿ�------------------------------------------
function car_match_sj_lib.check_match_room()
    return tonumber(groupinfo.groupid) == car_match_sj_lib.CFG_GAME_ROOM and 1 or 0;
end

--��ʼ��ĳһ�ֱ���
function car_match_sj_lib.init_match(match_type, match_id)
	if car_match_sj_lib.match_list[match_type] == nil then car_match_sj_lib.match_list[match_type] = {} end
	car_match_sj_lib.match_list[match_type].match_type = match_type --3������
	car_match_sj_lib.match_list[match_type].proccess = 1  --1������� 3���� 4�����
	car_match_sj_lib.match_list[match_type].start_time = match_id --match_id����current_time
	car_match_sj_lib.match_list[match_type].current_rand_num = car_match_sj_lib.get_rand_num(1, 1000)
    car_match_sj_lib.match_reward_list = {}
    --���Чʱ�����ⲽ
	if car_match_sj_lib.match_start_status[match_type] == 1 then
		car_match_sj_lib.match_list[match_type].match_id = match_id..""..match_type
    end

	--��ʼ�������ֺ�������Ϣ
	car_match_sj_lib.match_list[match_type].match_car_list = {}
	for i = 1,car_match_sj_lib.CFG_CAR_NUM do
		car_match_sj_lib.match_list[match_type].match_car_list[i] = {}
		car_match_sj_lib.match_list[match_type].match_car_list[i].area_id = i --�����ܵ�
		car_match_sj_lib.match_list[match_type].match_car_list[i].car_id = 0  --���λ���ϵĳ�
        car_match_sj_lib.match_list[match_type].match_car_list[i].win_chance = 0   --��ǰ���λ�õĻ�ʤ����
		car_match_sj_lib.match_list[match_type].match_car_list[i].mc = 0      --��ǰ����
		car_match_sj_lib.match_list[match_type].match_car_list[i].car_type = 0 --���λ��ͣ��ʲô��
        car_match_sj_lib.match_list[match_type].match_car_list[i].team_lv = 0   --���ӵȼ�
        car_match_sj_lib.match_list[match_type].match_car_list[i].team_exp = 0
	end

	--��ʼ����ʤ����
	car_match_sj_lib.init_win_chance(match_type)

	--��ʼ��NPC�ĺ�
	if car_match_sj_lib.npc_num == nil then car_match_sj_lib.npc_num = {} end
	car_match_sj_lib.npc_num[match_type] ={}

	for i=1,#car_match_sj_lib.npc_car[match_type] do        
    	table.insert(car_match_sj_lib.npc_num[match_type],i)
	end
end

--�޸�8��λ�õ�Ӯ��
function car_match_sj_lib.init_win_chance(match_type)
	local car_box = car_match_sj_lib.match_list[match_type].match_car_list
    for i=1,#car_box do
        car_match_sj_lib.match_list[match_type].match_car_list[i].win_chance = car_match_sj_lib.CFG_WIN_CHANCE[match_type][i]
    end
end

--�õ���������
function car_match_sj_lib.get_match_mc(match_type)
	local get_tab_index = function(list_table,index)
		local i = 1
		for k,v in pairs(list_table) do
			if index == i then
				return v
			end
			i = i + 1
		end
	end

    local get_mc = function(car_box)
		local win_chance = {}
        local total_chance = 0
		for k, v in pairs(car_box) do
            local tmp_chance = v.win_chance * 10
            table.insert(win_chance, tmp_chance)
            total_chance = total_chance + tmp_chance
        end
		local rand_num = car_match_sj_lib.get_rand_num(1, total_chance)
		local tmp_num = win_chance[1]
		for i=1,#win_chance do
			if (i > 1) then
			    tmp_num = tmp_num + win_chance[i]
			end
            if rand_num <= tmp_num then
				local tmp_car = get_tab_index(car_box,i)
				return tmp_car.area_id
            end
		end
	end

	--�Ѳ������ŵ�Ҫ���������ĺ�����(���⣩
	local car_box = table.clone(car_match_sj_lib.match_list[match_type].match_car_list)
	local mc = {}

	--�õݹ��㷨 �õ�������������
	for i = 1,car_match_sj_lib.CFG_CAR_NUM do
		--mc[1]=2�����1��������2���ܵ��ĳ���mc[2]=4�����2������4���ܵ��ĳ�����������
		local tmp_area_id = get_mc(car_box)
		table.insert(mc, tmp_area_id)

		--��car_box������ų���һ���ĳ���Ȼ������car_boxȥ�ŵ�1��
		for k1,v1 in pairs(car_box)do
			if v1.area_id == mc[i] then
				car_box[k1] = nil
				break
			end
		end
	end

	--���²�����8��λ�õ�������Ϣ
	for i = 1, #mc do
		local area_id = mc[i]
		car_match_sj_lib.match_list[match_type].match_car_list[area_id].mc = i
		if i == 1 then
			car_match_sj_lib.match_list[match_type].open_num = area_id
		end
	end
end

--�õ���ǰ�׶ε�ʣ��ʱ��
function car_match_sj_lib.get_remain_time(match_type, current_time)
	local match_info = car_match_sj_lib.match_list[match_type]
	local use_time = current_time - match_info.start_time --�������˶���ʱ��
	local remain_time = 0
	--����ʣ��ʱ��
	if use_time < car_match_sj_lib.CFG_BAOMING_TIME then
		remain_time = car_match_sj_lib.CFG_BAOMING_TIME - use_time
	elseif use_time < car_match_sj_lib.CFG_BAOMING_TIME + car_match_sj_lib.CFG_MATCH_TIME then
		remain_time = car_match_sj_lib.CFG_BAOMING_TIME + car_match_sj_lib.CFG_MATCH_TIME - use_time
	elseif use_time < car_match_sj_lib.CFG_BAOMING_TIME + car_match_sj_lib.CFG_MATCH_TIME + car_match_sj_lib.CFG_LJ_TIME then
		remain_time = car_match_sj_lib.CFG_BAOMING_TIME + car_match_sj_lib.CFG_MATCH_TIME + car_match_sj_lib.CFG_LJ_TIME - use_time
	end

	if car_match_sj_lib.check_time(match_type) ~= 1 and car_match_sj_lib.match_start_status[match_type]==0 then
		remain_time = -1
	end
	return remain_time
end

--��΢����һ��LUA������㷨����ֹ �����ҵ�����
function car_match_sj_lib.get_rand_num(min_num, max_num)
		local buf_tab = {}
		for i = 1, 100 do
			table.insert(buf_tab, math.random(min_num, max_num))
        end
		return buf_tab[math.random(10, 80)]
end

--�õ���������
function car_match_sj_lib.get_car_name(car_type)
	return car_match_lib.CFG_CAR_INFO[car_type].name
end

--�õ��������ļ۸�
function car_match_sj_lib.get_car_cost(car_type)
	return car_match_lib.CFG_CAR_INFO[car_type].cost
end

--�õ���ҳ��ļ۸�
function car_match_sj_lib.get_user_car_prize(user_id, car_id)
    if (car_match_lib.user_list[user_id] ~= nil and car_match_lib.user_list[user_id].car_list[car_id] ~= nil) then
        return car_match_lib.user_list[user_id].car_list[car_id].car_prize
    else
        return 0
    end
end

--�õ�����������
function car_match_sj_lib.get_match_name(match_type)
	return car_match_sj_lib.CFG_MATCH_NAME[match_type]
end

--�õ�����������Ҫ��Ǯ
function car_match_sj_lib.get_baoming_gold(match_type)
	local baoming_gold = car_match_sj_lib.CFG_BAOMING_GOLD[match_type]
    return baoming_gold
end

--��NPC�б��г�ȡһ��NPC����
function car_match_sj_lib.get_npc_num(match_type)
	local npc_count = #car_match_sj_lib.npc_num[match_type]
	local rand_num = math.random(1,npc_count or 8) --��һ��NPC
	local tmp_num = car_match_sj_lib.npc_num[match_type][rand_num]
	if(tmp_num==nil)then
		TraceError("NPC��ȡ�㷨�����ˣ�")
		TraceError(car_match_sj_lib.npc_num[match_type])
	end

	table.remove(car_match_sj_lib.npc_num[match_type], rand_num)
	return tmp_num
end

--���õ�ǰ�ڵڼ��׶�
function car_match_sj_lib.set_proccess(match_info,current_time)
	--���������Чʱ�䣬���һ�û����ڶ��׶Σ��Ͳ��ٸı����Ľ׶�
	--Ŀ�ģ���δ�����ı������ټ��������ѿ����ı������꣬Ȼ���ټ���
	if car_match_sj_lib.match_start_status[match_info.match_type] == 0 and match_info.proccess == 1 then
		return
    end
    if match_info.proccess == 4 then
        car_match_sj_lib.send_match_status2(current_time, match_info.match_type)
        --�����Ѿ�����
        if car_match_sj_lib.match_start_status[match_info.match_type] == 0 then
    		car_match_sj_lib.init_match(match_info.match_type, current_time)
			car_match_sj_lib.need_notify_proc = 1
        end
    end
    if (car_match_sj_lib.check_time(match_info.match_type) == 1 and
        current_time >= match_info.start_time + car_match_sj_lib.CFG_TOTALMATCH_TIME) then
        car_match_sj_lib.init_match(match_info.match_type, current_time)
        car_match_sj_lib.need_notify_proc = 1
	elseif match_info.proccess < 3 and current_time >= match_info.start_time + car_match_sj_lib.CFG_BAOMING_TIME then
        match_info.proccess = 3
        --�����׶����ˣ�������г�λû�������ͼ�NPC
		car_match_sj_lib.add_npc(match_info.match_type)
		car_match_sj_lib.need_notify_proc = 1
   		car_match_sj_lib.get_match_mc(match_info.match_type)   		    --�������������
        car_match_sj_db_lib.log_sj_match(match_info)    --��¼������־
	elseif match_info.proccess < 4 and current_time >= match_info.start_time + car_match_sj_lib.CFG_BAOMING_TIME + car_match_sj_lib.CFG_MATCH_TIME then
		match_info.proccess = 4
		car_match_sj_lib.need_notify_proc = 1
		car_match_sj_lib.match_fajiang(match_info.match_type)     		--����ҷ���
		car_match_sj_lib.update_guanjun_info(match_info.match_type)     --���¹ھ���Ϣ
        car_match_sj_db_lib.clear_baoming()                             --�屨��
	end

	--�����б仯�ˣ���Ҫ֪ͨ�ͻ���
	if car_match_sj_lib.need_notify_proc == 1  then
		car_match_sj_lib.need_notify_proc = 0
		for k,v in pairs (car_match_sj_lib.match_user_list) do
			local user_info = usermgr.GetUserById(v.user_id)
			if user_info ~= nil then
				car_match_sj_lib.send_main_box(user_info, match_info.match_type)
				car_match_sj_lib.send_match_time(user_info, match_info.match_type)          --�³�ʱ��
                car_match_sj_lib.send_today_king(user_info, match_info.match_type)
                car_match_sj_lib.send_match_reward(user_info, match_info.match_type)
                car_match_sj_lib.send_team_info(user_info)
                if car_match_sj_lib.match_start_status[match_info.match_type] == 0 then
                    car_match_sj_lib.send_next_match_time(user_info, match_info.match_type)
                end
			end
		end
    end
end

--����NPC
function car_match_sj_lib.add_npc(match_type)
	for k,v in pairs (car_match_sj_lib.match_list[match_type].match_car_list) do
		local rand_num = car_match_sj_lib.get_npc_num(match_type) or 1
		if v.car_id==0 then --������λ����û�г��������ͼ�NPC
			v.car_id = car_match_sj_lib.npc_car[match_type][rand_num].car_id
			v.car_type = car_match_sj_lib.npc_car[match_type][rand_num].car_type
			v.match_user_id = car_match_sj_lib.npc_car[match_type][rand_num].user_id
			v.match_nick_name = _U(car_match_sj_lib.npc_car[match_type][rand_num].nick_name)
			v.match_user_face = "face/1025.jpg" --NPC��ͷ��Ҫ��ôŪ��todo
            v.team_lv = car_match_sj_lib.get_rand_num(1, 100)
            v.team_exp = 0
		end
	end

	--֪ͨ�ͻ��˱仯��������Ϣ
	for k,v in pairs(car_match_sj_lib.match_user_list) do
		local user_info = usermgr.GetUserById(v.user_id)
		if user_info ~= nil then
			car_match_sj_lib.send_main_box(user_info,match_type)
		end
	end
end

--���ʱ��
function car_match_sj_lib.check_time(match_type)
	local table_time = os.date("*t", car_match_sj_lib.current_time);
	local now_hour  = tonumber(table_time.hour);
    local now_min  = tonumber(table_time.min);
    if (car_match_sj_lib.CFG_OPEN_TIME[match_type][now_hour] ~= nil and
        now_min >= car_match_sj_lib.CFG_OPEN_TIME[match_type][now_hour][1]  and
        now_min <= car_match_sj_lib.CFG_OPEN_TIME[match_type][now_hour][2]) then
        return 1
    end
	return 0
end

--���¹ھ�������Ϣ
function car_match_sj_lib.update_guanjun_info(match_type)
	local call_back = function(user_info, car_info, site)
		netlib.send(function(buf)
	    	buf:writeString("SJCARQTYPE");
	    	buf:writeInt(car_info.car_id)
	    	buf:writeInt(car_info.car_type)
	    	buf:writeInt(site)
	    end,user_info.ip,user_info.port);
	end

	for k,v in pairs(car_match_sj_lib.match_list[match_type].match_car_list)do
		local car_id = v.car_id
		local match_user_id = v.match_user_id
		local match_user_info = usermgr.GetUserById(match_user_id)
		local nick_name = v.match_nick_name
		local car_type = v.car_type
        local car_prize = 0;
        if (match_user_id > 0) then --�ھ�Ϊ���
            car_prize = car_match_sj_lib.get_user_car_prize(match_user_id, car_id)
        else
            car_prize = car_match_sj_lib.get_car_cost(car_type)    --�ھ�ΪNPC
        end
		if(match_user_id == nil)then
			TraceError("�ùھ����˲��ǲ����ߣ���")
			TraceError(v)
        end
        
        if v.mc == 1 then
    		--��һ��д���ھ��б���ȥ
            local buf_tab = {
                ["area_id"] = k2,
                ["user_id"] = match_user_id,
                ["nick_name"] = nick_name,
                ["car_id"] = car_id,
                ["car_type"] = car_type,
                ["area_id"] = car_match_sj_lib.match_list[match_type].open_num,
            }
            --���չھ�
            if #car_match_sj_lib.today_king_list[match_type] < car_match_sj_lib.CFG_TODAY_KING_LEN then
                table.insert(car_match_sj_lib.today_king_list[match_type], buf_tab)
            else
                table.remove(car_match_sj_lib.today_king_list[match_type], 1)
                table.insert(car_match_sj_lib.today_king_list[match_type], buf_tab)
            end
    
            if (match_user_id > 0) then
                car_match_sj_db_lib.add_king_list(match_type, buf_tab)
            end
        end
	end
end

--���������˷���
function car_match_sj_lib.match_fajiang(match_type)
    --��һ����λ�ú�
    local open_num = car_match_sj_lib.match_list[match_type].open_num
    local user_id = 0
    local mingci = 0
    local area_id = 0
    local car_type = 0

    --�������˷���
    for i = 1, car_match_sj_lib.CFG_CAR_NUM do
        mingci = car_match_sj_lib.match_list[match_type].match_car_list[i].mc
        area_id = car_match_sj_lib.match_list[match_type].match_car_list[i].area_id
        user_id = car_match_sj_lib.match_list[match_type].match_car_list[i].match_user_id
        car_type = car_match_sj_lib.match_list[match_type].match_car_list[i].car_type

        --�����顢���ꡢ���롢������
        local team_lv = 0
        local reward_num = 0

        team_lv = car_match_sj_lib.match_list[match_type].match_car_list[i].team_lv
        reward_num = car_match_sj_lib.get_reward_num(team_lv)

        local add_exp = car_match_sj_lib.race_reward[reward_num][mingci].exp
        if (team_lv == #car_match_sj_lib.exp_list) then --�����˲��Ӿ���
            add_exp = 0
        end

        local flag_lv = car_match_sj_lib.race_reward[reward_num][mingci].flag
        local flag_num = car_match_sj_lib.race_reward[reward_num][mingci].flag_num
        local add_gold = car_match_sj_lib.race_reward[reward_num][mingci].chouma
        local add_gas = mingci == 1 and 1 or 0

        local user_info = usermgr.GetUserById(user_id)
        local img_url =  car_match_sj_lib.match_list[match_type].match_car_list[i].match_user_face
        local nick_name =  car_match_sj_lib.match_list[match_type].match_car_list[i].match_nick_name
        local team_exp = car_match_sj_lib.match_list[match_type].match_car_list[i].team_exp
        local buf_tab = {
            ["user_id"] = user_id,      
            ["area_id"] = area_id,      --��λ
            ["img_url"] = img_url,      --ͷ��
            ["nick_name"] = nick_name,  --�ǳ�
            ["add_exp"] = add_exp,      --��������
            ["flag_lv"] = flag_lv,      --��������ȼ�
            ["flag_num"] = flag_num,    --������������
            ["add_gold"] = add_gold,    --��������
            ["add_gas"] = add_gas,      --��������
            ["mingci"] = mingci,        --����  
            ["team_lv"] = team_lv,      --���ӵȼ�
            ["team_exp"] = team_exp,    --Ŀǰ���Ӿ���
        }
        car_match_sj_lib.save_fajiang(buf_tab)
    end
end

--������ҽ���
function car_match_sj_lib.save_fajiang(buf_tab)
    if (car_match_sj_lib.match_reward_list == nil) then
        car_match_sj_lib.match_reward_list = {}
    end
    car_match_sj_lib.match_reward_list[buf_tab.user_id] = buf_tab

    if (buf_tab.user_id > 0) then --ֻ�������Ϣ�ű���
        local user_info = usermgr.GetUserById(buf_tab.user_id)
        if (user_info == nil) then
            --��Ҳ�����ʱ������ҵĽ�����Ϣ������ʱ��ʾ
            car_match_sj_db_lib.update_offline_reward(buf_tab)
        end 
        --��������
        usermgr.addgold(buf_tab.user_id, buf_tab.add_gold, 0, new_gold_type.CAR_MATCH, -1)   --�ӳ���
        if (buf_tab.add_exp > 0) then   --�ӵľ������0ʱ�ż�
            car_match_sj_lib.add_team_exp(buf_tab.user_id, buf_tab.team_lv, buf_tab.team_exp, buf_tab.add_exp, car_match_sj_lib.gas_reason.match)   --�Ӿ���
        end
        car_match_sj_lib.add_car_flag(buf_tab.user_id, buf_tab.flag_lv, buf_tab.flag_num, car_match_sj_lib.gas_reason.match)  --�ӳ���
        if (buf_tab.add_gas ~= 0) then
            car_match_sj_lib.add_gas(buf_tab.user_id, buf_tab.add_gas, car_match_sj_lib.gas_reason.match)
        end
    end
end

--���ݳ��ӵȼ���������µȼ�����
function car_match_sj_lib.get_user_team_lv(lv, exp)
    if (lv == #car_match_sj_lib.exp_list) then     --������
        return #car_match_sj_lib.exp_list,exp
    end
    local up_lv_exp = car_match_sj_lib.exp_list[lv+1] or 0 --�ü�����������
    if (exp >= up_lv_exp) then          --������ھ�������������飬����������
        lv = lv + 1                     --�µĵȼ�
        exp = exp - up_lv_exp           --�µľ���(�����ľ���)
        lv, exp = car_match_sj_lib.get_user_team_lv(lv, exp)  --�ݹ��ж�һ�³����ľ����Ƿ��㹻����һ��
    end
    return lv, exp
end

--������ҳ��ӵȼ���ȡ��������
function car_match_sj_lib.get_reward_num(team_lv)
    for k, v in pairs(car_match_sj_lib.temp_race_reward) do
        if (team_lv <= v) then
            return v
        end
    end
end

--�����������ֵ
function car_match_sj_lib.add_gas(user_id, add_num, reason)
    --[[
        �Զ��ָ�������������ʱ��ҿ϶����ߣ�ֻ�з���������ʱ���ܲ�����
        ������Ҳ�����ʱ���������ͣ����ü�¼���ͻָ�ʱ�䣬����ʱ�ᴦ��
    --]]
    local user_info = usermgr.GetUserById(user_id)
    if (user_info ~= nil) then
        --ͬ��һ���ڴ������ֵ��CDʱ��
        local gas_num = car_match_sj_lib.user_list[user_id].gas_num
        if (gas_num == 0 and add_num < 0) then
            TraceError("���"..user_id.."����ֵΪ0��������..")
            return;
        end
        car_match_sj_lib.user_list[user_id].gas_num = gas_num + add_num
        --����ֵδ��������ָ�ʱ��
        if (car_match_sj_lib.user_list[user_id].gas_num < car_match_sj_lib.CFG_GAS_MAX) then
            if (reason == car_match_sj_lib.gas_reason.huifu) then               --�Զ��ָ�����
                car_match_sj_lib.user_list[user_id].gas_time = os.time()
            elseif (reason == car_match_sj_lib.gas_reason.match) then           --����������
                if (car_match_sj_lib.user_list[user_id].gas_time == 0 and add_num < 0) then     --֮ǰû�м�¼CDʱ�䣬��ʾ֮ǰ����������
                    car_match_sj_lib.user_list[user_id].gas_time = os.time()    --�����ʼ��¼ʱ��
                end
            end
        else
            car_match_sj_lib.user_list[user_id].gas_time = 0                    --���˾Ͱ�CDʱ�����
        end
        --���»ָ�ʱ��
        car_match_sj_db_lib.update_gas_time(user_id, car_match_sj_lib.user_list[user_id].gas_time)
        if (gas_num <= 5) then
            car_match_sj_lib.send_gas_chenge(user_info, add_num)
        end
        car_match_sj_lib.send_team_info(user_info)
    end
    car_match_sj_db_lib.add_gas(user_id, add_num, reason)
end

--����Ƿ�����߻ָ�������(������߸�����ָ�ͻ�����������ָ����͵ļ��ʱ��)
function car_match_sj_lib.add_off_line_gas(user_id)
    local gas_time = car_match_sj_lib.user_list[user_id].gas_time
    local off_time = os.time() - gas_time   --�����ϴλָ���ʱ��
    if (gas_time == 0) then return end      --�ָ�ʱ��Ϊ0˵������ֵ�������ô���

    if (off_time < car_match_sj_lib.CFG_GAS_TIME) then      --����ʱ�仹����һ�λָ�ʱ��
        --��������һ�¿��Ա�֤��Ҳ���ʱ�����˸����������ͽ���������ֵ������˲����ٳ��ֵ���ʱ
        if (car_match_sj_lib.user_list[user_id].gas_num >= car_match_sj_lib.CFG_GAS_MAX) then
            car_match_sj_lib.user_list[user_id].gas_time = 0
            car_match_sj_db_lib.update_gas_time(user_id, car_match_sj_lib.user_list[user_id].gas_time) --���»ָ�ʱ��
        end
    elseif (off_time >= car_match_sj_lib.CFG_GAS_TIME) then  --����������ϴλָ��м������
        local num = car_match_sj_lib.CFG_GAS_MAX - car_match_sj_lib.user_list[user_id].gas_num  --���ۿɻָ�����
        if (num <= 0) then          --�����������������ߺ�����������ͽ�������������
            car_match_sj_lib.user_list[user_id].gas_time = 0
        else
            local times = math.floor(off_time / car_match_sj_lib.CFG_GAS_TIME)              --ʵ�ʿɻָ�����
            local shengyu_time = off_time - (times * car_match_sj_lib.CFG_GAS_TIME)         --ʣ�µ�ʱ��
            if (times < num) then   --ʵ�ʿɻָ�С�����ۿɻָ���ȡʵ��
                num = times
                car_match_sj_lib.user_list[user_id].gas_time = os.time() - shengyu_time     --ʣ��ָ�ʱ��
            else
                car_match_sj_lib.user_list[user_id].gas_time = 0;                           --�ָ����˾����
            end
            --������(���ﲻ��ֱ�ӵ������߻ָ��Ľӿ�,���߻ָ��ӿڻ���ĸ���ʱ��)
            car_match_sj_db_lib.add_gas(user_id, num, car_match_sj_lib.gas_reason.huifu)    
            car_match_sj_lib.user_list[user_id].gas_num = car_match_sj_lib.user_list[user_id].gas_num + num
        end
        car_match_sj_db_lib.update_gas_time(user_id, car_match_sj_lib.user_list[user_id].gas_time) --���»ָ�ʱ��
    end
end

--����Ҽӳ��Ӿ���
function car_match_sj_lib.add_team_exp(user_id, old_lv, old_exp, add_exp, reason)
    local user_info = usermgr.GetUserById(user_id)
    local new_lv, new_exp = car_match_sj_lib.get_user_team_lv(old_lv, old_exp + add_exp)
    local curr_exp = new_exp
    if (user_info ~= nil) then --��һ����߾͸����ڴ�
        car_match_sj_lib.user_list[user_id].team_exp = new_exp
        car_match_sj_lib.user_list[user_id].team_lv = new_lv
    end
    if (new_lv == 100 and new_exp > 0) then --99����100������new_exp�ǳ����ľ��飬Ҫ��add_exp�п۳�
        add_exp = add_exp - new_exp
        if (user_info ~= nil) then
            car_match_sj_lib.user_list[user_id].team_exp = 0
        end
        curr_exp = 0
    end
    car_match_sj_db_lib.update_team_exp(user_id, add_exp, curr_exp, new_lv, reason)   --�Ӿ���
end

--������ҳ���
function car_match_sj_lib.add_car_flag(user_id, flag_lv, flag_num, reason)
    local user_info = usermgr.GetUserById(user_id)
    if (user_info ~= nil) then --��һ����߾͸����ڴ�
        local flag_name = "flag"..tostring(flag_lv).."_num"
        local user_flag = car_match_sj_lib.user_list[user_id][flag_name]
        car_match_sj_lib.user_list[user_id][flag_name] = user_flag + flag_num
    end
    car_match_sj_db_lib.add_car_flag(user_id, flag_lv, flag_num, reason)  --�ӳ���
end

--�������Ƿ�Ϊ����
function car_match_sj_lib.check_is_new_player(user_id, call_back)
    car_match_sj_db_lib.get_team_car_info(user_id, function(dt)
        if (#dt == 0) then
            call_back(1)
            return
        else
            call_back(0)
        end
    end)
end

-------------------------------------------ϵͳ�¼�----------------------------------------------------------------
--��ʱ��
function car_match_sj_lib.timer(e)
   
    if(car_match_sj_lib.check_match_room() == 0) then
        return;
    end
	local current_time = e.data.time;
    car_match_sj_lib.current_time = current_time
	local tmp_match_type = 3

	--��������Ч�����Ч������Ҫ֪ͨ�ͻ���
	car_match_sj_lib.send_match_status(tmp_match_type, current_time)

    if car_match_sj_lib.match_start_status[tmp_match_type] == 1 and
        car_match_sj_lib.match_list == nil or car_match_sj_lib.match_list[tmp_match_type] == nil then
        car_match_sj_lib.init_match(tmp_match_type ,current_time)
    else
        car_match_sj_lib.set_proccess(car_match_sj_lib.match_list[tmp_match_type],current_time)
    end
	if car_match_sj_lib.notify_flag > 0 then
		tmp_match_type = car_match_sj_lib.notify_flag
		car_match_sj_lib.notify_flag = 0 --�ȸı�ʶ����ֹ����������ϵķ���Ϣ
		for k,v in pairs (car_match_sj_lib.match_user_list) do
			local user_info = usermgr.GetUserById(v.user_id)
			if user_info ~= nil then
                car_match_sj_lib.send_main_box(user_info, tmp_match_type)
			end
		end
	end

	if (current_time % 10 == 0) then
		for k,v in pairs (car_match_sj_lib.user_list) do
			if (v.user_id ~= nil) then
			    local user_info = usermgr.GetUserById(v.user_id)
			    if user_info == nil then
    				car_match_sj_lib.user_list[k] = nil
                    car_match_sj_lib.match_user_list[k] = nil
			    end
			end
		end
	end
end


--������������
function car_match_sj_lib.restart_server()
    if(car_match_sj_lib.check_match_room() == 0) then
        return;
    end
	--���ݱ�������ҵ�½ʱ���ӱ��ݱ��������Ǯ��
	car_match_sj_db_lib.backup_baoming_table()

	--��ʼ������ǰ��match_id���ڴ���
	car_match_sj_db_lib.init_restart_match_id()

	--��ʼ������ھ�
	car_match_sj_db_lib.init_today_king_list()
end

--����������
function car_match_sj_lib.on_server_start(e)
    --������
    for i = 1, 100 do
        table.insert(car_match_sj_lib.exp_list, car_match_sj_lib.temp_exp_list[i])
    end
    for k, v in pairs (car_match_sj_lib.race_reward) do
        table.insert(car_match_sj_lib.temp_race_reward, k)
    end
    table.sort(car_match_sj_lib.temp_race_reward)
end

--�����Ƿ��Ѿ���ʼ��
function car_match_sj_lib.is_match_start(match_type)
    if (car_match_sj_lib.match_list[match_type] ~= nil and
        car_match_sj_lib.match_list[match_type].proccess >= 1 and
        car_match_sj_lib.match_list[match_type].proccess <= 3) then
        return 1
    else
        return 0
    end
end

------------------------------------------------����Э��--------------------------------------------
cmdHandler =
{
    ["SJCARSTAT"]   = car_match_sj_lib.on_recv_querystatus,         --�ͻ��˲�ѯ�״̬
    ["SJCAROPPL"]   = car_match_sj_lib.on_recv_openpl,              --�򿪻���
    ["CARCLOSE"]    = car_match_sj_lib.on_recv_closepl,             --�رջ���
    ["SJCARJOIN"]   = car_match_sj_lib.on_recv_baoming,             --������
	["SJCAROPJN"]   = car_match_sj_lib.on_recv_openjoin,            --�����������ť
	["SJCARMC"]     = car_match_sj_lib.on_recv_query_match_mc,      --���������
    ["GETGAS"]      = car_match_sj_lib.on_recv_get_gas,             --����ָ�����
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do
    cmdHandler_addons[k] = v
end

eventmgr:addEventListener("timer_second", car_match_sj_lib.timer);
eventmgr:addEventListener("on_server_start", car_match_sj_lib.restart_server);
eventmgr:addEventListener("on_server_start", car_match_sj_lib.on_server_start); 


