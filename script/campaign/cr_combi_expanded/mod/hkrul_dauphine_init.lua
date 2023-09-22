local dauphine_faction = "ovn_mar_cult_of_manann"  

local function rhox_dauphine_init_setting()    
    



	local faction = cm:get_faction(dauphine_faction);
    local faction_leader_cqi = faction:faction_leader():command_queue_index();

    local x = 1230
    local y = 190
    

    cm:create_force_with_general(
    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
    dauphine_faction,
    "hkrul_manann_flagellant,hkrul_manann_flagellant,hkrul_mar_sons_of_manann,wh_dlc04_emp_inf_free_company_militia_0,wh_dlc04_emp_inf_free_company_militia_0,hkrul_mar_culverin,ovn_mar_inf_knights_mariner_0",
    "cr_combi_region_khuresh_4_1",
    x,
    y,
    "general",
    "hkrul_dauphine",
    "names_name_6670700851",
    "",
    "names_name_6670700850",
    "",
    true,
    function(cqi)
        local character = cm:get_character_by_cqi(cqi)
        local forename =  common:get_localised_string("names_name_6670700851")
        local surname =  common:get_localised_string("names_name_6670700850")
        cm:change_character_custom_name(character, forename, surname,"","") --for emp as they don't have this name group
        
    end);
    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
    cm:force_declare_war(dauphine_faction, "cr_kho_servants_of_the_blood_nagas", false, false)
    cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)

    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
    cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
    cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
    cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
    
    local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), x, y, false, 5);
    cm:create_agent(dauphine_faction, "wizard", "mar_sea_wizard", agent_x, agent_y);       
    
    cm:make_region_visible_in_shroud("wh_main_emp_marienburg", "cr_combi_region_khuresh_4_1")
    cm:make_region_visible_in_shroud("ovn_mar_cult_of_manann", "wh3_main_combi_region_marienburg")
    cm:make_diplomacy_available("ovn_mar_cult_of_manann", "wh_main_emp_marienburg")
    
    if faction:is_human() then --teleport the Khorne guy when the dauphine is human
    --[[
        cm:callback(
            function()
                --local enemy_x, enemy_y = cm:find_valid_spawn_location_for_character_from_position("cr_kho_servants_of_the_blood_nagas", 1230, 240, false, 5);
                local enemy_leader = cm:get_faction("cr_kho_servants_of_the_blood_nagas"):faction_leader()
                cm:teleport_to(cm:char_lookup_str(enemy_leader), 1245, 226)
            end,
            5
        )
        --]]
        local khuresh_region = cm:get_region("cr_combi_region_khuresh_4_1")
        local dauphine_settlement = khuresh_region:settlement()
        cm:instantly_set_settlement_primary_slot_level(dauphine_settlement , 1) --reduce the starting settlement level for the human
        --cm:instant_set_building_health_percent("cr_combi_region_khuresh_4_1", "wh3_main_kho_settlement_major", 1)--for easy conquer
    else
    end
    cm:transfer_region_to_faction("cr_combi_region_khuresh_4_1",dauphine_faction)
    local khuresh_region = cm:get_region("cr_combi_region_khuresh_4_1")
    local khuresh_region_cqi = khuresh_region:cqi()
    cm:heal_garrison(khuresh_region_cqi)
    
    
    cm:callback(
        function()
            cm:show_message_event(
                dauphine_faction,
                "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                "factions_screen_name_" .. dauphine_faction,
                "event_feed_strings_text_rhox_mar_event_feed_string_scripted_event_intro_dauphine_secondary_detail",
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
			mixer_set_faction_trait(dauphine_faction, "rhox_dauphine_faction_trait", true)
		end)
        
		if cm:is_new_game() then
            rhox_dauphine_init_setting()
        end
        if cm:get_faction(dauphine_faction):is_human() then
            if cm:model():turn_number() < 3 then
                core:add_listener(
                    "rhox_mar_dauphine_RoundStart",
                    "FactionRoundStart",
                    function(context)
                        return context:faction():name() == dauphine_faction
                    end,
                    function(context)
                        if cm:model():turn_number() == 2 then
                            cm:trigger_incident(dauphine_faction, "rhox_mar_dauphine_turn2", true)
                        end
                    end,
                    true
                )
            end
        end
	end
)
]]