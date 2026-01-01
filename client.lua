local QBCore = exports['qb-core']:GetCoreObject()
local displayMessages = {}
local updateInterval = 35 -- Frissítési gyakoriság (ms)
local drawing = false -- Jelzi, hogy fut-e a rajzoló ciklus

-- Maximum ennyi üzenet látszódjon egyszerre egy ember felett
local maxStack = 5 

local function StartDrawingLoop()
    if drawing then return end
    drawing = true

    CreateThread(function()
        while drawing do
            if #displayMessages == 0 then
                drawing = false
                break
            end

            local playerPed = PlayerPedId()
            local myCoords = GetEntityCoords(playerPed)
            local uiUpdates = {}
            local gameTimer = GetGameTimer()
            
            local stackCounts = {} 

            for i = #displayMessages, 1, -1 do
                local msg = displayMessages[i]

                if gameTimer > msg.timeEnd then
                    SendNUIMessage({ action = 'removeMessage', id = msg.id })
                    table.remove(displayMessages, i)
                else
                    local targetIdx = GetPlayerFromServerId(msg.playerId)
                    
                    if targetIdx == -1 and msg.playerId ~= GetPlayerServerId(PlayerId()) then
                        SendNUIMessage({ action = 'removeMessage', id = msg.id })
                        table.remove(displayMessages, i)
                    else
                        local currentStack = stackCounts[msg.playerId] or 0

                        if currentStack < maxStack then
                            local targetPed = GetPlayerPed(targetIdx)
                            if DoesEntityExist(targetPed) then
                                local targetCoords = GetPedBoneCoords(targetPed, 12844, 0.0, 0.0, 0.0)
                                local dist = #(myCoords - targetCoords)
                                
                                if dist < Config.DrawDistance then
                                    local hasLos = HasEntityClearLosToEntity(playerPed, targetPed, 17)
                                    local isMe = (msg.playerId == GetPlayerServerId(PlayerId()))

                                    if hasLos or isMe then
                                        -- ITT HASZNÁLJUK A CONFIGBÓL AZ ÉRTÉKET (Config.StackOffset)
                                        local zAdjusted = targetCoords.z + 0.35 + (currentStack * Config.StackOffset)

                                        local onScreen, screenX, screenY = World3dToScreen2d(targetCoords.x, targetCoords.y, zAdjusted)
                                        
                                        if onScreen then
                                            local scale = (1 / dist) * 2
                                            local fov = (1 / GetGameplayCamFov()) * 100
                                            scale = scale * fov
                                            if scale > 1.0 then scale = 1.0 end
                                            if scale < 0.6 then scale = 0.6 end

                                            table.insert(uiUpdates, {
                                                id = msg.id, x = screenX, y = screenY, scale = scale, visible = true
                                            })
                                        else
                                            table.insert(uiUpdates, { id = msg.id, visible = false })
                                        end
                                    else
                                        table.insert(uiUpdates, { id = msg.id, visible = false })
                                    end
                                else
                                    table.insert(uiUpdates, { id = msg.id, visible = false })
                                end
                            else
                                table.insert(uiUpdates, { id = msg.id, visible = false })
                            end

                            stackCounts[msg.playerId] = currentStack + 1
                        else
                            table.insert(uiUpdates, { id = msg.id, visible = false })
                        end
                    end
                end
            end

            if #uiUpdates > 0 then
                SendNUIMessage({ action = 'updatePositions', updates = uiUpdates })
            end

            Wait(updateInterval)
        end
    end)
end

RegisterNetEvent('eper_me:client:onShare', function(text, targetPlayerId, type)
    local playerIdx = GetPlayerFromServerId(targetPlayerId)
    
    if playerIdx ~= -1 or targetPlayerId == GetPlayerServerId(PlayerId()) then
        local msgId = math.random(1000, 9999)
        
        table.insert(displayMessages, {
            id = msgId,
            playerId = targetPlayerId,
            text = text,
            type = type,
            timeEnd = GetGameTimer() + Config.DisplayTime 
        })

        local icon = Config.Icons[type] or ''

        SendNUIMessage({
            action = 'addMessage',
            id = msgId,
            text = text,
            type = type,
            icon = icon
        })

        StartDrawingLoop()
    end
end)