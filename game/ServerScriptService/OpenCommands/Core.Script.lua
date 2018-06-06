--[[

    ~ OpenCommands
        ~ by Trioxide

]]


local get = game.GetService

-- Services
local players = get(game, "Players")
local serverScriptService = get(game, "ServerScriptService")

-- OpenCommands
local openCommands = serverScriptService:WaitForChild("OpenCommands")
local commandModules = openCommands:WaitForChild("Commands")
local configuration = openCommands:WaitForChild("Configuration")

local utilities = require(openCommands:WaitForChild("Utilities"))
local permissions = require(configuration:WaitForChild("Permissions"))
local settings = require(configuration:WaitForChild("Settings"))

local onServerStart = {}
local onPlayerJoin = {}
local onPlayerLeave = {}
local commands = {}

-- Functions
local function parse(str)
    local words = {}
    
    for word in string.gmatch(str, "%a+") do
        table.insert(words, word)
    end

    return table.remove(words, 1), words
end

local function runCommand(player, str)
    print(player, str)
    local commandName, parameters = parse(str)
    local command = utilities.isCommand(commands, commandName)

    if (not command) then
        return
    end
    
    if (utilities.hasPermissionToExecute(player, command)) then
        command.action(player, parameters)
    else
        print(player.Name .. " has no permission to execute command " .. commandName)
    end
end

-- Set up
for _, module in pairs(commandModules:GetChildren()) do
    local command = require(module)
    command.setUtilities(utilities)

    if (command.onServerStart) then table.insert(onServerStart, command.onServerStart) end
    if (command.onPlayerJoin)  then table.insert(onServerStart, command.onPlayerJoin) end
    if (command.onPlayerLeave) then table.insert(onServerStart, command.onPlayerLeave) end

    commands[string.lower(module.Name)] = {
        name = module.Name,
        action = command.action,
        permissionLevel = command.permissionLevel,
        description = command.description
    }
end

-- Event listeners
players.PlayerAdded:connect(function(player)
    for _, command in pairs(onPlayerJoin) do
        command(player)
    end

    player.Chatted:connect(function(message)
        if (string.sub(message, 1, 1) == "!") then
            runCommand(player, string.sub(message, 2))
        end
    end)
end)

players.PlayerRemoving:connect(function(player)
    for _, command in pairs(onPlayerLeave) do
        command(player)
    end
end)
