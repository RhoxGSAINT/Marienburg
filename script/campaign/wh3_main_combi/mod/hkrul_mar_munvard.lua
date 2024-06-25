local mundvard_faction_key = "ovn_mar_the_wasteland"



--new and fancy Jaan
local mundvard_details = {
    general_faction = mundvard_faction_key,
    unit_list = "wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie,hkrul_burgher,hkrul_burgher,wh_dlc04_vmp_veh_corpse_cart_1,wh_main_vmp_cav_black_knights_0,wh_main_vmp_mon_fell_bats,wh_main_vmp_mon_crypt_horrors", -- unit keys from main_units table
    region_key = "",
    type = "general",																				-- Agent type
    subtype = "hkrul_mar_munvard",																	-- Agent subtype
    forename = "names_name_505123616",															-- From local_en names table, Bernhoff the Butcher is now ruler of Reikland
    clanname = "",																					-- From local_en names table
    surname = "names_name_505123615",																-- From local_en names table
    othername = "",																					-- From local_en names table
    is_faction_leader = true																		-- Bool for whether the general being replaced is the new faction leader
}
-- Replaces the starting general for a specific faction
local function hkrul_mundvard()
    cm:callback(
        function() 
            local mundvard_faction = cm:get_faction(mundvard_faction_key)
            --out("Rhox Mar Mundvard Culture: "..mundvard_faction:culture())
            --out("Rhox Mar Mundvard subCulture: "..mundvard_faction:subculture())
            if mundvard_faction:is_null_interface() == false and mundvard_faction:is_dead() == false then

    
                cm:transfer_region_to_faction("wh3_main_combi_region_fort_bergbres","wh_main_grn_skullsmasherz") --just do it regardless of the player faction
                cm:transfer_region_to_faction("wh3_main_combi_region_grung_zint", mundvard_faction_key)
                local grung_zint_region = cm:get_region("wh3_main_combi_region_grung_zint")
                local grung_zint_cqi = grung_zint_region:cqi()
                cm:heal_garrison(grung_zint_cqi)

                local fort_cqi = cm:get_region("wh3_main_combi_region_fort_bergbres"):cqi()
                cm:heal_garrison(fort_cqi)--change starting settlements and heal the garrison

                cm:force_declare_war(mundvard_faction_key, "wh_main_grn_skullsmasherz", false, false)
                
                
                
                local x, y = cm:find_valid_spawn_location_for_character_from_settlement("wh_main_grn_skullsmasherz", "wh3_main_combi_region_grung_zint", false, true, 0)

                cm:create_force_with_general(
                -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                "wh_main_grn_skullsmasherz",
                "wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_cav_orc_boar_boyz",
                "wh3_main_combi_region_grung_zint",
                x,
                y,
                "general",
                "wh_main_grn_orc_warboss",
                "",
                "",
                "",
                "",
                false,
                function(cqi)
                    cm:set_force_has_retreated_this_turn(cm:get_character_by_cqi(cqi):military_force())
                end);
                
                
                

                local x2, y2 = cm:find_valid_spawn_location_for_character_from_settlement("wh_main_grn_skullsmasherz", "wh3_main_combi_region_fort_bergbres", false, true, 0)

                cm:create_force_with_general(
                -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                "wh_main_grn_skullsmasherz",
                "wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_cav_forest_goblin_spider_riders_0,wh_main_grn_cav_forest_goblin_spider_riders_0",
                "wh3_main_combi_region_fort_bergbres",
                x2,
                y2,
                "general",
                "wh_main_grn_goblin_great_shaman",
                "",
                "",
                "",
                "",
                false,
                function(cqi)
                end);
                
    
                local x, y = 436, 655
                --x, y  = cm:find_valid_spawn_location_for_character_from_settlement(deneuwe_faction_key, "wh3_main_combi_region_fu_chow", false, true, 8)

                -- Shaping starting setup
                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
                local previous_leader_cqi = mundvard_faction:faction_leader():cqi()
                -- replace previous leader with new one
                local char_str
                cm:create_force_with_general(
                    mundvard_details.general_faction,
                    mundvard_details.unit_list,
                    mundvard_faction:home_region():name(),
                    x,
                    y,
                    mundvard_details.type,
                    mundvard_details.subtype,
                    mundvard_details.forename,
                    mundvard_details.clanname,
                    mundvard_details.surname,
                    mundvard_details.othername,
                    mundvard_details.is_faction_leader,
                    function(cqi)
                        char_str = cm:char_lookup_str(cqi)
                        cm:set_character_unique(char_str, true)
                        cm:replenish_action_points(char_str)

                        --kill previous leader and dummy force leader
                        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                        local previous_leader_str = cm:char_lookup_str(previous_leader_cqi)
                        cm:set_character_immortality(previous_leader_str, false)
                        cm:kill_character(previous_leader_str, true)
                        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, 0.5)
                    end
                )
                
                -----------spawn alicia
                --local x3, y3 = cm:find_valid_spawn_location_for_character_from_settlement(mundvard_faction_key, "wh3_main_combi_region_grung_zint", false, true, 0)
                --out("Rhox mar x3, y3: "..x3.."/"..y3)
                --cm:spawn_unique_agent_at_region(cm:get_faction(mundvard_faction_key):command_queue_index(), "hkrul_alicia", grung_zint_cqi, true)
                cm:spawn_agent_at_position(cm:get_faction(mundvard_faction_key), 440, 660, "dignitary","hkrul_alicia")
                local alicia = cm:get_most_recently_created_character_of_type(mundvard_faction_key, "dignitary", "hkrul_alicia")
                local name1 = common:get_localised_string("names_name_405123616")
                local name2 = common:get_localised_string("names_name_405123615")
                if alicia then
                    cm:change_character_custom_name(alicia, name1, name2, "", "")
                    cm:replenish_action_points(cm:char_lookup_str(alicia:cqi()))
                end
                
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
                
                
                --ceate initial slots in the Marienburg region
                cm:add_foreign_slot_set_to_region_for_faction(mundvard_faction:command_queue_index(), cm:get_region("wh3_main_combi_region_marienburg"):cqi(), "rhox_mar_slot_set_mundvard");
                cm:add_foreign_slot_set_to_region_for_faction(mundvard_faction:command_queue_index(), cm:get_region("wh3_main_combi_region_gorssel"):cqi(), "rhox_mar_slot_set_mundvard");
                local fsm_mundvard = mundvard_faction:foreign_slot_managers();
                
                if fsm_mundvard:num_items() > 0 then
                    local first_fsm_slots = fsm_mundvard:item_at(0):slots();
                    
                    if first_fsm_slots:num_items() > 0 then
                        cm:foreign_slot_instantly_upgrade_building(first_fsm_slots:item_at(0), "rhox_mar_foreign_income_1");
                    end;
                end;
                if fsm_mundvard:num_items() > 1 then
                    local second_fsm_slots = fsm_mundvard:item_at(1):slots();
                    
                    if second_fsm_slots:num_items() > 0 then
                        cm:foreign_slot_instantly_upgrade_building(second_fsm_slots:item_at(0), "rhox_mar_foreign_trade_1");
                    end;
                end;
                
                local target_slot = grung_zint_region:slot_list():item_at(2) --there is a vanilla in the garrison
                cm:instantly_dismantle_building_in_region(target_slot)
                cm:instantly_upgrade_building_in_region(target_slot, "hkrul_mar_mundvard_lair")
                
                
            end
        end, 0.2 --delay to make sure this runs after wh2_campaign_custom_starts.lua
    )
end




cm:add_first_tick_callback(
    function()
        pcall(function()
            mixer_set_faction_trait("ovn_mar_the_wasteland", "rhox_mundvard_effect_bundle", true)
        end)
        if cm:get_local_faction_name(true) == mundvard_faction_key then --ui thing and should be local
            rhox_mar_mundvard_set_coven_listeners()
        end
        
        if cm:get_faction(mundvard_faction_key):is_human() and cm:model():turn_number()<8 then
            core:add_listener(
                "rhox_mar_mundvard_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():name() == mundvard_faction_key and cm:model():turn_number() ==8
                end,
                function(context)
                    if not cm:get_faction("wh_main_emp_marienburg"):is_dead() and not context:faction():at_war_with(cm:get_faction("wh_main_emp_marienburg")) then --you don't need this if you're already at war or Marienburg has died
                        cm:trigger_dilemma(mundvard_faction_key, "rhox_mar_mundvard_ultimatum_dilemma")
                    end
                end,
                false --no need to do twice
            )
            core:add_listener(
                "rhox_mundvard_DilemmaChoiceMadeEvent",
                "DilemmaChoiceMadeEvent",
                function(context)
                    return context:dilemma() == "rhox_mar_mundvard_ultimatum_dilemma"
                end,
                function(context)
                    local choice = context:choice();
                    
                    
                    if choice == 0 then --war
                        cm:force_declare_war("wh_main_emp_marienburg", mundvard_faction_key, true, true)
                    else --pay the price
                        cm:force_grant_military_access("wh_main_emp_marienburg", mundvard_faction_key, false)
                        cm:force_grant_military_access(mundvard_faction_key, "wh_main_emp_marienburg", false)
                    end
                end,
                false --no need to do twice
            );
        end
    end
);

cm:add_first_tick_callback_new(function() 
        hkrul_mundvard() --initial lord replace and setting
        
        if cm:get_faction(mundvard_faction_key):is_human() then       
            local faction_name = mundvard_faction_key
            local title = "event_feed_strings_text_wh2_scripted_event_how_they_play_title";
            local primary_detail = "factions_screen_name_" .. faction_name;
            local secondary_detail = "";
            local pic = nil;
            secondary_detail = "event_feed_strings_text_rhox_mar_event_feed_string_scripted_event_intro_mundvard_secondary_detail";
            pic = 594;
            cm:show_message_event(
                faction_name,
                title,
                primary_detail,
                secondary_detail,
                true,
                pic
            );
            
            --initial mission thing
            local mm = mission_manager:new(mundvard_faction_key, "rhox_mar_war_on_empire")
            mm:add_new_objective("DECLARE_WAR");
            mm:add_condition("faction wh_main_emp_empire")
            mm:add_payload("money 5000");
            mm:trigger() 
            
            cm:trigger_mission(mundvard_faction_key, "rhox_mar_cousin_alliance", true)
            --local mm2 = mission_manager:new(mundvard_faction_key, "rhox_mar_cousin_alliance")
            --mm2:add_new_objective("MAKE_ALLIANCE");
            --mm2:add_condition("faction wh_main_vmp_schwartzhafen")
            --mm2:add_payload("money 5000");
            --mm2:add_payload("SPAWN_AGENT{agent champion;ap_factor 1;}");
            --mm2:add_payload("SPAWN_AGENT champion");
            --mm2:trigger() 
        end
    end
)




--do extra things when they establish a coven
core:add_listener(
    "rhox_max_CharacterGarrisonTargetAction",
    "CharacterGarrisonTargetAction",
    function(context)
        return (context:agent_action_key() == "rhox_mar_agent_action_dignitary_hinder_settlement_establish_pirate_cove" or context:agent_action_key() == "rhox_mar_agent_action_dignitary_hinder_settlement_establish_pirate_cove_unique") and (context:mission_result_critial_success() or context:mission_result_success())
    end,
    function(context)
        local faction = context:character():faction()
        local faction_name = faction:name()
        local character = context:character()
        
        
        --if character:has_skill("wh3_main_skill_cth_caravan_master_scouts") then --temp change it to another skill
        
        if character:character_subtype_key() == "hkrul_alicia" then --alicia is much better than other vampires
            cm:apply_effect_bundle_to_character("rhox_mar_bundle_agent_action_dignitary_hinder_settlement_success_actor", character, 5) 
            cm:apply_effect_bundle("rhox_mar_bundle_pirate_cove_created", faction_name, 5)
        else
            cm:apply_effect_bundle("rhox_mar_bundle_pirate_cove_created", faction_name, 15) --you won't get another agent while this effect bundle is on
        end
        
        
        
        --
    end,
    true
)


        

----------------------------things for cove visibility 



local function coven_visibility()
    --- get UI components
    local settlement_list = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list")
    if not settlement_list then
        return
    end
    local childCount = settlement_list:ChildCount()
    
    --- Turn on visibility in every settlement
    for i=1, childCount - 1  do
        local child = UIComponent(settlement_list:Find(i))
        if not child then
            return
        end
        local vampire_coven = find_uicomponent(child, "settlement_view", "hostile_views", "wh3_daemon_factions")
        vampire_coven:SetVisible(true)
    end
end

local function rhox_diktat_button_visibility()
    local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel") --there is "frame_slaves" slaves in the income
    if parent_ui then
        local diktat_panel = find_child_uicomponent(parent_ui, "frame_slaves")
        if diktat_panel then
            diktat_panel:SetVisible(true)
        end
    end
end



function rhox_mar_mundvard_set_coven_listeners()
        
    --- Trigger check for visibility when settlement is selected
    core:add_listener(
        "rhox_mundvard_less_vampire_coven_trigger",
        "SettlementSelected",
        true,
        function(context)
            core:get_tm():real_callback(function()
                coven_visibility()
                rhox_diktat_button_visibility()
            end, 1)
                
            
        end,
        true
    )
    
    core:add_listener(
        "rhox_mar_mundvard_performed_slave_diktats",
        "ComponentLClickUp",
        function(context)
            return string.find(context.string, "wh3_main_ritual_def_slave_")
        end,
        function()
            core:get_tm():real_callback(function()
                coven_visibility()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )


    --- Trigger whenever vampire coven slot is pressed
    core:add_listener(
        "rhox_mundvard_coven_click_trigger_1",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_expand_slot"
        end,
        function()
            core:get_tm():real_callback(function()
                coven_visibility()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )


    --- Trigger whenever vampire coven slot is pressed
    core:add_listener(
        "rhox_mundvard_coven_click_trigger_2",
        "ComponentLClickUp",
        function (context)
            return context.string == "square_building_button"
        end,
        function()
            core:get_tm():real_callback(function()
                coven_visibility()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )
    
    core:add_listener(
        "rhox_mundvard_coven_click_trigger_3",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_raze"
        end,
        function()
            core:get_tm():real_callback(function()
                coven_visibility()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )
end

    
    