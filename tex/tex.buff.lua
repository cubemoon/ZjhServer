if not tex_buf_lib then
    tex_buf_lib = _S
    {
        onrecvwanttokick = NULL_FUNC,
        toupiaotimeover = NULL_FUNC,
        dealkickresult = NULL_FUNC,
        onrecvkickpeopleid = NULL_FUNC,
        sendresult = NULL_FUNC,
        initkickinfo = NULL_FUNC,
        on_after_gameover = NULL_FUNC,
        onrecvtoupiao = NULL_FUNC,
        on_after_user_standup = NULL_FUNC,
        on_after_user_sitdown = NULL_FUNC,
        onrecvifkickvip = NULL_FUNC,
        onafterkickuser = NULL_FUNC,
        get_kick_card_count = NULL_FUNC,
        sub_kick_card_count = NULL_FUNC,
        load_kick_card_from_db = NULL_FUNC,
        on_before_user_enter_desk = NULL_FUNC,
        onrecvcheckcishu = NULL_FUNC,
        send_can_kick_result = NULL_FUNC,
        get_aleady_kick=NULL_FUNC,
        set_aleady_kick=NULL_FUNC,
        is_user_kicked=NULL_FUNC,
        on_recvclick_cancel=NULL_FUNC, --�յ������ȡ������ť
        give_kick_card=NULL_FUNC,
    }
end

--��½��ɺ��¼�
function tex_buf_lib.load_kick_card_from_db(userinfo) 
 --   if(tex_gamepropslib ~= nil) then
        --�����������userinfo.propslist[kick_card_id]�м�¼���˿�����
  --      tex_gamepropslib.get_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, userinfo, function(kick_card_count) end)
   -- end
end

--��ȡ���˿�
function tex_buf_lib.get_kick_card_count(user_id)
    local userinfo = usermgr.GetUserById(user_id);
    if(userinfo == nil or userinfo.propslist == nil) then return 0 end
    return userinfo.propslist[tex_gamepropslib.PROPS_ID.KICK_CARD_ID] or 0
end

--�������˿�
--complete_callback_func(props_count)
function tex_buf_lib.sub_kick_card_count(user_id, sub_count,complete_callback_func)
    local userinfo = usermgr.GetUserById(user_id);
    if not userinfo then return end
    if tex_gamepropslib == nil then return end

    local kick_card_id = tex_gamepropslib.PROPS_ID.KICK_CARD_ID;
    --�������˿�����
    tex_gamepropslib.set_props_count_by_id(kick_card_id, sub_count, userinfo, complete_callback_func)
end

--��ĳ����ҷ��������˿�
function tex_buf_lib.give_kick_card(user_id,card_num)
    local userinfo = usermgr.GetUserById(user_id);
    if not userinfo then return end
    if tex_gamepropslib == nil then return end

    local kick_card_id = tex_gamepropslib.PROPS_ID.KICK_CARD_ID;
    tex_gamepropslib.set_props_count_by_id(kick_card_id, card_num, userinfo, function(count) end)
end

function tex_buf_lib.send_can_kick_result(userinfo, cankick, call_back)
    local cankicknum = tex_buf_lib.get_kick_card_count(userinfo.userId)
        netlib.send(
                function(buf)
                    buf:writeString("TXFQTR")
                    buf:writeByte(cankick)
                    buf:writeInt(cankicknum)
                    buf:writeByte(userinfo.site or 0)
                end,userinfo.ip,userinfo.port)    
    if (call_back ~= nil and cankick <= 0) then
        call_back(cankicknum)
    end
end

--[[
	to wangyu
	���˿�ʵ�ִ���
	��ȡ�����ϵ��û���Ϣ��������
						deskmgr.getplayers(deskno)
	�������ݽṹ����	{{ siteno=i, userinfo=userinfo },{ siteno=i, userinfo=userinfo }...}	
--]]	
--�յ������˵�����
function tex_buf_lib.onrecvwanttokick(buf)
    local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;
	local deskno = userinfo.desk

	local deskinfo = desklist[deskno].gamedata
    local cankick = 0
	local players = deskmgr.getplayers(deskno)
    local cankicknum = 0

    local kickcounts = 0
    kickcounts = tex_buf_lib.get_kick_card_count(userinfo.userId)

    
    --�ȿ��Ƿ�VIP�����жϴ����ǲ��ǹ����ǲ����������ˣ��ǲ�����������
    --����ֱ�Ӽ�¼������ͶƱ�˵�info
    if kickcounts <= 0 then
        cankick = 3 --���˴�������
    elseif deskinfo.kickinfo.peoplecount ~= 0  then
		cankick = 4 --��������
	elseif #players < 5 then
		cankick = 1 --��������    
    elseif tex_buf_lib.get_aleady_kick(deskno)==1 then
        cankick = 7 --����������߹��ˣ����ÿͻ�����ʾ��Ӧ����
    else
		deskinfo.kickinfo.userinfo = userinfo --��¼����ͶƱ�˵�info	
    end
    --����������ˣ���ô�������Ϊ�ù����˿�
    if (cankick==0) then
        tex_buf_lib.set_aleady_kick(deskno,1)
    end
    --�����Ƿ�������˺�����
    tex_buf_lib.send_can_kick_result(userinfo, cankick)
  
end
	
--֪ͨ������ĳ���Ѿ����߳�����
function tex_buf_lib.onafterkickuser(deskno,kickuser, is_playing)
   local deskinfo = desklist[deskno].gamedata
   local kickname = kickuser.userinfo.nick
   local face = kickuser.userinfo.imgUrl
   local faqiren = deskinfo.kickinfo.userinfo
    for _, player in pairs(deskmgr.getplayers(deskno)) do
        --���������棬��Ӧ���յ�Э��
        if (is_playing == 0 or 
            (is_playing == 1 and kickuser.userinfo.userId ~= player.userinfo.userId)) then
            netlib.send(
                function(buf)
                    buf:writeString("TXKICK")
                    buf:writeString(kickname)  --�����˵�����
                    buf:writeString(face)  --�����˵�ͷ��
                    buf:writeByte(kickuser.okcount) --ͬ�������
                    buf:writeByte(kickuser.notokcount) --��ͬ�������
                    buf:writeByte(kickuser.abortcount) --��Ȩ������
                    buf:writeByte(kickuser.count) --ͶƱ������
                    buf:writeString(faqiren.nick or "") --�����˵��ǳ�
                end,player.userinfo.ip,player.userinfo.port)
        end
    end
    --���������棬��Ӧ���յ�Э��
    if (is_playing == 0) then
        --֪ͨ���ߵ����Լ�������
        netlib.send(
            function(buf)
                buf:writeString("TXBTZL")       
            end,kickuser.userinfo.ip,kickuser.userinfo.port)
    end
end

--ͶƱ30��ʱ�䵽
function tex_buf_lib.toupiaotimeover(deskno)
	local deskinfo = desklist[deskno].gamedata
	for i, player in pairs(deskinfo.kickinfo.toupiaoren) do
		if player.toupiaoresult == -1 then  --û��ͶƱ,������Ȩ����
			player.toupiaoresult = 2 --��Ȩ
			deskinfo.kickinfo.toupiaoabort = deskinfo.kickinfo.toupiaoabort + 1			
		end
	end
	
	tex_buf_lib.dealkickresult(deskno)
end

function tex_buf_lib.add_desk_kick_list(deskno, kick_info, kick_user_info)
    kick_info.userinfo = kick_user_info;
    if(desklist[deskno] and desklist[deskno].gamedata) then
        table.insert(desklist[deskno].gamedata.kickedlist, kick_info); 
    end
end

--����ͶƱ���
function tex_buf_lib.dealkickresult(deskno)
    local deskinfo = desklist[deskno].gamedata
    --ͶƱ�����󲻴�������Ϣ
    if deskinfo.kickinfo.peoplecount == 0 then
        return
    end
    
    local result = 0
    local kickuserinfo = deskinfo.kickinfo.kickuserinfo
	local kickname = kickuserinfo.nick
	local face = kickuserinfo.imgUrl
    --ͬ����ڰ������߳�������ͶƱ
    local isplaying = 0
    if deskinfo.kickinfo.toupiaook > deskinfo.kickinfo.peoplecount / 2 then  	        
    	--������Ϸ�е��˽��������߳�����
    	for _, player in pairs(deskmgr.getplayingplayers(deskno)) do
    		if player.userinfo == deskinfo.kickinfo.kickuserinfo then
    			isplaying = 1
    			break
    		end			
        end
        local player = {
                        userinfo = deskinfo.kickinfo.kickuserinfo,
                        systime = os.time(),
                        isondesk = isplaying,
                        okcount = deskinfo.kickinfo.toupiaook,
                        notokcount = deskinfo.kickinfo.toupiaonotok,
                        abortcount = deskinfo.kickinfo.toupiaoabort,
                        count = deskinfo.kickinfo.peoplecount,
                    }

	    --֪ͨ������
	    tex_buf_lib.onafterkickuser(deskno, player, isplaying)
        tex_buf_lib.add_desk_kick_list(deskno, player, deskinfo.kickinfo.kickuserinfo);
    	result = 1
    end

     --��Ȩ+��ͬ����ڵ��ڰ��������
   if deskinfo.kickinfo.toupiaonotok + deskinfo.kickinfo.toupiaoabort >= deskinfo.kickinfo.peoplecount / 2 then  
    	result = 2
   end
    
	--֪ͨͶƱ���
	for _, player in pairs(deskmgr.getplayers(deskno)) do
		local deskuserinfo = player.userinfo
		local desksiteno = player.siteno
		
        if deskinfo.kickinfo.peoplecount == 0 then
            break
        end
        --���������ߵ���
		if deskinfo.kickinfo.kickuserinfo  ~= deskuserinfo then
            --ͶƱ��û�н����Ļ�����������û�����ͶƱ��ͶƱ�ˣ�������ʲô�õģ�
            if result > 0 then
                if deskinfo.kickinfo.toupiaoren[deskuserinfo.userId] ~= nil then
                    deskinfo.kickinfo.toupiaoren[deskuserinfo.userId].toupiaoresult = 3
                end
            end
            if deskinfo.kickinfo.toupiaoren[deskuserinfo.userId] == nil or 
                deskinfo.kickinfo.toupiaoren[deskuserinfo.userId].toupiaoresult > -1 then
                --֪ͨͶƱ���
                tex_buf_lib.sendresult(deskinfo,deskuserinfo,result)			        
             end
        else --���ͶƱ�ǳɹ��ģ����������ˣ�ͶƱ���
            if result==1 then
                 --֪ͨͶƱ���
                tex_buf_lib.sendresult(deskinfo,deskuserinfo,result)	
            end
        end
    end

    --���������ֹͣ�ƻ�����
	if result ~= 0 then
        if (deskinfo.kickinfo.timeover ~= nil) then
            deskinfo.kickinfo.timeover.cancel()
            deskinfo.kickinfo.timeover = nil
        end
        --���ٷ����˵����˿�
        local faqiren = deskinfo.kickinfo.userinfo
        local send_kick_counts = function(kick_counts)
	        netlib.send(
	            	    function(buf)
	                    buf:writeString("TXVPCS")
	                    buf:writeInt(kick_counts) ---������-1������vip��0����������������������
	                end,faqiren.ip,faqiren.port)
        end
        
        tex_buf_lib.sub_kick_card_count(faqiren.userId, -1,send_kick_counts)

        tex_buf_lib.initkickinfo(deskno) --���ͶƱ����Ϣ
        --֪ͨ�ͻ��˸��û���ʣ�����˿���
        
            
        --�û��ڲ��ܱ�����
        if (isplaying == 0 and kickuserinfo.desk ~= nil and kickuserinfo.desk == deskno and result==1) then
            pre_process_back_to_hall(kickuserinfo)            
        end
	end
    
end


function tex_buf_lib.sendresult(deskinfo,userinfo,result)
    if deskinfo.kickinfo.peoplecount == 0 then
        return
    end
    local kickuserinfo = deskinfo.kickinfo.kickuserinfo
	local kickname = kickuserinfo.nick
	local face = kickuserinfo.imgUrl
    local faqiren = deskinfo.kickinfo.userinfo
    local isKickUser=0 --�ǲ��Ǳ����� 0���� 1��

    if(kickuserinfo.userId==userinfo.userId)then
        isKickUser=1
    end

    --TraceError(faqiren)
    netlib.send(
            function(buf)
                buf:writeString("TXTPJG")
                buf:writeByte(deskinfo.kickinfo.toupiaook) --ͬ�������
                buf:writeByte(deskinfo.kickinfo.toupiaonotok) --��ͬ�������
                buf:writeByte(deskinfo.kickinfo.toupiaoabort) --��Ȩ������
                buf:writeByte(deskinfo.kickinfo.peoplecount) --ͶƱ��������
                buf:writeByte(result) --ͶƱ�����2��ͶƱ��������ͬ���ߣ�1��ͶƱ������ͬ���ߣ�0�������� 
                buf:writeString(kickname)   --�����˵�����
                buf:writeString(face)       --�����˵�ͷ��
                buf:writeString(faqiren.nick or "")       --�����˵��ǳ�
                buf:writeByte(isKickUser)  --�ǲ��Ǳ����� 0���� 1��
            end,userinfo.ip,userinfo.port)
end

--�յ�����˭����Ϣ
function tex_buf_lib.onrecvkickpeopleid(buf)
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;
	local deskno = userinfo.desk
	local kicksiteno = buf:readByte()

	local deskinfo = desklist[deskno].gamedata
	
	local cankick = 0 
	local players = deskmgr.getplayers(deskno)

    --��鱻�����Ƿ�����λ��
    local kickuserinfo = nil
    local cankicknum = 0
    for _, player in pairs(players) do
        if player.siteno == kicksiteno then
            kickuserinfo = player.userinfo --���ߵ��˵��û���Ϣ 
            break
        end
    end
    
    local kickcounts = tex_buf_lib.get_kick_card_count(userinfo.userId)
    if kickcounts <= 0 then
        cankick = 3
    elseif deskinfo.kickinfo.peoplecount > 0  then
        cankick = 4
	elseif #players  < 5 then
        cankick = 1 --��������
    elseif kickuserinfo == nil then
        cankick = 5 --�Ѿ��뿪
    elseif tex_buf_lib.is_user_kicked(kickuserinfo, deskno)  == 1 then
        cankick = 6 --���Ǳ�����
   
    end
    local kick_func = function(kick_card_num)
        if (kick_card_num <= 0) then
            return
        end
        
        cankicknum = kick_card_num
        deskinfo.kickinfo.kickuserinfo = kickuserinfo
        deskinfo.kickinfo.peoplecount = #players - 1	--�ռ���ǰ���Բ���ͶƱ���������۳��Լ��ͱ��ߵ���
        deskinfo.kickinfo.toupiaook = 1 --������Ĭ��Ϊͬ��
        --30���ʱ
        deskinfo.kickinfo.timeover = timelib.createplan(
                function()
                     tex_buf_lib.toupiaotimeover(deskno)
               end, 30)
        for _, player in pairs(deskmgr.getplayers(deskno)) do
    		local deskuserinfo = player.userinfo
    		local desksiteno = player.siteno
    		--ֻ����ȨͶƱ���˷���ͶƱ����Ϣ
    		if deskuserinfo ~= deskinfo.kickinfo.kickuserinfo  and 
                deskinfo.kickinfo.userinfo ~= deskuserinfo then    
                deskinfo.kickinfo.toupiaoren[deskuserinfo.userId] = {}
    			deskinfo.kickinfo.toupiaoren[deskuserinfo.userId].toupiaoresult = -1 --û��ͶƱ
                --֪ͨ����
    			netlib.send(
                	function(buf)
                    	buf:writeString("TXTRID")
                    	buf:writeByte(deskinfo.kickinfo.peoplecount)
                    	buf:writeString(kickuserinfo.nick)
                    	buf:writeString(kickuserinfo.imgUrl)
                        buf:writeString(deskinfo.kickinfo.userinfo.nick or "")
                	end,deskuserinfo.ip,deskuserinfo.port)
            end
             --���ӷ����˷��ͽ����Ϣ��ȫ��Ϊ0
            local faqiren = deskinfo.kickinfo.userinfo
               
            tex_buf_lib.sendresult(deskinfo,faqiren,0)
        end
    end    
    --�����Ƿ�������˺�����
    if(cankick~=0)then
        tex_buf_lib.send_can_kick_result(userinfo, cankick)  
    else
        local cankicknum = tex_buf_lib.get_kick_card_count(userinfo.userId)
        kick_func(cankicknum)
    end

end

--���ͶƱ����Ϣ
function tex_buf_lib.initkickinfo(deskno) 
	local deskinfo = desklist[deskno].gamedata
	
	deskinfo.kickinfo = {}
	deskinfo.kickinfo.peoplecount = 0	--ͶƱ����
	deskinfo.kickinfo.userinfo = {}	--����ͶƱ��
	deskinfo.kickinfo.toupiaook = 0		--ͬ������
	deskinfo.kickinfo.toupiaonotok = 0	--��ͬ������
	deskinfo.kickinfo.toupiaoabort = 0  --��Ȩ����
	
	deskinfo.kickinfo.kickuserinfo = {}	--�����˵���Ϣ
	
	deskinfo.kickinfo.toupiaoren = {} --ͶƱ���������
    deskinfo.kickinfo.alreadykick = 1 --��һ���ù����˿���
end

function tex_buf_lib.get_aleady_kick(deskno)
    local deskinfo = desklist[deskno].gamedata
    return deskinfo.kickinfo.alreadykick
end

function tex_buf_lib.set_aleady_kick(deskno,v_alreadykick)
      local deskinfo = desklist[deskno].gamedata
    deskinfo.kickinfo.alreadykick = v_alreadykick
end

--��Ϸ��������ô˺���
function tex_buf_lib.on_after_gameover(deskno)
	local deskinfo = desklist[deskno].gamedata
	--�����Ƿ�����Ҫ���ߵ���
    for i, player in pairs(deskinfo.kickedlist) do
        if player.isondesk == 1 then
            local kickname = player.userinfo.nick
            if (player.userinfo.desk ~= nil and 
                player.userinfo.desk == deskno) then
                pre_process_back_to_hall(player.userinfo) --ǿ������                       
            end
            player.isondesk = 0
            player.systime = os.time()
            --֪ͨ������
            if not player.n_type or player.n_type ~= 1 then
              tex_buf_lib.onafterkickuser(deskno,player, 0)
            else
              --todo ����T��֪ͨ
              if wing_lib then
                wing_lib.send_kick_info_toall(deskno,player)
              end
            end
        end
        
        --ʱ���Ѿ�����10���Ӻ��ɾ����¼
        if os.time() - player.systime > 600 then
            deskinfo.kickedlist[i] = nil
        end
    end
end

--���º�֪ͨ���µ���ͶƱ���
function tex_buf_lib.on_after_user_sitdown(userinfo, deskno, siteno)
    local deskinfo = desklist[deskno].gamedata
    if deskinfo.kickinfo.peoplecount > 0 then
        tex_buf_lib.sendresult(deskinfo,userinfo,0)
    end

    --֪ͨ�ͻ��˸��û���ʣ�����˿���
    local kickcounts = tex_buf_lib.get_kick_card_count(userinfo.userId)

        netlib.send(
            	    function(buf)
                    buf:writeString("TXVPCS")
                    buf:writeInt(kickcounts) ---������-1������vip��0����������������������
                end,userinfo.ip,userinfo.port)

end

function tex_buf_lib.is_user_kicked(user_info, deskno)
    local deskinfo = desklist[deskno].gamedata
  	--�����Ƿ��������
  	for k, player in pairs(deskinfo.kickedlist) do
        if player.userinfo == nil then
            deskinfo.kickedlist[k] = nil
        elseif player.userinfo.userId == user_info.userId then
      		--ʱ���Ѿ�����30���Ӻ��ɾ����¼
      		if os.time() - player.systime > 600 then
      			deskinfo.kickedlist[k] = nil
      			return 0
            else
      			return 1
      		end
        end
    end
    return 0
end

--����ǰ�ж��Ƿ������
function tex_buf_lib.on_before_user_enter_desk(user_info, deskno)
    if (deskno == nil or deskno < 0) then
        return 1
    end
    if (tex_buf_lib.is_user_kicked(user_info, deskno) == 1) then
        return 0
    else
        return 1
    end
end
         
-- �û�վ����
function tex_buf_lib.on_after_user_standup(user_info,deskno,site)
    local deskinfo = desklist[deskno].gamedata
	if deskinfo.kickinfo.toupiaoren[user_info.userId] ~= nil and
            deskinfo.kickinfo.toupiaoren[user_info.userId].toupiaoresult == -1 then
        deskinfo.kickinfo.toupiaoren[user_info.userId].toupiaoresult = 2 --��Ȩ
		deskinfo.kickinfo.toupiaoabort = deskinfo.kickinfo.toupiaoabort + 1				
    end

    if deskinfo.kickinfo.peoplecount > 0 then
        tex_buf_lib.dealkickresult(deskno)
    end
	
end

function tex_buf_lib.onrecvifkickvip(buf)
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;
	local deskno = userinfo.desk

    local kickcounts = tex_buf_lib.get_kick_card_count(userinfo.userId)
    netlib.send(
            	    function(buf)
                    buf:writeString("TXKVIP")
                    buf:writeByte(1) --1:��vip��0������vip
                    buf:writeInt(kickcounts) ---������-1������vip��0����������������������
                end,userinfo.ip,userinfo.port)

end

--�յ���ѯ������Ϣ
function tex_buf_lib.onrecvcheckcishu(buf)
    local userinfo = userlist[getuserid(buf)]; 

    local complete_callback_func = function(kick_card_count)
        netlib.send(
                function(buf)
                buf:writeString("TXBFKS")
                buf:writeInt(kick_card_count) 
            end,userinfo.ip,userinfo.port)
    end

    local props_id = tex_gamepropslib.PROPS_ID.KICK_CARD_ID
    tex_gamepropslib.get_props_count_by_id(props_id, userinfo, complete_callback_func)
   
        
end

--���ȡ����ť���Ϳ�����Ϊ����û�ù��������ˣ���Ϊ�������ǵ㲻��ȡ����
function tex_buf_lib.on_recvclick_cancel(buf)
    local userinfo = userlist[getuserid(buf)];
    if not userinfo then return 0 end;
    local deskno = userinfo.desk or 0
    if(deskno~=0)then --��ֹ��һ�̲߳�ͬ����ɻص�����֮����յ�Ҫȡ����Э�飬��ʱ����ʲô������������������һ����ȡ��״����
        tex_buf_lib.set_aleady_kick(deskno,0)
    end
    return 1;
end

--�յ�ͶƱ��Ϣ
function tex_buf_lib.onrecvtoupiao(buf)
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end; if not userinfo.desk or userinfo.desk <= 0 then return end;
	local deskno = userinfo.desk
	local toupiaojieguo = buf:readByte() --ͶƱ�����2����Ȩ��1��ͬ�⣻0����ͬ��
	local deskinfo = desklist[deskno].gamedata
    --ͶƱ�Ѿ������Ļ������������Ϣ
	if deskinfo.kickinfo.peoplecount == 0 then
        return
    end

    --��һ���ù����˹�����
    tex_buf_lib.set_aleady_kick(deskno,1)
	if (deskinfo.kickinfo.toupiaoren[userinfo.userId].toupiaoresult ~= -1) then
        return
    end
    --��¼ͶƱ��ͶƱ��Ϣ
    deskinfo.kickinfo.toupiaoren[userinfo.userId].toupiaoresult = toupiaojieguo	
	if toupiaojieguo == 1 then
		deskinfo.kickinfo.toupiaook = deskinfo.kickinfo.toupiaook + 1 --ͬ����˼�һ
	elseif toupiaojieguo == 2 then
		deskinfo.kickinfo.toupiaoabort = deskinfo.kickinfo.toupiaoabort + 1 --��Ȩ���˼�һ
	else	
		deskinfo.kickinfo.toupiaonotok = deskinfo.kickinfo.toupiaonotok + 1 --��ͬ����˼�һ
	end	
	--��������
	tex_buf_lib.dealkickresult(deskno)
end

--]]



--�����б�
cmdHandler =
{
    	["TXFQTR"] = tex_buf_lib.onrecvwanttokick,			--��������
		["TXTRID"] = tex_buf_lib.onrecvkickpeopleid,		--�յ�����˭����Ϣ
		["TXTPXX"] = tex_buf_lib.onrecvtoupiao,				--�յ�ͶƱ���
   		["TXKVIP"] = tex_buf_lib.onrecvifkickvip,				--��ѯ�Ƿ�������˵�vip
        ["TXBFKS"] = tex_buf_lib.onrecvcheckcishu,				--��ѯ���˿��Ĵ���
        ["TXCLICKCANCEL"] = tex_buf_lib.on_recvclick_cancel, --�յ������ȡ������ť

    --[[
		to wangyu
		���˿�Э���������
	----------���˿�ģ��----------
	
		
		["TXEMOT"] = onrecvsendemot,			--�㷢����
		["TXGIFT"] = onrecvsendgift,			--��������
		["TXGFLT"] = onrecvgetgiftinfo,			--����ĳ�˵���������
		["TXGFUS"] = onrecvusinggift,			--����ĳ����		
    --]]
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do
	cmdHandler_addons[k] = v
end

TraceError("����texbuff���")

