local hunger = 100
local thirst = 100
local open = false
local move = false

RegisterCommand(Config.Command['command'], function() open = not open end)

if Config.Command['key'] then
    RegisterKeyMapping(Config.Command['command'],
                       Config.Command['keydescription'], 'keyboard',
                       Config.Command['keyuse'])
end

RegisterCommand(Config.Move['command'], function() SetNuiFocus(true, true) end)

if Config.Move['key'] then
    RegisterKeyMapping(Config.Move['command'], Config.Move['keydescription'],
                       'keyboard', Config.Move['keyuse'])
end

RegisterNUICallback("exit", function(data, cb) SetNuiFocus(false, false) end)

if GetResourceState("es_extended") == "started" then
 
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            Citizen.Wait(100)
        end
    end)

    Citizen.CreateThread(function()

        while true do
            if open then
                TriggerEvent('esx_status:getStatus', 'hunger',
                             function(status)
                    food = status.val / 10000
                end)
                TriggerEvent('esx_status:getStatus', 'thirst',
                             function(status)
                    thirst = status.val / 10000
                end)

                SendNUIMessage({
                    noti = true,
                    armour = GetPedArmour(PlayerPedId()),
                    health = GetEntityHealth(PlayerPedId()) - 100,
                    food = food,
                    thirst = thirst,
                    stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
                    playerid = GetPlayerServerId(PlayerId()),
                    name = Config.UI['servername'],
                    logo = Config.UI['serverlogo'],
                })
            else
                SendNUIMessage({noti = false})
            end
            Citizen.Wait(1000)
        end
    end)

elseif GetResourceState("qb-core") == "started" then
    QBCore = exports["qb-core"]:GetCoreObject()

    RegisterNetEvent('hud:client:UpdateNeeds') -- Triggered in qb-core
    AddEventHandler('hud:client:UpdateNeeds', function(newHunger, newThirst)
        hunger = newHunger
        thirst = newThirst
    end)

    Citizen.CreateThread(function()

        while true do
            if open then
                SendNUIMessage({
                    noti = true,
                    armour = GetPedArmour(PlayerPedId()),
                    health = GetEntityHealth(PlayerPedId()) - 100,
                    food = hunger,
                    thirst = thirst,
                    stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
                    playerid = GetPlayerServerId(PlayerId()),
                    name = Config.UI['servername'],
                    logo = Config.UI['serverlogo'],
                })
            else
                SendNUIMessage({noti = false})
            end
            Citizen.Wait(1000)
        end
    end)

end

