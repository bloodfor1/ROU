--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/WatchWarPanel"
require "UI/Template/WatchClassifyButtonTemplate"
require "UI/Template/WatchTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
WatchWarHandler = class("WatchWarHandler", super)
--lua class define end

--lua functions
function WatchWarHandler:ctor()
	
	super.ctor(self, HandlerNames.WatchWar, 0)
	
end --func end
--next--
function WatchWarHandler:Init()
	
	self.panel = UI.WatchWarPanel.Bind(self)
	super.Init(self)
	
	self.classifyTemplatePool = self:NewTemplatePool({
		TemplatePrefab = self.panel.WatchClassifyButtonTemplate.gameObject,
        UITemplateClass = UITemplate.WatchClassifyButtonTemplate,
		TemplateParent = self.panel.WatchClassifyButtonParent.transform,
	})

	self.watchTemplatePool = self:NewTemplatePool({
		TemplatePrefab = self.ctrlRef:GetCommonTemplateGO("WatchTemplate"),
        UITemplateClass = UITemplate.WatchTemplate,
		-- TemplateParent = self.panel.Content.transform,
		ScrollRect = self.panel.ScrollView.LoopScroll,
	})
    
	self.cachedClassifyList = nil
    self.lastPage = nil

	self.mgr = MgrMgr:GetMgr("WatchWarMgr")
	self.dataMgr = DataMgr:GetData("WatchWarData")

    local l_lastHandRefreshTime = -1000
    self.panel.Btn_N_B01:AddClick(function()
        -- 刷新按钮时间单独计算
        if Time.realtimeSinceStartup - l_lastHandRefreshTime < self.dataMgr.SpectatorListRefreshInterval then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFRESH_TOO_FAST"))
            return
        end
        l_lastHandRefreshTime = Time.realtimeSinceStartup
		self.mgr.RequestGetWatchRoomList(self.mgr.GetSelectClassifyTypeID(), nil, nil, true)
	end)

	self.panel.Btn_N_B02:AddClick(function()
		self.mgr.OpenSettingCtrl()
	end)

    self.panel.BtnSearch:AddClick(function()
        if string.ro_len(self.panel.SearchInput.Input.text) < self.dataMgr.SpectatorKeywordMinLength then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("WATCHWAR_SEARCH_CHAR_LIMIT", self.dataMgr.SpectatorKeywordMinLength))
            return
        end
		self.mgr.RequestSearchWatchRoom(self.panel.SearchInput.Input.text)
		-- self.panel.SearchInput.Input.text = ""
	end)

	local l_visible = false
	self.panel.SearchInput.Input.characterLimit = self.mgr.SpectatorKeywordMaxLength
	self.panel.SearchInput.Input.onValueChanged:AddListener(function()
		local l_r = (string.len(self.panel.SearchInput.Input.text) > 0)
		if l_r == l_visible then
			return
		end

		l_visible = l_r
		self.panel.BtnSearchCancel.gameObject:SetActiveEx(l_visible)
	end)
	self.panel.BtnSearchCancel:AddClick(function()
		self.panel.SearchInput.Input.text = ""
		self.mgr.RequestGetWatchRoomList(self.mgr.GetSelectClassifyTypeID(), 1, true)
    end)

	self.panel.Empty.gameObject:SetActiveEx(true)

	self:AddDragListener()
	local l_chatDataMgr=DataMgr:GetData("ChatData")
	l_chatDataMgr.ClearChatInfoCacheByChannel(l_chatDataMgr.EChannel.WatchChat)
end --func end
--next--
function WatchWarHandler:Uninit()
	
	self.classifyTemplatePool = nil
	self.watchTemplatePool = nil
	self.cachedClassifyList = nil
    self.lastPage = nil
    self.lastSelectIndex = nil

    self:ClearAutoRefreshTimer()

	self.mgr = nil
	self.dataMgr = nil

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function WatchWarHandler:OnActive()
	
	if not self.dataMgr.SearchDatas then
		local l_selectTypeId = self.mgr.GetSelectClassifyTypeID()
		if l_selectTypeId ~= self.dataMgr.ESelectClassifyType.Recommend then
			self.mgr.RequestGetWatchRoomList(l_selectTypeId, nil, true)
		else
			self.mgr.RequestGetWatchRoomList(self.dataMgr.ESelectClassifyType.Recommend)
		end
	end
	
    self:RefreshClassifyTypeList()
    self:RefreshWatchPages()
end --func end
--next--
function WatchWarHandler:OnDeActive()
	
	
end --func end
--next--
function WatchWarHandler:Update()
	
	
end --func end


--next--
function WatchWarHandler:BindEvents()
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_SELECT_CLASSIFY_EVENT, self.OnSelectClassifyEvent)
	self:BindEvent(self.mgr.EventDispatcher,self.mgr.ON_WATCH_LIST_DATA_UPDATE, self.OnDataChanged)
end --func end

--next--
--lua functions end

--lua custom scripts
-- 建立观战类型父子关系
function WatchWarHandler:GetClassifyList()
	if self.cachedClassifyList then
		return 
	end

	self.cachedClassifyList = {}
		
	local l_relationshipMaps = {}
	-- 梳理每个父类型拥有的子类型
	for i, v in ipairs(TableUtil.GetSpectatorTypeTable().GetTable()) do
		if v.IsChild > 0 then
			if v.FatherId <= 0 then
				logError("WatchWarHandler:GetClassifyList has error, child not have parent id [SpectatorTypeTable]", v.ID)
			else
				l_relationshipMaps[v.FatherId] = l_relationshipMaps[v.FatherId] or {}
				table.insert(l_relationshipMaps[v.FatherId], v.ID)
			end
		else
			if l_relationshipMaps[v.ID] and l_relationshipMaps[v.ID] ~= v.ID then
				logError("WatchWarHandler:GetClassifyList has error, dumplicate parent id [SpectatorTypeTable]", v.ID)
			end
			l_relationshipMaps[v.ID] = {}
		end
	end
	-- 输出
	for k, v in pairs(l_relationshipMaps) do
		local l_oneData = {
			ID = k,
		}
		if #v > 0 then
			l_oneData.childs = v
			table.sort(l_oneData.childs, function(m, n)
				return m < n
			end)
		end
		table.insert(self.cachedClassifyList, l_oneData)
	end

	table.sort(self.cachedClassifyList, function(m, n)
		return m.ID < n.ID
	end)

end

function WatchWarHandler:OnSelectClassifyEvent()

	self:ResetClassifyListPos()

	self.lastSelectIndex = nil
	if self.classifyTemplatePool then
		for i, v in ipairs(self.classifyTemplatePool:GetItems()) do
			if v:UpdateSelectState() then
				self.lastSelectIndex = i
			end
		end
	end

	self:RefreshWatchPages()
end


function WatchWarHandler:GetClassifyListPos(index)

	if not self.cachedClassifyList then return end

	local l_id = self.dataMgr.GetSelectClassifyTypeID()
	for k, v in ipairs(self.cachedClassifyList) do

		if v.ID == l_id then
			return k
		end

		for i, id in ipairs(v) do
			if id == l_id then
				return k
			end
		end
	end
end

function WatchWarHandler:ResetClassifyListPos(selectIndex, force)
	
	if not selectIndex then
		local l_index, childSelected = self:GetClassifyListPos()
		if not l_index then return end
		selectIndex = l_index
	end

	if selectIndex and (self.lastSelectIndex or force) then
		local l_rect = self.panel.WatchClassifyButtonParent.RectTransform
		if force or (l_rect.anchoredPosition.y - 75 * (self.lastSelectIndex - 1) > 1.4) then
			local l_rrr = 1.4
			if selectIndex > 5 then
				l_rrr = l_rrr + 74 * (selectIndex - 5)
			end
			MLuaCommonHelper.SetRectTransformPosY(self.panel.WatchClassifyButtonParent.gameObject, l_rrr)
		end
	end
end

function WatchWarHandler:OnDataChanged()

	self:RefreshWatchPages()
end

function WatchWarHandler:RefreshWatchPages()

	local l_search = (self.dataMgr.SearchDatas ~= nil)
	local l_originalDatas = self.dataMgr.SearchDatas or self.dataMgr.WatchDatas[self.mgr.GetSelectClassifyTypeID()]
	l_originalDatas = l_originalDatas or {}
	self.mgr.ClearSearchInfo()
	-- 根据观战类型获取templatego
	local function _getTemplateGOByType(type)

		if type == WatchUnitType.kWatchUnitTypePVE then
			return self.ctrlRef:GetCommonTemplateGO("WatchSingleTemplate")
		elseif type == WatchUnitType.kWatchUnitTypePVPLight then
			return self.ctrlRef:GetCommonTemplateGO("WatchPVPTemplate")
		else
			return self.ctrlRef:GetCommonTemplateGO("WatchPVPMultipleTemplate")
		end
	end
	-- 观战的职业template
	local function _getProfessionTemplateGO()
		return self.ctrlRef:GetCommonTemplateGO("WatchProTemplate")
	end
	-- 显示数量限制
    local l_countLimit = self.dataMgr.SpectatorTotalCap
    if self.mgr.GetSelectClassifyTypeID() == self.dataMgr.ESelectClassifyType.Recommend then
        l_countLimit = self.dataMgr.SpectatorPageCap
    end

    local l_count = 0
	local l_showDatas = {}
	for i, v in ipairs(l_originalDatas) do
		table.insert(l_showDatas, {
			orginalData = v,
			tplFunc = _getTemplateGOByType,
			proFunc = _getProfessionTemplateGO,
        })
		l_count = l_count + 1
		-- 数量溢出
        if l_count >= l_countLimit then
            break
        end
	end
	-- LoopScrollView, 手动更新

    local l_lastTotalCount = self.watchTemplatePool:totalCount()
    local l_currentTotalCount = #l_showDatas
    for i = 1, l_currentTotalCount do
    	if i <= l_lastTotalCount then
    		self.watchTemplatePool:ReplaceTemplateData(i, l_showDatas[i])
    	else
    		self.watchTemplatePool:AddTemplate(l_showDatas[i])
    	end
    end

   	for i = l_lastTotalCount - l_currentTotalCount, 1, -1 do
   		local l_index = l_currentTotalCount + i
		self.watchTemplatePool:RemoveTemplateByIndex(l_index)   		
   	end

	-- 刷新列表
    self.watchTemplatePool:RefreshCells()
	-- 更新触发变量
	self:UpdateLocalArgs(#l_showDatas)
	
	self.panel.Empty.gameObject:SetActiveEx(l_currentTotalCount <= 0)
	
	if l_search then
		if self.classifyTemplatePool then
			for i, v in ipairs(self.classifyTemplatePool:GetItems()) do
				v:UpdateSelectState()
			end
		end
	end
end

function WatchWarHandler:RefreshClassifyTypeList()

	local l_childTemplateGo = self.panel.WatchDetailsButtonTemplate.gameObject

	self:GetClassifyList()

	local l_datas = table.ro_deepCopy(self.cachedClassifyList)
	for i, v in ipairs(l_datas) do
		v.childTemplateGo = l_childTemplateGo
	end
	
	local l_selectIndex = 1
	local l_selectTypeId = self.mgr.GetSelectClassifyTypeID()
	if l_selectTypeId ~= self.dataMgr.ESelectClassifyType.Recommend then
		for i, v in ipairs(l_datas) do
			if v.ID == l_selectTypeId then
				l_selectIndex = i
				break
			end
		end
	end

	if l_selectIndex < 6 then l_selectIndex = nil end

	self.classifyTemplatePool:ShowTemplates({Datas = l_datas})

	self:ResetClassifyListPos(l_selectIndex, true)
end

function WatchWarHandler:UpdateLocalArgs(totalCount)

    self.judgeDragOffset = -415
    if totalCount <= 3 then
        self.judgeDragOffset = self.judgeDragOffset + 144 * (3 - totalCount)
    end
    self.totalDataCount = self.panel.ScrollView.LoopScroll.totalCount
end

function WatchWarHandler:ClearAutoRefreshTimer()

    if self.autoRefreshTimer then
		self:StopUITimer(self.autoRefreshTimer)
        self.autoRefreshTimer = nil
    end
end

-- 松手刷新逻辑
function WatchWarHandler:AddDragListener()

    local l_scrollView = self.panel.ScrollView.LoopScroll
    local l_rectTrans = l_scrollView.content
	local l_trigged = false
	local l_notLimited = false
	-- 开始拖拽
    l_scrollView.OnBeginDragCallback = function()
		l_trigged = false
		l_notLimited = false
        self:ClearAutoRefreshTimer()
	end
	-- 拖拽中
    l_scrollView.OnDragCallback = function()
        if l_trigged then return end
        local l_cellEndIndex = l_scrollView.cellEndIndex
        if l_cellEndIndex >= self.totalDataCount then
            if (l_rectTrans.anchoredPosition.y - l_rectTrans.sizeDelta.y) > self.judgeDragOffset then
				l_trigged = true
                if self.mgr.IsSpectatorRefreshLimit(self.mgr.GetSelectClassifyTypeID(), true) then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("REFRESH_TOO_FAST"))
                    return
                end
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("RELEASE_FOR_REFRESH"))
				l_notLimited = true
            end
        end
	end
	-- 拖拽结束
    l_scrollView.OnEndDragCallback = function()
        if l_trigged and not l_notLimited then
            self:ClearAutoRefreshTimer()
            self.autoRefreshTimer = self:NewUITimer(function()
                self:RefreshByDrag(l_scrollView.cellEndIndex)
            end, 1)
            self.autoRefreshTimer:Start()
            l_trigged = false
        end
    end
end

function WatchWarHandler:RefreshByDrag(index)

    local l_page = tonumber(index / self.dataMgr.SpectatorPageCap) + 1
    self.mgr.RequestGetWatchRoomList(self.mgr.GetSelectClassifyTypeID(), l_page)
end


--lua custom scripts end
return WatchWarHandler