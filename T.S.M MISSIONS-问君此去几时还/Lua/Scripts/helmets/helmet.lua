LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Wearable"], "wearableSprites")
LuaUserData.MakeMethodAccessible(Descriptors["Barotrauma.Items.Components.CustomInterface"], "TickBoxToggled")
LuaUserData.MakePropertyAccessible(Descriptors['Barotrauma.Items.Components.CustomInterface'], 'DrawHudWhenEquipped')
LuaUserData.MakePropertyAccessible(Descriptors['Barotrauma.Items.Components.StatusHUD'], 'DrawHudWhenEquipped')
if CLIENT then
    LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.CustomInterface"], "uiElements")
    LuaUserData.MakePropertyAccessible(Descriptors['Barotrauma.Items.Components.StatusHUD'], 'OverlayColor')
    LuaUserData.MakePropertyAccessible(Descriptors['Barotrauma.Items.Components.StatusHUD'], 'ThermalGoggles')
    LuaUserData.MakePropertyAccessible(Descriptors['Barotrauma.Items.Components.StatusHUD'], 'ShowDeadCharacters')
    LuaUserData.MakePropertyAccessible(Descriptors['Barotrauma.Items.Components.StatusHUD'], 'ShowTexts')
end

local sprite_size = 500

local function update_sprite(item)
    if SERVER then return end
    if not item.GetComponentString("Wearable").IsActive then return end

    local item0 = item.OwnInventory.GetItemAt(0)
    local item1 = item.OwnInventory.GetItemAt(1)
    local item2 = item.OwnInventory.GetItemAt(2)
    local row = 0
    local col = 0
    if item0 ~= nil then
        if item0.Prefab.Identifier == "tsm_ballistic_faceshield_big" then
            col = 1
        elseif item0.Prefab.Identifier == "tsm_ballistic_faceshield_small" then
            col = 1
        elseif item0.Prefab.Identifier == "tsm_helmet_screen" then
            col = 6
        else
            if item0.Prefab.Identifier == "tsm_helmet_nvd" then
                col = 4
            elseif item0.Prefab.Identifier == "tsm_helmet_thermalgoggles" then
                col = 2
            elseif item0.Prefab.Identifier == "tsm_ballistic_faceshield_aerjin" then
                col = 7
            end
            if item.GetComponentString("CustomInterface").customInterfaceElementList[1].State then
                col = col + 1
            end
        end
    end
    if item1 ~= nil then
        if item1.Prefab.Identifier == "tsm_protective_jaw" then
            row = 1
        elseif item1.Prefab.Identifier == "tsm_helmet_diving" then
            row = 4
        elseif item1.Prefab.Identifier == "tsm_helmet_diving1" then
            row = 5
        end
    end
    if item2 ~= nil then
        if item2.Prefab.Identifier == "tsm_helmet_flashlight" then
            row = row + 2
        end
    end

    item.GetComponentString("Wearable").wearableSprites[1].Sprite.SourceRect = Rectangle(col * sprite_size, row * sprite_size, sprite_size, sprite_size)
end

Hook.Add("item.equip", "tsm_equip_helmet", function(item, character)
    if item.HasTag("tsm_hashelmetinterface") then
        update_sprite(item)
    end
end)

Hook.Add("tsm_helmet_update_sprite", "tsm_helmet_update_sprite", function(effect, deltaTime, item, targets, worldPosition)
    update_sprite(item)
end)

local faceshieldAfflictions = {{"tsm_armor_faceshield_100", "tsm_armor_faceshield_80", "tsm_armor_faceshield_60", "tsm_armor_faceshield_40", "tsm_armor_faceshield_20"},
                               {100, 80, 60, 40, 20}}
local altynAfflictions = {{"tsm_armor_faceshield_aerjin_100", "tsm_armor_faceshield_aerjin_80", "tsm_armor_faceshield_aerjin_50", "tsm_armor_faceshield_aerjin_20"},
                          {100, 80, 50, 20}}


local function getShieldAffliction(shield, afflictionList)
    local conditionPercentage = shield.ConditionPercentage
    if conditionPercentage == 0 then return nil end
    for index = 2, #afflictionList[1] do
        local currentThreshold = afflictionList[2][index]
        if conditionPercentage > currentThreshold then
            return afflictionList[1][index - 1]
        end
    end
    return afflictionList[1][#afflictionList[1]]
end

local function update(item, character)
    local inventory = item.OwnInventory
    if character == nil or character.IsDead or character.Removed or item.Removed then return end

    local enabled = item.GetComponentString("CustomInterface").customInterfaceElementList[1].State
    local altyn = inventory.FindItemByIdentifier("tsm_ballistic_faceshield_aerjin")
    local faceshield = inventory.FindItemByIdentifier("tsm_ballistic_faceshield_small")
                        or inventory.FindItemByIdentifier("tsm_ballistic_faceshield_big")
    if faceshield or (altyn and enabled) then
        local shield = faceshield
        local shieldAfflictions = faceshieldAfflictions
        if altyn then
            shield = altyn
            shieldAfflictions = altynAfflictions
        end
        local targetAffliction = getShieldAffliction(shield, shieldAfflictions)
        for affliction in shieldAfflictions[1] do
            if affliction == targetAffliction then
                character.CharacterHealth.ApplyAffliction(nil, AfflictionPrefab.Prefabs[affliction].Instantiate(3))
            else
                character.CharacterHealth.ReduceAfflictionOnAllLimbs(affliction, 3)
            end
        end
    end

    local ci = item.GetComponentString("CustomInterface")
    local hud = item.GetComponentString("StatusHUD")
    local light = item.GetComponentString("LightComponent")
    local thermal = inventory.FindItemByIdentifier("tsm_helmet_thermalgoggles")
    local nvd = inventory.FindItemByIdentifier("tsm_helmet_nvd")
    local scanner = inventory.FindItemByIdentifier("tsm_helmet_screen")
    if altyn or thermal or nvd or scanner then
        ci.DrawHudWhenEquipped = true
    else
        ci.DrawHudWhenEquipped = false
        ci.customInterfaceElementList[1].State = false
        if CLIENT then
            ci.uiElements[1].Selected = false
        end
    end
    if ci.customInterfaceElementList[1].State then
        if thermal and thermal.Condition > 0 and not item.InWater then
            if CLIENT then
                hud.OverlayColor = Color(176,0,0,120)
                hud.ThermalGoggles = true
                hud.ShowDeadCharacters = false
                hud.ShowTexts = false
            end
            hud.DrawHudWhenEquipped = true
        elseif scanner and scanner.Condition > 0 then
            if CLIENT then
                hud.OverlayColor = Color(0,255,0,120)
                hud.ThermalGoggles = false
                hud.ShowDeadCharacters = true
                hud.ShowTexts = true
            end
            hud.DrawHudWhenEquipped = true
        elseif nvd and nvd.Condition > 0 then
            character.CharacterHealth.ApplyAffliction(nil, AfflictionPrefab.Prefabs["tsm_nightvision"].Instantiate(100))
            hud.DrawHudWhenEquipped = false
        else
            hud.DrawHudWhenEquipped = false
        end
    else
        hud.DrawHudWhenEquipped = false
        for affliction in altynAfflictions[1] do
            character.CharacterHealth.ReduceAfflictionOnAllLimbs(affliction, 3)
        end
        character.CharacterHealth.ReduceAfflictionOnAllLimbs("tsm_nightvision", 100)
    end

    local flashlight = inventory.FindItemByIdentifier("tsm_helmet_flashlight")
    if flashlight and flashlight.Condition > 0 then
        if item.InWater then
            character.CharacterHealth.ApplyAffliction(nil, AfflictionPrefab.Prefabs["tsm_ff_helmet1"].Instantiate(3))
            character.CharacterHealth.ReduceAfflictionOnAllLimbs("tsm_ff_helmet", 3)
        else
            character.CharacterHealth.ApplyAffliction(nil, AfflictionPrefab.Prefabs["tsm_ff_helmet"].Instantiate(3))
            character.CharacterHealth.ReduceAfflictionOnAllLimbs("tsm_ff_helmet1", 3)
        end
    end

    local jaw = inventory.FindItemByIdentifier("tsm_protective_jaw")
    if jaw and jaw.Condition > 0 then
        character.CharacterHealth.ApplyAffliction(nil, AfflictionPrefab.Prefabs["tsm_armor_jaw"].Instantiate(3))
    end
end

Hook.Add("tsm_helmet_update", "tsm_helmet_update", function(effect, deltaTime, item, targets, worldPosition)
    update_sprite(item)
    if LuaUserData.IsTargetType(targets[1], "Barotrauma.Character") then
        update(item, targets[1])
    elseif LuaUserData.IsTargetType(targets[1], "Barotrauma.Item") and targets[2].Picker ~= nil
            and targets[2].Picker.Inventory.GetItemInLimbSlot(InvSlotType.Head) == item then
        update(item, targets[2].Picker)
    end
end)

Hook.Patch("Barotrauma.Items.Components.CustomInterface", "TickBoxToggled", function(instance, ptable)
    local item = instance.item
    if item.HasTag("tsm_hashelmetinterface") then
        update_sprite(item)
        local character = item.GetComponentString("Wearable").Picker
        if character == nil then return end
        if Character.Controlled == character then
            if instance.customInterfaceElementList[1].State then
                instance.PlaySound(ActionType.OnUse)
            else
                instance.PlaySound(ActionType.OnSecondaryUse)
            end
        end
        update(item, character)
    end
end, Hook.HookMethodType.After)

Hook.Patch("Barotrauma.Items.Components.Wearable", "Unequip", function(instance, ptable)
    local character = ptable["character"]
    if not instance.item.HasTag("tsm_hashelmetinterface") then return end
    if character == nil then return end
    for affliction in faceshieldAfflictions[1] do
        character.CharacterHealth.ReduceAfflictionOnAllLimbs(affliction, 3)
    end
    for affliction in altynAfflictions[1] do
        character.CharacterHealth.ReduceAfflictionOnAllLimbs(affliction, 3)
    end
    character.CharacterHealth.ReduceAfflictionOnAllLimbs("tsm_ff_helmet", 3)
    character.CharacterHealth.ReduceAfflictionOnAllLimbs("tsm_ff_helmet1", 3)
    character.CharacterHealth.ReduceAfflictionOnAllLimbs("tsm_armor_jaw", 3)
    character.CharacterHealth.ReduceAfflictionOnAllLimbs("tsm_nightvision", 100)
    instance.item.GetComponentString("LightComponent").Voltage = 0
    instance.item.GetComponentString("StatusHUD").DrawHudWhenEquipped = false
    local ci = instance.item.GetComponentString("CustomInterface")
    ci.customInterfaceElementList[1].State = false
    if CLIENT then
        ci.uiElements[1].Selected = false
    end
end)
