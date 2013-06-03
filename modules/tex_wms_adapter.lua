TraceError("init tex_wms_adapter_lib....")

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_after_user_login) then
    eventmgr:removeEventListener("h2_on_user_login", tex_wms_adapter_lib.on_after_user_login)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.timer) then
    eventmgr:removeEventListener("timer_second", tex_wms_adapter_lib.timer);
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.after_get_props_list) then
    eventmgr:removeEventListener("after_get_props_list", tex_wms_adapter_lib.after_get_props_list)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_game_over_event) then
    eventmgr:removeEventListener("game_event_ex", tex_wms_adapter_lib.on_game_over_event)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_user_add_gold) then
    eventmgr:removeEventListener("on_user_add_gold", tex_wms_adapter_lib.on_user_add_gold)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_get_safe_gold_info) then
    eventmgr:removeEventListener("on_get_safebox_info", tex_wms_adapter_lib.on_get_safe_gold_info)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_get_safe_gold_change) then
    eventmgr:removeEventListener("on_safebox_sq", tex_wms_adapter_lib.on_get_safe_gold_change)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.restart_server) then
    eventmgr:removeEventListener("on_server_start", tex_wms_adapter_lib.restart_server)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_after_init_car) then
    eventmgr:removeEventListener("finish_init_car", tex_wms_adapter_lib.on_after_init_car)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_after_init_parking) then
    eventmgr:removeEventListener("already_init_parking", tex_wms_adapter_lib.on_after_init_parking)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_after_init_yinpiao) then
    eventmgr:removeEventListener("already_init_yinpiao", tex_wms_adapter_lib.on_after_init_yinpiao)
end

if (tex_wms_adapter_lib and tex_wms_adapter_lib.on_user_change_coupon) then
    eventmgr:removeEventListener("on_user_change_coupon", tex_wms_adapter_lib.on_user_change_coupon)
end


tex_wms_adapter_lib = tex_wms_adapter_lib or {}
tex_wms_adapter_lib.gift_cfg = 
        {
            
            [0] = "����",
            [1] = "���˿�",
            [2] = "ȫ������",
            [3] = "�����ʸ�֤��",
            [4] = "����",
            [5] = "�̻�",
            [6] = "����",
            [7] = "��������Ʊ",
            [8] = "�����ɿ���",
            [9] = "�ر�ͼ",  
            [10] = "��ʯ��ȯ",
            [14] = "ľ����",
            [15] = "������",
            [16] = "ͭ����",
            [17] = "������",
            [18] = "����",
            [19] = "�������",
            [20] = "һƿơ��",
            [21] = "��ե��֭",
            [22] = "һС����ʳ",
            [23] = "��õ��",
            [24] = "��õ��",
            [25] = "��ˮ��",
            [26] = "������",
            [27] = "��ʿ���",
            [28] = "׼�о����",
            [29] = "�о����",
            [30] = "�Ӿ����",
            [31] = "�������",
            [32] = "������",
            [33] = "�������",
            [34] = "�������",
            [35] = "�������",
            [36] = "��λ��ë" ,
            [998]  = "��������Ʊ",
            [999]  = "��������Ʊ",
            [1000] = "���������",
            [1001] = "�ʤι�֭",
            [1002] = "��ʽ����",
            [1003] = "����",
            [1004] = "ơ��",
            [1005] = "�ú���",
            [1006] = "��β��",
            [1007] = "����",
            [1008] = "��ʿ��",
            [1009] = "��������",
            [1010] = "������˹",
            [2001] = "��񿾼���",
            [2002] = "����С����",
            [2003] = "���¸��",
            [2004] = "��ζ����",
            [2005] = "��ζ����",
            [2006] = "��ζ���Ĥ",
            [2007] = "����",
            [2008] = "�ɿ�������",
            [2009] = "��������˾",
            [2010] = "������",
            [3001] = "ѩ��",
            [3002] = "����",
            [3003] = "��ʽˮ��",
            [3004] = "ZIPPO",
            [4001] = "õ��",
            [4002] = "���շ�",
            [4003] = "�������",
            [4004] = "�в�����",
            [4005] = "�й�����",
            [4006] = "�в�è",
            [4007] = "�вƽ���",
            [4008] = "һ����˳",
            [4009] = "�޵�������",
            [4010] = "���µ�һ��",
            [4011] = "��ʿ",
            [4012] = "��������",
            [4013] = "������",
            [4014] = "������",
            [4015] = "�ʹ�",
            [4016] = "��»˫ȫ",
            [4017] = "����ͼ",
            [4018] = "���ƻ����",
            [4019] = "������ʹ",
            [4020] = "��ħ",
            [4021] = "С����",
            [4022] = "������",
            [4026] = "����˧��",
            [4027] = "������Ů",
            [5001] = "����ʯ",
            [5002] = "�̱�ʯ",
            [5003] = "�Ʊ�ʯ",
            [5004] = "�챦ʯ",
            [5005] = "�ڱ�ʯ",
            [5006] = "����֮��",
            [9001] = "ʥ�����˵ĳ�����",
            [9002] = "��ɫ��ñ",
            [9003] = "��ɫ��ñ",
            [9004] = "��������-����",
            [9005] = "��������-����",
            [9006] = "��������-��Ԫ��",
            [9007] = "�����",
            [9008] = "������˱�־",
            [9009] = "��������ѫ��",
            [9010] = "�м�����ѫ��",
            [9011] = "�߼�����ѫ��",
            [9012] = "ʥ��������",
            [9013] = "ʥ��������",
            [9014] = "����������",
            [9015] = "�������������",
            [4023] = "�ع�",
            [4024] = "������",
            [4025] = "��«��",
            [5007] = "���������",
            [5008] = "����������",
            [5009] = "����������",
            [5010] = "����һ����",
            [5014] = "���˷�����",
            [5015] = "���˷�����",
            [5016] = "���˷�����",
            [5035] = "����ѫ��",
            [5020] = "����LV��",
            [5013] = "����",
            [5022] = "���� QQ3",
            [5019] = "���� N5",
            [5018] = "ѩ���� C2",
            [5012] = "�׿ǳ�",
            [5011] = "�µ�A8L",
            [5017] = "����S600",
            [5021] = "��ɯ���� �ܲ�",
            [5024] = "������ 599",
            [5025] = "��ʱ�� Panamera",
            [5026] = "�������� Aventador",
            [5027] = "���ӵ����� ����",
            [5030] = "��������ʿ1.6GS",
            [5031] = "������ 1.0L",
            [5032] = "��������M5 1.3L",
            [5033] = "����˹2.0L",
            [5034] = "��ľ�°���1.0L",
            [5036] = "���ӵ����� ����(�ƽ��)",
            [5037] = "Zenvo  ST1",
            [5038] = "���� 2-Eleven",
            [5039] = "�������������������",
            [5040] = "��ʱ�ݵ�����������",
            [5041] = "������������������",
            [5042] = "���س�",
            [5044] = "���������г�",
            [5045] = "��������г�",
            [5043] = "�������",
            [5046] = "�߶���",
            [5047] = "Ӣ�����G",
            [5048] = "�ݱ�XF",
            [5049] = "����Z4",
            [5050] = "����Ľ��",
            [5051] = "��³��",
            [5023] = "��ͧ",
            [9023] = "�ھ�������ָ",
            [61001] = "¶�쳵��1",
            [62001] = "���³���1",
            [63001] = "˽�ҳ���1",
            [64001] = "˽����ͧ1",
            [9016] = "��������",
            [9017] = "�촽����",
            [9018] = "Ĺ��",
            [9019] = "����",
            [9020] = "ľ����",
            [9021] = "Ұ��",
            [9022] = "����girl",
            [9024] = "�Ը���Ů",
            [9025] = "ˮ����Ů",
            [5028] = "��������",
            [5029] = "�ƽ�����",
            [5301] = "����ף��",
            [5302] = "����ף��",
            [5303] = "����ף��",
            [100020] = "����ף��ͼֽ",
            [100021] = "����ף��ͼֽ",
            [100022] = "����ף��ͼֽ",
            [100100] = "�ϰ���ͼֽ",
            [100101] = "��ѩ����C2ͼֽ",
            [100102] = "�ϼ׿ǳ�ͼֽ",
            [100103] = "����ɯ����ͼֽ",
            [100104] = "�Ϸ�����ͼֽ",
            [100105] = "����ͼֽ1",
            [100106] = "����ͼֽ2",
            [100107] = "����ͼֽ3",
            [100108] = "ѩ����ͼֽ",
            [100109] = "�׿ǳ�ͼֽ",
            [100110] = "��ɯ����ͼֽ",
            [100111] = "������ͼֽ",
            [100112] = "��������ͼֽ",
            [100113] = "���ӵ�����ͼֽ",
            [100114] = "���ӵ�����(�ƽ��)ͼֽ",
            [100115] = "���س�ͼֽ",
            [100116] = "���������г�ͼֽ",
            [100117] = "��������г�ͼֽ",
            [100118] = "����õ����о���",
            [100119] = "�ݻ�������о���",
            [200001] = "�ͷ׵��ߺ�",
            [200002] = "��ͨ���ھ�����",
            [200003] = "�������ھ�����",
            [200004] = "ͭ����",
            [200005] = "������",
            [200006] = "����",
            [200007] = "ĩ�տ���",
            [200008] = "Ȫˮ",
            [200009] = "���",
            [200010] = "��ʯ��",
            [200011] = "������",
            [200012] = "�����",
            [200013] = "��Կ��",
            [200014] = "����õ�����",
            [200015] = "�ݻ��������",            
            [200016] = "����Կ��",
						[200017] = "�ƽ�Կ��",					
						[200018] = "ˮ��Կ��",
						[200019] = "��ͨ�����", 
						[200020] = "���������", 
						[200021] = "�ƽ������", 
						[200022] = "�ٱ���߿�", 
						[200027] = "�ɳ�ѫ��",          
        }
tex_wms_adapter_lib.gift_cfg_buy_sell = {
            [1001] = "�ʤι�֭",
            [1002] = "��ʽ����",
            [1003] = "����",
            [1004] = "ơ��",
            [1005] = "�ú���",
            [1006] = "��β��",
            [1007] = "����",
            [1008] = "��ʿ��",
            [1009] = "��������",
            [1010] = "������˹",
            [2001] = "��񿾼���",
            [2002] = "����С����",
            [2003] = "���¸��",
            [2004] = "��ζ����",
            [2005] = "��ζ����",
            [2006] = "��ζ���Ĥ",
            [2007] = "����",
            [2008] = "�ɿ�������",
            [2009] = "��������˾",
            [2010] = "������",
            [3001] = "ѩ��",
            [3002] = "����",
            [3003] = "��ʽˮ��",
            [3004] = "ZIPPO",
            [4001] = "õ��",
            [4002] = "���շ�",
            [4003] = "�������",
            [4004] = "�в�����",
            [4005] = "�й�����",
            [4006] = "�в�è",
            [4007] = "�вƽ���",
            [4008] = "һ����˳",
            [4009] = "�޵�������",
            [4010] = "���µ�һ��",
            [4011] = "��ʿ",
            [4012] = "��������",
            [4013] = "������",
            [4014] = "������",
            [4015] = "�ʹ�",
            [4016] = "��»˫ȫ",
            [4017] = "����ͼ",
            [4018] = "���ƻ����",
            [4019] = "������ʹ",
            [4020] = "��ħ",
            [4021] = "С����",
            [4022] = "������",
            [4026] = "����˧��",
            [4027] = "������Ů",
            [5001] = {"����ʯ",10000,9500},
            [5002] = {"�̱�ʯ",50000,4750},
            [5003] = {"�Ʊ�ʯ",100000,95000},
            [5004] = {"�챦ʯ",500000,47500},
            [5005] = {"�ڱ�ʯ",1000000,950000},
            [5006] = "����֮��",
            [9001] = "ʥ�����˵ĳ�����",
            [9002] = "��ɫ��ñ",
            [9003] = "��ɫ��ñ",
            [9004] = "��������-����",
            [9005] = "��������-����",
            [9006] = "��������-��Ԫ��",
            [9007] = "�����",
            [9008] = "������˱�־",
            [9009] = "��������ѫ��",
            [9010] = "�м�����ѫ��",
            [9011] = "�߼�����ѫ��",
            [9012] = "ʥ��������",
            [9013] = "ʥ��������",
            [9014] = "����������",
            [9015] = "�������������",
            [4023] = "�ع�",
            [4024] = "������",
            [4025] = "��«��",
            [5007] = "���������",
            [5008] = "����������",
            [5009] = "����������",
            [5010] = "����һ����",
            [5014] = "���˷�����",
            [5015] = "���˷�����",
            [5016] = "���˷�����",
            [5035] = "����ѫ��",
            [5020] = "����LV��",
            [5013] = "����",
            [5022] = "���� QQ3",
            [5019] = "���� N5",
            [5018] = "ѩ���� C2",
            [5012] = "�׿ǳ�",
            [5011] = "�µ�A8L",
            [5017] = "����S600",
            [5021] = "��ɯ���� �ܲ�",
            [5024] = "������ 599",
            [5025] = "��ʱ�� Panamera",
            [5026] = "�������� Aventador",
            [5027] = "���ӵ����� ����",
            [5030] = "��������ʿ1.6GS",
            [5031] = "������ 1.0L",
            [5032] = "��������M5 1.3L",
            [5033] = "����˹2.0L",
            [5034] = "��ľ�°���1.0L",
            [5036] = "���ӵ����� ����(�ƽ��)",
            [5037] = "Zenvo  ST1",
            [5038] = "���� 2-Eleven",
            [5039] = "�������������������",
            [5040] = "��ʱ�ݵ�����������",
            [5041] = "������������������",
            [5042] = "���س�",
            [5044] = "���������г�",
            [5045] = "��������г�",
            [5043] = "�������",
            [5046] = "�߶���",
            [5047] = "Ӣ�����G",
            [5048] = "�ݱ�XF",
            [5049] = "����Z4",
            [5050] = "����Ľ��",
            [5051] = "��³��",
            [5023] = "��ͧ",
            [9023] = "�ھ�������ָ",
            [61001] = "¶�쳵��1",
            [62001] = "���³���1",
            [63001] = "˽�ҳ���1",
            [64001] = "˽����ͧ1",
            [9016] = "��������",
            [9017] = "�촽����",
            [9018] = "Ĺ��",
            [9019] = "����",
            [9020] = "ľ����",
            [9021] = "Ұ��",
            [9022] = "����girl",
            [9024] = "�Ը���Ů",
            [9025] = "ˮ����Ů",
            [5028] = "��������",
            [5029] = "�ƽ�����",
            [1] = {"���˿�",0},
            [2] = {"ȫ������",0},
            [3] = "�����ʸ�֤��",
            [4] = "����",
            [5] = "�̻�",
            [6] = "����",
            [7] = "��������Ʊ",
            [8] = "�����ɿ���",
            [9] = "�ر�ͼ",
            [5301] = "����ף��",
            [5302] = "����ף��",
            [5303] = "����ף��",
            [14] = "ľ����",
            [15] = "������",
            [16] = "ͭ����",
            [17] = "������",
            [18] = "����",
            [19] = "�������",
            [20] = "һƿơ��",
            [21] = "��ե��֭",
            [22] = "һС����ʳ",
            [23] = "��õ��",
            [24] = "��õ��",
            [25] = "��ˮ��",
            [26] = "������",
            [100020] = "����ף��ͼֽ",
            [100021] = "����ף��ͼֽ",
            [100022] = "����ף��ͼֽ",
            [100100] = "�ϰ���ͼֽ",
            [100101] = "��ѩ����C2ͼֽ",
            [100102] = "�ϼ׿ǳ�ͼֽ",
            [100103] = "����ɯ����ͼֽ",
            [100104] = "�Ϸ�����ͼֽ",
            [100105] = "�ϱ�ʱ��ͼֽ",
            [100106] = "����������ͼֽ",
            [100107] = "����ͼֽ",
            [100108] = "ѩ����ͼֽ",
            [100109] = {"�׿ǳ�ͼֽ",88000},
            [100110] = {"��ɯ����ͼֽ",580000},
            [100111] = {"������ͼֽ",880000},
            [100112] = {"��������ͼֽ",2880000},
            [100113] = {"���ӵ�����ͼֽ",5880000},
            [100114] = {"���ӵ�����(�ƽ��)ͼֽ",8880000},
            [100115] = {"���س�ͼֽ",88880000},
            [100116] = "���������г�ͼֽ",
            [100117] = "��������г�ͼֽ",
            [100118] = "����õ����о���",
            [100119] = "�ݻ�������о���",
            [200001] = {"�ͷ׵��ߺ�",58800},
            [200002] = "��ͨ���ھ�����",
            [200003] = "�������ھ�����",
            [200004] = "ͭ����",
            [200005] = "������",
            [200006] = "����",
            [200007] = "ĩ�տ���",
            [200008] = "Ȫˮ",
            [200009] = "���",
            [200010] = "��ʯ��",
            [200011] = "������",
            [200012] = "�����",
            [200013] = "��Կ��",
            [200014] = "����õ�����",
            [200015] = "�ݻ��������",
            [200016] = "����Կ��",
						[200017] = "�ƽ�Կ��",					
						[200018] = "ˮ��Կ��",            
						[200027] = "�ɳ�ѫ��",
            [10] = "��ʯ��ȯ",
            [0] = "����",  
        }
tex_wms_adapter_lib.gold_type = tex_wms_adapter_lib.gold_type or {}
tex_wms_adapter_lib.last_unique_num = 0 --��һ�ε�Ψһ�������ڴ���Ψһ����
tex_wms_adapter_lib.last_clock = 1 --��һ�κ�����
tex_wms_adapter_lib.max_pay_id = 200000000000
tex_wms_adapter_lib.max_user_id = 200000000000
tex_wms_adapter_lib.process_pay_ok = 1
tex_wms_adapter_lib.process_user_reg_ok = 1
tex_wms_adapter_lib.reg_site = tex_wms_adapter_lib.reg_site or {} --�û����Եط�



function tex_wms_adapter_lib.restart_server(e)    
    for k, v in pairs(hall.gold_type) do
        tex_wms_adapter_lib.gold_type[v.id] = v.des
    end
    local sql = "select * from reg_site"
    dblib.execute(sql, function(dt)
        if (dt and #dt > 0) then
            for k, v in pairs(dt) do
                tex_wms_adapter_lib.reg_site[v.site_no] = v.site_name
            end
        end
    end)
    
end

--��ȡϵͳ����
function tex_wms_adapter_lib.get_day(time)
    return os.date("%Y_%m_%d", time or os.time())
end

function tex_wms_adapter_lib.lua_to_oracle_time(lua_time)
    return os.date("%Y%m%d%H%M%S", lua_time or os.time())
end

--�û���½
function tex_wms_adapter_lib.on_after_user_login(e)
    local cur_time = os.time()
    local user_info = e.data["user_info"]
    --�����û���Ϣ
    local user_nick = " "
    if (user_info.nick ~= "") then
        user_nick = user_info.nick
    end
    local sql = "select sys_time, reg_site_no, reg_ip from users where id = %d"
    sql = string.format(sql, user_info.userId)
    dblib.execute(sql, function(dt)
        --��ȡ�û�ע��ʱ��
        local reg_time = tex_wms_adapter_lib.lua_to_oracle_time(cur_time)
        if (dt and #dt > 0) then
            reg_time = tex_wms_adapter_lib.lua_to_oracle_time(tonumber(timelib.db_to_lua_time(dt[1].sys_time)))
        end
        local reg_site_name = tex_wms_adapter_lib.reg_site[dt[1].reg_site_no] or dt[1].reg_site_no
        local reg_ip = dt[1].reg_ip
        if (reg_ip == " ") then
            reg_ip = " "
        end
        sql = "insert into tex_wms.dozen_pub_dz_player_%s(playerid,playername,createtm,regip,activation,\
                lastgametm,lastloginip,passport,platformid,platformname)values(%d,'%s','%s','%s',%d,'%s','%s','%s','%s','%s')"
        sql = string.format(sql, tex_wms_adapter_lib.get_day(), user_info.userId, user_nick, 
                            reg_time, reg_ip, 1, tex_wms_adapter_lib.lua_to_oracle_time(cur_time), 
                            user_info.ip, user_info.passport or " ", dt[1].reg_site_no, reg_site_name)
        dblib.execute(sql)        
        --�����û�������Ϣ
        local user_gift_info = deskmgr.getuserdata(user_info).giftinfo or {}
        if (#user_gift_info > 0) then
            sql = "insert into tex_wms.dozen_pub_dz_playergools_%s(playerid,playername,goolsid,goolsname,gameqty,\
                        reltime)values(%d,'%s',%d,'%s',%d,'%s')"
            local gift_info = {}
            for k, v in pairs(user_gift_info) do            
                if (gift_info[v.id] == nil) then
                    gift_info[v.id] = {count = 0, name = " "}
                end
                gift_info[v.id].count = gift_info[v.id].count + 1
                gift_info[v.id].name = tex_wms_adapter_lib.gift_cfg[v.id] or v.id                
            end
            local user_nick = " "
            if (user_info.nick ~= "") then
                user_nick = user_info.nick
            end            
            for k, v in pairs(gift_info) do
                local sql_info = string.format(sql, tex_wms_adapter_lib.get_day(), user_info.userId, 
                                               user_nick, k, _U(v.name), v.count, tex_wms_adapter_lib.lua_to_oracle_time())
                dblib.execute(sql_info)
            end
        end
        --�����û�������Ϣ
        local gift_info = {}
        gift_info[0] = {count = user_info.gamescore, name = tex_wms_adapter_lib.gift_cfg[0]}
        for k, v in pairs(gift_info) do
            local sql_info = string.format(sql, tex_wms_adapter_lib.get_day(), user_info.userId, 
                                           user_nick, k, _U(v.name), v.count, tex_wms_adapter_lib.lua_to_oracle_time())
            dblib.execute(sql_info)
        end
    end)
    --�����û�����
    local gift_info = {}
    gift_info[0] = {count = user_info.gamescore, name = tex_wms_adapter_lib.gift_cfg[0]}
    for k, v in pairs(gift_info) do
        local sql_info = string.format(sql, tex_wms_adapter_lib.get_day(), user_info.userId, 
                                       user_nick, k, _U(v.name), v.count, tex_wms_adapter_lib.lua_to_oracle_time())
        dblib.execute(sql_info)
    end
end

--�����û�������Ϣ
function tex_wms_adapter_lib.after_get_props_list(e)
    --�����û�������Ϣ    
    local user_info = usermgr.GetUserById(e.data["user_id"])
    if (user_info == nil) then
        return
    end
    local user_prop_info = user_info.propslist or {}
    if (#user_prop_info > 0) then
        sql = "insert into tex_wms.dozen_pub_dz_playergools_%s(playerid,playername,goolsid,goolsname,gameqty,\
                    reltime)values(%d,'%s',%d,'%s',%d,'%s')"
        local prop_info = {}
        for k, v in pairs(user_prop_info) do            
            if (prop_info[k] == nil and v ~= 0) then
                prop_info[k] = {count = v, name = tex_wms_adapter_lib.gift_cfg[k] or k}
            end
        end
        local user_nick = " "
        if (user_info.nick ~= "") then
            user_nick = user_info.nick
        end
        for k, v in pairs(prop_info) do
            local sql_info = string.format(sql, tex_wms_adapter_lib.get_day(), user_info.userId, 
                                           user_nick, k, _U(v.name), v.count, 
                                           tex_wms_adapter_lib.lua_to_oracle_time())
            dblib.execute(sql_info)
        end
    end
end


function tex_wms_adapter_lib.on_after_init_car(e)
    local user_id = e.data["user_id"]
    if (user_id  == nil) then
        return
    end
    sql = "insert into tex_wms.dozen_pub_dz_playergools_%s(playerid,playername,goolsid,goolsname,gameqty,\
                    reltime)values(%d,'%s',%d,'%s',%d,'%s')"
    local gift_info = {}
    if car_match_lib.user_list[user_id].car_list then
      for k, v in pairs(car_match_lib.user_list[user_id].car_list) do            
          if (gift_info[v.car_type] == nil) then
              gift_info[v.car_type] = {count = 0, name = " "}
          end
          gift_info[v.car_type].count = gift_info[v.car_type].count + 1
          gift_info[v.car_type].name = tex_wms_adapter_lib.gift_cfg[v.car_type] or v.car_type
      end
    local user_nick = " "
      local user_info = usermgr.GetUserById(user_id)
      if (user_info ~= nil and user_info.nick ~= "") then
          user_nick = user_info.nick
      end
      for k, v in pairs(gift_info) do
       
          local sql_info = string.format(sql, tex_wms_adapter_lib.get_day(), user_id, 
                                         user_nick, k, _U(v.name), v.count, tex_wms_adapter_lib.lua_to_oracle_time())
          dblib.execute(sql_info)
        
    end
  end
   
end


function tex_wms_adapter_lib.on_after_init_parking(e)
      --��¼��λ��Ϣ
    local parking_info = {}
    local parking_data = parkinglib.user_list[e.data.user_id]
    local parking_list = parking_data.parking_list
    local user_nick = " "
    local user_id = e.data.user_id
    local user_info = usermgr.GetUserById(user_id)
    if (user_info ~= nil and user_info.nick ~= "") then
        user_nick = user_info.nick
    end
    local tb_car_type = {61001,62001,63001,64001}
    sql = "insert into tex_wms.dozen_pub_dz_playergools_%s(playerid,playername,goolsid,goolsname,gameqty,\
                    reltime)values(%d,'%s',%d,'%s',%d,'%s')"
    for k,v in pairs (parking_list) do
      if v.parking_count and  v.parking_count > 0 then
        local sql2 = string.format(sql, tex_wms_adapter_lib.get_day(), user_id, 
                         user_nick, tb_car_type[k], _U(tex_wms_adapter_lib.gift_cfg[tb_car_type[k]]), v.parking_count, tex_wms_adapter_lib.lua_to_oracle_time())
        dblib.execute(sql2)
      end
    end
end

function tex_wms_adapter_lib.on_after_init_yinpiao(e)
     --��¼��λ��Ϣ
    local user_nick = " "
    local user_id = e.data.user_id
    local user_info = daxiao_hall.get_user_info(user_id)
    if (user_info ~= nil and user_info.nick ~= "") then
        user_nick = user_info.nick
    end
    local yinpiao_count = e.data.yinpiao_count
    local ex_yinpiao_count = e.data.ex_yinpiao_count
    sql = "insert into tex_wms.dozen_pub_dz_playergools_%s(playerid,playername,goolsid,goolsname,gameqty,\
                reltime)values(%d,'%s',%d,'%s',%d,'%s')"
    
    local sql1 = string.format(sql, tex_wms_adapter_lib.get_day(), user_id, 
                     user_nick, 999, _U(tex_wms_adapter_lib.gift_cfg[999]), yinpiao_count, tex_wms_adapter_lib.lua_to_oracle_time())
    dblib.execute(sql1)
    
    local sql1 = string.format(sql, tex_wms_adapter_lib.get_day(), user_id, 
                     user_nick, 998, _U(tex_wms_adapter_lib.gift_cfg[998]), ex_yinpiao_count, tex_wms_adapter_lib.lua_to_oracle_time())
    dblib.execute(sql1)
    
end
function tex_wms_adapter_lib.on_user_change_coupon(e)
    local businessname = "��ȯ����"
    local user_id =  e.data["user_id"]
    local to_user_id =  e.data["to_user_id"] or user_id
    local add_gool_id = e.data["gools_id"] or 0 
    local add_gool_num = e.data["gift_count"]
    local bet_count = e.data["smallbet"] or " "
    local coupon_num = e.data["coupon_num"]
    if not tex_wms_adapter_lib.gift_cfg_buy_sell[add_gool_id][2] then
        TraceError("��ȯ�̳Ǹ���Ʒû�����ø���Ʒ��ֵ�������ã�лл����")
        TraceError(debug.traceback())
    end  
    local billcode = tex_wms_adapter_lib.get_unique_code()
    --д����
    local businessid = _U(hall.gold_type.COUPON_SYS.id..add_gool_id) or " "
    local businessname =  _U(hall.gold_type.COUPON_SYS.des..tex_wms_adapter_lib.gift_cfg[add_gool_id] or " ")
    local remark = _U(hall.gold_type.COUPON_SYS.des..tex_wms_adapter_lib.gift_cfg[add_gool_id]..add_gool_id)
    tex_wms_adapter_lib.write_dozen_wms_dz_movemas(billcode, businessid, businessname, 0, 4, 1, bet_count or " ")
   
    --д��ȯ������ϸ �Լ��� ϵͳ
    tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, user_id, nil, 10, 1, tex_wms_adapter_lib.gift_cfg_buy_sell[add_gool_id][2], -coupon_num, remark)
    tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, "PM000000", _U("������Ϸϵͳ"), 10, 0, tex_wms_adapter_lib.gift_cfg_buy_sell[add_gool_id][2], coupon_num, remark)
    
    --дgools������ϸ �Լ���ϵͳ
    tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, to_user_id, nil, add_gool_id, 0, tex_wms_adapter_lib.gift_cfg_buy_sell[add_gool_id][2], add_gool_num, remark)
    tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, "PM000000", _U("������Ϸϵͳ"), add_gool_id, 1, tex_wms_adapter_lib.gift_cfg_buy_sell[add_gool_id][2], -add_gool_num, remark)

end

--��ȡ����������Ϣ
function tex_wms_adapter_lib.on_get_safe_gold_info(e)
    local user_info = e.data["user_info"]
    if (user_info == nil) then
        return
    end
    local user_nick = " "
    if (user_info.nick ~= "") then
        user_nick = user_info.nick
    end
            
    sql = "insert into tex_wms.dozen_pub_dz_playergools_%s(playerid,playername,goolsid,goolsname,gameqty,\
                reltime)values(%d,'%s',%d,'%s',%d,'%s')"
    gift_info = {count= user_info.safegold * 10000, name = tex_wms_adapter_lib.gift_cfg[0]}
    local sql_info = string.format(sql, tex_wms_adapter_lib.get_day(), user_info.userId, 
                                       user_nick, 0, _U(gift_info.name), gift_info.count, 
                                       tex_wms_adapter_lib.lua_to_oracle_time())
    dblib.execute(sql_info)
end

--�յ�������任��Ϣ
function tex_wms_adapter_lib.on_get_safe_gold_change(e)
    local user_info = e.data["userinfo"]
    local user_id = user_info.userId
    local change_type =  e.data["nType"] -- 1ΪȡǮ 
    local add_gold = e.data["gold"]
    local billcode = tex_wms_adapter_lib.get_unique_code()
    local trade_type = 0
    local tb_bussiness_info = {} 
    if change_type == 1 then
      trade_type = 1
      tb_bussiness_info = hall.gold_type.SAFE_BOX_GET
      add_gold = -add_gold
    else
      tb_bussiness_info = hall.gold_type.SAFE_BOX_CUN
    end
    
    --Сäע��Ϣ
  	local deskno =user_info.desk
  	local deskinfo = desklist[deskno]
    if deskinfo and deskinfo.smallbet then
      bet_count = deskinfo.smallbet
    end
    
    
    --д����
    local businessid = _U(tb_bussiness_info.id or " ")
    local businessname =  _U(tb_bussiness_info.des or " ")
    local remark = _U(tb_bussiness_info.des or " ")
    tex_wms_adapter_lib.write_dozen_wms_dz_movemas(billcode, businessid, businessname, 0, 2, 1, bet_count or " ")
   
    --д������ϸ�Լ��ͱ�����
    tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, user_id, nil, 0, (trade_type + 1) % 2, math.abs(add_gold)*10000, -add_gold*10000, remark)
    tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, user_id, nil, 1000, trade_type, math.abs(add_gold)*10000, add_gold*10000, remark)
   
end

--��ȡΨһ�Ľ��׺�
function tex_wms_adapter_lib.get_unique_code()
    local cur_clock = os.clock() * 1000
    if (cur_clock ~= tex_wms_adapter_lib.last_clock) then
        tex_wms_adapter_lib.last_clock = cur_clock
        tex_wms_adapter_lib.last_unique_num = 0
    else
        tex_wms_adapter_lib.last_unique_num = tex_wms_adapter_lib.last_unique_num + 1
    end
    return tex_wms_adapter_lib.lua_to_oracle_time()..groupinfo.groupid..tex_wms_adapter_lib.last_clock.."00"..tex_wms_adapter_lib.last_unique_num
end

--�����û��ӽ�ҽӿ������� û��ʵ��
function tex_wms_adapter_lib.on_user_add_gold(e)
    local user_id = e.data["user_id"]
    local to_user_id = e.data["to_user_id"] or user_id  
    local add_gold = e.data["add_gold"]
    local add_type = e.data["add_type"]
    local chou_shui_gold = e.data["chou_shui_gold"]
    local chou_shui_type = e.data["chou_shui_type"] 
    local add_gool_id = e.data["gools_id"] or -1 
    local add_gool_num = e.data["gools_num"]
    local bet_count = 0
    
    --Сäע��Ϣ
  	local user_info = usermgr.GetUserById(user_id)
  	if not user_info then
  	  user_info = daxiao_hall.get_user_info(user_id)
  	end
  	
  	local deskno = nil
  	if user_info then
    	deskno =user_info.desk
    	local deskinfo = desklist[deskno]
      if deskinfo and deskinfo.smallbet then
        bet_count = deskinfo.smallbet
      else
        deskno = 0
      end
    end
  
    if add_gool_id > 0 and add_gool_num == nil then 
      add_gool_num = 1
    elseif add_gool_num == nil then
      add_gool_num = 0
    end
    local player_num = 2  --�����û�����
    if (add_gool_id and add_gool_id > 0 ) then
        player_num = 4
    end
    --��Ϸ����������
    if (add_type ~= 10101) then
        if (add_gold ~= 0) then
             local billcode = tex_wms_adapter_lib.get_unique_code()
             local businessid = ((add_type or " ")..(add_gool_id or " ")) or " "
             local businessname = _U((tex_wms_adapter_lib.gold_type[add_type] or " ")..((tex_wms_adapter_lib.gift_cfg[add_gool_id] or " ") or "����"))
             local trade_type = 1  --0��ʾ������1��ʾ����
             if (add_gold > 0) then
                 trade_type = 0
             end      
            --д����
            tex_wms_adapter_lib.write_dozen_wms_dz_movemas(billcode, businessid, businessname, 0, player_num, 1, bet_count or " ", deskno)   
            
            --�ӱ�����ϸ
            --д������ϸ �Լ��� ϵͳ
            local remark = businessname..businessid
            tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, user_id, nil, 0, trade_type, math.abs(add_gold), add_gold, remark)
            tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, "PM000000", _U("������Ϸϵͳ"), 0, (trade_type + 1) % 2, math.abs(add_gold), -add_gold, remark)
            --���add_gool_id����4����ϸ
            if add_gool_id and add_gool_id > 0 then
              --�Լ�����Ʒ��ϸ
              tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, user_id, nil, add_gool_id, (trade_type + 1) % 2, math.abs(add_gold), -add_gool_num, remark)
              tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, "PM000000", _U("������Ϸϵͳ"), add_gool_id, trade_type, math.abs(add_gold), add_gool_num, remark)
            end
        end
        
        --����г�ˮ��Ϣ����һ�� ��д��������д����ϸ��
        if (chou_shui_gold ~= 0 and chou_shui_type and chou_shui_type ~= 10100) then
            local billcode = tex_wms_adapter_lib.get_unique_code()
            local businessid = ((chou_shui_type or " ")..(add_gool_id or " ")) or " "
            local businessname = _U((tex_wms_adapter_lib.gold_type[chou_shui_type] or " ")..((tex_wms_adapter_lib.gift_cfg[add_gool_id] or " ") or "����"))
            local remark = businessname..businessid
            --д����
            tex_wms_adapter_lib.write_dozen_wms_dz_movemas(billcode, businessid, businessname, 0, 2, 1, bet_count or " ", deskno)   
            --д�ӱ��ˮ��ϸ���Լ���ϵͳ��
            local remark = businessname..add_gool_id
            tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, user_id, nil, 0, 1, math.abs(chou_shui_gold), chou_shui_gold, remark)
            tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, "PM000000", _U("������Ϸϵͳ"), 0, 0, math.abs(chou_shui_gold), -chou_shui_gold, remark)
        end
    end
end


--�����û��ӽ�ҽӿ�
--function tex_wms_adapter_lib.on_user_add_gold(e)
--    TraceError(e.data)
--    local user_id = e.data["user_id"]
--    local add_gold = e.data["add_gold"]
--    local chou_shui_gold = e.data["chou_shui_gold"]
--    local add_type = e.data["add_type"]
--    local chou_shui_type = e.data["chou_shui_type"]
--    local add_gool_id = e.data["gools_id"] or -1 
--    local to_user_id = e.data["to_user_id"] or user_id
--    local add_gool_num = e.data["gools_num"]
--    if add_gool_id > 0 and add_gool_num == nil then 
--      add_gool_num = 1
--    elseif add_gool_num == nil then
--      add_gool_num = 0
--    end
--    --local add_gool_num = e.data["gools_num"]
--    local player_num = 2  --�����û�����
--    if (add_gool_id and add_gool_id > 0 ) or (chou_shui_gold ~= 0 and add_type ~= chou_shui_type) then
--        player_num = 4
--    end
--    --��Ϸ����������
--    if (add_type ~= 10101) then
--        if (add_gold ~= 0) then
--            --��������Ϣ
--            local businessname = "����"
--            if (add_type == 10100) then
--                businessname = "��Ϸ��ˮ"
--            end
--            local billcode = tex_wms_adapter_lib.get_unique_code()
--            local sql = "insert into tex_wms.dozen_wms_dz_movemas_%s(billcode,businessid,businessname,tradeno,\
--                        businessdate,sumqty,playernumber,state,remark)values('%s','%s','%s','%s','%s',%d,%d,%d,'%s')"
--            local gold_type = tex_wms_adapter_lib.gold_type[add_type] or " "
--            gold_type = _U(gold_type.."_"..add_type)
--            TraceError("sssssss"..gold_type)
--            --gold_type = add_type
--            sql = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, ((add_type or " ")..(add_gool_id or " ")) or " ",
--                                (_U(tex_wms_adapter_lib.gold_type[add_type] or " ").._U(tex_wms_adapter_lib.gift_cfg[add_gool_id] or " ") or "����"), billcode, tex_wms_adapter_lib.lua_to_oracle_time(),
--                                0, player_num, 1, " ")
--            dblib.execute(sql)
--            --������ϸ
--            sql = "insert into tex_wms.dozen_wms_dz_movedet_%s(billcode,playerid,playername,goolsid,\
--                   goolsname,goolsvalue, tradetype,tradeqty,remark)values('%s','%s','%s','%s','%s',%d,%d,%d,'%s')"
--            local trade_type = 1  --0��ʾ������1��ʾ����
--            if (add_gold > 0) then
--                trade_type = 0
--            end
--            local user_nick = " "
--            local user_info = usermgr.GetUserById(user_id)
--            if (user_info ~= nil and user_info.nick ~= " ") then
--                user_nick = user_info.nick
--            end
--            --�Լ�����ϸ
--            local sql1 = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, user_id, user_nick, 0, 
--                                _U(tex_wms_adapter_lib.gift_cfg[0]), math.abs(add_gold), trade_type, add_gold, gold_type)
--            dblib.execute(sql1)
--            --ϵͳ����ϸ
--            sql1 = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, "PM000000", _U("������Ϸϵͳ"), 0, 
--                                _U(tex_wms_adapter_lib.gift_cfg[0]), math.abs(add_gold), (trade_type + 1) % 2, -add_gold, gold_type)
--            dblib.execute(sql1)
--            if add_gool_id and add_gool_id > 0 then
--              --�Լ�����Ʒ��ϸ
--              local user_nick = " "
--              local user_info = usermgr.GetUserById(to_user_id)
--              if (user_info ~= nil and user_info.nick ~= " ") then
--                  user_nick = user_info.nick
--              end
--              local sql2 = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, to_user_id, user_nick, add_gool_id, 
--                                  _U(tex_wms_adapter_lib.gift_cfg[add_gool_id] or " "), math.abs(add_gold), (trade_type + 1) % 2, add_gool_num, gold_type)
--              dblib.execute(sql2)
--              --ϵͳ����Ʒ��ϸ
--              sql2 = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, "PM000000", _U("������Ϸϵͳ"), add_gool_id, 
--                                  _U(tex_wms_adapter_lib.gift_cfg[add_gool_id] or " "), math.abs(add_gold), trade_type, -add_gool_num, gold_type)
--              dblib.execute(sql2)
--            end
--        end
--        --д���ˮ��Ϣ
--        if (chou_shui_gold ~= 0 and add_type ~= chou_shui_type) then
--          --�����Ҫ��ˮ������д����
--            local trade_type = 0  --0��ʾ������1��ʾ����
--            --д���Լ��ĳ�ˮ��Ϣ
--            gold_type = tex_wms_adapter_lib.gold_type[chou_shui_type] or " "
--            gold_type = _U(gold_type.."_"..chou_shui_type)
--
--            sql1 = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, user_id, user_nick, 0, 
--                                _U(tex_wms_adapter_lib.gift_cfg[0]), chou_shui_gold, trade_type, chou_shui_gold, gold_type)
--            dblib.execute(sql1)
--            --д��ϵͳ�ĳ�ˮ��Ϣ
--            sql1 = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, "PM000000", _U("������Ϸϵͳ"), 0, 
--                                _U(tex_wms_adapter_lib.gift_cfg[0]), -chou_shui_gold, (trade_type + 1) % 2, -chou_shui_gold, gold_type)
--            dblib.execute(sql1)
--        end
--    end
--end

--��Ϸ������
function tex_wms_adapter_lib.on_game_over_event(e)
    local sum_gold = 0
    local player_num = 0
    local smallbet = 0
    local desk_no = 0
    for k, v in pairs(e.data) do
        if (v.wingold ~= 0)  then
            sum_gold = sum_gold + v.wingold
            player_num = player_num + 1
            smallbet = v.smallbet or 0
            desk_no = v.deskno
        end
    end
    local billcode = tex_wms_adapter_lib.get_unique_code()
    local sql = "insert into tex_wms.dozen_wms_dz_movemas_%s(billcode,businessid,businessname,tradeno,\
                businessdate,sumqty,playernumber,state,remark,roomno)values('%s','%d','%s','%s','%s',%d,%d,%d,'%s',%d)"
    sql = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, "10101",
                        _U("��Ϸ����"), billcode, tex_wms_adapter_lib.lua_to_oracle_time(),
                        sum_gold, player_num, 1, smallbet,desk_no)
    dblib.execute(sql)
    for k, v in pairs(e.data) do
        if (v.wingold ~= 0)  then
            sql = "insert into tex_wms.dozen_wms_dz_movedet_%s(billcode,playerid,playername,goolsid,\
                   goolsname,goolsvalue, tradetype,tradeqty,remark)values('%s','%s','%s','%s','%s',%d,%d,%d,'%s')"
            local user_nick = " "
            local user_info = usermgr.GetUserById(v.userid)
            if (user_info ~= nil and user_info.nick ~= "") then
                user_nick = user_info.nick
            end
            local trade_type = 1
            if (v.wingold > 0) then
                trade_type = 0
            end
            sql = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, v.userid, user_nick, 0, 
                                _U(tex_wms_adapter_lib.gift_cfg[0]), math.abs(v.wingold), trade_type, v.wingold, _U("��Ϸ����_10101"))
            dblib.execute(sql)
        end
    end
end

--���ע����Ǯ����user���в�ѯ
function tex_wms_adapter_lib.check_user_reg()    
    local check_func = function(dt)
        if (dt and dt[1].num > (tex_wms_adapter_lib.max_user_id or 200000000000) and             
            tex_wms_adapter_lib.process_user_reg_ok == 1) then
            tex_wms_adapter_lib.process_user_reg_ok = 0
            local cur_time = os.time()
            local sql = "SELECT id as user_id, gold, nick_name as nick, reg_ip, sys_time, reg_site_no FROM users where id >= %d"
            sql = string.format(sql, tex_wms_adapter_lib.max_user_id or 200000000000)
            dblib.execute(sql, function(dt) 
                if (dt and #dt > 0) then
                    for i = 1, #dt do
                        local user_nick = " "
                        if (dt[i].nick ~= " ") then
                            user_nick = dt[i].nick
                        end
                        local reg_time = tex_wms_adapter_lib.lua_to_oracle_time(cur_time)
                        if (dt and #dt > 0) then
                            reg_time = tex_wms_adapter_lib.lua_to_oracle_time(tonumber(timelib.db_to_lua_time(dt[i].sys_time)))
                        end
                        local reg_ip = dt[i].reg_ip
                        if (reg_ip == " ") then
                            reg_ip = " "
                        end
                        local nick = dt[i].nick
                        if (nick == "") then
                            nick = " "
                        end
                        local reg_site_name = tex_wms_adapter_lib.reg_site[dt[i].reg_site_no] or dt[i].reg_site_no
                        --д���û���Ϣ����Ϊ�����û������½
                        local sql = "insert into tex_wms.dozen_pub_dz_player_%s(playerid,playername,createtm,regip,activation,\
                                lastgametm,lastloginip,passport,platformid,platformname)values(%d,'%s','%s','%s',%d,'%s','%s','%s','%s','%s')"
                        sql = string.format(sql, tex_wms_adapter_lib.get_day(), dt[i].user_id, nick, 
                                            reg_time, reg_ip, 1, tex_wms_adapter_lib.lua_to_oracle_time(cur_time), 
                                            reg_ip, " ", dt[i].reg_site_no, reg_site_name)
                        dblib.execute(sql)
                        local businessid = hall.gold_type.regAddGold.id;
                        --д��������Ϣ
                        local billcode = tex_wms_adapter_lib.get_unique_code()
                        sql = "insert into tex_wms.dozen_wms_dz_movemas_%s(billcode,businessid,businessname,tradeno,\
                                    businessdate,sumqty,playernumber,state,remark)values('%s','%d','%s','%s','%s',%d,%d,%d,'%s')"
                        sql = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, businessid,
                                            _U(tex_wms_adapter_lib.gold_type[businessid]), billcode, tex_wms_adapter_lib.lua_to_oracle_time(),
                                            0, 2, 1, " ")
                        dblib.execute(sql)
                        local trade_type = 1
                        --д��ϸ
                        sql = "insert into tex_wms.dozen_wms_dz_movedet_%s(billcode,playerid,playername,goolsid,\
                               goolsname,goolsvalue, tradetype,tradeqty,remark)values('%s','%s','%s','%s','%s',%d,%d,%d,'%s')"
                        local sql_temp = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, dt[i].user_id, nick, 0, 
                                            _U(tex_wms_adapter_lib.gift_cfg[0]), dt[i].gold, (trade_type + 1) % 2, dt[i].gold, _U("ע��_1000"))
                        dblib.execute(sql_temp)
                        sql_temp = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, "PM000000", _U("������Ϸϵͳ"), 0, 
                                            _U(tex_wms_adapter_lib.gift_cfg[0]), dt[i].gold, trade_type, -dt[i].gold, _U("��ֵ_1000"))
                        dblib.execute(sql_temp)
                        --��¼����
                        tex_wms_adapter_lib.max_user_id = tex_wms_adapter_lib.max_user_id + 1
                        sql = "update tex_wms.table_index_info2 set user_reg_index = user_reg_index + 1"
                        dblib.execute(sql)                        
                    end
                end
                tex_wms_adapter_lib.process_user_reg_ok = 1
            end)
        end
    end
    local sql = "select max(id) as num from users"
    --�����û���µ��û���¼
    dblib.execute(sql, check_func)
    --�����һ���û���¼д��������
    if (tex_wms_adapter_lib.max_user_id == nil or tex_wms_adapter_lib.max_user_id == 200000000000) then
        local sql = "select user_reg_index from tex_wms.table_index_info2"
        dblib.execute(sql, function(dt) 
            if (dt and #dt > 0) then
                tex_wms_adapter_lib.max_user_id = dt[1].user_reg_index
            end
        end)                
    end
end


--����ֵ��д����Ӫϵͳ
function tex_wms_adapter_lib.check_pay_wms()    
    local check_func = function(dt)
        if (dt and dt[1].num > (tex_wms_adapter_lib.max_pay_id or 200000000000) and tex_wms_adapter_lib.process_pay_ok == 1) then
            tex_wms_adapter_lib.process_pay_ok = 0
            local sql = "SELECT a.userid as user_id, a.gold as gold, b.nick_name as nick, a.rmb as rmb FROM log_pay_success a, users b WHERE a.id >= %d AND a.userid = b.id"
            sql = string.format(sql, tex_wms_adapter_lib.max_pay_id or 200000000000)
            dblib.execute(sql, function(dt) 
                if (dt and #dt > 0) then
                    for i = 1, #dt do
                        local user_nick = " "
                        if (dt[i].nick ~= "") then
                            user_nick = dt[i].nick
                        end
                        --д��������Ϣ
                        local billcode = tex_wms_adapter_lib.get_unique_code()
                        local sql = "insert into tex_wms.dozen_wms_dz_movemas_%s(billcode,businessid,businessname,tradeno,\
                                    businessdate,sumqty,playernumber,state,remark)values('%s','%d','%s','%s','%s',%d,%d,%d,'%s')"
                        sql = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, 1000,
                                            _U(tex_wms_adapter_lib.gold_type[1000]), billcode, tex_wms_adapter_lib.lua_to_oracle_time(),
                                            0, 2, 1, " ")
                        dblib.execute(sql)
                        local trade_type = 1
                        --д��ϸ
                        sql = "insert into tex_wms.dozen_wms_dz_movedet_%s(billcode,playerid,playername,goolsid,\
                               goolsname,goolsvalue, tradetype,tradeqty,remark)values('%s','%s','%s','%s','%s',%d,%d,%d,'%s')"
                        local sql_temp = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, dt[i].user_id, user_nick, 0, 
                                            _U(tex_wms_adapter_lib.gift_cfg[0]), dt[i].gold, (trade_type + 1) % 2, dt[i].gold, _U("��ֵ_1000"))
                        dblib.execute(sql_temp)
                        sql_temp = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, "PM000000", _U("������Ϸϵͳ"), 0, 
                                            _U(tex_wms_adapter_lib.gift_cfg[0]), dt[i].gold, trade_type, -dt[i].gold, _U("��ֵ_1000"))
                        dblib.execute(sql_temp)
                        --��¼����
                        tex_wms_adapter_lib.max_pay_id = tex_wms_adapter_lib.max_pay_id + 1
                        sql = "update tex_wms.table_index_info2 set pay_index = pay_index + 1"
                        dblib.execute(sql)                        
                    end
                end
                tex_wms_adapter_lib.process_pay_ok = 1
            end)
        end
    end
    local sql = "select max(id) as num from log_pay_success"
    --�����û���µĳ�ֵ��¼
    dblib.execute(sql, check_func)
    --�����һ�γ�ֵ��¼д��������
    if (tex_wms_adapter_lib.max_pay_id == nil or tex_wms_adapter_lib.max_pay_id == 200000000000) then
        local sql = "select pay_index from tex_wms.table_index_info2"
        dblib.execute(sql, function(dt) 
            if (dt and #dt > 0) then
                tex_wms_adapter_lib.max_pay_id = dt[1].pay_index
            end
        end)                
    end
end

function tex_wms_adapter_lib.timer(e)
    if (gamepkg.name == 'tex' and groupinfo.groupid == "18002") then   
        tex_wms_adapter_lib.check_pay_wms()
        tex_wms_adapter_lib.check_user_reg()
    end
end



------------------------------------------------------------------------
--------------------------���ݿ����------------------------------------
------------------------------------------------------------------------
--д������
--billcode����, businessid��ţ� businessname���ƣ�sumqty�ܺ�һ��Ϊ0�� playernumber������ϸ�������ܣ�stateΪ1��Ч��remarkСäע
function tex_wms_adapter_lib.write_dozen_wms_dz_movemas(billcode, businessid, businessname, sumqty, playernumber, state, remark, deskno)
    local sql = "insert into tex_wms.dozen_wms_dz_movemas_%s(billcode,businessid,businessname,tradeno,\
                businessdate,sumqty,playernumber,state,remark,roomno)values('%s','%s','%s','%s','%s',%d,%d,%d,'%s',%d)"
    sql = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, businessid or " ",
                        businessname or "����", billcode, tex_wms_adapter_lib.lua_to_oracle_time(),
                        sumqty, playernumber, state, remark, deskno or 0)
    dblib.execute(sql)
end

--д�ӱ��� 
--billcode���� goolsvalue��ԶΪ����
function tex_wms_adapter_lib.write_dozen_wms_dz_movedet(billcode, user_id, user_nick, goolsid, tradetype, goolsvalue, tradeqty, remark)
      if tradetype == 1 then
        tradeqty = -math.abs(tradeqty)
      else
        tradeqty = math.abs(tradeqty)
      end
      --������ϸ
      sql = "insert into tex_wms.dozen_wms_dz_movedet_%s(billcode,playerid,playername,goolsid,\
             goolsname,tradetype,goolsvalue,tradeqty,remark)values('%s','%s','%s','%s','%s',%d,%d,%d,'%s')"
             
      if not user_nick then 
        user_nick = " "
        user_info = usermgr.GetUserById(user_id)
        if (user_info ~= nil and user_info.nick ~= "") then
            user_nick = user_info.nick
        else
          if daxiao_hall then
            user_info = daxiao_hall.get_user_info(user_id)
            if (user_info ~= nil and user_info.nick ~= "") then
              user_nick = user_info.nick
            end
          end
        end   
      end
   
      sql = string.format(sql, tex_wms_adapter_lib.get_day(), billcode, user_id, user_nick, goolsid, 
                          _U(tex_wms_adapter_lib.gift_cfg[goolsid]), tradetype, goolsvalue, tradeqty, remark)
      dblib.execute(sql)
end



eventmgr:addEventListener("h2_on_user_login", tex_wms_adapter_lib.on_after_user_login)
eventmgr:addEventListener("after_get_props_list", tex_wms_adapter_lib.after_get_props_list)
eventmgr:addEventListener("timer_second", tex_wms_adapter_lib.timer);
eventmgr:addEventListener("on_user_add_gold", tex_wms_adapter_lib.on_user_add_gold)
eventmgr:addEventListener("on_get_safebox_info", tex_wms_adapter_lib.on_get_safe_gold_info)
eventmgr:addEventListener("on_safebox_sq", tex_wms_adapter_lib.on_get_safe_gold_change)
eventmgr:addEventListener("game_event_ex", tex_wms_adapter_lib.on_game_over_event)
eventmgr:addEventListener("on_server_start", tex_wms_adapter_lib.restart_server)
eventmgr:addEventListener("finish_init_car", tex_wms_adapter_lib.on_after_init_car)
eventmgr:addEventListener("already_init_parking", tex_wms_adapter_lib.on_after_init_parking)
eventmgr:addEventListener("already_init_yinpiao", tex_wms_adapter_lib.on_after_init_yinpiao)
eventmgr:addEventListener("on_user_change_coupon", tex_wms_adapter_lib.on_user_change_coupon)

