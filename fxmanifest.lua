fx_version 'cerulean'
game 'gta5'

description 'Bodycam Script (NS-Shop)'
author 'NIKLO'
version '1.0.0'
discord 'https://discord.gg/CKNRYZ2Rju'

lua54 'yes'

shared_scripts {
  '@es_extended/imports.lua',
  'config.lua',
  '@ox_lib/init.lua', 
}

server_scripts {
  'server/server.lua',
}

client_scripts {
  'client/client.lua',
}

ui_page 'client/nui/index.html'

files {
  'client/nui/index.html',
  'client/nui/script.js',
}

escrow_ignore {
  'config.lua'
}

dependency "screenshot-basic"