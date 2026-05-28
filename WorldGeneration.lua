-- WorldGeneration.lua
-- Minecraft-style procedural world generation

local WorldGen = {}
local G = getgenv()

-- ============ CONFIGURATION ============
WorldGen.Config = {
	-- World settings
	Seed = math.random(1, 999999),
	WorldSize = 100, -- Chunks in each direction (200x200 total chunks)
	ChunkSize = 16, -- Blocks per chunk (16x16)
	RenderDistance = 8, -- Chunks to render around player
	
	-- Terrain settings
	BaseHeight = 64,
	MountainHeight = 120,
	SeaLevel = 62,
	
	-- Generation settings
	CaveDensity = 0.02,
	TreeDensity = 0.005,
	OreDensity = {
		Coal = 0.01,
		Iron = 0.005,
		Gold = 0.002,
		Diamond = 0.0005,
		Emerald = 0.0002
	},
	
	-- Block IDs
	Blocks = {
		Air = 0,
		Stone = 1,
		Dirt = 2,
		Grass = 3,
		Sand = 4,
		Water = 5,
		Wood = 6,
		Leaves = 7,
		Cobblestone = 8,
		CoalOre = 9,
		IronOre = 10,
		GoldOre = 11,
		DiamondOre = 12,
		EmeraldOre = 13,
		Bedrock = 14,
		Planks = 15,
		Glass = 16
	},
	
	-- Colors for different blocks (for GUI/minimap)
	BlockColors = {
		[0] = Color3.fromRGB(0, 0, 0), -- Air
		[1] = Color3.fromRGB(128, 128, 128), -- Stone
		[2] = Color3.fromRGB(101, 67, 33), -- Dirt
		[3] = Color3.fromRGB(62, 109, 33), -- Grass
		[4] = Color3.fromRGB(219, 193, 108), -- Sand
		[5] = Color3.fromRGB(43, 92, 174), -- Water
		[6] = Color3.fromRGB(101, 67, 33), -- Wood
		[7] = Color3.fromRGB(50, 101, 25), -- Leaves
		[8] = Color3.fromRGB(111, 111, 111), -- Cobblestone
		[9] = Color3.fromRGB(35, 35, 35), -- Coal Ore
		[10] = Color3.fromRGB(184, 148, 96), -- Iron Ore
		[11] = Color3.fromRGB(248, 198, 45), -- Gold Ore
		[12] = Color3.fromRGB(83, 213, 245), -- Diamond Ore
		[13] = Color3.fromRGB(36, 214, 73), -- Emerald Ore
		[14] = Color3.fromRGB(35, 35, 35), -- Bedrock
		[15] = Color3.fromRGB(156, 110, 68), -- Planks
		[16] = Color3.fromRGB(166, 215, 247) -- Glass
	}
}

-- ============ NOISE GENERATION ============
local function noise2D(x, z, seed)
	local n = x * 374761393 + z * 668265263 + seed
	n = (n + 127) * 936827371
	n = n ~ n * 374761393
	return (n % 1000000) / 1000000
end

local function perlinNoise(x, z, seed, scale, octaves, persistence, lacunarity)
	local value = 0
	local amplitude = 1
	local frequency = scale
	local maxValue = 0
	
	for i = 1, octaves do
		local nx = x * frequency
		local nz = z * frequency
		
		local sample = noise2D(math.floor(nx * 1000), math.floor(nz * 1000), seed + i)
		value = value + sample * amplitude
		maxValue = maxValue + amplitude
		
		amplitude = amplitude * persistence
		frequency = frequency * lacunarity
	end
	
	return value / maxValue
end

-- ============ BIOME GENERATION ============
local function getBiome(x, z, seed)
	local tempNoise = perlinNoise(x, z, seed + 1000, 0.005, 3, 0.5, 2)
	local humidNoise = perlinNoise(x, z, seed + 2000, 0.005, 3, 0.5, 2)
	
	local temp = tempNoise * 2 - 1
	local humid = humidNoise * 2 - 1
	
	if temp < -0.5 then
		if humid < 0 then
			return "Tundra"
		else
			return "Taiga"
		end
	elseif temp < 0.5 then
		if humid < -0.5 then
			return "Desert"
		elseif humid < 0.5 then
			return "Plains"
		else
			return "Forest"
		end
	else
		if humid < 0 then
			return "Savanna"
		elseif humid < 0.5 then
			return "Jungle"
		else
			return "Swamp"
		end
	end
end

-- ============ HEIGHT GENERATION ============
local function getHeight(x, z, biome, seed)
	local baseHeight = WorldGen.Config.BaseHeight
	
	-- Terrain noise
	local heightNoise = perlinNoise(x, z, seed, 0.01, 4, 0.5, 2)
	local mountainNoise = perlinNoise(x, z, seed + 500, 0.005, 2, 0.5, 2)
	
	local height = baseHeight + heightNoise * 20
	
	-- Biome-specific height adjustments
	if biome == "Mountains" or biome == "Taiga" then
		height = height + mountainNoise * 40
	elseif biome == "Desert" then
		height = baseHeight + heightNoise * 10
	elseif biome == "Plains" then
		height = baseHeight + heightNoise * 15
	elseif biome == "Forest" or biome == "Jungle" then
		height = baseHeight + heightNoise * 25
	end
	
	return math.floor(height)
end

-- ============ BLOCK PLACEMENT ============
local function getBlockType(x, y, z, height, biome, seed)
	-- Bedrock at bottom
	if y == 0 then
		return WorldGen.Config.Blocks.Bedrock
	end
	
	-- Air above height
	if y > height then
		if y <= WorldGen.Config.SeaLevel and y > height then
			return WorldGen.Config.Blocks.Water
		end
		return WorldGen.Config.Blocks.Air
	end
	
	-- Top layer
	if y == height then
		if biome == "Desert" then
			return WorldGen.Config.Blocks.Sand
		else
			return WorldGen.Config.Blocks.Grass
		end
	end
	
	-- Dirt layer
	if y >= height - 3 then
		return WorldGen.Config.Blocks.Dirt
	end
	
	-- Cave generation
	local caveNoise = perlinNoise(x, z, seed + 3000, 0.05, 2, 0.5, 2)
	if y > 10 and y < height - 5 and caveNoise > WorldGen.Config.CaveDensity then
		return WorldGen.Config.Blocks.Air
	end
	
	-- Ore generation
	if y < 50 then
		local coalNoise = perlinNoise(x, z, seed + 4000, 0.02, 2, 0.5, 2)
		if coalNoise > 1 - WorldGen.Config.OreDensity.Coal * 10 then
			return WorldGen.Config.Blocks.CoalOre
		end
		
		if y < 40 then
			local ironNoise = perlinNoise(x, z, seed + 5000, 0.02, 2, 0.5, 2)
			if ironNoise > 1 - WorldGen.Config.OreDensity.Iron * 10 then
				return WorldGen.Config.Blocks.IronOre
			end
		end
		
		if y < 30 then
			local goldNoise = perlinNoise(x, z, seed + 6000, 0.02, 2, 0.5, 2)
			if goldNoise > 1 - WorldGen.Config.OreDensity.Gold * 10 then
				return WorldGen.Config.Blocks.GoldOre
			end
		end
		
		if y < 15 then
			local diamondNoise = perlinNoise(x, z, seed + 7000, 0.02, 2, 0.5, 2)
			if diamondNoise > 1 - WorldGen.Config.OreDensity.Diamond * 10 then
				return WorldGen.Config.Blocks.DiamondOre
			end
		end
	end
	
	return WorldGen.Config.Blocks.Stone
end

-- ============ TREE GENERATION ============
local function generateTree(x, y, z, chunk)
	local woodHeight = 4 + math.random(0, 2)
	
	-- Generate trunk
	for i = 1, woodHeight do
		local blockPos = Vector3.new(x, y + i, z)
		chunk[blockPos] = WorldGen.Config.Blocks.Wood
	end
	
	-- Generate leaves
	for dx = -2, 2 do
		for dz = -2, 2 do
			for dy = woodHeight - 2, woodHeight do
				local distance = math.abs(dx) + math.abs(dz) + math.abs(dy - (woodHeight - 1))
				if distance <= 3 then
					local blockPos = Vector3.new(x + dx, y + dy, z + dz)
					if chunk[blockPos] == nil or chunk[blockPos] == WorldGen.Config.Blocks.Air then
						chunk[blockPos] = WorldGen.Config.Blocks.Leaves
					end
				end
			end
		end
	end
end

-- ============ CHUNK GENERATION ============
local generatedChunks = {}

function WorldGen:GenerateChunk(chunkX, chunkZ)
	local chunkKey = chunkX .. "," .. chunkZ
	
	-- Check if chunk already generated
	if generatedChunks[chunkKey] then
		return generatedChunks[chunkKey]
	end
	
	local chunkData = {}
	local chunkSize = self.Config.ChunkSize
	local seed = self.Config.Seed
	
	-- Generate terrain
	for x = 0, chunkSize - 1 do
		for z = 0, chunkSize - 1 do
			local worldX = chunkX * chunkSize + x
			local worldZ = chunkZ * chunkSize + z
			
			local biome = getBiome(worldX, worldZ, seed)
			local height = getHeight(worldX, worldZ, biome, seed)
			
			-- Generate blocks from bottom to top
			for y = 0, height do
				local blockType = getBlockType(worldX, y, worldZ, height, biome, seed)
				if blockType ~= WorldGen.Config.Blocks.Air then
					local blockPos = Vector3.new(x, y, z)
					chunkData[blockPos] = blockType
				end
			end
			
			-- Generate trees
			local treeNoise = perlinNoise(worldX, worldZ, seed + 8000, 0.01, 2, 0.5, 2)
			if biome ~= "Desert" and biome ~= "Tundra" and treeNoise > 1 - WorldGen.Config.TreeDensity * 100 then
				if height > WorldGen.Config.SeaLevel then
					generateTree(x, height, z, chunkData)
				end
			end
		end
	end
	
	generatedChunks[chunkKey] = chunkData
	return chunkData
end

-- ============ RENDER CHUNK ============
function WorldGen:RenderChunk(chunkX, chunkZ, parent)
	local chunkData = self:GenerateChunk(chunkX, chunkZ)
	local chunkSize = self.Config.ChunkSize
	local chunkFolder = Instance.new("Folder")
	chunkFolder.Name = string.format("Chunk_%d_%d", chunkX, chunkZ)
	chunkFolder.Parent = parent or workspace
	
	local blockSize = 4 -- Size of each block part
	
	for pos, blockType in pairs(chunkData) do
		if blockType ~= self.Config.Blocks.Air then
			local part = Instance.new("Part")
			part.Size = Vector3.new(blockSize, blockSize, blockSize)
			part.Position = Vector3.new(
				(chunkX * chunkSize + pos.X) * blockSize,
				pos.Y * blockSize,
				(chunkZ * chunkSize + pos.Z) * blockSize
			)
			part.Anchored = true
			part.BrickColor = BrickColor.new(self.Config.BlockColors[blockType])
			part.Material = Enum.Material.SmoothPlastic
			part.Parent = chunkFolder
		end
	end
	
	return chunkFolder
end

-- ============ WORLD GENERATION ============
function WorldGen:GenerateWorld(parent)
	print("Generating world with seed: " .. self.Config.Seed)
	
	local worldFolder = Instance.new("Folder")
	worldFolder.Name = "World"
	worldFolder.Parent = parent or workspace
	
	local renderDistance = self.Config.RenderDistance
	
	for x = -renderDistance, renderDistance do
		for z = -renderDistance, renderDistance do
			self:RenderChunk(x, z, worldFolder)
			task.wait() -- Prevent lag
		end
	end
	
	print("World generation complete!")
	return worldFolder
end

-- ============ PLAYER POSITION TRACKING ============
function WorldGen:TrackPlayer(player, updateDistance)
	updateDistance = updateDistance or 2
	
	local lastChunkX = nil
	local lastChunkZ = nil
	
	game:GetService("RunService").RenderStepped:Connect(function()
		local char = player.Character
		if not char then return end
		
		local rootPart = char:FindFirstChild("HumanoidRootPart")
		if not rootPart then return end
		
		local chunkSize = self.Config.ChunkSize
		local blockSize = 4
		
		local playerX = rootPart.Position.X / blockSize / chunkSize
		local playerZ = rootPart.Position.Z / blockSize / chunkSize
		
		local currentChunkX = math.floor(playerX)
		local currentChunkZ = math.floor(playerZ)
		
		if lastChunkX ~= currentChunkX or lastChunkZ ~= currentChunkZ then
			lastChunkX = currentChunkX
			lastChunkZ = currentChunkZ
			
			-- Generate new chunks around player
			for x = -updateDistance, updateDistance do
				for z = -updateDistance, updateDistance do
					local chunkX = currentChunkX + x
					local chunkZ = currentChunkZ + z
					
					local chunkKey = chunkX .. "," .. chunkZ
					if not generatedChunks[chunkKey] then
						self:GenerateChunk(chunkX, chunkZ)
					end
				end
			end
		end
	end)
end

-- ============ UTILITY FUNCTIONS ============
function WorldGen:SetBlock(worldPosition, blockType)
	local blockSize = 4
	local chunkSize = self.Config.ChunkSize
	
	local chunkX = math.floor(worldPosition.X / blockSize / chunkSize)
	local chunkZ = math.floor(worldPosition.Z / blockSize / chunkSize)
	
	local localX = (worldPosition.X / blockSize) % chunkSize
	local localZ = (worldPosition.Z / blockSize) % chunkSize
	local localY = worldPosition.Y / blockSize
	
	local chunk = self:GenerateChunk(chunkX, chunkZ)
	local blockPos = Vector3.new(localX, localY, localZ)
	chunk[blockPos] = blockType
	
	-- Update visual
	local chunkFolder = workspace:FindFirstChild(string.format("Chunk_%d_%d", chunkX, chunkZ))
	if chunkFolder then
		local part = chunkFolder:FindFirstChild(string.format("Block_%d_%d_%d", localX, localY, localZ))
		if part then
			part.BrickColor = BrickColor.new(self.Config.BlockColors[blockType])
		else
			local newPart = Instance.new("Part")
			newPart.Size = Vector3.new(blockSize, blockSize, blockSize)
			newPart.Position = worldPosition
			newPart.Anchored = true
			newPart.BrickColor = BrickColor.new(self.Config.BlockColors[blockType])
			newPart.Name = string.format("Block_%d_%d_%d", localX, localY, localZ)
			newPart.Parent = chunkFolder
		end
	end
end

function WorldGen:GetBlock(worldPosition)
	local blockSize = 4
	local chunkSize = self.Config.ChunkSize
	
	local chunkX = math.floor(worldPosition.X / blockSize / chunkSize)
	local chunkZ = math.floor(worldPosition.Z / blockSize / chunkSize)
	
	local localX = (worldPosition.X / blockSize) % chunkSize
	local localZ = (worldPosition.Z / blockSize) % chunkSize
	local localY = worldPosition.Y / blockSize
	
	local chunk = self:GenerateChunk(chunkX, chunkZ)
	local blockPos = Vector3.new(localX, localY, localZ)
	
	return chunk[blockPos] or self.Config.Blocks.Air
end

-- ============ SAVE/LOAD WORLD ============
function WorldGen:SaveWorld(worldName)
	if not (writefile and readfile) then
		warn("Cannot save world - writefile not available")
		return false
	end
	
	local saveData = {
		Seed = self.Config.Seed,
		Chunks = {}
	}
	
	for key, chunkData in pairs(generatedChunks) do
		local chunkDataTable = {}
		for pos, blockType in pairs(chunkData) do
			chunkDataTable[tostring(pos)] = blockType
		end
		saveData.Chunks[key] = chunkDataTable
	end
	
	local json = game:GetService("HttpService"):JSONEncode(saveData)
	writefile(worldName .. ".json", json)
	print("World saved: " .. worldName)
	return true
end

function WorldGen:LoadWorld(worldName)
	if not (readfile and isfile) then
		warn("Cannot load world - readfile not available")
		return false
	end
	
	local fileName = worldName .. ".json"
	if not isfile(fileName) then
		warn("World file not found: " .. fileName)
		return false
	end
	
	local json = readfile(fileName)
	local saveData = game:GetService("HttpService"):JSONDecode(json)
	
	self.Config.Seed = saveData.Seed
	generatedChunks = {}
	
	for key, chunkDataTable in pairs(saveData.Chunks) do
		local chunkData = {}
		for posStr, blockType in pairs(chunkDataTable) do
			local x, y, z = posStr:match("(%d+),(%d+),(%d+)")
			chunkData[Vector3.new(tonumber(x), tonumber(y), tonumber(z))] = blockType
		end
		generatedChunks[key] = chunkData
	end
	
	print("World loaded: " .. worldName)
	return true
end

-- ============ EXPORT ============
getgenv().WorldGen = WorldGen

print("WorldGeneration.lua loaded!")
print("Usage:")
print("  WorldGen:GenerateWorld(workspace) - Generate a new world")
print("  WorldGen:SaveWorld('MyWorld') - Save the world")
print("  WorldGen:LoadWorld('MyWorld') - Load a saved world")
print("  WorldGen:TrackPlayer(game.Players.LocalPlayer) - Auto-generate chunks around player")
print("  WorldGen:SetBlock(Vector3.new(x, y, z), BlockID) - Place a block")
print("  WorldGen:GetBlock(Vector3.new(x, y, z)) - Get block type")

return WorldGen
