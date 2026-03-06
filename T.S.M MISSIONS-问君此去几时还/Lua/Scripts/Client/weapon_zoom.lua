local function HasAffliction(character,identifier,minamount)
    if character==nil or character.CharacterHealth==nil then return false end

    local aff = character.CharacterHealth.GetAffliction(identifier)
    local res = false
    if(aff~=nil) then
        res = aff.Strength >= (minamount or 0.5)
    end
    return res
end

local function lerp(a,b,t)  --定义函数
	return a* (1- t) + b * t  --啊吧啊吧啊吧
end


Hook.Patch("Barotrauma.Character", "ControlLocalPlayer", function(instance, ptable)  --补Hook
    local character = instance  --变量

    if not character then return end  
    if Game.GameSession.IsTabMenuOpen then return end
    if GUI.GUI.PauseMenuOpen then return end
    if GUI.KeyboardDispatcher.Subscriber then return end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_reddot",1) and not character.SelectedItem then  --右键且拿着武器且没与物品交互
    		Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.53)
          , 310)
        end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_holographic",1) and not character.SelectedItem then
        	Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.53)
          , 310)
        end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_double",1) and not character.SelectedItem then
            Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.57)
          , 360)
         end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_tripled",1) and not character.SelectedItem then
        Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.57)
        , 375)
    end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_pso",1) and not character.SelectedItem then
            Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.63)
            , 390)
         end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_c79",1) and not character.SelectedItem then
            Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.65)
            , 400)
         end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_acog",1) and not character.SelectedItem then
            Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.6)
            , 390)
         end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_95",1) and not character.SelectedItem then
             Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.57)
             , 365)
        end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_03",1) and not character.SelectedItem then
             Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.6)
             , 370)
        end
    if PlayerInput.SecondaryMouseButtonHeld() and HasAffliction(character,"tsm_sight_qmk152",1) and not character.SelectedItem then
        Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.63)
        , 390)
    end
    if PlayerInput.SecondaryMouseButtonHeld() and (character.HasEquippedItem("tsm_farsight",true,2) or character.HasEquippedItem("tsm_farsight",true,4)) and not character.SelectedItem then
    		Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.72)
            , 415)
        end
    if PlayerInput.SecondaryMouseButtonHeld() and (character.HasEquippedItem("tsm_mid_farsight",true,2) or character.HasEquippedItem("tsm_mid_farsight",true,4)) and not character.SelectedItem then
        Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.68)
        , 395)
    end
    if PlayerInput.SecondaryMouseButtonHeld() and (character.HasEquippedItem("tsm_short_farsight",true,2) or character.HasEquippedItem("tsm_mid_farsight",true,4)) and not character.SelectedItem then
        Screen.Selected.Cam.OffsetAmount = math.min( lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.62)
        , 385)
    end

end, Hook.HookMethodType.After)