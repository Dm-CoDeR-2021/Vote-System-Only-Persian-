fx_version 'cerulean'
games { 'gta5' }

project 'entekhabat1400'

server_scripts {
	'server.lua',
	'config.lua',
    '@mysql-async/lib/MySQL.lua'
}

client_scripts {
	'client.lua',
	'config.lua'
}