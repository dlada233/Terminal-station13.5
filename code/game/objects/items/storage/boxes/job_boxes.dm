// This contains all boxes that will be used on round-start spawning into a job.

// Ordinary survival box. Every crewmember gets one of these.
/obj/item/storage/box/survival
	name = "求生盒"
	desc = "一个装着生存必须品的盒子."
	icon_state = "internals"
	illustration = "emergencytank"
	/// What type of mask are we going to use for this box?
	var/mask_type = /obj/item/clothing/mask/breath
	/// Which internals tank are we going to use for this box?
	var/internal_type = /obj/item/tank/internals/emergency_oxygen
	/// What medipen should be present in this box?
	var/medipen_type = /obj/item/reagent_containers/hypospray/medipen
	/// Are we crafted?
	var/crafted = FALSE

/obj/item/storage/box/survival/Initialize(mapload)
	. = ..()
	if(crafted || !HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		return
	atom_storage.max_slots += 2
	atom_storage.max_total_storage += 4
	name = "大[name]"
	transform = transform.Scale(1.25, 1)

/obj/item/storage/box/survival/PopulateContents()
	if(crafted)
		return
	if(!isnull(mask_type))
		new mask_type(src)
	//SKYRAT EDIT ADDITION START - VOX INTERNALS - Honestly I dont know if this has a function any more with wardrobe_removal(), but TG still uses the plasmaman one so better safe than sorry
	if(!isplasmaman(loc))
		if(isvox(loc))
			new /obj/item/tank/internals/nitrogen/belt/emergency(src)
		else
			new internal_type(src)
	else
		new /obj/item/tank/internals/plasmaman/belt(src)
	//SKYRAT EDIT ADDITION END - VOX INTERNALS

	if(!isnull(medipen_type))
		new medipen_type(src)

	if(HAS_TRAIT(SSstation, STATION_TRAIT_PREMIUM_INTERNALS))
		new /obj/item/flashlight/flare(src)
		new /obj/item/radio/off(src)

	if(HAS_TRAIT(SSstation, STATION_TRAIT_RADIOACTIVE_NEBULA))
		new /obj/item/storage/pill_bottle/potassiodide(src)

	if(SSmapping.is_planetary() && LAZYLEN(SSmapping.multiz_levels))
		new /obj/item/climbing_hook/emergency(src)

	new /obj/item/oxygen_candle(src) //SKYRAT EDIT ADDITION

/obj/item/storage/box/survival/radio/PopulateContents()
	..() // we want the survival stuff too.
	new /obj/item/radio/off(src)

/obj/item/storage/box/survival/proc/wardrobe_removal()
	if(!isplasmaman(loc) && !isvox(loc)) //We need to specially fill the box with plasmaman gear, since it's intended for one	//SKYRAT EDIT: && !isvox(loc)
		return
	var/obj/item/mask = locate(mask_type) in src
	var/obj/item/internals = locate(internal_type) in src
	//SKYRAT EDIT ADDITION START - VOX INTERNALS - Vox mimic the above and below behavior, removing the redundant mask/internals; they dont mimic the plasma breathing though
	if(!isvox(loc))
		new /obj/item/tank/internals/plasmaman/belt(src)
	else
		new /obj/item/tank/internals/nitrogen/belt/emergency(src)
	//SKYRAT EDIT ADDITION END - VOX INTERNALS
	qdel(mask) // Get rid of the items that shouldn't be
	qdel(internals)

// Mining survival box
/obj/item/storage/box/survival/mining
	mask_type = /obj/item/clothing/mask/gas/explorer/folded

/obj/item/storage/box/survival/mining/PopulateContents()
	..()
	new /obj/item/crowbar/red(src)
	new /obj/item/healthanalyzer/simple/miner(src)

// Engineer survival box
/obj/item/storage/box/survival/engineer
	name = "扩容求生盒"
	desc = "一个装着生存必须品的盒子, 盒子标签上写有一个大容量的气瓶."
	illustration = "extendedtank"
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi

/obj/item/storage/box/survival/engineer/radio/PopulateContents()
	..() // we want the regular items too.
	new /obj/item/radio/off(src)

// Syndie survival box
/obj/item/storage/box/survival/syndie
	name = "特战求生盒"
	desc = "一个盒子装着你的求生用品，这个标签上印着有大容量的气瓶和方便的生存小贴士."
	icon_state = "syndiebox"
	illustration = "extendedtank"
	mask_type = /obj/item/clothing/mask/gas/syndicate
	internal_type = /obj/item/tank/internals/emergency_oxygen/engi
	medipen_type =  /obj/item/reagent_containers/hypospray/medipen/atropine

/obj/item/storage/box/survival/syndie/PopulateContents()
	..()
	new /obj/item/crowbar/red(src)
	new /obj/item/screwdriver/red(src)
	new /obj/item/weldingtool/mini(src)
	new /obj/item/paper/fluff/operative(src)

/obj/item/storage/box/survival/centcom
	name = "快反求生盒"
	desc = "一个装着确保你的团队生存的基本用品的盒子。这个标签上写着双罐气瓶."
	illustration = "extendedtank"
	internal_type = /obj/item/tank/internals/emergency_oxygen/double

/obj/item/storage/box/survival/centcom/PopulateContents()
	. = ..()
	new /obj/item/crowbar(src)

// Security survival box
/obj/item/storage/box/survival/security
	mask_type = /obj/item/clothing/mask/gas/sechailer

/obj/item/storage/box/survival/security/radio/PopulateContents()
	..() // we want the regular stuff too
	new /obj/item/radio/off(src)

// Medical survival box
/obj/item/storage/box/survival/medical
	mask_type = /obj/item/clothing/mask/breath/medical

/obj/item/storage/box/survival/crafted
	crafted = TRUE

/obj/item/storage/box/survival/engineer/crafted
	crafted = TRUE

//Mime spell boxes

/obj/item/storage/box/mime
	name = "看不见的盒子"
	desc = "不幸的是，它不够大，无法捕获默剧演员."
	foldable_result = null
	icon_state = "box"
	inhand_icon_state = null
	alpha = 0

/obj/item/storage/box/mime/attack_hand(mob/user, list/modifiers)
	..()
	if(HAS_MIND_TRAIT(user, TRAIT_MIMING))
		alpha = 255

/obj/item/storage/box/mime/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	if (iscarbon(old_loc))
		alpha = 0
	return ..()

/obj/item/storage/box/hug
	name = "抱抱盒"
	desc = "给那些多愁善感的人."
	icon_state = "hugbox"
	illustration = "heart"
	foldable_result = null

/obj/item/storage/box/hug/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]夹紧抱抱盒在脖颈上!我猜它根本就不是一个抱抱盒.."))
	return BRUTELOSS

/obj/item/storage/box/hug/attack_self(mob/user)
	..()
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, SFX_RUSTLE, 50, vary=TRUE, extrarange=-5)
	user.visible_message(span_notice("[user]抱了[src]."),span_notice("你抱了[src]."))

/obj/item/storage/box/hug/black
	icon_state = "hugbox_black"
	illustration = "heart_black"

// clown box, we also use this for the honk bot assembly
/obj/item/storage/box/clown
	name = "小丑盒"
	desc = "给小丑的彩色盒子"
	illustration = "clown"

/obj/item/storage/box/clown/attackby(obj/item/I, mob/user, params)
	if((istype(I, /obj/item/bodypart/arm/left/robot)) || (istype(I, /obj/item/bodypart/arm/right/robot)))
		if(contents.len) //prevent accidently deleting contents
			balloon_alert(user, "内有物品!")
			return
		if(!user.temporarilyRemoveItemFromInventory(I))
			return
		qdel(I)
		balloon_alert(user, "wheels added, honk!")
		var/obj/item/bot_assembly/honkbot/A = new
		qdel(src)
		user.put_in_hands(A)
	else
		return ..()

/obj/item/storage/box/clown/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]打开[src]，并被[p_them()]消耗! 这是一种自杀行为!"))
	playsound(user, 'sound/misc/scary_horn.ogg', 70, vary = TRUE)
	forceMove(user.drop_location())
	var/obj/item/clothing/head/mob_holder/consumed = new(src, user)
	consumed.desc = "[user.real_name]! 看起来是自杀了!"
	return OXYLOSS

// Special stuff for medical hugboxes.
/obj/item/storage/box/hug/medical/PopulateContents()
	new /obj/item/stack/medical/bruise_pack(src)
	new /obj/item/stack/medical/ointment(src)
	new /obj/item/reagent_containers/hypospray/medipen(src)

//Clown survival box
/obj/item/storage/box/survival/hug
	name = "抱抱盒"
	desc = "多愁善感人群专用的盒子."
	icon_state = "hugbox"
	illustration = "heart"
	foldable_result = null
	mask_type = null
	var/random_funny_internals = TRUE

/obj/item/storage/box/survival/hug/PopulateContents()
	if(!random_funny_internals)
		return ..()
	internal_type = pick(
			/obj/item/tank/internals/emergency_oxygen/engi/clown/n2o,
			/obj/item/tank/internals/emergency_oxygen/engi/clown/bz,
			/obj/item/tank/internals/emergency_oxygen/engi/clown/helium,
			)
	return ..()

//Mime survival box
/obj/item/storage/box/survival/hug/black
	icon_state = "hugbox_black"
	illustration = "heart_black"
	random_funny_internals = FALSE

//Duplicated suicide/attack self procs, since the survival boxes are a subtype of box/survival
/obj/item/storage/box/survival/hug/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]夹紧抱抱盒在脖颈上!我猜它根本就不是一个抱抱盒.."))
	return BRUTELOSS

/obj/item/storage/box/survival/hug/attack_self(mob/user)
	..()
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, SFX_RUSTLE, 50, vary=TRUE, extrarange=-5)
	user.visible_message(span_notice("[user]拥抱了[src]."),span_notice("你拥抱了[src]."))

/obj/item/storage/box/hug/plushes
	name = "战术抱抱套件"
	desc = "一个可爱的小盒子，里面装满了柔软可爱的毛绒玩具，非常适合让刚刚遭受危险事件的人平静下来，\
	传说地狱里有一个特别的地方给那些拿走盒子只为自己的医务人员."

/obj/item/storage/box/hug/plushes/PopulateContents()
	for(var/i in 1 to 7)
		var/plush_path = /obj/effect/spawner/random/entertainment/plushie
		new plush_path(src)

/obj/item/storage/box/survival/mining/bonus
	mask_type = null
	internal_type = /obj/item/tank/internals/emergency_oxygen/double

/obj/item/storage/box/survival/mining/bonus/PopulateContents()
	..()
	new /obj/item/gps/mining(src)
	new /obj/item/t_scanner/adv_mining_scanner(src)

/obj/item/storage/box/miner_modkits
	name = "矿工模块/奖杯盒"
	desc = "包含游戏中所有的采矿模块和奖杯."

/obj/item/storage/box/miner_modkits/Initialize(mapload)
	. = ..()
	atom_storage.set_holdable(list(/obj/item/borg/upgrade/modkit, /obj/item/crusher_trophy))
	atom_storage.numerical_stacking = TRUE

/obj/item/storage/box/miner_modkits/PopulateContents()
	for(var/trophy in subtypesof(/obj/item/crusher_trophy))
		new trophy(src)
	for(var/modkit in subtypesof(/obj/item/borg/upgrade/modkit))
		for(var/i in 1 to 10) //minimum cost ucrrently is 20, and 2 pkas, so lets go with that
			new modkit(src)

/obj/item/storage/box/skillchips
	name = "技能芯片盒"
	desc = "内含所有技能芯片的副本"

/obj/item/storage/box/skillchips/PopulateContents()
	var/list/skillchips = subtypesof(/obj/item/skillchip)

	for(var/skillchip in skillchips)
		new skillchip(src)

/obj/item/storage/box/skillchips/science
	name = "科研技能芯片盒"
	desc = "包含所有科研技能芯片的副本."

/obj/item/storage/box/skillchips/science/PopulateContents()
	new/obj/item/skillchip/job/roboticist(src)
	new/obj/item/skillchip/job/roboticist(src)

/obj/item/storage/box/skillchips/engineering
	name = "工程技能芯片盒"
	desc = "包含所有工程技能芯片的副本."

/obj/item/storage/box/skillchips/engineering/PopulateContents()
	new/obj/item/skillchip/job/engineer(src)
	new/obj/item/skillchip/job/engineer(src)
