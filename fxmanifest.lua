fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'enty#8799'
thanks_to 'JericoFX#3512, BerkieB#5038'
description 'Claiming Land script for QBCore'
version '1.6.9'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {'server/*.lua'}

shared_scripts { 'config.lua' }

dependencies {
    'qb-core',
    'PolyZone'
}