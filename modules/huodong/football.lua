TraceError("init football huodong")
------------------------------------�¼��Ƴ�----------------------------------------

if footballlib and footballlib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", footballlib.on_user_exit)
end

if footballlib and footballlib.on_server_start then
	eventmgr:removeEventListener("on_server_start", footballlib.on_server_start)
end

--------------------------------------------------------------------------------------

--���򾺲�
if not footballlib then
footballlib = 
{
    
   xia_zhu = NULL_FUNC,                --��ע
    do_jie_suan = NULL_FUNC,                --���㣨�ֹ����У�
---------ϵͳ�¼�----------------------------------------------
   
    on_user_exit = NULL_FUNC,                   --�û��˳�
    on_server_start = NULL_FUNC,                   --��Ϸ����    
---------------------------------------------------------------  
    on_recv_open_main_wnd = NULL_FUNC,     --�����������
    on_recv_open_score_wnd = NULL_FUNC,     --����򿪱ȷ־��´���
    
----------------------------------------------------------------
	check_datetime = NULL_FUNC,            --���ʱ��
	check_can_game = NULL_FUNC,			   --����ܲ�����
    
    
------------------------���͵��ͻ��˵�Э�麯��----------------------------------------

    net_send_match_data = NULL_FUNC,      --���ͱ�������
    net_send_score_data = NULL_FUNC,      --���ͱ����ȷ־�������
    net_send_match_status = NULL_FUNC,      --���ͱ���״̬
    net_send_error_msg = NULL_FUNC,      --������ע������ʾ
    net_send_result = NULL_FUNC,      --���;��½��
    

----------------------------------ȫ�ֱ���-----------------------------------------
    
    user_list   = {},       --�û��������
    caichi1 = 0,            --ʤƽ���Ĳʳ�
    caichi2 = 0,            --�ȷֵĲʳ�
    caichi = {
        [1] = {0,0},
        [2] = {0,0},
    },

    
    
--------------------��Ӫ�ɵ�������ʼ��------------------------------------------------------------------------  
    OP_MATCHES_DATA = {
        [1] = {
            status = 0,     --0:δ��ʼ,1:������,2:�ѽ���
            last_time = 0,
            begin_time = "2012-05-20 02:45:00",
            score = "", --�ȷ�
            team1 = {name = "����",score = 0},
            team2 = {name = "�ж���",score = 0},
            [1] = {desc = "��ʤ",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
            [2] = {desc = "ƽ",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
            [3] = {desc = "��ʤ",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
            [4] = {desc = "�ȷ�ʤ��",pay_count = 0, peilv = 0,result = 0},

        },
        [2] = {
            status = 0,     --0:δ��ʼ,1:������,2:�ѽ���
            last_time = 0,
            score = "", --�ȷ�
            begin_time = "2012-04-26 02:45",
			team1 = {name = "�ʼ������",score = 0},
            team2 = {name = "����",score = 0},
            [1] = {desc = "��ʤ",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
            [2] = {desc = "ƽ",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
            [3] = {desc = "��ʤ",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
            [4] = {desc = "�ȷ�ʤ��",pay_count = 0, peilv = 0,result = 0},--��Ʊ��,--����,--���,0:Ϊ����,1:����

        },
    },

    OP_SCORE_DATA = {    --ʤƽ�����������
        [1] = {
                {desc = "1:0",pay_count = 0, peilv = 1,result = 1},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "4:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "4:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "4:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "ʤ����",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "ƽ����",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:4",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:4",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                 {desc = "2:4",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                 {desc = "������",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                },
        [2] = {
                {desc = "1:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "4:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "4:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "4:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "ʤ����",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:0",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "3:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "ƽ����",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:1",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:2",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "2:3",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "0:4",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                {desc = "1:4",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                 {desc = "2:4",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                 {desc = "������",pay_count = 0, peilv = 1,result = 0},    --��Ʊ��,--����,--���,0:Ϊ����,1:����
                },
    },
    
    OP_START_TIME = "2012-05-18 08:00:00",  --���ʼʱ��
    OP_END_TIME = "2012-05-21 00:00:00",  --�����ʱ��
	OP_QP_ROOM = 62022, --�������ĸ����俪��Ϸ
	OP_TEX_ROOM = 18001, --�������ĸ����俪��Ϸ	
}
end



------------------------------------��������----------------------------------------

------------------------------------ͨ�÷���----------------------------------
--�����Чʱ�䣬��ʱ����int	0�����Ч�������Ҳ�ɲ�������1�����Ч
function footballlib.check_datetime()
	local sys_time = os.time();	
	local startime = timelib.db_to_lua_time(footballlib.OP_START_TIME);
	local endtime = timelib.db_to_lua_time(footballlib.OP_END_TIME);
			
	if(sys_time > startime and sys_time <= endtime) then
		return 1;
	end
 
	--�ʱ���ȥ��
	return 0;

end


--����ǲ�������
function footballlib.check_can_game()
	local can_game=1
	if (footballlib.is_valid_room()~=1) then return 0 end
	can_game=footballlib.check_datetime()
   return can_game
end

--�ǲ����ڹ涨�ķ�������
footballlib.is_valid_room=function()
	if(gamepkg.name == "tex" and footballlib.OP_TEX_ROOM ~= tonumber(groupinfo.groupid))then
		return 0
	end
	--if(gamepkg.name ~= "tex" and footballlib.OP_QP_ROOM ~= tonumber(groupinfo.groupid))then
	--	return 0
	--end
	--���Ƹĳ�ֻ��commonsvr�Ϸ�
	if(gamepkg.name ~= "tex" and gamepkg.name ~= "commonsvr")then
		return 0
	end
	return 1
end

--����Ƿ�����Чʱ����
footballlib.on_recv_check_status = function(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	local user_id=user_info.userId;
   	
   	--��һ���ǲ�����ָ���ķ�����
   	local status=footballlib.check_datetime()
	
   	netlib.send(function(buf)
            buf:writeString("FTACTIVE");
            buf:writeInt(status or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
        end,user_info.ip,user_info.port);
end

------------------------------------������----------------------------------------
footballlib.on_recv_open_main_wnd  = function(buf)    --�򿪾���������
    if footballlib.check_can_game() ~= 1 then return end

    --TraceError("OP wnd")
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 

    --�жϱ���״̬
    --����
    for i = 1, 1 do
        if footballlib.OP_MATCHES_DATA[i].status ~= 4 then
            local begin_time = timelib.db_to_lua_time(footballlib.OP_MATCHES_DATA[i].begin_time);
            local past_time = os.time() - begin_time;
            local status = 0
            local last_time = 0
            if past_time < -3600 then
                status = 1; --����Ͷע
            elseif past_time >= -3600 and past_time <= 0 then
                status = 2; --��������ʱ
                last_time = -past_time
            elseif past_time >= 0 and past_time <= 120 * 60 then
                status = 3; --������ʼ���ȴ��佱
            --else
            --    status = 4;
            end
            
            footballlib.OP_MATCHES_DATA[i].status = status;
            footballlib.OP_MATCHES_DATA[i].last_time = last_time;
        end

    end
    footballlib.net_send_match_status(user_info);


    
    if footballlib.user_list[user_info.userId] == nil then
        --TraceError("new user")
        local on_ret = function(user_match_data)
            --�û����ݸ�ʽ,user_match_data
            --[1]:match_id
            --[1][1-4]:��ʤ,ƽ,��ʤ,�ȷ־��µ��ҵ�Ʊ��
            
            
            footballlib.user_list[user_info.userId] = {}
            footballlib.user_list[user_info.userId].match_data = user_match_data
            local my_pay_count = 0
            for k,v in pairs(user_match_data) do
                for k1,v1 in pairs(v) do
                    my_pay_count = my_pay_count + v1
                end
            end

            footballlib.user_list[user_info.userId].pay_count = my_pay_count
            footballlib.user_list[user_info.userId].score_data = {}     
            
            --���͸��ͻ�������
            footballlib.net_send_match_data(user_info,user_info.userId);    

         end

        --��ȡ�û���������
        football_db_lib.get_football_match_db(user_info.userId,on_ret)
       
    else
        --���͸��ͻ�������
        footballlib.net_send_match_data(user_info,user_info.userId);
    end

    --���������
    local call_back = function(paiming_list)
        --TraceError("paiming 1")
        --TraceError(paiming_list)
        local len = #paiming_list;
        if paiming_list[len][2] > 0 then
            local data = paiming_list[len]
            table.remove(paiming_list,len)
            table.insert(paiming_list,1,data)
	else
	    table.remove(paiming_list,len)
        end
        footballlib.net_send_result(user_info,paiming_list);
    end
    for i = 2 ,1,-1 do
        if footballlib.OP_MATCHES_DATA[i].status == 4 then
            football_db_lib.get_paiming_list(user_info.userId,i,6,call_back)
            break;
        end

    end

end


footballlib.on_recv_open_score_wnd = function(buf)   --�򿪱ȷ־��´���
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 

    local match_id = buf:readByte() --����ID,1-2.
    
    if footballlib.OP_MATCHES_DATA[match_id] == nil  or footballlib.user_list[user_info.userId] == nil then
        return
    end
    
    

    if footballlib.user_list[user_info.userId].score_data[match_id] == nil then
        local on_ret = function(user_score_data)
            --�û����ݸ�ʽ,user_score_data
            --[1]:match_id
            --[1][1-?]:���ֱȷֵ��ҵ�Ʊ��
            
            footballlib.user_list[user_info.userId].score_data[match_id] = user_score_data

            footballlib.net_send_score_data(user_info,user_info.userId,match_id);
		end
        --��ȡ�û���������
        football_db_lib.get_football_score_db(user_info.userId,match_id,on_ret)
        
    else
        footballlib.net_send_score_data(user_info,user_info.userId,match_id);
    end


end



footballlib.xia_zhu = function(user_info,pay_count,match_id)
    --�ж�Ǯ�Ƿ������ע
    local result = 1    --��-1��Ǯ������-2���Ѿ����ⶥ��
    if gamepkg.name == "tex" then
        if user_info.gamescore < pay_count * 10000 then --����
            result = -1;
            return result
        end
    elseif user_info.gamescore < pay_count * 100000 then    --���ƽ��
            result = -1;
            return result
    end

    --�ж��Ƿ�ⶥ
    local limit_pay=10000
    if gamepkg.name ~= "tex" then limit_pay=100000 end
    if footballlib.user_list[user_info.userId].pay_count + pay_count > limit_pay then
        result = -2
        return result
    end

    --�ж��Ƿ���ǰһСʱ
    if tonumber(timelib.db_to_lua_time(footballlib.OP_MATCHES_DATA[match_id].begin_time)) - os.time() < 3600 or footballlib.OP_MATCHES_DATA[match_id].status ~= 1 then
        result = -3
        return result
    end

    --�ж��Ƿ�����Ϸ��
    if (user_info.site ~= nil) then
        result = -4
        return result
    end
    --��Ǯ
    if gamepkg.name == "tex" then
        usermgr.addgold(user_info.userId,-pay_count * 10000,0,new_gold_type.FOOTBALL,-1);
    else
        usermgr.addgold(user_info.userId,-pay_count * 100000,0,new_gold_type.FOOTBALL,-1);
    end

    footballlib.user_list[user_info.userId].pay_count = footballlib.user_list[user_info.userId].pay_count + pay_count

    return result;
end

footballlib.on_recv_click_win_lose_btn  = function(buf)    --���ʤƽ�����µİ�ť
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 

    local match_id = buf:readByte() --����ID,1-2.
    local btn_id = buf:readByte()   --��עID:1:��ʤ,2:ƽ,3:��ʤ
    local pay_count = buf:readInt()    --��ע��Ʊ��.

    if footballlib.user_list[user_info.userId] == nil or footballlib.user_list[user_info.userId].match_data == nil then
        return
    end

    local result = footballlib.xia_zhu(user_info,pay_count,match_id)
    
    if result == 1 then

        footballlib.user_list[user_info.userId].match_data[match_id][btn_id] = footballlib.user_list[user_info.userId].match_data[match_id][btn_id] + pay_count;
        footballlib.OP_MATCHES_DATA[match_id][btn_id].pay_count = footballlib.OP_MATCHES_DATA[match_id][btn_id].pay_count + pay_count;
        footballlib.caichi1 = footballlib.caichi1 + pay_count
        footballlib.caichi[match_id][1] = footballlib.caichi[match_id][1] + pay_count
    
        --���¼�������
        for i = 1, 1 do
            local data = footballlib.OP_MATCHES_DATA[i]
            for j = 1,4 do
                local total_count = data[j].pay_count
                if total_count > 0 then
                    data[j].peilv = tonumber(string.format("%.2f", (footballlib.caichi[i][1] * 0.9) / total_count))
                end

            end
        end
		local peilv_info = ""
		for i = 1, 3 do    --д������
			if (i ~= 1) then
				peilv_info = peilv_info..","
			end
			peilv_info = peilv_info..footballlib.OP_MATCHES_DATA[match_id][i].peilv			
	   end
       football_db_lib.record_match_data(user_info.userId,btn_id,pay_count,match_id);
        football_db_lib.record_match_caichi(match_id, btn_id, footballlib.OP_MATCHES_DATA[match_id][btn_id].pay_count, peilv_info)
    
        --�㲥
        for k,v in pairs(footballlib.user_list) do
            local user = usermgr.GetUserById(k)
            if user ~= nil then
            	footballlib.net_send_match_data(user,user_info.userId);
        	end
            	
        end
    else
        footballlib.net_send_error_msg(user_info,result)
    end

    

end

footballlib.on_recv_click_score_btn = function(buf)    --����ȷ־��µİ�ť
    local user_info = userlist[getuserid(buf)]
    if(user_info == nil)then return end 

    local match_id = buf:readByte() --����ID,1-2.
    local btn_id = buf:readByte()   --��עID,���ݽ�����������ۼ�,��1��.
    local pay_count = buf:readInt()    --��ע��Ʊ��.

	if footballlib.user_list[user_info.userId] == nil or footballlib.user_list[user_info.userId].score_data == nil then
        return
    end
    
    --�ж��Ƿ������ע
    local result = footballlib.xia_zhu(user_info,pay_count,match_id)


    if result == 1 then
        if footballlib.user_list[user_info.userId].score_data[match_id] == nil then
            footballlib.user_list[user_info.userId].score_data[match_id] = {}
        end
    
        local my_pay_count = footballlib.user_list[user_info.userId].score_data[match_id][btn_id] or 0
        footballlib.user_list[user_info.userId].score_data[match_id][btn_id] = my_pay_count + pay_count;

        footballlib.user_list[user_info.userId].match_data[match_id][4] =  footballlib.user_list[user_info.userId].match_data[match_id][4] + pay_count;

        footballlib.OP_SCORE_DATA[match_id][btn_id].pay_count = footballlib.OP_SCORE_DATA[match_id][btn_id].pay_count + pay_count;
    
        
        footballlib.OP_MATCHES_DATA[match_id][4].pay_count = footballlib.OP_MATCHES_DATA[match_id][4].pay_count + pay_count;
       

        footballlib.caichi2 = footballlib.caichi2 + pay_count

        footballlib.caichi[match_id][2] = footballlib.caichi[match_id][2] + pay_count
        
    
        --���¼�������
        for k,v in pairs(footballlib.OP_SCORE_DATA[match_id]) do
            if v.pay_count > 0 then
                v.peilv = tonumber(string.format("%.2f", (footballlib.caichi[match_id][2] * 0.9) / v.pay_count))
            end

        end
    
        football_db_lib.record_score_data(user_info.userId,btn_id,pay_count,match_id);
		
        --football_db_lib.record_score_caichi(match_id,btn_id,footballlib.OP_SCORE_DATA[match_id][btn_id].pay_count,footballlib.OP_SCORE_DATA[match_id][btn_id].peilv)
		local peilv_info = ""
		for i = 1, 25 do    --д������
			if (i ~= 1) then
				peilv_info = peilv_info..","
			end
			peilv_info = peilv_info..footballlib.OP_SCORE_DATA[match_id][i].peilv			
	   end
		football_db_lib.record_score_caichi(match_id, btn_id, footballlib.OP_SCORE_DATA[match_id][btn_id].pay_count, peilv_info)
        --�㲥
        for k,v in pairs(footballlib.user_list) do
            local user = usermgr.GetUserById(k)
            if user ~= nil then
            	footballlib.net_send_score_data(user,user_info.userId,match_id);
                footballlib.net_send_match_data(user,user_info.userId);
        	end
            	
        end
    else
        footballlib.net_send_error_msg(user_info,result)
    end

    
end


------------------------------------���͵��ͻ��˵�Э�麯��----------------------------------------
--������ע����֪ͨ
footballlib.net_send_error_msg = function(user_info,result)
    

    netlib.send(function(buf_out)
        buf_out:writeString("FTERROR")
		buf_out:writeByte(result)   --:-1:Ǯ������-2��������ע�Ѿ�����
    end, user_info.ip, user_info.port)
end

footballlib.net_send_match_status = function(user_info)
    --TraceError("ftstate")
    
    netlib.send(function(buf_out)
        buf_out:writeString("FTSTATE")
        for i=1,1 do
    		buf_out:writeByte(i)   --�û�ID       
            buf_out:writeByte(footballlib.OP_MATCHES_DATA[i].status)
            buf_out:writeInt(footballlib.OP_MATCHES_DATA[i].last_time)
            buf_out:writeString(footballlib.OP_MATCHES_DATA[i].score)  
        end

    end, user_info.ip, user_info.port)
end

footballlib.net_send_result = function(user_info,paiming_list)
    --TraceError("paiming")
    --TraceError(paiming_list)
     netlib.send(function(buf_out)
        buf_out:writeString("FTWINNER")
		buf_out:writeInt(#paiming_list)                
        for i = 1,#paiming_list do  
            buf_out:writeByte(paiming_list[i][4] or 0) 
            buf_out:writeInt(paiming_list[i][1] or 0)
            buf_out:writeString(paiming_list[i][3] or "")   
            if gamepkg.name ~= "tex" then
                buf_out:writeInt(paiming_list[i][2] or 0)   
            else
                buf_out:writeInt(paiming_list[i][2] or 0)
            end

        end
    end, user_info.ip, user_info.port)

end

--��������ʱ,֪ͨ�ͻ��˾�������
footballlib.net_send_match_data = function(user_info,my_user_id)
    if  footballlib.user_list == nil then
        return
    end

    --TraceError("send data"..my_user_id)
    netlib.send(function(buf_out)
        buf_out:writeString("FTOPENMWND")
		buf_out:writeInt(my_user_id)   --�û�ID       
        buf_out:writeInt(footballlib.caichi1 or 0)   --ʤƽ���ʳ�
        buf_out:writeInt(footballlib.caichi2 or 0)   --�ȷֲʳ�
        for i = 1,1 do  --��ʱд����������һ��
            local data = footballlib.OP_MATCHES_DATA[i]
            for j = 1,4 do
                buf_out:writeInt(tonumber(data[j].pay_count or 0))   --��Ʊ��
                buf_out:writeString(tostring(data[j].peilv or 0))   --����
                buf_out:writeInt(tonumber(footballlib.user_list[my_user_id].match_data[i][j] or 0))   --�ҵ�Ʊ��
            end
        end
    end, user_info.ip, user_info.port)
end

--�򿪱ȷ־��´���
footballlib.net_send_score_data = function(user_info,my_user_id,match_id)
    --TraceError("sceore"..match_id)
    if footballlib.OP_SCORE_DATA[match_id] == nil or footballlib.user_list == nil or footballlib.user_list[my_user_id].score_data == nil then
        return
    end

    --TraceError("send score data")

    netlib.send(function(buf_out)
        buf_out:writeString("FTOPENSWND")
        buf_out:writeByte(match_id)
        buf_out:writeInt(my_user_id)   --�û�ID  
        for i = 1, 25 do    --д������
                buf_out:writeInt(footballlib.OP_SCORE_DATA[match_id][i].pay_count or 0)   --��Ʊ��
                buf_out:writeString(tostring(footballlib.OP_SCORE_DATA[match_id][i].peilv or 0))   --����
                buf_out:writeInt(footballlib.user_list[my_user_id].score_data[match_id][i] or 0)   --�ҵ�Ʊ��
        end
    end, user_info.ip, user_info.port)
end



------------------------------------ϵͳ�¼�����----------------------------------------
--��Ϸ����
footballlib.on_server_start = function()
    --TraceError("server start")

    if footballlib.check_can_game() ~= 1 then return end
    
    --��������������ȡ����
    local call_back1 = function(caichi_list,peilv_list,match_id)
        --TraceError(match_id)
        --TraceError(caichi_list)
        for i=1,3 do
            footballlib.OP_MATCHES_DATA[match_id][i].pay_count = caichi_list[i];
            footballlib.OP_MATCHES_DATA[match_id][i].peilv = peilv_list[i];
            footballlib.caichi1 = footballlib.caichi1 + caichi_list[i];
            footballlib.caichi[match_id][1] = footballlib.caichi[match_id][1] + caichi_list[i]
        end

        
    end
    local call_back2 = function(caichi_list,peilv_list,match_id)
        for i=1,25 do
            footballlib.OP_SCORE_DATA[match_id][i].pay_count = caichi_list[i];
            footballlib.OP_SCORE_DATA[match_id][i].peilv = peilv_list[i];
            footballlib.caichi2 = footballlib.caichi2 + caichi_list[i];

            footballlib.caichi[match_id][2] = footballlib.caichi[match_id][2] + caichi_list[i]

            footballlib.OP_MATCHES_DATA[match_id][4].pay_count = footballlib.OP_MATCHES_DATA[match_id][4].pay_count + caichi_list[i];
        end

        
    end
    for i = 1,2 do
        football_db_lib.get_match_caichi(i,call_back1)
        football_db_lib.get_score_caichi(i,call_back2)
    end

end

--ע�⣺�ֹ����㣬��ִ̨�У��Ƚ����״̬�����޸ġ�
footballlib.do_jie_suan = function(match_id,score,match_data_id,score_data_id)

    if footballlib.OP_MATCHES_DATA[match_id].status == 4 then return end

    footballlib.OP_MATCHES_DATA[match_id].score = score;
    footballlib.OP_MATCHES_DATA[match_id][match_data_id].result = 1
    footballlib.OP_SCORE_DATA[match_id][score_data_id].result = 1


    football_db_lib.jieshuan_match(match_id,match_data_id);
    football_db_lib.jieshuan_score(match_id,score_data_id);
    
    footballlib.OP_MATCHES_DATA[match_id].status = 4 --�Ѿ�����������

    TraceError("success")
    
end

--�û������¼�
footballlib.on_user_exit = function(e)

    if footballlib.check_can_game() ~= 1 then return end


    --TraceError("clear");
    --����û�����
    footballlib.user_list[e.data.user_id] = nil;
end


------------------------------------�¼����----------------------------------------
--��Ϸ��ʼ�¼�
eventmgr:addEventListener("on_server_start", footballlib.on_server_start)

--�û��˳�
eventmgr:addEventListener("on_user_exit", footballlib.on_user_exit);


------------------------------------������Ӧ----------------------------------------
--�����б�
cmdHandler = 
{
    ["FTOPENMWND"] = footballlib.on_recv_open_main_wnd,    --�򿪾���������
    ["FTOPENSWND"] = footballlib.on_recv_open_score_wnd,    --�򿪱ȷ־��´���
    ["FTCLICKWLBTN"] = footballlib.on_recv_click_win_lose_btn,    --���ʤƽ�����µİ�ť
    ["FTCLICKSCBTN"] = footballlib.on_recv_click_score_btn,    --����ȷ־��µİ�ť
    
    ["FTACTIVE"] = footballlib.on_recv_check_status,    ---����Ƿ�����
    
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

--dofile("games/modules/config_for_yunyin.lua")
