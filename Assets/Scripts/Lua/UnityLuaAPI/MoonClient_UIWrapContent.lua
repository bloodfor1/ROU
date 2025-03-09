---@class MoonClient.UIWrapContent : UnityEngine.MonoBehaviour
---@field public updateOneItem (fun(item:UnityEngine.GameObject, index:number):void)
---@field public itemSize UnityEngine.Vector2
---@field public itemOffset UnityEngine.Vector2
---@field public fixedDirection number
---@field public FixedCount number
---@field public Tpl UnityEngine.GameObject

---@type MoonClient.UIWrapContent
MoonClient.UIWrapContent = { }
---@return MoonClient.UIWrapContent
function MoonClient.UIWrapContent.New() end
function MoonClient.UIWrapContent:TestScroll() end
function MoonClient.UIWrapContent:InitContent() end
---@param num number
function MoonClient.UIWrapContent:SetContentCount(num) end
function MoonClient.UIWrapContent:ForceUpdate() end
return MoonClient.UIWrapContent
