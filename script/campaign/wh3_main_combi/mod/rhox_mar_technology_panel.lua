--[[ --we should touch this after the chorf

local new_tech_list={
    ["tech_rhox_mar_rijkers_isle"]=true,
    ["tech_rhox_mar_temple_district"]=true,
    ["tech_rhox_mar_temple_district_2"]=true,
    ["tech_rhox_mar_mananns_haven"]=true,
    ["tech_rhox_mar_the_flats"]=true,
    ["tech_rhox_mar_old_money_ward_1"]=true,
    ["tech_rhox_mar_old_money_ward_2"]=true,
    ["tech_rhox_mar_old_money_ward_3"]=true,
    ["tech_rhox_mar_elf_town_1"]=true,
    ["tech_rhox_mar_elf_town_2"]=true,
    ["tech_rhox_mar_riddra_isle"]=true,
    ["tech_rhox_mar_norscan_town"]=true,
    ["tech_rhox_mar_craftsmarket_1"]=true,
    ["tech_rhox_mar_dead_canal_1"]=true,
    ["tech_rhox_mar_north_wall_1"]=true,
    ["tech_rhox_mar_arabtown"]=true,
    ["tech_rhox_mar_treasurehoem"]=true,
    ["tech_rhox_mar_guilderfield"]=true,
    ["tech_rhox_mar_stoessel_isle"]=true,
    ["tech_rhox_mar_south_dock_1"]=true,
    ["tech_rhox_mar_craftsmarket_2"]=true,
    ["tech_rhox_mar_dead_canal_2"]=true,
    ["tech_rhox_mar_north_wall_2"]=true,
    ["tech_rhox_mar_dealers_market_1"]=true,
    ["tech_rhox_mar_nippon_town"]=true,
    ["tech_rhox_mar_palace_district"]=true,
    ["tech_rhox_mar_hightower_isle"]=true,
    ["tech_rhox_mar_luydenhoek_isle"]=true,
    ["tech_rhox_mar_south_dock_2"]=true,
    ["tech_rhox_mar_craftsmarket_3"]=true,
    ["tech_rhox_mar_dead_canal_3"]=true,
    ["tech_rhox_mar_knife_alley"]=true,
    ["tech_rhox_mar_dealers_market_2"]=true,
    ["tech_rhox_mar_silk_market"]=true,
    ["tech_rhox_mar_gold_mound"]=true,
    ["tech_rhox_mar_dwarfs_hold"]=true,
    ["tech_rhox_mar_little_moot"]=true,
    ["tech_rhox_mar_east_wall_1"]=true,
    ["tech_rhox_mar_east_wall_2"]=true,
    ["tech_rhox_mar_indic_district"]=true,
    ["tech_rhox_mar_luigis_town"]=true,
    ["tech_rhox_mar_kislevan_way"]=true,
    ["tech_rhox_mar_remas_way"]=true,
    ["tech_rhox_mar_porters_wall_1"]=true,
    ["tech_rhox_mar_wine_sack"]=true,
    ["tech_rhox_mar_rijks_gate_1"]=true,
    ["tech_rhox_mar_rijks_gate_2"]=true,
    ["tech_rhox_mar_rijks_gate_3"]=true,
    ["tech_rhox_mar_north_miragliano"]=true,
    ["tech_rhox_mar_porters_wall_2"]=true,
    ["tech_rhox_mar_deedesveld"]=true,
    ["tech_rhox_mar_heiligdom"]=true
}

core:add_listener(
	"rhox_mar_technology_panel_open",
	"PanelOpenedCampaign",
	function(context)	
        return context.string == "technology_panel" and cm:get_local_faction_name(true) == "wh_main_emp_marienburg"
	end,
	function()
        local parent_ui = find_uicomponent(core:get_ui_root(), "technology_panel", "technology_list", "list_clip", "list_box", "tech_template");
        if not parent_ui then
            return --to prevent script break
        end
        local group_ui = find_uicomponent(parent_ui, "building_group_parent");
        group_ui:SetVisible(false) --It's UI We don't want to see this
        
        local technology_parent = find_uicomponent(parent_ui, "tree_parent", "slot_parent");
        local arrow_parent = find_uicomponent(parent_ui, "tree_parent", "branch_parent");
        cm:callback(
			function()
--remove all the nodes and arrows and links that are not in the Marienburg one
                local total_nodes = technology_parent:ChildCount()
                for i=0,total_nodes-1 do
                    local node = find_child_uicomponent_by_index(technology_parent, i)
                    local tech_key = node:Id()
                    local node_key = tech_key:gsub( "_ovn_", "_rhox_")--this because tech key and node key is different
                    --out("Rhox Mar: Node Id: "..node_key)
                    if not new_tech_list[node_key] then
                        --out("Rhox Mar: Setting this node invisible")
                        node:SetVisible(false)
                    end
                end
                
                local total_arrows = arrow_parent:ChildCount()
                for i=0,total_arrows-1 do
                    local arrow = find_child_uicomponent_by_index(arrow_parent, i)
                    local parent_node = arrow:GetContextObject("CcoTreeLink")
                    local parent_node_key = parent_node:Call("ParentContext.NodeKey")
                    if not new_tech_list[parent_node_key] then
                        arrow:SetVisible(false)
                    end
                    --out("Rhox Mar: "..tostring(i).."th value: "..tostring(parent_node_key))
                end
                
            end,
            0.1
        )
	end,
	true
)

--]]