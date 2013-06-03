TraceError("init daxiao_game...")
dofile("games/modules/daxiao/daxiao.adapter.lua") --����ʮ���ӹ���

if (daxiao_lib and daxiao_lib.gm_cmd) then
    eventmgr:removeEventListener("gm_cmd", daxiao_lib.gm_cmd)
end

--if daxiao_lib and daxiao_lib.on_after_user_login then
--	eventmgr:removeEventListener("h2_on_user_login", daxiao_lib.on_after_user_login);
--end

if daxiao_lib and daxiao_lib.timer then
	eventmgr:removeEventListener("timer_second", daxiao_lib.timer);
end

if daxiao_lib and daxiao_lib.restart_server then
	eventmgr:removeEventListener("on_server_start", daxiao_lib.restart_server);
end
if not daxiao_lib then
    daxiao_lib = _S
    {    	   
        on_after_user_login = NULL_FUNC,--��½��������
		check_datetime  = NULL_FUNC,	--�����Чʱ�䣬��ʱ����
		on_recv_query_time = NULL_FUNC, --�ͻ��˼��ʣ��ʱ��
		on_recv_buy_yinpiao = NULL_FUNC,	--���չ�����Ʊ
		on_recv_exchange = NULL_FUNC,	--ȡ����Ʊ/��Ԫ
        on_recv_check_time = NULL_FUNC, --֪ͨ����ˣ�����ʱ��״̬        
        send_remain_time = NULL_FUNC, --���������뿪��
        update_bet_info = NULL_FUNC, --����Ͷע��Ϣ
        on_recv_xiazhu = NULL_FUNC, --�ͻ���֪ͨ��ע
        calc_can_use_gold = NULL_FUNC, --�������õ�Ǯ
        gen_counts = NULL_FUNC,
        create_open_num = NULL_FUNC,
        fajiang = NULL_FUNC,
        --����׬����Ʊ
        calc_win_yinpiao = NULL_FUNC, --����׬����Ʊ
        add_yinpiao = NULL_FUNC, --����ҼӼ���Ʊ
        get_random_num = NULL_FUNC, --�������������
        
        start_game = NULL_FUNC, --��ʼ��Ϸ
        timer = NULL_FUNC, --��ʱ��
        send_other_bet_info = NULL_FUNC, --�������˵�Ͷע��Ϣ
        send_history = NULL_FUNC, --������ʷ��¼
        gm_open_num = NULL_FUNC, --��ָ���ĺ�
        on_recv_gm_num = NULL_FUNC, --�ͻ���֪ͨ��ָ���ĺ�
        is_valid_room = NULL_FUNC,
        gm_cmd = NULL_FUNC,
   		--��Ϸ����:
   		num1 = 0,	--����1
		num2 = 0,	--����2
		num3 = 0,	--����3
		
		gm_num1 = 0, --gm��ָ��������
		gm_num2 = 0, --gm��ָ��������
		gm_num3 = 0, --gm��ָ��������
		fajiang_lock = 0,
		history = {},	--��ʷ����
		history_len = 6,	--��ʷ���ӳ���
 		 		
 		daxiao_game_info = {},		--��������
 		

		total_num = 0,	--������ӽ��
	
		limit_bet = 1000,	--��������ע����  1000
		limit_local_bet = 1000,	--������ע����  1000
		day_count_bet = 10000,	--����ÿ����ע����  10000 ��(ÿʮ���Ӳſ�һ�Σ������ܵ�10000�Σ������������Ӧ����û�õģ�
		
		choushui_info=0.05, --ȡ��Ʊ�Ļ���Ҫ��%5��ˮ

		--��עʱ�� 10����
		startime = "2011-12-30 00:00:00",  --���ʼʱ��
    	endtime = "2019-01-04 00:00:00",  --�����ʱ��
    	tex_open_time = {{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23}}, --{8,9,10},ָ�����ݿ����ʱ��
		qp_open_time = {}, --{8,9,10},ָ�����ƿ����ʱ��
        open_time = {},
        fajiang_time = 0,  --���ַ���ʱ��
		other_bet_time = 0, --���������ע��Ϣ
		bet_id = "-1", --���ֵ�ID
		kajiang_table={}, --�����ı�񣬱��ֿ�����ʲô��
		
		all_user_bet_info={}, --���������ע��Ϣ
		send_huodong_expire = 0,  --�Ƿ��͹������
		--�������ñ�
		bet_peilv = {
			[1]=1,             --��
			[2]=180,           --111
			[3]=180,           --222
			[4]=180,           --333
			[5]=180,           --444
			[6]=180,           --555
			[7]=180,           --666
			[8]=25,           --����һ�ֱ���			
			[9]=1,             --��
			[10]=50,            --��Ϊ4
			[11]=18,            --��Ϊ5
			[12]=14,            --��Ϊ6
			[13]=12,            --��Ϊ7
			[14]=8,            --��Ϊ8
			[15]=6,            --��Ϊ9
			[16]=6,            --��Ϊ10
			[17]=6,            --��Ϊ11
			[18]=6,            --��Ϊ12
			[19]=8,            --��Ϊ13
			[20]=12,            --��Ϊ14
			[21]=14,            --��Ϊ15
			[22]=18,            --��Ϊ16
			[23]=50,            --��Ϊ17
			[24]=1,            --Ѻ�е���
			[25]=2,            --Ѻ��˫��
			[26]=3,            --Ѻ������
		},
		
		qp_game_room = 62022, --�������ĸ����俪��Ϸ
		tex_game_room = 18001, --�������ĸ����俪��Ϸ
		tex_gm_id_arr = {'69464','1073'}, -- {'832791'},
		qp_gm_id_arr = {}, --{'19563389'},
		org_bet_info="0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0",
		--ֹͣ��עʱ�� 10��
        user_list = {},
    }    
end

--gm��ָ���ĺ�
daxiao_lib.gm_open_num=function(num1,num2,num3)
	daxiao_lib.gm_num1=num1
	daxiao_lib.gm_num2=num2
	daxiao_lib.gm_num3=num3	
end

daxiao_lib.is_valid_room=function()
	if(gamepkg.name == "daxiao" and 19001 ~= tonumber(groupinfo.groupid))then
		return 0
	end
	return 1
end

--�������õ�Ǯ
daxiao_lib.calc_can_use_gold=function(userinfo)

    --����ĳ���
    local can_usegold = 0
    if (gamepkg.name == "daxiao") then
	    if(userinfo.chouma==nil or userinfo.chouma == 0)then
	    	can_usegold = userinfo.gamescore
	    else    
	        can_usegold = userinfo.gamescore - userinfo.chouma  --�۳�����ע�ĳ���        
	    end
	else
		if(userinfo.site~=nil)then
			can_usegold = userinfo.gamescore
		end
    end
    return can_usegold
end

--����׬����Ʊ
daxiao_lib.calc_win_yinpiao=function(bet_info,num1,num2,num3)
	--�����ݴ����
	if(bet_info==nil or bet_info=="")then
		bet_info=daxiao_lib.org_bet_info		
	end
	if (bet_info == daxiao_lib.org_bet_info) then
		return 0,0,{}
	end
	local bet_info_tab={}
	local win_yinpiao = 0 --׬������Ʊ
	local get_yinpiao = 0 --���Ӧ�õõ�����Ʊ
	local count_right=0 --Ѻ�еĸ���
	local count_num=num1+num2+num3 --����
	
	local user_zj_info={} --��ҵķ������н���Ϣ
	local split_bet_info = function(bet_info)
		local tmp_tab=split(bet_info, ",")
		return tmp_tab
	end
	
	bet_info_tab = split_bet_info(bet_info)
	
	--׬����Ʊ=��Ӧ����*Ͷע����Ʊ
	--���õ�����Ʊ=��Ӧ����*Ͷע����Ʊ+Ͷע����Ʊ
	--ǰ23���������Ʊ
	local is_baozi=0
	if(num1==num2 and num1==num3)then
		is_baozi=1
	end
	for i=1,23 do
		local zj_buf={} --�����н���Ϣ����������id��׬�˶�����Ʊ
		local tmp_bet_right=0 --�Ƿ�Ѻ�еı�ʶ��
		if(i==1 and count_num>=4 and count_num<=10 and is_baozi==0)then --����Ҫ�����ӳԵ�
			tmp_bet_right=1
		elseif(i==2 and num1==1 and num2==1 and num3==1)then
			tmp_bet_right=1
		elseif(i==3 and num1==2 and num2==2 and num3==2)then
			tmp_bet_right=1
		elseif(i==4 and num1==3 and num2==3 and num3==3)then
			tmp_bet_right=1
		elseif(i==5 and num1==4 and num2==4 and num3==4)then
			tmp_bet_right=1		
		elseif(i==6 and num1==5 and num2==5 and num3==5)then
			tmp_bet_right=1
		elseif(i==7 and num1==6 and num2==6 and num3==6)then
			tmp_bet_right=1
		elseif(i==8 and is_baozi==1)then
		--   tmp_bet_right=1   --�°汾����������Ϊ����baozi�����н�������Ѻ��ָ����baozi
		elseif(i==9 and count_num>=11 and count_num<=17 and is_baozi==0)then --����Ҫ�����ӳԵ�
			tmp_bet_right=1
		elseif(i==10 and count_num==4)then
			tmp_bet_right=1	
		elseif(i==11 and count_num==5)then
			tmp_bet_right=1	
		elseif(i==12 and count_num==6)then
			tmp_bet_right=1	
		elseif(i==13 and count_num==7)then
			tmp_bet_right=1				
		elseif(i==14 and count_num==8)then
			tmp_bet_right=1				
		elseif(i==15 and count_num==9)then
			tmp_bet_right=1				
		elseif(i==16 and count_num==10)then
			tmp_bet_right=1				
		elseif(i==17 and count_num==11)then
			tmp_bet_right=1				
		elseif(i==18 and count_num==12)then
			tmp_bet_right=1				
		elseif(i==19 and count_num==13)then
			tmp_bet_right=1				
		elseif(i==20 and count_num==14)then
			tmp_bet_right=1				
		elseif(i==21 and count_num==15)then
			tmp_bet_right=1			
		elseif(i==22 and count_num==16)then
			tmp_bet_right=1				
		elseif(i==23 and count_num==17)then
			tmp_bet_right=1																						
		end
		
		if(tmp_bet_right==1)then
			table.insert(daxiao_lib.kajiang_table,i)
		end
		
		
		if(bet_info_tab==nil or bet_info_tab[i]==nil or tonumber(bet_info_tab[i])==0)then --��Ӧ����ûѺ��ֱ����Ϊû��
			tmp_bet_right=0
		end
		--���Ѻ���ˣ��ͼ���Ʊ
		if(tmp_bet_right==1)then
			win_yinpiao=win_yinpiao+bet_info_tab[i]*daxiao_lib.bet_peilv[i]
			get_yinpiao=get_yinpiao+(bet_info_tab[i]+bet_info_tab[i]*daxiao_lib.bet_peilv[i])
			zj_buf.area_id=i
			zj_buf.get_yinpiao=get_yinpiao
			zj_buf.area_win_yinpiao = bet_info_tab[i]+bet_info_tab[i]*daxiao_lib.bet_peilv[i]
			table.insert(user_zj_info,zj_buf)
		end
	end
	
	--�������������Ʊ,��Ѻ�м�����
	--Ѻ��1����1����2����3����3����3��
	local tmp_num=0
	for i=24,29 do
		local zj_buf={} --�����н���Ϣ����������id��׬�˶�����Ʊ
		count_right=0 --��ʶѹ���˼���
		
		if(i==24+tmp_num)then  --��ʶλ��
			if(num1==1+tmp_num and  tonumber(bet_info_tab[i])~=0)then --����Ӧλ�õ������ǲ��Ƕ�����
				count_right=count_right+1
			end
			if(num2==1+tmp_num and  tonumber(bet_info_tab[i])~=0)then
				count_right=count_right+1
			end
			if(num3==1+tmp_num and  tonumber(bet_info_tab[i])~=0)then
				count_right=count_right+1
			end
			
			--�Ƿ��ǿ���λ
			if(num1==1+tmp_num or num2==1+tmp_num or num3==1+tmp_num)then			
				table.insert(daxiao_lib.kajiang_table,i)
			end
		end
		tmp_num=tmp_num+1
		
		win_yinpiao=win_yinpiao+bet_info_tab[i]*count_right
		local is_zj_area=0
		if(count_right~=0)then
			is_zj_area=1
		end
		
		get_yinpiao=get_yinpiao+(bet_info_tab[i]*is_zj_area+bet_info_tab[i]*count_right)
		if(count_right>0)then
			zj_buf.area_id=i
			zj_buf.get_yinpiao=get_yinpiao
			zj_buf.area_win_yinpiao = bet_info_tab[i]*is_zj_area+bet_info_tab[i]*count_right
			table.insert(user_zj_info,zj_buf)			
		end		
	end
		
	return win_yinpiao,get_yinpiao,user_zj_info
end

--����Ƿ�����Чʱ����
daxiao_lib.on_recv_check_time = function(buf)
	--local user_info = daxiao_hall.get_user_info_by_key(daxiao_hall.get_user_key(buf));	
   	--if not user_info then return end;
    local ip = buf:ip()
    local port = buf:port()
   	local time_status=daxiao_lib.check_datetime()
   	local room_status=daxiao_lib.is_valid_room()
   	
   	local status = time_status
   	if daxiao_lib.is_valid_room() ~= 1 then status = 0 end

    --���û�������Ҳ��Ч
    --[[local sql="select count(*) as num from user_daxiao_info where user_id=%d"
    sql = string.format(sql, user_info.userId)
    dblib.execute(sql, function(dt)
        if (time_status == 1 and dt and #dt >0 and dt[1].num > 0) then
            time_status = 1
        else
            time_status = 0
        end
        if (viplib.get_vip_level(user_info) >= 1) then
            time_status = 1
        end
       	netlib.send(function(buf)
                buf:writeString("DVDDATE");
                buf:writeInt(time_status == 1 and status == 1 and 1 or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
            end,user_info.ip,user_info.port);
    end, user_info.userId)--]]
    --if (time_status == 1 and viplib.get_vip_level(user_info) < 1) then
    --    time_status = 0
    --end
    netlib.send(function(buf)
            buf:writeString("DVDDATE");
            buf:writeInt(time_status == 1 and status == 1 and 1 or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
        end, ip, port);
end

--�û���½���ʼ������
daxiao_lib.on_after_user_login = function(user_info, call_back)

	--local user_info = e.data.userinfo
    --�����޸ĳ������
	--xpcall(function() car_match_db_lib.on_after_user_login(user_info) end, throw)
	local sql=""
	if(user_info == nil)then 
		TraceError("�û���½���ʼ������,if(user_info == nil)then")
	 	return
	end
	user_info.init_daxiao_flag = 1
    user_info.yinpiao_count=0
    user_info.ex_yinpiao_count = 0
    user_info.bet_info=daxiao_lib.org_bet_info
    user_info.bet_num_count = 0
    user_info.bet_id=""
	--��½��ѯ���ݿ�
	--�õ��û����������ж�����Ʊ�������һ��Ͷעֵ�������һ��ͶעID
	sql="select yinpiao_count,bet_info,bet_id, ex_yinpiao_count from user_daxiao_info where user_id=%d"
	sql=string.format(sql,user_info.userId)
	dblib.execute(sql,function(dt)	
				if(dt~=nil and  #dt>0)then
					user_info.yinpiao_count=dt[1].yinpiao_count;
                    user_info.ex_yinpiao_count=dt[1].ex_yinpiao_count;
					if(dt[1].bet_id==daxiao_lib.bet_id and dt[1].bet_info~=nil and dt[1].bet_info~="")then
						user_info.bet_info=dt[1].bet_info;
					else
						user_info.bet_info=daxiao_lib.org_bet_info;
					end					
					user_info.bet_id=dt[1].bet_id;
				else
					user_info.yinpiao_count=0;
                    user_info.ex_yinpiao_count=0;
					user_info.bet_info=daxiao_lib.org_bet_info;
					user_info.bet_id="";
				end
				
				local tmp_user_bet_info = split(user_info.bet_info,",")
				local tmp_bet_num_count = 0
	   			for i=1,29 do	   					
	   				tmp_bet_num_count=tmp_bet_num_count+tmp_user_bet_info[i]
	   			end
	   			user_info.bet_num_count=tmp_bet_num_count
				daxiao_lib.check_back_yinpiao(user_info)
				if call_back ~= nil then
					call_back(user_info)
				end
				eventmgr:dispatchEvent(Event("already_init_yinpiao", _S{user_id=user_info.userId,yinpiao_count=user_info.yinpiao_count,ex_yinpiao_count=user_info.ex_yinpiao_count}));
	    end, user_info.userId)
end

--����Ƿ��˻���Ʊ
daxiao_lib.check_back_yinpiao = function(user_info)
    local check_status = daxiao_lib.check_expire()
    if (check_status == 0) then
        local sql = "update user_daxiao_info set yinpiao_count = 0, bet_info = '%s', bet_id = '' where user_id = %d"
        sql = string.format(sql, daxiao_lib.org_bet_info, user_info.userId)
		dblib.execute(sql, function(dt)
            if (gamepkg.name == "daxiao") then
				local gold = user_info.yinpiao_count * daxiao_adapt_lib.tex_yipiao_rate
				local choushui = gold * daxiao_lib.choushui_info
				gold = gold - choushui
				usermgr.addgold(user_info.userId, gold, choushui, g_GoldType.daxiao_gold, g_GoldType.daxiao_choushui,-1);
			else
				local gold = user_info.yinpiao_count * daxiao_adapt_lib.qp_yipiao_rate
				local choushui = gold * daxiao_lib.choushui_info
				gold = gold - choushui
				usermgr.addgold(user_info.userId, gold, choushui, tSqlTemplete.goldType.DAXIAO_GOLD, tSqlTemplete.goldType.DAXIAO_CHOUSHUI,-1);
        	end
        end, user_info.userId)
    end
end

--����Ƿ����
function daxiao_lib.check_expire(time_check)
    local sys_time = os.time();	
    if (time_check ~= nil) then
        sys_time = time_check
    end
    local statime = timelib.db_to_lua_time(daxiao_lib.startime);
	local endtime = timelib.db_to_lua_time(daxiao_lib.endtime);
	if(sys_time > statime and sys_time <= endtime) then
		return 1
    else
        return 0
	end
end

--�����Чʱ�䣬��ʱ����int	0�����Ч�������Ҳ�ɲ�������1�����Ч
function daxiao_lib.check_datetime(time_check)
    local sys_time = os.time();	
    if (time_check ~= nil) then
        sys_time = time_check
    end
	local check_status = daxiao_lib.check_expire(sys_time)
    --ֻ����ָ����ʱ���ʱ��
    local tableTime = os.date("*t",sys_time);
	local nowHour  = tonumber(tableTime.hour);
	--������趨����Ϸ��ʱ�䣬�Ϳ�һ���ǲ����������ʱ�䷶Χ��
	if(check_status==1)then
        for k,v in pairs(daxiao_lib.open_time) do
            for k1, v1 in pairs(v) do
                if(nowHour == v1)then
    				return 1
    			end
            end
		end
		return 0
	end
	--�ʱ���ȥ��
	return 0;
end

daxiao_lib.on_recv_refresh_buy_yinpiao = function(buf)
    local user_info = daxiao_hall.get_user_info_by_key(daxiao_hall.get_user_key(buf));	
    daxiao_lib.refresh_buy_yinpiao(user_info)
end

daxiao_lib.refresh_buy_yinpiao = function(user_info)
    if not user_info then return end;
    local sql="select id, gold_num, gold_type from user_exchange_gold where user_id=%d and (gold_type = 1 or gold_type = 2)"
	sql=string.format(sql,user_info.userId)
    dblib.execute(sql, function(dt) 
        if (dt and #dt > 0) then
            local id_info = ""
            for k, v in pairs(dt) do
                if (v.gold_type == 1) then
                    xpcall(function()daxiao_lib.add_yinpiao(user_info.userId, v.gold_num, 0, 1) end, throw)
                elseif (v.gold_type == 2) then
                    xpcall(function()daxiao_lib.add_exyinpiao(user_info.userId, v.gold_num, 0, 1) end, throw)
                end
                if (id_info ~= "")then
                    id_info = id_info..","
                end
                id_info = id_info..v.id                
            end
            sql = "delete from user_exchange_gold where id in("..id_info..")"
            dblib.execute(sql, nil, user_info.userId)
        end
    end, user_info.userId)
end

--���չ�����Ʊ
daxiao_lib.on_recv_buy_yinpiao = function(buf)
    if (daxiao_lib.is_valid_room()~=1) then return end
	local user_info = daxiao_hall.get_user_info_by_key(daxiao_hall.get_user_key(buf));	
   	if not user_info then return end;
   	--�յ���Ʊ
   	local buy_type=buf:readInt(); --1���� 2.ȡ��
    local buy_yinpiao = buf:readInt(); --��Ʊ����
        
   	if ((user_info.vip_level < 1 and buy_type == 1) or buy_yinpiao <= 0 or buy_type ~= 2) then
--   			netlib.send(function(buf)
--	            buf:writeString("DVDEXCG");
--	            buf:writeInt(-1);		--�һ���ʽ��ʶ��1������ 2��ȡ���� 0��Ϊ�һ�����   3������ʱ���ܹ���
--	            buf:writeInt(0);		--�һ���Ʊ����
--	        end,user_info.ip,user_info.port);
   		return
   	end
   	
   	--���͹�����Ʊ���
	local function send_buy_yinpiao_result(user_info, result,yinpiao_count)
		netlib.send(function(buf)
	            buf:writeString("DVDEXCG");
	            buf:writeInt(result);		--�һ���ʽ��ʶ��1������ 2��ȡ���� 0��Ϊ�һ�����   3������ʱ���ܹ���
	            buf:writeInt(yinpiao_count);		--�һ���Ʊ����
	        end,user_info.ip,user_info.port);
    end
   	--��������������ˣ���ô�Ͳ��ܴ�ȡ��Ʊ
    if(user_info.yinpiao_count==nil)then
    	--����ȡ��Ʊ���
    	result = 0
		send_buy_yinpiao_result(user_info, result, buy_yinpiao)
    	return
    end
    
    --����û��Ʊ�Ļ���������ȡ
    if(buy_type==2 and user_info.yinpiao_count==0)then
    	--����ȡ��Ʊ���
    	result = 0
		send_buy_yinpiao_result(user_info, result, buy_yinpiao)
    	return
    end
    --������ϵ���Ʊ��Ҫȡ����Ʊ�٣��Ͳ���ȡ�������ʼֵ��0��nil������ȡ��ʱ��ֻ��Ҫ�ж��ڴ棬û�ж����ݿ�
    if(buy_type==2 and user_info.yinpiao_count<buy_yinpiao)then
    	--����ȡ����Ʊ���
    	result = 0
		send_buy_yinpiao_result(user_info, result, buy_yinpiao)
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
   	local yinpiao_choushui=1
   	local yinpiao_rate=10000
   	if (gamepkg.name == "daxiao") then
   		yinpiao_rate = daxiao_adapt_lib.tex_yipiao_rate
   	else
   		yinpiao_rate = daxiao_adapt_lib.qp_yipiao_rate
   	end
   	
   	if(buy_type==2)then --ȡ��
   		yinpiao_choushui=1-daxiao_lib.choushui_info
   		choushui_gold=daxiao_adapt_lib.tex_yipiao_rate * buy_yinpiao*daxiao_lib.choushui_info
   	end  	
    
    --���ʱ��yinpiao_choushui==1��ȡ��ʱ����0.95(�����۳�ˮ��
    local buy_gold = daxiao_adapt_lib.tex_yipiao_rate * buy_yinpiao*yinpiao_choushui
    local can_use_gold = 0 --daxiao_lib.calc_can_use_gold(user_info) --�������õ�Ǯ,��Ϊ���ݵ�userinfo.chouma��Щ���⣬�����Ȳ����������
    
    --����ǹ�����Ʊ����Ҫ��һ��Ǯ������
    if(user_info.site==nil)then
		can_use_gold = user_info.gamescore
    end

	--�ȼӼ�Ǯ���ټӼ���Ʊ    
	--����
	if (gamepkg.name == "daxiao") then
	  if buy_type == 1 then
	    usermgr.addgold(user_info.userId, -buy_gold*temp_flag, choushui_gold, g_GoldType.daxiao_gold, g_GoldType.daxiao_choushui,-1,nil,999,buy_yinpiao);
	  else
	    usermgr.addgold(user_info.userId, -buy_gold*temp_flag, choushui_gold, g_GoldType.daxiao_gold_sell, g_GoldType.daxiao_choushui,-1,nil,999,buy_yinpiao);
	  end
		
	else
		--����
		usermgr.addgold(user_info.userId, -buy_gold*temp_flag, choushui_gold, tSqlTemplete.goldType.DAXIAO_GOLD, tSqlTemplete.goldType.DAXIAO_CHOUSHUI,-1);
	end
  	daxiao_lib.add_yinpiao(user_info.userId,buy_yinpiao*temp_flag,0,buy_type)	
	
	--֪ͨ�ͻ��˴�ȡ��Ʊ�Ľ��
	send_buy_yinpiao_result(user_info, buy_type, buy_yinpiao)	
end


--������ҵ�Ͷע��Ϣ
function daxiao_lib.update_bet_info(userId,area_id,yinpiao_bet)
	local user_info=daxiao_hall.get_user_info(userId)
	if(user_info == nil)then return end
	--�����ַ����ж�Ӧλ�õ�ֵ
	local update_bet=function(bet_info,area_id,yinpiao_bet)
		if(bet_info==nil or bet_info=="")then
			bet_info=daxiao_lib.org_bet_info;	
		end
		local tmp_tab=split(bet_info,",")
		local tmp_str=""
		local tmp_bet=0
		tmp_bet=tonumber(tmp_tab[area_id])

		if(tmp_bet==nil)then
			TraceError("error bet_info="..bet_info)
		end
		tmp_bet=tmp_bet+yinpiao_bet

		tmp_tab[area_id]=tostring(tmp_bet)
	
		for i=1,#tmp_tab do
			tmp_str=tmp_str..","..tmp_tab[i]
		end
		
		--������ע�����
		local tmp_bet_info=string.sub(tmp_str,2)
		local user_info=daxiao_hall.get_user_info(userId)
		local sql="update user_daxiao_info set bet_info='%s',bet_id='%s' where user_id=%d;commit; "
		sql=string.format(sql,tmp_bet_info,daxiao_lib.bet_id,userId)

		dblib.execute(sql, nil, userId)
		return tmp_bet_info --ȥ����1�����ź󷵻�
	end
	
	--������ҵ�Ͷע��Ϣ
	local tmpstr=""
	 
   	--������Ϸ��Ϣ
   	local bufftable ={		 				
		 				userId = user_info.userId,	--�û�Id
                        nick = user_info.nick,
                        ip = user_info.ip,
                        port = user_info.port,
		 				bet_info = user_info.bet_info or daxiao_lib.org_bet_info, --���Ͷע����Ϣ		 				
					}
					
	local already_join_game=0 --�Ƿ��Ѽ�������Ϸ
	
	--����Ѽ������Ϸ���͸���һ��Ͷע��Ϣ
	for k,v in pairs(daxiao_lib.daxiao_game_info) do
		if(v.userId==user_info.userId)then
			already_join_game=1
			v.ip = user_info.ip
			v.port = user_info.port
			break
		end
	end
	
	--�������Ϸ��Ϣ���뵽��¼����
	if(already_join_game==0)then
		table.insert(daxiao_lib.daxiao_game_info,bufftable)
	end
	
	for k,v in pairs (daxiao_lib.daxiao_game_info) do
		if(v~=nil and v.userId==userId)then

			v.bet_info=update_bet(v.bet_info,area_id,yinpiao_bet)
			tmpstr=v.bet_info
		end
	end
	return tmpstr
end

--������ע
function daxiao_lib.on_recv_xiazhu(buf)
	local user_info = daxiao_hall.get_user_info_by_key(daxiao_hall.get_user_key(buf));	
   	if not user_info then return end;
   	local time_status = daxiao_lib.check_datetime()
   	--����ʱ�䲻����
   	if (time_status==0) then return end
   	if user_info.vip_level < 1 then
--   		netlib.send(function(buf)
--	            buf:writeString("DVDBET");
--	            buf:writeInt(-1);		--��ע�����0�����Ч�� 1����ע�ɹ��� 2����עʧ�ܣ���Ʊ����
--	        end,user_info.ip,user_info.port);
   		return
   	end
   	--����쵽23���ǰ3���Ӳ�����ע
   	local tableTime = os.date("*t",os.time());
    local nowYear = tonumber(tableTime.year);
    local nowMonth = tonumber(tableTime.month);
    local nowDay = tonumber(tableTime.day);
    local now_hour = tonumber(tableTime.hour);
	local db_time = nowYear.."-"..nowMonth.."-"..nowDay.." "..now_hour..":00:00"
    local next_time = timelib.db_to_lua_time(db_time)+60*60

    --if(daxiao_lib.check_datetime(next_time) == 0 and next_time <= os.time()+60*3)then
	--	return
	--end
	
   	if (daxiao_lib.is_valid_room()~=1) then return end
	
   	--��ע����
   	local area_id = buf:readInt();--����id
   	local yinpiao_bet = buf:readInt();--�������µ���Ʊ����
   	
   	--���ؿͻ�����ע���
   	local send_bet_result=function(user_info,result)
   		netlib.send(function(buf)
	            buf:writeString("DVDBET");
	            buf:writeInt(result);		--��ע�����0�����Ч�� 1����ע�ɹ��� 2����עʧ�ܣ���Ʊ����
	        end,user_info.ip,user_info.port);
	    local sql = "insert into log_daxiao_xiaozhu(user_id, area_id, yinpiao_bet, status, bet_id, sys_time) value(%d, %d, %d, %d, %d, now())"
		sql = string.format(sql, user_info.userId, area_id, yinpiao_bet, result, daxiao_lib.bet_id)
		dblib.execute(sql, function(dt) end, user_info.userId)	        
   	end
   	
   	--���ֽ���ǰ10�벻���������ע
 	if(daxiao_lib.fajiang_time-os.time()<10 ) then
		send_bet_result(user_info,3)
   		return
	end
	
	--����������ע����
 	if(yinpiao_bet>daxiao_lib.limit_local_bet) then
 		send_bet_result(user_info,4)
   		return
 	end
 	
 	--���˵�����ע
 	if(user_info.bet_num_count==nil)then
 		user_info.bet_num_count = 0
 	end
 	
 	--����ע��������������
   	if(user_info.bet_num_count>daxiao_lib.limit_bet-yinpiao_bet)then
   	 	send_bet_result(user_info,5)
   		return
   	end
   	
   	--�ж���Ʊ
   	if(user_info.yinpiao_count == nil or (user_info.yinpiao_count + user_info.ex_yinpiao_count) == 0 or 
       ((user_info.yinpiao_count + user_info.ex_yinpiao_count) <yinpiao_bet))then
   		send_bet_result(user_info,2)
   		return
   	end

  	--��������ϵ���Ʊ������ɹ��ͷ��ؿͻ��˳ɹ�����Ȼ��֪ͨ˵ʧ��
	if daxiao_lib.add_yinpiao(user_info.userId,-yinpiao_bet,0,3) then
		--�۳��ˣ��͸�����ע���ֶΣ�֪ͨ�ͻ�����ע�ɹ�
	   	user_info.bet_num_count = user_info.bet_num_count + yinpiao_bet
  		user_info.bet_info=daxiao_lib.update_bet_info(user_info.userId,area_id,yinpiao_bet)
		user_info.bet_id=daxiao_lib.bet_id
		send_bet_result(user_info,1)
	else
		send_bet_result(user_info,2)
	end	
	
end


--�������3������
function daxiao_lib.get_random_num(num_1,num_2,num_3)
	--��ʱ����Ϊ���������
	local t = os.time() 
	math.randomseed(t)
	
	--Ĭ����1��1��������ȡ6������
	local tmp_num1=math.random(1,3333)%6+1
	local tmp_num2=math.random(3334,6666)%6+1
	local tmp_num3=math.random(6667,10000)%6+1
	local tmp_nouse_num=0
	local buf_tab = daxiao_lib.gen_counts()

	local rand_type=math.random(1,t)%5+1 --��5��������㷨���Ժ��ټ�
	if(rand_type==1)then  --ȡ1��32000���������ȡ��
		tmp_num1=math.random(20000,30000)%6+1
		tmp_num2=math.random(10000,20000)%6+1
		tmp_num3=math.random(1,10000)%6+1
	elseif(rand_type==2)then
		tmp_num1=buf_tab[math.random(10, 60)]
		tmp_num2=buf_tab[math.random(10, 60)]
		tmp_num3=buf_tab[math.random(10, 60)]
	elseif(rand_type==3)then
		tmp_num1=buf_tab[math.random(15, 60)]
		tmp_num2=buf_tab[math.random(15, 60)]
		tmp_num3=buf_tab[math.random(15, 60)]
	elseif(rand_type==4)then
		tmp_nouse_num=math.random(1,10000)
		tmp_nouse_num=math.random(1,10000)
		tmp_num1=math.random(1,t)%6+1
		tmp_nouse_num=math.random(1,10000)
		tmp_nouse_num=math.random(1,10000)
		tmp_num2=math.random(20000,30000)%6+1
		tmp_nouse_num=math.random(1,10000)
		tmp_nouse_num=math.random(1,10000)		
		tmp_num3=math.random(10000,30000)%6+1	
	end	
	
	if(num_1==nil or num_2==nil  or num_3==nil)then
		--ȡ1��10000���������6ȥ�࣬�õ���ֵ������һ�㣬ֱ����luaȡ1��6�������Щ����
		num_1 = tmp_num1
		num_2 = tmp_num2
		num_3 = tmp_num3
    end
    

    if (num_1 == num_2 and num_2 == num_3) then
        num_1 = math.random(1, 6)
        num_2 = math.random(1, 6)
        num_3 = math.random(1, 6)
    end
	return num_1,num_2,num_3
end

function daxiao_lib.gen_counts()
	local buf_tab={}
	for i=1, 60 do
		table.insert(buf_tab, math.random(1, 6))
	end
	return buf_tab
end

--��ĳ����ҼӼ���Ʊ
--userId��ұ��
--yinpiao�Ӽ�����Ʊ����
--flag�ǲ���֪ͨ�ͻ���0��֪ͨ1֪ͨ
--yinpiao_type ������Ʊ����������Ʊ��������Ϸ����Ʊ�仯
function daxiao_lib.add_yinpiao(userId,yinpiao,flag,yinpiao_type)
	if (daxiao_lib.is_valid_room()~=1) then return end
	
	local user_info=daxiao_hall.get_user_info(userId);
	local sql=""
	
	if(user_info==nil)then 
   		flag=1 --���Ͷע�������ˣ��Ͳ�����ͻ��˷���
    end
    local add_ex_yinpiao = 0  --��Ҫ�޸ĵ���չ��Ʊ
    local add_yinpiao = yinpiao  --��Ҫ�޸ĵ�ԭʼ��Ʊ
    --���������ߣ���Ҫ���ڴ�
	if(user_info~=nil)then
		--��ʼ��
		if(user_info.yinpiao_count==nil) then user_info.yinpiao_count=0 end
		--����ҼӼ���Ʊ
        if (yinpiao < 0 and yinpiao_type == 3) then --�����ע�������Ʊ�Ƿ���ע
            if (user_info.ex_yinpiao_count + yinpiao >= 0) then
                user_info.ex_yinpiao_count = user_info.ex_yinpiao_count + yinpiao
                add_ex_yinpiao = yinpiao
                add_yinpiao = 0
            else
                add_ex_yinpiao = -user_info.ex_yinpiao_count
                add_yinpiao = user_info.ex_yinpiao_count + yinpiao
                user_info.ex_yinpiao_count = 0
            end
        end
		user_info.yinpiao_count=user_info.yinpiao_count+add_yinpiao
		if(user_info.yinpiao_count<0)then
			user_info.yinpiao_count=0
			return false
		end
	end
	
	--�����ݿ�
	local tmp_bet_info=daxiao_lib.org_bet_info;	
	local tmp_nick=""
	if(user_info~=nil)then 
		tmp_bet_info=user_info.bet_info
		tmp_nick=string.trans_str(user_info.nick)
    end
    --���ﲻ���ã�Ϊɶ��ʱ��Ϊ��
	if (tmp_bet_info == nil) then
        tmp_bet_info=daxiao_lib.org_bet_info;
    end
	sql="insert into user_daxiao_info(user_id,yinpiao_count,bet_info,bet_id,user_nick) value(%d,%d,'%s','%s','%s') ON DUPLICATE KEY UPDATE yinpiao_count=yinpiao_count+%d,bet_id='%s',ex_yinpiao_count=ex_yinpiao_count+%d;commit; "
	sql=string.format(sql,userId,add_yinpiao,tmp_bet_info,daxiao_lib.bet_id,tmp_nick,add_yinpiao,daxiao_lib.bet_id,add_ex_yinpiao)
	dblib.execute(sql, nil, userId)
	
	--д�Ӽ���Ʊ����־
	local tmp_yinpiao_count=-1  --��Ϊ����Ҳ�����Ʊ����ʱ��ҿ����������ˣ���ʱ�Ͳ�д��������ж���Ǯ�˰ɡ��Ժ��п��ٸĽ�
	if(user_info~=nil)then 
		tmp_yinpiao_count=user_info.yinpiao_count or 0
    end

    local tmp_ex_yinpiao_count=-1  --��Ϊ����Ҳ�����Ʊ����ʱ��ҿ����������ˣ���ʱ�Ͳ�д��������ж���Ǯ�˰ɡ��Ժ��п��ٸĽ�
	if(user_info~=nil)then 
		tmp_ex_yinpiao_count=user_info.ex_yinpiao_count or 0
	end
	
    if (add_ex_yinpiao ~= 0) then
        sql="insert into log_user_ex_yipiao(user_id,before_ex_yinpiao,add_yinpiao,yinpiao_type,sys_time)value(%d,%d,%d,%d,now());commit;"
    	sql=string.format(sql,userId,tmp_ex_yinpiao_count,add_ex_yinpiao,yinpiao_type)
    	dblib.execute(sql)
    end
	sql="insert into log_user_yipiao(user_id,before_yinpiao,add_yinpiao,yinpiao_type,sys_time)value(%d,%d,%d,%d,now());commit;"
	sql=string.format(sql,userId,tmp_yinpiao_count,yinpiao,yinpiao_type)
	dblib.execute(sql)
	if(flag==nil or flag~=1)then
		netlib.send(function(buf)
	            buf:writeString("DVDYPNUM"); --֪ͨ�ͻ��ˣ����������Ʊ��
	            buf:writeInt(user_info.yinpiao_count); --�����Ʊ��
                buf:writeInt(user_info.ex_yinpiao_count); --�����Ʊ��
	            end,user_info.ip,user_info.port)
    end 
	return true
end

function daxiao_lib.add_exyinpiao(userId, add_ex_yinpiao, flag, yinpiao_type)
	if (daxiao_lib.is_valid_room()~=1) then return end
	local user_info=daxiao_hall.get_user_info(userId);
	local sql=""
	if(user_info~=nil)then
		user_info.ex_yinpiao_count = user_info.ex_yinpiao_count or 0 
		user_info.ex_yinpiao_count = user_info.ex_yinpiao_count + add_ex_yinpiao
	end
	--�����ݿ�
	sql="insert into user_daxiao_info(user_id,yinpiao_count,bet_info,bet_id,user_nick,ex_yinpiao_count) value(%d,%d,'%s','%s','%s',%d) ON DUPLICATE KEY UPDATE ex_yinpiao_count=ex_yinpiao_count+%d;commit; "
	sql=string.format(sql,userId,user_info.yinpiao_count or 0, "", 0, "", add_ex_yinpiao,add_ex_yinpiao)
	dblib.execute(sql, nil, userId)
	
	--д�Ӽ���Ʊ����־
	local tmp_yinpiao_count=-1  --��Ϊ����Ҳ�����Ʊ����ʱ��ҿ����������ˣ���ʱ�Ͳ�д��������ж���Ǯ�˰ɡ��Ժ��п��ٸĽ�
	if(user_info~=nil)then 
		tmp_yinpiao_count=user_info.yinpiao_count or 0
    end

    local tmp_ex_yinpiao_count=-1  --��Ϊ����Ҳ�����Ʊ����ʱ��ҿ����������ˣ���ʱ�Ͳ�д��������ж���Ǯ�˰ɡ��Ժ��п��ٸĽ�
	if(user_info~=nil)then 
		tmp_ex_yinpiao_count=user_info.ex_yinpiao_count
	end
	
    if (add_ex_yinpiao ~= 0) then
			sql="insert into log_user_ex_yipiao(user_id,before_ex_yinpiao,add_yinpiao,yinpiao_type,sys_time)value(%d,%d,%d,%d,now());commit;"
			sql=string.format(sql,userId,user_info.ex_yinpiao_count,add_ex_yinpiao,yinpiao_type)
			dblib.execute(sql)
    end
    netlib.send(function(buf)
            buf:writeString("DVDYPNUM"); --֪ͨ�ͻ��ˣ����������Ʊ��
            buf:writeInt(user_info.yinpiao_count or 0); --�����Ʊ��
            buf:writeInt(user_info.ex_yinpiao_count or 0); --�����Ʊ��
    end,user_info.ip,user_info.port)    
end

function daxiao_lib.fajiang()
	local all_zj_info={}; --���еı����н���Ϣ
	local sql="";
	local user_zj_info={}; --��ҷ�������н���Ϣ
	local tmp_user_info; --Ϊ�˸��ͻ��˷���ҵ��ǳƣ����������������
	
	local win_yinpiao=0 --׬������Ʊ
	local get_yinpiao=0 --һ��Ӧ���е���Ʊ
	local nick_name=""
	local gain_most_info={} --��һ��׬������10����
    local round_bet_info = ""  --һ����Ӯ�����
	for k,v in pairs (daxiao_lib.daxiao_game_info) do
		local buf_zj_info={};
		--��ÿ���н����˷���
		win_yinpiao,get_yinpiao,user_zj_info=daxiao_lib.calc_win_yinpiao(v.bet_info,daxiao_lib.num1,daxiao_lib.num2,daxiao_lib.num3)
		--[[tmp_user_info=daxiao_hall.get_user_info(v.userId) 
		if (tmp_user_info ~= nil and tmp_user_info.bet_num_count > 0) then
            if (round_bet_info ~= "") then
                round_bet_info = round_bet_info.."|"
            end
            round_bet_info = round_bet_info..v.userId..","..tmp_user_info.bet_num_count..","..win_yinpiao
        end--]]
		--�õ��м������н�����Щ��׬�˶���Ǯ����Ϣ
		if(win_yinpiao>0)then					
		    daxiao_lib.add_yinpiao(v.userId, get_yinpiao,1,4);--���ﴫget_yinpiao����Ϊ���˽�֮�󱾽�ҲҪ�������						
            netlib.send(function(buf)
                buf:writeString("DVDMYWIN"); --֪ͨ�ͻ��ˣ���ҵ��н���¼
                buf:writeInt(win_yinpiao); --�н�������		           
            end, v.ip, v.port)
			buf_zj_info.userId=v.userId
			buf_zj_info.nick=v.nick
			buf_zj_info.win_yinpiao=win_yinpiao
			table.insert(all_zj_info,buf_zj_info)
        end
        xpcall(function() daxiao_lib.send_zj_info(user_zj_info, v) end, throw)
	end
    daxiao_adapt_lib.record_round_info(round_bet_info)
	--֪ͨ�ͻ��ˣ���ҵ��н���¼
	--����win_yinpiao����
	if(all_zj_info~=nil and #all_zj_info>2)then

		table.sort(all_zj_info, 
		      function(a, b)
			     return a.win_yinpiao > b.win_yinpiao		                   
		end)
	end

	for k,v in pairs (daxiao_lib.daxiao_game_info) do
		local user_info=daxiao_hall.get_user_info(v.userId)
		if(user_info~=nil)then				
			netlib.send(function(buf)
	            buf:writeString("DVDHISTORY"); --֪ͨ�ͻ��ˣ���ҵ��н���¼
	           
	            local mc_len=10 --�����ʾǰ10��
	            local send_len=#all_zj_info or 0
	            if(send_len>mc_len)then send_len=mc_len end
	            buf:writeInt(send_len); --�н����������
	            if(send_len>0)then
		            for i=1,send_len do
		            	buf:writeInt(all_zj_info[i].userId) --���ID
		            	buf:writeString(all_zj_info[i].nick or "")   --����ǳ�
		            	buf:writeInt(all_zj_info[i].win_yinpiao or 0) --����н�����Ʊ����
		            end
	            end
	            end,user_info.ip,user_info.port) 
		end
	end
end

function daxiao_lib.send_zj_info(user_zj_info, user_game_info)
    --�����������ݣ�������1��Э�����ȫ����ȥ�ˣ������ͻ�����ǰ������Щ���⣬����Ҫ��DVDPRIZE��DVDMYWIN 2��Э�顣
    netlib.send(function(buf)
        buf:writeString("DVDPRIZE")
        buf:writeInt(daxiao_lib.num1)
        buf:writeInt(daxiao_lib.num2)
        buf:writeInt(daxiao_lib.num3)
        buf:writeInt(daxiao_lib.total_num)
        buf:writeInt(29)
        for i=1,29 do
            local tmp_flag=0
            if(daxiao_lib.kajiang_table==nil)then
                TraceError("daxiao_lib.kajiang_table nil")
            end
            for k,v in pairs (daxiao_lib.kajiang_table)do
                if(i==v)then
                    tmp_flag=1 --�Ƿ��ǿ���λ
                    break
                end
            end
    
            if(user_zj_info==nil)then
                TraceError("user_zj_info nil:"..i)
            end
            buf:writeInt(i) --�����Ӯ������
            local tmpnum=0
            
            for k,v in pairs (user_zj_info) do
                if(v.area_id==i)then				            	
                    tmpnum=v.area_win_yinpiao --�����Ӯ����Ʊ����������
                    break	
                end			            		
            end
            buf:writeInt(tmpnum)
            buf:writeByte(tmp_flag) --����λ
            
        end
    end, user_game_info.ip, user_game_info.port) 
end

function daxiao_lib.create_open_num()

 	--���gmָ���˺ţ��Ϳ�ָ���ĺţ��������֮��Ҫ��ֵ����������ֹһֱ��һ����
 	if(daxiao_lib.gm_num1~=nil and daxiao_lib.gm_num1~=0)then
 		daxiao_lib.num1,daxiao_lib.num2,daxiao_lib.num3 = daxiao_lib.get_random_num(daxiao_lib.gm_num1,daxiao_lib.gm_num2,daxiao_lib.gm_num3)
 		daxiao_lib.gm_num1=0
 		daxiao_lib.gm_num2=0
 		daxiao_lib.gm_num3=0
	else
 		daxiao_lib.num1,daxiao_lib.num2,daxiao_lib.num3 = daxiao_lib.get_random_num()	--��ȡ�����
 	end
 	
	daxiao_lib.total_num=daxiao_lib.num1+daxiao_lib.num2+daxiao_lib.num3
	--������ʷ����
	if(#daxiao_lib.history < daxiao_lib.history_len)then		--�������С��6��ֱ�Ӽ���
		local bufftable ={
					  	    num_1 = daxiao_lib.num1, 
		                    num_2 = daxiao_lib.num2,
		                    num_3 = daxiao_lib.num3,
		                    total_num = daxiao_lib.total_num,   
		                }	                
		table.insert(daxiao_lib.history,bufftable)
	else
		table.remove(daxiao_lib.history,1)	--ɾ����һ��		
		local bufftable ={
					  	    num_1 = daxiao_lib.num1, 
		                    num_2 = daxiao_lib.num2,
		                    num_3 = daxiao_lib.num3,
		                    total_num = daxiao_lib.total_num,   
		                }	                
		table.insert(daxiao_lib.history,bufftable)
	end
	
	--д��ʷ������־
 	sql="insert into log_daxiao_history(num1,num2,num3,total_num,bet_id,sys_time) value (%d,%d,%d,%d,'%s',now());commit;";
 	sql=string.format(sql,daxiao_lib.num1,daxiao_lib.num2,daxiao_lib.num3,daxiao_lib.total_num,daxiao_lib.bet_id);
 	dblib.execute(sql);
end

--����
--ÿ10���ӽ���һ�Σ�Ҫ���������£�
--1. �����ֵ���Ա����
--2. ��ʼ���µ�һ���õ��ı���
--3. д������־
function daxiao_lib.start_game()
	if (daxiao_lib.is_valid_room()~=1) then return end


	
 	--��ʼ��һ�ֵ���Ϣ
 	local function init_game_info()
 		local curr_time=os.time()
		--��ʼ��������ʱ��		
	 	daxiao_lib.fajiang_time=curr_time+60*3
	 	
		local time_status=daxiao_lib.check_datetime()
		
	 	--��ʼ���������˵��б�
	 	for k,v in pairs (daxiao_lib.daxiao_game_info) do
	 		local user_info=daxiao_hall.get_user_info(v.userId)
	 		if(user_info~=nil)then
	 			user_info.bet_info=daxiao_lib.org_bet_info;
	 			user_info.bet_num_count = 0
	 			netlib.send(function(buf)
		            buf:writeString("DVDDATE");
		            buf:writeInt(time_status or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
		        	end,user_info.ip,user_info.port); 
	 		end			
	 	end
	 	daxiao_lib.daxiao_game_info = {}
	 	
	 	--��ʼ�����ֵ�ͶעID��������ʱ��Ϊ��͵��ֶ���ΪͶעID
	 	daxiao_lib.bet_id = os.date("%Y%m%d%H%M", curr_time)
	 	
	 	--�������µ�bet_id�����������ֹ����������ʱҪ��Ǯ
	 	daxiao_lib.update_last_betid(daxiao_lib.bet_id)
	 	
	 	daxiao_lib.kajiang_table = {}
	 	
	 	daxiao_lib.all_user_bet_info = {}
	 	daxiao_lib.fajiang_lock = 0
 	end
 	
 		
 	--��ʼ����һ�ֵ���Ϣ
 	init_game_info();
 	
end

--����ʱ
function daxiao_lib.timer()	
    if (gamepkg.name == "daxiao") then
        daxiao_lib.open_time = daxiao_adapt_lib.tex_open_time
    else
        daxiao_lib.open_time = daxiao_adapt_lib.qp_open_time
    end

    if (daxiao_lib.is_valid_room()~=1) then return end
  
    local tableTime = os.date("*t",os.time());
    local nowYear = tonumber(tableTime.year);
    local nowMonth = tonumber(tableTime.month);
    local nowDay = tonumber(tableTime.day);
    local now_hour = tonumber(tableTime.hour);
	local db_time = nowYear.."-"..nowMonth.."-"..nowDay.." "..now_hour..":00:00"
	local next_time = timelib.db_to_lua_time(db_time) + 60*60
	
	if(daxiao_lib.check_expire() == 0 and daxiao_lib.send_huodong_expire == 0)then
		for k, v in pairs(daxiao_hall.user_list) do
			netlib.send(function(buf)
				buf:writeString("DVDEXPIRE")
			end, v.ip, v.port)
		end
		daxiao_lib.send_huodong_expire = 1
		return
    end
    local time_status = daxiao_lib.check_datetime()
    --if (time_status == 0) then return end
    --if(daxiao_lib.check_datetime(next_time) == 0 and os.time() + 60*3 >= next_time)then
    --    return
	--end
	daxiao_lib.send_huodong_expire = 0
    --3���ӿ�һ��
    if(os.time() > daxiao_lib.fajiang_time)then
    	if daxiao_lib.fajiang_lock == 0 then --��һ���ڴ�������ֹ����ν�
    		daxiao_lib.fajiang_lock = 1
        	daxiao_lib.create_open_num()
        	daxiao_lib.fajiang()
        end
        --����(�и�ȱ�ݣ��տ��ֻ����һ��û���й�������
        if time_status ~= 0 then
        	daxiao_lib.start_game()
        end

        
    end
    
    if(os.time() > daxiao_lib.other_bet_time)then	 
        --����(�и�ȱ�ݣ��տ��ֻ����һ��û���й�������
        daxiao_lib.send_other_bet_info()
    end
	math.random(1,10000)
end

--������������
function daxiao_lib.restart_server(e)
	if (daxiao_lib.is_valid_room()~=1) then return end
	if (gamepkg.name == "daxiao") then
        daxiao_lib.open_time = daxiao_adapt_lib.tex_open_time
    else
        daxiao_lib.open_time = daxiao_adapt_lib.qp_open_time
    end
	local param_str_value = "-1"
	--TraceError("daxiao_lib.restart_server")

	local function return_yinpiao(user_id,bet_info)
		if(user_id==-1 or bet_info=="-1")then return end
		local yin_piao=0;
		local tmp_bet_info={}
		tmp_bet_info=split(bet_info,",")   			
		for i=1,29 do
			yin_piao=yin_piao+tmp_bet_info[i]
		end
		--������Ʊ
		local sql="update user_daxiao_info set yinpiao_count=yinpiao_count+%d,bet_info='%s' where user_id=%d and bet_info<>'%s';commit;"
		sql=string.format(sql,yin_piao,daxiao_lib.org_bet_info,user_id,daxiao_lib.org_bet_info)
		dblib.execute(sql, nil, user_id)
		
		sql="insert into log_user_yipiao(user_id,before_yinpiao,add_yinpiao,yinpiao_type,sys_time)value(%d,%d,%d,%d,now());commit;"
		sql=string.format(sql,user_id,-1,yin_piao,6)
		dblib.execute(sql, nil, user_id)
	end
	
	local sql = "SELECT param_str_value FROM cfg_param_info WHERE param_key = 'DAXIAO_BETID' and room_id=%d"
	sql = string.format(sql,groupinfo.groupid);
	dblib.execute(sql,
    function(dt)
    	if dt and #dt > 0 then
    		param_str_value = dt[1]["param_str_value"]
    	else
    		param_str_value = "-1"
		end
		
	
    		--ͨ��param_str_value��betid)���������Ʊ
    		sql="select user_id,bet_info from user_daxiao_info where bet_id='%s'"
    		sql=string.format(sql,param_str_value)
    		dblib.execute(sql,
			    function(dt)
			    	if dt and #dt > 0 then
			    		for i=1,#dt do
			    			
			    			local user_id=dt[i]["user_id"] or -1
			    			local bet_info=dt[i]["bet_info"] or "-1"
			    			TraceError("return_yinpiao(user_id,bet_info)="..user_id.." ###"..bet_info)
			    			return_yinpiao(user_id,bet_info)
			    			
			    		end
			    	end
			    end)
	end)
end

--���������һ��betid
function daxiao_lib.update_last_betid(betid)
	--�������ݿ�
	--TraceError("daxiao_lib.update_last_betid")
	local sql = "insert into cfg_param_info (param_key,param_str_value,room_id) value('DAXIAO_BETID','-1',%d) on duplicate key update param_str_value = '%s'";
	sql=string.format(sql, groupinfo.groupid,betid)
	dblib.execute(sql)
end
--�������Ͷע������Ϣ
function daxiao_lib.send_other_bet_info()
	local tmp_user_bet_info1={} --����ͳ��Ͷע��������ʱ����
	local tmp_user_bet_info2={} --��������������Ͷע��������ʱ����
	local tmp_bet_info=""
	local tmp_str=""
	local tmp_bet_num=daxiao_lib.org_bet_info
	tmp_user_bet_info2=split(tmp_bet_num,",")
	--�õ������˵�Ͷע��Ϣ�ŵ�tmp_user_bet_info2��
	for k,v in pairs (daxiao_lib.daxiao_game_info) do
   			tmp_bet_info=v.bet_info
   			if(tmp_bet_info==nil or tmp_bet_info=="")then
   				tmp_bet_info=daxiao_lib.org_bet_info
   			end
   			tmp_user_bet_info1=split(tmp_bet_info,",")   			
   			for i=1,29 do	   					
   				tmp_user_bet_info2[i]=tmp_user_bet_info2[i]+tmp_user_bet_info1[i]
   			end
	end
	
	daxiao_lib.all_user_bet_info=tmp_user_bet_info2
	
	--֪ͨ�ͻ��ˣ��������Ͷע����������˼�ȥ�Լ���
	for k,v in pairs (daxiao_lib.daxiao_game_info) do
		local user_info=daxiao_hall.get_user_info(v.userId)
		if(user_info~=nil)then
			tmp_user_bet_info1=split(user_info.bet_info or daxiao_lib.org_bet_info,",")
			netlib.send(function(buf)
		    	buf:writeString("DVDOTHBET")
		    	buf:writeInt(29)    	
		    	for i=1,29 do
		    		buf:writeInt(i)
					local tmp_num2=tonumber(tmp_user_bet_info2[i]) or 0
					local tmp_num1=tonumber(tmp_user_bet_info1[i]) or 0				
		    		buf:writeInt(tmp_num2-tmp_num1)    		
		    	end
		    	end,user_info.ip,user_info.port)
	    end
     end
     
     --10��֮������ٽ���һ��
     daxiao_lib.other_bet_time=os.time()+10
end

--������ʷ��
function daxiao_lib.send_history(user_info,history_list)
	local send_len = 0
	if(history_list~=nil)then
	   send_len=#history_list	   
	end
	netlib.send(function(buf)
    	buf:writeString("DVDREC")
    
		 buf:writeInt(send_len)
			if(send_len < daxiao_lib.history_len)then
				for i=1,send_len do
			        buf:writeInt(history_list[i].num_1) 
			        buf:writeInt(history_list[i].num_2) 
			        buf:writeInt(history_list[i].num_3)  
			        buf:writeInt(history_list[i].total_num) 
		        end
			else
		        for i=1,daxiao_lib.history_len do
			        buf:writeInt(history_list[i].num_1)	 
			        buf:writeInt(history_list[i].num_2)  
			        buf:writeInt(history_list[i].num_3)  
			        buf:writeInt(history_list[i].total_num)  
		        end
		    end
     	end,user_info.ip,user_info.port) 
end

function daxiao_lib.do_open_game(user_info)
	--local user_info = daxiao_hall.get_user_info_by_key(daxiao_hall.get_user_key(buf));	
   	if not user_info then return end;
   	
   	
   	
   	--֪ͨ�ͻ��ˣ������Ϣ
   	local send_dvd_info = function(user_info)
   		
   		local bet_info=user_info.bet_info or daxiao_lib.org_bet_info
   		local tmp_user_bet_info=split(bet_info,",")

   		netlib.send(function(buf)
            buf:writeString("DVDOPEN"); --֪ͨ�ͻ��ˣ����������Ʊ��
            buf:writeInt(user_info.yinpiao_count); --�����Ʊ��
            buf:writeInt(user_info.ex_yinpiao_count); --�����Ʊ��
            buf:writeInt(29); --Ĭ��Ϊ29�����򶼴��ؿͻ��ˡ���Ϊ�����������������򶼿�������Ͷ
			for i=1,29 do
				buf:writeInt(i) --����id
				local tmpnum=0
				if(daxiao_lib.all_user_bet_info~=nil and #daxiao_lib.all_user_bet_info~=0)then
					local tmp_num1=tonumber(daxiao_lib.all_user_bet_info[i]) or 0
					local tmp_num2=tonumber(tmp_user_bet_info[i]) or 0
					tmpnum=tmp_num1-tmp_num2
				end
				buf:writeInt(tmpnum) --������� Ͷע����Ʊ����
				buf:writeInt(tonumber(tmp_user_bet_info[i]) or 0) --����Լ� Ͷע����Ʊ����
				
			end            
            end,user_info.ip,user_info.port) 
   	end
	
   	local dx_status=daxiao_lib.check_datetime()
   	if daxiao_lib.fajiang_lock == 0 then
   		dx_status = 1
   	end
   	netlib.send(function(buf)
            buf:writeString("DVDDATE");
            buf:writeInt(dx_status or 0);		--int	0�����Ч�������Ҳ�ɲ�������1�����Ч
        end,user_info.ip,user_info.port);
    
    if(dx_status==0)then 
    	send_dvd_info(user_info)
    	return 
    end
   	--������Ϸ��Ϣ
   	local bufftable ={		 				
		 				userId = user_info.userId,	--�û�Id
                        ip = user_info.ip,
                        port = user_info.port,
                        nick = user_info.nick,
		 				bet_info = user_info.bet_info or daxiao_lib.org_bet_info, --���Ͷע����Ϣ		 				
					}
					
	local already_join_game=0 --�Ƿ��Ѽ�������Ϸ
	
	--����Ѽ������Ϸ���͸���һ��Ͷע��Ϣ
	for k,v in pairs(daxiao_lib.daxiao_game_info) do
		if(v.userId==user_info.userId)then
			already_join_game=1
			v.ip = user_info.ip
            v.port = user_info.port
			break
		end
	end
	--�������Ϸ��Ϣ���뵽��¼����
	if(already_join_game==0)then
		table.insert(daxiao_lib.daxiao_game_info,bufftable)
	end

   	--���ͻ��˷�����ʱ�仹�������
   	daxiao_lib.send_remain_time(user_info,daxiao_lib.fajiang_time)
   	
   	--���ͻ��˷�������ʷ
   	daxiao_lib.send_history(user_info,daxiao_lib.history)
   	
   	--֪ͨ�ͻ��ˣ������Ϣ
   	send_dvd_info(user_info)
end
--�������ˣ�ʣ�࿪��ʱ��
function daxiao_lib.on_recv_query_time(buf)
	local user_info = daxiao_hall.get_user_info_by_key(daxiao_hall.get_user_key(buf));	
   	if not user_info then return end;
   	daxiao_lib.send_remain_time(user_info,daxiao_lib.fajiang_time)
end

--���߿ͻ��˻��������
function daxiao_lib.send_remain_time(user_info,fajiang_time)
	local curr_time = os.time();
	local remain_time = fajiang_time-curr_time;
	netlib.send(function(buf)
        buf:writeString("DVDTIME"); --֪ͨ�ͻ��ˣ�ʣ�࿪��ʱ��
        buf:writeInt(remain_time);		--ʣ�࿪��ʱ��
      
    end,user_info.ip,user_info.port);
end

--�ͻ���ָ����ĳ��������������
function daxiao_lib.on_recv_gm_num(buf)
	local user_info = daxiao_hall.get_user_info_by_key(daxiao_hall.get_user_key(buf));	
   	if not user_info then return end;
   	
   	--�Ƿ�GM
	local function is_gm(user_id)
		if type(user_id) ~= string then
			user_id = tostring(user_id)
		end
		local tmp_gm={}
		if (gamepkg.name == "daxiao") then
			tmp_gm=daxiao_lib.tex_gm_id_arr
		else		
			tmp_gm=daxiao_lib.qp_gm_id_arr
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
    local gm_num2=buf:readInt(); --����1
    local gm_num3=buf:readInt(); --����1
    if(gm_num1==nil or gm_num2==nil or gm_num3==nil)then
    	return
    end

    daxiao_lib.gm_open_num(gm_num1,gm_num2,gm_num3)
end

--gmָ�������������˺�
daxiao_lib.gm_cmd = function(e)
    if (e.data["cmd"] == "add_dx_user" and e.data["args"][1] ~= nil) then        
        daxiao_lib.add_yinpiao(tonumber(e.data["args"][1]), 0, 0, 0)
    end
end

--Э������
cmd_daxiao_handler = 
{
    ["DVDDATE"] = daxiao_lib.on_recv_check_time, --����ʱ��״̬
    ["DVRFYP"] = daxiao_lib.on_recv_refresh_buy_yinpiao, --����������Ʊ��������adapter������ͬ�Ķ���
    ["DVDBET"] = daxiao_lib.on_recv_xiazhu, --������ע
    ["DVDEXCG"] = daxiao_lib.on_recv_buy_yinpiao, --����ˢ����Ʊ��Ϣ
    ["DVDTIME"] = daxiao_lib.on_recv_query_time, --�������ˣ�ʣ�࿪��ʱ��
    ["DVDGMNUM"] = daxiao_lib.on_recv_gm_num, --�������ˣ�ʣ�࿪��ʱ��
}

--���ز���Ļص�
for k, v in pairs(cmd_daxiao_handler) do 
	cmdHandler[k] = v
end


--eventmgr:addEventListener("h2_on_user_login", daxiao_lib.on_after_user_login);
eventmgr:addEventListener("timer_second", daxiao_lib.timer);
eventmgr:addEventListener("on_server_start", daxiao_lib.restart_server);
eventmgr:addEventListener("gm_cmd", daxiao_lib.gm_cmd)

