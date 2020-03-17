writefile("cc2autofarmv3.lua", game:HttpGet("https://raw.githubusercontent.com/yafyz/rbxscripts/master/cc2/autofarm.lua"))
if not pcall(function() 
    readfile("cc2autofarm_settings.lua")
end) then 
    writefile("cc2autofarm_settings.lua", [[{"Auto-Rebirth":false}]])
end
loadfile("cc2autofarmv3.lua")()
