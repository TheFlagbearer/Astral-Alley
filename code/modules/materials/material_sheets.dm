// Stacked resources. They use a material datum for a lot of inherited values.
// If you're adding something here, make sure to add it to fifty_spawner_mats.dm as well
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	throw_speed = 3
	throw_range = 3
	max_amount = 50
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
		)

	var/default_type = DEFAULT_WALL_MATERIAL
	var/material/material
	var/perunit = SHEET_MATERIAL_AMOUNT
	var/apply_colour //temp pending icon rewrite
	drop_sound = 'sound/items/drop/axe.ogg'
	tax_type = MINING_TAX

/obj/item/stack/material/New()
	..()
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

	if(!default_type)
		default_type = DEFAULT_WALL_MATERIAL
	material = get_material_by_name("[default_type]")
	if(!material)
		qdel(src)
		return 0

	recipes = material.get_recipes()

	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()

	if(apply_colour)
		color = material.icon_colour

	if(material.conductive)
		flags |= CONDUCT

	if (!stacktype)
		stacktype = material.stack_type

	matter = material.get_matter()
	update_strings()
	return 1


/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	singular_name = material.sheet_singular_name

	if(amount>1)
		name = "[material.use_name] [material.sheet_plural_name]"
		desc = "A stack of [material.use_name] [material.sheet_plural_name]."
		gender = PLURAL
	else
		name = "[material.use_name] [material.sheet_singular_name]"
		desc = "A [material.sheet_singular_name] of [material.use_name]."
		gender = NEUTER

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.name != M.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M) M.update_strings()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/cable_coil))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material.build_rod_product(user, W, src)
		return
	return ..()

/obj/item/stack/material/iron
	name = "iron"
	icon_state = "sheet-ingot"
	default_type = "iron"
	apply_colour = 1
	no_variants = FALSE
	associated_reagents = list("iron")

/obj/item/stack/material/lead
	name = "lead"
	icon_state = "sheet-ingot"
	default_type = "lead"
	apply_colour = 1
	no_variants = TRUE
	stack_color = COLOR_LEAD

/obj/item/stack/material/sandstone
	name = "sandstone brick"
	icon_state = "sheet-brick"
	default_type = "sandstone"
	no_variants = FALSE
	associated_reagents = list("silicon")
	stack_color = COLOR_SANDSTONE
	dyeable = TRUE

/obj/item/stack/material/marble
	name = "marble brick"
	icon_state = "sheet-brick"
	default_type = "marble"
	no_variants = FALSE
	associated_reagents = list("carbon")
	stack_color = COLOR_MARBLE

/obj/item/stack/material/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	default_type = "diamond"
	drop_sound = 'sound/items/drop/glass.ogg'
	associated_reagents = list("carbon")

/obj/item/stack/material/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	default_type = "uranium"
	no_variants = FALSE
	associated_reagents = list("uranium")
	stack_color = COLOR_URANIUM

/obj/item/stack/material/phoron
	name = "solid phoron"
	icon_state = "sheet-phoron"
	default_type = "phoron"
	no_variants = FALSE
	associated_reagents = list("phoron")
	stacktype = /obj/item/stack/material/phoron

/obj/item/stack/material/plastic
	name = "plastic"
	icon_state = "sheet-plastic"
	default_type = "plastic"
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = 5
	drop_sound = 'sound/items/drop/boots.ogg'
	associated_reagents = list("silicon")
	dyeable = TRUE
	stacktype = /obj/item/stack/material/plastic

/obj/item/stack/material/gold
	name = "gold"
	icon_state = "sheet-ingot"
	default_type = "gold"
	no_variants = FALSE
	associated_reagents = list("gold")
	stack_color = COLOR_GOLD

/obj/item/stack/material/silver
	name = "silver"
	icon_state = "sheet-ingot"
	default_type = "silver"
	no_variants = FALSE
	associated_reagents = list("silver")
	stack_color = COLOR_SILVER

//Valuable resource, cargo can sell it.
/obj/item/stack/material/platinum
	name = "platinum"
	icon_state = "sheet-ingot"
	default_type = "platinum"
	no_variants = FALSE
	associated_reagents = list("platinum")
	stack_color = COLOR_PLATINUM

//Extremely valuable to Research.
/obj/item/stack/material/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	default_type = "mhydrogen"
	no_variants = FALSE
	associated_reagents = list("hydrogen")

//Fuel for MRSPACMAN generator.
/obj/item/stack/material/tritium
	name = "tritium"
	icon_state = "sheet-ingot"
	default_type = "tritium"
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_TRITIUM

/obj/item/stack/material/osmium
	name = "osmium"
	icon_state = "sheet-ingot"
	default_type = "osmium"
	apply_colour = 1
	no_variants = FALSE

//R-UST port
// Fusion fuel.
/obj/item/stack/material/deuterium
	name = "deuterium"
	icon_state = "sheet-ingot"
	default_type = "deuterium"
	apply_colour = 1
	no_variants = FALSE

	stack_color = "#999999"

/obj/item/stack/material/steel
	name = DEFAULT_WALL_MATERIAL
	icon_state = "sheet-metal"
	default_type = DEFAULT_WALL_MATERIAL
	no_variants = FALSE
	associated_reagents = list("iron")

	stack_color = COLOR_GRAY40
	stacktype = /obj/item/stack/material/steel

/obj/item/stack/material/plasteel
	name = "plasteel"
	icon_state = "sheet-plasteel"
	default_type = "plasteel"
	no_variants = FALSE
	associated_reagents = list("iron", "carbon", "platinum")

	stack_color = COLOR_GRAY40
	stacktype = /obj/item/stack/material/plasteel

/obj/item/stack/material/durasteel
	name = "durasteel"
	icon_state = "sheet-metal"
	item_state = "sheet-metal"
	default_type = "durasteel"
	no_variants = FALSE
	associated_reagents = list("iron")

	stack_color = COLOR_GRAY

/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MAT_WOOD
	burn_state = 0 //Burnable
	burntime = MEDIUM_BURN
	associated_reagents = list("woodpulp")
	stack_color = WOOD_COLOR_GENERIC
	no_variants = FALSE
	stacktype = /obj/item/stack/material/wood

/obj/item/stack/material/wood/ten
	amount = 10

/obj/item/stack/material/wood/fifty
	amount = 50

/obj/item/stack/material/wood/mahogany
	name = "mahogany plank"
	default_type = MATERIAL_MAHOGANY
	stack_color = WOOD_COLOR_RICH
	stacktype = /obj/item/stack/material/wood/mahogany

/obj/item/stack/material/wood/mahogany/ten
	amount = 10

/obj/item/stack/material/wood/mahogany/twentyfive
	amount = 25

/obj/item/stack/material/wood/maple
	name = "maple plank"
	default_type = MATERIAL_MAPLE
	stack_color = WOOD_COLOR_PALE
	stacktype = /obj/item/stack/material/wood/maple

/obj/item/stack/material/wood/maple/ten
	amount = 10

/obj/item/stack/material/wood/maple/twentyfive
	amount = 25

/obj/item/stack/material/wood/ebony
	name = "ebony plank"
	default_type = MATERIAL_EBONY
	stack_color = WOOD_COLOR_BLACK
	stacktype = /obj/item/stack/material/wood/ebony

/obj/item/stack/material/wood/ebony/ten
	amount = 10

/obj/item/stack/material/wood/ebony/twentyfive
	amount = 25

/obj/item/stack/material/wood/walnut
	name = "walnut plank"
	default_type = MATERIAL_WALNUT
	stack_color = WOOD_COLOR_CHOCOLATE
	stacktype = /obj/item/stack/material/wood/walnut

/obj/item/stack/material/wood/walnut/ten
	amount = 10

/obj/item/stack/material/wood/walnut/twentyfive
	amount = 25

/obj/item/stack/material/wood/bamboo
	name = "bamboo plank"
	default_type = MATERIAL_BAMBOO
	stack_color = WOOD_COLOR_PALE2
	stacktype = /obj/item/stack/material/wood/bamboo

/obj/item/stack/material/wood/bamboo/ten
	amount = 10

/obj/item/stack/material/wood/bamboo/fifty
	amount = 50

/obj/item/stack/material/wood/yew
	name = "yew plank"
	default_type = MATERIAL_YEW
	stack_color = WOOD_COLOR_YELLOW
	stacktype = /obj/item/stack/material/wood/yew

/obj/item/stack/material/wood/yew/ten
	amount = 10

/obj/item/stack/material/wood/yew/fifty
	amount = 50

/obj/item/stack/material/wood/sif
	name = "alien wooden plank"
	default_type = MAT_SIFWOOD
	stack_color = "#0099cc"
	stacktype = /obj/item/stack/material/wood/sif

/obj/item/stack/material/log
	name = "log"
	icon_state = "sheet-log"
	default_type = MAT_LOG
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = LONG_BURN
	stack_color = WOOD_COLOR_GENERIC
	max_amount = 25
	w_class = ITEMSIZE_HUGE
	description_info = "Use inhand to craft things, or use a sharp and edged object on this to convert it into two wooden planks."
	var/plank_type = /obj/item/stack/material/wood
	associated_reagents = list("woodpulp")

	stacktype = /obj/item/stack/material/log

/obj/item/stack/material/log/sif
	name = "alien log"
	default_type = MAT_SIFLOG
	color = "#0099cc"
	plank_type = /obj/item/stack/material/wood/sif
	stacktype = /obj/item/stack/material/log/sif


/obj/item/stack/material/log/attackby(var/obj/item/W, var/mob/user)
	if(!istype(W) || W.force <= 0)
		return ..()
	if(W.sharp && W.edge)
		var/time = (3 SECONDS / max(W.force / 10, 1)) * W.toolspeed
		user.setClickCooldown(time)
		if(do_after(user, time, src) && use(1))
			to_chat(user, "<span class='notice'>You cut up a log into planks.</span>")
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
			var/obj/item/stack/material/wood/existing_wood = null
			for(var/obj/item/stack/material/wood/M in user.loc)
				if(M.material.name == src.material.name)
					existing_wood = M
					break

			var/obj/item/stack/material/wood/new_wood = new plank_type(user.loc)
			new_wood.amount = 2
			if(existing_wood && new_wood.transfer_to(existing_wood))
				to_chat(user, "<span class='notice'>You add the newly-formed wood to the stack. It now contains [existing_wood.amount] planks.</span>")
	else
		return ..()


/obj/item/stack/material/cardboard
	name = "cardboard"
	icon_state = "sheet-card"
	default_type = "cardboard"
	no_variants = FALSE
	dyeable = TRUE

/obj/item/stack/material/snow
	name = "snow"
	desc = "The temptation to build a snowman rises."
	icon_state = "sheet-snow"
	default_type = "snow"
	associated_reagents = list("water")
	stack_color = COLOR_WHITE

/obj/item/stack/material/snowbrick
	name = "snow brick"
	desc = "For all of your igloo building needs."
	icon_state = "sheet-brick"
	default_type = "packed snow"
	associated_reagents = list("water")
	stack_color = COLOR_WHITE

/obj/item/stack/material/leather
	name = "leather"
	desc = "The by-product of mob grinding."
	icon_state = "sheet-fabric"
	default_type = "leather"
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = 5
	associated_reagents = list("protein")
	dyeable = TRUE
	stack_color = COLOR_BROWN
	drop_sound = 'sound/items/drop/clothing.ogg'
	tax_type = CLOTHING_TAX

/obj/item/stack/material/leather/synthetic
	name = "synthetic leather"
	default_type = "synthetic leather"
	desc = "A synthetic product which is cheaper than the actual thing."

/obj/item/stack/material/silk
	name = "silk"
	desc = "Many lives were lost trying to wrangle the silk from giant spiders, but it was a risk we were willing to take."
	icon_state = "sheet-cloth"
	default_type = "silk"
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = 5
	associated_reagents = list("protein")
	dyeable = TRUE
	drop_sound = 'sound/items/drop/clothing.ogg'
	tax_type = CLOTHING_TAX

/obj/item/stack/material/cotton
	name = "cotton"
	desc = "Picked from cotton plants."
	icon_state = "sheet-cloth"
	default_type = "cotton"
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = 5
	associated_reagents = list("protein")
	dyeable = TRUE
	drop_sound = 'sound/items/drop/clothing.ogg'
	stacktype = /obj/item/stack/material/cotton
	tax_type = CLOTHING_TAX

/obj/item/stack/material/cotton/black
	stack_color = COLOR_BLACK

/obj/item/stack/material/cotton/red
	stack_color = COLOR_BLACK

/obj/item/stack/material/cotton/maroon
	stack_color = COLOR_MAROON

/obj/item/stack/material/cotton/forest
	stack_color = COLOR_FOREST_GREEN

/obj/item/stack/material/cotton/navy
	stack_color = COLOR_NAVY

/obj/item/stack/material/cotton/beige
	stack_color = COLOR_BEIGE

/obj/item/stack/material/cotton/gray
	stack_color = COLOR_GRAY

/obj/item/stack/material/cotton/green
	stack_color = COLOR_GREEN

/obj/item/stack/material/cotton/pink
	stack_color = COLOR_PINK

/obj/item/stack/material/denim
	name = "denim"
	desc = "The worker's fabric as many would say."
	icon_state = "sheet-fabric"
	default_type = "denim"
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = 5
	associated_reagents = list("protein")
	dyeable = TRUE
	stack_color = COLOR_DENIM
	drop_sound = 'sound/items/drop/clothing.ogg'
	tax_type = CLOTHING_TAX

/obj/item/stack/material/wool
	name = "wool"
	desc = "Sheared from your local sheep. A so-done sheep."
	icon_state = "sheet-fabric"
	default_type = "wool"
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = 5
	associated_reagents = list("protein")
	dyeable = TRUE
	drop_sound = 'sound/items/drop/clothing.ogg'
	tax_type = CLOTHING_TAX

/obj/item/stack/material/polychromatic_thread
	name = "polychromatic thread"
	desc = "A color shifting thread that can easily change color via electromagnetic pulses."
	icon_state = "sheet-fabric"
	default_type = "polychromatic thread"
	no_variants = FALSE
	burn_state = 0 //Burnable
	burntime = 5
	associated_reagents = list("protein")
	dyeable = TRUE
	drop_sound = 'sound/items/drop/clothing.ogg'
	tax_type = CLOTHING_TAX

/obj/item/stack/material/glass
	name = "glass"
	icon_state = "sheet-glass"
	default_type = MATERIAL_GLASS
	no_variants = FALSE
	drop_sound = 'sound/items/drop/glass.ogg'
	associated_reagents = list("silicon")
	stack_color = COLOR_DEEP_SKY_BLUE

/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	icon_state = "sheet-rglass"
	default_type = MATERIAL_REINFORCED_GLASS
	no_variants = FALSE

/obj/item/stack/material/glass/phoronglass
	name = "borosilicate glass"
	desc = "This sheet is special phoron-glass alloy designed to withstand large temperatures"
	singular_name = "borosilicate glass sheet"
	icon_state = "sheet-glass"
	default_type = "borosilicate glass"
	no_variants = FALSE
	stack_color = COLOR_PHORON

/obj/item/stack/material/glass/phoronrglass
	name = "reinforced borosilicate glass"
	desc = "This sheet is special phoron-glass alloy designed to withstand large temperatures. It is reinforced with few rods."
	singular_name = "reinforced borosilicate glass sheet"
	icon_state = "sheet-rglass"
	default_type = "reinforced borosilicate glass"
	no_variants = FALSE
	stack_color = COLOR_PHORON

/obj/item/stack/material/bronze
	name = "bronze"
	icon_state = "sheet-ingot"
	singular_name = "bronze ingot"
	default_type = MATERIAL_BRONZE
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_BROWN

/obj/item/stack/material/tin
	name = "tin"
	icon_state = "sheet-ingot"
	singular_name = "tin ingot"
	default_type = MATERIAL_TIN
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_WHITE

/obj/item/stack/material/copper
	name = "copper"
	icon_state = "sheet-ingot"
	singular_name = "copper ingot"
	default_type = MATERIAL_COPPER
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_DARK_BROWN
	stacktype = /obj/item/stack/material/copper

/obj/item/stack/material/painite
	name = "painite"
	icon_state = "sheet-gem"
	singular_name = "painite gem"
	default_type = MATERIAL_PAINITE
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_NT_RED

/obj/item/stack/material/void_opal
	name = "void opal"
	icon_state = "sheet-void_opal"
	singular_name = "void opal"
	default_type = MATERIAL_VOID_OPAL
	stack_color = "#292929"
	apply_colour = 1
	no_variants = FALSE

/obj/item/stack/material/quartz
	name = "quartz"
	icon_state = "sheet-gem"
	singular_name = "quartz gem"
	default_type = MATERIAL_QUARTZ
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_WHITE

/obj/item/stack/material/quartz/rose_quartz
	name = "rose quartz"
	singular_name = "rose quartz gem"
	default_type = MATERIAL_ROSE_QUARTZ

	stack_color = "#e3a3a3"
	stacktype = /obj/item/stack/material/quartz/rose_quartz

/obj/item/stack/material/titanium
	name = "titanium"
	icon_state = "sheet-ingot"
	singular_name = "titanium ingot"
	default_type = MATERIAL_TITANIUM
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_TITANIUM
	stacktype = /obj/item/stack/material/titanium

/obj/item/stack/material/aluminium
	name = "aluminium"
	icon_state = "sheet-ingot"
	singular_name = "aluminium ingot"
	default_type = MATERIAL_ALUMINIUM
	apply_colour = 1
	no_variants = FALSE
	stack_color = COLOR_GRAY

/obj/item/stack/material/astralite
	name = "astralite"
	icon_state = "sheet-ingot"
	singular_name = "astralite ingot"
	default_type = MATERIAL_ASTRALITE
	apply_colour = 1
	no_variants = FALSE
	stack_color = "#c94000"