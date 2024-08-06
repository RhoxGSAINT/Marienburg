
--Egmond chaos corruption

if not campaign_traits.trait_exclusions["faction"]["wh2_main_trait_corrupted_chaos"] then
    campaign_traits.trait_exclusions["faction"]["wh2_main_trait_corrupted_chaos"] = {}
end
if not campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_khorne"] then
    campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_khorne"] = {}
end
if not campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_nurgle"] then
    campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_nurgle"] = {}
end
if not campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"] then
    campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"] = {}
end
if not campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_tzeentch"] then
    campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_tzeentch"] = {}
end
table.insert(campaign_traits.trait_exclusions["faction"]["wh2_main_trait_corrupted_chaos"],"ovn_mar_house_den_euwe") --so Egmong shouldn't get it. Do it regardless Egmond is human or not
table.insert(campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_khorne"],"ovn_mar_house_den_euwe")
table.insert(campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_nurgle"],"ovn_mar_house_den_euwe")
table.insert(campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"],"ovn_mar_house_den_euwe")
table.insert(campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_tzeentch"],"ovn_mar_house_den_euwe")


imperial_authority.campaign_factions.main_warhammer["wh_main_emp_marienburg"]={settlement_culture = "wh_main_emp_empire", active = true}
imperial_authority.campaign_factions.main_warhammer["ovn_mar_house_den_euwe"]={settlement_culture = "wh_main_emp_empire", active = false}
if vfs.exists("script/frontend/mod/cr_iee_campaign_frontend.lua") then
    imperial_authority.campaign_factions.main_warhammer["ovn_mar_cult_of_manann"]={settlement_culture = "wh_main_emp_empire", active = false}
    imperial_authority.campaign_factions.main_warhammer["ovn_mar_house_fooger"]={settlement_culture = "wh_main_emp_empire", active = false}
end


--LL defeat trait
cm:add_first_tick_callback(
	function()
		campaign_traits.legendary_lord_defeated_traits["hkrul_mar_egmond"] ="hkrul_defeated_trait_egmond"
		campaign_traits.legendary_lord_defeated_traits["hkrul_hendrik"] ="hkrul_defeated_trait_hendrik"
		campaign_traits.legendary_lord_defeated_traits["hkrul_jk"] ="hkrul_defeated_trait_jk"
		campaign_traits.legendary_lord_defeated_traits["hkrul_mar_munvard"] ="hkrul_defeated_trait_munvard"
		campaign_traits.legendary_lord_defeated_traits["hkrul_dauphine"] ="hkrul_defeated_trait_dauphine"
		campaign_traits.legendary_lord_defeated_traits["hkrul_fooger"] ="hkrul_defeated_trait_fooger"
	end
)

local deneuwe_faction_key = "ovn_mar_house_den_euwe"
----------------------Aekold
table.insert(character_unlocking.character_data["aekold"]["override_allowed_factions"]["main_warhammer"], deneuwe_faction_key)--Hero thing
table.insert(character_unlocking.character_data["aekold"]["mission_chain_keys"]["main_warhammer"], "rhox_egmond_aekold_helbrass_stage_1")
character_unlocking.character_data["aekold"]["mission_keys"][deneuwe_faction_key]={}
character_unlocking.character_data["aekold"]["mission_keys"][deneuwe_faction_key]["main_warhammer"]="rhox_egmond_aekold_helbrass_stage_1"


----------------Ulrika
local mar_factions={
    wh_main_emp_marienburg=true,
    ovn_mar_house_den_euwe=true,
    ovn_mar_cult_of_manann=true,
    ovn_mar_house_fooger=true
}



cm:add_first_tick_callback(
	function()
        for mar_faction_key, _ in pairs(mar_factions) do
            
            local mar_faction = cm:get_faction(mar_faction_key)
            if mar_faction and mar_faction:is_human() then
                if cm:is_new_game() then 
                    --out("Rhox mar: Locking Vanilla Ulrika mission")
                    character_unlocking.character_data["ulrika"].factions_involved[mar_faction_key] = true --this will make vanilla script not trigger Ulrika mission chain
                end
                cm:add_faction_turn_start_listener_by_name(
                    "rhox_mar_ulrika_trigger_listner",
                    mar_faction_key,
                    function(context)
                        local faction = context:faction()
                        local faction_name = faction:name()

                        if cm:get_saved_value("rhox_mar_ulrika_triggered_"..mar_faction_key) ~=true and faction:faction_leader():rank() >= 11 then
                            out("Rhox Mar: triggering mission!")
                            cm:set_saved_value("rhox_mar_ulrika_triggered_"..mar_faction_key, true)
                            
                            local mm = mission_manager:new(faction_name, "wh3_dlc23_ie_emp_ulrika_stage_1")
                            mm:add_new_objective("CONSTRUCT_N_BUILDINGS_INCLUDING");
                            mm:add_condition("faction " .. faction_name);
                            
                            
                            local building_level = "rhox_mar_emp_garrison_1"
                            
                            mm:add_condition("building_level " .. building_level);
                            mm:add_condition("total 1");
                            mm:add_payload("text_display dummy_mission_1_ulrika");
                            mm:trigger() 
                        end
                    end,
                    true
                )
                
                core:add_listener(
                    "rhox_mar_ulrica_listener",
                    "MissionSucceeded",
                    function(context)
                        local faction = context:faction()
                        local faction_name = faction:name()
                        return context:mission():mission_record_key() == "wh3_dlc23_ie_emp_ulrika_stage_1" and mar_factions[faction_name]
                    end,
                    function(context)
                        local faction = context:faction()
                        local faction_name = faction:name()
                        cm:trigger_mission(faction_name, "wh3_dlc23_ie_emp_ulrika_stage_2", true)
                    end,
                    false
                );
            end
        end
	end
);
