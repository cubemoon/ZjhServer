--gm��������
--[[
    ���Ǽ�Ӯwin_pos 1����Ӯ�� 2�ù�Ӯ
    peilv Ӯ��������
    function super_cow_lib.change_win_lost(win_pos, peilv) 
--]]

if super_cow_lib and super_cow_lib.on_gm_cmd then
	eventmgr:removeEventListener("gm_cmd", super_cow_lib.on_gm_cmd)
end

--gm����
super_cow_lib.on_gm_cmd = function(e)
    if (e.data["cmd"] == "sc_default_percent") then
        local args = e.data["args"]
        if (args[1] == nil) then
            gm_lib.send_gm_ret(e.data["user_id"], "��������")
            return
        end
        super_cow_lib.gm_set_default_percent(tonumber(args[1]))
        if (ret <= 0) then
            gm_lib.send_gm_ret(e.data["user_id"], "ִ�д���,��������")
        else
            gm_lib.send_gm_ret(e.data["user_id"], "ִ�гɹ�")
        end
    elseif (e.data["cmd"] == "sc_win_score") then
        local args = e.data["args"]
        if (#args < 2) then
            gm_lib.send_gm_ret(e.data["user_id"], "��������,��������")
            return
        end
        local ret = super_cow_lib.gm_start_win_score(tonumber(args[1]), tonumber(args[2]))
        if (ret <= 0) then
            gm_lib.send_gm_ret(e.data["user_id"], "ִ�д���,��������")
        else
            gm_lib.send_gm_ret(e.data["user_id"], "ִ�гɹ�")
        end        
    elseif (e.data["cmd"] == "sc_lose_score") then
        local args = e.data["args"]
        if (#args < 2) then
            gm_lib.send_gm_ret(e.data["user_id"], "��������,��������")
            return
        end
        local ret = super_cow_lib.gm_start_lose_score(tonumber(args[1]), tonumber(args[2]))
        if (ret <= 0) then
            gm_lib.send_gm_ret(e.data["user_id"], "ִ�д���,��������")
        else
            gm_lib.send_gm_ret(e.data["user_id"], "ִ�гɹ�")
        end
    elseif (e.data["cmd"] == "sc_get_sys_win_score") then
        gm_lib.send_gm_ret(e.data["user_id"], tostring(super_cow_lib.sys_win_gold))
    end
end

super_cow_lib.gm_set_default_percent = function(percent)
    if percent > 1 or percent < 0.5 then return 0 end
    super_cow_lib.GM_DEFAULT_PERCENT = percent;
    return 1
end

--�ӷ�
--�������ӵ���Ŀ��ֵ������С��Ŀǰ��Ӯ�������ʣ�����С��0.5���ߴ���1��
super_cow_lib.gm_start_win_score = function(target_score,percent)
    if percent > 1 or percent < 0.5 then return 0 end
    local sys_win_gold = super_cow_lib.sys_win_gold;    
    if target_score <= sys_win_gold then return 0 end;

    super_cow_lib.GM_WIN_TARGET = target_score;
    super_cow_lib.GM_WIN_PERCENT = percent;

    super_cow_lib.GM_LOSE_TARGET = nil;
    super_cow_lib.GM_LOSE_PERCENT = nil;
    return 1 
end

--����
--������������Ŀ��ֵ�����ܴ���Ŀǰ��Ӯ�������ʣ�����С��0.5���ߴ���1��
super_cow_lib.gm_start_lose_score = function(target_score,percent)
    if percent > 1 or percent < 0.5 then return 0 end
    local sys_win_gold = super_cow_lib.sys_win_gold;

    if target_score >= sys_win_gold then return 0 end;

    super_cow_lib.GM_LOSE_TARGET = target_score;
    super_cow_lib.GM_LOSE_PERCENT = percent;
    super_cow_lib.GM_WIN_TARGET = nil;
    super_cow_lib.GM_WIN_PERCENT = nil;
    return 1 
end

--������¼�
function super_cow_lib.on_jiesuan()
    local sys_win_gold = super_cow_lib.sys_win_gold;
    
    --�Ƿ�Ҫ�ӷ�
    if super_cow_lib.GM_WIN_TARGET ~= nil and super_cow_lib.GM_WIN_PERCENT ~= nil then
        if sys_win_gold >= super_cow_lib.GM_WIN_TARGET then
            super_cow_lib.GM_WIN_TARGET = nil;
            super_cow_lib.GM_WIN_PERCENT = nil;
            --����ϵͳ��Ӯ��Ǯ
            super_cow_db_lib.update_sys_win(0)
            super_cow_lib.sys_win_gold = 0
        end
    end

    --�Ƿ�Ҫ����
    if super_cow_lib.GM_LOSE_TARGET ~= nil and super_cow_lib.GM_LOSE_PERCENT ~= nil then
        if sys_win_gold <= super_cow_lib.GM_LOSE_TARGET then
            super_cow_lib.GM_LOSE_TARGET = nil;
            super_cow_lib.GM_LOSE_PERCENT = nil;
            --����ϵͳ��Ӯ��Ǯ
            super_cow_db_lib.update_sys_win(0)
            super_cow_lib.sys_win_gold = 0
        end
    end
end

--[[
    ��ע�����¼�
    bet_info = {
        1 = 100,  --�ڹ���100
        2 = 200,  --������200
    }
--]]
function super_cow_lib.on_bet_over(bet_info)
    local more_site = 1;
    local less_site = 2;    
    if bet_info[2] > bet_info[1] then
        more_site = 2;
        less_site = 1;
    end
    local n = math.random(0, 100);
    --�Ƿ�Ҫ�ӷ�
    if super_cow_lib.GM_WIN_TARGET ~= nil and super_cow_lib.GM_WIN_PERCENT ~= nil then
        if n <= super_cow_lib.GM_WIN_PERCENT * 100 then                       
            local n2 = math.random(0, 100);
            local peilv = 2
            if (n2 < 5) then
                peilv = 7
            elseif (n2 < 20) then
                peilv = 5
            end
            super_cow_lib.change_win_lost(less_site,  peilv);
        end
        return;
    end

    --�Ƿ�Ҫ����
    if super_cow_lib.GM_LOSE_TARGET ~= nil and super_cow_lib.GM_LOSE_PERCENT ~= nil then
        if n <= super_cow_lib.GM_LOSE_PERCENT * 100 then
            local n2 = math.random(0, 100)            
            local peilv = 2
            if (n2 < 5) then
                peilv = 7
            elseif (n2 < 20) then
                peilv = 5
            end
            super_cow_lib.change_win_lost(more_site, peilv);
        end
        return;
    end

    --Ĭ�ϵ�����ֵ
    if super_cow_lib.GM_DEFAULT_PERCENT == nil  then super_cow_lib.GM_DEFAULT_PERCENT = 0.6 end;
    if n <= (super_cow_lib.GM_DEFAULT_PERCENT - 0.5) * 100 then        
        super_cow_lib.change_win_lost(less_site, 2);
    end
end

eventmgr:addEventListener("gm_cmd", super_cow_lib.on_gm_cmd) 

