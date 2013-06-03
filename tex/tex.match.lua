
--��ʼ��������Ϣ
TraceError("��ʼ�����ݱ�����Ϣ")

if tex_match and tex_match.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", tex_match.on_after_user_login);
end

if tex_match and tex_match.ontimecheck then
	eventmgr:removeEventListener("timer_minute", tex_match.ontimecheck);
end

tex_match = _S
{
	init = NULL_FUNC,    --��ʼ��   
	add_queue=NULL_FUNC,
	get_base_score=NULL_FUNC,
	get_out_score=NULL_FUNC,
	get_match_id_by_desk_no=NULL_FUNC,
	get_pre_match_win_lost_info=NULL_FUNC,
	is_all_game_over=NULL_FUNC,
	get_match_user_num=NULL_FUNC,
	get_score_rank=NULL_FUNC,
    process_pre_match_over=NULL_FUNC,
	is_final_match_round_over=NULL_FUNC,
	get_final_match_round_rank=NULL_FUNC,
	process_final_match_round_over=NULL_FUNC,
	on_game_over=NULL_FUNC,
	on_user_game_over=NULL_FUNC,
	join_match=NULL_FUNC,
	exit_match=NULL_FUNC,
	start_match=NULL_FUNC,
	on_recv_jbs_info=NULL_FUNC,
	on_recv_jbs_baomin=NULL_FUNC,
	on_recv_jbs_cancel=NULL_FUNC,
	update_invite_ph_list=NULL_FUNC,
	on_recv_invite_ph_list=NULL_FUNC,
	on_recv_invite_dj=NULL_FUNC,
	can_join_invite_match=NULL_FUNC,
	can_sit_invite_desk=NULL_FUNC,
	on_recv_refresh_timeinfo=NULL_FUNC,
	on_after_user_login=NULL_FUNC,
	init_invite_ph=NULL_FUNC,
	init_invate_match=NULL_FUNC,
	get_invate_match_id=NULL_FUNC,
	get_invate_match_count=NULL_FUNC,
	on_recv_already_know_reward=NULL_FUNC,
	invite_match_fajiang=NULL_FUNC,
	ontimecheck=NULL_FUNC,
	invite_update_user_play_count=NULL_FUNC,
	
	on_recv_activity_stat = NULL_FUNC,	--����ʱ��״̬
	on_recv_sign = NULL_FUNC,		--����������
	sign_succes = NULL_FUNC,	--�����ɹ�
	
	update_invite_db = NULL_FUNC,	--���±�����Ϣ	
	update_play_count = NULL_FUNC, 	--�����������
	consider_screen = NULL_FUNC,	--����ڼ���
	inster_invite_db = NULL_FUNC,	--����д���ݿ�
	
	on_recv_buy_ticket = NULL_FUNC,		--���������ȯ
	
	send_buy_ticket_result = NULL_FUNC,	--���͹������ȯ���
	
	statime = "2012-01-17 20:00:00",  --���ʼʱ��
    endtime = "2012-02-7 23:00:00",  --�����ʱ��
    
    rank_endtime = "2012-02-09 00:00:00",	--���а����ʱ��
 --   exttime = "2011-11-14 00:00:00",  --ֻ���콱ʱ��
    room_smallbet1=-50,
    room_smallbet2=500,
    room_smallbet3=20000,
    refresh_invate_time=-1,  --��һ��ˢ�����а��ʱ��
	last_msg_time=-1, --��һ�η���Ϣ��ʱ��
    invite_ph_list_zj={}, --ר�ҳ�����
    invite_ph_list_zy={}, --ְҵ������
    invite_ph_list_yy={}, --ҵ�ೡ����
 
}

if (tex_match == nil) then
    tex_match = 
    {
        group_list = {},  --������
        --[[
            [match_id] =
            {
                user_list = 
                {   
                    user_id=
                    {
                        score = 0, --����                        
                        join_time = os.time(),
                        round_num = 0,  --���˼���
                    }
                }
                stage = 0 -- �����׶� 1��ʾ������2��ʾ����
                start_time = xx
            }         
        --]]
        index_match_id = 1;
        -----------------------��������-----------------------------------
        round_num = 3,      --һ�ִ򼸸���
        ------------------------------------------------------------------
        -----------------------��������-----------------------------------
        init_score = 10,       --��ʼ����
        min_score = 10,        --��������̭�ķ���
        max_score = 10,        --���������ķ���
        start_game_user = 3,   --������ʼ����
        pass_user_num = 1,     --��������
        ------------------------------------------------------------------
        is_match_group = 0,    --�Ƿ��Ǳ���������
        
    }
end


--��̨�� begin

function tex_match.init()
if true then return end
end

--����һ���û����ŶӶ����н����Ŷ�
function tex_match.add_queue(user_id)
if true then return end
end

--�õ�ĳһ����������Ϸ������
function tex_match.get_base_score(match_id)
    local match_group_item = tex_match.group_list[match_id]
    if (match_group_item == nil) then
        TraceError("Ϊ��û�д˱�����Ϣ")
        return 0
    end
    --60s����20%
    local time_min = math.floor((os.time() - match_group_item.start_time) / 60)
    if (time_min == 0) then
        return tex_match.init_score
    else
        return math.floor(tex_match.init_score * math.pow(1.2, time_min))
    end
end

--��ȡ��̭��
function tex_match.get_out_score(match_id)
    return tex_match.get_base_score(match_id) * 2
end

--�������Ż�õ�ǰ��������id
function tex_match.get_match_id_by_desk_no(desk_no)   
    local user_key = hall.desk.get_user(desk_no, 1) --�õ��û�����Ϣ��
     if (user_key == nil) then
        return -1
    end
    local user_game_data = deskmgr.getuserdata(userlist[user_key])
    if (user_game_data == nil) then
        return -1
    end
    return user_game_data.tex_match_id or -1
end

--��ȡ��������,��̭�ͱ����е��û�����
function tex_match.get_pre_match_win_lost_info(math_id)
    local match_group_item = tex_match.group_list[math_id]
    if (match_group_item == nil) then
        return -1, -1, -1
    end
    local win_num = 0
    local lose_num = 0
    local match_num = 0
    for k, v in pairs(match_group_item.user_list) do
        if (v.score >= tex_match.max_score) then
            win_num = win_num + 1
        elseif (v.score < tex_match.min_score) then
            lose_num = lose_num + 1
        else
            match_num = match_num + 1
        end
    end
    return win_num, lose_num, match_num
end

--����Ƿ������û���������ɣ����ڵȴ�״̬
function tex_match.is_all_game_over(match_id) 
    --����Ƿ��������Ӷ����������
    local is_all_game_over = 1
    local user_info = nil
    for k, v in pairs(tex_match.group_list[math_id].user_list) do
        user_info = usermgr.GetUserById(k) 
        if (user_info ~= nil and user_info.desk_no ~= nil and 
            user_info.site_no and gamepkg.getGameStart(user_info.desk, user_info.site) == 1) then
            is_all_game_over = 0
            break
        end
    end
    return is_all_game_over
end

--��ȡ��������
function tex_match.get_match_user_num(match_id)
    local match_group_item = tex_match.group_list[match_id];
    local user_num
    for k, v in pairs(match_group_item.user_list) do
        user_num = user_num + 1
    end
    return user_num
end

--��ȡ��������
function tex_match.get_score_rank(match_id)
    local match_group_item = tex_match.group_list[match_id];
    local match_user_list = {}
    for k, v in pairs(match_group_item.user_list) do
        table.insert(match_user_list, k)
    end
    --���շ���������������ͬ�İ��ձ���ʱ������
    table.sort(match_user_list, 
               function(a, b) 
                    if (match_group_item.user_list[a].score == match_group_item.user_list[b].score) then
                        return match_group_item.user_list[a].join_time > match_group_item.user_list[b].join_time
                    else
                        return match_group_item.user_list[a].score > match_group_item.user_list[b].score 
                    end
               end)
    return match_user_list
end

--������������
function tex_match.process_pre_match_over(match_id)
    --ȷ������
    local match_group_item = tex_match.group_list[math_id]
    local match_user_rank = tex_match.get_score_rank(match_id)
    -- todo match_user_list ǰn���˰佱,��ʾ���������֣��콱
    --ɾ����̭���ˣ������˽������
    for i = tex_match.pass_user_num + 1, #match_user_rank do
        tex_match.exit_match(match_user_rank[i])
    end    
end

--����һ���Ƿ����
function tex_match.is_final_match_round_over(desk_no, match_id)    
    local user_info = hall.desk.get_user(desk_no, 1) --�õ��û�����Ϣ��
    if (user_info == nil) then
        return -1
    end    
    if (tex_match.group_list[match_id].user_list[user_info.userId].round_num == tex_match.round_num) then
        return 1
    else
        return 0
    end    
end

--��ȡ������һ������
function tex_match.get_final_match_round_rank(desk_no, match_id)
    local user_info = nil
    local match_user_id_list = {}
    for i = 1, room.cfg.DeskSiteCount do
        user_info = hall.desk.get_user(desk_no, i)
        table.insert(match_user_id_list, user_info.userId)
    end
    table.sort(match_user_id_list, 
                function(a, b)
                    return tex_match.group_list[match_id].user_list[a].score > tex_match.group_list[match_id].user_list[b].score
                end)
    return match_user_id_list
end

--�������һ�ֱ�����ɺ�Ľ������
function tex_match.process_final_match_round_over(match_id)    
    --��̭�������
    local match_user_rank = tex_match.get_score_rank()
    local user_num = #match_user_rank
    --��̭һ������
    local match_group_item = tex_match.group_list[match_id]
    local pass_user_list = match_group_item.pass_user_list
    table.sort()
    --ѡ���ڶ����������������������ǰ�����
    local left_user_num = user_num / 2 - pass_user_list
    local is_find = 0
    for i = 1,  #match_user_rank do
        is_find = 0
        for j = 1,  #pass_user_list do
            if (pass_user_list[j] == match_user_rank[i]) then
                is_find = 1
                break
            end
        end
        if (is_find == 0) then
            left_user_num = left_user_num - 1
            table.insert(pass_user_list, match_user_rank[i])
            if (left_user_num == 0) then
                --һ����Ա�Ľ��������Ѿ�ȷ��
                break
             end
        end
    end
    --ɾ��û�н��������
    for i = 1,  #match_user_rank do
        is_find = 0
        for j = 1,  #pass_user_list do
            if (match_user_rank[j] == pass_user_list[i]) then
                is_find = 1
                break
            end    
        end
        if (is_find == 0) then
            tex_match.exit_match(match_user_rank[i])            
        end
    end    
end

--һ����Ϸ����
function tex_match.on_game_over(desk_no)    
    local match_id = tex_match.get_match_id_by_desk_no(desk_no)
    if (match_id == -1) then
        return
    end
    local match_group_item = tex_match.group_list[match_id]
    if (match_group_item.stage == 1) then  --��һ�ֽ���
        local win_num, lose_num, match_num = tex_match.get_pre_match_win_lost_info(match_id)
        --������������
        if (win_num + match_num >= tex_match.pass_user_num) then--���������������������������������
            if (match_group_item.pre_match_over == 0) then
                TraceError("����: �����������������ֽ����󽫵ȴ��������������ȷ����������")
            end
            match_group_item.pre_match_over = 1            
            --����Ԥ�����
            if (tex_match.is_all_game_over() == 1) then
                tex_match.process_pre_match_over(match_id)
                --������һ���׶α���
                match_group_item.stage = 2
            end 
        end
        if (match_group_item.pre_match_over == 0) then
           --todo ������λ
            TraceError("������λ")
            tex_match.start_match(match_id)
        end
    else
        --���һ���Ƿ��Ѿ����
        if (tex_match.is_final_match_round_over(desk_no, match_id) == 1) then
            --ȷ����������
            local round_user_rank = tex_match.get_final_match_round_rank(desk_no, match_id)
            if (tex_match.is_all_game_over(match_id) == 0) then                
                TraceError("һ���Ѿ��������ȴ������˱������,֪ͨ��һ��������Ϣ")
            else
                --���һ����
                if (tex_match.get_match_user_num() == room.cfg.DeskSiteCount) then 
                    TraceError("���һ�ַ���")
                    --�������˳���������
                    for k, v in pairs(match_group_item.user_list) do
                        tex_match.exit_match(k)
                    end
                    --һ����Ϸ�������û����±���
                    return
                else
                    --��һ������
                    table.insert(tex_match.group_list[match_id].pass_user_list, round_user_rank[1])
                    --����һ�ֽ��������
                    TraceError("һ���Ѿ�����,֪ͨ��һ��������Ϣ,�Ѿ���̭����Ϣ")
                    tex_match.process_final_match_round_over()                    
                end
            end
            --todo ������λ
            tex_match.start_match(match_id)
        end
        
    end
    
    --�����׶�
    --���3�����Ƿ���꣬�����ȷ����������̭����
    --�������ֱ�ӿ���
    --��̭�͵ڶ�����ҵȴ�
    --�����˴���һ�֣�ȷ����������������
end

--һ����Ϸ����
--����ֵ���Ƿ�������Ƿ���̭
function tex_match.on_user_game_over(user_info, gold, beishu)
    --��¼�û��μӵ��ǳ�����
    	--�������˳�����
	local send_out_result=function(user_info)
		 netlib.send(function(buf)	    
		    	 buf:writeString("TXBISAIOUT")
		    	 buf:writeByte(user_info.site)
		    	 buf:writeInt(user_info.userId)	
		    	 buf:writeString(user_info.face)
		    	 buf:writeString(user_info.nick)		    	 
			  end, user_info.ip, user_info.port)
	end
    local user_game_data = deskmgr.getuserdata(user_info)
    if (user_game_data.tex_match_id == nil) then
        TraceError("������Ϊ��û�б���id")
        return -1
    end
    local match_group_item = tex_match.group_list[user_game_data.tex_match_id]
    if (match_group_item.user_list[user_info.userId] == nil) then
        TraceError("�û�Ϊ��û���ڱ�����Ϣ��")
        return -1
    end
    local match_user_info = match_group_item.user_list[user_info.userId]
    --����Ƿ���Ԥ��
    if (match_group_item.stage == 1) then        
        --beishu=��������*���䱶��*�ӱ�����
        match_user_info.score = match_user_info.score - beishu / groupinfo.gamepeilv * tex_match.get_base_score(user_game_data.tex_match_id)
        --����Ƿ���̭��
        if (match_user_info.score < tex_match.min_score) then
            TraceError("����Ѿ�����̭")
            send_out_result(user_info);
        --����Ƿ����
        elseif (match_user_info.score >= tex_match.max_score) then
            --����Լ��ǲ������һ��������������            
            TraceError("��ϲ����Ѿ�����")
        end
    else
        match_user_info.round_num = match_user_info.round_num + 1        
    end
    return 1
    
    --
        --������������°������ӣ������Ⱦ�����ͬ����
    --��⵱ǰ�����Ƿ����
        --��ʼ����
    --�������Ƿ����
        
end

--�μӱ���
function tex_match.join_match(user_id)

	--���ͱ������
	local send_join_result=function(user_info,match_id,baoming_result,already_baoming)
		 netlib.send(function(buf)	    
		    	 buf:writeString("TXJBSJOIN")
		    	 buf:writeByte(baoming_result)
		    	 buf:writeInt(match_id)	
		    	 buf:writeInt(already_baoming)	
			  end, user_info.ip, user_info.port)
	end
	
	--���±�������������������ֲ������ˣ�
	local send_update_join_result=function(user_info,match_id,already_baoming)
		local match_user_list = tex_match.group_list[match_id].user_list
	 	for k, v in pairs(match_user_list) do
        	netlib.send(function(buf)	    
		    	 buf:writeString("TXJBSSETNUM")
		    	 buf:writeInt(match_id)	
		    	 buf:writeInt(already_baoming)	
			  end, v.ip, v.port)
        end
		 
	end

    local user_info = usermgr.GetUserById(user_id)
    local group_list = tex_match.group_list
    if (group_list[tex_match.index_match_id] == nil) then
        group_list[tex_match.index_match_id] = 
        {
            stage = 1,
            start_time = 0,
            user_list = {},  
            pass_user_list = {}, --�����û��б����ھ����׶�          
            join_num = 0,       --�μ���Ϸ������
            pre_match_over = 0, --�����г��������Ƿ�����
        }
    end
    local group_info = group_list[tex_match.index_match_id]
    local match_user_list = group_list[tex_match.index_match_id].user_list
    if (match_user_list[user_info.userId] ~= nil) then
        TraceError("�Ѿ���������")
        send_join_result(user_info,tex_match.index_match_id,0,group_info.join_num);
        return
    else
        match_user_list[user_info.userId]=
        {
            score = tex_match.init_score,
            rank = -1,
            round_num = 0,  --���˼���
            join_time = os.time(),
        }
        group_info.join_num = group_info.join_num + 1
        --��¼�û��μӵ��ǳ�����
        local user_game_data = deskmgr.getuserdata(user_info)
        user_game_data.tex_match_id = tex_match.index_match_id
        
        --֪ͨ�ͻ��˱����ɹ�
        send_join_result(user_info,tex_match.index_match_id,1,group_info.join_num);
        send_update_join_result(user_info,tex_match.index_match_id,group_info.join_num);
        --�����������Ƿ�ﵽ����������ﵽ������ͬʱ��ʼ����һ������
        if (group_info.join_num == tex_match.start_game_user) then
            tex_match.start_match(tex_match.index_match_id)  --��ʼһ������
            tex_match.index_match_id = tex_match.index_match_id + 1
            --����ٰ��1k�������������id������һ�Σ��Ƿ����ͬʱ�ٰ�1k������
            if (tex_match.index_match_id > 10000) then 
                tex_match.index_match_id = 1
            end
        end
    end
end

--�˳�����
function tex_match.exit_match(user_id)
    
    --����ȡ���������
	local send_exit_result=function(user_info,match_id,baoming_result,already_baoming)
		 netlib.send(function(buf)	    
		    	 buf:writeString("TXJBSCANCEL")
		    	 buf:writeByte(baoming_result)
		    	 buf:writeInt(match_id)	
		    	 buf:writeInt(already_baoming)	
			  end, user_info.ip, user_info.port)
	end
	
    local user_info = usermgr.GetUserById(user_id)
    if (user_info == nil) then
    	send_exit_result(user_info,tex_match.index_match_id,0,group_info.join_num);
        TraceError("�˳�����ʱ���û���ϢΪ��")
        return 
    end

	
    local user_game_data = deskmgr.getuserdata(user_info)
    if (user_game_data == nil) then
    	send_exit_result(user_info,tex_match.index_match_id,0,group_info.join_num);
        TraceError("�û�û�б���id")
        return 
    end
    local match_group_item = tex_match.group_list[user_game_data.tex_match_id]
    local match_user_list = match_group_item.user_list
    if (match_user_list[user_id] ~= nil) then
        match_user_list[user_id] = nil
        if (match_group_item.start_time == 0) then
            match_group_item.join_num = match_group_item.join_num - 1
            send_exit_result(user_info,tex_match.index_match_id,1,group_info.join_num);
        end
        --�������˳��˱��������¿�ʼһ������
        local has_user = 0
        for k1, v1 in pairs(match_user_list) do
            has_user = 1
            break
        end
        if (has_user == 0) then
            tex_match.group_list[user_game_data.tex_match_id] = nil
        end
    end
         
    local user_game_data = deskmgr.getuserdata(user_info)
    if (user_game_data ~= nil) then 
        user_game_data.tex_match_id = nil
    end
end

--��ʼһ����Ϸ����ʼ���û�����ͬ������
function tex_match.start_match(match_id)
	local send_start_match=function(user_info,match_id,baoming_result,already_baoming)
		 netlib.send(function(buf)	    
		    	 buf:writeString("TXJBSBEGIN")
		    	 buf:writeByte(baoming_result)
		    	 buf:writeInt(match_id)	
		    	 buf:writeInt(already_baoming)	
			  end, user_info.ip, user_info.port)
	end
	
    --���ñ�����ʼʱ��
    if (tex_match.group_list[match_id].start_time == 0) then
        tex_match.group_list[match_id].start_time = os.time()
    end
    local match_user_list = tex_match.group_list[match_id].user_list
    local start_desk_no = math.floor(match_id * (tex_match.start_game_user / 3)) + 1
    local end_desk_no = math.floor((match_id + 1) * (tex_match.start_game_user / 3)) + 1
    local site_no = 1    
    local user_info = nil
    for k, v in pairs(match_user_list) do
        --��ǰ�û��Ѿ�����λ���ˣ�������Ϸû�п�ʼ�������û�վ������Ȼ������һ�����ʵ�λ����
        user_info = usermgr.GetUserById(k)
        if (user_info.desk ~=nil or user_info.site ~= nil and 
            gamepkg.getGameStart(user_info.desk, user_info.site) == false) then
            --TraceError("standup:"..user_info.userId.." "..start_desk_no.." "..site_no)
            doUserStandup(user_info.key, true)
        end
    end
    
    local find_site = 0
    for k, v in pairs(match_user_list) do
        find_site = 0
        user_info = usermgr.GetUserById(k)
        if (user_info.desk == nil or user_info.site == nil) then
            for i = start_desk_no, end_desk_no do
                for j = 1, room.cfg.DeskSiteCount do
                    local site_user_info = deskmgr.getsiteuser(i, j)
                    if (site_user_info == nil) then
                        --TraceError("sitdown:"..user_info.userId.." "..i.." "..j)
                        doSitdown(user_info.key, user_info.ip, user_info.port, i, j)
                        find_site = 1
                        break
                    end
                end
                if (find_site == 1) then
                    break
                else
                    start_desk_no = start_desk_no + 1
                end
            end
        end
    end
end


function tex_match.on_recv_jbs_info(buf)
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
end

function tex_match.on_recv_jbs_baomin(buf)
	local user_info = userlist[getuserid(buf)];
	if(user_info == nil)then return end
	--��������
	tex_match.join_match(user_info.userId)
	
	 
end

function tex_match.on_recv_jbs_cancel(buf)
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	tex_match.exit_match(user_info.userId)
end

--��̨�� end

-----------------���ǻ����ķָ���--------------------------------------------
--�ֻ��,������ begin

function check_datetime()
	local statime = timelib.db_to_lua_time(tex_match.statime);
	local endtime = timelib.db_to_lua_time(tex_match.endtime);
--	local exttime = timelib.db_to_lua_time(tex_match.exttime);
	local sys_time = os.time();
	--�����콱��������Ϸʱ��
	if(sys_time >= statime and sys_time <= endtime) then
		    local tdate = os.date("*t", sys_time);		    
	        if (tdate.hour >= 20 and tdate.hour < 23)  then
	            return 2;
	        end	        
	end	
	--ֻ���콱
	if(sys_time > statime and sys_time <= endtime) then
        return 1;
	end
	
	
	--�ʱ���ȥ��
	return 0;
end

--�ж��ǲ�����Ч�ı���
function tex_match.can_join_invite_match(user_info,deskinfo,match_num)
	--TraceError("--�ж��ǲ�����Ч�ı���, userId:"..user_info.userId.." match_num:"..match_num)
	--�ж�ʱ��ĺϷ���,0���Ϸ���1ֻ�����콱��Ϣ��2�����콱��Ϣ�ͱ���
	if(deskinfo~=nil and deskinfo.smallbet~=tex_match.room_smallbet1 and deskinfo.smallbet~=tex_match.room_smallbet2 and deskinfo.smallbet~=tex_match.room_smallbet3)then
		--TraceError("--�ж��ǲ�����Ч�ı���->>>deskinfo,room_smallbet1,room_smallbet2")
		return false
	end
	
	--1.ʱ���жϣ�������û��ʼ������11��4-6��ÿ��20��:00׼ʱ�μӡ�����
	if(check_datetime()~=2)then
	    --msg = "�Բ��𣬱����ʱ�����ƣ����Ķ��˵����";
    	--OnSendServerMessage(userinfo, 1 , _U(msg));
    	--TraceError("--�ж��ǲ�����Ч�ı���->>>>check_datetime")
		return false
	end

	--2.VIP�жϣ�VIP3����
	--3.�����ж�(4�����ϲ���ɼ�������Ϊ��������ҲӦ�ÿ�����Ϸ���������ﲻ���ж���
    --[[
    local msg = "";
    local viplevel = 0
	if(viplib) then
	    viplevel = viplib.get_vip_level(user_info)
	end
    if(viplevel<3)then
    	--msg = "��Ǹ�����뷿����Ҫ���ٽ�VIP��ݣ����ֵ��ȡ��VIP���!";
    	--OnSendServerMessage(userinfo, 1 , _U(msg));
    	return false
    end
    --]]
    
    --�ж�3�����ϲ�����Ч��������¼����
    if(match_num<4)then
   		--TraceError("--�жϲ�����Ч�ı���-->>>match_num")
    	return false
    end
    
    return true
end


--���ɱ�������Ϣ(ÿ�Σ�ÿ����ҷ�����Ч����ʱ���ã�
function tex_match.update_invite_ph_list(user_info,match_gold)
	--TraceError("--���ɱ�������Ϣ(ÿ�Σ�ÿ����ҷ�����Ч����ʱ���ã�")
	if (user_info==nil) then return end
	
	if(user_info.sign_ruslt == "0")then return end

	local deskno=user_info.desk
	local deskinfo=desklist[deskno]
	local match_num = tex_match.get_invate_match_count(deskno)
	local match_type=1
	
	--TraceError("���ɱ�������Ϣ,match_num:"..match_num)
	if(tex_match.can_join_invite_match(user_info,deskinfo,match_num))then
	
		if(deskinfo.smallbet==tex_match.room_smallbet1)then
			match_type=1;
		elseif(deskinfo.smallbet==tex_match.room_smallbet2)then
			match_type=2;
			
			--�ж��û���ְҵ������ר�ҳ�����
			if(user_info.sign_ruslt == "2")then
				----TraceError("match_type=2,useid:%d, sign:%s"..user_info.userId..user_info.sign_ruslt)
				return
			end
			
		elseif(deskinfo.smallbet==tex_match.room_smallbet3)then
			match_type=3;
			
			--�ж��û���ְҵ������ר�ҳ�����
			if(user_info.sign_ruslt == "1")then
				--TraceError("match_type=3,useid:%d,sign:%s"..user_info.userId..user_info.sign_ruslt)
				return
			end
			
		end
		--TraceError("match_type "..match_type.."deskinfo.smallbet "..deskinfo.smallbet)
		tex_match.update_invite_db(user_info,match_gold,match_type, 0)
	end	
end

--���±�����Ϣ 
function tex_match.update_invite_db(user_info,match_gold,match_type, sign)
	--TraceError("���±�����Ϣ  sign->"..sign)
	if(sign == 0)then
		local sql="insert into t_invite_pm(user_id,nick_name,win_gold,play_count,match_type,sys_time) value(%d,'%s',%d,1,%d,now()) on duplicate key update win_gold=win_gold+%d,play_count=play_count+1,sys_time=now();commit;";
		sql=string.format(sql,user_info.userId,user_info.nick,match_gold,match_type,match_gold);
		dblib.execute(sql)
		tex_match.update_play_count(user_info,match_type)
	else
		local sql="insert into t_invite_pm(user_id,nick_name,win_gold,match_type,sys_time,sign) value(%d,'%s',%d,%d,now(),%d) ON DUPLICATE KEY UPDATE sys_time=NOW()";
		sql=string.format(sql,user_info.userId,user_info.nick,match_gold,match_type,sign);
		dblib.execute(sql)
		tex_match.update_play_count(user_info,match_type)
	end
end	


	--�����������
tex_match.update_play_count=function(user_info,match_type)
 
	--TraceError("����������� userID->"..user_info.userId.."match_type->"..match_type)
 
	if(match_type==1)then
	
		if(user_info.yy_play_count==nil)then
			user_info.yy_play_count=1
			return
		end
		
		user_info.yy_play_count=user_info.yy_play_count+1 or 1
		
	elseif(match_type==2)then
	
		if(user_info.zy_play_count==nil)then
			user_info.zy_play_count=1
			--TraceError("����������� user_info.zy_play_count->"..user_info.zy_play_count)
			return
		end
		
		user_info.zy_play_count=user_info.zy_play_count+1 or 1
		--TraceError("����������� user_info.zy_play_count->"..user_info.zy_play_count)
		
	elseif(match_type==3)then
		if(user_info.zj_play_count==nil)then
			user_info.zj_play_count=1
			--TraceError("����������� user_info.zj_play_count->"..user_info.zj_play_count)
			return
		end
		user_info.zj_play_count=user_info.zj_play_count+1 or 1
		--TraceError("����������� user_info.zj_play_count->"..user_info.zj_play_count)
	end
end


function tex_match.can_sit_invite_desk(user_info,desk_info)
	----TraceError("--�������ǲ�������Ҫ��ķ���")
	if (user_info==nil) then return false end
	if (desk_info==nil) then return false end
	----TraceError("can_sit_invite_desk 01")
	--�������ǲ�������Ҫ��ķ���
	if(desk_info~=nil and desk_info.smallbet==tex_match.room_smallbet and desk_info.at_least_gold==tex_match.room_at_least_gold)then
		local msg = "";
	    local viplevel = 0
		if(viplib) then
		    viplevel = viplib.get_vip_level(user_info)
		end
	    if(viplevel<3)then
	    	--msg = "��Ǹ���μ���������Ҫ���ٽ�VIP��ݣ����ֵ��ȡ��VIP���!";
	    	msg = tex_lan.get_msg(userinfo, "match_msg");
	    	OnSendServerMessage(user_info, 1 , _U(msg));
	    	return false
	    end
	end
	return true

end


tex_match.ontimecheck = function(e)
  	--10����Ҫˢһ��
  	----TraceError("tex_match.ontimecheck");
  	local userinfo = e.data.userinfo
  	if(userinfo==nil)then
  		--TraceError("tex_match.ontimecheck userinfo is nil")
  	end
  	
  	if(check_datetime() == 0)then	--�жϻʱ�����
  		return
  	end
  	
	if(tex_match.refresh_invate_time==-1 or os.time()>tex_match.refresh_invate_time+60*10)then
		----TraceError("tex_match.ontimecheck");
    	tex_match.refresh_invate_time=os.time();
    	tex_match.init_invite_ph();
    end
    
    --20:00,20:20,20:40,21:00,21:20,21:40,22:00 ����ȫ��7�ι㲥
    
    local tableTime = os.date("*t",os.time());
    local nowYear = tonumber(tableTime.year);
    local nowMonth = tonumber(tableTime.month);
    local nowDay = tonumber(tableTime.day);
    
    local nowHour  = tonumber(tableTime.hour);
    local nowMin   = tonumber(tableTime.min);
    local nowSec      = tonumber(tableTime.sec);
    
    local tmp_time="'"..nowYear.."-"..nowMonth.."-"..nowDay.." "..nowHour..":"..nowMin..":00"
    if ((nowHour==20 and nowMin==0)
    	or (nowHour==20 and nowMin==20)
    	or (nowHour==20 and nowMin==40)
    	or (nowHour==21 and nowMin==0)
    	or (nowHour==21 and nowMin==20)
    	or (nowHour==21 and nowMin==40)
    	or (nowHour==22 and nowMin==0)) 	then
		
		-- --TraceError(tmp_time)
		-- --TraceError(tex_match.last_msg_time)
   	-- --TraceError(timelib.db_to_lua_time(tmp_time))
   
		if(tex_match.last_msg_time<timelib.db_to_lua_time(tmp_time))then
		----TraceError("2012���᷽�۴������ȿ���")
		   	--BroadcastMsg(_U("2012���᷽�۴������ȿ������Ͽ���룬Ӯȡÿ�����1800W�������¶����շ��۴󽱣�"),0)
	    	local msg=""
	    	msg=tex_lan.get_msg(userinfo, "match_msg_noti");
	   -- --TraceError(msg)
	    	BroadcastMsg(_U(msg),0)
	    	tex_match.last_msg_time=os.time();
		end
	end
    
end

--��ʼ�����а�
function tex_match.init_invite_ph()
	--TraceError("-->>>>��ʼ�����а�")
	tex_match.invite_ph_list_zj={}; --ר�ҳ�����
	tex_match.invite_ph_list_yy={};	--ҵ�ೡ����
	tex_match.invite_ph_list_zy={};	--ְҵ������
	
	--��ʼ������
	local init_match_ph=function(ph_list,match_type)
		local sql="select user_id,nick_name,win_gold,match_king_count,play_count,sign from t_invite_pm where match_type=%d and play_count>=1 order by win_gold desc"
		sql=string.format(sql,match_type)
		----TraceError(sql)
		dblib.execute(sql,function(dt)	
				if(dt~=nil and  #dt>0)then
					for i=1,#dt do
						local bufftable ={
						  	    mingci = i, 
			                    user_id = dt[i].user_id,
			                    nick_name=dt[i].nick_name,
			                    win_gold=dt[i].win_gold,
			                    match_king_count=dt[i].match_king_count,
			                    play_count=dt[i].play_count,
			                    sign = dt[i].sign,
		                }
		                
						table.insert(ph_list,bufftable)
					end
				end
	    end)
    end
    --��ʼ��ҵ�ೡ����
    init_match_ph(tex_match.invite_ph_list_yy,1)
    --��ʼ��ְҵ������
    init_match_ph(tex_match.invite_ph_list_zy,2)
    --��ʼ��ר�ҳ�����
    init_match_ph(tex_match.invite_ph_list_zj,3)
	
end

--���������������а�
function tex_match.on_recv_invite_ph_list(buf)
	--TraceError("--���������������а�")
	local user_info = userlist[getuserid(buf)]; 
	local mc = -1; --���ڼ����Լ�������
	local win_gold = 0; --���ڼ����Լ��ĳɼ�
	local match_king_count = 0; --���ڼ����Լ������ߴ���
	local play_count = 0; --���ڼ����Լ�����Ĵ���
	
	local invite_paimin_list={};
	local send_len=5;--Ĭ�Ϸ�5����Ϣ
	if(user_info == nil)then return end
	
	--��ѯ�Լ������Σ����û�����ξͷ���-1
	--�������Σ��ɼ�����Ϊ���ߵĴ�������Ĵ���
	local my_mc=-1;
	local my_win_gold=0;
	local my_king_count=0;
	local my_play_count=0;
	
	local get_my_pm = function(ph_list,user_info)
		local mc=-1
		if (ph_list==nil) then return -1,0,0,0 end
		
		for i=1,#ph_list do
			if(ph_list[i].user_id==user_info.userId)then
				return i,ph_list[i].win_gold,ph_list[i].match_king_count,ph_list[i].play_count
			end
		end

		return -1,0,0,0;--û���ҵ���Ӧ��ҵļ�¼����Ϊ��û�гɼ�
	end
	
	--�õ��Լ����˶�����
	local get_my_real_play_count=function(user_info,match_type)
	
		if(match_type==3)then
			return user_info.zj_play_count or 0
		end
		
		if(match_type==2)then
			return user_info.zy_play_count or 0
		end

		if(match_type==1)then
			return user_info.yy_play_count or 0						
		end	
	end
	
	--1��ҵ�ೡ��2��ְҵ����3��ר�ҳ�
	local query_match_type = buf:readByte(); 
	local my_real_play_count=get_my_real_play_count(user_info,query_match_type) or 0
	
	if(query_match_type==1)then
		invite_paimin_list=tex_match.invite_ph_list_yy
	elseif(	query_match_type==2) then
		invite_paimin_list=tex_match.invite_ph_list_zy
	elseif(	query_match_type==3) then
		invite_paimin_list=tex_match.invite_ph_list_zj
	end
	
	----TraceError("query_match_type="..query_match_type)
	
	--TraceError(invite_paimin_list)
	--�жϱ���    0��δ����    1��ְҵ��      2��ר�ҳ�       3��ְҵ����ר�ҳ�
	local baoming_sign = user_info.sign_ruslt	--���Ϳͻ��ˣ�ֻ��0��δ������1���ѱ���
	--TraceError("query_match_type:"..query_match_type)
	if(query_match_type==2)then
		--TraceError("111111111->>>"..baoming_sign)
		if(baoming_sign=="0")then
		--	TraceError("22222222222")
			baoming_sign = "0"
		elseif(baoming_sign=="1")then
			--TraceError("3333333333")
			baoming_sign = "1"
		elseif(baoming_sign=="2")then
			--TraceError("4444444444")
			baoming_sign = "0"
		elseif(baoming_sign=="3")then
			--TraceError("5555555")
			baoming_sign = "1"
		end
	
	elseif(	query_match_type==3) then
		--TraceError("6666666:"..baoming_sign)
		
		if(baoming_sign == "0")then
			--TraceError("777777777")
			baoming_sign = "0"
		elseif(baoming_sign == "1")then
			--TraceError("88888888888")
			baoming_sign = "0"
		elseif(baoming_sign == "2")then
			--TraceError("99999999999")
			baoming_sign = "1"
		elseif(baoming_sign == "3")then
			--TraceError("++++++++++")
			baoming_sign = "1"
		end
		
	end
	
	--����my_play_count����ʹ�ã���Ҫ����������ȥ����
	my_mc,my_win_gold,my_king_count,my_play_count=get_my_pm(invite_paimin_list,user_info)

    	netlib.send(function(buf)
	    	buf:writeString("INVITEPHLIST")
			--TraceError("my_win_gold:"..my_win_gold)
			if(baoming_sign=="1")then
	    		buf:writeByte(1)	--�Ƿ��ѱ�����0��δ������1���ѱ���
	    	else
	    		buf:writeByte(0)	--�Ƿ��ѱ�����0��δ������1���ѱ���

	    	end
	    	
		    --�Ƿ���ʾ�콱��ť
		    buf:writeByte(0) --Ŀǰû���콱���ܣ����õ����Ĵ����ˡ��Ժ����ټ���
		    buf:writeInt(my_win_gold or 0)
		    buf:writeInt(my_mc or 0)
		    buf:writeInt(my_king_count or 0)

		    buf:writeInt(60-my_real_play_count)--��60�ֻ�����پ�
		    buf:writeString(tostring(my_real_play_count))--��Ҫ������ô�Ż�����ľ��� e.g. 10|20|32
			if send_len>#invite_paimin_list then send_len=#invite_paimin_list end --��෢5����Ϣ
			--TraceError("send_len:"..send_len)
			
			 buf:writeInt(send_len)
				--�ٷ������˵�
		        for i=1,send_len do
			        buf:writeInt(invite_paimin_list[i].mingci)	--����
			        buf:writeInt(invite_paimin_list[i].user_id) --���ID
			        buf:writeString(invite_paimin_list[i].nick_name) --�ǳ�
			        buf:writeInt(invite_paimin_list[i].win_gold) --��ҳɼ�
			        
		
		        end
	        end,user_info.ip,user_info.port)   
end

--��д���������콱������°汾�в���ʹ���ˣ��ȱ�������ֹ�Ժ�Ҫ��ʵ�ｱ
function tex_match.on_recv_invite_dj(buf)
	--TraceError("--��д���������콱������°汾�в���ʹ���ˣ��ȱ�������ֹ�Ժ�Ҫ��ʵ�ｱ")
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	local real_name=buf:readString();
	local tel=buf:readString();
	local yy_num=buf:readInt();
	local address=buf:readString();
	local sql="update t_invite_pm set real_name='%s',tel='%s',yy_num=%d,address='%s' where user_id=%d;commit;"
	sql=string.format(sql,real_name,tel,yy_num,address,user_info.userId)
	
	dblib.execute(sql)
	netlib.send(function(buf)
		    buf:writeString("INVITEDJ")
		    buf:writeByte(1)		    
	        end,user_info.ip,user_info.port)   
end

--���ɱ���ID������¼��α�����������ÿ��������ͬһʱ�̣�ֻ����һ������������ֱ�������Ӻ�+ʱ�����Ψһ��
function tex_match.init_invate_match(deskno)
	--TraceError("--���ɱ���ID������¼��α�����������ÿ��������ͬһʱ�̣�ֻ����һ������������ֱ�������Ӻ�+ʱ�����Ψһ��")
	local deskinfo = desklist[deskno];
	if deskinfo==nil then return -1 end;
	if(deskinfo.smallbet~=tex_match.room_smallbet1 and deskinfo.smallbet~=tex_match.room_smallbet2 and deskinfo.smallbet~=tex_match.room_smallbet3)then
		return -1
	end
	local playinglist=deskmgr.getplayers(deskno)
	
	deskinfo.invate_match_id = deskno..os.time();
	deskinfo.invate_match_count=#playinglist;
	
	local flag=0;--0��Ч��1��Ч
	local match_time_status=check_datetime();
	if(match_time_status ==2)then
	--TraceError("--���ɱ���ID������¼��α�����������ÿ��������ͬһʱ�̣�ֻ����һ������������ֱ�������Ӻ�+ʱ�����Ψһ��")
		if(deskinfo.invate_match_count~=nil and deskinfo.invate_match_count>3)then
			flag=1;
		end
		for _, player in pairs(playinglist) do
		local user_info = player.userinfo
			if(#playinglist>1)then
			
				--���߿ͻ�����γɼ�����Ч������Ч��
				netlib.send(function(buf)
				    buf:writeString("INVITEREC")
				    buf:writeByte(flag)		    
			        end,user_info.ip,user_info.port)   
			end
		end
	end
	
	return deskinfo.invate_match_id;
end

--�õ���������ID
function tex_match.get_invate_match_id(deskno)
	--TraceError("--�õ���������ID")
	local deskinfo = desklist[deskno];
	if deskinfo==nil then return -1 end;
	return deskinfo.invate_match_id or -1;
end

--�õ�������������������õ�������Ὣ������0����Ϊ������ֻ�н���ʱ�ſ�����һ�α�����
function tex_match.get_invate_match_count(deskno)
	--TraceError("--�õ�������������������õ�������Ὣ������0����Ϊ������ֻ�н���ʱ�ſ�����һ�α�����  deskno:"..deskno)
	local deskinfo = desklist[deskno];
	if deskinfo==nil then return -1 end;
	--TraceError("--111111111111111111 invate_match_count:"..deskinfo.invate_match_count)
	return deskinfo.invate_match_count or 0;
end

--��������ֺͽ������������
function tex_match.on_recv_refresh_timeinfo(buf)
	--TraceError("--��������ֺͽ������������")
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	local match_time_status=check_datetime();--��Ч��1 ��Ч��0
	--��Ч���������ʱ��1�����뿪��ʱ��0
	--��Ч���������ʱ��0�����뿪��ʱ��1
	local flag1=0;
	local flag2=0;
	if(match_time_status == 0 or match_time_status == 1)then
		flag1=0
		flag2=1
	else
		flag1=1
		flag2=0
	end
	netlib.send(function(buf)
	    buf:writeString("INVITEBTN")
	    buf:writeInt(flag1)  --�����������ʱ��		
	    buf:writeInt(flag2)  --�����������ʱ��
	    buf:writeInt(-1)  --�������˶�����		    
	end,user_info.ip,user_info.port)   
end

--�ͻ���֪ͨ�Ѿ�����콱��ť��(��������ʱ��ʹ�ã���ֹ�߼����ֻ��ң�
function tex_match.on_recv_already_know_reward(buf)
	--TraceError("--�ͻ���֪ͨ�Ѿ�����콱��ť��")
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	local match_type=buf:readByte()
	local sql="update t_invite_pm set get_reward_time=now() where user_id=%d and match_type=%d;commit;"
	sql=string.format(sql,user_info.userId,match_type);
	dblib.execute(sql)
end

--�û���¼���¼�
tex_match.on_after_user_login = function(e)
	--TraceError("--�û���¼���¼�")
	local userinfo = e.data.userinfo
	if(userinfo == nil)then 
		--TraceError("����  �����û���½���ʼ������,if(user_info == nil)then")
	 	return
	end
	--���ǲ���Ҫ�����������ǵĻ��ͷ���Ϣ
	local match_time_status=check_datetime();--��Ч��1 ��Ч��0
	--������ڲ��Ǳ���ʱ�䣬�ͷ���������ģ��Ҳ�����û�ý����˵ı����ɼ���
	--TraceError("--�û���¼���¼�match_time_status->"..match_time_status)

	if(match_time_status==1)then
		tex_match.invite_match_fajiang(userinfo)
	end
	
	tex_match.invite_update_user_play_count(userinfo)
	
end


function tex_match.invite_update_user_play_count(user_info)

		if(user_info.sign_ruslt == nil)then
			user_info.sign_ruslt = "0"
		end
		
		local sql="SELECT play_count,match_type FROM t_invite_pm where user_id=%d order by match_type"
		sql=string.format(sql,user_info.userId)
		dblib.execute(sql,function(dt)
			if(dt~=nil and #dt>0)then			
				for i=1,#dt do
 
					if(dt[i].match_type==1)then
						user_info.yy_play_count=dt[i].play_count or 0
	
					elseif(dt[i].match_type==2)then
						user_info.zy_play_count=dt[i].play_count or 0
			
					elseif(dt[i].match_type==3)then
						user_info.zj_play_count=dt[i].play_count or 0
	
					end
				
				end
			end
		end)
		
		--TraceError("user_info.userId->"..user_info.userId)
		--sql="SELECT SUM(sign) AS sign FROM t_invite_pm where user_id=%d AND DATE(baoming_time) = DATE(NOW()) and hour(baoming_time)<23 "
		--sql="SELECT SUM(sign) AS sign FROM t_invite_pm WHERE user_id=%d AND !(DATE(baoming_time) != DATE(NOW()) OR  ((HOUR(NOW())<23 AND baoming_time='1900-01-01 00:00:00') OR ( HOUR(NOW())>=23 AND HOUR(baoming_time)<23)));"
		--���ӵ�SQL,��1���жϵ����ڱ��������2���жϵ���23��00������23��00���������3���ж�31����1�������4���ж��ޱ��������
		sql ="SELECT SUM(sign) AS sign FROM t_invite_pm WHERE user_id=%d AND (!(DATE(baoming_time) != DATE(NOW()) OR  ((HOUR(NOW())<23 AND baoming_time='1900-01-01 00:00:00') OR ( HOUR(NOW())>=23 AND HOUR(baoming_time)<23))) OR (DATE(baoming_time)=DATE_SUB(DATE(NOW()), INTERVAL 1 DAY) AND HOUR(baoming_time)>=23))"
		
		sql=string.format(sql,user_info.userId)
		--TraceError("sql="..sql)
		dblib.execute(sql,function(dt)
			if(dt~=nil and #dt>0)then	
				
				--local temp1 = 0
				--temp1 = dt[1].sign or 0
				--TraceError("temp1->"..temp1)
						
				--user_info.sign_ruslt = temp1
				user_info.sign_ruslt = dt[1].sign or "0"  --ȡ��ֵ��0��δ���� 1��ְҵ��  2��ר�ҳ�  3��ְҵ����ר�ҳ�
				
				--TraceError("user_info.sign_ruslt->"..user_info.sign_ruslt)
				
				if(user_info.sign_ruslt == "" )then
					user_info.sign_ruslt = "0"
				end
			end
		end)
end

--����ڼ���
function tex_match.consider_screen()
	local screen = 0

	local statime_1 = timelib.db_to_lua_time("2012-01-17 00:00:00")  --�ʱ��
    local statime_2 = timelib.db_to_lua_time("2012-01-18 00:00:00")  --�ʱ��
    local statime_3 = timelib.db_to_lua_time("2012-01-19 00:00:00")  --�ʱ��
    local statime_4 = timelib.db_to_lua_time("2012-01-20 00:00:00")  --�ʱ��
    local statime_5 = timelib.db_to_lua_time("2012-01-21 00:00:00")  --�ʱ��
    
    local statime_6 = timelib.db_to_lua_time("2012-01-22 00:00:00")  --�ʱ��
    local statime_7 = timelib.db_to_lua_time("2012-01-23 00:00:00")  --�ʱ��
    local statime_8 = timelib.db_to_lua_time("2012-01-24 00:00:00")  --�ʱ��
    local statime_9 = timelib.db_to_lua_time("2012-01-25 00:00:00")  --�ʱ��
    local statime_10 = timelib.db_to_lua_time("2012-01-26 00:00:00")  --�ʱ��
    
    local statime_11 = timelib.db_to_lua_time("2012-01-27 00:00:00")  --�ʱ��
    local statime_12 = timelib.db_to_lua_time("2012-01-28 00:00:00")  --�ʱ��
    local statime_13 = timelib.db_to_lua_time("2012-01-29 00:00:00")  --�ʱ��
    local statime_14 = timelib.db_to_lua_time("2012-01-30 00:00:00")  --�ʱ��
    local statime_15 = timelib.db_to_lua_time("2012-01-31 00:00:00")  --�ʱ��
    
    local statime_16 = timelib.db_to_lua_time("2012-02-01 00:00:00")  --�ʱ��
    local statime_17 = timelib.db_to_lua_time("2012-02-02 00:00:00")  --�ʱ��
    local statime_18 = timelib.db_to_lua_time("2012-02-03 00:00:00")  --�ʱ��
    local statime_19 = timelib.db_to_lua_time("2012-02-04 00:00:00")  --�ʱ��
    local statime_20 = timelib.db_to_lua_time("2012-02-05 00:00:00")  --�ʱ��
    
    local statime_21 = timelib.db_to_lua_time("2012-02-06 00:00:00")  --�ʱ��
    local statime_22 = timelib.db_to_lua_time("2012-02-07 00:00:00")  --�ʱ��
    
  
	local sys_time = os.time()
    if(sys_time > statime_1 and sys_time < statime_2) then
        screen = 1
    elseif(sys_time > statime_2 and sys_time < statime_3) then
    	screen = 2
    elseif(sys_time > statime_3 and sys_time < statime_4) then
    	screen = 3
    elseif(sys_time > statime_4 and sys_time < statime_5) then
    	screen = 4
    elseif(sys_time > statime_5 and sys_time < statime_6) then
    	screen = 5
    	
   elseif(sys_time > statime_6 and sys_time < statime_7) then
    	screen = 6
    elseif(sys_time > statime_7 and sys_time < statime_8) then
    	screen = 7
    elseif(sys_time > statime_8 and sys_time < statime_9) then
    	screen = 8
    elseif(sys_time > statime_9 and sys_time < statime_10) then
    	screen = 9
    	
    elseif(sys_time > statime_10 and sys_time < statime_11) then
    	screen = 10
    elseif(sys_time > statime_11 and sys_time < statime_12) then
    	screen = 11
    elseif(sys_time > statime_12 and sys_time < statime_13) then
    	screen = 12
    elseif(sys_time > statime_13 and sys_time < statime_14) then
    	screen = 13
    	
    elseif(sys_time > statime_14 and sys_time < statime_15) then
    	screen = 14
    elseif(sys_time > statime_15 and sys_time < statime_16) then
    	screen = 15
    elseif(sys_time > statime_16 and sys_time < statime_17) then
    	screen = 16
    elseif(sys_time > statime_17 and sys_time < statime_18) then
    	screen = 17
    elseif(sys_time > statime_18 and sys_time < statime_19) then
    	screen = 18
    elseif(sys_time > statime_19 and sys_time < statime_20) then
    	screen = 19
    elseif(sys_time > statime_20 and sys_time < statime_21) then
    	screen = 20
    elseif(sys_time > statime_21 and sys_time < statime_22) then
    	screen = 21
    elseif(sys_time > statime_22) then
    	screen = 22
	end
	
	return screen;
end

--����ҷ���
--����������ٴ�һ�̾ͷ��������ص�½ʱ�ŷ���
function tex_match.invite_match_fajiang(userinfo)
	--TraceError("--����ҷ���")
	local _tosqlstr = function(s) 
		s = string.gsub(s, "\\", " ") 
		s = string.gsub(s, "\"", " ") 
		s = string.gsub(s, "\'", " ") 
		s = string.gsub(s, "%)", " ") 
		s = string.gsub(s, "%(", " ") 
		s = string.gsub(s, "%%", " ") 
		s = string.gsub(s, "%?", " ") 
		s = string.gsub(s, "%*", " ") 
		s = string.gsub(s, "%[", " ") 
		s = string.gsub(s, "%]", " ") 
		s = string.gsub(s, "%+", " ") 
		s = string.gsub(s, "%^", " ") 
		s = string.gsub(s, "%$", " ") 
		s = string.gsub(s, ";", " ") 
		s = string.gsub(s, ",", " ") 
		s = string.gsub(s, "%-", " ") 
		s = string.gsub(s, "%.", " ") 
		return s 
	end
	
	local mc=-1;
	
	local screen_n = tex_match.consider_screen()
	
	local send_result=function(userinfo,mc,match_type)
		--TraceError("mc:"..mc.."  userid"..userinfo.userId.."  match_type"..match_type)
		netlib.send(function(buf)
		    buf:writeString("INVITEGIF")
		    buf:writeInt(mc)  --����	
		    buf:writeByte(match_type)
		    buf:writeInt(screen_n)  --�ڼ���	    
		end,userinfo.ip,userinfo.port)  
	end
	
	--���巢��
	local jutifajiang = function(i,userinfo,reward)
		--������
		usermgr.addgold(userinfo.userId, reward, 0, g_GoldType.invite_match_gold, -1, 1);
					  				
		local user_nick = userinfo.nick
		user_nick=_tosqlstr(user_nick).."   "
							
		--��ȫ���㲥
		local msg=""
		if(match_type==1)then
			--msg=string.format(msg,"ҵ��","1W");
			msg=tex_lan.get_msg(userinfo, "match_msg_awards_1")..user_nick..tex_lan.get_msg(userinfo, "match_msg_awards_type_1");
			reward = reward/10000
			msg = string.format(msg,i,reward);
 	
		elseif(match_type==2)then
			--msg=string.format(msg,"ְҵ","8W");
			msg=tex_lan.get_msg(userinfo, "match_msg_awards_1")..user_nick..tex_lan.get_msg(userinfo, "match_msg_awards_type_2");
			reward = reward/10000
			msg = string.format(msg,i,reward);
			
		elseif(match_type==3)then
			--msg=string.format(msg,"ר��","188W");
			msg=tex_lan.get_msg(userinfo, "match_msg_awards_1")..user_nick..tex_lan.get_msg(userinfo, "match_msg_awards_type_3");
			reward = reward/10000
			msg = string.format(msg,i,reward);
			
		end
		
		BroadcastMsg(_U(msg),0)
	
	end
	
	--����
	local fajiang=function(userinfo,match_type,reward1,reward2,reward3,reward4,reward5)
		--get_reward_timeÿ���üƻ�������'2000-10-10'��
		local sql="select user_id,get_reward_time from t_invite_pm where match_type=%d and play_count>=1  order by win_gold desc limit 5";
		sql=string.format(sql,match_type)
		--�������ߣ����ڲ����ˣ���ʱ���ε�
		--local xz=0;
		--if(match_type==1)then
		--	xz=9009;
		--elseif(match_type==2)then
		--	xz=9010;
		--elseif(match_type==3)then
		--	xz=9011;
		--end

		dblib.execute(sql,function(dt)	
				if(dt~=nil and  #dt>0)then
					--local fajiang_flag=0;
					local len=5
					if(#dt<5)then
						len=#dt
					end
					
					for i=1,len do
						local get_reward_time=0;
						if(dt[i].get_reward_time~=nil)then
							get_reward_time=timelib.db_to_lua_time(dt[i].get_reward_time) or 0
						end
					  	if(dt[i].user_id==userinfo.userId and get_reward_time<timelib.db_to_lua_time('2010-11-11'))then
	     			  			if(i==1)then
					  				jutifajiang(i,userinfo,reward1)
					  			elseif(i==2)then
					  				jutifajiang(i,userinfo,reward2)
					  				--usermgr.addgold(userinfo.userId, reward2, 0, g_GoldType.invite_match_gold, -1, 1);
					  			elseif(i==3)then
					  				jutifajiang(i,userinfo,reward3)
					  				--usermgr.addgold(userinfo.userId, reward3, 0, g_GoldType.invite_match_gold, -1, 1);
					  			elseif(i==4)then
					  				jutifajiang(i,userinfo,reward4)
					  				--usermgr.addgold(userinfo.userId, reward4, 0, g_GoldType.invite_match_gold, -1, 1);
					  			elseif(i==5)then
					  				jutifajiang(i,userinfo,reward5)
					  				--usermgr.addgold(userinfo.userId, reward5, 0, g_GoldType.invite_match_gold, -1, 1);
					  			end
					  			--fajiang_flag=1;
					      		send_result(userinfo,i,match_type)
					    end
					end
					
					--�����콱��Ϣ,����������εģ��͸��������콱ʱ�䣬�����û���εģ���ֱ����0
					sql="update t_invite_pm set get_reward_time=now() where user_id=%d and match_type=%d;commit;";
					sql=string.format(sql,userinfo.userId,match_type)
					dblib.execute(sql)
				end
		end)  
	end
 
	--��ҵ�ೡ�Ľ� 
	--fajiang(userinfo,1,10000,2000,1000,500,500);
	
	--��ְҵ���Ľ�
	--fajiang(userinfo,2,80000,20000,10000,2000,2000);
	fajiang(userinfo,2,200000,100000,50000,10000,10000);
	
	--��ר�ҳ��Ľ�
	--fajiang(userinfo,3,1880000,100000,50000,20000,20000);
	fajiang(userinfo,3,1000000,200000,100000,50000,50000);
	
end

--����ʱ��״̬
function tex_match.on_recv_activity_stat(buf)
	
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	
	--0�����Ч������ʾ���UI��2�����Ч�������׶�
	local check_stat = check_datetime()
	
	
	local endtime = timelib.db_to_lua_time(tex_match.endtime);
	local ranktime =  timelib.db_to_lua_time(tex_match.rank_endtime);
	local sys_time = os.time();
	if(sys_time > endtime) then
		check_stat = 5 --��������������а�ͼ�걣��1�����ʧ��
	end
	
	if(sys_time > ranktime) then
		check_stat = 0 --���������
	end
	--TraceError("--����ʱ��״̬-->>"..check_stat)
	
	netlib.send(function(buf)
		    buf:writeString("INVITEPHDATE")
		    buf:writeByte(check_stat)		    
	        end,user_info.ip,user_info.port)   
end

--����������
function tex_match.on_recv_sign(buf)
	--TraceError("--����������")
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	
	--������һ������ 2��ְҵ����3��ר�ҳ�	
	local sign = buf:readByte()
	
	--1�������ɹ���2������ʧ�ܣ������ʸ�֤��3������ڣ�4�������쳣���
	local sign_ruslt = 0
	
	--��ѯ�ʸ�֤����
	local shiptickets_count = user_info.propslist[7]
    
	if(sign == 2)then	--2��ְҵ��
		if(check_datetime() == 0)then	--�жϻ��Ч��
			sign_ruslt = 3
			--TraceError("--ְҵ�� ��������    3")
		elseif(shiptickets_count < 2)then	--�жϱ����ʸ�
			sign_ruslt = 2
	 		--TraceError("-- ְҵ�� ��������   2")
		
		else--�����ɹ�����۳��ʸ�֤����
			sign_ruslt = 1
			tex_match.sign_succes(user_info, 2, sign)
		end
		
	elseif(sign == 3)then	--3��ר�ҳ�
		if(check_datetime() == 0)then	--�жϻ��Ч��
			sign_ruslt = 3
			--TraceError("--ר�ҳ� ��������    3")
		elseif(shiptickets_count < 5)then	--�жϱ����ʸ�
			sign_ruslt = 2
			--TraceError("--ר�ҳ� ��������    2")
		
		else--�����ɹ�����۳��ʸ�֤����
			sign_ruslt = 1
			tex_match.sign_succes(user_info, 5, sign)
		end
		
	else
		--TraceError("��������,����sign->"..sign)
		return;
	end
		 
	netlib.send(function(buf)
		    buf:writeString("INVITESIGNUP")
		    buf:writeByte(sign_ruslt)		    
	        end,user_info.ip,user_info.port) 
end

--�����ɹ�
function  tex_match.sign_succes(user_info, k_count, match_type)
	--TraceError("�����ɹ�->>match_type:"..match_type.."k_count:"..k_count)
	--user_info.sign_ruslt��¼    0��δ����        1��ְҵ��        2��ר�ҳ�          3��ְҵ����ר�ҳ�
	
	local xie_sign = 0
	if(match_type == 2)then
		if(user_info.sign_ruslt == "0")then
			user_info.sign_ruslt = "1"
			xie_sign = 1
		elseif(user_info.sign_ruslt == "2")then
			user_info.sign_ruslt = "3"
 			xie_sign = 1
		end
	elseif(match_type == 3)then
		--TraceError("�����ɹ�user_info.sign_ruslt->>"..user_info.sign_ruslt)
		if(user_info.sign_ruslt == "0")then
			user_info.sign_ruslt = "2"
			xie_sign = 2
		elseif(user_info.sign_ruslt == "1")then
			user_info.sign_ruslt = "3"
 			xie_sign = 2
		end
	end
	user_info.propslist[7] = user_info.propslist[7] - k_count
	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.NewYearTickets_ID, -k_count, user_info)
	--TraceError("--�����ɹ�����۳��ʸ�֤����"..k_count)
	
	--����д���ݿ�
	tex_match.inster_invite_db(user_info,0,match_type,xie_sign)
	
	--д��־	
	local sql = "INSERT INTO log_invite_baoming_info (userid,card_count,card_type,sys_time)	VALUES (%d,%d,%d,now());"
	sql=string.format(sql,user_info.userId,k_count,match_type);
	dblib.execute(sql)
end

--����д���ݿ�
function tex_match.inster_invite_db(user_info,match_gold,match_type, xie_sign)
	--TraceError("����д���ݿ�,sign->"..xie_sign)

		local sql="insert into t_invite_pm(user_id,nick_name,win_gold,match_type,baoming_time,sign) value(%d,'%s',%d,%d,now(),%d) ON DUPLICATE KEY UPDATE baoming_time=NOW()";
		sql=string.format(sql,user_info.userId,user_info.nick,match_gold,match_type,xie_sign);
		dblib.execute(sql)
		 

end	

--���������ȯ
function tex_match.on_recv_buy_ticket(buf)
	--TraceError("--���������ȯ")
	local user_info = userlist[getuserid(buf)]; 
	if(user_info == nil)then return end
	
	local gold = get_canuse_gold(user_info)		--����û�����
	local ruslt = 0
	if(check_datetime() == 0)then	--�жϻ��Ч��
		ruslt = 2
		--TraceError("--���������ȯ����  ��ѹ���")
		
	elseif(gold < 20000)then	--�жϳ���С��2�����
		ruslt = 0
	 	--TraceError("-- ���������ȯ����  ����С��2�����")
		
	else--�����ɹ�����۳��ʸ�֤����
		--TraceError("���͹������ȯ���,�ɹ�")
		ruslt = 1
 		--��2�����
	    usermgr.addgold(user_info.userId, -20000, 0, g_GoldType.baoxiang, -1);
	    
	    --�Ӵ��ڴ�������ȯ 
  		tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.NewYearTickets_ID, 1, user_info)
  	
	end
 
 	--���͹������ȯ���
	tex_match.send_buy_ticket_result(user_info, ruslt)
end
 
--���͹������ȯ���
function tex_match.send_buy_ticket_result(user_info, ruslt)
	--TraceError("���͹������ȯ���,userId:"..user_info.userId.." ruslt->"..ruslt)
	netlib.send(function(buf)
		    buf:writeString("INVITEBUYTK")
		    buf:writeByte(ruslt)		    
	        end,user_info.ip,user_info.port) 
end

--�ֻ��,������ end

--Э������
cmd_tex_match_handler = 
{
	--��̨�����Э��
	["TXJBSINFO"] = tex_match.on_recv_jbs_info,  --������ݽ�������Ϣ
    ["TXJBSJOIN"] = tex_match.on_recv_jbs_baomin,  --������
    ["TXJBSCANCEL"] = tex_match.on_recv_jbs_cancel,  --ȡ������
    
    --���������Э��
    ["INVITEPHLIST"] = tex_match.on_recv_invite_ph_list,  --���������������а�
    ["INVITEDJ"] = tex_match.on_recv_invite_dj,  --��д���������콱���
    ["INVITEBTN"] = tex_match.on_recv_refresh_timeinfo, --����ˢ��ͼ�갴ť��Ϣ
    ["INVITEGIF"] = tex_match.on_recv_already_know_reward, --�ͻ���֪ͨ�Ѿ�����콱��ť��
    
    ["INVITEPHDATE"] = tex_match.on_recv_activity_stat, --����ʱ��״̬
    ["INVITESIGNUP"] = tex_match.on_recv_sign, --����������
    ["INVITEBUYTK"] = tex_match.on_recv_buy_ticket, --���������ȯ
}

--���ز���Ļص�
for k, v in pairs(cmd_tex_match_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", tex_match.on_after_user_login);
eventmgr:addEventListener("timer_minute", tex_match.ontimecheck);