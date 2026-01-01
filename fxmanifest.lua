fx_version 'cerulean'
game 'gta5'

author 'Eper'
description 'Eper ME/DO Script'
version '1.0.0'

ui_page 'html/index.html'

shared_script 'config.lua' -- Opcionális, ha később konfigurálhatóvá tennénk

client_script 'client.lua'
server_script 'server.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/fonts/*.ttf' -- Ha majd használunk egyedi fontot
}