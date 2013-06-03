TraceError("���� ��Ϸ���� ���....")

if not tex_ip_protect_lib then
	tex_ip_protect_lib = _S
	{
        check_ip_address_protect = NULL_FUNC,
        unlock_user_protect = NULL_FUNC,   
        after_user_login = NULL_FUNC,  
        check_user_email = NULL_FUNC,	--����û�email   
	}
end

--������֤��������߱�����
function tex_ip_protect_lib.check_ip_address_protect(user_info)

	--��ͻ��˷��ؽ�����ڲ�����
	local send_check_ip = function(open_box,is_first)
		    netlib.send(function(buf)
		                    buf:writeString("TXCHECKIP")
		                    buf:writeByte(open_box)
		                    buf:writeByte(is_first)
		                end,
	                user_info.ip, user_info.port)    
	end
  	
  	
	--�������ID�����ε�½��IP
	--������ҵ����εĵ�½IP���Ƿ��һ�ε�½
	local send_user_ip_info = function(user_id,user_ip_address)
		local sql="SELECT safe_pw ,ipaddress,lockflag,last_ip FROM user_safebox_info AS a LEFT JOIN user_ip_protect_info b ON a.user_id=b.user_id WHERE a.user_id=%d;";
   
	    local ipaddress="";
	    local lockflag=0;
	    local safe_pw="";
	    --is_first�Ƿ��һ�ε�½��open_box�ǲ���Ҫ����
	    local is_first=1;
	    local open_box=0;--��1������0��������
	    sql=string.format(sql,user_id);
	    dblib.execute(sql,function(dt)
	        if(dt and #dt > 0) then
	        	ipaddress = dt[1].ipaddress;
	        	lockflag = dt[1].lockflag;
	        	safe_pw=dt[1].safe_pw;
	        	--���û��ͨ���������룬ֱ�Ӳ��õ���
				if(safe_pw==nil or safe_pw=="") then
					open_box=0;				
	        	--���ipaddressΪ�ջ�nil����ôis_first=1����Ϊ0
	            elseif(ipaddress~=nil and ipaddress~="")then
	            	is_first=0;	
			    	local pos=string.find(ipaddress,user_ip_address) or -1
			    	--���ؿͻ��˲��õ�����1������0��������
			    	if(pos==-1)then	
			    		
			    		open_box=1;
			    	else			    		
			    		open_box=0;
			    	end
			    	--1.��û��channel_id��2.last_ip�ǲ�����ͬ
			    	local user_info=usermgr.GetUserById(user_id);
			    	if(user_info~=nil and user_info.channel_id~=nil and user_info.channel_id>0
			    		 and user_info.ip~=dt[1].last_ip)then
			    		open_box=1;
			    	end
			    	
				else
					is_first=1;
					open_box=1;
			    end
				--���ͼ�������ͻ���		    
	        	send_check_ip(open_box,is_first);
	        	--�����ɹ�����½ʱ���õ�����ʱ����������Ϊ�ǺϷ���½ʱ������Ҫ��IP��ַ
	        	if(open_box==0)then  	
					tex_ip_protect_lib.after_user_login(user_info)
				end
	        end
        end)
		
	end
	
	
	--1.�õ���ҵ�IP��ַ
	--2.��ҵ�IP��ַ�ǲ�����5�����õ�ַ�е�
	--3.���õ�ַ��ֱ�ӷ���|���ǳ��õ�ַ������IP��ַ�⣬�����û���֪ͨ�ͻ�������û�������
	
    if(user_info == nil)then return end;
    local user_ip_address=get_two_pairs_ip(user_info.ip);
	local user_id=user_info.userId
   
    --�õ�������ε�½IP��ַ��
    send_user_ip_info(user_id,user_ip_address); 
    
end


--����IP��ַ������IP��ַ��
update_user_ipaddress = function(user_id,ip_address,user_ip_address,last_ip)
	local sql="";
	--����ǿյģ���ֱ�Ӳ�����ε�IP
	if(ip_address==nil or ip_address=="") then
		sql="insert ignore into user_ip_protect_info(user_id,ipaddress,last_ip,lockflag,sys_time) value(%d,'%s','%s',0,now())";
		sql = string.format(sql,user_id,user_ip_address,last_ip);
		dblib.execute(sql);
	else
		--�����Ϊ�գ���������������ε�IP
		local tmpStr=get_four_rencent_ip(ip_address)..","..user_ip_address;
		sql="update user_ip_protect_info set ipaddress='%s',lockflag=0,last_ip='%s' where user_id=%d";
		sql = string.format(sql,tmpStr,last_ip,user_id);
		dblib.execute(sql);
    end

end
--����û�email
tex_ip_protect_lib.check_user_email = function(buf)
	local userKey = getuserid(buf)
	local userInfo = userlist[userKey]
	if not userInfo then return end
	--֪ͨ�ͻ���
	netlib.send(function(buf)
            buf:writeString("TXRETRIEVE")
            buf:writeString(userInfo.email or "")
        end,
    userInfo.ip, userInfo.port)
end

--�������IP��ǰ����
get_two_pairs_ip = function(ip_address)
	if(ip_address==nil or ip_address=="") then return "" end;
	local ip_address_list = split(ip_address,".");
	local two_pairs_ip_address = ""; 
	for i=1,2 do
		two_pairs_ip_address = two_pairs_ip_address.."."..ip_address_list[i];
	end
	two_pairs_ip_address=string.sub(two_pairs_ip_address, 2)
	return two_pairs_ip_address;
end

--�����������ù���4��IP��ַ��,�Զ�����������Ǹ�IP
get_four_rencent_ip = function(ip_address)
	if(ip_address==nil or ip_address=="") then return "" end;
	local ip_address_list = split(ip_address,",");
	local four_rencent_ip = ""; 
	local tmplen=#ip_address_list;
	local pos=1;	
	if (tmplen>=5) then 
		tmplen=5
		pos=2; 
	end;
	for i=pos,tmplen do
		four_rencent_ip = four_rencent_ip..","..ip_address_list[i];
	end
	four_rencent_ip=string.sub(four_rencent_ip, 2)
	return four_rencent_ip;
end


function tex_ip_protect_lib.after_user_login(user_info)
	local sql="update user_ip_protect_info set last_ip='%s' where user_id=%d"
	sql=string.format(sql,user_info.ip,user_info.userId)
	dblib.execute(sql);
end

--�����û�����������ǶԵľͽ��������Եľͽ���ʧ��
function tex_ip_protect_lib.unlock_user_protect(buf)
--��ͻ��˷��ؽ�����ڲ�����

	local send_unlock_info = function(unlockflag,user_info)
			
		    netlib.send(function(buf)
		                    buf:writeString("TXUNLOCK")
		                    buf:writeByte(unlockflag)
		                end,
	                user_info.ip, user_info.port)    
	end
	
    local user_info = userlist[getuserid(buf)]; 
    if(user_info == nil)then return end;
	    local password = buf:readString(buf)
	    local sql="";
	
	    
	    --����ҽ���
	    local unlock_user=function(user_id,check_flag)
	    local user_info = usermgr.GetUserById(user_id);
		local user_ip_address=get_two_pairs_ip(user_info.ip);
		   
		--��������������ǶԵģ��ͽ���������ε�IPд�����ݿ��У�
		local unlockflag=0
	   if(check_flag==1)then
	    	sql="select ipaddress from user_ip_protect_info where user_id=%d";
	    	sql=string.format(sql,user_id);
	    	  dblib.execute(sql,function(dt)
		        if(dt and #dt > 0) then
		        	local ipaddress = dt[1].ipaddress;		        	

			    	unlockflag=1
			    	update_user_ipaddress(user_id,ipaddress,user_ip_address,user_info.ip)		    	
				    --���ظ��ͻ��˽���״̬�������ɹ�
				    send_unlock_info(unlockflag,user_info);
				else
					unlockflag=1
					--���ظ��ͻ��˽���״̬,�����ɹ�
					update_user_ipaddress(user_id,"",user_ip_address,user_info.ip)
				    send_unlock_info(unlockflag,user_info);
		        end
	        end)
	    else
	        unlockflag=0
			--���ظ��ͻ��˽���״̬,�������ɹ�
			send_unlock_info(unlockflag,user_info);
	    end
  	end

    --����ұ����������ǲ��ǶԵģ��ǶԵľͽ���
    check_safebox_pwd(user_info.userId,password,unlock_user)
    
end


--�����б�
cmd_ip_protect_handler = 
{
	["TXCHECKIP"] = tex_ip_protect_lib.check_ip_address_protect, --����IP��ַ��Ϣ
    ["TXUNLOCK"] = tex_ip_protect_lib.unlock_user_protect, --�����û�
	["TXRETRIEVE"] = tex_ip_protect_lib.check_user_email,	--����û�����
}

--���ز���Ļص�
for k, v in pairs(cmd_ip_protect_handler) do 
	cmdHandler_addons[k] = v
end



