--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/JobAwardItemTemplate"
require "UI/Template/JobReceiveItemTemplate"
require "UI/Template/SkillJobAttrItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local SINGLE_REWARD_FX = "Effects/Prefabs/Creature/Ui/Fx_Ui_HuoQu_01"
--lua fields end

--lua class define
---@class JobAdditionTemplateParameter.JobAwardItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field bg MoonClient.MLuaUICom
---@field ImageBg MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field Border MoonClient.MLuaUICom
---@field CanTakeEff MoonClient.MLuaUICom
---@field AttrBG MoonClient.MLuaUICom
---@field HasAward MoonClient.MLuaUICom
---@field RawPart MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom[]
---@field Image MoonClient.MLuaUICom[]
---@field AttrTxt MoonClient.MLuaUICom[]
---@field Icon MoonClient.MLuaUICom[]
---@field Image MoonClient.MLuaUICom[]
---@field AttrTxt MoonClient.MLuaUICom[]
---@field Complete MoonClient.MLuaUICom
---@field JobNext MoonClient.MLuaUICom
---@field txtNext MoonClient.MLuaUICom
---@field Occupation MoonClient.MLuaUICom
---@field ProfessionTxt MoonClient.MLuaUICom
---@field Line MoonClient.MLuaUICom
---@field JobLv MoonClient.MLuaUICom

---@class JobAdditionTemplateParameter.SkillJobAttrItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field SkillName MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom

---@class JobAdditionTemplateParameter.JobReceiveItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Icon MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom

---@class JobAdditionTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field JobAddition MoonClient.MLuaUICom
---@field ProTxt MoonClient.MLuaUICom
---@field scroll MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field CurJob MoonClient.MLuaUICom
---@field CurJobTxt MoonClient.MLuaUICom
---@field Fill MoonClient.MLuaUICom[]
---@field AttrBtn MoonClient.MLuaUICom
---@field CurBtn MoonClient.MLuaUICom
---@field Attrs MoonClient.MLuaUICom
---@field AttrBg MoonClient.MLuaUICom
---@field Receive MoonClient.MLuaUICom
---@field RewardEffect MoonClient.MLuaUICom
---@field ReceiveBg MoonClient.MLuaUICom
---@field JobAwardItemTemplate JobAdditionTemplateParameter.JobAwardItemTemplate
---@field SkillJobAttrItemTemplate JobAdditionTemplateParameter.SkillJobAttrItemTemplate
---@field JobReceiveItemTemplate JobAdditionTemplateParameter.JobReceiveItemTemplate

---@class JobAdditionTemplate : BaseUITemplate
---@field Parameter JobAdditionTemplateParameter

JobAdditionTemplate = class("JobAdditionTemplate", super)
--lua class define end

--lua functions
function JobAdditionTemplate:Init()
	
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
    self.data = DataMgr:GetData("SkillData")
    self.rewardEffectId = 0
    self.refreshLimit = 0

end --func end
--next--
function JobAdditionTemplate:BindEvents()
	
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_SKILL_JOB_AWARD, self.OnRefreshCell)
	
end --func end
--next--
function JobAdditionTemplate:OnDestroy()
	
    self.jobAwardPool = nil
    self.jobReceivePool = nil
    self.jobAttrPool = nil
    self.jobAwards = nil
    if self.moveCo then
        MgrMgr:GetMgr("CoroutineMgr"):removeCo(self.moveCo)
        self.moveCo = nil
    end
	
end --func end
--next--
function JobAdditionTemplate:OnDeActive()
	
	
end --func end
--next--
function JobAdditionTemplate:OnSetData(data)
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function JobAdditionTemplate:JobAdditionRefresh()

    self.Parameter.Receive:SetActiveEx(false)
    self.Parameter.Attrs:SetActiveEx(false)
    self.Parameter.JobReceiveItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self:gameObject():GetComponent("RectTransform").anchoredPosition = Vector2(-21, -25.6)
    self:ReBuildLayout()
    self.fillSize = self.Parameter.Fill[1].RectTransform.sizeDelta
    for i, v in ipairs(self.Parameter.Fill) do
        v.RectTransform.sizeDelta = Vector2(0, self.fillSize.y)
    end

    if not self.jobAwardPool then
        self.jobAwardPool = self:NewTemplatePool({
            UITemplateClass = UITemplate.JobAwardItemTemplate,
            TemplateParent = self.Parameter.Content.transform,
            TemplatePrefab = self.Parameter.JobAwardItemTemplate.LuaUIGroup.gameObject
        })
    end

    if not self.jobReceivePool then
        self.jobReceivePool = self:NewTemplatePool({
            UITemplateClass = UITemplate.JobReceiveItemTemplate,
            TemplateParent = self.Parameter.ReceiveBg.transform,
            TemplatePrefab = self.Parameter.JobReceiveItemTemplate.LuaUIGroup.gameObject
        })
    end

    if not self.jobAttrPool then
        self.jobAttrPool = self:NewTemplatePool({
            UITemplateClass = UITemplate.SkillJobAttrItemTemplate,
            TemplateParent = self.Parameter.Attrs.transform,
            TemplatePrefab = self.Parameter.SkillJobAttrItemTemplate.LuaUIGroup.gameObject
        })
    end

    self:RefreshAwards()
    self:RefreshProTxt()
    self:RefreshSlider()

    --self.Parameter.scroll.LoopScroll.OnDragCallback = function()
    --end
    self.Parameter.scroll.LoopScroll:SetOnValueChangedMethod(function()
        self.refreshLimit = self.refreshLimit + 1
        if self.refreshLimit % 10 == 0 then
            self:RefreshProTxt()
            self:RefreshSlider()
        end
    end)

    self.Parameter.CurBtn:AddClick(function()
        self:MoveToCurrent()
    end)

    self.Parameter.AttrBtn:AddClick(function()
        self:RefreshAttrs()
    end)

    self.Parameter.AttrBg:AddClick(function()
        self:OnCloseAttr()
    end)

    self.Parameter.ReceiveBg:AddClick(function()
        self.Parameter.Receive:SetActiveEx(false)
        self:DestroyRewardFx()
    end)

end

function JobAdditionTemplate:RefreshAwards()

    local jobAwards = {}
    local proIds = self.data.GetProfessionIdList()
    for i, proId in ipairs(proIds) do
        local proAwards = self.data.GetProfessionJobAwards(proId)
        if proAwards then
            if next(jobAwards) then
                table.remove(jobAwards, #jobAwards)
                table.insert(jobAwards, { type = GameEnum.JobAwardItemType.Pro, proId = proId, temp = self })
            end
            for i, v in ipairs(proAwards) do
                table.insert(jobAwards, {
                    type = GameEnum.JobAwardItemType.Normal,
                    sdata = v,
                    jobLv = v.NeedJobLvl,
                    proId = v.ProfessionID,
                    temp = self
                })
            end
            table.insert(jobAwards, {
                type = GameEnum.JobAwardItemType.ForeShow,
                proId = proId,
                temp = self
            })
        end
    end
    local curIdx = self:GetCurAwardIdx()
    self.jobAwards = jobAwards
    self.jobAwardPool:ShowTemplates({Datas = jobAwards,StartScrollIndex=curIdx})
    local l_curItem
    for i, v in ipairs(self.jobAwardPool:GetItems()) do
        if v.status == GameEnum.JobAwardItemStatus.CanTake then
            l_curItem = v
            break
        end
    end
    if l_curItem then
        local size = Vector2(Screen.width, Screen.height)
        local sizeUI = MUIManager:GetUIScreenSize();
        self.moveCo = MgrMgr:GetMgr("CoroutineMgr"):addCo(function()
            AwaitTime(0.1)
            if self.Parameter then
                local pos1 = MUIManager.UICamera:ScreenToWorldPoint(Vector3(size.x * 0.6, size.y / 2, 0))
                local minx = self.Parameter.scroll.RectTransform.sizeDelta.x - self.Parameter.Content.RectTransform.sizeDelta.x
                local minWorldPos = MUIManager.UICamera:ScreenToWorldPoint(Vector3(minx / sizeUI.x * size.x, size.y / 2, 0))

                local pos2 = l_curItem:gameObject().transform.position
                --if pos1.x < pos2.x then           --以防策划改需求，先写好
                    local xDelta = pos1.x - pos2.x
                    local pos3 = self.Parameter.Content.transform.position
                    self.Parameter.Content.transform.position = Vector3(math.max(minWorldPos.x,pos3.x + xDelta), pos3.y, pos3.z)
                --end
            end
        end)
    end
    self:ReBuildLayout()

end

function JobAdditionTemplate:ReBuildLayout()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.Content.RectTransform)
end

function JobAdditionTemplate:RefreshProTxt()

    if not self.jobAwardPool then return end
    --[[local items = self.jobAwardPool:GetItems()
    local proId
    local uiCamera = MUIManager.UICamera
    --local screenSize = MUIManager:GetUIScreenSize()
    local width = UnityEngine.Screen.width
    for i, v in ipairs(items) do
        local screenPoint = uiCamera:WorldToScreenPoint(v:transform().position)
        if screenPoint.x >= width/2 then
            proId = v:GetProId()
            break
        end
    end
    if proId then]]
    local proSdata = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProID)
    self.Parameter.ProTxt.LabText = Lang("SKILL_JOB_AWARD_TITLE", proSdata.Name)

end

function JobAdditionTemplate:RefreshAttrs()

    self.Parameter.Attrs:SetActiveEx(true)
    local datas = {}
    for i, v in ipairs(self.jobAwardPool:GetItems()) do
        local status = v:GetStatus()
        if status and status == GameEnum.JobAwardItemStatus.Taked then
            for j = 1, v.data.sdata.AwardAttribute.Count do
                table.insert(datas, v.data.sdata.AwardAttribute[j - 1])
            end
        end
    end
    -- AttrDecision表第二类
    local out =
    {
        [13] = 0,
        [15] = 0,
        [17] = 0,
        [19] = 0,
        [21] = 0,
        [23] = 0
    }
    for i, v in ipairs(datas) do
        for id, k in pairs(out) do
            local l_tableX = TableUtil.GetAttrInfoTable().GetRowById(id)
            if v[1] == l_tableX.EquipId then
                out[id] = (out[id] or 0) + v[2]
            end
        end
    end
    datas = {}
    for id, v in pairs(out) do
        table.insert(datas, { id = id, val = v})
    end
    table.sort(datas, function (x, y)
        local l_tableX = TableUtil.GetAttrInfoTable().GetRowById(x.id)
        local l_tableY = TableUtil.GetAttrInfoTable().GetRowById(y.id)
        return l_tableX.ShortId < l_tableY.ShortId
    end)
    self.jobAttrPool:ShowTemplates({Datas = datas})

end

function JobAdditionTemplate:OnCloseAttr()
    self.Parameter.Attrs:SetActiveEx(false)
end

function JobAdditionTemplate:RefreshSlider()

    if not self.jobAwardPool then return end

    local jobLv = MPlayerInfo.JobLv
    local cShowLv,cProNum = Common.CommonUIFunc.GetShowJobLevelAndProByLv(jobLv, MPlayerInfo.ProfessionId)
    local items = self.jobAwardPool:GetItems()

    if not jobLv then return end
    if not self.jobAwardPool or cProNum < 1 or #items == 0 then return end

    self:ReBuildLayout()
    local size = self.Parameter.Slider.RectTransform.sizeDelta
    self.Parameter.Slider.RectTransform.sizeDelta = Vector2(self.Parameter.Content.RectTransform.sizeDelta.x, size.y)

    local changeJobLv = Common.CommonUIFunc.InitProfessionChangeLv()
    local changeJobPos = {}
    local changeJobLvPos = {}
    local changeJobIdx = 1

    local nextv, lastv, maxv
    for i, v in ipairs(items) do
        local realLv = v:GetRealJobLv()
        if not lastv then
            lastv = v
        end
        if realLv >= jobLv and not nextv then
            nextv = v
        elseif realLv < jobLv and realLv > lastv:GetRealJobLv() then
            lastv = v
        end
        if not maxv or realLv > maxv:GetRealJobLv() then
            maxv = v
        end

        if v:GetRealJobLv() == changeJobLv[changeJobIdx + 1] then
            changeJobPos[changeJobIdx] = v:transform().anchoredPosition
            changeJobLvPos[changeJobIdx] = changeJobPos[changeJobIdx]
        elseif changeJobLv[changeJobIdx + 1] ~= nil and v:GetRealJobLv() >= changeJobLv[changeJobIdx + 1] then
            changeJobIdx = changeJobIdx + 1
        end
    end
    if not nextv then
        nextv = maxv
    end
    if lastv:GetRealJobLv() >= jobLv then
        lastv = nil
    end
    --logError("NEXT V ", #changeJobPos, lastv and lastv:GetRealJobLv(), nextv:GetRealJobLv())

    local lvDestPosx = 0
    for i = 1, #changeJobPos do
        local destPosx = 0
        if not changeJobLv[i + 1] or jobLv < changeJobLv[i + 1] then
            local pos1 = lastv and lastv:transform().anchoredPosition or Vector2(0, nextv:transform().anchoredPosition.y)
            if lastv ~= nil and lastv:GetRealJobLv() == changeJobLv[i] and i ~= 1 then
                pos1 = changeJobPos[i - 1]
            end
            local pos2 = nextv:transform().anchoredPosition
            local lastJobLv, nextJobLv = lastv and lastv:GetRealJobLv() or 10, nextv:GetRealJobLv()
            destPosx = pos1.x + (jobLv - lastJobLv)/(nextJobLv - lastJobLv) * (pos2.x - pos1.x)
            if jobLv == nextJobLv then
                nextv:SetJobLvActive(false)
            end
            lvDestPosx = math.max(destPosx, lvDestPosx)
        else
            destPosx = changeJobPos[i].x
            lvDestPosx = changeJobPos[i].x
        end
        self.Parameter.Fill[5 - i].RectTransform.sizeDelta = Vector2(destPosx, self.fillSize.y)
    end

    self.Parameter.CurJob.RectTransform.anchoredPosition = Vector2(lvDestPosx - 27,
        self.Parameter.CurJob.RectTransform.anchoredPosition.y)
    self.Parameter.CurJobTxt.LabText = string.ro_concat("Job ", cShowLv)

end

function JobAdditionTemplate:OnRefreshCell(sendInfo)

    local item = self.jobAwardPool:FindShowTem(function(v)
        return v:GetProId() == sendInfo.profession_id and sendInfo.level == v:GetJobLv()
    end)
    if item then
        item:SetData(item.data)
    end
    local jobAwardSdata = self.data.GetJobAwardByProAndLevel(sendInfo.profession_id, sendInfo.level)
    if jobAwardSdata then
        self:ShowReceive(jobAwardSdata)
    end

end

function JobAdditionTemplate:MoveToCurrent(useTween)

    local curItem = self.jobAwardPool:GetItem(1)
    local jobLv = MPlayerInfo.JobLv
    for i, v in ipairs(self.jobAwardPool:GetItems()) do
        if v:GetRealJobLv() <= jobLv then
            curItem = v
        else
            break
        end
    end
    if curItem then
        local size = MUIManager:GetUIScreenSize()
        local pos1 = MUIManager.UICamera:ScreenToWorldPoint(Vector3(size.x * 0.6,size.y/2,0))
        local pos2 = curItem:gameObject().transform.position
        local xDelta = pos1.x - pos2.x
        local pos3 = self.Parameter.Content.transform.position
        self.Parameter.Content.transform.position = Vector3(pos3.x + xDelta, pos3.y, pos3.z)
    end

end

function JobAdditionTemplate:GetCurAwardIdx()

    local curIdx = 1
    local jobLv = MPlayerInfo.JobLv
    local awardItems = self.jobAwardPool:GetItems()
    for i, v in ipairs(awardItems) do
        if v:GetRealJobLv() <= jobLv then
            curIdx = i
        else
            break
        end
    end
    return curIdx

end

function JobAdditionTemplate:ShowReceive(jobAwardSdata)

    self.Parameter.Receive:SetActiveEx(true)
    local fullSize = MUIManager:GetUIScreenSize()
    self.Parameter.Receive.RectTransform.sizeDelta = Vector2(fullSize.x * 2, fullSize.y * 2)
    self:CreateRewardFx()
    local datas = {}
    for i = 0, jobAwardSdata.AwardAttribute.Count - 1 do
        table.insert(datas, {atlas = jobAwardSdata.AwardIconAtlas, sprite = jobAwardSdata.AwardIconSprite[i],
            attr = jobAwardSdata.AwardAttribute[i]})
    end
    MAudioMgr:Play("event:/UI/SkillPanelLevelUp")
    self.jobReceivePool:ShowTemplates({Datas = datas})

end

function JobAdditionTemplate:CreateRewardFx()

    local effectName = SINGLE_REWARD_FX
    if self.rewardEffectId == 0 then
        local l_fxData = {}
        l_fxData.rawImage = self.Parameter.RewardEffect.RawImg
        l_fxData.destroyHandler = function ()
            self.rewardEffectId = 0
        end
        self.rewardEffectId = self:CreateUIEffect(effectName, l_fxData)
        
    end

end

function JobAdditionTemplate:DestroyRewardFx( ... )

    if self.rewardEffectId ~= 0 then
        self:DestroyUIEffect(self.rewardEffectId)
        self.rewardEffectId = 0
    end

end

--function JobAdditionTemplate:MoveToCurrent()
--
--    local curIdx = self:GetCurAwardIdx()
--    logYellow(tostring(curIdx).."  "..tostring(1000))
--    self.Parameter.scroll.LoopScroll:ScrollToCell(curIdx - 1, 1000)
--
--end
--lua custom scripts end
return JobAdditionTemplate