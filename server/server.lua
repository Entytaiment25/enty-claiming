local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.Command.Name, Config.Command.Description, {}, false, function(source, args)
    local src = source
    TriggerClientEvent('ClaimEvent', src)
end)