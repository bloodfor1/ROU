module("UIManager", package.seeall)

---@class UIGroupMask
UIGroupMask = class("UIGroupMask")

local uiGroupMaskPath = "UI/Prefabs/BlockBG"

function UIGroupMask:ctor(maskParent, maskColor, maskDelayClickTime, closePanelName,overrideCanvasSortingOrder)

    self.maskGameObject = MResLoader:CreateObjFromPool(uiGroupMaskPath)
    self.maskTransform = self.maskGameObject.transform

    self.maskTransform:SetParent(maskParent, false)

    self.maskTransform:SetAsFirstSibling()

    self.maskGameObject:SetRectTransformOffset(0, 0, 0, 0)
    self.maskGameObject:SetLocalPosZero()
    self.maskGameObject:SetRectTransformAnchor(0, 0, 1, 1)

    MLuaCommonHelper.SetLocalScale(self.maskGameObject, 1, 1, 1)

    self.maskGroup = self.maskGameObject:GetComponent("MLuaUIGroup")

    self:SetVisible(true)

    self.maskComponents = BindMLuaGroup(self.maskGroup)

    if maskColor==nil or maskColor == UI.BlockColor.Transparent then
        self.maskComponents.DarkMask:SetActiveEx(false)
    else
        self.maskComponents.DarkMask:SetRawImgMaterial("")
        self.maskComponents.DarkMask:SetActiveEx(true)
        self.maskComponents.DarkMask.RawImg.color = maskColor
    end

    if closePanelName then
        self.maskComponents.MaskButton:AddClick(function()
            UIMgr:DeActiveUI(closePanelName)
        end)
    end

    --设置延迟点击
    self.maskDelayClickTimer = nil
    if maskDelayClickTime and maskDelayClickTime > 0 then
        local l_maskButton = self.maskComponents.MaskButton.Btn
        l_maskButton.enabled = false
        self.maskDelayClickTimer = Timer.New(function()
            if MLuaCommonHelper.IsNull(l_maskButton) then
                return
            end
            l_maskButton.enabled = true
        end, maskDelayClickTime)
        self.maskDelayClickTimer:Start()
    else
        self.maskComponents.MaskButton.Btn.enabled = true
    end

    if overrideCanvasSortingOrder then
        for i = 0, self.maskGroup.Canvases.Length-1 do
            self.maskGroup.Canvases[i].overrideSorting = true
            self.maskGroup.Canvases[i].sortingOrder = overrideCanvasSortingOrder
        end
    else
        for i = 0, self.maskGroup.Canvases.Length-1 do
            self.maskGroup.Canvases[i].overrideSorting = false
        end
    end

end

function UIGroupMask:SetMaskClickMethod(method)
    if method == nil then
        return
    end

    self.maskComponents.MaskButton:AddClick(function()
        method()
    end)
end

function UIGroupMask:Uninit()

    if self.maskDelayClickTimer then
        self.maskDelayClickTimer:Stop()
        self.maskDelayClickTimer = nil
    end

    if self.maskComponents then
        self.maskComponents.MaskButton:AddClick(nil, true)
        self.maskComponents = nil
    end

    self.maskTransform = nil

    if self.maskGameObject then
        MResLoader:DestroyObj(self.maskGameObject)
        self.maskGameObject = nil
    end

end

function UIGroupMask:SetVisible(isVisible)

    self.maskGroup:SetVisible(isVisible)

end