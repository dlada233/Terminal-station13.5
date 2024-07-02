/obj/item/dnainjector
	name = "\improper DNA 注射器"
	desc = "一种廉价的一次性自动注射器，可为使用者注射DNA."
	icon = 'icons/obj/medical/syringe.dmi'
	icon_state = "dnainjector"
	inhand_icon_state = "dnainjector"
	worn_icon_state = "pen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY

	var/damage_coeff = 1
	var/list/fields
	var/list/add_mutations = list()
	var/list/remove_mutations = list()

	var/used = FALSE

/obj/item/dnainjector/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	if(used)
		update_appearance()

/obj/item/dnainjector/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, used))
		update_appearance()

/obj/item/dnainjector/update_icon_state()
	. = ..()
	icon_state = inhand_icon_state = "[initial(icon_state)][used ? "0" : null]"

/obj/item/dnainjector/update_desc(updates)
	. = ..()
	desc = "[initial(desc)][used ? "这个已经被用过了." : null]"

/obj/item/dnainjector/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/item/dnainjector/proc/inject(mob/living/carbon/target, mob/user)
	if(!target.can_mutate())
		return FALSE
	for(var/removed_mutation in remove_mutations)
		target.dna.remove_mutation(removed_mutation)
	for(var/added_mutation in add_mutations)
		if(added_mutation == /datum/mutation/human/race)
			message_admins("[ADMIN_LOOKUPFLW(user)] injected [key_name_admin(target)] with the [name] [span_danger("(MONKEY)")]")
		if(target.dna.mutation_in_sequence(added_mutation))
			target.dna.activate_mutation(added_mutation)
		else
			target.dna.add_mutation(added_mutation, MUT_EXTRA)
	if(fields)
		if(fields["name"] && fields["UE"] && fields["blood_type"])
			target.real_name = fields["name"]
			target.dna.unique_enzymes = fields["UE"]
			target.name = target.real_name
			target.dna.blood_type = fields["blood_type"]
		if(fields["UI"]) //UI+UE
			target.dna.unique_identity = merge_text(target.dna.unique_identity, fields["UI"])
		if(fields["UF"])
			target.dna.unique_features = merge_text(target.dna.unique_features, fields["UF"])
		if(fields["UI"] || fields["UF"])
			target.updateappearance(mutcolor_update = TRUE, mutations_overlay_update = TRUE)
	return TRUE

/obj/item/dnainjector/attack(mob/target, mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return
	if(used)
		to_chat(user, span_warning("This injector is used up!"))
		return
	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target
		if (!humantarget.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
			return
	log_combat(user, target, "attempted to inject", src)

	if(target != user)
		target.visible_message(span_danger("[user] is trying to inject [target] with [src]!"), \
			span_userdanger("[user] is trying to inject you with [src]!"))
		if(!do_after(user, 3 SECONDS, target) || used)
			return
		target.visible_message(span_danger("[user] injects [target] with the syringe with [src]!"), \
						span_userdanger("[user] injects you with the syringe with [src]!"))

	else
		to_chat(user, span_notice("You inject yourself with [src]."))

	log_combat(user, target, "injected", src)

	if(!inject(target, user)) //Now we actually do the heavy lifting.
		to_chat(user, span_notice("It appears that [target] does not have compatible DNA."))

	used = TRUE
	update_appearance()

/obj/item/dnainjector/timed
	var/duration = 600

/obj/item/dnainjector/timed/inject(mob/living/carbon/target, mob/user)
	if(target.stat == DEAD) //prevents dead people from having their DNA changed
		to_chat(user, span_notice("你无法修改[target]的DNA，他已经死了."))
		return FALSE
	if(!target.can_mutate())
		return FALSE
	var/endtime = world.time + duration
	for(var/mutation in remove_mutations)
		if(mutation == /datum/mutation/human/race)
			if(!ismonkey(target))
				continue
			target.dna.remove_mutation(mutation)
		else
			target.dna.remove_mutation(mutation)
	for(var/mutation in add_mutations)
		if(target.dna.get_mutation(mutation))
			continue //Skip permanent mutations we already have.
		if(mutation == /datum/mutation/human/race && !ismonkey(target))
			message_admins("[ADMIN_LOOKUPFLW(user)] injected [key_name_admin(target)] with the [name] [span_danger("(MONKEY)")]")
			target.dna.add_mutation(mutation, MUT_OTHER, endtime)
		else
			target.dna.add_mutation(mutation, MUT_OTHER, endtime)
	if(fields)
		if(fields["name"] && fields["UE"] && fields["blood_type"])
			if(!target.dna.previous["name"])
				target.dna.previous["name"] = target.real_name
			if(!target.dna.previous["UE"])
				target.dna.previous["UE"] = target.dna.unique_enzymes
			if(!target.dna.previous["blood_type"])
				target.dna.previous["blood_type"] = target.dna.blood_type
			target.real_name = fields["name"]
			target.dna.unique_enzymes = fields["UE"]
			target.name = target.real_name
			target.dna.blood_type = fields["blood_type"]
			target.dna.temporary_mutations[UE_CHANGED] = endtime
		if(fields["UI"]) //UI+UE
			if(!target.dna.previous["UI"])
				target.dna.previous["UI"] = target.dna.unique_identity
			target.dna.unique_identity = merge_text(target.dna.unique_identity, fields["UI"])
			target.dna.temporary_mutations[UI_CHANGED] = endtime
		if(fields["UF"]) //UI+UE
			if(!target.dna.previous["UF"])
				target.dna.previous["UF"] = target.dna.unique_features
			target.dna.unique_features = merge_text(target.dna.unique_features, fields["UF"])
			target.dna.temporary_mutations[UF_CHANGED] = endtime
		if(fields["UI"] || fields["UF"])
			target.updateappearance(mutcolor_update = TRUE, mutations_overlay_update = TRUE)
	return TRUE

/obj/item/dnainjector/timed/hulk
	name = "\improper DNA注射器（浩克）"
	desc = "这个会让你又高又壮，但对你的皮肤可能不太好."
	add_mutations = list(/datum/mutation/human/hulk)

/obj/item/dnainjector/timed/h2m
	name = "\improper DNA注射器（人类 > 猴子）"
	desc = "让你变成一个跳蚤窝."
	add_mutations = list(/datum/mutation/human/race)

/obj/item/dnainjector/activator
	name = "\improper DNA激活器"
	desc = "如果对象拥有目标基因，则注射后激活对应突变."
	var/force_mutate = FALSE
	var/research = FALSE //Set to true to get expended and filled injectors for chromosomes
	var/filled = FALSE
	var/crispr_charge = FALSE // Look for viruses, look at symptoms, if research and Dormant DNA Activator or Viral Evolutionary Acceleration, set to true

/obj/item/dnainjector/activator/inject(mob/living/carbon/target, mob/user)
	if(!target.can_mutate())
		return FALSE
	for(var/mutation in add_mutations)
		var/datum/mutation/human/added_mutation = mutation
		if(istype(added_mutation, /datum/mutation/human))
			mutation = added_mutation.type
		if(!target.dna.activate_mutation(added_mutation))
			if(force_mutate)
				target.dna.add_mutation(added_mutation, MUT_EXTRA)
		else if(research && target.client)
			filled = TRUE
		for(var/datum/disease/advance/disease in target.diseases)
			for(var/datum/symptom/symp in disease.symptoms)
				if((symp.type == /datum/symptom/genetic_mutation) || (symp.type == /datum/symptom/viralevolution))
					crispr_charge = TRUE
		log_combat(user, target, "[!force_mutate ? "failed to inject" : "injected"]", "[src] ([mutation])[crispr_charge ? " with CRISPR charge" : ""]")
	return TRUE

/// DNA INJECTORS

/obj/item/dnainjector/acidflesh
	name = "\improper DNA注入器（酸性皮肤）"
	add_mutations = list(/datum/mutation/human/acidflesh)

/obj/item/dnainjector/antiacidflesh
	name = "\improper DNA注入器（酸性皮肤）"
	remove_mutations = list(/datum/mutation/human/acidflesh)

/obj/item/dnainjector/antenna
	name = "\improper DNA注射器（天线）"
	add_mutations = list(/datum/mutation/human/antenna)

/obj/item/dnainjector/antiantenna
	name = "\improper DNA注射器（反天线）"
	remove_mutations = list(/datum/mutation/human/antenna)

/obj/item/dnainjector/antiglow
	name = "\improper DNA注射器（吸光）"
	add_mutations = list(/datum/mutation/human/glow/anti)

/obj/item/dnainjector/removeantiglow
	name = "\improper DNA注射器（反吸光）"
	remove_mutations = list(/datum/mutation/human/glow/anti)

/obj/item/dnainjector/blindmut
	name = "\improper DNA注射器（致盲）"
	desc = "让你什么也看不见."
	add_mutations = list(/datum/mutation/human/blind)

/obj/item/dnainjector/antiblind
	name = "\improper DNA注射器（反致盲）"
	desc = "这是一个奇迹!!!"
	remove_mutations = list(/datum/mutation/human/blind)

/obj/item/dnainjector/chameleonmut
	name = "\improper DNA注射器（变色龙）"
	add_mutations = list(/datum/mutation/human/chameleon)

/obj/item/dnainjector/antichameleon
	name = "\improper DNA注射器（反变色龙）"
	remove_mutations = list(/datum/mutation/human/chameleon)

/obj/item/dnainjector/chavmut
	name = "\improper DNA注射器（呆讷）"
	add_mutations = list(/datum/mutation/human/chav)

/obj/item/dnainjector/antichav
	name = "\improper DNA注射器（反呆讷）"
	remove_mutations = list(/datum/mutation/human/chav)

/obj/item/dnainjector/clumsymut
	name = "\improper DNA注射器（笨拙）"
	desc = "制造小丑仆从."
	add_mutations = list(/datum/mutation/human/clumsy)

/obj/item/dnainjector/anticlumsy
	name = "\improper DNA注射器（反笨拙）"
	desc = "将这个注射给安保小丑."
	remove_mutations = list(/datum/mutation/human/clumsy)

/obj/item/dnainjector/coughmut
	name = "\improper DNA注射器（咳嗽）"
	desc = "会让你的喉咙发出糟糕的声音."
	add_mutations = list(/datum/mutation/human/cough)

/obj/item/dnainjector/anticough
	name = "\improper DNA注射器（反咳嗽）"
	desc = "能够让你讨厌的咳嗽声停止."
	remove_mutations = list(/datum/mutation/human/cough)

/obj/item/dnainjector/cryokinesis
	name = "\improper DNA注射器（冰冻）"
	add_mutations = list(/datum/mutation/human/cryokinesis)

/obj/item/dnainjector/anticryokinesis
	name = "\improper DNA DNA注射器（反冰冻）"
	remove_mutations = list(/datum/mutation/human/cryokinesis)

/obj/item/dnainjector/deafmut
	name = "\improper DNA注射器（失聪）"
	desc = "不好意思，你刚说啥？"
	add_mutations = list(/datum/mutation/human/deaf)

/obj/item/dnainjector/antideaf
	name = "\improper DNA注射器（反失聪）"
	desc = "能让你重新听见声音."
	remove_mutations = list(/datum/mutation/human/deaf)

/obj/item/dnainjector/dwarf
	name = "\improper DNA注射器（侏儒）"
	desc = "毕竟这是一个小世界."
	add_mutations = list(/datum/mutation/human/dwarfism)

/obj/item/dnainjector/antidwarf
	name = "\improper DNA注射器（反侏儒）"
	desc = "让你长得又大又壮."
	remove_mutations = list(/datum/mutation/human/dwarfism)

/obj/item/dnainjector/elvismut
	name = "\improper DNA注射器（猫王）"
	add_mutations = list(/datum/mutation/human/elvis)

/obj/item/dnainjector/antielvis
	name = "\improper DNA注射器（反猫王）"
	remove_mutations = list(/datum/mutation/human/elvis)

/obj/item/dnainjector/epimut
	name = "\improper DNA注射器（癫痫）"
	desc = "不如此刻让我们尽情地一起摇摆~"
	add_mutations = list(/datum/mutation/human/epilepsy)

/obj/item/dnainjector/antiepi
	name = "\improper DNA注射器（反癫痫）"
	desc = "让你不再摇摆."
	remove_mutations = list(/datum/mutation/human/epilepsy)

/obj/item/dnainjector/geladikinesis
	name = "\improper DNA注射器（冷凝）"
	add_mutations = list(/datum/mutation/human/geladikinesis)

/obj/item/dnainjector/antigeladikinesis
	name = "\improper DNA注射器（反冷凝）"
	remove_mutations = list(/datum/mutation/human/geladikinesis)

/obj/item/dnainjector/gigantism
	name = "\improper DNA注射器（巨人症）"
	add_mutations = list(/datum/mutation/human/gigantism)

/obj/item/dnainjector/antigigantism
	name = "\improper DNA注射器（反巨人症）"
	remove_mutations = list(/datum/mutation/human/gigantism)

/obj/item/dnainjector/glassesmut
	name = "\improper DNA注射器（近视）"
	desc = "会让你需要戴傻了吧唧的眼镜."
	add_mutations = list(/datum/mutation/human/nearsight)

/obj/item/dnainjector/antiglasses
	name = "\improper DNA注射器（反近视）"
	desc = "扔掉那些眼镜吧!"
	remove_mutations = list(/datum/mutation/human/nearsight)

/obj/item/dnainjector/glow
	name = "\improper DNA注射器（荧光）"
	add_mutations = list(/datum/mutation/human/glow)

/obj/item/dnainjector/removeglow
	name = "\improper DNA注射器（反荧光）"
	remove_mutations = list(/datum/mutation/human/glow)

/obj/item/dnainjector/hulkmut
	name = "\improper DNA注射器（浩克）"
	desc = "This will make you big and strong, but give you a bad skin condition."
	add_mutations = list(/datum/mutation/human/hulk)

/obj/item/dnainjector/antihulk
	name = "\improper DNA注射器（反浩克）吧"
	desc = "Cures green skin."
	remove_mutations = list(/datum/mutation/human/hulk)

/obj/item/dnainjector/h2m
	name = "\improper (Human > Monkey),DNA注射器（人类>猴子）"
	desc = "让你变成一个跳蚤窝."
	add_mutations = list(/datum/mutation/human/race)

/obj/item/dnainjector/m2h
	name = "\improper DNA注射器（猴子>人类）"
	desc = "能让你...不那么毛发旺盛."
	remove_mutations = list(/datum/mutation/human/race)

/obj/item/dnainjector/illiterate
	name = "\improper DNA注射器（文盲）"
	add_mutations = list(/datum/mutation/human/illiterate)

/obj/item/dnainjector/antiilliterate
	name = "\improper DNA注射器（反文盲）"
	remove_mutations = list(/datum/mutation/human/illiterate)

/obj/item/dnainjector/insulated
	name = "\improper DNA注射器（绝缘）"
	add_mutations = list(/datum/mutation/human/insulated)

/obj/item/dnainjector/antiinsulated
	name = "\improper DNA注射器（反绝缘）"
	remove_mutations = list(/datum/mutation/human/insulated)

/obj/item/dnainjector/lasereyesmut
	name = "\improper DNA注射器（激光眼）"
	add_mutations = list(/datum/mutation/human/laser_eyes)

/obj/item/dnainjector/antilasereyes
	name = "\improper DNA注射器（反激光眼）"
	remove_mutations = list(/datum/mutation/human/laser_eyes)

/obj/item/dnainjector/mindread
	name = "\improper DNA注射器（读心）"
	add_mutations = list(/datum/mutation/human/mindreader)

/obj/item/dnainjector/antimindread
	name = "\improper DNA注射器（反读心）"
	remove_mutations = list(/datum/mutation/human/mindreader)

/obj/item/dnainjector/mutemut
	name = "\improper DNA注射器（静音）"
	add_mutations = list(/datum/mutation/human/mute)

/obj/item/dnainjector/antimute
	name = "\improper DNA注射器（反静音）"
	remove_mutations = list(/datum/mutation/human/mute)

/obj/item/dnainjector/olfaction
	name = "\improper DNA注射器（强大嗅觉）"
	add_mutations = list(/datum/mutation/human/olfaction)

/obj/item/dnainjector/antiolfaction
	name = "\improper DNA注射器（反强大嗅觉）"
	remove_mutations = list(/datum/mutation/human/olfaction)

/obj/item/dnainjector/piglatinmut
	name = "\improper DNA注射器（乡村拉丁语）"
	add_mutations = list(/datum/mutation/human/piglatin)

/obj/item/dnainjector/antipiglatin
	name = "\improper DNA注射器（反乡村拉丁语）"
	remove_mutations = list(/datum/mutation/human/piglatin)

/obj/item/dnainjector/paranoia
	name = "\improper DNA注射器（躁狂症）"
	add_mutations = list(/datum/mutation/human/paranoia)

/obj/item/dnainjector/antiparanoia
	name = "\improper DNA注射器（反躁狂症）"
	remove_mutations = list(/datum/mutation/human/paranoia)

/obj/item/dnainjector/pressuremut
	name = "\improper DNA注射器（压力适应性）"
	desc = "给你火."
	add_mutations = list(/datum/mutation/human/pressure_adaptation)

/obj/item/dnainjector/antipressure
	name = "\improper DNA注射器（反压力适应性）"
	desc = "治愈着火."
	remove_mutations = list(/datum/mutation/human/pressure_adaptation)

/obj/item/dnainjector/radioactive
	name = "\improper DNA注射器（放射性）"
	add_mutations = list(/datum/mutation/human/radioactive)

/obj/item/dnainjector/antiradioactive
	name = "\improper DNA注射器（反放射性）"
	remove_mutations = list(/datum/mutation/human/radioactive)

/obj/item/dnainjector/shock
	name = "\improper DNA注射器（电击之触）"
	add_mutations = list(/datum/mutation/human/shock)

/obj/item/dnainjector/antishock
	name = "\improper DNA注射器（反电击之触）"
	remove_mutations = list(/datum/mutation/human/shock)

/obj/item/dnainjector/spastic
	name = "\improper DNA注射器（痉挛）"
	add_mutations = list(/datum/mutation/human/spastic)

/obj/item/dnainjector/antispastic
	name = "\improper DNA注射器（反痉挛）"
	remove_mutations = list(/datum/mutation/human/spastic)

/obj/item/dnainjector/spatialinstability
	name = "\improper DNA注射器（空间不稳定性）"
	add_mutations = list(/datum/mutation/human/badblink)

/obj/item/dnainjector/antispatialinstability
	name = "\improper DNA注射器（反空间不稳定性）"
	remove_mutations = list(/datum/mutation/human/badblink)

/obj/item/dnainjector/stuttmut
	name = "\improper DNA注射器（结巴）"
	desc = "让让让，你，结结b,结巴."
	add_mutations = list(/datum/mutation/human/nervousness)

/obj/item/dnainjector/antistutt
	name = "\improper DNA注射器（反结巴）"
	desc = "修复你的口语障碍."
	remove_mutations = list(/datum/mutation/human/nervousness)

/obj/item/dnainjector/swedishmut
	name = "\improper DNA注射器（瑞典语）"
	add_mutations = list(/datum/mutation/human/swedish)

/obj/item/dnainjector/antiswedish
	name = "\improper DNA注射器（反瑞典语）"
	remove_mutations = list(/datum/mutation/human/swedish)

/obj/item/dnainjector/telemut
	name = "\improper DNA注射器（心灵遥感）"
	desc = "超级心灵传动!"
	add_mutations = list(/datum/mutation/human/telekinesis)

/obj/item/dnainjector/telemut/darkbundle
	name = "\improper DNA注射器"
	desc = "很好，让仇恨流经你的全身."

/obj/item/dnainjector/antitele
	name = "\improper DNA注射器（反心灵遥感）"
	desc = "让你无法聚焦你的心灵."
	remove_mutations = list(/datum/mutation/human/telekinesis)

/obj/item/dnainjector/firemut
	name = "\improper DNA注射器（温度适应性）"
	desc = "给你火."
	add_mutations = list(/datum/mutation/human/temperature_adaptation)

/obj/item/dnainjector/antifire
	name = "\improper DNA注射器（反温度适应性）"
	desc = "治愈着火."
	remove_mutations = list(/datum/mutation/human/temperature_adaptation)

/obj/item/dnainjector/thermal
	name = "\improper DNA注射器（热像视觉）"
	add_mutations = list(/datum/mutation/human/thermal)

/obj/item/dnainjector/antithermal
	name = "\improper DNA注射器（反热像视觉）"
	remove_mutations = list(/datum/mutation/human/thermal)

/obj/item/dnainjector/tourmut
	name = "\improper DNA注射器（秽语综合征）"
	desc = "让你得上讨厌的秽语综合征."
	add_mutations = list(/datum/mutation/human/tourettes)

/obj/item/dnainjector/antitour
	name = "\improper DNA注射器（反秽语综合征）"
	desc = "能治好你的秽语综合征."
	remove_mutations = list(/datum/mutation/human/tourettes)

/obj/item/dnainjector/twoleftfeet
	name = "\improper DNA注射器（双左脚）"
	add_mutations = list(/datum/mutation/human/extrastun)

/obj/item/dnainjector/antitwoleftfeet
	name = "\improper DNA注射器（反双左脚）"
	remove_mutations = list(/datum/mutation/human/extrastun)

/obj/item/dnainjector/unintelligiblemut
	name = "\improper DNA注射器（降智）"
	add_mutations = list(/datum/mutation/human/unintelligible)

/obj/item/dnainjector/antiunintelligible
	name = "\improper DNA注射器（反降智）"
	remove_mutations = list(/datum/mutation/human/unintelligible)

/obj/item/dnainjector/void
	name = "\improper DNA injector (虚化)"
	add_mutations = list(/datum/mutation/human/void)

/obj/item/dnainjector/antivoid
	name = "\improper DNA注射器（反虚化）"
	remove_mutations = list(/datum/mutation/human/void)

/obj/item/dnainjector/xraymut
	name = "\improper DNA注射器（X-光视觉）"
	desc = "你终于能看到舰长到底在干啥了."
	add_mutations = list(/datum/mutation/human/xray)

/obj/item/dnainjector/antixray
	name = "\improper DNA注射器（反X-射线）"
	desc = "这会让你看得更清楚."
	remove_mutations = list(/datum/mutation/human/xray)

/obj/item/dnainjector/wackymut
	name = "\improper DNA注射器（滑稽）"
	add_mutations = list(/datum/mutation/human/wacky)

/obj/item/dnainjector/antiwacky
	name = "\improper DNA注射器（反滑稽）"
	remove_mutations = list(/datum/mutation/human/wacky)

/obj/item/dnainjector/webbing
	name = "\improper DNA注射器（织网）"
	add_mutations = list(/datum/mutation/human/webbing)

/obj/item/dnainjector/antiwebbing
	name = "\improper DNA注射器（反织网能力）"
	remove_mutations = list(/datum/mutation/human/webbing)

/obj/item/dnainjector/clever
	name = "\improper DNA注射器（聪慧）"
	add_mutations = list(/datum/mutation/human/clever)

/obj/item/dnainjector/anticlever
	name = "\improper DNA注射器（反聪慧）"
	remove_mutations = list(/datum/mutation/human/clever)
