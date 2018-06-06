-- Configuration
local permissionLevel = 0;
local description = "";

local function action()
end

local function unaction()
end

local function onServerStart()
end

local function onPlayerJoin(player)
end

local function onPlayerLeave(player)
end

return {
    ["permissionLevel"] = permissionLevel,
    ["description"] = description,
    ["action"] = action,
    ["unaction"] = unaction,
    ["onServerStart"] = onServerStart,
    ["onPlayerJoined"] = onPlayerJoined,
    ["onPlayerLeave"] = onPlayerLeave
}
