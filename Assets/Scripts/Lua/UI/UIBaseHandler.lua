require("Data/BaseModel")
require "UI/UIBase"

module("UI", package.seeall)

-- UI的基类
local super = UI.UIBase
---@class UIBaseHandler : UIBase
UIBaseHandler = class("UIBaseHandler", super)

------------------------------- 生命周期 -------------------------------
--[Comment]
--@inheritable
--Class
function UIBaseHandler:ctor(name)
    self.name = name
    self.ctrlRef = nil
    super.ctor(self)
end

--[Comment]
--@inheritable
--初始化（OnLoaded后调用）
function UIBaseHandler:Init()
    super.Init(self)
    self.canvas = self.uObj:GetComponent("Canvas")
    if MLuaCommonHelper.IsNull(self.canvas) then
        logError("handler必须挂载canvas组件，handler名字=" .. tostring(self.name))
    end
    -- if not self.isActive then
    --     self:_setVisible(false)
    -- end
end

-- 销毁
function UIBaseHandler:Uninit()
    if self._basePanelAsyncLoadTaskId > 0 then
        MResLoader:CancelAsyncTask(self._basePanelAsyncLoadTaskId)
        self._basePanelAsyncLoadTaskId = 0
    end
    super.Uninit(self)
end

--[Comment]
--@override
--打开UI（Active->OnActive->BindEvents->OnShow())
function UIBaseHandler:Active(ctrlRef, callback)

    if self.isActive == true then
        return
    end

    self.ctrlRef = ctrlRef
    self.isActive = true
    self.isShowing = true--ctrlRef:IsShowing()
    if self.uObj ~= nil then
        self:_activeAfterLoaded(callback)
    else
        self:Load(function(ctrl)
            ctrl:_activeAfterLoaded(callback)
        end)
    end
    return true
end
---@Description:处理默认打开第一个handler，无法回调的情况
function UIBaseHandler:SetActiveCallback(callback)
    if callback==nil then
        return
    end
    if self:IsInited() then
        callback(self)
        return
    end
    self.activeCallback = callback
end

function UIBaseHandler:_activeAfterLoaded(callback)
    self.uObj.transform:SetAsLastSibling()
    self:_basePanelBindEvents()
    self:OnActive()

    if callback ~= nil then
        callback(self)
    end

    if self.activeCallback then
        self.activeCallback(self)
        self.activeCallback = nil
    end

    self:OnShow()
    self.ctrlRef:OnHandlerSwitch(self.name)

    if self.isShowing == false or self.ctrlRef:IsShowing() == false then
        self:_setVisible(false)
        self:OnHide()
    else
        self:_setVisible(true)
    end
end

--[Comment]
--@override
--关闭UI（Deactive->UnBindEvents->OnHide->OnDeActive)
function UIBaseHandler:DeActive()
    if self.isActive == false then
        return
    end

    --新手指引箭头关闭
    self:UninitGuideArrow()

    self.isActive = false
    self.isShowing = false

    if self:IsInited() then
        self:_basePanelUnBindEvents()
        self:OnHide()
        self:OnDeActive()
        self:_basePanelAfterOnDeActive()

        if not self.ctrlRef:IsCached() then
            --or not self:IsCached() then --暂不支持部分handler缓存，目前都跟着ctrl走
            self:Uninit()
        else
            self:_setVisible(false)
        end
        self:_releaseAll(not self.ctrlRef:IsCached())
    else
        if self._basePanelAsyncLoadTaskId > 0 then
            MResLoader:CancelAsyncTask(self._basePanelAsyncLoadTaskId)
            self._basePanelAsyncLoadTaskId = 0
        end
    end
    self.ctrlRef = nil

end

--[Comment]
--@override
-- 窗口显示时（Active后调用）
function UIBaseHandler:OnActive()
end

--[Comment]
--@override
-- 窗口显示时（Active后调用）
function UIBaseHandler:OnDeActive()
end

--[Comment]
--@inheritable
--显示
function UIBaseHandler:_basePanelShowUI()
    if self.isShowing then
        return
    end

    self.isShowing = true
    if self.isInited then
        self.uObj.transform:SetAsLastSibling()
        self:_setVisible(true)
        self:OnShow()
    end


end

function UIBaseHandler:OnShow()

end

--[Comment]
--@inheritable
--隐藏
function UIBaseHandler:BasePanelHideUI()
    if not self.isShowing then
        return false
    end

    self.isShowing = false
    if self.isInited then
        self:_setVisible(false)
        self:OnHide()
    end

    return true
end

function UIBaseHandler:OnHide()
end

--[Comment]
--@override
--绑定事件(Active后&OnActive前调用)
function UIBaseHandler:BindEvents()
end

-- 更新
function UIBaseHandler:Update()
end

-- 更新Input
function UIBaseHandler:UpdateInput(touchItem)
    self:passThroughHandler(touchItem)
end

--[Comment]
--@override
--游戏登出
function UIBaseHandler:OnLogout()
end

--[Comment]
--@override
--断线重连
function UIBaseHandler:OnReconnected()

end


------------------------------- END 生命周期 -------------------------------

--[Comment]
--设置UI对象的父元素
function UIBaseHandler:_AddObjToParent()
    if not self.ctrlRef then
        logError("handler parent ctrlRef is not exist, name=" .. tostring(self.name))
        return
    end

    local l_rootUObj = self.ctrlRef.rootUObj or self.ctrlRef.uObj
    if not l_rootUObj then
        logError("handler parent obj is not exist, name=" .. tostring(self.name))
        return
    end

    self.uObj.transform:SetParent(l_rootUObj.transform)
end

return UIBaseHandler
