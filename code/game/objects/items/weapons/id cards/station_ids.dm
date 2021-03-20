/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the city."
	icon_state = "id"
	item_state = "card-id"

	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/id.dmi'
		)

	var/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID | SLOT_EARS

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	var/primary_color = rgb(0,0,0) // Obtained by eyedroppering the stripe in the middle of the card
	var/secondary_color = rgb(0,0,0) // Likewise for the oval in the top-left corner

	var/datum/job/job_access_type = /datum/job/assistant    // Job type to acquire access rights from, if any

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

	var/unique_ID			// character's unique ID
	var/list/associated_email_login = list("login" = "", "password" = "")

/obj/item/weapon/card/id/examine(mob/user)
	set src in oview(1)
	if(in_range(usr, src))
		show(usr)
		usr << desc
	else
		usr << "<span class='warning'>It is too far away.</span>"

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/proc/show(mob/user as mob)
	if(front && side)
		user << browse_rsc(front, "front.png")
		user << browse_rsc(side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/card/id/proc/update_name()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	var/icon/charicon = cached_character_icon(M)
	front = icon(charicon,dir = SOUTH)
	side = icon(charicon,dir = WEST)

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	if(!id_card)
		return 0

	id_card.age = age
	if(mind)
		id_card.associated_email_login = list("login" = "[mind.prefs.email]", "password" = "[SSemails.get_persistent_email_password(mind.prefs.email)]")
		id_card.unique_ID = mind.prefs.unique_id

	return 1

/obj/item/weapon/card/id/proc/dat()
	var/dat = ("<table><tr><td>")
	dat += text("Name: []</A><BR>", registered_name)
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)
	dat += text("Occupation: []</A><BR>\n", assignment)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4><img src=side.png height=80 width=80 border=4></td>"
	dat += "</tr></table>"
	return dat

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: \icon[src] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: \icon[src] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	usr << "The blood type on the card is [blood_type]."
	usr << "The DNA hash on the card is [dna_hash]."
	usr << "The fingerprint hash on the card is [fingerprint_hash]."
	return

/obj/item/weapon/card/id/get_worn_icon_state(var/slot_name)
	if(slot_name == slot_wear_id_str)
		return "id" //Legacy, just how it is. There's only one sprite.

	return ..()

/obj/item/weapon/card/id/initialize()
	. = ..()
	var/datum/job/J = SSjobs.GetJob(rank)
	if(J)
		access = J.get_access()

/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/silver/secretary
	assignment = "City Hall Guard"
	rank = "City Hall Guard"
	job_access_type = /datum/job/bguard

/obj/item/weapon/card/id/silver/hop
	assignment = "City Clerk"
	rank = "City Clerk"
	job_access_type = /datum/job/hop

/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"
	preserve_item = 1

/obj/item/weapon/card/id/gold/captain
	assignment = "Mayor"
	rank = "Mayor"
	job_access_type = /datum/job/captain

/obj/item/weapon/card/id/gold/captain/spare
	name = "\improper Mayor's spare ID"
	desc = "The spare ID of the High Lord himself."
	registered_name = "Mayor"
	job_access_type = /datum/job/captain

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/initialize()
	. = ..()
	access = get_all_station_access() + access_synth

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Central Command."
	icon_state = "nanotrasen"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/weapon/card/id/centcom/initialize()
	. = ..()
	access += get_all_centcom_access()

/obj/item/weapon/card/id/centcom/station/initialize()
	. = ..()
	access |= get_all_station_access()

// NT big bad IDs
/obj/item/weapon/card/id/nanotrasen
	icon_state = "nanotrasen"

/obj/item/weapon/card/id/nanotrasen/initialize()
	. = ..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/nanotrasen/ntrep
	name = "\improper Government Representative ID"
	desc = "An ID for Government Representative. You can smell the pompous."
	job_access_type = /datum/job/nanotrasen
	rank = "Government Representative"

/obj/item/weapon/card/id/nanotrasen/pdsi
	name = "\improper PDSI Agent ID"
	desc = "An ID straight from NanoTrasen for the PDSI."
	job_access_type = /datum/job/nanotrasen/pdsi
	rank = "Government Representative"

/obj/item/weapon/card/id/nanotrasen/president
	name = "\improper President's ID"
	desc = "An ID that reeks of appointed entitlement. For the president, naturally."
	job_access_type = /datum/job/nanotrasen/president
	rank = "President"

/obj/item/weapon/card/id/nanotrasen/ceo
	name = "\improper NanoTrasen CEO's ID"
	desc = "The head honcho themselves. This has access to anything that exists under the colonies."
	job_access_type = /datum/job/nanotrasen/ceo
	rank = "Nanotrasen CEO"

/obj/item/weapon/card/id/nanotrasen/governor
	name = "\improper Governor's ID"
	desc = "An ID for the city cler- assigned Governor of the colony."
	job_access_type = /datum/job/nanotrasen/governor
	rank = "Governor"

/obj/item/weapon/card/id/nanotrasen/advisor
	name = "\improper Advisor's ID"
	desc = "The president's advisors wear these, for whatever they actually do?"
	job_access_type = /datum/job/nanotrasen/advisor

/obj/item/weapon/card/id/nanotrasen/advisor/initialize()
	. = ..()
	access |= list(access_advisor, access_cent_general)

/obj/item/weapon/card/id/nanotrasen/justice
	name = "\improper Supreme Justice's ID"
	desc = "The high decider."
	job_access_type = /datum/job/nanotrasen/supreme_justice
	rank = "Supreme Justice"

// Emergency response team IDs

/obj/item/weapon/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"
	icon_state = "centcom"

/obj/item/weapon/card/id/centcom/ERT/initialize()
	. = ..()
	access |= get_all_station_access()

// Department-flavor IDs
/obj/item/weapon/card/id/medical
	name = "identification card"
	desc = "A card issued to city medical staff."
	icon_state = "med"
	primary_color = rgb(189,237,237)
	secondary_color = rgb(223,255,255)

/obj/item/weapon/card/id/medical/doctor
	assignment = "Doctor"
	rank = "Doctor"
	job_access_type = /datum/job/doctor

/obj/item/weapon/card/id/medical/chemist
	assignment = "Chemist"
	rank = "Chemist"
	job_access_type = /datum/job/chemist

/obj/item/weapon/card/id/medical/geneticist
	assignment = "Geneticist"
	rank = "Geneticist"
	job_access_type = /datum/job/doctor	//geneticist

/obj/item/weapon/card/id/medical/psychiatrist
	assignment = "Psychiatrist"
	rank = "Psychiatrist"
	job_access_type = /datum/job/psychiatrist

/obj/item/weapon/card/id/medical/paramedic
	assignment = "Paramedic"
	rank = "Paramedic"
	job_access_type = /datum/job/paramedic

/obj/item/weapon/card/id/medical/intern
	assignment = "Medical Intern"
	rank = "Medical Intern"
	job_access_type = /datum/job/medicalintern

/obj/item/weapon/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	icon_state = "medGold"
	primary_color = rgb(189,237,237)
	secondary_color = rgb(255,223,127)
	assignment = "Medical Director"
	rank = "Medical Director"
	job_access_type = /datum/job/cmo

/obj/item/weapon/card/id/security
	name = "identification card"
	desc = "A card issued to city security staff."
	icon_state = "sec"
	primary_color = rgb(189,47,0)
	secondary_color = rgb(223,127,95)

/obj/item/weapon/card/id/security/officer
	assignment = "Police Officer"
	rank = "Police Officer"
	job_access_type = /datum/job/officer

/obj/item/weapon/card/id/security/detective
	assignment = "Detective"
	rank = "Detective"
	job_access_type = /datum/job/detective

/obj/item/weapon/card/id/security/warden
	assignment = "Prison Warden"
	rank = "Prison Warden"
	job_access_type = /datum/job/warden

/obj/item/weapon/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	icon_state = "secGold"
	primary_color = rgb(189,47,0)
	secondary_color = rgb(255,223,127)
	assignment = "Chief of Police"
	rank = "Chief of Police"
	job_access_type = /datum/job/hos

/obj/item/weapon/card/id/engineering
	name = "identification card"
	desc = "A card issued to city engineering staff."
	icon_state = "eng"
	primary_color = rgb(189,94,0)
	secondary_color = rgb(223,159,95)
/*
/obj/item/weapon/card/id/engineering/engineer
	assignment = "City Engineer"
	rank = "City Engineer"
	job_access_type = /datum/job/engineer
*/
/obj/item/weapon/card/id/engineering/atmos
	assignment = "Maintenance Worker"
	rank = "Maintenance Worker"
	job_access_type = /datum/job/atmos

/obj/item/weapon/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	icon_state = "engGold"
	primary_color = rgb(189,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Maintenance Director"
	rank = "Maintenance Director"
	job_access_type = /datum/job/chief_engineer

/obj/item/weapon/card/id/science
	name = "identification card"
	desc = "A card issued to city science staff."
	icon_state = "sci"
	primary_color = rgb(142,47,142)
	secondary_color = rgb(191,127,191)

/obj/item/weapon/card/id/science/scientist
	assignment = "Scientist"
	rank = "Scientist"
	job_access_type = /datum/job/scientist

/obj/item/weapon/card/id/science/xenobiologist
	assignment = "Xenobiologist"
	rank = "Xenobiologist"
	job_access_type = /datum/job/xenobiologist

/obj/item/weapon/card/id/science/roboticist
	assignment = "Roboticist"
	rank = "Roboticist"
	job_access_type = /datum/job/roboticist

/obj/item/weapon/card/id/science/intern
	assignment = "Research Assistant"
	rank = "Research Assistant"
	job_access_type = /datum/job/scienceintern

/obj/item/weapon/card/id/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	icon_state = "sciGold"
	primary_color = rgb(142,47,142)
	secondary_color = rgb(255,223,127)
	assignment = "Research Director"
	rank = "Research Director"
	job_access_type = /datum/job/rd

/obj/item/weapon/card/id/cargo
	name = "identification card"
	desc = "A card issued to city cargo staff."
	icon_state = "cargo"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)

/obj/item/weapon/card/id/cargo/cargo_tech
	assignment = "Factory Worker"
	rank = "Factory Worker"
	job_access_type = /datum/job/cargo_tech

/obj/item/weapon/card/id/cargo/mining
	assignment = "Miner"
	rank = "Miner"
	job_access_type = /datum/job/mining

/obj/item/weapon/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	icon_state = "cargoGold"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Factory Manager"
	rank = "Factory Manager"
	job_access_type = /datum/job/qm

/obj/item/weapon/card/id/assistant
	assignment = "Civilian"
	rank = "Civilian"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/civilian
	name = "identification card"
	desc = "A card issued to city civilian staff."
	icon_state = "civ"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(95,159,191)
	assignment = "Civilian"
	rank = "Civilian"
	job_access_type = /datum/job/assistant

/obj/item/weapon/card/id/civilian/bartender
	assignment = "Bartender"
	rank = "Bartender"
	job_access_type = /datum/job/bartender

/obj/item/weapon/card/id/civilian/botanist
	assignment = "Botanist"
	rank = "Botanist"
	job_access_type = /datum/job/hydro

/obj/item/weapon/card/id/civilian/chaplain
	assignment = "Chaplain"
	rank = "Chaplain"
	job_access_type = /datum/job/chaplain

/obj/item/weapon/card/id/civilian/chef
	assignment = "Chef"
	rank = "Chef"
	job_access_type = /datum/job/chef

/obj/item/weapon/card/id/heads/judge
	assignment = "Judge"
	rank = "Judge"
	job_access_type = /datum/job/judge

/obj/item/weapon/card/id/security/prosecutor
	assignment = "District Prosecutor"
	rank = "District Prosecutor"
	job_access_type = /datum/job/prosecutor

/obj/item/weapon/card/id/civilian/defense
	assignment = "Defense Attorney"
	rank = "Defense Attorney"
	job_access_type = /datum/job/defense

/obj/item/weapon/card/id/civilian/secretary
	assignment = "City Hall Secretary"
	rank = "City Hall Secretary"
	job_access_type = /datum/job/secretary

/obj/item/weapon/card/id/civilian/barber
	assignment = "Barber"
	rank = "Barber"
	job_access_type = /datum/job/barber

/obj/item/weapon/card/id/civilian/janitor
	assignment = "Sanitation Technician"
	rank = "Sanitation Technician"
	job_access_type = /datum/job/janitor

/obj/item/weapon/card/id/civilian/journalist
	assignment = "Journalist"
	rank = "Journalist"
	job_access_type = /datum/job/journalist

/obj/item/weapon/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	icon_state = "civGold"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/external
	name = "identification card"
	desc = "An identification card of some sort. It does not look like it is issued by NT."
	icon_state = "permit"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)
