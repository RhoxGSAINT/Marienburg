

local function add_hkrul_mar_ror()
    -- Easy data table for faction info and unit info

    local ror_table = { -- A table of many RoR's ---- BEGIN REWRITE
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_pion", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_pion", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_klumpf", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_bucs", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_carriers_ror", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_carriers_ror", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_mar_mananns_blades_ror", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_mananns_blades_ror", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_mar_riverwarden_ror", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_riverwarden_ror", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_mar_art_paixhan_ror", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_art_paixhan_ror", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_mar_bordermen_ror", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_bordermen_ror", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_mar_teuling", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_teuling", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_mar_naval_paixhan", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_naval_paixhan", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
        { -- This is the first RoR we wish to spawn
            faction_key = "wh_main_emp_marienburg", -- The faction we're adding this RoR to; from `factions`
            unit_key = "hkrul_mar_talons", -- The unit key; from `main_units`
            merc_pool = "renown", -- The mercenary pool we're adding this RoR to; from `recruitment_sources`
            merc_group = "hkrul_mar_talons", -- The mercenary pool group this unit belongs to; in `mercenary_unit_groups`
            count = 1, -- The number of RoRs we're adding; this will be 1 by default, only put this line if you're seeking to change the number added
        }, -- and you can make a new table for each other RoR you're seeking to add!
    } -- Closing out the ror_table variable!

    ---- END REWRITE.
    
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
    
    
    for i, ror in pairs(ror_table) do
        local faction_key, unit_key = ror.faction_key, ror.unit_key
        local faction = cm:get_faction(faction_key)
        local merc_pool, merc_group = ror.merc_pool, ror.merc_group
        local count = ror.count or 1 -- if ror.count is undefined, we'll just use the default of 1!

        if faction then
            cm:add_unit_to_faction_mercenary_pool(
                faction,
                unit_key,
                merc_pool,
                count,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                merc_group
            )
        end
        local faction2 = cm:get_faction("ovn_mar_house_den_euwe") --egmond
        if faction2 then
            cm:add_unit_to_faction_mercenary_pool(
                faction2,
                unit_key,
                merc_pool,
                count,
                defaults.replen_chance,
                defaults.max,
                defaults.max_per_turn,
                defaults.faction_restriction,
                defaults.subculture_restriction,
                defaults.tech_restriction,
                defaults.partial_replenishment,
                merc_group
            )
        end
        
    end
    cm:add_event_restricted_unit_record_for_faction("hkrul_mar_talons", "wh_main_emp_marienburg", "rhox_mar_talons_lock")--red talons restriction
    cm:add_event_restricted_unit_record_for_faction("hkrul_mar_talons", "ovn_mar_house_den_euwe", "rhox_mar_talons_lock")
    
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