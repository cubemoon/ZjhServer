
TraceError("init sn_huodonglib....")

if not sn_huodonglib then
	sn_huodonglib = _S
	{
        on_recv_gift_sn = NULL_FUNC,		--ʱ��У��        
        on_game_over = NULL_FUNC,			--��Ϸ���������ж�
  		on_after_user_login = NULL_FUNC,    --�û���½ʱ������Ʒ
  		on_recv_czgift = NULL_FUNC,			--��½�Զ��ͳ�ֵ�õ�����Ʒ
	}
end

--�յ�������
function sn_huodonglib.on_recv_gift_sn(buf)
    --TraceError("init on_recv_gift_sn....");
	local userinfo = userlist[getuserid(buf)]; 
    if not userinfo then return end;
    local gift_sn=buf:readString();  --�õ�������
    gift_sn=no_sql_insert(gift_sn);
    local sendStr="";
    local sendResult;
    local retresult;
    --1.���ô洢���̣����������ûʹ�ù�����ֱ���õ�
   dblib.execute(string.format("call sp_update_giftsn(%d,'%s')",userinfo.userId,gift_sn),
		function(dt)
            if dt and #dt > 0 then
				--�洢���̷�����Ҫ���Ľ�
                --TraceError(dt[1]["result"]);
                retresult=tonumber(dt[1]["result"]);
    				if retresult > 0 then
    				   	sendResult=1;
                        	
    					--����ҷ���
    					if retresult==1 then
    						--A.12000�ݣ�688���롢30����ֵ��
    						usermgr.addgold(userinfo.userId, 688, 0, g_GoldType.jhm_huodong, -1, 1);
    						usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), 30, g_ExpType.jhm_huodong, groupinfo.groupid);
                            --sendStr="688���롢30����ֵ";
                            sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_688");
                        elseif retresult==2 then
    					    --B.12000�ݣ�ͭ��VIP 3�����顢888���롢30����ֵ��
    						usermgr.addgold(userinfo.userId, 888, 0, g_GoldType.jhm_huodong, -1, 1);
    						usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), 30, g_ExpType.jhm_huodong, groupinfo.groupid);
    						add_user_vip(userinfo,1,3);
                            --sendStr="ͭ��VIP3�����顢888���롢30����ֵ"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_888");
    					elseif retresult==3 then
    					--1000�ݣ�ͭ��VIP5�����顢1688���롢50����ֵ�������ͷױ������̳���Ʒ��
    						usermgr.addgold(userinfo.userId, 1688, 0, g_GoldType.jhm_huodong, -1, 1);
    						usermgr.addexp(userinfo.userId, usermgr.getlevel(userinfo), 50, g_ExpType.jhm_huodong, groupinfo.groupid);
    						gift_addgiftitem(userinfo,9007,userinfo.userId,userinfo.nick, false);
    						add_user_vip(userinfo,1,5);
                            --sendStr="ͭ��VIP5�����顢1688���롢50����ֵ��\n�����ͷױ������̳���Ʒ";
                            sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_1688");
	   					elseif retresult==4 then
    					--����1000W���룬������10����
    						usermgr.addgold(userinfo.userId, 10000000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="1000W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_1000W");
	   					elseif retresult==5 then
    					--����500W���룬������10����
    						usermgr.addgold(userinfo.userId, 5000000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="500W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_500W");
	   					elseif retresult==6 then
    					--����200W���룬������200����
    						usermgr.addgold(userinfo.userId, 2000000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="200W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_200W");
    					elseif retresult==7 then
    					--����100����룬������200����
    						usermgr.addgold(userinfo.userId, 1000000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="100W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_100W");
    					elseif retresult==8 then
    					--����90����룬������50����
    						usermgr.addgold(userinfo.userId, 900000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="90W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_90W");
    					elseif retresult==9 then
    					--����80����룬������50����
    						usermgr.addgold(userinfo.userId, 800000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="80W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_80W");
    					elseif retresult==10 then
    					--����70����룬������50����
    						usermgr.addgold(userinfo.userId, 700000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="70W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_70W");
    					elseif retresult==11 then
    					--����60����룬������50����
    						usermgr.addgold(userinfo.userId, 600000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="60W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_60W");
    					elseif retresult==12 then
    					--����50����룬������100����
    						usermgr.addgold(userinfo.userId, 500000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="50W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_50W");
    					elseif retresult==13 then
    					--����40����룬������50����
    						usermgr.addgold(userinfo.userId, 400000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="40W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_40W");
    					elseif retresult==14 then
    					--����30����룬������50����
    						usermgr.addgold(userinfo.userId, 300000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="30W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_30W");
    					elseif retresult==15 then
    					--����20����룬������50����
    						usermgr.addgold(userinfo.userId, 200000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="20W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_20W");
    					elseif retresult==16 then
    					--����10����룬������50����
    						usermgr.addgold(userinfo.userId, 100000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="10W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_10W");
    					elseif retresult==17 then
    					--QQ��
    						gift_addgiftitem(userinfo,5022,userinfo.userId,userinfo.nick, false)  
    					    --sendStr="QQ��";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_QQ");
     					elseif retresult==18 then
    					--��ɯ
    						gift_addgiftitem(userinfo,5021,userinfo.userId,userinfo.nick, false)  
    					    --sendStr="��ɯ";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_Car");   
    					elseif retresult==19 then
    					--����
    						gift_addgiftitem(userinfo,5013,userinfo.userId,userinfo.nick, false)  
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_Car1");
    				    elseif retresult==20 then
    					--�׿ǳ�
    						gift_addgiftitem(userinfo,5012,userinfo.userId,userinfo.nick, false)  
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_Car2");		
    					elseif retresult==21 then
    						usermgr.addgold(userinfo.userId, 50000000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="5000W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_5000W");  
    					elseif retresult==22 then
    						usermgr.addgold(userinfo.userId, 20000000, 0, g_GoldType.jhm_huodong, -1, 1);
    					    --sendStr="2000W����";
    					    sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_2000W");
                        elseif retresult==23 then
                            --����http://172.17.0.114/zentao/story-view-793.html
                            --ѩ����C2һ��
                            car_match_db_lib.add_car(userinfo.userId, 5018, 1, 1);
                            --�챦ʯ����
    						gift_addgiftitem(userinfo,5004,userinfo.userId,userinfo.nick, false);
    						gift_addgiftitem(userinfo,5004,userinfo.userId,userinfo.nick, false);
                            --VIP����30������
    						add_user_vip(userinfo,2,30);
                            sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_Car3");
               elseif retresult == 24 then
                --.7600�ݣ�ͭ��VIP 3�����顢1888���롣
    						usermgr.addgold(userinfo.userId, 1888, 0, g_GoldType.jhm_huodong, -1, 1);
    						add_user_vip(userinfo,1,3);
                --sendStr="ͭ��VIP 3�����顢1888����"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult24");
               elseif retresult == 25 then
                 --.2000�ݣ�����VIP 3�����顢3888���롣
    						usermgr.addgold(userinfo.userId, 3888, 0, g_GoldType.jhm_huodong, -1, 1);
    						add_user_vip(userinfo,2,3);
                --sendStr="����VIP 3�����顢3888����"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult25");
               elseif retresult == 26 then
                 --.400�ݣ���VIP 3�����顢5888���롣
    						usermgr.addgold(userinfo.userId, 5888, 0, g_GoldType.jhm_huodong, -1, 1);
    						add_user_vip(userinfo,3,3);
                --sendStr="��VIP 3�����顢5888����"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult26");
    					 elseif retresult == 27 then
    					  --.30w�ݣ�ͭ��VIP 3�����顢6w���롣
    						usermgr.addgold(userinfo.userId, 60000, 0, g_GoldType.jhm_huodong, -1, 1);
    						add_user_vip(userinfo,1,3);
                --sendStr="ͭ��VIP 3�����顢6w���롣"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult27");
              elseif retresult == 28 then
                --.30w�ݣ���VIP 3�����顢4w���롣
    						usermgr.addgold(userinfo.userId, 40000, 0, g_GoldType.jhm_huodong, -1, 1);
    						add_user_vip(userinfo,3,3);
                --sendStr="��VIP 3�����顢4w���롣"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult28");
              elseif retresult == 29 then
                --.30w�ݣ�����VIP 3�����顢7.5w���롣
    						usermgr.addgold(userinfo.userId, 75000, 0, g_GoldType.jhm_huodong, -1, 1);
    						add_user_vip(userinfo,2,3);
                --sendStr="����VIP 3�����顢7.5w���롣"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult29");
              elseif retresult == 30 then
                 --.30w�ݣ�ͭ��VIP 3�����顢7.5w���롣
    						usermgr.addgold(userinfo.userId, 100000, 0, g_GoldType.jhm_huodong, -1, 1);
    						add_user_vip(userinfo,1,3);
                --sendStr="ͭ��VIP 3�����顢7.5w���롣"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult30");
              elseif retresult == 31 then
                --.5w�ݣ���VIP 15�����顢8w���롢�׿ǳ�������
    						usermgr.addgold(userinfo.userId, 80000, 0, g_GoldType.jhm_huodong, -1, 1);
    						car_match_db_lib.add_car(userinfo.userId, 5012, 0)
    						add_user_vip(userinfo,3,15);
                --sendStr="��VIP 15�����顢8w���롢�׿ǳ�������"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult31");
              elseif retresult == 32 then
                --.5w�ݣ���VIP 30�����顢3w���롢����������
    						usermgr.addgold(userinfo.userId, 30000, 0, g_GoldType.jhm_huodong, -1, 1);
    						car_match_db_lib.add_car(userinfo.userId, 5049, 0)
    						add_user_vip(userinfo,3,30);
                --sendStr="��VIP 30�����顢3w���롢����������"
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult32");
    					elseif retresult == 33 then
    					  --30w�� 1W���� + VIP*1��
    					  usermgr.addgold(userinfo.userId, 10000, 0, g_GoldType.jhm_huodong, -1, 1);
    					  add_user_vip(userinfo,1,1);
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult33");
              elseif retresult == 34 then
                --20w�� 1.5W���� + VIP*1��
                usermgr.addgold(userinfo.userId, 15000, 0, g_GoldType.jhm_huodong, -1, 1);
                add_user_vip(userinfo,1,1);
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult34");            
              elseif retresult == 35 then
                --20w�� 1.5W���� + VIP*1��
                usermgr.addgold(userinfo.userId, 15000, 0, g_GoldType.jhm_huodong, -1, 1);
                add_user_vip(userinfo,1,1);
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult35");
              elseif retresult == 36 then
                --20w�� 1.5W���� + VIP*1��
                usermgr.addgold(userinfo.userId, 15000, 0, g_GoldType.jhm_huodong, -1, 1);
                add_user_vip(userinfo,1,1);
                sendStr=tex_lan.get_msg(userinfo, "jhm_chouma_type_retresult36");
    					end
    				else
    					--�洢���̷�����-1,-2-3�ȴ�����

    				    sendResult=retresult
                        if retresult==-1 then
                            --sendStr="���������"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_error");
                        elseif retresult==-2 then
                            --sendStr="�������ѱ�ʹ��"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_error_beenUsed");
                        elseif retresult==-3 then
                            --sendStr="���������"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_error_expired");
                        elseif retresult==-4 then
                            --sendStr="�����ù�ͬ���͵ļ�����򼤻����ѱ�ʹ��"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_error_usedSameType");
                        elseif retresult==-5 then
                            --sendStr="����7��֮���Ѿ�ʹ�ù������͵ļ����롣"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_error_usedSameType_retresult5");
                        elseif retresult==-6 then
                            --sendStr="����3��֮���Ѿ�ʹ�ù������͵ļ����롣"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_error_usedSameType_retresult6");
                        elseif retresult==-7 then
                            --sendStr="����1��֮���Ѿ�ʹ�ù������͵ļ����롣"
                            sendStr=tex_lan.get_msg(userinfo, "jhm_error_usedSameType_retresult7");
                        end
    				end
				   -- TraceError("sendResult"..sendResult)
                   -- TraceError("sendStr"..sendStr)
				
				netlib.send(
					function(buf)				
						buf:writeString("JHMGIFTSN")
						buf:writeByte(sendResult)
						buf:writeString(_U(sendStr))
						
					end,userinfo.ip,userinfo.port)
            else
                netlib.send(
					function(buf)				
						buf:writeString("JHMGIFTSN")
						buf:writeByte("-1")
						--buf:writeString(_U("��������֤����"))
						buf:writeString(_U(tex_lan.get_msg(userinfo, "jhm_error2")))
						
					end,userinfo.ip,userinfo.port)
				--TraceError("�����뷢�ų���")
			end
		end)
    
end

function add_user_vip(userinfo,vip_level,vip_days)
		--��VIP
		local sql = "";
		sql = "insert into user_vip_info values(%d,%d,DATE_ADD(now(),INTERVAL %d DAY),0,0)";
		sql = sql.." ON DUPLICATE KEY UPDATE over_time = case when over_time > now() then DATE_ADD(over_time,INTERVAL %d DAY) else DATE_ADD(now(),INTERVAL %d DAY) end,notifyed = 0,first_logined = 0; ";
		sql = string.format(sql,userinfo.userId,vip_level,vip_days,vip_days,vip_days);
		dblib.execute(sql);
end

--���������SQL��䣬��ֹע�빥��
function no_sql_insert(tmp_str)
    tmp_str = string.gsub(tmp_str, "'", "\"");
    tmp_str = string.gsub(tmp_str,"select","s_elect");
    tmp_str = string.gsub(tmp_str,"insert","i_nsert");
    tmp_str = string.gsub(tmp_str,"update","u_pdate");
    return tmp_str;
end


--��½������
function sn_huodonglib.on_recv_czgift(buf)
    do return end;
	local user_info = userlist[getuserid(buf)]
	if user_info==nil then return end
	--���ݿ�Ĭ��ʱ��Ϊ2000��11��11�գ����������2012��5�����ߣ�������ݿ����ֵС��2012�꣬��һ���Ǹ�Ĭ��ֵ��û���ͳ���
	local sql="select gift_id from user_givegift_info where user_id=%d and give_time<'2012-1-1';update user_givegift_info set give_time=now() where user_id=%d;"
	sql=string.format(sql,user_info.userId,user_info.userId)
	dblib.execute(sql,function(dt)
		if(dt and #dt>0)then
            local gifts = {};
            local count = 0;
            for i=1,#dt do
                local gift_id=dt[i].gift_id
                --��ֵ�ͳ����룬�´���
                if (car_match_lib.CFG_CAR_INFO[gift_id] ~= nil) then
                    car_match_db_lib.add_car(user_info.userId, gift_id, 0)
                else
                    gift_addgiftitem(user_info,gift_id,user_info.userId,user_info.nick, false)                      
                end
                --�ϲ��ٷ����ͻ���
                if(gifts[gift_id] == nil) then
                    gifts[gift_id] = 1;
                    count = count + 1;
                else
                    gifts[gift_id] = gifts[gift_id] + 1;
                end
            end
			netlib.send(
				function(buf)				
				buf:writeString("CZGIFT")
				buf:writeInt(count)
                for k,v in pairs(gifts) do
                    buf:writeInt(k);
                    buf:writeInt(v);
                end
			end,user_info.ip,user_info.port)
		end
	end, user_info.userId)
end

--�����б�
cmdHandler = 
{
	["JHMGIFTSN"] = sn_huodonglib.on_recv_gift_sn, --�յ�������
	--["CZGIFT"] = sn_huodonglib.on_recv_czgift, --�յ�������
}

--���ز���Ļص�
for k, v in pairs(cmdHandler) do 
	cmdHandler_addons[k] = v
end








