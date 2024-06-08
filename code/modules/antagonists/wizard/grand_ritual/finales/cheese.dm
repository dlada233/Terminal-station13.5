/**
 * Gives the wizard a defensive/mood buff and a Wabbajack, a juiced up chaos staff that will surely break something.
 * Everyone but the wizard goes crazy, suffers major brain damage, and is given a vendetta against the wizard.
 * Already insane people are instead cured of their madness, ignoring any other effects as the station around them loses its marbles.
 */
/datum/grand_finale/cheese
	// we don't set name, desc and others, thus we won't appear in the radial choice of a normal finale rune
	dire_warning = TRUE
	minimum_time = 45 MINUTES //i'd imagine speedrunning this would be crummy, but the wizard's average lifespan is barely reaching this point

/datum/grand_finale/cheese/trigger(mob/living/invoker)
	message_admins("[key_name(invoker)]召唤了瓦巴杰克，诅咒船员发疯!")
	priority_announce("危险：现实改写能力极高的物体被召唤到空间站，建立立即撤离并做好冲击准备", "[command_name()]高维事务处", 'sound/effects/glassbr1.ogg')

	for (var/mob/living/carbon/human/crewmate as anything in GLOB.human_list)
		if (isnull(crewmate.mind))
			continue
		if (crewmate == invoker) //everyone but the wizard is royally fucked, no matter who they are
			continue
		if (crewmate.has_trauma_type(/datum/brain_trauma/mild/hallucinations)) //for an already insane person, this is retribution
			to_chat(crewmate, span_boldwarning("你周遭突然充满了刺耳的狂笑和疯癫的呓语..."))
			to_chat(crewmate, span_nicegreen("...时间流逝，你意识到无论事件的背后是什么，它已无可挽回地在你破碎的心灵中扎下了根. \
				废墟中回荡起不详的共鸣，精神中的失常奇点在那里诞生了! \
				而这奇点坍缩之日，就是你...永获宁静之时."))
			if(crewmate.has_quirk(/datum/quirk/insanity))
				crewmate.remove_quirk(/datum/quirk/insanity)
			else
				crewmate.cure_trauma_type(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_ABSOLUTE)
		else
			//everyone else gets to relish in madness
			//yes killing their mood will also trigger mood hallucinations
			create_vendetta(crewmate.mind, invoker.mind)
			to_chat(crewmate, span_boldwarning("你周遭突然充满了刺耳的狂笑和疯癫的呓语. \n\
				你感到内在的心理破碎成了无数块参差不齐的玻璃碎片，\
				由宇宙中未知的颜色无限地反射出令人炫目、发狂的摧毁之光. \n\
				短暂的停顿后，你心中像是又经过了千年，一句短语在你脑海中不断回响，言语间充满了有关获救的虚假希望... \n\
				<b>[invoker]必须死.</b>"))
			var/datum/brain_trauma/mild/hallucinations/added_trauma = new()
			added_trauma.resilience = TRAUMA_RESILIENCE_ABSOLUTE
			crewmate.adjustOrganLoss(ORGAN_SLOT_BRAIN, BRAIN_DAMAGE_DEATH - 25, BRAIN_DAMAGE_DEATH - 25) //you'd better hope chap didn't pick a hypertool
			crewmate.gain_trauma(added_trauma)
			crewmate.add_mood_event("wizard_ritual_finale", /datum/mood_event/madness_despair)

	//drip our wizard out
	invoker.apply_status_effect(/datum/status_effect/blessing_of_insanity)
	invoker.add_mood_event("wizard_ritual_finale", /datum/mood_event/madness_elation)
	var/obj/item/gun/magic/staff/chaos/true_wabbajack/the_wabbajack = new
	invoker.put_in_active_hand(the_wabbajack)
	to_chat(invoker, span_mind_control("当[the_wabbajack]出现在你的手中时，有关本能与理性的每一寸思维都在向你尖叫..."))
