local Gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/yafyz/guiframework/master/main.lua"))()
local gui = Gui.new(game.CoreGui, 'cc2haxx')

local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local mouse = game.Players.LocalPlayer:GetMouse()

local OrangeColor = Color3.fromRGB(255, 181, 7)
local BlackColor = Color3.new(0,0,0)
local GreenColor = Color3.fromRGB(0, 255, 136)

local moveCon

gui:SetColor(Color3.new(1, 1, 1))
gui:SetTitle("CC2haxx", "0.1")

gui:CreateTab("Car stuff", {nil, {.3, 'Transparency', 'BackgroundColor3'}, 1})

local CarStuff = {
    thrust = gui:CreateButtonUnderTab("Car stuff", "Thrust", "Thrust (g)").frame,
    highlight = gui:CreateButtonUnderTab("Car stuff", "Highlight Car", "Highlight Car").frame,
    spin = gui:CreateButtonUnderTab("Car stuff", "Car Spin", "Car Spin (j)").frame,
    movecar = gui:CreateButtonUnderTab("Car stuff", "Move Car", "Move Car (h)").frame
}

function CalculateSpeed (Weight, Speed)
	return math.abs(Weight - 60) * Speed
end

local function ThrustHandler(actionName, inputState, inputObject)
    local car = game.Workspace.CarCollection:FindFirstChild(game.Players.LocalPlayer.Name)
    if not car then return end
    if inputState == Enum.UserInputState.Begin then
        Instance.new("BodyThrust", car.Car.PrimaryPart).Force = Vector3.new(200000, 0, 0)
        CarStuff.thrust.TextColor3 = OrangeColor
    else
        CarStuff.thrust.TextColor3 = BlackColor
        car.Car.PrimaryPart.BodyThrust:Destroy()
    end
end

local function HighlightCar()
    local car = game.Workspace.CarCollection:FindFirstChild(game.Players.LocalPlayer.Name)
    if not car then return end
	for i,v in pairs(car.Car:GetDescendants()) do
		if v.ClassName == "MeshPart" or v.ClassName == "Part" and not v:FindFirstChild("SelectionBox") then
			local box = Instance.new("SelectionBox")
			box.Adornee = v
			box.Color3 = GreenColor
			box.SurfaceColor3 = GreenColor
			box.Parent = v
		end
	end
end

local function CarSpin(actionName, inputState, inputObject)
    local car = game.Workspace.CarCollection:FindFirstChild(game.Players.LocalPlayer.Name)
    if not car then return end
    if inputState == Enum.UserInputState.Begin then
		local CarVelocity = Instance.new("BodyAngularVelocity", car.Car.PrimaryPart)
    	CarVelocity.MaxTorque = Vector3.new(0,40000000000,0)
        CarVelocity.AngularVelocity = Vector3.new(0, CalculateSpeed(car.Weight.Value, 1),0)
        CarStuff.spin.TextColor3 = OrangeColor
    else
        CarStuff.spin.TextColor3 = BlackColor
        car.Car.PrimaryPart.BodyAngularVelocity:Destroy()
    end
end

local function MoveCar(actionName, inputState, inputObject)
    local car = game.Workspace.CarCollection:FindFirstChild(game.Players.LocalPlayer.Name)
    if not car then return end
    if inputState == Enum.UserInputState.Begin then
	    local pos = Instance.new("BodyPosition", car.Car.PrimaryPart)
	    pos.MaxForce = Vector3.new(400000000,100000,400000000)
        moveCon = RunService.RenderStepped:Connect(function()
            if not pos or not pos.Parent then moveCon:Disconnect() return end
	    	pos.Position = mouse.Hit.p
        end)
        CarStuff.movecar.TextColor3 = OrangeColor
    else
        CarStuff.movecar.TextColor3 = BlackColor
        moveCon:Disconnect()
		car.Car.PrimaryPart.BodyPosition:Destroy()
    end
end

ContextActionService:BindAction("ThrustHandler", ThrustHandler, true, Enum.KeyCode.G)
CarStuff.highlight.MouseButton1Click:Connect(HighlightCar)
ContextActionService:BindAction("CarSpin", CarSpin, true, Enum.KeyCode.J)
ContextActionService:BindAction("MoveCar", MoveCar, true, Enum.KeyCode.H)

gui:CreateTab("Collect Powerups", {nil, {.3, 'Transparency', 'BackgroundColor3'}, 1})
local CollectPowerup = {
    enable = gui:CreateButtonUnderTab("Collect Powerups", "enable", "Enable").frame,
}

local pupCollectCon
local mapChangeDetectCon
local function TogglePuPCollect()
    if not pupCollectCon then
        pupCollectCon = game.Workspace.Map.PowerupLocations.DescendantAdded:Connect(function(desc)
            if desc.Name == "Powerup" then
                --local ptype = desc:WaitForChild("Type").Value
                local car = game.Workspace.CarCollection:FindFirstChild(game.Players.LocalPlayer.Name)
                if not car then return end
                desc.CFrame = car.Car.Body.Parts:FindFirstChildWhichIsA("Part").CFrame
            end
        end)
        mapChangeDetectCon = game.Workspace.Map.PowerupLocations.AncestryChanged:Connect(function()
            TogglePuPCollect()
            TogglePuPCollect()
        end)
        CollectPowerup.enable.TextColor3 = OrangeColor
    else
        CollectPowerup.enable.TextColor3 = BlackColor
        pupCollectCon:Disconnect()
        pupCollectCon = nil
        if mapChangeDetectCon then mapChangeDetectCon:Disconnect() end
    end
end
CollectPowerup.enable.MouseButton1Click:Connect(TogglePuPCollect)

if game.PlaceId == 654732683 then
    gui:CreateTab("Autofarm", {nil, {.3, 'Transparency', 'BackgroundColor3'}, 1})
    local Autofarm = {
        start = gui:CreateButtonUnderTab("Autofarm", "start", "Start Autofarm").frame,
        autorebirth = gui:CreateButtonUnderTab("Autofarm", "autorebirth", "Auto Rebirth").frame
    }
    if not pcall(function()
        readfile("cc2autofarm_settings.json")
    end) then
        writefile("cc2autofarm_settings.json", [[{"Auto-Rebirth":false}]])
    end
    local set = HttpService:JSONDecode(readfile("cc2autofarm_settings.json"))
    if set["Auto-Rebirth"] == true then Autofarm.autorebirth.TextColor3 = OrangeColor end
    local function ToggleAutoRebirth()
        if set["Auto-Rebirth"] == true then
            set["Auto-Rebirth"] = false
            Autofarm.autorebirth.TextColor3 = BlackColor
        else
            set["Auto-Rebirth"] = true
            Autofarm.autorebirth.TextColor3 = OrangeColor
        end
        writefile("cc2autofarm_settings.json", HttpService:JSONEncode(set))
    end
    local autofarmStarted
    local function StartAutofarm()
        if autofarmStarted then return end
        autofarmStarted = true
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yafyz/rbxscripts/master/cc2/autofarm_loader.lua"))()
    end
    Autofarm.start.MouseButton1Click:Connect(StartAutofarm)
    Autofarm.autorebirth.MouseButton1Click:Connect(ToggleAutoRebirth)
end
