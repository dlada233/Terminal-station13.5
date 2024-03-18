/obj/item/reagent_containers/spray/waterflower/lube
	name = "向汨葵"
	desc = "一朵纯洁的向汨葵....‘日’字呢，‘日’变得有点<i>滑</i>."
	icon = 'icons/obj/service/hydroponics/harvest.dmi'
	icon_state = "sunflower"
	inhand_icon_state = "sunflower"
	amount_per_transfer_from_this = 3
	spray_range = 1
	stream_range = 1
	volume = 30
	list_reagents = list(/datum/reagent/lube = 30)

//COMBAT CLOWN SHOES
//Clown shoes with combat stats and noslip. Of course they still squeak.
/obj/item/clothing/shoes/clown_shoes/combat
	name = "战术小丑鞋"
	desc = "先进的小丑鞋，在保护穿着者的同时确保他们不会被自己的香蕉皮滑到，当然走路时它也不会忘了吱吱做响."
	clothing_traits = list(TRAIT_NO_SLIP_WATER)
	slowdown = SHOES_SLOWDOWN
	armor_type = /datum/armor/clown_shoes_combat
	strip_delay = 70
	resistance_flags = NONE

/datum/armor/clown_shoes_combat
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 50
	bio = 90
	fire = 70
	acid = 50

/obj/item/clothing/shoes/clown_shoes/combat/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)

/// Recharging rate in PPS (peels per second)
#define BANANA_SHOES_RECHARGE_RATE 17
#define BANANA_SHOES_MAX_CHARGE 3000

//The super annoying version
/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat
	name = "Mk-honk 战术鞋"
	desc = "对小丑战术的多年研究的技术结晶，这双鞋只会留下混乱的足迹；它带有自充电供能，当然也能手动充电."
	slowdown = SHOES_SLOWDOWN
	armor_type = /datum/armor/banana_shoes_combat
	strip_delay = 70
	resistance_flags = NONE
	always_noslip = TRUE

/datum/armor/banana_shoes_combat
	melee = 25
	bullet = 25
	laser = 25
	energy = 25
	bomb = 50
	bio = 50
	fire = 90
	acid = 50

/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/pockets/shoes)
	bananium.insert_amount_mat(BANANA_SHOES_MAX_CHARGE, /datum/material/bananium)

	START_PROCESSING(SSobj, src)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat/process(seconds_per_tick)
	var/bananium_amount = bananium.get_material_amount(/datum/material/bananium)
	if(bananium_amount < BANANA_SHOES_MAX_CHARGE)
		bananium.insert_amount_mat(min(BANANA_SHOES_RECHARGE_RATE * seconds_per_tick, BANANA_SHOES_MAX_CHARGE - bananium_amount), /datum/material/bananium)

/obj/item/clothing/shoes/clown_shoes/banana_shoes/combat/attack_self(mob/user)
	ui_action_click(user)

#undef BANANA_SHOES_RECHARGE_RATE
#undef BANANA_SHOES_MAX_CHARGE

//BANANIUM SWORD

/obj/item/melee/energy/sword/bananium
	name = "蕉光剑"
	icon_state = "e_sword"
	attack_verb_continuous = list("击打", "敲击", "戳击")
	attack_verb_simple = list("击打", "敲击", "戳击")
	force = 0
	throwforce = 0
	hitsound = null
	embedding = null
	light_color = COLOR_YELLOW
	sword_color_icon = "bananium"
	active_heat = 0
	/// Cooldown for making a trombone noise for failing to make a bananium desword
	COOLDOWN_DECLARE(next_trombone_allowed)

/obj/item/melee/energy/sword/bananium/make_transformable()
	AddComponent( \
		/datum/component/transforming, \
		throw_speed_on = 4, \
		attack_verb_continuous_on = list("滑倒"), \
		attack_verb_simple_on = list("滑倒"), \
		clumsy_check = FALSE, \
	)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))

/obj/item/melee/energy/sword/bananium/on_transform(obj/item/source, mob/user, active)
	. = ..()
	adjust_slipperiness()

/*
 * Adds or removes a slippery component, depending on whether the sword is active or not.
 */
/obj/item/melee/energy/sword/bananium/proc/adjust_slipperiness()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		AddComponent(/datum/component/slippery, 60, GALOSHES_DONT_HELP)
	else
		qdel(GetComponent(/datum/component/slippery))

/obj/item/melee/energy/sword/bananium/attack(mob/living/M, mob/living/user)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
		slipper.Slip(src, M)

/obj/item/melee/energy/sword/bananium/throw_impact(atom/hit_atom, throwingdatum)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
		slipper.Slip(src, hit_atom)

/obj/item/melee/energy/sword/bananium/attackby(obj/item/weapon, mob/living/user, params)
	if(COOLDOWN_FINISHED(src, next_trombone_allowed) && istype(weapon, /obj/item/melee/energy/sword/bananium))
		COOLDOWN_START(src, next_trombone_allowed, 5 SECONDS)
		to_chat(user, span_warning("你将两把剑并在一起. 遗憾的是它们并不合适!"))
		playsound(src, 'sound/misc/sadtrombone.ogg', 50)
		return TRUE
	return ..()

/obj/item/melee/energy/sword/bananium/suicide_act(mob/living/user)
	if(!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		attack_self(user)
	user.visible_message(span_suicide("[user]用[src][pick("在自己的腹部上比划", "在自己的腹部上比划")]! 看起来是要剖腹自尽，但刀只会从身上无害地滑下来!"))
	var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
	slipper.Slip(src, user)
	return SHAME

//BANANIUM SHIELD

/obj/item/shield/energy/bananium
	name = "香蕉能量盾"
	desc = "一面可以阻挡大多数近战攻击以及能量投射物的盾牌，还能丢出去让对手滑倒."
	icon_state = "bananaeshield"
	inhand_icon_state = "bananaeshield"
	throw_speed = 1
	force = 0
	throwforce = 0
	throw_range = 5

	active_force = 0
	active_throwforce = 0
	active_throw_speed = 1
	can_clumsy_use = TRUE

/obj/item/shield/energy/bananium/on_transform(obj/item/source, mob/user, active)
	. = ..()
	adjust_comedy()

/*
 * Adds or removes a slippery and boomerang component, depending on whether the shield is active or not.
 */
/obj/item/shield/energy/bananium/proc/adjust_comedy()
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		AddComponent(/datum/component/slippery, 60, GALOSHES_DONT_HELP)
		AddComponent(/datum/component/boomerang, throw_range+2, TRUE)
	else
		qdel(GetComponent(/datum/component/slippery))
		qdel(GetComponent(/datum/component/boomerang))

/obj/item/shield/energy/bananium/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
		if(iscarbon(hit_atom) && !caught)//if they are a carbon and they didn't catch it
			var/datum/component/slippery/slipper = GetComponent(/datum/component/slippery)
			slipper.Slip(src, hit_atom)
	else
		return ..()


//BOMBANANA

/obj/item/seeds/banana/bombanana
	name = "爆蕉种子"
	desc = "成熟爆蕉树结出的种子，果实为小丑带来喜悦."
	plantname = "Bombanana Tree"
	product = /obj/item/food/grown/banana/bombanana

/obj/item/food/grown/banana/bombanana
	trash_type = /obj/item/grown/bananapeel/bombanana
	seed = /obj/item/seeds/banana/bombanana
	tastes = list("explosives" = 10)
	food_reagents = list(/datum/reagent/consumable/nutriment/vitamin = 1)

/obj/item/grown/bananapeel/bombanana
	desc = "一块香蕉皮，但是它为什么在哔哔响呢?"
	seed = /obj/item/seeds/banana/bombanana
	var/det_time = 50
	var/obj/item/grenade/syndieminibomb/bomb

/obj/item/grown/bananapeel/bombanana/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/slippery, det_time)
	bomb = new /obj/item/grenade/syndieminibomb(src)
	bomb.det_time = det_time
	if(iscarbon(loc))
		to_chat(loc, span_danger("[src]开始哔哔响."))
	bomb.arm_grenade(loc, null, FALSE)

/obj/item/grown/bananapeel/bombanana/Destroy()
	. = ..()
	QDEL_NULL(bomb)

/obj/item/grown/bananapeel/bombanana/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]故意被[src.name]滑到! 看起来是想要自杀."))
	playsound(loc, 'sound/misc/slip.ogg', 50, TRUE, -1)
	bomb.arm_grenade(user, 0, FALSE)
	return BRUTELOSS

//TEARSTACHE GRENADE

/obj/item/grenade/chem_grenade/teargas/moustache
	name = "催须弹"
	desc = "一枚浓密的催泪弹."
	icon_state = "moustacheg"
	clumsy_check = GRENADE_NONCLUMSY_FUMBLE

/obj/item/grenade/chem_grenade/teargas/moustache/detonate(mob/living/lanced_by)
	var/myloc = get_turf(src)
	. = ..()
	if(!.)
		return

	for(var/mob/living/carbon/M in view(6, myloc))
		if(!istype(M.wear_mask, /obj/item/clothing/mask/gas/clown_hat) && !istype(M.wear_mask, /obj/item/clothing/mask/gas/mime) )
			if(!M.wear_mask || M.dropItemToGround(M.wear_mask))
				var/obj/item/clothing/mask/fakemoustache/sticky/the_stash = new /obj/item/clothing/mask/fakemoustache/sticky()
				M.equip_to_slot_or_del(the_stash, ITEM_SLOT_MASK, TRUE, TRUE, TRUE, TRUE)

/obj/item/clothing/mask/fakemoustache/sticky
	var/unstick_time = 600

/obj/item/clothing/mask/fakemoustache/sticky/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_MOUSTACHE_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(unstick)), unstick_time)

/obj/item/clothing/mask/fakemoustache/sticky/proc/unstick()
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_MOUSTACHE_TRAIT)
