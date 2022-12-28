local QBCore = exports['qb-core']:GetCoreObject()
local switch = false
local locked = false
local FlMsgLck = false
RegisterNetEvent('ClaimEvent')
AddEventHandler('ClaimEvent', function(src)
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
        function ShowFloatingHelpNotification(msg, coords)
            AddTextEntry('MessageText', msg)
            SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
            SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
            BeginTextCommandDisplayHelp('MessageText')
            EndTextCommandDisplayHelp(2, false, false, -1)
        end

        CreateThread(function(coords)
            if Config.FloatingHelpText.Show then
                if not FlMsgLck then
                    FlMsgLck = true
                    local npc = GetEntityCoords(Ped)
                    local pl = GetEntityCoords(PlayerPedId())
                    if (#(pl - npc) < 3) then --FIX
                        print("ss")
                        while true do
                            print("1")
                            Wait(Config.FloatingHelpText.RefreshTime)
                            coords = vec3(SmallCenter.x, SmallCenter.y, Zones.z + 1)
                            ShowFloatingHelpNotification(Config.FloatingHelpText.Label, coords)
                        end
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
                TriggerEvent("chatMessage", "", { 255, 0, 0 }, "s")
                Deletion()
            end
        end, false)
        -- when switch is true and someone press the E key will throw the event
        RegisterKeyMapping('+EntyGenius', 'Interaction', 'keyboard', 'e')

        AddEventHandler('onResourceStop', function(resourceName)
            if (GetCurrentResourceName() ~= resourceName) then
                return
            end
            print('The resource ' .. resourceName .. ' was stopped.')
            Deletion()
        end)
    elseif locked then
        TriggerEvent(Config.Notify.Error.Event, Config.Notify.Error.Text, Config.Notify.Error.Type,
            Config.Notify.Error.Time)
    end
end)
