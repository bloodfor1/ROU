--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GetSpecialItemDialogPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GetSpecialItemDialogCtrl = class("GetSpecialItemDialogCtrl", super)
--lua class define end

--lua functions
function GetSpecialItemDialogCtrl:ctor()

	super.ctor(self, CtrlNames.GetSpecialItemDialog, UILayer.Tips, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.ClosePanelNameOnClickMask=UI.CtrlNames.GetSpecialItemDialog
	
end --func end
--next--
function GetSpecialItemDialogCtrl:Init()
	
	self.panel = UI.GetSpecialItemDialogPanel.Bind(self)
    super.Init(self)

    --self:SetBlockOpt(BlockColor.Dark,function ()
		--UIMgr:DeActiveUI(UI.CtrlNames.GetSpecialItemDialog)
    --end)
    
	self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
	})
	
    self.panel.Btn01:AddClick(function()
        if self.btn01Func ~= nil then
            self.btn01Func()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.GetSpecialItemDialog)
    end)
    self.panel.Btn02:AddClick(function()
        if self.btn02Func ~= nil then
            self.btn02Func()
        end
        UIMgr:DeActiveUI(UI.CtrlNames.GetSpecialItemDialog)
    end)
end --func end
--next--
function GetSpecialItemDialogCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function GetSpecialItemDialogCtrl:OnActive()
	
	
end --func end
--next--
function GetSpecialItemDialogCtrl:OnDeActive()
	
	
end --func end
--next--
function GetSpecialItemDialogCtrl:Update()
	
	
end --func end





--next--
function GetSpecialItemDialogCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
--title 标题
--content 内容
--onConfirm 确认函数
--onCancel 取消函数
--consume Item列表
function GetSpecialItemDialogCtrl:SetDlgInfo(title,content,btn01Txt,btn02Txt,btn01Func,btn02Func,consume,titleSprite)
    self.btn01Func = btn01Func
	self.btn02Func = btn02Func
	
    if consume ~= nil then
        self.panel.Content.LabText = content
        self.panel.Btn01Txt.LabText = btn01Txt
        self.panel.Btn02Txt.LabText = btn02Txt
        self.panel.TxtTitle.LabText = title

        self.panel.Content.gameObject:SetActiveEx(content~=nil)
        self.panel.TxtTitle.gameObject:SetActiveEx(true)
        self.panel.ItemParent.gameObject:SetActiveEx(true)
        self.itemPool:ShowTemplates({Datas = consume,Parent = self.panel.ItemParent.transform})
    end
end
--lua custom scripts end
return GetSpecialItemDialogCtrl