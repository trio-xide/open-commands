-- Configuration
local permissionLevel = 200;
local description = "Kicks a user from the server.";
local utilities

--[[

	Command: Kick
	Description: User can kick a player from the server if the user's permissionLevel is higher than the target's.
	
]]


local function action(caller, parameters)
	local targets = {}

	for _, parameter in pairs(parameters) do
		local target = utilities.findPlayerByString(caller, parameter)
		if (type(target) == "table") then
			targets = target
			break
		end

		table.insert(targets, target)
	end

	local callerPermissionLevel = utilities.getUserPermissionLevel(caller)
	for _, target in pairs(targets) do
		local targetPermissionLevel = utilities.getUserPermissionLevel(target)
		if (callerPermissionLevel > targetPermissionLevel) then
			print("Kicked " .. target.Name)
		end
	end
end

local function unaction()
end

local function setUtilities(utils)
	utilities = utils
end

return {
    ["permissionLevel"] = permissionLevel,
    ["description"] = description,
	["action"] = action,
	["setUtilities"] = setUtilities
}
