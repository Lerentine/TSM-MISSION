local activeCharge = {}

Hook.Add("roundEnd", "tsm_jz_c4_reset_on_round_end", function()
    for i, v in pairs(activeCharge) do
        i.GetComponentString("Projectile").IgnoredBodies = {}
        i.GetComponentString("LightComponent").isOn = false
    end
    activeCharge = {}
end)

Hook.Add("character.death", "tsm_jz_c4_reset_on_character_death", function(character)  --Reset on death
    if activeCharge == nil or character == nil then return end
    for i, c in pairs(activeCharge) do
        if c == character then
            i.GetComponentString("Projectile").IgnoredBodies = {}
            i.GetComponentString("LightComponent").isOn = false
            activeCharge[i] = nil
        end
    end
end)

Hook.Add("tsm_jz_m57detonator_onuse", "tsm_jz_m57detonator_onuse", function(effect, deltaTime, item, targets, worldPosition)
    local usingCharacter = targets[1]
    if usingCharacter == nil then return end
    -- local count = 0
    for i, c in pairs(activeCharge) do
        if i.Removed then
            activeCharge[i] = nil
        elseif c == usingCharacter then
            -- count = count + 1
            i.Condition = 0
            activeCharge[i] = nil
        end
    end
    -- print("//TSM DEBUG MESSAGE// C4 DETONATOR USED BY", usingCharacter.Name .. ":", count, "CHARGE(S) DETONATED")
end)

Hook.Add("tsm_jz_c4_onuse", "tsm_jz_c4_onuse", function(effect, deltaTime, item, targets, worldPosition)
    local usingCharacter = targets[1]
    if usingCharacter == nil then return end
    activeCharge[item] = usingCharacter
    -- print("//TSM DEBUG MESSAGE// C4 CHARGE THROWN BY", usingCharacter.Name)
    local ignoredBodies = {}
    for limb in usingCharacter.AnimController.Limbs do
        table.insert(ignoredBodies, limb.body.FarseerBody)
    end
    item.GetComponentString("Projectile").IgnoredBodies = ignoredBodies
    item.body.LinearVelocity = item.body.LinearVelocity * 0.5
    item.GetComponentString("LightComponent").isOn = true
end)

Hook.Add("tsm_jz_c4_onpicked", "tsm_jz_c4_onpicked", function(effect, deltaTime, item, targets, worldPosition)
    local pickingCharacter = targets[1]
    if pickingCharacter == nil or activeCharge[item] == nil then return end
    -- local usingCharacter = activeCharge[item]
    -- print("//TSM DEBUG MESSAGE//", pickingCharacter.Name, "PICKED UP A C4 CHARGE THROWN BY", usingCharacter.Name)
    item.GetComponentString("Projectile").IgnoredBodies = {}
    item.GetComponentString("LightComponent").isOn = false
    activeCharge[item] = nil
end)