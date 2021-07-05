-- Generates a 'terrain' with math.noise / perlin noise.
--[[If you want...
local Player 
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character.HumanoidRootPart
]]
local Plate = workspace:FindFirstChild('Plate') -- A model that will contain all the parts belonging to the generation.
--[[For Terrain Generation...
local Terrain = workspace.Terrain
--Terrain:Clear()
]]

if Plate then -- If the Plate already exists, then clear it, since we don't want 2 perlin generations at once..
	Plate:ClearAllChildren()
else
	Plate = Instance.new('Model') 
	Plate.Parent = workspace
	Plate.Name = 'Plate'
end

local Origin = Instance.new('SpawnLocation') -- This is the part that will be used for generation. It is a SpawnLocation because this code was designed for "VBS" (Void's Script Builder), which has a part limit that can be "bypassed" by using SpawnLocations, although there still is a 1000/s limit.
Origin.Parent = Plate
Origin.Size = Vector3.new(1, 15, 1) -- Although this does modify the size of the Part (actually Basepart), it won't matter, since the code won't compensate for spacing dependent on size. The purpose of the Y axis being modified is to prevent gaps between a part and another, although this will depend on "Power".
Origin.Anchored = true
Origin.Enabled = false
Origin.Rotation = Vector3.new(0, 0, 0)

local Seed = math.random(1, 10e6) -- Treat these like Minecraft seeds. Different seeds will produce different results.
local Frequency = 4 -- The lower the frequency, the more "smooth" the plate is.
local Power = 30 -- The higher the power, the higher that the "terrain" can get.
local Resolution = 100 -- The size of the "terrain". Do note that the number given will multiply itself. Example: 30 (300 Parts)

for X = 1, Resolution do -- We start by making lines in the X axis.
	for Z = 1, Resolution do -- Then we make lines in the Z axis.
		local Step = game:GetService('RunService').Stepped -- Although this might sound weird, it really is not. This code is able to speed up the generation process (if the game you are in, has a part limit).
		if Z % math.random(1, 5) == 0 then
			Step:Wait()
		end
        -- Note: I (the writer) do not understand anything below, from "Y1" to "Y". This script's code was based off of a certain tutorial in the Developer Forum.
		local Y1 = math.noise(
		(X * Frequency) / Resolution,
		(Z * Frequency) / Resolution,
		Seed
		)

		local Y2 = math.noise(
		(X * Frequency * .125) / Resolution,
		(Z * Frequency * .125) / Resolution,
		Seed
		)

		local Y3 = math.noise(
		(X * Frequency * 4) / Resolution,
		(Z * Frequency * 4) / Resolution,
		Seed
		)

		local Y = (Y1 * Y2 * Power * Power) + Y3
		
		Origin = Origin:Clone()
		Origin.Parent = Plate
		Origin.CFrame = CFrame.new(X, Y, Z)

        --[[ For Terrain Generation...
        Terrain:FillBlock(
		CFrame.new(X, Y, Z), -- Coordinates in the world.
		Vector3.new(4, 4, 4),  -- Size.
		Enum.Material.Sand -- Material.
		)
        ]]
	end
end
