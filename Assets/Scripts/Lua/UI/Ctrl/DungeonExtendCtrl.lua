--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungeonExtendPanel"
require "ModuleMgr/DungeonMgr"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
DungeonExtendCtrl = class("DungeonExtendCtrl", super)
--lua class define end

--lua functions
function DungeonExtendCtrl:ctor()

	super.ctor(self, CtrlNames.DungeonExtend, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function DungeonExtendCtrl:Init()
	self.panel = UI.DungeonExtendPanel.Bind(self)
	super.Init(self)
	self:ReSetUI()
end --func end
--next--
function DungeonExtendCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function DungeonExtendCtrl:OnActive()
	if self.panel == nil then
		self.panel = UI.DungeonExtendPanel.Bind(self)
	end
	self.addSpeed = 0
	self.isTransferProfession = false
	self:InitTransferProfession()
	self:InitAddPointDungeons()
	self:InitPrayDungeons()
end --func end
--next--
function DungeonExtendCtrl:OnDeActive()
	--self:ReSetData()
	self:DestroyRewardFx()
end --func end
--next--
function DungeonExtendCtrl:Update()
	if self.isTransferProfession then
		self:SetButtonStateByNum()
	end
end --func end



--next--
function DungeonExtendCtrl:OnShow()
	
	if Common.CommonUIFunc.IsDungonBySceneId(MScene.SceneID) == false then
		UIMgr:DeActiveUI(UI.CtrlNames.DungeonExtend)
		return
	end
end --func end

--next--
function DungeonExtendCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

-----------------------------------新手副本召唤处理-------------------
		
function DungeonExtendCtrl:InitTransferProfession()
	--没有找到配置Return
	if MGlobalConfig:GetSequenceOrVectorInt("ShowAddMonsterBtnDungeonID") == nil then
		return
	end
	
	--配置对比失败Return
	local showAddMonsterBtnDungeonIDTb = MGlobalConfig:GetSequenceOrVectorInt("ShowAddMonsterBtnDungeonID")
	local isContain = false
	for i = 1, showAddMonsterBtnDungeonIDTb.Length do
        if showAddMonsterBtnDungeonIDTb[i-1] == MPlayerDungeonsInfo.DungeonID then
            isContain = true
			break
        end
    end
	
	if not isContain then return end
	self.isTransferProfession = true
	local normalGroupId = MGlobalConfig:GetInt("AddNormalMonsterGroupId") or 2
	local eliteGroupId = MGlobalConfig:GetInt("AddEliteMonsterGroupId") or 3
	self.panel.TransferProfession:SetActiveEx(true)
	--功能停用关闭按钮代码
	self.panel.BtnBeckonMonster:AddClick(function()
		--MgrMgr:GetMgr("DungeonMgr").OnSceneTriggerArgs(normalGroupId,1,ServerSceneTriggerTimingType.SsttimingTypeClickUi:ToInt())
    end)
	self.panel.BtnBeckonMonsterElite:AddClick(function()
		--MgrMgr:GetMgr("DungeonMgr").OnSceneTriggerArgs(eliteGroupId,1,ServerSceneTriggerTimingType.SsttimingTypeClickUi:ToInt())
    end)
	self.panel.BtnBeckonQuit:AddClick(function()
        MgrMgr:GetMgr("DungeonMgr").SendLeaveSceneReqWithFunc(function ()
			MgrMgr:GetMgr("DungeonMgr").IsTransferProfession = true
		end)
    end)
end

function DungeonExtendCtrl:SetButtonStateByNum()
	local tempTeamEntityTb = MgrMgr:GetMgr("DungeonMgr").GetTempMonsterEntityTb()
	if tempTeamEntityTb == nil then
		return
	end
	
	local EntityNumerTable = {}
	for i = 1,table.maxn(tempTeamEntityTb) do
		if EntityNumerTable[tempTeamEntityTb[i].EntityID] == nil then
			EntityNumerTable[tempTeamEntityTb[i].EntityID] = {}
			EntityNumerTable[tempTeamEntityTb[i].EntityID].MonsterNum = 1
		else
			local cNum = EntityNumerTable[tempTeamEntityTb[i].EntityID].MonsterNum
			EntityNumerTable[tempTeamEntityTb[i].EntityID].MonsterNum = cNum + 1
		end
	end
	
	local normalEntityId = MGlobalConfig:GetInt("AddNormalMonsterEntityId") or 7142
	local eliteEntityId = MGlobalConfig:GetInt("AddEliteMonsterEntityId") or 7143
	
	if EntityNumerTable[normalEntityId] then
		if EntityNumerTable[normalEntityId].MonsterNum > 4 then
			self.panel.BtnBeckonMonster:SetGray(true)
			self.panel.IconBtnBeckonMonster:SetGray(true)
			self.panel.BtnBeckonMonster.Btn.enabled = false
		else
			self.panel.BtnBeckonMonster:SetGray(false)
			self.panel.IconBtnBeckonMonster:SetGray(false)
			self.panel.BtnBeckonMonster.Btn.enabled = true
		end
	end
	
	if EntityNumerTable[eliteEntityId] then 
		if EntityNumerTable[eliteEntityId].MonsterNum >= 2 then
			self.panel.BtnBeckonMonsterElite:SetGray(true)
			self.panel.IconBtnBeckonMonsterElite:SetGray(true)
			self.panel.BtnBeckonMonsterElite.Btn.enabled = false
		else
			self.panel.BtnBeckonMonsterElite:SetGray(false)
			self.panel.IconBtnBeckonMonsterElite:SetGray(false)
			self.panel.BtnBeckonMonsterElite.Btn.enabled = true
		end
	end
end
-----------------------------------新手副本召唤处理-------------------

-----------------------------------加点副本处理-------------------
--可选职业
AddPointType =
{
	{id = 13,value =Common.Utils.Lang("ATTR_STR"),Word = "STR",Eng = "S",Sp = "UI_PreyDungeon_Img_ShuxingS.png"},
	{id = 17,value =Common.Utils.Lang("ATTR_AGI"),Word = "AGI",Eng = "A",Sp = "AUI_PreyDungeon_Img_ShuxingA.png"},
	{id = 21,value =Common.Utils.Lang("ATTR_VIT"),Word = "VIT",Eng = "V",Sp = "UI_PreyDungeon_Img_TizhiV.png"},
	{id = 15,value =Common.Utils.Lang("ATTR_INT"),Word = "INT",Eng = "I",Sp = "UI_PreyDungeon_Img_ShuxingI.png"},
	{id = 19,value =Common.Utils.Lang("ATTR_DEX"),Word = "DEX",Eng = "D",Sp = "UI_PreyDungeon_Img_ShuxingD.png"},
	{id = 23,value =Common.Utils.Lang("ATTR_LUCK"),Word = "LUCK",Eng = "L",Sp = "UI_PreyDungeon_Img_XingyunL.png"},
}

--isIgnoreFirst 是否忽略第一个推荐
function DungeonExtendCtrl:InitAddPointDungeons()

	if not MgrMgr:GetMgr("DungeonMgr").IsAddPoint then
		return
	end

	local professionIdList = Common.CommonUIFunc.GetPlayerProfessionList(MPlayerInfo.ProfessionId)
	local checkProfessionId = MPlayerInfo.ProfessionId
	if #professionIdList > 0 then
		checkProfessionId =  professionIdList[1]
	end

	local l_professionTableInfo=TableUtil.GetProfessionTable().GetRowById(checkProfessionId)
    if l_professionTableInfo==nil then
        logError("ProfessionTable表没有配，id："..tostring(checkProfessionId))
        return
    end

	local attrAriseData = Common.Functions.VectorSequenceToTable(l_professionTableInfo.AttrAriseList)

	self.panel.AddPointDungeon:SetActiveEx(true)
	if self.AddPoint == nil then
		self.AddPoint = {}
	end

	--计算出当前已经点击的添加的属性数量
	local addNum = 0
	for i = 1, #AddPointType do
		if MgrMgr:GetMgr("DungeonMgr").RecommendTable[i] then
			addNum = addNum + 1
		end
	end

	self.panel.AttrList:SetActiveEx(not(addNum == #attrAriseData))

	--每轮只显示一个推荐项目 判断是否是本轮唯一推荐
	local curRecommendNum = nil
	local nextRecommendNum = nil
	local l_num = 1
	if MgrMgr:GetMgr("DungeonMgr").IsIgnoreFirst then l_num = 2 end
	for j= l_num,#attrAriseData do
		local l_data = attrAriseData[j]
		if l_data then
			local num = l_data[1]
			local buffId = l_data[2]
			if not curRecommendNum and not MgrMgr:GetMgr("DungeonMgr").RecommendTable[num] then
				curRecommendNum = num
			else
				nextRecommendNum = num
			end
		end
	end

	self:DestroyRewardFx()
	for i = 1, #AddPointType do
        self.AddPoint[i] = self.AddPoint and self.AddPoint[i] or {}
        self.AddPoint[i].ui = self.panel.AttrList.transform:Find("Attributes_"..i)
        self:ExportElement(self.AddPoint[i])
		self.AddPoint[i].txt.LabText = AddPointType[i].value
		self.AddPoint[i].ui.gameObject:SetActiveEx(true)
		self.AddPoint[i].character:SetSprite("PreyDungeon",AddPointType[i].Sp)

		if curRecommendNum and curRecommendNum == i then
			self.AddPoint[i].btn:AddClick(function ()
				self.AddPoint[i].ui.gameObject:SetActiveEx(false)
				MgrMgr:GetMgr("DungeonMgr").RecommendTable[i] = true
				MgrMgr:GetMgr("DungeonMgr").IsAddPoint = false
				addNum = addNum + 1
				self.panel.AttrList:SetActiveEx(false)
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_ADD_RIGHT_"..AddPointType[i].Word))
				MgrMgr:GetMgr("DungeonMgr").OnAttrRaisedArg(i,false)
			end)
		elseif nextRecommendNum and nextRecommendNum == i then
			self.AddPoint[i].btn:AddClick(function ()
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_REC_RIGHT_"..AddPointType[i].Word))
			end)
		else
			self.AddPoint[i].btn:AddClick(function ()
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ATTR_ADD_WRONG_"..AddPointType[i].Word))
			end)
		end

		if curRecommendNum and curRecommendNum == i then
			self.AddPoint[i].character:SetGray(false)
			self.AddPoint[i].fxUI.gameObject:SetActiveEx(true)
			self:CreateRewardFx(self.AddPoint[i],"Effects/Prefabs/Creature/Ui/Fx_Ui_JiaDianFuBen_Golden",false)
			--self:CreateRewardFx(self.AddPoint[i],"Effects/Prefabs/Creature/Ui/Fx_Ui_YingDaoKuang_01",true)
		else
			self.AddPoint[i].character:SetGray(true)
			self:CreateRewardFx(self.AddPoint[i],"Effects/Prefabs/Creature/Ui/Fx_Ui_JiaDianFuBen_Blue",false)
		end
    end
end

function DungeonExtendCtrl:CloseAddPoint()
	self.panel.AddPointDungeon:SetActiveEx(false)
end

function DungeonExtendCtrl:ExportElement(element)
    element.btn = element.ui.transform:Find("bg"):GetComponent("MLuaUICom")
    element.txt = element.ui.transform:Find("Text"):GetComponent("MLuaUICom")
	element.character = element.ui.transform:Find("Value"):GetComponent("MLuaUICom")
	element.effectImg = element.ui.transform:Find("Effect"):GetComponent("MLuaUICom")
	element.fxUI = element.ui.transform:Find("Fx_UI")
	element.fxUI.gameObject:SetActiveEx(false)
	element.effectId = 0
	element.selectEffectId = 0
end

function DungeonExtendCtrl:CreateRewardFx(element,effectName,isSelect)
	if isSelect then
		if element.selectEffectId == 0 then
			local l_fxData = {}
			l_fxData.rawImage = element.effectImg.RawImg
			l_fxData.destroyHandler = function ( ... )
				element.selectEffectId = 0
			end
			l_fxData.loadedCallback = function(go)
				go.transform:SetLocalScale(0.7,0.7,0.7)
			end
			element.selectEffectId = self:CreateUIEffect(effectName, l_fxData)
			
		end
	else
		if element.effectId == 0 then
			local l_fxData = {}
			l_fxData.rawImage = element.effectImg.RawImg
			l_fxData.destroyHandler = function ( ... )
				element.effectId = 0
			end
			l_fxData.loadedCallback = function(go)
				go.transform:SetLocalScale(1.1,1.1,1.1)
			end
			element.effectId = self:CreateUIEffect(effectName, l_fxData)
			
		end
	end
end

function DungeonExtendCtrl:DestroyRewardFx()
	if self.AddPoint == nil then
		return
	end
	for i = 1,#self.AddPoint do
		if self.AddPoint[i].effectId ~= 0 then
			self:DestroyUIEffect(self.AddPoint[i].effectId)
			self.AddPoint[i].effectId = 0
		end
		if self.AddPoint[i].selectEffectId ~= 0 then
			self:DestroyUIEffect(self.AddPoint[i].selectEffectId)
			self.AddPoint[i].selectEffectId = 0
		end
	end
end
-----------------------------------加点副本处理-------------------

-----------------------------------祈福副本处理-------------------
function DungeonExtendCtrl:InitPrayDungeons(barCur,barLast,barTime, barName, isColorReverse)
	if not MgrMgr:GetMgr("DungeonMgr").IsSliderShow then
		return
	end
	if barCur == nil or barLast == nil or barTime == nil then
		return
	end

    self.panel.Name:SetActiveEx(barName ~= "")
    self.panel.NameText.LabText = barName
    local l_dungeonType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
    if l_dungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonFollow then
        self.panel.TailLine.gameObject:SetActiveEx(true)
        self.panel.PreyDungeon.gameObject:SetActiveEx(false)
        self.panel.TailLineSlider.MSlider.IsColorReverse = isColorReverse
        self.panel.TailLineSlider.MSlider:SetSlider(barCur,barTime)
    else
        self.panel.TailLine.gameObject:SetActiveEx(false)
        self.panel.PreyDungeon.gameObject:SetActiveEx(true)
        --self.panel.SliderGuard.MSlider.value = barLast
        self.panel.SliderGuard.MSlider.IsColorReverse = isColorReverse
        self.panel.SliderGuard.MSlider:SetSlider(barCur,barTime)
    end
end

function DungeonExtendCtrl:ClosePray()
	self.panel.PreyDungeon:SetActiveEx(false)
end
-----------------------------------祈福副本处理-------------------

function DungeonExtendCtrl:ReSetUI()
	self.panel.TransferProfession:SetActiveEx(false)
	self.panel.AddPointDungeon:SetActiveEx(false)
	self.panel.PreyDungeon:SetActiveEx(false)
    self.panel.Name:SetActiveEx(false)
	self.panel.SliderGuard.MSlider.value = 1
    self.panel.SliderGuard.MSlider.IsColorReverse = true
	self.panel.TailLine.gameObject:SetActiveEx(false)
	self.panel.TailLineSlider.MSlider.value = 0
end

return DungeonExtendCtrl
--lua custom scripts end
