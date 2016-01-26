require("Card")
require("deal")
require("rank")
require("ai")
function Main()
  local self = CCScene:create()
  local layer
  local shoudian = {}
  local zhu = 7
  local fourpai = deal(zhu)
  local wodepai = {}
  local zhuozi = {{},{},{},{}}
  local zhuozip = {ccp(13*25,2.5*80),ccp(23*25,3.5*80),ccp(13*25,4.5*80),ccp(3*25,3.5*80)}
  local zhuozip2 = {ccp(19*25,0.5*80),ccp(30*25,3.5*80),ccp(19*25,4.5*80),ccp(0*25,3.5*80)}
  local gbutton = CCSprite:create("view/go.jpg")
  local pbutton = CCSprite:create("view/pass.jpg")
  local psign = {}
  local remainsign = {}
  local win = {}
  local touyou = CCSprite:create("view/touyou.png")
  local moyou = CCSprite:create("view/moyou.png")
  local moyou2 = CCSprite:create("view/moyou.png")
  
	local function zhangshou()
  	for i=1, 27 do
			table.insert(shoudian,ccp(i*25,1*80))
		end		
	end

	local function mopai(temp)
	  local n = table.maxn(temp)
	  if n==27 then
      wodepai = reverse(temp)
	  else
	    wodepai = temp
	  end
    for var=1, n do
      if n==27 then
        layer:addChild(wodepai[28-var],var-1)
      end
      wodepai[n+1-var]:setPosition(shoudian[var])
    end
	end
	
	local function fangpai(pai,ren)
	  local function juzhong(i,max,mid)
	    local xx = mid.x - ((max - (max % 2)) / 2 - i) * 20
	    local yy = mid.y
	  	return ccp(xx,yy)
	  end
	  if not emptytable(zhuozi[ren]) then
      for key, var in pairs(zhuozi[ren]) do
      	layer:removeChild(var,true)
      end
    else
      psign[ren]:setVisible(false)
	  end
	  zhuozi[ren] = pai
	  if emptytable(pai) then
	  	psign[ren]:setVisible(true)
	  else
      if ren==1 then
        for key, var in pairs(pai) do
          pai[table.maxn(pai)+1-key]:setPosition(juzhong(key,table.maxn(pai),zhuozip[ren]))
        end
      else
        for key, var in pairs(pai) do
          var:setVisible(true)
        	var:setPosition(juzhong(key,table.maxn(pai),zhuozip[ren]))
        end
      end
    end
	end
	
	local function you(ren)
    if emptytable(fourpai[ren]) then
      table.insert(win,ren)
      local n = table.maxn(win)
      if n == 1 then
        --头游
        touyou:setPosition(zhuozip2[ren])
        touyou:setVisible(true)
      else
        if n == 2 then
          if math.abs(win[1]-win[2]) == 2 then
            moyou:setPosition(zhuozip2[shangjia(win[1])])
            moyou:setVisible(true)
            moyou2:setPosition(zhuozip2[shangjia(win[2])])
            moyou2:setVisible(true)
            --下局双贡
            
          end
        else
          for var=1, 4 do
            if not searchkey(win,var) then
              moyou:setPosition(zhuozip2[var])
              moyou:setVisible(true)
              --下局贡牌
              
            end
          end
        end
      end
    else
      return false
    end
  end
  
  local function reng(pai,ren)
    --检测牌型和大小
    local daxiao = rank(pai,zhu)
    local temp,s
    if daxiao then
      --检测有没有上家大
      if bijiao(daxiao,ren,zhuozi,zhu) then
        --手牌中移除
    	  if ren==1 then
    		  for key, var in pairs(pai) do
      			table.remove(wodepai,searchkey(wodepai,var))
            if table.maxn(wodepai) % 2 == 0 then
              table.remove(shoudian)
            else
              table.remove(shoudian,1)
            end
          end
          --重排手牌
          mopai(wodepai)
          fourpai[1] = wodepai
      	else
      	  -- bug?
          for key, var in pairs(pai) do
            table.remove(fourpai[ren],searchkey(fourpai[ren],var))
          end
      	end
      	--桌上加入
        fangpai(pai,ren)
        remainsign[ren]:setString(table.maxn(fourpai[ren]))
        if ren == 1 then
          --判断胜负
          you(1)
          if searchkey(win,1) then
--            while table.maxn(win)<3 do
--              s = tonumber(os.date("%s", os.time()));
--              if tonumber(os.date("%s", os.time())) == s + 1 then
            	  --延时下三家出牌
                for var=2, 4 do
                  temp = ai(fourpai,zhuozi,var,zhu)
                  if temp then
                    reng(temp,var)
                    remainsign[var]:setString(table.maxn(fourpai[var]))
                    you(var)
                  else
                    fangpai({},var)
                  end
                end
--              end
--            end
          else
            for var=2, 4 do
                  temp = ai(fourpai,zhuozi,var,zhu)
                  if temp then
                    reng(temp,var)
                    remainsign[var]:setString(table.maxn(fourpai[var]))
                    you(var)
                  else
                    fangpai({},var)
                  end
                end
          end
        end
      end
    end
  end
    
	local function onTouch(type,x,y)
    local p=ccp(x,y)
    local xuanzhong = {}
    local temp
    if gbutton:boundingBox():containsPoint(p) then
      --提取选中的牌
      xuanzhong = getxuan(wodepai)
    	reng(xuanzhong,1)
    	--如果你出完游戏还没
    	
    end
    if pbutton:boundingBox():containsPoint(p) then
      for key, var in pairs(wodepai) do
      	if var.choose then
      		var:setPosition(ccp(var:getPosition(x),changedy(var)))
      	end
      end
    	if (not bijiao(rank({Card("S",2)},3),1,zhuozi,zhu)) or (searchkey(win,1))then
    		--不要
    		fangpai({},1)
    		psign[1]:setVisible(true)
        --延时下三家出牌
        for var=2, 4 do
          temp = ai(fourpai,zhuozi,var,zhu)
          if temp then
          	reng(temp,var)
          	remainsign[var]:setString(table.maxn(fourpai[var]))
          	you(var)
          else
            fangpai({},var)
          end
        end    	
    	end
    end
    for key, var in pairs(wodepai) do
      if var:boundingBox():containsPoint(p) then
        var:setPosition(ccp(var:getPosition(x),changedy(var)))
        break
      end
    end
  end
  
	local function startGame()
	  --张手
    zhangshou()
    --摸自己的牌
    mopai(fourpai[1])
    --出牌键
    gbutton:setPosition(ccp(650,250-10))
    layer:addChild(gbutton)
    --不出键
    pbutton:setPosition(ccp(150,250-10))
    layer:addChild(pbutton)
    for var=1, 4 do
      --不出字
      table.insert(psign,CCLabelTTF:create("PASS","Courier",50))
      psign[var]:setAnchorPoint(ccp(0,0))
      psign[var]:setPosition(zhuozip[var])
      layer:addChild(psign[var])
      psign[var]:setVisible(false)
      --手牌数
      table.insert(remainsign,CCLabelTTF:create(27,"Courier",30))
      remainsign[var]:setAnchorPoint(ccp(0,0))
      remainsign[var]:setPosition(zhuozip2[var])
      layer:addChild(remainsign[var])
      remainsign[var]:setColor(ccc3(0,0,255))
    end
    --头游末游
    touyou:setAnchorPoint(ccp(0,0))
    layer:addChild(touyou)
    touyou:setVisible(false)
    moyou:setAnchorPoint(ccp(0,0))
    layer:addChild(moyou)
    moyou:setVisible(false)
    moyou2:setAnchorPoint(ccp(0,0))
    layer:addChild(moyou2)
    moyou2:setVisible(false)
    --另外三家牌
    for var=2, 4 do
      for key, va in pairs(fourpai[var]) do
        layer:addChild(va)
        va:setVisible(false)
      end
    end 
  end
	
	local function init()
		layer = CCLayer:create()
		self:addChild(layer)
		layer:setTouchEnabled(true)
		layer:registerScriptTouchHandler(onTouch)
		startGame()
	end

	init()
	return self
end

local function __main()
	CCEGLView:sharedOpenGLView():setDesignResolutionSize(800,480,kResolutionShowAll)
	local dir = CCDirector:sharedDirector()
	dir:setDisplayStats(false)
  dir:runWithScene(Main())
end

__main()