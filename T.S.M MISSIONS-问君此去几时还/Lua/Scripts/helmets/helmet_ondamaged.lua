Hook.Add("character.applyDamage", "TSM_helmet_ondamaged", function(characterHealth, attackResult, hitLimb)
    if hitLimb == nil or hitLimb.type ~= LimbType.Head or characterHealth == nil or attackResult == nil then return end

    local character = characterHealth.Character
    if character == nil or character.Inventory == nil then return end

    local helmet = character.Inventory.GetItemInLimbSlot(InvSlotType.Head)
    if helmet == nil or helmet.OwnInventory == nil then return end

    if characterHealth.GetAffliction("tsm_armor_faceshield_100") or characterHealth.GetAffliction("tsm_armor_faceshield_80") or characterHealth.GetAffliction("tsm_armor_faceshield_60") or characterHealth.GetAffliction("tsm_armor_faceshield_40") or characterHealth.GetAffliction("tsm_armor_faceshield_20") or characterHealth.GetAffliction("tsm_armor_jaw")
            or characterHealth.GetAffliction("tsm_armor_faceshield_aerjin_100") or characterHealth.GetAffliction("tsm_armor_faceshield_aerjin_80") or characterHealth.GetAffliction("tsm_armor_faceshield_aerjin_50") or characterHealth.GetAffliction("tsm_armor_faceshield_aerjin_20")then
        local total_damage = 0
        for affliction in attackResult.Afflictions do
            local affType = affliction.Prefab.Identifier.Value
            if (affType == "gunshotwound" or affType == "explosiondamage") and affliction.Strength > 0 then
                total_damage = total_damage + affliction.Strength
            end
        end
        for item in helmet.OwnInventory.AllItemsMod do
            if item.HasTag("tsm_ballistic_faceshield") or item.Prefab.Identifier.Value == "tsm_protective_jaw" then
                item.Condition = item.Condition - total_damage
            end
        end
    end
end)