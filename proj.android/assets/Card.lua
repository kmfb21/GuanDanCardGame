function Card(suit,num)
--创建精灵
	local self=CCSprite:create("pockers/"..suit..num..".jpg")
--点数和花色
	self.num = num
	self.suit = suit
	self.choose = false
--牌形状大小和锚点
	self:setAnchorPoint(ccp(0,0))
	self:setScale(0.7)
	return self
end
function realnum(num,zhu)
--J是11 Q是12 K是13 A是14 主牌16 小鬼18 大鬼19
  if num==1 then
    return 14
  else
   if num==zhu then
     return 16
   else
     return num
   end
  end
end
function lipai(pai,zhu)
  local function sortfunc(a,b)
    return realnum(a.num,zhu)>realnum(b.num,zhu)
  end
  table.sort(pai,sortfunc)
end
function searchkey(tb,va)
  for key, var in pairs(tb) do
    if var==va then
      return key
    end
  end
  return false
end
function shangjia(ren)
  if ren==1 then
    return 4
  else
    return ren-1
  end
end
function emptytable(tb)
  return next(tb)==nil
end
function changedy(card)
  if card.choose then
    card.choose = false
    return 80
  else
    card.choose = true
    return 80+20
  end
end
function getxuan(pai)
  local result = {}
  for key, var in pairs(pai) do
    if var.choose then
      table.insert(result,var)
    end
  end
  return result
end
function bijiao(daxiao,ren,zhuozi,zhu)
  if emptytable(zhuozi[shangjia(ren)]) then
    if emptytable(zhuozi[shangjia(shangjia(ren))]) then
      if emptytable(zhuozi[shangjia(shangjia(shangjia(ren)))]) then
        return true
      else
        return ranking(daxiao,rank(zhuozi[shangjia(shangjia(shangjia(ren)))],zhu))
      end
    else
      return ranking(daxiao,rank(zhuozi[shangjia(shangjia(ren))],zhu))
    end
  else
    return ranking(daxiao,rank(zhuozi[shangjia(ren)],zhu))
  end
end
function reverse(ls)
  local n
  local temp = {}
	if ls then
		n = table.maxn(ls)
		for var=1, n do
			table.insert(temp,ls[n+1-var])
		end
		return temp
	else
	  return false
	end
end