declareGlobal("GiftLevelActivity",{})
require("Table/BasePackageTable")

GiftLevelActivity.SystemId = 11203
GiftLevelActivity.FreeBaseGiftType = 0
GiftLevelActivity.SaleBaseGiftType = 1

function GiftLevelActivity.GetReward(level_gift_info, arg, res)
	--level_gift_info:IsReceivedGift(-100, 1)
	local role = level_gift_info:GetRole()
    if not role:IsSystemOpen(GiftLevelActivity.SystemId) then
        res:set_result(KKSG.ERR_SYSTEM_NOT_OPEN)
        return
    end
	
    local gift_id = arg:gift_id()
	local gift_type = arg:type()
	--level_gift_info:IsReceivedGift(-100, 11)
	local gift_conf = Table.BasePackageTable.GetRowById(gift_id)
	--level_gift_info:IsReceivedGift(-111, gift_id)
	--level_gift_info:IsReceivedGift(-111, gift_type)
	if not gift_conf then
	    --level_gift_info:IsReceivedGift(-111, -111)
        ScriptTool:PrintError("BasePackageTable is nullptr id is "..tostring(gift_id))
		res:set_result(KKSG.ERR_INVALID_CONFIG)
        return
    end
	--level_gift_info:IsReceivedGift(-100, 12)
	if role:GetLevel() < gift_conf.Base then
		res:set_result(KKSG.ERR_NOT_ENOUGH_BASE_LEVEL)
		return
	end
	--level_gift_info:IsReceivedGift(-100, 13)
	if level_gift_info:IsReceivedGift(gift_id, gift_type) ~= 0 then
		res:set_result(KKSG.ERR_LEVEL_GIFT_HAS_RECEIVED)
		return
	end
	--level_gift_info:IsReceivedGift(-100, 2)
	--mian fei
	if gift_type == GiftLevelActivity.FreeBaseGiftType then
		local space_num = LevelGift:GetBagSpaceNumber(role)
		if(space_num < gift_conf.FreeBasePackage:size()) then
			res:set_result(KKSG.ERR_LEVEL_GIFT_BAG_NUM)
			return
		end
		--local reason = ChangeReason:new_local(KKSG.ITEM_REASON_LEVEL_GIFT);
		--local award_ids = std.vector_int_:new_local()
		--level_gift_info:IsReceivedGift(-100, 3)
		for index = 1, gift_conf.FreeBasePackage:size() do
			local award_id = gift_conf.FreeBasePackage[index-1]
			--award_ids:push_back(award_id);
			--level_gift_info:IsReceivedGift(-100, 4)
			local award_result = AwardLogic:ZhuDongGetAward(role, award_id, KKSG.ITEM_REASON_LEVEL_GIFT);
			res:set_result(award_result.error)
			if award_result.error ~= KKSG.ERR_SUCCESS then
				return
			end
		end
		--AwardLogic:SendAward(role, award_ids, reason);
	else
	--shou fei
		local space_num = LevelGift:GetBagSpaceNumber(role)
		if(space_num < gift_conf.SaleBasePackage:size()) then
			res:set_result(KKSG.ERR_LEVEL_GIFT_BAG_NUM)
			return
		end
		
		local cost_items = std.vector_ItemDesc_:new_local()
		for index = 1, gift_conf.SaleBasePackagePrice:size() do
			if gift_conf.SaleBasePackagePrice[index-1]:size() == 2 then
				local cost_item = ItemDesc:new_local()
				cost_item.item_id = gift_conf.SaleBasePackagePrice[index-1][0]
				cost_item.item_count = gift_conf.SaleBasePackagePrice[index-1][1]
				cost_items:push_back(cost_item)
			end
		end
		
		local error_code = ItemTransition:TakeItem(role, cost_items, KKSG.ITEM_REASON_LEVEL_GIFT_BUY)
		if error_code ~= KKSG.ERR_SUCCESS then
			res:set_result(KKSG.ERR_LEVEL_GIFT_MONEY_NOT_ENOUGH)
			return
		end

		--local reason = ChangeReason:new_local(KKSG.ITEM_REASON_LEVEL_GIFT);
		--local award_ids = std.vector_int_:new_local()
		for index = 1, gift_conf.SaleBasePackage:size() do
			local award_id = gift_conf.SaleBasePackage[index-1]
			--award_ids:push_back(award_id);
			local award_result = AwardLogic:ZhuDongGetAward(role, award_id, KKSG.ITEM_REASON_LEVEL_GIFT_BUY);
			res:set_result(award_result.error)
			if award_result.error ~= KKSG.ERR_SUCCESS then
				return
			end
		end

		--AwardLogic:SendAward(role, award_ids, reason);
	end
    --level_gift_info:IsReceivedGift(-100, 10)
	
	level_gift_info:ReceiveGift(gift_id, gift_type)
	res:set_result(KKSG.ERR_SUCCESS)
end