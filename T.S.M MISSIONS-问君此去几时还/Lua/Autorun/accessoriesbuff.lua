local function HasAffliction(character, identifier, minamount)
	if character == nil or character.CharacterHealth == nil then
		return false
	end

	local aff = character.CharacterHealth.GetAffliction(identifier)
	local res = false
	if aff ~= nil then
		res = aff.Strength >= (minamount or 0.5)
	end
	return res
end

--移除手臂晃动惩罚
Hook.Patch("Barotrauma.AnimController", "GetAimWobble", function(instance, ptable)
	if HasAffliction(instance.Character, "tsm_straight_grip_buff", 1) then
		ptable.PreventExecution = true
		return 0
	end
end, Hook.HookMethodType.Before)

--移除腿部受伤移速惩罚
Hook.Patch("Barotrauma.Character", "CalculateMovementPenalty", function(instance, ptable)
	if HasAffliction(instance, "tsm_thumb_grip_buff", 1) then
		ptable.PreventExecution = true
	return 0
	end
end, Hook.HookMethodType.Before)