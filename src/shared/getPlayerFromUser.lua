local function getPlayerByUsernamePartial(partialInput)
	if partialInput == nil then warn(
		'Oops! You forgot to pass in a partial username. | getPlayerByUsernamePartial.lua'
	); return nil end
    local matchingPlayers = {}

    for _, player in ipairs(game.Players:GetPlayers()) do
        if string.sub(string.lower(player.Name), 1, #partialInput) == string.lower(partialInput) then
            table.insert(matchingPlayers, player.Name)
        end
    end

    if #matchingPlayers > 0 then
        return matchingPlayers
    else
        return nil
    end
end


return getPlayerByUsernamePartial