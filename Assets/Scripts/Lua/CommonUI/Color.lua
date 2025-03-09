---@module CommonUI.Color
module("CommonUI.Color", package.seeall)
declareGlobal("RoColor", CommonUI.Color)

----------------- color begin -----------------
--Type = {Word = 1, BackGround = 2} --颜色类型（1：文字颜色 2：背景颜色）
Scheme = { Dark = 1, Light = 2 }   --色系（1：暗色 2：亮色）

Tag = {
    None = "None", Green = "Green", Blue = "Blue", Purple = "Purple",
    Yellow = "Yellow", Red = "Red", Gray = "Gray", Pink = "Pink",
    Btn = "Btn", Tog01 = "Tog01", Tog02 = "Tog02", Coffee = "Coffee",
    DarkBlue = "DarkBlue", Lavender = "Lavender", Black = "Black", White = "White"
}
declareGlobal("RoColorTag", CommonUI.Color.Tag)

--None（黑/白）、Green（绿）、Blue（蓝）、Purple（紫）、Yellow（黄）、Red（红）、Gray（灰）
WordColor = {
    None = { "575c62ff", "e7e7e7ff" }, Green = { "50be6cff", "52c56fff" },
    Blue = { "6a9ff0ff", "6cb2f9ff" }, Purple = { "c06edcff", "c55ce9ff" },
    Yellow = { "f29c38ff", "f2be4fff" }, Red = { "f16754ff", "f25541ff" },
    Gray = { "a7b3c2ff", "a7b3c2ff" }, Black = { "727272ff", "727272ff" },
    White = { "ffffffff", "ffffffff" }
}

OutlineColor = { --None 白色
    None = "ffffffff", Green = "409c5eff", Blue = "567bb3ff", Purple = "9a46b7ff",
    Yellow = "bd7432ff", Red = "c54c42ff", Btn = "416ec2ff", Tog01 = "7d6d5dff", Tog02 = "375681ff",
    White = "ffffffff"
}
declareGlobal("RoOutlineColor", RoColor.OutlineColor)

BgColor = { --None 白色
    None = "c6d8e9ff", Green = "6ecc86ff", Blue = "7cabf4ff", Purple = "c87fe1ff",
    Yellow = "f6ae5bff", Red = "f37b71ff", Pink = "fe95b3ff", Coffee = "696259ff",
    DarkBlue = "4f6072ff", Lavender = "8b92bdff", NavyBlue = "334f7aff", White = "ffffffff"
}
declareGlobal("RoBgColor", RoColor.BgColor)

--[Comment]
--获取字体颜色字符串值
--@param colorTag 颜色代号
--@param colorScheme 色系
GetWordColorHex = function(colorTag, colorScheme)
    local l_color = WordColor[colorTag]
    if l_color == nil then
        logError("[GetWordColorHex]Invalid colorTag:{0}, please check it", tostring(colorTag))
        return nil
    end

    colorScheme = tonumber(colorScheme) or Scheme.Light
    return l_color[colorScheme]
end

GetWordColor = function(colorTag, colorScheme)
    return Hex2Rgba(GetWordColorHex(colorTag, colorScheme))
end

GetFontColor = function(colorTag, colorScheme)
    return Hex2Color(GetWordColorHex(colorTag, colorScheme))
end


--[Comment]
--返回颜色格式化后的串
--格式：$$colorTag#Scheme$$ 转化成 颜色16进制
--示例：恭喜<color=$$Blue$$>xxx</color>成功了=>恭喜<color=#60a5eb>xxx</color>成功了
FormatWord = function(str, colorScheme)
    colorScheme = tonumber(colorScheme) or Scheme.Light
    return (string.gsub(str, '%$%$([a-zA-Z]+)%$%$', function(colorTag)
        local l_colorHex = GetWordColorHex(colorTag, colorScheme)
        --- 不存在的颜色模式返回原来的值
        if l_colorHex == nil then
            return StringEx.Format("$${0}$$", colorTag)
        end
        return "#" .. GetWordColorHex(colorTag, colorScheme)
    end))
end

FormatWordDark = function(str)
    return FormatWord(str, Scheme.Dark)
end

FormatWordLight = function(str)
    return FormatWord(str, Scheme.Light)
end

--[Comment]
--返回颜色格式化后的串
--格式：$$colorTag#Scheme$$ 转化成 颜色16进制
--示例：恭喜<color=$$Blue#1$$>xxx</color>成功了=>恭喜<color=#60a5eb>xxx</color>成功了
FormatWord1 = function(str)
    return (string.gsub(str, '%$%$([a-zA-Z]+#%d+)%$%$', function(w)
        local l_colorInfo = string.ro_split(w, '#')
        return "#" .. GetWordColorHex(l_colorInfo[1], l_colorInfo[2])
    end))
end

--[Comment]
--rgb转16进制
Rgb2Hex = function(rgb)
    return string.format("%02X%02X%02X", math.ceil(rgb.r * 255), math.ceil(rgb.g * 255), math.ceil(rgb.b * 255))
end

--[Comment]
--16进制转color
Hex2Color = function(hexStr)
    local r, g, b, a = Hex2Rgba(hexStr)
    return Color(r / 255, g / 255, b / 255, a / 255)
end

--[Comment]
--16进制转rgba
Hex2Rgba = function(hexStr)
    local len = hexStr and string.len(hexStr) or 0
    local pams = {}
    for i = 1, len, 2 do
        table.insert(pams, string.sub(hexStr, i, i + 1))
    end
    return tonumber(pams[1] or 0, 16), tonumber(pams[2] or 0, 16), tonumber(pams[3] or 0, 16), tonumber(pams[4] or 255, 16)
end

--[Comment]
--设置透明度
--a [0, 1]
SetHexAlpha = function(hexStr, a)
    local l_r, l_g, l_b, l_a = Hex2Rgba(hexStr)
    return string.format("%02X%02X%02X%02X", l_r, l_g, l_b, math.floor(a * 255))
end

function GetColorText(text, colorTag, colorScheme)
    if colorTag == "" or colorTag == nil then
        return text
    end
    return FormatWord(string.ro_concat("<color=$$", colorTag, "$$>", text, "</color>"), colorScheme)
end

UIDefineColorValue = {
    TitleColor = "5987e5ff", --标题颜色
    SmallTitleColor = "4b6cbbff", --小标题颜色
    DeclarativeColor = "667db1ff", --陈述性字色
    DeclarativeAssistColor = "afb6d0ff", --陈述性辅助字色
    StressColor = "e5a241ff", --强调字色
    WaringColor = "d05175ff", --警示颜色
    NumericalColor = "46456fff", --数值信息则色
    ItemCountColor = "4B4993FF", --道具数量文本颜色
}

--UI定义的颜色
UIDefineColor = {
    TitleColor = Hex2Color(UIDefineColorValue.TitleColor), --标题颜色
    SmallTitleColor = Hex2Color(UIDefineColorValue.SmallTitleColor), --小标题颜色
    DeclarativeColor = Hex2Color(UIDefineColorValue.DeclarativeColor), --陈述性字色
    DeclarativeAssistColor = Hex2Color(UIDefineColorValue.DeclarativeAssistColor), --陈述性辅助字色
    StressColor = Hex2Color(UIDefineColorValue.StressColor), --强调字色
    WaringColor = Hex2Color(UIDefineColorValue.WaringColor), --警示颜色
    NumericalColor = Hex2Color(UIDefineColorValue.NumericalColor), --数值信息则色
    ItemCountColor = Hex2Color(UIDefineColorValue.ItemCountColor), --道具数量文本颜色
}

function GetTextWithDefineColor(text, colorTag)
    return string.ro_concat("<color=#", colorTag, ">", text, "</color>")
end

declareGlobal("UIDefineColor", RoColor.UIDefineColor)

--策划自定义颜色
UICustomColor = {

}
declareGlobal("UICustomColor", RoColor.UICustomColor)
----------------- color end -----------------