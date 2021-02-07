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
	local set = HttpService:JSONDecode(readfile("cc2autofarm_settings.json"))
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

local servers = TeleportService:GetTeleportSetting("servers");

local function getUri(placeId, cursor)
    return string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100&cursor=%s", placeId, cursor);
end

local function checkServers()
    if not servers or #servers == 0 then
        servers = {};
        local cursor = "";
        while true do
            local data = HttpService:JSONDecode(game:HttpGet(getUri(game.placeId, cursor)));
            for _,v in next, data["data"] do
                table.insert(servers, v["id"]) end;
			pcall(function()
				plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. #servers;
				plr.PlayerGui.Screen.Twitter.TextColor3 = Color3.new(1,1, 0);
			end);
            if (not data["nextPageCursor"] or data["nextPageCursor"] == cursor) then
                break end;
            cursor = data["nextPageCursor"];
        end
    end
end

checkServers();

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
if not pcall(CheckRebirth) then
	pcall(function()
		writefile("cc2autofarm_settings.json", [[{"Auto-Rebirth":false}]])
	end)
end
local thisServer = servers[#servers]
table.remove(servers, #servers)
pcall(function() 
	plr.PlayerGui.Screen.Twitter.Text = "Collected Servers: " .. tostring(#servers) .. ", " .. tostring(suc) .. " " .. tostring(ret) 
	plr.PlayerGui.Screen.Twitter.TextColor3 = Color3.new(1,1, 0)
end)
TeleportService:SetTeleportSetting("servers", servers)
TeleportService:TeleportToPlaceInstance(game.PlaceId, thisServer)
