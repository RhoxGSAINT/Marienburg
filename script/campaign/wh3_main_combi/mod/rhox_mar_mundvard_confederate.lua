local mundvard_mission_key = "rhox_mar_vmp_mission_confederate_lord_mundvard"
local mundvard_ritual_key = "rhox_mar_vmp_ritual_confederate_lord_mundvard"
local mundvard_faction_key = "ovn_mar_the_wasteland"

local mundvard_mission_data = {
			target_faction = mundvard_faction_key,
			ritual_key = mundvard_ritual_key,
			lord_subtype = "hkrul_mar_munvard",
			limit_power_objective = true,
			payload = {
				"text_display dummy_confederate_lord_mundvard"
			},
			unique_objectives_config = {
				unit_count = 10,
				unit_rank = 0, -- no veteran requirement
				unit_list = {
					"wh2_dlc11_vmp_inf_crossbowmen",
					"wh2_dlc11_vmp_inf_handgunners"
				},
				scripted_unit_key = "rhox_mar_vmp_scripted_mundvard_gunpowder_units",
				unit_override_text = "mission_text_text_rhox_mar_vmp_mundvard_gunpowder_units",

				trade_count = 5,
				scripted_trade_key = "rhox_mar_vmp_scripted_mundvard_trade_agreements",
				trade_override_text = "mission_text_text_rhox_mar_vmp_mundvard_trade_agreements",
			},

			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_data = mission_data.unique_objectives_config

				local objectives = {
					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_unit_key,
						objective_data.unit_override_text,
						objective_data.unit_count,
						0,
						false
					),

					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_trade_key,
						objective_data.trade_override_text,
						objective_data.trade_count,
						0,
						false
					),
				}

				vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
			end,

			post_trigger_callback = function(faction_key, mission_data, mission_key)
				vampire_bloodlines:rhox_update_mundvard_confederation_objectives(faction_key)
			end
		}

-- Only register the confederation when Mundvard's faction exists in this campaign (vanilla setup errors on a missing target faction)
-- Pre first tick runs before vampire_bloodlines:initialise(), which issues the confederation missions on a new game
cm:add_pre_first_tick_callback(
	function()
		if not vampire_bloodlines or not cm:get_faction(mundvard_faction_key) then
			return
		end

		vampire_bloodlines.confederation_missions[mundvard_mission_key] = mundvard_mission_data
		vampire_bloodlines.confederation_rituals[mundvard_ritual_key] = mundvard_faction_key
	end
)

function vampire_bloodlines:rhox_update_mundvard_confederation_objectives(faction_key)
	local mission_data = self.confederation_missions[mundvard_mission_key]
	local objective_data = mission_data.unique_objectives_config
	local faction = cm:get_faction(faction_key)

	if not faction or faction:is_null_interface() then
		return
	end

	-- Crossbowmen / Handgunners

	local units_completed_saved_value_key = faction_key .. "_mundvard_confederation_units_completed"
	local units_completed = cm:get_saved_value(units_completed_saved_value_key) or false

	if not units_completed then
		local current_unit_count = math.min(
			self:count_units_from_list_with_min_rank(
				faction,
				objective_data.unit_list,
				objective_data.unit_rank
			),
			objective_data.unit_count
		)

		cm:set_scripted_mission_text(
			mundvard_mission_key,
			objective_data.scripted_unit_key,
			objective_data.unit_override_text,
			current_unit_count,
			objective_data.unit_count
		)

		if current_unit_count >= objective_data.unit_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				mundvard_mission_key,
				objective_data.scripted_unit_key,
				true
			)

			cm:set_saved_value(units_completed_saved_value_key, true)
		end
	end

	-- Trade agreements

	local trade_completed_saved_value_key = faction_key .. "_mundvard_confederation_trade_completed"
	local trade_completed = cm:get_saved_value(trade_completed_saved_value_key) or false

	if not trade_completed then
		local current_trade_count = math.min(
			faction:factions_trading_with():num_items(),
			objective_data.trade_count
		)

		cm:set_scripted_mission_text(
			mundvard_mission_key,
			objective_data.scripted_trade_key,
			objective_data.trade_override_text,
			current_trade_count,
			objective_data.trade_count
		)

		if current_trade_count >= objective_data.trade_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				mundvard_mission_key,
				objective_data.scripted_trade_key,
				true
			)

			cm:set_saved_value(trade_completed_saved_value_key, true)
		end
	end
end

local function is_valid_mundvard_confederation_faction(faction)
	local mission_data = vampire_bloodlines.confederation_missions[mundvard_mission_key]
	if not mission_data then
		return false
	end
	local target_faction = cm:get_faction(mission_data.target_faction)

	return faction
		and faction:is_null_interface() == false
		and faction:is_human()
		and faction:subculture() == "wh_main_sc_vmp_vampire_counts"
		and faction:name() ~= mission_data.target_faction
		and target_faction
		and target_faction:is_human() == false
end

-- Mundvard - Update when a unit is created
core:add_listener(
	"RhoxVampireBloodlinesMundvardUnitCreated",
	"UnitCreated",
	function(context)
		local unit = context:unit()

		return is_valid_mundvard_confederation_faction(unit:faction())
			and table.contains(mundvard_mission_data.unique_objectives_config.unit_list, unit:unit_key())
	end,
	function(context)
		local faction_key = context:unit():faction():name()

		cm:callback(
			function()
				vampire_bloodlines:rhox_update_mundvard_confederation_objectives(faction_key)
			end,
			0.1
		)
	end,
	true
)

-- Mundvard - Update after a trade agreement is signed
core:add_listener(
	"RhoxVampireBloodlinesMundvardTradeAgreement",
	"PositiveDiplomaticEvent",
	function(context)
		return context:is_trade_agreement()
			and (is_valid_mundvard_confederation_faction(context:proposer()) or is_valid_mundvard_confederation_faction(context:recipient()))
	end,
	function(context)
		local faction_key = nil

		if is_valid_mundvard_confederation_faction(context:proposer()) then
			faction_key = context:proposer():name()
		else
			faction_key = context:recipient():name()
		end

		cm:callback(
			function()
				vampire_bloodlines:rhox_update_mundvard_confederation_objectives(faction_key)
			end,
			0.1
		)
	end,
	true
)

-- Mundvard - Fallback/state refresh
core:add_listener(
	"RhoxVampireBloodlinesMundvardTurnStartUpdate",
	"FactionTurnStart",
	function(context)
		return is_valid_mundvard_confederation_faction(context:faction())
	end,
	function(context)
		vampire_bloodlines:rhox_update_mundvard_confederation_objectives(context:faction():name())
	end,
	true
)
