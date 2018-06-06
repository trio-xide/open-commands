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
local configuration = openCommands:WaitForChild("Configuration")

local permissions = require(configuration:WaitForChild("Permissions"))
local settings = require(configuration:WaitForChild("Settings"))

function isInTable(tab, object)
	for _, value in pairs(tab) do
		if (value == object) then
			return true
		end
	end
	return false
end

function isCommand(commands, str)
	for _, command in pairs(commands) do
		if (string.lower(str) == string.lower(command.name)) then
			return command
		end
	end

	return nil
end

function getUserPermissionLevel(player)
	local userPermissionLevel = 0
    for permissionLevel, data in pairs(permissions) do
        if (permissionLevel == 0) then
            return 0
        end
        
        if (isInTable(data.people, player.Name) or isInTable(data.people, player.UserId)) then
            return permissionLevel
        end
	end
	
	return 0
end

function hasPermissionToExecute(caller, command)
	local userPermissionLevel = getUserPermissionLevel(caller)
	return userPermissionLevel >= command.permissionLevel
end

function findPlayerByString(caller, str)
	str = string.lower(str)

	if (str == "all") then
		return players:GetPlayers()
	elseif (str == "others") then
		local playersToReturn = players:GetPlayers()
		for index, player in pairs(playersToReturn) do
			if (player == caller) then
				table.remove(playersToReturn, index)
				return playersToReturn
			end
		end
	else
		for _, player in pairs(players:GetPlayers()) do
			local playerName = string.lower(player.Name)
			if (string.find(playerName, str)) then
				return player
			end
		end
	end

	return nil
end

return {
	["isCommand"] = isCommand,
	["getUserPermissionLevel"] = getUserPermissionLevel,
	["hasPermissionToExecute"] = hasPermissionToExecute,
	["findPlayerByString"] = findPlayerByString
}