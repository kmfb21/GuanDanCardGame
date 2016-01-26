require("rank")
require("Card")
function ai(fourpai,zhuozi,ren,zhu)
  local function zhaoputong(pai,rk)
  	local n = rk.n
  	local maxn = table.maxn(pai)
  	local var,rkvar
  	for var1=maxn, n, -1 do
  		if n == 1 then
        var = {pai[var1]}
        rkvar = rank(var,zhu)
        if rkvar.num > rk.num then
          return var
        end
  		else
        for var2=var1-1, n-1, -1 do
          if n == 2 then
            var = {pai[var1],pai[var2]}
            rkvar = rank(var,zhu)
            if rkvar then
              if ranking(rkvar,rk) then
                return var
              end
            end
          else
            for var3=var2-1, n-2, -1 do
            	if n == 3 then
            		var = {pai[var1],pai[var2],pai[var3]}
            		rkvar = rank(var,zhu)
                if rkvar then
                	if ranking(rkvar,rk) then
                		return var
                	end
                end
            	else
            	  for var4=var3-1, n-3, -1 do
            	  	if n == 4 then
            	      var = {pai[var1],pai[var2],pai[var3],pai[var4]}
                    rkvar = rank(var,zhu)
                    if rkvar then
                      if ranking(rkvar,rk) then
                        return var
                      end
                    end
            	  	else
            	  	  for var5=var4-1, n-4, -1 do
            	  	  	if n == 5 then
            	  	      var = {pai[var1],pai[var2],pai[var3],pai[var4],pai[var5]}
                        rkvar = rank(var,zhu)
                        if rkvar then
                          if ranking(rkvar,rk) then
                            return var
                          end
                        end
            	  	  	else
            	  	  	  for var6=maxn, 6, -1 do
                            var = {pai[var6],pai[var6-1],pai[var6-2],pai[var6-3],pai[var6-4],pai[var6-5]}
                            rkvar = rank(var,zhu)
                            if rkvar then
                              if ranking(rkvar,rk) then
                                return var
                              end
                            end
            	  	  	  end
            	  	  	  return false
--            	  	  	  for var6=var5-1, n-5, -1 do            	  	  	  
--            	  	  	  	if n == 6 then
--            	  	  	  	  var = {pai[var1],pai[var2],pai[var3],pai[var4],pai[var5],pai[var6]}
--                            rkvar = rank(var,zhu)
--                            if rkvar then
--                              if ranking(rkvar,rk) then
--                                return var
--                              end
--                            end
--                          else
--                            return false
--            	  	  	  	end
--            	  	  	  end
            	  	  	end
            	  	  end
            	  	end
            	  end
            	end
            end
          end
        end
  		end
  	end
  	return false
  end
  local function fd(pai,rk)
--  	for var=table.maxn(pai), 1, -1 do
--  		if rk then
--  			if realnum(pai[var].num,zhu)>rk.num then
--  				return {pai[var]}
--  			end
--  		else
--  		  return {pai[var]}
--  		end
--  	end
--  	return false
    local base = {{},{},{},{},{},{},{},{}}
    base[1].type, base[1].n = "gang", 6
    base[2].type, base[2].n = "sandui", 6
    base[3].type, base[3].n = "st", 5
    base[4].type, base[4].n = "saner", 5
    base[5].type, base[5].n = "san", 3
    base[6].type, base[6].n = "dui", 2
    base[7].type, base[7].n = "dan", 1
    base[8].type, base[8].n = "zha", 4
    if rk then
    	return reverse(zhaoputong(pai,rk))
    else
      for key, var in pairs(base) do
      	var.num = 0
      	if zhaoputong(pai,var) then
      		return reverse(zhaoputong(pai,var))
      	end
      end
    end
  end
  if emptytable(zhuozi[shangjia(ren)]) then
    if emptytable(zhuozi[shangjia(shangjia(ren))]) then
      if emptytable(zhuozi[shangjia(shangjia(shangjia(ren)))]) then
        --随便出
        return fd(fourpai[ren],false)
      else
        return fd(fourpai[ren],rank(zhuozi[shangjia(shangjia(shangjia(ren)))],zhu))
      end
    else
      --考虑一下压对家
      return fd(fourpai[ren],rank(zhuozi[shangjia(shangjia(ren))],zhu))
    end
  else
    return fd(fourpai[ren],rank(zhuozi[shangjia(ren)],zhu))
  end
end
