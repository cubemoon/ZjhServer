--�������ñ��
config_for_yunying = config_for_yunying or {}

TraceError("���� gameprops(��Ϸ����) ���....")
if tex_gamepropslib and tex_gamepropslib.on_after_user_login then
	eventmgr:removeEventListener("h2_on_user_login", tex_gamepropslib.on_after_user_login);
end

if tex_gamepropslib and tex_gamepropslib.timer then
	eventmgr:removeEventListener("timer_minute", tex_gamepropslib.timer);
end


if not tex_gamepropslib then
	tex_gamepropslib = _S
	{
        get_props_list = NULL_FUNC,                 --��ȡ����ڴ��еĵ����б�

        on_recv_get_props = NULL_FUNC,              --�յ����������á������Ϣ
        on_recv_togive_props = NULL_FUNC,           --�յ����������á������Ϣ
        net_broadcast_togive_props = NULL_FUNC,
        net_send_error_result = NULL_FUNC,                --ֻ�������Լ�����Э��
        net_send_togive_props_result = NULL_FUNC,
        net_send_refresh_props_count = NULL_FUNC,   --֪ͨ�ͻ��ˣ����µ�������TIPS
        on_after_user_login = NULL_FUNC,			--�û���¼��ʼ������
        vaild_props_id = NULL_FUNC,                 --������ID�Ƿ���Ч��0����Ч��1����Ч
        get_props_count_by_id = NULL_FUNC,          --���ݵ���IDȡ�õ�������
        set_props_count_by_id = NULL_FUNC,          --���ݵ���ID���õ�������
		on_recv_open_box = NULL_FUNC,               --�ͻ��˴���������
		open_box = NULL_FUNC,
        PROPS_LEN = 8,              --������������
        PROPS_ID = _S               --����ID�������ݿ�� user_props_info ��Ӧ
        {
            KICK_CARD_ID    = 1,    --���˿�ID
            SPEAKER_ID      = 2,    --С����ID
            ShipTickets_ID      = 3,    --�����ʸ�֤��
            GUN_1_ID = 4,--����
            GUN_2_ID = 5,--�̻�
            GUN_3_ID = 6,--����
            NewYearTickets_ID = 7,--���ھ�������Ʊ
            love_chocolate_id = 8,--�����ɿ���
            wabao_map_id = 9,--�ر�ͼ
            DIAMOND = 10, --��ʯ��ȯ
          	GOLD_MOONCATE             = 11,   --���±�
          	SILVER_MOONCATE           = 12,  --���±�
          	BRONZE_MOONCATE           = 13,  --ͭ�±�
          	MUBAOXIANG         			  = 14,  --ľ����
          	TIEBAOXIANG  		 			    = 15,  --������
          	TONGBAOXIANG              = 16,  --ͭ����
          	YINBAOXIANG               = 17,  --������
          	JINBAOXIANG               = 18,  --����
          	
          	BHXY_ID                   = 19,   --�������
          	YPPJ_ID                   = 20,   --һƿơ��
          	YXBLS_ID                  = 21,   --һС����ʳ
          	XZGZ_ID                   = 22,   --��ե��֭
          	
          	ROSE_RED                  = 23,  --��õ��
          	ROSE_PINK                 = 24,  --��õ��
          	DIAMOND_PURPLE            = 25,  --��ˮ��
          	DIAMOND_BLUE              = 26,  --������
          	
          	WING1                     = 27,  --��ʿ���
          	WING2                     = 28,  --׼�о����
          	WING3                     = 29,  --�о����
          	WING4                     = 30,  --�Ӿ����
          	WING5                     = 31,  --�������
          	WING6                     = 32,  --������
          	WING7                     = 33,  --�������
          	WING8                     = 34,  --�������
          	WING9                     = 35,  --�������
          	FEATHER                   = 36,  --��λ��ë   
          	  
  					
        		FANGKUAI1 = 5001,
        		FANGKUAI2 = 5002,
        		FANGKUAI3 = 5003,
        		FANGKUAI4 = 5004,
        		FANGKUAI5 = 5005,
        		FANGKUAI6 = 5006,
        		FANGKUAI7 = 5007,
        		FANGKUAI8 = 5008,
        		FANGKUAI9 = 5009,
        		FANGKUAI10 = 5010,
        		FANGKUAIJ  = 5011,
        		FANGKUAIQ  = 5012,
        		FANGKUAIK  = 5013,
        		MEIHUA1    = 5014,
        		MEIHUA2    = 5015,
        		MEIHUA3    = 5016,
        		MEIHUA4    = 5017,
        		MEIHUA5    = 5018,
        		MEIHUA6    = 5019,
        		MEIHUA7    = 5020,
        		MEIHUA8    = 5021,
        		MEIHUA9    = 5022,
        		MEIHUA10   = 5023,
        		MEIHUAJ    = 5024,
        		MEIHUAQ    = 5025,
        		MEIHUAK    = 5026,
        		HONGTAO1   = 5027,
        		HONGTAO2   = 5028,
        		HONGTAO3   = 5029,
        		HONGTAO4   = 5030,
        		HONGTAO5   = 5031,
        		HONGTAO6   = 5032,
        		HONGTAO7   = 5033,
        		HONGTAO8   = 5034,
        		HONGTAO9   = 5035,
        		HONGTAO10  = 5036,
        		HONGTAOJ   = 5037,
        		HONGTAOQ   = 5038,
        		HONGTAOK   = 5039,
        		HEITAO1    = 5040,
        		HEITAO2    = 5041,
        		HEITAO3    = 5042,
        		HEITAO4    = 5043,
        		HEITAO5    = 5044,
        		HEITAO6    = 5045,
        		HEITAO7    = 5046,
        		HEITAO8    = 5047,
        		HEITAO9    = 5048,
        		HEITAO10   = 5049,
        		HEITAOJ    = 5050,
        		HEITAOQ    = 5051,
        		HEITAOK    = 5052,
        		XIAOWANG   = 5053,
        		DAWANG     = 5054,
        		SHUIJING   = 5055,
        		HUANGJIN   = 5056,
          	
          	
          	GOLD_MOONCATE_TZ          = 100020,  --3��ͼֽ
          	SILVER_MOONCATE_TZ        = 100021,
          	BRONZE_MOONCATE_TZ        = 100022,
          	
          	AT_TZ1                    = 100105, --����1
          	AT_TZ2                    = 100106, --����2
          	AT_TZ3									  =	100107, --����3ͼֽ
						XTL_TZ								    =	100108, --ѩ����ͼֽ
						JKC_tZ								    =	100109, --�׿ǳ�ͼֽ
						MSLD_TZ								    =	100110, --��ɯ����ͼֽ
						FLL_TZ								    =	100111, --������ͼֽ
						LBJN_TZ								    =	100112, --��������ͼֽ
						BJD_TZ								    =	100113, --���ӵ�����ͼֽ
						BJDHJ_TZ							    =	100114, --���ӵ����а���ƽ����ͼֽ
						SMC_TZ								    =	100115, --���س�ͼֽ
						YONGJIU_TZ                = 100116,
						FENGHUANG_TZ              = 100117,
						ROSE_BOX1_TZ              = 100118,--���˽ڻͼֽ1
						ROSE_BOX2_TZ              = 100119,--���˽ڻͼֽ2

						BFDKH                     = 200001, --�ͷ׵��ߺ���
						KINGCAR_BOX1              = 200002, --��ͨ�ھ���
						KINGCAR_BOX2              = 200003, --�����ھ���
						PAY_GIVE_BOX1             = 200004, --��ֵ��ͭ����
						PAY_GIVE_BOX2             = 200005, --��ֵ��������
						PAY_GIVE_BOX3             = 200006, --��ֵ�ͽ���
						MORI_QIEGAO               = 200007, --ĩ���и�
						NEWYEAR_WATER             = 200008, --����Ȫˮ
						NEWYEAR_REDBAG            = 200009, --������
						NEWYEAR_GEMBOX            = 200010, --���걦ʯ��
						NEWYEAR_ITEMBOX           = 200011, --���������
						NEWYEAR_SCROLL            = 200012, --�������
						NEWYEAR_CARKEY            = 200013, --���공Կ��
						LOVER_DAY_ROSE            = 200014, --����õ�����
						LOVER_DAY_DIAMOND         = 200015, --�ݻ��������
						pay_car_1                 = 200016, --����Կ��
						pay_car_2                 = 200017, --�ƽ�Կ��						
						pay_car_3                 = 200018, --ˮ��Կ��
						pay_box_1                 = 200019, --��ͨ�����
						pay_box_2                 = 200020, --���������
						pay_box_3                 = 200021, --�ƽ������ 
						daojuka_3                 = 200022, --�ٱ���߿�						
						nanjue_box                = 200023, --�о�����
						zijue_box                 = 200024, --�Ӿ�����
						bojue_box                 = 200025, --��������
						houjue_box                = 200026, --�������
						MEDAL                     = 200027,  --�ɳ�ѫ��
						pay_box_4                 = 200028, --��ͨ�����
						pay_box_5                 = 200029, --���������
						pay_box_6                 = 200030, --�ƽ������ 
        },

        SQL = _S
        {
            --��ȡ��������
            get_props_count = "select total_count from user_props_info where props_type=%d and user_id=%d",
            --��ѯ��������
            select_props_count = "select props_type, total_count from user_props_info where user_id=%d;commit;",
            --���µ������������������µ���������user_id, props_id, props_count
            update_props_count = "call sp_update_gameprops_count(%d, %d, %d);",

            --��־
            add_props_log = "insert into log_user_props(user_id, do_type, props_id, add_count, sys_time) values(%d, %d, %d, %d, NOW())",

            give_props_log = "insert into log_user_give_props(from_user_id, to_user_id, props_id, add_count, sys_time) values(%d, %d, %d, %d, NOW())",
        },
        
        

				REWARDMSG_ITEM_NAME = {
          [5012] = "�׿ǳ�",
          [5018] = "ѩ����",
          [5021] = "��ɯ����",
          [100110] = "��ɯ����ͼֽ",
          [100111] = "������ͼֽ",
          [5024] = "������",										
          [5026] = "��������",
          [100112] = "��������ͼֽ",			
				},
				BOX_NAME = {
					[200004] = "ͭ����",
					[200005] = "������",
					[200006] = "����",
				},
				
			--ÿ�ջ�õı��䶫������
        already_get = {
        	[200016]={
        		0, --����*2
        		0, --ѩ����
        		0, --�׿ǳ�
        		0, --����Z4
        		0, --�µ�A8
        	},
        	[200017]={
        		0, --�׿ǳ�
        		0, --����Z4
        		0, --�µ�A8
        		0, --��ɯ����
        		0, --������
        	},
        	[200018]={
        		0, --����Z4
        		0, --�µ�A8
        		0, --��ɯ����
        		0, --������
        		0, --��������
        	},
        },
				
	}
end



--���ݵ���ID��ȡ�õ�������
--[[
    props_id:
    user_info:
    complete_callback_func: �ص����������ص�������
--]]
function tex_gamepropslib.get_props_count_by_id(props_id, user_info, complete_callback_func)
    if(complete_callback_func == nil) then 
        --TraceError("tex_gamepropslib.get_props_count_by_id() -> �ص���������Ϊ��")
        return 
    end

    --��ҵ����б�
    local propslist = tex_gamepropslib.get_props_list(user_info)
    local props_count = 0

    local set_props_count_to_user_info = function(count)
        if(propslist[props_id] == nil) then
            if(tex_gamepropslib.vaild_props_id(props_id) == 1) then
                table.insert(user_info.propslist, props_id, count)
            end
        else
            user_info.propslist[props_id] = count
        end
        --ִ�лص�����
        complete_callback_func(count or 0)
    end
    
    if(user_info.propslist==nil) then
        --�ڴ����Ϊ�գ�������ݿ�
        local sql = string.format(tex_gamepropslib.SQL.get_props_count, props_id, user_info.userId);
        dblib.execute(sql, 
                    function(dt)
                       if (dt and #dt > 0) then
                            props_count = dt[1].total_count or 0
                            --��ȡ�ɹ�������ID��Ч���ŵ��ڴ���
                            set_props_count_to_user_info(props_count)
                       else
                            set_props_count_to_user_info(props_count)
                       end
                    end)
    else
        props_count = propslist[props_id];
        complete_callback_func(props_count or 0)
    end
end

--���ݵ���ID�����õ�������
--[[
    props_id:
    add_count:�������ӻ���ٵ�ֵ
    user_info:
    complete_callback_func:
]]--
function tex_gamepropslib.set_props_count_by_id(props_id, add_count, user_info, complete_callback_func, do_type, failed_callback_func)
    --������ID�Ƿ���Ч
    if(tex_gamepropslib.vaild_props_id(props_id) == 0) then 
  		if(failed_callback_func ~= nil) then 
  			failed_callback_func() 
  		end
    	return 
    end
    if(do_type == nil) then
        do_type = 0;
    end

    dblib.execute(string.format(tex_gamepropslib.SQL.add_props_log, user_info.userId, do_type, props_id, add_count));

    --���µ����ݿ�   
    local sql = string.format(tex_gamepropslib.SQL.update_props_count, user_info.userId, props_id, add_count);
        dblib.execute(sql, 
                 function(dt) 
                 	local props_count = 0
                    if (dt and #dt > 0) then
                        props_count = dt[1].total_count or 0
                        --��ҵ����б�
                        local propslist = tex_gamepropslib.get_props_list(user_info)
                        --���³ɹ����ŵ��ڴ���
                        if(propslist[props_id] == nil) then
                            table.insert(user_info.propslist, props_id, props_count)
                        else
                            user_info.propslist[props_id] = props_count
                        end
												eventmgr:dispatchEvent(Event("bag_change_event", {user_id = user_info.userId}));
                        
                    end  
                    --ִ�лص�����
                    if(complete_callback_func ~= nil) then complete_callback_func(props_count) end  
                 end, user_info.userId)
end

--�ӵ��ߵ��½ӿڣ��Ժ������������������Ҳ�����ʱҲ�ӵ���
function tex_gamepropslib.add_tools(props_id, add_count, user_id, complete_callback_func)
    --������ID�Ƿ���Ч
    if(tex_gamepropslib.vaild_props_id(props_id) == 0) then return end
	local user_info = usermgr.GetUserById(user_id)
    --���µ����ݿ�   
    local sql = string.format(tex_gamepropslib.SQL.update_props_count, user_id, props_id, add_count);
        dblib.execute(sql, 
                 function(dt) 
                 	local props_count = 0
                    if (dt and #dt > 0 and user_info ~= nil) then
                    	
                        props_count = dt[1].total_count or 0
                        --��ҵ����б�
                        local propslist = tex_gamepropslib.get_props_list(user_info)
                        --���³ɹ����ŵ��ڴ���
                        if(propslist[props_id] == nil) then
                            table.insert(user_info.propslist, props_id, props_count)
                        else
                            user_info.propslist[props_id] = props_count
                        end
												eventmgr:dispatchEvent(Event("bag_change_event", {user_id = user_info.userId}));
                        
                    end
                    --ִ�лص�����
                    if(complete_callback_func ~= nil) then complete_callback_func(props_count) end
                 end, user_id)
end

--������ID�Ƿ���Ч��0����Ч��1����Ч
function tex_gamepropslib.vaild_props_id(props_id)
    local is_valid = 0
    for k, v in pairs(tex_gamepropslib.PROPS_ID) do
        if(props_id == v) then
            is_valid = 1
            break;
        end
    end
    return is_valid
end


--��ȡ����ڴ��еĵ����б�
function tex_gamepropslib.get_props_list(user_info)
    if(user_info.propslist == nil) then
        user_info.propslist = {}
    end
    return user_info.propslist
end


--�յ�����������б����ݡ���Ϣ
function tex_gamepropslib.on_recv_get_props(buf)
		local get_count = function(tab)
			local i = 0
			for k, v in pairs(tab) do
				i = i + 1
			end
			return i
	  end
	  
    local user_info = userlist[getuserid(buf)]
    if not user_info then return end
    --��ͻ��˷��͵����б�
    local send_to_func = function(temp_propslist)
        netlib.send(
                function(buf)
                    buf:writeString("TXPROPS")      --���ͻ���Э�飬�����б�
                    buf:writeInt(get_count(temp_propslist));
                    for k, v in pairs(temp_propslist) do
                        buf:writeInt(k)     --  ID
                        buf:writeInt(v)     --  ����
                    end
                end,user_info.ip,user_info.port)
    end
    	--TraceError("�յ�����������б����ݡ���Ϣ1111111111111111111")
    local propslist = tex_gamepropslib.get_props_list(user_info)
    --�ڴ���û�е��ߣ��������ݿ��ȡ
    if(#propslist < tex_gamepropslib.PROPS_LEN) then
    	
        local sql = string.format(tex_gamepropslib.SQL.select_props_count, user_info.userId);
        dblib.execute(sql, 
                    function(dt)
                        if (dt and #dt >= 0) then
                            --�������ݣ��ŵ��ڴ���
                            for i = 1, #dt do
                                local temp_id = dt[i].props_type
                                if(tex_gamepropslib.vaild_props_id(temp_id) == 1) then
                                    table.insert(user_info.propslist, temp_id, dt[i].total_count)
                                end
                            end
                        end
                        --���ݶ����еĵ���ID���жϵ���
                        for k, v in pairs(tex_gamepropslib.PROPS_ID) do
                            --������ݿ���е��߲�ȫ�����øõ�������Ϊ0
                            
                            if(user_info.propslist[v] == nil) then
                                table.insert(user_info.propslist, v, 0)
                            end
                        end
                        --��ͻ��˷��͵����б�
                        send_to_func(user_info.propslist)
                    end)
    else
        --��ͻ��˷��͵����б�
        send_to_func(propslist)
    end
end

--�յ����������͵��ߡ���Ϣ
function tex_gamepropslib.on_recv_togive_props(buf)
    local user_info = userlist[getuserid(buf)]; 
    if not user_info then return end;

	local props_id = buf:readInt()
    local togive_props_count = buf:readInt()   --�������������ţ���ʱ����
	local tosites_len = buf:readInt()
	local tosites = {}
	--����ǰ󶨵Ĳ��ܽ���
	if props_id >= 27 and props_id <= 35 then return end
	for i = 1, tosites_len do
		tosites[i] = buf:readByte()
    end

    if (togive_props_count < 1) then
        TraceError("�����͵��� num < 0  "..user_info.userId.."   "..user_info.ip)
	    return
    end
    
    if (togive_props_count > 1 and tosites_len ~= 1) or (togive_props_count ~= 1 and tosites_len > 1) or (tosites_len < 1) or (togive_props_count < 1) then
   	    TraceError("�����˺����͵�����������1����������")
   	    return
    end
    
	--��ȡ����������ִ���������
    local complete_callback_func = function(props_count)
        if(props_count == nil or props_count < tosites_len) or props_count < togive_props_count then
                tex_gamepropslib.net_send_error_result(user_info, 9)
                return;
            end

            local last_toprops_time = user_info.last_toprops_time or 0
            if(os.clock()*1000 - last_toprops_time < 800) then
                --TraceError("���͵��ߣ������̫����")
                return
            end
            user_info.last_toprops_time = os.clock()*1000
        	
        	--��¼����ʧ�ܵ����
        	local failedusers = {}

          local retcode = 0
        	for i = 1, #tosites do
        		local touser_info = nil
        		local tosite = tosites[i]
        		if(tosite and tosite ~= 0) then
        			if(user_info.desk and user_info.site) then
        				touser_info = deskmgr.getsiteuser(user_info.desk, tosite)
        			else
        				--TraceError("��ս��ʱ������͵��ߣ�")
        			end
                else
        			--�͸��Լ�
        			touser_info = user_info
        		end
        		if touser_info then
                    --TraceError("user_info:"..user_info.userId.."  touser_info:"..touser_info.userId)
                    if(user_info.userId == touser_info.userId) then
                        --TraceError("����ɣ��Լ����Լ��͵��ߣ�")
        		    else
        					retcode = do_togive_props(user_info, touser_info, props_id, togive_props_count)     		
                        if(retcode ~= 1) then
        					table.insert(failedusers, {site = touserinfo.site or 0, retcode = retcode})
        				end
                    end
                    
        		end
        	end
        	--ֻ������Ϸ�в�����������ʧ�ܵ����
        	if(user_info.desk and user_info.site) then
        		tex_gamepropslib.net_send_togive_props_result(user_info, failedusers)
        	end
    end
	
    tex_gamepropslib.get_props_count_by_id(props_id, user_info, complete_callback_func)

end

--ִ�����͵���
--����:1=�ɹ� 5=���߲��� 6=������վ������
function do_togive_props(user_info, touser_info, props_id, togive_props_count)
	if not user_info or not touser_info then
		--TraceError("˭�͸�˭����")
		return 0
	end
    --TraceError("do_togive_props user_info.userId:"..user_info.userId.."  touser_info:"..touser_info.userId)
	local retcode = 0
	--ֻ������Ϸ�в��ܸ������͵���
	if(user_info.desk and user_info.site and touser_info.site) then
		local deskdata = deskmgr.getdeskdata(user_info.desk)
		local sitedata = deskmgr.getsitedata(user_info.desk, user_info.site)
		local tosite = touser_info.site
	
		local tositedata = deskmgr.getsitedata(user_info.desk, tosite)
		
		local props_num = user_info.propslist[props_id] or 0;
        if(props_num < togive_props_count) then
            retcode = 5
        else
            retcode = 1
		end
	else
		--TraceError("�����²���������")
        retcode = 6
    end

    local user_callback_func = function(temp_props_count)
        --���ͳɹ���֪ͨ�ͻ��ˣ����µ�������TIPS
        tex_gamepropslib.net_send_refresh_props_count(user_info, props_id, temp_props_count)
        --�㲥���������ﶯ��
        local nolimit_ture = 0;
				for _,v in pairs (config_for_yunying.cannot_puton_gift) do
					if v == props_id then
						nolimit_ture = 1;
						break
					end
				end
				--if nolimit_ture ~= 1 then
                    tex_gamepropslib.net_broadcast_togive_props(user_info.desk, user_info.site, touser_info.site, props_id, 2,togive_props_count)
                    --[[
                else
    			tex_gamepropslib.net_broadcast_togive_props(user_info.desk, user_info.site, touser_info.site, props_id, 7,togive_props_count)
                --]]
                --end
    end

    local touser_callback_func = function(temp_props_count)
        --���ͳɹ���֪ͨ�ͻ��ˣ����µ�������TIPS
        tex_gamepropslib.net_send_refresh_props_count(touser_info, props_id, temp_props_count)
         --����������ҵĵ�������
         --���³ɹ��˱�������ң��ټ����Լ�������
        tex_gamepropslib.set_props_count_by_id(props_id, -1*togive_props_count, user_info, user_callback_func, 2)
    end

    if(retcode == 1)then	   
        --���±�������ҵĵ�������
        tex_gamepropslib.set_props_count_by_id(props_id, togive_props_count, touser_info, touser_callback_func, 3)


        local user_id = user_info.userId;
        if(duokai_lib ~= nil and duokai_lib.is_sub_user(user_id) == 1) then
            user_id = duokai_lib.get_parent_id(user_id);
        end
        dblib.execute(string.format(tex_gamepropslib.SQL.give_props_log, user_id, touser_info.userId, props_id, togive_props_count));
    end

    return retcode
end

--���������ﶯ��
function tex_gamepropslib.net_broadcast_togive_props(deskno, fromsite, tositeno, props_id, typenumber, props_number)
    net_broadcast_give_gift(deskno, fromsite, tositeno, props_id, typenumber, props_number);
end

--���͵��߽��
function tex_gamepropslib.net_send_togive_props_result(user_info, failedusers)
    if(not user_info or not failedusers) then
        return
    end
    netlib.send(
        function(buf)
            buf:writeString("TXBGFF")
            buf:writeInt(#failedusers)
            for i = 1, #failedusers do
                buf:writeByte(failedusers[i].site)	
                buf:writeInt(failedusers[i].retcode) --1=�ɹ����� 5=���߲��� 6=������վ������ 0=�����쳣
            end
        end
    , user_info.ip, user_info.port)
end

function tex_gamepropslib.net_send_error_result(user_info, retcode)
    if not user_info then return end
    netlib.send(
		function(buf)
			buf:writeString("TXBGFD")
			buf:writeByte(retcode)	--9=���߲��� 
		end
	, user_info.ip, user_info.port, borcastTarget.playingOnly)
end


--֪ͨ�ͻ��ˣ����µ�������TIPS
function tex_gamepropslib.net_send_refresh_props_count(user_info, props_id, props_count)
    netlib.send(
        function(buf)
            buf:writeString("TXREDJNUM")
            buf:writeInt(props_id)
            buf:writeInt(props_count)
        end
    , user_info.ip, user_info.port)
end

--�û���¼��ʼ������
function tex_gamepropslib.on_after_user_login(e)

    local user_info = e.data.userinfo;
	if(user_info==nil)then return end;
	
     
    if(user_info.propslist == nil or #user_info.propslist==0) then
    	user_info.propslist={}
    	
    	 for i = 1,tex_gamepropslib.PROPS_LEN do
	       	table.insert(user_info.propslist, i, 0)
	     end
	     
        --�ڴ����Ϊ�գ�������ݿ�
        local sql="select props_type,total_count from user_props_info where user_id=%d order by props_type"
		sql=string.format(sql,user_info.userId)
        dblib.execute(sql, 
                    function(dt)
                       if (dt and #dt > 0) then
                       
                            for i = 1,#dt do
                                local v = dt[i]["props_type"]
                       		
                            	user_info.propslist[v]=dt[i]["total_count"]
                            end
                            eventmgr:dispatchEvent(Event("after_get_props_list", {user_id = user_info.userId}));
                       end
                    end)
    
    end
	
	
end

--�ͻ�������򿪱���
function tex_gamepropslib.on_recv_open_box(buf)
	local user_info = userlist[getuserid(buf)]
	if user_info == nil then return end
	local item_id = buf:readInt()
	if tonumber(groupinfo.groupid) ~= 18001 then return end
	
	--�ж��ǲ��Ǳ��䣬�Ǳ�����ÿ�����ӿ�
	for k,_ in pairs (config_for_yunying.BOX_PORBABILITY_LIST) do
		if item_id == k then
			tex_gamepropslib.open_box(user_info, item_id)
			return
		end
	end
	
	--��������ͷ׵��ߺ�����Ϣ������ģ���Ӧ����
  eventmgr:dispatchEvent(Event("use_item_event", {user_id = user_info.userId, item_id=item_id}));
  
	--�ж��ǲ���ĩ���и�
	if item_id == tex_gamepropslib.PROPS_ID.MORI_QIEGAO then
		if end_world and end_world.check_time() == 1 then
			end_world.use_qiegao(user_info, item_id)
		else
			--todoreturn����ڡ���
			netlib.send(function(buf)
				buf:writeString("TXOPENBOX")
				buf:writeByte(-1)									
				buf:writeInt(0)
				buf:writeByte(0)
				buf:writeInt(0)
				buf:writeInt(0)	
			end, user_info.ip, user_info.port)
		end
	end
	--�ж��ǲ��Ǵ���Ȫˮ
	if item_id == tex_gamepropslib.PROPS_ID.NEWYEAR_WATER then
		if new_year and new_year.check_time() == 1 then
			new_year.use_water(user_info)
		else
			netlib.send(function(buf)
				buf:writeString("TXOPENBOX")
				buf:writeByte(-1)									
				buf:writeInt(0)
				buf:writeByte(0)
				buf:writeInt(0)
				buf:writeInt(0)	
			end, user_info.ip, user_info.port)
		end
	end
	--ʹ�ô��ڵ���
	if item_id >= tex_gamepropslib.PROPS_ID.NEWYEAR_REDBAG and item_id <= tex_gamepropslib.PROPS_ID.NEWYEAR_CARKEY then
		if new_year then
			new_year.use_box(user_info, item_id)
		else
			netlib.send(function(buf)
				buf:writeString("TXOPENBOX")
				buf:writeByte(-1)									
				buf:writeInt(0)
				buf:writeByte(0)
				buf:writeInt(0)
				buf:writeInt(0)	
			end, user_info.ip, user_info.port)
		end
	end
end

function tex_gamepropslib.open_box(user_info, item_id)
	--���ñ����ӿڲ��ұ��䣬�б���Ļ��ͱ�������-1
	local set_count_box = function(nCount)
		if nCount >= 1 then
				if gift_getgiftcount(user_info) >= 100 then
					net_send_gift_faild(user_info, 5)		--���߿ͻ�����������
					user_info.update_open_box_update_db = 0
					return
				end	
				--�������
				local call_back = function ()
					--�������ݿ����
					user_info.update_open_box_update_db = 0
					local find = 1;
					local add = 0;
					local rand = math.random(1, 10000);
					for i = 1, #config_for_yunying.BOX_PORBABILITY_LIST[item_id] do
								add = add + config_for_yunying.BOX_PORBABILITY_LIST[item_id][i];
								if add >= rand then
										find = i;
									break;
								end
					end
					if config_for_yunying.BOX_ITEM_GIFT_ID[item_id][find][4] and 
					   tex_gamepropslib.already_get[item_id] and
					   tex_gamepropslib.already_get[item_id][find] and
					   tex_gamepropslib.already_get[item_id][find] >= config_for_yunying.BOX_ITEM_GIFT_ID[item_id][find][4] then
					    
					    find =1 
					    --TraceError("�������ޣ�ǿ�ư���")
					end  
					--���ñ����ӿڸ����ߣ����Ϳͻ���Э��
				    if find > 0 then
						local type_id          = config_for_yunying.BOX_ITEM_GIFT_ID[item_id][find][1]
						local item_gift_id     = config_for_yunying.BOX_ITEM_GIFT_ID[item_id][find][2]
						local item_number      = config_for_yunying.BOX_ITEM_GIFT_ID[item_id][find][3]
						if type_id == 1 or type_id == 7 then	
							tex_gamepropslib.set_props_count_by_id(item_gift_id, item_number, user_info, nil)
						elseif type_id == 2 then
							--������
							gift_addgiftitem(user_info, item_gift_id, user_info.userId, user_info.nick, 0)
						elseif type_id == 3 then
							--������
							for i = 1,item_number do 
							  car_match_db_lib.add_car(user_info.userId, item_gift_id, 0);
							end
						elseif type_id == 4 then
							--����Ʊ
							daxiao_adapt_lib.add_exyinpiao(user_info.userId,item_number,0,3)
							--daxiao_lib.add_yinpiao(user_info.userId,buy_yinpiao*temp_flag,0,buy_type)	
						end
						
						if tex_gamepropslib.already_get[item_id] and tex_gamepropslib.already_get[item_id][find] then
						  tex_gamepropslib.already_get[item_id][find] = tex_gamepropslib.already_get[item_id][find] + item_number
						end
						
						--��¼�����ӻ�õĵ���
						tex_gamepropslib.record_gift_box_log(user_info,item_gift_id,type_id,item_number,item_id)
						eventmgr:dispatchEvent(Event("bag_open_box_event", {user_id = user_info.userId, box_id=item_id, type_id=type_id, item_gift_id= item_gift_id, item_number=item_number}));
						netlib.send(function(buf)
							buf:writeString("TXOPENBOX")
									buf:writeByte(1)									
									buf:writeInt(item_id)
									buf:writeByte(type_id)
									buf:writeInt(item_gift_id)
									buf:writeInt(item_number)	
						end, user_info.ip, user_info.port)
						
						--���㲥��Ϣ
						local match_name = "��ͨ"
						if item_id == 200003 then
							match_name = "����"
						end

						local msg = "��%s���ھ���������%s�����һ������ϲ���ɣ�"
						
						if (item_id == 200002 or item_id == 200003) and tex_gamepropslib.REWARDMSG_ITEM_NAME[item_gift_id] ~= nil then  
								msg = string.format(msg, match_name, tex_gamepropslib.REWARDMSG_ITEM_NAME[item_gift_id])
								tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
						end
						
						msg = "��%s�л��%s��"
						if (item_id == 200004 or item_id == 200005 or item_id == 200006) and type_id == 3 then  
								msg = string.format(msg, tex_gamepropslib.BOX_NAME[item_id], car_match_lib.CFG_CAR_INFO[item_gift_id]["name"])
								tex_speakerlib.send_sys_msg( _U("��ϲ")..user_info.nick.._U(msg))
						end
					end
				end  --end call_back			
				tex_gamepropslib.set_props_count_by_id(item_id, -1, user_info, call_back)
		else
			user_info.update_open_box_update_db = 0
			return
		end
	end
	
	--������ݿ������򷵻�
	if user_info.update_open_box_update_db == 1 then
		--[[timelib.createplan(function()
			user_info.update_open_box_update_db = 0
		end, 10)--]]
		return
	end
	--�������ݿ�
	user_info.update_open_box_update_db = 1
	tex_gamepropslib.get_props_count_by_id(item_id, user_info, set_count_box)	
	
end

--�̳ǹ�����ã��ж��ǲ��Ǻϳ�ͼֽ �� ���� �ͷ׺��ӿ��۵���
function tex_gamepropslib.is_gameprops(user_info, to_user_info, giftid, gift_num)
	if (not user_info) or (not to_user_info) or (not giftid) then
		return 0;
	end
	
	if giftid > 100000 and giftid < 200000 then

		--���ӱ������ͼֽ
		tex_gamepropslib.set_props_count_by_id(giftid, gift_num or 1, to_user_info, nil)

		--��¼����ͼֽlog
		if hecheng_db_lib then
			hecheng_db_lib.record_tz_change(to_user_info,giftid,1)
		end
		return 1;
	end
	if giftid > 200000  or giftid < 998 then
		--���ӱ�����ĺ���	
		tex_gamepropslib.set_props_count_by_id(giftid, gift_num or 1, to_user_info, nil)
		--��¼����ͼֽlog
		--hecheng_db_lib.record_tz_change(user_info,giftid,1);
		tex_gamepropslib.record_gift_box_log(to_user_info,giftid,-1,gift_num)	
		return 2
	end
	return 0;	
end
--�ж�һ��id����Ʒ��������(���Ե��ж�һ�������ﻹ�ǵ���)����������������
function tex_gamepropslib.get_type_pro_gift(giftid)
  if giftid > 100000  or giftid < 998 then
    return 1
  else
    return 2
  end
end

function tex_gamepropslib.record_gift_box_log(user_info,item_id,type_id,item_number,box_id)
		if not user_info or not item_id  then 
			return
		end
		if not type_id then type_id = 1 end
		if not item_number then item_number = 1 end
		if not box_id then box_id = 0 end
		local user_id = user_info.user_id
    local sqltemple = "INSERT INTO log_gift_box(user_id, item_id, type_id, item_number, box_id, sys_time)value(%d, %d, %d, %d, %d, now()) ";
    sqltemple = string.format(sqltemple, user_info.userId, item_id, type_id, item_number, box_id);
    dblib.execute(sqltemple);
end

function tex_gamepropslib.timer(e)
	local current_time = os.time()
	--ÿ�������һ��֮ǰһ�������
	if tex_gamepropslib.clear_data_time == nil or  
	tex_gamepropslib.is_today(tex_gamepropslib.clear_data_time,current_time) == 0 then
		for k1,v1 in pairs (tex_gamepropslib.already_get) do
		  for k2,v2 in pairs(v1) do
		    tex_gamepropslib.already_get[k1][k2] = 0
		  end
		end
		tex_gamepropslib.clear_data_time=current_time
	end

end


--�ǲ�����ͬһ��
function tex_gamepropslib.is_today(time1,time2)
	if time1==nil or time2==nil or time1=="" or time2=="" then return 0 end
	local table_time1 = os.date("*t",time1);
	local year1  = table_time1.year;
	local month1 = table_time1.month;
	local day1 = table_time1.day;
	local time1 = year1.."-"..month1.."-"..day1.." 00:00:00"
	
	local table_time2 = os.date("*t",time2);
	local year2  = tonumber(table_time2.year);
	local month2 = tonumber(table_time2.month);
	local day2 = tonumber(table_time2.day);
	local time2 = year2.."-"..month2.."-"..day2.." 00:00:00"
	
	--�ݴ������ʱ���õ��յģ���õ�1970��
	if tonumber(year1)<2012 or tonumber(year2)<2012 then 
		return 0 
	end
	if time1~=time2 then
		return 0
	end
	return 1
end


--�����б�
cmd_gameprops_handler = 
{
	["TXPROPS"] = tex_gamepropslib.on_recv_get_props, --�յ�����������б����ݡ���Ϣ
    ["TXTOUDJ"] = tex_gamepropslib.on_recv_togive_props, --�յ����������͵��ߡ���Ϣ
    ["TXOPENBOX"] = tex_gamepropslib.on_recv_open_box,  --������ͷ׵��ߺ�
}

--���ز���Ļص�
for k, v in pairs(cmd_gameprops_handler) do 
	cmdHandler_addons[k] = v
end


eventmgr:addEventListener("timer_minute", tex_gamepropslib.timer)
eventmgr:addEventListener("h2_on_user_login", tex_gamepropslib.on_after_user_login);


