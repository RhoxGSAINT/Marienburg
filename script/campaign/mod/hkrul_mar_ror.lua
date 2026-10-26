local function add_hkrul_mar_ror()
    local ror_table = {
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

    local vmp_ror_table = { --for Mudvard
        "wh_dlc04_vmp_cav_chillgheists_0",
        "wh_dlc04_vmp_cav_vereks_reavers_0",
        "wh_dlc04_vmp_inf_feasters_in_the_dusk_0",
        "wh_dlc04_vmp_inf_konigstein_stalkers_0",
        "wh_dlc04_vmp_inf_sternsmen_0",
        "wh_dlc04_vmp_inf_tithe_0",
        "wh_dlc04_vmp_mon_devils_swartzhafen_0",
        "wh_dlc04_vmp_veh_claw_of_nagash_0",
        "wh_dlc04_vmp_mon_direpack_0",
        "wh2_dlc11_cst_mon_mournguls_ror_0"
    }
    local vmp_raise_dead_faction_table = { --for Mudvard
        "wh3_dlc29_vmp_inf_lahmian_handmaidens_death",
        "wh3_dlc29_vmp_inf_spirit_host",
        "wh3_main_vmp_blood_knights_sword_shield",
        "wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow",
        "wh3_dlc29_vmp_veh_coven_throne",
        "wh3_dlc29_vmp_cav_drakenhof_templars",
        "wh3_dlc29_vmp_mon_zombie_dragon",
        "wh_main_vmp_cav_hexwraiths",
        "wh_main_vmp_inf_cairn_wraiths",
        "wh_main_vmp_mon_terrorgheist",
        "wh_main_vmp_mon_vargheists",
        "wh_main_vmp_mon_varghulf",
        "wh_main_vmp_veh_black_coach",
        "wh_dlc02_vmp_cav_blood_knights_0",
        "wh_dlc04_vmp_veh_mortis_engine_0"
    }
    local vmp_raise_dead_province_table = { --for Mudvard
        "wh2_dlc11_cst_mon_mournguls_0",
        "wh_main_vmp_inf_skeleton_warriors_0",
        "wh_main_vmp_inf_skeleton_warriors_1",
        "wh_main_vmp_inf_zombie",
        "wh_main_vmp_cav_black_knights_0",
        "wh_main_vmp_cav_black_knights_3",
        "wh_main_vmp_inf_grave_guard_0",
        "wh_main_vmp_inf_grave_guard_1",
        "wh_main_vmp_mon_crypt_horrors",
        "wh_main_vmp_inf_crypt_ghouls",
        "wh_main_vmp_mon_dire_wolves",
        "wh_main_vmp_mon_fell_bats",
        "wh_dlc04_vmp_veh_corpse_cart_0",
        "wh_dlc04_vmp_veh_corpse_cart_1",
        "wh_dlc04_vmp_veh_corpse_cart_2",
        "wh3_main_vmp_inf_grave_guard_2"
    }
    local vmp_additional_units = { --for Mudvard
        "wh2_dlc11_vmp_inf_crossbowmen",
        "wh2_dlc11_vmp_inf_handgunners"
    }

    local mundvard_additional_units = {
        "hkrul_burgher",
        "hkrul_privateers",
        "hkrul_privateers_dual_swords",
        "hkrul_mar_cav_rijders_crossbow",
        "hkrul_mar_inf_crossbow",
        "hkrul_mar_riverwarden"
    }



    local iee_ror_table = { --for iee only
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

    local raise_dead_defaults = {
        replen_chance = 1,
        max = 999999,
        max_per_turn = 100,
        xp_level = 0,
        faction_restriction = "",
        subculture_restriction = "",
        tech_restriction = "",
        partial_replenishment = false,
    }

    local is_iee = cm:model():campaign_name_key() == "cr_combi_expanded"
    for faction_key, data in pairs(RHOX_MAR_FACTIONS) do
        local mar_faction = cm:get_faction(faction_key)
        if data.empire and mar_faction then
            local faction_ror_table = ror_table
            if is_iee then
                faction_ror_table = {}
                for _, ror in ipairs(ror_table) do
                    table.insert(faction_ror_table, ror)
                end
                for _, ror in ipairs(iee_ror_table) do
                    table.insert(faction_ror_table, ror)
                end
            end
            for _, ror in ipairs(faction_ror_table) do
                cm:add_unit_to_faction_mercenary_pool(
                    mar_faction,
                    ror,
                    "wh3_main_regiments_of_renown_pool",
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
    end

    -- Each house's RoR stays locked for the other Marienburg factions until an alliance or confederation unlocks it
    if cm:get_campaign_name() == "main_warhammer" then --only in Ie and IEE don't lock it otherwise
        local ror_locks = {
            {unit = "hkrul_fooger_ror", lock = "rhox_mar_fooger_lock", owner = "ovn_mar_house_fooger"},
            {unit = "ovn_mar_inf_knights_mariner_0", lock = "rhox_mar_manann_lock", owner = "ovn_mar_cult_of_manann"},
            {unit = "hkrul_mar_talons", lock = "rhox_mar_talons_lock", owner = nil},
            {unit = "hkrul_carriers_ror", lock = "rhox_mar_carrier_lock", owner = "wh_main_emp_marienburg"}
        }
        for faction_key, data in pairs(RHOX_MAR_FACTIONS) do
            if data.empire and cm:get_faction(faction_key) then
                for _, ror_lock in ipairs(ror_locks) do
                    if ror_lock.owner ~= faction_key then
                        cm:add_event_restricted_unit_record_for_faction(ror_lock.unit, faction_key, ror_lock.lock)
                    end
                end
            end
        end
    end


    ----------------------for mundvard
    local faction3 = cm:get_faction("ovn_mar_the_wasteland") --mundvard
    if faction3 then
        for i, ror in pairs(vmp_ror_table) do
            cm:add_unit_to_faction_mercenary_pool(
                faction3,
                ror,
                "wh3_main_regiments_of_renown_pool",
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
        for i, ror in pairs(vmp_additional_units) do
            cm:add_unit_to_faction_mercenary_pool(
                faction3,
                ror,
                "wh3_dlc29_vmp_additional_units",
                raise_dead_defaults.max,
                raise_dead_defaults.replen_chance,
                raise_dead_defaults.max,
                raise_dead_defaults.max_per_turn,
                raise_dead_defaults.faction_restriction,
                raise_dead_defaults.subculture_restriction,
                raise_dead_defaults.tech_restriction,
                raise_dead_defaults.partial_replenishment,
                ror
            )
        end
        for i, ror in pairs(mundvard_additional_units) do
            cm:add_unit_to_faction_mercenary_pool(
                faction3,
                ror,
                "wh3_dlc29_vmp_additional_units",
                raise_dead_defaults.max,
                raise_dead_defaults.replen_chance,
                raise_dead_defaults.max,
                raise_dead_defaults.max_per_turn,
                raise_dead_defaults.faction_restriction,
                raise_dead_defaults.subculture_restriction,
                raise_dead_defaults.tech_restriction,
                raise_dead_defaults.partial_replenishment,
                ror.."_mundvard"
            )
        end
        for i, ror in pairs(vmp_raise_dead_faction_table) do
            cm:add_unit_to_faction_mercenary_pool(
                faction3,
                ror,
                "wh3_dlc29_vmp_raise_dead_faction",
                raise_dead_defaults.max,
                raise_dead_defaults.replen_chance,
                raise_dead_defaults.max,
                raise_dead_defaults.max_per_turn,
                raise_dead_defaults.faction_restriction,
                raise_dead_defaults.subculture_restriction,
                raise_dead_defaults.tech_restriction,
                raise_dead_defaults.partial_replenishment,
                ror
            )
        end
        for i, ror in pairs(vmp_raise_dead_province_table) do
            cm:add_unit_to_faction_mercenary_pool(
                faction3,
                ror,
                "wh3_dlc29_vmp_raise_dead_province",
                raise_dead_defaults.max,
                raise_dead_defaults.replen_chance,
                raise_dead_defaults.max,
                raise_dead_defaults.max_per_turn,
                raise_dead_defaults.faction_restriction,
                raise_dead_defaults.subculture_restriction,
                raise_dead_defaults.tech_restriction,
                raise_dead_defaults.partial_replenishment,
                ror
            )
        end
    end
end

cm:add_first_tick_callback_new(function()
    add_hkrul_mar_ror()
end);



--------------------------------------------------------------Empire-Marienburg RoR crossover thing

local unlocked_marienburg_troops = false;
local unlocked_empire_troops = false;


local rhox_mar_empire_rors = { --will be locked at the start of the game, and will be unlocked later
    ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
    "wh_dlc04_emp_art_hammer_of_the_witches_0",
    "wh_dlc04_emp_art_sunmaker_0",
    "wh_dlc04_emp_cav_royal_altdorf_gryphites_0",
    "wh_dlc04_emp_cav_zintlers_reiksguard_0",
    "wh_dlc04_emp_inf_sigmars_sons_0",
    "wh_dlc04_emp_inf_silver_bullets_0",
    "wh_dlc04_emp_inf_stirlands_revenge_0",
    "wh_dlc04_emp_inf_tattersouls_0",
    "wh_dlc04_emp_veh_templehof_luminark_0",
    "wh2_dlc13_emp_inf_huntsmen_ror_0",
    "wh2_dlc13_emp_veh_war_wagon_ror_0"
}


local rhox_add_mar_rors = {
    ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
    { "hkrul_pion",                   "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_pion" },
    { "hkrul_klumpf",                 "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_klumpf" },
    { "hkrul_carriers_ror",           "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_carriers_ror" },
    { "hkrul_mar_mananns_blades_ror", "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_mar_mananns_blades_ror" },
    { "hkrul_mar_riverwarden_ror",    "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_mar_riverwarden_ror" },
    { "hkrul_mar_art_paixhan_ror",    "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_mar_art_paixhan_ror" },
    { "hkrul_mar_bordermen_ror",      "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_mar_bordermen_ror" },
    { "hkrul_mar_teuling",            "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_mar_teuling" },
    { "hkrul_mar_talons",             "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_mar_talons" },
    { "hkrul_mar_naval_paixhan",      "wh3_main_regiments_of_renown_pool", 1, 100, 1, "hkrul_mar_naval_paixhan" },
}



local function rhox_add_units(faction_obj, unit_group)
    for i, v in pairs(unit_group) do
        cm:add_unit_to_faction_mercenary_pool(
            faction_obj,
            v[1], -- key
            v[2], -- recruitment source
            v[3], -- count
            v[4], --replen chance
            v[5], -- max units
            0.1, -- max per turn
            "", --faction restriction
            "", --subculture restriction
            "", --tech restriction
            true, --partial
            v[1]
        );
    end
end

local function rhox_add_mar_units(faction_obj, unit_group)  --because they have different mercenary group name
    for i, v in pairs(unit_group) do
        cm:add_unit_to_faction_mercenary_pool(
            faction_obj,
            v[1], -- key
            v[2], -- recruitment source
            v[3], -- count
            v[4], --replen chance
            v[5], -- max units
            0.1, -- max per turn
            "", --faction restriction
            "", --subculture restriction
            "", --tech restriction
            true, --partial
            v[6]
        );
    end
end


cm:add_first_tick_callback_new(
    function()
        if cm:get_faction("wh_main_emp_marienburg"):is_human() then
            --cm:disable_event_feed_events(true, "", "", "mercenary_unit_character_level_restriction_lifted") --this will suppress all RoR events feed from firing
            for i = 1, #rhox_mar_empire_rors do
                cm:add_event_restricted_unit_record_for_faction(rhox_mar_empire_rors[i], "wh_main_emp_marienburg",
                    "rhox_mar_empire_ror_lock")
            end
        end
    end
);



-- Grudgebringers are not Marienburg, but they can't build buildings and can't finish the quest. It's only used for RoR so it's okay
local function rhox_mar_is_marienburg_faction(faction_key)
    local data = RHOX_MAR_FACTIONS[faction_key]
    return (data and data.empire) or faction_key == "ovn_emp_grudgebringers"
end


local function rhox_mar_check_empire(faction)
    if cm:get_campaign_name() ~= "main_warhammer" then --don't do it if it's not IE and IEE
        return
    end

    local region = cm:get_region("wh3_main_combi_region_marienburg")
    if not region then
        return
    end
    local owner = region:owning_faction()

    if owner:culture() == "wh_main_emp_empire" and region:building_exists("wh_main_special_marienburg_port_3") and not rhox_mar_is_marienburg_faction(owner:name()) then
        core:remove_listener("rhox_emp_building_check_RoundStart") --don't have to listen for it anymore
        cm:trigger_incident(faction:name(), "rhox_mar_gained_access_mar_ror", true)
        rhox_add_mar_units(faction, rhox_add_mar_rors);
        unlocked_marienburg_troops = true;


        cm:spawn_character_to_pool(owner:name(), "", "", "", "", 50, true, "general", "hkrul_lector_manann", true, "");
    end
end


local function rhox_mar_check_mar(faction)
    if cm:get_campaign_name() ~= "main_warhammer" then --don't do it if it's not IE and IEE
        return
    end
    local region = cm:get_region("wh3_main_combi_region_altdorf")
    if not region then
        return
    end
    local owner = region:owning_faction()
    out("Rhox: I'm marienburg listener")
    if owner:name() == "wh_main_emp_marienburg" and region:building_exists("wh_main_special_settlement_altdorf_4_emp") then
        core:remove_listener("rhox_mar_building_check_RoundStart") --don't have to listen for it anymore
        cm:trigger_incident(faction:name(), "rhox_mar_gained_access_emp_ror", true)
        for i = 1, #rhox_mar_empire_rors do
            cm:remove_event_restricted_unit_record_for_faction(rhox_mar_empire_rors[i], "wh_main_emp_marienburg")
        end
        unlocked_empire_troops = true;
    end
end



local function rhox_mar_check_talon(faction)
    if cm:get_campaign_name() ~= "main_warhammer" then --don't do it if it's not IE and IEE
        return
    end
    local region = cm:get_region("wh3_main_combi_region_marienburg")
    local owner = region:owning_faction()

    if owner and rhox_mar_is_marienburg_faction(owner:name()) and region:building_exists("rhox_mar_rijker") then
        cm:remove_event_restricted_unit_record_for_faction("hkrul_mar_talons", faction:name());
        --cm:set_saved_value("rhox_talons_granted", true)
    end
end




cm:add_first_tick_callback(
    function()
        local non_marienburg_human_empire_exist = false
        local human_empire_factions = cm:get_human_factions_of_culture("wh_main_emp_empire")
        for _, faction_key in ipairs(human_empire_factions) do
            if not rhox_mar_is_marienburg_faction(faction_key) then
                non_marienburg_human_empire_exist = true
            end
        end

        if non_marienburg_human_empire_exist and unlocked_marienburg_troops == false then
            core:add_listener(
                "rhox_emp_building_check_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():culture() == "wh_main_emp_empire" and context:faction():is_human() and
                    unlocked_marienburg_troops == false and not rhox_mar_is_marienburg_faction(context:faction():name())
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
                    return context:faction():culture() == "wh_main_emp_empire" and context:faction():is_human() and
                    cm:model():turn_number() == 2 and
                    not rhox_mar_is_marienburg_faction(context:faction():name())                                                                                                                                   --only at the second turn.
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
                return rhox_mar_is_marienburg_faction(context:faction():name()) and cm:get_saved_value("rhox_talons_granted") ~=
                true
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
        return building:name() == "rhox_mar_rijker" and
        (building_faction:name() == "wh_main_emp_marienburg" or building_faction:name() == "ovn_mar_house_den_euwe") and
        cm:get_saved_value("rhox_talons_granted") ~= true
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
local mar_faction_ror_unlocks = {
    wh_main_emp_marienburg = "hkrul_carriers_ror",
    ovn_mar_cult_of_manann = "ovn_mar_inf_knights_mariner_0",
    ovn_mar_house_fooger = "hkrul_fooger_ror"
}

core:add_listener(
    "Marienburg_faction_makes_alliance",
    "PositiveDiplomaticEvent",
    function(context)
        return (rhox_mar_is_marienburg_faction(context:recipient():name()) or rhox_mar_is_marienburg_faction(context:proposer():name())) and
        (context:is_military_alliance() or context:is_defensive_alliance())
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
        return rhox_mar_is_marienburg_faction(context:confederation():name()) and rhox_mar_is_marienburg_faction(context:faction():name())
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
--]] --condition has been changed


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
            unlocked_marienburg_troops = cm:load_named_value("rhox_mar_unlocked_marienburg_troops",
                unlocked_marienburg_troops, context)
            unlocked_empire_troops = cm:load_named_value("rhox_mar_unlocked_empire_troops", unlocked_empire_troops,
                context)
        end
    end
)
