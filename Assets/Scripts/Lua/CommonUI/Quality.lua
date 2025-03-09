---@module CommonUI.Quality
module("CommonUI.Quality", package.seeall)
declareGlobal("RoQuality", CommonUI.Quality)

--品质定义
None = 0
C = 1
B = 2
A = 3
S = 4

--配置
Cfg = {
[None] = {
	ID = 0, Name = "SETTING_QUALITY_VERYLOW",
    ColorTag = RoColorTag.None,
    WordColor = RoColor.WordColor.None,
    OutlineColor = RoColor.OutlineColor.None,
    BgColor = RoColor.BgColor.None,
},
[C] = {
	ID = 1, Name = "SETTING_QUALITY_LOW",
    ColorTag = RoColorTag.Green,
    WordColor = RoColor.WordColor.Green,
    OutlineColor = RoColor.OutlineColor.Green,
    BgColor = RoColor.BgColor.Green,
},
[B] = {
	ID = 2, Name = "SETTING_QUALITY_MIDDLE",
    ColorTag = RoColorTag.Blue,
    WordColor = RoColor.WordColor.Blue,
    OutlineColor = RoColor.OutlineColor.Blue,
    BgColor = RoColor.BgColor.Blue,
},
[A] = {
	ID = 3, Name = "SETTING_QUALITY_HIGH",
    ColorTag = RoColorTag.Purple,
    WordColor = RoColor.WordColor.Purple,
    OutlineColor = RoColor.OutlineColor.Purple,
    BgColor = RoColor.BgColor.Purple,
},
[S] = {
	ID = 4, Name = "SETTING_QUALITY_HIGH",
    ColorTag = RoColorTag.Yellow,
    WordColor = RoColor.WordColor.Yellow,
    OutlineColor = RoColor.OutlineColor.Yellow,
    BgColor = RoColor.BgColor.Yellow,
}}

-- 称号品质色，特殊处理
TitleCfg = {
    [None] = {
        WordColor = "ffffffff",
    },
    [C] = {
        WordColor = "baff9bff",
    },
    [B] = {
        WordColor = "b8dbffff",
    },
    [A] = {
        WordColor = "c6a3ffff",
    },
    [S] = {
        WordColor = "ffed5aff",
    }
}

--[Comment]
--获取字体品质颜色枚举
--@param quality 品质
--@return colorTag
GetColorTag = function(quality)
    quality = tonumber(quality) or RoQuality.None

    local l_cfg = Cfg[quality]
    if l_cfg == nil then
        logError("[GetColorTag]Invalid quality:{0}, please check it", tostring(quality))
        return nil
    end

    return l_cfg.ColorTag
end

--[Comment]
--获取字体品质颜色
--@param quality 品质
--@param colorScheme 色系(默认深色系)
--@return wordcolor, outlinecolor, bgcolor
GetColorHex = function(quality, colorScheme)
    quality = tonumber(quality) or RoQuality.None
    colorScheme = tonumber(colorScheme) or RoColor.Scheme.Light

    local l_cfg = Cfg[quality]
    if l_cfg == nil then
        logError("[GetColorHex]Invalid quality:{0}, please check it", tostring(quality))
        return nil
    end

    return l_cfg.WordColor[colorScheme], l_cfg.OutlineColor, l_cfg.BgColor
end

--[Comment]
--获取品质名称
--@param quality 品质
GetName = function(quality)
    local l_cfg = Cfg[quality]
    if l_cfg == nil then
        logError("[Quality.GetName]Invalid quality:{0}, please check it", tostring(quality))
        return nil
    end
    return Common.Utils.Lang(l_cfg.Name)
end

-- 获取称号品质色
GetTitleColorHex = function(quality)
    return TitleCfg[quality].WordColor
end