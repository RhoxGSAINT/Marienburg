local function cr_change_marienburg_campaign_display()
    --change the campaign settlement model used
	cm:override_building_chain_display("wh_main_EMPIRE_settlement_major", "cr_mar_special_settlement_marienburg", "wh3_main_combi_region_marienburg")
end



cm:add_first_tick_callback(
	function()
		if cm:is_new_game() then
			if cm:get_campaign_name() == "main_warhammer" then
				cr_change_marienburg_campaign_display()
			end
		end
	end
)