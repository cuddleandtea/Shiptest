//BUCKSHOT ROULETTE BY CuddleAndTea//
// --- Let's play a game --- //

//AMMO//
/obj/item/ammo_box/magazine/buckshot
	name = "dealers hand"
	desc = "Ammo will be loaded in the random order"
	icon = 'mod_celadon/adminevents/icons/obj/buckshot_roulette/dealerhand.dmi'
	icon_state = "grabbed+1"
	max_ammo = 8
	start_empty = TRUE
	caliber = "12ga"
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/magazine/buckshot/verb/Shuffle()
	stored_ammo = shuffle(stored_ammo)

/obj/item/ammo_box/magazine/internal/shot/lethal/buckshot_roulette
	max_ammo = 8

/obj/item/ammo_casing/shotgun/buckshot/blank
	name = "blank shell"
	desc = "A blank 12-gauge buckshot shell."
	icon_state = "slug"
	caliber = "12ga"
	projectile_type = null
	BB = null

/obj/item/ammo_casing/shotgun/buckshot/blank/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_box))
		var/obj/item/ammo_box/box = I
		if(isturf(loc))
			var/boolets = 0
			for(var/obj/item/ammo_casing/bullet in loc)
				if (box.stored_ammo.len >= box.max_ammo)
					break
				if (box.give_round(bullet, 0))
					boolets++
				else
					continue
			if (boolets > 0)
				box.update_appearance()
				to_chat(user, "<span class='notice'>You collect [boolets] shell\s. [box] now contains [box.stored_ammo.len] shell\s.</span>")
			else
				to_chat(user, "<span class='warning'>You fail to collect anything!</span>")
	else
		return ..()

///SPAM RANDOM BULLETS///
/obj/effect/spawner/lootdrop/event/buckshot
	name = "spawn shells"
	lootcount = 1
	loot = list(
		/obj/effect/spawner/lootdrop/event/buckshot/two,
		/obj/effect/spawner/lootdrop/event/buckshot/three,
		/obj/effect/spawner/lootdrop/event/buckshot/four
		)

/obj/effect/spawner/lootdrop/event/buckshot/two
	name = "spawn 2 shells"
	lootcount = 2
	loot = list(
		/obj/item/ammo_casing/shotgun/buckshot = 100,
		/obj/item/ammo_casing/shotgun/buckshot/blank = 100,
		)

/obj/effect/spawner/lootdrop/event/buckshot/three
	name = "spawn 3 shells"
	lootcount = 3
	loot = list(
		/obj/item/ammo_casing/shotgun/buckshot = 100,
		/obj/item/ammo_casing/shotgun/buckshot/blank = 100,
		/obj/item/ammo_casing/shotgun/buckshot/blank,
		/obj/item/ammo_casing/shotgun/buckshot
		)

/obj/effect/spawner/lootdrop/event/buckshot/four
	name = "spawn 4 shells"
	lootcount = 4
	loot = list(
		/obj/item/ammo_casing/shotgun/buckshot = 100,
		/obj/item/ammo_casing/shotgun/buckshot/blank = 100,
		/obj/item/ammo_casing/shotgun/buckshot/blank,
		/obj/item/ammo_casing/shotgun/buckshot
		)

//SAW//
/obj/item/circular_saw/alien/buckshot
	name = "sharp saw"
	desc = "Отпили ствол у дробовика. Выстрел нанесёт двойной урон"
	w_class = 1

//SPY GLASS//
/obj/item/spy_glass/buckshot
	name = "spy glass"
	desc = "Посмотри через неё на дробовик, чтобы увидеть какой заряжен патрон. Продолжай игру"
	icon = 'mod_celadon/adminevents/icons/obj/buckshot_roulette/spy_glass.dmi'
	icon_state = "glass"

/obj/item/spy_glass/buckshot/afterattack(obj/item/I, mob/user)
	if(istype(I, /obj/item/gun/ballistic/shotgun/brimstone/buckshot))
		var/obj/item/gun/ballistic/shotgun/brimstone/buckshot/B = I
		to_chat(user, "<span class='info'>You can see that the [B] have [B.chambered]</span>")
		visible_message(span_warning("[user] breaks [src] and looks into the chamber of a [B]..."))
		playsound(src, "shatter", 50, TRUE)
		qdel(src)
	else
		to_chat(user, "<span class='info'>This is not a shotgun.</span>")
		return

//BEER//
/obj/item/reagent_containers/food/drinks/soda_cans/cola/buckshot
	name = "beer can"
	icon = 'mod_celadon/adminevents/icons/obj/buckshot_roulette/beer.dmi'
	desc = "Открой. Выпей. Нажми на дробовик. Выпавший патрон выходит из игры. Продолжай ход"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 10)
	amount_per_transfer_from_this = 10
	qdel(src)

/obj/item/reagent_containers/food/drinks/soda_cans/cola/buckshot/afterattack(obj/item/I, mob/user)
	if(istype(I, /obj/item/gun/ballistic/shotgun/brimstone/buckshot))
		var/obj/item/gun/ballistic/shotgun/brimstone/buckshot/B = I
		to_chat(user, "<span class='info'>You rack the [B]</span>")
		visible_message(span_warning("[user] racks [src] the [B]"))
		B.chamber_round()

//GUN//
/obj/item/gun/ballistic/shotgun/brimstone/buckshot
	name = "shotgun"
	desc = "Do you still want to play?"
	sawn_desc = "Shorter barrel deals twise damage"
	fire_sound = 'sound/weapons/gun/shotgun/brimstone.ogg'
	icon = 'mod_celadon/adminevents/icons/obj/buckshot_roulette/shotgun.dmi'
	icon_state = "shotgun"
	item_state = "shotgun"

	mag_type = /obj/item/ammo_box/magazine/internal/shot/lethal/buckshot_roulette
	manufacturer = MANUFACTURER_HUNTERSPRIDE
	fire_delay = 1

/obj/item/gun/ballistic/shotgun/brimstone/buckshot/blow_up(mob/user)
	return FALSE

/obj/item/gun/ballistic/shotgun/brimstone/buckshot/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(semicd)
		return

	if(user == target)
		target.visible_message(span_warning("[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger..."), \
			span_userdanger("You stick [src] in your mouth, ready to pull the trigger..."))
	else
		target.visible_message(span_warning("[user] points [src] at [target]'s head, ready to pull the trigger..."), \
			span_userdanger("[user] points [src] at your head, ready to pull the trigger..."))

	semicd = TRUE

	if(!bypass_timer && (!do_mob(user, target, 20) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message(span_notice("[user] decided not to shoot."))
			else if(target && target.Adjacent(user))
				target.visible_message(span_notice("[user] has decided to spare [target]."), span_notice("[user] has decided to spare your life!"))
		semicd = FALSE
		return

	semicd = FALSE

	target.visible_message(span_warning("[user] pulls the trigger!"), span_userdanger("[(user == target) ? "You pull" : "[user] pulls"] the trigger!"))

	if(chambered && chambered.BB && can_trigger_gun(user))
		chambered.BB.damage *= 3
		//Check is here for safeties and such, brain will be removed after
		process_fire(target, user, TRUE, params, BODY_ZONE_HEAD)

/obj/item/gun/ballistic/shotgun/brimstone/buckshot/dropped(mob/user, silent = FALSE)
	. = ..()
	name = "shotgun"
	desc = "Do you still want to play?"
	icon_state = "shotgun"
	item_state = "shotgun"
	sawn_off = 0

///Step trigger///



///HP reader by SuhEugene///
/obj/item/buckshot_hp
	name = "Player HP"
	icon = 'mod_celadon/adminevents/icons/obj/buckshot_roulette/long_display.dmi'
	icon_state = ""

	maptext_y = 10
	maptext_x = 0
	maptext_width = 64

	pixel_x = -16

	layer = MOB_LAYER
	anchored = TRUE

	var/hp = 2

/obj/item/buckshot_hp/Initialize()
	. = ..()
	update_maptext_hp()

/obj/item/buckshot_hp/proc/update_maptext_hp()
	if (hp == 0)
		maptext = "<center class='maptext' style='font-size:6px; color: #eb4a38; text-shadow: 0 0 3px #3a0000; -dm-text-outline: 1px #3a0000;'>Game over!</center>"
		maptext_y = 11
		return

	maptext_y = 10
	maptext = "<center class='maptext' style='font-size:8px'>"

	if (hp >= 1)
		maptext += "<span style='-dm-text-outline: 1px #3a0000; text-shadow: 0 0 3px red; color: red;'>🗲</span>"

	if (hp > 1)
		maptext += "<span style='-dm-text-outline: 1px #003a00; text-shadow: 0 0 3px green; color: green;'>"
		maptext += "🗲"
		for (var/i = 1 to hp - 2)
			maptext += "🗲"
		maptext += "</span>"

	maptext += "</center>"

/obj/item/buckshot_hp/vv_edit_var(var_name, var_value)
	if (var_name == "hp")
		hp = var_value
		update_maptext_hp()
		return TRUE

	return ..()
// --- Отсюда начинай. Добавь remove_hp по клику
/obj/item/buckshot_hp/verb/add_hp(client/target_client, var/obj/item/buckshot_hp/BH)
	if(!check_rights(R_ADMIN))
		to_chat(usr, "<span class='warning'>You must be a Dealer to do it.</span>")
		return
	BH.hp +=
	playsound(src, 'mod_celadon/adminevents/sounds/buckshot_roulette/', 50, FALSE)

/datum/buildmode_mode/throwing/handle_click(client/target_client, params, obj/object)
	var/list/modifiers = params2list(params)

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(isturf(object))
			return
		throw_atom = object
		to_chat(target_client, "Selected object '[throw_atom]'")
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(throw_atom)
			throw_atom.throw_at(object, 10, 1, target_client.mob)
			log_admin("Build Mode: [key_name(target_client)] threw [throw_atom] at [object] ([AREACOORD(object)])")

/obj/item/buckshot_hp/verb/Edit_hp()
	if
	stored_ammo = shuffle(stored_ammo)

// --- DECALS --- //
/obj/effect/decal/cleanable/crayon/buckshot
	icon = 'mod_celadon/adminevents/icons/obj/buckshot_roulette/crayondecal.dmi'
	icon_state = "safe"

// --- SOUNDS --- //
/obj/effect/step_trigger/sound_effect/buckshot/dealer_shot
	sound = 'mod_celadon/adminevents/sounds/buckshot_roulette/'
