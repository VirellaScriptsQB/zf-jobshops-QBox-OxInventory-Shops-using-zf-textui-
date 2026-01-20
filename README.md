ZF-GANGSTASHES
=========================================
Gang stashes for QBX (qbx_core) + ox_inventory
Prompts use zf-textui and zones use ox_lib.

This resource provides multiple configured gang stashes.
Players in the correct gang can open the stash at its location.


REQUIREMENTS
-----------------------------------------
- qbx_core
- ox_inventory
- ox_lib
- zf-textui


INSTALL
-----------------------------------------
1) Drop the folder into your resources:
   zf-gangstashes/

2) Ensure it AFTER dependencies:
   ensure ox_lib
   ensure qbx_core
   ensure ox_inventory
   ensure zf-textui
   ensure zf-gangstashes

3) Configure stashes in config.lua
   - set gang name
   - set stash id
   - set coords
   - set stash size/weight


HOW IT WORKS
-----------------------------------------
- Each stash in Config.GangStashes becomes an ox_inventory stash:
    zf_gangstash_<id>
- Server validates gang membership before opening.
- Client shows a zf-textui prompt and triggers open when pressing E.


CONFIG NOTES
-----------------------------------------
- If your gangs are stored as PlayerData.gang.name (QBX default), you’re good.
- If your server uses a different gang field, adjust the gang check in server.lua.


TROUBLESHOOTING
-----------------------------------------
1) "ox_inventory not found"
   - Make sure ox_inventory is started before zf-gangstashes.

2) Pressing E does nothing
   - Ensure ox_lib is started and zones are working.
   - Make sure coords are valid vec3(...) and not vector4.

3) Stash opens but is empty or not saving
   - That’s normal unless you put items in it.
   - Ensure ox_inventory is configured correctly in your server.


GITHUB / LICENSE
-----------------------------------------
Free release. Use it, modify it, reupload it, make PRs.
Credit appreciated but not required.

Virella.Scripts
=========================================
