require("Card")
function deal(zhu)
  local decks={Card("RJ",19),Card("RJ",19),Card("BJ",18),Card("BJ",18)}
  local function thirteen(suit)
  	for var=1, 13 do
      table.insert(decks,1,Card(suit,var))
    end
  end
  for var=1, 2 do
  	thirteen("C")
  	thirteen("D")
  	thirteen("H")
  	thirteen("S")
  end
  local four={{},{},{},{}}
  local randNum
  local c,i
  math.randomseed(os.time()) 
  for var=1, 4 do
  	for vart=1, 27 do
  		randNum = math.random(table.maxn(decks))
  		c = table.remove(decks,randNum)
      table.insert(four[var],c)
  	end
  end

  for key, var in pairs(four) do
  	lipai(var,zhu)
  end
--print(table.concat(tbl, "¡¢"))

	return four
end