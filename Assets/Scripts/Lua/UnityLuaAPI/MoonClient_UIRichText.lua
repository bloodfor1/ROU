---@class MoonClient.UIRichText : UnityEngine.UI.Text
---@field public isUseDefaultHrefColor boolean
---@field public onClick (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onDown (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onUp (fun(go:UnityEngine.GameObject, eventData:UnityEngine.EventSystems.PointerEventData):void)
---@field public onHrefClick MoonClient.UIRichText.HrefClickEvent
---@field public onHrefDown MoonClient.UIRichText.HrefClickEvent
---@field public onHrefUp MoonClient.UIRichText.HrefClickEvent
---@field public onHidingTextClick MoonClient.UIRichText.HidingTextClickEvent
---@field public onHidingTextDown MoonClient.UIRichText.HidingTextClickEvent
---@field public onHidingTextUp MoonClient.UIRichText.HidingTextClickEvent
---@field public ContainHref boolean
---@field public FirstChatPos UnityEngine.Vector2
---@field public FirstChatRightTopPos UnityEngine.Vector2
---@field public PopulateMeshAct (fun():void)
---@field public hidingTextWithEllipsis boolean
---@field public SuffixLen number
---@field public MatchFunc (fun(match:System.Text.RegularExpressions.Match):string)
---@field public useEllipsis boolean
---@field public text string
---@field public preferredWidth number
---@field public preferredHeight number

---@type MoonClient.UIRichText
MoonClient.UIRichText = { }
---@return MoonClient.UIRichText
function MoonClient.UIRichText.New() end
function MoonClient.UIRichText:SetVerticesDirty() end
function MoonClient.UIRichText:Release() end
---@return UnityEngine.Vector2
---@param imgNativeSize UnityEngine.Vector2
---@param scaledFontSize number
function MoonClient.UIRichText:_calcDisplaySize(imgNativeSize, scaledFontSize) end
---@return number
---@param scrValue number
---@param targetValue number
---@param templateValue number
function MoonClient.UIRichText:_calcScaledValue(scrValue, targetValue, templateValue) end
function MoonClient.UIRichText:DelImageById() end
function MoonClient.UIRichText:DelHrefById() end
---@return string
---@param hrefName string
function MoonClient.UIRichText:GetHrefValue(hrefName) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIRichText:OnPointerClick(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIRichText:OnPointerDown(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.UIRichText:OnPointerUp(eventData) end
---@param clickImageName string
---@param clickAction (fun(arg0:string, arg1:UnityEngine.EventSystems.PointerEventData):void)
function MoonClient.UIRichText:AddImageClickFuncToDic(clickImageName, clickAction) end
function MoonClient.UIRichText:ClearImgClickInfo() end
---@param name string
---@param height number
---@param width number
---@param useCustomSize boolean
---@param shiftX number
---@param shiftY number
function MoonClient.UIRichText:AddCustomSetImgToDic(name, height, width, useCustomSize, shiftX, shiftY) end
return MoonClient.UIRichText
