local followers = {
	{
		["follower"] = "hkrul_mar_heir",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
                local faction = context:character():faction()
                local faction_key = faction:name()
				return cm:character_won_battle_against_culture(context:character(), "wh_main_emp_empire") and faction_key == "wh_main_emp_marienburg" and not faction:ancillary_exists("hkrul_mar_heir");
			end,
		["chance"] = 20
	},
	{
		["follower"] = "hkrul_mar_gote",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
                local faction = context:character():faction()
                local faction_key = faction:name()
				return cm:character_won_battle_against_culture(context:character(), "wh_main_emp_empire") and faction_key == "wh_main_emp_marienburg" and not faction:ancillary_exists("hkrul_mar_gote");
			end,
		["chance"] = 20
	}
};

function rhox_mar_load_followers()
	for i = 1, #followers do
		core:add_listener(
			followers[i].follower,
			followers[i].event,
			followers[i].condition,
			function(context)
				local character = context:character();
				local chance = followers[i].chance;
				
				if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") and cm:random_number(100) <= chance then
					cm:force_add_ancillary(context:character(), followers[i].follower, false, false);
				end;
			end,
			true
		);
	end;
end;


cm:add_first_tick_callback(function() rhox_mar_load_followers() end)