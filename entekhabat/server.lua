DM = nil
TriggerEvent('esx:getSharedObject', function(object) DM = object end)

local res
RegisterNetEvent('send:voteing')
AddEventHandler('send:voteing', function(sender, pl)
    if sender == '1' then
        res = 'Mohesn Rezaee'
    elseif sender == '2' then
        res = 'Mohsen Mehr Ali Zade'
    elseif sender == '3' then
        res = 'Saeed Jalili'
    elseif sender == '4' then
        res = 'Alireza Zakani'
    elseif sender == '5' then
        res = 'Abd Alnaser Hemati'
    elseif sender == '6' then
        res = 'Seied Ebrahim Reisi'
    end
    local jon = DM.GetPlayerFromId(pl)

    MySQL.Async.execute('UPDATE users SET vote = @vote WHERE identifier=@identifier', {
        ['@vote'] = res,
        ['@identifier'] = jon.identifier
    }, function(change)
        if change > 1 then
            print('Yek Ray Jadid Be : ' .. res .. ' Sabt Shod !') 
        end
    end)

    MySQL.Async.execute('UPDATE users SET voting = @voting WHERE identifier=@identifier', {
        ['@voting'] = '1',
        ['@identifier'] = jon.identifier
    }, function(change)
    end)
    if Config.namayeshRay then
    local players = DM.GetPlayers()
    for i=1, #players, 1 do
        local xps = DM.GetPlayerFromId(players[i])
        if xps.permission_level >= Config.perm_to_view then
            TriggerClientEvent('send:notif:to:admins:for:ray:giri:kandid:ha', players[i], GetPlayerName(pl), pl, res)
        end
    end
    end

end)

DM.RegisterServerCallback('get:vote:kandid:haye:aziz', function(source, cb)
    local xp = DM.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
        ['@identifier'] = xp.identifier
    }, function(data)
        local vote = data[1].voting
        if not vote or vote == 0 then
            cb(false)
        elseif vote == 1 then
            cb(true)
        end
    end)
end)

DM.RegisterServerCallback('get:ray:ha:from:data:base', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM users', {}, function(data)
		cb(data[1])
    end)
end)

local kandid
RegisterNetEvent('pas:gereftan:ray')
AddEventHandler('pas:gereftan:ray', function(pl)
    local xp = DM.GetPlayerFromId(pl)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
		['@identifier'] = xp.identifier
	}, function(data)
        local ara = data[1].vote
        kandid = ara
    end)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {
		['@identifier'] = xp.identifier
	}, function(data)
        if data[1].voting == 1 then
            if xp.money >= Config.pool_pas_gereftan then
                xp.removeMoney(Config.pool_pas_gereftan)
                MySQL.Async.execute('UPDATE users SET vote = @vote WHERE identifier=@identifier', {
                    ['@vote'] = 'pas gerefte',
                    ['@identifier'] = xp.identifier
                }, function(change)
                end)
                MySQL.Async.execute('UPDATE users SET voting = @voting WHERE identifier=@identifier', {
                    ['@voting'] = '0',
                    ['@identifier'] = xp.identifier
                }, function(change)
                end)
                TriggerClientEvent('gereftan:ray:majmu', -1, kandid)
            else
                TriggerClientEvent('send:orig:notif', pl, '~r~Shoma Pool Kafi ~g~' .. Config.pool_pas_gereftan ..' ~r~Nadarid !')
            end
        elseif data[1].voting == 0 then
            TriggerClientEvent('send:orig:notif', pl, '~r~Shoma Hanooz Ray Nadadid !')
        end
    end)
end)

RegisterNetEvent('add:ray:baraye:kandid')
AddEventHandler('add:ray:baraye:kandid', function(value)
    TriggerClientEvent('add:ray:cl', -1, value)
end)