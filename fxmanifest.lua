-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'zf-jobshops'
author 'Virella.Scripts'
description 'Job shops for QBX (qbx_core) + ox_inventory with zf-textui prompts'
version '1.0.0'

dependencies {
    'ox_lib',
    'qbx_core',
    'ox_inventory',
    'zf-textui'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_scripts {
    '@ox_lib/init.lua',
    'server.lua'
}
