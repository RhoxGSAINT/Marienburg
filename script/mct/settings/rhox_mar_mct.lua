if not get_mct then return end
local mct = get_mct()
local mct_mod = mct:register_mod("hkrul_mar")
mct_mod:set_title("Marienburg: The Merchant Empire", true)
mct_mod:set_author("SCM")
mct_mod:set_description("Some of the options for the players want a easier game", true)

local landship = mct_mod:add_new_option("rhox_mar_additional_landship", "slider")
landship:slider_set_min_max(0, 10)
landship:slider_set_step_size(1)
landship:set_default_value(0)
landship:set_text("mct_rhox_mar_additional_landship_title", true)
landship:set_tooltip_text("mct_rhox_mar_additional_landship_desc", true)


local rebellion = mct_mod:add_new_option("rhox_mar_rebellion", "checkbox")
rebellion:set_default_value(false)
rebellion:set_text("mct_rhox_mar_rebellion_skill_title", true)
rebellion:set_tooltip_text("mct_rhox_mar_rebellion_skill_desc", true)


local rebellion = mct_mod:add_new_option("rhox_mar_blue_pirate", "checkbox")
rebellion:set_default_value(false)
rebellion:set_text("mct_rhox_mar_blue_pirates_title", true)
rebellion:set_tooltip_text("mct_rhox_mar_blue_pirates_desc", true)


local rite = mct_mod:add_new_option("rhox_mar_jaan_rite", "checkbox")
rite:set_default_value(false)
rite:set_text("mct_rhox_mar_rite_title", true)
rite:set_tooltip_text("mct_rhox_mar_rite_desc", true)



