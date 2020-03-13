syn.queue_on_teleport(readfile("cc2autofarmv3.lua"))
repeat wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer
repeat wait() until plr.Character
plr.Character:WaitForChild("HumanoidRootPart")
plr.Character:WaitForChild("LeftFoot")

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function CollectShell()
    local shell = game.Workspace:FindFirstChild("Shell")
    assert(shell, "No Shell")
    shell.CFrame = plr.Character.LeftFoot.CFrame
    repeat wait() until not shell.Parent
end
local function getUri(startIndex) return "https://www.roblox.com/games/getgameinstancesjson?placeId=" .. tostring(game.PlaceId) .. "&startIndex=" .. tostring(startIndex) end

local servers = TeleportService:GetTeleportSetting("servers")
local function checkServers()
	if not servers or #servers == 0 then
		servers = {}
		local max = tonumber(HttpService:JSONDecode(game:HttpGet(getUri(0)))["TotalCollectionSize"])
		for i=0, max,10 do
			local resp = HttpService:JSONDecode(game:HttpGet(getUri(i)))
			if #resp["Collection"] == 0 then break end
			for _,y in next, resp["Collection"] do
				table.insert(servers, y["Guid"])
				pcall(function() plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. #servers end)
			end
		end
	end
end
checkServers()

TeleportService.TeleportInitFailed:Connect(function()
	checkServers()
    local nextServer = servers[#servers]
    table.remove(servers, #servers)
    pcall(function() plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. tostring(#servers) .. ", " .. tostring(suc) .. " " .. tostring(ret) end)
    TeleportService:SetTeleportSetting("servers", servers)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, nextServer)
end)

local suc, ret = pcall(CollectShell)
local thisServer = servers[#servers]
table.remove(servers, #servers)
pcall(function() plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. tostring(#servers) .. ", " .. tostring(suc) .. " " .. tostring(ret) end)
TeleportService:SetTeleportSetting("servers", servers)
TeleportService:TeleportToPlaceInstance(game.PlaceId, thisServer)
