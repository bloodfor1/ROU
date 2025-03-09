--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BlackWordPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
BlackWordCtrl = class("BlackWordCtrl", super)

local l_rowShowTime=1
local l_nowShowRow
local l_context
local l_cntShowTime
--lua class define end

--lua functions
function BlackWordCtrl:ctor()

	super.ctor(self, CtrlNames.BlackWord, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function BlackWordCtrl:Init()

	self.panel = UI.BlackWordPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function BlackWordCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BlackWordCtrl:OnActive()

	self:AddListener()

	self.panel.TxtContent.LabText=""
	l_context =nil

	local l_bwTableRow=TableUtil.GetBlackWord().GetRowByID(MUIBlackWordMgr.bwTableId)
	if l_bwTableRow~=nil then
		l_context = Common.Functions.VectorToTable(l_bwTableRow.Context)
	end
	l_nowShowRow=0
	l_cntShowTime=0
end --func end
--next--
function BlackWordCtrl:OnDeActive()


end --func end
--next--
function BlackWordCtrl:Update()
	if self.panel==nil or l_context==nil or #l_context==0 then
		return
	end
	if l_nowShowRow==0 then
		l_nowShowRow=l_nowShowRow+1
		self:AddContextRow(l_context[l_nowShowRow])
		return
	end
	l_cntShowTime=l_cntShowTime + Time.deltaTime
	if l_cntShowTime>l_rowShowTime then
		l_cntShowTime=0
		l_nowShowRow=l_nowShowRow+1
		if l_nowShowRow>#l_context then
			l_context=nil
			return
		end
		self:AddContextRow(l_context[l_nowShowRow])
	end
end --func end



--next--
function BlackWordCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function BlackWordCtrl:AddListener()
	if self.panel==nil then
		return
	end
	self.panel.ImgBg.Listener.onClick = function(uobj, event)
		if l_context~=nil and l_nowShowRow < #l_context then
			l_nowShowRow=l_nowShowRow+1
			while l_nowShowRow <= #l_context do
				self:AddContextRow(l_context[l_nowShowRow])
				l_nowShowRow=l_nowShowRow+1
			end
			l_context=nil
		else
			self:WordOver()
		end
    end
end

function BlackWordCtrl:AddContextRow(s)
	self.panel.TxtContent.LabText=self.panel.TxtContent.LabText.."\n"..s
end

function  BlackWordCtrl:WordOver()
	UIMgr:DeActiveUI(UI.CtrlNames.BlackWord)
	MUIBlackWordMgr:EndCallBack()
end

--lua custom scripts end
