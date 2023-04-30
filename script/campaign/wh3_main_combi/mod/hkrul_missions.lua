local mar_faction = "wh_main_emp_marienburg"

function hkrul_spawn_solkan(faction_key, agent_subtype)
    local agent_interface = cm:model():world():faction_by_key(faction_key)
    local agent_faction_cqi = agent_interface:command_queue_index()       
    cm:spawn_unique_agent(agent_faction_cqi,agent_subtype,true)
    cm:callback(
        function()
            local loop_char_list = cm:get_faction(faction_key):character_list()
            for i = 0, loop_char_list:num_items() - 1 do
                local looping = loop_char_list:item_at(i)
                if looping:character_subtype_key() == "hkrul_solkan" then
                    out("Rhox mar: Found Solkan")
                    local name1 = common:get_localised_string("names_name_605123635")
                    local name2 = common:get_localised_string("names_name_605123636")
                    cm:change_character_custom_name(looping, name1, name2, "", "")
                    cm:replenish_action_points(cm:char_lookup_str(looping:cqi()))
                    break
                end
            end
        end,
        0.5
    )
    
end

--wh2_dlc11_mission_piece_of_eight_6
local function hkrul_mar_setup_follower_1_mission(faction_key)
  local scmm = mission_manager:new(faction_key, "hkrul_mar_jk_follower_1")
  scmm:add_new_objective("MOVE_TO_REGION");
  scmm:add_condition("region wh3_main_combi_region_sjoktraken");
  scmm:add_payload("effect_bundle{bundle_key rhox_mar_anc_dummy;turns 1;}")
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_nijmenk;}");
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_frost_globe;}");
  scmm:add_payload("money 200");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_nijmenk;}");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_frost_globe;}");
  scmm:trigger()
end

local function hkrul_mar_setup_follower_2_mission(faction_key)
  local scmm = mission_manager:new(faction_key, "hkrul_mar_jk_follower_2")
  scmm:add_new_objective("MOVE_TO_REGION");
  scmm:add_condition("region wh3_main_combi_region_magritta");
  scmm:add_payload("effect_bundle{bundle_key rhox_mar_anc_dummy;turns 1;}")
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_roelef;}");
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_hakim;}");
  scmm:add_payload("money 250");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_roelef;}");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_hakim;}");
  scmm:trigger()
end

local function hkrul_mar_setup_follower_3_mission(faction_key)
  local scmm = mission_manager:new(faction_key, "hkrul_mar_jk_follower_3")
  scmm:add_new_objective("MOVE_TO_REGION");
  scmm:add_condition("region wh3_main_combi_region_karak_hirn");
  scmm:add_payload("effect_bundle{bundle_key rhox_mar_anc_dummy;turns 1;}")
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_fooger;}");
  scmm:add_payload("text_display rhox_mar_dummy_phy_dwarf");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_fooger;}");
  scmm:trigger()
end

local function hkrul_mar_setup_follower_4_mission(faction_key)
  local scmm = mission_manager:new(faction_key, "hkrul_mar_jk_follower_4")
  scmm:add_new_objective("MAKE_TRADE_AGREEMENT");
  scmm:add_condition("faction wh2_main_hef_eataine");
  scmm:add_payload("effect_bundle{bundle_key rhox_mar_anc_dummy;turns 1;}")
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_rothemuur;}");
  scmm:add_payload("money 850");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_rothemuur;}");
  scmm:trigger()
end

function hkrul_mar_setup_solkan_missions(faction_key) --not local because we have to use it in the other place
    local scmm = mission_manager:new(faction_key, "hkrul_mar_hendrik1")
    scmm:add_new_objective("HAVE_N_AGENTS_OF_TYPE");
    scmm:add_condition("total 2");
    scmm:add_condition("agent_subtype wh_main_emp_witch_hunter");
    scmm:add_payload("money 2500");
    scmm:add_payload("text_display dummy_hkrul_solkan_spawns");
    scmm:trigger()   
end

local function hkrul_mar_setup_follower_5_mission(faction_key)
  local scmm = mission_manager:new(faction_key, "hkrul_mar_jk_follower_5")
  scmm:add_new_objective("DECLARE_WAR")
  scmm:add_condition("faction wh_main_nor_skaeling")
  scmm:add_payload("effect_bundle{bundle_key rhox_mar_anc_dummy;turns 1;}")
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_scheldt;}");
  scmm:add_payload("money 750");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_scheldt;}");
  scmm:trigger()
end

local function hkrul_mar_setup_follower_6_mission(faction_key)
  local scmm = mission_manager:new(faction_key, "hkrul_mar_jk_follower_6")
  scmm:add_new_objective("MOVE_TO_REGION");
  scmm:add_condition("region wh3_main_combi_region_port_reaver");
  scmm:add_payload("effect_bundle{bundle_key rhox_mar_anc_dummy;turns 1;}")
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_leo;}");
  scmm:add_payload("money 750");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_leo;}");
  scmm:trigger()
end

local function hkrul_mar_setup_follower_7_mission(faction_key)
  local scmm = mission_manager:new(faction_key, "hkrul_mar_jk_follower_7")
  scmm:add_new_objective("MAKE_TRADE_AGREEMENT");
  scmm:add_condition("faction wh_main_brt_bretonnia");
  scmm:add_payload("effect_bundle{bundle_key rhox_mar_anc_dummy;turns 1;}")
  scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_thijs;}");
  scmm:add_payload("money 750");
  scmm:add_failure_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_thijs;}");
  scmm:trigger()
end



core:add_listener(
	"SolkanRename",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "hkrul_mar_hendrik1"
	end,
	function(context)
        out("Rhox Mar: In the mission success listener")
        hkrul_spawn_solkan("wh_main_emp_marienburg", "hkrul_solkan") --this function uses unique agent, so it won't spawn twice
        cm:set_saved_value("rhox_solkan_summoned", true); --need to check and summon it again each turn as a fail safe
	end,
	true
);





-- starting the scripted missions and show how to play
cm:add_first_tick_callback_new(
  function()
    local jaan_interface = cm:model():world():faction_by_key("wh_main_emp_marienburg")
    
    if jaan_interface:is_human() == true then        
        local faction_name = jaan_interface:name()
        local title = "event_feed_strings_text_wh2_scripted_event_how_they_play_title";
        local primary_detail = "factions_screen_name_" .. faction_name;
        local secondary_detail = "";
        local pic = nil;
        secondary_detail = "event_feed_strings_text_rhox_mar_event_feed_string_scripted_event_intro_mar_secondary_detail";
        pic = 591;
        cm:show_message_event(
            faction_name,
            title,
            primary_detail,
            secondary_detail,
            true,
            pic
        );
    end
    
    if cm:get_saved_value("hkrul_follower1_granted") == nil then
      if jaan_interface:is_human() == true then
        hkrul_mar_setup_follower_1_mission("wh_main_emp_marienburg")
        hkrul_mar_setup_follower_2_mission("wh_main_emp_marienburg")
        hkrul_mar_setup_follower_3_mission("wh_main_emp_marienburg")
        hkrul_mar_setup_follower_4_mission("wh_main_emp_marienburg")
        hkrul_mar_setup_follower_5_mission("wh_main_emp_marienburg")
        --hkrul_mar_setup_solkan_missions("wh_main_emp_marienburg")  --we're going to trigger it at the other time
        hkrul_mar_setup_follower_6_mission("wh_main_emp_marienburg")
        hkrul_mar_setup_follower_7_mission("wh_main_emp_marienburg")
      else -- for the AI
        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_nijmenk", false)
        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_roelef", false)
        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_fooger", false)
        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_rothemuur", false)
        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_scheldt", false)
        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_leo", false)
        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_thijs", false)
        hkrul_spawn_solkan("wh_main_emp_marienburg", "hkrul_solkan")
      end
      cm:set_saved_value("hkrul_follower1_granted", true);
    end
  end
)


--this shows pieces of eight: Great families UI at the first tick
cm:add_first_tick_callback(
	function()
        if cm:get_local_faction_name(true) == "wh_main_emp_marienburg" then
            local pieces_of_eight_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts");
            pieces_of_eight_button:SetVisible(true)
            pieces_of_eight_button:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_panel_open_button"),true)
            local treasure_hunt_count_ui = find_uicomponent(pieces_of_eight_button, "label_hunts_count");
            treasure_hunt_count_ui:SetVisible(false)
            
            
            core:add_listener(
                "rhox_treasure_panel_open_listener",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "treasure_hunts";
                end,
                function()
                    local pieces_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "pieces");
                    pieces_tab:SimulateLClick();
                    --pieces_tab:MoveTo(885, 919)  --doesn't work
                    --local x, y = pieces_tab:Position()
                    --out("Rhox mar: "..x..", "..y)  --1285, 919 is the original location
                    local pieces_text = find_uicomponent(pieces_tab, "tx");
                    pieces_text:SetText(common.get_localised_string("campaign_localised_strings_string_rhox_piece_tab"))
                    
                    
                    
                    
                    local treasure_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "hunts");
                    treasure_tab:SetVisible(false) --we're not using this button and should disable it. 
                    treasure_tab:Destroy() --Will this change the position?
                end,
                true
            )
        end
	end
);





cm:add_first_tick_callback(function() 
  if not cm:get_saved_value("hkrul_follower_set_done") then
    core:add_listener(
      "hkrul_follower_set_CharacterAncillaryGained",
      "CharacterAncillaryGained",
      function(context)
        --out("CharacterAncillaryGained works")
        local character = context:character()
        local ancillary = context:ancillary()
        return character:character_subtype("hkrul_jk")
        and (ancillary == "hkrul_mar_fooger" or ancillary == "hkrul_mar_nijmenk" or ancillary == "hkrul_mar_scheldt" 
        or ancillary == "hkrul_mar_anc_stadsraad" or ancillary == "hkrul_mar_rothemuur" or ancillary == "hkrul_mar_roelef" or ancillary == "wh2_dlc13_anc_talisman_stadsraad_key")
        and character:has_ancillary("hkrul_mar_fooger") and character:has_ancillary("hkrul_mar_nijmenk") and character:has_ancillary("hkrul_mar_scheldt")
        and character:has_ancillary("hkrul_mar_anc_stadsraad") and character:has_ancillary("hkrul_mar_rothemuur") and character:has_ancillary("hkrul_mar_roelef") 
        and character:has_ancillary("wh2_dlc13_anc_talisman_stadsraad_key")
      end,
      function(context)
        out("hkrul_follower_set_CharacterAncillaryGained conditions work")
        cm:set_saved_value("hkrul_follower_set_done", true)
        cm:trigger_incident(context:character():faction():name(),"rhox_mar_item_set_event", true)
      end,
      false
    )
  end
  
  
  if not cm:get_saved_value("hkrul_norsca_giant_set_done") then
    core:add_listener(
      "hkrul_follower_set_Norscagiant",
      "CharacterAncillaryGained",
      function(context)
        --out("CharacterAncillaryGained works")
        local character = context:character()
        local ancillary = context:ancillary()

        return character:character_type("general") and (ancillary == "hkrul_mar_follower_norsca" or ancillary == "hkrul_mar_anc_norscan")
        and character:has_ancillary("hkrul_mar_follower_norsca") and character:has_ancillary("hkrul_mar_anc_norscan") 
      end,
      function(context)
        --out("hkrul_follower_set_CharacterAncillaryGained conditions work")
        cm:set_saved_value("hkrul_norsca_giant_set_done", true)
        local character = context:character()
        local military_force = character:military_force() 
        local character_lookup_str = cm:char_lookup_str(character)
        
        rhox_add_unit_to_military_force(military_force, character_lookup_str, "wh_dlc08_nor_mon_norscan_giant_0")
      end,
      false
    )
  end
  

  if not cm:get_saved_value("hkrul_mar_elf_set_done") then
    core:add_listener(
      "hkrul_follower_set_elfguard",
      "CharacterAncillaryGained",
      function(context)
        --out("CharacterAncillaryGained works")
        local character = context:character()
        local ancillary = context:ancillary()

        return character:character_type("general") and (ancillary == "hkrul_mar_follower_elf" or ancillary == "hkrul_mar_frost_globe")
        and character:has_ancillary("hkrul_mar_follower_elf") and character:has_ancillary("hkrul_mar_frost_globe") 
      end,
      function(context)
        --out("hkrul_follower_set_CharacterAncillaryGained conditions work")
        cm:set_saved_value("hkrul_mar_elf_set_done", true)
        local character = context:character()
        local military_force = character:military_force() 
        local character_lookup_str = cm:char_lookup_str(character)

        rhox_add_unit_to_military_force(military_force, character_lookup_str, "wh2_main_hef_inf_phoenix_guard")
      end,
      false
    )
  end
  

  if not cm:get_saved_value("hkrul_lover_set_done") then
    core:add_listener(
      "hkrul_follower_set_lover",
      "CharacterAncillaryGained",
      function(context)
        --out("CharacterAncillaryGained works")
        local character = context:character()
        local ancillary = context:ancillary()

        return (ancillary == "hkrul_mar_hakim" or ancillary == "hkrul_mar_follower_roelef")
        and character:has_ancillary("hkrul_mar_hakim") and character:has_ancillary("hkrul_mar_follower_roelef") 
      end,
      function(context)
        --out("hkrul_follower_set_CharacterAncillaryGained conditions work")
        cm:set_saved_value("hkrul_lover_set_done", true)        
        cm:treasury_mod(context:character():faction():name(), 1000)
      end,
      false
    )
  end
  

  
  if not cm:get_saved_value("hkrul_cathay_set_done") then
    core:add_listener(
      "hkrul_follower_set_lover",
      "CharacterAncillaryGained",
      function(context)
        --out("CharacterAncillaryGained works")
        local character = context:character()
        local ancillary = context:ancillary()

        return (ancillary == "hkrul_mar_bonsai" or ancillary == "hkrul_mar_follower_cathay")
        and character:has_ancillary("hkrul_mar_bonsai") and character:has_ancillary("hkrul_mar_follower_cathay") 
      end,
      function(context)
        --out("hkrul_follower_set_CharacterAncillaryGained conditions work")
        cm:set_saved_value("hkrul_cathay_set_done", true)        
        local character = context:character()
        local military_force = character:military_force() 
        local character_lookup_str = cm:char_lookup_str(character)
        rhox_add_unit_to_military_force(military_force, character_lookup_str, "wh3_main_cth_veh_sky_junk_0")
      end,
      false
    )
  end
end)




core:add_listener(
	"rhox_mar_conquer_beichai_listener",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "rhox_mar_conquer_beichai"
	end,
	function(context)
        local scmm = mission_manager:new(context:faction():name(), "rhox_mar_embassy")
        scmm:add_new_objective("MOVE_TO_REGION");
        scmm:add_condition("region wh3_main_combi_region_marienburg");
        scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_hong;}");
        scmm:add_payload("money 2500");
        scmm:trigger()
	end,
	false
);


core:add_listener(
	"rhox_mar_magritta_mission_success_listener",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "hkrul_mar_jk_follower_2"
	end,
	function(context)
        local scmm = mission_manager:new(context:faction():name(), "rhox_mar_araby_brethern")
        scmm:add_new_objective("MOVE_TO_REGION");
        scmm:add_condition("region wh3_main_combi_region_great_desert_of_araby");
        scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_anc_araby;}");
        scmm:add_payload("money 750");
        scmm:trigger()
	end,
	false
);

core:add_listener(
	"rhox_mar_karak_hirn_mission_success_listener",
	"MissionSucceeded",
	function(context)
		return context:mission():mission_record_key() == "hkrul_mar_jk_follower_3"
	end,
	function(context)
        cm:remove_event_restricted_unit_record_for_faction("hkrul_fooger_ror", context:faction():name());
	end,
	false
);

core:add_listener(
    "hkrul_pg_lv8_mission",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_pg") and character:rank() >= 8 and faction:ancillary_exists("hkrul_mar_anc_norscan") == false and cm:get_saved_value("hkrul_pg_lv8_mission_active") ~= true
    end,
    function(context)
        local character = context:character()
		local faction_name = character:faction():name()
        local scmm = mission_manager:new(faction_name, "rhox_mar_exiled_chieftain")
        scmm:add_new_objective("MOVE_TO_REGION");
        scmm:add_condition("region wh3_main_combi_region_wreckers_point");
        scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_anc_norscan;}");
        scmm:add_payload("money 500");
        scmm:trigger()
        cm:set_saved_value("hkrul_pg_lv8_mission_active", true)
    end,
    false
)



local mission_to_ancillary ={
    ["hkrul_mar_jk_follower_1"]="hkrul_mar_nijmenk",
    ["hkrul_mar_jk_follower_2"]="hkrul_mar_roelef",--should give 'hkrul_mar_hakim' too
    ["hkrul_mar_jk_follower_3"]="hkrul_mar_fooger",
    ["hkrul_mar_jk_follower_4"]="hkrul_mar_rothemuur",
    ["hkrul_mar_jk_follower_5"]="hkrul_mar_scheldt",
    ["hkrul_mar_jk_follower_6"]="hkrul_mar_leo",
    ["hkrul_mar_jk_follower_7"]="hkrul_mar_thijs"
}


--mission fail safe payload
cm:add_first_tick_callback(
    function() 
        if cm:get_local_faction_name(true) == "wh_main_emp_marienburg" then
            --out("Rhox mar: Inside mar listener")
            core:add_listener(--failure payload wasn't working and I'm adding it here
                "rhox_mar_fail_safe",
                "MissionCancelled",
                function(context)
                    out("Rhox mar: Failed a mission?")
                    return mission_to_ancillary[context:mission():mission_record_key()]
                end,
                function(context)
                    out("Rhox mar: And it was a Marienburg one!")
                    out("Rhox mar: ancillary: "..mission_to_ancillary[context:mission():mission_record_key()])
                    cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), mission_to_ancillary[context:mission():mission_record_key()], false)
                    if context:mission():mission_record_key() == "hkrul_mar_jk_follower_2" then
                        cm:add_ancillary_to_faction(cm:get_faction("wh_main_emp_marienburg"), "hkrul_mar_hakim", false)
                    end
                end,
                true
            );
        end
    end
)


--add units to a force. Remove the least value if there are 20 unit cards in it
function rhox_add_unit_to_military_force(military_force, character_lookup_str, recruit_unit_key)
    if is_militaryforce(military_force) then
        local units = {}
        local unit_list = military_force:unit_list()
        if unit_list:num_items() >= 20 then
            for i = 1, unit_list:num_items() - 1 do --start at 1 to exclude the general
                local unit = unit_list:item_at(i)
                if unit:unit_class() ~= "com" then --let's try to avoid deleting agents
                    local unit_value = unit:get_unit_custom_battle_cost() -- * unit:percentage_proportion_of_full_strength()
                    table.insert(units, {value = unit_value, unit_key = unit:unit_key()})
                end
            end
            table.sort(units, function(a,b) return tonumber(a.value) < tonumber(b.value) end)
            cm:remove_unit_from_character(character_lookup_str, units[1].unit_key)
        end
        cm:grant_unit_to_character(character_lookup_str, recruit_unit_key)
    else
        out("add_unit_to_faction | no military_force found")
    end
end
