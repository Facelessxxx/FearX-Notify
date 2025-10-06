fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/index.html'

files {
  'html/index.html',
  'html/*.css',
  'html/*.js',
  'html/*.png',
  'html/*.jpg',
  'html/*.jpeg',
  'html/*.svg',
  'html/sounds/*.mp3',
  'html/sounds/*.ogg'
}

shared_scripts {
  'config.lua'
}

client_scripts {
  'client/*.lua'
}

server_scripts {
  'server/*.lua'
}
