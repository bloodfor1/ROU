declareGlobal("ExpCalculate",{})

function ExpCalculate.SpecialDeal(role,exp_data,extra_param)
	if extra_param.need_special_deal == kExpOperationTypeKillMonster then
		if exp_data.normal_exp <= int64.new(0) and extra_param.is_static_scene and extra_param.level_diff >= -10 then
			exp_data.normal_exp = 1
		end
	end
end