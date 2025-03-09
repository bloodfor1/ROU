--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ModelAlarmPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ModelAlarmCtrl = class("ModelAlarmCtrl", super)
--lua class define end

--lua functions
function ModelAlarmCtrl:ctor()
	
	super.ctor(self, CtrlNames.ModelAlarm, UILayer.Tips, nil, ActiveType.Standalone)
	self.cacheGrade = EUICacheLv.VeryLow
	
end --func end
--next--
function ModelAlarmCtrl:Init()
	
	self.panel = UI.ModelAlarmPanel.Bind(self)
	super.Init(self)

	self.timer = nil
	self.duration = nil
	self.creatEntity = nil
	
end --func end
--next--
function ModelAlarmCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ModelAlarmCtrl:OnActive()

    if self.uiPanelData ~= nil then
        self:ShowInfo(self.uiPanelData.ModelType,self.uiPanelData.HostId,self.uiPanelData.Content,self.uiPanelData.Scale,self.uiPanelData.Offset,self.uiPanelData.Duration)
    end
end --func end
--next--
function ModelAlarmCtrl:OnDeActive()
	
	self:Clear()

end --func end
--next--
function ModelAlarmCtrl:Update()
	
	
end --func end





--next--
function ModelAlarmCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function ModelAlarmCtrl:ShowInfo(talkType, hostId, content, scale, offset, duration)
	self:Clear()

	self.panel.ModelImg.gameObject:SetActiveEx(false)
	local l_attr = nil
	local l_tempId = MUIModelManagerEx:GetTempUID()

	local l_talkName = ""
    local l_low = nil
	if talkType == CommonUI.ModelAlarm.ModelType.Player then
		l_attr = MgrMgr:GetMgr("GarderobeMgr").GetRoleAttr(self.name)
        l_talkName = MPlayerInfo.Name
	elseif talkType == CommonUI.ModelAlarm.ModelType.NPC then
		l_attr = MAttrMgr:InitNpcAttr(l_tempId,"",hostId)
		if l_attr then
			l_talkName = l_attr.NpcName
		end
        l_low =  TableUtil.GetNpcTable().GetRowById(hostId)
	elseif talkType == CommonUI.ModelAlarm.ModelType.Monster then
		l_attr = MAttrMgr:InitMonsterAttr(l_tempId,"",hostId)
		if l_attr then
			l_talkName = l_attr.EntityName
		end
        l_low = TableUtil.GetEntityTable().GetRowById(hostId)
	end
    self.panel.NameText.LabText = l_talkName
	--self.panel.TalkContent.LabText = content
	local l_data1 = MGlobalConfig:GetFloat("TypeWriterCharsPerSecond", 0.3)
	local l_data2 = MGlobalConfig:GetFloat("TypeWriterStayTime", 1)
	self.panel.TalkContent:StartTypeWriterBySetcharsPerSecond(content,l_data1, l_data2,function ()
		if self.panel == nil then
			return
		end
		UIMgr:DeActiveUI(CtrlNames.ModelAlarm)
	end)
	--duration = self.panel.TalkContent:GetTypeWriterTotalTime()

	if l_attr == nil then return end
    local l_fxData = {}
    l_fxData.rawImage = self.panel.ModelImg.RawImg
    l_fxData.width = self.panel.ModelImg.RectTransform.sizeDelta.x * 2
    l_fxData.height = self.panel.ModelImg.RectTransform.sizeDelta.y * 2
    l_fxData.isMask = true
    l_fxData.attr = l_attr
    l_fxData.useOutLine = false
    l_fxData.defaultAnim = l_attr.CommonIdleAnimPath
	if talkType == CommonUI.ModelAlarm.ModelType.Player then
		l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)
	end
    if self.creatEntity ~= nil then
        self:DestroyUIModel(self.creatEntity);
    end
    self.creatEntity = self:CreateUIModel(l_fxData)
	self.creatEntity:AddLoadModelCallback(function(m)
    	local l_scale = 0.5/(self.creatEntity.ColRadius~=0 and self.creatEntity.ColRadius or 1)
    	if scale then
    		l_scale = l_scale * scale
    	end
    	local l_offset = 2 - self.creatEntity.ColHeight * l_scale
    	if offset then
            if l_low and l_low.DefaultEquipID and l_low.DefaultEquipID > 0 then
                self.creatEntity.Trans:SetPos(offset[0], offset[1]-0.2+l_offset,offset[2]-1.4)
            else
                self.creatEntity.Trans:SetPos(offset[0], offset[1]-0.2+l_offset,offset[2]-1.0)
            end
    	else
			self.creatEntity.Trans:SetPos(0, -0.2 + l_offset,-1.0)
		end
        self.creatEntity.Trans:SetLocalScale(l_scale, l_scale, l_scale)
        self.panel.ModelImg.gameObject:SetActiveEx(true)
    end)

	

	--if duration and duration > 0 then
	--	self.duration = duration
	--	self.timer = self:NewUITimer(function()
	--        if self.panel == nil then
	--            return
	--        end
	--        UIMgr:DeActiveUI(CtrlNames.ModelAlarm)
    --	end, duration, 0, true)
    --	self.timer:Start()
	--end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Layout.RectTransform)
end

function ModelAlarmCtrl:CreatePlayerModel(playerAttr)
	if playerAttr == nil then return end
    playerAttr:SetHair(MPlayerInfo.HairStyle)
    playerAttr:SetFashion(MPlayerInfo.Fashion)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentHead)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentFace)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentMouth)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentBack)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentTail)
    playerAttr:SetEyeColor(MPlayerInfo.EyeColorID)
    playerAttr:SetEye(MPlayerInfo.EyeID)
    playerAttr:SetWeapon(MPlayerInfo.WeaponFromBag, true)
    playerAttr:SetWeaponEx(MPlayerInfo.WeaponExFromBag, true)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentHeadFromBag, true)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentFaceFromBag, true)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentMouthFromBag, true)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentBackFromBag, true)
    playerAttr:SetOrnament(MPlayerInfo.OrnamentTailFromBag, true)
end

function ModelAlarmCtrl:Clear()
	if self.creatEntity ~= nil then
        self:DestroyUIModel(self.creatEntity)
        self.creatEntity = nil
    end

	if self.timer then
		self:StopUITimer(self.timer)
		self.timer = nil
	end
	self.duration = nil
end

--lua custom scripts end
return ModelAlarmCtrl