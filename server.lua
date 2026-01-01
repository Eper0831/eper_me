local QBCore = exports['qb-core']:GetCoreObject()

-- Segédfüggvény a Discord log küldéséhez
local function SendToDiscord(source, type, message)
    -- Ha ki van kapcsolva vagy nincs link, nem csinálunk semmit
    if not Config.EnableLogging or Config.Webhook == "" or Config.Webhook == "IDE_MÁSOLD_A_DISCORD_WEBHOOK_LINKET" then return end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    -- Alapértelmezett név, ha nincs Discord (OOC Név)
    local displayName = GetPlayerName(src)
    
    -- Discord ID keresése
    for _, v in pairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, 8) == "discord:" then
            -- Levágjuk a "discord:" előtagot, és csinálunk belőle egy pingelhető taget <@ID>
            local discordId = string.sub(v, 9)
            displayName = "<@" .. discordId .. ">"
            break
        end
    end

    local charName = "Ismeretlen"
    -- IC név lekérése
    if Player then
        charName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    end

    -- Színek és Cím beállítása (Lila a ME, Narancs a DO)
    local color = (type == "me") and 9317374 or 16750848
    local title = (type == "me") and "/me" or "/do"

    -- Log tartalom összeállítása (Tagelt névvel)
    -- Formátum: @DiscordTag (ID: 1) Karakter Név: Üzenet
    local logContent = "**" .. displayName .. " (ID: " .. src .. ")** " .. charName .. ": " .. message

    -- Embed összeállítása
    local embedData = {
        {
            ["color"] = color,
            ["title"] = title,
            ["description"] = logContent,
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S"),
            },
        }
    }

    -- Küldés a Discordnak
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = "Eper Log", embeds = embedData}), { ['Content-Type'] = 'application/json' })
end

-- /me parancs
QBCore.Commands.Add('me', 'Személyes cselekvés jelzése', {{name='szöveg', help='Mit csinálsz?'}}, false, function(source, args)
    local text = table.concat(args, ' ')
    if text == '' then 
        TriggerClientEvent('QBCore:Notify', source, 'Nem írtál be szöveget!', 'error')
        return 
    end
    
    TriggerClientEvent('eper_me:client:onShare', -1, text, source, 'me')
    SendToDiscord(source, 'me', text)
end)

-- /do parancs
QBCore.Commands.Add('do', 'Történés/Állapot jelzése', {{name='szöveg', help='Mi történik?'}}, false, function(source, args)
    local text = table.concat(args, ' ')
    if text == '' then 
        TriggerClientEvent('QBCore:Notify', source, 'Nem írtál be szöveget!', 'error')
        return 
    end
    
    TriggerClientEvent('eper_me:client:onShare', -1, text, source, 'do')
    SendToDiscord(source, 'do', text)
end)