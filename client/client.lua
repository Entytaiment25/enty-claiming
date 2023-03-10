local QBCore = exports['qb-core']:GetCoreObject()
local switch = false
local locked = false
local FlMsgLck = false
RegisterNetEvent('ClaimEvent')
AddEventHandler('ClaimEvent', function(source)
    if not locked then
        locked = true
        -- zone
        local RawZones = Config.Zones.Coords
        local Zones = RawZones[math.random(1, #RawZones)]
        print(Zones)

        local circleBig = CircleZone:Create(Zones, Config.Zones.Radius.BigCircle, {
            name = 'circleBig',
            useZ = true
        })

        local circleSmall = CircleZone:Create(vec3(circleBig:getCenter()), Config.Zones.Radius.SmallCircle, {
            name = 'circleSmall',
            useZ = true
        })
        local SmallCenter = circleSmall:getCenter()
        ComboZone:Create({ circleBig, circleSmall }, { name = "comboZone", debugPoly = Config.Zones.Debug })

        -- ped
        local Ped
        local PedModel = Config.Ped.Model
        local PedHash = Config.Ped.Hash

        CreateThread(function()
            RequestModel(GetHashKey(PedModel))
            while (not HasModelLoaded(GetHashKey(PedModel))) do
                Wait(1)
            end
            Ped = CreatePed(1, PedHash, SmallCenter.x, SmallCenter.y, Zones.z - 1, 0, false, true)
            SetEntityInvincible(Ped, true)
            SetBlockingOfNonTemporaryEvents(Ped, true)
            FreezeEntityPosition(Ped, true)

            -- blip
            local blip = AddBlipForCoord(SmallCenter.x, SmallCenter.y, Zones.z)
            SetBlipSprite(blip, Config.Blips.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, Config.Blips.Blip.Scale)
            SetBlipColour(blip, Config.Blips.Blip.Color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.Blips.Blip.Name)
            EndTextCommandSetBlipName(blip)
            SetBlipPriority(blip, 1.0)

            local radius = AddBlipForRadius(SmallCenter.x, SmallCenter.y, Zones.z, Config.Zones.Radius.BigCircle * 5)
            SetBlipAlpha(radius, Config.Blips.Radius.Alpha)
            SetBlipRotation(radius, 0)
            SetBlipColour(radius, Config.Blips.Radius.Color)
            SetBlipPriority(radius, 0.0)
        end)
        -- zone
        local function someMath()
            CreateThread(function()
                local npc = GetEntityCoords(Ped)
                local pl = GetEntityCoords(PlayerPedId())
                if (#(pl - npc) < 1.3) then
                    --- When the player is in range lets set a boolean true
                    switch = true
                else
                    switch = false
                end
            end)
        end

        circleSmall:onPlayerInOut(function(isPointInside)
            if isPointInside then
                someMath()
            else
                switch = false -- Lets put this here just in case
            end
        end)

        -- display
        local function DrawText3D(x, y, z, text)
            SetTextScale(0.35, 0.35)
            SetTextFont(4)
            SetTextProportional(true)
            SetTextColour(255, 255, 255, 215)
            SetTextEntry("STRING")
            SetTextCentre(true)
            AddTextComponentString(text)
            SetDrawOrigin(x, y, z, 0)
            DrawText(0.0, 0.0)
            local factor = (string.len(text)) / 370
            DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
            ClearDrawOrigin()
        end

        CreateThread(function(coords)
            if Config.FloatingMessage.Show then
                coords = vec3(SmallCenter.x, SmallCenter.y, Zones.z + 1)
                if not FlMsgLck then
                    FlMsgLck = true
                    while true do
                        local npc = GetEntityCoords(Ped)
                        local pl = GetEntityCoords(PlayerPedId())
                        if #(pl - npc) <= 2 then
                            DrawText3D(coords.x, coords.y, coords.z, Config.FloatingMessage.Label)
                        end
                        Wait(5)
                    end
                end
            end
        end)

        -- Error Handling
        local function Deletion()
            DeletePed(Ped)
            circleBig:destroy()
            circleSmall:destroy()
            locked = false
            switch = false
            FlMsgLck = false
            ClearFloatingHelp(1, true)
            EndTextCommandDisplayHelp(2, false, false, -1)
            RemoveBlip(blip)
            RemoveBlip(radius)
        end

        --https://cookbook.fivem.net/2020/01/06/using-the-new-console-key-bindings/
        RegisterCommand('+EntyGenius', function()
            --- If switch is true will throw a event
            if switch then
                TriggerEvent(Config.Notify.Win.Event, Config.Notify.Win.Text, Config.Notify.Win.Type,
                    Config.Notify.Win.Time)
                QBCore.Functions.TriggerCallback('sendnudes', function(returnValue, gang)
                    if returnValue then
                        print(gang)
                        TriggerEvent('chatMessage', "", { 0, 128, 255 }, gang .. " claimed the land!")
                    end
                end)
                Deletion()
            end
        end, false)

        -- when switch is true and someone press the E key will throw the event
        RegisterKeyMapping('+EntyGenius', 'Interaction', 'keyboard', 'e')

        AddEventHandler('onResourceStop', function(resourceName)
            if (GetCurrentResourceName() ~= resourceName) then
                return
            end
            Deletion()
        end)
    elseif locked then
        TriggerEvent(Config.Notify.Error.Event, Config.Notify.Error.Text, Config.Notify.Error.Type,
            Config.Notify.Error.Time)
    end
end)
