/datum/reagent/reaction_agent
	name = "Reaction Agent"
	description = "Hello! I am a bugged reagent. Please report me for my crimes. Thank you!!"

/datum/reagent/reaction_agent/intercept_reagents_transfer(datum/reagents/target, amount)
	if(!target)
		return FALSE
	if(target.flags & NO_REACT)
		return FALSE
	if(target.has_reagent(/datum/reagent/stabilizing_agent))
		return FALSE
	if(LAZYLEN(target.reagent_list) == 0)
		return FALSE
	if(LAZYLEN(target.reagent_list) == 1)
		if(target.has_reagent(type)) //Allow dispensing into self
			return FALSE
	return TRUE

/datum/reagent/reaction_agent/acidic_buffer
	name = "Strong Acidic Buffer-强酸缓冲液"
	description = "当加入另一个烧杯时，这种试剂会消耗自身，使烧杯的pH值向酸性方向移动."
	color = "#fbc314"
	ph = 0
	inverse_chem = null
	fallback_icon = 'icons/obj/drinks/drink_effects.dmi'
	fallback_icon_state = "acid_buffer_fallback"

//Consumes self on addition and shifts ph
/datum/reagent/reaction_agent/acidic_buffer/intercept_reagents_transfer(datum/reagents/target, amount)
	. = ..()
	if(!.)
		return

	//do the ph change
	var/message
	if(target.ph <= ph)
		message = "当加入缓冲液时，烧杯起泡，但没有效果。"
	else
		message = "随着pH值的变化，烧杯起泡!"
		target.adjust_all_reagents_ph((-(amount / target.total_volume) * BUFFER_IONIZING_STRENGTH))

	//give feedback & remove from holder because it's not transferred
	target.my_atom.audible_message(span_warning(message))
	playsound(target.my_atom, 'sound/chemistry/bufferadd.ogg', 50, TRUE)
	holder.remove_reagent(type, amount)

/datum/reagent/reaction_agent/basic_buffer
	name = "Strong Basic Buffer-强碱性缓冲液"
	description = "当加入另一个烧杯时，这种试剂会消耗自身，使烧杯的pH值向碱性移动."
	color = "#3853a4"
	ph = 14
	inverse_chem = null
	fallback_icon = 'icons/obj/drinks/drink_effects.dmi'
	fallback_icon_state = "base_buffer_fallback"

/datum/reagent/reaction_agent/basic_buffer/intercept_reagents_transfer(datum/reagents/target, amount)
	. = ..()
	if(!.)
		return

	//do the ph change
	var/message
	if(target.ph >= ph)
		message = "当加入缓冲液时，烧杯起泡，但没有效果."
	else
		message = "随着pH值的变化，烧杯起泡!"
		target.adjust_all_reagents_ph(((amount / target.total_volume) * BUFFER_IONIZING_STRENGTH))

	//give feedback & remove from holder because it's not transferred
	target.my_atom.audible_message(span_warning(message))
	playsound(target.my_atom, 'sound/chemistry/bufferadd.ogg', 50, TRUE)
	holder.remove_reagent(type, amount)

//purity testor/reaction agent prefactors

/datum/reagent/prefactor_a
	name = "Interim Product Alpha-临时产剂Alpha"
	description = "该试剂是纯度测试液的前因子，并将与稳定的等离子体反应产生它."
	color = "#bafa69"

/datum/reagent/prefactor_b
	name = "Interim Product Beta-临时产剂Beta"
	description = "该试剂是反应加速液的前因子，并将与稳定的等离子体反应以产生它。"
	color = "#8a3aa9"

/datum/reagent/reaction_agent/purity_tester
	name = "Purity Tester-纯度测试液"
	description = "如果烧杯中有高度不纯的试剂，该试剂会消耗自身并发生剧烈反应."
	ph = 3
	color = "#ffffff"

/datum/reagent/reaction_agent/purity_tester/intercept_reagents_transfer(datum/reagents/target, amount)
	. = ..()
	if(!.)
		return
	var/is_inverse = FALSE
	for(var/_reagent in target.reagent_list)
		var/datum/reagent/reaction_agent/reagent = _reagent
		if(reagent.purity <= reagent.inverse_chem_val)
			is_inverse = TRUE
	if(is_inverse)
		target.my_atom.audible_message(span_warning("当加入试剂时，烧杯剧烈起泡!"))
		playsound(target.my_atom, 'sound/chemistry/bufferadd.ogg', 50, TRUE)
	else
		target.my_atom.audible_message(span_warning("加入的试剂似乎作用不大."))
	holder.remove_reagent(type, amount)

///How much the reaction speed is sped up by - for 5u added to 100u, an additional step of 1 will be done up to a max of 2x
#define SPEED_REAGENT_STRENGTH 20

/datum/reagent/reaction_agent/speed_agent
	name = "Tempomyocin-反应加速液"
	description = "这种试剂会消耗自身，加速正在进行的反应，通过它自己来改变当前反应的纯度."
	ph = 10
	color = "#e61f82"

/datum/reagent/reaction_agent/speed_agent/intercept_reagents_transfer(datum/reagents/target, amount)
	. = ..()
	if(!.)
		return FALSE
	if(!length(target.reaction_list))//you can add this reagent to a beaker with no ongoing reactions, so this prevents it from being used up.
		return FALSE
	amount /= target.reaction_list.len
	for(var/_reaction in target.reaction_list)
		var/datum/equilibrium/reaction = _reaction
		if(!reaction)
			CRASH("[_reaction]在反应表中，但不是平衡的.")
		var/power = (amount / reaction.target_vol) * SPEED_REAGENT_STRENGTH
		power *= creation_purity
		power = clamp(power, 0, 2)
		reaction.react_timestep(power, creation_purity)
	holder.remove_reagent(type, amount)

#undef SPEED_REAGENT_STRENGTH
