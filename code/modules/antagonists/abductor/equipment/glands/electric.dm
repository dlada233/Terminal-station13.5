/obj/item/organ/internal/heart/gland/electric
	abductor_hint = "电子积聚器/放电器，被绑架者对电击完全免疫，此外他们还会随机放出电光."
	cooldown_low = 800
	cooldown_high = 1200
	icon_state = "species"
	uses = -1
	mind_control_uses = 2
	mind_control_duration = 900

/obj/item/organ/internal/heart/gland/electric/on_mob_insert(mob/living/carbon/gland_owner)
	. = ..()
	ADD_TRAIT(gland_owner, TRAIT_SHOCKIMMUNE, ABDUCTOR_GLAND_TRAIT)

/obj/item/organ/internal/heart/gland/electric/on_mob_remove(mob/living/carbon/gland_owner)
	. = ..()
	REMOVE_TRAIT(gland_owner, TRAIT_SHOCKIMMUNE, ABDUCTOR_GLAND_TRAIT)

/obj/item/organ/internal/heart/gland/electric/activate()
	owner.visible_message(span_danger("[owner]的皮肤开始释放出电弧!"),\
	span_warning("你感到体内开始积聚电能!"))
	playsound(get_turf(owner), SFX_SPARKS, 100, TRUE, -1, SHORT_RANGE_SOUND_EXTRARANGE)
	addtimer(CALLBACK(src, PROC_REF(zap)), rand(3 SECONDS, 10 SECONDS))

/obj/item/organ/internal/heart/gland/electric/proc/zap()
	tesla_zap(source = owner, zap_range = 4, power = 8e3, cutoff = 1e3, zap_flags = ZAP_MOB_DAMAGE | ZAP_OBJ_DAMAGE | ZAP_MOB_STUN)
	playsound(get_turf(owner), 'sound/magic/lightningshock.ogg', 50, TRUE)
