if CLIENT and Game.IsMultiplayer then return end

-- 存储延迟信息的表，键为信号发送者，值为最近一次处理的时间，用于限制触发频率
local delay = {}


-- 处理信号接收的函数
-- 参数：signal（接收到的信号）、connection（信号连接对象）
local function HandleReceive(signal, connection)
    -- 如果信号发送者为空，则直接返回（避免空引用错误）
    if signal.sender == nil then return end

    -- 初始化最小延迟时间（默认0，无延迟）
    local minDelay = 0

    -- 根据连接物品的标签设置不同的最小延迟，用于控制传送频率
    if connection.Item.HasTag("smalldelay") then
        minDelay = 0.2  -- 小延迟：0.2秒
    elseif connection.Item.HasTag("mediumdelay") then
        minDelay = 0.5  -- 中延迟：0.5秒
    elseif connection.Item.HasTag("bigdelay") then
        minDelay = 1    -- 大延迟：1秒
    elseif connection.Item.HasTag("hugedelay") then
        minDelay = 2    -- 超大延迟：2秒
    end

    -- 检查发送者是否在最近的最小延迟时间内触发过
    -- 如果是，则不执行后续逻辑（防止短时间内重复触发）
    if delay[signal.sender] and Timer.GetTime() - delay[signal.sender] < minDelay then
        return
    end

    -- 将信号发送者传送到连接物品的世界位置
    signal.sender.TeleportTo(connection.Item.WorldPosition)

    -- 如果发送者有选中的角色，也将该角色传送到相同位置
    if signal.sender.SelectedCharacter then
        signal.sender.SelectedCharacter.TeleportTo(connection.Item.WorldPosition)
    end


    -- 记录当前时间到延迟表，更新发送者最近一次处理的时间
    delay[signal.sender] = Timer.GetTime()
end

-- 注册信号接收钩子：监听 enterable_door1 类型的信号，触发时调用 HandleReceive 处理
Hook.Add("signalReceived.tsm_door_iron1", "OpenDoor", HandleReceive)
-- 注册信号接收钩子：监听 enterable_door2 类型的信号，触发时调用 HandleReceive 处理
Hook.Add("signalReceived.tsm_door_iron2", "OpenDoor", HandleReceive)
-- 注册信号接收钩子：监听 enterable_door3 类型的信号，触发时调用 HandleReceive 处理
Hook.Add("signalReceived.tsm_door_cave1", "OpenDoor", HandleReceive)