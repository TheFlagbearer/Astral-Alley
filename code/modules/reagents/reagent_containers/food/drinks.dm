////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10,15,25,30)
	volume = 50
	var/shaken
	price_tag = 5
	tax_type = DRINKS_TAX
	unique_save_vars = list("shaken")

/obj/item/weapon/reagent_containers/food/drinks/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/R = reagents.get_master_reagent()
		if(R.price_tag)
			price_tag = R.price_tag
		else
			price_tag = null
	return

/obj/item/weapon/reagent_containers/food/drinks/proc/open(mob/user)
	playsound(loc,"canopen", rand(10,50), 1)
	user << "<span class='notice'>You open [src] with an audible pop!</span>"
	flags |= OPENCONTAINER

/obj/item/weapon/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/weapon/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		user << "<span class='notice'>You need to open [src]!</span>"
		return 1
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		user << "<span class='notice'>You need to open [src]!</span>"
		return 1
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/standard_pour_into(var/mob/user, var/atom/target)
	if(!is_open_container())
		user << "<span class='notice'>You need to open [src]!</span>"
		return 1
	return ..()

/obj/item/weapon/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/weapon/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You drink from \the [src].</span>")

/obj/item/weapon/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		if(user.a_intent == I_HURT && !shaken)
			shaken = 1
			user.visible_message("[user] shakes \the [src]!", "You shake \the [src]!")
			playsound(loc,'sound/items/soda_shaking.ogg', rand(10,50), 1)
			return
		if(shaken)
			boom(user)
		else
			open(user)

/obj/item/weapon/reagent_containers/food/drinks/proc/boom(mob/user as mob)
	user.visible_message("<span class='danger'>\The [src] explodes all over [user] as they open it!</span>","<span class='danger'>\The [src] explodes all over you as you open it!</span>","You can hear a soda can explode.")
	playsound(loc,'sound/items/soda_burst.ogg', rand(20,50), 1)
	qdel(reagents)
	flags |= OPENCONTAINER
	shaken = 0

/obj/item/weapon/reagent_containers/food/drinks/examine(mob/user)
	if(!..(user, 1))
		return
	if(!reagents || reagents.total_volume == 0)
		user << "<span class='notice'>\The [src] is empty!</span>"
	else if (reagents.total_volume <= volume * 0.25)
		user << "<span class='notice'>\The [src] is almost empty!</span>"
	else if (reagents.total_volume <= volume * 0.66)
		user << "<span class='notice'>\The [src] is half full!</span>"
	else if (reagents.total_volume <= volume * 0.90)
		user << "<span class='notice'>\The [src] is almost full!</span>"
	else
		user << "<span class='notice'>\The [src] is full!</span>"


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/drinks/trophy_cup
	desc = "trophy cup"
	name = "trophy cup"
	icon_state = "trophy_cup"
	item_state = "" //nope :(
	w_class = ITEMSIZE_LARGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = CONDUCT | OPENCONTAINER

	var/engraving = null

	unique_save_vars = list("engraving")

/obj/item/weapon/reagent_containers/food/drinks/trophy_cup/examine(mob/user)
	..()
	if(engraving)
		to_chat(user, "\"[engraving]\"")


/obj/item/weapon/reagent_containers/food/drinks/golden_cup/on_reagent_change()
	..()


/obj/item/weapon/reagent_containers/food/drinks/trophy_cup/gold
	name = "golden trophy cup"
	color = COLOR_GOLD

/obj/item/weapon/reagent_containers/food/drinks/trophy_cup/silver
	name = "silver trophy cup"
	color = COLOR_SILVER

/obj/item/weapon/reagent_containers/food/drinks/trophy_cup/bronze
	name = "bronze trophy cup"
	color = WOOD_COLOR_YELLOW

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/weapon/reagent_containers/food/drinks/milk
	name = "milk carton"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/box.ogg'

/obj/item/weapon/reagent_containers/food/drinks/milk/New()
	..()
	reagents.add_reagent("milk", 50)

/obj/item/weapon/reagent_containers/food/drinks/soymilk
	name = "soymilk carton"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/box.ogg'

/obj/item/weapon/reagent_containers/food/drinks/soymilk/New()
	..()
	reagents.add_reagent("soymilk", 50)

/obj/item/weapon/reagent_containers/food/drinks/smallmilk
	name = "small milk carton"
	desc = "It's milk. White and nutritious goodness!"
	volume = 30
	icon_state = "mini-milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)

/obj/item/weapon/reagent_containers/food/drinks/smallmilk/New()
	..()
	reagents.add_reagent("milk", 30)

/obj/item/weapon/reagent_containers/food/drinks/smallchocmilk
	name = "small chocolate milk carton"
	desc = "It's milk! This one is in delicious chocolate flavour."
	volume = 30
	icon_state = "mini-milk_choco"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	drop_sound = 'sound/items/drop/box.ogg'

/obj/item/weapon/reagent_containers/food/drinks/smallchocmilk/New()
	..()
	reagents.add_reagent("chocolate_milk", 30)

/obj/item/weapon/reagent_containers/food/drinks/coffee
	name = "\improper Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)
/obj/item/weapon/reagent_containers/food/drinks/coffee/New()
	..()
	reagents.add_reagent("coffee", 30)

/obj/item/weapon/reagent_containers/food/drinks/tea
	name = "cup of Duke Purple Tea"
	desc = "An insult to Duke Purple is an insult to the Space Queen! Any proper gentleman will fight you, if you sully this tea."
	icon_state = "teacup"
	item_state = "coffee"
	center_of_mass = list("x"=16, "y"=14)

/obj/item/weapon/reagent_containers/food/drinks/tea/New()
	..()
	reagents.add_reagent("tea", 30)

/obj/item/weapon/reagent_containers/food/drinks/ice
	name = "cup of ice"
	desc = "Careful, cold ice, do not chew."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)

/obj/item/weapon/reagent_containers/food/drinks/ice/New()
	..()
	reagents.add_reagent("ice", 30)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	name = "cup of Dutch hot coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "coffee"
	center_of_mass = list("x"=15, "y"=13)

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate/New()
	..()
	reagents.add_reagent("hot_coco", 30)

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = list("x"=16, "y"=11)
/obj/item/weapon/reagent_containers/food/drinks/dry_ramen/New()
	..()
	reagents.add_reagent("dry_ramen", 30)

/obj/item/weapon/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = list("x"=16, "y"=12)
	drop_sound = 'sound/items/drop/box.ogg'

/obj/item/weapon/reagent_containers/food/drinks/sillycup/New()
	..()

/obj/item/weapon/reagent_containers/food/drinks/sillycup/on_reagent_change()
	..()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

/obj/item/weapon/reagent_containers/food/drinks/sillycup/MouseDrop(obj/over_object as obj)
	if(!reagents.total_volume && istype(over_object, /obj/structure/reagent_dispensers/water_cooler))
		if(over_object.Adjacent(usr))
			var/obj/structure/reagent_dispensers/water_cooler/W = over_object
			if(W.cupholder && W.cups < 10)
				W.cups++
				usr << "<span class='notice'>You put the [src] in the cup dispenser.</span>"
				qdel(src)
				W.update_icon()
	else
		return ..()

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/weapon/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=10)
	drop_sound = 'sound/items/drop/bottle.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 1750)

/obj/item/weapon/reagent_containers/food/drinks/shaker/on_reagent_change()
	..()

/obj/item/weapon/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=7)
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/weapon/reagent_containers/food/drinks/teapot/on_reagent_change()
	..()

/obj/item/weapon/reagent_containers/food/drinks/flask
	name = "\improper Mayor's flask"
	desc = "A metal flask belonging to the Mayor"
	icon_state = "flask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)
	drop_sound = 'sound/items/drop/bottle.ogg'
	matter = list(DEFAULT_WALL_MATERIAL = 2750)

/obj/item/weapon/reagent_containers/food/drinks/flask/on_reagent_change()
	..()

/obj/item/weapon/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/weapon/reagent_containers/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/weapon/reagent_containers/food/drinks/flask/detflask
	name = "\improper Detective's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the detective."
	icon_state = "detflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=8)

/obj/item/weapon/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = list("x"=15, "y"=4)
	matter = list(DEFAULT_WALL_MATERIAL = 2750)

/obj/item/weapon/reagent_containers/food/drinks/britcup
	name = "cup"
	desc = "A cup with the British flag emblazoned on it."
	icon_state = "britcup"
	volume = 30
	center_of_mass = list("x"=15, "y"=13)
	drop_sound = 'sound/items/drop/bottle.ogg'

/obj/item/weapon/reagent_containers/food/drinks/britcup/on_reagent_change()
	..()

