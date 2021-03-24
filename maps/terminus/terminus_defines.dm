#define Z_LEVEL_FIRST_TERMINUS					1
#define Z_LEVEL_SECOND_TERMINUS					2
#define Z_LEVEL_THIRD_TERMINUS					3
#define Z_LEVEL_FOURTH_TERMINUS					4
#define Z_LEVEL_FIFTH_TERMINUS					5
#define Z_LEVEL_SIXTH_TERMINUS					6
#define Z_LEVEL_SEVENTH_TERMINUS				7
#define Z_LEVEL_EIGHTH_TERMINUS					8
#define Z_LEVEL_NINTH_TERMINUS					9
#define Z_LEVEL_TENTH_TERMINUS					10

/datum/map/terminus
	name = "Terminus"
	full_name = "Terminus Settlement"
	path = "terminus"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("astral")

	zlevel_datum_type = /datum/map_z_level/terminus

	station_name  = "Terminus Settlement"
	station_short = "Terminus"
	dock_name     = "Terminus Dock"
	boss_name     = "Terminus Overseer Council"
	boss_short    = "TOC"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Sol"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has docked with the station at docks one and two. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %Dock_name% has been scheduled. The shuttle has been called. Those leaving should procede to docks one and two in approximately %ETA%"
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	allowed_spawns = list("Cryogenic Storage", "Prison")
	usable_email_tlds = list("freemail.net", "ntmail.nt")
	council_email = "council@ntmail.nt"

/datum/map_z_level/terminus/first
	z = Z_LEVEL_FIRST_TERMINUS
	name = "Sewers"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50

/datum/map_z_level/terminus/second
	z = Z_LEVEL_SECOND_TERMINUS
	name = "Basement Level"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/third
	z = Z_LEVEL_THIRD_TERMINUS
	name = "Ground Level"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/fourth
	z = Z_LEVEL_FOURTH_TERMINUS
	name = "Second Floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/fifth
	z = Z_LEVEL_FIFTH_TERMINUS
	name = "Third Floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/sixth
	z = Z_LEVEL_SIXTH_TERMINUS
	name = "The Moon - Underground"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/seventh
	z = Z_LEVEL_SEVENTH_TERMINUS
	name = "The Moon" // That wizard came from the Moon!
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 50
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/eighth
	z = Z_LEVEL_EIGHTH_TERMINUS
	name = "The Astral Alley"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 0
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/ninth
	z = Z_LEVEL_NINTH_TERMINUS
	name = "Redspace"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 0
	base_turf = /turf/simulated/open

/datum/map_z_level/terminus/tenth
	z = Z_LEVEL_TENTH_TERMINUS
	name = "The Fundament"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	transit_chance = 0
	base_turf = /turf/simulated/open

/datum/map/terminus/perform_map_generation()

	//Planetside Ore Generation
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_FIRST_TERMINUS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_FIRST_TERMINUS, world.maxx, world.maxy)         // Create the mining ore distribution map.

	//Lunar Ore Generation - To-do: Lunar specific ores (Helium?)
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SIXTH_TERMINUS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore/lunar(null, 1, 1, Z_LEVEL_SIXTH_TERMINUS, world.maxx, world.maxy)         // Create the mining ore distribution map.

	//Redspace Ore Generation - To-do: Redspace specific ores (ASTRALITE)
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_SIXTH_TERMINUS, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore/redspace(null, 1, 1, Z_LEVEL_SIXTH_TERMINUS, world.maxx, world.maxy)         // Create the mining ore distribution map.

	return 1