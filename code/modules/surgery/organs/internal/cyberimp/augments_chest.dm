/obj/item/organ/internal/cyberimp/chest
	name = "胸腔机械植入物"
	desc = "用于胸腔内器官的植入物."
	icon_state = "chest_implant"
	implant_overlay = "chest_implant_overlay"
	zone = BODY_ZONE_CHEST

/obj/item/organ/internal/cyberimp/chest/nutriment
	name = "营养泵植入物"
	desc = "当你极度饥饿时，此植入物会合成并将少量营养物泵入你的血液."
	icon_state = "chest_implant"
	implant_color = "#00AA00"
	var/hunger_threshold = NUTRITION_LEVEL_STARVING
	var/synthesizing = 0
	var/poison_amount = 5
	slot = ORGAN_SLOT_STOMACH_AID

/obj/item/organ/internal/cyberimp/chest/nutriment/on_life(seconds_per_tick, times_fired)
	if(synthesizing)
		return

	if(owner.nutrition <= hunger_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("你感到不那么饿了..."))
		owner.adjust_nutrition(25 * seconds_per_tick)
		addtimer(CALLBACK(src, PROC_REF(synth_cool)), 5 SECONDS)

/obj/item/organ/internal/cyberimp/chest/nutriment/proc/synth_cool()
	synthesizing = FALSE

/obj/item/organ/internal/cyberimp/chest/nutriment/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	owner.reagents.add_reagent(/datum/reagent/toxin/bad_food, poison_amount / severity)
	to_chat(owner, span_warning("你感到内脏像火烧一样."))


/obj/item/organ/internal/cyberimp/chest/nutriment/plus
	name = "高级营养泵植入物"
	desc = "当你感到饥饿时，此植入物会合成并将少量营养物泵入你的血液."
	icon_state = "chest_implant"
	implant_color = "#006607"
	hunger_threshold = NUTRITION_LEVEL_HUNGRY
	poison_amount = 10

/obj/item/organ/internal/cyberimp/chest/reviver
	name = "复活植入物"
	desc = "如果你失去意识，此植入物会尝试复活并治疗你，这是给胆小者准备的!"
	icon_state = "chest_implant"
	implant_color = "#AD0000"
	slot = ORGAN_SLOT_HEART_AID
	var/revive_cost = 0
	var/reviving = FALSE
	COOLDOWN_DECLARE(reviver_cooldown)
	COOLDOWN_DECLARE(defib_cooldown)

/obj/item/organ/internal/cyberimp/chest/reviver/on_death(seconds_per_tick, times_fired)
	if(isnull(owner)) // owner can be null, on_death() gets called by /obj/item/organ/internal/process() for decay
		return
	try_heal() // Allows implant to work even on dead people

/obj/item/organ/internal/cyberimp/chest/reviver/on_life(seconds_per_tick, times_fired)
	try_heal()

/obj/item/organ/internal/cyberimp/chest/reviver/proc/try_heal()
	if(reviving)
		if(owner.stat == CONSCIOUS)
			COOLDOWN_START(src, reviver_cooldown, revive_cost)
			reviving = FALSE
			to_chat(owner, span_notice("你的复活植入物已关闭并开始充电. 它将在[DisplayTimeText(revive_cost)]后重新就绪."))
		else
			addtimer(CALLBACK(src, PROC_REF(heal)), 3 SECONDS)
		return

	if(!COOLDOWN_FINISHED(src, reviver_cooldown) || HAS_TRAIT(owner, TRAIT_SUICIDED))
		return

	if(owner.stat != CONSCIOUS)
		revive_cost = 0
		reviving = TRUE
		to_chat(owner, span_notice("当你的恢复器植入物开始修补你的伤口时，你感到一阵微弱的嗡嗡声..."))
		COOLDOWN_START(src, defib_cooldown, 8 SECONDS) // 5 seconds after heal proc delay


/obj/item/organ/internal/cyberimp/chest/reviver/proc/heal()
	if(COOLDOWN_FINISHED(src, defib_cooldown))
		revive_dead()

	/// boolean that stands for if PHYSICAL damage being patched
	var/body_damage_patched = FALSE
	var/need_mob_update = FALSE
	if(owner.getOxyLoss())
		need_mob_update += owner.adjustOxyLoss(-5, updating_health = FALSE)
		revive_cost += 5
	if(owner.getBruteLoss())
		need_mob_update += owner.adjustBruteLoss(-2, updating_health = FALSE)
		revive_cost += 40
		body_damage_patched = TRUE
	if(owner.getFireLoss())
		need_mob_update += owner.adjustFireLoss(-2, updating_health = FALSE)
		revive_cost += 40
		body_damage_patched = TRUE
	if(owner.getToxLoss())
		need_mob_update += owner.adjustToxLoss(-1, updating_health = FALSE)
		revive_cost += 40
	if(need_mob_update)
		owner.updatehealth()

	if(body_damage_patched && prob(35)) // healing is called every few seconds, not every tick
		owner.visible_message(span_warning("[owner]的身体有点抽搐."), span_notice("你觉得有什么东西在修补你受伤的身体."))


/obj/item/organ/internal/cyberimp/chest/reviver/proc/revive_dead()
	if(!COOLDOWN_FINISHED(src, defib_cooldown) || owner.stat != DEAD || owner.can_defib() != DEFIB_POSSIBLE)
		return
	owner.notify_revival("你被[src]救活!")
	revive_cost += 10 MINUTES // Additional 10 minutes cooldown after revival.
	owner.grab_ghost()

	defib_cooldown += 16 SECONDS // delay so it doesn't spam

	owner.visible_message(span_warning("[owner]的身体有点抽搐."))
	playsound(owner, SFX_BODYFALL, 50, TRUE)
	playsound(owner, 'sound/machines/defib_zap.ogg', 75, TRUE, -1)
	owner.set_heartattack(FALSE)
	owner.revive()
	owner.emote("gasp")
	owner.set_jitter_if_lower(200 SECONDS)
	SEND_SIGNAL(owner, COMSIG_LIVING_MINOR_SHOCK)
	log_game("[owner] been revived by [src]")


/obj/item/organ/internal/cyberimp/chest/reviver/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return

	if(reviving)
		revive_cost += 200
	else
		reviver_cooldown += 20 SECONDS

	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.stat != DEAD && prob(50 / severity) && human_owner.can_heartattack())
			human_owner.set_heartattack(TRUE)
			to_chat(human_owner, span_userdanger("你感到胸口一阵剧痛!"))
			addtimer(CALLBACK(src, PROC_REF(undo_heart_attack)), 600 / severity)

/obj/item/organ/internal/cyberimp/chest/reviver/proc/undo_heart_attack()
	var/mob/living/carbon/human/human_owner = owner
	if(!istype(human_owner))
		return
	human_owner.set_heartattack(FALSE)
	if(human_owner.stat == CONSCIOUS)
		to_chat(human_owner, span_notice("你感到你的心再次跳动!"))


/obj/item/organ/internal/cyberimp/chest/thrusters
	name = "可植入推进器套装"
	desc = "一套可植入的推进器端口，它们使用环境或主体内部的气体在零重力区域进行推进，与普通的喷气背包不同，此装置没有惯性稳定系统."
	slot = ORGAN_SLOT_THRUSTERS
	icon_state = "imp_jetpack"
	base_icon_state = "imp_jetpack"
	implant_overlay = null
	implant_color = null
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	w_class = WEIGHT_CLASS_NORMAL
	var/on = FALSE

/obj/item/organ/internal/cyberimp/chest/thrusters/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/jetpack, \
		FALSE, \
		COMSIG_THRUSTER_ACTIVATED, \
		COMSIG_THRUSTER_DEACTIVATED, \
		THRUSTER_ACTIVATION_FAILED, \
		CALLBACK(src, PROC_REF(allow_thrust), 0.01), \
		/datum/effect_system/trail_follow/ion \
	)

/obj/item/organ/internal/cyberimp/chest/thrusters/Remove(mob/living/carbon/thruster_owner, special, movement_flags)
	if(on)
		deactivate(silent = TRUE)
	..()

/obj/item/organ/internal/cyberimp/chest/thrusters/ui_action_click()
	toggle()

/obj/item/organ/internal/cyberimp/chest/thrusters/proc/toggle(silent = FALSE)
	if(on)
		deactivate()
	else
		activate()

/obj/item/organ/internal/cyberimp/chest/thrusters/proc/activate(silent = FALSE)
	if(on)
		return
	if(organ_flags & ORGAN_FAILING)
		if(!silent)
			to_chat(owner, span_warning("你的推进器套装好像坏了!"))
		return
	if(SEND_SIGNAL(src, COMSIG_THRUSTER_ACTIVATED, owner) & THRUSTER_ACTIVATION_FAILED)
		return

	on = TRUE
	owner.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
	if(!silent)
		to_chat(owner, span_notice("你开启了推进器套装."))
	update_appearance()

/obj/item/organ/internal/cyberimp/chest/thrusters/proc/deactivate(silent = FALSE)
	if(!on)
		return
	SEND_SIGNAL(src, COMSIG_THRUSTER_DEACTIVATED, owner)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/cybernetic)
	if(!silent)
		to_chat(owner, span_notice("你关闭了推进器套装."))
	on = FALSE
	update_appearance()

/obj/item/organ/internal/cyberimp/chest/thrusters/update_icon_state()
	icon_state = "[base_icon_state][on ? "-on" : null]"
	return ..()

/obj/item/organ/internal/cyberimp/chest/thrusters/proc/allow_thrust(num, use_fuel = TRUE)
	if(!owner)
		return FALSE

	var/turf/owner_turf = get_turf(owner)
	if(!owner_turf) // No more runtimes from being stuck in nullspace.
		return FALSE

	// Priority 1: use air from environment.
	var/datum/gas_mixture/environment = owner_turf.return_air()
	if(environment && environment.return_pressure() > 30)
		return TRUE

	// Priority 2: use plasma from internal plasma storage.
	// (just in case someone would ever use this implant system to make cyber-alien ops with jetpacks and taser arms)
	if(owner.getPlasma() >= num * 100)
		if(use_fuel)
			owner.adjustPlasma(-num * 100)
		return TRUE

	// Priority 3: use internals tank.
	var/datum/gas_mixture/internal_mix = owner.internal?.return_air()
	if(internal_mix && internal_mix.total_moles() > num)
		if(!use_fuel)
			return TRUE
		var/datum/gas_mixture/removed = internal_mix.remove(num)
		if(removed.total_moles() > 0.005)
			owner_turf.assume_air(removed)
			return TRUE
		else
			owner_turf.assume_air(removed)

	deactivate(silent = TRUE)
	return FALSE
