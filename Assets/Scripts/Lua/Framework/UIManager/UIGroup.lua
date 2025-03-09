module("UIManager", package.seeall)

require "Framework/UIManager/UIGroupMask"

-- UI组
---@class UIGroup
UIGroup = class("UIGroup")

--组的GroupGame池的id
local _gameObjectPoolId
--Unity的RectTransform的类型
local _rectTransformType = System.Type.GetType("UnityEngine.RectTransform, UnityEngine")

--创建物体时的回调
local function _registerGroupGameObjectPoolOnCreateCallBack(gameObject)
    --添加RectTransform组件
    gameObject:AddComponent(_rectTransformType)
    gameObject:SetRectTransformAnchor(0, 0, 1, 1)
end

--注册对象池
local function _registerGroupGameObjectPoolId()
    _gameObjectPoolId = MResGoPool:Register(_registerGroupGameObjectPoolOnCreateCallBack, nil)
end

_registerGroupGameObjectPoolId()

function UIGroup:ctor(groupName)

    self.groupName = groupName

    --组中的主功能界面名字
    self.mainUIPanelNames = nil

    --组中的所有界面名字
    --键值对形式
    self.uiPanelNames = {}

    --组的界面数据
    self.data = nil

    --此Group隐藏的Group名字
    self.hideGroupNames = nil

    --隐藏自己的组的组名字
    self.hideSelfGroupName = nil

    ---@type UIPanelConfig
    self.uiGroupConfig = nil

    --是否打开了一个组
    self.isOpenGroup = false

    --每个组都会创建一个空物体，里面放遮罩和组中的界面
    self.groupGameObject = nil
    self.groupGameObjectTransform = nil

    --组中的遮罩
    self.groupMask = nil

end

--在打开组的时候调用
--创建组的空物体和遮罩
function UIGroup:CreateGroupGameObject(uiPanelConfigData)

    if self.groupGameObject then
        return
    end

    self.groupGameObject = MResGoPool:CreateGo(_gameObjectPoolId)

    self.groupGameObject.layer = MLayer.ID_UI

    self.groupGameObject.name = self.groupName

    self.groupGameObjectTransform = self.groupGameObject.transform

    local l_groupContainerTransform = UIMgr:GetGroupContainerTransform(uiPanelConfigData:GetGroupContainerType())

    self.groupGameObjectTransform:SetParent(l_groupContainerTransform, false)

    MLuaCommonHelper.SetLocalScale(self.groupGameObject, 1, 1, 1)

    self.groupGameObject:SetRectTransformOffset(0, 0, 0, 0)

    local overrideCanvasSortingOrder=uiPanelConfigData:GetOverrideCanvasSortingOrder()
    if overrideCanvasSortingOrder then
        overrideCanvasSortingOrder=overrideCanvasSortingOrder-1
    end

    if uiPanelConfigData:IsNeedShowMask() then
        self.groupMask = UIGroupMask.new(
                self.groupGameObjectTransform,
                uiPanelConfigData:GetMaskColor(),
                uiPanelConfigData:GetMaskDelayClickTime(),
                uiPanelConfigData:GetClosePanelNameOnClickMask(),
                overrideCanvasSortingOrder)
    end

end

--在关闭组的时候调用
--销毁创建的遮罩和组的空物体
function UIGroup:_destroyGroupGameObject()

    if self.groupMask then
        self.groupMask:Uninit()
        self.groupMask = nil
    end

    self.groupGameObjectTransform = nil

    if self.groupGameObject then
        MResGoPool:DestroyGo(self.groupGameObject)
        self.groupGameObject = nil
    end

end

function UIGroup:GetGroupTransform()

    if self.groupGameObjectTransform == nil then
        logError("组的物体是空的，组名字：" .. tostring(self.groupName))
    end

    return self.groupGameObjectTransform
end

function UIGroup:SetVisible(isVisible)

    if self.groupMask then
        self.groupMask:SetVisible(isVisible)
    end

    if self.groupGameObject then
        local l_layerID = isVisible and MLayer.ID_UI or MLayer.ID_INVISIBLE
        self.groupGameObject.layer = l_layerID
    end

end

function UIGroup:Uninit()
    self:_destroyGroupGameObject()
end

--打开单一界面
--使用此方式打开界面，这个界面绝对没有组配置
function UIGroup:ActiveUIPanel(uiName, uiPanelData, uiPanelConfigData)

    if uiName == nil then
        return
    end

    self:_setGroupConfigOnActiveUIPanel(uiName, uiPanelConfigData)

    self:_addPanelName(uiName)

    if self.data == nil then
        self.data = {}
    end
    self.data[uiName] = uiPanelData

end

--当只打开了一个界面时，处理组存储的数据
--1、如果这个组之前没打开过界面，那么这个界面是这个组的第一个界面
--   此时不管这个界面是什么设置，都认为这个界面是这个组的主功能界面
--2、如果这个组打开过别的界面了，则判断当前打开的界面是不是这个组的主功能界面，如果是的话把数据进行替换
--   此逻辑是解决先打开设置了InsertGroupName的界面，后面才打开InsertGroupName所对应的界面
function UIGroup:_setGroupConfigOnActiveUIPanel(uiName, uiPanelConfigData)

    --如果是直接打开一个组，相应的设置需要按组的方式来设置，不再管单独界面的设置
    if self.isOpenGroup then
        return
    end

    --打开第一个界面的时候此界面设为主功能界面
    if self.mainUIPanelNames == nil then
        --这一块的逻辑现在应该是走不到了，在前面就会报错
        self.mainUIPanelNames = {}
        table.insert(self.mainUIPanelNames, uiName)

        --只有打开第一个界面的时候，把这个界面的配置当成整组的配置
        self.uiGroupConfig = uiPanelConfigData
    else

        local l_groupName = UIGroupDefine:GetGroupName(uiName)
        --判断打开的界面是不是这个组的主功能界面
        if l_groupName == self.groupName then
            --判断主功能界面是不是只有一个，如果只有一个则换成此界面
            if #self.mainUIPanelNames == 1 then
                self.mainUIPanelNames[1] = uiName
            end
            self.uiGroupConfig = uiPanelConfigData
        end
    end
end

--根据组配置打开一组界面
function UIGroup:ActiveGroupWithGroupDefine(groupDefine, uiPanelDatas, uiPanelConfig)
    if groupDefine == nil then
        logError("groupDefine == nil")
        return
    end
    self.isOpenGroup = true
    self:_setGroupDefine(groupDefine, uiPanelDatas, uiPanelConfig)
    self.hideSelfGroupName = nil
end

function UIGroup:ExchangeGroupDefine(groupDefine, uiPanelDatas, uiGroupConfigData)
    if groupDefine == nil then
        logError("groupDefine == nil")
        return
    end
    self:_setGroupDefine(groupDefine, uiPanelDatas, uiGroupConfigData)
end

function UIGroup:_setGroupDefine(groupDefine, uiPanelDatas, uiGroupConfigData)
    if groupDefine == nil then
        logError("groupDefine == nil")
        return
    end

    --groupDefine可以不设置MainPanelNames，此时必须按组的方式关闭界面
    self.mainUIPanelNames = groupDefine.MainPanelNames

    --按组打开的时候要把之前打开的界面去掉
    for key, v in pairs(self.uiPanelNames) do
        self.uiPanelNames[key] = nil
    end

    local l_uiPanelNames = groupDefine.UIPanelNames
    for i = 1, #l_uiPanelNames do
        self:_addPanelName(l_uiPanelNames[i])
    end

    self.data = uiPanelDatas

    self.uiGroupConfig = uiGroupConfigData
end

function UIGroup:_addPanelName(uiName)
    if self.uiPanelNames[uiName] == nil then
        self.uiPanelNames[uiName] = uiName
    end
end

--键值对形式存储，使用pairs进行遍历
function UIGroup:GetPanelNames()
    return self.uiPanelNames
end

--界面是否是组的主功能界面
function UIGroup:IsGroupMainUIPanel(uiName)
    if self.mainUIPanelNames == nil then
        return false
    end

    return table.ro_contains(self.mainUIPanelNames, uiName)
end

--取界面对应的数据
function UIGroup:GetPanelDataWithPanelName(uiName)
    if self.data == nil then
        return nil
    end
    return self.data[uiName]
end

--取组名字
function UIGroup:GetGroupName()
    return self.groupName
end

--存储当前组隐藏的组的名字
function UIGroup:SetHideGroupNames(hideGroupNames)
    self.hideGroupNames = hideGroupNames
end
--获取当前组隐藏的组的名字
function UIGroup:GetHideGroupNames()
    return self.hideGroupNames
end

--设置隐藏此组的组的名字
function UIGroup:SetHideSelfGroupName(hideSelfGroupName)
    self.hideSelfGroupName = hideSelfGroupName
end
--获取隐藏此组的组的名字
function UIGroup:GetHideSelfGroupName()
    return self.hideSelfGroupName
end
--是否隐藏
function UIGroup:IsGroupHide()
    return self.hideSelfGroupName ~= nil
end

--这个组是否在切场景的时候关闭
function UIGroup:IsCloseOnSwitchScene()
    if self.uiGroupConfig == nil then
        logError("self.uiGroupConfig == nil")
        return false
    end
    return self.uiGroupConfig:IsCloseOnSwitchScene()
end

function UIGroup:IsKeepShowOnAllScene()
    if self.uiGroupConfig == nil then
        logError("self.uiGroupConfig == nil")
        return false
    end
    return self.uiGroupConfig:IsKeepShowOnAllScene()
end

function UIGroup:IsStandalone()
    if self.uiGroupConfig == nil then
        logError("self.uiGroupConfig == nil")
        return false
    end
    return self.uiGroupConfig:IsStandalone()
end

function UIGroup:GetForceHidePanelNames()
    if self.uiGroupConfig == nil then
        logError("self.uiGroupConfig == nil")
        return nil
    end
    return self.uiGroupConfig:GetForceHidePanelNames()
end

function UIGroup:GetGroupContainerType()
    if self.uiGroupConfig == nil then
        logError("self.uiGroupConfig == nil")
        return nil
    end
    return self.uiGroupConfig:GetGroupContainerType()
end

function UIGroup:IsTakePartInGroupStack()
    if self.uiGroupConfig == nil then
        logError("self.uiGroupConfig == nil")
        return false
    end
    return self.uiGroupConfig:IsTakePartInGroupStack()
end

function UIGroup:DebugLog()

    if not Application.isEditor then
        logError("测试打印Log使用，不要在正式流程中使用")
        return
    end

    logRed("--组名字：" .. self.groupName)

    local l_mainPanelNames = ""
    if self.mainUIPanelNames then
        for i = 1, #self.mainUIPanelNames do
            l_mainPanelNames = l_mainPanelNames .. "、" .. self.mainUIPanelNames[i]
        end
    end
    logGreen("----主功能名字：" .. l_mainPanelNames)

    local l_panelNames = ""
    for i, uiName in pairs(self.uiPanelNames) do
        l_panelNames = l_panelNames .. "、" .. uiName
    end
    logGreen("----组中界面名字：" .. l_panelNames)
end

return UIGroup