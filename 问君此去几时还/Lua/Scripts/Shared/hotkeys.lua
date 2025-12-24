if SERVER then return end

LuaUserData.MakeFieldAccessible(Descriptors['Barotrauma.Items.Components.CustomInterface'], 'uiElements')

local function toggleTickBox(ci, label)
    local index = 1
    for element in ci.uiElements do
        if LuaUserData.IsTargetType(element, "Barotrauma.GUITickBox") and ci.customInterfaceElementList[index].Label == label then
            element.Selected = not element.Selected
            break
        end
        index = index + 1
    end
end

Hook.Add("think", "tsm_hotkeys", function()
    if Character.Controlled == nil then return end
    if GUI.KeyboardDispatcher.Subscriber ~= nil then return end
    if GUI.InputBlockingMenuOpen then return end

    if PlayerInput.IsAltDown() and PlayerInput.KeyHit(Keys.F) then
        local weapon = nil
        for item in Character.Controlled.HeldItems do
            if item.HasTag("tsm_allowoverheadshooting") then
                weapon = item
            end
        end
        if weapon ~= nil then
            local ci = weapon.GetComponentString("CustomInterface")
            toggleTickBox(ci, "tsm_gun_up")
        end
    end

    if PlayerInput.IsAltDown() and PlayerInput.KeyHit(Keys.G) then
        local helmet = Character.Controlled.GetEquippedItem("tsm_hashelmetinterface", InvSlotType.Head)
        if helmet ~= nil then
            local ci = helmet.GetComponentString("CustomInterface")
            if ci.DrawHudWhenEquipped then
                toggleTickBox(ci, "tsm_on")
            end
        end
    end
    if PlayerInput.IsAltDown() and PlayerInput.KeyHit(Keys.V) then
        local weaponcrate = Character.Controlled.GetEquippedItem("tsm_weaponbackpack", InvSlotType.Bag)
        if weaponcrate ~= nil then
            local ci = weaponcrate.GetComponentString("CustomInterface")
            if ci.DrawHudWhenEquipped then
                toggleTickBox(ci, "Close")
            end
        end
    end

end)