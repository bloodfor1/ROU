--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainBuffPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_buffData = DataMgr:GetData("BuffData")
--next--
--lua fields end

--lua class define
MainBuffCtrl = class("MainBuffCtrl", super)
--lua class define end

local UPDTAE_DURATION = 2

--lua functions
function MainBuffCtrl:ctor()

	super.ctor(self, CtrlNames.MainBuff, UILayer.Normal, nil, ActiveType.Normal)
	self.cacheGrade = EUICacheLv.VeryLow

end --func end
--next--
function MainBuffCtrl:Init()

	self.panel = UI.MainBuffPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function MainBuffCtrl:Uninit()

	if self.buff1 then
		MResLoader:DestroyObj(self.buff1.go)
		self.buff1 = nil
	end
	if self.buff2 then
		MResLoader:DestroyObj(self.buff2.go)
		self.buff2 = nil
	end
	if self.buff3 then
		MResLoader:DestroyObj(self.buff3.go)
		self.buff3 = nil
	end
	self:ClearFx()
	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function MainBuffCtrl:OnActive()
    if self.uiPanelData then
        if self.uiPanelData.openType == l_buffData.EMainBuffOpenType.UpdateBuff then
			self:UpdateBuff()
        end
    end
end --func end
--next--
function MainBuffCtrl:OnDeActive()


end --func end
--next--
function MainBuffCtrl:Update()

	if not self.updateNum then
		self.updateNum = 0
	end
	self.updateNum = self.updateNum + 1
	if self.startTime and #self.timeLab > 0 and self.updateNum > UPDTAE_DURATION then
		self.updateNum = nil
		local l_pass = Time.realtimeSinceStartup - self.startTime
		for i = 1, #self.timeLab do
            --永久存在的buff不参与倒计时
			if self.timeLab[i] and not self.timeLab[i].forever then
				local l_time = self.timeLab[i].remain - l_pass
				local l_remain = math.ceil(l_time)
				if l_remain > 0 then
					self.timeLab[i].LabText = tostring(l_remain)
					self.timeLab[i].Bg.fillAmount = 1 - l_time / self.timeLab[i].all
				else
					self.timeLab[i].go:SetActiveEx(false)
                    table.ro_removeValue(self.curBuff, self.timeLab[i].id)
					local l_fx = self.timeLab[i].fx
					if l_fx ~= nil then
						self:DestroyUIEffect(l_fx)
						l_fx = nil
					end
					self.timeLab[i] = nil
				end
			end
		end
	end

end --func end





--next--
function MainBuffCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function MainBuffCtrl:InitBuff(buff)
    local l_info = buff.info
    local l_id = l_info.buff.tableInfo.Id
    if not self.curBuff then
        self.curBuff = {}
    end
    table.insert(self.curBuff,l_id)

    local l_index = #self.timeLab+1
    self.timeLab[l_index] = {}
    self.timeLab[l_index].id = l_id
    self.timeLab[l_index].go = buff.go
    self.timeLab[l_index].Lab = buff.timeLab
    self.timeLab[l_index].Bg = buff.bg
    self.timeLab[l_index].remain = l_info.buff.remainTime
    --remain为0时永久存在
    if l_info.buff.remainTime == 0 then
        self.timeLab[l_index].forever = true
    end
    self.timeLab[l_index].all = l_info.buff.totalTime
    self.timeLab[l_index].fx = buff.fx


	buff.go:SetActiveEx(true)
	buff.icon:SetSprite(l_info.buff.tableInfo.IconAtlas,l_info.buff.tableInfo.Icon)
	buff.nameLab.LabText = l_info.name
	buff.timeLab.LabText = tostring(math.ceil(l_info.buff.remainTime))
    if self.timeLab[l_index].forever then
        buff.bg.fillAmount = 0
    else
        buff.bg.fillAmount = 1- l_info.buff.remainTime/l_info.buff.totalTime
    end

	if buff.fx ~= nil then
		self:DestroyUIEffect(buff.fx)
		buff.fx = nil
	end

    --用于判断是否是首次出现
	if not self.preBuff or not table.ro_contains(self.preBuff,l_id) then
		if buff.isBoss then
			MLuaClientHelper.PlayFxHelper(buff.go)
		else
			local l_anim = buff.go:GetComponent("DOTweenAnimation")
			if l_anim then
				l_anim:DORestart()
				l_anim:DOPlayForward()
			end
		end
        if buff.effectImg then
            local l_fxData = {}
            l_fxData.rawImage = buff.effectImg.RawImg
            buff.fx = self:CreateUIEffect(self.Mgr.ReduceStatrEffect, l_fxData)
            
        end
	end
end

function MainBuffCtrl:UpdateBuff()
    if not self.panel then
        return
    end
    self:ClearFx()
    self.startTime = 0
    self:DeActiveBuff()
    self.Mgr = MgrMgr:GetMgr("BuffMgr")
    local l_info = self.Mgr.SpBuffInfo
    local l_bossBuffInfo = self.Mgr.BossBuffInfo

    --if #l_info<1 then
    --	MPlayerInfo.AbnormalState = false
    --	return
    --end
    local l_abnormalState = false
    for i = 1, #l_info do
        if l_info[i].name ~=Common.Utils.Lang("BUFF_DES_STOP") then
            l_abnormalState = true
            break
        end
    end
    MPlayerInfo.AbnormalState = l_abnormalState

    self.panel.buffPanel.gameObject:SetActiveEx(not(#l_info == 0 and #l_bossBuffInfo == 0))
    if #l_info == 0 and #l_bossBuffInfo == 0 then return end


    self.startTime = Time.realtimeSinceStartup
    self.preBuff = self.curBuff
    self.curBuff = {}

    --三个位置中为boss buff预留一个位置，并保持在最右
	self.typeInfo = {}
	local l_x = 1
    local l_i = 1
    local l_isBossBuffShown = false
	while l_x <= 3 and not l_isBossBuffShown do
		local l_buffInfo = l_info[l_i]
        if not l_buffInfo or l_x == 3 and #l_bossBuffInfo > 0 then
            l_buffInfo = l_bossBuffInfo[#l_bossBuffInfo]
            l_isBossBuffShown = true
        end
        if not l_buffInfo then break end
		if not table.ro_contains(self.typeInfo,l_buffInfo.name) then
			local l_buff = self:GetBuffByIndex(l_x, l_isBossBuffShown)
            if l_isBossBuffShown then
                l_buff.go.transform:SetAsLastSibling()
            end
			l_buff.info = l_buffInfo
			self:InitBuff(l_buff)
			table.insert(self.typeInfo,l_buffInfo.name)
            l_x = l_x +1
		end
        l_i = l_i + 1
	end

end

function MainBuffCtrl:ClearFx()
	if self.timeLab and #self.timeLab>0 then
		for i = 1, #self.timeLab do
			if self.timeLab[i] then
				local l_fx = self.timeLab[i].fx
				if l_fx ~= nil then
					self:DestroyUIEffect(l_fx)
					l_fx = nil
				end
			end
		end
	end
	self.timeLab = {}
end

function MainBuffCtrl:DeActiveBuff()
	if self.buff1 then
		self.buff1.go:SetActiveEx(false)
	end
	if self.buff2 then
		self.buff2.go:SetActiveEx(false)
	end
	if self.buff3 then
		self.buff3.go:SetActiveEx(false)
	end
    if self.bossBuff then
        self.bossBuff.go:SetActiveEx(false)
    end
end

function MainBuffCtrl:KillTween()
	if self.buff1 then
		self.buff1.go:SetActiveEx(false)
	end
	if self.buff2 then
		self.buff2.go:SetActiveEx(false)
	end
	if self.buff3 then
		self.buff3.go:SetActiveEx(false)
	end
end

function MainBuffCtrl:GetBuffByIndex(index, isBossType)
	local l_target = nil
    if isBossType then
        if not self.bossBuff then
            self.bossBuff = self:GetBuff(true)
        end
        l_target = self.bossBuff
    elseif index == 1 then
        if not self.buff1 then
            self.buff1 = self:GetBuff()
        end
        l_target = self.buff1
    elseif index == 2 then
        if not self.buff2 then
            self.buff2 = self:GetBuff()
        end
        l_target = self.buff2
    elseif index == 3 then
        if not self.buff3 then
            self.buff3 = self:GetBuff()
        end
        l_target = self.buff3
    end
    return l_target
end

function MainBuffCtrl:GetBuff(isBossType)
	local l_tp = self.panel.reduceBuff.gameObject
    if isBossType then
        l_tp = self.panel.bossBuff.gameObject
    end
	local l_go = self:CloneObj(l_tp)
	l_go.transform:SetParent(self.panel.buffList.gameObject.transform)
	l_go:SetLocalScaleToOther(l_tp)
	l_go:SetActiveEx(false)
	local l_buff = {}
	l_buff.go = l_go
	l_buff.icon = l_go.transform:Find("icon"):GetComponent("MLuaUICom")
	l_buff.bg = l_go.transform:Find("Image"):GetComponent("Image")
	l_buff.timeLab = l_go.transform:Find("timeLab"):GetComponent("MLuaUICom")
	l_buff.nameLab = l_go.transform:Find("TextMeshPro"):GetComponent("MLuaUICom")
    if not isBossType then
        l_buff.effectImg = l_go.transform:Find("Effect"):GetComponent("MLuaUICom")
	end
	l_buff.isBoss = isBossType
	l_buff.fx = nil
	return l_buff
end

--lua custom scripts end
