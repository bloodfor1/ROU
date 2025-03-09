module("Common.Utils", package.seeall)

local DropType = {
    RightDown = 1,
    LeftDown = 2,
    RightUp = 3,
    LeftUp = 4,
    Right = 5,
    Left = 6
}

local function _replace(str)
    return (string.gsub(str, "\\n", "\n"))
end

function Lang(key, ...)
    local l_str = nil
    if type(key) == "table" then
        if key.type == LocalizationNameType.kLocalizationNameTypeID then
            l_str = StringPoolManager:GetString(key.id)
        elseif key.type == LocalizationNameType.kLocalizationNameTypeKey then
            l_str = Lang(key.str)
        elseif key.type == LocalizationNameType.kLocalizationNameTypeCusmStr then
            l_str = key.str
        else
            logError("类型非法：LocalizationNameType={0}", tostring(key.type))
            return StringEx.Format("type={0}|id={1}|str={2}", tostring(key.type), tostring(key.id), tostring(key.str))
        end
    else
        key = tostring(key)
        l_str = Localization:Get(key) --TableUtil.GetStringTable().GetRowById(key).Value
        if string.ro_isEmpty(l_str) then
            logError("key无法找到对应值, key={0}", tostring(key))
            return key
        end
    end

    local l_arglen = select('#', ...)
    if l_arglen > 0 then
        return _replace(StringEx.Format(l_str, ...))
    else
        return _replace(l_str)
    end
end

-- 获取玩家名字，为空则返回初心者
function PlayerName(name)
    if not IsEmptyOrNil(name) then
        return name
    else
        return Lang("PLAYER_INITIAL_NAME")
    end
end

function IsNilOrEmpty(str)
    return not str or str == ""
end

--==============================--
--@Description:long2num
--@Date: 2018/10/13
--@Param: [args]
--@Return:
--==============================--
function Long2Num(long)
    return tonumber(tostring(long))
end

--==============================--
--@Description: 截取中文字符（允许存在英文字符标点符号）
--@Date: 2018/9/30
--@Param: [args]
--@Return:
--==============================--
function GetCutOutText(str, limitCount)
    local l_res = string.ro_cut(str, limitCount*2)
    if #l_res < #str then l_res = l_res .. ".." end
    return l_res
end

--==============================--
--@Description:将秒数转换为分数显示
--@Date: 2018/10/13
--@Param: [args]
--@Return:
--==============================--
function FormatMinuteTime(time)
    local min = math.floor(time / 60)
    local sec = math.ceil(time % 60)
    return StringEx.Format("{0}:{1}", min, sec)
end

--==============================--
--@Description:判断两个矩形相交 判断两矩形是否相交、原理狠简单、如果相交、肯定其中一个矩形的顶点在另一个顶点内
--@Date: 2018/12/13
--@Param: [args]
--@Return:
--==============================--
function IsRectTransformOverlap(r1, r2)
    local l_vectorArray1 = System.Array.CreateInstance(System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule"), 4)
    local l_vectorArray2 = System.Array.CreateInstance(System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule"), 4)
    r1:GetWorldCorners(l_vectorArray1)
    r2:GetWorldCorners(l_vectorArray2)
    local x1 = l_vectorArray1[0].x
    local y1 = l_vectorArray1[0].y
    local x2 = l_vectorArray1[2].x
    local y2 = l_vectorArray1[2].y

    local x3 = l_vectorArray2[0].x
    local y3 = l_vectorArray2[0].y
    local x4 = l_vectorArray2[2].x
    local y4 = l_vectorArray2[2].y
    return ((x1 >= x3 and x1 < x4) or (x3 >= x1 and x3 <= x2)) and ((y1 >= y3 and y1 < y4) or (y3 >= y1 and y3 <= y2))
end

--==============================--
--@Description:解析字符串
--@Date: 2019/6/20
--@Param: [args]parseStr字符串本身 separator分隔符 minNum分隔后个数限制，小于此值将返回nil
--@Return:
--==============================--
function ParseString(parseStr, separator, minNum)
    local l_splitArray = string.ro_split(parseStr, separator);
    if l_splitArray == nil or #l_splitArray < minNum then
        return nil;
    end
    return l_splitArray;
end

--==============================--
--@Description:c#数组是否包含某个值
--@Date: 2019/6/20
--@Param: [args]
--@Return:
--==============================--
function CSharpArrayContainValue(csharpArray, value)
    if csharpArray == nil or value == nil then
        return false
    end
    local l_arrayLen = csharpArray.Length
    for i = 0, l_arrayLen - 1 do
        if csharpArray[i] == value then
            return true
        end
    end
    return false
end

function CanDrop(width, height, clickWorldPos, dropType)
    local ret = true
    local scale = MUIManager:GetFullScreenScale(Vector2(Screen.width, Screen.height))
    local layouWidth = width / scale
    local layoutHeight = height / scale
    local delta = 0
    local minPos, maxPos = Vector2.zero, Vector2.zero
    local anchor = Vector2.zero
    if dropType == DropType.LeftDown then
        delta = Vector2(-delta, 0)
        anchor = Vector2(1, 1)
    elseif dropType == DropType.LeftUp then
        delta = Vector2(-delta, 0)
        anchor = Vector2(1, 0)
    elseif dropType == DropType.RightDown then
        delta = Vector2(delta, 0)
        anchor = Vector2(0, 1)
    elseif dropType == DropType.RightUp then
        delta = Vector2(delta, 0)
        anchor = Vector2(0, 0)
    elseif dropType == DropType.Right then
        delta = Vector2(delta, 0)
        anchor = Vector2(0, 0.5)
    elseif dropType == DropType.Left then
        delta = Vector2(-delta, 0)
        anchor = Vector2(1, 0.5)
    end
    local objWorldPos = MUIManager.UICamera:WorldToScreenPoint(clickWorldPos + Vector3(delta.x, delta.y, 0))
    if dropType == DropType.LeftDown then
        minPos = Vector2(objWorldPos.x - layouWidth, objWorldPos.y - layoutHeight)
        maxPos = Vector2(objWorldPos.x, objWorldPos.y)
    elseif dropType == DropType.LeftUp then
        minPos = Vector2(objWorldPos.x - layouWidth, objWorldPos.y)
        maxPos = Vector2(objWorldPos.x, objWorldPos.y + layoutHeight)
    elseif dropType == DropType.RightDown then
        minPos = Vector2(objWorldPos.x, objWorldPos.y - layoutHeight)
        maxPos = Vector2(objWorldPos.x + layouWidth, objWorldPos.y)
    elseif dropType == DropType.RightUp then
        minPos = Vector2(objWorldPos.x, objWorldPos.y)
        maxPos = Vector2(objWorldPos.x + layouWidth, objWorldPos.y + layoutHeight)
    elseif dropType == DropType.Right then
        minPos = Vector2(objWorldPos.x, objWorldPos.y - layoutHeight * 0.5)
        maxPos = Vector2(objWorldPos.x + layouWidth, objWorldPos.y + layoutHeight * 0.5)
    elseif dropType == DropType.Left then
        minPos = Vector2(objWorldPos.x - layouWidth, objWorldPos.y - layoutHeight * 0.5)
        maxPos = Vector2(objWorldPos.x, objWorldPos.y + layoutHeight * 0.5)
    end

    UnityEngine.Debug.DrawLine(MUIManager.UICamera:ScreenToWorldPoint(Vector3(minPos.x, minPos.y, objWorldPos.z)),
            MUIManager.UICamera:ScreenToWorldPoint(Vector3(maxPos.x, maxPos.y, 0)),
            Color.red, 10)
    local screenSizeDelta = Screen.safeArea
    ret = minPos.x > screenSizeDelta.x and minPos.y > screenSizeDelta.y
            and maxPos.x * 1.02 < screenSizeDelta.x + screenSizeDelta.width and maxPos.y * 1.02 < screenSizeDelta.y + screenSizeDelta.height
    --为了避免UI刚好贴着屏幕的边
    return ret, delta, anchor
end

function GetUIProperPosInScreen(width, height, clickWorldPos)
    local canDrop, delta, anchor
    for i = 1, table.count(DropType) do
        canDrop, delta, anchor = CanDrop(width, height, clickWorldPos, i)
        if canDrop then
            break
        end
    end
    return canDrop, delta, anchor
end

function ParseVector3(str, split)
    local ret = Vector3.zero

    if IsNilOrEmpty(str) then
        return ret
    end

    split = split or ','
    local arr = string.ro_split(str, split)
    ret.x = tonumber(arr[1]) or 0
    ret.y = tonumber(arr[2]) or 0
    ret.z = tonumber(arr[3]) or 0

    return ret
end

return Utils