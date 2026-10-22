local lianllach_faction = "cr_hef_clan_lianllach"

rhox_mar_trade_factions[lianllach_faction]=true

cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(lianllach_faction, "rhox_mar_lianllach_faction_trait", true)
		end)
        local faction = cm:get_faction(lianllach_faction)
		if cm:is_new_game() then
            cm:force_add_trait(cm:char_lookup_str(faction:faction_leader()), "rhox_mar_strongbreeze_trait")
            if faction:is_human() then
                local region_key = faction:home_region():name()
                
                
                local x,y = cm:find_valid_spawn_location_for_character_from_settlement(
                    lianllach_faction,
                    region_key,
                    false,
                    true,
                    5
                )
                cm:create_force_with_general(
                    lianllach_faction,
                    "",
                    region_key,
                    x,
                    y,
                    "general",
                    "rhox_mar_wavemaster_council",
                    "names_name_667070084",
                    "",
                    "",
                    "",
                    true,
                    function(cqi)                    
                    end
                );
                cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                cm:wound_character(cm:char_lookup_str(faction:faction_leader()), 999)
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
            end
        end
        
	end
)