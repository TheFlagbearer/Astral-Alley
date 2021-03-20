var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "midgrey", "FFF", "white", "steel", "techmaint", "dark", "plating", "reinforced")

/datum/category_item/player_setup_item/general/body
	name = "Body"
	sort_order = 5

/datum/category_item/player_setup_item/general/body/load_character(var/savefile/S)
	S["species"]			>> pref.species
	S["hair_red"]			>> pref.r_hair
	S["hair_green"]			>> pref.g_hair
	S["hair_blue"]			>> pref.b_hair
	S["facial_red"]			>> pref.r_facial
	S["facial_green"]		>> pref.g_facial
	S["facial_blue"]		>> pref.b_facial
	S["grad_style"]			>> pref.grad_style
	S["grad_red"]			>> pref.r_grad
	S["grad_green"]			>> pref.g_grad
	S["grad_blue"]			>> pref.b_grad
	S["skin_tone"]			>> pref.s_tone
	S["skin_red"]			>> pref.r_skin
	S["skin_green"]			>> pref.g_skin
	S["skin_blue"]			>> pref.b_skin
	S["hair_style_name"]		>> pref.h_style
	S["facial_style_name"]		>> pref.f_style
	S["lip_style"]			>> pref.lip_style
	S["lip_color"]			>> pref.lip_color
	S["eyes_red"]			>> pref.r_eyes
	S["eyes_green"]			>> pref.g_eyes
	S["eyes_blue"]			>> pref.b_eyes
	S["b_type"]			>> pref.b_type
	S["weight"]			>> pref.weight
	S["calories"]			>> pref.calories
	S["hydration"]			>> pref.hydration
	S["nutrition"]			>> pref.nutrition
	S["disabilities"]		>> pref.disabilities
	S["organ_data"]			>> pref.organ_data
	S["rlimb_data"]			>> pref.rlimb_data
	S["body_markings"]		>> pref.body_markings
	S["synth_color"]		>> pref.synth_color
	S["synth_red"]			>> pref.r_synth
	S["synth_green"]		>> pref.g_synth
	S["synth_blue"]			>> pref.b_synth
	pref.preview_icon = null
	S["bgstate"]			>> pref.bgstate
	S["cyber_control"]		>> pref.cyber_control

/datum/category_item/player_setup_item/general/body/save_character(var/savefile/S)
	S["species"]			<< pref.species
	S["hair_red"]			<< pref.r_hair
	S["hair_green"]			<< pref.g_hair
	S["hair_blue"]			<< pref.b_hair
	S["facial_red"]			<< pref.r_facial
	S["facial_green"]		<< pref.g_facial
	S["facial_blue"]		<< pref.b_facial
	S["grad_style"]		<< pref.grad_style
	S["grad_red"]			<< pref.r_grad
	S["grad_green"]		<< pref.g_grad
	S["grad_blue"]			<< pref.b_grad
	S["skin_tone"]			<< pref.s_tone
	S["skin_red"]			<< pref.r_skin
	S["skin_green"]			<< pref.g_skin
	S["skin_blue"]			<< pref.b_skin
	S["hair_style_name"]		<< pref.h_style
	S["facial_style_name"]		<< pref.f_style
	S["lip_style"]			<< pref.lip_style
	S["lip_color"]			<< pref.lip_color
	S["eyes_red"]			<< pref.r_eyes
	S["eyes_green"]			<< pref.g_eyes
	S["eyes_blue"]			<< pref.b_eyes
	S["b_type"]			<< pref.b_type
	S["weight"]			<< pref.weight
	S["calories"]			<< pref.calories
	S["hydration"]			<< pref.hydration
	S["nutrition"]			<< pref.nutrition
	S["disabilities"]		<< pref.disabilities
	S["organ_data"]			<< pref.organ_data
	S["rlimb_data"]			<< pref.rlimb_data
	S["body_markings"]		<< pref.body_markings
	S["synth_color"]		<< pref.synth_color
	S["synth_red"]			<< pref.r_synth
	S["synth_green"]		<< pref.g_synth
	S["synth_blue"]			<< pref.b_synth
	S["bgstate"]			<< pref.bgstate
	S["cyber_control"]		<< pref.cyber_control

/datum/category_item/player_setup_item/general/body/delete_character(var/savefile/S)
	pref.species = null
	pref.r_hair = null
	pref.g_hair = null
	pref.b_hair = null
	pref.r_facial = null
	pref.g_facial = null
	pref.b_facial = null
	pref.grad_style = null
	pref.r_grad = null
	pref.g_grad = null
	pref.b_grad = null
	pref.s_tone = null
	pref.r_skin = null
	pref.g_skin = null
	pref.b_skin = null
	pref.h_style = null
	pref.f_style = null
	pref.lip_style = null
	pref.lip_color = null
	pref.r_eyes = null
	pref.g_eyes = null
	pref.b_eyes = null
	pref.b_type = null
	pref.weight = null
	pref.disabilities = null
	pref.organ_data = null
	pref.rlimb_data = null
	pref.body_markings = null
	pref.synth_color = null
	pref.r_synth = null
	pref.g_synth = null
	pref.b_synth	= null
	pref.bgstate = null
	pref.calories = null
	pref.weight = null
	pref.hydration = initial(pref.hydration)
	pref.nutrition = initial(pref.nutrition)
	pref.cyber_control = null

/datum/category_item/player_setup_item/general/body/sanitize_character(var/savefile/S)
	if(!pref.species || !(pref.species in playable_species))
		pref.species = SPECIES_HUMAN

	pref.r_hair			= sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair			= sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair			= sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_facial			= sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial			= sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial			= sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.grad_style		= sanitize_inlist(pref.grad_style, GLOB.hair_gradients, initial(pref.grad_style))
	pref.r_grad			= sanitize_integer(pref.r_grad, 0, 255, initial(pref.r_grad))
	pref.g_grad			= sanitize_integer(pref.g_grad, 0, 255, initial(pref.g_grad))
	pref.b_grad			= sanitize_integer(pref.b_grad, 0, 255, initial(pref.b_grad))
	pref.s_tone			= sanitize_integer(pref.s_tone, -185, 34, initial(pref.s_tone))
	pref.r_skin			= sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin			= sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin			= sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.h_style			= sanitize_inlist(pref.h_style, hair_styles_list, initial(pref.h_style))
	pref.f_style			= sanitize_inlist(pref.f_style, facial_hair_styles_list, initial(pref.f_style))
	pref.r_eyes			= sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes			= sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes			= sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))
	pref.weight			= sanitize_integer(pref.weight, WEIGHT_MIN / CALORIES_MUL, WEIGHT_MAX / CALORIES_MUL, initial(pref.weight))
	pref.calories			= sanitize_integer(pref.calories, WEIGHT_MIN, WEIGHT_MAX, initial(pref.calories))

	pref.hydration			= sanitize_integer(pref.hydration, 0, 400, initial(pref.hydration))
	pref.nutrition			= sanitize_integer(pref.nutrition, 0, 400, initial(pref.nutrition))


	pref.disabilities	= sanitize_integer(pref.disabilities, 0, 65535, initial(pref.disabilities))
	if(!pref.organ_data) pref.organ_data = list()
	if(!pref.rlimb_data) pref.rlimb_data = list()
	if(!pref.body_markings) pref.body_markings = list()
	else pref.body_markings &= body_marking_styles_list
	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

	pref.cyber_control	= sanitize_integer(pref.cyber_control, initial(pref.cyber_control))

// Moved from /datum/preferences/proc/copy_to()
/datum/category_item/player_setup_item/general/body/copy_to_mob(var/mob/living/carbon/human/character)
	// Copy basic values
	character.r_eyes	= pref.r_eyes
	character.g_eyes	= pref.g_eyes
	character.b_eyes	= pref.b_eyes
	character.h_style	= pref.h_style
	character.r_hair	= pref.r_hair
	character.g_hair	= pref.g_hair
	character.b_hair	= pref.b_hair
	character.f_style	= pref.f_style
	character.r_facial	= pref.r_facial
	character.g_facial	= pref.g_facial
	character.b_facial	= pref.b_facial
	character.grad_style	= pref.grad_style
	character.r_grad	= pref.r_grad
	character.g_grad	= pref.g_grad
	character.b_grad	= pref.b_grad
	character.lip_style = pref.lip_style
	character.lip_color = pref.lip_color
	character.r_skin	= pref.r_skin
	character.g_skin	= pref.g_skin
	character.b_skin	= pref.b_skin
	character.s_tone	= pref.s_tone
	character.h_style	= pref.h_style
	character.f_style	= pref.f_style
	character.b_type	= pref.b_type
	character.synth_color = pref.synth_color
	character.r_synth	= pref.r_synth
	character.g_synth	= pref.g_synth
	character.b_synth	= pref.b_synth
	character.weight	= pref.weight
	character.calories	= pref.calories
	character.hydration	= pref.hydration
	character.nutrition	= pref.nutrition
	character.set_gender( pref.biological_gender)

	// Destroy/cyborgize organs and limbs.
	for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
		var/status = pref.organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				O.remove_rejuv()
			else if(status == "cyborg")
				if(pref.rlimb_data[name])
					O.robotize(pref.rlimb_data[name])
				else
					O.robotize()

	for(var/name in list(O_HEART,O_EYES,O_LUNGS,O_LIVER,O_KIDNEYS,O_BRAIN))
		var/status = pref.organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(I)
			if(status == "assisted")
				I.mechassist()
			else if(status == "mechanical")
				I.robotize()
			else if(status == "digital")
				I.digitize()

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	for(var/M in pref.body_markings)
		var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[M]
		var/mark_color = "[pref.body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum)

	return

/datum/category_item/player_setup_item/general/body/content(var/mob/user)
	. = list()
	if(!pref.preview_icon)
		pref.update_preview_icon()
 	user << browse_rsc(pref.preview_icon, "previewicon.png")

	var/mob_species = all_species[pref.species]
	. += "<h1>Physical Appearance:</h1><hr>"
	if(!pref.existing_character)
		. += "Set your character's physical appearance. Once this is done, you cannot undo this. You can change your character's appearance in-game.<br><br>"
	. += "<table><tr style='vertical-align:top'><td>"
	if(!pref.existing_character)
		. += "<b>Body:</b> "
		. += "<a href='?src=\ref[src];random=1'>&reg; Random</A><br>"
	. += "<br>"
	. += "<b>Species: </b><br>"
	if(!pref.existing_character)
		. += "<a href='?src=\ref[src];show_species=1'>[pref.species]</a><br>"
	else
		. += "[pref.species]"
	. += "<br>"
	. += "<b>Body Weight: </b><br>"
	if(!pref.existing_character)
		. += "<a href='?src=\ref[src];set_weight=1'>[pref.weight]lbs ([get_weight(pref.calories,mob_species)])</a><br>"
	else
		. += "[pref.weight]lbs ([get_weight(pref.calories,mob_species)])"
	. += "<br>"
	. += "<b>Blood Type: </b><br>"
	if(!pref.existing_character)
		. += "<a href='?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"
	else
		. += "[pref.b_type]"
	. += "<br>"
	if(has_flag(mob_species, HAS_SKIN_TONE))
		. += "<b>Skin Tone:</b> <br>"
		if(!pref.existing_character)
			. += "<a href='?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/220</a> ([skintone2racedescription(pref.s_tone)])<br>"
		else
			. += "[skintone2racedescription(pref.s_tone)]<br>"

	. += "<b>Needs Glasses: </b><br>"
	if(!pref.existing_character)
		. += "<a href='?src=\ref[src];disabilities=[NEARSIGHTED]'><b>[pref.disabilities & NEARSIGHTED ? "Yes" : "No"]</b></a><br>"
	else
		. += "[pref.disabilities & NEARSIGHTED ? "Yes" : "No"]<br>"
	. += "<b>Limbs:</b> <br>"

	if(!pref.existing_character)
		. += "<br><a href='?src=\ref[src];limbs=1'>Adjust</a> <a href='?src=\ref[src];reset_limbs=1'>Reset</a><br>"

	. += "<b>Internal Organs:</b> "
	. += "<a href='?src=\ref[src];organs=1'>Adjust</a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name = null
		switch(name)

			if(BP_TORSO)
				organ_name = "torso"
			if(BP_GROIN)
				organ_name = "groin"
			if(BP_HEAD)
				organ_name = "head"
			if(BP_L_ARM)
				organ_name = "left arm"
			if(BP_R_ARM)
				organ_name = "right arm"
			if(BP_L_LEG)
				organ_name = "left leg"
			if(BP_R_LEG)
				organ_name = "right leg"
			if(BP_L_FOOT)
				organ_name = "left foot"
			if(BP_R_FOOT)
				organ_name = "right foot"
			if(BP_L_HAND)
				organ_name = "left hand"
			if(BP_R_HAND)
				organ_name = "right hand"
			if(O_HEART)
				organ_name = "heart"
			if(O_VOICE)
				organ_name = "larynx"
			if(O_EYES)
				organ_name = "eyes"
			if(O_BRAIN)
				organ_name = "brain"
			if(O_LUNGS)
				organ_name = "lungs"
			if(O_LIVER)
				organ_name = "liver"
			if(O_KIDNEYS)
				organ_name = "kidneys"
			if(O_SPLEEN)
				organ_name = "spleen"
			if(O_STOMACH)
				organ_name = "stomach"
			if(O_INTESTINE)
				organ_name = "intestines"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				. += ", "
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
				R = all_robolimbs[pref.rlimb_data[name]]
			else
				R = basic_robolimb
			. += "\t[R.company] [organ_name] prosthesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tAmputated [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if ("brain")
					. += "\tPositronic [organ_name]"
				else
					. += "\tSynthetic [organ_name]"
		else if(status == "digital")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tDigital [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if("heart")
					. += "\tPacemaker-assisted [organ_name]"
				if("lungs")
					. += "\tAssisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					. += "\tSurgically altered [organ_name]"
				if("eyes")
					. += "\tRetinal overlayed [organ_name]"
				if("brain")
					. += "\tAssisted-interface [organ_name]"
				else
					. += "\tMechanically assisted [organ_name]"

		else if(!organ_name)
			. += "Normal Limbs"
	if(!ind)

		. += "\[...\]<br><br>"
	else
		. += "<br><br>"

	if(LAZYLEN(pref.rlimb_data) && !pref.is_synth())
		. += "<div class='notice'><b>Warning: A neural framework implant is required to use cybernetic limbs.</b> If you do not have one installed prior to saving your \
		character, you WILL not be able to control cybernetic limbs, putting you at a significant disadvantage depending on the affected \
		limbs. You will have to receive an implant during gameplay to use your cybernetic limbs in the future. <b>THIS SETTING CAN ONLY BE CHANGED VIA IN-GAME METHODS ONCE YOUR CHARACTER \
		HAS BEEN SAVED.</b></div><br>"
		. += "<b>Neural Framework Implant Installed: </b><br>"
		if(!pref.existing_character)
			. += "<a href='?src=\ref[src];cyber_control=[pref.cyber_control]'><b>[pref.cyber_control ? "Yes" : "No"]</b></a><br>"
		else
			. += "<b>[pref.cyber_control ? "Yes" : "No"]</b><br>"

	if(pref.is_synth())
		. += "<div class='notice'><b>Warning:</b> You are playing a <b>synthetic</b>. In this universe, synthetics are limited rights and are not \
		considered people, they may face economic and systematic discrimination. They are often considered property to humans and are expected to \
		be shackled to an owner. Synthetics found to be \"deviant\" may be subjected to decommissioning. Roleplay how you approach this carefully.</div><br>"

	. += "</td><td><b>Preview</b><br>"
	. += "<div class='statusDisplay'><center><img src=previewicon.png width=[pref.preview_icon.Width()] height=[pref.preview_icon.Height()]></center></div>"
	. += "<br><a href='?src=\ref[src];cycle_bg=1'>Cycle background</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Hide loadout" : "Show loadout"]</a>"
	. += "<br><a href='?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Hide job gear" : "Show job gear"]</a>"
	. += "</td></tr></table>"

	if(has_flag(mob_species, HAS_HAIR_COLOR))
		if(!pref.existing_character)
			. += "<b>Hairstyle:</b><br>"
			. += "<a href='?src=\ref[src];hair_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_hair, 2)][num2hex(pref.g_hair, 2)][num2hex(pref.b_hair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_hair, 2)][num2hex(pref.g_hair, 2)][num2hex(pref.b_hair, 2)]'><tr><td>__</td></tr></table></font> "
	. += "<br>"

	if(!pref.existing_character)
		. += " <a href='?src=\ref[src];hair_style=1'>[pref.h_style]</a><br>"
		. += "<b>Hair Gradient</b><br>"
		. += "<a href='?src=\ref[src];grad_color=1'>Change Color</a> [color_square(pref.r_grad, pref.g_grad, pref.b_grad)] "
		. += " Gradient Style: <a href='?src=\ref[src];grad_style_left=[pref.grad_style]'><</a> <a href='?src=\ref[src];grad_style_right=[pref.grad_style]''>></a> <a href='?src=\ref[src];grad_style=1'>[pref.grad_style]</a><br>"

	else
		. += "<b>Hairstyle:</b><br> <font face='fixedsys' size='3' color='#[num2hex(pref.r_hair, 2)][num2hex(pref.g_hair, 2)][num2hex(pref.b_hair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_hair, 2)][num2hex(pref.g_hair, 2)][num2hex(pref.b_hair, 2)]'><tr><td>__</td></tr></table></font> "
		. += "[pref.h_style]<br>"

		. += "Hair Gradient: [color_square(pref.r_grad, pref.g_grad, pref.b_grad)] <br>"



	if(has_flag(mob_species, HAS_HAIR_COLOR))
		if(!pref.existing_character)
			. += "<br><b>Facial Hair: </b><br>"
			. += "<a href='?src=\ref[src];facial_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_facial, 2)][num2hex(pref.g_facial, 2)][num2hex(pref.b_facial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_facial, 2)][num2hex(pref.g_facial, 2)][num2hex(pref.b_facial, 2)]'><tr><td>__</td></tr></table></font> "
		else
			. += "<b>Facial Hair:</b><br> <font face='fixedsys' size='3' color='#[num2hex(pref.r_facial, 2)][num2hex(pref.g_facial, 2)][num2hex(pref.b_facial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_facial, 2)][num2hex(pref.g_facial, 2)][num2hex(pref.b_facial, 2)]'><tr><td>__</td></tr></table></font> "
			. += "[pref.f_style]<br>"

	if(!pref.existing_character)
		. += "<br><a href='?src=\ref[src];facial_style=1'>[pref.f_style]</a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Eye Color: </b> <br>"
		if(!pref.existing_character)
			. += "<a href='?src=\ref[src];eye_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_eyes, 2)][num2hex(pref.g_eyes, 2)][num2hex(pref.b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_eyes, 2)][num2hex(pref.g_eyes, 2)][num2hex(pref.b_eyes, 2)]'><tr><td>__</td></tr></table></font> <br>"
		else
			. += "<font face='fixedsys' size='3' color='#[num2hex(pref.r_eyes, 2)][num2hex(pref.g_eyes, 2)][num2hex(pref.b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_eyes, 2)][num2hex(pref.g_eyes, 2)][num2hex(pref.b_eyes, 2)]'><tr><td>__</td></tr></table></font><br>"


	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Body Color: </b><br>"
		if(!pref.existing_character)
			. += "<a href='?src=\ref[src];skin_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_skin, 2)][num2hex(pref.g_skin, 2)][num2hex(pref.b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_skin, 2)][num2hex(pref.g_skin, 2)][num2hex(pref.b_skin, 2)]'><tr><td>__</td></tr></table></font><br>"
		else
			. += "<font face='fixedsys' size='3' color='#[num2hex(pref.r_skin, 2)][num2hex(pref.g_skin, 2)][num2hex(pref.b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_skin, 2)][num2hex(pref.g_skin, 2)][num2hex(pref.b_skin, 2)]'><tr><td>__</td></tr></table></font><br>"

	. += "<br><a href='?src=\ref[src];marking_style=1'>Body Markings +</a><br>"
	for(var/M in pref.body_markings)
		. += "[M] [pref.body_markings.len > 1 ? "<a href='?src=\ref[src];marking_up=[M]'>&#708;</a> <a href='?src=\ref[src];marking_down=[M]'>&#709;</a> " : ""]<a href='?src=\ref[src];marking_remove=[M]'>-</a> <a href='?src=\ref[src];marking_color=[M]'>Color</a>"
		. += "<font face='fixedsys' size='3' color='[pref.body_markings[M]]'><table style='display:inline;' bgcolor='[pref.body_markings[M]]'><tr><td>__</td></tr></table></font>"
		. += "<br>"

	. += "<br>"
	. += "<b>Allow Synth color:</b> <a href='?src=\ref[src];synth_color=1'><b>[pref.synth_color ? "Yes" : "No"]</b></a><br>"
	if(pref.synth_color)
		. += "<a href='?src=\ref[src];synth2_color=1'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_synth, 2)][num2hex(pref.g_synth, 2)][num2hex(pref.b_synth, 2)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_synth, 2)][num2hex(pref.g_synth, 2)][num2hex(pref.b_synth, 2)]'><tr><td>__</td></tr></table></font> "

	. = jointext(.,null)

/datum/category_item/player_setup_item/general/body/proc/has_flag(var/datum/species/mob_species, var/flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/general/body/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/mob_species = all_species[pref.species]

	if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["blood_type"])
		var/new_b_type = input(user, "Choose your character's blood-type:", "Character Preference") as null|anything in valid_bloodtypes
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["set_weight"])
		var/min_weight = calories_to_weight(mob_species.min_calories) + 10
		var/max_weight = calories_to_weight(mob_species.max_calories) - 10
		var/new_weight = input(user, "Choose your character's weight:\n([round(min_weight)]-[round(max_weight)])", "Character Preference", pref.weight) as num|null
		if(new_weight && CanUseTopic(user))
			pref.weight = max(min(round(text2num(new_weight)), max_weight), min_weight)
			pref.calories = weight_to_calories(pref.weight)
			return TOPIC_REFRESH


	else if(href_list["show_species"])
		// Actual whitelist checks are handled elsewhere, this is just for accessing the preview window.
		var/choice = input("Which species would you like to look at?") as null|anything in playable_species
		if(!choice) return
		pref.species_preview = choice
		SetSpecies(preference_mob())
		pref.alternate_languages.Cut() // Reset their alternate languages. Todo: attempt to just fix it instead?
		return TOPIC_HANDLED

	else if(href_list["set_species"])
		user << browse(null, "window=species")
		if(!pref.species_preview || !(pref.species_preview in all_species))
			return TOPIC_NOACTION

		var/prev_species = pref.species
		pref.species = href_list["set_species"]
		if(prev_species != pref.species)
			if(!(pref.biological_gender in mob_species.genders))
				pref.set_biological_gender(mob_species.genders[1])

			//grab one of the valid hair styles for the newly chosen species
			var/list/valid_hairstyles = list()
			for(var/hairstyle in hair_styles_list)
				var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
				if(pref.biological_gender == MALE && S.gender == FEMALE)
					continue
				if(pref.biological_gender == FEMALE && S.gender == MALE)
					continue
				if(!(pref.species in S.species_allowed))
					continue
				valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

			if(valid_hairstyles.len)
				pref.h_style = pick(valid_hairstyles)
			else
				//this shouldn't happen
				pref.h_style = hair_styles_list["Bald"]

			//grab one of the valid facial hair styles for the newly chosen species
			var/list/valid_facialhairstyles = list()
			for(var/facialhairstyle in facial_hair_styles_list)
				var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
				if(pref.biological_gender == MALE && S.gender == FEMALE)
					continue
				if(pref.biological_gender == FEMALE && S.gender == MALE)
					continue
				if(!(pref.species in S.species_allowed))
					continue

				valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

			if(valid_facialhairstyles.len)
				pref.f_style = pick(valid_facialhairstyles)
			else
				//this shouldn't happen
				pref.f_style = facial_hair_styles_list["Shaved"]

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = 0

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			var/min_age = get_min_age()
			var/max_age = get_max_age()
			pref.age = max(min(pref.age, max_age), min_age)

			pref.weight = calories_to_weight(mob_species.normal_calories)

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference", rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = hex2num(copytext(new_hair, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = list()
		for(var/hairstyle in hair_styles_list)
			var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
			if(!(pref.species in S.species_allowed))
				continue

			valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

		var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference", pref.h_style)  as null|anything in valid_hairstyles
		if(new_h_style && CanUseTopic(user))
			pref.h_style = new_h_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_grad = input(user, "Choose your character's secondary hair color:", "Character Preference", rgb(pref.r_grad, pref.g_grad, pref.b_grad)) as color|null
		if(new_grad && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_grad = hex2num(copytext(new_grad, 2, 4))
			pref.g_grad = hex2num(copytext(new_grad, 4, 6))
			pref.b_grad = hex2num(copytext(new_grad, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["grad_style"])
		var/list/valid_gradients = GLOB.hair_gradients

		var/new_grad_style = input(user, "Choose a color pattern for your hair:", "Character Preference", pref.grad_style)  as null|anything in valid_gradients
		if(new_grad_style && CanUseTopic(user))
			pref.grad_style = new_grad_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference", rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = hex2num(copytext(new_facial, 2, 4))
			pref.g_facial = hex2num(copytext(new_facial, 4, 6))
			pref.b_facial = hex2num(copytext(new_facial, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference", rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(mob_species, HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			pref.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			pref.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference", (-pref.s_tone) + 35)  as num|null
		if(new_s_tone && has_flag(mob_species, HAS_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min( round(new_s_tone), 220),1)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference", rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		if(new_skin && has_flag(mob_species, HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.r_skin = hex2num(copytext(new_skin, 2, 4))
			pref.g_skin = hex2num(copytext(new_skin, 4, 6))
			pref.b_skin = hex2num(copytext(new_skin, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = list()
		for(var/facialhairstyle in facial_hair_styles_list)
			var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
			if(pref.biological_gender == MALE && S.gender == FEMALE)
				continue
			if(pref.biological_gender == FEMALE && S.gender == MALE)
				continue
			if(!(pref.species in S.species_allowed))
				continue

			valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

		var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference", pref.f_style)  as null|anything in valid_facialhairstyles
		if(new_f_style && has_flag(mob_species, HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/usable_markings = pref.body_markings.Copy() ^ body_marking_styles_list.Copy()
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(!S.species_allowed.len)
				continue
			else if(!(pref.species in S.species_allowed))
				usable_markings -= M

		var/new_marking = input(user, "Choose a body marking:", "Character Preference")  as null|anything in usable_markings
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_up"])
		var/M = href_list["marking_up"]
		var/start = pref.body_markings.Find(M)
		if(start != 1) //If we're not the beginning of the list, swap with the previous element.
			moveElement(pref.body_markings, start, start-1)
		else //But if we ARE, become the final element -ahead- of everything else.
			moveElement(pref.body_markings, start, pref.body_markings.len+1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_down"])
		var/M = href_list["marking_down"]
		var/start = pref.body_markings.Find(M)
		if(start != pref.body_markings.len) //If we're not the end of the list, swap with the next element.
			moveElement(pref.body_markings, start, start+2)
		else //But if we ARE, become the first element -behind- everything else.
			moveElement(pref.body_markings, start, 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Choose the [M] color: ", "Character Preference", pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_limbs"])
		reset_limbs()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])

		var/list/limb_selection_list = list("Left Leg","Right Leg","Left Arm","Right Arm","Left Foot","Right Foot","Left Hand","Right Hand","Full Body")

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = all_species[pref.species]
		if(!current_species.has_organ["brain"])
			limb_selection_list -= "Full Body"
		else if(pref.organ_data[BP_TORSO] == "cyborg")
			limb_selection_list |= "Head"

		var/organ_tag = input(user, "Which limb do you want to change?") as null|anything in limb_selection_list

		if(!organ_tag || !CanUseTopic(user)) return TOPIC_NOACTION

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		var/list/choice_options = list("Normal","Amputated","Prosthesis")
		switch(organ_tag)
			if("Left Leg")
				limb =        BP_L_LEG
				second_limb = BP_L_FOOT
			if("Right Leg")
				limb =        BP_R_LEG
				second_limb = BP_R_FOOT
			if("Left Arm")
				limb =        BP_L_ARM
				second_limb = BP_L_HAND
			if("Right Arm")
				limb =        BP_R_ARM
				second_limb = BP_R_HAND
			if("Left Foot")
				limb =        BP_L_FOOT
				third_limb =  BP_L_LEG
			if("Right Foot")
				limb =        BP_R_FOOT
				third_limb =  BP_R_LEG
			if("Left Hand")
				limb =        BP_L_HAND
				third_limb =  BP_L_ARM
			if("Right Hand")
				limb =        BP_R_HAND
				third_limb =  BP_R_ARM
			if("Head")
				limb =        BP_HEAD
				choice_options = list("Prosthesis")
			if("Full Body")
				limb =        BP_TORSO
				third_limb =  BP_GROIN
				choice_options = list("Normal","Prosthesis")

		var/new_state = input(user, "What state do you wish the limb to be in?") as null|anything in choice_options
		if(!new_state || !CanUseTopic(user)) return TOPIC_NOACTION

		switch(new_state)
			if("Normal")
				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						pref.organ_data[other_limb] = null
						pref.rlimb_data[other_limb] = null
				pref.organ_data[limb] = null
				pref.rlimb_data[limb] = null
				if(third_limb)
					pref.organ_data[third_limb] = null
					pref.rlimb_data[third_limb] = null

			if("Amputated")
				if(limb == BP_TORSO)
					return
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			if("Prosthesis")
				var/tmp_species = pref.species ? pref.species : SPECIES_HUMAN
				var/list/usable_manufacturers = list()
				for(var/company in chargen_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(!(limb in M.parts))
						continue
					if(tmp_species in M.species_cannot_use)
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = input(user, "Which manufacturer do you wish to use for this limb?") as null|anything in usable_manufacturers
				if(!choice)
					return

				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"

				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

				if(limb == BP_TORSO)
					for(var/other_limb in BP_ALL - BP_TORSO)
						if(pref.organ_data[other_limb])
							continue
						pref.organ_data[other_limb] = "cyborg"
						pref.rlimb_data[other_limb] = choice
					if(!pref.organ_data[O_BRAIN])
						pref.organ_data[O_BRAIN] = "assisted"
					for(var/internal_organ in list(O_HEART,O_EYES))
						pref.organ_data[internal_organ] = "mechanical"

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])

		var/organ_name = input(user, "Which internal function do you want to change?") as null|anything in list("Heart", "Eyes","Larynx", "Lungs", "Liver", "Kidneys", "Spleen", "Intestines", "Stomach", "Brain")
		if(!organ_name) return

		var/organ = null
		switch(organ_name)
			if("Heart")
				organ = O_HEART
			if("Eyes")
				organ = O_EYES
			if("Lungs")
				organ = O_LUNGS
			if("Liver")
				organ = O_LIVER
			if("Larynx")
				organ = O_VOICE
			if("Kidneys")
				organ = O_KIDNEYS
			if("Spleen")
				organ = O_SPLEEN
			if("Intestines")
				organ = O_INTESTINE
			if("Stomach")
				organ = O_STOMACH
			if("Brain")
				if(pref.organ_data[BP_HEAD] != "cyborg")
					user << "<span class='warning'>You may only select a cybernetic or synthetic brain if you have a full prosthetic body.</span>"
					return
				organ = "brain"

		var/list/organ_choices = list("Normal")
		if(pref.organ_data[BP_TORSO] == "cyborg")
			organ_choices -= "Normal"
			if(organ_name == "Brain")
				organ_choices += "Cybernetic"
				organ_choices += "Positronic"
				organ_choices += "Drone"
			else
				organ_choices += "Assisted"
				organ_choices += "Mechanical"
		else
			organ_choices += "Assisted"
			organ_choices += "Mechanical"

		var/new_state = input(user, "What state do you wish the organ to be in?") as null|anything in organ_choices
		if(!new_state) return

		switch(new_state)
			if("Normal")
				pref.organ_data[organ] = null
			if("Assisted")
				pref.organ_data[organ] = "assisted"
			if("Cybernetic")
				pref.organ_data[organ] = "assisted"
			if ("Mechanical")
				pref.organ_data[organ] = "mechanical"
			if("Drone")
				pref.organ_data[organ] = "digital"
			if("Positronic")
				pref.organ_data[organ] = "mechanical"

		return TOPIC_REFRESH

	else if(href_list["disabilities"])
		var/disability_flag = text2num(href_list["disabilities"])
		pref.disabilities ^= disability_flag
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cyber_control"])
		pref.cyber_control = !pref.cyber_control
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth_color"])
		pref.synth_color = !pref.synth_color
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["synth2_color"])
		var/new_color = input(user, "Choose your character's synth colour: ", "Character Preference", rgb(pref.r_synth, pref.g_synth, pref.b_synth)) as color|null
		if(new_color && CanUseTopic(user))
			pref.r_synth = hex2num(copytext(new_color, 2, 4))
			pref.g_synth = hex2num(copytext(new_color, 4, 6))
			pref.b_synth = hex2num(copytext(new_color, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/general/body/proc/reset_limbs()

	for(var/organ in pref.organ_data)
		pref.organ_data[organ] = null
	while(null in pref.organ_data)
		pref.organ_data -= null

	for(var/organ in pref.rlimb_data)
		pref.rlimb_data[organ] = null
	while(null in pref.rlimb_data)
		pref.rlimb_data -= null

	// Sanitize the name so that there aren't any numbers sticking around.
	pref.real_name          = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		pref.real_name      = random_name(pref.identifying_gender, pref.species)

/datum/category_item/player_setup_item/general/body/proc/SetSpecies(mob/user)
	if(!pref.species_preview || !(pref.species_preview in all_species))
		pref.species_preview = SPECIES_HUMAN
	var/datum/species/current_species = all_species[pref.species_preview]
	var/dat = "<body>"
	dat += "<center><h2>[current_species.name] \[<a href='?src=\ref[src];show_species=1'>change</a>\]</h2></center><hr/>"
	dat += "<table padding='8px'>"
	dat += "<tr>"
	dat += "<td width = 400>[current_species.blurb]</td>"
	dat += "<td width = 200 align='center'>"
	if("preview" in icon_states(current_species.icobase))
		usr << browse_rsc(icon(current_species.icobase,"preview"), "species_preview_[current_species.name].png")
		dat += "<img src='species_preview_[current_species.name].png' width='64px' height='64px'><br/><br/>"
	dat += "<b>Language:</b> [current_species.species_language]<br/>"
	dat += "<small>"
	if(current_species.spawn_flags & SPECIES_CAN_JOIN)
		switch(current_species.rarity_value)
			if(1 to 2)
				dat += "</br><b>Often present on human stations.</b>"
			if(3 to 4)
				dat += "</br><b>Rarely present on human stations.</b>"
			if(5)
				dat += "</br><b>Unheard of on human stations.</b>"
			else
				dat += "</br><b>May be present on human stations.</b>"
	if(current_species.spawn_flags & SPECIES_IS_WHITELISTED)
		dat += "</br><b>Whitelist restricted.</b>"
	if(!current_species.has_organ[O_HEART])
		dat += "</br><b>Does not have a circulatory system.</b>"
	if(!current_species.has_organ[O_LUNGS])
		dat += "</br><b>Does not have a respiratory system.</b>"
	if(current_species.flags & NO_SCAN)
		dat += "</br><b>Does not have DNA.</b>"
	if(current_species.flags & NO_PAIN)
		dat += "</br><b>Does not feel pain.</b>"
	if(current_species.flags & NO_SLIP)
		dat += "</br><b>Has excellent traction.</b>"
	if(current_species.flags & NO_POISON)
		dat += "</br><b>Immune to most poisons.</b>"
	if(current_species.appearance_flags & HAS_SKIN_TONE)
		dat += "</br><b>Has a variety of skin tones.</b>"
	if(current_species.appearance_flags & HAS_SKIN_COLOR)
		dat += "</br><b>Has a variety of skin colours.</b>"
	if(current_species.appearance_flags & HAS_EYE_COLOR)
		dat += "</br><b>Has a variety of eye colours.</b>"
	if(current_species.flags & IS_PLANT)
		dat += "</br><b>Has a plantlike physiology.</b>"
	dat += "</small></td>"
	dat += "</tr>"
	dat += "</table><center><hr/>"

	var/restricted = 0

	if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
		restricted = 2
	else if(!is_alien_whitelisted(preference_mob(),current_species))
		restricted = 1

	if(restricted)
		if(restricted == 1)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>If you wish to be whitelisted, you can make an application post on <a href='?src=\ref[user];preference=open_whitelist_forum'>the forums</a>.</small></b></font></br>"
		else if(restricted == 2)
			dat += "<font color='red'><b>You cannot play as this species.</br><small>This species is not available for play as a station race..</small></b></font></br>"
	if(!restricted || check_rights(R_ADMIN, 0))
		dat += "\[<a href='?src=\ref[src];set_species=[pref.species_preview]'>select</a>\]"
	dat += "</center></body>"

	user << browse(dat, "window=species;size=700x400")
