--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/StoryBoardPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
StoryBoardCtrl = class("StoryBoardCtrl", super)
--lua class define end

--lua functions
function StoryBoardCtrl:ctor()
	super.ctor(self, CtrlNames.StoryBoard, UILayer.Function, nil, ActiveType.Exclusive)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.StoryBoard
	self.MaskDelayClickTime=2
	self.asyncLoadTask=0

	self.style = nil	
	self.callback = nil
	self.args = nil
end --func end
--next--
function StoryBoardCtrl:Init()
	self.panel = UI.StoryBoardPanel.Bind(self)
	super.Init(self)


end --func end
--next--
function StoryBoardCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function StoryBoardCtrl:OnActive()
    MLuaClientHelper.PlayFxHelper(self.panel.AnimationObj.gameObject)
    local l_storyBoardId = self.uiPanelData.storyBoardId
    local l_callBack = self.uiPanelData.callback
    local l_args = self.uiPanelData.args
    self:SetStoryBoardData(l_storyBoardId,l_callBack,l_args)
end 

function StoryBoardCtrl:SetStoryBoardData(id,callback,args)
	local l_data = TableUtil.GetStoryBoard().GetRowByID(id)
	if l_data == nil then
		logError("StoryBoard does not contain id = {0},@王倩雯",id)
		UIMgr:DeActiveUI(UI.CtrlNames.StoryBoard)
		return
	end
	if l_data.ShareID > 0 and MgrMgr:GetMgr("ShareMgr").CanShare()  then
		self.panel.ShareButton.gameObject:SetActive(true)
	else
		self.panel.ShareButton.gameObject:SetActive(false)
	end
	self.panel.ShareButton:AddClick(function() self:ToShare(id) end)


	self.callback = callback
	self.args = args
	local l_bgImgs =  Common.Functions.VectorToTable(l_data.BGImgs)
	if #l_bgImgs == 0 then
		logError("ID = {0} 的剧情概要 未配置背景图 @王倩雯",id)
	else
		self:ShowBackground(l_bgImgs,id)
	end
	self:RemoveStyle()

	local l_contents = Common.Functions.VectorToTable(l_data.Contents)
	local l_styleId = l_data.StyleID
	if l_styleId > 0 and #l_contents > 0 then
		self:LoadStyle(l_styleId,l_contents)
	end
end
function StoryBoardCtrl:ToShare(id)
	--logError("StoryBoardCtrl:ToShare : "..tostring(id))
	local l_data = TableUtil.GetStoryBoard().GetRowByID(id)
	local ShareID = l_data.ShareID
	MgrMgr:GetMgr("ShareMgr").OpenShareUI(ShareID,nil,MgrMgr:GetMgr("ShareMgr").ShareID.StoryShare,l_data.ID)

end
function StoryBoardCtrl:ShowBackground( bgImgs)
	if #bgImgs == 1 then
		self.panel.BG_Single_Image:SetActiveEx(true)
		self.panel.BG_Multi_Images:SetActiveEx(false)
		local l_bgPath = StringEx.Format("PlotIcon/{0}",bgImgs[1])
		self.panel.BG_Single_Image:SetRawTex(l_bgPath,true)
	else
		self.panel.BG_Single_Image:SetActiveEx(false)
		self.panel.BG_Multi_Images:SetActiveEx(true)
		local l_bgPath_L = StringEx.Format("PlotIcon/{0}",bgImgs[1])
		local l_bgPath_R = StringEx.Format("PlotIcon/{0}",bgImgs[2])
		self.panel.BG_Image_Left:SetRawTex(l_bgPath_L,false)
		self.panel.BG_Image_Right:SetRawTex(l_bgPath_R,false)
	end
end

function StoryBoardCtrl:LoadStyle(styleId,contents)
    local l_location = "UI/Prefabs/StoryBoardStyle/StoryBoardStyle_"..styleId
    self.asyncLoadTask = MResLoader:CreateObjAsync(l_location, function(uobj, sobj, taskId)
    	self.asyncLoadTask = 0
    	if not uobj then
    		logError("不存在Id为"..styleId.."的parefab @王倩雯")
    		return
    	end
    	self.style = uobj
    	self.style.transform:SetParent(self.panel.ContentRoot.Transform)
    	MLuaCommonHelper.SetLocalPos(self.style, 0, 0, 0)
    	MLuaCommonHelper.SetLocalRot(self.style, 0, 0, 0, 0)
    	MLuaCommonHelper.SetLocalScale(self.style, 1, 1, 1)
    	self:ShowContents(styleId,contents)
    end, self, false)
end

function StoryBoardCtrl:RemoveStyle()
    if self.asyncLoadTask and self.asyncLoadTask > 0 then
        MResLoader:CancelAsyncTask(self.asyncLoadTask)
        self.asyncLoadTask = 0
    end
    if self.style ~= nil then
    	self.style.transform:SetParent(nil)
    	MResLoader:DestroyObj(self.style, false)
    	self.style = nil
    end
end

function StoryBoardCtrl:ShowContents(styleId,contents)
	local l_textList = self:GetStyleTextList()
	if l_textList == nil then
		return
	end
	local l_maxContentCount = #contents
	local l_maxTextCount = #l_textList
	if l_maxContentCount > l_maxTextCount then
		logRed("配置最大文本段落为{0},{1}样式上最多只有{2}个文本,超出的将不会显示,请检查配置 @王倩雯",l_maxContentCount,styleId,l_maxTextCount)
	end
	for k,v in pairs(l_textList) do
		if k > l_maxContentCount then
			v.gameObject:SetActiveEx(false)
		else
			v.gameObject:SetActiveEx(true)
			local l_content = contents[k]
			v.text = l_content
		end
	end

	if self.callback == nil then
		return
	end
	self.callback(self.args)
end

function StoryBoardCtrl:GetStyleTextList( ... )
	if self.style == nil then
		return nil
	end
	local l_tmp = self.style:GetComponentsInChildren("UIRichText")
	local l_count = l_tmp.Length
	if l_count == 0 then
		return nil
	end
	local l_textList = {}
	for i = 0,l_count - 1 do
		local l_text = l_tmp[i]
		l_textList[tonumber(l_text.gameObject.name)] = l_text
	end
	return l_textList
end

--next--
function StoryBoardCtrl:OnDeActive()
	self:RemoveStyle()
	self.callback = nil
	self.args = nil
end --func end
--next--
function StoryBoardCtrl:Update()
		
end --func end





--next--
function StoryBoardCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return StoryBoardCtrl