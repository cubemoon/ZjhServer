TraceError("init car_shop...")

if not car_shop_lib then
    car_shop_lib = _S
    {

        --[[
            ����  5043
            ����  5013
            ����  5022 
            ����  5019
            ����  5031
            ��������  5032
            ��ľ�°��� 5034
            ѩ����  5018
            ����  5030
            �߶���  5046
            ����˹  5033
            
            ------------------------
            �׿ǳ�  5012
            Ӣ�����G  5047
            �ݱ�XF  5048
            -------------------------
            ����Z4  5049
            �µ�  5011
            ��ɯ����  5021
            ����  5017
            ------------------------
            ������  5024
            ����Ľ��  5050
            ��ʱ�� 5025            
            ------------------------
            ��������  5026
            ����   5038
            Zenvo  5037
            ���ӵ�  5027
            �ƽ𲼼ӵ�  5036
        --]]
		--����  
        CAR_LIST =  --���г�������
        {
            {5043,5013,5022,5019,5018,5051,5046},   --��ͨ
            {5012,5047,5048},   --����
            {5049,5011,5021,5017,},   --���
            {5024, 5050,5025},        --ϡ��
            {5026,5038,5037,5027,5036},   --����
        }
    }
end

function car_shop_lib.is_vaild_shop_car(car_type)
    for i = 1, #car_shop_lib.CAR_LIST do
        for j = 1, #car_shop_lib.CAR_LIST[i] do
            if (car_shop_lib.CAR_LIST[i][j] == car_type) then
                return 1, i
            end
        end
    end
    return 0, 0
end

function car_shop_lib.on_recv_car_list(buf)
    local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
    local flag_type = buf:readByte()
    if (flag_type < 1 or flag_type > #car_shop_lib.CAR_LIST) then
        TraceError("��������")
        return
    end
    netlib.send(function(buf) 
        buf:writeString("CARSPLS")
        local car_num = #car_shop_lib.CAR_LIST[flag_type]
        buf:writeInt(flag_type)
        buf:writeInt(car_num)
        for i = 1, car_num do
            local car_type = car_shop_lib.CAR_LIST[flag_type][i]
            buf:writeInt(car_type)
            local can_buy = car_shop_lib.can_buy_car(user_info, car_type, flag_type)
            buf:writeInt(car_match_lib.CFG_CAR_INFO[car_type].need_level)
            buf:writeInt(car_match_lib.CFG_CAR_INFO[car_type].need_gold)
            buf:writeInt(car_match_lib.CFG_CAR_INFO[car_type].need_flag[flag_type])
            buf:writeInt(can_buy)            
        end
    end, user_info.ip, user_info.port)    
end

function car_shop_lib.can_buy_car(user_info, car_type, flag_type)
    local user_id = user_info.userId
    local need_gold = car_match_lib.CFG_CAR_INFO[car_type].need_gold
    --���Ǯ�Ƿ�
    local user_gold = get_canuse_gold(user_info)
    if (user_gold < need_gold) then
        return -1
    end
    --�����Ƿ�
    local flag_num = car_match_sj_lib.user_list[user_id]["flag"..flag_type.."_num"]
    local need_flag_num = car_match_lib.CFG_CAR_INFO[car_type].need_flag[flag_type]
    if (flag_num < need_flag_num) then
        return -2
    end
    --���Ӿ����Ƿ�
    if (car_match_sj_lib.user_list[user_id].team_lv < car_match_lib.CFG_CAR_INFO[car_type].need_level) then
        return -3
    end
    return 1
end
function car_shop_lib.on_recv_car_exchange(buf)
    local user_info = userlist[getuserid(buf)];
    if not user_info then return end;
    local user_id = user_info.userId
    local car_type = buf:readInt() --��Ҫ�һ��ĳ�
    local ret, flag_type = car_shop_lib.is_vaild_shop_car(car_type)
    if (ret == 0 or car_match_lib.CFG_CAR_INFO[car_type] == nil) then
        TraceError("on_recv_car_exchange �Ƿ��ĳ�  "..car_type.."  "..user_info.userId)
        return
    end
    local send_ret = function(ret)
        netlib.send(function(buf)
            buf:writeString("CARSPEC")
            buf:writeInt(ret)
            buf:writeInt(car_type)
            buf:writeInt(flag_type)
        end, user_info.ip, user_info.port)
    end
    local ret = car_shop_lib.can_buy_car(user_info, car_type, flag_type)
    if (ret < 0) then
        send_ret(ret)
        return
    end
    local need_flag_num = car_match_lib.CFG_CAR_INFO[car_type].need_flag[flag_type]
    local need_gold = car_match_lib.CFG_CAR_INFO[car_type].need_gold
    --�۳��꣬��Ǯ
    car_match_sj_lib.add_car_flag(user_info.userId, flag_type, -need_flag_num, car_match_sj_lib.gas_reason.buy)
    usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_BUY, -1)
    --�ӳ�
    car_match_db_lib.add_car(user_info.userId, car_type, 0, 1)
    car_match_sj_lib.send_team_info(user_info)
    --��¼�һ���־
    car_shop_db_lib.record_exchange_log(user_info.userId, car_type, 1)
    send_ret(1)
end

------------------------------------------------����Э��--------------------------------------------
cmdHandler =
{
    ["CARSPLS"] = car_shop_lib.on_recv_car_list,                --�����ȡ�����б�    
    ["CARSPEC"] = car_shop_lib.on_recv_car_exchange,            --����һ�����
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do
    cmdHandler_addons[k] = v
end

--eventmgr:addEventListener("timer_second", car_match_lib.timer);
--eventmgr:addEventListener("on_server_start", car_match_lib.restart_server);
--eventmgr:addEventListener("gm_cmd", car_match_lib.gm_cmd)

