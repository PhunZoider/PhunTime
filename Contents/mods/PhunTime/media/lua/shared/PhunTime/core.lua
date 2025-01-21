local climateManager = nil
local gt = nil

PhunTime = {
    name = "PhunTime",
    events = {
        OnNightStart = "OnPhunNightStart",
        OnDayStart = "OnPhunDayStart"
    },
    commands = {
        onStart = "PhunTimeStart",
        daytimeStart = "PhunTimeDaytimeStart",
        nightTimeStart = "PhunTimeNightTimeStart"
    },
    settings = {},
    dawnTime = 0,
    duskTime = 0,
    isNight = nil
}

local Core = PhunTime
Core.settings = SandboxVars[Core.name] or {}
-- Setup any events
for _, event in pairs(Core.events) do
    if not Events[event] then
        LuaEventManager.AddEvent(event)
    end
end

function Core:ini()
    if not self.inied then
        self.inied = true
        self:testNight()
    end

end

function Core:setIsNight(value)

    if isServer() then
        sendServerCommand(Core.name, value and Core.commands.nightTimeStart or Core.commands.daytimeStart, {})
    end
    self.isNight = value
    local speed = Core.settings.DaySpeed
    if value then
        speed = Core.settings.NightSpeed
    end
    getSandboxOptions():getOptionByName("DayLength"):setValue(speed)
    getSandboxOptions():applySettings()
    triggerEvent(value and self.events.OnNightStart or self.events.OnDayStart)

end

function Core:testNight()

    if not climateManager and getClimateManager then
        climateManager = getClimateManager()
    end
    if not gt and getGameTime then
        gt = getGameTime()
    end
    if gt and climateManager and climateManager.getSeason then

        local season = climateManager:getSeason()
        if season and season.getDawn then
            local time = gt:getTimeOfDay()
            self.dawnTime = season:getDawn() + Core.settings.DayOffset
            self.duskTime = season:getDusk() + Core.settings.NightOffset
        end
    end
    if self.duskTime and self.dawnTime then
        local currentTime = gt:getTimeOfDay()
        local night = currentTime > self.duskTime or currentTime < self.dawnTime
        if night ~= self.isNight then
            self:setIsNight(night)
        end
    end
end
