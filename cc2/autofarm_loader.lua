writefile("cc2autofarmv3.lua", game:HttpGet("https://raw.githubusercontent.com/yafyz/rbxscripts/master/cc2/autofarm.lua"))
if not pcall(function() 
    readfile("cc2autofarm_settings.json")
end) then 
    writefile("cc2autofarm_settings.json", [[{"Auto-Rebirth":false}]])
end
loadfile("cc2autofarmv3.lua")()
