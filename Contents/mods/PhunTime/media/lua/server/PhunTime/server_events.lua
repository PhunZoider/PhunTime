if isClient() then
    return
end
local Core = PhunTime

Events.EveryOneMinute.Add(function()
    Core:testNight()
end)

Events.OnServerStarted.Add(function()
    Core:testNight()
end)
