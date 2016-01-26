require("Card")
function rank(hand,zhu)
  local function wanneng(card)
  	if card.num==zhu then
  		return card.suit=="H"
  	else
  	  return false
  	end
  end
  local function same(pai)
  	local num = 0
  	local pei = false
  	for key, var in pairs(pai) do
  		if not wanneng(var) then
  			if num==0 then
  				num = realnum(var.num,zhu)
  			else
  			  if num~=realnum(var.num,zhu) then
  			  	return false
  			  end
  			end
  		else
  		  pei = true
  		end
  	end
  	if pei then
  		if num > 17 then
  			return false
  		end
  	end
  	if num==0 then
  		return zhu
  	else
  	  return num
  	end
  end
  local function fl(pai)
  	local suit = ""
  	for key, var in pairs(pai) do
  		if not wanneng(var) then
  			if suit=="" then
  			  suit = var.suit
  			else
  			  if suit~=var.suit then
  			  	return false
  			  end
  			end
  		end
  	end
  	return true
  end
  local function sst(nums)
    local temp
  	table.sort(nums)
  	local init = nums[1]-1
  	local flag = true
  	for key, var in pairs(nums) do
  		if key~=var-init then
  			flag = false
  		end
  	end
  	if flag then
  		return nums[1]
    else
      if nums[1]==1 then
      	nums[1] = 14
      	temp = sst(nums)
      	table.remove(nums,searchkey(nums,14))
      	table.insert(nums,1)
      	return temp
      end
  	end
  end
  local function saner(nums)
  	for key, var in pairs(nums) do
  		var = realnum(var,zhu)
  	end
  	table.sort(nums)
  	if nums[1]==nums[2] then
  		if nums[4]==nums[5] then
  			if nums[3]==nums[2] then
  				return nums[3]
  			else
  			  if nums[3]==nums[4] then
  			    return nums[3]
  			  else
  			    return false
  			  end
  			end
  		end
  	end
  	return false
  end
  local function sandui(nums)
    local temp
  	table.sort(nums)
  	if nums[1]==nums[2] then
  		if nums[3]==nums[2]+1 then
  			if nums[4]==nums[3] then
  				if nums[5]==nums[4]+1 then
  					if nums[6]==nums[5] then
  						return nums[1]
  					end
  				end
  			end
  		else
  		  if nums[1]==1 then
  		    nums[1] = 14
  		    nums[2] = 14
          temp = sandui(nums)
          table.remove(nums,searchkey(nums,14))
          table.insert(nums,1)
          table.remove(nums,searchkey(nums,14))
          table.insert(nums,1)
          return temp
  		  end
  		end
  	end
  end
  local function gang(nums)
  	local temp
  	table.sort(nums)
    if nums[1]==nums[2] then
      if nums[3]==nums[2] then
        if nums[4]==nums[3]+1 then
          if nums[5]==nums[4] then
            if nums[6]==nums[5] then
              return nums[1]
            end
          end
        else
          if nums[1]==1 then
            nums[1] = 14
            nums[2] = 14
            nums[3] = 14
            temp = gang(nums)
            table.remove(nums,searchkey(nums,14))
            table.insert(nums,1)
            table.remove(nums,searchkey(nums,14))
            table.insert(nums,1)
            table.remove(nums,searchkey(nums,14))
            table.insert(nums,1)
            return temp
          end
        end
      end
    end
  end
  local function trans(pai,f)
  	local nums = {}
  	local nn = table.maxn(pai)
  	for key, var in pairs(pai) do
  		if not wanneng(var) then
  			table.insert(nums,var.num)
  		end
  	end
  	if nn - table.maxn(nums)==0 then
  		return f(nums)
  	else
  	  if nn - table.maxn(nums)==1 then
  	  	for var=13, 1, -1 do
  	  		table.insert(nums,var)
  	  		if f(nums) then
  	  		  return f(nums)
  	  		end
  	  		table.remove(nums,searchkey(nums,var))
  	  	end
  	  	return false
  	  else
  	    for vart=13, 1, -1 do
  	    	table.insert(nums,vart)
  	    	for var=13, 1, -1 do
            table.insert(nums,var)
            if f(nums) then
              return f(nums)
            end
            table.remove(nums,searchkey(nums,var))
          end
  	      table.remove(nums,searchkey(nums,vart))
  	    end
  	    return false
  	  end
  	end
  end
	local self = {}
	self.n = table.maxn(hand)
--  单牌dan
--  对子dui
--  三个san
--  4炸zha.4 王炸zha.11
--  三二saner 顺st 5炸zha.5 同花顺zha.5.5
--  三对sandui 钢板gang 6炸zha.6
--  7炸zha.7 8炸zha.8 9炸zha.9 10炸zha.10
  if self.n==0 then
  	return false
  elseif self.n==1 then
    self.num = realnum(hand[1].num,zhu)
    self.type = "dan"
    return self
  elseif self.n==2 then
    self.num = same(hand)
    if self.num then
    	self.type = "dui"
    	return self
    else
      return false
    end
  elseif self.n==3 then
    self.num = same(hand)
    if self.num then
      self.type = "san"
      return self
    else
      return false
    end
  elseif self.n==4 then
    self.num = same(hand)
    if self.num then
      self.type = "zha"
      return self
    else
      if (hand[1].num+hand[2].num+hand[3].num+hand[4].num)==(18+18+19+19) then
        self.type = "zha"
        self.n = 11
        return self
      else
        return false
      end
    end
  elseif self.n==5 then
    self.num = same(hand)
    if self.num then
    	self.type = "zha"
    	return self
    else
      self.num = trans(hand,sst)
      if self.num then
      	if fl(hand) then
      		self.type = "zha"
      		self.n = 5.5
      		return self
      	else
      	  self.type = "st"
      	  return self
      	end
      else
        self.num = trans(hand,saner)
        if self.num then
        	self.type = "saner"
        	self.num = realnum(self.num,zhu)
        	return self
        end
        return false
      end
    end
  elseif self.n==6 then
    self.num = same(hand)
    if self.num then
    	self.type = "zha"
    	return self
    else
      self.num = trans(hand,sandui)
      if self.num then
      	self.type = "sandui"
      	return self
      else
        self.num = trans(hand,gang)
        if self.num then
        	self.type = "gang"
        	return self
        end
      end
    end
    return false
  elseif self.n==7 then
    self.num = same(hand)
    if self.num then
      self.type = "zha"
      return self
    else
      return false
    end
  elseif self.n==8 then
    self.num = same(hand)
    if self.num then
      self.type = "zha"
      return self
    else
      return false
    end
  elseif self.n==9 then
    self.num = same(hand)
    if self.num then
      self.type = "zha"
      return self
    else
      return false
    end
  elseif self.n==10 then
    self.num = same(hand)
    if self.num then
      self.type = "zha"
      return self
    else
      return false
    end
  else
    return false
  end
end
function ranking(daxiao,beiya)
	if beiya.type ~= "zha" then
		if daxiao.type == "zha" then
			return true
		else
		  if daxiao.type == beiya.type then
		  	return daxiao.num > beiya.num
		  else
		    return false
		  end
		end
	else
	  if daxiao.type ~= "zha" then
	  	return false
	  else
	    if daxiao.n == beiya.n then
	    	return daxiao.num > beiya.num
	    else
	      return daxiao.n > beiya.n
	    end
	  end
	end
end