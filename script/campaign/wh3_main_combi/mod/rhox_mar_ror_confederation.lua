local unlocked_marienburg_troops = false;
local unlocked_empire_troops = false;
local confederation_cooldown = 20 
local confederation_ended = false


local rhox_remove_empire_rors = {
	---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
        {"wh_dlc04_emp_art_hammer_of_the_witches_0", "renown", 0, 0, 0},
		{"wh_dlc04_emp_art_sunmaker_0", "renown", 0, 0, 0},
        {"wh_dlc04_emp_cav_royal_altdorf_gryphites_0", "renown", 0, 0, 0},
        {"wh_dlc04_emp_cav_zintlers_reiksguard_0", "renown", 0, 0, 0},
        {"wh_dlc04_emp_inf_sigmars_sons_0", "renown", 0, 0, 0},
        {"wh_dlc04_emp_inf_silver_bullets_0", "renown", 0, 0, 0},
        {"wh_dlc04_emp_inf_stirlands_revenge_0", "renown", 0, 0, 0},
        {"wh_dlc04_emp_inf_tattersouls_0", "renown", 0, 0, 0},
        {"wh_dlc04_emp_veh_templehof_luminark_0", "renown", 0, 0, 0},
        {"wh2_dlc13_emp_inf_huntsmen_ror_0", "renown", 0, 0, 0},
        {"wh2_dlc13_emp_veh_war_wagon_ror_0", "renown", 0, 0, 0}
}


local rhox_remove_chaos_rors = {
	---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
        {"wh3_dlc20_chs_cav_chaos_chariot_msla_ror", "renown", 0, 0, 0},
		{"wh3_dlc20_chs_inf_aspiring_champions_mtze_ror", "renown", 0, 0, 0},
        {"wh3_dlc20_chs_mon_giant_mnur_ror", "renown", 0, 0, 0},
        {"wh3_dlc20_kho_cav_skullcrushers_mkho_ror", "renown", 0, 0, 0},
        {"wh3_twa07_tze_cav_doom_knights_ror_0", "renown", 0, 0, 0},
        {"wh3_twa08_kho_mon_bloodthirster_0_ror", "renown", 0, 0, 0},
        {"wh3_twa08_nur_mon_great_unclean_one_0_ror", "renown", 0, 0, 0},
        {"wh3_twa08_sla_mon_keeper_of_secrets_0_ror", "renown", 0, 0, 0},
        {"wh3_twa08_tze_mon_lord_of_change_0_ror", "renown", 0, 0, 0},
        {"wh_pro04_chs_art_hellcannon_ror_0", "renown", 0, 0, 0},
        {"wh_pro04_chs_cav_chaos_knights_ror_0", "renown", 0, 0, 0},
        {"wh_pro04_chs_inf_chaos_warriors_ror_0", "renown", 0, 0, 0},
        {"wh_pro04_chs_inf_forsaken_ror_0", "renown", 0, 0, 0},
        {"wh_pro04_chs_mon_chaos_spawn_ror_0", "renown", 0, 0, 0},
        {"wh_pro04_chs_mon_dragon_ogre_ror_0", "renown", 0, 0, 0}
}

local rhox_add_empire_rors = {
	---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
        {"wh_dlc04_emp_art_hammer_of_the_witches_0", "renown", 1, 100, 1},
		{"wh_dlc04_emp_art_sunmaker_0", "renown", 1, 100, 1},
        {"wh_dlc04_emp_cav_royal_altdorf_gryphites_0", "renown", 1, 100, 1},
        {"wh_dlc04_emp_cav_zintlers_reiksguard_0", "renown", 1, 100, 1},
        {"wh_dlc04_emp_inf_sigmars_sons_0", "renown", 1, 100, 1},
        {"wh_dlc04_emp_inf_silver_bullets_0", "renown", 1, 100, 1},
        {"wh_dlc04_emp_inf_stirlands_revenge_0", "renown", 1, 100, 1},
        {"wh_dlc04_emp_inf_tattersouls_0", "renown", 1, 100, 1},
        {"wh_dlc04_emp_veh_templehof_luminark_0", "renown", 1, 100, 1},
        {"wh2_dlc13_emp_inf_huntsmen_ror_0", "renown", 1, 100, 1},
        {"wh2_dlc13_emp_veh_war_wagon_ror_0", "renown", 1, 100, 1}
}

local rhox_add_mar_rors = {
	---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
        {"hkrul_pion", "renown", 1, 100, 1, "hkrul_mar_pion"},
		{"hkrul_klumpf", "renown", 1, 100, 1, "hkrul_mar_bucs"},
        {"hkrul_carriers_ror", "renown", 1, 100, 1, "hkrul_carriers_ror"},
        {"hkrul_mar_mananns_blades_ror", "renown", 1, 100, 1, "hkrul_mar_mananns_blades_ror"},
        {"hkrul_mar_riverwarden_ror", "renown", 1, 100, 1, "hkrul_mar_riverwarden_ror"},
        {"hkrul_mar_art_paixhan_ror", "renown", 1, 100, 1, "hkrul_mar_art_paixhan_ror"},
        {"hkrul_mar_bordermen_ror", "renown", 1, 100, 1, "hkrul_mar_bordermen_ror"},
        {"hkrul_mar_teuling", "renown", 1, 100, 1, "hkrul_mar_teuling"},
        {"hkrul_mar_talons", "renown", 1, 100, 1, "hkrul_mar_talons"},
        {"hkrul_mar_naval_paixhan", "renown", 1, 100, 1, "hkrul_mar_naval_paixhan"},
        {"hkrul_fooger_ror", "renown", 1, 100, 1, "hkrul_fooger_ror"},
        {"snek_hkrul_mar_ror_landship", "renown", 1, 100, 1, "hkrul_landship_ror"}
}

local function rhox_add_units (faction_obj, unit_group)
	for i, v in pairs(unit_group) do
		cm:add_unit_to_faction_mercenary_pool(
			faction_obj,
			v[1], -- key
			v[2], -- recruitment source
			v[3], -- count
			v[4], --replen chance
			v[5], -- max units
			0.1, -- max per turn
			"",	--faction restriction
			"",	--subculture restriction
			"",	--tech restriction
			true, --partial
			v[1]
		);
	end	
end

local function rhox_add_mar_units (faction_obj, unit_group) --because they have different mercenary group name
	for i, v in pairs(unit_group) do
		cm:add_unit_to_faction_mercenary_pool(
			faction_obj,
			v[1], -- key
			v[2], -- recruitment source
			v[3], -- count
			v[4], --replen chance
			v[5], -- max units
			0.1, -- max per turn
			"",	--faction restriction
			"",	--subculture restriction
			"",	--tech restriction
			true, --partial
			v[6]
		);
	end	
end


cm:add_first_tick_callback_new(
    function()       
        if cm:get_local_faction_name(true) == "wh_main_emp_marienburg" then
            --cm:disable_event_feed_events(true, "", "", "mercenary_unit_character_level_restriction_lifted") --this will suppress all RoR events feed from firing
            rhox_add_units(cm:get_local_faction(true), rhox_remove_empire_rors); --This will remove the units from Marienburg, they'll gain access to them later
            cm:add_event_restricted_unit_record_for_faction("snek_hkrul_mar_ror_landship", "wh_main_emp_marienburg", "hkrul_mar_lock_landship_ror")
            cm:add_event_restricted_unit_record_for_faction("hkrul_fooger_ror", "wh_main_emp_marienburg", "rhox_mar_phy_exc_lock") --lock them only for players
            
            rhox_add_units(cm:get_faction("wh_main_chs_chaos_separatists"), rhox_remove_chaos_rors); --Hopefully, this will remove the RORs from Chaos seperatist
        end
    end
);


local function rhox_mar_check_empire()
	local region = cm:get_region("wh3_main_combi_region_marienburg")
	local owner = region:owning_faction()

	if owner:name() == "wh_main_emp_empire" and region:building_exists("wh_main_special_marienburg_port_3") then
       core:remove_listener("rhox_emp_building_check_RoundStart") --don't have to listen for it anymore
       cm:trigger_incident(cm:get_local_faction_name(true), "rhox_mar_gained_access_mar_ror", true)
       rhox_add_mar_units(cm:get_local_faction(true), rhox_add_mar_rors);
       unlocked_marienburg_troops = true;
	end
end


local function rhox_mar_check_mar()
	local region = cm:get_region("wh3_main_combi_region_altdorf")
	local owner = region:owning_faction()
    out("Rhox: I'm marienburg listener")
	if owner:name() == "wh_main_emp_marienburg" and region:building_exists("wh_main_special_settlement_altdorf_4_emp") then
        core:remove_listener("rhox_mar_building_check_RoundStart") --don't have to listen for it anymore
        cm:trigger_incident(cm:get_local_faction_name(true), "rhox_mar_gained_access_emp_ror", true)
        rhox_add_units(cm:get_local_faction(true), rhox_add_empire_rors);
        unlocked_empire_troops = true;
	end
end



local function rhox_mar_check_talon()
	local region = cm:get_region("wh3_main_combi_region_marienburg")
	local owner = region:owning_faction()

	if (owner:name() == "wh_main_emp_marienburg" or owner:name() == "ovn_mar_house_den_euwe") and region:building_exists("rhox_mar_rijker") then
        cm:remove_event_restricted_unit_record_for_faction("hkrul_mar_talons", cm:get_local_faction_name(true));
        cm:set_saved_value("rhox_talons_granted", true)
	end
end


local function rhox_mar_confederation_dilemma_choice(context)
	local dilemma = context:dilemma();
	local choice = context:choice();
	local faction = context:faction();
	local faction_key = faction:name();
	

	-- CONFEDERATION
    local confederation_faction_key = "ovn_mar_house_den_euwe";
    local confederation_faction = cm:model():world():faction_by_key(confederation_faction_key);
    
    
    if choice == 0 then
        cm:force_confederation(faction_key, confederation_faction_key);
        confederation_ended = true
    elseif choice ==1 then
        confederation_ended = true --they refused and there wern't be any confederation offer
    elseif choice ==2 then
        confederation_cooldown = 10 --just increase the cooldown so they can see the event 10 turns later  --rhox temp change it to 10 after testing
    end
end



cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == "wh_main_emp_empire" and unlocked_marienburg_troops == false then
            core:add_listener(
                "rhox_emp_building_check_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():name() == "wh_main_emp_empire" and unlocked_marienburg_troops == false
                end,
                function(context)
                    rhox_mar_check_empire()
                end,
                true
            )
            core:add_listener(
                "rhox_emp_mission_check_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():name() == "wh_main_emp_empire" and cm:model():turn_number() == 2; --only at the second turn.
                end,
                function(context)
                    cm:trigger_mission("wh_main_emp_empire", "rhox_mar_conquer_marien")
                end,
                true
            )
        end
        if cm:get_local_faction_name(true) == "wh_main_emp_marienburg" and unlocked_empire_troops == false then
            core:add_listener(
                "rhox_mar_building_check_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():name() == "wh_main_emp_marienburg" and unlocked_empire_troops == false
                end,
                function(context)
                    rhox_mar_check_mar()
                end,
                true
            )
        end
        
        
        if (cm:get_local_faction_name(true) == "wh_main_emp_marienburg" or cm:get_local_faction_name(true) == "ovn_mar_house_den_euwe") then --and cm:get_saved_value("rhox_talons_granted") ~=true --for the guys who missed it. Have to add it at the next patch.
            core:add_listener(
                "rhox_mar_building_check_talon_RoundStart",
                "FactionRoundStart",
                function(context)
                    return (context:faction():name() == "wh_main_emp_marienburg" or context:faction():name() == "ovn_mar_house_den_euwe") --and cm:get_saved_value("rhox_talons_granted") ~=true
                end,
                function(context)
                    rhox_mar_check_talon()
                end,
                true
            )
        end


        if cm:get_local_faction_name(true) == "wh_main_emp_marienburg" and confederation_ended == false then
            core:add_listener(
                "rhox_mar_confederation_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():name() == "wh_main_emp_marienburg"
                end,
                function(context)
                    local confederation_faction_key = "ovn_mar_house_den_euwe";
                    local confederation_faction = cm:model():world():faction_by_key(confederation_faction_key);
                    
                    
                    --[[
                    if cm:model():turn_number() == 1 then --nothing to do with confederation, but let's do it here
                        cm:join_garrison("character_cqi:"..cm:get_faction("wh_main_emp_marienburg"):faction_leader():cqi(), "settlement:wh3_main_combi_region_marienburg");
                    end
                    --]]
                    
                    if cm:model():turn_number() == 15 then --it has nothing to do with conf, but put in here, it won't be affected.
                        cm:trigger_incident("wh_main_emp_marienburg", "rhox_mar_free_witch_hunter", true)
                        hkrul_mar_setup_solkan_missions("wh_main_emp_marienburg") --free witch hunter and mission to get Solkan
                    end
                    
                    
                    if cm:model():turn_number() == 18 and confederation_faction:is_null_interface() == false and confederation_faction:is_dead() == false then --show them warning so they can prepare money for it
                        cm:trigger_incident("wh_main_emp_marienburg", "rhox_mar_conf_warning", true)
                    end
                    confederation_cooldown = confederation_cooldown-1;
                    
    
                    if confederation_cooldown == 0 then
                        if confederation_faction:is_null_interface() == false and confederation_faction:is_dead() == false then
                             --trigger dilemma
                             cm:trigger_dilemma_with_targets(cm:get_local_faction(true):command_queue_index(), "rhox_mar_confederation_dilemma", confederation_faction:command_queue_index(), 0, 0, 0, 0, 0);
                        else --it means faction is dead just increase the cooldown by 10
                             confederation_cooldown = 10
                        end
                             
                    end
                end,
                true
            )
            core:add_listener(
                "mar_DilemmaChoiceMadeEvent",
                "DilemmaChoiceMadeEvent",
                function(context)
                    return context:dilemma() == "rhox_mar_confederation_dilemma"
                end,
                function(context) rhox_mar_confederation_dilemma_choice(context) end,
                true
            );
        end
    end
);





core:add_listener(
        "RijkerisleBuildingCompleted",
        "BuildingCompleted",
        function(context)
            local building = context:building()
            local building_faction = building:faction()
            return building:name() == "rhox_mar_rijker" and (building_faction:name() == "wh_main_emp_marienburg" or building_faction:name() == "ovn_mar_house_den_euwe") and cm:get_saved_value("rhox_talons_granted") ~=true --have to give to the guys who missed it. 
        end,
        function(context)
            local building = context:building()
            local building_faction = building:faction()
            cm:remove_event_restricted_unit_record_for_faction("hkrul_mar_talons", building_faction:name());
            cm:set_saved_value("rhox_talons_granted", true) 
        end,
        false
)



--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mar_unlocked_marienburg_troops", unlocked_marienburg_troops, context)
        cm:save_named_value("rhox_mar_unlocked_empire_troops", unlocked_empire_troops, context)
        cm:save_named_value("rhox_mar_confederation_cooldown", confederation_cooldown, context)
        cm:save_named_value("rhox_mar_confederation_ended", confederation_ended, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			unlocked_marienburg_troops = cm:load_named_value("rhox_mar_unlocked_marienburg_troops", unlocked_marienburg_troops, context)
            unlocked_empire_troops = cm:load_named_value("rhox_mar_unlocked_empire_troops", unlocked_empire_troops, context)
            confederation_cooldown = cm:load_named_value("rhox_mar_confederation_cooldown", confederation_cooldown, context)
            confederation_ended = cm:load_named_value("rhox_mar_confederation_ended", confederation_ended, context)
		end
	end
)