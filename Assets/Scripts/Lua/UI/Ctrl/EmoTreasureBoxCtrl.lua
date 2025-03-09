--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EmoTreasureBoxPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
EmoTreasureBoxCtrl = class("EmoTreasureBoxCtrl", super)
--lua class define end

--lua functions
function EmoTreasureBoxCtrl:ctor()
	
	super.ctor(self, CtrlNames.EmoTreasureBox, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function EmoTreasureBoxCtrl:Init()
	
	self.panel = UI.EmoTreasureBoxPanel.Bind(self)
	super.Init(self)

    self.mask=self:NewPanelMask(BlockColor.Dark,nil,function()
        if self.callback then
            self.callback()
            self.callback = nil
        end
        UIMgr:DeActiveUI(self.name)
    end)

    --self:SetBlockOpt(BlockColor.Dark, function()
		--if self.callback then
		--	self.callback()
		--	self.callback = nil
		--end
    --    UIMgr:DeActiveUI(self.name)
    --end)

    self.fxs = {}
	self.callback = nil
end --func end
--next--
function EmoTreasureBoxCtrl:Uninit()


	if self.fxs ~= nil then
        for k, v in pairs(self.fxs) do
            self:DestroyUIEffect(v)
        end
        self.fxs = nil
    end

	self.callback = nil

	if self.closeTimer then
        self:StopUITimer(self.closeTimer)
        self.closeTimer = nil
    end

    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end

	if self.itemTimer then
        self:StopUITimer(self.itemTimer)
		self.itemTimer = nil
	end

    self.itemPrefab = nil

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function EmoTreasureBoxCtrl:OnActive()
	
    self:ShowTreasure(self.uiPanelData.itemId, self.uiPanelData.callback)
end --func end
--next--
function EmoTreasureBoxCtrl:OnDeActive()
	
	
end --func end
--next--
function EmoTreasureBoxCtrl:Update()
	
	
end --func end





--next--
function EmoTreasureBoxCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function EmoTreasureBoxCtrl:LoadFx(path, img, key, x, y, scale)
    
    img.gameObject:SetActiveEx(false)

    if self.fxs[key] ~= nil then
        self:DestroyUIEffect(self.fxs[key])
        self.fxs[key] = nil
    end

    local l_effectFxData = {}
    -- l_effectFxData.parent = self.panel.Fx.transform
    l_effectFxData.rawImage = img
    -- l_effectFxData.rotation = Quaternion.Euler(0, 0, 0)
    l_effectFxData.position = Vector3.New(x or 0, y or 0, 0)
    l_effectFxData.scaleFac = Vector3.New(scale or 1, scale or 1, scale or 1)
    l_effectFxData.playTime = 3

    l_effectFxData.loadedCallback = function(go)
        local l_spineTrans = go.transform:Find("Clip01/Spine GameObject (skeleton)")
        if l_spineTrans then
            local l_spine = l_spineTrans:GetComponent("SkeletonAnimation")
            l_spine:Initialize(true)
            -- l_spine.AnimationName = "animation1"
            -- l_spine.AnimationName = "animation"
        end
        img.gameObject:SetActiveEx(true)
    end
    l_effectFxData.destroyHandler = function ()
        self.fxs[key] = nil
    end

    self.fxs[key] = self:CreateUIEffect(path, l_effectFxData)
end

function EmoTreasureBoxCtrl:ShowTreasure(itemId, callback)

	self:LoadFx("Effects/Prefabs/Creature/Ui/Fx_Ui_EMoZhuanPan_XiaoEMo_01", self.panel.Fx.RawImg, "fx1", -0.05, 0.15, 0.85)

    -- self.panel.SkeletonGraphic.gameObject:SetActiveEx(true)

    local l_startTime = Time.realtimeSinceStartup
    local function _callback(item)
        
        MLuaCommonHelper.SetRectTransformPos(item:gameObject(), 0, 82)

        item:SetGameObjectActive(false)

        self.itemTimer = self:NewUITimer(function()
            item:SetGameObjectActive(true)
                item:SetData({
                ID = itemId, 
                IsShowCount = false, 
                IsShowTips = false,
                -- HideButton = true,
            })
            local l_trans = item:transform()
            MLuaCommonHelper.SetLocalScale(l_trans, 0, 0, 0)
            self.tween = l_trans:DOScale(Vector3.New(1.3, 1.3, 1.3), 1)
            self:LoadFx("Effects/Prefabs/Creature/Ui/Fx_Ui_EMoZhuanPan_XiaoEMo_02", self.panel.Fx1.RawImg, "fx2", 0, 0.3)
        end, 3 - (Time.realtimeSinceStartup - l_startTime))
        self.itemTimer:Start()
    end
    if not self.itemPrefab then
        self.itemPrefab = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.panel.PanelRef.transform
        })
        self.itemPrefab:AddLoadCallback(_callback)
    else
        _callback(self.itemPrefab)
    end

    self:AutoClose(5, callback)
end


function EmoTreasureBoxCtrl:AutoClose(time, callback)

	self.callback = callback
    self.closeTimer = self:NewUITimer(function()
        if self.callback then
            self.callback()
		end
		self.callback = nil
        UIMgr:DeActiveUI(self.name)
    end, time)
    self.closeTimer:Start()
end

--lua custom scripts end
return EmoTreasureBoxCtrl