--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FashionRatingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FashionRatingCtrl = class("FashionRatingCtrl", super)
--lua class define end

--lua functions
function FashionRatingCtrl:ctor()

    super.ctor(self, CtrlNames.FashionRating, UILayer.Function, nil, ActiveType.Exclusive)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    --self:SetBlockOpt(BlockColor.Dark)

end --func end
--next--
function FashionRatingCtrl:Init()

    self.panel = UI.FashionRatingPanel.Bind(self)
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("FashionRatingMgr")
    self.data = DataMgr:GetData("FashionData")

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.FashionRating)
        UIMgr:DeActiveUI(CtrlNames.FashionRatingMain)
    end, true)

    self.panel.BtnLast:AddClick(function()
        if self.CurPage == 1 then
            UIMgr:DeActiveUI(CtrlNames.FashionRating)
            -- local l_ctrl = UIMgr:GetUI(CtrlNames.FashionRatingMain)
            -- if l_ctrl then
            --     l_ctrl:ShowMain(true)
            -- end
        else
            self:SetPage(self.CurPage - 1)
        end
    end, true)

    self.panel.BtnNext:AddClick(function()
        self:SetPage(self.CurPage + 1)
    end, true)

    self.DataLis = self.data.GetSortData()

    self.PREFAB_MAX = 7
    local l_pageNum = {}
    for i = 1, self.PREFAB_MAX do
        local l_page = self.panel["Page" .. tostring(i)]
        if l_page then
            l_page.LuaUIGroup.gameObject:SetActive(false)
            local l_count = 0
            while true do
                local l_e = l_page["E" .. tostring(l_count + 1)]
                if l_e then
                    l_count = l_count + 1
                else
                    break
                end
            end
            l_pageNum[l_page] = l_count
        end
    end

    local l_pagesInfo = {
        self.panel.Page1,
        self.panel.Page2,
        self.panel.Page3,
        self.panel.Page4,
        self.panel.Page5,
        self.panel.Page6,
        self.panel.Page7,
        self.panel.Page6,
    }
    self.MaxPage = 0
    local l_showCount = #self.DataLis - 1
    local l_pCount = l_showCount
    while l_pCount > 0 do
        local l_page = l_pagesInfo[self.MaxPage * 2 + 1] or self.panel.Page7
        l_pCount = l_pCount - l_pageNum[l_page]
        l_page = l_pagesInfo[self.MaxPage * 2 + 2] or self.panel.Page6
        l_pCount = l_pCount - l_pageNum[l_page]
        self.MaxPage = self.MaxPage + 1
    end
    self.MaxPage = math.max(self.MaxPage, 1)

    self.Pages = {}
    local l_addPageFunc = function(l_pageL, l_pageR, l_startIndex)
        local l_obj = {
            {
                Com = l_pageL,
                Num = l_pageNum[l_pageL],
                ItemLis = {},
            },
            {
                Com = l_pageR,
                Num = l_pageNum[l_pageR],
                ItemLis = {},
            }
        }
        for i = 1, #l_obj do
            local l_num = l_obj[i].Num
            for j = 1, l_num do
                l_obj[i].ItemLis[j] = {
                    data = self.DataLis[l_startIndex],
                    obj = l_obj[i].Com["E" .. tostring(j)],
                    key = i * 100 + j
                }
                l_startIndex = l_startIndex + 1
            end
        end
        self.Pages[#self.Pages + 1] = l_obj
    end

    local l_startIndex = 2
    for i = 0, self.MaxPage - 1 do
        local l_pageL = l_pagesInfo[i * 2 + 1] or self.panel.Page7
        local l_pageR = l_pagesInfo[i * 2 + 2] or self.panel.Page6
        l_addPageFunc(l_pageL, l_pageR, l_startIndex)
        l_startIndex = l_startIndex + l_pageNum[l_pageL] + l_pageNum[l_pageR]
    end

    self.CurPage = nil
    self.head = {}
    self:SetPage(1)

end --func end
--next--
function FashionRatingCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    for i = 1, #self.Pages do
        for j = 1, #self.Pages[i] do
            local l_page = self.Pages[i][j]
            for k = 1, #l_page.ItemLis do
                self:ClearPageItem(l_page.ItemLis[k])
            end
        end
    end
    self.Pages = {}

end --func end
--next--
function FashionRatingCtrl:OnActive()

end --func end
--next--
function FashionRatingCtrl:OnDeActive()

end --func end
--next--
function FashionRatingCtrl:Update()

end --func end

--next--
function FashionRatingCtrl:BindEvents()

    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.Event.DetailData, function(self, data)
        if data then
            for i = 1, #self.Pages do
                for j = 1, #self.Pages[i] do
                    local l_page = self.Pages[i][j]
                    for k = 1, #l_page.ItemLis do
                        local l_item = l_page.ItemLis[k]
                        if l_item.InWait and l_item.data.rid == data.rid and l_item.data.rank == data.rank then
                            self:ResetPageItem(l_item)
                        end
                    end
                end
            end
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function FashionRatingCtrl:SetPage(num)

    num = math.max(1, math.min(num, self.MaxPage))
    if self.CurPage == num then
        return
    end

    self.CurPage = num
    self.panel.PageNum_L.LabText = tostring((num - 1) * 2 + 1)
    self.panel.PageNum_R.LabText = tostring((num - 1) * 2 + 2)
    self.panel.BtnNext:SetActiveEx(self.CurPage ~= self.MaxPage)

    for i = 1, #self.Pages do
        for j = 1, #self.Pages[i] do
            local l_page = self.Pages[i][j]
            local l_show = (i == num)
            if not l_show then
                l_page.Com.LuaUIGroup.gameObject:SetActive(false)
                for k = 1, #l_page.ItemLis do
                    self:ClearPageItem(l_page.ItemLis[k])
                end
            end
        end
    end

    for i = 1, #self.Pages do
        for j = 1, #self.Pages[i] do
            local l_page = self.Pages[i][j]
            local l_show = (i == num)
            if l_show then
                l_page.Com.LuaUIGroup.gameObject:SetActive(true)
                for k = 1, #l_page.ItemLis do
                    self:ResetPageItem(l_page.ItemLis[k])
                end
            end
        end
    end

    -- 右边的页面没有数据需要显示 PanelNoRight
    self.panel.PanelNoRight:SetActiveEx(false)
    if self.Pages[num] and self.Pages[num][2] then
        local l_page = self.Pages[num][2]
        if not l_page.ItemLis[1].data then
            self.panel.PanelNoRight:SetActiveEx(true)
            l_page.Com.LuaUIGroup.gameObject:SetActive(false)
        end
    end

end

function FashionRatingCtrl:ResetPageItem(pageItem)

    if not pageItem.data then
        self:ClearPageItem(pageItem)
        return
    end

    if not pageItem.data.name then
        pageItem.InWait = true
        self:ClearPageItem(pageItem)
        self.Mgr.RequestRoleFashionScore({ { rid = pageItem.data.rid, photo_id = -1, rank = pageItem.data.rank } }, self.data.NowChooseTheme)
        return
    end

    pageItem.InWait = nil
    pageItem.obj.LuaUIGroup.gameObject:SetActive(true)
    pageItem.obj.BgWoman:SetActiveEx(pageItem.data.sex == SexType.SEX_FEMALE)
    pageItem.obj.BgMan:SetActiveEx(pageItem.data.sex == SexType.SEX_MALE)
    pageItem.obj.TxtName.LabText = pageItem.data.name
    pageItem.obj.TxtScore.LabText = Lang("Fashion_Point", pageItem.data.score) --得分:%s.PT
    local l_ProRow = TableUtil.GetProfessionTable().GetRowById(pageItem.data.type or 0, true)--实际职业
    pageItem.obj.TxtJob.LabText = l_ProRow and l_ProRow.Name or "???"
    pageItem.obj.TxtRank.LabText = self:GetRankDescByRank(pageItem.data.rank)
    pageItem.obj.TxtPoint.LabText = pageItem.data.outlook.fashion_count
    if pageItem.obj.Btn then
        pageItem.obj.Btn.Btn.onClick:RemoveAllListeners()
        pageItem.obj.Btn.Btn.onClick:AddListener(function()
            Common.CommonUIFunc.RefreshPlayerMenuLByUid(pageItem.data.rid)
        end)
    end
    if pageItem.obj.BtnMax then
        pageItem.obj.BtnMax:SetActiveEx(true)
        pageItem.obj.BtnMax.Btn.onClick:RemoveAllListeners()
        pageItem.obj.BtnMax.Btn.onClick:AddListener(function()
            local l_fashionData = {
                openType = DataMgr:GetData("FashionData").EUIOpenType.RATING_PHOTO_INCLUDE,
                data = pageItem.data
            }
            UIMgr:ActiveUI(UI.CtrlNames.FashionRatingPhoto, l_fashionData)
        end)
    end
    self:ShowRT(pageItem)
    self:ShowHead(pageItem)

end

function FashionRatingCtrl:ClearPageItem(pageItem)

    self:ClearRT(pageItem)
    self:ClearHead(pageItem)
    local l_st = ""
    pageItem.obj.LuaUIGroup.gameObject:SetActiveEx(false)
    pageItem.obj.BgWoman:SetActiveEx(false)
    pageItem.obj.BgMan:SetActiveEx(false)
    pageItem.obj.TxtName.LabText = l_st
    pageItem.obj.TxtScore.LabText = l_st
    pageItem.obj.TxtJob.LabText = l_st
    pageItem.obj.TxtRank.LabText = l_st
    pageItem.obj.TxtPoint.LabText = l_st
    if pageItem.obj.BtnMax then
        pageItem.obj.BtnMax:SetActiveEx(false)
    end

end

function FashionRatingCtrl:ShowRT(pageItem)

    if pageItem.model or not pageItem.obj.Model then
        return
    end

    local l_attr = MgrMgr:GetMgr("PlayerInfoMgr").GetAttribData(pageItem.data)
    if l_attr==nil then
        return
    end

    pageItem.obj.Model.RawImg.raycastTarget = false
    local l_pos, l_scale, l_rotation = pageItem.data:GetPSR()
    if not l_pos then
        l_pos = { x = 0, y = -1.51, z = -0.17 }
        l_scale = { x = 1.9, y = 1.9, z = 1.9 }
        l_rotation = { x = -10.295, y = 180, z = 0 }
    end
    local l_vMat, l_pMat = pageItem.data:GetMatData()
    local l_fxData = {}
    l_fxData.rawImage = pageItem.obj.Model.RawImg
    l_fxData.attr = l_attr
    l_fxData.useShadow = false
    l_fxData.useOutLine = false
    l_fxData.useCustomLight = true
    l_fxData.isOneFrame = true
    if l_pMat and l_vMat then
        l_fxData.isCameraMatrixCustom = true
        l_fxData.vMatrix = l_vMat
        l_fxData.pMatrix = l_pMat
        local l_rotEul = MUIModelManagerEx:GetRotationEulerByViewMatrix(l_vMat)
        l_fxData.customLightDirX = 0
        l_fxData.customLightDirY = l_rotEul.y - 180
        l_fxData.customLightDirZ = 0
    end
    pageItem.model = self:CreateUIModel(l_fxData)

    local l_animKey, l_animPath, l_animTime = pageItem.data:GetAnimInfo()
    l_animKey = l_animKey or "Idle"
    l_animPath = l_animPath or l_attr.CommonIdleAnimPath
    l_animTime = l_animTime or 0
    pageItem.model.Ator:OverrideAnim(l_animKey, l_animPath)
    pageItem.model.Ator:Play(l_animKey, l_animTime)
    pageItem.model.Ator.Speed = 0
    pageItem.obj.Model:SetActiveEx(false)

    pageItem.model:AddLoadModelCallback(function(m)
        pageItem.obj.Model:SetActiveEx(true)
        pageItem.model.Trans:SetPos(l_pos.x, l_pos.y, l_pos.z)
        pageItem.model.Trans:SetLocalScale(l_scale.x, l_scale.y, l_scale.z)
        pageItem.model.UObj:SetRotEuler(l_rotation.x, l_rotation.y, l_rotation.z)

        local l_emotion1, l_emotion2 = pageItem.data:GetEmotion()
        if l_emotion1 and l_emotion2 then
            pageItem.model:ChangeEmotion(l_emotion1, l_emotion2, 999999)
        end
    end)

end

function FashionRatingCtrl:ClearRT(pageItem)

    if not pageItem.model or not pageItem.obj.Model then
        return
    end
    pageItem.obj.Model:SetActiveEx(false)
    pageItem.obj.Model.RawImg.raycastTarget = false
    if pageItem.model then
        self:DestroyUIModel(pageItem.model);
        pageItem.model = nil
    end

end

function FashionRatingCtrl:ShowHead(pageItem)
    if not pageItem.obj.ImgHead then
        return
    end

    pageItem.obj.ImgHead:SetActiveEx(true)
    if self.head[pageItem.key] == nil then
        self.head[pageItem.key] = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = pageItem.obj.ImgHead.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    local l_equipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(pageItem.data)
    ---@type HeadTemplateParam
    local param = {
        EquipData = l_equipData
    }

    self.head[pageItem.key]:SetData(param)
end

function FashionRatingCtrl:ClearHead(pageItem)

    if not pageItem.obj.ImgHead then
        return
    end

    pageItem.obj.ImgHead:SetActiveEx(false)

end

function FashionRatingCtrl:GetRankDescByRank(rank)

    if rank == 1 then
        return rank .. "st"
    elseif rank == 2 then
        return rank .. "nd"
    elseif rank == 3 then
        return rank .. "rd"
    else
        return rank .. "th"
    end

end
--lua custom scripts end
return FashionRatingCtrl