TraceError("init car_match_lib...")

if car_match_lib and car_match_lib.timer then
	eventmgr:removeEventListener("timer_second", car_match_lib.timer);
end

if car_match_lib and car_match_lib.restart_server then
	eventmgr:removeEventListener("on_server_start", car_match_lib.restart_server);
end

if (car_match_lib and car_match_lib.gm_cmd) then
    eventmgr:removeEventListener("gm_cmd", car_match_lib.gm_cmd)
end

if car_match_lib and car_match_lib.on_user_exit then
	eventmgr:removeEventListener("on_user_exit", car_match_lib.on_user_exit);
end

if not car_match_lib then
    car_match_lib = _S
    {
		------------------------------------��������--------------------------------
        on_recv_tuifei                      = NULL_FUNC, --�����ѯ�˷�
  		on_recv_baoming                     = NULL_FUNC, --������
  		on_recv_openjoin                    = NULL_FUNC, --�ͻ��ˣ������������ť
  		on_recv_openpl                      = NULL_FUNC, --�ͻ��˴򿪻���
        on_recv_querystatus                 = NULL_FUNC, --�ͻ��˿�������״̬
        on_recv_xiazhu                      = NULL_FUNC, --�ͻ�����ע
        on_recv_carinfo                     = NULL_FUNC, --�ͻ��˲�ѯ������Ϣ
        on_recv_carface_info                = NULL_FUNC, --�鳵����Ϣ������ͷ����ʾ��
        on_recv_query_match_mc              = NULL_FUNC, --���������
        on_recv_query_king_info             = NULL_FUNC, --��ĳ���˵ùڵ���Ϣ
		on_recv_open_box					= NULL_FUNC, --�յ�����������

        ------------------------------------���緢��--------------------------------
        send_match_time                     = NULL_FUNC, --�鱾�׶�ʣ��ʱ��
        send_king_list                      = NULL_FUNC, --��ͻ��˷�����ھ�
        send_main_box                       = NULL_FUNC, --����������Ϣ
        send_all_message                    = NULL_FUNC, --ȫ���㲥���½���Ϣ
		send_user_message                   = NULL_FUNC, --��ĳ���˷����½���Ϣ
        send_cfg_info                       = NULL_FUNC, --�������������Ϣ���ͻ��ˣ�������ʾ
        send_match_mc                       = NULL_FUNC, --����������
		send_match_status                   = NULL_FUNC, --������״̬
		send_match_status2                  = NULL_FUNC, --������״̬
        send_next_match_time                = NULL_FUNC, --����һ����ʼʱ����ͻ���
        send_xiazhu_pm                      = NULL_FUNC, --��ע�ý����а�
		send_superfans                      = NULL_FUNC, --��������˿����Ϣ
		send_today_minren                   = NULL_FUNC, --��������
		send_king_car                       = NULL_FUNC, --����֮��
		send_today_king                     = NULL_FUNC, --���չھ�
		send_history_minren                 = NULL_FUNC, --��ʷ����
        send_chadui                         = NULL_FUNC, --���ͱ������
        send_other_bet                      = NULL_FUNC, --���������˵���ע
        send_guanjun_reward                 = NULL_FUNC, --ֻҪ������ע�ˣ���֪ͨ�ͻ����µĹھ�����
        send_sys_chat_msg                   = NULL_FUNC, --��������
        send_king_gift_des                  = NULL_FUNC, --���ͱ�������
        send_other_winner                   = NULL_FUNC, --����2-8����ҵĻ���Ϣ

        ------------------------------------�ڲ��ӿ�--------------------------------
        init_match                          = NULL_FUNC, --��ʼ��ĳ�ֱ���
        init_peilv                          = NULL_FUNC, --��ʼ��������Ϣ
        init_user_match                     = NULL_FUNC, --��ʼ����ҵı�����Ϣ
        init_user_king_info                 = NULL_FUNC, --��ʼ����ҵĹھ���Ϣ
		init_super_fans_list                = NULL_FUNC, --��ʼ��������˿��Ϣ

        get_match_by_id                     = NULL_FUNC, --ͨ������ID�õ�������Ϣ
        get_match_mc                        = NULL_FUNC, --�õ�����������
  		get_speed                           = NULL_FUNC, --�õ�ĳ�೵���ٶ�
        get_npc_car_info                    = NULL_FUNC, --��NPC�ĳ�����Ϣ
        get_remain_time                     = NULL_FUNC, --�õ�ʣ��ʱ��
        get_rand_num                        = NULL_FUNC, --ȡ�����
		get_jiacheng_by_prize               = NULL_FUNC, --���ݳ��ۻ�ȡ�ӳɼ���������ֵ
		get_jiacheng                        = NULL_FUNC, --��ȡ���ͼӳ�
        get_car_name                        = NULL_FUNC, --��ȡ����
        get_car_cost                        = NULL_FUNC, --�õ��������ļ۸�
        get_user_car_prize                  = NULL_FUNC, --�õ���ҵĳ��۸�
        get_match_name                      = NULL_FUNC, --��ȡ������
        get_baoming_gold                    = NULL_FUNC, --�õ�����������Ҫ��Ǯ
        get_default_match_type              = NULL_FUNC, --�õ�ĳ�����Ĭ�ϵ�match_type
        get_npc_num                         = NULL_FUNC, --��NPC�б��г�ȡһ��NPC����

		set_proccess                        = NULL_FUNC, --������������
		add_npc                             = NULL_FUNC, --����NPC
		check_time                          = NULL_FUNC, --���ʱ��
		query_car_info                      = NULL_FUNC, --�鳵�ӵ���Ϣ
        query_carinfo_by_site               = NULL_FUNC, --����λ�ò鳵�ӵ���Ϣ
		update_guanjun_info                 = NULL_FUNC, --���±����ھ���һЩ��Ϣ
		update_minren_list                  = NULL_FUNC, --��������
		update_king_car_list                = NULL_FUNC, --��������֮��
        update_bet_info                     = NULL_FUNC, --�õ�ĳ�����Ĭ�ϵ�match_type
        return_baoming_gold                 = NULL_FUNC, --�˻�����ӵ��˵ı�����
        match_fajiang                       = NULL_FUNC, --���������˷���
        xiazhu_fajiang                      = NULL_FUNC, --����ע���˷���
        clear_car_king_data                 = NULL_FUNC, --������
        change_mc                           = NULL_FUNC, --GM���Ƴ�
		give_kingcar_box					= NULL_FUNC, --���ھ�����
        add_other_winner                    = NULL_FUNC, --����һ��2-8���Ĳ��������
        give_other_winner                   = NULL_FUNC, --��������ҷ���
	    check_match_room                    = NULL_FUNC, --����Ƿ����������
		get_useing_king_count               = NULL_FUNC, --�õ���������õĳ��Ĺھ�����
		open_or_close_wnd                   = NULL_FUNC, --�򿪻�ر���壬���������Ż�
		on_user_exit						= NULL_FUNC, --�������
		
        ------------------------------------ϵͳ�¼�--------------------------------
        timer                               = NULL_FUNC, --��ʱ��
        gm_cmd                              = NULL_FUNC, --GM����
        restart_server                      = NULL_FUNC, --����������

		------------------------------------ϵͳ����--------------------------------
		current_time = 0,   --ϵͳ��ǰʱ��
		match_list = {}, --������Ϣ
		user_list = {},  --����б�
		king_list = {
			[1] = {},
			[2] = {},
		},  --����ھ����б�
		king_car_list = {}, --����֮��
		all_zj_info = {
			[1] = {},
			[2] = {},
		},    --�н�����б�
		restart_match_id = {
			[1] = 0,
			[2] = 0,
		}, --���������������¼����ǰ��match_id�Ƕ���
        CFG_GOLD_TYPE = {
            XIA_ZHU = 1,  --��ע
            BAO_MIN = 2,  --����
            JIANG_JIN = 3, --����
            CAR_WIN = 4,   --��Ӯ��Ǯ
            BACK_XIA_ZHU = 5, --�˻���������
        },
		match_start_status = {0, 0}, --�����ǲ��ǿ�ʼ��
		notify_flag = 0, -- ֪ͨ�ͻ���ˢ�½���
		need_notify_proc = 0, --֪ͨ�����б仯
        gm_ctrl = {0, 0},
		CFG_KING_LEN = 10, --���10���ھ���¼
		CFG_TOTALMATCH_TIME = 6*60, --30 * 60,   --�೤ʱ��һ������
		CFG_BAOMING_TIME = 60*2, --10 * 60, --�����׶���Ҫ����ʱ��
		CFG_XZ_TIME = 60*2,      --19 * 60 + 15, --��ע�׶�Ҫ����ʱ��
		CFG_MATCH_TIME = 50, --����������ʱ��
		CFG_LJ_TIME = 60*1,--5, --�����콱�������ʾʱ��
		CFG_CAR_NUM = 8,      --һ��8��������
		CFG_BET_RATE = { -- �ʻ������Ķһ�����
			[1] = 100,
			[2] = 10000,
		},
		CFG_MAX_CAR_LEVEL = 99, --���������99��
		CFG_MAX_GJ_CAR_GOLD = 100000, --�ùھ��������
		CFG_XIAZHU_PM_LEN = 8, --��ע�ý����а񳤶�
		CFG_MATCH_NUM = 2, --һ��2�ֱ���
		CFG_BET_INIT = "0,0,0,0,0,0,0,0", --Ĭ����ע�����
		CFG_BAOMING_GOLD ={   --Ĭ�ϵı�������
			[1] = 5000,
			[2] = 100000,
		},
		CFG_MAX_XZ_GOLD = {   --�����ע
			[1] = 100000,
			[2] = 10000000,
		},
		CFG_MAX_XZ_HUA = {   --�����ע�Ļ�
			[1] = 100000,
			[2] = 100000,
		},
		CFG_MIN_XZ_GOLD = {   --��С��ע
			[1] = 100,
			[2] = 10000,
		},
		king_reward = {    --�ھ��Ľ���
			[1] = 0,
			[2] = 0,
		},
		king_nick = {}, --�ھ����ǳ�
		CFG_TIME_DESC = "10:00-23:00",
		CFG_MAX_CAR_COST = 1000000, --������������
		CFG_RETURN_RATE = 0.8, --������
		CFG_MAX_HUIXIN = 20, --������ֵ
		CFG_CAR_LEVEL = "4,10,28,81",
		CFG_OPEN_TIME = {{},{}}, --����ʱ��
		send_bet_flag = 0, --��������ע�ķ���Ϣ��ʶ
		CFG_BAOXIANG = {
			[1] = "",
			[2] = "",
		},
        CFG_SHIPS_INFO = {
            [5028] = {
                ["cost"] = 8380000,	--��������838W
                ["name"] = "��������",
            },
	        [5029] = {
                ["cost"] = 22800000,	--�ƽ�����2280W
                ["name"] = "�ƽ�����",
            },
            [5023] = {
                ["cost"] = 9347369,  --��ͧ888W
                ["name"] = "��ͧ",
            },
        },
		--  �ͼ������������£�����80������110������140��ѩ����180���׿ǳ�220
    	--	�߼������������£��µ�180������210����ɯ����240��������275����ʱ��300����������360�����ӵ�420
		CFG_CAR_INFO = {
			[5011] = {
				["speed"]=180,
				["cost"]=1880000,
				["name"]="�µ�A8",
			},
			[5012] = {
				["speed"]=220,
				["cost"]=288000,
				["name"]="�׿ǳ�",
			},
			[5013] = {
				["speed"]=80,
				["cost"]=18800,
				["name"]="����",
			},
			[5017] = {
				["speed"]=210,
				["cost"]=2880000,
				["name"]="����",
			},
			[5018] = {
				["speed"]=180,
				["cost"]=78800,
				["name"]="ѩ����",
			},
			[5019] = {
				["speed"]=140,
				["cost"]=33800,
				["name"]="����",
			},
			[5021] = {
				["speed"]=240,
				["cost"]=2800000,
				["name"]="��ɯ����",
			},
			[5022] = {
				["speed"]=110,
				["cost"]=25500,
				["name"]="����qq",
			},
			[5024] = {
				["speed"]=275,
				["cost"]=5880000,
				["name"]="������",
			},
			[5025] = {
				["speed"]=300,
				["cost"]=12800000,
				["name"]="��ʱ��",
			},
			[5026] = {
				["speed"]=360,
				["cost"]=18880000,
				["name"]="��������",
			},
			[5027] = {
				["speed"]=420,
				["cost"]=47600000,
				["name"]="���ӵ�",
			},

		},

		CFG_XZGOLD_MSG = 1000000, --100�򣬵����һ����̨���׻�������ֵ100��ʱ���Ҳ���Ϣ����������Ϣ
		npc_num = {
			[1] = {},
			[2] = {},
		},
		--NPC���壬�ȷ�������ն�����Ƶ������ļ���ȥ
		npc_car ={
			[1] ={
				[1]={
					["user_id"] = -100,
					["nick_name"] = "�����",
					["car_id"] = -100,
					["car_type"] = 5019,
				},
				[2]={
					["user_id"] = -101,
					["nick_name"] = "������",
					["car_id"] = -101,
					["car_type"] = 5022,
				},
				[3]={
					["user_id"] = -102,
					["nick_name"] = "����",
					["car_id"] = -102,
					["car_type"] = 5019,
				},
				[4]={
					["user_id"] = -103,
					["nick_name"] = "��˹����",
					["car_id"] = -103,
					["car_type"] = 5022,
				},
				[5]={
					["user_id"] = -104,
					["nick_name"] = "������",
					["car_id"] = -104,
					["car_type"] = 5019,
				},
				[6]={
					["user_id"] = -105,
					["nick_name"] = "˹ͼ����",
					["car_id"] = -105,
					["car_type"] = 5022,
				},
				[7]={
					["user_id"] = -106,
					["nick_name"] = "�ʹ�",
					["car_id"] = -106,
					["car_type"] = 5019,
				},
				[8]={
					["user_id"] = -107,
					["nick_name"] = "Ī˹",
					["car_id"] = -107,
					["car_type"] = 5022,
				},
				[9]={
					["user_id"] = -108,
					["nick_name"] = "������ķ",
					["car_id"] = -108,
					["car_type"] = 5019,
				},
				[10]={
					["user_id"] = -109,
					["nick_name"] = "����˹��",
					["car_id"] = -109,
					["car_type"] = 5022,
				},
				[11]={
					["user_id"] = -110,
					["nick_name"] = "��˹����",
					["car_id"] = -110,
					["car_type"] = 5019,
				},
				[12]={
					["user_id"] = -111,
					["nick_name"] = "�յٶ�",
					["car_id"] = -111,
					["car_type"] = 5022,
				},
				[13]={
					["user_id"] = -112,
					["nick_name"] = "���ع���",
					["car_id"] = -112,
					["car_type"] = 5019,
				},
				[14]={
					["user_id"] = -113,
					["nick_name"] = "СƤ����",
					["car_id"] = -113,
					["car_type"] = 5022,
				},
				[15]={
					["user_id"] = -114,
					["nick_name"] = "��³��",
					["car_id"] = -114,
					["car_type"] = 5019,
				},
				[16]={
					["user_id"] = -115,
					["nick_name"] = "���ܶ���",
					["car_id"] = -115,
					["car_type"] = 5022,
				},
			},
			[2] ={
				[1]={
					["user_id"] = -200,
					["nick_name"] = "���ܶ���",
					["car_id"] = -200,
					["car_type"] = 5017,
				},
				[2]={
					["user_id"] = -201,
					["nick_name"] = "��³��",
					["car_id"] = -201,
					["car_type"] = 5024,
				},
				[3]={
					["user_id"] = -202,
					["nick_name"] = "СƤ����",
					["car_id"] = -202,
					["car_type"] = 5017,
				},
				[4]={
					["user_id"] = -203,
					["nick_name"] = "���ع���",
					["car_id"] = -203,
					["car_type"] = 5024,
				},
				[5]={
					["user_id"] = -204,
					["nick_name"] = "�յٶ�",
					["car_id"] = -204,
					["car_type"] = 5024,
				},
				[6]={
					["user_id"] = -205,
					["nick_name"] = "˹ͼ����",
					["car_id"] = -205,
					["car_type"] = 5017,
				},
				[7]={
					["user_id"] = -206,
					["nick_name"] = "����˹��",
					["car_id"] = -206,
					["car_type"] = 5024,
				},
				[8]={
					["user_id"] = -207,
					["nick_name"] = "������ķ",
					["car_id"] = -207,
					["car_type"] = 5017,
				},
				[9]={
					["user_id"] = -208,
					["nick_name"] = "������",
					["car_id"] = -208,
					["car_type"] = 5024,
				},
				[10]={
					["user_id"] = -209,
					["nick_name"] = "��˹����",
					["car_id"] = -209,
					["car_type"] = 5017,
				},
				[11]={
					["user_id"] = -210,
					["nick_name"] = "�ʹ�",
					["car_id"] = -210,
					["car_type"] = 5024,
				},
				[12]={
					["user_id"] = -211,
					["nick_name"] = "������",
					["car_id"] = -211,
					["car_type"] = 5017,
				},
				[13]={
					["user_id"] = -212,
					["nick_name"] = "Ī˹",
					["car_id"] = -212,
					["car_type"] = 5024,
				},
				[14]={
					["user_id"] = -213,
					["nick_name"] = "��˹����",
					["car_id"] = -213,
					["car_type"] = 5017,
				},
				[15]={
					["user_id"] = -214,
					["nick_name"] = "����",
					["car_id"] = -214,
					["car_type"] = 5024,
				},
				[16]={
					["user_id"] = -215,
					["nick_name"] = "�����",
					["car_id"] = -215,
					["car_type"] = 5017,
				},
			},
		},
		CFG_MATCH_NAME = {
			[1] = "��ͨ��",
			[2] = "������",
		},
		CFG_GAME_ROOM = 18001, --ֻ���ڵ��ݵ��������������Ĳ���
		CFG_SUPERFANS_LEN = 6, --������˿��ǰ6��
		CFG_TODAYMR_LEN = 10, --��������
		CFG_TODAY_KING_LEN = 10, --���չھ�
		CFG_KINGCAR_LEN = 10, --����֮��
		CFG_WEEK_KING_LEN = 10,
		CFG_HISTORYMR_LEN = 10, --��ʷ����
		superfans_list = {}, --������˿
		today_king_list = {},
		history_minren_list = {},
		today_minren_list = {},
        -----------------------------------���������¼�����------------------------------------
        CFG_PEILV = {
            [1] = {},
            [2] = {},
        },         --des:��λ����
        CFG_WIN_CHANCE = {
            [1] = {},
            [2] = {},
        },    --des:��λ��ʤ����
        CFG_MAX_REWARD = {},    --des:�����䳵�۶�Ӧ����ӳɱ���
        open_wnd_user_list = {}, --�򿪴��ڵ����
    }
end

------------------------------------��������------------------------------------------

--�����ѯ�˷�
function car_match_lib.on_recv_tuifei(buf)
    local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
    car_match_db_lib.tui_fei(user_info)
end

--�յ�����
function car_match_lib.on_recv_baoming(buf)
	local send_baoming_result = function(user_info,result)
	 	netlib.send(function(buf)
        	buf:writeString("CARJOIN");
        	buf:writeInt(result)
        end,user_info.ip,user_info.port);
	end

	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;

   	local car_id = buf:readInt()
   	local area_id = buf:readByte()
   	local match_type = buf:readByte()
   	local baoming_gold = buf:readInt()
   	local car_type = buf:readInt()
   	local user_id = user_info.userId
   	local result = 1

   	-- -1,��λ���������ѱ�������;-2 ����ʱ����ڣ�-3 �������ӵķ��ò��� -4������λ���ϱ�������  0��������Ч������
   	--���쳣�ж�
   	if car_match_lib.match_start_status[match_type] == 0 then return end --�������Чʱֱ�Ӳ�������

   	local need_gold = car_match_lib.get_baoming_gold(match_type,area_id)
    --�õ���������ϵ�Ǯ
    local usergold = get_canuse_gold(user_info)

   	if baoming_gold < need_gold then
   		send_baoming_result(user_info,-1)
   		return
   	end

   	if car_match_lib.match_list[match_type].proccess ~= 1 then
   	   	send_baoming_result(user_info,-2)
   		return
   	end

   	if usergold < need_gold then
   		send_baoming_result(user_info,-3)
   		return
   	end

   	local find = 0
   	for k,v in pairs(car_match_lib.match_list[match_type].match_car_list) do
   		if v.match_user_id == user_id then
   			find = 1
   			break
   		end
   	end

   	if find==1 then
   	   	send_baoming_result(user_info,-4)
   		return
   	end

   	
	if (car_match_sys_ctrl) then
		--car_match_sys_ctrl.update_win_info(match_type, need_gold, car_match_lib.CFG_GOLD_TYPE.BAO_MIN)
	end
   	local return_user_id = car_match_lib.match_list[match_type].match_car_list[area_id].match_user_id
   	local return_chadui = car_match_lib.match_list[match_type].match_car_list[area_id].chadui
   	local return_user_nick = car_match_lib.match_list[match_type].match_car_list[area_id].match_nick_name

    --��Ǯ
    --�����Ͳ�Ӵ�����1��֪ͨ�ͻ��˱����ɹ�
    if return_chadui == 0 then
      if match_type == 1 then
   	    usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH_BAOMING_1, -1);
   	  else
   	    usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH_BAOMING_2, -1);
   	  end
   	else
   	  if match_type == 1 then
   	    usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH_QIANGWEI_1, -1);
   	  else
   	    usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH_QIANGWEI_2, -1);
   	  end
   	end


   	car_match_lib.match_list[match_type].match_car_list[area_id].chadui = car_match_lib.match_list[match_type].match_car_list[area_id].chadui + 1
   	car_match_lib.match_list[match_type].match_car_list[area_id].car_id = car_id
   	car_match_lib.match_list[match_type].match_car_list[area_id].match_user_id = user_id
   	car_match_lib.match_list[match_type].match_car_list[area_id].match_nick_name = user_info.nick
   	car_match_lib.match_list[match_type].match_car_list[area_id].match_user_face = user_info.imgUrl or ""
   	car_match_lib.match_list[match_type].match_car_list[area_id].car_type = car_type
   	car_match_lib.match_list[match_type].match_car_list[area_id].king_count = car_match_lib.user_list[user_id].car_list[car_id].king_count
   	car_match_lib.match_list[match_type].match_car_list[area_id].hui_xin = car_match_lib.user_list[user_id].car_list[car_id].hui_xin
    car_match_lib.match_list[match_type].match_car_list[area_id].jiacheng = car_match_lib.get_jiacheng(user_id, car_id)

   	send_baoming_result(user_info,result)

   	--��ֹ2������ͬʱ���˱��������2��ͬʱ�����������趨Ϊ999
   	if car_match_lib.notify_flag ~= 0 and car_match_lib.notify_flag ~= match_type then
   		car_match_lib.notify_flag = 999
   	else
   		car_match_lib.notify_flag = match_type
   	end

   	--��ͻ������½Ƿ���ʾ��Ϣ
   	local msg_type = 1 --1�����ɹ� 2����λ���� 3 �׻���100��
   	local msg_list = {}
   	if return_user_id==nil or return_user_id==0 then
   		msg_type = 1
   		table.insert(msg_list, user_info.nick)
   		table.insert(msg_list, area_id)
   	else
   		msg_type = 2
   		table.insert(msg_list,user_info.nick)
   		table.insert(msg_list,return_user_nick)
   		table.insert(msg_list, area_id)
   		--֪ͨ�ͻ��˱������
   		local return_user_info = usermgr.GetUserById(return_user_id)
   		if return_user_info~=nil then
   			car_match_lib.send_chadui(return_user_id,match_type)
   		else
   			car_match_db_lib.need_notify_chadui(return_user_id,match_type)
   		end

   		--�˻�����ӵ��˵ı�����
   		car_match_lib.return_baoming_gold(return_user_id,return_chadui,match_type)
   	end

   	car_match_lib.send_all_message(match_type, msg_type, msg_list)

 	--֪ͨ���ݲ㱣�汨������
 	local baoming_num = car_match_lib.match_list[match_type].match_car_list[area_id].chadui or 0
 	local match_id = car_match_lib.match_list[match_type].match_id
 	car_match_db_lib.update_car_baoming(area_id, car_id, user_id, baoming_num, match_type, match_id)
 	car_match_db_lib.record_car_baoming_log(area_id,car_id,user_id,match_id,match_type,baoming_gold)
end

--�յ��򿪲������
function car_match_lib.on_recv_openjoin(buf)
	local get_car_num = function(car_list)
		local len = 0
		for k,v in pairs(car_list)do
			len = len + 1
		end
		return len
	end
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
   	local user_id = user_info.userId
   	local area_id = buf:readByte()
   	local match_type = buf:readByte()
   	local need_gold = 0
   	need_gold = car_match_lib.get_baoming_gold(match_type,area_id)
   	--car_list��Ҫ�����ݲ��ʼ��
   	local car_num = get_car_num(car_match_lib.user_list[user_id].car_list)

   	--�õ����Ա����ź�ά��˹�ĳ�
   	local match_car_list = {}
   	for k,v in pairs(car_match_lib.user_list[user_id].car_list) do

   		if v.car_type~=nil and car_match_lib.CFG_CAR_INFO[v.car_type]~=nil then
			--��������г���������
			if v.car_type ~= 5044 and v.car_type ~= 5045 then
				if (match_type == 1 and car_match_lib.CFG_CAR_INFO[v.car_type].cost < car_match_lib.CFG_MAX_CAR_COST and car_match_lib.CFG_CAR_INFO[v.car_type].cost > 0)
					or (match_type==1 and (car_match_lib.CFG_CAR_INFO[v.car_type].cost == -1 or car_match_lib.CFG_CAR_INFO[v.car_type].cost == -2)) then
					table.insert(match_car_list,v)
				end
				if (match_type==2 and car_match_lib.CFG_CAR_INFO[v.car_type].cost >= car_match_lib.CFG_MAX_CAR_COST and car_match_lib.CFG_CAR_INFO[v.car_type].cost > 0)
					or (match_type==2 and car_match_lib.CFG_CAR_INFO[v.car_type].cost == -3) then
					table.insert(match_car_list,v)
				end
			end
		end
   	end

   	netlib.send(function(buf)
        buf:writeString("CAROPJN");
        buf:writeInt(need_gold)
        buf:writeInt(#match_car_list)

        for k,v in pairs (match_car_list) do
        	buf:writeInt(v.car_id)
        	buf:writeInt(v.car_type)
        	buf:writeInt(v.king_count)
        end
     end,user_info.ip,user_info.port);
end

--�յ������
function car_match_lib.on_recv_openpl(buf)
	local user_info = userlist[getuserid(buf)]
   	if not user_info then return end;
   	local user_id = user_info.userId
   	local match_type = buf:readByte() --�õ�������ID
   	if match_type == 0 then
   		match_type = car_match_lib.get_default_match_type(user_info)
    end

    --���ͳ�����Ϣ
    if (car_match_sj_lib) then
        car_match_sj_lib.send_team_info(user_info)
    end

    local send_func = function()
        --����������Ϣ
        car_match_lib.send_main_box(user_info,match_type)
        --����ʣ��ʱ��
        car_match_lib.send_match_time(user_info,match_type)
        --���ھ��б�
        if (car_match_lib.match_list[match_type].proccess ~= 3) then
            car_match_lib.send_king_list(user_info, match_type)
        end
        --ֻ����8���˷���������ѹ����������ֱ�ӷ����ҵĹھ�����
        if (car_match_lib.match_list[match_type].proccess == 2) then
    		for i = 1, car_match_lib.CFG_CAR_NUM do
    			car_match_lib.send_guanjun_reward(match_type,i)
    		end
    	end
    	--��Ҫ�Ļ��ͷ���һ�ֱ�����ʼ��ʱ��
    	car_match_lib.send_next_match_time(user_info, match_type)
    end
    
     --�����������
    if (car_match_sj_lib) then
        --�жϹر������ڼ��Ƿ�Ҫ������
        car_match_sj_lib.add_off_line_gas(user_id)
        car_match_sj_lib.check_is_new_player(user_id, function(ret)
            if (ret == 1) then
                car_match_lib.send_new_player(user_info)
            else
                send_func()
            end
        end)
    else
        send_func()
    end
end

--�ͻ��˲�ѯ�״̬
--byte 1��Ч -1��������ʱ����� -2������Ч��ʱ�� 0�����쳣
function car_match_lib.on_recv_querystatus(buf)
	local user_info = userlist[getuserid(buf)];
	if not user_info then return end;
	local match_type = buf:readInt()

	local send_result = function(user_info,status)
	   	netlib.send(function(buf)
	        buf:writeString("CARSTAT");
	        buf:writeByte(status);
			buf:writeByte(match_type);
			buf:writeString(_U(car_match_lib.CFG_BAOXIANG[match_type]) or "");
    	end,user_info.ip,user_info.port);
	end
	--�ĳɿͻ��˵�½�ɹ�����Ϊ�ǵ�½�ɹ���
	if match_type == 1 then
  	car_match_db_lib.on_after_user_login(user_info)
  end

    --�ĳɿͻ��˵�½�ɹ�����Ϊ�ǵ�½�ɹ���
    car_match_sj_db_lib.on_after_user_login(user_info)

	--ÿ���������״̬ʱ��˳���������ϢҲ����ȥ
	for i=1,car_match_lib.CFG_MATCH_NUM do
		car_match_lib.send_cfg_info(user_info,i)
		car_match_lib.send_match_time(user_info,i)
	end

	--���֮ǰ�б���ӣ���֪ͨһ���˿�, ֻ��Ҫ֪ͨһ�ξͺ���
    if (match_type == 1) then
	    car_match_db_lib.car_need_notify_msg(user_info.userId)
    end
    --ֻ����ָ����ʱ���ʱ��
    if car_match_lib.match_start_status[match_type] == 0 then
    	send_result(user_info,-2)
    	return
    end
    if car_match_lib.check_time(match_type)==1 then
    	send_result(user_info,1)
    	return
    end
   	--������Чʱ��
   	send_result(user_info,-2)
end

--�ͻ�����ע
--byte -1 ��ע��ʱ -2 ��עʧ�� 1 ��ע�ɹ� -4Ǯ����
function car_match_lib.on_recv_xiazhu(buf)

	local send_result = function (user_info,result)
		netlib.send(function(buf)
	        buf:writeString("CARXZ");
	        buf:writeByte(result);
    	end,user_info.ip,user_info.port);
	end
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
   	local user_id = user_info.userId
   	local area_id = buf:readByte()
   	local bet_count = buf:readInt()
   	local match_type = buf:readByte()

   	--��Ǯ��������ʱ����û�й����쳣��Ϣ
    if (car_match_lib.check_time(match_type) ~= 1 and car_match_lib.match_start_status[match_type] == 0)  or car_match_lib.match_list[match_type].proccess ~= 2 then
    	send_result(user_info,-1)
    	return
    end

    local need_gold = bet_count * car_match_lib.CFG_BET_RATE[match_type]
    --�õ���������ϵ�Ǯ
    local usergold = get_canuse_gold(user_info)
    if usergold < need_gold then
    	send_result(user_info,-4)
    	return
    end

    --С����С��ע
    if need_gold < car_match_lib.CFG_MIN_XZ_GOLD[match_type] then
    	send_result(user_info,-2)
    	return
    end

    --���������ע
	local already_bet = car_match_lib.user_list[user_id].match_info[match_type].bet_num_count or 0
    if (already_bet+bet_count)* car_match_lib.CFG_BET_RATE[match_type] > car_match_lib.CFG_MAX_XZ_GOLD[match_type] then
        send_result(user_info,-3)
    	return
    end

   	--��Ǯ������ע��Ϣ
   	if car_match_lib.user_list[user_id].match_info[match_type].bet_num_count == nil then
   		car_match_lib.user_list[user_id].match_info[match_type].bet_num_count = bet_count
   	else
   		car_match_lib.user_list[user_id].match_info[match_type].bet_num_count = car_match_lib.user_list[user_id].match_info[match_type].bet_num_count + bet_count
   	end

   	--usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH, -1);
   	--��ע��Ϣ
    if match_type == 1 then
      usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH_XIANHUA_1, -1);
    else
      usermgr.addgold(user_id, -need_gold, 0, new_gold_type.CAR_MATCH_XIANHUA_2, -1);
    end
 	  
    if (car_match_sys_ctrl) then
		car_match_sys_ctrl.update_win_info(match_type, need_gold, car_match_lib.CFG_GOLD_TYPE.XIA_ZHU)
	end
   	car_match_lib.update_bet_info(user_id,area_id,bet_count,match_type)

	--�޸�match_list����עλ�õ�����ע���
	if car_match_lib.match_list[match_type].match_car_list[area_id].xiazhu == nil then
		car_match_lib.match_list[match_type].match_car_list[area_id].xiazhu = bet_count
	else
		car_match_lib.match_list[match_type].match_car_list[area_id].xiazhu = car_match_lib.match_list[match_type].match_car_list[area_id].xiazhu + bet_count
	end

	--���2����ͬʱ������ע���Ͱѱ�ʶ�ĳ�999��֪ͨ��ʱ����2��������ע��Ϣ��ˢ��һ��
	if car_match_lib.send_bet_flag ~= 0 and car_match_lib.send_bet_flag ~= match_type then
		car_match_lib.send_bet_flag = 999
	else
		car_match_lib.send_bet_flag = match_type
	end
   	send_result(user_info,1)

   	--дһ����ע��־
   	car_match_db_lib.record_car_xiazhu_log(user_id,area_id,bet_count, car_match_lib.match_list[match_type].match_id, match_type, car_match_lib.user_list[user_id].match_info[match_type].bet_info)

end

--�յ��ͻ��˲�ѯ������Ϣ
function car_match_lib.on_recv_carinfo(buf)
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
   	local user_id = user_info.userId
   	local query_car_list = buf:readString()

   	if query_car_list==nil or query_car_list=="" then return end

	car_match_lib.query_car_info(user_info,query_car_list)

end

--�ͻ���ͷ��ʱ�õ����Ļ���Ҫ��ѯ����һЩ��Ϣ
function car_match_lib.on_recv_carface_info(buf)
	local call_back = function(user_info, car_info, site)
		netlib.send(function(buf)
	    	buf:writeString("CARQTYPE");
	    	buf:writeInt(car_info.car_id)
	    	buf:writeInt(car_info.car_type)
	    	buf:writeInt(car_info.king_count)
	    	buf:writeInt(site)
	    end,user_info.ip,user_info.port);
	end
	local user_info = userlist[getuserid(buf)]
   	if not user_info then return end
   	local user_id = user_info.userId
   	local car_type = buf:readInt()
   	local site = buf:readInt()

	car_match_lib.query_carinfo_by_site(user_id, car_type, site, call_back)
end

--�յ����������
function car_match_lib.on_recv_query_match_mc(buf)
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end;
   	local match_type = buf:readByte()
	car_match_lib.send_match_mc(match_type)
end

--�յ����󷢹ھ���Ϣ
function car_match_lib.on_recv_query_king_info(buf)
	local user_info = userlist[getuserid(buf)];
   	if not user_info then return end
   	local query_user_id = buf:readInt()
    if(duokai_lib and duokai_lib.is_sub_user(query_user_id) == 1) then
        query_user_id = duokai_lib.get_parent_id(query_user_id)
    end
	netlib.send(function(buf)
		buf:writeString("CARKINGIF")
		buf:writeInt(car_match_lib.user_list[query_user_id].match_info[1].total_king_count or 0)
		buf:writeInt(car_match_lib.user_list[query_user_id].match_info[2].total_king_count or 0)
	end, user_info.ip, user_info.port)
end

------------------------------------���緢��------------------------------------------

--�����׶�ʣ��ʱ��
function car_match_lib.send_match_time(user_info,match_type)
	--������û��ʼ���Ͳ�Ҫ������ʱ����
	if car_match_lib.match_start_status[match_type] == 0 then return end
	local current_time = car_match_lib.current_time
	local match_info = car_match_lib.match_list[match_type]
	local remain_time = car_match_lib.get_remain_time(match_type, current_time)
	netlib.send(function(buf)
       buf:writeString("CARTIME"); --֪ͨ�ͻ���
       buf:writeByte(match_info.match_type);
	   buf:writeByte(match_info.proccess);
	   buf:writeInt(remain_time);

	end,user_info.ip,user_info.port)
end

--��ͻ��˷�����֮��
function car_match_lib.send_king_list(user_info, match_type)
	netlib.send(function(buf)
	    buf:writeString("CARCARPM")
	    buf:writeByte(match_type)
	    buf:writeInt(#car_match_lib.king_list[match_type])
	    for i=#car_match_lib.king_list[match_type], 1, -1  do --��Ҫ��������
			buf:writeInt(car_match_lib.king_list[match_type][i].user_id);
	    	buf:writeString(car_match_lib.king_list[match_type][i].nick_name);
	    	buf:writeInt(car_match_lib.king_list[match_type][i].car_id);
	    	buf:writeInt(car_match_lib.king_list[match_type][i].car_type);
	    	buf:writeInt(car_match_lib.king_list[match_type][i].area_id);
	    end
	end,user_info.ip,user_info.port);
end

--����������Ϣ
function car_match_lib.send_main_box(user_info,match_type,not_send_history)
	if match_type==nil then match_type=2 end--Ĭ����ʾ�ڶ�������
	if car_match_lib.match_list[match_type] == nil or car_match_lib.match_list[match_type].proccess==nil then return end
	local user_id = user_info.userId
 	netlib.send(function(buf)
        buf:writeString("CAROPPL");
        buf:writeByte(car_match_lib.match_list[match_type].proccess)
        buf:writeInt(car_match_lib.get_remain_time(match_type, car_match_lib.current_time))
        buf:writeByte(car_match_lib.CFG_CAR_NUM)
        for  i = 1,car_match_lib.CFG_CAR_NUM do
        	  buf:writeByte(i)
        	  buf:writeInt(car_match_lib.match_list[match_type].match_car_list[i].car_id)
        	  --��������С����ģ�������string�����ͻ���
        	  buf:writeString(car_match_lib.match_list[match_type].match_car_list[i].peilv.."")
        	  buf:writeInt(car_match_lib.match_list[match_type].match_car_list[i].xiazhu)
        	  if(car_match_lib.user_list[user_id]==nil)then
        	  	TraceError("��Ҳ�����Ϣ�д���1:")
        	  end
        	  if(car_match_lib.user_list[user_id].match_info==nil)then
        	  	TraceError("��Ҳ�����Ϣ�д���2:")
        	  	TraceError(car_match_lib.user_list[user_id])
        	  end
        	  if(car_match_lib.user_list[user_id].match_info[match_type]==nil)then
        	  	car_match_lib.init_user_match(user_id,match_type)
        	  end

        	  local bet_info = car_match_lib.user_list[user_id].match_info[match_type].bet_info or car_match_lib.CFG_BET_INIT
        	  local bet_tab = split(bet_info,",")
        	  buf:writeInt(tonumber(bet_tab[i]))
        	  --if car_match_lib.match_list[match_type].proccess > 2 and car_match_lib.match_list[match_type].match_car_list[i].mc<1 or car_match_lib.match_list[match_type].match_car_list[i].mc>8 then
        	  --   TraceError("match_type="..match_type.." error mc="..car_match_lib.match_list[match_type].match_car_list[i].mc)
         	  --end

        	  buf:writeInt(car_match_lib.match_list[match_type].match_car_list[i].mc)
        	  buf:writeInt(car_match_lib.match_list[match_type].match_car_list[i].chadui - 1) --Ҫ�ѱ�����ֵ����

        	  --���������ID
        	  local match_user_id = car_match_lib.match_list[match_type].match_car_list[i].match_user_id
        	  local match_nick_name = car_match_lib.match_list[match_type].match_car_list[i].match_nick_name
        	  local match_user_face = car_match_lib.match_list[match_type].match_car_list[i].match_user_face
        	  buf:writeInt(match_user_id or 0)
        	  buf:writeString(match_nick_name or "")
        	  local car_type = car_match_lib.match_list[match_type].match_car_list[i].car_type or 0
        	  local king_count = car_match_lib.match_list[match_type].match_car_list[i].king_count or 0
              local jiacheng = car_match_lib.match_list[match_type].match_car_list[i].jiacheng * 100 or 0
        	  buf:writeInt(car_type)
              buf:writeInt(jiacheng)
        	  buf:writeString(match_user_face or "")
        	  buf:writeInt(king_count)
        end

        --1��1000�������
        local seed = car_match_lib.match_list[match_type].current_rand_num or 1000
        buf:writeInt(seed)
        buf:writeByte(match_type)
        buf:writeInt(car_match_lib.king_reward[match_type])
    end,user_info.ip,user_info.port);

	--���ͳ�ʼ������Ϣ
	if (car_match_lib.match_list[match_type].proccess == 2) then
		for i = 1, car_match_lib.CFG_CAR_NUM do
			car_match_lib.send_guanjun_reward(match_type,i)
		end
	end
    --������˿����
    if (car_match_lib.match_list[match_type].proccess == 3) then
        car_match_lib.send_superfans(user_info, match_type)
    end

    --[[
    if (car_match_lib.match_list[match_type].proccess == 1 and
        car_match_lib.user_list[user_id] ~= nil and
        car_match_lib.user_list[user_id].match_info[match_type] ~= nil and
        car_match_lib.user_list[user_id].match_info[match_type].notify_paihang1 == 0) then
        car_match_lib.user_list[user_id].match_info[match_type].notify_paihang1 = 1
            car_match_lib.send_history(user_info, match_type)
    end
    if (car_match_lib.match_list[match_type].proccess == 2 and
        car_match_lib.user_list[user_id] ~= nil and
        car_match_lib.user_list[user_id].match_info[match_type] ~= nil and
        car_match_lib.user_list[user_id].match_info[match_type].notify_paihang2 == 0) then
        car_match_lib.user_list[user_id].match_info[match_type].notify_paihang2 = 1
            car_match_lib.send_history(user_info, match_type)
    end
    --]]

    if(not_send_history == nil) then
        car_match_lib.send_history(user_info, match_type)
    end

    --��������Ϣ
    if (car_match_sj_lib) then
        car_match_sj_lib.send_team_info(user_info)
    end
end

function car_match_lib.send_history(user_info, match_type)
    --�������˹���
    if (car_match_lib.match_list[match_type].proccess == 1 or car_match_lib.match_list[match_type].proccess == 2) then
        car_match_lib.send_today_minren(user_info, match_type)
    end
    --����ʷ���˹���
    if (car_match_lib.match_list[match_type].proccess == 1 or car_match_lib.match_list[match_type].proccess == 2) then
        car_match_lib.send_history_minren(user_info, match_type)
    end
    --���չھ�����
    if (car_match_lib.match_list[match_type].proccess == 1 or car_match_lib.match_list[match_type].proccess == 2) then
        car_match_lib.send_today_king(user_info, match_type)
    end
    --����֮������
    if (car_match_lib.match_list[match_type].proccess == 1 or car_match_lib.match_list[match_type].proccess == 2) then
        car_match_lib.send_king_car(user_info, match_type)
    end
end

--ȫ���������½ǵ���Ϣ
function car_match_lib.send_all_message(match_type, msg_type, msg_list)
    local user_list = car_match_lib.user_list
    if (msg_type == 1 or msg_type == 2) then
        user_list = car_match_lib.open_wnd_user_list
    end
	for k,v in pairs(user_list) do
		
		local user_id = 0;
		if (type(v) == "number") then
			user_id = v
		else
			user_id = v.user_id
		end
		local user_info = usermgr.GetUserById(user_id)
		if user_info ~= nil then
		 	netlib.send(function(buf)
		    	buf:writeString("CARMSG");
		    	buf:writeByte(match_type)
		    	buf:writeByte(msg_type)
		    	buf:writeByte(#msg_list)
		    	for k1,v1 in pairs(msg_list) do
		    		buf:writeString(v1)
		    	end
		    end,user_info.ip,user_info.port);
	    end
    end
end

--�����½ǵ���Ϣ
function car_match_lib.send_user_message(user_info, match_type, msg_type, msg_list)
 	netlib.send(function(buf)
    	buf:writeString("CARMSG");
    	buf:writeByte(match_type)
    	buf:writeByte(msg_type)
    	buf:writeByte(#msg_list)
    	for k,v in pairs(msg_list) do
    		buf:writeString(v)
    	end
    end,user_info.ip,user_info.port);
end

--�������������Ϣ���ͻ��ˣ�������ʾ
function car_match_lib.send_cfg_info(user_info,match_type)
		netlib.send(function(buf)
	    	buf:writeString("CARCFG");
	    	buf:writeByte(match_type) --match type
	    	buf:writeInt(car_match_lib.CFG_MAX_CAR_COST)  --������������(����) ����ֻ����ʾ�ã��Ȳ�֧��N��������ֻ֧��2��
	    	buf:writeInt(car_match_lib.CFG_BAOMING_GOLD[match_type])  --������
	    	buf:writeInt(car_match_lib.CFG_MAX_XZ_GOLD[match_type])  --�����ע���
	    	buf:writeString(car_match_lib.CFG_CAR_LEVEL) --��������������
	    	buf:writeInt(car_match_lib.CFG_MATCH_TIME)   --��3�׶��ܹ��ж�����
	    	buf:writeString(_U(car_match_lib.CFG_TIME_DESC))   --����ʱ������
	    	buf:writeInt(car_match_lib.CFG_MAX_XZ_HUA[match_type])  --�����ע�Ļ�
	    end,user_info.ip,user_info.port);
end

--����������
function car_match_lib.send_match_mc(match_type)
	local car_list = car_match_lib.match_list[match_type].match_car_list

	for k,v in pairs(car_match_lib.open_wnd_user_list) do
		local user_info = usermgr.GetUserById(v)
		if user_info==nil then return end
		netlib.send(function(buf)
		    buf:writeString("CARMC");
		    buf:writeByte(match_type);
		    buf:writeByte(#car_list);
		    for k1,v1 in pairs (car_list) do
		    	buf:writeInt(v1.mc);
		    	buf:writeInt(v1.car_id);
		    	buf:writeInt(v1.car_type);
		    	buf:writeInt(v1.match_user_id);
		    	buf:writeString(v1.match_nick_name);
		    	buf:writeString(v1.match_user_face);
		    	local car_gold = v1.car_prize or 0

		    	buf:writeInt(car_gold);	--���ļ�ֵ
				buf:writeInt(v1.hui_xin); --����ֵ
				buf:writeInt(v1.king_count); --�ھ�����
				buf:writeInt(v1.xiazhu); --�׻�

		    end
		end,user_info.ip,user_info.port);
	end
end

--ʱ�䵽�ˣ�֪ͨ����
function car_match_lib.send_match_status(match_type, current_time)
	local send_result = function(status)
		for k,v in pairs (car_match_lib.open_wnd_user_list) do
			local user_info = usermgr.GetUserById(v)
			if user_info~=nil then
			   	netlib.send(function(buf)
			        buf:writeString("CARSTAT");
			        buf:writeByte(status);
					buf:writeByte(match_type);
                    buf:writeString(_U(car_match_lib.CFG_BAOXIANG[match_type]) or "");
		    	end,user_info.ip,user_info.port);
		    	car_match_lib.send_match_time(user_info,match_type);

	    	end
    	end
    end

    local total_time = car_match_lib.CFG_TOTALMATCH_TIME / 60;   --һ��������ʱ��
    local table_time = os.date("*t", current_time);
    local now_min = table_time.min
    local times = math.floor(60 / total_time);      --һСʱ�ڿɿ��ĳ���
    for i = 1, times do
        if (now_min == (i * total_time == 60 and 0 or i * total_time)) then
            if (car_match_lib.match_start_status[match_type] == 0 and car_match_lib.check_time(match_type) == 1) then
                car_match_lib.match_start_status[match_type] = 1
                car_match_lib.init_match(match_type, current_time)
                send_result(1)
                return
            end
        end
    end
end

--ʱ�䵽�ˣ�֪ͨ����
function car_match_lib.send_match_status2(current_time, match_type)
	local send_result = function(status)
		for k,v in pairs (car_match_lib.open_wnd_user_list) do
			local user_info = usermgr.GetUserById(v)
			if user_info~=nil then
			   	netlib.send(function(buf)
			        buf:writeString("CARSTAT");
			        buf:writeByte(status);
					buf:writeByte(match_type);
                    buf:writeString(_U(car_match_lib.CFG_BAOXIANG[match_type]) or "");
		    	end,user_info.ip,user_info.port);
	    	end
    	end
	end
    --�����Ч�����Ч��
	if car_match_lib.match_start_status[match_type]==1 and
       car_match_lib.check_time(match_type)==0 then
        car_match_lib.match_start_status[match_type] = 0
        send_result(-2)
        return
    end
end

--����һ����ʼʱ����ͻ���
function car_match_lib.send_next_match_time(user_info, match_type)
	--��������Ѿ���ʼ���Ͳ����ٽ����������
	if car_match_lib.match_start_status[match_type] == 1 then
		return
	end
    local total_time = car_match_lib.CFG_TOTALMATCH_TIME / 60;   --һ��������ʱ��
	local table_time = os.date("*t", car_match_lib.current_time);
	local now_hour = table_time.hour
	local now_min = table_time.min
	local start_hour = ""
	local start_min = ""
    local need_calc = 1
	if (car_match_lib.CFG_OPEN_TIME[match_type][now_hour] ~= nil and
        now_min + total_time <= car_match_lib.CFG_OPEN_TIME[match_type][now_hour][2]) then
        local times = math.floor(60 / total_time);      --һСʱ�ڿɿ��ĳ���
        for i = 1, times do
            if (now_min < i * total_time) then
                start_hour = now_hour;
                start_min = i * total_time;
                if (start_min < car_match_lib.CFG_OPEN_TIME[match_type][now_hour][1]) then
                    start_min = car_match_lib.CFG_OPEN_TIME[match_type][now_hour][1]
                end
                if (start_min < 10) then
			        start_min = "0"..start_min
                end
                need_calc = 0
                break;
            elseif (i == times) then
                need_calc = 1
            end
        end
    end
    if (need_calc == 1) then
        for i = 1, 24 do
            local next_time = (now_hour + i) % 24
            if (car_match_lib.CFG_OPEN_TIME[match_type][next_time] ~= nil) then
                start_hour = next_time;
                start_min = car_match_lib.CFG_OPEN_TIME[match_type][next_time][1];
                if (start_min < 10) then
                    start_min = "0"..start_min
                end
                break;
            end
        end
    end

    --��һ���ݴ���
    local msg = ""
    if start_hour ~= "" and start_min ~= "" then
		msg = _U("�³�����"..start_hour.."��"..start_min.."��ʼ")
    else
        msg = _U("����δ���ţ����Ժ�...")
    end
    netlib.send(function(buf)
        buf:writeString("CARDES")
        buf:writeString(msg)
        buf:writeInt(match_type)
    end,user_info.ip,user_info.port);
end

--��ע�ý����а�
function car_match_lib.send_xiazhu_pm(match_type)
	if car_match_lib.all_zj_info[match_type] == nil then return end
	if(#car_match_lib.all_zj_info[match_type] > 1)then
		table.sort(car_match_lib.all_zj_info[match_type],
		      function(a, b)
			     return a.add_gold > b.add_gold
		end)
	end

	local send_len = #car_match_lib.all_zj_info[match_type]
	if send_len > car_match_lib.CFG_XIAZHU_PM_LEN then
		send_lend = car_match_lib.CFG_XIAZHU_PM_LEN
	end

	--�����´���
	for k,v in pairs (car_match_lib.open_wnd_user_list) do
		local user_info = usermgr.GetUserById(v)
		if user_info~=nil then
		   	netlib.send(function(buf)
		        buf:writeString("CARJCDR");
		        buf:writeByte(match_type)
		        buf:writeInt(send_len);
	            for i=1,send_len do
	            	buf:writeInt(car_match_lib.all_zj_info[match_type][i].user_id) --���ID
	            	buf:writeString(car_match_lib.all_zj_info[match_type][i].nick_name or "")   --����ǳ�
	            	buf:writeString(car_match_lib.all_zj_info[match_type][i].img_url or "")   --���ͷ��
	            	buf:writeInt(car_match_lib.all_zj_info[match_type][i].add_gold or 0) --��ҵõ�Ǯ
	            end
 		    end,user_info.ip,user_info.port);
		end
	end

	for k,v in pairs(car_match_lib.all_zj_info[match_type]) do
		local user_info = usermgr.GetUserById(v.user_id)
		if user_info ~= nil then
			local add_gold = v.add_gold or 0
		   	local msg_type = 4 --1�����ɹ� 2����λ���� 3 �׻���100�� 4.����ע�н����˷���Ϣ
		   	local msg_list = {}
			table.insert(msg_list, add_gold)
			car_match_lib.send_user_message(user_info,match_type,msg_type,msg_list)
			car_match_lib.send_sys_chat_msg(user_info, _U("��ϲ���ڱ���������Ӯ��$")..add_gold)
		end
	end

end

--��������˿�б�
function car_match_lib.send_superfans(user_info, match_type)

	if car_match_lib.superfans_list[match_type] == nil then car_match_lib.superfans_list[match_type] = {} end
	local len = #car_match_lib.superfans_list[match_type]
	if len > car_match_lib.CFG_SUPERFANS_LEN then
		len = car_match_lib.CFG_SUPERFANS_LEN
	end

	netlib.send(function(buf)
		buf:writeString("CARCJFS")
		buf:writeByte(match_type)
		buf:writeInt(len)
		for i = 1, len do
			buf:writeInt(car_match_lib.superfans_list[match_type][i].user_id)
			buf:writeString(car_match_lib.superfans_list[match_type][i].nick_name)
			buf:writeString(car_match_lib.superfans_list[match_type][i].img_url)
			buf:writeInt(car_match_lib.superfans_list[match_type][i].area_id)
			buf:writeInt(car_match_lib.superfans_list[match_type][i].area_bet_count)
		end
	end,user_info.ip,user_info.port)
end

--��������˹���
function car_match_lib.send_today_minren(user_info, match_type)
	if car_match_lib.today_minren_list[match_type] == nil then car_match_lib.today_minren_list[match_type] = {} end
	local len = #car_match_lib.today_minren_list[match_type]
	if len > car_match_lib.CFG_TODAYMR_LEN then
		len = car_match_lib.CFG_TODAYMR_LEN
	end
	netlib.send(function(buf)
		buf:writeString("CARJRMR")
		buf:writeByte(match_type)
		buf:writeInt(len)
		for i = 1, len do
			buf:writeInt(car_match_lib.today_minren_list[match_type][i].user_id)
			buf:writeString(car_match_lib.today_minren_list[match_type][i].nick_name)
			buf:writeString(car_match_lib.today_minren_list[match_type][i].img_url)
			buf:writeInt(car_match_lib.today_minren_list[match_type][i].today_win_gold)
		end
	end,user_info.ip,user_info.port)
end

--������֮������
function car_match_lib.send_king_car(user_info, match_type)
	if car_match_lib.king_car_list[match_type] == nil then car_match_lib.king_car_list[match_type] = {} end
	local len = #car_match_lib.king_car_list[match_type]
	if len > car_match_lib.CFG_KINGCAR_LEN then
		len = car_match_lib.CFG_KINGCAR_LEN
	end
	netlib.send(function(buf)
		buf:writeString("CARKICA")
		buf:writeByte(match_type)
		buf:writeInt(len)
		for i = 1, len do
			buf:writeInt(car_match_lib.king_car_list[match_type][i].user_id)
			buf:writeString(car_match_lib.king_car_list[match_type][i].nick_name)
			buf:writeInt(car_match_lib.king_car_list[match_type][i].car_id)
			buf:writeInt(car_match_lib.king_car_list[match_type][i].car_type)
			buf:writeInt(car_match_lib.king_car_list[match_type][i].king_count)
			buf:writeInt(car_match_lib.king_car_list[match_type][i].car_prize)
		end
	end,user_info.ip,user_info.port)
end

--������ھ�����
function car_match_lib.send_today_king(user_info, match_type)
	if car_match_lib.today_king_list[match_type] == nil then car_match_lib.today_king_list[match_type] = {} end
	local len = #car_match_lib.today_king_list[match_type]
	if len > car_match_lib.CFG_TODAY_KING_LEN then
		len = car_match_lib.CFG_TODAY_KING_LEN
    end

	netlib.send(function(buf)
		buf:writeString("CARJRGJ")
		buf:writeByte(match_type)
		buf:writeInt(len)
		for i = 1, len do
			buf:writeInt(car_match_lib.today_king_list[match_type][i].user_id)
			buf:writeInt(car_match_lib.today_king_list[match_type][i].area_id)
			buf:writeString(car_match_lib.today_king_list[match_type][i].nick_name)
			buf:writeInt(car_match_lib.today_king_list[match_type][i].car_id)
			buf:writeInt(car_match_lib.today_king_list[match_type][i].car_type)
			buf:writeInt(car_match_lib.today_king_list[match_type][i].king_count)
			buf:writeInt(car_match_lib.today_king_list[match_type][i].car_prize)
		end
	end,user_info.ip,user_info.port)
end

--����ʷ���˹���
function car_match_lib.send_history_minren(user_info, match_type)
	if car_match_lib.history_minren_list[match_type] == nil then car_match_lib.history_minren_list[match_type] = {} end
	local len = #car_match_lib.history_minren_list[match_type]
	if len > car_match_lib.CFG_HISTORYMR_LEN then
		len = car_match_lib.CFG_HISTORYMR_LEN
	end
	netlib.send(function(buf)
		buf:writeString("CARLSMR")
		buf:writeByte(match_type)
		buf:writeInt(len)
		for i = 1, len do
			buf:writeInt(car_match_lib.history_minren_list[match_type][i].user_id)
			buf:writeString(car_match_lib.history_minren_list[match_type][i].nick_name)
			buf:writeString(car_match_lib.history_minren_list[match_type][i].img_url)
			buf:writeInt(car_match_lib.history_minren_list[match_type][i].week_win_gold)
		end
	end,user_info.ip,user_info.port)
end

--֪ͨ��ұ������
function car_match_lib.send_chadui(user_id,match_type)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
 	netlib.send(function(buf)
    	buf:writeString("CARCHA");
    	buf:writeByte(match_type)
    end,user_info.ip,user_info.port);

end

--���������˵���ע
function car_match_lib.send_other_bet(match_type)
	if match_type==nil then return end
	for k,v in pairs (car_match_lib.open_wnd_user_list) do
		local user_info = usermgr.GetUserById(v)
		if user_info ~= nil then
		   	netlib.send(function(buf)
		        buf:writeString("CAROTXZ");
		        buf:writeByte(match_type)
		        buf:writeInt(car_match_lib.CFG_CAR_NUM)
		        for i=1,car_match_lib.CFG_CAR_NUM do
		        	buf:writeByte(i)
		        	buf:writeInt(car_match_lib.match_list[match_type].match_car_list[i].xiazhu or 0)
		        	buf:writeString(car_match_lib.match_list[match_type].match_car_list[i].peilv or "")
		        end
		    end,user_info.ip,user_info.port);
	    end
	end
end

--ֻҪ������ע�ˣ���֪ͨ�ͻ����µĹھ�����
function car_match_lib.send_guanjun_reward(match_type,area_id)

	local match_user_id = car_match_lib.match_list[match_type].match_car_list[area_id].match_user_id
	if match_user_id == nil then return end
	local match_user_info = usermgr.GetUserById(match_user_id)
	if match_user_info == nil then return end

	--�ھ�����=��Χ�Ըó�����ע�ܶ�(�׻�����)����Ӧ���ʡ�����ӳɱ���
	local xiazhu = car_match_lib.match_list[match_type].match_car_list[area_id].xiazhu or 0
	local peilv = car_match_lib.match_list[match_type].match_car_list[area_id].peilv
    local car_id = car_match_lib.match_list[match_type].match_car_list[area_id].car_id
	local jiacheng = car_match_lib.match_list[match_type].match_car_list[area_id].jiacheng
	local guanjun_gold = xiazhu * peilv * jiacheng * car_match_lib.CFG_BET_RATE[match_type]
    guanjun_gold = math.floor(guanjun_gold)

	netlib.send(function(buf)
		    buf:writeString("CARCKP");
		    buf:writeByte(match_type)
			buf:writeInt(jiacheng * 100)		--���ͼӳ�
		    buf:writeInt(guanjun_gold) --�ھ�����
		    buf:writeInt(xiazhu) --��ע����
	end, match_user_info.ip, match_user_info.port);

end

--����ϵͳ����
function car_match_lib.send_sys_chat_msg(user_info, msg)
	netlib.send(function(buf)
        buf:writeString("REDC");
        buf:writeByte(4)      --desk chat
        buf:writeString(msg or "")     --text
        buf:writeInt(0)         --user id
        buf:writeString("") --user name
        buf:writeByte(0)
    end,user_info.ip,user_info.port);
end

--���͹ھ���������
function car_match_lib.send_king_gift_des(user_info, match_type)
	netlib.send(function(buf)
		buf:writeString("CARKINGDES")
		buf:writeByte(match_type)
		buf:writeString(car_match_lib.CFG_KING_GIFT_DES[match_type])
	end, user_info.ip, user_info.port)
end

--����2-8����ҵĻ���Ϣ
function car_match_lib.send_other_winner(user_info, jiacheng, add_gold, match_type)
	if user_info == nil then return end
    netlib.send(function(buf)
		buf:writeString("CAROTHERWIN")
		buf:writeInt(jiacheng * 100)
		buf:writeInt(add_gold)
        buf:writeInt(match_type)
	end, user_info.ip, user_info.port)
end

--��������֪ͨ
function car_match_lib.send_new_player(user_info)
    if user_info == nil then return end
    netlib.send(function(buf)
        buf:writeString("OPENPANELNG")
        buf:writeInt(1)
    end, user_info.ip, user_info.port)
end 
------------------------------------�ڲ��ӿ�------------------------------------------
function car_match_lib.check_match_room()
    return tonumber(groupinfo.groupid) == car_match_lib.CFG_GAME_ROOM and 1 or 0;
end

--��ʼ��ĳһ�ֱ���
function car_match_lib.init_match(match_type, match_id)
	if car_match_lib.match_list[match_type] == nil then car_match_lib.match_list[match_type] = {} end
	car_match_lib.match_list[match_type].match_type = match_type --1����2ά��˹
	car_match_lib.match_list[match_type].proccess = 1  --1������� 2�׻� 3���� 4�����    
	car_match_lib.match_list[match_type].start_time = match_id --match_id����current_time
	car_match_lib.match_list[match_type].current_rand_num = car_match_lib.get_rand_num(1, 1000)

	--���֮ǰ�б��������µ�һ�ֿ�ʼʱ���ھ����䣨���ܻ�Ƿ���Ч��Ҫ���ⲽ��
	if car_match_lib.match_list[match_type].open_num == nil then car_match_lib.match_list[match_type].open_num = 0 end
	if car_match_lib.match_list[match_type].open_num ~= 0 then
		car_match_lib.match_list[match_type].open_num = 0
		car_match_lib.give_kingcar_box(match_type)      --������
		car_match_lib.give_other_winner(match_type)     --��2-8������
	end

    --���Чʱ�����ⲽ
	if car_match_lib.match_start_status[match_type] == 1 then
		--match_id̫�� int�ʹ治�£����������10
        match_id = math.floor(match_id / 10)..""..match_type
		car_match_lib.match_list[match_type].match_id = match_id
		--������һ�ֵı���ID����һ�����������Ļ�Ҫ�õ����
		car_match_db_lib.update_last_matchid(match_id, match_type)
    end

	--��ʼ�������ֺ�������Ϣ
	car_match_lib.match_list[match_type].match_car_list = {}
	for i = 1,car_match_lib.CFG_CAR_NUM do
		car_match_lib.match_list[match_type].match_car_list[i] = {}
		car_match_lib.match_list[match_type].match_car_list[i].area_id = i --�����ܵ�
		car_match_lib.match_list[match_type].match_car_list[i].car_id = 0  --���λ���ϵĳ�
		car_match_lib.match_list[match_type].match_car_list[i].peilv = 0   --��ǰ���λ�õ�����
        car_match_lib.match_list[match_type].match_car_list[i].jiacheng = 0   --��ǰ���λ�ó��Ľ���ӳ�
        car_match_lib.match_list[match_type].match_car_list[i].win_chance = 0   --��ǰ���λ�õĻ�ʤ����
		car_match_lib.match_list[match_type].match_car_list[i].xiazhu = 0  --��ǰ���λ�õ���ע
		car_match_lib.match_list[match_type].match_car_list[i].mc = 0      --��ǰ����
		car_match_lib.match_list[match_type].match_car_list[i].chadui = 0  --��Ӵ���
		car_match_lib.match_list[match_type].match_car_list[i].car_type = 0 --���λ��ͣ��ʲô��
		car_match_lib.match_list[match_type].match_car_list[i].king_count = 0 --���λ�õĳ��ù����ι�
		car_match_lib.match_list[match_type].match_car_list[i].hui_xin = 0 --���λ�õĳ��Ļ���ֵ
	end



	--��ʼ����ҵ���ע��Ϣ�ͱ���ID
	for k,v in pairs (car_match_lib.user_list)do
		local match_user_info = usermgr.GetUserById(v.user_id)
		if match_user_info == nil then
			car_match_lib.user_list[v.user_id] = nil
		else
			if car_match_lib.user_list[v.user_id].match_info[match_type] == nil then
	 			car_match_lib.user_list[v.user_id].match_info[match_type] = {}
	 		end
			car_match_lib.user_list[v.user_id].match_info[match_type].bet_num_count = 0
			car_match_lib.user_list[v.user_id].match_info[match_type].bet_info = car_match_lib.CFG_BET_INIT
			car_match_lib.user_list[v.user_id].match_info[match_type].match_id = match_id
			car_match_lib.user_list[v.user_id].match_info[match_type].match_type = match_type
            car_match_lib.user_list[v.user_id].match_info[match_type].notify_paihang1 = 0
            car_match_lib.user_list[v.user_id].match_info[match_type].notify_paihang2 = 0
		end
	end
	--��ʼ������
	car_match_lib.init_peilv(match_type)

	--��ʼ���н���¼
	car_match_lib.all_zj_info[match_type] = {}

	--��ʼ��NPC�ĺ�
	if car_match_lib.npc_num == nil then car_match_lib.npc_num = {} end
	car_match_lib.npc_num[match_type] ={}

	for i=1,#car_match_lib.npc_car[match_type] do
    	table.insert(car_match_lib.npc_num[match_type],i)
	end

	--��ʼ��������˿����Ϣ
	car_match_lib.superfans_list[match_type] = {}

end

--���ݲ�����8�����޸�8��λ�õ����ʼ�Ӯ��
function car_match_lib.init_peilv(match_type)
	--��ʼ��8��λ�õ�����
	local car_box = car_match_lib.match_list[match_type].match_car_list
    --����match_type������������
    for i=1,#car_box do
        car_match_lib.match_list[match_type].match_car_list[i].peilv = car_match_lib.CFG_PEILV[match_type][i]
        car_match_lib.match_list[match_type].match_car_list[i].win_chance = car_match_lib.CFG_WIN_CHANCE[match_type][i]
    end
end

--��ʼ����ҵı�����Ϣ
function car_match_lib.init_user_match(user_id,match_type)
	if car_match_lib.user_list[user_id].match_info[match_type] == nil then
		car_match_lib.user_list[user_id].match_info[match_type] = {}
	end
	car_match_lib.user_list[user_id].match_info[match_type].bet_info = car_match_lib.CFG_BET_INIT
	car_match_lib.user_list[user_id].match_info[match_type].match_id = car_match_lib.match_list[match_type].match_id
	car_match_lib.user_list[user_id].match_info[match_type].match_type = match_type

end

--��ʼ����ҵĹھ���Ϣ
function car_match_lib.init_user_king_info(user_id)
    if (car_match_lib.user_list[user_id] == nil) then return end
	if car_match_lib.user_list[user_id].match_info == nil then 	car_match_lib.user_list[user_id].match_info = {} end
	if car_match_lib.user_list[user_id].match_info[1] == nil then 	car_match_lib.user_list[user_id].match_info[1] = {} end
	if car_match_lib.user_list[user_id].match_info[2] == nil then 	car_match_lib.user_list[user_id].match_info[2] = {} end

	car_match_lib.user_list[user_id].match_info[1].total_king_count = 0
	car_match_lib.user_list[user_id].match_info[2].total_king_count = 0
	for k,v in pairs(car_match_lib.user_list[user_id].car_list) do
   		if v.car_type~=nil and car_match_lib.CFG_CAR_INFO[v.car_type]~=nil then
	   		if car_match_lib.CFG_CAR_INFO[v.car_type].cost < car_match_lib.CFG_MAX_CAR_COST then
	   			car_match_lib.user_list[user_id].match_info[1].total_king_count = car_match_lib.user_list[user_id].match_info[1].total_king_count + v.king_count
	   		else
	   			car_match_lib.user_list[user_id].match_info[2].total_king_count = car_match_lib.user_list[user_id].match_info[2].total_king_count + v.king_count
	   		end
		end
   	end
end

--��ʼ��������˿��Ϣ
function car_match_lib.init_super_fans_list(match_type)
   	--������˿�����ÿ�ֶ���һ�������Բ���д���ݿ�
   	if car_match_lib.superfans_list[match_type] == nil then car_match_lib.superfans_list[match_type] = {} end

   	for k, v in pairs (car_match_lib.user_list) do
   		local bet_info = v.match_info[match_type].bet_info or car_match_lib.CFG_BET_INIT
   		local area_bet_count_tab = split(bet_info, ",")
   		for i = 1, #area_bet_count_tab do
	   		local area_bet_count = tonumber(area_bet_count_tab[i])
	   		if area_bet_count>0 then
		   		local buf_tab = {
			   		["user_id"] = v.user_id,
			   		["nick_name"] = v.nick_name,
			   		["img_url"] = v.img_url,
			   		["area_id"] = i,
			   		["area_bet_count"] = area_bet_count,
			   	}
			   	table.insert(car_match_lib.superfans_list[match_type], buf_tab)
		    end
   		end

   	end

   	if #car_match_lib.superfans_list[match_type] > 1 then
		table.sort(car_match_lib.superfans_list[match_type],
		      function(a, b)
			     return a.area_bet_count > b.area_bet_count
		end)
	end
end

--ͨ������ID���ұ�����Ϣ
function car_match_lib.get_match_by_id(match_id)
	for k,v  in pairs(car_match_lib.match_list) do
		if v.match_id == match_id then
			return v
		end
	end
end

--�õ���������
function car_match_lib.get_match_mc(match_type)
	local get_tab_index = function(list_table,index)
		local i = 1
		for k,v in pairs(list_table) do
			if index == i then
				return v
			end
			i = i + 1
		end
	end

    local get_mc = function(car_box)
		local win_chance = {}
        local total_chance = 0
		for k, v in pairs(car_box) do
            local tmp_chance = v.win_chance * 10
            table.insert(win_chance, tmp_chance)
            total_chance = total_chance + tmp_chance
        end
		local rand_num = car_match_lib.get_rand_num(1, total_chance)
		local tmp_num = win_chance[1]
		for i=1,#win_chance do
			if (i > 1) then
			    tmp_num = tmp_num + win_chance[i]
			end
            if rand_num <= tmp_num then
				local tmp_car = get_tab_index(car_box,i)
				return tmp_car.area_id
            end
		end
	end

	--�Ѳ������ŵ�Ҫ���������ĺ�����(���⣩
	local car_box = table.clone(car_match_lib.match_list[match_type].match_car_list)
	local mc = {}

	--�õݹ��㷨 �õ�������������
	for i = 1,car_match_lib.CFG_CAR_NUM do
		--mc[1]=2�����1��������2���ܵ��ĳ���mc[2]=4�����2������4���ܵ��ĳ�����������
		local tmp_area_id = get_mc(car_box)
		table.insert(mc, tmp_area_id)

		--��car_box������ų���һ���ĳ���Ȼ������car_boxȥ�ŵ�1��
		for k1,v1 in pairs(car_box)do
			if v1.area_id == mc[i] then
				car_box[k1] = nil
				break
			end
		end
	end

	--���²�����8��λ�õ�������Ϣ
	for i = 1, #mc do
		local area_id=mc[i]
		car_match_lib.match_list[match_type].match_car_list[area_id].mc = i
		if i == 1 then
			car_match_lib.match_list[match_type].open_num = area_id
		end
	end

end

--ͨ�������ͺŵõ������ٶ�
function car_match_lib.get_speed(car_type)
	if car_type==nil or car_type== 0 then return 0 end
	return car_match_lib.CFG_CAR_INFO[car_type].speed
end

--�õ�NPC�ĳ�����Ϣ
function car_match_lib.get_npc_car_info(car_info,call_back)
	if call_back==nil then return end
	local car_list_tab = split(car_info,",")
	local buf_tab_list = {}

	for k,v in pairs(car_match_lib.npc_car) do
		for k1,v1 in pairs(v) do
			for k2,v2 in pairs(car_list_tab)do
				if v1.car_id == tonumber(v2) then
					local buf_tab = {}
					buf_tab.user_id = v1.user_id
					buf_tab.nick_name = _U(v1.nick_name)
					buf_tab.car_id = v1.car_id
					buf_tab.car_type = v1.car_type
					buf_tab.hui_xin = v1.hui_xin or 0
					buf_tab.king_count = v1.king_count or 0
					buf_tab.is_using = 1
					buf_tab.cansale = 0
					local car_gold = car_match_lib.get_car_cost(v1.car_type)
					buf_tab.car_prize = car_gold or 0
                    local jiacheng = car_match_lib.get_jiacheng_by_prize(car_gold)
                    buf_tab.jiacheng = jiacheng --����ӳ�
					table.insert(buf_tab_list,buf_tab)
					call_back(buf_tab_list)
					return --��ʱNPCֻ��һ����������ֻҪ�ҵ���ֱ��return�ˡ�
				end
			end
		end
	end
end

--�õ���ǰ�׶ε�ʣ��ʱ��
function car_match_lib.get_remain_time(match_type, current_time)
	local match_info = car_match_lib.match_list[match_type]
    if (match_info == nil) then return end;
	local use_time = current_time - match_info.start_time --�������˶���ʱ��
	local remain_time = 0
	--����ʣ��ʱ��
	if use_time < car_match_lib.CFG_BAOMING_TIME then
		remain_time = car_match_lib.CFG_BAOMING_TIME - use_time
	elseif use_time < car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME then
		remain_time = car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME - use_time
	elseif use_time < car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME + car_match_lib.CFG_MATCH_TIME then
		remain_time = car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME + car_match_lib.CFG_MATCH_TIME - use_time
	elseif use_time < car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME + car_match_lib.CFG_MATCH_TIME + car_match_lib.CFG_LJ_TIME then
		remain_time = car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME + car_match_lib.CFG_MATCH_TIME + car_match_lib.CFG_LJ_TIME - use_time
	end

	if car_match_lib.check_time(match_type)~=1 and car_match_lib.match_start_status[match_type]==0 then
		remain_time=-1
	end
	return remain_time
end

--��΢����һ��LUA������㷨����ֹ �����ҵ�����
function car_match_lib.get_rand_num(min_num, max_num)
		local buf_tab = {}
		for i = 1, 100 do
			table.insert(buf_tab, math.random(min_num, max_num))
        end
		return buf_tab[math.random(10, 80)]
end

--ͨ������ȡ�øó��Ľ��𼰼ӳɷ�Χ
function car_match_lib.get_jiacheng_by_prize(car_prize)
    for k, v in pairs(car_match_lib.CFG_MAX_REWARD) do
        if (car_prize >= v.min and car_prize <= v.max) then
            return tonumber(k)
        end
    end
end

--ͨ��usͨ��userid��caridȡ���ۼӳ�
function car_match_lib.get_jiacheng(user_id, car_id)
    local car_prize = car_match_lib.get_user_car_prize(user_id, car_id)         --ͨ��userid��caridȡ����
    local jiacheng = car_match_lib.get_jiacheng_by_prize(car_prize)				    --������Ӧ����ӳ�
	return jiacheng
end

--�õ���������
function car_match_lib.get_car_name(car_type)
	return car_match_lib.CFG_CAR_INFO[car_type].name
end

--�õ��������ļ۸�
function car_match_lib.get_car_cost(car_type)
	return car_match_lib.CFG_CAR_INFO[car_type].cost
end

--�õ���ҳ��ļ۸�
function car_match_lib.get_user_car_prize(user_id, car_id)
    if (car_match_lib.user_list[user_id] ~= nil and car_match_lib.user_list[user_id].car_list[car_id] ~= nil) then
        return car_match_lib.user_list[user_id].car_list[car_id].car_prize
    else
        return 0
    end
end

--�õ�����������
function car_match_lib.get_match_name(match_type)
	return car_match_lib.CFG_MATCH_NAME[match_type]
end

--�õ�����������Ҫ��Ǯ
function car_match_lib.get_baoming_gold(match_type,area_id)
	--���ݱ������ͺ�λ�ü���ع�ʽ��������λ��Ҫ���ٱ�����
	local baoming_gold = car_match_lib.CFG_BAOMING_GOLD[match_type]
	local chadui_num = car_match_lib.match_list[match_type].match_car_list[area_id].chadui or 0
	local chadui_gold = baoming_gold * math.pow(2,chadui_num)
	local need_gold = baoming_gold + chadui_gold
	if chadui_num == 0 then
		need_gold = baoming_gold
	end
    return need_gold
end

--�õ�ĳ�����Ĭ�ϵ�match_type
function car_match_lib.get_default_match_type(user_info)
	local match_type = 1
	--����10��Ĭ��Ϊȥά��˹��
	if user_info.gamescore >= 100000 then
		match_type = 2
    end
    --ֻҪ��һ�������ˣ���ѡ��Ĭ�ϴ��Ѿ�������tab
    if (car_match_lib.check_time(1) == 1 and car_match_lib.check_time(2) ~= 1) then
        match_type = 1
    end
    if (car_match_lib.check_time(2) == 1 and car_match_lib.check_time(1) ~= 1) then
        match_type = 2
    end
	return match_type
end

--��NPC�б��г�ȡһ��NPC����
function car_match_lib.get_npc_num(match_type)
	local npc_count = #car_match_lib.npc_num[match_type]
	local rand_num = math.random(1,npc_count or 8) --��һ��NPC
	local tmp_num = car_match_lib.npc_num[match_type][rand_num]
	if(tmp_num==nil)then
		TraceError("NPC��ȡ�㷨�����ˣ�")
		TraceError(car_match_lib.npc_num[match_type])
	end

	table.remove(car_match_lib.npc_num[match_type], rand_num)
	return tmp_num
end

function car_match_lib.get_all_bet_info(match_type)
    local all_bet_info = {}
        --ȡ����������ע
    for k, v in pairs(car_match_lib.user_list) do
        local bet_info = v.match_info[match_type].bet_info or car_match_lib.CFG_BET_INIT
        local tmp_bet_tab = split(bet_info,",")
        local all_bet = 0
        for i = 1, #tmp_bet_tab do
            all_bet = all_bet + tmp_bet_tab[i]
        end
        all_bet = all_bet * car_match_lib.CFG_BET_RATE[match_type]
        if (all_bet > 0) then
            all_bet_info[v.user_id] = {}
            all_bet_info[v.user_id].bet = all_bet
            all_bet_info[v.user_id].add_gold = 0
        end
    end
    --ȡ�������н���
    for k, v in pairs (car_match_lib.all_zj_info[match_type]) do
        if (v.user_id ~= nil and all_bet_info[v.user_id] ~= nil) then 
            all_bet_info[v.user_id].add_gold = v.add_gold
        end
    end
    return all_bet_info
end

--���õ�ǰ�ڵڼ��׶�
function car_match_lib.set_proccess(match_info,current_time)
	--���������Чʱ�䣬���һ�û����ڶ��׶Σ��Ͳ��ٸı����Ľ׶�
	--Ŀ�ģ���δ�����ı������ټ��������ѿ����ı������꣬Ȼ���ټ���
	if car_match_lib.match_start_status[match_info.match_type] == 0 and  match_info.proccess == 1 then
		return
    end
    --��������Ч����Ч,Ŀǰ��2�ֱ�����ʱ�䲻һ�£�
    if match_info.proccess == 4 then
        car_match_lib.send_match_status2(current_time, match_info.match_type) 
        --todo
        --��Ѿ���Ч��
        if car_match_lib.match_start_status[match_info.match_type] == 0 then
    		car_match_lib.init_match(match_info.match_type, current_time)
			car_match_lib.need_notify_proc = 1
        end   
    end
	--������ڳ���һ�ֱ�����ʱ��,���һ��Ч���ͳ�ʼ��������Ϣ
    if (car_match_lib.check_time(match_info.match_type) == 1 and
        current_time >= match_info.start_time + car_match_lib.CFG_TOTALMATCH_TIME) then
        car_match_lib.init_match(match_info.match_type, current_time)
        car_match_lib.need_notify_proc = 1
	--�����ǰʱ����ڱ���ʱ���ˣ������ý�����һ�׶�
	elseif match_info.proccess < 2 and current_time >= match_info.start_time + car_match_lib.CFG_BAOMING_TIME then
        match_info.proccess = 2
		car_match_lib.need_notify_proc = 1

		--�����׶����ˣ�������г�λû�������ͼ�NPC
		car_match_lib.add_npc(match_info.match_type)

		--ȫ��֪ͨ�����׻���
		if match_info.match_type == 1 then
			BroadcastMsg(_U("���������ѽ�����������������ȫ����������������֧������Ŀ�еĹھ���"),0)
		end
	--�����ǰʱ�������עʱ���ˣ������ý�����һ�׶�
	elseif match_info.proccess < 3 and current_time >= match_info.start_time + car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME then
        match_info.proccess = 3
		car_match_lib.need_notify_proc = 1
		--�õ�������˿���б�
		xpcall(function() car_match_lib.init_super_fans_list(match_info.match_type) end, throw)
		--���gmû�п��ƣ����Զ�����
        if (car_match_lib.gm_ctrl == nil) then
			car_match_lib.gm_ctrl = {0,0}
		end
  		--��������׶Σ�������������β�֪ͨ�ͻ���
   		car_match_lib.get_match_mc(match_info.match_type)
        --����ɱ��
        if (car_match_sys_ctrl) then
            xpcall(function() car_match_sys_ctrl.on_process2_end(match_info.match_type) end, throw)
        end
        car_match_lib.gm_ctrl[match_info.match_type] = 0
	--�����ǰʱ����ڱ���ʱ���ˣ������ý�����һ�׶�
	elseif match_info.proccess < 4 and current_time >= match_info.start_time + car_match_lib.CFG_BAOMING_TIME + car_match_lib.CFG_XZ_TIME + car_match_lib.CFG_MATCH_TIME then
		match_info.proccess = 4
		car_match_lib.need_notify_proc = 1

        --��һ�׶���Ҫ�������ߺ��׻����˷���
		car_match_lib.match_fajiang(match_info.match_type)
		car_match_lib.xiazhu_fajiang(match_info.match_type)

        --������ע���н���Ϣ
        local all_bet_info = car_match_lib.get_all_bet_info(match_info.match_type)

		--���¹ھ���һЩ��Ϣ
		car_match_lib.update_guanjun_info(match_info.match_type)

        --��һ�±�����Ϣ
        car_match_db_lib.clear_baoming()
		--���׻��ý����а�
		car_match_lib.send_xiazhu_pm(match_info.match_type)
		if (car_match_sys_ctrl) then
			car_match_sys_ctrl.on_round_over(match_info.match_type)
		end
		if match_info.match_type == 1 or match_info.match_type == 2 then
        	eventmgr:dispatchEvent(Event("after_car_match_event", {match_type = match_info.match_type, car_list = car_match_lib.match_list[match_info.match_type].match_car_list, open_num = car_match_lib.match_list[match_info.match_type].open_num, all_bet_info = all_bet_info}))
        end
	end

	--�����б仯�ˣ���Ҫ֪ͨ�ͻ���
	if car_match_lib.need_notify_proc == 1  then
		car_match_lib.need_notify_proc = 0
		for k,v in pairs (car_match_lib.open_wnd_user_list) do
			local user_info = usermgr.GetUserById(v)
			if user_info ~= nil then
				--�ȷ�ʣ��ʱ���ٷ��������Ϣ
				car_match_lib.send_main_box(user_info, match_info.match_type)
				car_match_lib.send_match_time(user_info, match_info.match_type)
                if car_match_lib.match_start_status[match_info.match_type] == 0 then
                    car_match_lib.send_next_match_time(user_info, match_info.match_type)
                end
				--�����ʱ��Ҫ���µĹھ��б�֪ͨ�ͻ���
				if match_info.proccess == 4 then
					car_match_lib.send_king_list(user_info, match_info.match_type)
				end
			end
		end
        --todo����һ��ð���Э��
    end
end

--����NPC
function car_match_lib.add_npc(match_type)
	for k,v in pairs (car_match_lib.match_list[match_type].match_car_list) do
		local rand_num = car_match_lib.get_npc_num(match_type) or 1
		if v.car_id==0 then --������λ����û�г��������ͼ�NPC
			v.car_id = car_match_lib.npc_car[match_type][rand_num].car_id
			v.car_type = car_match_lib.npc_car[match_type][rand_num].car_type
			v.match_user_id = car_match_lib.npc_car[match_type][rand_num].user_id
			v.match_nick_name = _U(car_match_lib.npc_car[match_type][rand_num].nick_name)
			v.match_user_face = "face/1025.jpg" --NPC��ͷ��Ҫ��ôŪ��todo
			v.king_count = car_match_lib.npc_car[match_type][rand_num].king_count or 0
			v.hui_xin = car_match_lib.npc_car[match_type][rand_num].hui_xin or 0
			v.jiacheng = car_match_lib.get_jiacheng_by_prize(car_match_lib.get_car_cost(v.car_type))
		end
	end

	--֪ͨ�ͻ��˱仯��������Ϣ
	--for k,v in pairs(car_match_lib.user_list) do
	for k,v in pairs(car_match_lib.open_wnd_user_list) do
		local user_info = usermgr.GetUserById(v)
		if user_info ~= nil and car_match_lib.user_list[v] ~= nil and 
				car_match_lib.user_list[v].match_info ~= nil and car_match_lib.user_list[v].match_info.match_type == match_type then
			car_match_lib.send_main_box(user_info, match_type, 1)
		end
	end
end

--���ʱ��
function car_match_lib.check_time(match_type)
	local table_time = os.date("*t",car_match_lib.current_time);
	local now_hour  = tonumber(table_time.hour);
    local now_min  = tonumber(table_time.min);
    if (car_match_lib.CFG_OPEN_TIME[match_type][now_hour] ~= nil and
        now_min >= car_match_lib.CFG_OPEN_TIME[match_type][now_hour][1]  and
        now_min <= car_match_lib.CFG_OPEN_TIME[match_type][now_hour][2]) then
        return 1
    end
	return 0
end

--�鳵����Ϣ
function car_match_lib.query_car_info(user_info,query_car_list)
   	if not user_info then return end
   	local user_id = user_info.userId

   	if query_car_list==nil or query_car_list=="" then return end

	local call_back = function(car_list)
		netlib.send(function(buf)
		    buf:writeString("CARQUERY");
		    buf:writeInt(#car_list);
		    for k,v in pairs (car_list) do
		    	buf:writeInt(v.car_id);
		    	buf:writeInt(v.car_type);
		    	buf:writeInt(v.user_id);
		    	buf:writeString(v.nick_name);
		    	local car_gold = v.car_prize or 0
		    	buf:writeInt(car_gold); --���ļ۸�
				buf:writeInt(v.hui_xin); --����ֵ
				buf:writeInt(v.king_count); --�ھ�����
                buf:writeInt((v.jiacheng or 0) * 100); --����ӳ�
		    end
		end,user_info.ip,user_info.port);
	end

   	local car_list_tab = split(query_car_list,",")

   	--��Ϊ���ݲ��õ���in�����Լ������Ʒ�ֹһ���Բ�̫��Ӱ������
   	if #car_list_tab > 10 then return end

   	--��NPC�ĳ�����Ϣֻ��һ��һ���飬���⣬��ʱ��֧�ֻ�Ͳ�ѯ
   	local is_npc = 0
   	if  #car_list_tab==1 and tonumber(car_list_tab[1]) < 0 then
		is_npc = 1
   	end

   	if  is_npc == 1 then
   		car_match_lib.get_npc_car_info(query_car_list,call_back)
   	else
   		car_match_db_lib.get_car_list(query_car_list,call_back)
   	end

end

--������λ�鳵��Ϣ
function car_match_lib.query_carinfo_by_site(user_id, car_type, site, call_back)
   	--������ǳ��Ļ��Ͳ�������Ϣ
   	if car_match_lib.CFG_CAR_INFO[car_type] == nil then return end

   	--�����ݿ��ѯ��Ϣ������
   	car_match_db_lib.query_carinfo_by_type(user_id, car_type, site, call_back)
end

--���¹ھ�������Ϣ
function car_match_lib.update_guanjun_info(match_type)
	local call_back = function(user_info, car_info, site)
		netlib.send(function(buf)
	    	buf:writeString("CARQTYPE");
	    	buf:writeInt(car_info.car_id)
	    	buf:writeInt(car_info.car_type)
	    	buf:writeInt(car_info.king_count)
	    	buf:writeInt(site)
	    end,user_info.ip,user_info.port);
	end

	for k,v in pairs(car_match_lib.match_list[match_type].match_car_list)do

		local car_id = v.car_id
		local match_user_id = v.match_user_id
		local match_user_info = usermgr.GetUserById(match_user_id)
		local nick_name = v.match_nick_name
		local car_type = v.car_type
        local car_prize = 0;
        if (match_user_id > 0) then --�ھ�Ϊ���
            car_prize = car_match_lib.get_user_car_prize(match_user_id, car_id)
        else
            car_prize = car_match_lib.get_car_cost(car_type)    --�ھ�ΪNPC
        end
		if(match_user_id==nil)then
			TraceError("�ùھ����˲��ǲ����ߣ���")
			TraceError(v)
		end
		--��һ��д���ھ��б���ȥ
		--���ھ����ӹھ�����
		if v.mc == 1 then
			v.king_count = v.king_count + 1
            car_match_lib.init_user_king_info(match_user_id)
			local buf_tab = {
				["area_id"] = k2,
				["user_id"] = match_user_id,
				["nick_name"] = nick_name,
				["car_id"] = car_id,
				["car_type"] = car_type,
				["area_id"] = car_match_lib.match_list[match_type].open_num,
				["king_count"] = v.king_count,
				["car_prize"] = car_prize,
			}
			--��ʷ�ھ�
			for k, v in pairs(car_match_lib.king_list[match_type]) do
				if v.car_id == car_id then
					v.king_count = buf_tab.king_count
				end
			end
			if #car_match_lib.king_list[match_type] < car_match_lib.CFG_KING_LEN then
				table.insert(car_match_lib.king_list[match_type], buf_tab)
			else
				table.remove(car_match_lib.king_list[match_type], 1)
				table.insert(car_match_lib.king_list[match_type], buf_tab)
			end
			--���չھ�
			for k, v in pairs(car_match_lib.today_king_list[match_type]) do
				if v.car_id == car_id then
					v.king_count = buf_tab.king_count
				end
			end
			if #car_match_lib.today_king_list[match_type] < car_match_lib.CFG_TODAY_KING_LEN then
				table.insert(car_match_lib.today_king_list[match_type], buf_tab)
			else
				table.remove(car_match_lib.today_king_list[match_type], 1)
				table.insert(car_match_lib.today_king_list[match_type], buf_tab)
            end

            if (match_user_id > 0) then
			    car_match_db_lib.add_king_list(match_type, buf_tab)
            end

			if match_user_info~=nil and car_match_lib.user_list[match_user_id].car_list[car_id] ~= nil then --�����һ����ߣ����ҳ�û������
				car_match_lib.user_list[match_user_id].car_list[car_id].king_count = car_match_lib.user_list[match_user_id].car_list[car_id].king_count + 1
				car_match_lib.user_list[match_user_id].car_list[car_id].hui_xin = 0
			elseif match_user_id < 0 then --NPC�ùھ�
				for k1,v1 in pairs (car_match_lib.npc_car[match_type]) do
					if v1.user_id == match_user_id then
						v1.king_count = v.king_count
						v1.hui_xin = 0
					end
				end
			end

			--֪ͨ���ݿ����Ҽ�һ�ιھ�����
            if (match_user_id > 0) then
			    car_match_db_lib.add_king_count(car_id)
            end

			--����֮��
			car_match_lib.update_king_car_list(match_type, buf_tab)

			for k1,v1 in pairs (car_match_lib.match_list[match_type].match_car_list) do
				local user_info = usermgr.GetUserById(v1.match_user_id)
				if user_info ~= nil then
					car_match_lib.query_car_info(user_info, car_id)
				end
			end

			--���õùھ����˵��ǳ�
			car_match_lib.king_nick[match_type] = nick_name

			--�����������ʱ���ĳ��ĳɾ�
			if match_user_info ~= nil and match_user_info.site ~= nil then
				--�ĳɸ����ڵ���Ⱥ���ھ�������Ϣ
				--car_match_lib.query_carinfo_by_site(match_user_id, car_type, match_user_info.site, call_back)
				car_match_lib.refresh_using_king_count(match_user_id)
			end

			--��¼���ݿ���־
			car_match_db_lib.record_car_car_match_log(match_user_id, car_match_lib.match_list[match_type].open_num, car_match_lib.match_list[match_type].match_id, match_type, car_id)
			
		else
			if v.hui_xin < car_match_lib.CFG_MAX_HUIXIN then
				v.hui_xin = v.hui_xin + 1
				if match_user_info~=nil and car_match_lib.user_list[match_user_id].car_list[car_id] ~= nil then
					car_match_lib.user_list[match_user_id].car_list[car_id].hui_xin = car_match_lib.user_list[match_user_id].car_list[car_id].hui_xin + 1
				elseif match_user_id < 0 then
					for k1,v1 in pairs (car_match_lib.npc_car[match_type]) do
						if v1.user_id == match_user_id then
							v1.hui_xin = v.hui_xin
						end
					end
				end
				car_match_db_lib.add_hui_xin(car_id)
			end
		end
	end

	--����ھ������ˣ��ͷ�С����
	if car_match_lib.king_nick[match_type] ~= nil then
    	local msg = _U("��ϲ")..car_match_lib.king_nick[match_type].._U("���").._U(car_match_lib.CFG_MATCH_NAME[match_type]).._U("�ھ����³���������������ʼ")
    	tex_speakerlib.send_sys_msg(msg)
    	car_match_lib.king_nick[match_type] = nil
    end
end

--�������˺���ʷ����
function car_match_lib.update_minren_list(user_id, match_type, buf_tab)
		local add_gold = buf_tab.add_gold
		if car_match_lib.user_list[user_id].match_info[match_type].today_win_gold == nil then car_match_lib.user_list[user_id].match_info[match_type].today_win_gold = 0 end
		if car_match_lib.user_list[user_id].match_info[match_type].week_win_gold == nil then car_match_lib.user_list[user_id].match_info[match_type].week_win_gold = 0 end

		car_match_lib.user_list[user_id].match_info[match_type].today_win_gold = car_match_lib.user_list[user_id].match_info[match_type].today_win_gold + add_gold
		car_match_lib.user_list[user_id].match_info[match_type].week_win_gold = car_match_lib.user_list[user_id].match_info[match_type].week_win_gold + add_gold
		buf_tab.today_win_gold = car_match_lib.user_list[user_id].match_info[match_type].today_win_gold
		buf_tab.week_win_gold = car_match_lib.user_list[user_id].match_info[match_type].week_win_gold
		if car_match_lib.today_minren_list[match_type] == nil then car_match_lib.today_minren_list[match_type] = {} end


		local tmp_index = #car_match_lib.today_minren_list[match_type]
		local finder = 0
		for k, v in pairs (car_match_lib.today_minren_list[match_type]) do
			if v.user_id == buf_tab.user_id then
				v.today_win_gold = buf_tab.today_win_gold
				finder = 1
				break
			end
		end
		if tmp_index < car_match_lib.CFG_TODAYMR_LEN then
			if finder ~= 1 then
				table.insert(car_match_lib.today_minren_list[match_type], buf_tab)
			end
			car_match_db_lib.add_today_minren(match_type, buf_tab)
		elseif car_match_lib.user_list[user_id].match_info[match_type].today_win_gold > car_match_lib.today_minren_list[match_type][tmp_index].today_win_gold then
			if finder ~= 1 then
				table.remove(car_match_lib.today_minren_list[match_type], tmp_index)
				table.insert(car_match_lib.today_minren_list[match_type], buf_tab)
			end
			car_match_db_lib.add_today_minren(match_type, buf_tab)
		end

		if car_match_lib.history_minren_list[match_type] == nil then car_match_lib.history_minren_list[match_type] = {} end

		tmp_index = #car_match_lib.history_minren_list[match_type]
		for k, v in pairs (car_match_lib.history_minren_list[match_type]) do
			if v.user_id == buf_tab.user_id then
				v.week_win_gold = buf_tab.week_win_gold
				finder = 2
				break
			end
		end
		if tmp_index < car_match_lib.CFG_WEEK_KING_LEN then
			if finder ~= 2 then
				table.insert(car_match_lib.history_minren_list[match_type], buf_tab)
			end
			car_match_db_lib.add_week_minren(match_type, buf_tab)
		elseif car_match_lib.user_list[user_id].match_info[match_type].week_win_gold > car_match_lib.history_minren_list[match_type][tmp_index].week_win_gold then
			if finder ~= 2 then
				table.remove(car_match_lib.history_minren_list[match_type], tmp_index)
				table.insert(car_match_lib.history_minren_list[match_type], buf_tab)
			end
			car_match_db_lib.add_week_minren(match_type, buf_tab)
		end

		--����
		if #car_match_lib.today_minren_list[match_type] > 1 then
			table.sort(car_match_lib.today_minren_list[match_type],
			      function(a, b)
				     return a.today_win_gold > b.today_win_gold
			end)
		end
		if #car_match_lib.history_minren_list[match_type] > 1 then
			table.sort(car_match_lib.history_minren_list[match_type],
			      function(a, b)
				     return a.week_win_gold > b.week_win_gold
			end)
		end

end

--��������֮��
function car_match_lib.update_king_car_list(match_type, old_buf_tab)
	local buf_tab = table.clone(old_buf_tab)
	--�����˲�Ҫȥ��������֮��
	if buf_tab.user_id < 0 then return end
	if car_match_lib.king_car_list[match_type] == nil then car_match_lib.king_car_list[match_type] = {} end
	local car_id = buf_tab.car_id
	local len =#car_match_lib.king_car_list[match_type]
	local finder = 0
	for k, v in pairs(car_match_lib.king_car_list[match_type]) do
		if car_id == v.car_id then
			v.king_count = v.king_count + 1
			finder = 1
			break
		end
	end

	if len < car_match_lib.CFG_KINGCAR_LEN then
		if finder == 0 then
			table.insert(car_match_lib.king_car_list[match_type], buf_tab)
		end
		car_match_db_lib.add_kingcar_list(match_type, buf_tab)
	elseif buf_tab.king_count > car_match_lib.king_car_list[match_type][len].king_count then
		if finder == 0 then
			table.remove(car_match_lib.king_car_list[match_type], len)
			table.insert(car_match_lib.king_car_list[match_type], buf_tab)
		end
		car_match_db_lib.add_kingcar_list(match_type, buf_tab)
	end

	if len > 1 then
		table.sort(car_match_lib.king_car_list[match_type],
		      function(a, b)
			     return a.king_count > b.king_count
		end)
	end
end

--������ҵ�Ͷע��Ϣ
function car_match_lib.update_bet_info(user_id,area_id,bet_count,match_type)
	--�����ַ����ж�Ӧλ�õ�ֵ
	local update_bet=function(bet_info,area_id,bet_count)
		if(bet_info==nil or bet_info=="")then
			bet_info=car_match_lib.CFG_BET_INIT;
		end
		local tmp_tab=split(bet_info,",")
		local tmp_str=""
		local tmp_bet=0
		tmp_bet=tonumber(tmp_tab[area_id])

		if(tmp_bet==nil)then
			TraceError("error bet_info="..bet_info)
		end

		tmp_bet = tmp_bet + bet_count
		local gold_cost = bet_count * car_match_lib.CFG_BET_RATE[match_type]

		if gold_cost >= car_match_lib.CFG_XZGOLD_MSG then
			local user_info = usermgr.GetUserById(user_id)
			local msg_list = {}
			local msg_type = 3 --1�����ɹ� 2����λ���� 3 �׻���100��
			table.insert(msg_list, user_info.nick)
			table.insert(msg_list, car_match_lib.match_list[match_type].match_car_list[area_id].match_nick_name)
			table.insert(msg_list, bet_count)
			car_match_lib.send_all_message(match_type, msg_type, msg_list)
		end

		tmp_tab[area_id]=tostring(tmp_bet)

		for i=1,#tmp_tab do
			tmp_str=tmp_str..","..tmp_tab[i]
		end

		--������ע�����
		local tmp_bet_info=string.sub(tmp_str,2)

		return tmp_bet_info --ȥ����1�����ź󷵻�
	end

	--������ҵ�Ͷע��Ϣ
	local bet_info = car_match_lib.user_list[user_id].match_info[match_type].bet_info
	bet_info = update_bet(bet_info, area_id, bet_count)
	car_match_lib.user_list[user_id].match_info[match_type].bet_info = bet_info

	--�������ݿ�
	car_match_db_lib.update_bet_info(user_id,bet_info, car_match_lib.match_list[match_type].match_id, match_type)
	return car_match_lib.user_list[user_id].match_info[match_type].bet_info
end

--�˻�����ӵ��˵ı�����
function car_match_lib.return_baoming_gold(user_id,return_chadui,match_type)
	return_chadui = return_chadui - 1
	local baoming_gold = car_match_lib.CFG_BAOMING_GOLD[match_type]
	local chadui_gold = baoming_gold * math.pow(2,return_chadui)
	if return_chadui == 0 then chadui_gold = 0 end
	local add_gold = baoming_gold + chadui_gold
	if chadui_num == 0 then
		add_gold = baoming_gold
	end

	--usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH, -1);
  if match_type == 1 then
    usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH_BEIQIANGWEI_1, -1);
  else
    usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH_BEIQIANGWEI_2, -1);
  end
	
	if (car_match_sys_ctrl) then
		--car_match_sys_ctrl.update_win_info(match_type, -add_gold, car_match_lib.CFG_GOLD_TYPE.BACK_XIA_ZHU)
	end
end

--���������˷���
function car_match_lib.match_fajiang(match_type)
    --��һ����λ�ú�
    local open_num = car_match_lib.match_list[match_type].open_num
    local user_id = 0
    local mingci = 0
    local add_gold = 0

    --�������˷���
    for i = 1, car_match_lib.CFG_CAR_NUM do
        mingci = car_match_lib.match_list[match_type].match_car_list[i].mc
        user_id = car_match_lib.match_list[match_type].match_car_list[mingci].match_user_id

        if  user_id > 0 then --�������
            local xiazhu = car_match_lib.match_list[match_type].match_car_list[mingci].xiazhu or 0
            local jiacheng = car_match_lib.match_list[match_type].match_car_list[mingci].jiacheng
            if (mingci == open_num) then --��һ��ֱ�ӷ���
                --�ھ�����=��ǰ����ע�ܶ�*��ǰ��λ����*�ӳɱ���
                local peilv = car_match_lib.match_list[match_type].match_car_list[mingci].peilv
                local car_id = car_match_lib.match_list[match_type].match_car_list[mingci].car_id
                add_gold = xiazhu * peilv * jiacheng * car_match_lib.CFG_BET_RATE[match_type]
                add_gold = math.floor(add_gold)
                car_match_lib.king_reward[match_type] = add_gold
                --usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH, -1);
                if match_type == 1 then
                  usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH_GAMEFANJIANG_1, -1);
                else
                  usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH_GAMEFANJIANG_2, -1);
                end
                if (car_match_sys_ctrl) then
					car_match_sys_ctrl.update_win_info(match_type, -add_gold, car_match_lib.CFG_GOLD_TYPE.CAR_WIN)
				end
    		    --д��־
    		    car_match_db_lib.record_log_match_fajiang(user_id, add_gold, match_type)
            else    --�������α����������Ƚ�������Ժ��ٷ���
                add_gold = xiazhu * jiacheng * car_match_lib.CFG_BET_RATE[match_type]
                add_gold = math.floor(add_gold)
                car_match_lib.add_other_winner(user_id, mingci, jiacheng, add_gold, match_type)
            end
        else        --NPCֻ��ʾ����
            if (mingci == open_num) then
                local xiazhu = car_match_lib.match_list[match_type].match_car_list[mingci].xiazhu or 0
                local jiacheng = car_match_lib.match_list[match_type].match_car_list[mingci].jiacheng
                local peilv = car_match_lib.match_list[match_type].match_car_list[mingci].peilv
                local car_id = car_match_lib.match_list[match_type].match_car_list[mingci].car_id
                add_gold = xiazhu * peilv * jiacheng * car_match_lib.CFG_BET_RATE[match_type]
                add_gold = math.floor(add_gold)
                car_match_lib.king_reward[match_type] = add_gold
            end
        end
    end
end

--����ע���˷���
function car_match_lib.xiazhu_fajiang(match_type)
	--�õ��������ĺ���
	local open_num = car_match_lib.match_list[match_type].open_num
	for k,v in pairs (car_match_lib.user_list) do
		local user_id = v.user_id
		local nick_name = v.nick_name
		local img_url = v.img_url
		if v.match_info[match_type] ~=nil then
			local bet_info = v.match_info[match_type].bet_info or car_match_lib.CFG_BET_INIT
			local tmp_bet_tab = split(bet_info,",")
			local xiazhu = tonumber(tmp_bet_tab[open_num]) or 0 --����λ����ע���
			if xiazhu > 0 then
				--Ӧ�üӶ���Ǯ
				local add_gold = xiazhu * car_match_lib.CFG_BET_RATE[match_type] * car_match_lib.match_list[match_type].match_car_list[open_num].peilv
				add_gold = math.floor(add_gold)
				--usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH, -1);
        if match_type == 1 then
          usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH_FANJIANG_1, -1);
        else
          usermgr.addgold(user_id, add_gold, 0, new_gold_type.CAR_MATCH_FANJIANG_2, -1);
        end
                
		        if (car_match_sys_ctrl) then
					car_match_sys_ctrl.update_win_info(match_type, -add_gold, car_match_lib.CFG_GOLD_TYPE.JIANG_JIN)
				end
				--�����н�����б�
				local buf_tab = {
					["user_id"] = user_id,
					["add_gold"] = add_gold,
					["nick_name"] = nick_name, --����Ҫ��car_match_lib.user_list��nick��������user_info�ģ���Ϊcar_match_lib.user_list��һ��֮�����ģ�����������߾�����
					["img_url"] = img_url,
				}
				table.insert(car_match_lib.all_zj_info[match_type], buf_tab)

				car_match_lib.update_minren_list(user_id, match_type, buf_tab)
				if add_gold > 0 then
					car_match_db_lib.record_log_xiazhu_fajiang(user_id, add_gold, match_type, bet_info)
                end
                
            end
            if (bet_info ~= car_match_lib.CFG_BET_INIT) then
                local match_id = car_match_lib.match_list[match_type].match_id
                car_match_db_lib.update_bet_info(user_id,car_match_lib.CFG_BET_INIT,match_id,match_type) --�����ע��Ϣ
            end
		end
		local user_info = usermgr.GetUserById(user_id)
		if user_info == nil and car_match_lib.user_list[user_id] ~= nil then
			local other_match_type = match_type % 2 + 1 --�õ���һ��������type
			--�������һ��������û��ע�Ͱ���ҵ���Ϣ�������Լ�ڴ�
			if car_match_lib.user_list[user_id].match_info[other_match_type].bet_info == nil or
					car_match_lib.user_list[user_id].match_info[other_match_type].bet_info == car_match_lib.CFG_BET_INIT then
				car_match_lib.user_list[user_id] = nil
			end
		end
	end
end

--������
function car_match_lib.clear_car_king_data(current_time)
	local table_time = os.date("*t", current_time);
	local now_hour = table_time.hour
	local now_min = table_time.min
	local now_sec = table_time.sec

	if now_hour == 0 and now_min == 0 and now_sec == 1 then
        car_match_db_lib.clear_today_minren()
		car_match_lib.today_minren_list = {}
		car_match_lib.today_minren_list[1] = {}
		car_match_lib.today_minren_list[2] = {}
		--ÿ��һ���ÿ�ܵ���������
		local now_week = os.date("%w", current_time)
		if tonumber(now_week) == 1 then
            car_match_db_lib.clear_week_minren()
			car_match_lib.history_minren_list = {}
			car_match_lib.history_minren_list[1] = {}
			car_match_lib.history_minren_list[2] = {}
		end

		for k, v in pairs (car_match_lib.open_wnd_user_list) do
			local user_info = usermgr.GetUserById(v)
			if user_info ~= nil then
				car_match_lib.send_today_minren(user_info, 1)
				car_match_lib.send_history_minren(user_info, 1)

				car_match_lib.send_today_minren(user_info, 2)
				car_match_lib.send_history_minren(user_info, 2)
			end
		end

	end

end

--GM���Ƴ�
function car_match_lib.change_mc(match_type, mc)
    --ֻ�ܵڶ��׶���������
    if ((match_type ~= 1 and match_type ~= 2) or
        #mc ~= 8 or car_match_lib.match_list[match_type].proccess ~= 2) then
        return
    end
    for i = 1, 8 do
        car_match_lib.match_list[match_type].match_car_list[mc[i]].mc = i
    end
    car_match_lib.match_list[match_type].open_num = mc[1]
	if (car_match_lib.gm_ctrl == nil) then
		car_match_lib.gm_ctrl = {0, 0}
	end
	car_match_lib.gm_ctrl[match_type] = 1
end

--����һ�������
function car_match_lib.add_other_winner(user_id, mingci, jiacheng, add_gold, match_type)
    if (car_match_lib.match_list[match_type].other_winner == nil) then
        car_match_lib.match_list[match_type].other_winner = {}
    end
    local buf_tab = {
					["user_id"]  = user_id,
                    ["mingci"]   = mingci,
					["add_gold"] = add_gold,
					["jiacheng"] = jiacheng,
				}
	table.insert(car_match_lib.match_list[match_type].other_winner, buf_tab)
end

--��������ҷ���
function car_match_lib.give_other_winner(match_type)
    local tmp_tab = car_match_lib.match_list[match_type].other_winner
    if (tmp_tab ~= nil) then
        for k, v in pairs(tmp_tab) do
            local user_info = usermgr.GetUserById(v.user_id)
            car_match_lib.send_other_winner(user_info, v.jiacheng, v.add_gold, match_type)
            --usermgr.addgold(v.user_id, v.add_gold, 0, new_gold_type.CAR_MATCH, -1);
            if match_type == 1 then
              usermgr.addgold(v.user_id, v.add_gold, 0, new_gold_type.CAR_MATCH_GAMEFANJIANG_1, -1);
            else
              usermgr.addgold(v.user_id, v.add_gold, 0, new_gold_type.CAR_MATCH_GAMEFANJIANG_2, -1);
            end
            if (car_match_sys_ctrl) then
				car_match_sys_ctrl.update_win_info(match_type, -v.add_gold, car_match_lib.CFG_GOLD_TYPE.CAR_WIN)
			end
    		car_match_db_lib.record_log_match_fajiang(v.user_id, v.add_gold, match_type)
        end
        car_match_lib.match_list[match_type].other_winner = nil
    end
end

-------------------------------------------ϵͳ�¼�----------------------------------------------------------------
--��ʱ��
function car_match_lib.timer(e)
    if(car_match_lib.check_match_room() == 0) then
        return;
    end
	local current_time = e.data.time;
    car_match_lib.current_time = current_time
	local tmp_match_type = 1

	--��������Ч�����Ч������Ҫ֪ͨ�ͻ���
	car_match_lib.send_match_status(1, current_time)
    car_match_lib.send_match_status(2, current_time)

	for i = 1, car_match_lib.CFG_MATCH_NUM do
		if car_match_lib.match_start_status[i] == 1 and
           car_match_lib.match_list == nil or car_match_lib.match_list[i]==nil then
			car_match_lib.init_match(i,current_time)
        else
			car_match_lib.set_proccess(car_match_lib.match_list[i],current_time)
		end
	end
	--notify_flag����1ʱˢ���ŵ���Ϣ������2ʱˢά��˹����Ϣ
	if car_match_lib.notify_flag > 0 then
		tmp_match_type = car_match_lib.notify_flag
		car_match_lib.notify_flag = 0 --�ȸı�ʶ����ֹ����������ϵķ���Ϣ
		--for k,v in pairs (car_match_lib.user_list) do
		for k,v in pairs (car_match_lib.open_wnd_user_list) do
			local user_info = usermgr.GetUserById(v)
			if user_info ~= nil then
				if car_match_lib.notify_flag == 999 then
					--����������ˢ
					for i=1,car_match_lib.CFG_MATCH_NUM do
						car_match_lib.send_main_box(user_info, i, 1)
					end
				else
					car_match_lib.send_main_box(user_info,tmp_match_type, 1)
				end
			end
		end
	end

	--���������ע�ˣ�֪ͨ�ͻ��ˣ�������ע
	if car_match_lib.send_bet_flag >0 and current_time % 2 == 0 then
		tmp_match_type = car_match_lib.send_bet_flag
		car_match_lib.send_bet_flag = 0
		if tmp_match_type == 999 then
			for i=1,car_match_lib.CFG_MATCH_NUM do
				car_match_lib.send_other_bet(i)
				--֪ͨ����ѡ�ָ��½���������Ҫ�Ļ��������ǿ����Ż��ġ�
				for j = 1, car_match_lib.CFG_CAR_NUM do
					car_match_lib.send_guanjun_reward(i,j)
				end
			end
		else
			car_match_lib.send_other_bet(tmp_match_type)
			--֪ͨ����ѡ�ָ��½���������Ҫ�Ļ��������ǿ����Ż��ġ�
			for j = 1, car_match_lib.CFG_CAR_NUM do
				car_match_lib.send_guanjun_reward(tmp_match_type, j)
			end
		end
	end

	for i = 1, car_match_lib.CFG_MATCH_NUM do
		--����ǰһ���ӷ�С������Ϣ
		if car_match_lib.match_list ~= nil and car_match_lib.match_list[i] ~= nil and
           car_match_lib.match_list[i].proccess == 2 and
           car_match_lib.get_remain_time(i, current_time) == 60 then
			--ȫ����С����֪ͨ������
			tex_speakerlib.send_sys_msg(_U("�������δ���������ʼ���Ͻ�ǰ��Χ�ۣ�"))
			break
		end
	end

	math.random(1,100)

	if (e.data.time % 10 == 0 and car_match_lib.check_time(1) == 0 and car_match_lib.check_time(2) == 0) then
		for k,v in pairs (car_match_lib.user_list) do
			if (v.user_id ~= nil) then
			    local user_info = usermgr.GetUserById(v.user_id)
			    if user_info == nil then
				car_match_lib.user_list[k] = nil
			    end
			end
		end
	end

	car_match_lib.clear_car_king_data(current_time)
end

--gmָ�������������
function car_match_lib.gm_cmd(e)
    if(car_match_lib.check_match_room() == 0) then
        return;
    end
    if (e.data["cmd"] == "change_car_rank" and e.data["args"][1] ~= nil) then
        local mc = {}
        for i = 2, 9 do
            table.insert(mc, tonumber(e.data["args"][i]))
        end
        car_match_lib.change_mc(tonumber(e.data["args"][1]), mc)
    end
end

--������������
function car_match_lib.restart_server()
    if(car_match_lib.check_match_room() == 0) then
        return;
    end
	--���ݱ�������Ϊ���������ڱ仯����ֹ�������������λ���ϱ��������û��������ˣ������ȱ��ݣ���ҵ�½ʱ���ӱ��ݱ��������Ǯ��
	car_match_db_lib.backup_baoming_table()

	--��ʼ������ǰ��match_id���ڴ���
	car_match_db_lib.init_restart_match_id()

	--��ʼ��king_list
	car_match_db_lib.init_king_list()
	car_match_db_lib.init_today_king_list()
	car_match_db_lib.init_kingcar_list()
	car_match_db_lib.init_today_minren()
	car_match_db_lib.init_week_minren()

end

--���ھ����ھ�����
function car_match_lib.give_kingcar_box(match_type)
	local send_result = function(user_id, box_type)
		local user_info = usermgr.GetUserById(user_id)
		if user_info == nil then return end
		netlib.send(function(buf)
			buf:writeString("GCARKINGBOX")
			buf:writeByte(box_type)
		end, user_info.ip, user_info.port)
	end

	local carbox_type = tex_gamepropslib.PROPS_ID.KINGCAR_BOX1
	if match_type == 2 then
		carbox_type = tex_gamepropslib.PROPS_ID.KINGCAR_BOX2
	end

	for k,v in pairs(car_match_lib.match_list[match_type].match_car_list)do
		--�õ�һ���Ĳ��ǻ�����
		if v.mc == 1 and v.match_user_id > 0 then
			--����ҷ�����
			tex_gamepropslib.add_tools(carbox_type, 1, v.match_user_id)

			--֪ͨ�ͻ��˵���
			send_result(v.match_user_id, match_type)
			return
		end
	end
end

function car_match_lib.on_recv_open_box(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local box_type = buf:readByte()
	local item_id = tex_gamepropslib.PROPS_ID.KINGCAR_BOX1
	if box_type == 2 then
		item_id = tex_gamepropslib.PROPS_ID.KINGCAR_BOX2
	end
	if tex_gamepropslib then
		tex_gamepropslib.open_box(user_info, item_id)
	end
end

--�����Ƿ��Ѿ���ʼ��
function car_match_lib.is_match_start(match_type)
    if (car_match_lib.match_list[match_type] ~= nil and
        car_match_lib.match_list[match_type].proccess >= 1 and
        car_match_lib.match_list[match_type].proccess <= 3) then
        return 1
    else
        return 0
    end
end

--�õ��������ʹ�õĳ��Ĺھ�����
function car_match_lib.get_useing_king_count(user_id)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return -1 end
	local parking_data = parkinglib.user_list[user_info.userId]
	if parking_data == nil or parking_data.using_car == nil then return -1 end
	return parking_data.using_car.king_count or 0
end

--�������ڴ���ʱ,����ʹ�õ�����king_count�и��£������������֪ͨ���ϵ��˴���һ��
function car_match_lib.refresh_using_king_count(user_id)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil or user_info.desk == nil or  user_info.site == nil then return end
	local use_king_count = car_match_lib.get_useing_king_count(user_id)
	netlib.broadcastdesk(
		function(buf)
            buf:writeString("FREKINGCO")
            buf:writeInt(user_info.site)
            buf:writeInt(use_king_count)            
		end, user_info.desk, borcastTarget.all)
end

function car_match_lib.open_or_close_wnd(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local show_status = buf:readByte()
	if show_status == 1 then
		car_match_lib.open_wnd_user_list[user_info.userId] = user_info.userId
	else
		car_match_lib.open_wnd_user_list[user_info.userId] = nil
	end
end

function car_match_lib.on_user_exit(e)
    local user_id = e.data.user_id;
    if(car_match_lib.open_wnd_user_list[user_id] ~= nil) then
        car_match_lib.open_wnd_user_list[user_id] = nil;
    end
end

--�յ����ֵ���쳵
function car_match_lib.on_recv_new_player(buf)
    local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
    if (car_match_sj_db_lib) then
        --��һ������
        --��ֹ��ˢ������
        if (user_info.update_new_car_user == nil) then
            user_info.update_new_car_user = 1
            car_match_sj_lib.check_is_new_player(user_info.userId, function(ret) 
                car_match_db_lib.add_car(user_info.userId, 5043, 1, 1)
                --ע�ᳵ����Ϣ
                car_match_sj_lib.add_team_exp(user_info.userId, 0, 0, 200, 4)
                car_match_sj_lib.add_gas(user_info.userId, 5, 4)
                user_info.update_new_car_user = nil
                netlib.send(function(buf) 
                    buf:writeString("CARGETCAR")
                    buf:writeInt(1)
                end, user_info.ip, user_info.port)
                car_match_sj_lib.send_team_info(user_info)
            end)
        end
    end
end

------------------------------------------------����Э��--------------------------------------------
cmdHandler =
{
    ["CARREST"]     = car_match_lib.on_recv_tuifei,                 --�����ѯ�˷�
	["CARJOIN"]     = car_match_lib.on_recv_baoming,                --������
	["CAROPJN"]     = car_match_lib.on_recv_openjoin,               --�ͻ��ˣ������������ť
	["CAROPPL"]     = car_match_lib.on_recv_openpl,                 --�򿪻���
	["CARSTAT"]     = car_match_lib.on_recv_querystatus,            --�ͻ��˲�ѯ�״̬
	["CARXZ"]       = car_match_lib.on_recv_xiazhu,                 --�ͻ�����ע
	["CARQUERY"]    = car_match_lib.on_recv_carinfo,                --�ͻ��˲�ѯ������Ϣ
	["CARQTYPE"]    = car_match_lib.on_recv_carface_info,           --�ͻ���ͷ��ʱ�õ����Ļ���Ҫ��ѯ����һЩ��Ϣ
	["CARMC"]       = car_match_lib.on_recv_query_match_mc,         --���������
	["CARKINGIF"]   = car_match_lib.on_recv_query_king_info,        --��ĳ���˵ùڵ���Ϣ
	["OCARKINGBOX"] = car_match_lib.on_recv_open_box,               --������
	["CARSHOW"]     = car_match_lib.open_or_close_wnd,              --��¼�򿪺͹ر���壬�Ż�һ������
	["CARGETCAR"]   = car_match_lib.on_recv_new_player,             --�յ����ֵ���쳵
	
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("timer_second", car_match_lib.timer)
eventmgr:addEventListener("on_server_start", car_match_lib.restart_server)
eventmgr:addEventListener("gm_cmd", car_match_lib.gm_cmd)
eventmgr:addEventListener("on_user_exit", car_match_lib.on_user_exit)
