-- 仅在客户端执行视野控制逻辑
if SERVER then return end

-- 允许Lua访问相机的缩放控制字段
LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Camera"], "globalZoomScale")

-- 判断角色是否正在使用喷雾器（使用时禁用缩放）
local function IsUsingSprayer(character)
    if not character.IsKeyDown(InputType.Aim) then return false end  -- 未按瞄准键
    if not character.Inventory then return false end  -- 无背包

    -- 获取手持物品（优先右手）
    local rightHand = character.Inventory.GetItemInLimbSlot(InvSlotType.RightHand)
    local leftHand = character.Inventory.GetItemInLimbSlot(InvSlotType.LeftHand)
    local heldItem = rightHand or leftHand

    return heldItem and heldItem.GetComponentString("Sprayer") ~= nil
end

-- 数值限制函数：将值约束在min和max之间
local function ClampValue(value, min, max)
    return math.max(min, math.min(value, max))
end

-- 缩放范围变量（minZoom：最小缩放；maxZoom：实际最大缩放，受双重限制）
local minZoom, maxZoom

-- 更新缩放范围（核心：同时满足「最大为3」和「最大为最小的2倍」）
local function UpdateZoomRange()
    -- 计算基础最小缩放（基于当前分辨率）
    local currentRes = Vector2(GUI.UIWidth, Game.GameScreen.Cam.Resolution.Y)
    local refRes = GUI.ReferenceResolution
    minZoom = currentRes.Length() / refRes.Length()

    -- 计算双重限制下的最大缩放：
    -- 1. 最大为最小缩放的2倍；2. 最大不超过3；取两者中的较小值
    local maxByMin = minZoom * 2  -- 最小缩放的2倍
    maxZoom = math.min(maxByMin, 3)  -- 实际最大缩放 = 两者中的较小值
end
-- 初始化缩放范围
UpdateZoomRange()

-- 强制相机内置最大缩放上限为3（与自定义限制匹配）
Game.GameScreen.Cam.MaxZoom = 3

-- 分辨率变化时（如窗口大小调整），重新计算缩放范围
Hook.Patch(
        "Barotrauma.Camera",
        "SetResolution",
        function(instance, ptable)
            UpdateZoomRange()  -- 重新应用双重限制
        end,
        Hook.HookMethodType.After
)

-- 鼠标滚轮控制视野缩放（核心逻辑）
Hook.Patch(
        "Barotrauma.Character",
        "ControlLocalPlayer",
        function(instance, ptable)
            -- 过滤无效场景：无角色/鼠标在UI上/使用喷雾器
            if not instance then return end
            if Character.IsMouseOnUI then return end
            if IsUsingSprayer(instance) then return end

            local camera = ptable["cam"]
            if not camera then return end

            -- 基于滚轮输入调整缩放（灵敏度：除以1000，可按需修改）
            local newZoom = camera.globalZoomScale + (PlayerInput.ScrollWheelSpeed / 1000)
            -- 应用双重限制：不小于minZoom，不大于计算后的maxZoom（≤3且≤minZoom*2）
            camera.globalZoomScale = ClampValue(newZoom, minZoom, maxZoom)
        end,
        Hook.HookMethodType.After
)

-- 游戏停止时重置缩放为最小状态
Hook.Add("stop", "ResetZoomOnExit", function()
    local mainCamera = Game.GameScreen.Cam
    if mainCamera then
        mainCamera.globalZoomScale = minZoom
    end
end)