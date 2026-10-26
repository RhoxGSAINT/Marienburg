-- Factions handled by the Marienburg mod. empire: Empire-culture faction, iee_only: exists only in IEE
RHOX_MAR_FACTIONS = {
    wh_main_emp_marienburg = {empire = true, iee_only = false},
    ovn_mar_house_den_euwe = {empire = true, iee_only = false},
    ovn_mar_cult_of_manann = {empire = true, iee_only = true},
    ovn_mar_house_fooger = {empire = true, iee_only = true},
    mixer_emp_house_de_roelef = {empire = true, iee_only = true},
    cr_hef_clan_lianllach = {empire = false, iee_only = true}
}


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


local rhox_mar_iee_exists = vfs.exists("script/frontend/mod/cr_iee_campaign_frontend.lua")
for faction_key, data in pairs(RHOX_MAR_FACTIONS) do
    if data.empire and (rhox_mar_iee_exists or not data.iee_only) then
        imperial_authority.campaign_factions.main_warhammer[faction_key]={settlement_culture = "wh_main_emp_empire", active = faction_key == "wh_main_emp_marienburg"}
    end
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
character_unlocking.character_data["aekold"]["starting_mission_keys"][deneuwe_faction_key]={}
character_unlocking.character_data["aekold"]["starting_mission_keys"][deneuwe_faction_key]["main_warhammer"]="rhox_egmond_aekold_helbrass_stage_1"



local mundvard = {
    key = "ovn_mar_the_wasteland",
    first_lair = "wh3_main_combi_region_eilhart",
    lair_pools = {
        {key = "close", distance = 35000, lair_count = 1}, -- Distance set at the value at which at least 50 regions are within range
        {key = "medium", distance = 240000, lair_count = 2}, -- Distance set at the value at which 50% of all regions are within range
        {key = "far", distance = 400000, lair_count = 3}, -- Distance set at the value at which 75% of all region are within range
        {key = "random", distance = 9999999, lair_count = 4}, -- All regions are valid at this distance
    }
}

table.insert(vampire_lairs.lair_spawning_data.factions, mundvard)	

table.insert(vampire_technology.locked_techs_necromancers.factions, "ovn_mar_the_wasteland")
table.insert(vampire_technology.locked_techs_necromancers.factions, "ovn_mar_the_wasteland")


table.insert(vampire_technology.starting_vampire_techs, {faction = "ovn_mar_the_wasteland", tech = "wh3_main_tech_vmp_vampires_main_1"})
table.insert(vampire_technology.starting_vampire_techs, {faction = "ovn_mar_the_wasteland", tech = "wh3_main_tech_vmp_vampires_main_2"})
table.insert(vampire_technology.starting_necromancer_techs, {faction = "ovn_mar_the_wasteland", tech = "wh3_main_tech_vmp_necromancers_0"})





----------------Ulrika



cm:add_first_tick_callback(
	function()
        for mar_faction_key, data in pairs(RHOX_MAR_FACTIONS) do
            
            local mar_faction = cm:get_faction(mar_faction_key)
            if data.empire and mar_faction and mar_faction:is_human() then
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
                        return context:mission():mission_record_key() == "wh3_dlc23_ie_emp_ulrika_stage_1" and RHOX_MAR_FACTIONS[faction_name] and RHOX_MAR_FACTIONS[faction_name].empire
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
