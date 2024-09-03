
local Orion = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()


local window = Orion:MakeWindow({Name = "Combat", HidePremium = false, SaveConfig = false})


local Combat = window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
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
