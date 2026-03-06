if not CLIENT then return end

LuaUserData.MakePropertyAccessible(Descriptors["Barotrauma.CampaignMode"], "SlideshowPlayer")
LuaUserData.RegisterType("Barotrauma.SlideshowPrefab")
local SlideshowPrefab = LuaUserData.CreateStatic("Barotrauma.SlideshowPrefab")

local testSlideshowPrefab = SlideshowPrefab.Prefabs["Test Slide"]
local testSlideshowPlayer = GUI.SlideshowPlayer(GUI.Canvas.Instance, testSlideshowPrefab)

Hook.Add("play_testslide", "play_testslide", function(effect, deltaTime, item, targets, worldPosition)
    if Game.GameSession.Campaign and Character.Controlled == targets[1] then
        Game.GameSession.Campaign.SlideshowPlayer = testSlideshowPlayer
    end
end)
