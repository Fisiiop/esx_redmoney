description 'esx_redmonney'

-- By Fisiio
-- Based on the script esx_LSD 

version '1.0.0'

server_scripts {

  '@es_extended/locale.lua',
	'locales/fr.lua',
  'server/esx_redmonney_sv.lua',
  'config.lua'

}

client_scripts {

  '@es_extended/locale.lua',
	'locales/fr.lua',
  'config.lua',
  'client/esx_redmonney_cl.lua'

}
