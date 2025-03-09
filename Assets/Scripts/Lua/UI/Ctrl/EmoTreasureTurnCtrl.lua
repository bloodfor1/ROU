--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EmoTreasureTurnPanel"

require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
EmoTreasureTurnCtrl = class("EmoTreasureTurnCtrl", super)
--lua class define end

--lua functions
function EmoTreasureTurnCtrl:ctor()
    
    super.ctor(self, CtrlNames.EmoTreasureTurn, UILayer.Function, nil, ActiveType.Exclusive)
    
end --func end
--next--
function EmoTreasureTurnCtrl:Init()
    
    self.panel = UI.EmoTreasureTurnPanel.Bind(self)
    super.Init(self)

    self.mask=self:NewPanelMask(BlockColor.Dark,nil,function()
        self:CloseUI()
    end)

    --self:SetBlockOpt(BlockColor.Dark, function()
    --    self:CloseUI()
    --end)
    
    self.panel.Button:AddClick(function()
        self:CloseUI()
    end)

    self.panel.Table.gameObject:SetActiveEx(false)
    self.panel.SkeletonGraphic.gameObject:SetActiveEx(false)

    self.raycaster = self.panel.BG10.gameObject:GetComponent("GraphicRaycaster")

    self.fxTask = 0
    self.fxObj = nil

    self.tween = nil
	self.itemTemplates = nil
	self.action = nil
end --func end
--next--
function EmoTreasureTurnCtrl:Uninit()


    if self.fx ~= nil then
        self:DestroyUIEffect(self.fx)
        self.fx = nil
    end



    self:ClearStates()

    self.raycaster = nil
    self.itemTemplates = nil
	self.action = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function EmoTreasureTurnCtrl:OnActive()

    self:ShowTreasure(self.uiPanelData.itemList, self.uiPanelData.itemId)
end --func end
--next--
function EmoTreasureTurnCtrl:OnDeActive()
    if self.timer1 then
        self:StopUITimer(self.timer1)
        self.timer1 = nil
    end

    if self.timer2 then
        self:StopUITimer(self.timer2)
        self.timer2 = nil
    end
    
end --func end
--next--
function EmoTreasureTurnCtrl:Update()
    
    
end --func end





--next--
function EmoTreasureTurnCtrl:BindEvents()
    
    
end --func end

--next--
--lua functions end

--lua custom scripts

function EmoTreasureTurnCtrl:LoadFx(path, scale, height)
    
    self.panel.Fx.gameObject:SetActiveEx(false)

    if self.fx ~= nil then
        self:DestroyUIEffect(self.fx)
        self.fx = nil
    end

    local l_effectFxData = {}
    -- l_effectFxData.parent = self.panel.Fx.transform
    l_effectFxData.rawImage = self.panel.Fx.RawImg
    -- l_effectFxData.rotation = Quaternion.Euler(0, 0, 0)
    l_effectFxData.position = Vector3.New(0, height, 0)
    l_effectFxData.scaleFac = Vector3.New(scale, scale, scale)
    l_effectFxData.playTime = -1

    l_effectFxData.loadedCallback = function(go)
        self.panel.Fx.gameObject:SetActiveEx(true)
    end
    l_effectFxData.destroyHandler = function ()
        self.fx = nil
    end

    self.fx = self:CreateUIEffect(path, l_effectFxData)
end

function EmoTreasureTurnCtrl:RotateFinish(index)

	self.action = nil

    if self.panel == nil or self.panel.Icon[index] == nil then
		return
	end

	self.panel.FxRoot.transform:SetParent(self.panel.BG10.transform)
	self.panel.FxRoot.transform:SetSiblingIndex(0)
    self.panel.FxRoot.transform:SetLocalScale(1.3, 1.3, 1)
    
    self.panel.FxRoot.transform.localPosition = self.panel.Icon[index].transform.localPosition

	self.panel.FxRoot.UObj:SetActiveEx(true)

	self.raycaster.enabled = true
end

function EmoTreasureTurnCtrl:FindIndex(itemList, itemId)

    for i, v in ipairs(itemList) do
        if v == itemId then
            return i
        end
    end
    return 1
end

function EmoTreasureTurnCtrl:ShowTreasure(itemList, itemId)
    
    self:LoadFx("Effects/Prefabs/Creature/Ui/Fx_Ui_EMoBaoZang_ZhuanPan_01", 2.1, -0.7)

    self:ClearStates()
    
    self.panel.SkeletonGraphic.gameObject:SetActiveEx(true)

	if self.itemTemplates == nil then
		self.itemTemplates = {}
		self.itemTemplates = self.itemTemplates
		for i = 1, DataMgr:GetData("TurnTableData").QueryTurnTableRewardCount do
			self.itemTemplates[i] = self:NewTemplate("ItemTemplate", {
				TemplateParent = self.panel.Icon[i].transform,
			})
		end
	end
    
    itemList = itemList or {}
	for i, v in ipairs(self.itemTemplates) do
		v:SetData({ID = itemList[i], IsShowCount = false})
	end
	self.action = true
    self.timer1 = self:NewUITimer(function()
        self.panel.Table.gameObject:SetActiveEx(true)
        self.tween = Common.CommonUIFunc.TweenUI(self.panel.Table.gameObject, UITweenType.Alpha, 1, 0.3, false, function()
            local l_curveCom = self.panel.Arrow10.UObj:GetComponent("UITurnTableAnimationCurve")
            self.raycaster.enabled = false

            local l_anglePart = 360 / DataMgr:GetData("WabaoAwardData").WabaoRewardCount
            local l_index = self:FindIndex(itemList, itemId)
            local l_angle = l_anglePart * (l_index - 1)

            self.panel.FxRoot.UObj:SetActiveEx(true)
            self.panel.FxRoot.transform.localPosition = Vector3.New(0, 10000, 0)
            MLuaClientHelper.PlayFxHelper(self.panel.halo.UObj)
            MgrMgr:GetMgr("WabaoAwardMgr").ActionRotate({
                curveCom = l_curveCom,
                targetAngle = l_angle,
                auto = true,
                callback = function()
                    self:RotateFinish(l_index)
                end
            })
        end)
	end, 1.5)
	self.timer1:Start()

    self.timer2 = self:NewUITimer(function()
        local l_spine = self.panel.SkeletonGraphic.transform:GetComponent("SkeletonGraphic")
        l_spine.startingLoop = true
        l_spine.startingAnimation = "animation2"
	end, 1.4)
	self.timer2:Start()
end


function EmoTreasureTurnCtrl:ClearStates()
    
    if self.tween then
        MUITweenHelper.KillTween(self.tween)
        self.tween = nil
    end
end


function EmoTreasureTurnCtrl:CloseUI()

	-- 逻辑还未做完就退出
	if self.action then
		MgrMgr:GetMgr("WabaoAwardMgr").ForceQuit()
	end
	UIMgr:DeActiveUI(self.name)
end

--lua custom scripts end
return EmoTreasureTurnCtrl