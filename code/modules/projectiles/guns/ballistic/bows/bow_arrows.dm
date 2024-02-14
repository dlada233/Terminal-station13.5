///base arrow
/obj/item/ammo_casing/arrow
	name = "弓箭"
	desc = "锐利的箭，锐利的眼!"
	icon = 'icons/obj/weapons/bows/arrows.dmi'
	icon_state = "arrow"
	base_icon_state = "arrow"
	inhand_icon_state = "arrow"
	projectile_type = /obj/projectile/bullet/arrow
	flags_1 = NONE
	throwforce = 1
	firing_effect_type = null
	caliber = CALIBER_ARROW
	///Whether the bullet type spawns another casing of the same type or not.
	var/reusable = TRUE

/obj/item/ammo_casing/arrow/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/envenomable_casing)
	AddElement(/datum/element/caseless, reusable)

/obj/item/ammo_casing/arrow/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)]" //SKYRAT EDIT: Original: icon_state = "[base_icon_state]"

///base arrow projectile
/obj/projectile/bullet/arrow
	name = "弓箭"
	desc = "噢!快把它弄出来!"
	icon = 'icons/obj/weapons/bows/arrows.dmi'
	icon_state = "arrow_projectile"
	damage = 50
	speed = 1
	range = 25
	shrapnel_type = null
	embedding = list(
		embed_chance = 90,
		fall_chance = 2,
		jostle_chance = 2,
		ignore_throwspeed_threshold = TRUE,
		pain_stam_pct = 0.5,
		pain_mult = 3,
		jostle_pain_mult = 3,
		rip_time = 1 SECONDS
	)

/// holy arrows
/obj/item/ammo_casing/arrow/holy
	name = "神圣箭"
	desc = "神圣的疾行者寻找它的目标."
	icon_state = "holy_arrow"
	inhand_icon_state = "holy_arrow"
	base_icon_state = "holy_arrow"
	projectile_type = /obj/projectile/bullet/arrow/holy

/// holy arrow projectile
/obj/projectile/bullet/arrow/holy
	name = "神圣箭"
	desc = "你要战那便战吧！异端渣滓！"
	icon_state = "holy_arrow_projectile"
	damage = 20 //still a lot but this is roundstart gear so far less
	embedding = list(
		embed_chance = 50,
		fall_chance = 2,
		jostle_chance = 0,
		ignore_throwspeed_threshold = TRUE,
		pain_stam_pct = 0.5,
		pain_mult = 3,
		rip_time = 1 SECONDS
	)

/obj/projectile/bullet/arrow/holy/Initialize(mapload)
	. = ..()
	//50 damage to revenants
	AddElement(/datum/element/bane, target_type = /mob/living/basic/revenant, damage_multiplier = 0, added_damage = 30)

/// special pyre sect arrow
/// in the future, this needs a special sprite, but bows don't support non-hardcoded arrow sprites
/obj/item/ammo_casing/arrow/holy/blazing
	name = "飞火流星箭"
	desc = "神圣的疾行者寻找它的目标赐予灼热的火焰，当命中时摧毁自身并点燃目标，但如果你击中一个已经点燃的目标呢...?"// 答案是爆炸
	projectile_type = /obj/projectile/bullet/arrow/blazing
	reusable = FALSE

/obj/projectile/bullet/arrow/blazing
	name = "飞火箭"
	desc = "代表太阳审判你!"
	icon_state = "holy_arrow_projectile"
	damage = 20
	embedding = null

/obj/projectile/bullet/arrow/blazing/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/human_target = target
	if(!human_target.on_fire)
		to_chat(human_target, span_danger("[src]在火焰中爆炸，并且又点燃了你!"))
		human_target.adjust_fire_stacks(2)
		human_target.ignite_mob()
		return
	to_chat(human_target, span_danger("[src]与你身上的火焰反yin-"))
	explosion(src, light_impact_range = 1, flame_range = 2) //ow
