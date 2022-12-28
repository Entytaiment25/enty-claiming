local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.Command.Name, Config.Command.Description, {}, false, function(source, args)
    local src = source
    TriggerClientEvent('ClaimEvent', src)
    local Player = QBCore.Functions.GetPlayer(src)
    local job = Player.PlayerData.gang.name
    print(Player, job)
end)