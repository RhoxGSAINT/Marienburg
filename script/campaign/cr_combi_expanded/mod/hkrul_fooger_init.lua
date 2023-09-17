local fooger_faction = "ovn_mar_house_fooger"  

local function rhox_fooger_init_setting()



	local faction = cm:get_faction(fooger_faction);
    local faction_leader_cqi = faction:faction_leader():command_queue_index();

    local x = 1131
    local y = 392
    

    cm:create_force_with_general(
    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
    fooger_faction,
    "hkrul_fooger_ror,hkrul_mar_fooger_qual,hkrul_mar_fooger_qual,hkrul_mar_fooger_qual_great,hkrul_mar_fooger_qual_great,hkrul_mar_mortar,hkrul_carriers",
    "cr_combi_region_ind_1_3",
    x,
    y,
    "general",
    "hkrul_fooger",
    "names_name_6670700853",
    "",
    "names_name_6670700852",
    "",
    true,
    function(cqi)
        local character = cm:get_character_by_cqi(cqi)
        local forename =  common:get_localised_string("names_name_6670700853")
        local surname =  common:get_localised_string("names_name_6670700852")
        cm:change_character_custom_name(character, forename, surname,"","") --for emp as they don't have this name group
        
    end);
    

    if faction:is_human() then --only human Fooger gets Guzunda
        cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_guzunda", true)
        local unique_agent = cm:get_most_recently_created_character_of_type(faction, "champion", "hkrul_guzunda")
        if unique_agent then 
            cm:replenish_action_points(cm:char_lookup_str(unique_agent:cqi()))
        end
        
        local mm = mission_manager:new(fooger_faction, "rhox_mar_fooger_alliance")
        mm:add_new_objective("MAKE_ALLIANCE");
        mm:add_condition("faction wh_main_dwf_dwarfs");
        mm:add_payload("text_display rhox_fooger_thane_rewards");
        mm:trigger() 
        
        local ind_region = cm:get_region("cr_combi_region_ind_1_3")
        local foger_settlement = ind_region:settlement()
        cm:instantly_set_settlement_primary_slot_level(foger_settlement , 1)
    end
    
    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
    cm:force_declare_war(fooger_faction, "cr_ogr_deathtoll", false, false)
    cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
    
    cm:transfer_region_to_faction("cr_combi_region_ind_1_3",fooger_faction)
    local ind_region = cm:get_region("cr_combi_region_ind_1_3")
    local ind_region_cqi = ind_region:cqi()
    cm:heal_garrison(ind_region_cqi)

    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
    cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
    cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
    cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
    
    --[[
    local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), x, y, false, 5);
    cm:create_agent(fooger_faction, "wizard", "mar_sea_wizard", agent_x, agent_y);       --]]
    cm:make_region_visible_in_shroud("wh_main_emp_marienburg", "cr_combi_region_ind_1_3")
    cm:make_region_visible_in_shroud("ovn_mar_house_fooger", "wh3_main_combi_region_marienburg")
    cm:make_diplomacy_available("ovn_mar_house_fooger", "wh_main_emp_marienburg")
    
    cm:callback(
        function()
            cm:show_message_event(
                fooger_faction,
                "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                "factions_screen_name_" .. fooger_faction,
                "event_feed_strings_text_rhox_mar_event_feed_string_scripted_event_intro_fooger_secondary_detail",
                true,
                591
            );
        end,
        1
    )
    
    
    
    

    
        
end



--[[

cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(fooger_faction, "rhox_fooger_faction_trait", true)
		end)
        
		if cm:is_new_game() then
            rhox_fooger_init_setting()
            local faction = cm:get_faction(fooger_faction)
            for i=1,#rhox_fooger_reinforcements_units do
                local unit = rhox_fooger_reinforcements_units[i]
                cm:add_unit_to_faction_mercenary_pool(faction,unit,"renown",0,100,20,0,"","","",true,unit)
            end
        end
	end
)
]]
