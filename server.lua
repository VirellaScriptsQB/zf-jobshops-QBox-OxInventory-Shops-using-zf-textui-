local function debugPrint(...)
    if Config.Debug then
        print('[zf-jobshops]', ...)
    end
end

local function getPlayer(src)
    local ok, p = pcall(function()
        return exports.qbx_core:GetPlayer(src)
    end)
    return ok and p or nil
end

local function getGradeLevel(Player)
    local grade = Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.grade
    if type(grade) == 'table' then
        return tonumber(grade.level or grade.grade or 0) or 0
    end
    return tonumber(grade or 0) or 0
end

local function isOnDuty(Player)
    return Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.onduty == true
end

local function notify(src, nType, title, msg)
    if Config.Notify and Config.Notify.Mode == 'event' and Config.Notify.EventName then
        TriggerClientEvent(Config.Notify.EventName, src, { type = nType or 'info', title = title or 'Job Shops', text = msg or '' })
        return
    end
    TriggerClientEvent('ox_lib:notify', src, { type = nType or 'info', title = title or 'Job Shops', description = msg or '' })
end

local function discordLog(title, message)
    if not (Config.DiscordLogs and Config.DiscordLogs.Enabled and Config.DiscordLogs.Webhook and Config.DiscordLogs.Webhook ~= '') then
        return
    end

    local payload = {
        username = (Config.DiscordLogs.Username or 'zf-jobshops'),
        avatar_url = (Config.DiscordLogs.AvatarURL or nil),
        embeds = {{
            title = title or 'ZF Job Shops',
            description = message or '',
            color = (Config.DiscordLogs.EmbedColor or 5793266),
            footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
        }}
    }

    PerformHttpRequest(Config.DiscordLogs.Webhook, function() end, 'POST', json.encode(payload), {
        ['Content-Type'] = 'application/json'
    })
end

local function findShop(id)
    id = tostring(id or '')
    if id == '' then return nil end
    for _, s in ipairs(Config.JobShops or {}) do
        if tostring(s.id) == id then
            return s
        end
    end
    return nil
end

-- Try to register shops at runtime (works on many ox_inventory builds).
-- If your ox_inventory doesn't support RegisterShop, you can manually add these to:
-- ox_inventory/data/shops.lua (same shopId + inventory).
CreateThread(function()
    Wait(750)

    if not exports.ox_inventory then
        print('[zf-jobshops] ox_inventory not found. Shops won’t register/open.')
        return
    end

    for _, s in ipairs(Config.JobShops or {}) do
        if s.shopId and s.items then
            local shopData = {
                name = s.label or s.shopId,
                inventory = s.items,
                -- groups is optional; we do access control ourselves too
                groups = { [s.job] = s.minGrade or 0 }
            }

            local ok = pcall(function()
                if exports.ox_inventory.RegisterShop then
                    exports.ox_inventory:RegisterShop(s.shopId, shopData)
                elseif exports.ox_inventory.registerShop then
                    exports.ox_inventory:registerShop(s.shopId, shopData)
                end
            end)

            debugPrint('RegisterShop', s.shopId, ok and 'OK' or 'SKIPPED/FAILED')
        end
    end
end)

RegisterNetEvent('zf-jobshops:server:tryOpenShop', function(shopKey)
    local src = source
    local shop = findShop(shopKey)
    if not shop then
        notify(src, 'error', 'Shop', 'Invalid shop.')
        return
    end

    local Player = getPlayer(src)
    if not Player then return end

    local job = Player.PlayerData.job
    if not job or job.name ~= shop.job then
        notify(src, 'error', 'Shop', 'Not authorized.')
        return
    end

    local grade = getGradeLevel(Player)
    if grade < (shop.minGrade or 0) then
        notify(src, 'error', 'Shop', 'Not authorized.')
        return
    end

    local requireDuty = (shop.requireDuty ~= nil) and shop.requireDuty or (Config.RequireDuty == true)
    if requireDuty and not isOnDuty(Player) then
        notify(src, 'error', 'Shop', 'You must be on duty.')
        return
    end

    -- Optional distance check (prevents event abuse)
    local ped = GetPlayerPed(src)
    local pcoords = GetEntityCoords(ped)
    local dist = #(pcoords - shop.coords)
    if dist > ((shop.radius or 1.6) + 2.0) then
        notify(src, 'error', 'Shop', 'Too far away.')
        return
    end

    if not shop.shopId then
        notify(src, 'error', 'Shop', 'Shop not configured.')
        return
    end

    -- Tell client to open it (most reliable)
    TriggerClientEvent('zf-jobshops:client:openShop', src, shop.shopId)

    discordLog('Job Shop Opened', ('**%s** (%d) opened `%s`'):format(GetPlayerName(src) or 'Unknown', src, shop.shopId))
end)
