fx_version 'cerulean'
game 'gta5'

author 'JGR'
description 'Entrada por puerta'
version '1.0.1'

shared_scripts {
	'@ox_lib/init.lua',
	'@qbx_core/modules/lib.lua',
}

client_scripts {
	'@qbx_core/modules/playerdata.lua',
	'client.lua',
}

server_scripts {
    'updates.lua',
}

lua54 'yes'

dependency 'qbx_core'
dependency 'ox_lib'