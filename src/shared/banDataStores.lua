local banDataStores = {}

local function isPlayerBanned(player)-- Check if player is banned (returns true or false)
	local banDataStore = banDataStores[player.UserId]
	if banDataStore then
		local banData = banDataStore:GetAsync('banData')
		if banData then
			if banData.banned then
				return true -- Player is banned
			else
				return false -- Player is not banned
			end
		else
			return false -- If this happends, were fucked because roblox's datastore services are down
		end
	else
		return false
	end
end

local function banPlayer(player, reason)-- Ban player (returns true or false) 
	local banDataStore = banDataStores[player.UserId]
	if banDataStore then
		local banData = banDataStore:GetAsync('banData')
		if banData then
			if banData.banned then
				return false -- Player is already banned
			else
				banDataStore:SetAsync('banData', {
					banned = true;
					reason = reason;
				})
				return true
			end
		else
			banDataStore:SetAsync('banData', {
				banned = true;
				reason = reason;
			})
			return true
		end
	else
		banDataStores[player.UserId] = game:GetService('DataStoreService'):GetDataStore('banData_' .. player.UserId)
		banDataStore = banDataStores[player.UserId]
		banDataStore:SetAsync('banData', {
			banned = true;
			reason = reason;
		})
		return true
	end
end

local function unbanPlayer(player)
	local banDataStore = banDataStores[player.UserId]
	if banDataStore then
		local banData = banDataStore:GetAsync('banData')
		if banData then
			if banData.banned then
				return false -- Player is unbanned already
			else
				banDataStore:SetAsync('banData', {
					banned = false; -- Unban player
				})
				return true
			end
		else
			banDataStore:SetAsync('banData', {
				banned = false; -- Unban player (just in case)
			})
			return true
		end
	else
		banDataStores[player.UserId] = game:GetService('DataStoreService'):GetDataStore('banData_' .. player.UserId)
		banDataStore = banDataStores[player.UserId]
		banDataStore:SetAsync('banData', {
			banned = false; -- Unban player (just in case)
		})
		return true
	end
end

local banDataStores = { -- Makes it so you can call the functions from other scripts
	isPlayerBanned = isPlayerBanned;
	banPlayer = banPlayer;
	unbanPlayer = unbanPlayer;
}


return banDataStores