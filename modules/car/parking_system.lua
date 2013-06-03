TraceError("init parking system....")

if parkinglib and parkinglib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", parkinglib.on_user_exit);
end

if parkinglib and parkinglib.on_site_event then 
	eventmgr:removeEventListener("site_event", parkinglib.on_site_event);
end

if parkinglib and parkinglib.on_using_gift then 
	eventmgr:removeEventListener("on_using_gift", parkinglib.on_using_gift);
end

if parkinglib and parkinglib.already_init_car then
	eventmgr:removeEventListener("already_init_car", parkinglib.already_init_car);
end
if parkinglib and parkinglib.on_after_sub_user_login then 
	eventmgr:removeEventListener("h2_on_sub_user_login", parkinglib.on_after_sub_user_login)
end

if not parkinglib then
	parkinglib = _S
	{
        process_parking_time_over = NULL_FUNC,      --��λ���ڴ���
        calc_parking_status    = NULL_FUNC,         --���㳵λ״̬
        get_parking_count = NULL_FUNC,              --��ȡ��λ����
        get_car_info = NULL_FUNC,                   --��ȡ������Ϣ
        process_using_car      = NULL_FUNC,              --������������
        pay_parking            = NULL_FUNC,         --�⳵λ��Ǯ
        --�ͻ�������handle
        on_recv_open_main_wnd  = NULL_FUNC,			--���ͳ�λ������
        on_recv_parking_renew  = NULL_FUNC,         --����
        on_recv_parking_config = NULL_FUNC,         --��ȡ��λ����
        on_recv_parking_status = NULL_FUNC,         --��ȡ�û���λ״̬
        on_recv_sale_car       = NULL_FUNC,         --����
        on_recv_using_car      = NULL_FUNC,         --���ó�Ϊ����
        active_parking_site    = NULL_FUNC,			--��ͨ�����򣩳�λ
        net_send_parking_data  = NULL_FUNC,			--���ͳ�λ��Ϣ
        --ϵͳ�¼�����
        process_sale_car       = NULL_FUNC,         --����Ʒ����ʱ�򴥷�
        on_after_user_login    = NULL_FUNC,         --�û���¼ʱ��
        on_site_event          = NULL_FUNC,        --�����¼�
        on_add_gift_item       = NULL_FUNC,         --����������
        on_user_exit           = NULL_FUNC,         --�û��뿪
        on_using_gift          = NULL_FUNC,         --ʹ����Ʒ
        already_init_car       = NULL_FUNC,         --��ʼ����
        
        --�����ӿ�
        add_parking            = NULL_FUNC,         --��ӳ�λ�ӿ�
        is_active_item         = NULL_FUNC,         --�жϵ����Ƿ񼤻���
        is_parking_item        = NULL_FUNC,         --�ж��Ƿ�λ����
        get_using_car_info     = NULL_FUNC,

        OP_PARKING_OPEN_PRICE = {   --��ͬ��λ��ͨ�۸�
            1000,     --����
            10000,    --�м�
            100000,   --�߼�
            500000,   --���⳵λ
        },  
        OP_PARKING_OPEN_PRICE_LOG = {
            61001,
            62001,
            63001,
            64001,
        },
        OP_PKARING_RENEW_PACKAGE= {
            [1] ={
                youhui=1,
                name="һ����",
                time=24 * 3600 * 30,
            },
            [6] ={
                youhui=0.9,
                name="����",
                time=24 * 3600 * 30 * 6,
            },
            [12] = {
                youhui=0.8,
                name="1��",
                time=24 * 3600 * 30 * 12,
            }
        },

        --��λ�ɷų����ƣ���Ҫ�ǳ��ļ۸�����
        OP_PARKING_LIMIT_CAR_PRICE = {
            [1] = 100000, --������λ��10w���µ�
            [2] = 1000000,--�м���λ, 100W���µ�
            [3] = 1000000000,
            [4] = 0,      --���⳵λ
        },

        OP_PARKING_BUY_TIME = 24 * 3600 * 30,
        OP_PARKING_CARS = {
            [5011] = {
                parking_type = -1,
            },
            [5012] = {
                parking_type = -1,
            },
            [5013] = {
                parking_type = -1,
            },
            [5017] = {
                parking_type = -1,
            },
            [5018] = {
                parking_type = -1,
            },
            [5019] = {
                parking_type = -1,
            },
            [5021] = {
                parking_type = -1,
            },
            [5022] = {
                parking_type = -1,
            },
            [5023] = {
                parking_type = 4,--���⳵λ
            },
            [5024] = {
                parking_type = -1,
            },
            [5025] = {
                parking_type = -1,
            },
            [5026] = {
                parking_type = -1,
            },
            [5027] = {
                parking_type = -1,
            },
            [5028] = {
                parking_type = 4,--���⳵λ
            },
            [5029] = {
                parking_type = 4,--���⳵λ
            },
            [5030] = {
                parking_type = -1,
            },
            [5031] = {
                parking_type = -1,
            },
            [5032] = {
                parking_type = -1,
            },
            [5033] = {
                parking_type = -1,
            },
            [5034] = {
                parking_type = -1,
            },
            [5036] = {
                parking_type = -1,
            },
            [5037] = {
                parking_type = -1,
            },
            [5038] = {
                parking_type = -1,
            },
            [5039] = {
                parking_type = -1,
            },
            [5040] = {
                parking_type = -1,
            },
            [5041] = {
                parking_type = -1,
            },

            [5042] = {
                parking_type = -1,
            },
            [5043] = {
                parking_type = -1,
            },
            [5044] = {
                parking_type = -1,
            },
            [5045] = {
                parking_type = -1,
            },
            [5046] = {
                parking_type = -1,
            },
            [5047] = {
                parking_type = -1,
            },
            [5048] = {
                parking_type = -1,
            },
            [5049] = {
                parking_type = -1,
            },
            [5050] = {
                parking_type = -1,
            },
            [5051] = {
                parking_type = -1,
            },

        },
        
        user_list = {},                 --�û��ĳ�λ����������
	}
end

--TODO �����û��˳���ɾ���û���Ϣ

parkinglib.get_car_info = function(parking_data, car_index)
    for k, v in pairs(parking_data.parking_list) do
        for k1, v1 in pairs(v.cars) do
            if(v1.index == car_index) then
                return v1;
            end
        end
    end
    return nil;
end

parkinglib.get_parking_count = function(parking_cars) 
    local count= 0;
    for k,v in pairs(parking_cars) do
        count = count + 1;
    end
    return count;
end

parkinglib.pay_parking = function(user_info, gold, parking_type, parking_time)
--    local retcode = 0;
--    if(user_info.desk and user_info.site) then
--        local deskdata = deskmgr.getdeskdata(user_info.desk);
--        local sitedata = deskmgr.getsitedata(user_info.desk, user_info.site);
--        retcode = dobuygift1(user_info, deskdata, sitedata, 0, gold);
--        --����ɹ�
--    else
--        retcode = dobuygift2(user_info, 0, gold)
--    end
--    return retcode;
--get_canuse_gold(user_info, is_include_self_chouma)

  if not parking_time then 
    parking_time =1
  end
  if get_canuse_gold(user_info) < gold then
    return 2
  else
    usermgr.addgold(user_info.userId, -gold, 0, hall.gold_type.PARKING_SYS.id, -1, 1, nil, parkinglib.OP_PARKING_OPEN_PRICE_LOG[parking_type], parking_time)
    return 1
  end
end

parkinglib.add_parking = function(user_info, parking_type, parking_count, car_id, index)           
    car_id = car_id ~= nil and car_id or 0;
    index = index ~= nil and index or 0;
    local total_count = parking_count;
    local parking_data = parkinglib.user_list[user_info.userId];
    if(parking_data == nil or parking_count <= 0) then 
        TraceError("�û�û�еĳ�λ����"..user_info.userId.." parking_type"..parking_type.." parking_count"..parking_count);
        return; 
    end;

    local parking_list = parking_data.parking_list;
    local data = parking_list[parking_type];
    local find = 0;
    if(car_id > 0 and index > 0) then
        for k, v in pairs(data.cars) do
            --ָ������ĳ�
            --�鿴�⳵�м���û��
            if(v.id == car_id and v.parking_id == 0 and v.index == index) then
                find = 1;
                v.parking_id = table.maxn(data.parking_cars) + 1;
                table.insert(data.parking_cars, v.parking_id, {
                    id=v.id,
                    idx=v.index,
                    time=os.time(),
                    oversec=parkinglib.OP_PARKING_BUY_TIME, 
                });
                parking_count = parking_count - 1;
                break;
            end
        end
    end

    if(find == 0 and car_id > 0 and parking_count > 0) then
        for k, v in pairs(data.cars) do
            
            if(v.id == car_id and v.parking_id == 0) then
                find = 1;
                v.parking_id = table.maxn(data.parking_cars) + 1;
                table.insert(data.parking_cars, v.parking_id, {
                    id=v.id,
                    idx=v.index,
                    time=os.time(),
                    oversec=parkinglib.OP_PARKING_BUY_TIME, 
                });
                parking_count = parking_count - 1;
            end

            if(parking_count <= 0) then
                break;
            end
        end
    end

    if(find == 0 and parking_count > 0) then
        --ֱ�����ó�λ, �����һ��
        for k, v in pairs(data.cars) do
            if(v.parking_id == 0) then
                find = 1;
                v.parking_id = table.maxn(data.parking_cars) + 1;
                table.insert(data.parking_cars, v.parking_id, {
                    id=v.id,
                    idx=v.index,
                    time=os.time(),
                    oversec= parkinglib.OP_PARKING_BUY_TIME,
                });
                parking_count = parking_count - 1;
            end

            if(parking_count <= 0) then
                break;
            end
        end
    end

    if(find == 0 and parking_count > 0) then
        --����һ���յĳ�λ
        for i=1, parking_count do 
            table.insert(data.parking_cars, {
                id=0,
                time=os.time(),--��λδʹ��
                oversec=parkinglib.OP_PARKING_BUY_TIME,
            });
        end
    end

    data.parking_count = data.parking_count + total_count;
    parking_db_lib.add_user_parking_db(user_info.userId, data.id, parking_type, data.parking_count, data.parking_cars);
    parking_data.parking_count = parking_data.parking_count + total_count;
    

    if(data.id == 0) then--����ˢ������
        parking_data.refresh = 1;
    end
    if(index > 0) then
        parkinglib.process_using_car(user_info, index);
    end
    parking_data.refresh = 1
end

--�ڳ��⿪ͨ����λ
parkinglib.active_parking_site  = function(buf)
    local user_info = userlist[getuserid(buf)]
    local parking_data = parkinglib.user_list[user_info.userId];
    if(user_info == nil or parking_data == nil)then return end 
    local parking_list = parking_data.parking_list;
    local parking_type = buf:readInt(); --Ҫ��ͨ�ĳ�λ����
    local parking_count = 1;--buf:readInt();--Ҫ��ͨ������
    local car_id = buf:readInt();
    local index = buf:readInt();

    local retcode = 1;
    --local car_id = buf:readInt() --ͣ�ڸó�λ�ĳ���ID��Ϊ0��ʾû������

    local parking_price = parkinglib.OP_PARKING_OPEN_PRICE[parking_type];
    if(parking_price == nil or parking_price <= 0) then
        TraceError("û�и����͵ĳ�λ����ʲô"..parking_type);
        return;
    end

    local data = parking_list[parking_type];
    parking_price = parking_price * parking_count;

    --�ж�����
    if(parking_list[parking_type].parking_count + parking_count > 100) then
        retcode = 0; 
    end

    if(retcode == 1) then
        retcode = parkinglib.pay_parking(user_info, parking_price, parking_type);
    end

    --ĳ�û��ĳ�λ���Ӳ�����ͣ�ڳ�λ�ϵ�ĳ����
    if(retcode == 1) then
        --д��־��
        parking_db_lib.log_user_parking_db(user_info.userId, parking_type, parking_count, parking_price)
        parkinglib.add_parking(user_info, parking_type, parking_count, car_id, index);
        --[[if(index > 0) then
            parkinglib.process_using_car(user_info, index);
        end--]]
        parkinglib.net_send_parking_data(user_info, parking_data, user_info.userId); 
    else
        netlib.send(function(buf)
            buf:writeString("PKACTIVERS");
            buf:writeInt(retcode);--0 ����ʧ�� 2 Ǯ����
        end, user_info.ip, user_info.port);
    end
end

parkinglib.calc_parking_status = function(userinfo, user_parking_data) 
    local parking_count = 0;--��λ����
    local car_count =  0;--��������
    local car_type  =  0; --��������
    local car_price =  0;--�����ܼ�ֵ
    local client_refresh_time = 0;--�ͻ���������������ˢ������
    local cars = {};
    for k, v in pairs(user_parking_data.parking_list) do
        parking_count = parking_count + v.parking_count;
        local active_count = 0;
        for k1, v1 in pairs(v.cars) do
            cars[v1.id] = 1;
            car_count = car_count + 1;
            car_price = car_price + car_match_lib.get_user_car_prize(userinfo.userId, v1.car_id) or car_match_lib.get_car_cost(v1.car_type)
            if(v1.parking_id > 0) then
                active_count = active_count + 1;
            end
        end

        for k2, v2 in pairs(v.parking_cars) do
            local over_time = v2.time + v2.oversec;
            if(over_time < client_refresh_time or client_refresh_time == 0) then
                client_refresh_time = over_time - os.time();
            end
        end
        v.active_count = active_count;
    end

    for k, v in pairs(cars) do
        car_type = car_type + 1;
    end

    --ע�⣬�ͻ��˵���ʱ����15�ջ�chubug
    if(client_refresh_time > 15 * 3600 * 24) then
        client_refresh_time = 0;
    end
    
    user_parking_data.car_type = car_type;
    user_parking_data.car_count = car_count;
    user_parking_data.car_price = car_price;
    user_parking_data.parking_count = parking_count;
    user_parking_data.client_refresh_time = client_refresh_time;
end
--�Զ����û�ѡ��λ
parkinglib.auto_select_parking = function(user_info, user_parking_data) 
    --�鿴�ж��ٳ�λ�ǿյģ�Ĭ�ϰ��û��󶨳�λ
    for k, v in pairs(user_parking_data.parking_list) do
        local parking_count = v.parking_count;
        local real_parking_count = parkinglib.get_parking_count(v.parking_cars); 
        local find = false;
        local left_count = parking_count - real_parking_count;
        if(left_count > 0) then
            --�����пյĳ�λ����
            find = true;
            for i = 1, left_count do
                table.insert(v.parking_cars, {--Ĭ����һ���µĳ�λ
                    id=0,
                    time = os.time(),
                    oversec= parkinglib.OP_PARKING_BUY_TIME,
                });
            end
        end

        local empty_parking = 0;--�ճ�λ�ĸ���
        for k1, v1 in pairs(v.parking_cars) do
            if(v1.id <= 0) then
                empty_parking = empty_parking + 1;
            else
                local find_parking = 0;
                for k2, v2 in pairs(v.cars) do
                    --�����ĸ���ռ�����λ��
                    if(v2.parking_id == k1) then
                        --�ҵ���
                        find_parking = 1;
                        break;
                    end
                end

                if(find_parking == 0) then
                    --TraceError("���쳣���"..user_info.userId.." "..tostringex(v1));
                    empty_parking = empty_parking + 1;
                    v1.id = 0;
                    find = true;
                end
            end
        end
            
        --�Զ��Ҹ�û�м����λ���ó�ͣ��
        if(empty_parking > 0) then
            local carids = {};
            for k1, v1 in pairs(v.cars) do
                if(v1.parking_id == 0) then
                    empty_parking = empty_parking - 1;
                    for k2, v2 in pairs(v.parking_cars) do
                        --�����пյĳ�λû��
                        if(v2.id <= 0) then
                            find = true;
                            v1.parking_id = k2; 
                            v2.id = v1.id;
                            if(v2.time == -1) then
                                v2.time = os.time();
                                v2.oversec=parkinglib.OP_PARKING_BUY_TIME;
                            end
                            break;
                        end
                    end
                end

                if(empty_parking <= 0) then
                    break;
                end
            end
        end

        if(find == true) then
            parking_db_lib.add_user_parking_db(user_info.userId, v.id, k, v.parking_count, v.parking_cars);
        end
    end
end

--������ڵĳ�λ
parkinglib.process_parking_time_over = function(user_info, user_parking_data) 
    local parking_list = user_parking_data.parking_list;
    local count = 0;
    for k, v in pairs(parking_list) do
        local modify = 0;
        for k1, v1 in pairs(v.parking_cars) do
            if(v1.time == nil or v1.time == -1) then
                modify = 1;
                v1.time = os.time();
            end

            if(v1.oversec == nil) then 
                modify = 1;
                v1.oversec = parkinglib.OP_PARKING_BUY_TIME;
            end

            if(v1.time + v1.oversec< os.time()) then
                --������
                modify = 1;
                count = count + 1;

                --���ڳ�����
                v.parking_cars[k1] = nil;
                v.parking_count = v.parking_count - 1;
                for k2, v2 in pairs(v.cars) do
                    if(v2.id == v1.id and v2.parking_id == k1) then
                        v2.parking_id = 0;
                        --��λ�����ˣ���Ӧ�ĳ�ҲҪ��һ������
                        local parking_data = parkinglib.user_list[user_info.userId];
                        if (parking_data ~= nil and parking_data.using_car ~= nil and v1.idx == parking_data.using_car.index) then                                
                            car_match_db_lib.update_is_using(user_info.userId, parking_data.using_car.index, 0);
                            parking_data.using_car = nil;
                        end
                        break;
                    end
                end
            end
        end

        if(modify == 1) then
            parking_db_lib.add_user_parking_db(user_info.userId, v.id, k, v.parking_count, v.parking_cars);
        end
    end

    if(count > 0) then
        netlib.send(function(buf)
            buf:writeString("PKREMIND");
            buf:writeInt(count);
        end, user_info.ip, user_info.port);
    end
end

parkinglib.on_recv_sale_car = function(buf) 
    --TraceError('on_recv_sale_car');
    local user_info = userlist[getuserid(buf)]
    local parking_data = parkinglib.user_list[user_info.userId];
    if(user_info == nil or parking_data == nil)then return end 
    local result = 0;
    local send_func = function(buf) 
        buf:writeString("PKSALE");
        buf:writeInt(result);--1�ɹ�,-1���ڱ���,0,ʧ��
    end
    local car_index = buf:readInt();
    
    if not car_match_lib.user_list[user_info.userId] or
      not car_match_lib.user_list[user_info.userId].car_list[car_index] then
        return
    end
    
    if (car_match_lib and car_match_sj_lib) then
        local car_type = car_match_lib.user_list[user_info.userId].car_list[car_index].car_type or 0
        local sell_lv = 10
        local team_lv = car_match_sj_lib.user_list[user_info.userId].team_lv
        if (car_type == 5043 and team_lv < sell_lv) then  --���������󷢶��ҳ��ӵȼ�С��10��������
            parkinglib.send_can_not_sell_car(user_info, car_type, sell_lv)
            return
        end
    end


    parkinglib.process_sale_car(user_info, car_index, function(result)
        if(result == 1) then
            result = 1;
            car_match_db_lib.del_car(user_info.userId, car_index);
        end
    end); 
end

parkinglib.process_using_car = function(user_info, car_index, refresh)
    local parking_data = parkinglib.user_list[user_info.userId];
    if(parking_data ~= nil) then
        if(parking_data.using_car ~= nil) then
            parking_data.using_car.is_using = 0;
            car_match_db_lib.update_is_using(user_info.userId, parking_data.using_car.index, 0);
        end
        gift_remove_using(user_info);
        
        local car_info = parkinglib.get_car_info(parking_data, car_index);
        if(car_info ~= nil) then
            parking_data.using_car = car_info;
            car_info.is_using = 1;
            dispatchMeetEvent(user_info);
            if(refresh == true) then
                parkinglib.net_send_parking_data(user_info, parking_data, user_info.userId);
            end
        end
        car_match_db_lib.update_is_using(user_info.userId, car_index, 1);
    end
end

parkinglib.on_recv_using_car = function(buf)
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 
    local car_index = buf:readInt();
    parkinglib.process_using_car(user_info, car_index, true);
end


parkinglib.on_recv_open_main_wnd  = function(buf)    --�򿪳�λ������
    --TraceError("OP wnd")
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 

    local user_id = buf:readInt() --Ҫ�򿪵ĳ�λ����
    if(duokai_lib) then
        if(duokai_lib.is_sub_user(user_id) == 1) then
            user_id = duokai_lib.get_parent_id(user_id);
        end
    end
    --��һ�δ����ݿ��ȡ����
    local refresh = 0;
    if(parkinglib.user_list[user_id] ~= nil and (parkinglib.user_list[user_id].refresh == nil  or parkinglib.user_list[user_id].refresh == 1)) then
        refresh = 1; 
    end
    if parkinglib.user_list[user_id] == nil or refresh == 1 then
        local on_ret = function(user_parking_data)
            local enter_desk_data = {};

            if(parkinglib.user_list[user_id] == nil) then
                parkinglib.user_list[user_id] = {};
            end

            if(refresh == 1 and parkinglib.user_list[user_id].enter_desk_data ~= nil) then
                enter_desk_data = parkinglib.user_list[user_id].enter_desk_data;
            end
            user_parking_data.enter_desk_data = enter_desk_data;
            parkinglib.user_list[user_id] = user_parking_data;
            parkinglib.process_parking_time_over(user_info, user_parking_data);
            parkinglib.auto_select_parking(user_info, user_parking_data);
            parkinglib.net_send_parking_data(user_info, user_parking_data, user_id);    
            parkinglib.user_list[user_id].refresh = 0
        end
        parking_db_lib.get_user_parking_db(user_id, on_ret);
    else
        local user_parking_data = parkinglib.user_list[user_id];
        parkinglib.process_parking_time_over(user_info, user_parking_data);
        parkinglib.auto_select_parking(user_info, user_parking_data);
        parkinglib.net_send_parking_data(user_info, user_parking_data, user_id);
    end
end







parkinglib.on_recv_parking_status = function(buf)
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 
    local to_userid = buf:readInt();
    local parking_data = parkinglib.user_list[to_userid];
    if(parking_data == nil) then
        return;
    end
    local parking_list = parking_data.parking_list;
    local active_count = 0;
    if(parking_list ~= nil) then
        local status = 0;
        for k, v in pairs(parking_list) do
            if(status < k and v.parking_count > 0) then
                status = k;
                active_count = v.active_count;
            end
        end
        if(status > 0) then
            netlib.send(function(buf)
                buf:writeString("PKSTUTAS");
                buf:writeInt(status);
                buf:writeInt(active_count);
            end, user_info.ip, user_info.port);
        end
    end
end

parkinglib.on_recv_parking_config = function(buf)
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 
    netlib.send(function(buf)
        local count = #parkinglib.OP_PARKING_OPEN_PRICE;
        buf:writeString('PKCONFIG');
        buf:writeInt(count);--��λ��������
        for i = 1, #parkinglib.OP_PARKING_OPEN_PRICE do
            buf:writeInt(i);--��λ����
            buf:writeInt(parkinglib.OP_PARKING_OPEN_PRICE[i]);--��λ��Ǯ
        end
        buf:writeInt(3);--��ʱд������Ϊ�ͻ���ֻ������ʾ3���۸�
        for k, v in pairs(parkinglib.OP_PKARING_RENEW_PACKAGE) do
            buf:writeInt(k);
            buf:writeString(_U(v.name));
            buf:writeString(tostring(v.youhui));
        end
    end, user_info.ip, user_info.port);
end

--����
parkinglib.on_recv_parking_renew = function(buf) 
    local user_info = userlist[getuserid(buf)];
    if(user_info == nil)then return end 
    local parking_time = buf:readInt();
    local parking_type = buf:readInt();
    local parking_id   = buf:readInt();
  
    local parking_data = parkinglib.user_list[user_info.userId];
    local parking_list = parking_data.parking_list;
    local result = 0;
    local overtime = "";
    local sendFunc = function(buf)
        buf:writeString("PKRENEWRS");
        buf:writeInt(result);        
        buf:writeString(overtime);
    end
    local renew_data = parkinglib.OP_PKARING_RENEW_PACKAGE[parking_time];
    if(parking_data ~= nil and parking_list ~= nil and  
       parking_list[parking_type] ~= nil and renew_data ~= nil) then
           local data = parking_list[parking_type].parking_cars[parking_id];
           if(data ~= nil) then
               local price = parking_time * parkinglib.OP_PARKING_OPEN_PRICE[parking_type] * renew_data.youhui;

               --��Ǯ
               result = parkinglib.pay_parking(user_info, price, parking_type, parking_time);
               if(result == 1) then
                   if(data.time + data.oversec< os.time()) then
                       --�Ѿ�������
                       data.time = os.time();
                       data.oversec = 0;
                   end
    
                   data.oversec = data.oversec + renew_data.time; 
                   local test_over_time = data.time + data.oversec
                   if (test_over_time > 2147483647) then
                        test_over_time = 2147483647
                   end
                   overtime = timelib.lua_to_db_time(test_over_time);

                   --��������
                   parking_db_lib.add_user_parking_db(user_info.userId, parking_list[parking_type].id, parking_type, parking_list[parking_type].parking_count, parking_list[parking_type].parking_cars);

                   --֪ͨ�ͻ��˸�����
                   parkinglib.net_send_parking_data(user_info, parking_data, user_info.userId);
               end
           end
    end

    netlib.send(sendFunc, user_info.ip, user_info.port);
end

--��������ʱ,֪ͨ�ͻ�������
parkinglib.net_send_parking_data = function(user_info, parking_data, my_user_id)
    local touserinfo = usermgr.GetUserById(my_user_id) or {};
    parkinglib.calc_parking_status(touserinfo, parking_data);
    netlib.send(function(buf)
        local parking_list = parking_data.parking_list;
        local count = 0;
        for k, v in pairs(parking_list) do
           count = count + 1; 
        end
        buf:writeString("PKOPENMWND");
        buf:writeInt(my_user_id);
        buf:writeString(touserinfo.nick or "");
        buf:writeString(touserinfo.imgUrl or "");
        buf:writeInt(parking_data.car_type);
        buf:writeInt(parking_data.car_count);
        buf:writeInt(parking_data.parking_count);
        local str_price = tostring(parking_data.car_price)
        buf:writeString(str_price);
        buf:writeInt(count);
        for k, v in pairs(parking_list) do
            buf:writeInt(k);--��λ����
            buf:writeInt(#v.cars);
            for k1, v1 in pairs(v.cars) do
				buf:writeInt(v1.index)				--��������һ�������������б�ʱ�����������
				buf:writeInt(v1.id)					--������  ��������ʾɶͼƬ
				buf:writeByte(v1.is_using)			--�Ƿ�����ʹ�� 1=�ǣ�0=����
                buf:writeByte(v1.cansale)			--�Ƿ���Գ��� 1=�ǣ�0=����
                local salegold = car_match_lib.get_user_car_prize(my_user_id, v1.car_id) or car_match_lib.get_car_cost(v1.car_type);
                buf:writeInt(salegold)			    --���ռ۸�
				buf:writeString(v1.fromuser or "")			--�����˵�����
                buf:writeInt(v1.parking_id or 0);
                buf:writeInt(v1.king_count or 0)
            end

            buf:writeInt(parkinglib.get_parking_count(v.parking_cars));
            for k2, v2 in pairs(v.parking_cars) do
                buf:writeInt(k2);
                local test_over_time = v2.time + v2.oversec
                if (test_over_time > 2147483647) then
                    test_over_time = 2147483647
                end
                if(v2.time ~= nil and v2.time ~= "") then
                    buf:writeString(timelib.lua_to_db_time(v2.time));
                    buf:writeString(timelib.lua_to_db_time(test_over_time));
                else
                    buf:writeString("");
                    buf:writeString("");
                end
            end
        end
        buf:writeInt(parking_data.client_refresh_time or 0);
    end, user_info.ip, user_info.port);
end

-----------------------------------------�����ӿ�------------------------------------------------------
--�Ƿ񲴳�����
parkinglib.is_parking_item = function(item_id) 
    local ret = 0;
    if(parkinglib.OP_PARKING_CARS[item_id] ~= nil)then
        ret = 1;
    end
    return ret;
end

parkinglib.get_using_car_info = function(userinfo)
    local parking_data = parkinglib.user_list[userinfo.userId];   
    local using_car = nil;
    if(parking_data ~= nil) then
        using_car = parking_data.using_car;
        if(using_car and parkinglib.is_active_item(userinfo, using_car.id, using_car.index) == 0) then
           using_car = nil;  
        end
    end
    return using_car;
end

--�Ƿ񼤻�ĵ���(������ǳ�λϵͳ���ߣ�Ĭ����Ϊ�Ǽ����)
parkinglib.is_active_item = function(userinfo, item_id, item_index) 
    local parking_data = parkinglib.user_list[userinfo.userId];   
    local ret = 0;
    if(parking_data == nil) then
        return ret;
    end
    local parking_list = parking_data.parking_list;
    local find = false;
    if(parkinglib.is_parking_item(item_id) == 1) then
        if(parking_list ~= nil) then
            for parking_type, v in pairs(parking_list) do
                for k1, v1 in pairs(v.cars) do
                    if(v1.id == item_id and v1.parking_id > 0 and v1.index == item_index) then
                        find = true;
                        ret = 1;
                        break;
                    end
                end
                if(find == true) then
                    break;
                end
            end
        end
    else
        find = true; 
    end

    if(find == false) then
        ret = 0;
    end
    return ret;
end

------------------------------------------ϵͳ�¼�����-----------------------------------------------

parkinglib.on_after_user_login = function(userinfo)
    parking_db_lib.translate_old_cars_data(userinfo.userId);
    
end
--�û����ߵ�ʱ��
parkinglib.on_user_exit = function(e)
    local user_id = e.data.user_id;
    if(parkinglib.user_list[user_id] ~= nil) then
        parkinglib.user_list[user_id] = nil;
    end
end

parkinglib.on_using_gift = function(e)
    local userinfo = e.data.userinfo;
    local iteminfo = e.data.iteminfo;
    if(userinfo and iteminfo) then
        local parking_data = parkinglib.user_list[userinfo.userId];
        if(parking_data) then
            local parking_list = parking_data.parking_list;
            for k,v in pairs(parking_list) do
                for k1,v1 in pairs(v.cars) do
                    if(v1.is_using == 1) then
                        v1.is_using = 0;
                        parking_data.using_car = nil;
                        car_match_db_lib.update_is_using(userinfo.userId, v1.index, 0);
                        return;
                    end
                end
            end
        end
    end
end

--�û���ӵ��ߵ�ʱ��
parkinglib.on_add_gift_item = function(userinfo, item_id)
    if(parkinglib.user_list[userinfo.userId] ~= nil) then
        parkinglib.user_list[userinfo.userId].refresh = 1;
    end
end

function parkinglib.on_after_sub_user_login(e)
    if(duokai_lib ~= nil) then
        local user_info = e.data.user_info;
        local parent_id = duokai_lib.get_parent_id(user_info.userId);
        parkinglib.user_list[user_info.userId] = parkinglib.user_list[parent_id];
    end
end

--�û���¼��ʱ��
parkinglib.already_init_car = function(e)
    local user_info = usermgr.GetUserById(e.data.user_id);
	if(user_info == nil)then 
		TraceError("parkinglib �û���½���ʼ������,if(user_info == nil)then")
	 	return
    end
    local userId = user_info.userId;
    
    local on_ret = function(user_parking_data)
        --TraceError(user_parking_data);
        parkinglib.user_list[user_info.userId] = user_parking_data;
        if(duokai_lib and duokai_lib.is_sub_user(user_info.userId) == 0) then
            --�������ʺ�
            local all_sub_user = duokai_lib.get_all_sub_user(user_info.userId);
            for sub_user_id, v in pairs(all_sub_user) do
                parkinglib.user_list[sub_user_id] = user_parking_data;
            end
        end
        eventmgr:dispatchEvent(Event("already_init_parking", _S{user_id=user_info.userId}));

        local parking_list = user_parking_data.parking_list;
        --���ڴ���
        --parkinglib.process_parking_time_over(user_info, user_parking_data);

        --�����ֵ�͵ĵ���
        if(user_info.init_give_parking == nil) then
            user_info.init_give_parking = 1;
            parking_db_lib.get_give_parking_db(userId, function(parking_info)
                for k,v in pairs(parking_info) do
                    parking_db_lib.update_give_parking_db(v.id, function(result)
                        --TraceError("result"..result);
                        if(result == 1) then
                            --TraceError("1");
                            parking_db_lib.delete_give_parking_db(v.id);
    
                            --���ͳ�λ
                            local parking_count = v.parking_count;--���͵�����
                            local parking_type = v.parking_type;--���͵�����
                            local data = parking_list[parking_type];
                            --TraceError(data);
    
                            local give_time_count = parking_count;
                            local update = false;
                            if(data.parking_count < parking_count) then
                                --TraceError(data.parking_count);
                                --�û�û����ô��ĳ�λ,�͹���λ
                                give_time_count = data.parking_count;
                                data.parking_count = parking_count;
                                local give_count = parking_count - parkinglib.get_parking_count(data.parking_cars); 
                                update = true;
                                for i = 1, give_count do
                                    table.insert(data.parking_cars, {
                                        id=0,
                                        time=timelib.db_to_lua_time(v.sys_time),
                                        oversec=parkinglib.OP_PARKING_BUY_TIME,
                                    });
                                end
                            end
    
                            if give_time_count > 0 then
                                update = true;
                                local min_parking = nil;
                                --�����û�ʱ��
                                for k5, v5 in pairs(data.parking_cars) do
                                    if(v5.time + v5.oversec < os.time()) then
                                        --������
                                        v5.time = os.time();
                                        v5.oversec = 0;
                                    end
                                    if(min_parking == nil or (min_parking.time + min_parking.oversec) > (v5.time + v5.oversec)) then
                                        min_parking = v5;
                                    end
                                end
    
                                if(min_parking ~= nil) then
                                    --�ӵ�����ʱ��ĳ�λ��
                                    min_parking.oversec = min_parking.oversec + parkinglib.OP_PARKING_BUY_TIME * give_time_count;
                                end
                            end
    
                            if(update == true) then
                                parking_db_lib.add_user_parking_db(userId, data.id, parking_type, data.parking_count, data.parking_cars);
                            end
                        end
                    end);
                end
            end);

            parkinglib.give_free_parking(user_info)
        end
        
        --[[
        for k, v in pairs(parking_list) do
            local carids = {};
            for k1, v1 in pairs(v.cars) do
                table.insert(carids, v1.id);
            end
            if(#carids > 0) then
                parking_db_lib.log_user_car_db(user_info.userId, k, v.parking_count, carids)
            end
        end
        --]]
    end
    parking_db_lib.get_user_parking_db(user_info.userId, on_ret);
    
    
end


parkinglib.on_site_event = function(e)
    local userinfo = e.data.userinfo;
    local deskno = userinfo.desk; 
    local userId = userinfo.userId;
    local parking_data = parkinglib.user_list[userId];
    if(parking_data ~= nil and deskno ~= nil and deskno > 0) then
        local item_id = 0;
        local item_index = 0;
		if parking_data.using_car then
            item_id = parking_data.using_car.id; 
            item_index = parking_data.using_car.index;
            if(parkinglib.is_active_item(userinfo, item_id, item_index) == 0) then
               item_id = 0; 
            end

            if(parkinglib.is_parking_item(item_id) == 0) then
                item_id = 0;
            end
        end

        if(item_id > 0 and (parking_data.last_desk == nil or parking_data.last_desk ~= deskno)) then
            parking_data.last_desk = deskno;
            if(parking_data.enter_desk_data == nil) then
                parking_data.enter_desk_data = {};
            end
            if(parking_data.enter_desk_data[deskno] == nil or parking_data.enter_desk_data[deskno] + 10 * 60 < os.time()) then
                parking_data.enter_desk_data[deskno] = os.time();
                --onsenddeskchat(userinfo.desk, 4, _U("xxxxxx������"), {userId=0, nick=""})
                --�㲥��������
                local sendfunc = function(buf)
                    buf:writeString("PKSHOW")
                    buf:writeInt(item_id);		--��Ӧ��λ��
                    buf:writeString(userinfo.nick);
                end;
                netlib.broadcastdesk(sendfunc, deskno, borcastTarget.all);
            end
        end
    end
end

--�û������ߵ�ʱ��
parkinglib.process_sale_car = function(userinfo, index, callback)
    local parking_data = parkinglib.user_list[userinfo.userId];   
    local parking_list = parking_data.parking_list;
    local find = false;
    local car_info = nil;
    for parking_type, v in pairs(parking_list) do
        find = false;
        for k1, v1 in pairs(v.cars) do
            if(v1.index == index) then
                --�ѳ�λ������������
                car_info = v1;
                table.remove(v.cars, k1);
                if(v1.parking_id ~= nil and v1.parking_id > 0) then
                    --��ճ�λ����
                    for k2, v2 in pairs(v.parking_cars) do
                        if(k2 == v1.parking_id) then
                            find = true;
                            v2.id = 0;
                            v2.idx = 0;
                            break;
                        end
                    end
                end
                break;
            end
        end

        if(find == true) then--and #carids > 0) then
            --���³�λ����״̬
            parking_db_lib.add_user_parking_db(userinfo.userId, v.id, parking_type, v.parking_count, v.parking_cars);
        end

        if(car_info ~= nil) then
            local car_prize = car_match_lib.get_user_car_prize(userinfo.userId, car_info.car_id)
            usermgr.addgold(userinfo.userId, car_prize, 0, new_gold_type.SALECAR, new_gold_type.SALECARTAX, 1, nil, car_info.car_type); 
            break;
        end
    end

    if(car_info == nil) then
        callback(0);
    else
    	callback(1);
    end
    parkinglib.auto_select_parking(userinfo, parking_data);
    parkinglib.net_send_parking_data(userinfo, parking_data, userinfo.userId);
end


function parkinglib.give_free_parking(user_info)
    local user_parking_data = parkinglib.user_list[user_info.userId];
    if(user_parking_data ~= nil and user_parking_data.parking_list ~= nil) then
        local init_parking = 0;
        for k, v in pairs(user_parking_data.parking_list) do
            if(v.id > 0) then
                init_parking = 1;
                break;
            end
        end

        if(init_parking == 0) then
            parking_db_lib.log_user_parking_db(user_info.userId, 1, 1, 0)
        	parkinglib.add_parking(user_info, 1, 1)
			local parking_data = parkinglib.user_list[user_info.userId]
			parkinglib.net_send_parking_data(user_info, parking_data, user_info.userId)
        end
    end
    --[[
	local sql = "select already_give from user_parking_info where user_id = %d"
	sql = string.format(sql, user_info.userId)
	dblib.execute(sql, function(dt)
		if not dt or #dt == 0 then
            parking_db_lib.log_user_parking_db(user_info.userId, 1, 1, 0)
        	parkinglib.add_parking(user_info, 1, 1)
			local parking_data = parkinglib.user_list[user_info.userId]
			parkinglib.net_send_parking_data(user_info, parking_data, user_info.userId)
		end
	end, user_info.userId)--]]
end

--֪ͨ�ó������ȼ�������
function parkinglib.send_can_not_sell_car(user_info, car_type, sell_lv)
    if user_info == nil then return end
    netlib.send(function(buf)
        buf:writeString("CANNOTSELL")
        buf:writeInt(sell_lv)
    end, user_info.ip, user_info.port)
end

--�����б�
cmdHandler = 
{
    ["PKOPENMWND"] = parkinglib.on_recv_open_main_wnd,    --�򿪳�λϵͳ������
    ["PKACTIVE"] = parkinglib.active_parking_site,    --����ĳ����λ
    ["PKCONFIG"] = parkinglib.on_recv_parking_config, --��ȡ��λ����
    ["PKSTUTAS"] = parkinglib.on_recv_parking_status,   --��ȡ��λ��ͨ״̬
    ["PKRENEW"]  = parkinglib.on_recv_parking_renew,            --��λ����
    ["PKSALE"] = parkinglib.on_recv_sale_car,         --���۳���
    ["PKUSING"] = parkinglib.on_recv_using_car,       --��������
}


--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end


eventmgr:addEventListener("on_user_exit", parkinglib.on_user_exit);
eventmgr:addEventListener("site_event", parkinglib.on_site_event);
eventmgr:addEventListener("on_using_gift", parkinglib.on_using_gift);
eventmgr:addEventListener("already_init_car", parkinglib.already_init_car);
eventmgr:addEventListener("h2_on_sub_user_login", parkinglib.on_after_sub_user_login)


