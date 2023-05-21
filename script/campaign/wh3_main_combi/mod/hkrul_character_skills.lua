local marienburg_faction_key = "wh_main_emp_marienburg"

local function get_character_by_subtype(subtype, faction)
    local character_list = faction:character_list()
    
    for i = 0, character_list:num_items() - 1 do
        local character = character_list:item_at(i)
        
        if character:character_subtype(subtype) then
            return character
        end
    end
    return false
end

core:add_listener(
	"hkrul_jk_special_2_3_2_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_jk_special_2_3_2"
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		local world_walker_interface = cm:get_faction("wh_dlc08_nor_norsca")
		
		if world_walker_interface and not world_walker_interface:is_dead() then
			cm:force_make_trade_agreement(faction_name, "wh_dlc08_nor_norsca")
		end
	end,
	true
)

core:add_listener(
	"hkrul_jk_special_2_3_1_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_jk_special_2_3_1"
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		local orthodoxy_interface = cm:get_faction("wh3_main_ksl_the_great_orthodoxy")
		
		if orthodoxy_interface and not orthodoxy_interface:is_dead() then
			cm:force_make_trade_agreement(faction_name, "wh3_main_ksl_the_great_orthodoxy")
            cm:make_diplomacy_available(faction_name, "wh3_main_ksl_the_great_orthodoxy")
		end
	end,
	true
)

core:add_listener(
    "hkrul_jk_special_2_2_2_CharacterSkillPointAllocated",
    "CharacterSkillPointAllocated",
    function(context)
        local skill = context:skill_point_spent_on()
        return skill == "hkrul_jk_special_2_2_2"
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        local faction_name = faction:name()
        local estalia_name = "wh_main_teb_estalia"
        if vfs.exists("script/frontend/mod/cataph_teb.lua") then --you have Cataph's TEB enabled. Then we have to use a different faction name
            out("Rhox Mar: Found Cataph's mod")
            estalia_name = "mixer_teb_estalia"
        end
        local estalia_interface = cm:get_faction(estalia_name)
        
        
        if estalia_interface and not estalia_interface:is_dead() then
            out("Rhox Mar: Going to make a trade agreement")
            cm:force_make_trade_agreement(faction_name, estalia_name)
            cm:make_diplomacy_available(faction_name, estalia_name)
        end
        out("Rhox Mar: Made trade agreement")
    end,
    true
)

core:add_listener(
	"hkrul_jk_special_2_2_1_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_jk_special_2_2_1"
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		local tilea_name = "wh_main_teb_tilea"
		if vfs.exists("script/frontend/mod/cataph_teb.lua") then --you have Cataph's TEB enabled. Then we have to use a different faction name
            out("Rhox Mar: Found Cataph's mod")
            tilea_name = "mixer_teb_tilea"
        end
		local tilea_interface = cm:get_faction(tilea_name)
		
		if tilea_interface and not tilea_interface:is_dead() then
            out("Rhox Mar: Going to make a trade agreement")
			cm:force_make_trade_agreement(faction_name, tilea_name)
            cm:make_diplomacy_available(faction_name, tilea_name)
		end
		out("Rhox Mar: Made trade agreement")
	end,
	true
)

core:add_listener(
	"hkrul_jk_special_2_1_1_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_jk_special_2_1_1"
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		local averland_interface = cm:get_faction("wh_main_emp_averland")
		
		if averland_interface and not averland_interface:is_dead() then
			cm:force_alliance(faction_name, "wh_main_emp_averland", false)
		end
	end,
	true
)

core:add_listener(
	"hkrul_jk_special_2_1_2_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_jk_special_2_1_2"
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		local ostland_interface = cm:get_faction("wh_main_emp_ostland")
		
		if ostland_interface and not ostland_interface:is_dead() then
			cm:force_alliance(faction_name, "wh_main_emp_ostland", false)
		end
	end,
	true
)


core:add_listener(
    "hkrul_jk_special_0_5_CharacterSkillPointAllocated", --change for actual skill_key
    "CharacterSkillPointAllocated",
    function(context)
        local skill = context:skill_point_spent_on()
        return skill == "hkrul_jk_special_0_5" 
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        local faction_key = character:faction():name()
        local reikland_interface = cm:get_faction("wh_main_emp_empire")
        local money = -2000
        if faction_key == "wh_main_emp_empire" then
            return --for confederation and recruit defeated lords. don't do anything if Jaan is in the Reikland faction
        end
        if cm:get_faction(marienburg_faction_key):is_human() == false and RHOX_MAR_MCT_SETTING.block_rebellion == true then
            return --do not do anything if Marienburg is not human and player checked the option
        end
        
        if reikland_interface and not reikland_interface:is_dead() and cm:get_saved_value("hkrul_jk_special_0_5_actived_before") ~= true then --we put variable restriction here because of the mission
            local target_region = cm:get_region("wh3_main_combi_region_eilhart") 
            if target_region:owning_faction() ~= reikland_interface then
                if reikland_interface:has_home_region() then
                    target_region = reikland_interface:home_region()
                else
                    target_region = nil
                end
            end
            if target_region then
              local mf = cm:force_rebellion_with_faction(target_region, "wh_main_emp_empire_rebels", 20, true, false)
                cm:callback(
                    function() 
                        local unit_list = mf:unit_list()
                        for i = 0, unit_list:num_items() - 1 do
                            local unit = unit_list:item_at(i)
                            cm:add_experience_to_unit(unit, 6)
                        end
                        cm:apply_effect_bundle_to_force("hkrul_mar_rebel", mf:command_queue_index(), 0)
                    end, 0.1
                )
                cm:treasury_mod(faction_key, money)
            end
            cm:set_saved_value("hkrul_jk_special_0_5_actived_before", true)
        end
        
        if faction:ancillary_exists("hkrul_mar_axel") == false and cm:get_saved_value("hkrul_jk_special_0_5_mission_active") ~= true then
            local character = context:character()
            
            local faction_name = faction:name()
            local region = cm:get_region("wh3_main_combi_region_eilhart")
            if faction:is_human() and region:owning_faction() and region:owning_faction():name() ~= marienburg_faction_key then --AI don't get mission, just give ancillary if player already owns the eilhart
                local scmm = mission_manager:new(faction_name, "rhox_mar_bridge_reik")
                scmm:add_new_objective("CAPTURE_REGIONS");
                scmm:add_condition("region wh3_main_combi_region_eilhart");
                scmm:add_condition("ignore_allies");
                scmm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_mar_axel;}");
                scmm:add_payload("money 750");
                scmm:trigger()
            else
                cm:add_ancillary_to_faction(faction, "hkrul_mar_axel", false)
            end
            cm:set_saved_value("hkrul_jk_special_0_5_mission_active", true)
        end
    end,
    true
)

core:add_listener(
    "hkrul_jk_special_0_6_CharacterSkillPointAllocated", 
    "CharacterSkillPointAllocated",
    function(context)
        local skill = context:skill_point_spent_on()
        return skill == "hkrul_jk_special_0_6" 
    end,
    function(context)
        local character = context:character()
        local faction_key = character:faction():name()
        local reikland_interface = cm:get_faction("wh_main_emp_empire")
        local money = -4000
        
        if faction_key == "wh_main_emp_empire" then
            return --for confederation and recruit defeated lords. don't do anything if Jaan is in the Reikland faction
        end
        if cm:get_faction(marienburg_faction_key):is_human() == false and RHOX_MAR_MCT_SETTING.block_rebellion == true then
            return --do not do anything if Marienburg is not human and player checked the option
        end
        
        if reikland_interface and not reikland_interface:is_dead() and cm:get_saved_value("hkrul_jk_special_0_6_actived_before") ~= true then
            local target_region = cm:get_region("wh3_main_combi_region_altdorf") --change for actual region_key
            if target_region:owning_faction() ~= reikland_interface then
                if reikland_interface:has_home_region() then
                    target_region = reikland_interface:home_region()
                else
                    target_region = nil
                end
            end
            if target_region then
              local mf = cm:force_rebellion_with_faction(target_region, "wh_main_emp_empire_rebels", 20, true, false)
                cm:callback(
                    function() 
                        local unit_list = mf:unit_list()
                        for i = 0, unit_list:num_items() - 1 do
                            local unit = unit_list:item_at(i)
                            cm:add_experience_to_unit(unit, 5)
                        end
                        cm:apply_effect_bundle_to_force("hkrul_mar_rebel", mf:command_queue_index(), 0)
                    end, 0.1
                )
                cm:treasury_mod(faction_key, money)
            end
            cm:set_saved_value("hkrul_jk_special_0_6_actived_before", true)
        end
        if cm:get_faction("wh_main_emp_marienburg"):is_human() then --mission is only for the players, so have to check it.
            cm:trigger_mission("wh_main_emp_marienburg", "rhox_mar_conquer_empire", true)
        end
    end,
    true
)


core:add_listener(
	"hkrul_jk_special_2_4_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_jk_special_2_4"
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		local elasor_interface = cm:get_faction("wh2_main_hef_tor_elasor")       
		local nwc_interface = cm:get_faction("wh2_main_emp_new_world_colonies")
        local cultsigmar_interface =cm:get_faction("wh3_main_emp_cult_of_sigmar")
        local westernp_interface =cm:get_faction("wh3_main_cth_the_western_provinces")

		
		if elasor_interface and not elasor_interface:is_dead() then
			cm:force_make_trade_agreement(faction_name, "wh2_main_hef_tor_elasor")
            cm:make_diplomacy_available(faction_name, "wh2_main_hef_tor_elasor")
		end

		if nwc_interface and not nwc_interface:is_dead() then
			cm:force_make_trade_agreement(faction_name, "wh2_main_emp_new_world_colonies")
            cm:make_diplomacy_available(faction_name, "wh2_main_emp_new_world_colonies")
		end

		
		if westernp_interface and not westernp_interface:is_dead() then
			cm:force_make_trade_agreement(faction_name, "wh3_main_cth_the_western_provinces")
            cm:make_diplomacy_available(faction_name, "wh3_main_cth_the_western_provinces")
		end
				
		if cultsigmar_interface and not cultsigmar_interface:is_dead() then
			cm:force_make_trade_agreement(faction_name, "wh3_main_emp_cult_of_sigmar")
            cm:make_diplomacy_available(faction_name, "wh3_main_emp_cult_of_sigmar")
		end
	end,        
    true
)


-------------for solakan skill check
core:add_listener(
    "hkrul_mar_simon_bundle_listener",
    "CharacterSkillPointAllocated",
    function(context)
        local skill = context:skill_point_spent_on()        
        return skill == "hkrul_solkan_special_0_3"
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        local jaanarmy = get_character_by_subtype("hkrul_jk", faction)
        out("Rhox mar: Before going into the army.")
        if character:is_embedded_in_military_force() and jaanarmy and jaanarmy:has_military_force() and character:embedded_in_military_force():command_queue_index() == jaanarmy:military_force():command_queue_index() then
            out("Rhox mar: Passed the condition")
            cm:apply_effect_bundle_to_character("hkrul_mar_bundle_simon", character, 1)
        end
    end,
    true
)

core:add_listener(
    "hkrul_mar_simon_bundle_backup",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_jk")
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        local simon = get_character_by_subtype("hkrul_solkan", faction)
        
        if simon and simon:has_skill("hkrul_solkan_special_0_3") and simon:is_embedded_in_military_force() and character:has_military_force() and character:military_force():command_queue_index() == simon:embedded_in_military_force():command_queue_index() then
            cm:apply_effect_bundle_to_character("hkrul_mar_bundle_simon", simon, 1)
        end
    end,
    true
)

core:add_listener(
    "rhox_mar_simon_embed_listener",
    "CharacterCharacterTargetAction",
    function(context)
        --out("Rhox mar: agent action key: "..context:agent_action_key())
        return context:agent_action_key() == "wh2_main_agent_action_champion_assist_army_training" and context:character():character_subtype_key() == "hkrul_solkan" and context:character():has_skill("hkrul_solkan_special_0_3")
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        local jaanarmy = get_character_by_subtype("hkrul_jk", faction)
        
        if character:has_effect_bundle("hkrul_mar_bundle_simon") then
            return;--no need to apply it if character already has it
        end
        
        out("Rhox mar: Before going into the army.")
        if character:is_embedded_in_military_force() and jaanarmy and jaanarmy:has_military_force() and character:embedded_in_military_force():command_queue_index() == jaanarmy:military_force():command_queue_index() then
            out("Rhox mar: Passed the condition")
            cm:apply_effect_bundle_to_character("hkrul_mar_bundle_simon", character, 1)
        end
    end,
    true
)

----------------For alicia skill check. 
core:add_listener(
    "hkrul_mar_alicia_bundle_listener",
    "CharacterSkillPointAllocated",
    function(context)
        local skill = context:skill_point_spent_on()        
        return skill == "hkrul_alicia_special_2_0"
    end,
    function(context)
        local character = context:character() --alicia  
        local faction = character:faction()
        local mundvard = get_character_by_subtype("hkrul_mar_munvard", faction)
        --out("Rhox mar: Before going into the army.")
        if character:is_embedded_in_military_force() and mundvard and mundvard:has_military_force() and character:embedded_in_military_force():command_queue_index() == mundvard:military_force():command_queue_index() then
            --out("Rhox mar: Passed the condition")
            cm:apply_effect_bundle_to_character("hkrul_mar_bundle_alicia", character, 1)
        end
    end,
    true
)

core:add_listener(
    "hkrul_mar_alicia_bundle_backup",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_mar_munvard") --mundvard turn start. Check if Alicia is embedded
    end,
    function(context)
        local character = context:character()    --mundvard
        local faction = character:faction()
        local alicia = get_character_by_subtype("hkrul_alicia", faction)
        if alicia and alicia:has_skill("hkrul_alicia_special_2_0") and alicia:is_embedded_in_military_force() and character:has_military_force() and character:military_force():command_queue_index() == alicia:embedded_in_military_force():command_queue_index() then
            cm:apply_effect_bundle_to_character("hkrul_mar_bundle_alicia", alicia, 1)
        end
    end,
    true
)

core:add_listener(
    "rhox_mar_alicia_embed_listener",
    "CharacterCharacterTargetAction",
    function(context)
        --out("Rhox mar: agent action key: "..context:agent_action_key())
        return context:agent_action_key() == "wh2_main_agent_action_dignitary_assist_army_replenish_troops" and context:character():character_subtype_key() == "hkrul_alicia" and context:character():has_skill("hkrul_alicia_special_2_0")
    end,
    function(context)
        local character = context:character() --alicia  
        local faction = character:faction()
        local mundvard = get_character_by_subtype("hkrul_mar_munvard", faction)
        
        if character:has_effect_bundle("hkrul_mar_bundle_alicia") then
            return;--no need to apply it if character already has it
        end
        
        if character:is_embedded_in_military_force() and mundvard and mundvard:has_military_force() and character:embedded_in_military_force():command_queue_index() == mundvard:military_force():command_queue_index() then
            cm:apply_effect_bundle_to_character("hkrul_mar_bundle_alicia", character, 1)
        end
    end,
    true
)






---caravan
----------------------------------------------

--add unit
core:add_listener(
	"caravan_master_SkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return skill == "hkrul_caravan_lord_special_1_0"
	end,
	function(context)
		local character = context:character()
        local military_force = character:military_force() --they're caravan. They'll always have it.
        local character_lookup_str = cm:char_lookup_str(character)
        
        rhox_add_unit_to_military_force(military_force, character_lookup_str, "hkrul_carriers")
	end,
	true
)


--LH cargo add
--

function rhox_mar_add_initial_cargo(caravan_handle)

    local character = caravan_handle:caravan_master():character() --caravan master
    local faction = character:faction()
    if character:has_effect_bundle("rhox_mar_bundle_caravan_heroes") then
        cm:remove_effect_bundle_from_character("rhox_mar_bundle_caravan_heroes", character)
    end-- remove the pre-existing one if any
    local cargo_bundle = cm:create_new_custom_effect_bundle("rhox_mar_bundle_caravan_heroes");
    cargo_bundle:set_duration(0);
    local bonus_cargo =0
		
    
    out("Rhox mar: Checking caravan master")    
    local cargo_amount = caravan_handle:cargo();
    out("Rhox mar: Cargo Amount before the function: "..cargo_amount)
    
    local crispijn = get_character_by_subtype("hkrul_crispijn", faction)
    if crispijn and crispijn:has_skill("hkrul_crispijn_special_1_2") and crispijn:is_embedded_in_military_force() and character:has_military_force() and character:military_force():command_queue_index() == crispijn:embedded_in_military_force():command_queue_index() then
        out("Rhox mar: hkrul_crispijn found")
        bonus_cargo = bonus_cargo+ 200
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_capacity", "character_to_character_own", 20); --it's percentage but will work since 1000 is the minimum
    end
    
    local guzunda = get_character_by_subtype("hkrul_guzunda", faction)
    if guzunda and guzunda:has_skill("hkrul_guzunda_special_1_0") and guzunda:is_embedded_in_military_force() and character:has_military_force() and character:military_force():command_queue_index() == guzunda:embedded_in_military_force():command_queue_index() then
        out("Rhox mar: hkrul_guzunda found")
        bonus_cargo = bonus_cargo+ 200
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_capacity", "character_to_character_own", 20); --it's percentage but will work since 1000 is the minimum
    end
    
    local lisette = get_character_by_subtype("hkrul_lisette", faction)
    if lisette and lisette:has_skill("hkrul_lisette_special_1_1") and lisette:is_embedded_in_military_force() and character:has_military_force() and character:military_force():command_queue_index() == lisette:embedded_in_military_force():command_queue_index() then
        out("Rhox mar: hkrul_lisette found")
        bonus_cargo = bonus_cargo+ 200
        cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_capacity", "character_to_character_own", 20); --it's percentage but will work since 1000 is the minimum
    end
    
    cm:apply_custom_effect_bundle_to_character(cargo_bundle, character)
    cm:callback(
        function()
            cm:set_caravan_cargo(caravan_handle, caravan_handle:cargo() + bonus_cargo) --apply effect_bundle, then the bonus cargo
            out("Rhox mar: Cargo Amount after the function: "..caravan_handle:cargo())
        end,
        0.5
    )
end

-----------------------------------Jaan things
--------------------------------Jaan is enterting or leaving the town

local rhox_jaan_skill_to_effect={
    {skill_name ="hkrul_jaan_special_4_0", effect_name="wh_main_effect_force_all_campaign_upkeep", scope ="general_to_force_own", value =-70},
    {skill_name ="hkrul_jaan_special_4_1", effect_name="wh_main_effect_economy_trade_tariff_mod", scope ="character_to_faction_unseen", value =20},
    {skill_name ="hkrul_jaan_special_4_2", effect_name="rhox_mar_jaan_ranged_ammunition", scope ="faction_to_force_own", value =5},
    {skill_name ="hkrul_jaan_special_4_2", effect_name="rhox_mar_jaan_ranged_damage", scope ="faction_to_force_own", value =3},
    {skill_name ="hkrul_jaan_special_4_3", effect_name="rhox_mar_jaan_physical_resistance", scope ="faction_to_force_own", value =3},
    {skill_name ="hkrul_jaan_special_4_4", effect_name="wh2_main_effect_building_construction_time_mod_all", scope ="faction_to_region_own", value =-15},
    {skill_name ="hkrul_jaan_special_4_5", effect_name="rhox_mar_jaan_melee_attack", scope ="faction_to_force_own", value =2},
    {skill_name ="hkrul_jaan_special_4_5", effect_name="rhox_mar_jaan_melee_defence", scope ="faction_to_force_own", value =2},
    {skill_name ="hkrul_jaan_special_4_6", effect_name="wh_main_effect_agent_movement_range_mod", scope ="faction_to_force_own", value =8},
    {skill_name ="hkrul_jaan_special_4_7", effect_name="wh_main_effect_technology_research_points", scope ="character_to_faction_unseen", value =15},
    {skill_name ="hkrul_jaan_special_4_8", effect_name="wh3_main_effect_caravan_cargo_capacity", scope ="faction_to_character_own", value =15},
    {skill_name ="hkrul_jaan_special_4_8", effect_name="hkrul_mar_enable_kuypers_ring", scope ="faction_to_character_own", value =1},
    {skill_name ="hkrul_jaan_special_4_9", effect_name="rhox_mar_jaan_double_cathay_caravan", scope ="character_to_faction_unseen", value =100},
    {skill_name ="hkrul_jaan_special_4_10", effect_name="wh_main_faction_xp_increase_generals", scope ="character_to_province_own_factionwide", value =5},
    {skill_name ="hkrul_jaan_special_4_10", effect_name="wh_main_faction_xp_increase_generals_hidden", scope ="faction_to_force_own", value =5},
    {skill_name ="hkrul_jaan_special_4_12", effect_name="hkrul_jk_enable_politician", scope ="rhox_mar_faction_to_character_own_lords_only", value =1}
}


local function rhox_update_jaan_slack_off_skills(character)
    if character:has_effect_bundle("rhox_mar_bundle_jaan") then
        cm:remove_effect_bundle_from_character("rhox_mar_bundle_jaan", character)
    end-- remove the pre-existing one if any
    
    
    local jaan_bundle = cm:create_new_custom_effect_bundle("rhox_mar_bundle_jaan");
    jaan_bundle:set_duration(0);
    jaan_bundle:add_effect("hkrul_effect_xp_stealing_jaan_hidden", "character_to_character_own", 35);
    --jaan_bundle:add_effect("wh_main_effect_force_stat_melee_attack", "general_to_force_own", 100);  --temp check
    --these two are from innitiate 
    for i, current_effect in pairs(rhox_jaan_skill_to_effect) do
        --out("Rhox mar: Looking at the skill: "..current_effect.skill_name)
        if character:has_skill(current_effect.skill_name) then 
            --out("Rhox mar: He has it!")
            jaan_bundle:add_effect(current_effect.effect_name, current_effect.scope, current_effect.value)
        end
    end
    cm:apply_custom_effect_bundle_to_character(jaan_bundle, character)
end


core:add_listener(
    "hkrul_mar_jaan_bundle_enter_garrison",
    "CharacterEntersGarrison",
    function(context)
        local character = context:character()    
        local region_object = context:garrison_residence():region()
        local region_name = region_object:name()
        return character:character_subtype_key() == "hkrul_jk" and region_name == "wh3_main_combi_region_marienburg"
    end,
    function(context)
        local character = context:character() 
        rhox_update_jaan_slack_off_skills(character)
    end,
    true
)

core:add_listener(
    "hkrul_mar_jaan_bundle_leaves_garrison",
    "CharacterLeavesGarrison",
    function(context)
        local character = context:character()    
        local region_object = context:garrison_residence():region()
        local region_name = region_object:name()
        return character:character_subtype_key() == "hkrul_jk" and region_name == "wh3_main_combi_region_marienburg"
    end,
    function(context)
        local character = context:character() 
        if character:has_effect_bundle("rhox_mar_bundle_jaan") then
            cm:remove_effect_bundle_from_character("rhox_mar_bundle_jaan", character)
        end
    end,
    true
)

local rhox_jaan_slackoff_skills={
    ["hkrul_jaan_special_4_0"]= true,
    ["hkrul_jaan_special_4_1"]= true,
    ["hkrul_jaan_special_4_2"]= true,
    ["hkrul_jaan_special_4_3"]= true,
    ["hkrul_jaan_special_4_4"]= true,
    ["hkrul_jaan_special_4_5"]= true,
    ["hkrul_jaan_special_4_6"]= true,
    ["hkrul_jaan_special_4_7"]= true,
    ["hkrul_jaan_special_4_8"]= true,
    ["hkrul_jaan_special_4_9"]= true,
    ["hkrul_jaan_special_4_10"]= true,
    ["hkrul_jaan_special_4_12"]= true
}
----------update the bundle on skill point
core:add_listener(
	"jaan_slackoff_SkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		return rhox_jaan_slackoff_skills[skill]
	end,
	function(context)
		local character = context:character()
		if character:has_effect_bundle("rhox_mar_bundle_jaan") then --it means this character is garrisoned in Marienburg
            rhox_update_jaan_slack_off_skills(character)
        end
	end,
	true
)




core:add_listener(
    "rhox_jaan_resource_pumping_check_RoundStart",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return character:character_subtype_key() == "hkrul_jk" and character:has_effect_bundle("rhox_mar_bundle_jaan") and character:has_skill("hkrul_jaan_special_4_11")    --bundle is to check if Jaan is in the  capital has skill is to check whether he actually has the skill unlocked
    end,
    function(context)
        out("Rhox Mar: Passed the test")
        local character = context:character()
        if character:has_trait("wh2_main_trait_lazy") then
            cm:force_remove_trait("character_cqi:"..character:cqi(), "wh2_main_trait_lazy")
        end
        campaign_traits:set_lord_record(character, "turns_lazy", 0); --he will never get lazy
        out("Rhox Mar: Lazy trait check")
        
        
        local faction = context:character():faction()
        local army_list = faction:military_force_list()
        local candidate ={}
        for i=0,army_list:num_items()-1 do
            local general = army_list:item_at(i):general_character()
            if general and general:character_subtype_key() ~= "hkrul_jk" and general:character_subtype_key() ~= "mar_caravan_master" and general:character_type("general") then --Jaan can't slave drive himself
                table.insert(candidate, general)
            end
        end
        out("Rhox Mar: Number of non-Jaan generals: "..#candidate)
        if #candidate > 0 then
            local target_index = cm:random_number(#candidate,1)
            out("Rhox Mar: target general's subtype: "..candidate[target_index]:character_subtype_key())
            local military_force = candidate[target_index]:military_force()
            if military_force:has_effect_bundle("rhox_mar_bundle_slavedrive_jaan") then
                cm:remove_effect_bundle_from_force("rhox_mar_bundle_slavedrive_jaan", military_force:command_queue_index())  --remove it to avoid turns stacking
            end
            cm:apply_effect_bundle_to_force("rhox_mar_bundle_slavedrive_jaan", military_force:command_queue_index(), 2) --1 is removed immediately so 2
            --cm:apply_effect_bundle_to_characters_force("rhox_mar_bundle_slavedrive_jaan", candidate[target_index]:command_queue_index(), 1)
        end
    end,
    true
)




--------------------------------------dilemma
core:add_listener(
	"hkrul_jk_special_4_12_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		local character = context:character()
		local faction = character:faction()
		return skill == "hkrul_jaan_special_4_12" and faction:ancillary_exists("hkrul_mar_speaker") == false
	end,
	function(context)
		local character = context:character()
		local faction = character:faction()
		local faction_name = faction:name()
		if faction:is_human() then
            cm:trigger_dilemma(faction_name, "rhox_mar_dilemma_burgerhof")
        else --AI can't have dilemma, just give them a ancillary
            cm:add_ancillary_to_faction(faction, "hkrul_mar_speaker", false)
		end
		
		
	end,
	false
)


-------------------double cathay caravan value

core:add_listener(
    "jaan_dobule_caravn_money_marienburg",
    "CaravanCompleted",
    function(context)
        
        local node = context:complete_position():node()
        local region_owner = node:region_data():region():owning_faction();
        --out("Rhox Mar: caravan finished node name: "..node:region_data():region():name())
        
        if region_owner:is_null_interface() then
            return false
        end
        local bundle_active = region_owner:bonus_values():scripted_value("rhox_mar_enable_double_cathay_caravan", "value") 
        --out("Rhox Mar: Jaan value: "..bundle_active)
        
        
        
        return bundle_active > 1 and node:region_data():region():name() == "wh3_main_combi_region_marienburg" and region_owner:is_human() --for player only
    end,
    function(context)
        -- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
        local node = context:complete_position():node()
        local region_owner = node:region_data():region():owning_faction();
            
        if not region_owner:is_null_interface() then --he had this bundle, so he is likely to not have lost the Marienburg. But still
            cm:trigger_incident_with_targets(
                region_owner:command_queue_index(),
                "rhox_mar_double_cathay_reward_jaan",
                0,
                0,
                region_owner:faction_leader():command_queue_index(), --will be Jaan
                0,
                0,
                0
            )
        end
                    
    end,
    true
);

------------ai slack in Marienburg
core:add_listener(
    "hkrul_mar_jk_slack_in_marienburg",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_jk") and not character:faction():is_human() --only for AI
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        local region = cm:get_region("wh3_main_combi_region_marienburg")
        
        cm:cai_enable_movement_for_character("character_cqi:"..character:cqi()) --enable him as initial and disable when he can go into Marienburg
        
        if not character:has_military_force() then
            out("Rhox Mar: Jaan does not have military force")
            return
        end
        
        if region:settlement():has_commander() then
            out("Rhox Mar: Marienburg already had a garrison")
            out("Rhox mar: That commander subtype: "..region:settlement():commander():character_subtype_key())
            if region:settlement():commander():character_subtype("hkrul_jk") then
                out("Rhox Mar: It was JK. let him stay there.")
                cm:cai_disable_movement_for_character("character_cqi:"..character:cqi())
                out("Rhox Mar: It was JK. let him stay there.")
            end
            
            return --somebody is in the garrison don't do it
        end
        
        if region:owning_faction():name() ~= faction:name() then --jaan does not control Marienburg. Don't do it. 
            out("Rhox Mar: Jaan does not own Marienburg")
            return
        end
        
        cm:join_garrison("character_cqi:"..character:cqi(),"settlement:wh3_main_combi_region_marienburg")
        cm:cai_disable_movement_for_character("character_cqi:"..character:cqi())
        out("Rhox Mar: Put this guy in Marienburg")
    end,
    true
)

