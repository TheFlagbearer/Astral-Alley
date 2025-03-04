
#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2


SUBSYSTEM_DEF(jobs)
	name = "Jobs"
	init_order = INIT_ORDER_JOBS
	flags = SS_NO_FIRE

	//List of all jobs
	var/list/occupations = list()
	//Players who need jobs
	var/list/unassigned = list()
	//Debug info
	var/list/job_debug = list()

	var/list/prioritized_jobs = list()
	var/list/job_mannequins = list()				//Cache of icons for job info window

/datum/controller/subsystem/jobs/Initialize(timeofday)
	SetupOccupations()
	SetupJobCache()
	LoadJobs("config/jobs.txt")

	admin_notice("<span class='danger'>Job setup complete</span>", R_DEBUG)

	return ..()


/datum/controller/subsystem/jobs/proc/SetupJobCache()
	for(var/datum/job/J in occupations)
		J.get_job_mannequin()


/datum/controller/subsystem/jobs/proc/SetupOccupations(var/faction = "City")
	occupations = list()
	//var/list/all_jobs = typesof(/datum/job)
	var/list/all_jobs = list(/datum/job/assistant) | using_map.allowed_jobs
	if(!all_jobs.len)
		world << "<span class='warning'>Error setting up jobs, no job datums found!</span>"
		return 0
	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job)	continue
		if(job.faction != faction)	continue
		occupations += job
	sortTim(occupations, /proc/cmp_job_datums)


	return 1

/datum/controller/subsystem/jobs/proc/Debug(var/text)
	if(!Debug2)	return 0
	job_debug.Add(text)
	return 1

/datum/controller/subsystem/jobs/proc/GetJob(var/rank)
	if(!rank)	return null
	for(var/datum/job/J in occupations)
		if(!J)	continue
		if(J.title == rank)	return J
	return null

/datum/controller/subsystem/jobs/proc/GetPlayerAltTitle(mob/new_player/player, rank)
	return player.client.prefs.GetPlayerAltTitle(GetJob(rank))

/datum/controller/subsystem/jobs/proc/AssignRole(var/mob/new_player/player, var/rank, var/latejoin = 0)
	Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	if(player && player.mind && rank)
		var/datum/job/job = GetJob(rank)
		if(!job)
			return 0
		if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
			return 0
		if(jobban_isbanned(player, rank))
			return 0
		if(!job.player_old_enough(player.client))
			return 0
		if(!is_hard_whitelisted(player, job))
			return 0
		if(job.clean_record_required && !isemptylist(player.client.prefs.crime_record) )
			return 0
		if((player.client.prefs.criminal_status == "Incarcerated") && job.title != "Prisoner")
			return 0
		if(player.client.prefs.is_synth() && !job.allows_synths)
			return 0
		if(player.client.prefs.SINless && !job.allows_sinless)
			return 0

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
			player.mind.assigned_role = rank
			player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
			unassigned -= player
			job.current_positions++
			return 1
	Debug("AR has failed, Player: [player], Rank: [rank]")
	return 0

/datum/controller/subsystem/jobs/proc/FreeRole(var/rank)	//making additional slot on the fly
	var/datum/job/job = GetJob(rank)
	if(job && job.total_positions != -1)
		job.total_positions++
		return 1
	return 0

/datum/controller/subsystem/jobs/proc/FindOccupationCandidates(datum/job/job, level, flag)
	Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned)
		if(jobban_isbanned(player, job.title))
			Debug("FOC isbanned failed, Player: [player]")
			continue
		if(!is_hard_whitelisted(player, job))
			Debug("FOC not hard whitelisted failed, Player: [player]")
			continue
		if(!job.player_old_enough(player.client))
			Debug("FOC player not old enough, Player: [player]")
			continue
		if((player.client.prefs.criminal_status == "Incarcerated") && job.title != "Prisoner") //CASSJUMP
			Debug("DO player is prisoner, Player: [player], Job:[job.title]")
			continue
		if(job.clean_record_required && !isemptylist(player.client.prefs.crime_record) )
			Debug("DO player needs clean record, Player: [player], Job:[job.title]")
			continue
		if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
			Debug("FOC character not old enough, Player: [player]")
			continue
		if(flag && (!player.client.prefs.be_special & flag))
			Debug("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.client.prefs.is_synth() && !job.allows_synths)
			Debug("FOC job does not allow synths, Player: [player]")
			continue
		if(player.client.prefs.SINless && !job.allows_sinless)
			Debug("FOC job does not allow SINless, Player: [player]")
			continue

		if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
			Debug("FOC pass, Player: [player], Level:[level]")
			candidates += player



	return candidates

/datum/controller/subsystem/jobs/proc/GiveRandomJob(var/mob/new_player/player)
	Debug("GRJ Giving random job, Player: [player]")
	for(var/datum/job/job in shuffle(occupations))
		if(!job)
			continue

		if(job.minimum_character_age && (player.client.prefs.age < job.minimum_character_age))
			continue

		if(istype(job, GetJob("Civilian"))) // We don't want to give him assistant, that's boring!
			continue

		if(job.title in command_positions) //If you want a command position, select it!
			continue

		if(jobban_isbanned(player, job.title))
			Debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue
		if((player.client.prefs.criminal_status == "Incarcerated") && job.title != "Prisoner") //CASSJUMP
			Debug("DO player is prisoner, Player: [player], Job:[job.title]")
			continue
		if(!job.player_old_enough(player.client))
			Debug("GRJ player not old enough, Player: [player], Job: [job.title]")
			continue
		if(job.clean_record_required && !isemptylist(player.client.prefs.crime_record) )
			Debug("DO player needs clean record, Player: [player], Job:[job.title]")
			continue
		if(!is_hard_whitelisted(player, job))
			Debug("GRJ not hard whitelisted failed, Player: [player]")
			continue
		if(player.client.prefs.is_synth() && !job.allows_synths)
			Debug("GRJ job does not allow synths, Player: [player]")
			continue
		if(player.client.prefs.SINless && !job.allows_sinless)
			Debug("GRJ job does not allow SINless, Player: [player]")
			continue

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			Debug("GRJ Random job given, Player: [player], Job: [job]")
			AssignRole(player, job.title)
			unassigned -= player
			break

/datum/controller/subsystem/jobs/proc/ResetOccupations()
	for(var/mob/new_player/player in player_list)
		if((player) && (player.mind))
			player.mind.assigned_role = null
			player.mind.special_role = null
	SetupOccupations()
	unassigned = list()
	return


	///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/subsystem/jobs/proc/FillHeadPosition()
	for(var/level = 1 to 3)
		for(var/command_position in command_positions)
			var/datum/job/job = GetJob(command_position)
			if(!job)	continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)	continue

			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!V.client) continue
				var/age = V.client.prefs.age

				if(age < job.minimum_character_age) // Nope.
					continue

				switch(age)
					if(job.minimum_character_age to (job.minimum_character_age+10))
						weightedCandidates[V] = 3 // Still a bit young.
					if((job.minimum_character_age+10) to (job.ideal_character_age-10))
						weightedCandidates[V] = 6 // Better.
					if((job.ideal_character_age-10) to (job.ideal_character_age+10))
						weightedCandidates[V] = 10 // Great.
					if((job.ideal_character_age+10) to (job.ideal_character_age+20))
						weightedCandidates[V] = 6 // Still good.
					if((job.ideal_character_age+20) to INFINITY)
						weightedCandidates[V] = 3 // Geezer.
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(candidates.len == 1) weightedCandidates[V] = 1


			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(AssignRole(candidate, command_position))
				return 1
	return 0

	///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/subsystem/jobs/proc/CheckHeadPositions(var/level)
	for(var/command_position in command_positions)
		var/datum/job/job = GetJob(command_position)
		if(!job)	continue
		var/list/candidates = FindOccupationCandidates(job, level)
		if(!candidates.len)	continue
		var/mob/new_player/candidate = pick(candidates)
		AssignRole(candidate, command_position)
	return



/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/jobs/proc/DivideOccupations()
	//Setup new player list and get the jobs list
	Debug("Running DO")
	SetupOccupations()

	//Holder for Triumvirate is stored in the ticker, this just processes it
	if(ticker && ticker.triai)
		for(var/datum/job/A in occupations)
			if(A.title == "AI")
				A.spawn_positions = 3
				break

	//Get the players who are ready
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned += player

	Debug("DO, Len: [unassigned.len]")
	if(unassigned.len == 0)	return 0

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	HandleFeedbackGathering()

	//People who wants to be assistants, sure, go on.
	Debug("DO, Running Assistant Check 1")
	var/datum/job/assist = new DEFAULT_JOB_TYPE ()
	var/list/assistant_candidates = FindOccupationCandidates(assist, 3)
	Debug("AC1, Candidates: [assistant_candidates.len]")
	for(var/mob/new_player/player in assistant_candidates)
		Debug("AC1 pass, Player: [player]")
		AssignRole(player, "Civilian")
		assistant_candidates -= player
	Debug("DO, AC1 end")

	//Select one head
	Debug("DO, Running Head Check")
	FillHeadPosition()
	Debug("DO, Head Check end")

	//Other jobs are now checked
	Debug("DO, Running Standard Check")


	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(occupations)
	// var/list/disabled_jobs = ticker.mode.disabled_jobs  // So we can use .Find down below without a colon.
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		CheckHeadPositions(level)

		// Loop through all unassigned players
		for(var/mob/new_player/player in unassigned)

			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(!job || ticker.mode.disabled_jobs.Find(job.title) )
					continue

				if(jobban_isbanned(player, job.title))
					Debug("DO isbanned failed, Player: [player], Job:[job.title]")
					continue

				if(!job.player_old_enough(player.client))
					Debug("DO player not old enough, Player: [player], Job:[job.title]")
					continue
				if(!is_hard_whitelisted(player, job))
					Debug("DO not hard whitelisted failed, Player: [player], Job:[job.title]")
					continue
				if(job.clean_record_required && !isemptylist(player.client.prefs.crime_record) )
					Debug("DO player needs clean record, Player: [player], Job:[job.title]")
					continue
				if((player.client.prefs.criminal_status == "Incarcerated") && job.title != "Prisoner") //CASSJUMP
					Debug("DO player is prisoner, Player: [player], Job:[job.title]")
					continue
				if(player.client.prefs.is_synth() && !job.allows_synths)
					Debug("DO job does not allow synths, Player: [player]")
					continue
				if(player.client.prefs.SINless && !job.allows_sinless)
					Debug("DO job does not allow SINless, Player: [player]")
					continue

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
						AssignRole(player, job.title)
						unassigned -= player
						break

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			GiveRandomJob(player)
	/*
	Old job system
	for(var/level = 1 to 3)
		for(var/datum/job/job in occupations)
			Debug("Checking job: [job]")
			if(!job)
				continue
			if(!unassigned.len)
				break
			if((job.current_positions >= job.spawn_positions) && job.spawn_positions != -1)
				continue
			var/list/candidates = FindOccupationCandidates(job, level)
			while(candidates.len && ((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
				var/mob/new_player/candidate = pick(candidates)
				Debug("Selcted: [candidate], for: [job.title]")
				AssignRole(candidate, job.title)
				candidates -= candidate*/

	Debug("DO, Standard Check end")

	Debug("DO, Running AC2")

	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			Debug("AC2 Assistant located, Player: [player]")
			AssignRole(player, "Civilian")

	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.new_player_panel_proc()
			unassigned -= player
	return 1

/datum/controller/subsystem/jobs/proc/EquipRank(var/mob/living/carbon/human/H, var/rank, var/joined_late = 0)
	if(!H)	return null

	var/datum/job/job = GetJob(rank)
	var/list/spawn_in_storage = list()

	if(!joined_late || job.no_shuttle)
		var/obj/S = null
		for(var/obj/effect/landmark/start/sloc in landmarks_list)
			if(sloc.name != rank)	continue
			if(locate(/mob/living) in sloc.loc)	continue
			S = sloc
			break
		if(!S)
			S = locate("start*[rank]") // use old stype
		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.forceMove(S.loc)
		else
			var/list/spawn_props = LateSpawn(H.client, rank)
			var/turf/T = spawn_props["turf"]
			H.forceMove(T)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	if(job)

		//Equip custom gear loadout.
		var/list/custom_equip_slots = list() //If more than one item takes the same slot, all after the first one spawn in storage.
		var/list/custom_equip_leftovers = list()
		if(H.client.prefs.gear && H.client.prefs.gear.len && job.title != "Cyborg" && job.title != "AI" && job.title != "Prisoner")
			for(var/thing in H.client.prefs.gear)
				var/datum/gear/G = gear_datums[thing]
				if(G)
					var/permitted
					if(G.allowed_roles)
						for(var/job_name in G.allowed_roles)
							if(job.title == job_name)
								permitted = 1
					else
						permitted = 1

					if(G.whitelisted && !is_alien_whitelisted(H, all_species[G.whitelisted]))

					//if(G.whitelisted && (G.whitelisted != H.species.name || !is_alien_whitelisted(H, G.whitelisted)))
						permitted = 0

					if(!permitted)
						to_chat(H, "<span class='warning'>Your current species, job or whitelist status does not permit you to spawn with [thing]!</span>")
						continue

					// Implants get special treatment
					if(G.sort_category == "Cyberware")
						var/obj/item/weapon/implant/I = G.spawn_item(H)
						I.invisibility = 100
						I.implant_loadout(H)
						continue

					// Try desperately (and sorta poorly) to equip the item. Now with increased desperation!
					if(G.slot && !(G.slot in custom_equip_slots))
						var/metadata = H.client.prefs.gear[G.display_name]
						if(G.slot == slot_wear_mask || G.slot == slot_wear_suit || G.slot == slot_head)
							custom_equip_leftovers += thing
						else if(H.equip_to_slot_or_del(G.spawn_item(H, metadata), G.slot))
							to_chat(H, "<span class='notice'>Equipping you with \the [thing]!</span>")
							if(G.slot != slot_tie)
								custom_equip_slots.Add(G.slot)
						else
							custom_equip_leftovers.Add(thing)
					else
						spawn_in_storage += thing
		//Equip job items.
		job.setup_account(H)
		job.equip(H, H.mind ? H.mind.role_alt_title : "")
		job.equip_backpack(H)
		job.apply_fingerprints(H)

	//	equip_passport(H)
		equip_permits(H)
		if(job.title != "Cyborg" && job.title != "AI")
			H.equip_post_job()

		//Robolimb Control
		if(H.client.prefs.cyber_control)
			var/obj/item/weapon/implant/neural/N = new /obj/item/weapon/implant/neural
			N.invisibility = 100
			N.implant_loadout(H)

		//If some custom items could not be equipped before, try again now.
		for(var/thing in custom_equip_leftovers)
			var/datum/gear/G = gear_datums[thing]
			if(G.slot in custom_equip_slots)
				spawn_in_storage += thing
			else
				var/metadata = H.client.prefs.gear[G.display_name]
				if(H.equip_to_slot_or_del(G.spawn_item(H, metadata), G.slot))
					to_chat(H, "<span class='notice'>Equipping you with \the [thing]!</span>")
					custom_equip_slots.Add(G.slot)
				else
					spawn_in_storage += thing
	else
		to_chat(H, "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator.")

	H.job = rank

	var/alt_title = null
	var/is_prisoner = FALSE

	if(H.mind)
		H.mind.assigned_role = rank
		alt_title = H.mind.role_alt_title

		switch(rank)
			if("Cyborg")
				return H.Robotize()
			if("AI")
				return H
			if("Mayor")
				if(!H.mind.prefs.silent_join)
					var/sound/announce_sound = (ticker.current_state <= GAME_STATE_SETTING_UP)? null : sound('sound/misc/boatswain.ogg', volume=20)
					captain_announcement.Announce("The [alt_title ? alt_title : "Mayor"] [H.real_name] has arrived to the city.", new_sound=announce_sound)
			if("President")
				if(!H.mind.prefs.silent_join)
					var/sound/announce_sound = (ticker.current_state <= GAME_STATE_SETTING_UP)? null : sound('sound/misc/fanfare_prez.ogg', volume=20)
					captain_announcement.Announce("[alt_title ? alt_title : "President"] [H.real_name] is visiting the city!", new_sound=announce_sound)
			if("Governor")
				if(!H.mind.prefs.silent_join)
					var/sound/announce_sound = (ticker.current_state <= GAME_STATE_SETTING_UP)? null : sound('sound/misc/boatswain.ogg', volume=20)
					captain_announcement.Announce("[alt_title ? alt_title : "Governor"] [H.real_name] is visiting the city!", new_sound=announce_sound)

			if("Prisoner")
				is_prisoner = TRUE

		if(!is_prisoner)
			//Deferred item spawning.
			if(spawn_in_storage && spawn_in_storage.len)
				var/obj/item/weapon/storage/B
				for(var/obj/item/weapon/storage/S in H.contents)
					B = S
					break

				if(!isnull(B))
					for(var/thing in spawn_in_storage)
						to_chat(H, "<span class='notice'>Placing \the [thing] in your [B.name]!</span>")
						var/datum/gear/G = gear_datums[thing]
						var/metadata = H.client.prefs.gear[G.display_name]
						var/obj/new_item = G.spawn_item(B, metadata)

						B.add_fingerprint(H)
						new_item.add_fingerprint(H)

				else
					to_chat(H, "<span class='danger'>Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug.</span>")

	if(istype(H)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
		var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
		var/obj/item/weapon/storage/S = locate() in H.contents
		var/obj/item/wheelchair/R = null
		if(S)
			R = locate() in S.contents
		if(!l_foot || !r_foot || R)
			var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(H.loc)
			W.buckle_mob(H)
			H.update_canmove()
			W.set_dir(H.dir)
			W.add_fingerprint(H)
			if(R)
				W.color = R.color
				qdel(R)

	to_chat(H, "<B>You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B>")

	if(job.idtype)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
		to_chat(H, "<b>To speak on your department's radio channel use :h. For the use of other channels, examine your headset.</b>")

	if(job.supervisors)
		to_chat(H, "<b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>")

	if(job.req_admin_notify)
		to_chat(H, "<b>You are playing a job that is important for Game Progression. If you have to disconnect, ensure that you cryo first to free up your job slot.</b>")


	var/complete_login = H.client.prefs.email
	var/datum/computer_file/data/email_account/EA

	var/datum/computer_file/data/email_account/job_email = get_email(job.get_job_email())

	// If someone already joined and email is already in-game.
	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		if(account.login == H.client.prefs.email)
			H.mind.initial_email = account
			EA = account
			break

	if(H.client.prefs.email && !SSemails.check_persistent_email(H.client.prefs.email))
		SSemails.new_persistent_email(H.client.prefs.email) // so this saves without having to make dupes over and over.
		EA = SSemails.manifest_persistent_email(H.client.prefs.email)

	if(!EA)
		EA = new/datum/computer_file/data/email_account()
		EA.password = SSemails.get_persistent_email_password(complete_login)
		EA.login = complete_login


	if(SSemails.check_persistent_email(H.client.prefs.email))
		EA.get_persistent_data()

	if(!EA.password)
		EA.password = GenerateKey()

	if(!EA.login)
		EA.login = H.client.prefs.email

	H.mind.initial_email_login = list("login" = "[EA.login]", "password" = "[EA.password]")
	H.mind.initial_email = EA




	if(job_email)
		to_chat(H, "Your workplace's email address is <b>[job_email.login]</b> and the password is <b>[job_email.password]</b>.")
	to_chat(H, "Your personal email address is <b>[EA.login]</b> and the password is <b>[EA.password]</b>. This information has also been placed into your notes.")
	H.mind.store_memory("Your email account address is [EA.login] and the password is [EA.password].")
	if(job_email)
		H.mind.store_memory("Your workplace account address is [job_email.login] and the password is [job_email.password].")

	var/new_msgs = 0

	for(var/datum/computer_file/data/email_message/EM in EA.inbox)
		if(EM.read)
			continue
		new_msgs++

	if(new_msgs)
		to_chat(H, "<font size=3><span class='notice'>You have <b>[new_msgs]</b> unread email(s).</span></font>")
		to_chat(H, "Check your email inbox from one of the computers or your communicator to access them..")


	// END EMAIL GENERATION


	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
		if(equipped != 1)
			var/obj/item/clothing/glasses/G = H.glasses
			G.add_fingerprint(H)
			G.prescription = 1

	spawnId(H, rank, alt_title)

	//Gives the SINless their camera evasion abilities
	disable_sinless_tracking(H)

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)

	return H





/datum/controller/subsystem/jobs/proc/spawnId(var/mob/living/carbon/human/H, rank, title)
	if(!H)
		return 0

	var/obj/item/weapon/card/id/C = H.get_equipped_item(slot_wear_id)

	var/datum/job/job = null
	for(var/datum/job/J in occupations)
		if(J.title == rank)
			job = J
			break
	if(job)
		if(job.title == "Cyborg")
			return
		else
			C = new job.idtype(H)
			C.access += job.get_access()

	else
		C = new /obj/item/weapon/card/id(H)

	if(C)
		C.rank = rank
		C.assignment = title ? title : rank
		H.set_id_info(C)

		//put the player's account number onto the ID
		if(H.mind)
			if(H.mind.initial_account)
				C.associated_account_number = H.mind.initial_account.account_number
				C.associated_pin_number = H.mind.initial_account.remote_access_pin

		if((!H.mind.prefs.SINless) || job.allows_sinless)
			H.equip_to_slot_or_del(C, slot_wear_id)

		//if you're a business owner, you get all the accesses your business has no matter what job you choose.
		var/datum/business/B = get_business_by_owner_uid(H.mind.prefs.unique_id)
		if(B)
			for(var/V in B.business_accesses)
				C.access |= V

		//business access compatibility? why. don't ask me.
		if(job.business)
			for(var/V in job.access)
				C.access |= job.access

	return 1



/datum/controller/subsystem/jobs/proc/LoadJobs(jobsfile) //ran during round setup, reads info from jobs.txt -- Urist
	if(!config.load_jobs_from_txt)
		return 0

	var/list/jobEntries = file2list(jobsfile)

	for(var/job in jobEntries)
		if(!job)
			continue

		job = trim(job)
		if (!length(job))
			continue

		var/pos = findtext(job, "=")
		var/name = null
		var/value = null

		if(pos)
			name = copytext(job, 1, pos)
			value = copytext(job, pos + 1)
		else
			continue

		if(name && value)
			var/datum/job/J = GetJob(name)
			if(!J)	continue
			J.total_positions = text2num(value)
			J.spawn_positions = text2num(value)
			if(name == "AI" || name == "Cyborg")//I dont like this here but it will do for now
				J.total_positions = 0

	return 1

/datum/controller/subsystem/jobs/proc/HandleFeedbackGathering()
	for(var/datum/job/job in occupations)
		var/tmp_str = "|[job.title]|"

		var/level1 = 0 //high
		var/level2 = 0 //medium
		var/level3 = 0 //low
		var/level4 = 0 //never
		var/level5 = 0 //banned
		var/level6 = 0 //account too young
		for(var/mob/new_player/player in player_list)
			if(!(player.ready && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(jobban_isbanned(player, job.title))
				level5++
				continue
			if(!is_hard_whitelisted(player, job))
				level5++
				continue
			if(!job.player_old_enough(player.client))
				level6++
				continue
			if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
				level1++
			else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
				level2++
			else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
				level3++
			else level4++ //not selected

		tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|YOUNG=[level6]|-"
		feedback_add_details("job_preferences",tmp_str)

/datum/controller/subsystem/jobs/proc/LateSpawn(var/client/C, var/rank)

	var/datum/spawnpoint/spawnpos

	//Handling Prisoners
	if(C.prefs.criminal_status == "Incarcerated")
		spawnpos = spawntypes["Prison"]
	else
		//Spawn them at their preferred one
		if(C && C.prefs.spawnpoint)
			if(!(C.prefs.spawnpoint in using_map.allowed_spawns))
				to_chat(C, "<span class='warning'>Your chosen spawnpoint ([C.prefs.spawnpoint]) is unavailable for the current map. Spawning you at one of the enabled spawn points instead.</span>")
				spawnpos = null
			else
				spawnpos = spawntypes[C.prefs.spawnpoint]

	//We will return a list key'd by "turf" and "msg"
	. = list("turf","msg")
	if(spawnpos && istype(spawnpos) && spawnpos.turfs.len)
		if(spawnpos.check_job_spawning(rank))
			.["turf"] = spawnpos.get_spawn_position()
			.["msg"] = spawnpos.msg
		else
			to_chat(C,"Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Spawning you at the Airbus instead.")
			var/spawning = pick(latejoin)
			.["turf"] = get_turf(spawning)
			.["msg"] = "will arrive to the city shortly by airbus"
	else
		var/spawning = pick(latejoin)
		.["turf"] = get_turf(spawning)
		.["msg"] = "has arrived to the city"

/*
/datum/controller/subsystem/jobs/proc/equip_passport(var/mob/living/carbon/human/H)
	var/obj/item/weapon/passport/pass = new/obj/item/weapon/passport(get_turf(H))

	if(!H.mind || !H.mind.prefs) return

	pass.name = "[H.real_name]'s passport"
	pass.citizenship = H.mind.prefs.birthplace
	pass.owner = H.real_name

	H.update_passport(pass)
	H.equip_to_slot_or_del(pass, slot_in_backpack)
*/
/datum/controller/subsystem/jobs/proc/equip_permits(var/mob/living/carbon/human/H)
	if(!H.mind || !H.mind.prefs) return

	var/synth_type = H.get_FBP_type()
	var/is_mpl_vatborn = (H.get_species() == SPECIES_HUMAN_VATBORN_MPL)
	var/obj/item/clothing/uniform = H.w_uniform
	var/obj/item/clothing/accessory/permit/permit

	switch(synth_type)
		if(FBP_NONE)
			return

		if(FBP_DRONE)
			permit = new/obj/item/clothing/accessory/permit/drone(get_turf(H))

		if(FBP_POSI)
			permit = new/obj/item/clothing/accessory/permit/synth(get_turf(H))

		if(FBP_CYBORG)
			permit = new/obj/item/clothing/accessory/permit/fbp(get_turf(H))


	if(permit)
		permit.set_name(H.real_name)

		if(uniform && uniform.can_attach_accessory(permit)) // attaches permit to uniform
			uniform.attach_accessory(null, permit)
		else
			H.equip_to_slot_or_del(permit, slot_in_backpack) // otherwise puts it in your backpack

	if(is_mpl_vatborn)
		permit = new/obj/item/clothing/accessory/permit/vatborn

		permit.set_name(H.real_name)
		if(uniform && uniform.can_attach_accessory(permit)) // attaches permit to uniform
			uniform.attach_accessory(null, permit)
		else
			H.equip_to_slot_or_del(permit, slot_in_backpack) // otherwise puts it in your backpack


/datum/controller/subsystem/jobs/proc/get_active_police()

	var/active_popo = 0

	for(var/J in security_positions)
		var/datum/job/police_officer = SSjobs.GetJob(J)

		if(!police_officer)
			continue

		active_popo += police_officer.get_active()

	return active_popo

/datum/controller/subsystem/jobs/proc/disable_sinless_tracking(var/mob/living/carbon/human/H)
	if((!H.mind) || (!H.mind.prefs) || !H.mind.prefs.SINless) return

	H.add_modifier(/datum/modifier/disable_tracking)