Config = {}

Config.Debug = false

-- What job is required per shop is configured inside each shop below.
-- If you want duty-only access, set RequireDuty = true (QBX job onduty).
Config.RequireDuty = false

-- zf-textui integration
Config.TextUI = {
    Mode = 'event', -- 'event' recommended for zf-textui
    ShowEvent = 'zf-textui:client:show',
    HideEvent = 'zf-textui:client:hide',
}

-- Notification (optional: if you use zf-notify)
Config.Notify = {
    Mode = 'event', -- 'event' | 'ox'
    EventName = 'zf-notify:client:notify',
}

-- Discord logs (optional)
Config.DiscordLogs = {
    Enabled = false,
    Webhook = '',
    Username = 'zf-jobshops',
    AvatarURL = '',
    EmbedColor = 5793266,
}

-- =====================================================================
-- JOB SHOPS
-- =====================================================================
-- ox_inventory shop inventory format:
-- items = {
--   { name = 'water', price = 10, count = 50 },
--   { name = 'weapon_pistol', price = 0, metadata = { serial = 'POLICE' } },
-- }
--
-- NOTE:
-- Some ox_inventory versions require shops to be defined in ox_inventory/data/shops.lua.
-- This script will TRY to RegisterShop dynamically if your ox_inventory supports it.
-- If your build doesn't, see README-style note in server.lua comments.
--
Config.JobShops = {
    {
        id = 'police_armory',
        label = 'Police Armory',
        coords = vector3(450.2354, -998.1426, 30.9279),
        radius = 1.6,
        job = 'police',
        minGrade = 0,           -- minimum grade level
        requireDuty = true,     -- overrides Config.RequireDuty for this shop
        prompt = '[E] Police Armory',

        -- ox_inventory shop id (what you open)
        shopId = 'police_armory',

        items = {
            { name = 'weapon_stungun', price = 0 },
            { name = 'weapon_nightstick', price = 0 },
            { name = 'weapon_flashlight', price = 0 },
            { name = 'weapon_pistol', price = 0 },
            { name = 'pistol_ammo', price = 0, count = 250 },
            { name = 'radio', price = 0 },
            { name = 'armor', price = 0, count = 10 },
            { name = 'bandage', price = 0, count = 50 },
        }
    },

    -- Example: EMS supply (edit/remove if you don't want it)
    {
        id = 'ems_supply',
        label = 'EMS Supply',
        coords = vec3(306.20, -601.60, 43.30),
        radius = 1.6,
        job = 'ambulance',
        minGrade = 0,
        requireDuty = true,
        prompt = '[E] EMS Supply',
        shopId = 'ems_supply',

        items = {
            { name = 'bandage', price = 0, count = 200 },
            { name = 'firstaid', price = 0, count = 50 },
            { name = 'radio', price = 0 },
        }
    }
}
