TraceError("��ʼ�������Ӽ�ǿ��...")

daxiao_lib

--Э������
cmd_daxiao_handler = 
{
	["DVDDATE"] = daxiao_lib.on_recv_check_time, --����ʱ��״̬
    ["DVDEXCG"] = daxiao_lib.on_recv_buy_yinpiao, --���չ�����Ʊ
    ["DVDBET"] = daxiao_lib.on_recv_xiazhu, --������ע
    ["DVDOPEN"] = daxiao_lib.on_recv_open_game, --�������ˣ�����������Ϣ
    ["DVDTIME"] = daxiao_lib.on_recv_query_time, --�������ˣ�ʣ�࿪��ʱ��
    ["DVDGMNUM"] = daxiao_lib.on_recv_gm_num, --�������ˣ�ʣ�࿪��ʱ��
}

--���ز���Ļص�
for k, v in pairs(cmd_daxiao_handler) do 
	cmdHandler_addons[k] = v
end

eventmgr:addEventListener("h2_on_user_login", daxiao_lib.on_after_user_login);
eventmgr:addEventListener("timer_second", daxiao_lib.timer);
eventmgr:addEventListener("on_server_start", daxiao_lib.restart_server);
eventmgr:addEventListener("gm_cmd", daxiao_lib.gm_cmd)
 