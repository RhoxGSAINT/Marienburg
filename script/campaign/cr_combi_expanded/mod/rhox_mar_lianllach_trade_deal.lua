local faction_key = "cr_hef_clan_lianllach"
local secret_pact_duration = 10
local secret_pact_bonus = 5000


local trade_secret_pact={} --target faction key -> remaining turns
local pending_trade_dilemma={} --target faction keys waiting for the dilemma choice, in launch order
local smuggler_dealings_count = 0 --how many times FOURTH was chosen, value of the smuggler dealings bundle

core:add_listener(
    "rhox_mar_lianllach_trade_deal_made",
    "PositiveDiplomaticEvent",
    function(context)
        return (context:recipient():name() == faction_key or context:proposer():name() == faction_key) and context:is_trade_agreement() and cm:get_faction(faction_key):is_human()
    end,
    function(context)
		local target_faction_key = context:recipient():name()
		if target_faction_key == faction_key then
			target_faction_key = context:proposer():name()
		end
		local target_faction = cm:get_faction(target_faction_key)
        --trigger dilemma
		local dilemma_builder = cm:create_dilemma_builder("rhox_mar_lianllach_trade_deal");
		local payload_builder = cm:create_payload();
		payload_builder:diplomatic_attitude_adjustment(target_faction, 1)
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear()

		payload_builder:treasury_adjustment(2000);
		payload_builder:diplomatic_attitude_adjustment(target_faction, -1)
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear()

		payload_builder:text_display("rhox_mar_lianllach_pact_break_bonus");
		dilemma_builder:add_choice_payload("THIRD", payload_builder);
		payload_builder:clear()

		if not RHOX_MAR_LIANLLACH_ELECTION.saved_info.election_ended then --no smuggler choice after the coup
			--the same bundle is re-applied with a higher value, so the smuggler influence goes up by 1 each time
			payload_builder:treasury_adjustment(-2000);
			local dealings_bundle = cm:create_new_custom_effect_bundle("rhox_mar_lianllach_smuggler_dealings");
			dealings_bundle:add_effect("rhox_mar_lianllach_faction_smuggler_influence", "faction_to_faction_own_unseen", smuggler_dealings_count + 1);
			dealings_bundle:set_duration(0);
			payload_builder:effect_bundle_to_faction(dealings_bundle);
			dilemma_builder:add_choice_payload("FOURTH", payload_builder);
		end

        dilemma_builder:add_target("default", target_faction);

		table.insert(pending_trade_dilemma, target_faction_key)
        cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction(faction_key));
    end,
    true
)

core:add_listener(
	"rhox_mar_lianllach_trade_deal_choice",
	"DilemmaChoiceMadeEvent",
	function(context)
		return context:dilemma() == "rhox_mar_lianllach_trade_deal" and context:faction():name() == faction_key
	end,
	function(context)
		local target_faction_key = table.remove(pending_trade_dilemma, 1)
		if not target_faction_key then
			return
		end
		if context:choice() == 2 then --THIRD (0-based)
			trade_secret_pact[target_faction_key] = secret_pact_duration
		else
			trade_secret_pact[target_faction_key] = nil
		end
		if context:choice_key() == "FOURTH" then
			smuggler_dealings_count = smuggler_dealings_count + 1
		end
	end,
	true
)

core:add_listener(
	"rhox_mar_lianllach_trade_turn_count",
	"FactionTurnStart",
	function(context)
		return context:faction():name() == faction_key
	end,
	function(context)
		for key, _ in pairs(trade_secret_pact) do
			trade_secret_pact[key]=trade_secret_pact[key]-1
			if trade_secret_pact[key] <= 0 then
				trade_secret_pact[key] = nil
			end
		end
	end,
	true
)


core:add_listener(
	"rhox_mar_lianllach_trade_pact_broken",
	"NegativeDiplomaticEvent",
	function(context)
		return context:proposer():name() == faction_key and context:was_trade_agreement()
	end,
	function(context)
		local target_faction_key = context:recipient():name()

		if not trade_secret_pact[target_faction_key] then
			return
		end
		trade_secret_pact[target_faction_key] = nil

		local target_faction = cm:get_faction(target_faction_key)

		local incident_builder = cm:create_incident_builder("rhox_mar_lianllach_trade_pact_broken")
        incident_builder:add_target("default", target_faction)

        local payload_builder = cm:create_payload()
		payload_builder:treasury_adjustment(secret_pact_bonus);
		payload_builder:diplomatic_attitude_adjustment(target_faction, -5)
		incident_builder:set_payload(payload_builder)
		cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(faction_key))
	end,
	true
)


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mar_lianllach_trade_secret_pact", trade_secret_pact, context)
		cm:save_named_value("rhox_mar_lianllach_pending_trade_dilemma", pending_trade_dilemma, context)
		cm:save_named_value("rhox_mar_lianllach_smuggler_dealings_count", smuggler_dealings_count, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
            trade_secret_pact = cm:load_named_value("rhox_mar_lianllach_trade_secret_pact", {}, context)
            pending_trade_dilemma = cm:load_named_value("rhox_mar_lianllach_pending_trade_dilemma", {}, context)
            smuggler_dealings_count = cm:load_named_value("rhox_mar_lianllach_smuggler_dealings_count", 0, context)
		end
	end
)
