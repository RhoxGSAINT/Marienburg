local function add_hkrul_mar_ror()

    local ror_table={
        "hkrul_pion",
        "hkrul_klumpf",
        "hkrul_carriers_ror",
        "hkrul_mar_mananns_blades_ror", 
        "hkrul_mar_riverwarden_ror",
        "hkrul_mar_art_paixhan_ror",
        "hkrul_mar_bordermen_ror",
        "hkrul_mar_teuling", 
        "hkrul_mar_naval_paixhan", 
        "hkrul_mar_talons",
    }
    
    local vmp_ror_table ={  --for Mudvard
        "wh_dlc04_vmp_cav_chillgheists_0",
        "wh_dlc04_vmp_cav_vereks_reavers_0",
        "wh_dlc04_vmp_inf_feasters_in_the_dusk_0",
        "wh_dlc04_vmp_inf_konigstein_stalkers_0",
        "wh_dlc04_vmp_inf_sternsmen_0",
        "wh_dlc04_vmp_inf_tithe_0",
        "wh_dlc04_vmp_mon_devils_swartzhafen_0",
        "wh_dlc04_vmp_veh_claw_of_nagash_0",
        "wh_dlc04_vmp_mon_direpack_0"
    }
    
    local iee_ror_table ={  --for iee only
        "ovn_mar_inf_knights_mariner_0",
        "hkrul_fooger_ror"
    }

    -- List of default values to shove into the function before; shouldn't need to be changed, usecase may vary.
    local defaults = {
        replen_chance = 100,
        max = 1,
        max_per_turn = 0.1,
        xp_level = 0,
        faction_restriction = "", 
        subculture_restriction = "",
        tech_restriction = "",
        partial_replenishment = true,
    }
    
        local faction = cm:get_faction("wh_main_emp_marienburg")
        local faction2 = cm:get_faction("ovn_mar_house_den_euwe") --egmond
        local dauphine_faction = cm:get_faction("ovn_mar_cult_of_manann") --Dauphine
        local fooger_faction = cm:get_faction("ovn_mar_house_fooger") --Fooger
    for i, ror in pairs(ror_table) do
        local unit_key = ror
        
        local count = 1

        if faction then
            cm:add_unit_to_faction_mercenary_pool(
                faction,
                unit_key,
                "renown",
                count,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                unit_key
            )
        end
        if faction2 then
            cm:add_unit_to_faction_mercenary_pool(
                faction2,
                unit_key,
                "renown",
                count,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                unit_key
            )
        end
        if cm:model():campaign_name_key() == "cr_combi_expanded" then
            cm:add_unit_to_faction_mercenary_pool(
                dauphine_faction,
                unit_key,
                "renown",
                count,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                unit_key
            )
        
        
            cm:add_unit_to_faction_mercenary_pool(
                fooger_faction,
                unit_key,
                "renown",
                count,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                unit_key
            )
        end
        
    end
    if cm:model():campaign_name_key() == "cr_combi_expanded" then
        for i, ror in pairs(iee_ror_table) do
            cm:add_unit_to_faction_mercenary_pool(
                faction,
                ror,
                "renown",
                1,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                ror
            )
            cm:add_unit_to_faction_mercenary_pool(
                faction2,
                ror,
                "renown",
                1,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                ror
            )
            cm:add_unit_to_faction_mercenary_pool(
                dauphine_faction,
                ror,
                "renown",
                1,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                ror
            )
            cm:add_unit_to_faction_mercenary_pool(
                fooger_faction,
                ror,
                "renown",
                1,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                ror
            )
        end


        cm:add_event_restricted_unit_record_for_faction("hkrul_fooger_ror", "wh_main_emp_marienburg", "rhox_mar_fooger_lock")
        cm:add_event_restricted_unit_record_for_faction("hkrul_fooger_ror", "ovn_mar_house_den_euwe", "rhox_mar_fooger_lock")
        cm:add_event_restricted_unit_record_for_faction("hkrul_fooger_ror", "ovn_mar_cult_of_manann", "rhox_mar_fooger_lock")
        
        cm:add_event_restricted_unit_record_for_faction("ovn_mar_inf_knights_mariner_0", "wh_main_emp_marienburg", "rhox_mar_manann_lock")
        cm:add_event_restricted_unit_record_for_faction("ovn_mar_inf_knights_mariner_0", "ovn_mar_house_den_euwe", "rhox_mar_manann_lock")
        cm:add_event_restricted_unit_record_for_faction("ovn_mar_inf_knights_mariner_0", "ovn_mar_house_fooger", "rhox_mar_manann_lock")
    
        cm:add_event_restricted_unit_record_for_faction("hkrul_mar_talons", "ovn_mar_cult_of_manann", "rhox_mar_talons_lock")
        cm:add_event_restricted_unit_record_for_faction("hkrul_mar_talons", "ovn_mar_house_fooger", "rhox_mar_talons_lock")
        
        cm:add_event_restricted_unit_record_for_faction("hkrul_carriers_ror", "ovn_mar_cult_of_manann", "rhox_mar_carrier_lock")
        cm:add_event_restricted_unit_record_for_faction("hkrul_carriers_ror", "ovn_mar_house_fooger", "rhox_mar_carrier_lock")
    end
    
    if cm:get_campaign_name() == "main_warhammer" then--only in Ie and IEE don't lock it otherwise
        cm:add_event_restricted_unit_record_for_faction("hkrul_mar_talons", "wh_main_emp_marienburg", "rhox_mar_talons_lock")
        cm:add_event_restricted_unit_record_for_faction("hkrul_mar_talons", "ovn_mar_house_den_euwe", "rhox_mar_talons_lock")
        
        cm:add_event_restricted_unit_record_for_faction("hkrul_carriers_ror", "ovn_mar_house_den_euwe", "rhox_mar_carrier_lock")
    end
    
    
    ----------------------for mundvard
    local faction3 = cm:get_faction("ovn_mar_the_wasteland") --mundvard
    for i, ror in pairs(vmp_ror_table) do
        if faction3 then
            cm:add_unit_to_faction_mercenary_pool(
                faction3,
                ror,
                "renown",
                1,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                ror
            )
        end
    end
    if faction3 then
        cm:add_unit_to_faction_mercenary_pool(
                faction3,
                "wh2_dlc11_vmp_inf_crossbowmen",
                "renown",
                0,
                defaults.replen_chance,
                6,
                0,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                "wh2_dlc11_vmp_inf_crossbowmen"
            )
        cm:add_unit_to_faction_mercenary_pool(
                faction3,
                "wh2_dlc11_vmp_inf_handgunners",
                "renown",
                0,
                defaults.replen_chance,
                1,
                0,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                "wh2_dlc11_vmp_inf_handgunners"
            )
    end
end

cm:add_first_tick_callback_new(function()
    add_hkrul_mar_ror()
end);



--------------------------------------------------------------Empire-Marienburg RoR crossover thing

local unlocked_marienburg_troops = false;
local unlocked_empire_troops = false;


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
        {"hkrul_pion", "renown", 1, 100, 1, "hkrul_pion"},
		{"hkrul_klumpf", "renown", 1, 100, 1, "hkrul_klumpf"},
        {"hkrul_carriers_ror", "renown", 1, 100, 1, "hkrul_carriers_ror"},
        {"hkrul_mar_mananns_blades_ror", "renown", 1, 100, 1, "hkrul_mar_mananns_blades_ror"},
        {"hkrul_mar_riverwarden_ror", "renown", 1, 100, 1, "hkrul_mar_riverwarden_ror"},
        {"hkrul_mar_art_paixhan_ror", "renown", 1, 100, 1, "hkrul_mar_art_paixhan_ror"},
        {"hkrul_mar_bordermen_ror", "renown", 1, 100, 1, "hkrul_mar_bordermen_ror"},
        {"hkrul_mar_teuling", "renown", 1, 100, 1, "hkrul_mar_teuling"},
        {"hkrul_mar_talons", "renown", 1, 100, 1, "hkrul_mar_talons"},
        {"hkrul_mar_naval_paixhan", "renown", 1, 100, 1, "hkrul_mar_naval_paixhan"},
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
        if cm:get_faction("wh_main_emp_marienburg"):is_human() then
            --cm:disable_event_feed_events(true, "", "", "mercenary_unit_character_level_restriction_lifted") --this will suppress all RoR events feed from firing
            rhox_add_units(cm:get_faction("wh_main_emp_marienburg"), rhox_remove_empire_rors); --This will remove the Empire RoR units from Marienburg, they'll gain access to them later
            
            rhox_add_units(cm:get_faction("wh_main_chs_chaos_separatists"), rhox_remove_chaos_rors); --Hopefully, this will remove the RORs from Chaos seperatist
        end
    end
);



local marienburg_factions={
    wh_main_emp_marienburg = true,
    ovn_mar_house_den_euwe = true,
    ovn_mar_cult_of_manann = true,
    ovn_mar_house_fooger = true,
    ovn_emp_grudgebringers = true--not because they are Marienburg, but because they can't build buildings and can't finish the quest. It's only used for RoR so it's okay
}


local function rhox_mar_check_empire(faction)
    if cm:get_campaign_name() ~= "main_warhammer" then --don't do it if it's not IE and IEE
        return
    end

	local region = cm:get_region("wh3_main_combi_region_marienburg")
	local owner = region:owning_faction()

	if owner:culture() == "wh_main_emp_empire" and region:building_exists("wh_main_special_marienburg_port_3") and not marienburg_factions[owner:name()] then
       core:remove_listener("rhox_emp_building_check_RoundStart") --don't have to listen for it anymore
       cm:trigger_incident(faction:name(), "rhox_mar_gained_access_mar_ror", true)
       rhox_add_mar_units(faction, rhox_add_mar_rors);
       unlocked_marienburg_troops = true;
       
       local general_x_pos, general_y_pos = cm:find_valid_spawn_location_for_character_from_settlement(owner:name(),region:name(), false, true, 5)
        cm:create_force_with_general(
            owner:name(),
            "",
            region:name(),
            general_x_pos,
            general_y_pos,
            "general",
            "hkrul_lector_manann",
            "",
            "",
            "",
            "",
            false,
            function(cqi)
            end
        )
       --cm:spawn_agent_at_settlement(owner, region:settlement(), "general", "hkrul_lector_manann")
       

	end
end


local function rhox_mar_check_mar(faction)
    if cm:get_campaign_name() ~= "main_warhammer" then --don't do it if it's not IE and IEE
        return
    end
	local region = cm:get_region("wh3_main_combi_region_altdorf")
	local owner = region:owning_faction()
    out("Rhox: I'm marienburg listener")
	if owner:name() == "wh_main_emp_marienburg" and region:building_exists("wh_main_special_settlement_altdorf_4_emp") then
        core:remove_listener("rhox_mar_building_check_RoundStart") --don't have to listen for it anymore
        cm:trigger_incident(faction:name(), "rhox_mar_gained_access_emp_ror", true)
        rhox_add_units(faction, rhox_add_empire_rors);
        unlocked_empire_troops = true;
	end
end



local function rhox_mar_check_talon(faction)
    if cm:get_campaign_name() ~= "main_warhammer" then --don't do it if it's not IE and IEE
        return
    end
	local region = cm:get_region("wh3_main_combi_region_marienburg")
	local owner = region:owning_faction()

	if owner and marienburg_factions[owner:name()] and region:building_exists("rhox_mar_rijker") then
        cm:remove_event_restricted_unit_record_for_faction("hkrul_mar_talons", faction:name());
        --cm:set_saved_value("rhox_talons_granted", true)
	end
end




cm:add_first_tick_callback(
    function()
        local non_marienburg_human_empire_exist = false
        local human_empire_factions = cm:get_human_factions_of_culture("wh_main_emp_empire")
        for _, faction_key in ipairs(human_empire_factions) do
            if not marienburg_factions[faction_key] then
                non_marienburg_human_empire_exist =true
            end
        end

        if non_marienburg_human_empire_exist and unlocked_marienburg_troops == false then
            core:add_listener(
                "rhox_emp_building_check_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():culture() == "wh_main_emp_empire" and context:faction():is_human() and unlocked_marienburg_troops == false and not marienburg_factions[context:faction():name()]
                end,
                function(context)
                    rhox_mar_check_empire(context:faction())
                end,
                true
            )
            core:add_listener(
                "rhox_emp_mission_check_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():culture() == "wh_main_emp_empire" and context:faction():is_human() and cm:model():turn_number() == 2 and not marienburg_factions[context:faction():name()] --only at the second turn.
                end,
                function(context)
                    cm:trigger_mission(context:faction():name(), "rhox_mar_conquer_marien")
                end,
                true
            )
        end
        if cm:get_faction("wh_main_emp_marienburg"):is_human() and unlocked_empire_troops == false then
            core:add_listener(
                "rhox_mar_building_check_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():name() == "wh_main_emp_marienburg" and unlocked_empire_troops == false
                end,
                function(context)
                    rhox_mar_check_mar(context:faction())
                end,
                true
            )
        end
        
        
        core:add_listener(
            "rhox_mar_building_check_talon_RoundStart",
            "FactionRoundStart",
            function(context)
                return marienburg_factions[context:faction():name()] and cm:get_saved_value("rhox_talons_granted") ~=true
            end,
            function(context)
                rhox_mar_check_talon(context:faction())
            end,
            true
        )
    end
);





core:add_listener(
        "RijkerisleBuildingCompleted",
        "BuildingCompleted",
        function(context)
            local building = context:building()
            local building_faction = building:faction()
            return building:name() == "rhox_mar_rijker" and (building_faction:name() == "wh_main_emp_marienburg" or building_faction:name() == "ovn_mar_house_den_euwe") and cm:get_saved_value("rhox_talons_granted") ~=true
        end,
        function(context)
            local building = context:building()
            local building_faction = building:faction()
            cm:remove_event_restricted_unit_record_for_faction("hkrul_mar_talons", building_faction:name());
            cm:set_saved_value("rhox_talons_granted", true) 
        end,
        false
)

--marienburg_factions
---------------------------------------------------------RoR unlock
local mar_faction_ror_unlocks={
    wh_main_emp_marienburg ="hkrul_carriers_ror",
    ovn_mar_cult_of_manann ="ovn_mar_inf_knights_mariner_0",
    ovn_mar_house_fooger ="hkrul_fooger_ror"
} 

core:add_listener(
    "Marienburg_faction_makes_alliance",
    "PositiveDiplomaticEvent",
    function(context)
        return (marienburg_factions[context:recipient():name()] or marienburg_factions[context:proposer():name()]) and (context:is_military_alliance() or context:is_defensive_alliance())
    end,
    function(context)
        local ror1 = mar_faction_ror_unlocks[context:recipient():name()]
        local ror2 = mar_faction_ror_unlocks[context:proposer():name()]
        
        if ror1 then
            cm:remove_event_restricted_unit_record_for_faction(ror1, context:proposer():name())
        end
        if ror2 then
            cm:remove_event_restricted_unit_record_for_faction(ror2, context:recipient():name())
        end
    end,
    true
)

core:add_listener(
    "Marienburg_faction_confederation",
    "FactionJoinsConfederation",
    function(context)
        return marienburg_factions[context:confederation():name()] and marienburg_factions[context:faction():name()] 
    end,
    function(context)
        local ror = mar_faction_ror_unlocks[context:faction():name()]
        
        if ror then
            cm:remove_event_restricted_unit_record_for_faction(ror, context:confederation():name())
        end
    end,
    true
)

--[[
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
--]]--condition has been changed


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mar_unlocked_marienburg_troops", unlocked_marienburg_troops, context)
        cm:save_named_value("rhox_mar_unlocked_empire_troops", unlocked_empire_troops, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			unlocked_marienburg_troops = cm:load_named_value("rhox_mar_unlocked_marienburg_troops", unlocked_marienburg_troops, context)
            unlocked_empire_troops = cm:load_named_value("rhox_mar_unlocked_empire_troops", unlocked_empire_troops, context)
		end
	end
)