local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.Command.Name, Config.Command.Description, {}, false, function(source, args)
    local src = source
    TriggerClientEvent('ClaimEvent', src)
end)

QBCore.Functions.CreateCallback('sendnudes', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local gang = Player.PlayerData.gang.name
    print(gang)
    cb(true, gang) -- tell the client that he can do stuff
end)
