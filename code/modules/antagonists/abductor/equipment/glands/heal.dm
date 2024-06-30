#define REJECTION_VOMIT_FLAGS (MOB_VOMIT_BLOOD | MOB_VOMIT_STUN | MOB_VOMIT_KNOCKDOWN | MOB_VOMIT_FORCE)

/obj/item/organ/internal/heart/gland/heal
	abductor_hint = "有机复制器，强制性地将受损的和电子器官从被绑架者身体中排出，并对其空位进行再生；此外，如果被绑架有中等毒素损伤或血液中含有毒素，它会通过呕吐的方式强制性地移除试剂，并在血含量过低时再生血液到健康阈值；此外被绑架者也会排斥诸如心灵护盾之类的植入物."
	cooldown_low = 200
	cooldown_high = 400
	uses = -1
	human_only = TRUE
	icon_state = "health"
	mind_control_uses = 3
	mind_control_duration = 3000

/obj/item/organ/internal/heart/gland/heal/activate()
	if(!(owner.mob_biotypes & MOB_ORGANIC))
		return

	for(var/implant in owner.implants)
		reject_implant(implant)
		return

	for(var/organ in owner.organs)
		if(istype(organ, /obj/item/organ/internal/cyberimp))
			reject_cyberimp(organ)
			return

	var/obj/item/organ/internal/appendix/appendix = owner.get_organ_slot(ORGAN_SLOT_APPENDIX)
	if((!appendix && !HAS_TRAIT(owner, TRAIT_NOHUNGER)) || (appendix && ((appendix.organ_flags & ORGAN_FAILING) || IS_ROBOTIC_ORGAN(appendix))))
		replace_appendix(appendix)
		return

	var/obj/item/organ/internal/liver/liver = owner.get_organ_slot(ORGAN_SLOT_LIVER)
	if((!liver && !HAS_TRAIT(owner, TRAIT_LIVERLESS_METABOLISM)) || (liver && ((liver.damage > liver.high_threshold) || IS_ROBOTIC_ORGAN(liver))))
		replace_liver(liver)
		return

	var/obj/item/organ/internal/lungs/lungs = owner.get_organ_slot(ORGAN_SLOT_LUNGS)
	if((!lungs && !HAS_TRAIT(owner, TRAIT_NOBREATH)) || (lungs && ((lungs.damage > lungs.high_threshold) || IS_ROBOTIC_ORGAN(lungs))))
		replace_lungs(lungs)
		return

	var/obj/item/organ/internal/stomach/stomach = owner.get_organ_slot(ORGAN_SLOT_STOMACH)
	if((!stomach && !HAS_TRAIT(owner, TRAIT_NOHUNGER)) || (stomach && ((stomach.damage > stomach.high_threshold) || IS_ROBOTIC_ORGAN(stomach))))
		replace_stomach(stomach)
		return

	var/obj/item/organ/internal/eyes/eyes = owner.get_organ_slot(ORGAN_SLOT_EYES)
	if(!eyes || (eyes && ((eyes.damage > eyes.low_threshold) || IS_ROBOTIC_ORGAN(eyes))))
		replace_eyes(eyes)
		return

	var/obj/item/bodypart/limb
	var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	for(var/zone in limb_list)
		limb = owner.get_bodypart(zone)
		if(!limb)
			replace_limb(zone)
			return
		if((limb.get_damage() >= (limb.max_damage / 2)) || (!IS_ORGANIC_LIMB(limb)))
			replace_limb(zone, limb)
			return

	if(owner.getToxLoss() > 40)
		replace_blood()
		return
	var/tox_amount = 0
	for(var/datum/reagent/toxin/T in owner.reagents.reagent_list)
		tox_amount += owner.reagents.get_reagent_amount(T.type)
	if(tox_amount > 10)
		replace_blood()
		return
	if(owner.blood_volume < BLOOD_VOLUME_OKAY)
		owner.blood_volume = BLOOD_VOLUME_NORMAL
		to_chat(owner, span_warning("你感到血液在体内脉动."))
		return

	var/obj/item/bodypart/chest/chest = owner.get_bodypart(BODY_ZONE_CHEST)
	if((chest.get_damage() >= (chest.max_damage / 4)) || (!IS_ORGANIC_LIMB(chest)))
		replace_chest(chest)
		return

/obj/item/organ/internal/heart/gland/heal/proc/reject_implant(obj/item/implant/implant)
	owner.visible_message(span_warning("[owner]吐出了一个损坏的微型植入物!"), span_userdanger("你突然吐出了一个损坏的微型植入物!"))
	owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
	implant.removed(owner)
	qdel(implant)

/obj/item/organ/internal/heart/gland/heal/proc/reject_cyberimp(obj/item/organ/internal/cyberimp/implant)
	owner.visible_message(span_warning("[owner]吐出了自己的[implant.name]!"), span_userdanger("你突然吐出了自己的[implant.name]!"))
	owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
	implant.Remove(owner)
	implant.forceMove(owner.drop_location())

/obj/item/organ/internal/heart/gland/heal/proc/replace_appendix(obj/item/organ/internal/appendix/appendix)
	if(appendix)
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		appendix.Remove(owner)
		appendix.forceMove(owner.drop_location())
		owner.visible_message(span_warning("[owner]吐出了自己的[appendix.name]!"), span_userdanger("你突然吐出了自己的[appendix.name]!"))
	else
		to_chat(owner, span_warning("你感觉到脾胃处有一种奇怪的隆隆声..."))

	var/appendix_type = /obj/item/organ/internal/appendix
	if(owner?.dna?.species?.mutantappendix)
		appendix_type = owner.dna.species.mutantappendix
	var/obj/item/organ/internal/appendix/new_appendix = new appendix_type()
	new_appendix.Insert(owner)

/obj/item/organ/internal/heart/gland/heal/proc/replace_liver(obj/item/organ/internal/liver/liver)
	if(liver)
		owner.visible_message(span_warning("[owner]吐出了自己的[liver.name]!"), span_userdanger("你突然吐出了自己的[liver.name]!"))
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		liver.Remove(owner)
		liver.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning("你感觉到脾胃处有一种奇怪的隆隆声..."))

	var/liver_type = /obj/item/organ/internal/liver
	if(owner?.dna?.species?.mutantliver)
		liver_type = owner.dna.species.mutantliver
	var/obj/item/organ/internal/liver/new_liver = new liver_type()
	new_liver.Insert(owner)

/obj/item/organ/internal/heart/gland/heal/proc/replace_lungs(obj/item/organ/internal/lungs/lungs)
	if(lungs)
		owner.visible_message(span_warning("[owner]吐出了自己的[lungs.name]!"), span_userdanger("你突然吐出了自己的[lungs.name]!"))
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		lungs.Remove(owner)
		lungs.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning("你感觉到胸膛里有一种奇怪的隆隆声..."))

	var/lung_type = /obj/item/organ/internal/lungs
	if(owner.dna.species && owner.dna.species.mutantlungs)
		lung_type = owner.dna.species.mutantlungs
	var/obj/item/organ/internal/lungs/new_lungs = new lung_type()
	new_lungs.Insert(owner)

/obj/item/organ/internal/heart/gland/heal/proc/replace_stomach(obj/item/organ/internal/stomach/stomach)
	if(stomach)
		owner.visible_message(span_warning("[owner]吐出了自己的[stomach.name]!"), span_userdanger("你突然吐出了自己的[stomach.name]!"))
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		stomach.Remove(owner)
		stomach.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning("你感觉到脾胃处有一种奇怪的隆隆声..."))

	var/stomach_type = /obj/item/organ/internal/stomach
	if(owner?.dna?.species?.mutantstomach)
		stomach_type = owner.dna.species.mutantstomach
	var/obj/item/organ/internal/stomach/new_stomach = new stomach_type()
	new_stomach.Insert(owner)

/obj/item/organ/internal/heart/gland/heal/proc/replace_eyes(obj/item/organ/internal/eyes/eyes)
	if(eyes)
		owner.visible_message(span_warning("[owner]的[eyes.name]从眼眶里掉出!"), span_userdanger("你的[eyes.name]从眼眶里掉出!"))
		playsound(owner, 'sound/effects/splat.ogg', 50, TRUE)
		eyes.Remove(owner)
		eyes.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning("你感到眼眶后面有一种奇怪的隆隆声..."))

	addtimer(CALLBACK(src, PROC_REF(finish_replace_eyes)), rand(10 SECONDS, 20 SECONDS))

/obj/item/organ/internal/heart/gland/heal/proc/finish_replace_eyes()
	var/eye_type = /obj/item/organ/internal/eyes
	if(owner.dna.species && owner.dna.species.mutanteyes)
		eye_type = owner.dna.species.mutanteyes
	var/obj/item/organ/internal/eyes/new_eyes = new eye_type()
	new_eyes.Insert(owner)
	owner.visible_message(span_warning("一双新的眼睛突然从[owner]的眼眶里长了出来!"), span_userdanger("一双新的眼睛从你的眼眶里长了出来！"))

/obj/item/organ/internal/heart/gland/heal/proc/replace_limb(body_zone, obj/item/bodypart/limb)
	if(limb)
		owner.visible_message(span_warning("[owner]的[limb.plaintext_zone]突然脱落!"), span_userdanger("你的[limb.plaintext_zone]突然脱落!"))
		playsound(owner, SFX_DESECRATION, 50, TRUE, -1)
		limb.drop_limb()
	else
		to_chat(owner, span_warning("你感到[parse_zone(body_zone)]有一种奇怪的刺痛感...即使你缺失它也依然如此."))

	addtimer(CALLBACK(src, PROC_REF(finish_replace_limb), body_zone), rand(150, 300))

/obj/item/organ/internal/heart/gland/heal/proc/finish_replace_limb(body_zone)
	owner.visible_message(span_warning("伴随着一声巨响，[owner]的[parse_zone(body_zone)]迅速从他们的身体重新生长出来!"),
	span_userdanger("伴随着一声巨响，你的[parse_zone(body_zone)]迅速从你的身体重新生长出来!"),
	span_warning("你听到一声巨响."))
	playsound(owner, 'sound/magic/demon_consume.ogg', 50, TRUE)
	owner.regenerate_limb(body_zone)

/obj/item/organ/internal/heart/gland/heal/proc/replace_blood()
	owner.visible_message(span_warning("[owner]开始口吐大量鲜血!"), span_userdanger("你突然开始口吐大量鲜血!"))
	keep_replacing_blood()

/obj/item/organ/internal/heart/gland/heal/proc/keep_replacing_blood()
	var/keep_going = FALSE
	owner.vomit(vomit_flags = (MOB_VOMIT_BLOOD | MOB_VOMIT_FORCE), lost_nutrition = 0, distance = 3)
	owner.Stun(15)
	owner.adjustToxLoss(-15, forced = TRUE)

	owner.blood_volume = min(BLOOD_VOLUME_NORMAL, owner.blood_volume + 20)
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		keep_going = TRUE

	if(owner.getToxLoss())
		keep_going = TRUE
	for(var/datum/reagent/toxin/R in owner.reagents.reagent_list)
		owner.reagents.remove_reagent(R.type, 4)
		if(owner.reagents.has_reagent(R.type))
			keep_going = TRUE
	if(keep_going)
		addtimer(CALLBACK(src, PROC_REF(keep_replacing_blood)), 3 SECONDS)

/obj/item/organ/internal/heart/gland/heal/proc/replace_chest(obj/item/bodypart/chest/chest)
	if(!IS_ORGANIC_LIMB(chest))
		owner.visible_message(span_warning("[owner]的[chest.name]迅速排出其机械组件，代之以有机组织!"), span_userdanger("你的[chest.name]迅速排出其机械组件，代之以有机组织!"))
		playsound(owner, 'sound/magic/clockwork/anima_fragment_attack.ogg', 50, TRUE)
		var/list/dirs = GLOB.alldirs.Copy()
		for(var/i in 1 to 3)
			var/obj/effect/decal/cleanable/robot_debris/debris = new(get_turf(owner))
			debris.streak(dirs)
	else
		owner.visible_message(span_warning("[owner]的[chest.name]脱去了受损的肉体，迅速代之以新!"), span_warning("你的[chest.name]脱去了受损的肉体，迅速代之以新!"))
		playsound(owner, 'sound/effects/splat.ogg', 50, TRUE)
		var/list/dirs = GLOB.alldirs.Copy()
		for(var/i in 1 to 3)
			var/obj/effect/decal/cleanable/blood/gibs/gibs = new(get_turf(owner))
			gibs.streak(dirs)

	var/obj/item/bodypart/chest/new_chest = new(null)
	new_chest.replace_limb(owner, TRUE)
	qdel(chest)

#undef REJECTION_VOMIT_FLAGS
