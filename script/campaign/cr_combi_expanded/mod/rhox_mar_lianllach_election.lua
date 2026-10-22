local lianllach_faction = "cr_hef_clan_lianllach"


RHOX_MAR_LIANLLACH_ELECTION={
	base_duration=15,
	influence_incumbent_penalty=250, --extra influence lost for re-electing the previous winner
	influence_gap_factor=400, --influence lost per 1.0 share behind the leading party
	tide_min=80, --random tide multiplier range, in percent
	tide_max=120,
	building_strength=500000, --strength per building that favours a party
	dark_elf_trade_value=5, --smuggler bonus value per active trade agreement with the Dark Elves
	smuggler_required_share=0.7, --Strongbreeze only becomes a choice with at least this share
	dilemma_key="rhox_mar_lianllach_election",
	smuggler_dilemma_key="rhox_mar_lianllach_election_strongbreeze", --same choices plus FOURTH for Strongbreeze
	parties={"magic", "war", "trade", "smuggler"},
	choice_keys={"FIRST", "SECOND", "THIRD", "FOURTH"}, --same order as parties
	mage_subtype_table={
		wh2_dlc15_hef_archmage_beasts=true,
		wh2_dlc15_hef_archmage_death=true,
		wh2_dlc15_hef_archmage_fire=true,
		wh2_dlc15_hef_archmage_heavens=true,
		wh2_dlc15_hef_archmage_high=true,
		wh2_dlc15_hef_archmage_life=true,
		wh2_dlc15_hef_archmage_light=true,
		wh2_dlc15_hef_archmage_metal=true,
		wh2_dlc15_hef_archmage_shadows=true,
		wh2_main_hef_teclis=true,
		wh2_dlc10_hef_alarielle=true,
		wh2_dlc15_hef_eltharion=true
	},
	trade_subtype_table={
		mar_caravan_master=true
	},
	saved_info={
		remaining_turn=2,
		last_winner=nil, --party key of the previous election's winner
		election_ended=false --true once Strongbreeze is elected
	}
}

function RHOX_MAR_LIANLLACH_ELECTION:calculate_strength()
	local magic, war, trade, smuggler = 0, 0, 0, 0

	local faction = cm:get_faction(lianllach_faction)
	if not faction then
		return magic, war, trade, smuggler
	end
	local military_force_list = faction:military_force_list()
	for i = 0, military_force_list:num_items() - 1 do
		local military_force = military_force_list:item_at(i)
		if not military_force:is_armed_citizenry() and military_force:has_general() then
			local general = military_force:general_character()
			local subtype = general:character_subtype_key()
			local strength = military_force:strength()
			if cm:get_characters_bonus_value(general, "rhox_mar_lianllach_strongbreeze_watched") > 0 then
				--everyone is watching him, so his army counts towards every party
				magic = magic + strength
				war = war + strength
				trade = trade + strength
				smuggler = smuggler + strength
			elseif self.mage_subtype_table[subtype] then
				magic = magic + strength
			elseif self.trade_subtype_table[subtype] then
				trade = trade + strength*2 --because trade is scarace
			else
				war = war + strength
			end
		end
	end
	trade=trade+faction:income()*100

	--each building gives 1 to the scripted bonus value of its party
	local bonus_values = faction:bonus_values()
	magic = magic + bonus_values:scripted_value("rhox_mar_lianllach_faction_magic_influence", "value")*self.building_strength
	war = war + bonus_values:scripted_value("rhox_mar_lianllach_faction_war_influence", "value")*self.building_strength
	trade = trade + bonus_values:scripted_value("rhox_mar_lianllach_faction_trade_influence", "value")*self.building_strength
	smuggler = smuggler + bonus_values:scripted_value("rhox_mar_lianllach_faction_smuggler_influence", "value")*self.building_strength

	--every active trade agreement with the Dark Elves counts like smuggler bonus value
	local trading_with = faction:factions_trading_with()
	for i = 0, trading_with:num_items() - 1 do
		if trading_with:item_at(i):subculture() == "wh2_main_sc_def_dark_elves" then
			smuggler = smuggler + self.dark_elf_trade_value*self.building_strength
		end
	end

	out("Rhox Lianllach: total strength magic "..magic..", war "..war..", trade "..trade..", smuggler "..smuggler)
	return magic, war, trade, smuggler
end


--compress the strength with sqrt, optionally apply the random tide, then convert to shares
function RHOX_MAR_LIANLLACH_ELECTION:calculate_share(apply_tide)
	local magic, war, trade, smuggler = self:calculate_strength()
	local raw_strength = {magic=magic, war=war, trade=trade, smuggler=smuggler}
	local share = {}
	local total = 0
	for _, party in ipairs(self.parties) do
		local tide = 1
		if apply_tide then
			tide = cm:random_number(self.tide_max, self.tide_min)/100
		end
		share[party] = math.sqrt(raw_strength[party]) * tide
		total = total + share[party]
	end
	for _, party in ipairs(self.parties) do
		if total > 0 then
			share[party] = share[party]/total
		else
			share[party] = 1/#self.parties
		end
	end
	return share
end


function RHOX_MAR_LIANLLACH_ELECTION:hold_election()
	self.saved_info.remaining_turn=self.base_duration --reset the duration

	for _, party in ipairs(self.parties) do
		cm:remove_effect_bundle("rhox_mar_lianllach_faction_"..party, lianllach_faction)
	end

	local share = self:calculate_share(true)

	--Strongbreeze can only be elected with enough of the Council behind him
	local candidates = {}
	local smuggler_eligible = false
	for i, party in ipairs(self.parties) do
		if party ~= "smuggler" then
			table.insert(candidates, i)
		elseif share[party] >= self.smuggler_required_share then
			table.insert(candidates, i)
			smuggler_eligible = true
		end
	end

	local leading_share = 0
	for _, i in ipairs(candidates) do
		leading_share = math.max(leading_share, share[self.parties[i]])
	end

	--influence for each choice, then shift them so they sum to 0
	local influence = {}
	local influence_sum = 0
	for _, i in ipairs(candidates) do
		local party = self.parties[i]
		influence[party] = -self.influence_gap_factor*(leading_share - share[party])
		if self.saved_info.last_winner == party then
			influence[party] = influence[party] - self.influence_incumbent_penalty
		end
		influence_sum = influence_sum + influence[party]
	end
	local influence_mean = influence_sum/#candidates

	local choice_influence = {}
	local max_influence = nil
	for _, i in ipairs(candidates) do
		local party = self.parties[i]
		choice_influence[party] = math.floor(influence[party] - influence_mean + 0.5)
		if not max_influence or choice_influence[party] > max_influence then
			max_influence = choice_influence[party]
		end
	end

	--failsafe: at least one choice must not cost influence
	if max_influence < 0 then
		for _, i in ipairs(candidates) do
			local party = self.parties[i]
			choice_influence[party] = choice_influence[party] - max_influence
		end
	end

	--trigger dilemma
	local dilemma_key = self.dilemma_key
	if smuggler_eligible then
		dilemma_key = self.smuggler_dilemma_key
	end
	local dilemma_builder = cm:create_dilemma_builder(dilemma_key);
	local payload_builder = cm:create_payload();

	for _, i in ipairs(candidates) do
		local party = self.parties[i]
		local choice_payload = cm:create_new_custom_effect_bundle("rhox_mar_lianllach_faction_"..party);
		if party == "smuggler" then
			choice_payload:set_duration(0); --no more elections after Strongbreeze, so it stays
		else
			choice_payload:set_duration(15);
		end
		payload_builder:effect_bundle_to_faction(choice_payload);
		out("Rhox Lianllach: election "..party.." share "..share[party]..", influence "..choice_influence[party])
		payload_builder:influence_adjustment(choice_influence[party])
		dilemma_builder:add_choice_payload(self.choice_keys[i], payload_builder);
		payload_builder:clear()
	end

	cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction(lianllach_faction));
end


function RHOX_MAR_LIANLLACH_ELECTION:election_notification()
	local share = self:calculate_share(false) --show the shares before the random tide
	local incident_builder = cm:create_incident_builder("rhox_mar_lianllach_election_notification")
	local payload_builder = cm:create_payload();
	local payload = cm:create_new_custom_effect_bundle("rhox_mar_lianllach_election_coming");
	payload:set_duration(3);
	for _, party in ipairs(self.parties) do
		payload:add_effect("rhox_mar_lianllach_faction_"..party.."_upcoming_dummy", "faction_to_faction_own_unseen", math.floor(share[party]*100 + 0.5));
	end
	payload_builder:effect_bundle_to_faction(payload);
	incident_builder:set_payload(payload_builder)
    cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(lianllach_faction))

end




function RHOX_MAR_LIANLLACH_ELECTION:init()
	core:add_listener(
		"rhox_mar_lianllach_election_turn_count",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == lianllach_faction
		end,
		function(context)
			if self.saved_info.election_ended then
				return
			end
			self.saved_info.remaining_turn = self.saved_info.remaining_turn-1
			if self.saved_info.remaining_turn<=0 then
				self:hold_election()
			elseif self.saved_info.remaining_turn ==3 then
				self:election_notification()
			end
		end,
		true
	)

	core:add_listener(
		"rhox_mar_lianllach_election_choice",
		"DilemmaChoiceMadeEvent",
		function(context)
			local dilemma = context:dilemma()
			return (dilemma == self.dilemma_key or dilemma == self.smuggler_dilemma_key) and context:faction():name() == lianllach_faction
		end,
		function(context)
			local choice_key = context:choice_key()
			for i, key in ipairs(self.choice_keys) do
				if key == choice_key then
					self.saved_info.last_winner = self.parties[i]
					if self.parties[i] == "smuggler" then
						self.saved_info.election_ended = true
						cm:remove_effect_bundle("rhox_mar_lianllach_smuggler_dealings", lianllach_faction) --no use after the coup
						cm:trigger_incident(lianllach_faction, "rhox_mar_lianllach_strongbreeze_coup", true)
					end
					break
				end
			end
		end,
		true
	)
end


cm:add_first_tick_callback(
	function()
		if cm:get_local_faction_name() == lianllach_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            core:get_or_create_component("rhox_mar_lianllach_faction_effect", "ui/campaign ui/rhox_mar_lianllach_faction_effect.twui.xml", parent_ui)
        end
		if cm:get_faction(lianllach_faction):is_human() then
        	RHOX_MAR_LIANLLACH_ELECTION:init()
		end
	end
)


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_mar_lianllach_election_saved_info", RHOX_MAR_LIANLLACH_ELECTION.saved_info, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
            RHOX_MAR_LIANLLACH_ELECTION.saved_info = cm:load_named_value("rhox_mar_lianllach_election_saved_info", RHOX_MAR_LIANLLACH_ELECTION.saved_info, context)
		end
	end
)
