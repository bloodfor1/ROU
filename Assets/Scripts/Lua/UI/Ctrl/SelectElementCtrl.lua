--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SelectElementPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SelectElementCtrl = class("SelectElementCtrl", super)
--lua class define end

--lua functions
function SelectElementCtrl:ctor()

	super.ctor(self, CtrlNames.SelectElement, UILayer.Function, nil, ActiveType.None)
	self.handlerTable = {}
end --func end
--next--
function SelectElementCtrl:Init()

	self.panel = UI.SelectElementPanel.Bind(self)
	super.Init(self)
	self.panel.CloseBtn:AddClick(function()
		local l_rect = self.panel.Root.RectTransform
		l_rect.anchoredPosition = Vector2.New(0, 0)
		l_rect:DOAnchorPos(Vector2.New(0, -200), 0.5):OnComplete(function()
			UIMgr:DeActiveUI(UI.CtrlNames.SelectElement)
		end)
		self.panel.CloseBtn:AddClick(nil)

		MgrMgr:GetMgr("MultipleActionMgr").ClearCacheTargetInfo()
	end)

	self.default_handler = ""

end --func end

--next--
function SelectElementCtrl:SetupHandlers()
	if #self.handlerTable > 0 then
    	self:InitHandler(self.handlerTable, self.panel.ToggleTpl, self.panel.Root, self.default_handler)
    end
end --func end

--next--
function SelectElementCtrl:Uninit()

	self.default_handler = nil
	self.handlerTable = {}

	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function SelectElementCtrl:OnActive()
	local l_rect = self.panel.Root.RectTransform
	l_rect.anchoredPosition = Vector2.New(0, -200)
	l_rect:DOAnchorPos(Vector2.New(0, 0), 0.5)

end --func end
--next--
function SelectElementCtrl:OnDeActive()

end --func end
--next--
function SelectElementCtrl:Update()


end --func end



--next--
function SelectElementCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function SelectElementCtrl:AddHandler(handlerName, btnName)
	local l_params = {}
	l_params[1] = handlerName
	l_params[2] = btnName
	l_params[8] = false

	table.insert(self.handlerTable, l_params)
end

function SelectElementCtrl:RemoveAllHandler()
	for k,_ in pairs(self.handlers) do
        self:EnsureUnloadHandler(k)
    end

	self.handlerTable = {}
	self.default_handler = nil
end

function SelectElementCtrl:SetDefaultHandler(handlerName)

	self.default_handler = handlerName
end

--lua custom scripts end
return SelectElementCtrl