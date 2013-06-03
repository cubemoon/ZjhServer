TraceError("init friend����....")

if not friendlib then
	friendlib = _S
	{
		sql = _S
		{
			log_user_maxfriend = "insert into log_user_maxfriend_info(userid,maxnum,currtime) values(%d,%d,now());commit;",
			log_user_friend_num = "insert ignore into user_friendnum_info(userid,gamefriend,snsfriend,freshtime) values(%d,0,0,now()); "..
									" update user_friendnum_info set gamefriend = %d,snsfriend = %d,freshtime = now() where userid = %d;commit;",
			log_user_delfriend = "insert into log_user_delfriend_info(userid,deluserid,deltime) values(%d,%d,now());commit;",
			log_user_addfriend = "insert into log_user_addfriend_info(userid,adduserid,addtime) values(%d,%d,now());commit;",

			getFriendsIdList = "SELECT id FROM users WHERE user_name IN (%s) AND reg_site_no = %d",
			get_user_friends_sql = "select concat(user_friends.friends) as friends from user_friends where user_id = %d",
			update_user_friends_info = "update user_friends set snsfriends = %s,friends = %s where user_id = %d;commit;",
			update_user_friends_info_only = "update user_friends set friends = %s where user_id = %d;commit;",
			getuserinfofromdb = "select userid as userId,nick_name as nick,face as imgUrl,gold as gamescore,level from users a join user_tex_info b where a.id = b.userid and a.id = %d;",
			updateuserdelgamefriend = "update user_friends set friends = replace(friends,%s,'|') where user_id = %d;commit;",
			updateuseraddgamefriend = "update user_friends set friends = concat(friends,%s) where user_id = %d;commit;",
			getuservipinfo = "select vip_level from user_vip_info where user_id = %d and over_time >= now();",
		},

		change_userstate_tofriend				= NULL_FUNC,			--���º���״̬
		load_user_friend_info_from_sns 			= NULL_FUNC,			--�������ݿ��е���Ϣ��д���ڴ�
		write_friendinfo_to_ram					= NULL_FUNC,			--ִ����Һ�����Ϣд���ڴ�
		friendxml_to_table						= NULL_FUNC,			--��XML�ļ��н�������Һ�����Ϣ��
		do_delete_userfriend_byid				= NULL_FUNC,			--ִ��ɾ������
		do_add_userfriend_byid					= NULL_FUNC,			--ִ�����Ӻ���
		do_change_userstate_tofriend			= NULL_FUNC,			--ִ�з������״̬
		send_user_allfriend_info				= NULL_FUNC,			--�������к��ѵ���Ϣ
		net_OnRecvInviteFriendJoin				= NULL_FUNC,             --�յ���������ĳ�����Ѽ�������
		net_OnRecvShowAddFriend					= NULL_FUNC,            --�յ������ܷ���ʾ��Ӹú��Ѱ�ť
		net_OnRecvChangeFriendInfo				= NULL_FUNC,         	--�յ��޸ĺ�����Ϣ����
		net_OnRecvGetAllFriendInfo				= NULL_FUNC,         	--�յ��õ����к�����Ϣ����
		net_OnRecvJoinFriendDesk				= NULL_FUNC,			--�յ���������������
		net_OnRecvWantToAddFriend				= NULL_FUNC,			 --�յ�������ĳ�˺���
		net_send_changeresult					= NULL_FUNC,			--��������ɾ�����
		send_newfriend_info						= NULL_FUNC,			--�����º�����Ϣ
		send_newfriend_info_tomanager			= NULL_FUNC,			--�����º��Ѹ����ѹ�����
		net_broadcastdesk_toplay				= NULL_FUNC,			--�㲥�Ӻ��ѳɹ�����
		set_user_friend_info					= NULL_FUNC,			--���ú��ѹ����������Ϣ
		net_OnRecvCheckUserOnline				= NULL_FUNC,			--�յ���������������
		
		CONFIG = _S
		{
			MAXFRIEND = 1000,--��������������
			LIMIT = 20,--���ͺ���ÿ����������
		}
	}
end

friendlib.load_user_friend_info_from_sns = function(userinfo)
    --TraceError('load_user_friend_info_from_sns');
	--if true then return end
    --���к�����鶼�ܼӺ��ѣ���һ��
	if true or userinfo.nRegSiteNo == 0 or userinfo.nRegSiteNo == 1 then
        --��½ʱ������ǰ�ȸ��º���
        --local url = "http://121.9.221.7:8080/GetBuddylist.php?uid=-1"    --userinfo.passport
		
        --dblib.dourl(url, function(xml_info)
	   
            --local success, yy_friends_uids = xpcall(function() return friendlib.friendxml_to_table(xml_info) end, throw)
            local success=true;
            local yy_friends_uids="";
            
            if success then
                --���º���
                
                if yy_friends_uids == "" then
                    yy_friends_uids = dblib.tosqlstr(yy_friends_uids)
                end
                local szSql = format(friendlib.sql.getFriendsIdList, yy_friends_uids, userinfo.nRegSiteNo)
                dblib.execute(szSql, function(dt)
                    if dt and #dt >= 0 then
                        local snsfriend = {}
                        local len = #dt
                        local snsnum = 0
                        local gamenum = 0
                        if len >= friendlib.CONFIG.MAXFRIEND then
                            --��¼��������������޵���־
                            dblib.execute(string.format(friendlib.sql.log_user_maxfriend,userinfo.userId,len))
                            
                            len = friendlib.CONFIG.MAXFRIEND 
                            snsnum = len
                            
                            for i = 1, len  do
                                if tonumber(dt[i]["id"]) and tonumber(dt[i]["id"]) ~= tonumber(userinfo.userId) then
                                    snsnum = snsnum + 1
                                    table.insert(snsfriend, tostring(dt[i]["id"]))
                                end
                            end
                            
                            --д���ڴ�
                            local szSnsfriend = "|"..table.concat(snsfriend,"|").."|"
                            friendlib.write_friendinfo_to_ram(userinfo,"", szSnsfriend)
                            --д�����ݿ�
                            --dblib.execute(string.format(friendlib.sql.update_user_friends_info,dblib.tosqlstr(szSnsfriend),dblib.tosqlstr(""),userinfo.userId))
                        else
                            --ȥ�������д��ڵ�Y��
                            local sql = format(friendlib.sql.get_user_friends_sql,userinfo.userId)
                            dblib.execute(sql, function(dt1)
                                if dt1 and #dt1 >= 0 then
                                    snsnum = len
                                    local friendsstr = ""
                                    
                                    if dt1[1].friends and string.len(dt1[1].friends) ~= 0 then
                                        --�жϵ�һ����ĸ�ǲ���|���ǵĻ�����
                                        if string.sub(dt1[1].friends,1,1) ~= "|"then
                                          dt1[1].friends = "|"..dt1[1].friends
                                          --�������ݿ�
                                          dblib.execute(string.format(friendlib.sql.update_user_friends_info_only,dblib.tosqlstr(dt1[1].friends),userinfo.userId),nil,userinfo.userId)
                                        end
                                        
                                        local tFriend = split(dt1[1].friends, "|")
                                        
                                        --���ͬʱ��YY���ѣ��������ѣ�ȥ���ظ��˵�����
                                        local tmpTable = {}
                                        for k,v in pairs(tFriend) do
                                            if(tonumber(v) ~= nil)then
                                                tmpTable[tostring(v)] = v
                                            end
                                        end
                                        
                                        for i = 1,#dt do
                                            local v = dt[i]["id"]
                                            if(tonumber(v) ~= nil)then
                                                tmpTable[tostring(v)] = v
                                            end
                                        end
                                        
                                        local friendlist = {}
                                        for _,uid in pairs(tmpTable) do
                                            if(tonumber(uid) ~= userinfo.userId)then
                                                table.insert(friendlist, uid)
                                                gamenum = gamenum + 1
                                            end
                                        end
                                        
                                        friendsstr = "|"..table.concat(friendlist, "|").."|"
                                        
                                        if gamenum + len > friendlib.CONFIG.MAXFRIEND then
                                            --��¼��������������޵���־
                                            dblib.execute(string.format(friendlib.sql.log_user_maxfriend,userinfo.userId,gamenum + len))
                                        
                                            gamenum = friendlib.CONFIG.MAXFRIEND - len
                                        end
                                    else
                                        --TraceError("���û����Ϸ����")
                                    end
    	
                                    for i = 1, len  do
                                        if tonumber(dt[i]["id"]) and tonumber(dt[i]["id"]) ~= tonumber(userinfo.userId) then
                                            snsnum = snsnum + 1
                                            table.insert(snsfriend, tostring(dt[i]["id"]))
                                        end
                                    end
                                    --д���ڴ�
                                    local szSnsfriend = "|"..table.concat(snsfriend,"|").."|"
                                    friendlib.write_friendinfo_to_ram(userinfo,friendsstr,szSnsfriend)
                                    --д�����ݿ�
                                    --dblib.execute(string.format(friendlib.sql.update_user_friends_info,dblib.tosqlstr(szSnsfriend),dblib.tosqlstr(friendsstr),userinfo.userId))
                                else
                                    TraceError("�����쳣,û�и���ҵĺ��Ѽ�¼")
                                end
                            end)
                        end

                        --��¼����������־
                        local userid = userinfo.userId
                        --dblib.execute(string.format(friendlib.sql.log_user_friend_num,userid,gamenum,snsnum,userid));
                    else
                        TraceError("��ȡ���YY�����쳣")
                    end
                end)
            else
                TraceError("��ȡyy������Ϣ���ݴ���")
            end
       -- end)
    end
end

friendlib.friendxml_to_table = function(xml_info)
	if (type(xml_info) ~= "string") then
		TraceError("ΪɶxmlΪ��")
		return "", ""
    end
    --���xml�ļ��Ƿ�Ϸ�
    if (string.find(xml_info, [[xml version="1.0" encoding="UTF"]]) == nil) then
        TraceError("xml���ݲ��Ϸ�"..xml_info)
		return "", ""
    end

    local users_friend = {}
    local friend_uids_list = {}
    local user_friend_uids = ""
    local strlen = 0  --��ֹ�ַ�������
    local find = false
    --����yy������Ϣ
    for w in string.gmatch(xml_info, [[<uid>[%d]+</uid>%s+<imid>[%d]+</imid>]]) do
    	local uid = string.match(w, [[<uid>([%d]+)</uid>]])
    	local imid = string.match(w, [[<imid>([%d]+)</imid>]])
    	local users_item = {uid=uid, imid=imid}
    	if (tonumber(uid) ~= nil and imid ~= nil) then
            if(strlen < 14000)then
        		users_friend[tonumber(uid)] = users_item
        		table.insert(friend_uids_list, "'"..tostring(uid).."'")
                strlen = strlen + string.len(tostring(uid)) + 1  --uid��",",
            end
    	end
    	find = true
    end
    --�����Լ�����Ϣ
    if (find == false) then
        for w in string.gmatch(xml_info, [[<id>[%d]+</id>%s+<imid>[%d]+</imid>]]) do
        	local id = string.match(w, [[<id>([%d]+)</id>]])
        	local imid = string.match(w, [[<imid>([%d]+)</imid>]])
        	local users_item = {id=id, imid=imid}
        	if (tonumber(id) ~= nil and imid ~= nil) then
                if(strlen < 14000)then
            		users_friend[tonumber(id)] = users_item
            		table.insert(friend_uids_list, "'"..tostring(uid).."'")
                    strlen = strlen + string.len(tostring(uid)) + 1  --uid��",",
                end
        	end
        end
    end

    --friend_uids_list����������
    user_friend_uids = table.concat(friend_uids_list,",")
	return user_friend_uids
end

friendlib.write_friendinfo_to_ram = function(userinfo,gamefriend,snsfriend)
	local tabgf = split(gamefriend,"|")
	local tabsnsf = split(snsfriend,"|")
	--TraceError(tabsnsf)
	userinfo.friends = {}
	local friendcount = 0
	--��Ϸ����
	for k,v in pairs(tabgf) do
		if tonumber(v) ~= nil then
			userinfo.friends[tonumber(v)] = {}
			userinfo.friends[tonumber(v)].friendType = 0
			friendcount = friendcount + 1
		end
	end
	--SNS����
	for k,v in pairs(tabsnsf) do
		if tonumber(v) ~= nil then
			userinfo.friends[tonumber(v)] = {}
			userinfo.friends[tonumber(v)].friendType = 1
			friendcount = friendcount + 1
		end
	end

	--��¼����ҵĺ�������
	userinfo.extra_info["F06"] = friendcount
	save_extrainfo_to_db(userinfo)

	--TraceError("���к����б� " .. tostringex(userinfo.friends))
	--֪ͨ����������������
	friendlib.change_userstate_tofriend(userinfo,1)

  friendlib.send_user_allfriend_info(userinfo,0)--0�������ߺ���
end

friendlib.send_user_allfriend_info = function(userinfo,nType)
	ASSERT(userinfo, 'userinfo nil')
	if not userinfo.friends then return end

    local tPack = {}
	local tSendPacks = { [1] = tPack }
	local friendsNum = 0
	for k, v in pairs(userinfo.friends) do
		if table.getn(tPack) == friendlib.CONFIG.LIMIT then
			tPack = {}
			tSendPacks[table.getn(tSendPacks) + 1] = tPack
		end
		local info
		if nType == 0 then
			info = usermgr.GetUserById(tonumber(k))
			if info and info.friends then--��ֹ�첽
				friendsNum = friendsNum + 1--��������
				tPack[table.getn(tPack) + 1] = info
			end
		else
			info = userinfo.friends[tonumber(k)].userinfo
			if info then
				friendsNum = friendsNum + 1--��������
				tPack[table.getn(tPack) + 1] = info
			end
		end
	end

	local sendUserFriendOnLinePack = function(userinfo, tPack)
		if table.getn(tPack) ~= 0 then
			netlib.send(
				function(outBuf)
					outBuf:writeString("FDSENDOL")
					for k, v in ipairs(tPack) do
						local ntype = 0
						local deskinfo = {}
						if v.desk and v.desk > 0 then
							ntype = 1
							table.insert(deskinfo,desklist[v.desk].smallbet)
							table.insert(deskinfo,desklist[v.desk].largebet)
                            table.insert(deskinfo,desklist[v.desk].channel_id or -1)
							table.insert(deskinfo,v.desk)
							table.insert(deskinfo,desklist[v.desk].desktype)
						end
						local vip_level = 0
						if viplib and viplib.get_vip_level(v) then
							vip_level = viplib.get_vip_level(v)
                        end
                      
						outBuf:writeInt(v.userId)
						outBuf:writeString(v.nick or "")
						outBuf:writeString(v.imgUrl or "")
						outBuf:writeByte(vip_level)--�Ƿ�ΪVIP
						outBuf:writeByte(ntype)--0����,1������
                        outBuf:writeInt(v.channel_id or -1) --����û���Ƶ������
                        outBuf:writeInt(v.channel_role or 0);
                        outBuf:writeInt(v.sex);
                        outBuf:writeInt(v.home_status or 0);
                        
						outBuf:writeByte(#deskinfo)
						for k,v in pairs(deskinfo) do
							outBuf:writeInt(v)
						end
					end
					outBuf:writeInt(0)
				end,userinfo.ip,userinfo.port)
        end
	end

	local sendUserFriendAllPack = function(userinfo, tPack)
       
        local vip_level = 0
        --TraceError(tPack)
		if table.getn(tPack) ~= 0 then
			netlib.send(
				function(outBuf)
					outBuf:writeString("FDSENDALL")
					for k, v in ipairs(tPack) do
						outBuf:writeInt(v.userid)
						outBuf:writeString(v.nick or "")
						outBuf:writeString(v.face or "")
						outBuf:writeInt(v.level or 0)
						outBuf:writeInt(v.gold or 0)
						outBuf:writeByte(v.friendType)
						outBuf:writeByte(v.viplevel)
					end
					outBuf:writeInt(0)
				end,userinfo.ip,userinfo.port)
        end
    end

    for k, v in ipairs(tSendPacks) do
		if nType == 0 then
			sendUserFriendOnLinePack(userinfo, v)
		else
			sendUserFriendAllPack(userinfo, v)
		end
	end
	
	--�����Լ���ǰ��������������ȡ
    local ntfdFun = function(outBuf)
        outBuf:writeString("FDSENDEND")
        outBuf:writeInt(friendsNum)
		outBuf:writeByte(nType)--0����--1����
    end

    netlib.send(ntfdFun,userinfo.ip,userinfo.port)
end

friendlib.change_userstate_tofriend = function(userinfo,nType)
	ASSERT(userinfo, 'userinfo nil')
	if not userinfo.friends then
		return
	end
	--TraceError("״̬�仯 nType = " .. nType)
	--TraceError("userinfo �� ID " .. userinfo.userId)
	for k,v in pairs(userinfo.friends) do
		local touserinfo = usermgr.GetUserById(tonumber(k))

		if touserinfo and touserinfo.friends then--��ֹ�첽ִ��
			--TraceError("���� �� ID " .. touserinfo.userId)
			if nType == 1 then--��������ͼӺ���һ��
				--TraceError("������")
				local deskinfo = {}
				local nType = 0 
				if userinfo.desk and userinfo.desk > 0 then
					nType = 1
					table.insert(deskinfo,desklist[userinfo.desk].smallbet)
					table.insert(deskinfo,desklist[userinfo.desk].largebet)
                    table.insert(deskinfo,desklist[userinfo.desk].channel_id or -1)
					table.insert(deskinfo,userinfo.desk)
					table.insert(deskinfo,desklist[userinfo.desk].desktype)
				end

				friendlib.send_newfriend_info(touserinfo,userinfo,nType,deskinfo)--֪ͨ�����Լ�������
			else
				--TraceError("����״̬ nType" .. nType)
				friendlib.do_change_userstate_tofriend(userinfo,touserinfo,nType)
			end
		end
	end
end

friendlib.do_change_userstate_tofriend = function(userinfo,friendinfo,nType)
	local deskinfo = {}
	if nType == 3 then
		table.insert(deskinfo,desklist[userinfo.desk].smallbet)
		table.insert(deskinfo,desklist[userinfo.desk].largebet)
        table.insert(deskinfo,desklist[userinfo.desk].channel_id or -1)
		table.insert(deskinfo,userinfo.desk)
		table.insert(deskinfo,desklist[userinfo.desk].desktype)
	end

	netlib.send(
		function(buf)
			buf:writeString("FDSENDSTATE")
			buf:writeInt(userinfo.userId)
			buf:writeByte(nType)--0����,2����������,3����������
			buf:writeByte(#deskinfo)
			for k,v in pairs(deskinfo) do
				buf:writeInt(v)
			end
		end,friendinfo.ip,friendinfo.port)
end

friendlib.net_OnRecvInviteFriendJoin = function(buf)
	local userKey = getuserid(buf)
    local userinfo = userlist[userKey]
	if not userinfo then return end
	if not userinfo.friends then return end

	if not userinfo.desk or userinfo.desk <= 0 then
		--TraceError("�Լ����������ϻ����������˼���??")
		return
	end

	local inviteuserid = buf:readInt()
	if not usermgr.GetUserById(inviteuserid) or not userinfo.friends[inviteuserid] then
		--TraceError("�����ߵ��û������Լ��ĺ���")
		return
	end

	local inviteuserinfo = usermgr.GetUserById(inviteuserid)
	
	netlib.send(
		function(buf)
			buf:writeString("FDSENDINVITE")
			buf:writeByte((inviteuserinfo.site and inviteuserinfo.site > 0) and 1 or 0)--�Ƿ�������1���棬0û��
			buf:writeString(userinfo.nick or "")
			buf:writeInt(desklist[userinfo.desk].smallbet)
			buf:writeInt(desklist[userinfo.desk].largebet)
			buf:writeInt(userinfo.desk)
            buf:writeInt(userinfo.channel_id or -1)
            buf:writeInt(desklist[userinfo.desk].desktype)
		end,inviteuserinfo.ip,inviteuserinfo.port)
end

friendlib.net_OnRecvShowAddFriend = function(buf)
	local userKey = getuserid(buf)
	local userinfo = userlist[userKey]
	if not userinfo then return end
	if not userinfo.friends then return end

	if not userinfo.site or userinfo.site <= 0 then
		--TraceError("�Լ��������£����ܼӱ��˺���")
		return
	end

	local clickid = buf:readInt()
    --[[
    if (duokai_lib and duokai_lib.is_sub_user(clickid) == 1) then
        clickid = duokai_lib.get_parent_id(clickid)
    end
    --]]
	local clickuserinfo = usermgr.GetUserById(clickid)
	if not clickuserinfo then 
		--TraceError("clickuserinfo nil")
		return 
	end
	if not clickuserinfo.site or clickuserinfo.site <= 0 then
		--TraceError("����û���£����ܼӱ��˺���")
		return
	end

    if(duokai_lib and duokai_lib.is_sub_user(clickid) == 1) then
        clickid = duokai_lib.get_parent_id(clickid)
    end
	if userinfo.friends[clickid] then
		--TraceError("�Ѿ����Լ��ĺ�����")
		return
	end

	--����Լ��ͶԷ��ĺ�������
	--if #userinfo.friends >= friendlib.CONFIG.MAXFRIEND then
	local myfriendcount = userinfo.extra_info["F06"] or 0
	local hisfriendcount = clickuserinfo.extra_info["F06"] or 0
	local limitcount = friendlib.CONFIG.MAXFRIEND
	if myfriendcount > limitcount or hisfriendcount > limitcount then
		--TraceError("�����Ӻ��ѽ���������")
		return
	end
	
	--�������оܾ��б�
	if clickuserinfo.refuselist and #clickuserinfo.refuselist > 0 then
		local num = 0
		for k,v in pairs(clickuserinfo.refuselist) do
			if tonumber(v) == tonumber(userinfo.userId) then
				num = 1
				break
			end
		end

		if num == 1 then
			--TraceError("��ǰ���������Ѿ��ܾ����Լ�")
			return
		end
	end
	
	--���Ϳ�����ʾ��
    --TraceError('okdkjkdd')
	netlib.send(
		function(buf)
			buf:writeString("FDSENDSHOWADD")
		end,userinfo.ip,userinfo.port)
end

friendlib.net_OnRecvChangeFriendInfo = function(buf)
    --TraceError('net_onRecChagneFreindInfo');
	local userKey = getuserid(buf)
	local userinfo = userlist[userKey]
	if not userinfo then return end
	if not userinfo.friends then return end
	
	local changetype = buf:readByte()--��������,0ɾ��,1����,2�ܾ�
	local changeid = buf:readInt()--�ʼ���ʼ����from 

	if changeid == userinfo.userId then
		TraceError("����Լ���")
		return
	end

	if changetype ~= 0 then
		local szMd5 = buf:readString()

		local szMd5Check = string.md5(tostring(changeid) .. tostring(userinfo.userId) .. "OY^_^OY")

		if szMd5 ~= szMd5Check then
			TraceError("��֤û��ͨ��")
			return
		end
	end

	if changetype == 0 then
		if not userinfo.friends[tonumber(changeid)] then
			--TraceError("�����Լ����ѷǷ�ɾ��")
			friendlib.net_send_changeresult(userinfo,0,0,changeid)
			return
		end

		friendlib.do_delete_userfriend_byid(userinfo,changeid)
	elseif changetype == 1 then
		if userinfo.friends[tonumber(changeid)] then
			--TraceError("�Ѿ����Լ����ѷǷ����")
			friendlib.net_send_changeresult(userinfo,1,0,changeid)
			return
		end
		
		--�����������Ƿ񳬹�����
		local touserinfo = usermgr.GetUserById(changeid)
		if(not touserinfo) then
			--TraceError("�ӹ����˶�������...")
			friendlib.net_send_changeresult(userinfo,1,0,changeid)
			return
		end
		local myfriendcount = userinfo.extra_info["F06"] or 0
		local hisfriendcount = touserinfo.extra_info["F06"] or 0
		local limitcount = friendlib.CONFIG.MAXFRIEND
		if myfriendcount > limitcount or hisfriendcount > limitcount then
			--TraceError("�����Ӻ��ѽ���������")
			friendlib.net_send_changeresult(userinfo,1,0,changeid)
			return
        end

        if userinfo.site and userinfo.site > 0 then 
            friendlib.do_add_userfriend_byid(userinfo,changeid)
    	end
	else
		if not userinfo.refuselist then--�ܾ��б�����
			userinfo.refuselist = {}--����
			table.insert(userinfo.refuselist,changeid)
			return
		end

		local num = 0
		for k,v in pairs(userinfo.refuselist) do
			if tonumber(v) == tonumber(changeid) then
				num = 1
				break
			end
		end

		if num == 0 then
			table.insert(userinfo.refuselist,changeid)
		end
	end
end

friendlib.net_OnRecvCheckUserOnline = function(buf)
	local userKey = getuserid(buf)
	local myInfo = userlist[userKey]
	if not myInfo then return end

	local user_id = buf:readInt(); --�յ���Ҫ��ѯ���û�ID
	local userinfo = usermgr.GetUserById(user_id)
	local is_online = 0; --�Ƿ�����0�������ߣ� 1����
	if userinfo ~= nil then
		is_online = 1;
	end
	--֪ͨ�ͻ����û��������
	netlib.send(
		function(buf)
			buf:writeString("PHUOS")
			buf:writeByte(is_online)--�Ƿ�����
			buf:writeInt(user_id)	--��Ҫ��ѯ���û�ID
		end,myInfo.ip,myInfo.port)
end

friendlib.do_delete_userfriend_byid = function(userinfo,delid)
    if not userinfo then return end
    if not userinfo.friends then return end
    
    --ɾ������
    userinfo.friends[tonumber(delid)] = nil
	friendlib.net_send_changeresult(userinfo,0,1,delid)
    --�ܾ��б���ɾ��
    if type(userinfo.refuselist) == "table" then
        for i=1,#userinfo.refuselist do
            if(userinfo.refuselist[i] == delid)then
                userinfo.refuselist[i] = nil
                break
            end
        end
    end
    --���´���ҵĺ�������
    userinfo.extra_info["F06"] = userinfo.extra_info["F06"] - 1
    save_extrainfo_to_db(userinfo)
    
    local deluserinfo = usermgr.GetUserById(delid)
    
    --�������ߣ�Ҫ���Լ�ɾ��--����Ϊ����
    if deluserinfo then
        deluserinfo.friends[tonumber(userinfo.userId)] = nil
        friendlib.net_send_changeresult(deluserinfo,0,1,userinfo.userId)
        --�ܾ��б���ɾ��
        if type(deluserinfo.refuselist) == "table" then
            for i=1,#deluserinfo.refuselist do
                if(deluserinfo.refuselist[i] == userinfo.userId)then
                    deluserinfo.refuselist[i] = nil
                    break
                end
            end
        end
        --������һ����ҵĺ�������
        deluserinfo.extra_info["F06"] = deluserinfo.extra_info["F06"] - 1
        save_extrainfo_to_db(deluserinfo)
    
        friendlib.do_change_userstate_tofriend(userinfo,deluserinfo,0)
    
        friendlib.do_change_userstate_tofriend(deluserinfo,userinfo,0)--�ҵ����ߺ�����ɾ��֮
    end
	
    --��¼ɾ����־
    dblib.execute(string.format(friendlib.sql.log_user_delfriend,userinfo.userId,delid))
    
    --д�����ݿ�
    local usergamestr = "|" .. tostring(delid) .. "|"
    dblib.execute(string.format(friendlib.sql.updateuserdelgamefriend,dblib.tosqlstr(usergamestr),userinfo.userId))
    
    --д�����ݿ�
    local delgamestr = "|" .. tostring(userinfo.userId) .. "|"
    dblib.execute(string.format(friendlib.sql.updateuserdelgamefriend,dblib.tosqlstr(delgamestr),delid))
end

friendlib.do_add_userfriend_byid = function(userinfo,addid)
	if not userinfo then return end
	if not userinfo.friends then return end
	
	local adduserinfo = usermgr.GetUserById(addid)

	--֪ͨ�Ӻ��ѳɹ���
	friendlib.net_send_changeresult(userinfo,1,1,addid)

    --֪ͨ�����ģ�飬����˽����мӹ�����
    if (tex_dailytask_lib) then
        xpcall(function()tex_dailytask_lib.set_addfriend_status(adduserinfo) end,throw)
    end
    
  	--֪ͨ���˼�԰���º���  
    if (dhomelib) then
        xpcall(function()dhomelib.notify_add_friend(userinfo.userId,adduserinfo.userId) end,throw)
    end
    
	eventmgr:dispatchEvent(Event("add_friend",	_S{to_user_info=userinfo, from_user_info=adduserinfo}));

	--���´���ҵĺ�������
	userinfo.extra_info["F06"] = userinfo.extra_info["F06"] + 1
	save_extrainfo_to_db(userinfo)

	--��Ϸ����
	userinfo.friends[tonumber(addid)] = {}
	userinfo.friends[tonumber(addid)].friendType = 0

	if adduserinfo then

		local ntype = 0 
		local deldeskinfo = {}
		if adduserinfo.desk and adduserinfo.desk > 0 then --��������
			--֪ͨ�Ӻ��ѳɹ���
			friendlib.net_send_changeresult(adduserinfo,1,1,addid)
			--������һ����ҵĺ�������
			adduserinfo.extra_info["F06"] = adduserinfo.extra_info["F06"] + 1
			save_extrainfo_to_db(adduserinfo)

			ntype = 1
			table.insert(deldeskinfo,desklist[adduserinfo.desk].smallbet)
			table.insert(deldeskinfo,desklist[adduserinfo.desk].largebet)
            table.insert(deldeskinfo,desklist[adduserinfo.desk].channel_id or -1)
			table.insert(deldeskinfo,adduserinfo.desk)
            table.insert(deldeskinfo,desklist[adduserinfo.desk].desktype)
		end

		friendlib.send_newfriend_info(userinfo,adduserinfo,ntype,deldeskinfo)--�����Լ�,���ѵ�״��
		
		local mydeskinfo = {}
		table.insert(mydeskinfo,desklist[userinfo.desk].smallbet)
		table.insert(mydeskinfo,desklist[userinfo.desk].largebet)
        table.insert(mydeskinfo,desklist[userinfo.desk].channel_id or -1)
		table.insert(mydeskinfo,userinfo.desk)
		table.insert(mydeskinfo,desklist[userinfo.desk].desktype)
		friendlib.send_newfriend_info(adduserinfo,userinfo,1,mydeskinfo)--���ߺ���,�Լ���״��

		--���ú��ѹ�����Ϣ
		friendlib.set_user_friend_info(userinfo,adduserinfo,addid)

		--��Ϸ����
		adduserinfo.friends[tonumber(userinfo.userId)] = {}
		adduserinfo.friends[tonumber(userinfo.userId)].friendType = 0

		--���ú��ѹ�����Ϣ
		friendlib.set_user_friend_info(adduserinfo,userinfo,userinfo.userId)

		--���͸��º��ѹ�����Ϣ
		friendlib.send_newfriend_info_tomanager(userinfo,userinfo.friends[tonumber(addid)].userinfo)

		--���͸��º��ѹ�����Ϣ
		friendlib.send_newfriend_info_tomanager(adduserinfo,adduserinfo.friends[tonumber(userinfo.userId)].userinfo)
	else
		--���������ˣ�ȥ���ݿ��
		dblib.execute(string.format(friendlib.sql.getuserinfofromdb,tonumber(addid)),
			function(dt)
				if dt and #dt > 0 then
					local frieninfo = table.clone(dt[1])
					frieninfo["viplevel"] = 0
					local id = frieninfo["userId"]
					dblib.execute(string.format(friendlib.sql.getuservipinfo,tonumber(id)),
						function(dtt)
							if dtt and #dtt > 0 then
								--frieninfo["viplevel"] = dtt[1]["vip_level"] > 0 and 1 or 0
                                				frieninfo["viplevel"] = dtt[1]["vip_level"]
							end

							friendlib.set_user_friend_info(userinfo,frieninfo,id)
							--���͸��º��ѹ�����Ϣ
							friendlib.send_newfriend_info_tomanager(userinfo,userinfo.friends[tonumber(id)].userinfo)
						end)
				end
			end)
	end
	
	--�������Ϲ㲥�Ӻ��Ѷ���
	friendlib.net_broadcastdesk_toplay(userinfo,addid)

	--��¼�Ӻ�����־
	dblib.execute(string.format(friendlib.sql.log_user_addfriend,userinfo.userId,addid))

	--д�����ݿ�
	local usergamestr = tostring(addid) .. "|"
	dblib.execute(string.format(friendlib.sql.updateuseraddgamefriend,dblib.tosqlstr(usergamestr),userinfo.userId))

	--д�����ݿ�
	local delgamestr = tostring(userinfo.userId) .. "|"
	dblib.execute(string.format(friendlib.sql.updateuseraddgamefriend,dblib.tosqlstr(delgamestr),addid))
end

friendlib.send_newfriend_info_tomanager = function(userinfo,friendinfo)
	netlib.send(
		function(buf)
			buf:writeString("FDSENDTOMGR")
			buf:writeInt(friendinfo.userid)
			buf:writeString(friendinfo.nick or "")
			buf:writeString(friendinfo.face or "")
			buf:writeInt(friendinfo.level)
			buf:writeInt(friendinfo.gold)
			buf:writeByte(friendinfo.friendType)
			buf:writeByte(friendinfo.viplevel)--�Ƿ�ΪVIP
		end,userinfo.ip,userinfo.port)
end

friendlib.net_send_changeresult = function(userinfo,addordel,result,changeID)
	netlib.send(
		function(buf)
			buf:writeString("FDSENDRESULT")
			buf:writeByte(addordel)--0ɾ����1����
			buf:writeByte(result)--0ʧ�ܣ�1�ɹ�
            buf:writeInt(changeID)  --���������ID
		end,userinfo.ip,userinfo.port)
end

friendlib.net_broadcastdesk_toplay = function(userinfo,addid)
	netlib.broadcastdesk(
		function(buf)
			buf:writeString("FDSENDPLAY")
			buf:writeInt(userinfo.userId)--���ܷ�
			buf:writeInt(addid)--���ͷ�
		end,userinfo.desk,borcastTarget.all)
end

friendlib.send_newfriend_info = function(userinfo,newfriend,ntype,info)
    --TraceError('to userid'..userinfo.userId..' friend id'..newfriend.userId);
	local vip_level = 0
	if viplib and viplib.get_vip_level(newfriend) then
		vip_level = viplib.get_vip_level(newfriend)	
	end
	netlib.send(
		function(buf)
			buf:writeString("FDSENDNEWOL")
			buf:writeInt(newfriend.userId)
			buf:writeString(newfriend.nick or "")
			buf:writeString(newfriend.imgUrl or "")
			buf:writeByte(vip_level)--�Ƿ�ΪVIP
			buf:writeByte(ntype)--0����--1����
			buf:writeInt(newfriend.channel_id or -1)
            buf:writeInt(newfriend.channel_role or 0);
            buf:writeInt(newfriend.sex or 0);
            buf:writeInt(newfriend.home_status or 0);            
			buf:writeByte(#info)	
			for i = 1,#info do
				buf:writeInt(info[i])
			end
		end,userinfo.ip,userinfo.port)
end

--������Һ��ѹ�����Ϣ
friendlib.set_user_friend_info = function(userinfo,friendinfo,friendid)
	if not userinfo then return end
	local userlevle = 0
	if friendinfo.level then
		userlevle = friendinfo.level
	else
		userlevle = usermgr.getlevel(friendinfo)
	end

    local vip_level = 0
    if(viplib and usermgr.GetUserById(friendinfo.userId) ~= nil) then
        vip_level = viplib.get_vip_level(usermgr.GetUserById(friendinfo.userId))
    else
        vip_level = friendinfo.viplevel
    end

    local isvip = (vip_level > 0) and 1 or 0

	userinfo.friends[tonumber(friendid)].userinfo = {}
	userinfo.friends[tonumber(friendid)].userinfo["userid"] = friendinfo.userId
	userinfo.friends[tonumber(friendid)].userinfo["nick"] = friendinfo.nick
	userinfo.friends[tonumber(friendid)].userinfo["face"] = friendinfo.imgUrl
	userinfo.friends[tonumber(friendid)].userinfo["level"] = userlevle
	userinfo.friends[tonumber(friendid)].userinfo["gold"] = friendinfo.gamescore
	userinfo.friends[tonumber(friendid)].userinfo["isvip"] = isvip
    	userinfo.friends[tonumber(friendid)].userinfo["viplevel"] = vip_level
	userinfo.friends[tonumber(friendid)].userinfo["friendType"] = userinfo.friends[tonumber(friendid)].friendType
end

friendlib.net_OnRecvGetAllFriendInfo = function(buf)
	--TraceError("������������")
	local userKey = getuserid(buf)
    local userinfo = userlist[userKey]
	if not userinfo then return end
	if not userinfo.friends then return end
  --if not userinfo.mobile_mode then return end;
  if userinfo.init_friend_finsh == 1 then 
    --friendlib.send_user_allfriend_info(userinfo,1) 
    return 
  end

	local leavefriendidlist = {}
	
	for k,v in pairs(userinfo.friends) do
		local friendinfo = usermgr.GetUserById(tonumber(k))

		if not friendinfo then--�õ����ߺ����б�
			table.insert(leavefriendidlist,tonumber(k))
		else
			friendlib.set_user_friend_info(userinfo,friendinfo,k)
		end			 
	end

	--���Ѷ�����
	if #leavefriendidlist <= 0 then
		friendlib.send_user_allfriend_info(userinfo,1)--1�õ����к����б�
	else --�����߼�������ǰ�����⣬����ֻ�ᷢ�����ߵĺ�����������������ߵĺ��ѣ����˵IOS�汾Ҫ�õ�����������������ˣ����ָ���ǰ�߼�һ����ֻ�Ż�����(��ǰ��ѭ�������ݿ⣬����һ�����㶨
		local leave_ids = ""
		for k,v in pairs(leavefriendidlist) do
			if leave_ids == "" then
				leave_ids = v
			else
				leave_ids = leave_ids..","..v
			end
		end
		
		local sql = "select userid as userId,nick_name as nick,face as imgUrl,gold as gamescore,level,vip_level AS viplevel from users a left join user_tex_info b on a.id = b.userid left join user_vip_info c on a.id = c.user_id where  a.id in (%s) limit 1000;"
		sql = string.format(sql, leave_ids)
		dblib.execute(sql, function(dt)		
			if dt and #dt > 0 then
				for i = 1, #dt do
					local frieninfo = table.clone(dt[i])
					friendlib.set_user_friend_info(userinfo,frieninfo,frieninfo["userId"])
				end
			end
				friendlib.send_user_allfriend_info(userinfo,1)
				userinfo.init_friend_finsh = 1
		end)
	end
end

friendlib.net_OnRecvJoinFriendDesk = function(buf)
	local userKey = getuserid(buf)
  local userinfo = userlist[userKey]
	if not userinfo then return end
	if not userinfo.friends then return end

	local deskno = buf:readInt()
	--local joinid = buf:readInt()--����ID--�����������˵�ID��Ҳ�����Ǳ������˵�ID

	local deskinfo = desklist[deskno]
	if not deskinfo then
		TraceError("�����ڵ����Ӻ�" .. deskno)
		return
	end
	
	--[[
	if not userinfo.friends[tonumber(joinid)] then
		TraceError("�뿪��Ȩ���벻�Ǻ��ѵ�������??")
		return
	end
	--]]	
    if deskinfo.desktype == g_DeskType.VIP then--�������VIP��
		if viplib and not viplib.check_user_vip(userinfo) then
			netlib.send(
				function(buf)
					buf:writeString("FDJOINFAIL")
				end,userinfo.ip,userinfo.port)
			return
		end
	end

	DoRecvRqWatch(userinfo, deskno, 1)
end

friendlib.net_OnRecvWantToAddFriend = function(buf)
	local userKey = getuserid(buf)
    local userinfo = userlist[userKey]
	if not userinfo then return end
	if not userinfo.friends then return end
	if not (userinfo.site and userinfo.site > 0) then 
		--TraceError("������λ�������?")
		return 
	end
	local touserid = buf:readInt()
	local touserinfo = usermgr.GetUserById(touserid)

	if not touserinfo then return end
	if not (touserinfo.site and touserinfo.site > 0) then 
		--TraceError("���ӵ��˲�����λ�ϣ���ô��ģ�")
		return 
	end
	
	if userinfo.desk and touserinfo.desk then
		if userinfo.desk ~= touserinfo.desk then
			TraceError("����һ������?")
			return
		end
	end

	if userinfo.friends[tonumber(touserid)] then
		TraceError("net_OnRecvWantToAddFriend �Ѿ����Լ����ѻ��ܼ�?")
		return
	end
	--�ɷ������ĳ��Ϊ����
	eventmgr:dispatchEvent(Event("want_add_friend",	{to_user_info=touserinfo, from_user_info=userinfo}));
	
	if not touserinfo.refuselist then--�ܾ��б�����
		touserinfo.refuselist = {}--����
		table.insert(touserinfo.refuselist,userinfo.userId)
	else
		local num = 0
		for k,v in pairs(touserinfo.refuselist) do
			if tonumber(v) == tonumber(userinfo.userId) then
				num = 1
				break
			end
		end
	
		if num == 0 then
			table.insert(touserinfo.refuselist,userinfo.userId)
		end
	end

	--make md5
    local szMd5 = string.md5(tostring(userinfo.userId) .. tostring(touserinfo.userId) .. "OY^_^OY")
    --send request to another user
    local sendFun = function(outBuf)
        outBuf:writeString("FDSENDCANADD")
        outBuf:writeString(szMd5)
        outBuf:writeInt(touserinfo.userId)
        outBuf:writeInt(userinfo.userId)
        outBuf:writeString(userinfo.nick)
	end
	--��������
	netlib.broadcastdeskex(sendFun,userinfo.desk,borcastTarget.all)
end

--�����б�
cmdHandler = 
{
  ["FDRQYQHY"] = friendlib.net_OnRecvInviteFriendJoin,         --�յ���������ĳ�����Ѽ�������
  ["FDRQTJHY"] = friendlib.net_OnRecvShowAddFriend,            --�յ������ܷ���ʾ��Ӹú��Ѱ�ť
  ["FDRQZJHY"] = friendlib.net_OnRecvChangeFriendInfo,         --�յ��޸ĺ�����Ϣ����
  ["FDRQAFIF"] = friendlib.net_OnRecvGetAllFriendInfo,         --�յ��õ����к�����Ϣ����
  ["FDRQJOIN"] = friendlib.net_OnRecvJoinFriendDesk,			 --�յ���������������
  ["FDRQWTAD"] = friendlib.net_OnRecvWantToAddFriend,			 --�յ�������ĳ�˺���
  ["PHUOS"] 	 = friendlib.net_OnRecvCheckUserOnline,			 --�յ���ѯ����������
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end
