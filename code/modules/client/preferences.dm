#define SAVE_RESET -1

var/list/preferences_datums = list()

datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id
	var/first_seen
	var/last_seen

	var/list/ips_associated	= list()
	var/list/cids_associated = list()
	var/list/characters_created = list()
	var/byond_join_date

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/be_special = 0					//Special role selection
	var/UI_style = "Midnight"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/tooltipstyle = "Midnight"		//Style for popup tooltips
	var/client_fps = 0

	//character preferences
	var/real_name						//our character's name
//	var/be_random_name = 0				//whether we are a random name every round
	var/nickname						//our character's nickname
	var/age = 30						//age of character
	var/birth_day = 1					//day you were born
	var/birth_month	= 1					//month you were born
	var/birth_year						//year you were born
	// There's no birth year, as that's automatically calculated by your age.

	var/spawnpoint = "City Arrivals Airbus" //where this character will spawn (0-2).
	var/b_type = "O+"					//blood type (not-chooseable)
	var/backbag = 2					//backpack type
	var/pdachoice = 1					//PDA type
	var/h_style = "Short Hair"		//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/grad_style = "none"				//Gradient style
	var/r_grad = 0						//Gradient color
	var/g_grad = 0						//Gradient color
	var/b_grad = 0						//Gradient color
	var/f_style = "Shaved"				//Face hair type
	var/lip_style						//Lips/Makeup Style
	var/lip_color						//Color of the makeup/lips
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin tone
	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = SPECIES_HUMAN         //Species datum to use.
	var/weight = 120
	var/calories = 420000			// Used for calculation of weight.
	var/nutrition = 300			// How hungry you are.
	var/hydration = 300
	var/species_preview                 //Used for the species selection window.
	var/list/alternate_languages = list() //Secondary language(s)
	var/list/language_prefixes = list() //Kanguage prefix keys
	var/list/gear						//Left in for Legacy reasons, will no longer save.
	var/list/gear_list = list()			//Custom/fluff item loadouts.
	var/gear_slot = 1					//The current gear save slot
	var/list/traits						//Traits which modifier characters for better or worse (mostly worse).
	var/synth_color	= 0					//Lets normally uncolorable synth parts be colorable.
	var/r_synth							//Used with synth_color to color synth parts that normaly can't be colored.
	var/g_synth							//Same as above
	var/b_synth							//Same as above

		//Some faction information.
	var/birthplace = "Vetra"           //System of birth.
	var/citizenship = "Blue Colony"     //Current home system.
	var/faction = "NanoTrasen Colony Civilian"                //General associated faction.
	var/religion = "None"               //Religious association.
	var/antag_faction = "None"			//Antag associated faction.
	var/antag_vis = "Shared"			//How visible antag association is to others.

		//Mob preview
	var/icon/preview_icon = null

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

	var/job_govlaw_high = 0
	var/job_govlaw_med = 0
	var/job_govlaw_low = 0

	// Money related

	var/money_balance = 0
	var/bank_pin
	var/bank_account

	var/datum/expense/expenses = list()

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 1

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list() // skills can range from 0 to 3

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	var/list/player_alt_titles = new()		// the default name of a job like "Doctor"

	var/list/body_markings = list() // "name" = "#rgbcolor"

	var/list/flavor_texts = list()
	var/list/flavour_texts_robot = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""

	var/list/datum/record/police/crime_record = list()
	var/list/datum/record/hospital/health_record = list()
	var/list/datum/record/employment/job_record = list()

	var/exploit_record = ""

	// Antag and Prison stuff

	var/criminal_status = "None"

	var/disabilities = 0

	var/economic_status = "Working Class"
	var/social_class = "Working Class"
	var/SINless = FALSE

	var/uplinklocation = "PDA"
	var/email

	// OOC Metadata:
	var/metadata = ""
	var/list/ignored_players = list()

	var/client/client = null
	var/client_ckey = null
	var/unique_id

	// Communicator identity data
	var/communicator_visibility = 1

	//Silent joining for shenanigans
	var/silent_join = 0

	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

	var/lastnews // Hash of last seen lobby news content.

	var/existing_character = 0 //when someone spawns with this character for the first time or confirms, it's set to 1.
	var/played = 0 //this will set to 1 once someone plays this character on a canon round.

	//Cooldowns for saving/loading. These are four are all separate due to loading code calling these one after another
	var/saveprefcooldown
	var/loadprefcooldown
	var/savecharcooldown
	var/loadcharcooldown

	var/cyber_control = FALSE //Allows players to use cyberware on spawn

/datum/preferences/New(client/C)
	player_setup = new(src)
	set_biological_gender(pick(MALE, FEMALE))
	real_name = random_name(identifying_gender,species)
	b_type = RANDOM_BLOOD_TYPE

	gear = list()
	gear_list = list()
	gear_slot = 1

	if(istype(C))
		client = C
		client_ckey = C.ckey
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())


					return

/datum/preferences/proc/ZeroSkills(var/forced = 0)
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		if(!skills.Find(S.ID) || forced)
			skills[S.ID] = SKILL_NONE

/datum/preferences/proc/CalculateSkillPoints()
	used_skillpoints = 0
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		var/multiplier = 1
		switch(skills[S.ID])
			if(SKILL_NONE)
				used_skillpoints += 0 * multiplier
			if(SKILL_BASIC)
				used_skillpoints += 1 * multiplier
			if(SKILL_ADEPT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 1 * multiplier
				else
					used_skillpoints += 3 * multiplier
			if(SKILL_EXPERT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 3 * multiplier
				else
					used_skillpoints += 6 * multiplier

/datum/preferences/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/CalculateSkillClass(points, age)
	if(points <= 0) return "Unconfigured"
	// skill classes describe how your character compares in total points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(-1000 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return

	if(!get_mob_by_key(client_ckey))
		user << "<span class='danger'>No mob exists for the given client!</span>"
		close_load_dialog(user)
		return

	var/dat = "<html><body><center>"

	if(path)
		dat += "Slot - "
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a> - "
		dat += "<a href='?src=\ref[src];resetslot=1'>Reset slot</a> - "
		dat += "<a href='?src=\ref[src];deleteslot=1'>Delete slot</a>"

	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)

	dat += "</html></body>"
	//user << browse(dat, "window=preferences;size=635x736")
	var/datum/browser/popup = new(user, "Character Setup","Character Setup", 800, 800, src)
	popup.set_content(dat)
	popup.open()

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	if(href_list["preference"] == "open_whitelist_forum")
		if(config.forumurl)
			user << link(config.forumurl)
		else
			user << "<span class='danger'>The forum URL is not set in the server configuration.</span>"
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_preferences()
		save_character()
		make_existing()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["changeslot"])
		load_character(text2num(href_list["changeslot"]))
		sanitize_preferences()
		close_load_dialog(usr)
	else if(href_list["resetslot"])
		if("No" == alert("This will reset the current slot. Continue?", "Reset current slot?", "No", "Yes"))
			return 0
		load_character(SAVE_RESET)
		sanitize_preferences()
	else if(href_list["deleteslot"])
		if("No" == alert("This will delete the current slot. If you do this, you WON'T be able to play this character again. Continue?", "Delete current slot?", "No", "Yes"))
			return 0
		if("No" == alert("Just making sure - If there is something you need adjusted, contact an admin instead of deleting this slot. This will make a character with this name unplayable and can be treated as permadeath, the game won't allow you to play a character with the same name. Continue?", "Delete current slot?", "No", "Yes"))
			return 0
		delete_character()
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = TRUE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()

	// This needs to happen before anything else becuase it sets some variables.
	character.set_species(species)
	// Special Case: This references variables owned by two different datums, so do it here.
//	if(be_random_name)
//		real_name = random_name(identifying_gender,species)


	// Ask the preferences datums to apply their own settings to the new mob
	player_setup.copy_to_mob(character)

	if(icon_updates)
		character.force_update_limbs()
		character.update_icons_body()
		character.update_mutations()
		character.update_underwear()
		character.update_hair()

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body><center>"

	var/savefile/S = new /savefile(path)
	if(S)
		dat += "<h1>Character Selection<h1><br>"
		dat += "<b>Currently selected: </b>"
		dat += "<a href='?src=\ref[src];changeslot=[default_slot]'>[real_name]</a><br>"
		dat += "Select a character slot to load:<hr>"
		var/name
		for(var/i=1, i<= config.character_slots, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)	name = "Empty Slot [i]"
			if(i==default_slot)
				name = "[name]"
			dat += "<a href='?src=\ref[src];changeslot=[i]'>[name]</a><br>"

	dat += "</center></body>"
	//user << browse(dat, "window=saves;size=300x390")
	panel = new(user, "Character Slots", "Character Slots", 300, 420, src)
	panel.set_content(dat)
	panel.open()

/datum/preferences/proc/close_load_dialog(mob/user)
	//user << browse(null, "window=saves")
	panel.close()

/datum/preferences/proc/make_existing()
	existing_character = 1
	return 1

/datum/preferences/proc/make_editable()
	existing_character = 0
	return 1


/datum/preferences/proc/is_synth() // lets us know if this is a non-FBP synth
	if(O_BRAIN in organ_data)
		switch(organ_data[O_BRAIN])
			if("mechanical")
				return PREF_FBP_POSI
			if("digital")
				return PREF_FBP_SOFTWARE

	return FALSE

/datum/preferences/proc/is_fbp() // lets us know if this is a non-FBP synth
	if(O_BRAIN in organ_data)
		switch(organ_data[O_BRAIN])
			if("assisted")
				return PREF_FBP_CYBORG

	return FALSE

/datum/preferences/proc/get_birthplace_abbrev() // Used to generate a SIN
	switch(birthplace)
		if("Africa")
			return "AFRO"
		if("Asia")
			return "AISA"
		if("Europe")
			return "EURO"
		if("Oceania")
			return "OCE"
		if("North America")
			return "NA"
		if("South America")
			return "SA"
		if("Luna")
			return "LUNA"