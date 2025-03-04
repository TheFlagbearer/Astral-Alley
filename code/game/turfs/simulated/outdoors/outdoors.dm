var/list/turf_edge_cache = list()

/turf/
	// If greater than 0, this turf will apply edge overlays on top of other turfs cardinally adjacent to it, if those adjacent turfs are of a different icon_state,
	// and if those adjacent turfs have a lower edge_blending_priority.
	var/edge_blending_priority = 0
	// Outdoors var determines if the game should consider the turf to be 'outdoors', which controls certain things such as weather effects.
	var/outdoors = FALSE

/turf/simulated/floor/outdoors
	name = "generic ground"
	desc = "Rather boring."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = null
	edge_blending_priority = 1
	outdoors = TRUE					// This variable is used for weather effects.
	// When a turf gets demoted or promoted, this list gets adjusted.  The top-most layer is the layer on the bottom of the list, due to how pop() works.
	var/list/turf_layers = list(/turf/simulated/floor/outdoors/rocks)
	var/can_build_onto = 0

/turf/simulated/floor/outdoors/initialize()
	update_icon()
	. = ..()

/turf/simulated/floor/New()
	if(outdoors)
		SSplanets.addTurf(src)
	..()

/turf/simulated/floor/Destroy()
	if(outdoors)
		SSplanets.removeTurf(src)
	return ..()

/turf/simulated/proc/make_outdoors()
	if(outdoors)
		return
	outdoors = TRUE
	SSplanets.addTurf(src)

/turf/simulated/proc/make_indoors()
	if(!outdoors)
		return
	outdoors = FALSE
	SSplanets.removeTurf(src)

/turf/simulated/post_change()
	..()
	// If it was outdoors and still is, it will not get added twice when the planet controller gets around to putting it in.
	if(outdoors)
		make_outdoors()
	else
		make_indoors()

/turf/simulated/proc/update_icon_edge()
	if(edge_blending_priority && !forbid_turf_edge())
		for(var/checkdir in cardinal)
			var/turf/simulated/T = get_step(src, checkdir)
			if(istype(T) && T.edge_blending_priority && edge_blending_priority < T.edge_blending_priority && icon_state != T.icon_state && !T.forbid_turf_edge())
				var/cache_key = "[T.get_edge_icon_state()]-[checkdir]"
				if(!turf_edge_cache[cache_key])
					var/image/I = image(icon = 'icons/turf/outdoors_edge.dmi', icon_state = "[T.get_edge_icon_state()]-edge", dir = checkdir)
					I.plane = -45 //fixed glitch that shows plane edges above mob
					turf_edge_cache[cache_key] = I
				add_overlay(turf_edge_cache[cache_key])

/turf/simulated/proc/get_edge_icon_state()
	return icon_state

// Tests if we shouldn't apply a turf edge.
// Returns the blocker if one exists.
/turf/simulated/proc/forbid_turf_edge()
	for(var/obj/structure/S in contents)
		if(S.block_turf_edges)
			return S
	return null

/turf/simulated/floor/outdoors/attackby(obj/item/C as obj, mob/user as mob)
	if(can_build_onto)
		if(istype(C, /obj/item/stack/material/steel))
			var/obj/item/stack/material/steel/S = C
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			src.ChangeTurf(/turf/simulated/floor/plating)
			S.use(1)
		else
			return ..()
	else
		return ..()



/turf/simulated/floor/outdoors/update_icon()
	..()
	update_icon_edge()

/turf/simulated/floor/outdoors/mud
	name = "mud"
	icon_state = "mud_dark"
	edge_blending_priority = 3
	can_build_onto = 1


/turf/simulated/floor/outdoors/rocks
	name = "rocks"
	desc = "Hard as a rock."
	icon_state = "rock"
	edge_blending_priority = 1
	can_build_onto = 1

/turf/simulated/floor/outdoors/rocks/caves
	outdoors = FALSE

/turf/simulated/floor/outdoors/rocks/dark
	icon_state = "rock_dark"

/turf/simulated/floor/outdoors/rocks/caves/dark
	icon_state = "rock_dark"

// This proc adds a 'layer' on top of the turf.
/turf/simulated/floor/outdoors/proc/promote(var/new_turf_type)
	var/list/new_turf_layer_list = turf_layers.Copy()
	var/list/coords = list(x, y, z)

	new_turf_layer_list.Add(src.type)

	ChangeTurf(new_turf_type)
	var/turf/simulated/floor/outdoors/T = locate(coords[1], coords[2], coords[3])
	if(istype(T))
		T.turf_layers = new_turf_layer_list.Copy()

// This proc removes the topmost layer.
/turf/simulated/floor/outdoors/proc/demote()
	if(!turf_layers.len)
		return // Cannot demote further.
	var/list/new_turf_layer_list = turf_layers.Copy()
	var/list/coords = list(x, y, z)

	ChangeTurf(pop(new_turf_layer_list))
	var/turf/simulated/floor/outdoors/T = locate(coords[1], coords[2], coords[3])
	if(istype(T))
		T.turf_layers = new_turf_layer_list.Copy()

// Called by weather processes, and maybe technomancers in the future.
/turf/simulated/floor/proc/chill()
	return

/turf/simulated/floor/outdoors/chill()
	promote(/turf/simulated/floor/outdoors/snow)

/turf/simulated/floor/outdoors/snow/chill()
	return // Todo: Add heavy snow.

/turf/simulated/floor/outdoors/ex_act(severity)
	switch(severity)
		if(2)
			if(prob(33))
				return
		if(3)
			if(prob(66))
				return
	demote()

// Martian Surface

/turf/simulated/floor/outdoors/mars
	name = "martian soil"
	desc = "Lifeless rock and sand..."
	icon = 'icons/turf/mars.dmi'
	icon_state = "asteroid0"
	edge_blending_priority = 3
	can_build_onto = 1

/turf/simulated/floor/outdoors/mars/plating
	name = "plating"
	desc = "Dust-covered plating."
	icon_state = "asteroidplating"
	can_build_onto = 1