
-- cause foreign bodies, rib fractures, pneumothorax, tamponade, internal bleeding, fractures, neurotrauma
NT.OnDamagedMethods.triton_7L = function(character, strength, limbtype)
	limbtype = HF.NormalizeLimbType(limbtype)

	local causeFullForeignBody = false

	-- torso specific
	if strength >= 1 and limbtype == LimbType.Torso then
		local hitOrgan = false
		if
			HF.Chance(
				HF.Clamp(strength * 0.02, 0, 0.3)
					* NTC.GetMultiplier(character, "anyfracturechance")
					* NTConfig.Get("NT_fractureChance", 1)
			)
		then
			NT.BreakLimb(character, limbtype)
			causeFullForeignBody = true
		end
		if
			HasLungs(character)
			and HF.Chance(
				0.3 * NTC.GetMultiplier(character, "pneumothoraxchance") * NTConfig.Get("NT_pneumothoraxChance", 1)
			)
		then
			HF.AddAffliction(character, "pneumothorax", 5)
			HF.AddAffliction(character, "lungdamage", strength)
			HF.AddAffliction(character, "organdamage", strength / 4)
			hitOrgan = true
		end
		if
			HasHeart(character)
			and hitOrgan == false
			and strength >= 5
			and HF.Chance(
				strength / 50 * NTC.GetMultiplier(character, "tamponadechance") * NTConfig.Get("NT_tamponadeChance", 1)
			)
		then
			HF.AddAffliction(character, "tamponade", 5)
			HF.AddAffliction(character, "heartdamage", strength)
			HF.AddAffliction(character, "organdamage", strength / 4)
			hitOrgan = true
		end
		if strength >= 5 then
			HF.AddAffliction(character, "internalbleeding", strength * HF.RandomRange(0.3, 0.6))
		end

		-- liver and kidney damage
		if hitOrgan == false and strength >= 2 and HF.Chance(0.5) then
			HF.AddAfflictionLimb(character, "organdamage", limbtype, strength / 4)
			if HF.Chance(0.5) then
				HF.AddAffliction(character, "liverdamage", strength)
			else
				HF.AddAffliction(character, "kidneydamage", strength)
			end
		end
	end

	-- head
	if strength >= 1 and limbtype == LimbType.Head then
		if
			HF.Chance(
				strength / 90 * NTC.GetMultiplier(character, "anyfracturechance") * NTConfig.Get("NT_fractureChance", 1)
			)
		then
			NT.BreakLimb(character, limbtype)
			causeFullForeignBody = true
		end
		if strength >= 5 and HF.Chance(0.7) then
			HF.AddAffliction(character, "cerebralhypoxia", strength * HF.RandomRange(0.1, 0.4))
		end
	end

	-- extremities
	if strength >= 1 and HF.LimbIsExtremity(limbtype) then
		if
			NT.LimbIsBroken(character, limbtype)
			and not NT.LimbIsAmputated(character, limbtype)
			and HF.Chance(strength / 60 * NTC.GetMultiplier(character, "traumamputatechance"))
		then
			NT.TraumamputateLimb(character, limbtype)
		end
		if
			HF.Chance(
				strength / 60 * NTC.GetMultiplier(character, "anyfracturechance") * NTConfig.Get("NT_fractureChance", 1)
			)
		then
			NT.BreakLimb(character, limbtype)
			causeFullForeignBody = true
		end
	end

	-- foreign bodies
	if causeFullForeignBody then
		HF.AddAfflictionLimb(
			character,
			"foreignbody",
			limbtype,
			HF.Clamp(strength, 0, 30) * NTC.GetMultiplier(character, "foreignbodymultiplier")
		)
	else
		if HF.Chance(0.75) then
			HF.AddAfflictionLimb(
				character,
				"foreignbody",
				limbtype,
				HF.Clamp(strength / 4, 0, 20) * NTC.GetMultiplier(character, "foreignbodymultiplier")
			)
		end
	end
end

-- cause foreign bodies, rib fractures, pneumothorax, tamponade, internal bleeding, fractures, neurotrauma
NT.OnDamagedMethods.tsm_bl = function(character, strength, limbtype)
	limbtype = HF.NormalizeLimbType(limbtype)

	local causeFullForeignBody = false

	-- torso specific
	if strength >= 1 and limbtype == LimbType.Torso then
		local hitOrgan = false
		if
			HF.Chance(
				HF.Clamp(strength * 0.02, 0, 0.3)
					* NTC.GetMultiplier(character, "anyfracturechance")
					* NTConfig.Get("NT_fractureChance", 1)
			)
		then
			NT.BreakLimb(character, limbtype)
			causeFullForeignBody = true
		end
		if
			HasLungs(character)
			and HF.Chance(
				0.3 * NTC.GetMultiplier(character, "pneumothoraxchance") * NTConfig.Get("NT_pneumothoraxChance", 1)
			)
		then
			HF.AddAffliction(character, "pneumothorax", 5)
			HF.AddAffliction(character, "lungdamage", strength)
			HF.AddAffliction(character, "organdamage", strength / 4)
			hitOrgan = true
		end
		if
			HasHeart(character)
			and hitOrgan == false
			and strength >= 3
			and HF.Chance(
				strength / 50 * NTC.GetMultiplier(character, "tamponadechance") * NTConfig.Get("NT_tamponadeChance", 1)
			)
		then
			HF.AddAffliction(character, "tamponade", 5)
			HF.AddAffliction(character, "heartdamage", strength)
			HF.AddAffliction(character, "organdamage", strength / 4)
			hitOrgan = true
		end
		if strength >= 3 then
			HF.AddAffliction(character, "internalbleeding", strength * HF.RandomRange(0.3, 0.6))
		end

		-- liver and kidney damage
		if hitOrgan == false and strength >= 2 and HF.Chance(0.5) then
			HF.AddAfflictionLimb(character, "organdamage", limbtype, strength / 4)
			if HF.Chance(0.5) then
				HF.AddAffliction(character, "liverdamage", strength)
			else
				HF.AddAffliction(character, "kidneydamage", strength)
			end
		end
	end

	-- head
	if strength >= 1 and limbtype == LimbType.Head then
		if
			HF.Chance(
				strength / 90 * NTC.GetMultiplier(character, "anyfracturechance") * NTConfig.Get("NT_fractureChance", 1)
			)
		then
			NT.BreakLimb(character, limbtype)
			causeFullForeignBody = true
		end
		if strength >= 3 and HF.Chance(0.7) then
			HF.AddAffliction(character, "cerebralhypoxia", strength * HF.RandomRange(0.1, 0.4))
		end
	end

	-- extremities
	if strength >= 1 and HF.LimbIsExtremity(limbtype) then
		if
			NT.LimbIsBroken(character, limbtype)
			and not NT.LimbIsAmputated(character, limbtype)
			and HF.Chance(strength / 60 * NTC.GetMultiplier(character, "traumamputatechance"))
		then
			NT.TraumamputateLimb(character, limbtype)
		end
		if
			HF.Chance(
				strength / 60 * NTC.GetMultiplier(character, "anyfracturechance") * NTConfig.Get("NT_fractureChance", 1)
			)
		then
			NT.BreakLimb(character, limbtype)
			causeFullForeignBody = true
		end
	end

	-- foreign bodies
	if causeFullForeignBody then
		HF.AddAfflictionLimb(
			character,
			"foreignbody",
			limbtype,
			HF.Clamp(strength, 0, 30) *5* NTC.GetMultiplier(character, "foreignbodymultiplier")
		)
	else
		if HF.Chance(0.75) then
			HF.AddAfflictionLimb(
				character,
				"foreignbody",
				limbtype,
				HF.Clamp(strength /4, 0, 20) *5 * NTC.GetMultiplier(character, "foreignbodymultiplier")
			)
		end
	end
end

