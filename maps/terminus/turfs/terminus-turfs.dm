/*
	There aren't enough new turfs to warrant separate folders. When the time comes, I'll split them up.
*/
/turf/simulated/floor/lunar
	name = "lunar surface"
	desc = "It's not made of cheese"
	icon = 'icons/turf/moon.dmi'
	icon_state = "asteroid"
	initial_flooring = /decl/flooring/lunar

/turf/simulated/floor/lunar/initialize()
	icon_state = "asteroid[rand(0,12)]"
	. = ..()

/turf/simulated/floor/martian
	name = "martian surface"
	desc = "Well? Is there life?"
	icon = 'icons/turf/mars.dmi'
	icon_state = "asteroid"
	initial_flooring = /decl/flooring/martian

/turf/simulated/floor/martian/initialize()
	icon_state = "asteroid[rand(0,12)]"
	. = ..()

/turf/simulated/floor/redspace
	name = "withered soil"
	desc = "Nothing good grows here."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "basalt"

/turf/simulated/floor/redspace/initialize()
	icon_state = "basalt[rand(0,12)]"
	. = ..()

/turf/simulated/floor/wasteland
	name = "wasteland"
	desc = "The ground walked by those left behind."
	icon = 'icons/turf/floors.dmi'
	icon_state = "wasteland"

/turf/simulated/floor/wasteland/initialize()
	icon_state = "wasteland[rand(0,12)]"
	. = ..()

/turf/simulated/floor/flesh
	name = "organic mat"
	desc = "It pulses with activity. You feel watched while walking on it."
	icon = 'icons/turf/floors.dmi'
	icon_state = "necro"

/turf/simulated/floor/flesh/initialize()
	icon_state = "necro[rand(1,3)]"
	. = ..()
