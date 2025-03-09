---@class MoonClient.MLuaUICom : UnityEngine.MonoBehaviour
---@field public Name string
---@field public UIPanel MoonClient.MLuaUIPanel
---@field public IsArray boolean
---@field public _luaFuncPackList System.Collections.Generic.List_MoonClient.MLuaFuncPack
---@field public UObj UnityEngine.GameObject
---@field public Transform UnityEngine.Transform
---@field public RectTransform UnityEngine.RectTransform
---@field public IsGray boolean
---@field public Btn UnityEngine.UI.Button
---@field public LongBtn MoonClient.ButtonLongPress
---@field public StrLocal MoonClient.UIStringLocal
---@field public LabText string
---@field public LabColor UnityEngine.Color
---@field public LabRayCastTarget boolean
---@field public Marquee MoonClient.UIMarquee
---@field public Img UnityEngine.UI.Image
---@field public RawImg UnityEngine.UI.RawImage
---@field public Tog UnityEngine.UI.Toggle
---@field public TogGroup UnityEngine.UI.ToggleGroup
---@field public TogEx MoonClient.UIToggleEx
---@field public TogExGroup MoonClient.UIToggleExGroup
---@field public Input UnityEngine.UI.InputField
---@field public TmpInput TMPro.TMP_InputField
---@field public Slider UnityEngine.UI.Slider
---@field public MSlider MoonClient.MUISlider
---@field public DropDown MoonClient.DropdownEx
---@field public Scroll UnityEngine.UI.ScrollRect
---@field public PageView MoonClient.PageView
---@field public Listener MoonClient.MLuaUIListener
---@field public ConBtn MoonClient.ContinuousButton
---@field public TogPanel MoonClient.MTogPanel
---@field public InputNumber MoonClient.MInputNumber
---@field public Grid UnityEngine.UI.GridLayoutGroup
---@field public LGroup UnityEngine.UI.LayoutGroup
---@field public HGroup UnityEngine.UI.HorizontalLayoutGroup
---@field public VGroup UnityEngine.UI.VerticalLayoutGroup
---@field public LoopScroll MoonClient.LoopScrollRect
---@field public GradualChange MoonClient.GradualChange
---@field public Head2D MoonClient.MHeadBehaviour
---@field public FxAnim MoonCommonLib.IFxHelper
---@field public SpineAnim MoonCommonLib.ISpineHelper
---@field public DragItem MoonClient.UIDragDropItem
---@field public DragContainer MoonClient.UIDragDropContainer
---@field public LayoutEle UnityEngine.UI.LayoutElement
---@field public Canvas UnityEngine.Canvas
---@field public CanvasGroup UnityEngine.CanvasGroup
---@field public Fitter UnityEngine.UI.ContentSizeFitter
---@field public ScaleAdjustItem MoonClient.ScaleAdjustItem
---@field public OutLine UnityEngine.UI.Outline
---@field public UiTextOutLine MoonClient.UITextOutLine
---@field public UiTextTypeWriter UITextTypeWriter
---@field public Animatior MoonClient.MUIAnimatior

---@type MoonClient.MLuaUICom
MoonClient.MLuaUICom = { }
---@return MoonClient.MLuaUICom
function MoonClient.MLuaUICom.New() end
---@param isShow boolean
function MoonClient.MLuaUICom:SetActiveEx(isShow) end
---@return UnityEngine.UI.Text
function MoonClient.MLuaUICom:GetText() end
---@return MoonClient.UIRichText
function MoonClient.MLuaUICom:GetRichText() end
---@return TMPro.TextMeshProUGUI
function MoonClient.MLuaUICom:GetTmLab() end
function MoonClient.MLuaUICom:PlayFx() end
function MoonClient.MLuaUICom:PlayChildrenFx() end
---@param luaFunc (fun():void)
---@param clearListener boolean
---@param clickDuration number
function MoonClient.MLuaUICom:AddClick(luaFunc, clearListener, clickDuration) end
---@param luaFunc (fun():void)
---@param luaSelf table
---@param clearListener boolean
---@param clickDuration number
function MoonClient.MLuaUICom:AddClickWithLuaSelf(luaFunc, luaSelf, clearListener, clickDuration) end
---@param clickInterval number
function MoonClient.MLuaUICom:_bindBtnListener(clickInterval) end
function MoonClient.MLuaUICom:_clearLuaPackList() end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MLuaUICom:OnPointerEnter(eventData) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MLuaUICom:OnPointerExit(eventData) end
---@param luaFunc (fun():void)
---@param clearListener boolean
function MoonClient.MLuaUICom:OnInputFieldChange(luaFunc, clearListener) end
---@param luaFunc (fun():void)
---@param clearListener boolean
function MoonClient.MLuaUICom:OnSliderChange(luaFunc, clearListener) end
---@param luaFunc (fun():void)
---@param clearListener boolean
function MoonClient.MLuaUICom:OnToggleChanged(luaFunc, clearListener) end
---@param luaFunc (fun():void)
---@param clearListener boolean
function MoonClient.MLuaUICom:OnToggleExChanged(luaFunc, clearListener) end
---@param gray boolean
function MoonClient.MLuaUICom:SetGray(gray) end
---@param atlasName string
---@param spriteName string
---@param setNativeSize boolean
function MoonClient.MLuaUICom:SetSprite(atlasName, spriteName, setNativeSize) end
---@param atlasName string
---@param spriteName string
---@param callback (fun():void)
---@param setNativeSize boolean
function MoonClient.MLuaUICom:SetSpriteAsync(atlasName, spriteName, callback, setNativeSize) end
function MoonClient.MLuaUICom:ResetSprite() end
---@param enable boolean
function MoonClient.MLuaUICom:SetImgEnable(enable) end
---@param rawName string
---@param setNativeSize boolean
function MoonClient.MLuaUICom:SetRawTex(rawName, setNativeSize) end
---@param rawName string
---@param callback (fun():void)
---@param setNativeSize boolean
function MoonClient.MLuaUICom:SetRawTexAsync(rawName, callback, setNativeSize) end
---@param URL string
---@param callback (fun():void)
function MoonClient.MLuaUICom:DownLoadImageWithURL(URL, callback) end
---@param URL string
---@param width number
---@param height number
---@param callback (fun():void)
---@param setNativeSize boolean
function MoonClient.MLuaUICom:UseLoadImageWithURL(URL, width, height, callback, setNativeSize) end
---@param tex UnityEngine.Texture
function MoonClient.MLuaUICom:SetManualTexture(tex) end
---@param nativeTexture MoonClient.NativeTexture
function MoonClient.MLuaUICom:SetNativeTexture(nativeTexture) end
function MoonClient.MLuaUICom:ResetRawTex() end
---@param enable boolean
function MoonClient.MLuaUICom:SetRawImgEnable(enable) end
---@param location string
function MoonClient.MLuaUICom:SetRawImgMaterial(location) end
---@return number
function MoonClient.MLuaUICom:GetRawImgWidth() end
---@return number
function MoonClient.MLuaUICom:GetRawImgHeight() end
---@param _datas System.String[]
function MoonClient.MLuaUICom:SetDropdownOptions(_datas) end
---@param luaFunc (fun():void)
---@param clearListener boolean
function MoonClient.MLuaUICom:OnScrollRectChange(luaFunc, clearListener) end
---@param fontName string
function MoonClient.MLuaUICom:SetTmpFont(fontName) end
---@param matName string
---@param callback (fun(arg1:TMPro.TextMeshProUGUI, arg2:TMPro.TMP_FontAsset):void)
function MoonClient.MLuaUICom:SetTmpFontAsync(matName, callback) end
---@param matName string
function MoonClient.MLuaUICom:SetTmpMatrial(matName) end
---@param matName string
---@param callback (fun(arg1:TMPro.TextMeshProUGUI, arg2:UnityEngine.Material):void)
function MoonClient.MLuaUICom:SetTmpMatrialAsync(matName, callback) end
function MoonClient.MLuaUICom:ResetTmp() end
---@param text string
---@param setTotalTime number
---@param setStayTime number
function MoonClient.MLuaUICom:StartTypeWriter(text, setTotalTime, setStayTime) end
---@param text string
---@param setcharsPerSecond number
---@param setStayTime number
---@param callback (fun():void)
function MoonClient.MLuaUICom:StartTypeWriterBySetcharsPerSecond(text, setcharsPerSecond, setStayTime, callback) end
---@return number
function MoonClient.MLuaUICom:GetTypeWriterTotalTime() end
---@param height number
function MoonClient.MLuaUICom:SetHeight(height) end
---@param width number
function MoonClient.MLuaUICom:SetWidth(width) end
---@param color UnityEngine.Color
function MoonClient.MLuaUICom:SetOutLineColor(color) end
---@return UnityEngine.Color
function MoonClient.MLuaUICom:GetOutLineColor() end
---@param enable boolean
function MoonClient.MLuaUICom:SetOutLineEnable(enable) end
---@param upGameObject UnityEngine.GameObject
---@param downGameObject UnityEngine.GameObject
---@param upFunc (fun():void)
---@param downFunc (fun():void)
function MoonClient.MLuaUICom:SetScrollRectGameObjListener(upGameObject, downGameObject, upFunc, downFunc) end
---@param state boolean
function MoonClient.MLuaUICom:SetMaskState(state) end
---@param upGameObject UnityEngine.GameObject
---@param downGameObject UnityEngine.GameObject
---@param upFunc (fun():void)
---@param downFunc (fun():void)
function MoonClient.MLuaUICom:SetLoopScrollGameObjListener(upGameObject, downGameObject, upFunc, downFunc) end
---@param upGameObject UnityEngine.GameObject
---@param downGameObject UnityEngine.GameObject
function MoonClient.MLuaUICom:SetScrollRectDownAndUpState(upGameObject, downGameObject) end
---@param upGameObject UnityEngine.GameObject
---@param downGameObject UnityEngine.GameObject
function MoonClient.MLuaUICom:SetLoopScrollRectDownAndUpState(upGameObject, downGameObject) end
---@param isVisible boolean
function MoonClient.MLuaUICom:SetVisible(isVisible) end
---@param id number
---@param param table
function MoonClient.MLuaUICom:PlayDynamicEffect(id, param) end
---@param id number
function MoonClient.MLuaUICom:StopDynamicEffect(id) end
---@param id number
function MoonClient.MLuaUICom:PauseDynamicEffect(id) end
function MoonClient.MLuaUICom:Clear() end
function MoonClient.MLuaUICom:ClearAll() end
return MoonClient.MLuaUICom
