/obj/structure/prop/misc/display_case
	name = "display case"
	desc = "A display case for prized possessions. It taunts you to kick it."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassboxb0"
	density = 1
	anchored = 1
	interaction_message = "<span class='notice'>Whatever object this display case once held is now long gone.</span>"

/obj/structure/prop/misc/vending_machine
	name = "broken vending machine"
	desc = "Someone's snack got stuck. A shame."
	icon = 'icons/obj/vending.dmi'
	icon_state = "poop"
	density = TRUE
	anchored = TRUE
	interaction_message = "<span class='notice'>An old, dilapidated vending machine. Whatever delicious snacks or drinks it once held are now gone.</span>"
	var/stored_money = 0

/obj/structure/prop/misc/vending_machine/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = I
		stored_money += C.worth
		qdel(I)
		to_chat(user, span("notice", "\The [src] eats your money. Why did you think that would work?"))
		return
	else
		..()