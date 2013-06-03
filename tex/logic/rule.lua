--getjiesuandata(roundsitedatalist)	��ȡ��������
--getroundpool(roundsitedatalist)	��ȡ��ǰ�ֵĲʳ���Ϣ
--gettypeex(pokelist)			��ȡ���ؼ�7ѡ5���
--gettype(pokelist)			��ȡ���ͣ�����Ȩֵ�����ű������ݣ�7ѡ5���

if false then
	function tostringex(v, len)
		if len == nil then len = 0 end
		local pre = string.rep('\t', len)
		local ret = ""
		if type(v) == "table" then
			if len > 5 then return "\t{ ... }" end
			local t = ""
			local keys = {}
			for k, v1 in pairs(v) do
				table.insert(keys, k)
			end
			--table.sort(keys)
			for k, v1 in pairs(keys) do
				k = v1
				v1 = v[k]
				t = t .. "\n\t" .. pre .. tostring(k) .. ":"
				t = t .. tostringex(v1, len + 1)
			end
			if t == "" then
				ret = ret .. pre .. "{ }\t(" .. tostring(v) .. ")"
			else
				if len > 0 then
					ret = ret .. "\t(" .. tostring(v) .. ")\n"
				end
				ret = ret .. pre .. "{" .. t .. "\n" .. pre .. "}"
			end
		else
			ret = ret .. pre .. tostring(v) .. "\t(" .. type(v) .. ")"
		end
		return ret
	end
	
	table.mergearray = function(...)
		local ret = {}
		for k, v in pairs({...}) do
			for k1, v1 in pairs(v) do
				table.insert(ret, v1)
			end
		end
		return ret
	end
	
	function run()
		--test({4,17,3,16,5,18,19})
		--test({4,10,11,16,5,12,1})
		test({4,1,42,11,13,10,12})
		test({14,23,24,25,26,10,12})
	end
	
	function test(pokelist)
		print("pokechars:" .. getpokestr(pokelist))
		local result, sublist = gettypeex(pokelist)
		print("result:" .. tostring(result))
		print("subchars:" .. getpokestr(sublist))
		print("")
	end

	tex = {cfg = {}}
	--�Ƶ��ַ���ʾ
	tex.pokechar = {
	[1]   = 'A', [2] = '2', [3]   = '3',[4]  = '4', [5]   = '5',[6]   = '6',[7]   = '7',[8]   = '8',[9]   = '9',[10] = 'X',[11] = 'J',[12] = 'Q',[13] = 'K',
	[14]  = 'A', [15] = '2',[16]  = '3',[17]  = '4',[18]  = '5',[19]  = '6',[20]  = '7',[21]  = '8',[22]  = '9',[23] = 'X',[24] = 'J',[25] = 'Q',[26] = 'K',
	[27]  = 'A', [28] = '2',[29]  = '3',[30]  = '4',[31]  = '5',[32]  = '6',[33]  = '7',[34]  = '8',[35]  = '9',[36] = 'X',[37] = 'J',[38] = 'Q',[39] = 'K',
	[40]  = 'A', [41] = '2',[42]  = '3',[43]  = '4',[44]  = '5',[45]  = '6',[46]  = '7',[47]  = '8',[48]  = '9',[49] = 'X',[50] = 'J',[51] = 'Q',[52] = 'K',
	}
	--�Ƶ����ֱ�ʾ
	tex.pokenum = {
	[1]   = 14, [2] = 2, [3]   = 3,[4]   = 4, [5]   = 5,[6]   = 6,[7]   = 7,[8]   = 8,[9]   = 9,[10] = 10,[11] = 11,[12] = 12,[13] = 13,
	[14]  = 14, [15] = 2,[16]  = 3,[17]  = 4, [18]  = 5,[19]  = 6,[20]  = 7,[21]  = 8,[22]  = 9,[23] = 10,[24] = 11,[25] = 12,[26] = 13,
	[27]  = 14, [28] = 2,[29]  = 3,[30]  = 4, [31]  = 5,[32]  = 6,[33]  = 7,[34]  = 8,[35]  = 9,[36] = 10,[37] = 11,[38] = 12,[39] = 13,
	[40]  = 14, [41] = 2,[42]  = 3,[43]  = 4, [44]  = 5,[45]  = 6,[46]  = 7,[47]  = 8,[48]  = 9,[49] = 10,[50] = 11,[51] = 12,[52] = 13,
	}
	--�ƵĻ�ɫ��ʾ
	tex.pokecolor = {
	[1]   = 1, [2] = 1, [3]   = 1,[4]   = 1, [5]   = 1,[6]   = 1,[7]   = 1,[8]   = 1,[9]   = 1,[10] = 1,[11] = 1,[12] = 1,[13] = 1,
	[14]  = 2, [15] = 2,[16]  = 2,[17]  = 2, [18]  = 2,[19]  = 2,[20]  = 2,[21]  = 2,[22]  = 2,[23] = 2,[24] = 2,[25] = 2,[26] = 2,
	[27]  = 3, [28] = 3,[29]  = 3,[30]  = 3, [31]  = 3,[32]  = 3,[33]  = 3,[34]  = 3,[35]  = 3,[36] = 3,[37] = 3,[38] = 3,[39] = 3,
	[40]  = 4, [41] = 4,[42]  = 4,[43]  = 4, [44]  = 4,[45]  = 4,[46]  = 4,[47]  = 4,[48]  = 4,[49] = 4,[50] = 4,[51] = 4,[52] = 4,
	}
	
	--�������
	tex.cfg.paixin = {
		tonghuashun = 9, --ͬ��˳
		bomb 		= 8, --ը��
		sandaier 	= 7, --������
		tonghua 	= 6, --ͬ��
		shun 		= 5, --��˳
		sanzhang 	= 4, --����
		liangdui 	= 3, --����
		duizi 		= 2, --һ��
		danzhang 	= 1, --����
	}
	
	function getpokestr(pokelist)
		local s = ""
		for k, v in pairs(pokelist) do
			s = s .. tex.pokechar[v]
		end
		return s
	end
end


local function getpokestr(pokelist)
	local s = ""
	local s1 = ""
	for k, v in pairs(pokelist) do
		s = s .. tex.pokechar[v]
		s1 = s1 .. v .. ","
	end
	return s .. "(" .. s1 .. ")"
end

--TraceError({gettypeex({33,29,50,20,13,30,32})})
--��ȡ����, ����ֵ�����أ�7ѡ5���
function gettypeex(pokelist)
	--TraceError("gettypeex" .. getpokestr(pokelist))
	local paixing, num, plist, sublist = gettype(pokelist)
	local weight1 = paixing * 10 ^ 10 + num * 10 ^ 6
	local weight2 = 0
	table.sort(sublist, function(a,b) return tex.pokenum[a] < tex.pokenum[b] end) --��С����
	--print(tostringex({paixing, num, plist, sublist}))
	if #sublist > 5 then error(tostringex(sublist) .. " error")  end
	for i = 1, #sublist do
		weight2 = weight2 + tex.pokenum[sublist[i]] * 14 ^ (i - 1)
	end
	if weight2 > 10 ^ 6 then error(weight2 .. " error")  end
	local pokes5 = {}
	for k, v in pairs(sublist) do
		table.insert(pokes5, v)
	end
	return weight1 + weight2, sublist
end

--��ȡ����, ����ֵ�����ͣ�����Ȩֵ�����ű������ݣ�7ѡ5���
function gettype(pokelist)
    assert(pokelist, "pokelist is nil")
	assert(#pokelist >= 2 and #pokelist <= 7 , "#pokelist=" .. #pokelist .. ":" .. tostringex(pokelist))
	local list = {}
	for i = 1, #pokelist do table.insert(list, pokelist[i]) end
	table.sort(list, function(a,b) return tex.pokenum[a] < tex.pokenum[b] end) --��С����

	--��ֵ�ɷ�
	local comtb = {}
	for i = 1, #list do
		local char = tex.pokechar[list[i]]
		if not comtb[char] then
			comtb[char] = {list[i]}
		else
			table.insert(comtb[char], list[i])
		end
	end
	local comarr = {}
	for k, v in pairs(comtb) do
		table.insert(comarr, v)
	end
	table.sort(comarr, function(a,b) if #a == #b then return tex.pokenum[a[1]] < tex.pokenum[b[1]] else return #a < #b end end) --��С����
	--print("comarr:" .. tostringex(comarr, 1))

	local tonghualist = {}		--ͬ��
	local sanzhanglist = {}		--����

	--ͬ��˳���ʼ�ͬ��˳
	tonghualist = gettonghua(list)
	local plist, thshun_weight = getshun(tonghualist)
	if #plist == 5 then
		return tex.cfg.paixin.tonghuashun,thshun_weight,plist,plist	--ͬ��˳���ʼ�ͬ��˳
	end

	--ը��
	if #comarr[#comarr] == 4 then
		local bomblist = comarr[#comarr]
		local bombnum = tex.pokenum[bomblist[1]]
		for i = #list, 1, -1 do
			if tex.pokenum[list[i]] ~= bombnum then
				return tex.cfg.paixin.bomb,bombnum,{list[i]},table.mergearray(bomblist, {list[i]})   --ը��
			end
		end
		return tex.cfg.paixin.bomb,bombnum,{},bomblist   --ը��
	end

	--������
	if #comarr[#comarr] == 3 then
		local sanlist = comarr[#comarr]
		if #pokelist >= 5 then
			local erlist = {}
			if #comarr[#comarr - 1] == 3 then
				erlist = {comarr[#comarr - 1][1], comarr[#comarr - 1][2]}
				return tex.cfg.paixin.sandaier,tex.pokenum[sanlist[1]],{erlist[1]}, table.mergearray(sanlist, erlist)  --����������������������
			elseif #comarr[#comarr - 1] == 2 then
				erlist = comarr[#comarr - 1]
				return tex.cfg.paixin.sandaier,tex.pokenum[sanlist[1]],{erlist[1]}, table.mergearray(sanlist,erlist)   --������
			end
		end
		sanzhanglist = sanlist
	end

	--ͬ��
	if #tonghualist >= 5 then
		local rettonghualst = {}
		local tonghuatbl = {}
		for k,v in pairs(tonghualist) do tonghuatbl[v] = 1 end
		for i = #list, 1, -1 do
			if tonghuatbl[list[i]] then
				table.insert(rettonghualst, list[i])
				if #rettonghualst == 5 then
					return tex.cfg.paixin.tonghua,0,rettonghualst,rettonghualst		--ͬ��
				end
			end
		end
	end

	--˳��
	local shunlist, shun_weight = getshun(list)
	if #shunlist == 5 then
		return tex.cfg.paixin.shun,shun_weight,shunlist,shunlist					--˳��
	end

	--����
	if #sanzhanglist == 3 then
		local dan = {}
		local sanzhangnum = tex.pokenum[sanzhanglist[1]]
		for i = #list, 1, -1 do
			if tex.pokenum[list[i]] ~= sanzhangnum then
				table.insert(dan, list[i])
				if #dan == 2 then
					return tex.cfg.paixin.sanzhang,sanzhangnum,dan,table.mergearray(sanzhanglist, dan) 		--����
				end
			end
		end
		return tex.cfg.paixin.sanzhang,sanzhangnum,dan,table.mergearray(sanzhanglist, dan) 		--����
	end

	--����
	if #comarr >=2 and #comarr[#comarr] == 2 and #comarr[#comarr - 1] == 2 then
		local liangduinum1 = tex.pokenum[comarr[#comarr][1]]
		local liangduinum2 = tex.pokenum[comarr[#comarr - 1][1]]
		local liangduinum = liangduinum1 * 100 + liangduinum2
		local liangduilist = table.mergearray(comarr[#comarr], comarr[#comarr - 1])
		for i = #list, 1, -1 do
			if tex.pokenum[list[i]] ~= liangduinum1 and tex.pokenum[list[i]] ~= liangduinum2 then
				local lastpoke = list[i]
				--print("liangduilist:" .. tostringex({1,2,3, unpack(liangduilist)}))
				return tex.cfg.paixin.liangdui,liangduinum,{lastpoke}, table.mergearray(liangduilist, {lastpoke})			--����
			end
		end
		return tex.cfg.paixin.liangdui,liangduinum,{}, liangduilist			--����
	end

	--����
	if #comarr[#comarr] == 2 then
		local danlist = {}
		local duizilist = comarr[#comarr]
		local duizinum = tex.pokenum[duizilist[1]]
		for i = #list, 1, -1 do
			if tex.pokenum[list[i]] ~= duizinum then
				table.insert(danlist, list[i])
				if #danlist == 3 then
					return tex.cfg.paixin.duizi,duizinum,danlist,table.mergearray(duizilist,danlist)		--����
				end
			end
		end
		return tex.cfg.paixin.duizi,duizinum,danlist,table.mergearray(duizilist,danlist)		--����
	end
	table.sort(list, function(a,b) return tex.pokenum[a] > tex.pokenum[b] end) --�Ӵ�С
	local danlist = {}
	for i = 1, #list do
		table.insert(danlist, list[i])
		if i >= 5 then break end
	end
	return tex.cfg.paixin.danzhang,0,list,danlist				--����
end

--˳��
function getshun(pokelist)
	local list = {}
	for i = 1, #pokelist do table.insert(list, pokelist[i]) end
	table.sort(list, function(a,b) return tex.pokenum[a] > tex.pokenum[b] end) --�Ӵ�С
	local ret = {list[1]}
	for i = 1, #list - 1 do
        if tex.pokenum[list[i]] - tex.pokenum[list[i + 1]] == 1 then
			table.insert(ret, list[i + 1])
            if #ret == 5 then return ret, 1 end
        else
			if tex.pokenum[ret[#ret]] ~= tex.pokenum[list[i + 1]] then
				ret = {list[i + 1]}
			end
		end
    end
    --���������A2345Ҳ��˳��
    if #ret == 4 and tex.pokenum[ret[1]] == 5 and tex.pokenum[list[1]] == 14 then
        --TraceError("A2345Ҳ��˳��")
        return table.mergearray(ret, {list[1]}), 0
    end
	return {}, 1
end

--ͬ��
function gettonghua(pokelist)
	local list = {}
	for i = 1, #pokelist do table.insert(list, pokelist[i]) end
	table.sort(list, function(a,b) return tex.pokenum[a] > tex.pokenum[b] end) --�Ӵ�С
	local retarr = {{},{},{},{}}
	for i = 1, #list do
		local pklist = retarr[tex.pokecolor[list[i]]]
		table.insert(pklist, list[i])
	end
	for i = 1, 4 do
		local pklist = retarr[i]
		if #pklist >= 5 then return pklist end
	end
	return {}
end


--��ȡ�ʳ���Ϣ�Լ�ÿ����λ��Ӧ�Ĳʳ��б�
--[[
	isjiesuan=1/0
]]
local function getpoolandsitepool(roundsitedatalist, isjiesuan)
	local list = {}
	--���¡һ�ݴ���Ĳ���
	for k, v in pairs(roundsitedatalist) do
		list[k] = {}
		for k1, v1 in pairs(v) do
			list[k][k1] = v1
		end
	end

	local pools = {}		--�ʳ��б����߳�
	local poolindex = 1		--�ʳ��α� 1-x
	local sitepoolindex = {}				--��λ�Ŷ�Ӧ�Ĳʳؼ���{1=2, 3=1}
	local sitepoolindexlist = {}			--��λ�Ŷ�Ӧ�Ĳʳ��б�{1={1,2}, 3={1}}
	table.sort(list,
		function(a, b)
			if a.betgold ~= b.betgold then
				return a.betgold < b.betgold
			else
				return a.isgiveup > b.isgiveup
			end
		end
	)		--gold��С����;gold��ͬ�ģ���δ������

	--����߳�
	while #list > 0 do
		--print("list:" .. tostringex(list))
		local item = list[1]
		local removetb = {}
		if item.isgiveup == 1 then		--��С��Ϊ�����ģ���Ǯ���뵱ǰ�أ����Ƴ�����
			removetb[item] = 1
			pools[poolindex] = (pools[poolindex] or 0) + item.betgold
		else							--��С��Ϊȫ�µģ�������߳�
			local decgold = item.betgold
			for k, v in pairs(list) do
				pools[poolindex] = (pools[poolindex] or 0) + decgold
				v.betgold = v.betgold - decgold
				if v.betgold == 0 then
					removetb[v] = 1
					sitepoolindex[v.siteno] = poolindex
				end
			end
			poolindex = poolindex + 1
		end

		--ɾ��Ԫ��
		local tmplist = {}
		for k, v in pairs(list) do
			if not removetb[v] then table.insert(tmplist, v) end
		end
		list = tmplist
	end

	--ת��Ϊ��λ�Ŷ�Ӧ�Ĳʳ��б�
	for k, v in pairs(sitepoolindex) do
		sitepoolindexlist[k] = {}
		for i = 1, v do
			table.insert(sitepoolindexlist[k], i)
		end
	end

	--sitepoolindexlist ÿ����Ӯ�õĲʳ��б�
	--TraceError("pools:" .. tostringex(pools))
	--TraceError("sitepoolindexlist:" .. tostringex(sitepoolindexlist))
	return pools, sitepoolindexlist
end


--�����߼�
--[[
����
	local roundsitedatalist =
	{
		{siteno=1, betgold=30, isgiveup=0, weight = 1},
		{siteno=2, betgold=5,  isgiveup=1, weight = 1},
		{siteno=3, betgold=25, isgiveup=0, weight = 1},
		{siteno=4, betgold=3,  isgiveup=0, weight = 1},
	}
	siteno:��λ��
	betgold: ���˶���Ǯ
	isgiveup:�Ƿ���;������
	weight:�ƵĴ�С���ݣ����ִ�������Ҳ�������

����ֵ
	pools:{
		1:	12	(number)
		2:	46	(number)
		3:	5	(number)
	}
	poolsΪ���飬 1Ϊ���ص�Ǯ��2Ϊ�߳�1��Ǯ������

	sitewininfo:{
	1:	(table: 003CE558)
	{
		wingold:		32	(number)
		poollist:	(table: 003CA298)
		{
			1:			1	(number)
			2:			2	(number)
			3:			3	(number)
		}
	}
	3:	(table: 003CA308)
	{
		wingold:		27	(number)
		poollist:	(table: 003CA378)
		{
			1:			1	(number)
			2:			2	(number)
		}
	}
	4:	(table: 003CA3F0)
	{
		wingold:		4	(number)
		poollist:	(table: 003CA460)
		{
			1:			1	(number)
		}
	}
	keyΪ��λ��
	value��
		wingoldΪӮ��Ǯ��
		poollistΪ���飬Ԫ��Ϊ�ʳ�����
]]
function getjiesuandata(roundsitedatalist)
	local pools, sitepoolindexlist = getpoolandsitepool(roundsitedatalist, 1)

	--TraceError("pools:" .. tostringex(pools))
	--TraceError("sitepoolindexlist:" .. tostringex(sitepoolindexlist))

	local list = {}

	--ɸ��������ѡ��
	for k, v in pairs(roundsitedatalist) do
		if v.isgiveup == 0 then
			local item = {}
			for k1, v1 in pairs(v) do
				item[k1] = v1
			end
			table.insert(list, item)
		end
	end

	--���ֻ��һ����û��������ô��Ӯ�����е�Ǯ
	if #list == 1 then
		local totalgold = 0
		for k, v in pairs(roundsitedatalist) do
			totalgold = totalgold + v.betgold
		end
		local retarr = {}
		retarr[list[1].siteno] = 
		{
			wingold = totalgold, 
			poollist = {{poolindex = 1, poolgold = totalgold}},
		}
		return {totalgold}, retarr
	end

	local sitewininfo = {}		--��ʤ��Ϣ��  �{{ siteno={wingold=xxx, poollist={...}} , ... }

	--�ų�����(���������)
	table.sort(list,
		function(a, b)
			return a.weight > b.weight
		end
	)		--weight�Ӵ�С
	local winusers = {}
	local i = 1
	while i <= #list do
		local users = {list[i].siteno}
		local weight = list[i].weight
		--�ҳ�����
		local startindex = i + 1
		for j = startindex, #list do
			if list[j].weight == weight then
				table.insert(users, list[j].siteno)
				i = i + 1
			end
		end
		table.insert(winusers, users)
		i = i + 1
	end

	--TraceError("winusers:" .. tostringex(winusers))

	--�����������㽱��
	for _, users in pairs(winusers) do
		local userpools = {}	--ͳ�������û����ԹϷֵĳ� {[2] = 3, [1] = 1,} key:��id,value:�Ϸݷ���
		local sites = {}
		for _, siteno in pairs(users) do
			sites[siteno] = 1
			for _, userpoolindex in pairs(sitepoolindexlist[siteno]) do
				userpools[userpoolindex] = (userpools[userpoolindex] or 0) + 1
			end
		end
		--�����û���û�÷���
		for siteno, userpoollist in pairs(sitepoolindexlist) do
			if not sites[siteno] then
				local plist = {}
				for _, pollindex in pairs(userpoollist) do
					if not userpools[pollindex] then table.insert(plist, pollindex) end
				end
				while #userpoollist > 0 do table.remove(userpoollist, 1) end
				for k, v in pairs(plist) do table.insert(userpoollist, v) end
			end
		end
		--��ʼ��Ǯ��
		for _, siteno in pairs(users) do
			for _, userpoolindex in pairs(sitepoolindexlist[siteno]) do
				local fenshu = userpools[userpoolindex]  --����
				sitewininfo[siteno] = sitewininfo[siteno] or {wingold=0, poollist={}}
				local poolgold = math.floor(pools[userpoolindex] / fenshu + 0.5)
				sitewininfo[siteno].wingold = sitewininfo[siteno].wingold + poolgold
				table.insert(sitewininfo[siteno].poollist, {poolindex=userpoolindex, poolgold=poolgold})
			end
		end
	end

	--�쳣��⣬��Ӧ��ʱ����Щ���Ӯ��0��ҵ�����
	local retarr = {}
	for k,v in pairs(sitewininfo) do
		if(v.wingold > 0) then
			retarr[k] = v
		else
			TraceError("��λ��["..k.."]�����Ӯ��["..v.wingold.."]����")
			TraceError(roundsitedatalist)
		end
	end
	--TraceError("sitewininfo:" .. tostringex(sitewininfo))
	return pools, retarr
end





--ÿ���һ����ע���ʱ�򣬻�ȡ��ǰ�γɵĲʳ�
--[[
	���������
		local roundsitedatalist =
		{
			{siteno=1, betgold=30, isgiveup=0, isallin = 0},
			{siteno=2, betgold=5,  isgiveup=1, isallin = 0},
			{siteno=3, betgold=25, isgiveup=0, isallin = 0},
			{siteno=4, betgold=3,  isgiveup=0, isallin = 1},
		}
	����ֵ��
		���飬�ʳ���Ϣ
		retpools:{
			1:	12	(number)
		}
]]
function getroundpool(roundsitedatalist)
	local pools = {} --�ʳ���Ϣ
	local sitepoolindexlist = {} --ÿ����λӮ�òʳ��б�
	pools, sitepoolindexlist = getpoolandsitepool(roundsitedatalist, 0)
	return pools
end


TraceError("tex logic loaded")
