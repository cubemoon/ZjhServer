TraceError("init super_cow_lib...")

if super_cow_lib and super_cow_lib.timer then
	eventmgr:removeEventListener("timer_second", super_cow_lib.timer);
end

if super_cow_lib and super_cow_lib.on_server_start then
	eventmgr:removeEventListener("on_server_start", super_cow_lib.on_server_start); 
end


if not super_cow_lib then
    super_cow_lib = _S
    {    	   
        check_datetime = NULL_FUNC, --���ʱ��
		check_can_game = NULL_FUNC,	--����ǲ�������
		on_recv_check_status = NULL_FUNC, --�ͻ��˲��ǲ�������
		on_recv_query_time = NULL_FUNC, --�ͻ��˼��ʣ��ʱ��
		on_recv_open_game = NULL_FUNC, --�����
		init_poke_box = NULL_FUNC, --��ʼ���ƺ�
		fapai = NULL_FUNC, --����
		get_card_list = NULL_FUNC, --�õ�ָ����������		
    	timer=NULL_FUNC, --��ʱ��
        on_server_start=NULL_FUNC, --ϵͳ����
    	get_real_num = NULL_FUNC, --�õ���ʵ���ƺţ�����J��11
    	get_cow_num = NULL_FUNC, --�õ�ţţ���ƺţ�����J��10
    	get_flower = NULL_FUNC, --�õ��ƵĻ�ɫ
		is_valid_room = NULL_FUNC, ----�ǲ����ڹ涨�ķ�������
		cal_poke_count = NULL_FUNC, --��һ�������ź�����ƣ��м���poke_len���ȵ��ƣ�����poke_len=2������2�������«
		checkisfourbomb = NULL_FUNC, --����ǲ���ը��
		sort_pokes = NULL_FUNC, --���ư���С��������
		get_cow_paixin = NULL_FUNC, --�õ�ţţ������
		wu_niu_shun = NULL_FUNC, --��ţ˳
		wu_xiao_fu = NULL_FUNC,--��С��
		is_gold_cow = NULL_FUNC, --�ǲ��ǽ�ţ
		is_hulu = NULL_FUNC, --�ǲ��Ǻ�«
		is_tonghua = NULL_FUNC, --�ǲ���ͬ��
		is_shun = NULL_FUNC, --�ǲ���˳��
		get_paixin=NULL_FUNC, --�õ�����
		send_supercow_gold = NULL_FUNC, --������ҵ���Ϸ��
		send_caichi = NULL_FUNC, --�������²ʳ�����
		on_recv_xiazhu = NULL_FUNC, --�յ���ע
		send_history = NULL_FUNC, --������ʷ��¼
		on_recv_buy_cowgamegold = NULL_FUNC, --����Ʊ
		send_other_bet_info = NULL_FUNC, --�����������ע����Ϣ
		start_game = NULL_FUNC, --��ʼ��Ϸ
		get_max_poke = NULL_FUNC, --�õ�������
		compare_poke_paixin = NULL_FUNC, --������
		compare_poke_color = NULL_FUNC, --�Ⱥ��
		calc_wingold_supercow = NULL_FUNC,  --������Ӯ
		get_peilv = NULL_FUNC, --�õ�����
		is_double_cow = NULL_FUNC, --ţ���ж�
		update_bet_info = NULL_FUNC, --������ע����Ϣ
		send_supercow_plays = NULL_FUNC, --������б�
		send_zj_user = NULL_FUNC, --���н������
		is_double_cow_new = NULL_FUNC, --�ǲ���ţ��
		send_all_users_info = NULL_FUNC, --Ⱥ����Ϣ��ҵ���Ϣ
		send_btn_status = NULL_FUNC, --���Ͱ�ť��״̬
		change_win_lost = NULL_FUNC, --���Ͱ�ť��״̬
        on_jiesuan = NULL_FUNC, --�����¼�
        on_bet_over = NULL_FUNC, --��ע����¼�
        zhongjiang_num1 = 0, --�н�λ1��Ӯ0��Ӯ
		zhongjiang_num2 = 0, --�н�λ1��Ӯ0��Ӯ
		
		is_check_bianpai = 0, --�Ƿ����˱���
		paixin1 = 0, --�üҵ�����
		paixin2 = 0, --��ҵ�����
		
		user_list={}, --�μӷ��ţ�����
		zj_user_list = {}, --�����н������
		poke_box={}, --�ƺ������
		player_poke_list={  --�üҺ͹�����ϵ���
			[1]={},          --�ü����ϵ���
			[2]={},          --������ϵ���
		},

		sort_player_poke_list={  --�üҺ͹�����ϵ���(�����
			[1]={},          --�ü����ϵ���
			[2]={},          --������ϵ���
		},
		startime = "2012-03-28 08:00:00",  --���ʼʱ��
    	endtime = "2012-05-15 00:00:00",  --�����ʱ��
    	tex_open_time = {}, --{8,9,10},ָ�����ݿ����ʱ��
		qp_open_time = {}, --{8,9,10},ָ�����ƿ����ʱ��
    	fajiang_time = 0,  --���ַ���ʱ��
    	fapai_time = 0, --���ַ���ʱ��
    	send_all_users_flag = 0, --���������ǲ���Ⱥ����Ϣ֪ͨ���˽��������µ�����
    	send_caichi_flag = 0, --�������Ƹ��²ʳ�
    	other_bet_time = 0, --���������ע��Ϣ
    	CFG_TEX_GAMEGOLD_RATE = 1,
    	CFG_QP_GAMEGOLD_RATE = 1,
    	CFG_CHOUSHUI_INFO = 0.05, --ȡ��Ʊ�Ļ���Ҫ��%5��ˮ
    	CFG_MAX_BET_RATE = 0.1,
		--����ע
		all_bet_count=0,
		
		CFG_QP_LIMIT_BET = 2000000,	--��������ע����  1000
		CFG_TEX_LIMIT_BET = 2000000, --��������ע����  1000
		CFG_LIMIT_AREA_BET = 2000000,	--������ע����  1000
		
		CFG_ALLOW_GM = 0, --�Ƿ���������GM���˹��ܣ����֣�ɱ�֣�1����0������
		already_gm_change_gold = 0, --����Ӯ���ܽ����		
		CFG_GM_LOSE_GOLD = 30000000, --�乻��3000����ɱ�֡�3000�����Ѷȡ�50��%
		CFG_GM_WIN_GOLD = -90000000, --Ӯ����9000���򳴷֡�3000�����Ѷȡ�50��% 
		
		CFG_GM_CAOFEN_RATE = 2, --2����2��֮1�Ļ��ʣ����Ҫ���ͻ��ʾ͸ĳ�3��4��5��������
		alread_gm_chao_fen_gold = 0, --�����ѳ�����ɱ���˶��ٷ�
		CFG_GM_CHAO_FEN_GOLD = -30000000, --���ֵ�Ǯ(�����������ӮǮ������add_goldΪ���������Գ�ʼֵ��Ƴɸ�����
		CFG_GM_SHA_FEN_GOLD = 30000000, --ɱ�ֵ�Ǯ��ɱ���������ӮǮ������Ҫ��add_goldΪ����������һ��ʼ��Ƴ�������
		CFG_DISPLAY_USERS_LEN = 30,--���ֻ��ʾ30�����
		CFG_CAICHI_XZ_RATE = 0.01,--�ʳ����ӹ����Ϊ�� ÿ��ȡ��ע������1%�ĵ��ʳأ��ʳط�Χ100����2000��
		--������Ͷע��Ϣ
		bet_count={
			[1]=0,          
			[2]=0,        
			[3]=0,         
			[4]=0,         
 		},		

		cfg_game_name = {      --��Ϸ���� 
		    ["soha"] = "soha",
		    ["cow"] = "cow",
		    ["zysz"] = "zysz",
		    ["mj"] = "mj",
		    ["tex"] = "tex",
		},
		
		tex_gm_id_arr = {}, -- {'832791'},
		qp_gm_id_arr = {}, --{'19563389'},
		CFG_INIT_BET="0,0,0,0", --Ĭ��Ͷע��Ϣ
		
		caichi=0, --�ʳ�
		CFG_MAX_CAICHI = 20000000, --���Ĳʳ�
		CFG_INIT_CAICHI = 1000000, --��ʼ���ʳص�ֵ
		CFG_CAICHI_RATE = 0.2, --ÿ�ֽ����ȡ1/5��ˮ���ʳ�
		CFG_CANT_BETTIME = 10, --ֹͣ��עʱ�� 10��
		CFG_BET_RATE = 1, --һǧ��һע
        sys_win_gold = 0, --ϵͳ��Ӯ
		CFG_REFRESH_OTHER_BET = 5, --ÿ��xx��ˢ�����������ע�����	
		CFG_FAPAI_TIME = 80, --����80���3����
		CFG_MAX_EXCHANGE = 1000000000,--���һ�10��
		qp_game_room = 62022, --�������ĸ����俪��Ϸ
		tex_game_room = 18001, --�������ĸ����俪��Ϸ	
		history={},
	    history_len = 10,	--��ʷ��¼����
	    already_fapai=0,   --�������ƶ�ʱ���ǲ��Ƿ�������
        niu_percent = 0.1,   --��ţ�ĸ���
		--���Ͷ�Ӧ�����ʣ�Ϊ-1ʱ�ͷ��ʳ����Ǯ
		paixin_rate={
			[1]=1,    --��ţ
			[2]=1,    --ţ1
			[3]=1,    --ţ2
			[4]=1,    --ţ3
			[5]=1,    --ţ4
			[6]=1,    --ţ5
			[7]=1,    --ţ6			
			[8]=2,    --ţ7
			[9]=2,    --ţ8			
			[10]=3,   --ţ9
			[11]=5,   --ţţ
			[12]=7,   --˳��
			[13]=7,   --ͬ��
			[14]=7,   --��«
			[15]=10,   --��ţ
			[16]=15,   --��С�� 
			[17]=-777,   --��÷ 
			[18]=-777,   --ţ��
			[19]=-777,   --��ţ˳			
		}
    }    
end

--�������߿ͻ��˰�ť�ܲ��ܵ�
function super_cow_lib.send_btn_status(user_id)
	local user_info=usermgr.GetUserById(user_id)
	if(user_info==nil)then return end
	--������¶�����Ʊ
	local most_bet_gold=math.floor(super_cow_lib.user_list[user_id].cowgamegold_count*super_cow_lib.CFG_MAX_BET_RATE) or 0
	--����ť,Ĭ���ܵ�
	local buy_btn=1
	local jiesuan_btn=1
	local add_one_btn=1
	local add_three_btn=1

	--����ǽ������10�룬�Ͳ��ܵ㹺��ͽ���
	local curr_time = os.time();
	local remain_time = super_cow_lib.fajiang_time-curr_time;
	if(remain_time<=10)then
		buy_btn=0
		jiesuan_btn=0
	end
	
	--�������ע���Ͳ��ܵ����
	if (super_cow_lib.user_list[user_id].bet_info~=super_cow_lib.CFG_INIT_BET)then
		jiesuan_btn=0
	end
	--��1����ע֮���ܲ��ܵ�
	local already_bet_gold=super_cow_lib.user_list[user_id].bet_num_count or 0
	local add_to_gold=already_bet_gold+already_bet_gold
	if(most_bet_gold<add_to_gold)then
		add_one_btn=0
	end
	--��3����ע֮���ܲ��ܵ�
	add_to_gold=already_bet_gold+already_bet_gold*3
	if(most_bet_gold<add_to_gold)then
		add_three_btn=0
	end
	
	netlib.send(function(buf)
        buf:writeString("FNCOWBTN"); --���ذ�ť�Ƿ�ҪΪ�ɵ�״̬
        buf:writeInt(most_bet_gold);		--������¶�����Ʊ
      	buf:writeInt(buy_btn); --����
      	buf:writeInt(jiesuan_btn); --����
      	buf:writeInt(add_one_btn); --��һ��
      	buf:writeInt(add_three_btn); --������
    end,user_info.ip,user_info.port);
end

--�������ˣ�ʣ�࿪��ʱ��
function super_cow_lib.on_recv_query_time(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	super_cow_lib.send_remain_time(user_info,super_cow_lib.fajiang_time)
end

--���߿ͻ��˻��������
function super_cow_lib.send_remain_time(user_info,fajiang_time)
	local curr_time = os.time();
	local remain_time = fajiang_time-curr_time;
	netlib.send(function(buf)
        buf:writeString("FNCOWTIME"); --֪ͨ�ͻ��ˣ�ʣ�࿪��ʱ��
        buf:writeInt(remain_time);		--ʣ�࿪��ʱ��
    end,user_info.ip,user_info.port);
end

--ÿ����ʾͷ���ǳơ���Ϸ�ң��Լ���ʾ�ڵ�һ��
function super_cow_lib.send_supercow_plays(user_info,tmp_user_list)
	local count_user = #tmp_user_list
	
	--�������30������ֻ��ʾ30��
	local tmp_len=super_cow_lib.CFG_DISPLAY_USERS_LEN
	local i=0
	if(count_user>tmp_len)then count_user=tmp_len end 
	netlib.send(function(buf)
	        buf:writeString("FNCOWPLAYERS"); --����ˣ���������б�
	        buf:writeInt(count_user+1)
	        --�ȷ�����
        	buf:writeInt(super_cow_lib.user_list[user_info.userId].user_id);		--���ID
	        buf:writeString(super_cow_lib.user_list[user_info.userId].nick_name);		--����ǳ�
	        buf:writeString(super_cow_lib.user_list[user_info.userId].face);		--���ͷ��·��
	        buf:writeInt(super_cow_lib.user_list[user_info.userId].cowgamegold_count);		--���Ŀǰ����Ϸ������
	        
			for k,v in pairs(tmp_user_list) do
		        i=i+1
		        buf:writeInt(v.user_id);		--���ID
		        buf:writeString(v.nick_name);		--����ǳ�
		        buf:writeString(v.face);		--���ͷ��·��
		        buf:writeInt(v.cowgamegold_count);		--���Ŀǰ����Ϸ������
		        if(i>=count_user) then break end
			end
	end,user_info.ip,user_info.port);
end

--�����
function super_cow_lib.on_recv_open_game(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	local user_id=user_info.userId;
   	--֪ͨ�ͻ��ˣ������Ϣ
   	local send_dvd_info = function(user_info)
   		local user_id=user_info.userId
        if (super_cow_lib.user_list[user_id] == nil) then
            return
        end
   		local bet_info=super_cow_lib.user_list[user_id].bet_info
   		local tmp_user_bet_info=split(bet_info,",")
   		netlib.send(function(buf)
            buf:writeString("FNCOWOPEN"); --֪ͨ�ͻ��ˣ����������Ʊ��
             buf:writeInt(super_cow_lib.user_list[user_id].cowgamegold_count or 0)
             buf:writeInt(1); --������Ϸ�Ҷһ���
             buf:writeString(1-super_cow_lib.CFG_CHOUSHUI_INFO); --ȡ����Ϸ�Ҷһ���
              
            buf:writeInt(4); --Ĭ��Ϊ4�����򶼴��ؿͻ��ˡ���Ϊ�����������������򶼿�������Ͷ
			for i=1,4 do
				buf:writeInt(i) --����id
				local tmpnum=super_cow_lib.bet_count[i]-tonumber(tmp_user_bet_info[i])
				buf:writeInt(tmpnum or 0) --������� Ͷע����Ʊ����
				buf:writeInt(tonumber(tmp_user_bet_info[i])) --����Լ� Ͷע����Ʊ����
				
			end            
            end,user_info.ip,user_info.port) 

           	--��ע������������Ϸ�ҵ�1/10
          	local max_bet_count = math.floor(super_cow_lib.user_list[user_id].cowgamegold_count*super_cow_lib.CFG_MAX_BET_RATE)
        --����ע��������������
         	if (gamepkg.name == "tex") then
         		if (max_bet_count > super_cow_lib.CFG_TEX_LIMIT_BET) then
                    max_bet_count = super_cow_lib.CFG_TEX_LIMIT_BET
                end
            else
                if (max_bet_count > super_cow_lib.CFG_QP_LIMIT_BET) then
                    max_bet_count = super_cow_lib.CFG_QP_LIMIT_BET
                end
         	end
            netlib.send(function(buf)
                    buf:writeString("FNCOWMAXBET");
                    buf:writeInt(max_bet_count or 0);
            end,user_info.ip,user_info.port);
   	end
	
	--super_cow_db_lib.init_supercow_db(user_id)	
 	
   	--���ͻ��˷�����ʱ�仹�������
   	super_cow_lib.send_remain_time(user_info,super_cow_lib.fajiang_time)
   	
   	--���ͻ��˷�������ʷ
   	super_cow_lib.send_history(user_info,super_cow_lib.history)
   	
   	--֪ͨ�ͻ��ˣ������Ϣ
   	send_dvd_info(user_info)
   	
   	--һ�ֿ�ʼ��30���Ҫ����
	if(os.time() > super_cow_lib.fapai_time)then
     	super_cow_lib.fapai()
    end
    
	--Ⱥ����Ϣ��֪ͨ�µ�����
	super_cow_lib.send_all_users_flag = 1	
	
	--��һ�²ʳ�
	netlib.send(function(buf)
	    buf:writeString("FNCOWCAICHI");
	    buf:writeInt(super_cow_lib.caichi or 0);
	end,user_info.ip,user_info.port);
	
	--��һ�°�ť״̬
	super_cow_lib.send_btn_status(user_id)
end

--����Ƿ�����Чʱ����
super_cow_lib.on_recv_check_status = function(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	local user_id=user_info.userId;
   	
   	--��һ���ǲ�����ָ���ķ�����
   	local status=super_cow_lib.check_datetime()   

   	netlib.send(function(buf)
            buf:writeString("FNCOWACTIVE");
            buf:writeInt(status or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
        end,user_info.ip,user_info.port);
end


--������ҵ���Ϸ��
super_cow_lib.send_supercow_gold = function(user_info,super_cow_gold)
	if(user_info~=nil)then
	   	netlib.send(function(buf)
	            buf:writeString("FNCOWCOINS");
	            buf:writeInt(super_cow_gold or 0);
	        end,user_info.ip,user_info.port);
        local user_id = user_info.userId
       	--��ע������������Ϸ�ҵ�1/10
      	local max_bet_count = math.floor(super_cow_lib.user_list[user_id].cowgamegold_count*super_cow_lib.CFG_MAX_BET_RATE)
        --����ע��������������
     	if (gamepkg.name == "tex") then
     		if (max_bet_count > super_cow_lib.CFG_TEX_LIMIT_BET) then
                max_bet_count = super_cow_lib.CFG_TEX_LIMIT_BET
            end
        else
            if (max_bet_count > super_cow_lib.CFG_QP_LIMIT_BET) then
                max_bet_count = super_cow_lib.CFG_QP_LIMIT_BET
            end
     	end
        netlib.send(function(buf)
                buf:writeString("FNCOWMAXBET");
                buf:writeInt(max_bet_count or 0);
            end,user_info.ip,user_info.port);    
    end
end

--������ҵ�Ͷע��Ϣ
function super_cow_lib.update_bet_info(user_id,area_id,cowgamegold_bet)
	
	--�����ַ����ж�Ӧλ�õ�ֵ
	local update_bet=function(user_id,bet_info,area_id,cowgamegold_bet)
		if(bet_info==nil or bet_info=="")then
			bet_info=super_cow_lib.CFG_INIT_BET;	
		end
		local tmp_tab=split(bet_info,",")
		local tmp_str=""
		local tmp_bet=0
		tmp_bet=tonumber(tmp_tab[area_id])

		if(tmp_bet==nil)then
			TraceError("error bet_info="..bet_info)
		end
		tmp_bet=tmp_bet+cowgamegold_bet

		tmp_tab[area_id]=tostring(tmp_bet)
	
		for i=1,#tmp_tab do
			tmp_str=tmp_str..","..tmp_tab[i]
		end
		
		local tmp_bet_info=string.sub(tmp_str,2)
		super_cow_db_lib.update_db_bet_info(user_id,tmp_bet_info,super_cow_lib.bet_id)
		return tmp_bet_info --ȥ����1�����ź󷵻�
	end
	
	--������ҵ�Ͷע��Ϣ
	
	bet_info=update_bet(user_id,super_cow_lib.user_list[user_id].bet_info,area_id,cowgamegold_bet)
	
	return bet_info
end

--���²ʳ�
super_cow_lib.send_caichi = function()
	for k,v in pairs(super_cow_lib.user_list) do
	   	local user_info=usermgr.GetUserById(v.user_id)
	   	if(user_info~=nil)then 
		   	netlib.send(function(buf)
		            buf:writeString("FNCOWCAICHI");
		            buf:writeInt(super_cow_lib.caichi or 0);
		        end,user_info.ip,user_info.port);
	    end
    end
end

--������ʷ��
function super_cow_lib.send_history(user_info,history_list)
	local send_len = 0
	if(history_list~=nil)then
	   send_len=#history_list
	end
	netlib.send(function(buf)
    	buf:writeString("FNCOWREC")
    	    
		 buf:writeInt(send_len)
			if(send_len < super_cow_lib.history_len)then
				for i=1,send_len do
			        buf:writeByte(history_list[i].zhongjiang_num1)
			        buf:writeByte(history_list[i].zhongjiang_num2)
			         
		        end
			else
		        for i=1,super_cow_lib.history_len do
			    	buf:writeByte(history_list[i].zhongjiang_num1)
			        buf:writeByte(history_list[i].zhongjiang_num2) 
		        end
		    end
     	end,user_info.ip,user_info.port) 
end

--�ǲ����ڹ涨�ķ�������
super_cow_lib.is_valid_room=function()
	if(gamepkg.name == "tex" and super_cow_lib.tex_game_room ~= tonumber(groupinfo.groupid))then
		return 0
	end
	if(gamepkg.name ~= "tex" and super_cow_lib.qp_game_room ~= tonumber(groupinfo.groupid))then
		return 0
	end
	return 1
end

function super_cow_lib.on_server_start(e)
    if (super_cow_lib.is_valid_room() == 1) then
        super_cow_db_lib.get_sys_win_from_db(function(sys_win_gold)
            super_cow_lib.sys_win_gold = sys_win_gold
        end)
        super_cow_db_lib.rollback_user_bet()
    end
end

--ʱ����������
function super_cow_lib.timer(e) 
	if (super_cow_lib.is_valid_room()~=1) then return end
	
	--һ�ֿ�ʼ��80���Ҫ����
	if(super_cow_lib.already_fapai==0 and os.time() > super_cow_lib.fapai_time)then
     	super_cow_lib.fapai()
     	super_cow_lib.already_fapai=1
    end

    if(super_cow_lib.is_check_bianpai == 0 and 
       super_cow_lib.fajiang_time - os.time() < super_cow_lib.CFG_CANT_BETTIME) then
        super_cow_lib.is_check_bianpai = 1
        local bet_info = {super_cow_lib.bet_count[2], super_cow_lib.bet_count[1]}
        xpcall(function() super_cow_lib.on_bet_over(bet_info) end, throw)
    end
    
  	--1���ӿ�һ��
  	if(os.time() > super_cow_lib.fajiang_time)then	 
     	--����(�и�ȱ�ݣ��տ��ֻ����һ��û���й�������
     	super_cow_lib.start_game()
    end


    --����ˢ��������ҵ���ע���
    if(os.time() > super_cow_lib.other_bet_time)then	 
     	--����(�и�ȱ�ݣ��տ��ֻ����һ��û���й�������
     	super_cow_lib.send_other_bet_info()
    end
    
  	--���users�з����仯��Ⱥ��һ�£�֪ͨ���пͻ���
  	if(super_cow_lib.send_all_users_flag == 1)then	 
     	--����(�и�ȱ�ݣ��տ��ֻ����һ��û���й�������
     	super_cow_lib.send_all_users_flag = 0
     	super_cow_lib.send_all_users_info()     	
    end
    
    --���ʳ�
    if(super_cow_lib.send_caichi_flag == 1)then
    	 super_cow_lib.send_caichi_flag = 0    	 
    	 super_cow_lib.send_caichi()
    end
end

--Ⱥ����ҵ���Ϣ����������
function super_cow_lib.send_all_users_info()
	local tmp_user_list={}
	local count_user=0
	for k,v in pairs(super_cow_lib.user_list) do
		table.insert(tmp_user_list,v)
		count_user=count_user+1
	end
	table.sort(tmp_user_list, 
	      function(a, b)
		     return a.cowgamegold_count > b.cowgamegold_count		                   
	end)

	for k,v in pairs(tmp_user_list) do
		local user_info=usermgr.GetUserById(v.user_id)
		if(user_info~=nil)then
			super_cow_lib.send_supercow_plays(user_info,tmp_user_list)
		end
	end
end

--����ǲ�������
function super_cow_lib.check_can_game()
	local can_game=1
	
	if (super_cow_lib.is_valid_room()~=1) then return 0 end
	
	if super_cow_lib.cfg_game_name[gamepkg.name] == nil then return 0 end
	
	can_game=super_cow_lib.check_datetime()
    return can_game
end

--�����Чʱ�䣬��ʱ����int	0�����Ч�������Ҳ�ɲ�������1�����Ч
function super_cow_lib.check_datetime()
	local sys_time = os.time();	
	local startime = timelib.db_to_lua_time(super_cow_lib.startime);
	local endtime = timelib.db_to_lua_time(super_cow_lib.endtime);

	if(sys_time > endtime or sys_time < startime) then
		return 0;
	end
	
	--ֻ����ָ����ʱ���ʱ��
 	local tableTime = os.date("*t",sys_time);
	local nowHour  = tonumber(tableTime.hour);

	local open_time={}
	if (gamepkg.name == "tex") then
		open_time = super_cow_lib.tex_open_time
	else
		open_time = super_cow_lib.qp_open_time
	end
	
	--������趨����Ϸ��ʱ�䣬�Ϳ�һ���ǲ����������ʱ�䷶Χ��
	if(open_time~=nil and #open_time>0)then
		for k,v in pairs(open_time) do
			if(nowHour==v)then
				return 1
			end
		end
		return 0
	end
	--�ʱ���ȥ��
	return 1;

end

--��ʼ���ƺ�
function super_cow_lib.init_poke_box()
	super_cow_lib.poke_box={}
	--û�д�С���������ƺ���ֻҪ��52����
	for i=1,52 do
		super_cow_lib.poke_box[i]=i
    end
    --����һ����
	table.disarrange(super_cow_lib.poke_box)
    
	--���üҷ�5����
	super_cow_lib.player_poke_list[1]=super_cow_lib.get_card_list(5)
	--����ҷ�5����
	super_cow_lib.player_poke_list[2]=super_cow_lib.get_card_list(5)
	
	--�õ��ú͹���ź������
	super_cow_lib.sort_player_poke_list[1]=super_cow_lib.sort_pokes(super_cow_lib.player_poke_list[1])
	super_cow_lib.sort_player_poke_list[2]=super_cow_lib.sort_pokes(super_cow_lib.player_poke_list[2])
	
end

--����
function super_cow_lib.fapai()
	--��ǰ3���Ƹ��߿ͻ���
	local function send_first_card(user_info)
		local player_poke1 = super_cow_lib.player_poke_list[1]
		local player_poke2 = super_cow_lib.player_poke_list[2]
		netlib.send(function(buf)
	            buf:writeString("FNCOWFAPAI");
	            buf:writeInt(3);
	            for i=1,3 do
	            	buf:writeInt(player_poke1[i]);
	            end
	            buf:writeInt(3);
	            for i=1,3 do
	            	buf:writeInt(player_poke2[i]);
	            end
	            
	      end,user_info.ip,user_info.port);
	end	

	--�����еķ��ţ���ߵ���ҷ�ǰ������
	for k,v in pairs(super_cow_lib.user_list)do
		local user_info=usermgr.GetUserById(v.user_id)
		if(user_info~=nil)then
			send_first_card(user_info)
		end
	end
end

--��ĳ����ҷ��������
function super_cow_lib.send_kajiang_info(user_info,real_win_gold)
		local player_poke1 = super_cow_lib.player_poke_list[1]
		local player_poke2 = super_cow_lib.player_poke_list[2]
		netlib.send(function(buf)
	            buf:writeString("FNCOWKAI");
	            buf:writeInt(2);
	            for i=1,2 do
	            	buf:writeInt(player_poke1[3+i]); --����4�͵�5���Ƹ��ͻ���
	            end
	            buf:writeInt(2);
	            for i=1,2 do
	            	buf:writeInt(player_poke2[3+i]); --����4�͵�5���Ƹ��ͻ���
	            end
	            
	            buf:writeInt(super_cow_lib.paixin1); --�üҵ�����
	            buf:writeInt(super_cow_lib.paixin2); --��ҵ�����
	            buf:writeInt(super_cow_lib.zhongjiang_num1); --�ù���Ӯ
	            buf:writeInt(super_cow_lib.zhongjiang_num2); --�����Ӯ
	            buf:writeInt(real_win_gold)
					            
	      end,user_info.ip,user_info.port);
end

--[[
    ���Ǽ�Ӯwin_pos 1����Ӯ�� 2�ù�Ӯ
    peilv Ӯ��������
--]]
function super_cow_lib.change_win_lost(win_pos, peilv)    	
    if(win_pos ~= 1 and win_pos ~= 2) then
        TraceError("����ĵ���λ��"..win_pos or -100)
        return
    end
    local lose_pos = -1
    if (win_pos == 1) then 
        lose_pos = 2 
    end
    if (win_pos == 2) then 
        lose_pos = 1 
    end

    local find_info = {peilv = 1000, poke_index1 = -1, poke_index2 = -1}
    local poke_list = super_cow_lib.player_poke_list[win_pos]
    for i = 1, 10 do
        for j = i + 1, 10 do
            poke_list[4]= super_cow_lib.poke_box[i]
            poke_list[5]= super_cow_lib.poke_box[j]
            super_cow_lib.sort_player_poke_list[win_pos]=super_cow_lib.sort_pokes(poke_list)
            local paixin = super_cow_lib.get_paixin(super_cow_lib.sort_player_poke_list[win_pos])        
            local changed_peilv = super_cow_lib.get_peilv(paixin)
            if (changed_peilv ~= -777 and changed_peilv <= peilv and
                math.abs(changed_peilv - peilv) <= math.abs(find_info["peilv"] - peilv)) then --�ҵ���ӽ�������
                find_info = {peilv = changed_peilv, poke_index1 = i, poke_index2 = j}
                if (find_info["peilv"] == peilv) then --�ҵ�����ͬ���ʵģ�ֱ�ӷ�����
                    break
                end
            end
        end
    end
    local poke_index1 = find_info["poke_index1"]
    if (poke_index1 <= 0) then
        TraceError("���Ϊɶû���ҵ�����ڵ����أ�������")
        return
    end
    poke_list[4] = super_cow_lib.poke_box[find_info["poke_index1"]]
    poke_list[5] = super_cow_lib.poke_box[find_info["poke_index2"]]
    super_cow_lib.sort_player_poke_list[win_pos] = super_cow_lib.sort_pokes(poke_list)
    table.remove(super_cow_lib.poke_box, find_info["poke_index2"])
    table.remove(super_cow_lib.poke_box, find_info["poke_index1"])
    --������һ����
    poke_list = super_cow_lib.player_poke_list[lose_pos]    
    for i = 1, 10, 2 do        
        poke_list[4]= super_cow_lib.poke_box[i]
        poke_list[5]= super_cow_lib.poke_box[i + 1]
        super_cow_lib.sort_player_poke_list[lose_pos] = super_cow_lib.sort_pokes(poke_list)
        local paixin = super_cow_lib.get_paixin(super_cow_lib.sort_player_poke_list[lose_pos])
        local changed_peilv = super_cow_lib.get_peilv(paixin)
        if (changed_peilv < find_info["peilv"]) then  
            table.remove(super_cow_lib.poke_box, i)
            table.remove(super_cow_lib.poke_box, i)
            break
        end
    end
    return
end

--ȡN����
function super_cow_lib.get_card_list(poke_count)
    local temp = {}
    for i = 1, poke_count do 
        table.insert(temp, super_cow_lib.poke_box[1])
        table.remove(super_cow_lib.poke_box, 1)
    end
    --���ƣ� 10%�ĸ��ʵ�ţ7����
    local random = math.random(1, 100)
    if (random < super_cow_lib.niu_percent * 100) then
        local find = 0
        for i = 1, 10 do
            for j = i + 1, 10 do
                temp[4]= super_cow_lib.poke_box[i]
                temp[5]= super_cow_lib.poke_box[j]
                local sort_pokes=super_cow_lib.sort_pokes(temp)
                local paixin = super_cow_lib.get_paixin(sort_pokes)        
                if (paixin > 7) then
                    table.remove(super_cow_lib.poke_box, j)
                    table.remove(super_cow_lib.poke_box, i)   
                    find = 1
                    break                 
                end
            end
            if (find == 1) then
                break
            end
        end
    end
    return temp
end

--�õ���Ӧ���Ƶĺ�
function super_cow_lib.get_real_num(poke_num)
	local tmp_num=math.floor(poke_num%13)
	if(tmp_num==0)then
		return 13
	else
		return tmp_num
	end
end

--�õ���Ӧ���Ƶ�ţ�ţ���ţţ�11��12��13��Ϊ10��
function super_cow_lib.get_cow_num(poke_num)
	local tmp_num=math.floor(poke_num%13)
	if(tmp_num==0 or tmp_num>10)then
		tmp_num = 10
	end
	return tmp_num
end

--�õ���Ӧ���Ƶĺ�
function super_cow_lib.get_flower(poke_num)
	if(poke_num<=13)then
		return 0
	elseif(poke_num<=26)then
		return 1
	elseif(poke_num<=39)then
		return 2
	elseif(poke_num<=52)then
		return 3
	end		
end

--��һ���ź����5���ƹ��������ǲ���ը��
function super_cow_lib.checkisfourbomb(pokes)
	if(super_cow_lib.get_real_num(pokes[1]) == super_cow_lib.get_real_num(pokes[4]) or super_cow_lib.get_real_num(pokes[2]) == super_cow_lib.get_real_num(pokes[5])) then
		return true
	else
		return false
	end
end

--���Ƶ���ʵ���ִ�С������,�����Ϊ��С����
function super_cow_lib.sort_pokes(pokes)
	local new_pokes=table.clone(pokes)
	table.sort(new_pokes, function(pram1,pram2) return super_cow_lib.get_real_num(pram1) < super_cow_lib.get_real_num(pram2) end)
	return new_pokes
end


--�����ҵ�������û��ţ
--10����ţţ
--9����ţ9
--0������ţ
--���������һ�ԣ��򷵻�1�����򷵻�0
function super_cow_lib.get_cow_paixin(pokelist)
	if not pokelist or #pokelist ~= 5 then return false end
	local pokeArr = {}

	table.insert(pokeArr,{pokelist[1],pokelist[2],pokelist[3]})
	table.insert(pokeArr,{pokelist[1],pokelist[2],pokelist[4]})
	table.insert(pokeArr,{pokelist[1],pokelist[2],pokelist[5]})
	table.insert(pokeArr,{pokelist[1],pokelist[3],pokelist[4]})
	table.insert(pokeArr,{pokelist[1],pokelist[3],pokelist[5]})
	table.insert(pokeArr,{pokelist[1],pokelist[4],pokelist[5]})
	table.insert(pokeArr,{pokelist[2],pokelist[3],pokelist[4]})
	table.insert(pokeArr,{pokelist[2],pokelist[3],pokelist[5]})
	table.insert(pokeArr,{pokelist[2],pokelist[4],pokelist[5]})
	table.insert(pokeArr,{pokelist[3],pokelist[4],pokelist[5]})

	local pointArr={}
	table.insert(pointArr,{pokelist[4],pokelist[5]})
	table.insert(pointArr,{pokelist[3],pokelist[5]})
	table.insert(pointArr,{pokelist[3],pokelist[4]})
	table.insert(pointArr,{pokelist[2],pokelist[5]})
	table.insert(pointArr,{pokelist[2],pokelist[4]})
	table.insert(pointArr,{pokelist[2],pokelist[3]})
	table.insert(pointArr,{pokelist[1],pokelist[5]})
	table.insert(pointArr,{pokelist[1],pokelist[4]})
	table.insert(pointArr,{pokelist[1],pokelist[3]})
	table.insert(pointArr,{pokelist[1],pokelist[2]})
	local point = 0
    local is_dui = 0
	--��ǰ������û��ţ���ٿ���ţ��
	for i=1,#pokeArr do
		local cow_value = 0
		for k,v in pairs(pokeArr[i]) do		
			cow_value = cow_value + super_cow_lib.get_cow_num(v)			
		end

		local bValid = math.mod(cow_value,10) == 0 and 1 or 0 ; -- �Ƿ���ţ
		if bValid == 1 then
			
			local point_temp = 0
            local is_dui_temp = 1
			for k,v in pairs(pointArr[i]) do
				point_temp = point_temp + super_cow_lib.get_cow_num(v)
            end
            local real_num = -1
            for k,v in pairs(pointArr[i]) do
                if (real_num == -1) then  --����Ƿ���һ��
                    real_num = super_cow_lib.get_real_num(v)
                elseif (real_num ~= super_cow_lib.get_real_num(v)) then
                    is_dui_temp = 0                    
                end
			end
			point_temp = math.mod(point_temp, 10)
			--Ϊ�˷������ţţ�����ͣ������ţţ�ͷ���10��
			if(point_temp == 0)then 
                point_temp = 10 
            end
            if (is_dui_temp == 1) then --����Ƕԣ���ֱ�ӷ�����
			    return point_temp, is_dui_temp
            elseif (point_temp >= point and is_dui == 0) then --��ǰû���ҵ��ԣ���������                
                point = point_temp
                is_dui = is_dui_temp
            end
		end
	end
	return point, is_dui
end

--��һ�������ź�������ǲ�����ţ˳(��ҵ���Ϊ(3.4.5.6.7)��(6.7.8.9.10)��(7.8.9.10.J)������50����ţ˳)
function super_cow_lib.wu_niu_shun(pokes)
	if(super_cow_lib.is_shun(pokes)~=true)then
		return false
	end
	
	if(super_cow_lib.get_real_num(pokes[1])==3 and super_cow_lib.get_real_num(pokes[5])==7 )then
		return true
	end
	if(super_cow_lib.get_real_num(pokes[1])==6 and super_cow_lib.get_real_num(pokes[5])==10 )then
		return true
	end
	if(super_cow_lib.get_real_num(pokes[1])==7 and super_cow_lib.get_real_num(pokes[5])==11 )then
		return true
	end	
	return false
end

--��һ�������ź�������ǲ�����С��(��ҵ������Ƽ���������ʮ��)
function super_cow_lib.wu_xiao_fu(pokes)
	local cow_num=0
	for k,v in pairs (pokes) do
		cow_num=cow_num+super_cow_lib.get_cow_num(v)
	end
	
	if(cow_num<=10)then
		return true
	else
		return false
	end	
end

--��һ�������ź�������ǲ��ǽ�ţ
function super_cow_lib.is_gold_cow(pokes)
	local cow_num=0
	for k,v in pairs (pokes) do
		if(super_cow_lib.get_cow_num(v)~=10)then
			return false
		end
	end
	return true
end

--��һ�������ź�������ǲ��� ��«(�����������������ӵ���)
function super_cow_lib.is_hulu(pokes)
	--1��3����ͬ��1��2����ͬ���ͷ��� ��«
	if(super_cow_lib.cal_poke_count(pokes,3)==1 and super_cow_lib.cal_poke_count(pokes,2)==3)then
		return true
	end
	return false
end

--��һ�������ź�����ƣ��м���poke_len���ȵ��ƣ�����poke_len=2������2������2��2�Լ���«�����poke_len=3������2������2������
--����Ҫ��һ�º�«�������ǲ��ǻ����
function super_cow_lib.cal_poke_count(pokes,poke_len)
	local count=0
	for i=#pokes,1,-1 do
		if(i-poke_len+1==0)then break end		
		if(super_cow_lib.get_real_num(pokes[i])==super_cow_lib.get_real_num(pokes[i-poke_len+1]))then
			--����Ҫ��һ�º�«�������ǲ��ǻ���ģ�����ǣ���Ҫ and pokes[i]~=pokes[i-poke_len]����
			count=count+1
		end
	end
	return count
end

--��һ�������ź�������ǲ��� ͬ��
function super_cow_lib.is_tonghua(pokes)
	local flower=-1
	for k,v in pairs(pokes) do		
		if(flower~=-1 and flower~=super_cow_lib.get_flower(v))then
			return false
		else
			flower=super_cow_lib.get_flower(v)
		end
	end
	return true
end

--��һ�������ź�������ǲ��� ˳��
function super_cow_lib.is_shun(pokes)
	local tmp_num1=super_cow_lib.get_real_num(pokes[5])-super_cow_lib.get_real_num(pokes[4])
	local tmp_num2=super_cow_lib.get_real_num(pokes[4])-super_cow_lib.get_real_num(pokes[3])
	local tmp_num3=super_cow_lib.get_real_num(pokes[3])-super_cow_lib.get_real_num(pokes[2])
	local tmp_num4=super_cow_lib.get_real_num(pokes[2])-super_cow_lib.get_real_num(pokes[1])
	if(tmp_num1==tmp_num2 and tmp_num2==tmp_num3 and tmp_num3==tmp_num4 and tmp_num1==1)then
		return true
	end
	return false
end

--�õ�����
function super_cow_lib.get_paixin(pokes)
	--�Ӹߵ��ͷ�������
	--��ţ˳
	if(super_cow_lib.wu_niu_shun(pokes))then
		return 19;
	end
	
	--��÷
	if(super_cow_lib.checkisfourbomb(pokes))then
		return 17;
	end
	
	--��С��
	if(super_cow_lib.wu_xiao_fu(pokes))then
		return 16;
	end
	
	--��ţ
	if(super_cow_lib.is_gold_cow(pokes))then
		return 15;
	end
	
	--��«
	if(super_cow_lib.is_hulu(pokes))then
		return 14;
	end
	
	--ͬ��
	if(super_cow_lib.is_tonghua(pokes))then
		return 13;
	end
	
	--˳��
	if(super_cow_lib.is_shun(pokes))then
		return 12;
	end
	
	--ţţ��ţ9��������ţ1����ţ
	local cow_point, is_dui =super_cow_lib.get_cow_paixin(pokes)
	return cow_point+1;--����ţ1�����Ͷ�Ӧ�Ĵ���һλ�����Լ�1������0������ţ������2ʱ����ţ1��3����ţ2
end


--������ע
function super_cow_lib.on_recv_xiazhu(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;

	if (super_cow_lib.is_valid_room()~=1) then return end
	
   	local user_id=user_info.userId
   	--��ע����
   	local area_id = buf:readInt();--����id
   	local cowgamegold_bet = buf:readInt();--�������µĽ�ţ��Ϸ������
   	local bet_type = buf:readByte(); --��ע����1,��ע��2��ע

   	
   	--���ؿͻ�����ע���
   	local send_bet_result=function(user_info,result)
   		netlib.send(function(buf)
	            buf:writeString("FNCOWBET");
	            buf:writeInt(result);		--��ע�����0����עʧ�ܣ� 1����ע�ɹ��� 2�����Ч��
	            buf:writeInt(area_id);		--��ע�����0����עʧ�ܣ� 1����ע�ɹ��� 2�����Ч��
	            
	        end,user_info.ip,user_info.port);
   	end
   	
   	--���ֽ���ǰ10�벻���������ע
 	if(super_cow_lib.fajiang_time-os.time()<super_cow_lib.CFG_CANT_BETTIME ) then
		send_bet_result(user_info,0)
   		return
	end
   	if(cowgamegold_bet==-1)then
   		super_cow_lib.user_list[user_id].bet_num_count=0
   		super_cow_lib.user_list[user_id].bet_info=super_cow_lib.CFG_INIT_BET      				
   		return
    end

    --����ֱ�ӷ��سɹ�
	if (bet_type == 2 and cowgamegold_bet == 0) then
        send_bet_result(user_info,1)
        return
    end
   	
	--����������ע����
 	if(cowgamegold_bet>super_cow_lib.CFG_LIMIT_AREA_BET) then
 		send_bet_result(user_info,3)
   		return
 	end
 		
 	--���˵�����ע
 	if(super_cow_lib.user_list[user_id].bet_num_count==nil)then
 		super_cow_lib.user_list[user_id].bet_num_count = 0
 	end
 	
 	--���˵�����ע
 	if(super_cow_lib.user_list[user_id].cowgamegold_count<cowgamegold_bet)then
 		send_bet_result(user_info,2)
 		return
 	end
 	
 	--����ע��������������
 	local tmp_limit=super_cow_lib.CFG_QP_LIMIT_BET
 	if (gamepkg.name == "tex") then
 		tmp_limit=super_cow_lib.CFG_TEX_LIMIT_BET
 	end
 	
   	if(super_cow_lib.user_list[user_id].bet_num_count>tmp_limit-cowgamegold_bet)then
   	 	send_bet_result(user_info,3)
   		return
   	end
   	--��ע������������Ϸ�ҵ�1/10
  	local tmp_bet_count = super_cow_lib.user_list[user_id].bet_num_count + cowgamegold_bet
  	if(tmp_bet_count>super_cow_lib.user_list[user_id].cowgamegold_count*super_cow_lib.CFG_MAX_BET_RATE)then
  		send_bet_result(user_info,3)
   		return
  	end  	
    local after_add_cowgamegold=function(user_id,result)
    	local user_info=usermgr.GetUserById(user_id)
	    if(result~=nil and result~=-1)then
			--�۳��ˣ��͸�����ע���ֶΣ�֪ͨ�ͻ�����ע�ɹ�
			
			super_cow_lib.user_list[user_id].cowgamegold_count=result --ˢ��һ�������ж���Ǯ������ע
		   	super_cow_lib.user_list[user_id].bet_num_count = super_cow_lib.user_list[user_id].bet_num_count + cowgamegold_bet
	  		super_cow_lib.user_list[user_id].bet_info=super_cow_lib.update_bet_info(user_info.userId,area_id,cowgamegold_bet)
			super_cow_lib.user_list[user_id].bet_id=super_cow_lib.bet_id
			send_bet_result(user_info,1)
			
			--��ע�ɹ���Ҫ֪ͨ�ͻ����µ�Ǯ���ж���
			super_cow_lib.send_supercow_gold(user_info,result)
			
			--������ע��Ϣ��������ע��Ϣ
			super_cow_lib.all_bet_count=super_cow_lib.all_bet_count+cowgamegold_bet
			super_cow_lib.bet_count[area_id]=super_cow_lib.bet_count[area_id]+cowgamegold_bet
			
			--�Ӳʳ�			
			super_cow_lib.add_caichi(math.floor(cowgamegold_bet*super_cow_lib.CFG_CAICHI_XZ_RATE))
			--д��־
			--���˱���־
			if(cowgamegold_bet>0)then
				super_cow_db_lib.log_user_supercow(user_id,result,cowgamegold_bet,1,super_cow_lib.user_list[user_id].bet_info or super_cow_lib.CFG_INIT_BET)
                super_cow_db_lib.update_user_bet_to_db(user_id, cowgamegold_bet)
			end
			
			--������ť�ܲ��ܵ�
			super_cow_lib.send_btn_status(user_id)
			
		else
			send_bet_result(user_info,2)
		end		
    end
    
   	--��������ϵĽ�ţ��Ϸ�ң�����ɹ��ͷ��ؿͻ��˳ɹ�����Ȼ��֪ͨ˵ʧ��
   	super_cow_db_lib.add_cowgamegold(user_id,-cowgamegold_bet,2,super_cow_lib.user_list[user_id].bet_info,after_add_cowgamegold)	
end

--���Ӳʳ�
function super_cow_lib.add_caichi(win_cowgamegold_bet)
	super_cow_lib.caichi=super_cow_lib.caichi+win_cowgamegold_bet   --���ڲ��ó�ˮsuper_cow_lib.CFG_CAICHI_RATE
	if(super_cow_lib.caichi>super_cow_lib.CFG_MAX_CAICHI)then
		super_cow_lib.caichi=super_cow_lib.CFG_MAX_CAICHI
	end
	super_cow_lib.send_caichi_flag = 1
end

--���չ�����Ʊ
super_cow_lib.on_recv_buy_cowgamegold = function(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	if (super_cow_lib.is_valid_room()~=1) then return end

    local user_id=user_info.userId
	--���͹�����Ʊ���
	local function send_buy_cowgamegold_result(user_info, result,cowgamegold_count,org_gamegold_count)
		netlib.send(function(buf)
	            buf:writeString("FNCOWEXCG");
	            buf:writeInt(result);		--�һ���ʽ��ʶ��1������ 2��ȡ���� 0��Ϊ�һ�����   3������ʱ���ܹ���
	            buf:writeInt(cowgamegold_count);		--�һ���Ʊ����
	            buf:writeInt(org_gamegold_count or 0);		--�һ�ԭʼ��Ʊ����
	            
	        end,user_info.ip,user_info.port);
	end
	
	 local after_add_cowgamegold=function(user_id,result)
    	local user_info=usermgr.GetUserById(user_id)
	    if(result~=nil and result~=-1)then
			--�۳��ˣ��͸�����ע���ֶΣ�֪ͨ�ͻ�����ע�ɹ�			
			super_cow_lib.user_list[user_id].cowgamegold_count=result --ˢ��һ�������ж���Ǯ������ע
					  
			--��ע�ɹ���Ҫ֪ͨ�ͻ����µ�Ǯ���ж���
			super_cow_lib.send_supercow_gold(user_info,result)			
			
			--д��־
			--���˱���־		
			super_cow_db_lib.log_user_supercow(user_id,result,result,2,super_cow_lib.user_list[user_id].bet_info or super_cow_lib.CFG_INIT_BET)
		end		
    end
	

   	 --�յ���Ʊ
   	local buy_type=buf:readInt(); --1���� 2.ȡ��
    local buy_cowgamegold = buf:readInt(); --��Ʊ����    
    
    --��������������ˣ���ô�Ͳ��ܴ�ȡ��Ʊ
    if(super_cow_lib.user_list[user_id].cowgamegold_count==nil)then
    	--����ȡ��Ʊ���
    	result = 0
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
    	return
    end
    --����ʱ���ܴ�ȡ
    if( user_info.site~=nil)then 
        result = 3
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
        
        return	
    end

    --����ûǮ�Ļ���������ȡ
    if(buy_type==2 and super_cow_lib.user_list[user_id].cowgamegold_count==0)then
    	--����ȡ��Ʊ���
    	result = 0
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
    	return
    end
    
    --ȡ��ʱ����������������ע���Ͳ�����ȡ��
    if(buy_type==2 and super_cow_lib.user_list[user_id].bet_info~=super_cow_lib.CFG_INIT_BET)then
    	--����ȡ��Ʊ���
    	result = 0
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
    	return
    end
	
	--������Ʊ���ܳ���10��
    if(buy_type==1 and super_cow_lib.user_list[user_id].cowgamegold_count+buy_cowgamegold>super_cow_lib.CFG_MAX_EXCHANGE)then
    	--���;�����Ʊ���
    	result = 4
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
    	return
    end	
	
    --������ϵ���Ʊ��Ҫȡ����Ʊ�٣��Ͳ���ȡ�������ʼֵ��0��nil������ȡ��ʱ��ֻ��Ҫ�ж��ڴ棬û�ж����ݿ�
    if(buy_type==2 and super_cow_lib.user_list[user_id].cowgamegold_count<buy_cowgamegold)then
    	--����ȡ����Ʊ���
    	result = 0
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
    	return
    end

    --�����ȡ������Ҫ��*-1
    local temp_flag=1
    if(buy_type==2)then
    	temp_flag=-1
   	end
   	
    --�Ӽ�����
    local choushui_gold=0
    --�����ȡ����Ҫ��5%�ĳ�ˮ,����Ļ�������ˮ
   	local cowgamegold_choushui=1
   	local cowgamegold_rate=1
   	if (gamepkg.name == "tex") then
   		cowgamegold_rate = super_cow_lib.CFG_TEX_GAMEGOLD_RATE
   	else
   		cowgamegold_rate = super_cow_lib.CFG_QP_GAMEGOLD_RATE
   	end

   	if(buy_type==2)then --ȡ��
   		cowgamegold_choushui=1-super_cow_lib.CFG_CHOUSHUI_INFO
   		choushui_gold=cowgamegold_rate * buy_cowgamegold*super_cow_lib.CFG_CHOUSHUI_INFO
   	end  	
    
    --���ʱ��cowgamegold_choushui==1��ȡ��ʱ����0.95(�����۳�ˮ��
    local org_buy_cowgamegold = buy_cowgamegold
    local buy_cowgamegold = cowgamegold_rate * buy_cowgamegold*cowgamegold_choushui
    local can_use_gold = 0 
    
    --����ǹ�����Ʊ����Ҫ��һ��Ǯ������
    if(user_info.site==nil)then
		can_use_gold = get_canuse_gold(user_info) 
	end


    if(buy_type==1 and can_use_gold==0)then
    	--���͹�����Ʊ���
    	result = 3 --����ʱ���ܹ��򣬲�ֱ���ж�site������can_usegold���Ժ��ٸĽ���
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
    	return
    end

	if(buy_type==1 and can_use_gold<buy_cowgamegold)then
    	--���͹�����Ʊ���
    	result = 0
		send_buy_cowgamegold_result(user_info, result, buy_cowgamegold)
    	return
    end


	--�ȼӼ�Ǯ���ټӼ���Ʊ
	--�Ӽ�Ǯ�ü����ˮ���ֵȥ�����Ӽ���Ʊ��ԭʼ��û�۹���ˮ��ֵȥ��
	usermgr.addgold(user_id, math.floor(buy_cowgamegold*temp_flag*-1), 0, new_gold_type.SUPERCOW, -1);    
	local bet_info=super_cow_lib.user_list[user_id].bet_info or super_cow_lib.CFG_INIT_BET
	
	super_cow_db_lib.add_cowgamegold(user_id,org_buy_cowgamegold*temp_flag,3,bet_info,after_add_cowgamegold)	

	--֪ͨ�ͻ��˴�ȡ��Ʊ�Ľ��
	send_buy_cowgamegold_result(user_info, buy_type, math.floor(buy_cowgamegold),org_buy_cowgamegold)
	
end

--�������Ͷע������Ϣ
function super_cow_lib.send_other_bet_info()
	local tmp_user_bet_info1={} --����ͳ��Ͷע��������ʱ����
	local tmp_bet_info=""
	local tmp_str=""

	
	--֪ͨ�ͻ��ˣ��������Ͷע����������˼�ȥ�Լ���
	for k,v in pairs (super_cow_lib.user_list) do
		local user_info=usermgr.GetUserById(v.user_id)
		if(user_info~=nil)then
			tmp_user_bet_info1=split(super_cow_lib.user_list[v.user_id].bet_info or super_cow_lib.CFG_INIT_BET,",")
			
			netlib.send(function(buf)
		    	buf:writeString("FNCOWOTHBET")
		    	buf:writeInt(4)    	
		    	for i=1,4 do
		    		local other_bet_num=super_cow_lib.bet_count[i]-tonumber(tmp_user_bet_info1[i])
		    		buf:writeInt(i)
		    		buf:writeInt(other_bet_num or 0)    		
		    	end
		    	end,user_info.ip,user_info.port)
	    end
     end
     
     --5��֮������ٽ���һ��,ÿ5��ˢ��һ��������ҵ���ע���
     super_cow_lib.other_bet_time=os.time() + super_cow_lib.CFG_REFRESH_OTHER_BET
end

--�������͵õ�����,����-777�����òʽ��Ǯ
function super_cow_lib.get_peilv(paixin)
	return super_cow_lib.paixin_rate[paixin]
end


--����Ӯ�˶���Ǯ
function super_cow_lib.calc_wingold_supercow(user_id,bet_info)
	if(bet_info==nil or bet_info==super_cow_lib.CFG_INIT_BET)then return 0,0 end	
	if(super_cow_lib.user_list[user_id].bet_id~=super_cow_lib.bet_id)then return 0,0 end
	
	local win_zhuang_gold=0
	local win_redblack_gold=0
	local tmp_user_bet_info=split(bet_info,",")
	local peilv=0
	local tmp_num1=0
	local tmp_num2=0
	local win_paixin_peilv1=super_cow_lib.get_peilv(super_cow_lib.paixin1)--�ڹ�Ӯʱ������
	local win_paixin_peilv2=super_cow_lib.get_peilv(super_cow_lib.paixin2)--����Ӯʱ������
	local real_win_gold=0
	--��Ӯ
	if(super_cow_lib.zhongjiang_num1==1)then
		--�õ�����
		if(win_paixin_peilv2==-777)then		
			if(tonumber(tmp_user_bet_info[1])~=0)then
				win_zhuang_gold=(tonumber(tmp_user_bet_info[1])/super_cow_lib.bet_count[1])*super_cow_lib.caichi*super_cow_lib.CFG_BET_RATE
				win_zhuang_gold=win_zhuang_gold+tonumber(tmp_user_bet_info[1])*super_cow_lib.CFG_BET_RATE
				real_win_gold=(tonumber(tmp_user_bet_info[1])/super_cow_lib.bet_count[1])*super_cow_lib.caichi*super_cow_lib.CFG_BET_RATE
			end
		else
			tmp_num1=tonumber(tmp_user_bet_info[1])*super_cow_lib.CFG_BET_RATE*(win_paixin_peilv2+1) --Ѻ��Ӯ��Ǯ
			tmp_num2=tonumber(tmp_user_bet_info[2])*super_cow_lib.CFG_BET_RATE*(win_paixin_peilv2-1) --Ѻ�����Ǯ
			win_zhuang_gold=tmp_num1-tmp_num2  --Ӯ��Ǯ�����Ǯ������Ϊ����Ŷ
			--����ʵ��Ӯ��Ǯ
			tmp_num1=tonumber(tmp_user_bet_info[1])*super_cow_lib.CFG_BET_RATE*win_paixin_peilv2 --Ѻ��Ӯ��Ǯ
			tmp_num2=tonumber(tmp_user_bet_info[2])*super_cow_lib.CFG_BET_RATE*win_paixin_peilv2 --Ѻ�����Ǯ
			real_win_gold=tmp_num1-tmp_num2  --Ӯ��Ǯ�����Ǯ������Ϊ����Ŷ			
			
		end
	else
	--��Ӯ		
		--�õ�����
		if(win_paixin_peilv1==-777)then
			if(tonumber(tmp_user_bet_info[2])~=0)then
				win_zhuang_gold=(tonumber(tmp_user_bet_info[2])/super_cow_lib.bet_count[2])*super_cow_lib.caichi*super_cow_lib.CFG_BET_RATE
				win_zhuang_gold=win_zhuang_gold+tonumber(tmp_user_bet_info[2])*super_cow_lib.CFG_BET_RATE
				real_win_gold=(tonumber(tmp_user_bet_info[2])/super_cow_lib.bet_count[2])*super_cow_lib.caichi*super_cow_lib.CFG_BET_RATE
			end
		else
			tmp_num1=tonumber(tmp_user_bet_info[2])*super_cow_lib.CFG_BET_RATE*(win_paixin_peilv1+1) --Ѻ��Ӯ��Ǯ
			tmp_num2=tonumber(tmp_user_bet_info[1])*super_cow_lib.CFG_BET_RATE*(win_paixin_peilv1-1) --Ѻ�����Ǯ
			win_zhuang_gold=tmp_num1-tmp_num2  --Ӯ��Ǯ�����Ǯ������Ϊ����Ŷ
			--����ʵ��Ӯ��Ǯ
			tmp_num1=tonumber(tmp_user_bet_info[2])*super_cow_lib.CFG_BET_RATE*win_paixin_peilv1 --Ѻ��Ӯ��Ǯ
			tmp_num2=tonumber(tmp_user_bet_info[1])*super_cow_lib.CFG_BET_RATE*win_paixin_peilv1 --Ѻ�����Ǯ
			real_win_gold=tmp_num1-tmp_num2  --Ӯ��Ǯ�����Ǯ������Ϊ����Ŷ
		end
	end

	--��Ӯ(*2��Ϊ�˷�����	
	if(super_cow_lib.zhongjiang_num2==1)then
		tmp_num1=tonumber(tmp_user_bet_info[3])*super_cow_lib.CFG_BET_RATE*2
		tmp_num2=0    --tonumber(tmp_user_bet_info[4])*super_cow_lib.CFG_BET_RATE�����������ʵ����ٴ�������д����1
		win_redblack_gold=tmp_num1-tmp_num2   --��Ӯ��Ǯ��ȥ�����Ǯ
		--����ʵ��Ӯ��Ǯ
		tmp_num1=tonumber(tmp_user_bet_info[3])*super_cow_lib.CFG_BET_RATE
		tmp_num2=tonumber(tmp_user_bet_info[4])*super_cow_lib.CFG_BET_RATE		
		real_win_gold=real_win_gold+tmp_num1-tmp_num2
	else
		--��Ӯ
		tmp_num1=0 --tonumber(tmp_user_bet_info[3])*super_cow_lib.CFG_BET_RATE
		tmp_num2=tonumber(tmp_user_bet_info[4])*super_cow_lib.CFG_BET_RATE*2
		win_redblack_gold=tmp_num2-tmp_num1
		--����ʵ��Ӯ��Ǯ
		tmp_num1=tonumber(tmp_user_bet_info[3])*super_cow_lib.CFG_BET_RATE
		tmp_num2=tonumber(tmp_user_bet_info[4])*super_cow_lib.CFG_BET_RATE
		real_win_gold=real_win_gold+tmp_num2-tmp_num1
	end	
	win_zhuang_gold=math.floor(win_zhuang_gold)
	win_redblack_gold=math.floor(win_redblack_gold)
	real_win_gold=math.floor(real_win_gold)
	return win_zhuang_gold,win_redblack_gold,real_win_gold
end

--����1�����1������ţ�ԣ�2�����2������ţ�ԣ�3����2�߶���ţ�ԣ�0��������ţ��
function super_cow_lib.is_double_cow_new(pokes1,pokes2)
	local ret_num=0
    local cow_point1, is_dui1 = super_cow_lib.get_cow_paixin(pokes1)
    local cow_point2, is_dui2 = super_cow_lib.get_cow_paixin(pokes2)
	if(cow_point1 ~= 10 and cow_point2 ~= 10)then  --û��һ��Ϊţţ��ֱ�ӷ���        
		return ret_num  
    end
    if(cow_point2 == 10 and cow_point1 > 0 and is_dui1 == 1) then --һ����ţţ��һ����ţ���ж�
        ret_num = ret_num + 1
    end
    if(cow_point1 == 10 and cow_point2 > 0 and is_dui2 == 1) then --һ����ţţ��һ����ţ���ж�
        ret_num = ret_num + 2
    end
	return ret_num
end

--���н��б�
function super_cow_lib.send_zj_user(user_info)
	
	local send_len=10
	if(send_len>#super_cow_lib.zj_user_list)then
		send_len=#super_cow_lib.zj_user_list
	end
	netlib.send(function(buf)
		buf:writeString("FNCOWUSERS"); --֪ͨ�ͻ��ˣ�ʣ�࿪��ʱ��
		buf:writeInt(send_len); --Ҫ��ʾ�ļ�¼����
		for i=1,send_len do
			buf:writeInt(super_cow_lib.zj_user_list[i].user_id);
	        buf:writeString(super_cow_lib.zj_user_list[i].nick_name);	
	      	buf:writeString(super_cow_lib.zj_user_list[i].face);
	      	buf:writeInt(super_cow_lib.zj_user_list[i].win_gold);
		end
	end,user_info.ip,user_info.port);
end

--����
--ÿ10���ӽ���һ�Σ�Ҫ���������£�
--1. �����ֵ���Ա����
--2. ��ʼ���µ�һ���õ��ı���
--3. д������־
function super_cow_lib.start_game()
	if (super_cow_lib.is_valid_room()~=1) then return end
	local sql="";
    local after_add_cowgamegold=function(user_id,result)
    	local user_info=usermgr.GetUserById(user_id)
	    if(result~=nil and result~=-1)then
			--�۳��ˣ��͸�����ע���ֶΣ�֪ͨ�ͻ�����ע�ɹ�
			
			super_cow_lib.user_list[user_id].cowgamegold_count=result --ˢ��һ�������ж���Ǯ������ע
		 	
			--��ע�ɹ���Ҫ֪ͨ�ͻ����µ�Ǯ���ж���
			super_cow_lib.send_supercow_gold(user_info,result)

			--д��־
			--���˱���־
			super_cow_db_lib.log_user_supercow(user_id,result,result,3,super_cow_lib.user_list[user_id].bet_info or super_cow_lib.CFG_INIT_BET)
		end		
    end
    
    local function real_jieshuan()
    	--�õ�����
	 	super_cow_lib.paixin1=super_cow_lib.get_paixin(super_cow_lib.sort_player_poke_list[1])
	 	super_cow_lib.paixin2=super_cow_lib.get_paixin(super_cow_lib.sort_player_poke_list[2])
	 	
		
		--����üҺ͹�Ҷ���ţţ��Ҫ��һ���ǲ���ţ��
		if(super_cow_lib.paixin1>=11 or super_cow_lib.paixin2>=11)then
			local ret = super_cow_lib.is_double_cow_new(super_cow_lib.sort_player_poke_list[1],super_cow_lib.sort_player_poke_list[2])
			if (ret == 1) then 
				super_cow_lib.paixin1 = 18 
			end
			if (ret == 2) then 
				super_cow_lib.paixin2 = 18 
			end
			if (ret == 3) then 
				super_cow_lib.paixin1 = 18
				super_cow_lib.paixin2 = 18 
			end 		
			
		end
		
		--�����üһ��ǹ��ʤ
		super_cow_lib.zhongjiang_num1 = super_cow_lib.compare_poke_paixin()
		
		--���Ǻ��û��Ǻ�ʤ
		super_cow_lib.zhongjiang_num2 = super_cow_lib.compare_poke_color()
		    	
		--�����ù�2�ҵ�����˭ʤ˭��
		--�ǲ���Ѻ���ˣ����Ѻ���ˣ��͸���ҷ���
        local sys_win_gold = 0
		for k,v in pairs(super_cow_lib.user_list) do
			local user_id = v.user_id			
			local win_zhuang_gold,win_redblack_gold,real_win_gold=super_cow_lib.calc_wingold_supercow(v.user_id,v.bet_info)
            if(real_win_gold==nil)then real_win_gold=0 end
			local win_cowgamegold_bet=win_zhuang_gold+win_redblack_gold
			local user_info = usermgr.GetUserById(user_id)			
            sys_win_gold = sys_win_gold + real_win_gold

			local buf={}
			buf.user_id=v.user_id
			buf.win_gold=real_win_gold
			buf.nick_name=v.nick_name
			buf.face=v.face
			buf.cowgamegold_count=v.cowgamegold_count
			
			--���������׬Ǯ�˾ͷŵ��н��û��б�����͸��ʳؼ�Ǯ
			if(real_win_gold>0)then
				table.insert(super_cow_lib.zj_user_list,buf)
			elseif(win_cowgamegold_bet<0)then
				--���ڸĳ�����ע�ɹ�ʱ�Ӳʳأ�����ӮǮʱ��
				--super_cow_lib.add_caichi(math.abs(win_cowgamegold_bet))							
			end
			super_cow_db_lib.add_cowgamegold(user_id,win_zhuang_gold+win_redblack_gold,1,v.bet_info,after_add_cowgamegold) --����ҷ���

			if(user_info~=nil)then
				super_cow_lib.send_kajiang_info(user_info,real_win_gold) --�ѷ�����������ͻ���
			end
        end
        --�޸��ڴ���Ӯ����Ϸ��
        super_cow_lib.sys_win_gold = super_cow_lib.sys_win_gold - sys_win_gold
        --�޸�ϵͳ��Ӯ����Ϸ��
        super_cow_db_lib.update_sys_win(super_cow_lib.sys_win_gold)
        super_cow_lib.on_jiesuan(super_cow_lib.sys_win_gold)
        --������ݿ�����ʱ��ע��Ǯ
        super_cow_db_lib.clear_user_temp_bet()
    end
    
	local function fajiang()
		--��ʵ����
		real_jieshuan()
		
		--������˲ʳؾ�Ҫ��ʼ���ʳ�		
		local win_paixin_peilv1=super_cow_lib.get_peilv(super_cow_lib.paixin1)--��һ���ǲ��ǿ��˲ʳ�
		local win_paixin_peilv2=super_cow_lib.get_peilv(super_cow_lib.paixin2)--��һ���ǲ��ǿ��˲ʳ�		
		if(win_paixin_peilv1==-777 or win_paixin_peilv2==-777)then
			super_cow_lib.caichi=super_cow_lib.CFG_INIT_CAICHI
		end
			
		
		--������ʷ����
		if(#super_cow_lib.history < super_cow_lib.history_len)then		--�������С��6��ֱ�Ӽ���
			local bufftable ={
						  	    zhongjiang_num1 = super_cow_lib.zhongjiang_num1, 
			                    zhongjiang_num2 = super_cow_lib.zhongjiang_num2,
			                }	                
			table.insert(super_cow_lib.history,bufftable)
		else
			table.remove(super_cow_lib.history,1)	--ɾ����һ��		
			local bufftable ={
						  	    zhongjiang_num1 = super_cow_lib.zhongjiang_num1, 
			                    zhongjiang_num2 = super_cow_lib.zhongjiang_num2,
			                }	                
			table.insert(super_cow_lib.history,bufftable)
		end
		--д��ʷ������־
	 	super_cow_db_lib.log_supercow_history(super_cow_lib.zhongjiang_num1,super_cow_lib.zhongjiang_num2,super_cow_lib.bet_id);	 	
		--���µĲʳص��ͻ���
		super_cow_lib.send_caichi()
		
		if(super_cow_lib.zj_user_list==nil or #super_cow_lib.zj_user_list==0)then return end
		if(#super_cow_lib.zj_user_list>2)then
			table.sort(super_cow_lib.zj_user_list, 
			      function(a, b)
				     return a.win_gold > b.win_gold		                   
			end)
		end	
		
		--�����н��б�
		for k,v in pairs(super_cow_lib.user_list) do
			local user_info=usermgr.GetUserById(v.user_id)
			if(user_info~=nil)then
				super_cow_lib.send_zj_user(user_info)
			end
		end		
	end
	
 	--��ʼ��һ�ֵ���Ϣ
 	local function init_game_info()
 		local curr_time=os.time()
		--��ʼ��������ʱ��
	 	super_cow_lib.fajiang_time = curr_time+60*2
	 	super_cow_lib.fapai_time = curr_time + super_cow_lib.CFG_FAPAI_TIME --����֮�� 30���ٷ�3����
	 	
	 	--��ʼ���ƺ�
	 	super_cow_lib.init_poke_box()
	 	
	 	--��ʼ�����ֵ�ͶעID��������ʱ��Ϊ��͵��ֶ���ΪͶעID
	 	super_cow_lib.bet_id = os.date("%Y%m%d%H%M", curr_time)
	 	
	 	--��ʼ���������˵��б�
	 	for k,v in pairs(super_cow_lib.user_list) do
			local user_info=usermgr.GetUserById(v.user_id)
			if(user_info==nil)then				
				table.remove(super_cow_lib.user_list,v.user_id)
			else				
				super_cow_lib.user_list[v.user_id].bet_info=super_cow_lib.CFG_INIT_BET
				super_cow_lib.user_list[v.user_id].bet_num_count=0				
			end
	 	end
	 	
	 	--�������µ�bet_id�����������ֹ����������ʱҪ��Ǯ
	 	super_cow_db_lib.update_last_betid(super_cow_lib.bet_id)
	 	
	 	
	 	--��ʼ����Ӯ���
	 	super_cow_lib.zhongjiang_num1=0
	 	super_cow_lib.zhongjiang_num2=0
	 		 	
	 	super_cow_lib.paixin1=0
	 	super_cow_lib.paixin2=0
	 	
	 	--��ʼ�����Ƶ�״̬
	 	super_cow_lib.already_fapai=0
        --�޸ı��Ʊ��
	 	super_cow_lib.is_check_bianpai = 0
	 	--��ʼ���ʳ�
	 	if(super_cow_lib.caichi==0)then
	 		super_cow_lib.caichi=super_cow_lib.CFG_INIT_CAICHI
	 	end
	 	
		--������Ͷע��Ϣ
		super_cow_lib.bet_count={
			[1]=0,          
			[2]=0,        
			[3]=0,         
			[4]=0,         
 		}
	 	super_cow_lib.zj_user_list={}
 	end
 	
 	--����һ�ֵ��˷���
 	if(super_cow_lib.player_poke_list[1]~=nil and #super_cow_lib.player_poke_list[1]>0)then
 		fajiang();
 	end
 	
 	--��ʼ����һ�ֵ���Ϣ
 	init_game_info();
	
end

--���������ƣ��õ������ƵĻ�ɫ������
function super_cow_lib.get_max_poke(pokes)
	local max_num=0
	local max_flower=0

	--��5���ƾ���������
	max_num=super_cow_lib.get_real_num(pokes[5])
	max_flower=super_cow_lib.get_flower(pokes[5])
	return max_num,max_flower
end

--�Ⱥ��
function super_cow_lib.compare_poke_color()
	local red_count=0 --�ü��м�������
	for k,v in pairs(super_cow_lib.player_poke_list[2]) do
		local tmp_flower=0
		tmp_flower=super_cow_lib.get_flower(v)
		if(tmp_flower==0 or tmp_flower==2)then
			red_count=red_count+1
		end
	end
	
	if(red_count>2)then
		return 1
	else
		return 0
	end
end

--�����ı�ʤ��
function super_cow_lib.compare_poke_paixin()
	
	--���������ȣ��������Ƶ�
	if(super_cow_lib.paixin1 == super_cow_lib.paixin2)then
		--�ȿ���С���ٿ���ɫ
		local max_num1=0
		local max_flower1=0
		local max_num2=0
		local max_flower2=0
		
		--�õ������ƵĻ�ɫ������
		max_num1,max_flower1=super_cow_lib.get_max_poke(super_cow_lib.sort_player_poke_list[1])
		max_num2,max_flower2=super_cow_lib.get_max_poke(super_cow_lib.sort_player_poke_list[2])

		--�ȿ�����ƵĴ�С���ٿ���ɫ��
		if(max_num1>max_num2)then
			return 0
		elseif(max_num2>max_num1)then
			return 1
		elseif(max_flower1>max_flower2)then
			return 0
		else
			return 1			
		end
	end

	--����õ����ʹ󣬾ͷ���1
	if(super_cow_lib.paixin1>super_cow_lib.paixin2)then
		return 0
	end
	
	return 1

end


--Э������
cmd_supercow_handler = 
{
        ["FNCOWACTIVE"] = super_cow_lib.on_recv_check_status, --�ͻ��ˣ��������Ƿ���Ч
        ["FNCOWBET"] = super_cow_lib.on_recv_xiazhu, --������ע
        ["FNCOWEXCG"] = super_cow_lib.on_recv_buy_cowgamegold, --����һ���Ϸ��
        ["FNCOWOPEN"] = super_cow_lib.on_recv_open_game, --���մ����
        
}

--���ز���Ļص�
for k, v in pairs(cmd_supercow_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("timer_second", super_cow_lib.timer);
eventmgr:addEventListener("on_server_start", super_cow_lib.on_server_start); 