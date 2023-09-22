local confederation_cooldown = 20 
local confederation_ended = false



local elector_treaties_to_disable = { --this is copy from wh2_dlc13_empire_politics.lua
	"form confederation",
	"military alliance",
	"defensive alliance",
	"break soft military access",
	"break defensive alliance",
	"break vassal",
	"break client state",
	"break trade",
	"break alliance"
}


core:add_listener(
    "rhox_mar_enable_marienburg_confederation", --vanilla script disables Empire factions from making alliance and confederation with all the Empires, should make it available
    "FactionRoundStart",
    function(context)
        local faction = context:faction();

        return faction:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false
    end,
    function(context)
        local faction = context:faction();
        local faction_key = faction:name();
        cm:callback(
			function()
                for i = 1, #elector_treaties_to_disable do
                    cm:force_diplomacy("faction:"..faction_key, "faction:ovn_mar_house_den_euwe", elector_treaties_to_disable[i], true, true, false)
                    cm:force_diplomacy("faction:"..faction_key, "faction:ovn_mar_cult_of_manann", elector_treaties_to_disable[i], true, true, false)
                    cm:force_diplomacy("faction:"..faction_key, "faction:ovn_mar_house_fooger", elector_treaties_to_disable[i], true, true, false)
                end
			end,
			1--we need it to start after the vanilla script has been fired
		)
        

    end,
    true
)



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
        if cm:get_faction("wh_main_emp_marienburg"):is_human() and confederation_ended == false then
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
                             cm:trigger_dilemma_with_targets(context:faction():command_queue_index(), "rhox_mar_confederation_dilemma", confederation_faction:command_queue_index(), 0, 0, 0, 0, 0);
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

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
        cm:save_named_value("rhox_mar_confederation_cooldown", confederation_cooldown, context)
        cm:save_named_value("rhox_mar_confederation_ended", confederation_ended, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
            confederation_cooldown = cm:load_named_value("rhox_mar_confederation_cooldown", confederation_cooldown, context)
            confederation_ended = cm:load_named_value("rhox_mar_confederation_ended", confederation_ended, context)
		end
	end
)