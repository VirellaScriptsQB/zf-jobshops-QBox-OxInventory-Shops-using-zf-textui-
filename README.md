ZF-JOBSHOPS
=========================================
Job shops for QBX (qbx_core) + ox_inventory
Uses ox_lib zones + zf-textui prompts.

This resource lets you create “job-only” shops at locations.
Example: Police Armory shop, EMS Supply shop, Mechanic shop, etc.


REQUIREMENTS
-----------------------------------------
- ox_lib
- qbx_core
- ox_inventory
- zf-textui


FILES (NO FOLDERS)
-----------------------------------------
- fxmanifest.lua
- config.lua
- client.lua
- server.lua
- README.txt


INSTALL
-----------------------------------------
1) Drop folder into your resources:
   zf-jobshops/

2) Ensure it AFTER dependencies:
   ensure ox_lib
   ensure qbx_core
   ensure ox_inventory
   ensure zf-textui
   ensure zf-jobshops

3) Configure shops inside config.lua:
   Config.JobShops = {
     {
       id = 'police_armory',          -- internal key used by this script
       label = 'Police Armory',       -- UI label
       coords = vec3(x, y, z),        -- location
       radius = 1.6,                  -- zone radius
       job = 'police',                -- required job name
       minGrade = 0,                  -- minimum job grade (level)
       requireDuty = true,            -- require onduty
       prompt = '[E] Police Armory',  -- zf-textui prompt
       shopId = 'police_armory',      -- ox_inventory shop id
       items = {                      -- ox_inventory shop inventory
         { name = 'weapon_pistol', price = 0 },
         { name = 'pistol_ammo', price = 0, count = 250 },
       }
     }
   }


HOW IT WORKS
-----------------------------------------
- Client creates zones using ox_lib.
- When player presses E:
  -> client triggers server validation event
- Server checks:
  - player job matches shop.job
  - player grade >= minGrade
  - if requireDuty = true, player must be on duty
  - distance check to prevent event abuse
- If allowed:
  -> server tells client to open the ox_inventory shop UI
  -> client opens the shop using ox_inventory API


IMPORTANT NOTE ABOUT OX_INVENTORY SHOPS
-----------------------------------------
Different ox_inventory builds handle shops in slightly different ways.

This script tries to register shops dynamically on resource start:
- exports.ox_inventory:RegisterShop(...)
or
- exports.ox_inventory:registerShop(...)

If your ox_inventory build does NOT support runtime registration:
You must add the shops manually inside:
  ox_inventory/data/shops.lua

Use the SAME shopId you set in config.lua
and copy the same inventory items list there.

After that, this script will still open the shop properly.


DUTY REQUIREMENT
-----------------------------------------
- If Config.RequireDuty = true: ALL shops require onduty
- Each shop can override it with:
  requireDuty = true/false


DISCORD LOGS (OPTIONAL)
-----------------------------------------
In config.lua:
Config.DiscordLogs = {
  Enabled = true,
  Webhook = 'YOUR_WEBHOOK_HERE',
  Username = 'zf-jobshops',
  EmbedColor = 5793266
}

Logged actions:
- when a player opens a job shop


TROUBLESHOOTING
-----------------------------------------
1) "ox_inventory not found"
   - Start ox_inventory before zf-jobshops.

2) Pressing E does nothing
   - Make sure ox_lib is started (zones require it).
   - Make sure coords are vec3(...) and correct.
   - Make sure zf-textui is started.

3) "Not authorized"
   - Job name mismatch (Config.JobShops[i].job)
   - Grade too low (minGrade)
   - Not on duty (requireDuty = true)

4) Shop opens but is empty / not found
   - Your ox_inventory build may require shops defined in shops.lua
   - Add the shopId and inventory to ox_inventory/data/shops.lua


GITHUB / LICENSE
-----------------------------------------
Free release. People can fork and add more shops.
Credit appreciated but not required.

Virella.Scripts
=========================================
