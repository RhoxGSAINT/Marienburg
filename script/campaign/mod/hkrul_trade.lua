local function add_unit_to_faction(unit_key, faction_key)
    local faction = cm:get_faction(faction_key)
    if not faction then
        out("add_unit_to_faction | no faction found")
        return
    end
    local faction_leader = faction:faction_leader()
    if not faction_leader then
        out("add_unit_to_faction | no faction leader found")
        return
    end
    
    local faction_leader_lookup_str = cm:char_lookup_str(faction_leader)
    local military_force
    if faction_leader:has_military_force() then 
        military_force = faction_leader:military_force()
    else
        local mf_list = faction:military_force_list()
        for i = 0, mf_list:num_items() - 1 do
            local mf = mf_list:item_at(i)
            if not mf:is_armed_citizenry() then
                military_force = mf
                break
            end
        end
    end
    if is_militaryforce(military_force) then
        local units = {}
        local unit_list = military_force:unit_list()
        if unit_list:num_items() >= 19 then
            for i = 1, unit_list:num_items() - 1 do --start at 1 to exclude the general
                local unit = unit_list:item_at(i)
                if unit:unit_class() ~= "com" then --let's try to avoid deleting agents
                    local unit_value = unit:get_unit_custom_battle_cost() -- * unit:percentage_proportion_of_full_strength()
                    table.insert(units, {value = unit_value, unit_key = unit:unit_key()})
                end
            end
            table.sort(units, function(a,b) return tonumber(a.value) < tonumber(b.value) end)
            cm:remove_unit_from_character(faction_leader_lookup_str, units[1].unit_key)
        end
        cm:grant_unit_to_character(faction_leader_lookup_str, unit_key)
    else
        out("add_unit_to_faction | no military_force found")
    end
end


local function check_concurrent_trade_bonuses(character)	
    local faction = character:faction()
        
    local faction_list = faction:factions_trading_with()
    local trade_count = faction_list:num_items()
        
    if character:has_effect_bundle("+") then
        cm:remove_effect_bundle_from_character("copycat_leadership_per_trade_agreement", character)
    end
    
    local bundle = cm:create_new_custom_effect_bundle("copycat_leadership_per_trade_agreement")
    bundle:add_effect("wh_main_effect_force_stat_leadership", "character_to_force_own", trade_count)
    bundle:set_duration(0)
    cm:apply_custom_effect_bundle_to_character(bundle, character)	
end

core:add_listener(
    "hkrul_mar_bonus_value_listener_CharacterTurnStart",
    "CharacterTurnStart",
    function(context)	
        local character = context:character()	
        return character:bonus_values():scripted_value("copycat_leadership_per_trade_agreement", "value") > 0
    end,
    function(context)
        check_concurrent_trade_bonuses(context:character())	
    end,
    true
)


core:add_listener(
    "hkrul_mar_bonus_value_listener_FactionLeaderDeclaresWar",
    "PositiveDiplomaticEvent",
    function(context)	
        local character = context:character()	
        return context:is_trade_agreement() and character:bonus_values():scripted_value("copycat_leadership_per_trade_agreement", "value") > 0
    end,
    function(context)
        check_concurrent_trade_bonuses(context:character())	
    end,
    true
)

-- THAT CONCLUDES THE LEADERSHIP PER CONCURRENT TRADE AGREEMENT SCRIPT --
-- NOW STARTS THE RITES UNLOCK SCRIPT--
local marienburg_faction_key = "wh_main_emp_marienburg"

cm:add_first_tick_callback(
    function() 
        local marienburg_faction = cm:get_faction(marienburg_faction_key)
        if not cm:get_saved_value("hkrul_mar_ritual_voyage" .. "_" .. marienburg_faction_key .. "_unlocked") then
            cm:lock_ritual(marienburg_faction, "hkrul_mar_ritual_voyage")
        end
        if not cm:get_saved_value("hkrul_mar_ritual_merchant" .. "_" .. marienburg_faction_key .. "_unlocked") then
            cm:lock_ritual(marienburg_faction, "hkrul_mar_ritual_merchant")
        end
        if not cm:get_saved_value("hkrul_mar_ritual_rebels" .. "_" .. marienburg_faction_key .. "_unlocked") then
            cm:lock_ritual(marienburg_faction, "hkrul_mar_ritual_rebels")
        end
        if not cm:get_saved_value("hkrul_mar_ritual_diplomacy" .. "_" .. marienburg_faction_key .. "_unlocked") then
            cm:lock_ritual(marienburg_faction, "hkrul_mar_ritual_diplomacy")
        end
    end
)

core:add_listener(
    "Vloedmuur_CharacterRankUp",
    "CharacterRankUp",
    function(context)	
        local character = context:character()	
        return character:faction():name() == marienburg_faction_key and character:is_faction_leader() and character:rank() >= 8
    end,
    function(context)
        local marienburg_faction = context:character():faction()
        if marienburg_faction:rituals():ritual_status("hkrul_mar_ritual_voyage"):script_locked() then
            cm:unlock_ritual(marienburg_faction, "hkrul_mar_ritual_voyage")
            show_rite_unlocked_event(marienburg_faction_key, "hkrul_mar_ritual_voyage")
            cm:set_saved_value("hkrul_mar_ritual_voyage" .. "_" .. marienburg_faction_key .. "_unlocked", true)
        end
    end,
    true
)

core:add_listener(
    "Trade_Secretariat_PositiveDiplomaticEvent",
    "PositiveDiplomaticEvent",
    function(context)    
        return context:is_trade_agreement() and (context:proposer():name() == marienburg_faction_key or context:recipient():name() == marienburg_faction_key)
    end,
    function(context)
        local marienburg_faction = cm:get_faction(marienburg_faction_key)
        cm:callback(function()
            local trade_count = marienburg_faction:factions_trading_with():num_items()
            if trade_count >= 6 and marienburg_faction:rituals():ritual_status("hkrul_mar_ritual_merchant"):script_locked() then
                cm:unlock_ritual(marienburg_faction, "hkrul_mar_ritual_merchant")
                show_rite_unlocked_event(marienburg_faction_key, "hkrul_mar_ritual_merchant")
                cm:set_saved_value("hkrul_mar_ritual_merchant" .. "_" .. marienburg_faction_key .. "_unlocked", true)
            end
        end, 0.1)
    end,
    true
)

core:add_listener(
    "Boatbuilders_GarrisonOccupiedEvent",
    "GarrisonOccupiedEvent",
    function(context)    
        local garrison_residence = context:garrison_residence()
        return garrison_residence:is_settlement() and garrison_residence:settlement_interface():is_port() and garrison_residence:faction():name() == marienburg_faction_key
    end,
    function(context)
        local marienburg_faction = context:garrison_residence():faction()
        local region_list = marienburg_faction:region_list()
        local port_settlement_count = 0
        for i = 0, region_list:num_items() - 1 do
            local region = region_list:item_at(i)
            if region:settlement():is_port() then
                port_settlement_count = port_settlement_count + 1
            end
        end
        if port_settlement_count >= 2 and marienburg_faction:rituals():ritual_status("hkrul_mar_ritual_rebels"):script_locked() then
            cm:unlock_ritual(marienburg_faction, "hkrul_mar_ritual_rebels")
            show_rite_unlocked_event(marienburg_faction_key, "hkrul_mar_ritual_rebels")
            cm:set_saved_value("hkrul_mar_ritual_rebels" .. "_" .. marienburg_faction_key .. "_unlocked", true)
        end
    end,
    true
)

core:add_listener(
    "Boatbuilders_FactionTurnStart",
    "FactionTurnStart",
    function(context)    
        return context:faction():name() == marienburg_faction_key
    end,
    function(context)
        local marienburg_faction = context:faction()
        local region_list = marienburg_faction:region_list()
        local port_settlement_count = 0
        for i = 0, region_list:num_items() - 1 do
            local region = region_list:item_at(i)
            if region:settlement():is_port() then
                port_settlement_count = port_settlement_count + 1
            end
        end
        if port_settlement_count >= 3 and marienburg_faction:rituals():ritual_status("hkrul_mar_ritual_rebels"):script_locked() then
            cm:unlock_ritual(marienburg_faction, "hkrul_mar_ritual_rebels")
            show_rite_unlocked_event(marienburg_faction_key, "hkrul_mar_ritual_rebels")
            cm:set_saved_value("hkrul_mar_ritual_rebels" .. "_" .. marienburg_faction_key .. "_unlocked", true)
        end
    end,
    true
)

core:add_listener(
    "Directorate_FactionTurnStart",
    "FactionTurnStart",
    function(context)    
        return context:faction():name() == marienburg_faction_key
    end,
    function(context)
        local marienburg_faction = context:faction()
        local net_income = marienburg_faction:net_income()
        if net_income >= 3000 and marienburg_faction:rituals():ritual_status("hkrul_mar_ritual_diplomacy"):script_locked() then
            cm:unlock_ritual(marienburg_faction, "hkrul_mar_ritual_diplomacy")
            show_rite_unlocked_event(marienburg_faction_key, "hkrul_mar_ritual_diplomacy")
            cm:set_saved_value("hkrul_mar_ritual_diplomacy" .. "_" .. marienburg_faction_key .. "_unlocked", true)
        end
    end,
    true
)

-- THAT CONCLUDES THE UNLOCKS --
-- THE NEXT PART WILL BE APPLYING EFFECTS TO RITES -- 

core:add_listener(
    "Trade_Secretariat_RitualStartedEvent",
    "RitualStartedEvent",
    function(context)    
        return context:ritual():ritual_key() == "hkrul_mar_ritual_merchant" and context:performing_faction():name() == marienburg_faction_key
    end,
    function(context)
        local marienburg_faction = context:performing_faction()
        local factions_trading_with = marienburg_faction:factions_trading_with()
        local turn_timer = 5
        cm:add_turn_countdown_event(marienburg_faction_key, turn_timer, "TradeRiteExpired", marienburg_faction_key)

        if factions_trading_with:num_items() > 0 then
            for i = 0, factions_trading_with:num_items() - 1 do
                local current_faction = factions_trading_with:item_at(i)
                local current_faction_regions = current_faction:region_list()            
                for j = 0, current_faction_regions:num_items() - 1 do
                    local current_region_name = current_faction_regions:item_at(j):name()
                    cm:make_region_visible_in_shroud(marienburg_faction_key, current_region_name)
                end
            end
        end
    end,
    true
)

core:add_listener(
    "Trade_Secretariat_TradeRiteExpired",
    "TradeRiteExpired",
    true,
    function(context)
        local faction_name = context.string
        local marienburg_faction = cm:get_faction(faction_name)
        cm:reset_shroud(marienburg_faction)
    end,
    true
)

--  NOW STARTS THE SCRIPT FOR THE SCHEME RITE -- 

core:add_listener(
    "Directorate_RitualStartedEvent",
    "RitualStartedEvent",
    function(context)    
        return context:ritual():ritual_key() == "hkrul_mar_ritual_diplomacy" and context:performing_faction():name() == marienburg_faction_key
    end,
    function(context)
        local dilemma_key = cm:get_saved_value("next_dilemma") or "hkrul_mar_dil_1"

        if not context:performing_faction():is_human() and RHOX_MAR_MCT_SETTING.disable_rite == false then
            local ai_choice = cm:random_number(3, 1)
            if ai_choice == 1 and cm:get_faction("wh_main_emp_wissenland") and cm:get_faction("wh_main_emp_wissenland"):is_dead()== false then
                cm:treasury_mod("wh_main_emp_wissenland", 10000)
                add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_wissenland")
                cm:force_declare_war("wh_main_emp_wissenland","wh_main_emp_empire", true, true)
            elseif ai_choice == 2 and cm:get_faction("wh_main_emp_talabecland") and cm:get_faction("wh_main_emp_talabecland"):is_dead()== false then
                cm:treasury_mod("wh_main_emp_talabecland", 10000)
                add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_talabecland")
                cm:force_declare_war("wh_main_emp_talabecland","wh_main_emp_empire",true, true)
            elseif ai_choice == 3 and cm:get_faction("wh_main_emp_nordland") and cm:get_faction("wh_main_emp_nordland"):is_dead()== false then
                cm:treasury_mod("wh_main_emp_nordland", 10000)
                add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_nordland")
                cm:force_declare_war("wh_main_emp_nordland","wh_main_emp_middenland", true, true)
            end
            show_ai_rite_performed_event(context:performing_faction(), context:ritual():ritual_key())
        elseif context:performing_faction():is_human() then
            cm:callback(
                function()
                    cm:trigger_dilemma(marienburg_faction_key, dilemma_key)
                end,
                3.2  --this is to give time to show the ritual
            )
        end
    end,
    true
)

core:add_listener(
    "hkrul_mar_dil_1".."_DilemmaChoiceMadeEvent", 
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "hkrul_mar_dil_1"
    end,
    function(context)
        local choice = context:choice()
        cm:set_saved_value("next_dilemma", "hkrul_mar_dil_2")

        if choice == 0 then    
            cm:treasury_mod("wh_main_emp_wissenland", 10000)
            add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_wissenland")
            cm:force_declare_war("wh_main_emp_wissenland","wh_main_emp_empire", true, true)
        elseif choice == 1 then
            cm:treasury_mod("wh_main_emp_nordland", 10000)
            add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_nordland")
            cm:force_declare_war("wh_main_emp_nordland","wh_main_emp_middenland", true, true)
        elseif choice == 2 then
            cm:treasury_mod("wh_main_emp_middenland", 10000)
            add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_middenland")
            cm:force_declare_war("wh_main_emp_middenland","wh_main_emp_empire", true, true)
        elseif choice == 3 then
            cm:treasury_mod("wh_main_brt_bretonnia", 10000)
            cm:force_declare_war("wh_main_brt_bretonnia","wh_main_emp_empire", true, true)
        end
    end,
    true
)

core:add_listener(
    "hkrul_mar_dil_2".."_DilemmaChoiceMadeEvent", 
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma() == "hkrul_mar_dil_2"
    end,
    function(context)
        local choice = context:choice()
        cm:set_saved_value("next_dilemma", "hkrul_mar_dil_1")

        if choice == 0 then    
            cm:treasury_mod("wh_main_emp_ostland", 10000)
            add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_ostland")
            cm:force_declare_war("wh_main_emp_ostland","wh_main_emp_middenland", true, true)
        elseif choice == 1 then
            cm:treasury_mod("wh_main_emp_talabecland", 10000)
            add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_talabecland")
            cm:force_declare_war("wh_main_emp_talabecland","wh_main_emp_empire",true, true)
        elseif choice == 2 then
            cm:treasury_mod("wh_main_emp_averland", 10000)
            add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_averland")
            cm:force_declare_war("wh_main_emp_averland","wh_main_emp_empire",true, true)
        elseif choice == 3 then
            cm:treasury_mod("wh_main_emp_empire", 10000)
            add_unit_to_faction("snek_hkrul_mar_landship", "wh_main_emp_empire")
            cm:force_declare_war("wh_main_emp_empire","wh_main_emp_nordland",true, true)
        end
    end,
    true
)        


core:add_listener(
    "rhox_mar_flood_giver", 
    "CharacterTurnStart",
    function(context)
		local marienburg_faction = cm:get_faction(marienburg_faction_key)
		if not marienburg_faction or not marienburg_faction:has_effect_bundle("hkrul_mar_ritual_voyage") then
			return false
		end
		local character = context:character()
		local character_faction = character:faction()
        return character:has_military_force() and not character:is_at_sea() and character_faction:at_war_with(marienburg_faction) and character:region() and character:region():owning_faction() and character:region():owning_faction() == marienburg_faction
		--must have militart force, and not at sea, at war with Marienburg, is in the region, region has owner, and the owner is marienburg
    end,
    function(context)
		local character = context:character()
        cm:apply_effect_bundle_to_characters_force("rhox_mar_bundle_voyage_enemy", character:command_queue_index(), 2)
    end,
    true
) 


