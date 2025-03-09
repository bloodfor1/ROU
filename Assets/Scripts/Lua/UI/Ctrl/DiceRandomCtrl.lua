--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DiceRandomPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
DiceRandomCtrl = class("DiceRandomCtrl", super)
--lua class define end

--lua functions
function DiceRandomCtrl:ctor()

	super.ctor(self, CtrlNames.DiceRandom, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function DiceRandomCtrl:Init()

	self.panel = UI.DiceRandomPanel.Bind(self)
    super.Init(self)

    self.panel.Floor.Listener.onClick=function(obj,data)
        --UIMgr:DeActiveUI(CtrlNames.DiceRandom)
    end

    self.SpriteCom = nil
    self.panel.Image:SetActiveEx(false)
    local l_modelData = 
    {
        prefabPath = "Effects/Prefabs/Creature/Ui/Fx_Ui_ShaiZi_02",
        rawImage = self.panel.Image.RawImg,
    }
    self.NoneModel = self:CreateUIModelByPrefabPath(l_modelData)
    self.NoneModel:AddLoadModelCallback(function(m)
        self.NoneModel.Trans:SetLocalScale(10,10,10)
        self.NoneModel.Trans:SetLocalPos(0,0.54,0)
        self.NoneModel.UObj:SetRotEuler(0,0,0)
        self.panel.Image:SetActiveEx(true)

        self.SpriteCom = self.NoneModel.Trans:Find("Main/Item_Scene_Shaizi").gameObject:GetComponent("MDiceBehaviour")

        self:ResetIcon()

        local l_fxCom = self.NoneModel.UObj:GetComponent("MLuaUICom")
        l_fxCom.FxAnim:PlayAll()
    end)

end --func end
--next--
function DiceRandomCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

    self.SpriteCom = nil

    self.ItemIDLis = nil
    if self.NoneModel ~= nil then
        self:DestroyUIModel(self.NoneModel);
        self.NoneModel = nil
    end
end --func end
--next--
function DiceRandomCtrl:OnActive()
    self:ResetIcon()

end --func end
--next--
function DiceRandomCtrl:OnDeActive()


end --func end
--next--
function DiceRandomCtrl:Update()


end --func end





--next--
function DiceRandomCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function DiceRandomCtrl:InitItems(mainItem,itemIDLis,pos)
    self.MainItem = mainItem
    self.ItemIDLis = itemIDLis

    --显示位置
    pos = pos or {x=0,y=-190}
    self.panel.Image.gameObject:SetRectTransformPos(pos.x,pos.y)

    --小于6个随机补足
    if #self.ItemIDLis > 0 then
        while #self.ItemIDLis < 6 do
            local l_randomID = self.ItemIDLis[math.random(1,#self.ItemIDLis)]
            self.ItemIDLis[#self.ItemIDLis+1] = l_randomID
        end
    end

    --五号位置为主位置
    local l_mainPos = -1
    for i=1,6 do
        if self.MainItem == self.ItemIDLis[i] then
            l_mainPos = i
            break
        end
    end
    if l_mainPos>=0 and l_mainPos~=5 then
        local l_temID = self.ItemIDLis[l_mainPos]
        self.ItemIDLis[l_mainPos] = self.ItemIDLis[5]
        self.ItemIDLis[5] = l_temID
    end

    self:ResetIcon()
end

function DiceRandomCtrl:ResetIcon()
    if not self.SpriteCom then
        return
    end

    for i=0,5 do
        local l_atlas,l_sprite = self:GetItemInfo(i+1)
        self.SpriteCom:SetDirSprite(MoonClient.DiceDirection.IntToEnum(i),l_sprite,l_atlas)
    end
end

function DiceRandomCtrl:GetItemInfo(pos)
    if self.ItemIDLis==nil or #self.ItemIDLis<=0 then
        return
    end
    if #self.ItemIDLis<pos then
        return
    end
    local l_row = TableUtil.GetItemTable().GetRowByItemID(self.ItemIDLis[pos])
    if l_row==nil then
        return
    end
    return l_row.ItemAtlas,l_row.ItemIcon
end
--lua custom scripts end
