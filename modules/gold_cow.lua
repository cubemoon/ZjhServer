TraceError("init gold_cow_lib...")

if gold_cow_lib and gold_cow_lib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", gold_cow_lib.on_after_user_login);
end

if gold_cow_lib and gold_cow_lib.timer then
	eventmgr:removeEventListener("timer_second", gold_cow_lib.timer);
end

if gold_cow_lib and gold_cow_lib.restart_server then
	eventmgr:removeEventListener("on_server_start", gold_cow_lib.restart_server);
end


if gold_cow_lib and gold_cow_lib.on_game_over then
	eventmgr:removeEventListener("game_event", gold_cow_lib.on_game_over);
end

if not gold_cow_lib then
    gold_cow_lib = _S
    {    	   
        on_after_user_login = NULL_FUNC,--��½��������
		check_datetime  = NULL_FUNC,	--�����Чʱ�䣬��ʱ����
		on_recv_query_time = NULL_FUNC, --�ͻ��˼��ʣ��ʱ��
        on_recv_check_status = NULL_FUNC, --֪ͨ����ˣ�����״̬
        on_recv_open_game = NULL_FUNC, --�������ˣ�����������Ϣ
        send_remain_time = NULL_FUNC, --���������뿪��
        update_bet_info = NULL_FUNC, --����Ͷע��Ϣ
        on_recv_xiazhu = NULL_FUNC, --�ͻ���֪ͨ��ע
        send_caichi=NULL_FUNC, --�����ͻ��˲ʳص���Ϣ
        add_caichi=NULL_FUNC, --�Ӳʳ�
        on_game_over = NULL_FUNC,                   --�����¼�
        --����׬�Ľ�ţ��Ϸ��
        get_random_num = NULL_FUNC, --���������
        get_card_num=NULL_FUNC, --�õ�6����
        set_user_cowgold_info = NULL_FUNC, --�������С��Ϸ��һЩ��Ϸ��һ���Ǹ����ݲ����
        start_game = NULL_FUNC, --��ʼ��Ϸ
        timer = NULL_FUNC, --��ʱ��
        send_other_bet_info = NULL_FUNC, --�������˵�Ͷע��Ϣ
        send_history = NULL_FUNC, --������ʷ��¼
        gm_open_num = NULL_FUNC, --��ָ���ĺ�
        on_recv_gm_num = NULL_FUNC, --�ͻ���֪ͨ��ָ���ĺ�
        update_pl=NULL_FUNC,	--�����µ�����
        init_poke_box=NULL_FUNC, --��ʼ���ƺ�
        get_one_poke=NULL_FUNC,  --���ƺ�����һ����
        send_is_finish=NULL_FUNC, --�����ͻ��ˣ��ǲ��Ǵ�15�̣����������С��Ϸ��
        send_gold_change=NULL_FUNC, --�����ͻ����µĿ��õć��˱�
        change_safebox_gold=NULL_FUNC, --�ı��������ڴ����Ǯ
        is_valid_room = NULL_FUNC,
   		--��Ϸ����:
   		num1 = 0,	--��1����
		num2 = 0,	--��2����
		num3 = 0,	--��3����
		num4 = 0,   --��4����
		num5 = 0,   --��5����
		num6 = 0,   --��6����
		
		zhongjiang_num = 0, --�н���λ��
		gm_num = 0, --gm��ָ����λ��
		
		history = {},	--��ʷ����
		history_len = 11,	--��ʷ���ӳ���

		total_num = 0,	--������ӽ��
	
		limit_bet = 100000,	--��������ע����
		tex_limit_bet = 10000,--��������ע����
		
		limit_local_bet = 100000,	--������ע����  1000
		day_count_bet = 10000,	--����ÿ����ע����  10000 ��(ÿʮ���Ӳſ�һ�Σ������ܵ�10000�Σ������������Ӧ����û�õģ�


		--��עʱ�� 10����
		startime = "2012-04-27 08:00:00",  --���ʼʱ��
    	endtime = "2012-05-11 00:00:00",  --�����ʱ��
		fajiang_time = 0,  --���ַ���ʱ��
		other_bet_time = 0, --���������ע��Ϣ
		bet_id = "-1", --���ֵ�ID
		
		all_user_bet_info={}, --���������ע��Ϣ
		user_list={}, --��ץ��ţС��Ϸ�����
		poke_box={}, --�ƺ�
		
		--�������ñ�
		bet_peilv = {
			[1]=12,          
			[2]=6,        
			[3]=3,         
			[4]=3,         
			[5]=6,           
			[6]=12,           
		},
		
		--����ע
		all_bet_count=0,
		
		--������Ͷע��Ϣ
		bet_count={
			[1]=0,          
			[2]=0,        
			[3]=0,         
			[4]=0,         
			[5]=0,           
			[6]=0,           
		},		

		cfg_game_name = {      --��Ϸ���� 
		    ["soha"] = "soha",
		    ["cow"] = "cow",
		    ["zysz"] = "zysz",
		    ["mj"] = "mj",
		    ["tex"] = "tex",
		},
		
		qp_game_room = 4031, --��Ϊֻ����һ��������
		tex_game_room = 18001, --��Ϊֻ����һ��������
		
		tex_gm_id_arr = {}, -- {'832791'},
		qp_gm_id_arr = {}, --{'19563389'},
		org_bet_info="0,0,0,0,0,0", --Ĭ��Ͷע��Ϣ
		
		caichi=0, --�ʳ�
		CFG_CAN_PLAY=15,    --������������ܲ�����ץ��ţ
		CFG_CANT_BETTIME=10, --ֹͣ��עʱ�� 10��
		CFG_BET_RATE=1000, --һǧ��һע
		CFG_REWARD_COWGAMEGOLD=1, --ÿ����1ע
		
    }    
end

--gm��ָ���ĺ�
gold_cow_lib.gm_open_num=function(num)
	gold_cow_lib.gm_num=num
end

gold_cow_lib.is_valid_room=function()
	if(gamepkg.name == "tex" and gold_cow_lib.tex_game_room ~= tonumber(groupinfo.groupid))then
		return 0
	end
	if(gamepkg.name ~= "tex" and gold_cow_lib.qp_game_room ~= tonumber(groupinfo.groupid))then
		return 0
	end
	return 1
end

--��Ϸ�����¼�����
gold_cow_lib.on_game_over = function(gameeventdata)
    if gold_cow_lib.check_datetime() == 0 then return end
    if gameeventdata == nil then return end
    --��Ϸ�¼���֤
    if gold_cow_lib.cfg_game_name[gamepkg.name] == nil then return end
    --���������û�
    for k,v in pairs(gameeventdata.data) do
        --��Ϸ��ʼ�¼� �˳�
        if (gamepkg.name ~= "cow" or gamepkg.name ~= "tlj") and v.single_event == 1 then
            break;
        else
        	--������ĵ�һ��
        	--��ʱ�䣬������Ϊ1
        	if(gold_cow_lib.user_list[v.userid]==nil) then gold_cow_lib.user_list[v.userid]={} end
        	if(gold_cow_lib.user_list[v.userid].lastplay_date ~= os.date("%Y-%m-%d", curr_time))then
        		gold_cow_lib.user_list[v.userid].lastplay_date = os.date("%Y-%m-%d", curr_time)
        		if(gold_cow_lib.user_list[v.userid].cowgamegold_rewardcount==0 and gold_cow_lib.user_list[v.userid].play_count>=15)then
        			gold_cow_lib.user_list[v.userid].play_count=1
        		else
        			gold_cow_lib.user_list[v.userid].play_count=gold_cow_lib.user_list[v.userid].play_count+1;
        		end
        	else
        		gold_cow_lib.user_list[v.userid].play_count=gold_cow_lib.user_list[v.userid].play_count+1;
        		--�򿪵�15��ʱ����һ����Ʊ
        		if(gold_cow_lib.user_list[v.userid].play_count==15)then
        			gold_cow_lib.user_list[v.userid].cowgamegold_rewardcount=1
        			gold_cow_db_lib.record_cowgamegold_rewardcount(v.userid,gold_cow_lib.user_list[v.userid].cowgamegold_rewardcount)
        		end
        	end
        	--todo db��¼
    		gold_cow_db_lib.record_user_cowgold_info(v.userid,gold_cow_lib.user_list[v.userid].play_count)
    		send_is_finish(v.userid)
        end
    end
end

--���ý�ţ��Ϸ��ʼֵ
function gold_cow_lib.set_user_cowgold_info(user_cowgold_info)
	local user_id=user_cowgold_info.user_id
	if(gold_cow_lib.user_list[user_id]==nil)then gold_cow_lib.user_list[user_id]={} end
	gold_cow_lib.user_list[user_id].user_id=user_id
	gold_cow_lib.user_list[user_id].play_count=user_cowgold_info.play_count
	gold_cow_lib.user_list[user_id].lastplay_date=user_cowgold_info.lastplay_date
	gold_cow_lib.user_list[user_id].cowgamegold_count=user_cowgold_info.cowgamegold_count
	gold_cow_lib.user_list[user_id].cowgamegold_rewardcount=user_cowgold_info.cowgamegold_rewardcount
	gold_cow_lib.user_list[user_id].bet_info=user_cowgold_info.bet_info
	local tmp_tab=split(gold_cow_lib.user_list[user_id].bet_info,",")
	local tmp_bet_num_count=0
	for i=1,6 do
		tmp_bet=tonumber(tmp_tab[i])
		tmp_bet_num_count=tmp_bet_num_count+tmp_bet
	end
	gold_cow_lib.user_list[user_id].bet_num_count=tmp_bet_num_count	
	
	--ȡ��IP��port���������Է��㲻��user_info��������Ϣ
	local user_info=usermgr.GetUserById(user_id)
	gold_cow_lib.user_list[user_id].ip=user_info.ip
	gold_cow_lib.user_list[user_id].port=user_info.port
	gold_cow_lib.user_list[user_id].nick=string.trans_str(user_info.nick) or ""
	
	
end

--����Ƿ�����Чʱ����
gold_cow_lib.on_recv_check_status = function(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	local user_id=user_info.userId;
   	
   	local cow_status=0
   	--�Ȳ�ʱ�䣬�ǲ��ǻʱ��
   	local time_status=gold_cow_lib.check_datetime()
   	cow_status=time_status
   	--�ٲ��ǲ�������������ǲ��Ǳ������״̬��
   	netlib.send(function(buf)
            buf:writeString("CTCOWACTIVE");
            buf:writeInt(time_status or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
        end,user_info.ip,user_info.port);
	send_is_finish(user_id)
end

function send_is_finish(user_id)

   	local user_info=usermgr.GetUserById(user_id)
   	if(user_info==nil)then return end
 
   	
   	local function send_finish_result(user_info)
   		local is_finish_task=0
   		local user_id=user_info.userId
   		if(gold_cow_lib.user_list[user_id].play_count>=gold_cow_lib.CFG_CAN_PLAY)then
	   		is_finish_task=1
	   	end
   		netlib.send(function(buf)
	        buf:writeString("CTCOWTASK");
	        buf:writeByte(is_finish_task or 1);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
	        buf:writeInt(gold_cow_lib.user_list[user_id].play_count or 0);		--int	�������
        end,user_info.ip,user_info.port);
   	end
   	
   	if(gold_cow_lib.user_list[user_id]==nil or gold_cow_lib.user_list[user_id].play_count==nil)then
   		gold_cow_db_lib.init_user_safebox_gold(user_id,send_finish_result)
   	else
   		send_finish_result(user_info)
   	end
   	
   	
   
   	


end

--�û���½���ʼ������
gold_cow_lib.on_after_user_login = function(e)
	local user_info = e.data.userinfo
	local sql=""
	if(user_info == nil)then 
		TraceError("�û���½���ʼ������,if(user_info == nil)then")
	 	return
	end

end

--�����Чʱ�䣬��ʱ����int	0�����Ч�������Ҳ�ɲ�������1�����Ч
function gold_cow_lib.check_datetime()
	local sys_time = os.time();	
	local statime = timelib.db_to_lua_time(gold_cow_lib.startime);
	local endtime = timelib.db_to_lua_time(gold_cow_lib.endtime);
			
	if(sys_time > statime and sys_time <= endtime) then
		return 1;
	end
 
	--�ʱ���ȥ��
	return 0;

end


--������ҵ�Ͷע��Ϣ
function gold_cow_lib.update_bet_info(userId,area_id,cowgamegold_bet)
	
	--�����ַ����ж�Ӧλ�õ�ֵ
	local update_bet=function(bet_info,area_id,cowgamegold_bet)
		if(bet_info==nil or bet_info=="")then
			bet_info=gold_cow_lib.org_bet_info;	
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
		
		--������ע�����
		local tmp_bet_info=string.sub(tmp_str,2)
		local user_info=usermgr.GetUserById(userId)
		local sql="update user_goldcow_info set bet_info='%s',bet_id='%s' where user_id=%d;commit; "
		sql=string.format(sql,tmp_bet_info,gold_cow_lib.bet_id,userId)

		dblib.execute(sql)
		return tmp_bet_info --ȥ����1�����ź󷵻�
	end
	
	--������ҵ�Ͷע��Ϣ
	local tmpstr=""
	
	for k,v in pairs (gold_cow_lib.user_list) do
		if(v~=nil and v.user_id==userId)then

			v.bet_info=update_bet(v.bet_info,area_id,cowgamegold_bet)
			tmpstr=v.bet_info
		end
	end
	return tmpstr
end

--���õ�Ǯ�����仯
function gold_cow_lib.send_gold_change(user_info)
	netlib.send(function(buf)
            buf:writeString("CTCOWMONEY");
            buf:writeInt(user_info.cowgamegold_count*10000);		--��ע�����0����עʧ�ܣ� 1����ע�ɹ��� 2�����Ч��
        end,user_info.ip,user_info.port);
end

--������ע
function gold_cow_lib.on_recv_xiazhu(buf)

	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
	
	if (gold_cow_lib.is_valid_room()~=1) then return end
	
   	local user_id=user_info.userId
   	--��ע����
   	local area_id = buf:readInt();--����id
   	local cowgamegold_bet = buf:readInt();--�������µĽ�ţ��Ϸ������
   	
   	--���ؿͻ�����ע���
   	local send_bet_result=function(user_info,result)
   		netlib.send(function(buf)
	            buf:writeString("CTCOWBET");
	            buf:writeInt(result);		--��ע�����0����עʧ�ܣ� 1����ע�ɹ��� 2�����Ч��
	        end,user_info.ip,user_info.port);
   	end
   	
   	
   	
   	--���ֽ���ǰ10�벻���������ע
 	if(gold_cow_lib.fajiang_time-os.time()<gold_cow_lib.CFG_CANT_BETTIME ) then
		send_bet_result(user_info,3)
   		return
	end
	
	--����������ע����
 	if(cowgamegold_bet>gold_cow_lib.limit_local_bet) then
 		send_bet_result(user_info,4)
   		return
 	end
 	
 	--���˵�����ע
 	if(gold_cow_lib.user_list[user_id].bet_num_count==nil)then
 		user_info.bet_num_count = 0
 	end
 	
 	--����ע��������������
 	local tmp_limit=gold_cow_lib.limit_bet
 	if (gamepkg.name == "tex") then
 		tmp_limit=gold_cow_lib.tex_limit_bet
 	end
   	if(gold_cow_lib.user_list[user_id].bet_num_count>tmp_limit-cowgamegold_bet)then
   	 	send_bet_result(user_info,5)
   		return
   	end
   	
   	--�жϽ�ţ��Ϸ��
   	--û����ѵ�Ǯ��Ҫ�����ϵ�Ǯ������
   	local tmp_rate=10000/gold_cow_lib.CFG_BET_RATE
   	if(gold_cow_lib.user_list[user_id].cowgamegold_rewardcount<=0)then
   	   	if(gold_cow_lib.user_list[user_id].cowgamegold_count == nil or gold_cow_lib.user_list[user_id].cowgamegold_count == 0 or gold_cow_lib.user_list[user_id].cowgamegold_count <cowgamegold_bet/tmp_rate)then
	   		send_bet_result(user_info,2)
	   		return
	   	end
   	end
    
    local after_add_cowgamegold=function(result)
	    if(result~=-1)then
			--�۳��ˣ��͸�����ע���ֶΣ�֪ͨ�ͻ�����ע�ɹ�
			gold_cow_lib.user_list[user_id].cowgamegold_count=result --ˢ��һ�������ж���Ǯ������ע
		   	gold_cow_lib.user_list[user_id].bet_num_count = gold_cow_lib.user_list[user_id].bet_num_count + cowgamegold_bet
	  		gold_cow_lib.user_list[user_id].bet_info=gold_cow_lib.update_bet_info(user_info.userId,area_id,cowgamegold_bet)
			gold_cow_lib.user_list[user_id].bet_id=gold_cow_lib.bet_id
			send_bet_result(user_info,1)
			
			--��ע�ɹ���Ҫ֪ͨ�ͻ����µ�Ǯ���ж���
			gold_cow_lib.send_gold_change(gold_cow_lib.user_list[user_id])
			
			--��ע�ɹ���Ҫ�޸�һ���ڴ���ı��������Ǯ�����ݿ����Ǯ���øģ���Ϊ�洢������Ĺ���
			gold_cow_lib.change_safebox_gold(user_id,gold_cow_lib.user_list[user_id].cowgamegold_count)
			
			--������ע��Ϣ��������ע��Ϣ
			gold_cow_lib.all_bet_count=gold_cow_lib.all_bet_count+cowgamegold_bet
			gold_cow_lib.bet_count[area_id]=gold_cow_lib.bet_count[area_id]+cowgamegold_bet
			
			--�����µ�����(���ö�̬���������ˣ�
			--gold_cow_lib.update_pl()
			
			--�Ĳʳ�
			gold_cow_lib.add_caichi(user_info,cowgamegold_bet)
			
			--д��־
			--���˱���־
			gold_cow_db_lib.log_user_goldcow(user_id,result,cowgamegold_bet,1,gold_cow_lib.user_list[user_id].bet_info)
		else
			send_bet_result(user_info,2)
		end	
	
    end
   	--��������ϵĽ�ţ��Ϸ�ң�����ɹ��ͷ��ؿͻ��˳ɹ�����Ȼ��֪ͨ˵ʧ��
   	gold_cow_lib.add_cowgamegold(user_info.userId,-cowgamegold_bet/tmp_rate,after_add_cowgamegold)
end

--�޸ı��������ڴ����ֵ
--���ﱾ��Ҫ���ñ�����ӿڣ�����Ϊ����ǻ���ϼ����Ҫ���ߣ�����ֱ���޸���
function gold_cow_lib.change_safebox_gold(user_id,new_safebox_gold)
	local user_info=usermgr.GetUserById(user_id)
	if (gamepkg.name == "tex") then
		user_info.safegold=new_safebox_gold
		net_send_user_getsetgold_case(user_info,1,new_safebox_gold)
	else
		user_info.safebox.safegold=new_safebox_gold
	end
end

--�Ӽ�ţţ��Ϸ��
function gold_cow_lib.add_cowgamegold(user_id,add_cowgamegold,call_back)
	
	if (gold_cow_lib.is_valid_room()~=1) then return end
	
	--�ȿ�ÿ����ѵ�ע
	local before_cowgamegold=gold_cow_lib.user_list[user_id].cowgamegold_count
	local goldtype=1
	local free_reward_count=gold_cow_lib.user_list[user_id].cowgamegold_rewardcount or 0
	local sql=""

	--����������ѵ�ע
	if(add_cowgamegold<0 and free_reward_count>0)then
		--��ѵ�ֻ����1ע
		
   		gold_cow_lib.user_list[user_id].cowgamegold_rewardcount=0
   		sql="update user_goldcow_info set cowgamegold_rewardcount=0 where user_id=%d;select row_count() as rowcount;"
   		sql=string.format(sql,user_id)

   		dblib.execute(sql,function(dt)
			if(dt and #dt>0)then			
				if(dt[1]["rowcount"] > 0 and call_back~=nil)then
					call_back(gold_cow_lib.user_list[user_id].cowgamegold_count)
				end
			end
		end,user_id)	

		return
   	end

	--��ѵ�Ǯ�����ˣ�ץ��ţ�õ��Ǳ����䣬��������ֱ�ӼӼ��������Ǯ�����ˡ�
	--�����ͬʱ��user_goldcow_info��Ǯ��ͳһ�������Ǯ�����ܱ�֤2��������һ�µ�
	--���ݵı���������Ҫע�⿴һ��
	local bet_info=gold_cow_lib.user_list[user_id].bet_info or ""
	if(add_cowgamegold<0)then
		gold_cow_lib.user_list[user_id].cowgamegold_count=gold_cow_lib.user_list[user_id].cowgamegold_count+add_cowgamegold
		sql="call sp_direct_safebox(%d,%d);"
		sql=string.format(sql,user_id,add_cowgamegold)
		dblib.execute(sql,function(dt)
			if(dt and #dt>0)then
				local result=dt[1].result;--result�ǵ��Ǳ仯���ֵ
				
				if(call_back~=nil)then
					--��Ǯ��־���ڻص���д����Ϊ��Ҫ֪����ʱ��Ͷע���
					call_back(result)					
				end				
			end
		end,user_id)	
	end
	

	if(add_cowgamegold>0)then
		 usermgr.addgold(user_id, add_cowgamegold*gold_cow_lib.CFG_BET_RATE, 0, new_gold_type.JIONGREN, -1);
		 goldtype=2
		--���˱���־,��Ǯֱ��д��־
		gold_cow_db_lib.log_user_goldcow(user_id,before_cowgamegold,add_cowgamegold/10,goldtype,bet_info)
	end
end


--�������6������(6���ƣ�
function gold_cow_lib.get_card_num()
	--��ʱ����Ϊ���������
	local t = os.time() 
	math.randomseed(t)
	
	--Ĭ����1��1��������ȡ54������
	local poke_box_count=#gold_cow_lib.poke_box	
	gold_cow_lib.num1=gold_cow_lib.get_one_poke(math.random(1,10000)%poke_box_count+1)
	poke_box_count=#gold_cow_lib.poke_box	
	gold_cow_lib.num2=gold_cow_lib.get_one_poke(math.random(1,10000)%poke_box_count+1)
	poke_box_count=#gold_cow_lib.poke_box	
	gold_cow_lib.num3=gold_cow_lib.get_one_poke(math.random(1,10000)%poke_box_count+1)
	poke_box_count=#gold_cow_lib.poke_box	
	gold_cow_lib.num4=gold_cow_lib.get_one_poke(math.random(1,10000)%poke_box_count+1)
	poke_box_count=#gold_cow_lib.poke_box	
	gold_cow_lib.num5=gold_cow_lib.get_one_poke(math.random(1,10000)%poke_box_count+1)
	poke_box_count=#gold_cow_lib.poke_box	
	gold_cow_lib.num6=gold_cow_lib.get_one_poke(math.random(1,10000)%poke_box_count+1)
end

function gold_cow_lib.init_poke_box()
	gold_cow_lib.poke_box={}
	for i=1,54 do
		gold_cow_lib.poke_box[i]=i
	end	
end

function gold_cow_lib.get_one_poke(poke_index)
	local tmp_poke=gold_cow_lib.poke_box[poke_index]
	table.remove(gold_cow_lib.poke_box,poke_index)
	return tmp_poke
end

--�������1�����֣���ţ����λ�ã�
function gold_cow_lib.get_random_num(num_1)
	--��ʱ����Ϊ���������
	local t = os.time() 
	math.randomseed(t)
	
	--Ĭ����1��1��������ȡ54������
	--����1��100�������
	local tmp_num1=math.random(1,10000)%100+1
	local tmp_nouse_num=0
	
	local rand_type=math.random(1,t)%6+1 --��4��������㷨���Ժ��ټ�
	
	if(rand_type==1)then  --ȡ1��32000���������ȡ��
		tmp_num1=math.random(20000,30000)%100+1
	elseif(rand_type==2)then
		tmp_nouse_num=math.random(1,10000)
		tmp_nouse_num=math.random(1,20000)
		tmp_num1=math.random(1,t)%100+1
	elseif(rand_type==3)then
		tmp_nouse_num=math.random(1,10000)
		tmp_nouse_num=math.random(1,10000)
		tmp_num1=(math.random(1,t)+math.random(1,t))%100+1
	elseif(rand_type==4)then
		tmp_nouse_num=math.random(1,t)
		tmp_nouse_num=math.random(1,10000)
		tmp_num1=(math.random(1,10000)+math.random(1,t))%100+1		
	elseif(rand_type==5)then
		tmp_nouse_num=math.random(1,10000)
		tmp_nouse_num=math.random(1,10000)
		tmp_num1=math.random(1,20000)%100+1		
	elseif(rand_type==6)then
		tmp_nouse_num=math.random(1,10000)
		tmp_nouse_num=math.random(1,3000)
		tmp_nouse_num=math.random(1,2000)
		tmp_num1=math.random(1,30000)%100+1	
	end	
	
	
	-- �������Σ�7%  14%  29%  29%  14%  7%
	if(tmp_num1>0 and tmp_num1<=7) then
		tmp_num1=1
	elseif(tmp_num1>=8 and tmp_num1<=21) then
		tmp_num1=2
	elseif(tmp_num1>=22 and tmp_num1<=50) then
		tmp_num1=3
	elseif(tmp_num1>=51 and tmp_num1<=79) then
		tmp_num1=4	
	elseif(tmp_num1>=80 and tmp_num1<=93) then
		tmp_num1=5		
	elseif(tmp_num1>=94 and tmp_num1<=100) then
		tmp_num1=6
	end

	--�����ָ��ֵ������ָ��ֵ����������������ɵ�ֵ������Ϊ�˸�GMԤ���ӿ�
	if(num_1==nil)then		
		num_1 = tmp_num1		
	end
	
	return num_1
end

--������û���н������˶���Ǯ
function gold_cow_lib.calc_win_cowgamegold(bet_info,open_num)
	if(bet_info==nil) then return 0,0 end
	if(open_num==nil) then return 0,0 end
	local tmp_bet_info=split(bet_info,",")
    local win_gold=0
    local get_gold=0
    --׬����Ʊ=��Ӧ����*Ͷע����Ʊ    
	win_gold=tonumber(tmp_bet_info[open_num])*gold_cow_lib.bet_peilv[open_num]
	get_gold=tmp_bet_info[open_num]+win_gold
	return win_gold,get_gold
end

--����
--ÿ10���ӽ���һ�Σ�Ҫ���������£�
--1. �����ֵ���Ա����
--2. ��ʼ���µ�һ���õ��ı���
--3. д������־
function gold_cow_lib.start_game()
	if (gold_cow_lib.is_valid_room()~=1) then return end
	
	local sql="";
	local zj_count=0; --�м�������н���
	local all_zj_info={}; --���еı����н���Ϣ
	
	local tmp_user_info; --Ϊ�˸��ͻ��˷���ҵ��ǳƣ����������������

	local function fajiang()
		local win_cowgamegold=0 --׬���Ľ�ţ��Ϸ��
		local get_cowgamegold=0 --һ��Ӧ���еĽ�ţ��Ϸ��
		local gain_most_info={} --��һ��׬������10����
		for k,v in pairs (gold_cow_lib.user_list) do
			local buf_zj_info={};
			
			--��ÿ���н����˷���
			win_cowgamegold,get_cowgamegold=gold_cow_lib.calc_win_cowgamegold(v.bet_info,gold_cow_lib.zhongjiang_num)
			gold_cow_lib.user_list[v.user_id].win_cowgamegold=win_cowgamegold
			gold_cow_lib.user_list[v.user_id].get_cowgamegold=get_cowgamegold
			--�õ��м������н�����Щ��׬�˶���Ǯ����Ϣ
			if(win_cowgamegold>0)then					
			    gold_cow_lib.add_cowgamegold(v.user_id, win_cowgamegold);
				zj_count=zj_count+1
				tmp_user_info=usermgr.GetUserById(v.user_id) --Ϊ�˸��ͻ��˷���ҵ��ǳƣ����������������
				
				if(tmp_user_info~=nil)then
					netlib.send(function(buf)
			            buf:writeString("DVDMYWIN"); --֪ͨ�ͻ��ˣ���ҵ��н���¼
			            buf:writeInt(win_cowgamegold); --�н����������		           
			            end,tmp_user_info.ip,tmp_user_info.port)
			            
			           
		        end
		        
				buf_zj_info.user_id=v.user_id
				buf_zj_info.nick=v.nick
				buf_zj_info.win_cowgamegold=win_cowgamegold
				table.insert(all_zj_info,buf_zj_info)
			end
		end
	
		--֪ͨ�ͻ��ˣ���ҵ��н���¼
		--����win_cowgamegold����
		if(all_zj_info~=nil and #all_zj_info>2)then
			table.sort(all_zj_info, 
			      function(a, b)
				     return a.win_cowgamegold > b.win_cowgamegold		                   
			end)
		end
		--����һ���ܹ���Ӯ���˶���Ǯ
		local all_win_gold=0
		for k,v in pairs (all_zj_info) do
			all_win_gold=all_win_gold+v.win_cowgamegold
		end
		
		--����Ϸ����˷�ǰ10���ļ�¼
		for k,v in pairs (gold_cow_lib.user_list) do
			local user_info=usermgr.GetUserById(v.user_id)
			if(user_info~=nil)then				
				netlib.send(function(buf)
		            buf:writeString("CTCOWUSERS"); --֪ͨ�ͻ��ˣ���ҵ��н���¼		           
		            local mc_len=10 --�����ʾǰ10��
		            local send_len=#all_zj_info or 0
		            if(send_len>mc_len)then send_len=mc_len end
		            buf:writeInt(send_len); --�н����������
		            if(send_len>0)then
			            for i=1,send_len do
			            	buf:writeInt(all_zj_info[i].user_id) --���ID
			            	buf:writeString(all_zj_info[i].nick or "")   --����ǳ�
			            	buf:writeInt(all_zj_info[i].win_cowgamegold*gold_cow_lib.CFG_BET_RATE or 0) --����н��Ľ�ţ��Ϸ������
			            end
		            end
		            end,user_info.ip,user_info.port) 
			end
		end
		
		--����ʳش���0����Ҫ����ҷֲʳ����Ǯ(��ʱ�������ˣ�
		--local reward_caichi=0
		--if(gold_cow_lib.caichi>0)then
		--	for k,v in pairs (all_zj_info) do
		--		reward_caichi=(gold_cow_lib.caichi/1000)*(v.win_cowgamegold/all_win_gold)
		--		--�ӽ�ţ��Ϸ��
		--	   	gold_cow_lib.add_cowgamegold(v.userId,reward_caichi)
		--	end
		--end
		
	end
	
 	--��ʼ��һ�ֵ���Ϣ
 	local function init_game_info()
 		local curr_time=os.time()
		--��ʼ��������ʱ��		
	 	gold_cow_lib.fajiang_time=curr_time+60*5
 	    
 	    --��ʼ�����ֵ�ͶעID��������ʱ��Ϊ��͵��ֶ���ΪͶעID
	 	gold_cow_lib.bet_id = os.date("%Y%m%d%H%M", curr_time)	 	
	 	
	 	--��ʼ����һ��Ͷע����
	 	for k,v in pairs(gold_cow_lib.user_list) do
	 		v.bet_info=gold_cow_lib.org_bet_info
			v.bet_num_count=0
			v.win_cowgamegold=0	
			v.get_cowgamegold=0		
	 	end
	 	
	 	--��ʼ���ʳ�
	 	gold_cow_lib.caichi=0
	 	gold_cow_lib.send_caichi()
	 	
	 	--��ʼ���ƺ�
	 	gold_cow_lib.init_poke_box()
	 	
	
	 	
	 	--�������µ�bet_id�����������ֹ����������ʱҪ��Ǯ
	 	gold_cow_lib.update_last_betid(gold_cow_lib.bet_id)
	 	
	 	gold_cow_lib.all_user_bet_info={}
	 	gold_cow_lib.all_bet_count=0
	 	gold_cow_lib.bet_count={
			[1]=0,          
			[2]=0,        
			[3]=0,         
			[4]=0,         
			[5]=0,           
			[6]=0,           
		}
 	end
 	
 	--�����н��ĺ���
 	local function set_zj_num()
 		if(gold_cow_lib.zhongjiang_num==1)then
 			gold_cow_lib.num1=55 			
 		elseif(gold_cow_lib.zhongjiang_num==2)then
 			gold_cow_lib.num2=55
 		elseif(gold_cow_lib.zhongjiang_num==3)then
 			gold_cow_lib.num3=55	
 		elseif(gold_cow_lib.zhongjiang_num==4)then
 			gold_cow_lib.num4=55
 		elseif(gold_cow_lib.zhongjiang_num==5)then
 			gold_cow_lib.num5=55
 		elseif(gold_cow_lib.zhongjiang_num==6)then
 			gold_cow_lib.num6=55
 		end
 	end
 	
 	--���gmָ���˺ţ��Ϳ�ָ���ĺţ��������֮��Ҫ��ֵ����������ֹһֱ��һ����
 	if(gold_cow_lib.gm_num~=nil and gold_cow_lib.gm_num~=0)then
 		gold_cow_lib.zhongjiang_num= gold_cow_lib.get_random_num(gold_cow_lib.gm_num)
 		gold_cow_lib.gm_num=0
	else
 		gold_cow_lib.zhongjiang_num = gold_cow_lib.get_random_num()	--��ȡ�����
 	end
 	
 	--����6�ŵ���
 	if(#gold_cow_lib.poke_box==0)then
 		gold_cow_lib.init_poke_box()
 	end
 	gold_cow_lib.get_card_num()
 	
 	--�����н��ĺ�Ϊ55����ţ
 	set_zj_num()

	--������ʷ����
	if(#gold_cow_lib.history < gold_cow_lib.history_len)then		--�������С��6��ֱ�Ӽ���
		local bufftable ={
	  	    zhongjiang_num = gold_cow_lib.zhongjiang_num
        }	                
		table.insert(gold_cow_lib.history,bufftable)
	else
		table.remove(gold_cow_lib.history,1)	--ɾ����һ��		
		local bufftable ={
			zhongjiang_num = gold_cow_lib.zhongjiang_num, 
		}	                
		table.insert(gold_cow_lib.history,bufftable)
	end
	
	
	--д��ʷ������־
	gold_cow_db_lib.log_goldcow_history(gold_cow_lib.zhongjiang_num,gold_cow_lib.bet_id)
 	
 	--���н����˷���
 	fajiang();
 	
 	--������������
 	local tmp_flag=0
 	for k1,v1 in pairs (gold_cow_lib.user_list) do
		local user_info=usermgr.GetUserById(v1.user_id)
		if (user_info~=nil)then				
		 	netlib.send(function(buf)
 				buf:writeString("CTCOWKAI")
            	buf:writeInt(gold_cow_lib.num1)
            	buf:writeInt(gold_cow_lib.num2)
            	buf:writeInt(gold_cow_lib.num3)
            	buf:writeInt(gold_cow_lib.num4)
            	buf:writeInt(gold_cow_lib.num5)
            	buf:writeInt(gold_cow_lib.num6)
            	buf:writeInt(v1.win_cowgamegold*gold_cow_lib.CFG_BET_RATE or 0)
		 	 end,user_info.ip,user_info.port) 
		 	 
		end --end if
	 end -- end for
 	
 	--��ʼ����һ�ֵ���Ϣ
 	init_game_info(); 	
end

--����ʱ
function gold_cow_lib.timer()
	math.random();
  	
  	if (gold_cow_lib.is_valid_room()~=1) then return end
  	
  	--10���ӿ�һ��
  	if(os.time() > gold_cow_lib.fajiang_time-3)then	 
     	--����(�и�ȱ�ݣ��տ��ֻ����һ��û���й�������
     	gold_cow_lib.start_game()
    end
    
    if(os.time() > gold_cow_lib.other_bet_time)then	 
     	--����(�и�ȱ�ݣ��տ��ֻ����һ��û���й�������
     	gold_cow_lib.send_other_bet_info()
    end    
end

--������������
function gold_cow_lib.restart_server(e)
	if (gold_cow_lib.is_valid_room()~=1) then return end
	
	local param_str_value = "-1"
	local function return_cowgamegold(user_id,bet_info)
		if(user_id==-1 or bet_info=="-1")then return end
		local yin_piao=0;
		local tmp_bet_info={}
		tmp_bet_info=split(bet_info,",")   			
		for i=1,6 do
			yin_piao=yin_piao+tmp_bet_info[i]
		end
		yin_piao=yin_piao/(10000/gold_cow_lib.CFG_BET_RATE)
		--�ȷ�����ţ��Ϸ�ң��ٻ�������
		local sql="update user_goldcow_info set cowgamegold_count=cowgamegold_count+%d,bet_info='%s' where user_id=%d and bet_info<>'%s';commit;"
		sql=string.format(sql,yin_piao,gold_cow_lib.org_bet_info,user_id,gold_cow_lib.org_bet_info)
		dblib.execute(sql,function(dt)
				--�������������Ǯ
				sql="UPDATE user_safebox_info SET safe_gold=safe_gold+%d WHERE user_id = %d;"
				sql=string.format(sql,yin_piao,user_id)
				dblib.execute(sql)
		end)
	
	end
	
	local sql = "SELECT param_str_value FROM cfg_param_info WHERE param_key = 'GOLDCOW_BETID' and room_id=%d"
	sql = string.format(sql,groupinfo.groupid);
	dblib.execute(sql,
    function(dt)
    	if dt and #dt > 0 then
    		param_str_value = dt[1]["param_str_value"]
    	else
    		param_str_value = "-1"
		end
    		--ͨ��param_str_value��betid)������˽�ţ��Ϸ��
    		sql="select user_id,bet_info from user_goldcow_info where bet_id='%s'"
    		sql=string.format(sql,param_str_value)
    		dblib.execute(sql,
			    function(dt)
			    	if dt and #dt > 0 then
			    		for i=1,#dt do
			    			
			    			local user_id=dt[i]["user_id"] or -1
			    			local bet_info=dt[i]["bet_info"] or "-1"
			    			
			    			return_cowgamegold(user_id,bet_info)			    			
			    		end
			    	end
			    end)
	end)
end

--���������һ��betid
function gold_cow_lib.update_last_betid(betid)
	--�������ݿ�
	local sql = "insert into cfg_param_info (param_key,param_str_value,room_id) value('GOLDCOW_BETID','-1',%d) on duplicate key update param_str_value = '%s'";
	sql=string.format(sql, groupinfo.groupid,betid)
	dblib.execute(sql)
end

--�������Ͷע������Ϣ
function gold_cow_lib.send_other_bet_info()
	local tmp_user_bet_info1={} --����ͳ��Ͷע��������ʱ����
	local tmp_user_bet_info2={} --��������������Ͷע��������ʱ����
	local tmp_bet_info=""
	local tmp_str=""
	local tmp_bet_num=gold_cow_lib.org_bet_info
	tmp_user_bet_info2=split(tmp_bet_num,",")
	--�õ������˵�Ͷע��Ϣ�ŵ�tmp_user_bet_info2��
	for k,v in pairs (gold_cow_lib.user_list) do
   			tmp_bet_info=v.bet_info
   			if(tmp_bet_info==nil or tmp_bet_info=="")then
   				tmp_bet_info=gold_cow_lib.org_bet_info
   			end
   			tmp_user_bet_info1=split(tmp_bet_info,",")   			
   			for i=1,6 do	   					
   				tmp_user_bet_info2[i]=tmp_user_bet_info2[i]+tmp_user_bet_info1[i]
   			end
	end
	
	gold_cow_lib.all_user_bet_info=tmp_user_bet_info2
	
	--֪ͨ�ͻ��ˣ��������Ͷע����������˼�ȥ�Լ���
	for k,v in pairs (gold_cow_lib.user_list) do
		local user_info=usermgr.GetUserById(v.user_id)
		if(user_info~=nil)then
			tmp_user_bet_info1=split(v.bet_info or gold_cow_lib.org_bet_info,",")
			netlib.send(function(buf)
		    	buf:writeString("CTCOWALLBET")
		    	buf:writeInt(6)    	
		    	for i=1,6 do
		    		buf:writeInt(i)
		    		--buf:writeInt(tmp_user_bet_info2[i]-tmp_user_bet_info1[i])
		    		buf:writeInt(tmp_user_bet_info2[i])
		    		buf:writeInt(gold_cow_lib.bet_peilv[i])		    		    		
		    	end
		    	end,user_info.ip,user_info.port)
	    end
     end
     
     --10��֮������ٽ���һ��
     gold_cow_lib.other_bet_time=os.time()+10
end

--�����ͻ��˲ʳ���Ϣ
function gold_cow_lib.send_caichi()
	for k,v in pairs(gold_cow_lib.user_list) do
		local user_info=usermgr.GetUserById(v.user_id)
		if(user_info~=nil)then
			netlib.send(function(buf)
	    		buf:writeString("CTCOWCAICHI")
	    		buf:writeInt(gold_cow_lib.caichi or 0) 
	    		end,user_info.ip,user_info.port)
		end
    end
end

--��Ͷע�������ʳؼ�Ǯ
function gold_cow_lib.add_caichi(user_info,bet_count)
	gold_cow_lib.caichi=gold_cow_lib.caichi+bet_count*1000
	gold_cow_lib.send_caichi()
end

--������ʷ��
function gold_cow_lib.send_history(user_info,history_list)
	local send_len = 0
	if(history_list~=nil)then
	   send_len=#history_list
	end
	netlib.send(function(buf)
    	buf:writeString("CTCOWREC")
    	    
		 buf:writeInt(send_len)
			if(send_len < gold_cow_lib.history_len)then
				for i=1,send_len do
			        buf:writeInt(history_list[i].zhongjiang_num) 
		        end
			else
		        for i=1,gold_cow_lib.history_len do
			        buf:writeInt(history_list[i].zhongjiang_num)	 
		        end
		    end
     	end,user_info.ip,user_info.port) 
end

--����=����������ע/��ǰ������ע����ȡ��
function gold_cow_lib.update_pl()
	for i=1,6 do
		bet_peilv[i]=gold_cow_lib.all_bet_count/gold_cow_lib.bet_count[i]
	end
end

--������Ϸ
--֪ͨ�ͻ��ˣ����������Ϣ
--	a. ��Ϣ����DVDOPEN
--	b. ������
--		1) int		��ţ��Ϸ������
--		2) int		��Ͷע�������
--		for ��Ͷע�������
--			1) int	����id
--			2) int	 ������� Ͷע�Ľ�ţ��Ϸ������
--			3) int  ����Լ� Ͷע�Ľ�ţ��Ϸ������
--���ͻ��˷�����ʱ�仹�������
--���ͻ��˷�������ʷ
function gold_cow_lib.on_recv_open_game(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	local user_id=user_info.userId
   	--֪ͨ�ͻ��ˣ������Ϣ
   	local send_dvd_info = function(cow_user_info)
   		local bet_info=cow_user_info.bet_info
   		local tmp_user_bet_info=split(bet_info,",")
   		local is_finish_task=0
   		if(gold_cow_lib.user_list[user_id].play_count>=gold_cow_lib.CFG_CAN_PLAY)then
	   		is_finish_task=1
	   	end
	   	local user_info=usermgr.GetUserById(cow_user_info.user_id)
	   	--todo
	   	--ͬ���������Ǯ
   		netlib.send(function(buf)
            buf:writeString("CTCOWOPEN") --֪ͨ�ͻ��ˣ�������ҽ�ţ��Ϸ����
            buf:writeByte(is_finish_task)            
            buf:writeInt(gold_cow_lib.user_list[user_id].cowgamegold_count*10000 or 0); --��ҽ�ţ��Ϸ����
            buf:writeInt(gold_cow_lib.user_list[user_id].cowgamegold_rewardcount or 0)
            buf:writeInt(6); --Ĭ��Ϊ6�����򶼴��ؿͻ��ˡ���Ϊ�����������������򶼿�������Ͷ
			for i=1,6 do
				buf:writeInt(i) --����id
				local tmpnum=0
				if(gold_cow_lib.all_user_bet_info~=nil and #gold_cow_lib.all_user_bet_info~=0)then
					tmpnum=gold_cow_lib.all_user_bet_info[i]
				end
				buf:writeInt(tmpnum) --������� Ͷע�Ľ�ţ��Ϸ������
				buf:writeInt(tmp_user_bet_info[i]) --����Լ� Ͷע�Ľ�ţ��Ϸ������
				buf:writeInt(gold_cow_lib.bet_peilv[i]) --������������
				
			end            
            end,user_info.ip,user_info.port) 
   	end
   	
   	local function send_client_info(user_info)
   	   	--���ͻ��˷�����ʱ�仹�������
	   	gold_cow_lib.send_remain_time(user_info,gold_cow_lib.fajiang_time)
	   	
	   	--���ͻ��˷�������ʷ
	   	gold_cow_lib.send_history(user_info,gold_cow_lib.history)
	   	
	   	--֪ͨ�ͻ��ˣ������Ϣ
	   	send_dvd_info(gold_cow_lib.user_list[user_info.userId])
   	end
   	
   	--������Ϸ��Ϣ
	local already_join_game=0 --�Ƿ��Ѽ�������Ϸ
	
	--����Ѽ������Ϸ���ͳ�ʼ��һ����ҵ���Ϸ��Ϣ
	for k,v in pairs(gold_cow_lib.user_list) do
		if(v.user_id==user_info.userId)then
			already_join_game=1
			break
		end
	end
	
	--�������Ϸ��Ϣ���뵽��¼����
	if(already_join_game==0)then
		--gold_cow_lib.user_list[user_info.userId]={}
		gold_cow_db_lib.init_user_safebox_gold(user_info.userId,send_client_info)	
		return --gold_cow_lib.user_list[user_info.userId].bet_info=gold_cow_lib.org_bet_info
	end
   	
   	send_client_info(user_info)
   	
end

--�������ˣ�ʣ�࿪��ʱ��
function gold_cow_lib.on_recv_query_time(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	gold_cow_lib.send_remain_time(user_info,gold_cow_lib.fajiang_time)
end

--���߿ͻ��˻��������
function gold_cow_lib.send_remain_time(user_info,fajiang_time)
	local curr_time = os.time();
	local remain_time = fajiang_time-curr_time;
	netlib.send(function(buf)
        buf:writeString("CTCOWTIME"); --֪ͨ�ͻ��ˣ�ʣ�࿪��ʱ��
        buf:writeInt(remain_time);		--ʣ�࿪��ʱ��
      
    end,user_info.ip,user_info.port);
end

--�ͻ���ָ����ĳ��������������
function gold_cow_lib.on_recv_gm_num(buf)
	local user_info = userlist[getuserid(buf)];	
   	if not user_info then return end;
   	
   	--�Ƿ�GM
	local function is_gm(user_id)
		if type(user_id) ~= string then
			user_id = tostring(user_id)
		end
		local tmp_gm={}
		if (gamepkg.name == "tex") then
			tmp_gm=gold_cow_lib.tex_gm_id_arr
		else		
			tmp_gm=gold_cow_lib.qp_gm_id_arr
		end
		
		for k, v in pairs(tmp_gm) do
			if v == user_id then
				return true
			end
		end
		return false
	end

   	if(is_gm(user_info.userId)==false)then
   		return
   	end

    local gm_num1=buf:readInt(); --����1

    if(gm_num1==nil)then
    	return
    end

    gold_cow_lib.gm_open_num(gm_num1)
end

--Э������
cmd_goldcow_handler = 
{
	["CTCOWACTIVE"] = gold_cow_lib.on_recv_check_status, --�����Ƿ���Ч
    ["CTCOWBET"] = gold_cow_lib.on_recv_xiazhu, --������ע
    ["CTCOWOPEN"] = gold_cow_lib.on_recv_open_game, --�������ˣ�����������Ϣ
    ["CTCOWTIME"] = gold_cow_lib.on_recv_query_time, --�������ˣ�ʣ�࿪��ʱ��
    ["CTCOWGMNUM"] = gold_cow_lib.on_recv_gm_num, --�������ˣ�GM����
    
}

--���ز���Ļص�
for k, v in pairs(cmd_goldcow_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", gold_cow_lib.on_after_user_login);
eventmgr:addEventListener("timer_second", gold_cow_lib.timer);
eventmgr:addEventListener("game_event", gold_cow_lib.on_game_over);
eventmgr:addEventListener("on_server_start", gold_cow_lib.restart_server);
 