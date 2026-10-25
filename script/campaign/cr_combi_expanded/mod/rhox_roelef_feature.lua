local roelef_faction = "mixer_emp_house_de_roelef"

-- Resource types whose buildings grant a per-type cargo value bundle
local rhox_roelef_cargo_resources = {
    "animals", "dyes", "gems", "gold", "ivory", "medicine", "obsidian", "spices",
    "furs", "iron", "salt", "marble", "pastures", "pottery", "timber", "wine"
}

local function rhox_roelef_update_resource_cargo(faction)
    for _, resource in ipairs(rhox_roelef_cargo_resources) do
        local bundle_key = "rhox_mar_roelef_cargo_" .. resource
        local has_resource = cm:get_factions_bonus_value(faction, "rhox_mar_roelef_supply_" .. resource) > 0
        if has_resource and not faction:has_effect_bundle(bundle_key) then
            cm:apply_effect_bundle(bundle_key, roelef_faction, 0)
        elseif not has_resource and faction:has_effect_bundle(bundle_key) then
            cm:remove_effect_bundle(bundle_key, roelef_faction)
        end
    end
end


-- Poaching contracts: one mission per resource, shown in the ogre contract panel
RHOX_ROELEF_CONTRACT = {
    faction_key = roelef_faction,
    mission_prefix = "rhox_mar_roelef_contract_",
    saved_target_prefix = "rhox_roelef_contract_target_",
    resource_keys = {
        animals = "res_animals",
        dyes = "res_dyes",
        gems = "res_gems",
        gold = "res_gold",
        ivory = "res_ivory",
        medicine = "res_medicine",
        obsidian = "res_obsidian",
        spices = "res_spices",
        furs = "res_rom_furs",
        iron = "res_rom_iron",
        salt = "res_rom_lead",
        marble = "res_rom_marble",
        pastures = "res_rom_oil",
        pottery = "res_rom_textiles",
        timber = "res_rom_timber",
        wine = "res_rom_wine"
    },
    weight_not_owned = 3,
    weight_owned = 1,
    num_contracts = 3,
    reward_experience = 2000,
    turn_to_issue_contracts = 1
}

function RHOX_ROELEF_CONTRACT:get_origin(faction)
    if faction:has_faction_leader() and faction:faction_leader():has_military_force() then
        local leader = faction:faction_leader()
        return leader:logical_position_x(), leader:logical_position_y()
    elseif faction:has_home_region() then
        local capital = faction:home_region():settlement()
        return capital:logical_position_x(), capital:logical_position_y()
    end
    return nil
end

-- Closest region holding the resource that belongs to a faction other than Roelef or its vassals
function RHOX_ROELEF_CONTRACT:find_target_region(faction, resource_key, pos_x, pos_y)
    local region_list = cm:model():world():region_manager():region_list()
    local closest_distance = false
    local chosen_region = false

    for i = 0, region_list:num_items() - 1 do
        local region = region_list:item_at(i)
        if not region:is_abandoned() and region:resource_exists(resource_key) then
            local owner = region:owning_faction()
            if owner:name() ~= self.faction_key and not owner:is_vassal_of(faction) then
                local settlement = region:settlement()
                local distance = distance_squared(settlement:logical_position_x(), settlement:logical_position_y(), pos_x, pos_y)
                if not closest_distance or distance < closest_distance then
                    closest_distance = distance
                    chosen_region = region
                end
            end
        end
    end

    return chosen_region, closest_distance
end

function RHOX_ROELEF_CONTRACT:pick_resource(faction, pos_x, pos_y)
    local candidates = {}
    local total_weight = 0

    for resource, resource_key in pairs(self.resource_keys) do
        if not cm:get_saved_value(self.saved_target_prefix .. resource) then
            local region, distance = self:find_target_region(faction, resource_key, pos_x, pos_y)
            if region then
                local weight = self.weight_owned
                if cm:get_factions_bonus_value(faction, "rhox_mar_roelef_supply_" .. resource) <= 0 then
                    weight = self.weight_not_owned
                end
                total_weight = total_weight + weight
                table.insert(candidates, {resource = resource, region = region, distance = distance, weight = weight})
            end
        end
    end

    if total_weight == 0 then
        return nil
    end

    local roll = cm:random_number(total_weight)
    for _, candidate in ipairs(candidates) do
        roll = roll - candidate.weight
        if roll <= 0 then
            return candidate
        end
    end
    return candidates[#candidates]
end

function RHOX_ROELEF_CONTRACT:issue_contract(candidate)
    local region = candidate.region
    local region_key = region:name()
    local owner = region:owning_faction()
    local money = math.max(math.floor(owner:treasury() / 5) + 500, 1650) * 2

    local payload = "money " .. money .. ";" ..
                    "diplomacy_change{" ..
                        "target_faction " .. owner:name() .. ";" ..
                        "attitude_adjustement -5;" ..
                    "}"

    cm:set_saved_value(self.saved_target_prefix .. candidate.resource, region_key)

    cm:trigger_custom_mission_from_string(
        self.faction_key,
        "mission{" ..
            "key " .. self.mission_prefix .. candidate.resource .. ";" ..
            "issuer CLAN_ELDERS;" ..
            "turn_limit " .. math.max(math.min(math.round(candidate.distance / 1000) * 2, 30), 10) .. ";" ..
            "primary_objectives_and_payload{" ..
                "objective{" ..
                    "type MOVE_TO_REGION;" ..
                    "region " .. region_key .. ";" ..
                "}" ..
                "payload{" ..
                    payload ..
                "}" ..
            "}" ..
        "}"
    )
end

function RHOX_ROELEF_CONTRACT:attempt_to_issue_contracts(faction, num_contracts)
    local pos_x, pos_y = self:get_origin(faction)
    if not pos_x then
        return
    end

    for i = 1, num_contracts do
        local candidate = self:pick_resource(faction, pos_x, pos_y)
        if not candidate then
            return
        end
        self:issue_contract(candidate)
    end
end

function RHOX_ROELEF_CONTRACT:get_resource_from_mission(mission_key)
    if string.sub(mission_key, 1, #self.mission_prefix) ~= self.mission_prefix then
        return nil
    end
    return string.sub(mission_key, #self.mission_prefix + 1)
end

-- Every general standing in the target region shares the contract experience
function RHOX_ROELEF_CONTRACT:reward_generals(faction, region_key)
    local mf_list = faction:military_force_list()
    for i = 0, mf_list:num_items() - 1 do
        local mf = mf_list:item_at(i)
        if mf:has_general() and not mf:is_armed_citizenry() then
            local general = mf:general_character()
            if general:has_region() and general:region():name() == region_key then
                cm:add_agent_experience(cm:char_lookup_str(general), self.reward_experience)
            end
        end
    end
end

-- The faction leader is sent back to the capital if they completed the contract in person
function RHOX_ROELEF_CONTRACT:return_faction_leader(faction, region_key)
    if not faction:has_faction_leader() or not faction:has_home_region() then
        return
    end
    local leader = faction:faction_leader()
    if not leader:has_military_force() or not leader:has_region() or leader:region():name() ~= region_key then
        return
    end
    local x, y = cm:find_valid_spawn_location_for_character_from_settlement(self.faction_key, faction:home_region():name(), false, true, 5)
    if x > -1 then
        cm:teleport_to(cm:char_lookup_str(leader), x, y)
    end
end

function RHOX_ROELEF_CONTRACT:setup()
    common.set_context_value("rhox_roelef_bounties_turn_start", self.turn_to_issue_contracts)

    core:add_listener(
        "rhox_roelef_issue_contracts",
        "FactionTurnStart",
        function(context)
            return cm:model():turn_number() >= self.turn_to_issue_contracts and context:faction():name() == self.faction_key
        end,
        function(context)
            local faction = context:faction()
            local number_of_active_contracts = faction:active_missions("OgreContract", true):num_items()
            if number_of_active_contracts < self.num_contracts then
                self:attempt_to_issue_contracts(faction, self.num_contracts - number_of_active_contracts)
            end
        end,
        true
    )

    core:add_listener(
        "rhox_roelef_contract_succeeded",
        "MissionSucceeded",
        function(context)
            return context:faction():name() == self.faction_key and self:get_resource_from_mission(context:mission():mission_record_key()) ~= nil
        end,
        function(context)
            local resource = self:get_resource_from_mission(context:mission():mission_record_key())
            local region_key = cm:get_saved_value(self.saved_target_prefix .. resource)
            if region_key then
                self:reward_generals(context:faction(), region_key)
                self:return_faction_leader(context:faction(), region_key)
            end
            cm:set_saved_value(self.saved_target_prefix .. resource, false)
        end,
        true
    )

    core:add_listener(
        "rhox_roelef_contract_ended",
        "MissionFailed",
        function(context)
            return context:faction():name() == self.faction_key and self:get_resource_from_mission(context:mission():mission_record_key()) ~= nil
        end,
        function(context)
            cm:set_saved_value(self.saved_target_prefix .. self:get_resource_from_mission(context:mission():mission_record_key()), false)
        end,
        true
    )

    core:add_listener(
        "rhox_roelef_contract_cancelled",
        "MissionCancelled",
        function(context)
            return context:faction():name() == self.faction_key and self:get_resource_from_mission(context:mission():mission_record_key()) ~= nil
        end,
        function(context)
            cm:set_saved_value(self.saved_target_prefix .. self:get_resource_from_mission(context:mission():mission_record_key()), false)
        end,
        true
    )
end


cm:add_first_tick_callback(
    function()
        core:add_listener(
            "rhox_roelef_resource_cargo",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == roelef_faction
            end,
            function(context)
                rhox_roelef_update_resource_cargo(context:faction())
            end,
            true
        )

        if cm:get_local_faction_name(true) == roelef_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management")
            local result = core:get_or_create_component("rhox_roelef_button_contracts", "ui/campaign ui/rhox_roelef_contract.twui.xml", parent_ui)
            if result then
                result:SetVisible(true)
                result:SetContextObject(cco("CcoCampaignFaction", roelef_faction))
                result:SetTooltipText(common.get_localised_string("rhox_mar_roelef_contract_button_tooltip"), true)
            else
                script_error("Rhox Roelef: could not create contract ui component")
            end
        end

        local faction = cm:get_faction(roelef_faction)
        if faction and faction:is_human() then
            RHOX_ROELEF_CONTRACT:setup()
        end
    end
)
