
local Orion = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()


local window = Orion:MakeWindow({Name = "Combat", HidePremium = false, SaveConfig = false})







local Combat = window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local interactionRemote = ReplicatedStorage.remoteInterface.interactions.meleePlayer
local worldResources = workspace.worldResources.choppable
local isToggled = false
local mineAuraActive = false
local remoteArgs = {[1] = 1, [2] = nil}


-- Function to find closest player
local function getClosestPlayer()
    local shortestDistance = math.huge
    local closestPlayer = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

-- Toggle Functionality
Combat:AddToggle({
    Name = "Kill Aura",
    Default = false,
    Callback = function(value)
        isToggled = value
        if isToggled then
            while isToggled and wait(0.01) do
                local closestPlayer = getClosestPlayer()
                if closestPlayer then
                    remoteArgs[2] = closestPlayer
                    interactionRemote:FireServer(unpack(remoteArgs))
                end
            end
        end
    end
})


local firing = false
local function fireRemote()
    local args = {
        [1] = 1,
        [2] = workspace.AI_Server:FindFirstChild("The Titan")
    }
    while firing do
        game:GetService("ReplicatedStorage").remoteInterface.interactions.meleeAI:FireServer(unpack(args))
        wait(0.1)
    end
end

Combat:AddToggle({
    Name = "Titan Kill Aura",
    Default = false,
    Callback = function(value)
        firing = value
        if firing then
            task.spawn(fireRemote)
        end
    end
})


Combat:AddButton({
    Name = "Remove AI Damage",
    Callback = function()
        local remotePath = game:GetService("ReplicatedStorage").remoteInterface.character.hurtByAIAttack
        if remotePath then
            remotePath:Destroy()
        end
    end
})


Combat:AddButton({
    Name = "Remove Fall Damage",
    Callback = function()
        local remotePath = game:GetService("ReplicatedStorage").remoteInterface.character.FallDamage
        if remotePath then
            remotePath:Destroy()
        end
    end
})


local Player = window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://7733960981",
    PremiumOnly = false
})


local infstamina = false
local function infstaminaf()
    while infstamina do
          task.wait()
   game:GetService("Players").LocalPlayer:SetAttribute("stamina", 1)
    end
end



Player:AddToggle({
    Name = "Inf Stamina",
    Default = false,
    Callback = function(value)
        infstamina = value
        if infstamina then
            task.spawn(infstaminaf)
        end
    end
})






local function mineNearbyResources()
    local playerPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    if playerPosition then
        
        for _, folder in ipairs(workspace.worldResources.choppable:GetChildren()) do
            
            for _, model in ipairs(folder:GetChildren()) do
                if (model:IsA("Model") or model:IsA("Part")) and (model.WorldPivot.Position - playerPosition).magnitude <= 40 then
                    local args = {
                        [1] = 1,
                        [2] = model,
                        [3] = CFrame.new(-2402.89404296875, 25.262937545776367, 593.9114990234375) * CFrame.Angles(3.141592502593994, 0.08492205291986465, -3.141592502593994)
                    }
                    game:GetService("ReplicatedStorage").remoteInterface.interactions.chop:FireServer(unpack(args))
                    wait(0.3)  
                end
            end
        end
    end
end

Player:AddToggle({
    Name = "Mine Aura",
    Default = false,
    Callback = function(value)
        mineAuraActive = value
        if mineAuraActive then
            task.spawn(function()
                while mineAuraActive and wait(0.01) do
                    mineNearbyResources()
                end
            end)
        end
    end
})

local function collectNearbyItems()
    local playerCharacter = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
    local playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart")

    local function processItems()
        for _, item in ipairs(workspace.droppedItems:GetChildren()) do
            if (item:IsA("Part") or item:IsA("MeshPart")) and (item.Position - playerHumanoidRootPart.Position).magnitude <= 20 then
                -- Fire the touch interest event
                firetouchinterest(playerHumanoidRootPart, item, 1)
                firetouchinterest(playerHumanoidRootPart, item, 0) 
                wait(0.1) 
            end
        end
    end

   
    while itemCollectionActive and wait(0.01) do
        processItems()
    end
end


Combat:AddToggle({
    Name = "Auto Pickup",
    Default = false,
    Callback = function(value)
        itemCollectionActive = value
        if itemCollectionActive then
            
            task.spawn(collectNearbyItems)
        end
    end
})

