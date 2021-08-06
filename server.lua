ESX                = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addGroupCommand', 'opis', 'user', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    if args[1] ~= nil then
        local text = table.concat(args, " ",1)
        if #text > 91 then
            TriggerClientEvent('pNotify:SendNotification', source, {text = "Maksymalna długość opisu to 91 znaków!"})
        else
            TriggerClientEvent('cocorp:opis', -1, source, ''..text..'')
            MySQL.Sync.execute("UPDATE users SET opis =@opis WHERE identifier=@identifier",{['@identifier'] = identifier , ['@opis'] = '(('..text..'))'})
        end
	else
		TriggerClientEvent('cocorp:opis', -1, source, '')
        MySQL.Sync.execute("UPDATE users SET opis =@opis WHERE identifier=@identifier",{['@identifier'] = identifier , ['@opis'] = ''})
	end
end, function(source, args, user)
end)