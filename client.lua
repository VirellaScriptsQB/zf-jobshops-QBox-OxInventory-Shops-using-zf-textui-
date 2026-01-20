local function notify(nType, title, msg)
    if Config.Notify and Config.Notify.Mode == 'event' and Config.Notify.EventName then
        TriggerEvent(Config.Notify.EventName, { type = nType or 'info', title = title or 'Job Shops', text = msg or '' })
        return
    end

    if lib and lib.notify then
        lib.notify({ type = nType or 'info', title = title or 'Job Shops', description = msg or '' })
    end
end

local function showTextUI(text)
    if Config.TextUI and Config.TextUI.Mode == 'event' and Config.TextUI.ShowEvent then
        TriggerEvent(Config.TextUI.ShowEvent, text)
        return
    end
    if lib and lib.showTextUI then lib.showTextUI(text) end
end

local function hideTextUI()
    if Config.TextUI and Config.TextUI.Mode == 'event' and Config.TextUI.HideEvent then
        TriggerEvent(Config.TextUI.HideEvent)
        return
    end
    if lib and lib.hideTextUI then lib.hideTextUI() end
end

local function debugPrint(...)
    if Config.Debug then
        print('[zf-jobshops]', ...)
    end
end

-- server tells client to open a shop (client-side open = most reliable)
RegisterNetEvent('zf-jobshops:client:openShop', function(shopId)
    if not shopId or shopId == '' then return end
    if not exports.ox_inventory then
        notify('error', 'Inventory', 'ox_inventory not found.')
        return
    end

    -- Most reliable method on current ox_inventory builds:
    local ok = pcall(function()
        exports.ox_inventory:openInventory('shop', { type = shopId })
    end)

    if not ok then
        -- fallback: older event
        TriggerEvent('ox_inventory:openInventory', 'shop', { type = shopId })
    end
end)

local function addShopZone(shop)
    if not (lib and lib.zones and lib.zones.sphere) then
        print('[zf-jobshops] ox_lib zones missing.')
        return
    end

    local showing = false
    lib.zones.sphere({
        coords = shop.coords,
        radius = shop.radius or 1.6,
        debug = Config.Debug or false,

        inside = function()
            if not showing then
                showTextUI(shop.prompt or ('[E] %s'):format(shop.label or 'Shop'))
                showing = true
            end

            if IsControlJustPressed(0, 38) then -- E
                TriggerServerEvent('zf-jobshops:server:tryOpenShop', shop.id)
            end
        end,

        onExit = function()
            if showing then
                hideTextUI()
                showing = false
            end
        end
    })
end

CreateThread(function()
    Wait(500)

    if type(Config.JobShops) ~= 'table' then
        print('[zf-jobshops] Config.JobShops missing or not a table.')
        return
    end

    for _, shop in ipairs(Config.JobShops) do
        if shop.coords then
            debugPrint('Adding zone for shop:', shop.id)
            addShopZone(shop)
        end
    end
end)
