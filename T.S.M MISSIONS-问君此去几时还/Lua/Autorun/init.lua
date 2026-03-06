JZ_Main = {}
JZ_Main.Path = table.pack(...)[1]  --获取路径

dofile(JZ_Main.Path .. '/Lua/Scripts/helmets/helmet.lua')--编译
dofile(JZ_Main.Path .. '/Lua/Scripts/helmets/helmet_ondamaged.lua')

if Game.IsSingleplayer or SERVER then
    dofile(JZ_Main.Path .. "/Lua/Server/tsm_cqb_combatinship.lua")
    dofile(JZ_Main.Path .. "/Lua/Scripts/Shared/Firesupport.lua")
    dofile(JZ_Main.Path .. "/Lua/Scripts/Shared/Shared.lua")
end

if CLIENT then  --仅客户端
	dofile(JZ_Main.Path .. "/Lua/Scripts/Shared/hotkeys.lua")
end

local function addNTHooks()
    table.insert(NTC.HumanUpdateHooks, function(character)
        --贝奥武夫
        if HF.HasAffliction(character, "tsm_beowulf_jia_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.2)
            NTC.SetMultiplier(character, "anyfracturechance", 0.2)
        end
        if HF.HasAffliction(character, "tsm_beowulf_yi_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.4)
            NTC.SetMultiplier(character, "anyfracturechance", 0.4)
        end
        if HF.HasAffliction(character, "tsm_beowulf_bing_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.5)
            NTC.SetMultiplier(character, "anyfracturechance", 0.5)
        end
        --占领军
        if HF.HasAffliction(character, "tsm_occupation_jia_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.2)
            NTC.SetMultiplier(character, "anyfracturechance", 0.2)
        end
        if HF.HasAffliction(character, "tsm_occupation_yi_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.3)
            NTC.SetMultiplier(character, "anyfracturechance", 0.3)
        end
        if HF.HasAffliction(character, "tsm_occupation_bing_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.5)
            NTC.SetMultiplier(character, "anyfracturechance", 0.5)
        end
        --快速反应部队
        if HF.HasAffliction(character, "tsm_qrf_jia_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.35)
            NTC.SetMultiplier(character, "anyfracturechance", 0.35)
        end
        if HF.HasAffliction(character, "tsm_qrf_yi_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.45)
            NTC.SetMultiplier(character, "anyfracturechance", 0.45)
        end
        if HF.HasAffliction(character, "tsm_qrf_bing_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.65)
            NTC.SetMultiplier(character, "anyfracturechance", 0.65)
        end
        --串扰中队
        if HF.HasAffliction(character, "tsm_crosstalk_jia_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.15)
            NTC.SetMultiplier(character, "anyfracturechance", 0.15)
        end
        --野火
        if HF.HasAffliction(character, "tsm_yehuo_jia_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.2)
            NTC.SetMultiplier(character, "anyfracturechance", 0.2)
        end
        if HF.HasAffliction(character, "tsm_yehuo_yi_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.4)
            NTC.SetMultiplier(character, "anyfracturechance", 0.4)
        end
        if HF.HasAffliction(character, "tsm_yehuo_bing_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.4)
            NTC.SetMultiplier(character, "anyfracturechance", 0.4)
        end
        --尖锐突袭者
        if HF.HasAffliction(character, "tsm_anonymous_jia_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.3)
            NTC.SetMultiplier(character, "anyfracturechance", 0.3)
        end
        if HF.HasAffliction(character, "tsm_anonymous_yi_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.55)
            NTC.SetMultiplier(character, "anyfracturechance", 0.55)
        end
        --奇迹之海
        if HF.HasAffliction(character, "tsm_jz_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.4)
            NTC.SetMultiplier(character, "anyfracturechance", 0.4)
        end
        if HF.HasAffliction(character, "tsm_advanced_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.3)
            NTC.SetMultiplier(character, "anyfracturechance", 0.3)
        end
        if HF.HasAffliction(character, "tsm_pt_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.65)
            NTC.SetMultiplier(character, "anyfracturechance", 0.65)
        end
        if HF.HasAffliction(character, "tsm_ma_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.1)
            NTC.SetMultiplier(character, "anyfracturechance", 0.1)
        end
        if HF.HasAffliction(character, "tsm_sec_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.35)
            NTC.SetMultiplier(character, "anyfracturechance", 0.35)
        end
        --降临派
        if HF.HasAffliction(character, "tsm_ai_stun_3") then
            NTC.SetMultiplier(character, "dislocationchance", 0.1)
            NTC.SetMultiplier(character, "anyfracturechance", 0.1)
        end
        --枪火
        if HF.HasAffliction(character, "tsm_nz_buff") then
            NTC.SetMultiplier(character, "dislocationchance", 0.5)
            NTC.SetMultiplier(character, "anyfracturechance", 0.5)
        end
        --警察
        if HF.HasAffliction(character, "tsm_outpostenhanced_police") then
            NTC.SetMultiplier(character, "dislocationchance", 0.5)
            NTC.SetMultiplier(character, "anyfracturechance", 0.5)
        end
        --日暮山
        if HF.HasAffliction(character, "tsm_outpostenhanced_sunset") then
            NTC.SetMultiplier(character, "dislocationchance", 0.2)
            NTC.SetMultiplier(character, "anyfracturechance", 0.2)
        end
        --先进作战
        if HF.HasAffliction(character, "tsm_outpostenhanced_advanced") then
            NTC.SetMultiplier(character, "dislocationchance", 0.0)
            NTC.SetMultiplier(character, "anyfracturechance", 0.0)
        end
        --站点突袭中队
        if HF.HasAffliction(character, "tsm_outpostenhanced_nujiang") then
            NTC.SetMultiplier(character, "dislocationchance", 0.0)
            NTC.SetMultiplier(character, "anyfracturechance", 0.0)
        end
    end)
end

local function tryAddNTHooks(iteration)
    if iteration > 5 then return end
    if NT ~= nil and NTC ~= nil and NTC.HumanUpdateHooks ~= nil then
        addNTHooks()
    else
        Timer.Wait(function() tryAddNTHooks(iteration + 1) end, 1000)
    end
end

Timer.Wait(function()
	if (Game.IsMultiplayer and SERVER) or not Game.IsMultiplayer then
        tryAddNTHooks(1)
	end
end, 100)