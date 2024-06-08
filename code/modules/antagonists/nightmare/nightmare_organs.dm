/// 梦魇的心脏需要多少生命刻来复活梦魇.
#define HEART_RESPAWN_THRESHHOLD (80 SECONDS)
/// 一个特殊标志值，用于使梦魇心脏不授予光蚀器. 似乎未使用.
#define HEART_SPECIAL_SHADOWIFY 2


/obj/item/organ/internal/brain/shadow/nightmare
	name = "肿瘤组织"
	desc = "从梦魇的头骨中挖出的肉质生长物. "
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "brain-x-d"
	applied_status = /datum/status_effect/shadow_regeneration/nightmare
	/// 我们的关联影遁法术，适用于所有梦魇
	var/datum/action/cooldown/spell/jaunt/shadow_walk/our_jaunt
	/// 我们的关联恐吓法术，适用于反派梦魇
	var/datum/action/cooldown/spell/pointed/terrorize/terrorize_spell

/obj/item/organ/internal/brain/shadow/nightmare/on_mob_insert(mob/living/carbon/brain_owner)
	. = ..()

	if(brain_owner.dna.species.id != SPECIES_NIGHTMARE)
		brain_owner.set_species(/datum/species/shadow/nightmare)
		visible_message(span_warning("[brain_owner]因[src]植根于身体而抽搐！"))

	our_jaunt = new(brain_owner)
	our_jaunt.Grant(brain_owner)

	if(brain_owner.mind?.has_antag_datum(/datum/antagonist/nightmare)) // 只有真正的梦魇才配使用这个能力
		terrorize_spell = new(src)
		terrorize_spell.Grant(brain_owner)

/obj/item/organ/internal/brain/shadow/nightmare/on_mob_remove(mob/living/carbon/brain_owner)
	. = ..()
	QDEL_NULL(our_jaunt)
	QDEL_NULL(terrorize_spell)

/atom/movable/screen/alert/status_effect/shadow_regeneration/nightmare
	name = "无光领域"
	desc = "沐浴在舒缓的黑暗中，你会慢慢再生，即使是在死亡之后也一样. \
		还会提升的反应能力，让你能够躲避投射物. "

/datum/status_effect/shadow_regeneration/nightmare
	alert_type = /atom/movable/screen/alert/status_effect/shadow_regeneration/nightmare

/datum/status_effect/shadow_regeneration/nightmare/on_apply()
	. = ..()
	if (!.)
		return FALSE
	RegisterSignal(owner, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(dodge_bullets))
	return TRUE

/datum/status_effect/shadow_regeneration/nightmare/on_remove()
	UnregisterSignal(owner, COMSIG_ATOM_PRE_BULLET_ACT)
	return ..()

/datum/status_effect/shadow_regeneration/nightmare/proc/dodge_bullets(mob/living/carbon/human/source, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER
	source.visible_message(
		span_danger("[source]在阴影中起舞，躲避了[hitting_projectile]！"),
		span_danger("你在黑暗的掩护下躲避了[hitting_projectile]！"),
	)
	playsound(source, SFX_BULLET_MISS, 75, TRUE)
	return COMPONENT_BULLET_PIERCED

/obj/item/organ/internal/heart/nightmare
	name = "黑暗之心"
	desc = "一种在光照下扭曲和蠕动的外来器官. "
	icon_state = "demon_heart-on"
	base_icon_state = "demon_heart"
	visual = TRUE
	color = "#1C1C1C"
	decay_factor = 0
	/// 主人在黑暗中死亡的生命刻数量. 用于梦魇复活.
	var/respawn_progress = 0
	/// 授予此心脏宿主的臂刃.
	var/obj/item/light_eater/blade

/obj/item/organ/internal/heart/nightmare/attack(mob/M, mob/living/carbon/user, obj/target)
	if(M != user)
		return ..()
	user.visible_message(
		span_warning("[user]将[src]举到嘴边，大口撕咬！"),
		span_danger("[src]在你的手中不自然地冷. 你将[src]举到嘴边并吞噬它！")
	)
	playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)

	user.visible_message(
		span_warning("血液从[user]的手臂中流出，重塑为武器！"),
		span_userdanger("冰冷的血液在你的静脉中流动，你的手臂重塑了自己！")
	)
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	Insert(user)

/obj/item/organ/internal/heart/nightmare/on_mob_insert(mob/living/carbon/heart_owner, special)
	. = ..()
	if(special != HEART_SPECIAL_SHADOWIFY)
		blade = new/obj/item/light_eater
		heart_owner.put_in_hands(blade)

/obj/item/organ/internal/heart/nightmare/on_mob_remove(mob/living/carbon/heart_owner, special)
	. = ..()
	respawn_progress = 0
	if(blade && special != HEART_SPECIAL_SHADOWIFY)
		heart_owner.visible_message(span_warning("[blade]崩解了！"))
		QDEL_NULL(blade)

/obj/item/organ/internal/heart/nightmare/Stop()
	return FALSE

/obj/item/organ/internal/heart/nightmare/on_death(seconds_per_tick, times_fired)
	if(!owner)
		return
	var/turf/T = get_turf(owner)
	if(istype(T))
		var/light_amount = T.get_lumcount()
		if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
			respawn_progress += seconds_per_tick SECONDS
			playsound(owner, 'sound/effects/singlebeat.ogg', 40, TRUE)
	if(respawn_progress < HEART_RESPAWN_THRESHHOLD)
		return

	owner.revive(HEAL_ALL & ~HEAL_REFRESH_ORGANS)
	if(!(owner.dna.species.id == SPECIES_SHADOW || owner.dna.species.id == SPECIES_NIGHTMARE))
		var/mob/living/carbon/old_owner = owner
		Remove(owner, HEART_SPECIAL_SHADOWIFY)
		old_owner.set_species(/datum/species/shadow)
		Insert(old_owner, HEART_SPECIAL_SHADOWIFY)
		to_chat(owner, span_userdanger("你感觉到阴影侵入你的皮肤，跳跃到你的胸口中央！你活了过来！"))
		SEND_SOUND(owner, sound('sound/effects/ghost.ogg'))
	owner.visible_message(span_warning("[owner]摇摇晃晃地站了起来！"))
	playsound(owner, 'sound/hallucinations/far_noise.ogg', 50, TRUE)
	respawn_progress = 0

/obj/item/organ/internal/heart/nightmare/get_availability(datum/species/owner_species, mob/living/owner_mob)
	if(isnightmare(owner_mob))
		return TRUE
	return ..()

#undef HEART_SPECIAL_SHADOWIFY
#undef HEART_RESPAWN_THRESHHOLD
