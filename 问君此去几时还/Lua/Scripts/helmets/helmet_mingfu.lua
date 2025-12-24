-- 定义新的面甲防护效果
local mingfuFaceshieldAffliction = "tsm_armor_faceshield_mf_100"

-- 更新状态的核心函数
local function updateMingfuHelmet(item, character)
    -- 检查必要条件（物品、角色有效且未死亡/移除）
    if not item or not character or character.IsDead or character.Removed or item.Removed then
        return
    end

    -- 获取头盔库存中的特定面甲配件（tsm_ballistic_faceshield_aerjin）
    local inventory = item.OwnInventory
    local aerjinShield = inventory and inventory.FindItemByIdentifier("tsm_ballistic_faceshield_aerjin")

    -- 获取角色健康组件
    local charHealth = character.CharacterHealth
    if not charHealth then return end

    -- 根据配件存在状态应用/移除效果（配件存在且耐久>0时生效）
    if aerjinShield and aerjinShield.Condition > 0 then
        -- 应用新的防护效果
        local afflictionPrefab = AfflictionPrefab.Prefabs[mingfuFaceshieldAffliction]
        if afflictionPrefab then
            charHealth.ApplyAffliction(nil, afflictionPrefab.Instantiate(3))
        end
    else
        -- 移除防护效果
        charHealth.ReduceAfflictionOnAllLimbs(mingfuFaceshieldAffliction, 3)
    end
end

-- 装备时触发更新（当带有指定标签的头盔被装备时）
Hook.Add("item.equip", "tsm_mingfu_helmet_equip", function(item, character)
    if item and item.HasTag("tsm_hashelmetinterface_mingfu") then
        updateMingfuHelmet(item, character)
    end
end)

-- 专用更新钩子（通过游戏内循环效果触发，确保状态实时刷新）
Hook.Add("tsm_helmet_update", "tsm_helmet_update", function(effect, deltaTime, item, targets, worldPosition)
    if not item or not item.HasTag("tsm_hashelmetinterface_mingfu") then return end

    -- 从目标中获取角色（参考你原有代码的角色获取逻辑）
    local character = nil
    if targets and #targets > 0 then
        if LuaUserData.IsTargetType(targets[1], "Barotrauma.Character") then
            character = targets[1]
        elseif LuaUserData.IsTargetType(targets[1], "Barotrauma.Item") and targets[2] and targets[2].Picker then
            character = targets[2].Picker
        end
    end

    -- 如果未获取到角色，尝试通过物品当前所有者获取
    if not character then
        character = item.GetCurrentOwner() -- 关键：通过物品的GetCurrentOwner()获取穿戴者
    end

    if character then
        updateMingfuHelmet(item, character)
    end
end)

-- 卸下头盔时清除效果
Hook.Patch("Barotrauma.Items.Components.Wearable", "Unequip", function(instance, ptable)
    local item = instance.item
    if not item or not item.HasTag("tsm_hashelmetinterface_mingfu") then return end

    local character = ptable["character"] -- 从Unequip方法参数中获取角色
    if character and character.CharacterHealth then
        -- 彻底移除防护效果
        character.CharacterHealth.ReduceAfflictionOnAllLimbs(mingfuFaceshieldAffliction, 3)
    end
end, Hook.HookMethodType.After)