TraceError("init ZQ db...")

if not zhongqiu_db_lib then
    zhongqiu_db_lib = _S
    {
    	--�����Ƿ���
    	init_user = NULL_FUNC,
 			save_user_info = NULL_FUNC,
      --�����Ǳ�����������Ϣ
 
    }    
end


--��ʼ������ڸ��ֱ����е�����;
function zhongqiu_db_lib.init_user(user_id)
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	zhongqiu_lib.user_list[user_id] = {}
	zhongqiu_lib.user_list[user_id].user_id = user_id
	zhongqiu_lib.user_list[user_id].play_count = {}
		
	local sql = "select play_count1, play_count2, play_count3 from user_zhongqiu_info where user_id = %d"
	sql = string.format(sql, user_id)
	dblib.execute(sql, function(dt)
		if dt and #dt > 0 then
			zhongqiu_lib.user_list[user_id].play_count[1] = dt[1].play_count1
			zhongqiu_lib.user_list[user_id].play_count[2] = dt[1].play_count2
			zhongqiu_lib.user_list[user_id].play_count[3] = dt[1].play_count3		
		else
			zhongqiu_lib.user_list[user_id].play_count[1] = 0
			zhongqiu_lib.user_list[user_id].play_count[2] = 0
			zhongqiu_lib.user_list[user_id].play_count[3] = 0
			sql = "insert into user_zhongqiu_info(play_count1, play_count2, play_count3, user_id, sys_time) value(0,0,0,%d,now()); "
			sql = string.format(sql, user_id)
			dblib.execute(sql)
		end
		zhongqiu_lib.send_panshu(user_info)
	end, user_id)
	

end

--��ʼ����ҵ�ͼֽ��Ϣ�����ڵ�ɾ��;
function zhongqiu_db_lib.init_user_tuzhi(user_id)
	
	local user_info = usermgr.GetUserById(user_id)
	if user_info == nil then return end
	
	--ȡ����ҵ����б�
	local propslist = tex_gamepropslib.get_props_list(user_info);
	
	--ɾ�����������±�ͼֽ
	if (zhongqiu_lib.check_time() ~= 1) and (zhongqiu_lib.check_time() ~= 2) then		
			for v1,_  in pairs(propslist) do 
				for _, v2 in pairs(zhongqiu_lib.GFG_TUZHI_LIST1) do 
					if v1 == v2 then
							--������ڲ��ҵ�������ͼֽ��ɾ��
							--�������ݿ�
							local get_count_tuzhi = function(nCount)
								tex_gamepropslib.set_props_count_by_id(v1, -1*nCount, user_info, nil)
							end
							tex_gamepropslib.get_props_count_by_id(v1, user_info, get_count_tuzhi)				
					end
				end
				for _, v2 in pairs(zhongqiu_lib.GFG_BOX_ID) do 
					if v1 == v2 then
							--������ڱ���
							--�������ݿ�
							local get_count_tuzhi = function(nCount)
								tex_gamepropslib.set_props_count_by_id(v1, -1*nCount, user_info, nil)
							end
							tex_gamepropslib.get_props_count_by_id(v1, user_info, get_count_tuzhi)				
					end
				end
			end
	end

	--ɾ������������Ƭ������ͼֽ
	if zhongqiu_lib.check_time() == 0 then
		for v1, _ in pairs(propslist) do 
				for _, v2 in pairs(zhongqiu_lib.GFG_TUZHI_LIST2) do 
					if v1 == v2 then
							local get_count_tuzhi = function(nCount)
								tex_gamepropslib.set_props_count_by_id(v1, -1*nCount, user_info, nil)
							end
							tex_gamepropslib.get_props_count_by_id(v1, user_info, get_count_tuzhi)				
					end
				end
			
			--ɾ����Ƭ
				for _, v2 in pairs(zhongqiu_lib.CFG_GIVE_ITEMID) do 
					if v1 == v2 then
							local get_count_tuzhi = function(nCount)
								tex_gamepropslib.set_props_count_by_id(v1, -1*nCount, user_info, nil)
							end
							tex_gamepropslib.get_props_count_by_id(v1, user_info, get_count_tuzhi)				
					end
				
				end
		end
			
	end
	
end

--�����û���Ϣ����ǰ����
function zhongqiu_db_lib.save_user_info(user_id) 
	if zhongqiu_lib.user_list[user_id] == nil or zhongqiu_lib.user_list[user_id].play_count == nil then return end	
	local sql = "update user_zhongqiu_info set play_count1 = %d, play_count2 = %d, play_count3 = %d,sys_time = now() where user_id = %d"
	sql = string.format(sql, zhongqiu_lib.user_list[user_id].play_count[1], zhongqiu_lib.user_list[user_id].play_count[2], zhongqiu_lib.user_list[user_id].play_count[3], user_id)
	dblib.execute(sql, function(dt) end, user_id) 
end


--���û�����
--function zhongqiu_db_lib.add_user_item(user_id, item_Id)
--	 
--	local sql = "update user_zhongqiu_info set userflag_count=userflag_count+%d, sys_time = now() where user_id = %d"
--	sql = string.format(sql, flag_count, user_id)
--	dblib.execute(sql, function(dt) end, user_id) 
--	sql = "insert into log_give_flag(user_id, add_flag, sys_time) value(%d,%d,now())"
--	sql = string.format(sql, user_id, flag_count)
--	dblib.execute(sql, function(dt) end, user_id) 
--end

--��¼���������־
function zhongqiu_db_lib.record_zhongqiu_transaction(user_info, item_id, type_id)
			if not user_info or not item_id or not type_id then 
				return
			end
		local user_id = user_info.user_id
    local sqltemple = "INSERT INTO log_zhongqiu_transaction (user_id, item_id, sys_time)value(%d, %d, now()) ";
    sqltemple = string.format(sqltemple, user_info.userId, item_id);
    dblib.execute(sqltemple);
end