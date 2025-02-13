if isServer() then
    return
end
local Core = PhunTime

Events.OnServerCommand.Add(function(module, command, arguments)
    if module == Core.name then
        Core:setIsNight(command == Core.commands.nightTimeStart)
    end
end)

Events.OnCreatePlayer.Add(function(player)
    Core:ini()
end)

Events[Core.events.OnNightStart].Add(function()
    print("Night started")
end)

Events[Core.events.OnDayStart].Add(function()
    print("Day started")
end)
