
if car_match_sys_ctrl and car_match_sys_ctrl.restart_server then
	eventmgr:removeEventListener("on_server_start", car_match_sys_ctrl.restart_server);
end

if car_match_sys_ctrl and car_match_sys_ctrl.timer then
    eventmgr:removeEventListener("timer_second", car_match_sys_ctrl.timer);
end

if (car_match_sys_ctrl == nil) then
    car_match_sys_ctrl = 
    {
        update_win_info = NULL_FUNC,
        on_round_over = NULL_FUNC,
        restart_server = NULL_FUNC,
        BACK_PRIZE_RATE = 0.05,
        random_win_rate = {  --���ģʽ��Ӯ�ĸ��ʺ�����
            {rate = 60, prize_rate = {0.8, 1.2}},
            {rate = 25, prize_rate = {0, 0.79}},
            {rate = 15, prize_rate = {1.21, 3}},
	    },
        sys_round_info ={{},{}},   --ϵͳ�ܵ���Ӯ��Ϣ
        cur_round_info = {{},{}},  --������Ӯ��Ϣ
    }
end

function car_match_sys_ctrl.init_sys_round_info(match_type)
    local sys_round_info = car_match_sys_ctrl.sys_round_info[match_type]
    sys_round_info.sys_win_gold = 0 --ϵͳӮ����Ǯ
    sys_round_info.sys_lost_gold = 0 --ϵͳ�����Ǯ
    sys_round_info.round_num = 0 --���ֵľ���
    sys_round_info.game_module = 0 --��ǰ��Ϸģʽ
    sys_round_info.ROUND_MAX_WIN = 2000000000  --ϵͳһ�������Ǯ��
end

function car_match_sys_ctrl.init_cur_round_info(match_type)
    local cur_round_info = car_match_sys_ctrl.cur_round_info[match_type]
    cur_round_info.win_info = {0,0,0,0,0,0,0,0} --����ÿ����λӮʱ��ϵͳ��Ӯ��Ϣ
    cur_round_info.win_rate = {0,0,0,0,0,0,0,0} --������
    cur_round_info.total_xiazhu = 0  --��������ע
end
--����������
function car_match_sys_ctrl.restart_server()
    if (tonumber(groupinfo.groupid) ~= 18001) then
		return
    end
    local sql = "select * from car_win_info";
	dblib.execute(sql, function(dt) 
        if (dt and #dt > 0) then
            for i = 1, #dt do
                car_match_sys_ctrl.sys_round_info[i].sys_win_gold = tonumber(dt[i].sys_win_gold)
                car_match_sys_ctrl.sys_round_info[i].sys_lost_gold = tonumber(dt[i].sys_lost_gold)
                car_match_sys_ctrl.sys_round_info[i].game_module = dt[i].game_module
                car_match_sys_ctrl.sys_round_info[i].round_num = dt[i].round_num
            end
            
        end
    end)
    for i = 1, 2 do
        car_match_sys_ctrl.init_cur_round_info(i)
        car_match_sys_ctrl.init_sys_round_info(i)
    end
end

function car_match_sys_ctrl.timer(e)
    if (tonumber(groupinfo.groupid) ~= 18001) then
		return
    end
    local cur_time = e.data.time
    local cur_week = os.date("%w", cur_time)
    local cur_time = os.date("%X", cur_time)
    --ÿ��һ����һ�������һ��������Ϣ
    if (cur_week == "1" and cur_time == "01:00:00") then
        local sql = "update car_win_info set round_num = 0,game_module=0,sys_win_gold='0',sys_lost_gold='0'";
        dblib.execute(sql)
        --�����ڴ��е���Ϣ
        for i = 1, 2 do
            car_match_sys_ctrl.init_cur_round_info(i)
            car_match_sys_ctrl.init_sys_round_info(i)
        end
    end
end
--���µ�����Ӯ
function car_match_sys_ctrl.update_win_info(match_type, win_count, win_type)
    if (win_type ~= car_match_lib.CFG_GOLD_TYPE.XIA_ZHU and win_type ~= car_match_lib.CFG_GOLD_TYPE.BAO_MIN and 
        win_type ~= car_match_lib.CFG_GOLD_TYPE.JIANG_JIN and win_type ~= car_match_lib.CFG_GOLD_TYPE.CAR_WIN and 
        win_type ~= car_match_lib.CFG_GOLD_TYPE.BACK_XIA_ZHU) then
        return
    end
    --����ϵͳ��Ӯ
    local sys_round_info = car_match_sys_ctrl.sys_round_info[match_type]
    if (win_count > 0) then        
        sys_round_info.sys_win_gold = sys_round_info.sys_win_gold + win_count
    else
        sys_round_info.sys_lost_gold = sys_round_info.sys_lost_gold + win_count
    end
    --������¼������ע���
    local cur_round_info = car_match_sys_ctrl.cur_round_info[match_type]
    if (win_type == car_match_lib.CFG_GOLD_TYPE.XIA_ZHU) then
        cur_round_info.total_xiazhu = cur_round_info.total_xiazhu + win_count
    end    
end

--����ϵͳ����Ӯ
function car_match_sys_ctrl.on_round_over(match_type)
    local sys_round_info = car_match_sys_ctrl.sys_round_info[match_type]
    --�������ݿ�
    local sql = "";
    sql = "update car_win_info set sys_lost_gold = '%s', sys_win_gold = '%s' where match_type = %d";
    sql = string.format(sql, sys_round_info.sys_lost_gold, sys_round_info.sys_win_gold, match_type)
    dblib.execute(sql)    
end

--�����������˵Ľ���
function car_match_sys_ctrl.get_car_fajiang_gold(match_type, open_num)
    --�����ܽ���(ÿ�����Ľ����û���ע�Ľ���)
    --���������˷��� 
    local user_id = 0
    --�������˷���
    local all_add_gold = 0
    for i = 1, car_match_lib.CFG_CAR_NUM do
        local add_gold = 0
        user_id = car_match_lib.match_list[match_type].match_car_list[i].match_user_id
        --������NPC
        if  user_id > 0 then
            local xiazhu = car_match_lib.match_list[match_type].match_car_list[i].xiazhu or 0
            local jiacheng = car_match_lib.match_list[match_type].match_car_list[i].jiacheng
            if (i == open_num) then --��һ��ֱ�ӷ���
                --�ھ�����=��ǰ����ע�ܶ�*��ǰ��λ����*�ӳɱ���
                local peilv = car_match_lib.match_list[match_type].match_car_list[i].peilv
                add_gold = xiazhu * peilv * jiacheng * car_match_lib.CFG_BET_RATE[match_type]
                add_gold = math.floor(add_gold)                    		    
            else    --�������η���
                add_gold = xiazhu * jiacheng * car_match_lib.CFG_BET_RATE[match_type]
                add_gold = math.floor(add_gold)                
            end
        end
        all_add_gold = all_add_gold + add_gold
    end
    return all_add_gold
end

--����ע���˷���
function car_match_sys_ctrl.get_xiazhu_fajiang_gold(match_type, open_num)
	--�õ��������ĺ���
    local all_add_gold = 0
	for k,v in pairs (car_match_lib.user_list) do
		if v.match_info[match_type] ~=nil then 
			local bet_info = v.match_info[match_type].bet_info or car_match_lib.CFG_BET_INIT
			local tmp_bet_tab = split(bet_info,",")
			local xiazhu = tonumber(tmp_bet_tab[open_num]) or 0 --����λ����ע���
			if xiazhu > 0 then
				--Ӧ�üӶ���Ǯ
				local add_gold = xiazhu * car_match_lib.CFG_BET_RATE[match_type] * car_match_lib.match_list[match_type].match_car_list[open_num].peilv
				add_gold = math.floor(add_gold)	
                all_add_gold = all_add_gold + add_gold
			end
		end		
    end
    return all_add_gold
end

--���㵱ǰ�ֵĽ�����Ϣ
function car_match_sys_ctrl.calc_round_info(match_type)    
    --����ÿ����λ��ʱ�Ľ�����Ϣ
    local round_info = car_match_sys_ctrl.cur_round_info[match_type]
    for i = 1, car_match_lib.CFG_CAR_NUM do
        --���㳵������Ǯ
        round_info.win_info[i] = round_info.win_info[i] + car_match_sys_ctrl.get_car_fajiang_gold(match_type, i)
        --������ע������Ǯ
        round_info.win_info[i] = round_info.win_info[i] + car_match_sys_ctrl.get_xiazhu_fajiang_gold(match_type, i)
    end
    --���������,  ������λС��
    for i = 1, #round_info.win_info do
        if (round_info.total_xiazhu == 0) then
            round_info.win_rate[i] = 0
        else
            round_info.win_rate[i] = math.ceil(round_info.win_info[i] * 100 / round_info.total_xiazhu) / 100
        end
    end
    return round_info
end

--�ڶ��ֽ�����ʱ������޸�����
function car_match_sys_ctrl.on_process2_end(match_type)
    if (car_match_lib.gm_ctrl[match_type] == 1) then
        return
    end
    --���Ӿ���
    car_match_sys_ctrl.add_round_num(match_type, 1)
    --��ȡ��һ����λ��
    local top_area_id = car_match_sys_ctrl.get_win_num(match_type)
    if (top_area_id < 1 or top_area_id > 8) then
        TraceError("top_area_id Ϊ�Ƿ�ֵ��Ϊɶ?  "..top_area_id)
    end
    --���ϵĵ�һ������
    local org_top_area_id = car_match_lib.match_list[match_type].open_num
    car_match_lib.match_list[match_type].match_car_list[org_top_area_id].mc = car_match_lib.match_list[match_type].match_car_list[top_area_id].mc
    car_match_lib.match_list[match_type].match_car_list[top_area_id].mc = 1
    car_match_lib.match_list[match_type].open_num = top_area_id
    --������Ϣ��0
    car_match_sys_ctrl.init_cur_round_info(match_type)
end

--����gmģʽ
function car_match_sys_ctrl.set_game_module(match_type, game_module)
	car_match_sys_ctrl.sys_round_info[match_type].game_module = game_module
    local sql = "";
    sql = "update car_win_info set game_module = %d where match_type = %d";
    sql = string.format(sql, game_module, match_type)
    dblib.execute(sql)
end

function car_match_sys_ctrl.get_game_module(match_type)
	return car_match_sys_ctrl.sys_round_info[match_type].game_module
end

--���þ���
function car_match_sys_ctrl.add_round_num(match_type, num)
    local sys_round_info = car_match_sys_ctrl.sys_round_info[match_type]
    sys_round_info.round_num = sys_round_info.round_num + num
    local sql = "update car_win_info set round_num = %d where match_type = %d";
    local sql = string.format(sql, sys_round_info.round_num, match_type)
    dblib.execute(sql)
end

--��ȡ����
function car_match_sys_ctrl.get_round_num(match_type)
	local sys_round_info = car_match_sys_ctrl.sys_round_info[match_type]
	return sys_round_info.round_num
end

--ȡ��Ӯ��λ��
function car_match_sys_ctrl.get_win_num(match_type)    
    local round_num = car_match_sys_ctrl.get_round_num(match_type)    
    local round_info = car_match_sys_ctrl.calc_round_info(match_type)
    --��һ�ֽ������ģʽ
    if (round_num ~= 1 and ((round_num - 1) % 5 == 0 or car_match_sys_ctrl.get_game_module(match_type) == 1)) then
        return car_match_sys_ctrl.process_force_mod(match_type, round_info)
    else
        return car_match_sys_ctrl.process_random_mod(match_type, round_info)
    end
end

--���ģʽ
function car_match_sys_ctrl.process_random_mod(match_type, round_info)
    local win_rate_info = car_match_sys_ctrl.random_win_rate
    local win_num = 0   --Ӯ��λ��
    local sum_rate = 0
    for i = 1, #win_rate_info do
        sum_rate = sum_rate + win_rate_info[i].rate
    end
    local random_num = math.random(0, sum_rate)
    sum_rate = 0 
    for i = 1, #win_rate_info do
        sum_rate =  sum_rate + win_rate_info[i].rate
        if (random_num <= sum_rate) then
            local win_num_info = {}
            for j = 1, #round_info.win_rate do
            if (round_info.win_rate[j] >= win_rate_info[i].prize_rate[1] and round_info.win_rate[j] <= win_rate_info[i].prize_rate[2]) then
                    table.insert(win_num_info,  j)
                end
            end
            if (#win_num_info ~= 0) then
                local chose_num = math.random(1,  #win_num_info)
                win_num = win_num_info[chose_num]
            end
            break
        end
    end
    if (win_num == 0) then  --û���ҵ�����ģʽ��λ�ã��ߴ�����ģʽ
        win_num = car_match_sys_ctrl.process_other_mod(match_type, round_info)
    end
    return win_num
end

--ǿ��ģʽ
function car_match_sys_ctrl.process_force_mod(match_type, round_info)
    --��ȡʵ�ʲʳغ����۲ʳ�
    local win_num = 0
    local sys_round_info = car_match_sys_ctrl.sys_round_info[match_type]
    local real_win_gold = sys_round_info.sys_win_gold + sys_round_info.sys_lost_gold
    local need_win_gold = math.floor(sys_round_info.sys_win_gold * 0.05)
    if (real_win_gold / 1.5 > need_win_gold)  then --ǿ���ͷ�
        local win_num_info = {}
        for j = 1, #round_info.win_rate do
            if (round_info.win_rate[j] > 1 and   --�ҵ������ͷֵ�λ��
                round_info.win_info[j] < sys_round_info.ROUND_MAX_WIN) then  --û�г����������ӮǮ��
                table.insert(win_num_info, j)
            end
        end
        if (#win_num_info ~= 0) then
            local chose_num = math.random(1,  #win_num_info)
            win_num = win_num_info[chose_num]
        end
        car_match_sys_ctrl.set_game_module(match_type, 1)
    elseif (real_win_gold / 1.2 < need_win_gold)  then --ǿ��ɱ��
        local lost_num_info = {}
        for j = 1, #round_info.win_rate do
            if (round_info.win_rate[j]  < 1 and   --�ҵ�����ɱ�ֵ�λ��
                round_info.win_info[j] < sys_round_info.ROUND_MAX_WIN) then  --û�г����������ӮǮ��
                table.insert(lost_num_info, j)
            end
        end
        if (#lost_num_info ~= 0) then
            local chose_num = math.random(1,  #lost_num_info)
            win_num = lost_num_info[chose_num]
        end
        car_match_sys_ctrl.set_game_module(match_type, 1)
    else  --����ǿ�Ƴ���ɱ���ˣ������ģʽ
        car_match_sys_ctrl.set_game_module(match_type, 0)
        win_num = car_match_sys_ctrl.process_random_mod(match_type, round_info)
    end
    --���е�������߲�ͨ
    if ( win_num == 0) then
        win_num = car_match_sys_ctrl.process_other_mod(match_type, round_info)
    end
    return win_num
end

--������ģʽ
function car_match_sys_ctrl.process_other_mod(match_type, round_info)
    local sys_round_info = car_match_sys_ctrl.sys_round_info[match_type]
    local random_num = math.random(1, 8)
    if (round_info.win_info[random_num] < sys_round_info.ROUND_MAX_WIN) then  --û�г����������ӮǮ��
        return random_num
    end
    for j = 1, #round_info.win_rate do
        if (round_info.win_info[j] < sys_round_info.ROUND_MAX_WIN) then  --û�г����������ӮǮ��
            return j
        end
    end
    return 1
end

eventmgr:addEventListener("on_server_start", car_match_sys_ctrl.restart_server);
eventmgr:addEventListener("timer_second", car_match_sys_ctrl.timer);

