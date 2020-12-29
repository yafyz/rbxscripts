--writefile("cc2autofarmv3.lua", game:HttpGet("https://raw.githubusercontent.com/yafyz/rbxscripts/master/cc2/autofarm.lua"))
--if not pcall(function() 
--    readfile("cc2autofarm_settings.json")
--end) then 
--    writefile("cc2autofarm_settings.json", [[{"Auto-Rebirth":false}]])
--end
--loadfile("cc2autofarmv3.lua")()
local gui = Instance.new("ScreenGui", game.CoreGui)
local label = Instance.new("TextLabel", gui)
label.Text = "broken because roblox wants authentication now when you request server list"
label.TextWrapped = true
label.Size = UDim2.new(0,250,0,200)
