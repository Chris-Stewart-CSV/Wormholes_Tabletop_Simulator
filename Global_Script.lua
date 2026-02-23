-- Global Script --

-- [[ Master Control ]] --
gameLoaded = false
activePlatforms = {}
local LEADERBOARD_GUID = "b0b7d0"
local lastMover = {} -- Tracks who last touched an object

-- [[ Score Tracking ]] --
scores = {
    Red = 0, Blue = 0, Yellow = 0, Purple = 0, Green = 0
}

-- [[ Wormhole Data ]] --
local wormholePairs = {
    {start = "c1d413", finish = "975560", name = "Red 1", owner = "Red"},
    {start = "3b1627", finish = "21512b", name = "Red 2", owner = "Red"},
    {start = "8a1e5f", finish = "ca0ec5", name = "Red 3", owner = "Red"},
    {start = "4870af", finish = "9927ed", name = "Red 4", owner = "Red"},
    {start = "66b283", finish = "8505fc", name = "Red 5", owner = "Red"},
    {start = "3e8fe1", finish = "a39019", name = "Blue 1", owner = "Blue"},
    {start = "29a4a0", finish = "46c65d", name = "Blue 2", owner = "Blue"},
    {start = "ec7811", finish = "ffdbb6", name = "Blue 3", owner = "Blue"},
    {start = "08dbf6", finish = "28c41b", name = "Blue 4", owner = "Blue"},
    {start = "aed8d8", finish = "70d004", name = "Blue 5", owner = "Blue"},
    {start = "f32f96", finish = "e6eb14", name = "Yellow 1", owner = "Yellow"},
    {start = "102c16", finish = "11c8bc", name = "Yellow 2", owner = "Yellow"},
    {start = "273945", finish = "3e8c11", name = "Yellow 3", owner = "Yellow"},
    {start = "332fe6", finish = "e09042", name = "Yellow 4", owner = "Yellow"},
    {start = "6dc4ae", finish = "087d49", name = "Yellow 5", owner = "Yellow"},
    {start = "cf363b", finish = "71e256", name = "Purple 1", owner = "Purple"},
    {start = "761714", finish = "647b32", name = "Purple 2", owner = "Purple"},
    {start = "1890db", finish = "302f12", name = "Purple 3", owner = "Purple"},
    {start = "3e5ab2", finish = "35e0c7", name = "Purple 4", owner = "Purple"},
    {start = "dced7e", finish = "4733c6", name = "Purple 5", owner = "Purple"},
    {start = "0fd677", finish = "2a0415", name = "Green 1", owner = "Green"},
    {start = "f29a9a", finish = "0423a2", name = "Green 2", owner = "Green"},
    {start = "4eeb7c", finish = "0960a5", name = "Green 3", owner = "Green"},
    {start = "01cdbb", finish = "eab9c1", name = "Green 4", owner = "Green"},
    {start = "5ce16c", finish = "c8c497", name = "Green 5", owner = "Green"}
}

function onLoad()
    Wait.time(function() 
        gameLoaded = true 
        updateNotecard() 
    end, 2)
end

-- Capture who is moving the object before it enters the bag
function onObjectPickUp(player_color, picked_up_object)
    if picked_up_object then
        lastMover[picked_up_object.getGUID()] = player_color
    end
end

function onObjectEnterContainer(container, enter_obj)
    if not gameLoaded or container == nil or enter_obj == nil then return end

    local cGuid = container.getGUID()
    for _, pair in ipairs(wormholePairs) do
        if cGuid == pair.start or cGuid == pair.finish then
            local targetGuid = (cGuid == pair.start) and pair.finish or pair.start
            local targetObj = getObjectFromGUID(targetGuid)
            
            if targetObj then
                local destPos = targetObj.getPosition()
                local objGuid = enter_obj.getGUID()
                
                -- Determine player: check our tracker first, then the object property
                local playerWhoMovedIt = lastMover[objGuid] or enter_obj.held_by_color or "Grey"

                Wait.time(function()
                    if container and not container.isDestroyed() then
                        performTeleportAndScore(container, objGuid, destPos, pair, playerWhoMovedIt)
                    end
                end, 0.2)
                return
            end
        end
    end
end

function performTeleportAndScore(container, objGuid, destPos, pair, userColor)
    spawnObject({
        type = "BlockSquare",
        position = {destPos.x, destPos.y + 0.5, destPos.z},
        scale = {1.5, 0.1, 1.5}, 
        callback_function = function(platform)
            platform.setLock(true)
            platform.setInvisibleTo(Player.getColors())
            
            container.takeObject({
                guid = objGuid,
                position = {destPos.x, destPos.y + 1.1, destPos.z},
                smooth = false,
                callback_function = function(token)
                    activePlatforms[token.getGUID()] = platform
                    
                    -- SCORING LOGIC
                    -- If a Red player uses a Blue wormhole, Blue gets a point.
                    if userColor ~= "Grey" and userColor ~= pair.owner then
                        scores[pair.owner] = scores[pair.owner] + 1
                        broadcastToAll(userColor .. " triggered a point for " .. pair.owner .. "!", {1, 1, 1})
                        updateNotecard()
                    else
                        broadcastToAll("Wormhole Traversed by " .. pair.owner .. " (No points).", {0.5, 0.5, 0.5})
                    end
                    
                    -- Clean up the mover tracker
                    lastMover[objGuid] = nil
                end
            })
        end
    })
end

function updateNotecard()
    local card = getObjectFromGUID(LEADERBOARD_GUID)
    if card then
        local displayString = "--- WORMHOLE REVENUE ---\n\n"
        displayString = displayString .. "RED: " .. scores.Red .. "\n"
        displayString = displayString .. "BLUE: " .. scores.Blue .. "\n"
        displayString = displayString .. "YELLOW: " .. scores.Yellow .. "\n"
        displayString = displayString .. "PURPLE: " .. scores.Purple .. "\n"
        displayString = displayString .. "GREEN: " .. scores.Green .. "\n\n"
        displayString = displayString .. "Last Update: " .. os.date("%H:%M:%S")
        
        card.setName("Wormhole Scoreboard")
        card.setDescription(displayString)
    else
        -- This helps you find the card if the GUID is wrong
        broadcastToAll("ERROR: Scoreboard not found! Check GUID.", {1, 0, 0})
    end
end