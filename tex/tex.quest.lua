
TraceError("init riddle_forgs....")
if not tex_dailytask_lib then
	tex_dailytask_lib = _S
	{
        checker_datevalid = NULL_FUNC,		--ʱ��У��        
        on_game_over = NULL_FUNC,			--��Ϸ���������ж�
        on_quan_change = NULL_FUNC,			--��ȯ�仯֪ͨ
        onRecvDakaiZhuanpan = NULL_FUNC,	--�յ���ת��
        onRecvKaishiChoujiang = NULL_FUNC,	--��ʼ�齱
        get_vaild_paixin = NULL_FUNC,	--��ʼ�齱
        on_after_user_login = NULL_FUNC,	--��¼����Ϣ
        get_lottery_count = NULL_FUNC,	--��ȡ��ȯ����
        get_pai_xin = NULL_FUNC,	--��ȡ��������
        add_lottery_count = NULL_FUNC,	--���ٽ�ȯ����
        notify_lottery_change = NULL_FUNC,	--֪ͨ��ȯ�����仯
        do_notify_lottery_change=NULL_FUNC,--֪ͨ��ȯ�����仯
        find_friend_play=NULL_FUNC, --�ӹ����ѣ���������پ�
        is_qianshan=NULL_FUNC, --����ǰ����
        get_tex_daren_count=NULL_FUNC, --��Ϊ����ÿ�մ��˼���
        get_daren_list=NULL_FUNC, --���½�ȯ�������� 
        get_this_month_paiming=NULL_FUNC,  --���½�ȯ��������
        get_month_reward_count=NULL_FUNC, --���»�ý�ȯ��
        all_task_down=NULL_FUNC, --�������������
        set_mingci=NULL_FUNC,--���õ���������Σ�ֻ���ǲ��ǽ����ǰ������
        get_mingci=NULL_FUNC,--�õ�����������Σ�ֻ���ǲ��ǽ����ǰ������
        give_kick_card=NULL_FUNC, --�����˿�
        add_yesterday_questgold=NULL_FUNC,--����������������˼�Ǯ
        get_already_used_today=NULL_FUNC, --�����õ��Ľ�����
        flash_paihang=NULL_FUNC,--ˢ�����а�
        ontimer_flash_paihang=NULL_FUNC,--��ʱˢ�����а�
        OnTimeCheckQuest=NULL_FUNC,--��ʱˢ�����а�
        set_addfriend_status=NULL_FUNC,--����һ�μӺ��ѵ�ʱ��
        update_user_playcount=NULL_FUNC,--������ҽ������˶�����
        get_last_monthday=NULL_FUNC,--�õ����ھ����µ��ж�����
        init_memory_data=NULL_FUNC,  --��ʼ�������ҵ���������ݵ��ڴ���
        is_finish_all_pai_xin=NULL_FUNC, --�Ƿ�����������
        get_vaildroom_paixin=NULL_FUNC,--���������㷿���Ҫ��
        update_pai_xin=NULL_FUNC,--ÿ������
        init=NULL_FUNC,--��ʼ��
        fajiang_month=NULL_FUNC, --ÿ�·���
        is_init = false,
        common_gold=0,	--��ͨ�����Ҫ��1������齱
        daren_gold=0,	--�н���ʱֻҪ��1ǧ�����齱
	}
end

wdg_today_paihang={} --�������������100��
wdg_yestoday_paihang={} --���������100��
last_flash_paihang_day="" --���һ��ˢ�����е�ʱ��
--��ʱˢ�����а�


--�ж�ʱ��ĺϷ��ԣ����ڲ��ǻ�ˣ��ĳ�ÿ�������ˣ����Բ����ж�ʱ���ˡ�
tex_dailytask_lib.checker_datevalid = function()
	--local starttime = os.time{year = 2011, month = 5, day = 19,hour = 10};
	--local endtime = os.time{year = 2011, month = 5, day = 26,hour = 0};
	--local sys_time = os.time()
    --if(sys_time < starttime or sys_time > endtime) then
    --    return false
	--end
    return true
end

function tex_dailytask_lib.h2_after_user_login(e)
    local user_info = e.data.userinfo
    tex_dailytask_lib.on_after_user_login(user_info, viplib.get_vip_level(user_info))
end

--�û���¼���¼�
tex_dailytask_lib.on_after_user_login = function(userinfo, viplevel, call_back)

    if (userinfo.wdg_huodong == nil) then
        userinfo.wdg_huodong = {}
        userinfo.wdg_huodong.lottery_count = 0
        userinfo.wdg_huodong.pai_xin = 0
		userinfo.wdg_huodong.pan_shu = 0
        userinfo.wdg_huodong.today_used_count=0 --�������˶��ٽ���
        userinfo.wdg_huodong.lottery_all_count=0 --���еĽ���
        userinfo.wdg_huodong.this_month_paiming=0  --��������
        userinfo.wdg_huodong.daren_count=0  --��Ϊ���˵Ĵ���
        userinfo.wdg_huodong.last_login = os.time()
    end
    --�������õõ������������
    tex_dailytask_lib.init_memory_data(userinfo)
    
    local sql = "call sp_huodong_wdg_init_user_lottery_info(%d, %d)"    
    sql = string.format(sql, userinfo.userId, viplevel)
   
    dblib.execute(sql, 
         function(dt)
            if (dt and #dt > 0) then
                if (userinfo.wdg_huodong == nil) then
                    userinfo.wdg_huodong = {}
                end
                userinfo.wdg_huodong.lottery_count = dt[1]["lottery_count"]
                userinfo.wdg_huodong.pai_xin = dt[1]["pai_xin"]
                userinfo.wdg_huodong.today_used_count = dt[1]["today_used_count"]
                userinfo.wdg_huodong.lottery_all_count = dt[1]["lottery_all_count"]
                userinfo.wdg_huodong.daren_count = dt[1]["daren_count"]
                userinfo.wdg_huodong.pan_shu = dt[1]["pan_shu"]
                userinfo.wdg_huodong.yesterday_pai_xin = dt[1]["yesterday_pai_xin"]
                userinfo.wdg_huodong.add_friend_time = timelib.db_to_lua_time(dt[1]["add_friend_time"])

                if(viplib.get_vip_level(userinfo)>0)then
                    tex_dailytask_lib.update_pai_xin(userinfo,512)
                end
                --tex_dailytask_lib.do_notify_lottery_change(userinfo)
                --tex_dailytask_lib.fuck_clear_error(userinfo)
            end
            if (call_back ~= nil) then
                call_back()
            end
         end)
end

--��������ݳ����Ͱ���ҵĽ���������������ֿ���
-- [[
tex_dailytask_lib.fuck_clear_error = function(userinfo)
	local table_time = os.date("*t", os.time())
	local now_day = table_time.day
	local most_lottery = now_day * 11 --������Ϊֹ�������еĽ���
	if userinfo.wdg_huodong.lottery_all_count > most_lottery then
		userinfo.wdg_huodong.lottery_all_count = most_lottery
		local sql = "update user_huodong_wdg_info set lottery_all_count = %d where user_id = %d"
		sql = string.format(sql, most_lottery, userinfo.userId)
		dblib.execute(sql, function(dt) end, userinfo.userId)
	end
end
--]]
--��ȡ��ȯ����
tex_dailytask_lib.get_lottery_count = function(userinfo)
    if (userinfo.wdg_huodong ~= nil and userinfo.wdg_huodong.lottery_count ~= nil) then
        return userinfo.wdg_huodong.lottery_count
    else
        --TraceError("û�л�ȡ��ȯ")
        return 0
    end
end

--��ȡ����
tex_dailytask_lib.get_pai_xin = function(userinfo)
    if (userinfo.wdg_huodong ~= nil and userinfo.wdg_huodong.pai_xin ~= nil) then
        return userinfo.wdg_huodong.pai_xin
    else
        --TraceError("û������")
        return 0
    end
end

--�޸Ľ�ȯ����,1��ʾ�ɹ���0��ʾʧ��
tex_dailytask_lib.add_lottery_count = function(userinfo, count)
 
    --TraceError(debug.traceback())
    if (userinfo.wdg_huodong.lottery_count + count >= 0) then
        userinfo.wdg_huodong.lottery_count = userinfo.wdg_huodong.lottery_count + count
    else
        --TraceError("��ȯ����Ҫ��ɸ����ˣ���ô���ٰ���")
        return 0
    end
    local sql = "update user_huodong_wdg_info set lottery_all_count = lottery_all_count + %d, lottery_count = lottery_count + %d,today_used_count=today_used_count + abs(%d) where user_id = %d and lottery_count >= 0;insert log_wdg_lottery(user_id, reason, sys_time, count) values(%d, %d, now(), %d);commit;"
    sql = string.format(sql, count < 0 and 0 or 1, count, count < 0 and 1 or 0, userinfo.userId, userinfo.userId, (count > 0 and 2 or 3), count);
 
    dblib.execute(sql, function() end, userinfo.userId)
   -- if (userinfo.wdg_huodong.lottery_count == 0) then
    --    tex_dailytask_lib.do_notify_lottery_change(userinfo)
  --  end
    --����һ�ţ������������䣬����ʹ�ü�1������һ�ţ�����������1������ʹ�ò���
    userinfo.wdg_huodong.today_used_count=userinfo.wdg_huodong.today_used_count+ (count < 0 and 1 or 0)
    userinfo.wdg_huodong.lottery_all_count=userinfo.wdg_huodong.lottery_all_count+(count < 0 and 0 or 1)
    return 1
end

function tex_dailytask_lib.pay_gold(user_info, gold)
    local retcode = 0;
    if(user_info.desk and user_info.site) then
        local deskdata = deskmgr.getdeskdata(user_info.desk);
        local sitedata = deskmgr.getsitedata(user_info.desk, user_info.site);
        retcode = dobuygift1(user_info, deskdata, sitedata, 0, gold);
        --����ɹ�
    else
        retcode = dobuygift2(user_info, 0, gold)
    end
    return retcode;
end

function tex_dailytask_lib.onRecvKaishiChoujiang(buf)
	local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
    local advUser = {}    
	local spend_gold = tex_dailytask_lib.daren_gold; --���ѵ�Ǯ

	local userdata = deskmgr.getuserdata(userinfo)
 
	local giftinfo = userdata.giftinfo 
	local giftcount = 0
	for k, item in pairs(giftinfo) do
		giftcount = giftcount + 1
	end

    if giftcount >= 100 then
        netlib.send(
    		function(buf)
    			buf:writeString("TXSTIPS")
    			buf:writeByte(1)	--�����byte (1, ��ʾ����������2�������ڴ����״ε�¼�ᵯ����ϲ�Ի���)
                buf:writeByte(0)    --����Ϊ0���������£�Ϊ�����¶ȴ󽱼��������Ĵ���
    		end, userinfo.ip, userinfo.port)
        return
    end

    local ret = tex_dailytask_lib.add_lottery_count(userinfo, -1)
    
    --��ȯ����,��Ҫ��1��飬��Ȼ��ֻҪ1ǧ��
    if(ret==0) then 
    	spend_gold = tex_dailytask_lib.common_gold
    else
    	spend_gold = tex_dailytask_lib.daren_gold
    end

    --������1ǧ�鶼û��
    local result = 1
    --������óɲ���Ǯ�齱����ô�������Ͳ��ܳ齱�ˡ�
	if spend_gold ~= 0 then
    	result = tex_dailytask_lib.pay_gold(userinfo, spend_gold);
    elseif ret == 0 then
    	result = 0
    end
    if (result ~= 1) then
        if(ret == 0) then
            --TraceError("��ȯ�����ˣ��޷��齱")
            local alreaddy_used_today = tex_dailytask_lib.get_already_used_today(userinfo)
            netlib.send(
                function(buf)
                    buf:writeString("TXKSCJ")
                    buf:writeInt(0)  
                    buf:writeInt(-3)  --֪ͨ�ͻ��˽�ȯ����
                    buf:writeInt(alreaddy_used_today or 0)--���˼��Ž���
                end,userinfo.ip,userinfo.port)
        else
            --�����ˣ�����Ǯ����
            tex_dailytask_lib.add_lottery_count(userinfo, 1);
        	netlib.send(
                    function(buf)
                        buf:writeString("TXSTIPS")
                        buf:writeByte(3)  
                        buf:writeInt(0) 
                    end,userinfo.ip,userinfo.port)
            end
        return  
    end

    local isAdvUser = 0
    if (advUser[userinfo.userId] ~= nil) then
        isAdvUser = 1
    end
    local sql = "call sp_huodong_wdg_get_random_gift(%d, %d)"
    sql = string.format(sql, userinfo.userId, isAdvUser)
   
    dblib.execute(sql, 
         function(dt)
             if (dt and #dt > 0) then
                local jiangpin = dt[1]["gift_id"]
                local desc = ""

                 
    --��Ʒid��Ӧ��
    --1�������˿˴�ʦ��װ
    --5005���ڱ�ʯ
    --3��С����ҩˮ
    --4������ҩˮ
    --5;  ����
    --6; ���˿�
    --5007�������
    --5008��������
    --5009��������
    --5010��һ����

    -----------------------------------------
	--TraceError("dddddddddddddddddd:"..jiangpin)
    if jiangpin == 1 then
        --desc = "�����˿˴�ʦ��װһ��"
        desc = tex_lan.get_msg(userinfo, "quest_desc_jiangpin_1");
    elseif jiangpin == 5005 then
        --desc = "�ڱ�ʯһö"
        desc = tex_lan.get_msg(userinfo, "quest_desc_jiangpin_5005");
    elseif jiangpin == 5007 then
        --desc = "���������"
        desc = tex_lan.get_msg(userinfo, "quest_desc_jiangpin_5007");
    elseif jiangpin == 5008 then
        --desc = "����������"
        desc = tex_lan.get_msg(userinfo, "quest_desc_jiangpin_5008");
    elseif jiangpin == 5009 then
        --desc = "����������"
        desc = tex_lan.get_msg(userinfo, "quest_desc_jiangpin_5009");
    elseif jiangpin == 5010 then
        --desc = "����һ����"
        desc = tex_lan.get_msg(userinfo, "quest_desc_jiangpin_5010");
    end

                --��÷�ҩˮ��Ʒ��ȫ�ֹ㲥
                 if jiangpin == 1 or jiangpin > 5000 then
                    --local msg = "��ϲ���"..userinfo.nick.."�ڰ���ת���г�������"..desc
		            --local msg = _U("��ϲ���").._U(userinfo.nick).._U("�ڰ���ת���г�������").._U(desc)
		            local msg = _U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin")).._U(userinfo.nick).._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_2")).._U(desc)
                    --msg = _U(msg)
                    
                    
                 end
                   --����1288�ĳ����������
                  --if jiangpin == 5043 then
                  --	car_match_db_lib.add_car(userinfo.userId, 5043, 0);
                    --usermgr.addgold(userinfo.userId, 1288, 0, g_GoldType.quest_wdg_jiangping, -1, 1);
                  --end
				
                --���˿�
                  if jiangpin == 6 then
                      if(tex_gamepropslib)then
                          tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, userinfo)
                      end
                  end
              
               --С����
                if jiangpin == 4 then
                      if(tex_gamepropslib)then
                      	tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, userinfo)
                      end
                  end
                  
                --ҩˮ��Ʒ
                if jiangpin == 3  then
                    local exp = 10
              	    usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), exp, g_ExpType.wdg_huodong, groupinfo.groupid)
                end

                --���뱳��
                if jiangpin ~= 3 and jiangpin~=4 and jiangpin~=5 and jiangpin~=6  then
                    gift_addgiftitem(userinfo,jiangpin,userinfo.userId,userinfo.nick, false)                        
                end

                --���й������﷢ȫ���㲥
                if(jiangpin==5011)then
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����˼�ֵ88W������:�µ�A8"),0)
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_5011")),0)
                end

                if(jiangpin==5012)then
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����˼�ֵ28W������:�׿ǳ�"),0)
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_5012")),0)
                end

                if(jiangpin==5013)then
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����˼�ֵ8888������:����"),0)
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_5013")),0)
                end
                
                if(jiangpin==5020)then
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����˼�ֵ28W������:LV��"),0)
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_5020")),0)
                end
                
                if(jiangpin==5021)then
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����˼�ֵ138W������:��ɯ"),0)
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_5021")),0)
                end
                
                if(jiangpin==5001)then
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����˼�ֵ10000������:����ʯ"),0)
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_5001")),0)
                end
                
                if(jiangpin==5022)then
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����˼�ֵ20000������:QQ��"),0)
                    BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_jiangpin_5022")),0)
                end
                


				--����ҳ齱��Ǯ
				--usermgr.addgold(userinfo.userId, -spend_gold, 0, g_GoldType.quest_wdg_choujiang, -1, 1);
				
                --֪ͨ�񽱽��
                --TraceError("֪ͨ�齱�����id="..jiangpin)
                local already_used_today=tex_dailytask_lib.get_already_used_today(userinfo)
            	netlib.send(
                function(buf)
                    buf:writeString("TXKSCJ")
                    buf:writeInt(userinfo.wdg_huodong.lottery_count)  
                    buf:writeInt(jiangpin)  --������
                    buf:writeInt(already_used_today or 0)--���˼��Ž���
                end,userinfo.ip,userinfo.port)
             end
         end)
	
	

    --����Ϊ�����Դ���
    --[[
    local userid = userinfo.userId
    local desc = ""
    local exp = 0
    local giftid = 0
    if userid == 201 then
        jiangpin = 1
        desc = "�����˿˴�ʦ��װһ��"
    elseif userid == 202 then
        jiangpin = 2
        desc = "�ڱ�ʯһö"
        giftid = 5005
    elseif userid == 203 then
        jiangpin = 3
        exp = 50
    elseif userid == 204 then
        jiangpin = 4
        exp = 100
    elseif userid == 205 then
        jiangpin = 5
        desc = "���������"
        giftid = 5007
    elseif userid == 206 then
        jiangpin = 6
        desc = "�����ĵ���"
    elseif userid == 207 then
        jiangpin = 7
        desc = "����������"
        giftid = 5008
    elseif userid == 208 then
        jiangpin = 8
        desc = "����������"
        giftid = 5009
    elseif userid == 209 then
        jiangpin = 9
        desc = "����һ����"
        giftid = 5010
    end
--]]
end

--ÿ���¸��ϸ�������������ҷ���
function tex_dailytask_lib.fajiang_month(userinfo)
    --����������ˣ��Ͳ��������������屳��
    local userdata = deskmgr.getuserdata(userinfo)
    local giftinfo = userdata.giftinfo 
    local giftcount = 0
	for k, item in pairs(giftinfo) do
		giftcount = giftcount + 1
	end

    if giftcount >= 100 then
       netlib.send(
    		function(buf)
    			buf:writeString("TXSTIPS")
    			buf:writeByte(1)	--�����byte (1, ��ʾ����������2�������ڴ����״ε�¼�ᵯ����ϲ�Ի���)
                buf:writeByte(0)    --����Ϊ0����������
    		end, userinfo.ip, userinfo.port)
        return
    end
    
    --�õ���ҵ����Σ�Ҫû�������
    local sql="select mc from pm_month where  left(sys_time,7)=left(DATE_SUB(NOW(), INTERVAL 1 MONTH),7) and ifnull(award_flag,0)=0 and user_id=%d;update pm_month set award_flag=1,award_time=now() where left(sys_time,7)=left(DATE_SUB(NOW(), INTERVAL 1 MONTH),7) and user_id=%d and ifnull(award_flag,0)=0;commit;"
    dblib.execute(string.format(sql,userinfo.userId,userinfo.userId),
    		function(dt)
                if(dt and #dt > 0) then
                    local mc=tonumber(dt[1].mc)

                    --5017����S600,5018ѩ����C2,5019����,5012�׿ǳ�
                    if(mc==1)then
                        gift_addgiftitem(userinfo,5017,userinfo.userId,userinfo.nick, false) 
                        
                    elseif(mc==2)then
                        gift_addgiftitem(userinfo,5012,userinfo.userId,userinfo.nick, false) 
                        
                    elseif(mc==3)then
                        gift_addgiftitem(userinfo,5018,userinfo.userId,userinfo.nick, false)
                    elseif(mc>=4 and mc<=10)then
                        gift_addgiftitem(userinfo,5019,userinfo.userId,userinfo.nick, false)
                        
                    end

                    netlib.send(
                    		function(buf)
                    			buf:writeString("TXSTIPS")
                    			buf:writeByte(2)	--�����byte (1, ��ʾ����������2�������ڴ����״ε�¼�ᵯ����ϲ�Ի���)
                                buf:writeByte(mc)    --����Ϊ0����������
                    		end, userinfo.ip, userinfo.port)
                    --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("������¶ȴ��˴󽱵�"..tostring(mc).."��"),0)
                end
    		end);
end

function tex_dailytask_lib.onRecvDakaiZhuanpan(buf)
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end;
    tex_dailytask_lib.check_fresh_info(userinfo, function()
        local lottery_count = tex_dailytask_lib.get_lottery_count(userinfo)
        local pai_xin = tex_dailytask_lib.get_pai_xin(userinfo)
       
    
    
        -- ���»�ý�ȯ��
        local month_reward_count=tex_dailytask_lib.get_month_reward_count(userinfo)
        
        -- ���½�ȯ��������
        local prev_month_paiming=tex_dailytask_lib.get_this_month_paiming(userinfo)
    
        --��Ϊ����ÿ�մ��˼���
        local tex_daren_count=tex_dailytask_lib.get_tex_daren_count(userinfo)
    
        --6). ���½�ȯ�������� 
    		--	i. �ǳƣ�string
    		--	ii. ��ȯ����int
    		--	iii. ��Ʒ��string
    		--	iv. ������int
        local tex_daren_list=tex_dailytask_lib.get_daren_list(userinfo)
    
        local daren_list_len=0
        if(tex_daren_list==nil)then
            daren_list_len=0
        elseif(#tex_daren_list>10)then
            daren_list_len=10
        else
            daren_list_len=#tex_daren_list
        end
    
        local already_used_today=tex_dailytask_lib.get_already_used_today(userinfo)
        local how_many_days=tex_dailytask_lib.get_last_monthday()--����쵽�µ�
    
        netlib.send(
                function(buf)
                    buf:writeString("TXDKZP")
                    buf:writeInt(lottery_count)  --������
                    buf:writeInt(pai_xin) --������ɶ�
                    buf:writeInt(already_used_today)--�������˼��Ž���
                    buf:writeInt(how_many_days or 0)--����쵽�µ�
                    buf:writeInt(month_reward_count)--���»�ý�ȯ��
                    buf:writeInt(prev_month_paiming)--���½�ȯ��������
                    buf:writeInt(tex_daren_count)--��Ϊ����ÿ�մ��˼���
                    buf:writeByte(daren_list_len)
                    for i=1,daren_list_len do
                        if(tex_daren_list[i]~=nil)then
                            local v=tex_daren_list[i]
                            buf:writeString(v.nick_name or "")
                            buf:writeInt(v.reward_count or 0)
                            buf:writeInt(v.up_or_down or 4)
                        else
                            buf:writeString("")
                            buf:writeInt(0)
                            buf:writeInt(4)
                        end
                    end
                end,userinfo.ip,userinfo.port)
    
         --���¶ȴ�
        tex_dailytask_lib.fajiang_month(userinfo)
    end)
end

--:֪ͨ�ͻ��˽�ȯ�仯֪ͨ
function tex_dailytask_lib.notify_lottery_change(buf)
  
    local userinfo = userlist[getuserid(buf)]; 
    tex_dailytask_lib.do_notify_lottery_change(userinfo)

end

--:֪ͨ�ͻ��˽�ȯ�仯֪ͨ
function tex_dailytask_lib.do_notify_lottery_change(userinfo)
  
	if not userinfo then return end;
    if not userinfo.wdg_huodong then return end;

    --֪ͨ�ͻ��˽��������仯
    netlib.send(
            function(buf)
                buf:writeString("TXJJBH")
                buf:writeInt(userinfo.wdg_huodong.lottery_count or 0)  --��������
            end,userinfo.ip,userinfo.port)
end


--�ж����� ����1���Ϸ����ͣ��Ƿ�����-1
--10(�ʼ�ͬ��˳)��9(ͬ��˳)��8(����)��7(��«)��6(ͬ��)��5(˳��)��4(����)��3(����)��2(һ��)��1(����)
--���������10�֣��ĳɣ���������������ѣ������10����Ϸ����128
--����ǰ������256
--VIP��½��512
--һ�ԣ�1024
--��Ϊ�����������������������ˣ���Ҫ��һЩ�������Ϣ����Ϊ����ԭ���ĳ�����ݣ����Է������Ʋ���
function tex_dailytask_lib.get_vaild_paixin(pai_xin)
    if (pai_xin == 10 or pai_xin == 9) then
        pai_xin = 64
    elseif (pai_xin == 8) then
        pai_xin = 32
    elseif (pai_xin == 7) then
        pai_xin = 16
    elseif (pai_xin == 6) then
        pai_xin = 8
    elseif (pai_xin == 5) then
        pai_xin = 4
    elseif (pai_xin == 4) then
        pai_xin = 2
    elseif (pai_xin == 3) then
        pai_xin = 1
    elseif(pai_xin==2)then
        pai_xin = 1024
    elseif(pai_xin==512)then
        pai_xin=512
    elseif(pai_xin==256)then
        pai_xin=256
    elseif(pai_xin==128)then
        pai_xin=128
    else
        pai_xin = 0
    end
    return pai_xin
end

--�����ǲ�������������ʷ����
function tex_dailytask_lib.get_vaildroom_paixin(pai_xin,smallbet)
    --һ��Ҫ��ר�ҳ���С��1000���Ͳ���ר�ҳ�
    if(pai_xin==1024 and smallbet<1000)then 
        pai_xin=0
    end

    --2��Ҫ��ר�ҳ�,С��1000���Ͳ���ר�ҳ�
    if(pai_xin==1 and smallbet<1000)then 
        pai_xin=0
    end


    --3�Ż�ʤҪ��ר�ҳ�,С��1000���Ͳ���ר�ҳ�
    if(pai_xin==2 and smallbet<1000)then 
        pai_xin=0
    end

    --˳�ӻ�ʤҪ��ר�ҳ���ְҵ��
    if(pai_xin==4 and smallbet<100)then 
        pai_xin=0
    end

    --ͬ����ʤҪ��ר�ҳ���ְҵ��
    if(pai_xin==8 and smallbet<100)then 
        pai_xin=0
    end

    --��«��ʤҪ��ר�ҳ���ְҵ��
    if(pai_xin==16 and smallbet<100)then 
        pai_xin=0
    end

    --ͬ��˳��ʤҪ��ר�ҳ���ְҵ��
    if(pai_xin==64 and smallbet<100)then 
        pai_xin=0
    end

     --������ʤҪ��ר�ҳ���ְҵ��
    if(pai_xin==32 and smallbet<100)then 
        pai_xin=0
    end

    return pai_xin
end

--�Ƿ�������paixin,1������ˣ�0û���
function tex_dailytask_lib.is_finish_all_pai_xin(pai_xin)
    --���������г�������ֱ������Ӻ�Ľ��ֵ���Է�ֹ�Ժ���һҪɾ��һ������ʱ���޸�
    if(pai_xin==(1+2+4+8+16+32+64+128+256+512+1024))then
        return 1
    end
    return 0
end

--id = bit��or(oldid��newid )
--�ж�����
tex_dailytask_lib.on_game_over = function(userinfo, pai_xin, deskno,gold)    
    if(tasklib.is_finish_task(userinfo) == 0) then
        return;
    end

    local deskinfo = desklist[deskno];

    if(deskinfo.desktype == g_DeskType.match) then
        return;
    end

    --���½������ƵĴ�����֮���ڷ���ʱҪ�ã���10�̲��ӹ����ѵ��ж�ʱ�õ��ϣ�
    tex_dailytask_lib.update_user_playcount(userinfo,1)

    --���������10�֣��ĳɣ���������������ѣ������10����Ϸ����128
    if(tex_dailytask_lib.find_friend_play(userinfo,10)==1)then
        tex_dailytask_lib.update_pai_xin(userinfo,128)
    end

    --����ǰ������256���ĳɷ�������ʱֱ�Ӹ�������
    --if(tex_dailytask_lib.is_qianshan(userinfo)==1)then
    --    tex_dailytask_lib.update_pai_xin(userinfo,256)
    --end

    --����ӮǮ���˲����������
    if(gold>0)then
        tex_dailytask_lib.update_pai_xin(userinfo,pai_xin)
    end
end

function tex_dailytask_lib.check_fresh_info(userinfo, call_back)
    --����ǵڶ����ˣ���ˢ�����а��
    if (userinfo.wdg_huodong.last_login == nil) then
        userinfo.wdg_huodong.last_login = os.time()
    end
    local cur_time = os.date("*t",os.time())
    local cur_day  = tonumber(cur_time.day)
    local org_time = os.date("*t", userinfo.wdg_huodong.last_login)
    local org_day = tonumber(org_time.day)
    if (cur_day ~= org_day) then
        userinfo.wdg_huodong.last_login = os.time()
        tex_dailytask_lib.on_after_user_login(userinfo, viplib.get_vip_level(userinfo), call_back)
    else
        call_back()
    end
end

function tex_dailytask_lib.update_pai_xin(userinfo, pai_xin)
    local smallbet =0
    if(userinfo.desk~=nil)then
    	local deskinfo = desklist[userinfo.desk]
    	smallbet = deskinfo.smallbet
    end
    pai_xin=tex_dailytask_lib.get_vaild_paixin(pai_xin)
    pai_xin=tex_dailytask_lib.get_vaildroom_paixin(pai_xin,smallbet)

    tex_dailytask_lib.check_fresh_info(userinfo, function()
        if (pai_xin > 0) then
            --�Ѿ���������������ˣ����ø���ȯ
            if (bit_mgr:_and(userinfo.wdg_huodong.pai_xin, pai_xin) == 0) then
                userinfo.wdg_huodong.pai_xin = bit_mgr:_or(userinfo.wdg_huodong.pai_xin, pai_xin)
                local sql = "update user_huodong_wdg_info set pai_xin = %d,sys_time=now() where user_id = %d;insert into log_user_task_info(user_id,getlottery_reason,sys_time) value(%d,%d,now()) ;commit;"
                sql = string.format(sql, userinfo.wdg_huodong.pai_xin, userinfo.userId,userinfo.userId,pai_xin)
               
                dblib.execute(sql, function()end, userinfo.userId);
                tex_dailytask_lib.add_lottery_count(userinfo, 1)
                tex_dailytask_lib.do_notify_lottery_change(userinfo)
                --�����һ������ʱ��Ҫ�����ǲ���Ҫ��������������ɵ����
                tex_dailytask_lib.all_task_down(userinfo)
                eventmgr:dispatchEvent(Event("update_quest_event", {userinfo = userinfo}))
            end
        end
    end)
end
--����ˣ�������ȫ������
function tex_dailytask_lib.all_task_down(userinfo)
    --local how_many_task=11 --�ж�����ÿ������������11�֣��ǵñ��������Ժ��
    --local all_task_countnum --�������������ɣ�Ӧ���ܺ��Ƕ���
    --local alltask_num = userinfo.wdg_huodong.pai_xin
    
    --�õ������������ʱ�����ܺ���
    --for i=1,how_many_task do all_task_countnum =all_task_countnum+ 2^i end
    
    if(tex_dailytask_lib.is_finish_all_pai_xin(userinfo.wdg_huodong.pai_xin) == 1)then --���е����������
        
        --����Ҽ�88888�Ľ���
        usermgr.addgold(userinfo.userId, 88888, 0, g_GoldType.quest_wdg_alltastkdown, -1, 1);
        netlib.send(
                function(buf)
                    buf:writeString("TXWCAL")                    
                end,userinfo.ip,userinfo.port)
        
        --��ȫ���㲥
        --BroadcastMsg(_U("��ϲ���")..userinfo.nick.._U("�����ÿ�����񣬻��88888������"),0)
        BroadcastMsg(_U(tex_lan.get_msg(userinfo, "quest_msg_task"))..userinfo.nick.._U(tex_lan.get_msg(userinfo, "quest_msg_task_1")),0)
        
        --����һ�����ݿ⣬������+1
        local sql="update user_huodong_wdg_info set daren_count=daren_count+1 where user_id=%d"
        sql=string.format(sql,userinfo.userId)
      
        dblib.execute(sql,function() end, userinfo.userId) 
        
        --�����ڴ��е�����
        userinfo.wdg_huodong.daren_count=userinfo.wdg_huodong.daren_count+1
        
        --�Ѵ��˱�־���뱳��
        gift_addgiftitem(userinfo,9008,userinfo.userId,userinfo.nick, false)
    end
    
end


-- ���»�ý�ȯ��
function tex_dailytask_lib.get_month_reward_count(userinfo)
	if(userinfo.wdg_huodong==nil)then
		userinfo.wdg_huodong={}
		userinfo.wdg_huodong.lottery_all_count=0
	end
    local lottery_all_count=userinfo.wdg_huodong.lottery_all_count or 0
    return lottery_all_count
end

-- ���½�ȯ��������
function tex_dailytask_lib.get_this_month_paiming(userinfo)
	local mingci = -1
	if(userinfo.wdg_huodong==nil or userinfo.wdg_huodong.this_month_paiming==nil)then
		mingci=-1
	else
		 mingci = userinfo.wdg_huodong.this_month_paiming
	end
    return mingci
end

--��Ϊ����ÿ�մ��˼���
function tex_dailytask_lib.get_tex_daren_count(userinfo)
    return userinfo.wdg_huodong.daren_count or 0;
end

--
function tex_dailytask_lib.flash_paihang()
    --����ûˢ�¹��Ļ�����ˢ�£���Ȼ�Ͳ�ˢ��
    local sys_today = os.date("%Y-%m-%d", os.time()) --ϵͳ�Ľ���
    if(last_flash_paihang_day == nil or last_flash_paihang_day==sys_today)then
        return -1
    end

    --ˢ��
    wdg_today_paihang={}

    local sql="select nick_name,lottery_count as reward_count,mc,mcsj from pm_today"
   
     dblib.execute(sql,function(dt)
	     	if dt and #dt>0 then
		        for i=1,#dt do               
		            	 local bufftable ={
		                    nick_name = dt[i].nick_name, 
		                    reward_count = tonumber(dt[i].reward_count),
		                    mingci=tonumber(dt[i].mc),
		                    up_or_down = tonumber(dt[i].mcsj), 
		                }
		                
		            table.insert(wdg_today_paihang, bufftable)
		        end
		    end
        end)
    last_flash_paihang_day=sys_today
    return 1 --ˢ�³ɹ�
end

tex_dailytask_lib.ontimer_flash_paihang = function(e)
   
    tex_dailytask_lib.OnTimeCheckQuest(e.data.min)
end

--��ʱ��飬�����������
tex_dailytask_lib.OnTimeCheckQuest = function(min) 

    local tableTime = os.date("*t",os.time())
    local nowHour  = tonumber(tableTime.hour)
   --[[
    --ִ��0���Ӷ�ʱ����12��֮�����ߵ���ң���ˢ�����ǵ����С�
    if(nowHour == 0 and (min == 0 or min==1)) then
        --12�����û�ˢ��һ����Ϣ
        for k, v in pairs(userlist) do
            --local userinfo=userlist
            tex_dailytask_lib.on_after_user_login(v,viplib.get_vip_level(v))
        end

    end
    --]]
    --ÿ��3��֮ǰ��ÿ��Сʱ��ǰ10���Ӷ������ˢ�£���ֹûˢ�µ�����Ϊ���ˢ��ֻ��ִ��һ�Σ����Բ��õ��Ļ����������⡣
    if(nowHour < 3 and (min >= 0 and min<=5)) then
       --��ʱˢ��ÿ����������
        tex_dailytask_lib.flash_paihang()
    end
end
--���½�ȯ�������� 
function tex_dailytask_lib.get_daren_list(userinfo)
    --6). ���½�ȯ�������� 
	--	i. �ǳƣ�string  nick_name
	--	ii. ��ȯ����int  reward_count
	--	iv. ������int  up_or_down
    --��������ǿյģ���ˢ��һ�£���ֹ��;������
    if(wdg_today_paihang==nil or #wdg_today_paihang==0)then
        tex_dailytask_lib.flash_paihang()
    end
    
    return wdg_today_paihang
end


--���playGameCount�ֵ��жϣ�����ӹ����ѣ������10�־ͷ���1�����򷵻�0
function tex_dailytask_lib.find_friend_play(userinfo,pan_shu)
    --�������û�ӹ����ѣ�ֱ�ӷ���
    local add_friend_time=userinfo.wdg_huodong.add_friend_time
    if(add_friend_time==nil or os.date("%Y-%m-%d", add_friend_time) ~= os.date("%Y-%m-%d", os.time()))then
      return 0  
    end

    --����playGameCount,10����
    if(userinfo.wdg_huodong.pan_shu>=pan_shu)then
      return 1
    end
    --����û�湻10��
    return  0
end

--�õ���������
function tex_dailytask_lib.get_mingci(user_info)
    return user_info.quest_mingci or 9999999
end

--���ñ�������
function tex_dailytask_lib.set_mingci(user_info,mingci)
    user_info.quest_mingci=mingci
    if(mingci==1)then
        tex_dailytask_lib.update_pai_xin(user_info,256)
    end
end

--�ǲ���ǰ����----->����Ϊ��һ���������
function tex_dailytask_lib.is_qianshan(user_info)
    local deskinfo = desklist[user_info.desk]
    if(deskinfo==nil or (deskinfo.desktype ~= g_DeskType.tournament and deskinfo.desktype ~= g_DeskType.channel_tournament))then
        return 0
    end
    if(tex_dailytask_lib.get_mingci(user_info)==1)then
        return 1
    end
    return 0
end

--�������µ�һ�γɹ��ӹ����ѵ�ʱ��
function tex_dailytask_lib.set_addfriend_status(userinfo)
    userinfo.wdg_huodong.add_friend_time = os.time()
    local sql = "update user_huodong_wdg_info set add_friend_time = '%s' where user_id=%d"
    sql = string.format(sql, timelib.lua_to_db_time(userinfo.wdg_huodong.add_friend_time), userinfo.userId)
  
    dblib.execute(sql)
end

--������ҽ������˶�����
function tex_dailytask_lib.update_user_playcount(userinfo,playGameCount)
    if(userinfo.wdg_huodong==nil or userinfo.wdg_huodong.pan_shu==nil)then
	userinfo.wdg_huodong={}
	userinfo.wdg_huodong.pan_shu=0
    end
    userinfo.wdg_huodong.pan_shu = userinfo.wdg_huodong.pan_shu + 1
    local sql = "update user_huodong_wdg_info set pan_shu = pan_shu + 1 where user_id=%d"
    sql = string.format(sql, userinfo.userId)
   
    dblib.execute(sql)
end

--����������������˼�Ǯ
--i=1���ԣ�i=2������i=3˳�ӣ�i=4ͬ����i=5��«��i=6������i=7ͬ��˳��ʼ�ͬ��˳,i=8���������10�֣�i=9����ǰ����,i=10VIP��½,i=11һ��
function tex_dailytask_lib.add_yesterday_questgold(userinfo)
    --�õ�����������������
    if userinfo==nil then return 0 end;
    if userinfo.wdg_huodong==nil then return 0 end;
    if userinfo.wdg_huodong.yesterday_pai_xin==nil then
    	userinfo.wdg_huodong.yesterday_pai_xin=0
    end
    local yesterday_pai_xin = userinfo.wdg_huodong.yesterday_pai_xin;
    local add_gold=0
    local how_many_task=11  --�ܹ��ж���������
    if(yesterday_pai_xin==0)then
    	return 0;
    end
    for i=1,how_many_task do 
        if (bit_mgr:_and(yesterday_pai_xin, 2^(i-1) ) >0) then
            if(i==8)then
                add_gold = add_gold + 188
            elseif(i==9)then
                    add_gold = add_gold + 288
            elseif(i==1 or i==2 or i==3 or i== 4 or i==5 or i==11)then
                add_gold = add_gold + 388
            elseif(i==6)then
                add_gold = add_gold + 1888
            elseif(i==7)then
                add_gold = add_gold + 8888
            end
        end
    end

    userinfo.wdg_huodong.yesterday_pai_xin = 0

    local sql = "update user_huodong_wdg_info set yesterday_pai_xin = 0 where user_id = %d;commit;"
    sql = string.format(sql, userinfo.userId)
  
    dblib.execute(sql)
    usermgr.addgold(userinfo.userId, add_gold, 0, g_GoldType.quest_wdg_nextdaylogin, -1, 1);
    
    return add_gold;
end

--�Ƿ���ĳ��0��֮ǰ
get_before_specday = function(time)
    local tableTime = os.date("*t",time)
    local endtime = os.time{year = tableTime.year, month = tableTime.month, day = tableTime.day, hour = 0}
    if time < endtime then
        return true, endtime
    else
        return false, endtime
    end
end

--����쵽�µ�
function tex_dailytask_lib.get_last_monthday()
    local sys_day = tonumber(os.date("%d", os.time()))
    local sys_year = os.date("%Y", os.time()) --��
    local sys_month = tonumber(os.date("%m", os.time()))+1 --��
    local next_month_day=sys_year.."-"..sys_month.."-1 00:00:00"
  
    local is_before,newday=get_before_specday(timelib.db_to_lua_time(next_month_day))
    local new_day=tonumber(os.date("%d", newday))
    --�޸�bug #206����30��Ҫ��ʾ����1���콱�������ǻ���0��
    return math.floor((newday-os.time()-1)/86400)+1
end


--��һ�½������˼��Ž���
function tex_dailytask_lib.get_already_used_today(userinfo)
    local today_used_count=userinfo.wdg_huodong.today_used_count or 0
    return today_used_count--��Ĭ��Ϊ����0��
end


--��ʼ�������ҵ����ݵ��ڴ���
function tex_dailytask_lib.init_memory_data(userinfo)
    if (userinfo.wdg_huodong == nil) then
        userinfo.wdg_huodong = {}
    end

    --local sql="call sp_month_paiming(%d)"
    local sql="select mc from pm_today where user_id=%d"
 
    dblib.execute(string.format(sql,userinfo.userId),function(dt)
            if (dt and #dt > 0) then
                userinfo.wdg_huodong.this_month_paiming = dt[1]["mc"]
            end
         end)
end

--����ӿڣ���������˼�������
function tex_dailytask_lib.get_task_info(user_info)
	if (not user_info) or (not user_info.wdg_huodong.pai_xin) then
			TraceError("������Ϣ")
		return 
	end
	local id = {1,2,4,8,16,32,64,128,256,512,1024}
	local finish_num = 0
	local pai_xin = user_info.wdg_huodong.pai_xin
	for i,v in pairs(id) do
		if (bit_mgr:_and(pai_xin, v) ~= 0) then
			finish_num = finish_num + 1
		end
	end
	return finish_num
end

--�����б�
cmdHandler = 
{
	
	["TXDKZP"] = tex_dailytask_lib.onRecvDakaiZhuanpan, --�յ���ת��
	["TXKSCJ"] = tex_dailytask_lib.onRecvKaishiChoujiang, --�յ���ʼ�齱
    ["TXJJBH"] = tex_dailytask_lib.notify_lottery_change, --��Ϸ����ʱ��һ�����󣬿ͻ���Ҳ�ᷢ����


	
    --gamecenter
    --[[["RERIDDL"] = gsriddlelib.OnRecvRiddleFromGC,--�յ����ڴ��������ID
	["RERIDAS"] = gsriddlelib.OnRecvAnswerRiddleFromGC,--�յ���֤������
    ["BCRIDOV"] = gsriddlelib.OnRecvRiddleOverFromGC,--�յ����˴������

    --client
    ["RIDQETM"] = gsriddlelib.OnRecvQueryTimeFromClient, --�յ���Ҳ�ѯʣ��ʱ��
    ["RIDINFO"] = gsriddlelib.OnRecvQueryRiddleFromClient, --�յ���Ҳ�ѯ��Ŀ����
    ["RIDANSW"] = gsriddlelib.OnRecvAnswerFromClient, --�յ���Ҵ���
    --]]
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

tex_dailytask_lib.init = function ()
    if (tex_dailytask_lib.is_init == true)  then
        return
    end
    tex_dailytask_lib.is_init = true
    eventmgr:removeEventListener("timer_minute", tex_dailytask_lib.ontimer_flash_paihang);
    eventmgr:addEventListener("timer_minute", tex_dailytask_lib.ontimer_flash_paihang);
    eventmgr:removeEventListener("h2_on_user_login", tex_dailytask_lib.h2_after_user_login);
    eventmgr:addEventListener("h2_on_user_login", tex_dailytask_lib.h2_after_user_login);
end

tex_dailytask_lib.init()

TraceError("��ʼ������")





