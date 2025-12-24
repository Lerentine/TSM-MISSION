LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.StatusEffect"],"user")

validmarker = {}

Hook.Add("Firesupport.callsupportinit", "Firesupport.callsupportinit", function(effect, deltaTime, item, targets, worldPosition)
    for i,v in pairs(targets) do
        if v.IsHuman and v ~= targets[1] then --and v.IsPlayer
            local targetinv = v.Inventory
            local targetitem = targetinv.FindItemByIdentifier("tsm_firesupportbinocle", false)
            if targetitem ~= nil then
                local targetitm = targetitem.OwnInventory.GetItemAt(0)
                validmarker[targetitm] = targetitm.ID
                return
            end
        end
    end
end)


Hook.Add("Firesupport.supportinbound", "Firesupport.supportinbound", function(effect, deltaTime, item, targets, worldPosition)
    if validmarker == nil then return end
    if validmarker[item] ~= nil then
        item.Condition = 0
        return
    end
end)