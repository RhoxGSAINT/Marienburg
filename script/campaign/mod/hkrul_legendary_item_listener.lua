--mundavard
core:add_listener(
    "hkrul_mundvard_item1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_mar_munvard") and character:rank() >= 7 and faction:ancillary_exists("hkrul_mundvard_artifact_wsoran") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mundvard_artifact_wsoran",
            true,
            false
        )
    end,
    false
) 
    

core:add_listener(
    "hkrul_mundvard_item2_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_mar_munvard") and character:rank() >= 15 and faction:ancillary_exists("hkrul_mundvard_sword_wsoran") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mundvard_sword_wsoran",
            true,
            false
        )
    end,
    false
) 

    core:add_listener(
    "hkrul_mundvard_item3_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_mar_munvard") and character:rank() >= 11 and faction:ancillary_exists("hkrul_mar_hilaria") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_hilaria",
            true,
            false
        )
    end,
    false
) 

--------------alicia
        core:add_listener(
    "hkrul_alicia_item1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_alicia") and character:rank() >= 8 and faction:ancillary_exists("hkrul_alicia_rose") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_alicia_rose",
            true,
            false
        )
    end,
    false
) 

    core:add_listener(
    "hkrul_alicia_item2_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_alicia") and character:rank() >= 14 and faction:ancillary_exists("hkrul_alicia_ring") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_alicia_ring",
            true,
            false
        )
    end,
    false
) 
    
-------------------------solkan
    
    
core:add_listener(
    "hkrul_solkan_weapon_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_solkan") and character:rank() >= 7 and faction:ancillary_exists("hkrul_solkan_item_greatsword") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_solkan_item_greatsword",
            true,
            false
        )
    end,
    false
)

    core:add_listener(
    "hkrul_solkan_weapon_unlock2",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_solkan") and character:rank() >= 15 and faction:ancillary_exists("hkrul_solkan_ring") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_solkan_ring",
            true,
            false
        )
    end,
    false
)

    core:add_listener(
    "hkrul_solkan_weapon_unlock3",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_solkan") and character:rank() >= 11 and faction:ancillary_exists("hkrul_mar_black_cap") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_black_cap",
            true,
            false
        )
    end,
    false
)
-------------------------egmond

core:add_listener(
    "hkrul_egmond_item_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_mar_egmond") and character:rank() >= 7 and faction:ancillary_exists("hkrul_mar_tze_amulet") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_tze_amulet",
            true,
            false
        )
    end,
    false
)

    core:add_listener(
    "hkrul_egmond_item2_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_mar_egmond") and character:rank() >= 11 and faction:ancillary_exists("hkrul_mar_egmond_nippon") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_egmond_nippon",
            true,
            false
        )
    end,
    false
)


core:add_listener(
    "hkrul_egmond_item1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_mar_egmond") and character:rank() >= 15 and faction:ancillary_exists("hkrul_egmond_katana") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_egmond_katana",
            true,
            false
        )
    end,
    false
)
------------------------jk

core:add_listener(
    "hkrul_jk_weapon_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_jk") and character:rank() >= 11 and faction:ancillary_exists("hkrul_mar_coin") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_coin",
            true,
            false
        )
    end,
    false
)
core:add_listener(
    "hkrul_jk_item2_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_jk") and character:rank() >= 14 and faction:ancillary_exists("wh2_dlc13_anc_talisman_stadsraad_key") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "wh2_dlc13_anc_talisman_stadsraad_key",
            true,
            false
        )
    end,
    false
)

core:add_listener(
    "hkrul_jk_item3_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_jk") and character:rank() >= 8 and faction:ancillary_exists("hkrul_mar_jk_hat") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_jk_hat",
            true,
            false
        )
    end,
    false
)     
---------------------pg
core:add_listener(
    "hkrul_pg_follower1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_pg") and character:rank() >= 12 and faction:ancillary_exists("hkrul_mar_lea") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_lea",
            true,
            false
        )
    end,
    false
)

--[[
core:add_listener(
    "hkrul_pg_follower2_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_pg") and character:rank() >= 8 and faction:ancillary_exists("hkrul_mar_anc_norscan") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_anc_norscan",
            true,
            false
        )
    end,
    false
)
--]]


core:add_listener(
    "hkrul_pg_follower3_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_pg") and character:rank() >= 15 and faction:ancillary_exists("hkrul_mar_stevedore") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_stevedore",
            true,
            false
        )
    end,
    false
)

core:add_listener(
    "hkrul_pg_follower4_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_pg") and character:rank() >= 5 and faction:ancillary_exists("hkrul_mar_barrel") == false
    end,
    function(context)
        local character = context:character()
		local faction = character:faction()
        cm:add_ancillary_to_faction(faction, "hkrul_mar_barrel", false)
    end,
    false
)

core:add_listener(
	"hkrul_pg_special_0_1_CharacterSkillPointAllocated",
	"CharacterSkillPointAllocated",
	function(context)
		local skill = context:skill_point_spent_on()
		local character = context:character()
		local faction = character:faction()
		return skill == "hkrul_pg_special_0_1" and faction:ancillary_exists("hkrul_mar_pirate_banner") == false
	end,
	function(context)
        local character = context:character()
		local faction = character:faction()
        cm:add_ancillary_to_faction(faction, "hkrul_mar_pirate_banner", false)
	end,
	false
)
----------------------hendrik
core:add_listener(
    "hkrul_hendrik_follower1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_hendrik") and character:rank() >= 8 and faction:ancillary_exists("hkrul_mar_anc_sander") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_anc_sander",
            true,
            false
        )
    end,
    false
)

core:add_listener(
    "hkrul_hendrik_follower2_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_hendrik") and character:rank() >= 12 and faction:ancillary_exists("hkrul_mar_mace") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_mace",
            true,
            false
        )
    end,
    false
)
    
    
---------------------crispijn

core:add_listener(
    "hkrul_crispijn_follower1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_crispijn") and character:rank() >= 5 and faction:ancillary_exists("hkrul_mar_gruber") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_gruber",
            true,
            false
        )
    end,
    false
)

---------------------odvaal

core:add_listener(
    "hkrul_odvaal_item1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_harb") and character:rank() >= 8 and faction:ancillary_exists("hkrul_mar_roe") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_roe",
            true,
            false
        )
    end,
    false
)
---------------------lisette

core:add_listener(
    "hkrul_lisette_follower1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_lisette") and character:rank() >= 8 and faction:ancillary_exists("hkrul_mar_casanova") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_casanova",
            true,
            false
        )
    end,
    false
)
---------------------cross

core:add_listener(
    "hkrul_cross_follower1_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_cross") and character:rank() >= 8 and faction:ancillary_exists("hkrul_mar_casino") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_mar_casino",
            true,
            false
        )
    end,
    false
)

----------------------building

core:add_listener(
        "SuidockBuildingCompleted",
        "BuildingCompleted",
        function(context)
            local building = context:building()
            local building_faction = building:faction()
            return building:name() == "hkrul_mar_suiddock" and building_faction:culture() == "wh_main_emp_empire"
        end,
        function(context)
            local building_faction = context:building():faction()
            cm:add_ancillary_to_faction(building_faction, "hkrul_mar_loodemans", false)
        end,
        false
)