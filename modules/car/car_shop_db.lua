TraceError("init car_shop_db...")

if not car_shop_db_lib then
    car_shop_db_lib = _S
    {
        --����
    }
end

function car_shop_db_lib.record_exchange_log(user_id, car_type, num)
    local sql = "insert into log_car_exchange_info(user_id, num, car_type, sys_time) value(%d, %d, %d, now())"
    sql = string.format(sql, user_id, num, car_type)
    dblib.execute(sql)
end

------------------------------------------------����Э��--------------------------------------------
cmdHandler =
{
    --["CARJOIN"]     = car_match_sj_lib.on_recv_baoming,                --������    
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do
    cmdHandler_addons[k] = v
end

--eventmgr:addEventListener("timer_second", car_match_lib.timer);
--eventmgr:addEventListener("on_server_start", car_match_lib.restart_server);
--eventmgr:addEventListener("gm_cmd", car_match_lib.gm_cmd)

