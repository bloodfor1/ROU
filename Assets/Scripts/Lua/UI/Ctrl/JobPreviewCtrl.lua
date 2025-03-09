--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/JobPreviewPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_defaultId = 1000  --进入时默认打开的职业ID
local l_curJobInfo = nil  --当前选中的职业信息
-- local l_model = nil  --人物展示模型
--next--
--lua fields end

--lua class define
JobPreviewCtrl = class("JobPreviewCtrl", super)
--lua class define end

--lua functions
function JobPreviewCtrl:ctor()

    super.ctor(self, CtrlNames.JobPreview, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true

end --func end
--next--
function JobPreviewCtrl:Init()

    self.panel = UI.JobPreviewPanel.Bind(self)
    super.Init(self)

    local l_rows = TableUtil.GetCareerPreviewTable().GetTable()
    l_defaultId = l_rows[1].ID
    for i = 1, #l_rows do
        local l_professionInfo = TableUtil.GetProfessionTable().GetRowById(l_rows[i].ID)
        self.panel.JobIconOn[i]:SetSprite("Common", l_professionInfo.ProfessionIcon)
        self.panel.JobIconOff[i]:SetSprite("Common", l_professionInfo.ProfessionIcon)
        self.panel.JobName[i].LabText = l_professionInfo.Name
        self.panel.JobNameOff[i].LabText = l_professionInfo.Name
        self.panel.JobTog[i]:OnToggleExChanged(function(value)
            if value then
                if l_curJobInfo and l_rows[i].ID == l_curJobInfo.ID then return end  --单按钮重复点击直接返回
                self:SelectOneJob(l_rows[i].ID)
            end
        end)
    end

    --进入体验按钮点击
    self.panel.BtnEnter:AddClick(function ()
        MgrMgr:GetMgr("DungeonMgr").EnterDungeons(l_curJobInfo.TrialDungeonsId, 0, 0)
        UIMgr:DeActiveUI(UI.CtrlNames.JobPreview)
    end)
    --退出按钮点击
    self.panel.BtnQuit:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.JobPreview)
    end)

end --func end
--next--
function JobPreviewCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function JobPreviewCtrl:OnActive()

    self.panel.JobTog[1].TogEx.isOn = true
    --self:SelectOneJob(l_defaultId)

end --func end
--next--
function JobPreviewCtrl:OnDeActive()

    --清理当前选中顺序
    l_curJobInfo = nil
    -- --人物模型清理
    -- if l_model ~=nil then
    --     self:DestroyUIModel(l_model)
    --     l_model = nil
    -- end

end --func end
--next--
function JobPreviewCtrl:Update()


end --func end



--next--
function JobPreviewCtrl:BindEvents()

    --dont override this function

end --func end



--next--
--lua functions end

--lua custom scripts

--选中一个职业
function JobPreviewCtrl:SelectOneJob(jobId)
    --选中的职业信息获取
    l_curJobInfo = TableUtil.GetCareerPreviewTable().GetRowByID(jobId)
    --职业图片设置  同步有卡顿 这里用异步 回调里面播放特效
    local l_careerImgPath = MPlayerInfo.IsMale and l_curJobInfo.ImgPath[0] or l_curJobInfo.ImgPath[1]
    self.panel.RoleViewImg:SetRawTexAsync(l_careerImgPath, function()
        self.panel.RoleViewImg.UObj:SetActiveEx(true)
        MLuaClientHelper.PlayFxHelper(self.panel.RoleViewImg.UObj)
    end)
    --进阶职业介绍
    if l_curJobInfo.AdvancedCareers.Count == 2 and not MPlayerInfo.IsMale then
        --存在多选 且为女性 则展示第二种情况
        self.panel.AdvanceJobText.LabText = l_curJobInfo.AdvancedCareers[1]
    else
        self.panel.AdvanceJobText.LabText = l_curJobInfo.AdvancedCareers[0]
    end
    --职业介绍
    self.panel.JobInfoText.LabText = l_curJobInfo.Des
    --设置属性雷达图
    self:SetRadarChart()
    --关键技能展示
    self:ShowMainSkill()
    --人物模型展示
    --self:ShowRolePlayerModel()
end

--设置属性雷达图
function JobPreviewCtrl:SetRadarChart()

    local cSetPolygon = self.panel.Liubianxing.gameObject:GetComponent("MUISetPolygon")

    for i = 0, 5 do
        cSetPolygon:SetValueByIndex(i, l_curJobInfo.SixDimensional[i] / 99 * 0.6 + 0.4)
    end

    cSetPolygon.enabled = false
    cSetPolygon.enabled = true

end

--关键技能展示
function JobPreviewCtrl:ShowMainSkill()
    --最多四个技能展示槽位
    for i = 1, 4 do
        if i > l_curJobInfo.RecommendedSkills.Count then
            --如果要展示的技能少于4个 则多的槽位隐藏
            self.panel.SkillBox[i].UObj:SetActiveEx(false)
        else
            --展示对应技能
            self.panel.SkillBox[i].UObj:SetActiveEx(true)
            --技能数据获取
            local l_skillInfo = TableUtil.GetSkillTable().GetRowById(l_curJobInfo.RecommendedSkills[i - 1])
            if not l_skillInfo then
                logError("@沈天考 职业关键技能配置有错 错误ID="..tostring(l_curJobInfo.RecommendedSkills[i - 1]))
            end
            --技能图标设置
            self.panel.SkillIcon[i]:SetSprite(l_skillInfo.Atlas, l_skillInfo.Icon)
            --技能名字设置
            self.panel.SkillName[i].LabText = l_skillInfo.Name
            --最大等级设置
            self.panel.MaxLvText[i].LabText = "Max Lv"..tostring(l_skillInfo.EffectIDs.Count)
            --播放视频的按钮设置
            if l_skillInfo.TargetType == -1 then
                --被动类型技能不用展示视频
                self.panel.BtnSkillPlay[i].UObj:SetActiveEx(false)
            else
                --展示播放按钮
                self.panel.BtnSkillPlay[i].UObj:SetActiveEx(true)
                self.panel.BtnSkillPlay[i]:AddClick(function()
                    --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NotOpened"))
                    local l_skillData =
                    {
                        openType = DataMgr:GetData("SkillData").OpenType.SetSkillPreviewInfo,
                        Id = l_skillInfo.Id
                    }
                    UIMgr:ActiveUI(UI.CtrlNames.SkillPreview, l_skillData)
                end)
            end
        end
    end

end

--lua custom scripts end
