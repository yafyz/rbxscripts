syn.queue_on_teleport(readfile("cc2autofarmv3.lua"))
repeat wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
repeat wait() until plr.Character
plr.Character:WaitForChild("HumanoidRootPart")

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function CollectShell()
    local shell = game.Workspace:FindFirstChild("Shell")
    assert(shell, "No Shell")
    shell.CFrame = plr.Character.HumanoidRootPart.CFrame
    repeat wait() until not shell.Parent
end
local function CheckRebirth()
	local set = HttpService:JSONDecode(readfile("cc2autofarm_settings.lua"))
	local tokens, money = plr.leaderstats.Tokens.Value, plr.Money.Value
	local t1, t2, t3, t4 = 40000000000, 200000000000 , 450000000000, 1500000000000
	print(set["Auto-Rebirth"])
	if set["Auto-Rebirth"] == true then
		if tokens == 0 and money >= t1 then
			game:GetService("ReplicatedStorage").rF.Transfer:InvokeServer()
		elseif tokens == 1 and money >= t2 then
			game:GetService("ReplicatedStorage").rF.Transfer:InvokeServer()
		elseif tokens == 2 and money >= t3 then
			game:GetService("ReplicatedStorage").rF.Transfer:InvokeServer()
		elseif tokens == 3 and money >= t4 then
			game:GetService("ReplicatedStorage").rF.Transfer:InvokeServer()
		end
	end
end
local function getUri(startIndex) 
	return "https://www.roblox.com/games/getgameinstancesjson?placeId=" .. tostring(game.PlaceId) .. "&startIndex=" .. tostring(startIndex)
end

local servers = TeleportService:GetTeleportSetting("servers")
local function checkServers()
	if not servers or #servers == 0 then
		servers = {}
		print("scraping servers retard, script works, your brain not, unless there is an error below from", script.Name)
		local max = tonumber(HttpService:JSONDecode(game:HttpGet(getUri(0)))["TotalCollectionSize"])
		for i=0, max,10 do
			local resp = HttpService:JSONDecode(game:HttpGet(getUri(i)))
			if #resp["Collection"] == 0 then break end
			for _,y in next, resp["Collection"] do
				table.insert(servers, y["Guid"])
				pcall(function() 
					plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. #servers 
					plr.PlayerGui.Screen.Twitter.TextColor3 = Color3.new(1,1, 0)
				end)
			end
		end
		for i=1, max / 10 do
			table.remove(servers, #servers)
		end
	end
end
checkServers()

TeleportService.TeleportInitFailed:Connect(function()
	checkServers()
    local nextServer = servers[#servers]
    table.remove(servers, #servers)
    pcall(function() 
		plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. tostring(#servers) .. ", " .. tostring(suc) .. " " .. tostring(ret) 
		plr.PlayerGui.Screen.Twitter.TextColor3 = Color3.new(1,1, 0)
	end)
    TeleportService:SetTeleportSetting("servers", servers)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, nextServer)
end)

local suc, ret = pcall(CollectShell)
pcall(CheckRebirth)
local thisServer = servers[#servers]
table.remove(servers, #servers)
pcall(function() 
	plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. tostring(#servers) .. ", " .. tostring(suc) .. " " .. tostring(ret) 
	plr.PlayerGui.Screen.Twitter.TextColor3 = Color3.new(1,1, 0)
end)
TeleportService:SetTeleportSetting("servers", servers)
TeleportService:TeleportToPlaceInstance(game.PlaceId, thisServer)
