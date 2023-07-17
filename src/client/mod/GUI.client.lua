print('Hello from GUI.client.lua')

-- Variables
local GUI = script.Parent
local kickButton = GUI:WaitForChild('KickButton')
local banButton = GUI:WaitForChild('BanButton')

-- Services
local getPlayerByUsernamePartial = require(game.ReplicatedStorage.Shared:WaitForChild('getPlayerFromUser'))
local ReplicatedStorage = game:GetService('ReplicatedStorage')

-- Events
local kickEvent = ReplicatedStorage:WaitForChild('KickEvent')
local banEvent = ReplicatedStorage:WaitForChild('BanEvent')

-- Main
kickButton.MouseButton1Click:Connect(function()
	local playerToKick = getPlayerByUsernamePartial(GUI:WaitForChild('PlayerToKick').Text)
	if playerToKick then
		if #playerToKick == 1 then -- Only one player found
			kickEvent:FireServer(playerToKick[1])
		else
			warn('Multiple players found with that username. | %s', table.concat(playerToKick, ', '))
		end
	else
		warn('No players found with that username. | %s', GUI:WaitForChild('PlayerToKick').Text)
	end
end)

banButton.MouseButton1Click:Connect(function()
	local playerToBan = getPlayerByUsernamePartial(GUI:WaitForChild('PlayerToBan').Text)
	if playerToBan then
		if #playerToBan == 1 then -- Only one player found
			banEvent:FireServer(playerToBan[1])
		else
			warn('Multiple players found with that username. | %s', table.concat(playerToBan, ', '))
		end
	else
		warn('No players found with that username. | %s', GUI:WaitForChild('PlayerToBan').Text)
	end
end)