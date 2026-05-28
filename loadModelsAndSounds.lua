task.spawn(function()
    local playerHandModel = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/playerHand.rbxm"
    local pigModel = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/pig.rbxm"
    local grassShortModel = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/grass.rbxm"
    local breakingParticlesPlaceholderModel = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/breakingparticlesplaceholder.rbxm"
    local cave1 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave1.ogg"
    local cave2 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave2.ogg"
    local cave3 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave3.ogg"
    local cave4 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave4.ogg"
    local cave5 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave5.ogg"
    local cave6 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave6.ogg"
    local cave7 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave7.ogg"
    local cave8 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave8.ogg"
    local cave10 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave10.ogg"
    local cave11 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave11.ogg"
    local cave12 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave12.ogg"
    local cave13 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave13.ogg"
    local cave14 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave14.ogg"
    local cave15 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave15.ogg"
    local cave16 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave16.ogg"
    local cave17 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave17.ogg.mp3"
    local cave18 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave18.ogg.mp3"
    local cave19 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/Cave19.ogg"
    local key = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/1-01.%20Key.mp3"
    local livingMice = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/1-05.%20Living%20Mice.mp3"
    local minecraft = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/1-08.%20Minecraft.mp3"
    local oxygene = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/1-09.%20Oxygène.mp3"
    local sweden = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/1-18.%20Sweden.mp3"
    local moogCity2 = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/2-06.%20Moog%20City%202.mp3"
    local biomeFest = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/2-08.%20Biome%20Fest.mp3"
    local hauntMuskie = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/2-10.%20Haunt%20Muskie.mp3"
    local floatingTrees = "https://raw.githubusercontent.com/Minecraft-Assets-Roblox/2-12.%20Floating%20Trees.mp3"
    if G.LoadGithubModel then
        local playerHandLoad = G.LoadGithubModel(playerHandModel, "PlayerHand")
        local pigLoad = G.LoadGithubModel(pigModel, "Pig")
        local grassShortLoad = G.LoadGithubModel(grassShortModel, "Grass_Short")
        local breakingParticlesPlaceholderLoad = G.LoadGithubModel(breakingParticlesPlaceholderModel, "Breaking_Particles")
    end
    if G.LoadGithubOGGAudio and G.LoadGithubAudio then
        local cave1Load = G.LoadGithubOGGAudio(cave1, "Cave1")
        local cave2Load = G.LoadGithubOGGAudio(cave2, "Cave2")
        local cave3Load = G.LoadGithubOGGAudio(cave3, "Cave3")
        local cave4Load = G.LoadGithubOGGAudio(cave4, "Cave4")
        local cave5Load = G.LoadGithubOGGAudio(cave5, "Cave5")
        local cave6Load = G.LoadGithubOGGAudio(cave6, "Cave6")
        local cave7Load = G.LoadGithubOGGAudio(cave7, "Cave7")
        local cave8Load = G.LoadGithubOGGAudio(cave8, "Cave8")
        local cave10Load = G.LoadGithubOGGAudio(cave10, "Cave10")
        local cave11Load = G.LoadGithubOGGAudio(cave11, "Cave11")
        local cave12Load = G.LoadGithubOGGAudio(cave12, "Cave12")
        local cave13Load = G.LoadGithubOGGAudio(cave13, "Cave13")
        local cave14Load = G.LoadGithubOGGAudio(cave14, "Cave14")
        local cave15Load = G.LoadGithubOGGAudio(cave15, "Cave15")
        local cave16Load = G.LoadGithubOGGAudio(cave16, "Cave16")
        local cave17Load = G.LoadGithubOGGAudio(cave17, "Cave17")
        local cave18Load = G.LoadGithubOGGAudio(cave18, "Cave18")
        local cave19Load = G.LoadGithubOGGAudio(cave19, "Cave19")
        local keyLoad = G.LoadGithubAudio(key, "Key")
        local livingMiceLoad = G.LoadGithubAudio(livingMice, "Living Mice")
        local minecraftLoad = G.LoadGithubAudio(minecraft, "Minecraft")
        local oxygeneLoad = G.LoadGithubAudio(oxygene, "Oxygène")
        local swedenLoad = G.LoadGithubAudio(sweden, "Sweden")
        local moogCity2Load = G.LoadGithubAudio(moogCity2, "Moog City 2")
        local biomeFestLoad = G.LoadGithubAudio(biomeFest, "Biome Fest")
        local hauntMuskieLoad = G.LoadGithubAudio(hauntMuskie, "Haunt Muskie")
        local floatingTreesLoad = G.LoadGithubAudio(floatingTrees, "Floating Trees")
    end
end)
