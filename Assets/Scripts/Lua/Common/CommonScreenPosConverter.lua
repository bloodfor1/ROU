--- UI root会根据屏幕坐标做一个调整，会进行一个大边对齐，然后去对小边进行缩放
--- 所以这个时候如果想要从3D表现上的位置对齐2DUI的位置，就需要透过这层转换
--- 需要转换的坐标是以屏幕左下角为原点的

---@module Common.CommonScreenPosConverter
module("Common.CommonScreenPosConverter", package.seeall)

local l_refResolution = MUIManager:GetCanvasScalerReferenceResolution()

---@class Vector2
local l_canvasScale = {
    x = l_refResolution.x,
    y = l_refResolution.y
}

---@type Vector2
local l_screenSize = {
    x = Screen.width,
    y = Screen.height
}

---@param screenSize Vector2
---@param refRes Vector2
---@return number
function _getScaleRatio(screenSize, refRes)
    if not _validateVec2(screenSize) or not _validateVec2(refRes) then
        logError("[CommonScreenPosConverter] param invalid")
        return 1
    end

    local l_rateScreen = screenSize.x / screenSize.y
    local l_rateRef = refRes.x / refRes.y
    if l_rateScreen >= l_rateRef then
        return refRes.y / screenSize.y
    else
        return refRes.x / screenSize.x
    end

    return 1
end

---@param vec2 Vector2
---@return boolean
function _validateVec2(vec2)
    if nil == vec2 then
        return false
    end

    if 0 == vec2.x or 0 == vec2.y then
        return false
    end

    return true
end

local l_scaleRate = _getScaleRatio(l_screenSize, l_canvasScale)

---@param screenPos Vector2
---@return Vector2
function ConvertedRectTransformPos(screenPos)
    if nil == screenPos then
        logError("[CommonScreenPosConverter] param got nil")
        return {}
    end

    -- 1 计算屏幕坐标是按照那条边进行所缩放的，并求出缩放比例
    --logError(ToString(l_screenSize))
    --logError(ToString(l_rate))

    -- 2 根据缩放比例求出屏幕坐标
    ---@type Vector2
    local l_ret = {
        x = screenPos.x * l_scaleRate,
        y = screenPos.y * l_scaleRate,
    }

    return l_ret
end

--获取当前的屏幕和标准设置的缩放比例
function GetScreenScaleRate()
    return l_scaleRate
end

--获取当前分辨率下的安全区域偏移
function GetScreenOffset()
    --获取到屏幕缩放比率
    local l_rate = 1- l_scaleRate
    --获取到当前屏蔽的安全区域
    local l_safeAreaRect = MDevice.TryGetScreenScale()

    local l_y_offSet = 0

    if l_safeAreaRect then
        l_y_offSet = l_safeAreaRect.y * l_rate
    end

    if l_y_offSet > 50 then
        logError("偏移计算有误",ToString(l_rate),ToString(MDevice.TryGetScreenScale()))
        return 0
    end

    return l_y_offSet
end