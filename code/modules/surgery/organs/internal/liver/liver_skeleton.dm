/**
 * Bone liver
 * Gives the owner liverless metabolism, makes them vulnerable to bone hurting juice and
 * makes milk heal them through meme magic.
 **/
/obj/item/organ/internal/liver/bone
	name = "骨团"
	desc = "你完全不知道这个奇怪的骨球是做什么用的."
	icon_state = "liver-bone"
	organ_traits = list(TRAIT_STABLELIVER)
	///Var for brute healing via milk
	var/milk_brute_healing = 2.5
	///Var for burn healing via milk
	var/milk_burn_healing = 2.5

/obj/item/organ/internal/liver/bone/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick, times_fired)
	. = ..()
	// parent returned COMSIG_MOB_STOP_REAGENT_CHECK or we are failing
	if((. & COMSIG_MOB_STOP_REAGENT_CHECK) || (organ_flags & ORGAN_FAILING))
		return
	if(istype(chem, /datum/reagent/toxin/bonehurtingjuice))
		organ_owner.adjustStaminaLoss(7.5 * REM * seconds_per_tick, updating_stamina = FALSE)
		organ_owner.adjustBruteLoss(0.5 * REM * seconds_per_tick, updating_health = FALSE)
		if(SPT_PROB(10, seconds_per_tick))
			switch(rand(1, 3))
				if(1)
					INVOKE_ASYNC(organ_owner, TYPE_PROC_REF(/atom/movable, say), pick("啊.", "嗷.", "我的骨头.", "嗷呜.", "嗷呜我的骨头."), forced = chem.type)
				if(2)
					organ_owner.manual_emote(pick("小声地嗷.", "看起来伤到骨头了.", "痛到扭曲，因为伤到骨头了."))
				if(3)
					to_chat(organ_owner, span_warning("伤到骨头了!"))
		if(chem.overdosed)
			if(SPT_PROB(2, seconds_per_tick)) //big oof
				var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly...
				var/obj/item/bodypart/bodypart = organ_owner.get_bodypart(selected_part) //We're so sorry skeletons, you're so misunderstood
				if(bodypart)
					playsound(organ_owner, SFX_DESECRATION, 50, vary = TRUE) //You just want to socialize
					organ_owner.visible_message(span_warning("[organ_owner]发出响亮的咯咯声并四处翻滚!!"), span_danger("你的骨头疼痛难忍，以至于你缺失的肌肉都痉挛了!!"))
					INVOKE_ASYNC(organ_owner, TYPE_PROC_REF(/atom/movable, say), "OOF!!", forced = chem.type)
					bodypart.receive_damage(brute = 200) //But I don't think we should
				else
					to_chat(organ_owner, span_warning("你感到仿佛你缺失的[parse_zone(selected_part)]在疼痛."))
					INVOKE_ASYNC(organ_owner, TYPE_PROC_REF(/mob, emote), "sigh")
		organ_owner.reagents.remove_reagent(chem.type, chem.metabolization_rate * seconds_per_tick)
		return COMSIG_MOB_STOP_REAGENT_CHECK // Stop metabolism
	if(chem.type == /datum/reagent/consumable/milk)
		if(chem.volume > 50)
			organ_owner.reagents.remove_reagent(chem.type, (chem.volume - 50))
			to_chat(organ_owner, span_warning("多余的牛奶正在从你的骨头上滴下来!"))
		organ_owner.heal_bodypart_damage(milk_brute_healing * REM * seconds_per_tick, milk_burn_healing * REM * seconds_per_tick)
		for(var/datum/wound/iter_wound as anything in organ_owner.all_wounds)
			iter_wound.on_xadone(1 * REM * seconds_per_tick)
		return // Do normal metabolism
