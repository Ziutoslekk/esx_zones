games { 'gta5' }
fx_version 'cerulean'

shared_script 'config.lua'

server_script {
    'server/main.lua'
}

client_script {
    'client/main.lua' 
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/pNotify.js",
    "html/noty.js",
    "html/noty.css",
    "html/themes.css",
    "html/sound-example.wav",
    "html/notif.wav",
}


