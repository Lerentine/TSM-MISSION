Hook.Add("tsm_enhancement_cyborg.OnContained", "", function(effect, deltaTime, item, targets, worldPosition)
    Entity.Spawner.AddItemToRemoveQueue(item)

    if NTCyb == nil then return end

    local character = targets[1]

    NTCyb.CyberifyLimb(character, LimbType.LeftArm, true)
    NTCyb.CyberifyLimb(character, LimbType.RightArm, true)
    NTCyb.CyberifyLimb(character, LimbType.LeftLeg, true)
    NTCyb.CyberifyLimb(character, LimbType.RightLeg, true)
end)