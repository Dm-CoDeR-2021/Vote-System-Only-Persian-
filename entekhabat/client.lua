DM = nil
CreateThread(function() while DM == nil do Wait(0) TriggerEvent('esx:getSharedObject', function(object) DM = object end) end end)

CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, 'prop_train_ticket_02', false, false, false)
        if DoesEntityExist(object) then
            DM.ShowHelpNotification('~INPUT_CONTEXT~ Open Vote Menu')
            if IsControlJustPressed(0, 38) then
                RequestAnimDict("mini@atmbase")
                while not HasAnimDictLoaded('mini@atmbase') do
                    Wait(1)
                end
                TaskPlayAnim(GetPlayerPed(-1), 'mini@atmbase', "base", 8.0, 1.0, -1, 0, 0.0, 0, 0, 0)
                Wait(2000)
                OpenVotingMenu()
            end
        end
    end
end)

local mohesn = 0
local mohsen2 = 0
local saeed = 0
local alireza = 0
local abd = 0
local reisi = 0
OpenVotingMenu = function()
    DM.TriggerServerCallback('get:vote:kandid:haye:aziz', function(hasray)
    local kandid = {}
    table.insert(kandid, {label = "محسن رضایی", value = '1'})
    table.insert(kandid, {label = "محسن مهرعلیزاده",  value = '2'})
    table.insert(kandid, {label = "سعید جلیلی",  value = '3'})
    table.insert(kandid, {label = "علیرضا زاکانی",  value = '4'})
    table.insert(kandid, {label = "عبدالناصر همتی",  value = '5'})
    table.insert(kandid, {label = "سید ابراهیم رئیسی", value = '6'})
    if Config.majmuara then
        table.insert(kandid, {label = "دیدن آمار رای",  value = '7'})
    end
    if Config.pas_gereftan_ray then
        table.insert(kandid, {label = "پس گرفت رای خود", value = '8'})
    end
    DM.UI.Menu.Open('default', GetCurrentResourceName(), 'vote_system', {
        title = 'به یکی از کاندید ها رای بدهید ! زنده باد ایران',
        align = 'top-left',
        elements = kandid
    }, function(data, menu)
        local value = data.current.value
        if value == '1' or value == '2' or value == '3' or value == '4' or value == '5' or value == '6' then
            if not hasray then
                TriggerServerEvent('send:voteing', data.current.value, GetPlayerServerId(PlayerId())) 
                menu.close()
                DM.ShowNotification('~g~🇮🇷 Ray Shoma Ba Movafaghiat Sabt Shod ! 🇮🇷')
            elseif hasray then
                DM.ShowNotification('~r~Shoma Ghablan Ray Dade Bodid !')
            end
        end
        if not hasray then
            TriggerServerEvent('add:ray:baraye:kandid', value)
        end
        if value == '7' then
            OpenAmarMenu()
        end
        if value == '8' then
            OpenPasGereftanMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
    end)
end

OpenAmarMenu = function()
    DM.TriggerServerCallback('get:ray:ha:from:data:base', function(data)
    local amar = {
        {label = "Mohsen Rezaee : " .. mohesn, value = '1'},
        {label = "Mohsen Meher Alizade : " .. mohsen2,  value = '2'},
        {label = "Saeed Jalili : " .. saeed,  value = '3'},
        {label = "Alireza Zakani : " .. alireza,  value = '4'},
        {label = "Abd Alnaser Hemati : " .. abd,  value = '5'},
        {label = "Seied Ebrahim Reisi : " .. reisi, value = '6'}
    }
    DM.UI.Menu.Open('default', GetCurrentResourceName(), 'amar', {
        title = 'آمار انتخابات',
        align = 'top-left',
        elements = amar
    }, function(data, menu)
        menu.close()
    end, function(data, menu)
        menu.close()
        OpenVotingMenu()
    end)
    end)
end

AddEventHandler('playerSpawned', function()
    for k,v in ipairs(Config.makan) do
        local object = GetClosestObjectOfType(v.x, v.y, v.z, 1.0, 'prop_train_ticket_02', false, false, false)
        if not DoesEntityExist(object) then
            obj1 = CreateObject('prop_train_ticket_02', v.x, v.y, v.z, false, false, false)
            SetEntityHeading(obj1, v.h)
        end
    end
    CreateThread(function()
        for k,v in ipairs(Config.makan) do
            zone = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(zone, 304)
            SetBlipColour(zone, 1)
            SetBlipScale(zone, 0.9)
            SetBlipAsShortRange(zone, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Ray Giri')
            EndTextCommandSetBlipName(zone)
        end
    end)
end)




AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        for k,v in ipairs(Config.makan) do
        obj1 = CreateObject('prop_train_ticket_02', v.x, v.y, v.z, false, false, false)
        SetEntityHeading(obj1, v.h)
        end

        CreateThread(function()
            for k,v in ipairs(Config.makan) do
                zone = AddBlipForCoord(v.x, v.y, v.z)
                SetBlipSprite(zone, 304)
                SetBlipColour(zone, 1)
                SetBlipScale(zone, 0.9)
                SetBlipAsShortRange(zone, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('Ray Giri')
                EndTextCommandSetBlipName(zone)
            end
        end)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteEntity(obj1)
        RemoveBlip(zone)
    end
end)

RegisterNetEvent('send:notif:to:admins:for:ray:giri:kandid:ha')
AddEventHandler('send:notif:to:admins:for:ray:giri:kandid:ha', function(player, id, sender)
    SendNotif('Player Ba ID : ~r~' .. GetPlayerServerId(PlayerId(id)) .. '~w~ Va Ba Esme : ~o~' .. player .. '~w~ Be : ~g~' .. sender .. '~w~ Ray Dad')
end)

RegisterNetEvent('send:orig:notif')
AddEventHandler('send:orig:notif', function(msg)
    SendNotif(msg)
end)
SendNotif = function(text)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
  SetNotificationBackgroundColor(90)
  EndTextCommandThefeedPostTicker(1, 0)
	DrawNotification(0, 1)
end

OpenPasGereftanMenu = function()
    local pas = {
        {label = 'Pas Gereftan Ray : '..Config.pool_pas_gereftan..'$', value = '1'}
    }
    DM.UI.Menu.Open('default', GetCurrentResourceName(), 'ray_gereftan', {
        title = 'Pas Gereftan Ray',
        align = 'top-left',
        elements = pas
    }, function(data, menu)
        if data.current.value == '1' then
            TriggerServerEvent('pas:gereftan:ray', GetPlayerServerId(PlayerId()))
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('gereftan:ray:majmu')
AddEventHandler('gereftan:ray:majmu', function(value)
    if value == 'Mohesn Rezaee' then
        mohesn = mohesn - 1
    elseif value == 'Mohsen Mehr Ali Zade' then
        mohsen2 = mohsen2 - 1
    elseif value == 'Saeed Jalili' then
        saeed = saeed - 1
    elseif value == 'Alireza Zakani' then
        alireza = alireza - 1
    elseif value == 'Abd Alnaser Hemati' then
        abd = abd - 1
    elseif value == 'Seied Ebrahim Reisi' then
        reisi = reisi - 1
    end
    SendNotif('~g~Shoma Ray Khod Ra Az : ~r~'..value..'~g~ Gereftid !')
end)

RegisterNetEvent('add:ray:cl')
AddEventHandler('add:ray:cl', function(value)
    if value == '1' then
        mohesn = mohesn + 1
    elseif value == '2' then
        mohsen2 = mohsen2 + 1
    elseif value == '3' then
        saeed = saeed + 1
    elseif value == '4' then
        alireza = alireza + 1
    elseif value == '5' then
        abd = abd + 1
    elseif value == '6' then
        reisi = reisi + 1
    end
end)