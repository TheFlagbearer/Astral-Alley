/*

TODO:
give money an actual use (QM stuff, vending machines)
send money to people (might be worth attaching money to custom database thing for this, instead of being in the ID)
log transactions

*/

#define NO_SCREEN 0
#define CHANGE_SECURITY_LEVEL 1
#define TRANSFER_FUNDS 2
#define VIEW_TRANSACTION_LOGS 3

/obj/item/weapon/card/id/var/money = 2000

/obj/machinery/atm
	name = "Automatic Teller Machine"
	desc = "For all your monetary needs!"
	icon = 'icons/obj/terminals.dmi'
	icon_state = "atm"
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	circuit =  /obj/item/weapon/circuitboard/atm
	var/datum/money_account/authenticated_account
	var/number_incorrect_tries = 0
	var/previous_account_number = 0
	var/max_pin_attempts = 3
	var/ticks_left_locked_down = 0
	var/ticks_left_timeout = 0
	var/machine_id = ""
	var/obj/item/weapon/card/held_card
	var/editing_security_level = 0
	var/view_screen = NO_SCREEN
	var/datum/effect/effect/system/spark_spread/spark_system

	var/is_printing = FALSE

/obj/machinery/atm/New()
	..()
	machine_id = "[station_name()] RT #[GLOB.num_financial_terminals++]"
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/machinery/atm/process()
	if(stat & NOPOWER)
		return

	if(ticks_left_timeout > 0)
		ticks_left_timeout--
		if(ticks_left_timeout <= 0)
			authenticated_account = null
	if(ticks_left_locked_down > 0)
		ticks_left_locked_down--
		if(ticks_left_locked_down <= 0)
			number_incorrect_tries = 0

	for(var/obj/item/weapon/spacecash/S in src)
		S.loc = src.loc
		if(prob(50))
			playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
		else
			playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)
		break
/*
/obj/machinery/atm/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		return

	//short out the machine, shoot sparks, spew money!
	emagged = 1
	spark_system.start()
	spawn_money(rand(100,500),src.loc)
	//we don't want to grief people by locking their id in an emagged ATM
	release_held_id(user)

	//display a message to the user
	var/response = pick("Initiating withdraw. Have a nice day!", "CRITICAL ERROR: Activating cash chamber panic siphon.","PIN Code accepted! Emptying account balance.", "Jackpot!")
	user << "<span class='warning'>\icon[src] The [src] beeps: \"[response]\"</span>"
	return 1
*/
/obj/machinery/atm/attackby(obj/item/I as obj, mob/user as mob)
	if(computer_deconstruction_screwdriver(user, I))
		return
	if(istype(I, /obj/item/weapon/card))
		if(emagged > 0)
			//prevent inserting id into an emagged ATM
			user << "<font color='red'>\icon[src] CARD READER ERROR. This system has been compromised!</font>"
			return
		else if(istype(I,/obj/item/weapon/card/emag))
			I.resolve_attackby(src, user)
			return

		var/obj/item/weapon/card/id/idcard = I
		if(!held_card)
			usr.drop_item()
			idcard.loc = src
			held_card = idcard
			if(authenticated_account && held_card.associated_account_number != authenticated_account.account_number)
				authenticated_account = null
	else if(authenticated_account)
		if(istype(I,/obj/item/weapon/spacecash))
			var/obj/item/weapon/spacecash/C = I
			//consume the money
			authenticated_account.money += C.worth
			if(prob(50))
				playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
			else
				playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

			//create a transaction log entry
			authenticated_account.add_transaction_log(authenticated_account.owner_name, "Credit deposit", C.worth, machine_id)

			to_chat(user, "<span class='info'>You insert [C] into [src].</span>")
			src.attack_hand(user)
			qdel(C)
	else
		..()

/obj/machinery/atm/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/silicon))
		to_chat (user, "<span class='warning'>A firewall prevents you from interfacing with this device!</span>")
		return
	if(get_dist(src,user) <= 1)

		//js replicated from obj/machinery/computer/card
		var/dat = "<h1>Automatic Teller Machine</h1>"
		dat += "For all your monetary needs!<br>"
		dat += "<i>This terminal is</i> [machine_id]. <i>Report this code when contacting IT Support</i><br/>"

		if(emagged > 0)
			dat += "Card: <span style='color: red;'>LOCKED</span><br><br><span style='color: red;'>Unauthorized terminal access detected! This ATM has been locked. Please contact IT Support.</span>"
		else
			dat += "Card: <a href='?src=\ref[src];choice=insert_card'>[held_card ? held_card.name : "------"]</a><br><br>"

			if(ticks_left_locked_down > 0)
				dat += "<span class='alert'>Maximum number of pin attempts exceeded! Access to this ATM has been temporarily disabled.</span>"
			else if(authenticated_account)
				if(authenticated_account.suspended)
					dat += "<font color='red'><b>Access to this account has been suspended, and the funds within frozen.</b></font>"
				else
					switch(view_screen)
						if(CHANGE_SECURITY_LEVEL)
							dat += "Select a new security level for this account:<br><hr>"
							var/text = "Zero - Either the account number or card is required to access this account. EFTPOS transactions will require a card and ask for a pin, but not verify the pin is correct."
							if(authenticated_account.security_level != 0)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=0'>[text]</a>"
							dat += "[text]<hr>"
							text = "One - An account ID and pin must be manually entered to access this account and process transactions."
							if(authenticated_account.security_level != 1)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=1'>[text]</a>"
							dat += "[text]<hr>"
							text = "Two - In addition to account number and pin, a card is required to access this account and process transactions."
							if(authenticated_account.security_level != 2)
								text = "<A href='?src=\ref[src];choice=change_security_level;new_security_level=2'>[text]</a>"
							dat += "[text]<hr><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
						if(VIEW_TRANSACTION_LOGS)
							dat += "<b>Transaction logs</b><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a>"
							dat += "<table border=1 style='width:100%'>"
							dat += "<tr>"
							dat += "<td><b>Date</b></td>"
							dat += "<td><b>Time</b></td>"
							dat += "<td><b>Target</b></td>"
							dat += "<td><b>Purpose</b></td>"
							dat += "<td><b>Value</b></td>"
							dat += "<td><b>Source terminal ID</b></td>"
							dat += "</tr>"
							for(var/datum/transaction/T in authenticated_account.transaction_log)
								dat += "<tr>"
								dat += "<td>[T.date]</td>"
								dat += "<td>[T.time]</td>"
								dat += "<td>[T.target_name]</td>"
								dat += "<td>[T.purpose]</td>"
								dat += "<td>[T.amount]</td>"
								dat += "<td>[T.source_terminal]</td>"
								dat += "</tr>"
							dat += "</table>"
							dat += "<A href='?src=\ref[src];choice=print_transaction'>Print</a><br>"
						if(TRANSFER_FUNDS)
							dat += "<b>Account balance:</b> [cash2text( authenticated_account.money, FALSE, TRUE, TRUE )]<br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=0'>Back</a><br><br>"
							dat += "<form name='transfer' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='hidden' name='choice' value='transfer'>"
							dat += "Target account ID: <input type='text' name='target_acc_number' value='' style='width:200px; background-color:white;'><br>"
							dat += "Funds to transfer: <input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><br>"
							dat += "Transaction purpose: <input type='text' name='purpose' value='Funds transfer' style='width:200px; background-color:white;'><br>"
							dat += "<input type='submit' value='Transfer funds'><br>"
							dat += "</form>"
						else
							dat += "Welcome, <b>[authenticated_account.owner_name].</b><br/>"
							dat += "<b>Account balance:</b> [cash2text( authenticated_account.money, FALSE, TRUE, TRUE )]"

							//show expenses
							if(!isemptylist(authenticated_account.expenses))
								dat += "<br><br><b>Debts:</b><br>"
								for(var/datum/expense/E in authenticated_account.expenses)
									var/dept_name
									if(E.department)
										dept_name = dept_name_by_id(E.department)
									var/purpose_name
									if(E.purpose)
										purpose_name = " ([E.purpose])"
										if(dept_name)
											dat += "([dept_name]) "
										dat += "<b>[E.name][purpose_name]:</b> [E.amount_left] credits. ([E.cost_per_payroll] per payroll.)<br>"
							dat += "<br>"

							dat += "<form name='withdrawal' action='?src=\ref[src]' method='get'>"
							dat += "<input type='hidden' name='src' value='\ref[src]'>"
							dat += "<input type='radio' name='choice' value='withdrawal' checked> Cash  <input type='radio' name='choice' value='e_withdrawal'> Chargecard<br>"
							dat += "<input type='text' name='funds_amount' value='' style='width:200px; background-color:white;'><input type='submit' value='Withdraw'>"
							dat += "</form>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=1'>Change account security level</a><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=2'>Make transfer</a><br>"
							dat += "<A href='?src=\ref[src];choice=view_screen;view_screen=3'>View transaction log</a><br>"
							dat += "<A href='?src=\ref[src];choice=balance_statement'>Print balance statement</a><br>"
							dat += "<A href='?src=\ref[src];choice=logout'>Logout</a><br>"
			else
				dat += "<form name='atm_auth' action='?src=\ref[src]' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='choice' value='attempt_auth'>"
				dat += "<b>Account:</b> <input type='text' id='account_num' name='account_num' style='width:250px; background-color:white;'><br>"
				dat += "<b>PIN:</b> <input type='text' id='account_pin' name='account_pin' style='width:250px; background-color:white;'><br>"
				dat += "<input type='submit' value='Submit'><br>"
				dat += "</form>"

		var/datum/browser/popup = new(user, "atm", "[src]", 550, 650, src)
		popup.set_content(jointext(dat,null))
		popup.open()

		onclose(user, "atm")

	else
		onclose(user, "atm")


/obj/machinery/atm/Topic(var/href, var/href_list)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("transfer")
				if(authenticated_account)
					var/transfer_amount = text2num(href_list["funds_amount"])
					transfer_amount = round(transfer_amount, 0.01)
					if(transfer_amount <= 0)
						alert("That is not a valid amount.")
					else if(transfer_amount <= authenticated_account.money)
						var/target_account_number = href_list["target_acc_number"]
						var/transfer_purpose = href_list["purpose"]
						if(charge_to_account(target_account_number, authenticated_account.owner_name, transfer_purpose, machine_id, transfer_amount))
							usr << "\icon[src]<span class='info'>Funds transfer successful.</span>"
							authenticated_account.money -= transfer_amount
							log_money(usr, "transferred money to [target_account_number] successfully", authenticated_account.account_number, authenticated_account.owner_name, transfer_amount)

							var/datum/money_account/TM = get_account(target_account_number)
							if(!TM.hidden)
								//create an entry in the account transaction log
								authenticated_account.add_transaction_log("Account #[target_account_number]", transfer_purpose, -transfer_amount, machine_id)
						else
							usr << "\icon[src]<span class='warning'>Funds transfer failed.</span>"
							log_money(usr, "failed to transfer money to [target_account_number] (unsuccesful)", authenticated_account.account_number, authenticated_account.owner_name, transfer_amount)



					else
						usr << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"
			if("view_screen")
				view_screen = text2num(href_list["view_screen"])
			if("change_security_level")
				if(authenticated_account)
					var/new_sec_level = max( min(text2num(href_list["new_security_level"]), 2), 0)
					if(new_sec_level == 2)
						switch(alert("Raising your security level to 2 will require the use of an ID card. If you lose your ID card or do not have one, you WILL lose access to your bank account! Are you sure you want to do this?", "Security Alert", "Yes", "No"))
							if("No")
								return
					authenticated_account.security_level = new_sec_level
					log_money(usr, "changed bank security level to [authenticated_account.security_level]", authenticated_account.account_number, authenticated_account.owner_name, 0)
			if("attempt_auth")

				// check if they have low security enabled
				scan_user(usr)

				if(!ticks_left_locked_down && held_card)
					var/tried_account_num = href_list["account_num"]
					if(!tried_account_num)
						tried_account_num = held_card.associated_account_number
					var/tried_pin = text2num(href_list["account_pin"])

					authenticated_account = attempt_account_access(tried_account_num, tried_pin, held_card && held_card.associated_account_number == tried_account_num ? 2 : 1)
					if(!authenticated_account)
						number_incorrect_tries++
						if(previous_account_number == tried_account_num)
							if(number_incorrect_tries > max_pin_attempts)
								//lock down the atm
								ticks_left_locked_down = 30
								playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)

								//create an entry in the account transaction log
								var/datum/money_account/failed_account = get_account(tried_account_num)
								if(failed_account)
									failed_account.add_transaction_log("Login attempt", "Unauthorised login attempt", 0, machine_id)
									log_money(usr, "unsuccessfully attempted to log in", tried_account_num, "(no success)", "n/a")
							else
								usr << "<font color='red'>\icon[src] Incorrect pin/account combination entered, [max_pin_attempts - number_incorrect_tries] attempts remaining.</font>"
								previous_account_number = tried_account_num
								playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 1)
						else
							usr << "<font color='red'>\icon[src] incorrect pin/account combination entered.</font>"
							number_incorrect_tries = 0
					else
						playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
						ticks_left_timeout = 120
						view_screen = NO_SCREEN

						authenticated_account.add_transaction_log(authenticated_account.owner_name, "Remote terminal access", 0, machine_id)
						usr << "<font color='blue'>\icon[src] Access granted. Welcome user '[authenticated_account.owner_name].</font>'"

					previous_account_number = tried_account_num
			if("e_withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						//	spawn_money(amount,src.loc)
						spawn_ewallet(amount,src.loc,usr)

						//create an entry in the account transaction log
						authenticated_account.add_transaction_log(authenticated_account.owner_name, "Credit withdrawal", -amount, machine_id)

						log_money(usr, "withdrew money from [src] (ewallet)", authenticated_account.account_number, authenticated_account.owner_name, amount)
					else
						usr << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"
			if("withdrawal")
				var/amount = max(text2num(href_list["funds_amount"]),0)
				amount = round(amount, 0.01)
				if(amount <= 0)
					alert("That is not a valid amount.")
				else if(authenticated_account && amount > 0)
					if(amount <= authenticated_account.money)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)

						//remove the money
						authenticated_account.money -= amount

						spawn_money(amount,src.loc,usr)

						authenticated_account.add_transaction_log(authenticated_account.owner_name, "Credit withdrawal", -amount, machine_id)
						log_money(usr, "withdrew money from [src] (cash)", authenticated_account.account_number, authenticated_account.owner_name, amount)
					else
						usr << "\icon[src]<span class='warning'>You don't have enough funds to do that!</span>"
			if("balance_statement")
				if(is_printing)
					to_chat(usr, "The ATM is still printing, be patient!")
					return

				to_chat(usr, "Printing account balance statement...")
				is_printing = TRUE
				sleep(15)

				if(authenticated_account)
					var/obj/item/weapon/paper/R = new(src.loc)
					R.name = "Account balance: [authenticated_account.owner_name]"
					R.info = "<b>NT Automated Teller Account Statement</b><br><br>"
					R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Account ID:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Balance:</i> [cash2text( authenticated_account.money, FALSE, TRUE, TRUE )]<br>"
					R.info += "<i>Date and time:</i> [stationtime2text()], [GLOB.current_date_string]<br><br>"
					R.info += "<i>Service terminal ID:</i> [machine_id]<br>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/weapon/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

				is_printing = FALSE

			if ("print_transaction")
				if(is_printing)
					to_chat(usr, "The ATM is still printing, be patient!")
					return

				to_chat(usr, "Printing transaction balance...")
				is_printing = TRUE
				sleep(15)

				if(authenticated_account)
					var/obj/item/weapon/paper/R = new(src.loc)
					R.name = "Transaction logs: [authenticated_account.owner_name]"
					R.info = "<b>Transaction logs</b><br>"
					R.info += "<i>Account holder:</i> [authenticated_account.owner_name]<br>"
					R.info += "<i>Account ID:</i> [authenticated_account.account_number]<br>"
					R.info += "<i>Date and time:</i> [stationtime2text()], [GLOB.current_date_string]<br><br>"
					R.info += "<i>Service terminal ID:</i> [machine_id]<br>"
					R.info += "<table border=1 style='width:100%'>"
					R.info += "<tr>"
					R.info += "<td><b>Date</b></td>"
					R.info += "<td><b>Time</b></td>"
					R.info += "<td><b>Target</b></td>"
					R.info += "<td><b>Purpose</b></td>"
					R.info += "<td><b>Value</b></td>"
					R.info += "<td><b>Source terminal ID</b></td>"
					R.info += "</tr>"
					for(var/datum/transaction/T in authenticated_account.transaction_log)
						R.info += "<tr>"
						R.info += "<td>[T.date]</td>"
						R.info += "<td>[T.time]</td>"
						R.info += "<td>[T.target_name]</td>"
						R.info += "<td>[T.purpose]</td>"
						R.info += "<td>[T.amount]</td>"
						R.info += "<td>[T.source_terminal]</td>"
						R.info += "</tr>"
					R.info += "</table>"

					//stamp the paper
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!R.stamped)
						R.stamped = new
					R.stamped += /obj/item/weapon/stamp
					R.overlays += stampoverlay
					R.stamps += "<HR><i>This paper has been stamped by the Automatic Teller Machine.</i>"

				if(prob(50))
					playsound(loc, 'sound/items/polaroid1.ogg', 50, 1)
				else
					playsound(loc, 'sound/items/polaroid2.ogg', 50, 1)

				is_printing = FALSE

			if("insert_card")
				if(!held_card)
					//this might happen if the user had the browser window open when somebody emagged it
					if(emagged > 0)
						usr << "<font color='red'>\icon[src] The ATM card reader rejected your ID because this machine has been sabotaged!</font>"
					else
						var/obj/item/I = usr.get_active_hand()
						if (istype(I, /obj/item/weapon/card/id))
							usr.drop_item()
							I.loc = src
							held_card = I
				else
					release_held_id(usr)

			if("logout")
				authenticated_account = null
				//usr << browse(null,"window=atm")

	src.attack_hand(usr)

//stolen wholesale and then edited a bit from newscasters, which are awesome and by Agouri
/obj/machinery/atm/proc/scan_user(mob/living/carbon/human/human_user as mob)
	if(!authenticated_account)
		if(human_user.wear_id)
			var/obj/item/weapon/card/id/I
			if(istype(human_user.wear_id, /obj/item/weapon/card/id) )
				I = human_user.wear_id
			else if(istype(human_user.wear_id, /obj/item/device/pda) )
				var/obj/item/device/pda/P = human_user.wear_id
				I = P.id
			if(I)
				authenticated_account = attempt_account_access(I.associated_account_number)
				if(authenticated_account)
					to_chat(human_user, "<font color='blue'>\icon[src] Access granted. Welcome user '[authenticated_account.owner_name].</font>'")

					authenticated_account.add_transaction_log(authenticated_account.owner_name, "Remote terminal access", 0, machine_id)

					view_screen = NO_SCREEN

// put the currently held id on the ground or in the hand of the user
/obj/machinery/atm/proc/release_held_id(mob/living/carbon/human/human_user as mob)
	if(!held_card)
		return

	held_card.loc = src.loc
	authenticated_account = null

	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(held_card)
	held_card = null


/obj/machinery/atm/proc/spawn_ewallet(var/sum, loc, mob/living/carbon/human/human_user as mob)
	var/obj/item/weapon/spacecash/ewallet/E = new /obj/item/weapon/spacecash/ewallet(loc)
	if(ishuman(human_user) && !human_user.get_active_hand())
		human_user.put_in_hands(E)
	E.worth = sum
	E.owner_name = authenticated_account.owner_name
	//Metadata for forensic accountants
	E.metadata += "Owner Name: [authenticated_account.owner_name]"
	E.metadata += "Creation Date: [GLOB.current_date_string]"
	E.metadata += "Creation Time: [stationtime2text()]"
	E.metadata += "Terminal ID: [machine_id]"