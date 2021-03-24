/*
	MATERIAL DATUMS
	This data is used by various parts of the game for basic physical properties and behaviors
	of the metals/materials used for constructing many objects. Each var is commented and should be pretty
	self-explanatory but the various object types may have their own documentation. ~Z

	PATHS THAT USE DATUMS
		turf/simulated/wall
		obj/item/weapon/material
		obj/structure/barricade
		obj/item/stack/material
		obj/structure/table

	VALID ICONS
		WALLS
			stone
			metal
			solid
			cult
		DOORS
			stone
			metal
			resin
			wood
*/

// Assoc list containing all material datums indexed by name.
var/list/name_to_material

//Returns the material the object is made of, if applicable.
//Will we ever need to return more than one value here? Or should we just return the "dominant" material.
/obj/proc/get_material()
	return null

//mostly for convenience
/obj/proc/get_material_name()
	var/material/material = get_material()
	if(material)
		return material.name

// Builds the datum list above.
/proc/populate_material_list(force_remake=0)
	if(name_to_material && !force_remake) return // Already set up!
	name_to_material = list()
	for(var/type in typesof(/material) - /material)
		var/material/new_mineral = new type
		if(!new_mineral.name)
			continue
		name_to_material[lowertext(new_mineral.name)] = new_mineral
	return 1

// Safety proc to make sure the material list exists before trying to grab from it.
/proc/get_material_by_name(name)
	if(!name_to_material)
		populate_material_list()
	return name_to_material[name]

/proc/material_display_name(name)
	var/material/material = get_material_by_name(name)
	if(material)
		return material.display_name
	return null

// Material definition and procs follow.
/material
	var/name	                          // Unique name for use in indexing the list.
	var/display_name                      // Prettier name for display.
	var/use_name
	var/flags = 0                         // Various status modifiers.
	var/sheet_singular_name = "sheet"
	var/sheet_plural_name = "sheets"
	var/is_fusion_fuel

	var/worth = 1

	// Shards/tables/structures
	var/shard_type = SHARD_SHRAPNEL       // Path of debris object.
	var/shard_icon                        // Related to above.
	var/shard_can_repair = 1              // Can shards be turned into sheets with a welder?
	var/list/recipes                      // Holder for all recipes usable with a sheet of this material.
	var/destruction_desc = "breaks apart" // Fancy string for barricades/tables/objects exploding.

	// Icons
	var/icon_colour                                      // Colour applied to products of this material.
	var/icon_base = "metal"                              // Wall and table base icon tag. See header.
	var/door_icon_base = "metal"                         // Door base icon tag. See header.
	var/icon_reinf = "reinf_metal"                       // Overlay used
	var/list/stack_origin_tech = list(TECH_MATERIAL = 1) // Research level for stacks.

	// Attributes
	var/cut_delay = 0            // Delay in ticks when cutting through this wall.
	var/radioactivity            // Radiation var. Used in wall and object processing to irradiate surroundings.
	var/ignition_point           // K, point at which the material catches on fire.
	var/melting_point = 1800     // K, walls will take damage if they're next to a fire hotter than this
	var/integrity = 150          // General-use HP value for products.
	var/protectiveness = 10      // How well this material works as armor.  Higher numbers are better, diminishing returns applies.
	var/opacity = 1              // Is the material transparent? 0.5< makes transparent walls/doors.
	var/reflectivity = 0         // How reflective to light is the material?  Currently used for laser reflection and defense.
	var/explosion_resistance = 5 // Only used by walls currently.
	var/conductive = 1           // Objects with this var add CONDUCTS to flags on spawn.
	var/conductivity = null      // How conductive the material is. Iron acts as the baseline, at 10.
	var/list/composite_material  // If set, object matter var will be a list containing these values.
	var/luminescence
	var/radiation_resistance = 0 // Radiation resistance, which is added on top of a material's weight for blocking radiation. Needed to make lead special without superrobust weapons.

	// Placeholder vars for the time being, todo properly integrate windows/light tiles/rods.
	var/created_window
	var/rod_product
	var/wire_product
	var/list/window_options = list()

	// Damage values.
	var/hardness = 60            // Prob of wall destruction by hulk, used for edge damage in weapons.  Also used for bullet protection in armor.
	var/weight = 20              // Determines blunt damage/throwforce for weapons.

	// Noise when someone is faceplanted onto a table made of this material.
	var/tableslam_noise = 'sound/weapons/tablehit1.ogg'
	// Noise made when a simple door made of this material opens or closes.
	var/dooropen_noise = 'sound/effects/stonedoor_openclose.ogg'
	// Path to resulting stacktype. Todo remove need for this.
	var/stack_type
	// Wallrot crumble message.
	var/rotting_touch_message = "crumbles under your touch"

// Placeholders for light tiles and rglass.
/material/proc/build_rod_product(var/mob/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!rod_product)
		user << "<span class='warning'>You cannot make anything out of \the [target_stack]</span>"
		return
	if(used_stack.get_amount() < 1 || target_stack.get_amount() < 1)
		user << "<span class='warning'>You need one rod and one sheet of [display_name] to make anything useful.</span>"
		return
	used_stack.use(1)
	target_stack.use(1)
	var/obj/item/stack/S = new rod_product(get_turf(user))
	S.add_fingerprint(user)
	S.add_to_stacks(user)

/material/proc/build_wired_product(var/mob/living/user, var/obj/item/stack/used_stack, var/obj/item/stack/target_stack)
	if(!wire_product)
		user << "<span class='warning'>You cannot make anything out of \the [target_stack]</span>"
		return
	if(used_stack.get_amount() < 5 || target_stack.get_amount() < 1)
		user << "<span class='warning'>You need five wires and one sheet of [display_name] to make anything useful.</span>"
		return

	used_stack.use(5)
	target_stack.use(1)
	user << "<span class='notice'>You attach wire to the [name].</span>"
	var/obj/item/product = new wire_product(get_turf(user))
	user.put_in_hands(product)

// Make sure we have a display name and shard icon even if they aren't explicitly set.
/material/New()
	..()
	if(!display_name)
		display_name = name
	if(!use_name)
		use_name = display_name
	if(!shard_icon)
		shard_icon = shard_type

// This is a placeholder for proper integration of windows/windoors into the system.
/material/proc/build_windows(var/mob/living/user, var/obj/item/stack/used_stack)
	return 0

// Weapons handle applying a divisor for this value locally.
/material/proc/get_blunt_damage()
	return weight //todo

// Return the matter comprising this material.
/material/proc/get_matter()
	var/list/temp_matter = list()
	if(islist(composite_material))
		for(var/material_string in composite_material)
			temp_matter[material_string] = composite_material[material_string]
	#ifdef SHEET_MATERIAL_AMOUNT
	else
		temp_matter[name] = SHEET_MATERIAL_AMOUNT
	#endif
	return temp_matter

// As above.
/material/proc/get_edge_damage()
	return hardness //todo

// Snowflakey, only checked for alien doors at the moment.
/material/proc/can_open_material_door(var/mob/living/user)
	return 1

// Currently used for weapons and objects made of uranium to irradiate things.
/material/proc/products_need_process()
	return (radioactivity>0) //todo

// Used by walls when qdel()ing to avoid neighbor merging.
/material/placeholder
	name = "placeholder"

// Places a girder object when a wall is dismantled, also applies reinforced material.
/material/proc/place_dismantled_girder(var/turf/target, var/material/reinf_material, var/material/girder_material)
	var/obj/structure/girder/G = new(target)
	if(reinf_material)
		G.reinf_material = reinf_material
		G.reinforce_girder()
	if(girder_material)
		if(istype(girder_material, /material))
			girder_material = girder_material.name
		G.set_material(girder_material)


// General wall debris product placement.
// Not particularly necessary aside from snowflakey cult girders.
/material/proc/place_dismantled_product(var/turf/target)
	place_sheet(target)

// Debris product. Used ALL THE TIME.
/material/proc/place_sheet(var/turf/target)
	if(stack_type)
		return new stack_type(target)

// As above.
/material/proc/place_shard(var/turf/target)
	if(shard_type)
		return new /obj/item/weapon/material/shard(target, src.name)

// Used by walls and weapons to determine if they break or not.
/material/proc/is_brittle()
	return !!(flags & MATERIAL_BRITTLE)

/material/proc/combustion_effect(var/turf/T, var/temperature)
	return

/material/proc/get_wall_texture()
	return

/material/proc/get_worth()
	return worth

// Datum definitions follow.
/material/uranium
	name = "uranium"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007A00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	door_icon_base = "stone"
	worth = 9

/material/diamond
	name = "diamond"
	stack_type = /obj/item/stack/material/diamond
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	icon_colour = "#00FFE1"
	opacity = 0.4
	reflectivity = 0.6
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_MATERIAL = 6)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	worth = 12

/material/gold
	name = "gold"
	stack_type = /obj/item/stack/material/gold
	icon_colour = "#EDD12F"
	icon_base = "solid"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 6.5

/material/gold/bronze //placeholder for ashtrays
	name = "bronze"
	stack_type = /obj/item/stack/material/bronze
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	icon_colour = "#EDD12F"
	worth = 2.4

/material/silver
	name = "silver"
	stack_type = /obj/item/stack/material/silver
	icon_colour = COLOR_SILVER
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 4.2

//R-UST port
/material/supermatter
	name = "supermatter"
	icon_colour = "#FFFF00"
	radioactivity = 20
	stack_type = null
	luminescence = 3
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	shard_type = SHARD_SHARD
	hardness = 30
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1

/material/phoron
	name = "phoron"
	stack_type = /obj/item/stack/material/phoron
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	icon_colour = COLOR_PHORON
	shard_type = SHARD_SHARD
	hardness = 30
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	worth = 7

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/material/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas("phoron", phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
*/

/material/stone
	name = "sandstone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D9C179"
	shard_type = SHARD_STONE_PIECE
	weight = 18
	hardness = 25
	protectiveness = 5 // 20%
	conductivity = 5
	door_icon_base = "stone"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	worth = 0.25

/material/stone/marble
	name = "marble"
	icon_colour = COLOR_MARBLE
	weight = 26
	hardness = 100
	integrity = 201 //hack to stop kitchen benches being flippable, todo: refactor into weight system
	stack_type = /obj/item/stack/material/marble

/material/steel
	name = DEFAULT_WALL_MATERIAL
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#515151"
	worth = 0.75

/material/biomass
	name = "biomass"
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = "diona"
	icon_reinf = "noreinf"

/material/diona/place_dismantled_product()
	return

/material/steel/holographic
	name = "holo" + DEFAULT_WALL_MATERIAL
	display_name = DEFAULT_WALL_MATERIAL
	stack_type = null
	shard_type = SHARD_NONE

/material/plasteel
	name = "plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#777777"
	explosion_resistance = 25
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(DEFAULT_WALL_MATERIAL = SHEET_MATERIAL_AMOUNT, "platinum" = SHEET_MATERIAL_AMOUNT) //todo
	worth = 4

// Very rare alloy that is reflective, should be used sparingly.
/material/durasteel
	name = "durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	icon_base = "metal"
	icon_reinf = "reinf_metal"
	icon_colour = "#6EA7BE"
	explosion_resistance = 75
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectivity = 0.7 // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list("plasteel" = SHEET_MATERIAL_AMOUNT, "diamond" = SHEET_MATERIAL_AMOUNT) //shrug
	worth = 7

/material/plasteel/titanium
	name = "titanium"
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#D1E6E3"
	icon_reinf = "reinf_metal"
	worth = 3

/material/plastic
	name = "plastic"
	stack_type = /obj/item/stack/material/plastic
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)
	worth = 0.5

/material/plastic/holographic
	name = "holoplastic"
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/material/osmium
	name = "osmium"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 3

/material/tritium
	name = "tritium"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = COLOR_TRITIUM
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	worth = 4

/material/deuterium
	name = "deuterium"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/material/mhydrogen
	name = "mhydrogen"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#E6C5DE"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	is_fusion_fuel = 1
	worth = 4

/material/platinum
	name = "platinum"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = COLOR_PLATINUM
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 3

/material/iron
	name = "iron"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 0.5

/material/lead
	name = "lead"
	stack_type = /obj/item/stack/material/lead
	icon_colour = COLOR_LEAD
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.

// Adminspawn only, do not let anyone get this.
/material/alienalloy
	name = "alienalloy"
	display_name = "durable alloy"
	stack_type = null
	icon_colour = "#6C7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	protectiveness = 80 // 80%

// Likewise.
/material/alienalloy/elevatorium
	name = "elevatorium"
	display_name = "elevator panelling"
	icon_colour = "#666666"

// Ditto.
/material/alienalloy/dungeonium
	name = "dungeonium"
	display_name = "ultra-durable"
	icon_base = "dungeon"
	icon_colour = "#FFFFFF"

/material/alienalloy/bedrock
	name = "bedrock"
	display_name = "impassable rock"
	icon_base = "rock"
	icon_colour = "#FFFFFF"

/material/alienalloy/alium
	name = "alium"
	display_name = "alien"
	icon_base = "alien"
	icon_colour = "#FFFFFF"

/material/resin
	name = "resin"
	icon_colour = "#35343a"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"

/material/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1
	return 0

/material/snow
	name = MAT_SNOW
	stack_type = /obj/item/stack/material/snow
	flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_WHITE
	integrity = 1
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "pile" //Just a bigger pile
	radiation_resistance = 1
	worth = 0

/material/snowbrick //only slightly stronger than snow, used to make igloos mostly
	name = "packed snow"
	flags = MATERIAL_BRITTLE
	stack_type = /obj/item/stack/material/snowbrick
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D8FDFF"
	integrity = 50
	weight = 2
	hardness = 2
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	radiation_resistance = 1

	worth = 0

/material/cult
	name = "cult"
	display_name = "disturbing stone"
	icon_base = "cult"
	icon_colour = "#402821"
	icon_reinf = "reinf_cult"
	shard_type = SHARD_STONE_PIECE
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"

/material/cult/place_dismantled_girder(var/turf/target)
	new /obj/structure/girder/cult(target)

/material/cult/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/cleanable/blood(target)

/material/cult/reinf
	name = "cult2"
	display_name = "human remains"

/material/cult/reinf/place_dismantled_product(var/turf/target)
	new /obj/effect/decal/remains/human(target)

//TODO PLACEHOLDERS:
/material/leather
	name = "leather"
	icon_colour = COLOR_LEATHER
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%
	worth = 2

/material/leather/synthetic
	name = "synthetic leather"
	icon_colour = COLOR_LEATHER
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+400
	melting_point = T0C+400
	protectiveness = 2 // 13%

/material/denim
	name = "denim"
	icon_colour = COLOR_DENIM
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 5
	worth = 1.8

/material/silk
	name = "silk"
	icon_colour = "#ebe9df"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 0 // 0%
	worth = 6

/material/wool
	name = "wool"
	icon_colour = "#ebe9df"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 0 // 0%

/material/cotton
	name = "cotton"
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/polychromatic_thread
	name = "polychromatic thread"
	display_name ="polychromatic thread"
	icon_colour = "#FFFFFF"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%
	worth = 9

/material/carpet
	name = "carpet"
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%

// This all needs to be OOP'd and use inheritence if its ever used in the future.
/material/cloth_teal
	name = "teal"
	display_name ="teal"
	use_name = "teal cloth"
	icon_colour = "#00EAFA"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/cloth_black
	name = "black"
	display_name = "black"
	use_name = "black cloth"
	icon_colour = "#505050"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/cloth_green
	name = "green"
	display_name = "green"
	use_name = "green cloth"
	icon_colour = "#01C608"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/cloth_purple
	name = "purple"
	display_name = "purple"
	use_name = "purple cloth"
	icon_colour = "#9C56C4"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/cloth_blue
	name = "blue"
	display_name = "blue"
	use_name = "blue cloth"
	icon_colour = "#6B6FE3"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/cloth_beige
	name = "beige"
	display_name = "beige"
	use_name = "beige cloth"
	icon_colour = "#E8E7C8"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/cloth_lime
	name = "lime"
	display_name = "lime"
	use_name = "lime cloth"
	icon_colour = "#62E36C"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%


/material/cloth_yellow
	name = "yellow"
	display_name = "yellow"
	use_name = "yellow cloth"
	icon_colour = "#ebc934"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/material/toy_foam
	name = "foam"
	display_name = "foam"
	use_name = "foam"
	flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	icon_colour = "#ff9900"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%

/material/void_opal
	name = "void opal"
	display_name = "void opal"
	use_name = "void opal"
	stack_type = /obj/item/stack/material/void_opal
	flags = MATERIAL_UNMELTABLE
	cut_delay = 60
	reflectivity = 0
	conductivity = 1
	shard_type = SHARD_SHARD
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	hardness = 100
	stack_origin_tech = list(TECH_ARCANE = 1, TECH_MATERIAL = 6)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	worth = 25
	icon_colour = "#292929"

/material/painite
	name = "painite"
	display_name = "painite"
	use_name = "painite"
	stack_type = /obj/item/stack/material/painite
	flags = MATERIAL_UNMELTABLE
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"
	worth = 10
	icon_colour = COLOR_NT_RED

/material/tin
	name = "tin"
	display_name = "tin"
	use_name = "tin"
	stack_type = /obj/item/stack/material/tin
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 1.2
	icon_colour = COLOR_WHITE

/material/copper
	name = "copper"
	display_name = "copper"
	use_name = "copper"
	stack_type = /obj/item/stack/material/copper
	conductivity = 52
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 1.2
	icon_colour = COLOR_DARK_BROWN

/material/quartz
	name = "quartz"
	display_name = "quartz"
	use_name = "quartz"
	stack_type = /obj/item/stack/material/quartz
	tableslam_noise = 'sound/effects/Glasshit.ogg'
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	worth = 4
	icon_colour = COLOR_WHITE

/material/quartz/rose_quartz
	name = "rose quartz"
	display_name = "rose quartz"
	use_name = "rose quartz"
	worth = 7
	stack_type = /obj/item/stack/material/quartz/rose_quartz

	icon_colour = "#e3a3a3"

/material/aluminium
	name = "aluminium"
	display_name = "aluminium"
	use_name = "aluminium"
	stack_type = /obj/item/stack/material/aluminium
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 1.2
	icon_colour = COLOR_GRAY

/material/astralite
	name = "astralite"
	display_name = "astralite"
	use_name = "astralite"
	stack_type = /obj/item/stack/material/astralite
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	worth = 20
	icon_colour = "#c94000"
	stack_origin_tech = list(TECH_ARCANE = 2, TECH_MATERIAL = 7)
	icon_base = "solid"
	weight = 15
	hardness = 40
	conductivity = 77