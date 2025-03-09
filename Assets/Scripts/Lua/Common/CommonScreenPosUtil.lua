-- 根据屏幕和输出尺寸位置进行位置的调整
-- 工具模块，业务逻辑无关
---@module Common.CommonScreenPosUtil
module("Common.CommonScreenPosUtil", package.seeall)

local l_screenSize = MUIManager:GetUIScreenSize()
local l_screenWidth = l_screenSize.x
local l_screenHeight = l_screenSize.y

local L_CONST_HALF = 0.5
local L_CONST_AD_TIMES = 2

-- 因为算出来边的位置会刚好在屏幕边缘，所以加一点偏移量，让边界回到一个正常的范围
-- 计算结果如果发生误差可能是和prefab获取的展开值有关系
local L_CONST_OFFSET = 50

local l_right_x_limit = l_screenWidth * L_CONST_HALF
local l_left_x_limit = -(l_screenWidth * L_CONST_HALF)
local l_top_y_limit = l_screenHeight * L_CONST_HALF
local l_bottom_y_limit = -(l_screenHeight * L_CONST_HALF)

-- 分别判断四个边界然后做补偿
-- 内置计数器，如果结果i中结算到有大于两个调整，说明计算错了，或者当前UI超出了屏幕尺寸
function CalcPos(pos, size)
    if nil == pos or nil == size then
        logError("[CommonScreenPosUtil] func param got nil")
        return nil
    end

    local l_counter = 0

    local l_x = pos.x
    local l_y = pos.y

    local l_right_x = pos.x + size.x * L_CONST_HALF
    local l_left_x = pos.x - size.x * L_CONST_HALF
    local l_top_y = pos.y + size.y * L_CONST_HALF
    local l_bottom_y = pos.y - size.y * L_CONST_HALF

    if l_right_x_limit < l_right_x then
        l_x = pos.x - (l_right_x - l_right_x_limit) - L_CONST_OFFSET
        l_counter = l_counter + 1
    end

    if l_left_x_limit > l_left_x then
        l_x = pos.x - (l_left_x - l_left_x_limit) + L_CONST_OFFSET
        l_counter = l_counter + 1
    end

    if l_top_y_limit < l_top_y then
        l_y = pos.y - (l_top_y - l_top_y_limit) - L_CONST_OFFSET
        l_counter = l_counter + 1
    end

    if l_bottom_y_limit > l_bottom_y then
        l_y = pos.y - (l_bottom_y - l_bottom_y_limit) + L_CONST_OFFSET
        l_counter = l_counter + 1
    end

    if L_CONST_AD_TIMES < l_counter then
        logError("[CommonScreenPosUtil] ad time above limit: " .. l_counter)
    end

    local l_ret = { x = l_x, y = l_y, z = pos.z }
    return l_ret
end