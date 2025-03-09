--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ChatLineRedEnvelopeOtherParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field txt_tag_lv MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field RedEnvelopeText MoonClient.MLuaUICom
---@field RedEnvelopeTag MoonClient.MLuaUICom
---@field RedEnvelopeState MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field Permission MoonClient.MLuaUICom
---@field img_tag_bg MoonClient.MLuaUICom
---@field img_chat_tag MoonClient.MLuaUICom
---@field Head MoonClient.MLuaUICom
---@field Channel MoonClient.MLuaUICom
---@field BtnRedEnvelope MoonClient.MLuaUICom
---@field BiaoQian MoonClient.MLuaUICom

---@class ChatLineRedEnvelopeOther : BaseUITemplate
---@field Parameter ChatLineRedEnvelopeOtherParameter

ChatLineRedEnvelopeOther = class("ChatLineRedEnvelopeOther", super)
--lua class define end

--lua functions
function ChatLineRedEnvelopeOther:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ChatLineRedEnvelopeOther:OnDestroy()
	
	    self.head2d = nil
	
end --func end
--next--
function ChatLineRedEnvelopeOther:OnDeActive()
	
	    -- do nothing
	
end --func end
--next--
function ChatLineRedEnvelopeOther:OnSetData(data)
	
	    self.msgPack = data
	    self.playerInfo = data.playerInfo
	    self:_setCustom(data)
	    --玩家名
	    self.Parameter.PlayerName.LabColor = Color.New(106 / 255, 159 / 255, 240 / 255, 1);
	    self.Parameter.PlayerName.LabText = self.playerInfo.name
	    --标签处理
	    MgrMgr:GetMgr("RoleTagMgr").SetTag(self.Parameter.BiaoQian, self.playerInfo.tag)
	    --红包
	    local l_redObj = self.msgPack.RedEnvelope
	    self.Parameter.BtnRedEnvelope:SetActiveEx(l_redObj ~= nil)
	    if l_redObj then
	        --寄语或口令内容
	        local l_content = l_redObj.redMsg or ""
	        l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)  --动态表情替换
	        self.Parameter.RedEnvelopeText.LabText = l_content
	        --红包是否已领取标记
	        if l_redObj.isRecived then
	            self.Parameter.RedEnvelopeState.LabText = Lang("ButtonText_AwardGetFinish")
	            self.Parameter.RedEnvelopeTag:SetSprite("RedEnvelope", "UI_RedEnvelope_Icon_Hongbao_08.png")
	            self.Parameter.BtnRedEnvelope.Img.color = Color.New(1, 1, 1, 180 / 255)
	        else
	            self.Parameter.RedEnvelopeState.LabText = Lang("NOT_GETTED")
	            self.Parameter.RedEnvelopeTag:SetSprite("RedEnvelope", "UI_RedEnvelope_Icon_Hongbao_07.png")
	            self.Parameter.BtnRedEnvelope.Img.color = Color.New(1, 1, 1, 1)
	        end
	        self.Parameter.RedEnvelopeTag.Img:SetNativeSize()
	        --红包点击处理
	        self.Parameter.BtnRedEnvelope:AddClick(function()
	            if l_redObj.isRecived then
	                --如果已经领取过的红包 则直接请求红包的结果
	                MgrMgr:GetMgr("RedEnvelopeMgr").ReqGetRedEnvelopeResultRecord(l_redObj.redId)
	            else
	                --如果没有领过的红包则 请求确认红包状态
	                local l_redIds = {}
	                table.insert(l_redIds, l_redObj.redId)
	                MgrMgr:GetMgr("RedEnvelopeMgr").ReqCheckRedEnvelopeState(l_redIds)
	            end
	            if self.MethodCallback then
	                self.MethodCallback(self.msgPack)
	            end
	        end, true)
	        l_content = l_redObj.redMsg
	    end
	    --公会职称
	    local l_guildData = DataMgr:GetData("GuildData")
	    self.Parameter.Permission:SetActiveEx(false)
	    --在公会中 且 职位大于成员 且 当前是公会频道 显示职称
	    local l_permission = self.playerInfo.data.guild_permission
	    if l_permission ~= nil and
	            l_permission <= l_guildData.EPositionType.Beauty and
	            l_permission > l_guildData.EPositionType.NotInGuild and
	            self.msgPack.channel == DataMgr:GetData("ChatData").EChannel.GuildChat then
	        self.Parameter.Permission:SetActiveEx(true)
	        local l_permissionStr = l_guildData.GetPositionName(l_permission) or ""
	        l_permissionStr = StringEx.Format("[{0}]", l_permissionStr)
	        self.Parameter.Permission.LabText = l_permissionStr
	        if l_guildData.IsGuildBeauty(l_permission) then
	            self.Parameter.Permission.LabColor = Color.New(255 / 255, 134 / 255, 157 / 255, 1)
	        else
	            self.Parameter.Permission.LabColor = RoColor.Hex2Color("FF9A23FF")
	        end
	    end
	    --已读消息
	    MgrMgr:GetMgr("ChatMgr").ReadChat(self.msgPack)
	
end --func end
--next--
function ChatLineRedEnvelopeOther:BindEvents()
	
	    -- do nothing
	
end --func end
--next--
--lua functions end

--lua custom scripts
--- 点击头像触发的事件
function ChatLineRedEnvelopeOther:_onIconClick()
    MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.playerInfo.uid, self.playerInfo)
    if self.MethodCallback then
        self.MethodCallback(self.msgPack)
    end
end

--- 设置玩家个性化数据
---@param data ChatMsgPack
function ChatLineRedEnvelopeOther:_setCustom(data)
    --- 头像
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Head.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = self.playerInfo:GetEquipData(),
        ShowProfession = true,
        Profession = self.playerInfo.type,
        ShowLv = true,
        Level = self.playerInfo.level,
        OnClick = self._onIconClick,
        OnClickSelf = self,
    }

    self.head2d:SetData(param)

    --- 设置聊天标签
    local tagID = data.playerInfo.ChatTagID
	MgrMgr:GetMgr("ChatMgr").UpdateChatTag(tagID,self.Parameter.img_chat_tag,
			self.Parameter.img_tag_bg, self.Parameter.txt_tag_lv)
end
--lua custom scripts end
return ChatLineRedEnvelopeOther