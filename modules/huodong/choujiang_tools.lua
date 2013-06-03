TraceError("init choujiang_tools_lib...")
if not choujiang_tools_lib then
    choujiang_tools_lib = _S
    {
		do_chuojiang=NULL_FUNC,
		do_fajiang=NULL_FUNC,
		onRecvDakaiZhuanpan=NULL_FUNC,
		onRecvKaishiChoujiang=NULL_FUNC,
    }   
 end

--�齱
function choujiang_tools_lib.do_chuojiang(user_info)
	local user_info = userlist[getuserid(buf)]; 
    if not user_info then return end;
    local do_cj=function(userinfo,choujiang_type)
    	local sql = "call sp_get_random_spring_gift(%d,'%s',%d)"
	    sql = string.format(sql, userinfo.userId,gamepkg.name,choujiang_type)
	    dblib.execute(sql, 
	         function(dt)
	             if (dt and #dt > 0) then
	                 local jiangpin = dt[1]["gift_id"]                 
	                  choujiang_tools_lib.do_fajiang(userinfo,jiangpin)
	                  
	        		 --֪ͨ�񽱽��
	            	 netlib.send(
	                 function(buf)
	                     buf:writeString("TXKSCJ")
	                     buf:writeInt(task_huodong_lib.user_list[user_id].jiangjuan or 0)  
	                     buf:writeInt(jiangpin)  --������
	                 end,userinfo.ip,userinfo.port)
	             end
	         end)
    end
    
    --��һ�ν�Ҫ�ö��ٽ���
    local cj_area,use_jiang_juan = choujiang_lib.g_get_user_reward_area(user_info.userId)
    
    local ret = task_huodong_lib.add_jiang_juan(user_info, -1*use_jiang_juan)


    if (ret == 0) then
        TraceError("��ȯ�����ˣ��޷��齱")
        return    
    end
    
 	if (gamepkg.name ~= "tex") then
		bag.get_all_item_info(user_info, function(items)
            local check_items = {[4]=1};--���С�����ǲ� ����ǰ��
            local check_space = 0;
            local ret = 0;
            --�������
            for k, v in pairs(check_items) do
                check_space = bag.check_space(items, {[k] = v});                
                if(check_space ~= 1) then--��������
                	--֪ͨ�񽱽��
	            	 netlib.send(
	                 function(buf)
	                     buf:writeString("TXKSCJ")
	                     buf:writeInt(0)  
	                     buf:writeInt(0)  --�������ˣ�����ʧ��
	                 end,userinfo.ip,userinfo.port)
                    return false;
                end
            end   
            TraceError("qp")
    		do_cj(user_info,choujiang_type);
	   		
	 	end);
	else
		 TraceError("tex")
		do_cj(user_info,choujiang_type);
	end 
 	

end



--���ƵĽ���1��5000
--���ݵĽ���5001��10000
function choujiang_tools_lib.do_fajiang(user_info,jiangpin)
    --���ƺ͵��ݵĽ�Ʒ���Ǵ�1��ʼ�䣬���������׳���������ʱ�����ݵ�ID��5000�����������ִ���
	local msg=""
	local nick_name=user_info.nick
	jiangpin=tonumber(jiangpin)
    if (gamepkg.name ~= "tex") then
        --���Ʒ���
        if(jiangpin == 1)then           --�Ϳ�
            --������������
            viploginlib.AddBuffToUser(user_info,user_info,1); 	
        elseif(jiangpin == 2)then
            --����������
            viploginlib.AddBuffToUser(user_info,user_info,2); 	
        elseif(jiangpin == 3)then
            --С�԰�
	   		bag.add_item (user_info,{item_id = 4, item_num = 1},nil,bag.log_type.MD33_HOUDONG);
        elseif(jiangpin == 4)then
	    	--200���
            usermgr.addgold(user_info.userId, 200, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);
        elseif(jiangpin == 5)then
	    	--1000���
	    	usermgr.addgold(user_info.userId, 1000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);            
        elseif(jiangpin == 6)then
	    	--5000���
	    	usermgr.addgold(user_info.userId, 5000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);            
        elseif(jiangpin == 7)then
	    	--10000���
	   		usermgr.addgold(user_info.userId, 10000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1); 
        elseif(jiangpin == 8)then
	    	--50000���
	    	usermgr.addgold(user_info.userId, 50000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);
	    	msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�50000��� ")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg) 
        elseif(jiangpin == 11)then
            --������������
            viploginlib.AddBuffToUser(user_info,user_info,1); 		
        elseif(jiangpin == 12)then
            --����������
             viploginlib.AddBuffToUser(user_info,user_info,2); 	
        elseif(jiangpin == 13)then
            --С�԰�
	    	bag.add_item (user_info,{item_id = 4, item_num = 1},nil,bag.log_type.MD33_HOUDONG);
        elseif(jiangpin == 14)then
             --1000���
	    	usermgr.addgold(user_info.userId, 1000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);            
        elseif(jiangpin == 15)then
            --10000���
	    	usermgr.addgold(user_info.userId, 10000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);            
        elseif(jiangpin == 16)then
            --50000���
	    	usermgr.addgold(user_info.userId, 50000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1); 
	        msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�50000��� ")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg)  
        elseif(jiangpin == 17)then
	    	--10000���
	   		usermgr.addgold(user_info.userId, 100000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);  
        elseif(jiangpin == 18)then
	   		--500000���
	    	usermgr.addgold(user_info.userId, 500000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);  
	        msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�500000���")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg) 
        elseif(jiangpin == 21)then--���
            --С�԰�
	    	bag.add_item (user_info,{item_id = 4, item_num = 3},nil,bag.log_type.MD33_HOUDONG);
       elseif(jiangpin == 22)then
             --5000���
	    	usermgr.addgold(user_info.userId, 5000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);   
        elseif(jiangpin == 23)then            
	    	--10000���
	    	usermgr.addgold(user_info.userId, 10000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);  
        elseif(jiangpin == 24)then
	    	--50000���
	    	usermgr.addgold(user_info.userId, 50000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);  
	        msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�50000���")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg) 
        elseif(jiangpin == 25)then
	    	--100000���
	    	usermgr.addgold(user_info.userId, 100000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1); 
	        msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�10����")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg)  
        elseif(jiangpin == 26)then
	    	--1000000���
	    	usermgr.addgold(user_info.userId, 1000000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1);  
	        msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�1������")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg)  
        elseif(jiangpin == 27)then
	    	--10000000���
	    	usermgr.addgold(user_info.userId, 10000000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1); 
	        msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�1ǧ����")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg)  
        elseif(jiangpin == 28)then
	    	--100000000���
	    	usermgr.addgold(user_info.userId, 100000000, 0, tSqlTemplete.goldType.cj_HOUDONG, -1); 
	    	msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�1�ڽ��")
	    	tools.SendBufToUserSvr("", "SPBC", "", "", msg)  
        end

    else

        jiangpin=jiangpin+5000
        --���ݷַ���Ʒ
        if (jiangpin  == 5001) then
            --8888����
            gift_addgiftitem(user_info,5013,user_info.userId,user_info.nick, false)  
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ8888���� ")
	    	BroadcastMsg(msg);             
        elseif (jiangpin  == 5002) then
	    	--T��
            tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info);
        elseif (jiangpin  == 5003) then
            --1288����;
	    	usermgr.addgold(user_info.userId, 1288, 0, new_gold_type.CHOUJIANG, -1);
        elseif (jiangpin  == 5004) then
	    	--����ҩˮ
            usermgr.addexp(user_info.userId, usermgr.getlevel(user_info), 10, g_ExpType.jhm_huodong, groupinfo.groupid);
        elseif (jiangpin  == 5005) then
	    	--С����
            tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info);
        elseif (jiangpin  == 5006) then
	    	--�ع�
	    	gift_addgiftitem(user_info,4023,user_info.userId,user_info.nick, false)	
        elseif (jiangpin  == 5007) then
	    	--������	 
	    	gift_addgiftitem(user_info,4024,user_info.userId,user_info.nick, false)		
        elseif (jiangpin  == 5008) then
	    	--��«��	 
	    	gift_addgiftitem(user_info,4025,user_info.userId,user_info.nick, false)	
        elseif (jiangpin  == 5009) then
	    	--LV��	 
	    	gift_addgiftitem(user_info,5020,user_info.userId,user_info.nick, false)	
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ�LV�� ")
	    	BroadcastMsg(msg); 		    		
        elseif (jiangpin  == 5010) then
	    	--138����ɯ���� 	
	    	gift_addgiftitem(user_info,5021,user_info.userId,user_info.nick, false)  
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ138����ɯ���� ")
	    	BroadcastMsg(msg); 		    	
        elseif (jiangpin  == 5011) then
	    	--1������ʯ
	    	gift_addgiftitem(user_info,5001,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ1������ʯ ")
	    	BroadcastMsg(msg); 	
        elseif (jiangpin  == 5012) then
	    	--2��QQ�γ�
	    	gift_addgiftitem(user_info,5022,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ2��QQ�γ� ")
	    	BroadcastMsg(msg); 	    	
        elseif (jiangpin  == 5021) then
	    	--T��
            tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 1, user_info);
        elseif (jiangpin  == 5022) then
	    	--С����
            tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 1, user_info);
        elseif (jiangpin  == 5023) then
            --�ع�
            gift_addgiftitem(user_info,4023,user_info.userId,user_info.nick, false)	
        elseif (jiangpin  == 5024) then
            --1000���˳���
            usermgr.addgold(user_info.userId, 1000, 0, new_gold_type.CHOUJIANG, -1);
        elseif (jiangpin  == 5025) then
            --5000���˳���
            usermgr.addgold(user_info.userId, 5000, 0, new_gold_type.CHOUJIANG, -1);
        elseif (jiangpin  == 5026) then
            --8888����
            gift_addgiftitem(user_info,5013,user_info.userId,user_info.nick, false)  
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ8888���� ")
	    	BroadcastMsg(msg);              
        elseif (jiangpin  == 5027) then
            --1������ʯ
            gift_addgiftitem(user_info,5001,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ1������ʯ ")
	    	BroadcastMsg(msg);               
        elseif (jiangpin  == 5028) then
            --2��QQ�γ�
            gift_addgiftitem(user_info,5022,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ2��QQ�γ� ")
	    	BroadcastMsg(msg);            
        elseif (jiangpin  == 5029) then
            --5���̱�ʯ
            gift_addgiftitem(user_info,5002,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ5���̱�ʯ ")
	    	BroadcastMsg(msg);	            
        elseif (jiangpin  == 5030) then
            --10��Ʊ�ʯ	
            gift_addgiftitem(user_info,5003,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ10��Ʊ�ʯ ")
	    	BroadcastMsg(msg);	
        elseif (jiangpin  == 5031) then
            --50��챦ʯ
            gift_addgiftitem(user_info,5004,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ50��챦ʯ ")
	    	BroadcastMsg(msg);	            
        elseif (jiangpin  == 5032) then
            --138����ɯ���� 	
            gift_addgiftitem(user_info,5021,user_info.userId,user_info.nick, false)  
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ138����ɯ���� ")
	    	BroadcastMsg(msg);	
        elseif (jiangpin  == 5041) then
            --T�˿�*2	
            tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.KICK_CARD_ID, 2, user_info);
        elseif (jiangpin  == 5042) then
            --С����*2
            tex_gamepropslib.set_props_count_by_id(tex_gamepropslib.PROPS_ID.SPEAKER_ID, 2, user_info);
        elseif (jiangpin  == 5043) then
            --5000���˳���
            usermgr.addgold(user_info.userId, 5000, 0, new_gold_type.CHOUJIANG, -1);
        elseif (jiangpin  == 5044) then
            --8888����
            gift_addgiftitem(user_info,5013,user_info.userId,user_info.nick, false) 
             msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ8888����")
	    	BroadcastMsg(msg);	             
        elseif (jiangpin  == 5045) then
            --1������ʯ
            gift_addgiftitem(user_info,5001,user_info.userId,user_info.nick, false)	
             msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ1������ʯ")
	    	BroadcastMsg(msg);	            
        elseif (jiangpin  == 5046) then
            --2��QQ�γ�
            gift_addgiftitem(user_info,5022,user_info.userId,user_info.nick, false)
             msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ2��QQ�γ�")
	    	BroadcastMsg(msg);	           
        elseif (jiangpin  == 5047) then
            --5���̱�ʯ
            gift_addgiftitem(user_info,5002,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ5���̱�ʯ")
	    	BroadcastMsg(msg);	
        elseif (jiangpin  == 5048) then
            --10��Ʊ�ʯ	
            gift_addgiftitem(user_info,5003,user_info.userId,user_info.nick, false)
            msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ10��Ʊ�ʯ")
	    	BroadcastMsg(msg);	
        elseif (jiangpin  == 5049) then
            --50��챦ʯ
            gift_addgiftitem(user_info,5004,user_info.userId,user_info.nick, false)
	    	msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ50��챦ʯ")
	    	BroadcastMsg(msg);			
        elseif (jiangpin  == 5050) then
	    	--138�򱼳�	
            gift_addgiftitem(user_info,5017,user_info.userId,user_info.nick, false)
	    	msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ138�򱼳�	")
	    	BroadcastMsg(msg);	
        elseif (jiangpin  == 5051) then
	   		--588������
	   		gift_addgiftitem(user_info,5024,user_info.userId,user_info.nick, false)
	    	msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ588������")
	    	BroadcastMsg(msg);	   		
        elseif (jiangpin  == 5052) then
	    	--1888����������
	    	gift_addgiftitem(user_info,5026,user_info.userId,user_info.nick, false)
	    	msg=_U("��ϲ ")..nick_name.._U("��ÿ��������껪�г齱�õ���ֵ1888����������")
	    	BroadcastMsg(msg);
        end
     end
end



function choujiang_tools_lib.onRecvDakaiZhuanpan(buf)
	local userinfo = userlist[getuserid(buf)]; 
	if not userinfo then return end;
	--local lottery_count = zhuanpan_zyszlib.get_lottery_count(userinfo)
	local lottery_count = task_huodong_lib.user_list[user_id].jiangjuan or 0
    local pai_xin = 0--zhuanpan_zyszlib.get_pai_xin(userinfo)
	netlib.send(
            function(buf)
                buf:writeString("TXDKZP")
                buf:writeInt(lottery_count)  --������
                buf:writeInt(pai_xin) --?
            end,userinfo.ip,userinfo.port)
 

end


function choujiang_tools_lib.onRecvKaishiChoujiang(buf)
	local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
   choujiang_tools_lib.do_chuojiang(user_info)

end    



--�����б�
cmdHandler = 
{
	--["TXDKZP"] = choujiang_tools_lib.onRecvDakaiZhuanpan, --�յ���ת��
	--["TXKSCJ"] = choujiang_tools_lib.onRecvKaishiChoujiang, --�յ���ʼ�齱
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end

