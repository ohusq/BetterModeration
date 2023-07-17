-- Server is used for security reasons.

-- Settings
local Settings = {
	moderation_access = {
		-- Input your userIDs here (NOT IN STRINGS)
		-- Example: 123456789
		2773194693; -- ohusq (me, testing)
	}
}
-- Services
local banDataStores = require(game.ReplicatedStorage.Shared:WaitForChild('banDataStores'))
local getPlayerByUsernamePartial = require(game.ReplicatedStorage.Shared:WaitForChild('getPlayerFromUser'))
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- Events
local kickEvent = ReplicatedStorage:WaitForChild('KickEvent')
local banEvent = ReplicatedStorage:WaitForChild('BanEvent')

-- Functions
local function hasModerationAccess(player) -- Checks if player has moderation access (returns true or false)
	for _, userID in ipairs(Settings.moderation_access) do
		if player.UserId == userID then
			return true
		end
	end
	return false
end

-- Main
kickEvent.OnServerEvent:Connect(function(user, player, reason) -- reason might be added later as a textbox
	if reason == nil then 	 reason = 'Kicked by staff member.' 		end
	if hasModerationAccess(user) then
		local playerToKick = getPlayerByUsernamePartial(player)
		if playerToKick then
			if #playerToKick == 1 then -- Only one player found
				Players[playerToKick[1]]:Kick(reason)
			else
				warn('Multiple players found with that username. | %s', table.concat(playerToKick, ', '))
			end
		else
			warn('No players found with that username. | %s', player)
		end
	else
		warn('You do not have moderation access. | Banning exploiter who ran this script.')
		local playerToBan = getPlayerByUsernamePartial(player)
		if playerToBan then
			if #playerToBan == 1 then -- Only one player found
				local banSuccess = banDataStores.banPlayer(Players:FindFirstChild(playerToBan[1]), 'Exploiting')
				if banSuccess then
					Players:Kick(playerToBan[1])
				else
					warn('Player is already banned. | Banning exploiter who ran this script.')
					banDataStores.banPlayer(Players:FindFirstChild(player), 'Exploiting')
					Players:Kick(player)
				end
			else
				warn('Multiple players found with that username. | %s', table.concat(playerToBan, ', '))
			end
		else
			warn('No players found with that username. | %s', player)
		end
	end
end)

banEvent.OnServerEvent:Connect(function(user, player, reason)
	if reason == nil then 	 reason = 'Banned by staff member.' 		end
	if hasModerationAccess(user) then
		local playerToBan = getPlayerByUsernamePartial(player)
		if playerToBan then
			if #playerToBan == 1 then -- Only one player found
				local banSuccess = banDataStores.banPlayer(Players:FindFirstChild(playerToBan[1]), reason)
				if banSuccess then
					Players[playerToBan[1]]:Kick(reason)
				else
					warn('Player is already banned.')
				end
			else
				warn('Multiple players found with that username. | %s', table.concat(playerToBan, ', '))
			end
		else
			warn('No players found with that username. | %s', player)
		end
	else
		warn('You do not have moderation access.')
	end
end)

Players.PlayerAdded:Connect(function(player)
	local banDataStore = banDataStores[player.UserId]
	if banDataStore then
		local banData = banDataStore:GetAsync('banData')
		if banData then
			if banData.banned then
				player:Kick(banData.reason) -- DOESNT WORK YET | TODO: Fix this
			else
				print('Player is not banned.')
			end
		end
	else
		banDataStores[player.UserId] = game:GetService('DataStoreService'):GetDataStore('banData_' .. player.UserId)
	end
end)

--[[
Made by ohusq

UNBAN VIA CONSOLE (incase you made an oopsie):
local userId = 123456789
game:GetService('DataStoreService'):GetDataStore('banData_' .. userId):SetAsync('banData', {
	banned = false; -- Unban player
})

]]