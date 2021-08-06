resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'CoCoRP Custom hud'

ui_page 'html/ui.html'

client_scripts {
	'@es_extended/locale.lua',
	'client/*.lua',
	'config.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server.lua',
}

dependencies {
	'es_extended',
}

files {
	'html/ui.html',
    'html/script.js',
    'html/style.css',
}