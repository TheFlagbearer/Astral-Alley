var/global/list/ore_data = list()

/ore
	var/name
	var/display_name
	var/alloy
	var/smelts_to
	var/compresses_to
	var/result_amount     // How much ore?
	var/spread = 1	      // Does this type of deposit spread?
	var/spread_chance     // Chance of spreading in any direction
	var/ore	              // Path to the ore produced when tile is mined.
	var/scan_icon         // Overlay for ore scanners.
	// Xenoarch stuff. No idea what it's for, just refactored it to be less awful.
	var/list/xarch_ages = list(
		"thousand" = 999,
		"million" = 999
		)
	var/xarch_source_mineral = "iron"

/ore/New()
	. = ..()
	if(!display_name)
		display_name = name

/ore/uranium
	name = "uranium"
	display_name = "pitchblende"
	smelts_to = "uranium"
	result_amount = 3
	spread_chance = 2
	ore = /obj/item/weapon/ore/uranium
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 704
		)
	xarch_source_mineral = "potassium"

/ore/hematite
	name = "hematite"
	display_name = "hematite"
	smelts_to = "iron"
	alloy = 1
	result_amount = 4
	spread_chance = 5
	ore = /obj/item/weapon/ore/iron
	scan_icon = "mineral_common"

/ore/coal
	name = "carbon"
	display_name = "raw carbon"
	smelts_to = "plastic"
	alloy = 1
	result_amount = 4
	spread_chance = 5
	ore = /obj/item/weapon/ore/coal
	scan_icon = "mineral_common"

/ore/glass
	name = "sand"
	display_name = "sand"
	smelts_to = "glass"
	alloy = 1
	compresses_to = "sandstone"

/ore/phoron
	name = "phoron"
	display_name = "phoron crystals"
	compresses_to = "phoron"
	//smelts_to = something that explodes violently on the conveyor, huhuhuhu
	result_amount = 3
	spread_chance = 2
	ore = /obj/item/weapon/ore/phoron
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 13,
		"billion_lower" = 10
		)
	xarch_source_mineral = "phoron"

/ore/silver
	name = "silver"
	display_name = "native silver"
	smelts_to = "silver"
	result_amount = 2
	spread_chance = 2
	ore = /obj/item/weapon/ore/silver
	scan_icon = "mineral_uncommon"

/ore/gold
	smelts_to = "gold"
	name = "gold"
	display_name = "native gold"
	result_amount = 2
	spread_chance = 2
	ore = /obj/item/weapon/ore/gold
	scan_icon = "mineral_uncommon"
	xarch_ages = list(
		"thousand" = 999,
		"million" = 999,
		"billion" = 4,
		"billion_lower" = 3
		)

/ore/diamond
	name = "diamond"
	display_name = "diamond"
	alloy = 1
	compresses_to = "diamond"
	result_amount = 2
	spread_chance = 1
	ore = /obj/item/weapon/ore/diamond
	scan_icon = "mineral_rare"
	xarch_source_mineral = "nitrogen"

/ore/platinum
	name = "platinum"
	display_name = "raw platinum"
	smelts_to = "platinum"
	compresses_to = "osmium"
	alloy = 1
	result_amount = 2
	spread_chance = 2
	ore = /obj/item/weapon/ore/osmium
	scan_icon = "mineral_rare"

/ore/copper
	name = "copper"
	display_name = "copper"
	smelts_to = "copper"
	alloy = 1
	result_amount = 3
	spread_chance = 4
	ore = /obj/item/weapon/ore/copper
	scan_icon = "mineral_common"

/ore/tin
	name = "tin"
	display_name = "tin"
	smelts_to = "tin"
	alloy = 1
	result_amount = 3
	spread_chance = 4
	ore = /obj/item/weapon/ore/tin
	scan_icon = "mineral_common"

/ore/hydrogen
	name = "mhydrogen"
	display_name = "metallic hydrogen"
	smelts_to = "tritium"
	compresses_to = "mhydrogen"
	scan_icon = "mineral_rare"

/ore/quartz
	name = "quartz"
	display_name = "unrefined quartz"
	compresses_to = "quartz"
	result_amount = 5
	spread_chance = 3
	ore = /obj/item/weapon/ore/quartz
	scan_icon = "mineral_common"

/ore/quartz/rose_quartz
	display_name = "unrefined rose quartz"
	compresses_to = "rose quartz"
	ore = /obj/item/weapon/ore/quartz/rose_quartz
	scan_icon = "mineral_rare"

/ore/bauxite
	name = "bauxite"
	display_name = "bauxite"
	smelts_to = "aluminium"
	result_amount = 3
	spread_chance = 3
	ore = /obj/item/weapon/ore/bauxite
	scan_icon = "mineral_common"

/ore/rutile
	name = "rutile"
	display_name = "rutile"
	smelts_to = "titanium"
	result_amount = 3
	spread_chance = 3
	ore = /obj/item/weapon/ore/rutile
	scan_icon = "mineral_uncommon"

/ore/painite
	name = "painite"
	display_name = "rough painite"
	compresses_to = "painite"
	result_amount = 3
	spread_chance = 2
	ore = /obj/item/weapon/ore/painite
	scan_icon = "mineral_rare"

/ore/void_opal
	name = "void opal"
	display_name = "rough void opal"
	compresses_to = "void opal"
	result_amount = 2
	spread_chance = 1
	ore = /obj/item/weapon/ore/void_opal
	scan_icon = "mineral_rare"

/ore/astralite
	name = "astralite"
	display_name = "raw astralite"
	alloy = 1
	result_amount = 1
	spread_chance = 1
	ore = /obj/item/weapon/ore/astralite
	scan_icon = "mineral_rare"