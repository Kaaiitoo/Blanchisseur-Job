fx_version 'adamant'

game 'gta5'

client_scripts {
    '@es_extended/locale.lua',
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",
	'client/client.lua',
    'client/cl_boss.lua',
    'client/cl_vestiaire.lua',
    'client/cl_blanchi.lua',
	'config.lua'
}


server_scripts {
    '@es_extended/locale.lua',
    '@mysql-async/lib/MySQL.lua',
	'server/server.lua',
}



dependencies {
	'es_extended'
}
