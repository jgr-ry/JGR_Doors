fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'JGR_Doors'
author 'JGR'
description 'Entrada al vehículo por la puerta más cercana (QBCore, Qbox, ESX y standalone)'
version '1.1.0'
jgr_version_key 'JGR_Doors'
repository 'https://github.com/jgr-ry/JGR_Doors'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'bridge/client.lua',
    'client.lua',
}

server_scripts {
    'server/version_check.lua',
}

dependency 'ox_lib'
