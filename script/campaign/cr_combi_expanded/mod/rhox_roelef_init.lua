local roelef_faction = "mixer_emp_house_de_roelef"

rhox_mar_trade_factions[roelef_faction]=true

local function rhox_roelef_init_setting()



	local faction = cm:get_faction(roelef_faction);
    local faction_leader_cqi = faction:faction_leader():command_queue_index();
    
    cm:transfer_region_to_faction("cr_combi_region_akhaba",roelef_faction)    

    cm:create_force_with_general(
    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
    roelef_faction,
    "wh3_dlc25_emp_veh_marienburg_land_ship,hkrul_privateers,hkrul_mar_inf_goedendagers,hkrul_mar_inf_greatsword,hkrul_mar_inf_boogschutter,hkrul_carriers_ror,hkrul_mar_inf_goedendagers",
    "cr_combi_region_akhaba",
    505,
    247,
    "general",
    --"hkrul_roelef",
    "wh_main_emp_lord",
    "names_name_1570717836",
    "",
    "names_name_1570717835",
    "",
    true,
    function(cqi)        
    end);
    
    cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
    cm:force_declare_war(roelef_faction, "wh3_main_ogre_the_famished", false, false)
    cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
    
    
    local ind_region = cm:get_region("cr_combi_region_akhaba")
    local ind_region_cqi = ind_region:cqi()
    cm:heal_garrison(ind_region_cqi)

    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
    cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
    cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
    cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
    
    cm:create_force_with_general(
        -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
        "wh3_main_ogre_the_famished",
        "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_maneaters_0,wh3_main_ogr_inf_maneaters_1",
        "cr_combi_region_akhaba",
        510,
        250,
        "general",
        "wh3_main_ogr_tyrant",
        "",
        "",
        "",
        "",
        false,
        function(cqi)
        end
    );
    
    
    cm:callback(
        function()
            cm:show_message_event(
                roelef_faction,
                "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                "factions_screen_name_" .. roelef_faction,
                "event_feed_strings_text_rhox_mar_event_feed_string_scripted_event_intro_roelef_secondary_detail",
                true,
                591
            );
        end,
        1
    )
        
end


cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(roelef_faction, "rhox_mar_roelef_faction_trait", true)
		end)
        local faction = cm:get_faction(roelef_faction)
		if cm:is_new_game() then
            rhox_roelef_init_setting()
        end
	end
)