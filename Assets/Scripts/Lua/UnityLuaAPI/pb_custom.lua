---@class int64
int64 = {}

---@return int64
function int64.new()
end

---@return string
function int64:tostring()
end

---@return int64
---@param a number
---@param b number
function int64.equals(a, b)
end

---@return number,number
function int64:tonum2()
end

---@return boolean
function int64:equals()
end

---@class uint64
uint64 = {}

---@return uint64
function uint64.new()
end

---@return string
function uint64:tostring()
end

---@return uint64
---@param a number
---@param b number
function uint64.equals(a, b)
end

---@return number,number
function uint64:tonum2()
end

---@return boolean
function uint64:equals()
end

---@class usefirststring

---@class ModuleMgr.usefirststring

---@class ModuleData.usefirststring

---@type Game
game = {}
---@type EventDispatcher
GlobalEventBus = {}
---@type ModuleMgr.MgrMgr
MgrMgr = {}
---@type ModuleMgr.MgrProxy
MgrProxy = {}
---@type Stage.StageMgr
StageMgr = {}
array = Common.array
---@type Stage.StageMgr
StageMgr = {}
---@type Common.Serialization
Serialization = {}
Lang = Common.Utils.Lang
DumpTable = Common.Functions.DumpTable
ToString = Common.Functions.ToString
switch = Common.Functions.switch
handler = Common.Functions.handler
IsNil = Common.Functions.IsNil
IsEmptyOrNil = Common.Functions.IsEmptyOrNil
ToInt64 = Common.Functions.ToInt64
ToUInt64 = Common.Functions.ToUInt64
---@type CommonUI.Color
RoColor = {}
RoColorTag = CommonUI.Color.Tag
RoOutlineColor = RoColor.OutlineColor
RoBgColor = RoColor.BgColor

---@type UIManager.UIManager
UIMgr = UIManager.UIManager

GetColorText = RoColor.GetColorText
GetImageText = Common.CommonUIFunc.GetImageText
GetItemText = ModuleMgr.ItemMgr.GetItemText
GetItemIconText = ModuleMgr.ItemMgr.GetItemIconText
---@type CommonUI.Dialog
Dialog = CommonUI.Dialog
EPlatform = GameEnum.EPlatform
EFlag = GameEnum.EFlag
ParseString = Common.Utils.ParseString
---@type ModuleData.DataMgr
DataMgr = {}
---@type Common.eRedSignKey
eRedSignKey = Common.eRedSignKey
---@type CommonUI.Quality
RoQuality = {}
ChatHrefType = ModuleData.ChatData.ChatHrefType

------------------
AwaitOne = Co.AwaitOne
AwaitAll = Co.AwaitAll
AwaitFirst = Co.AwaitFirst
AwaitPattern = Co.AwaitPattern
AwaitTrue = Co.AwaitTrue
AwaitFalse = Co.AwaitFalse
AwaitTime = Co.AwaitTime
AwaitFrame = Co.AwaitFrame
AwaitFrames = Co.AwaitFrames
AwaitRealtime = Co.AwaitRealtime
AwaitEqual = Co.AwaitEqual
AwaitNotEqual = Co.AwaitNotEqual
AwaitNotNilOrFalse = Co.AwaitNotNilOrFalse
AwaitCo = Co.AwaitCo
AwaitTween = Co.AwaitTween
AwaitAnimationPlayOnce = Co.AwaitAnimationPlayOnce
AwaitAnimatorPlayOnce = Co.AwaitAnimatorPlayOnce