/datum/action/changeling/chameleon_skin
	name = "变色龙皮肤"
	desc = "我们的皮肤色素能迅速随周围环境而变化，花费25点化学物质."
	helptext = "保持静止几秒，我们就可以与周围环境融为一体，并且该能力可以主动开启或关闭."
	button_icon_state = "chameleon_skin"
	dna_cost = 2
	chemical_cost = 25
	req_human = TRUE

/datum/action/changeling/chameleon_skin/sting_action(mob/user)
	var/mob/living/carbon/human/H = user //SHOULD always be human, because req_human = TRUE
	if(!istype(H)) // req_human could be done in can_sting stuff.
		return
	..()
	if(H.dna.get_mutation(/datum/mutation/human/chameleon))
		H.dna.remove_mutation(/datum/mutation/human/chameleon)
	else
		H.dna.add_mutation(/datum/mutation/human/chameleon)
	return TRUE

/datum/action/changeling/chameleon_skin/Remove(mob/user)
	if(user.has_dna())
		var/mob/living/carbon/C = user
		C.dna.remove_mutation(/datum/mutation/human/chameleon)
	..()
