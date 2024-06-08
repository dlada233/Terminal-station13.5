/*
Abilities that can be purchased by disease mobs. Most are just passive symptoms that will be
added to their disease, but some are active abilites that affect only the target the overmind
is currently following.
*/

GLOBAL_LIST_INIT(disease_ability_singletons, list(
new /datum/disease_ability/action/cough,
new /datum/disease_ability/action/sneeze,
new /datum/disease_ability/action/infect,
new /datum/disease_ability/symptom/mild/cough,
new /datum/disease_ability/symptom/mild/sneeze,
new /datum/disease_ability/symptom/medium/shedding,
new /datum/disease_ability/symptom/medium/beard,
new /datum/disease_ability/symptom/medium/hallucigen,
new /datum/disease_ability/symptom/medium/choking,
new /datum/disease_ability/symptom/medium/confusion,
new /datum/disease_ability/symptom/medium/vomit,
new /datum/disease_ability/symptom/medium/voice_change,
new /datum/disease_ability/symptom/medium/visionloss,
new /datum/disease_ability/symptom/medium/deafness,
new /datum/disease_ability/symptom/powerful/narcolepsy,
new /datum/disease_ability/symptom/medium/fever,
new /datum/disease_ability/symptom/medium/chills,
new /datum/disease_ability/symptom/medium/headache,
new /datum/disease_ability/symptom/medium/viraladaptation,
new /datum/disease_ability/symptom/medium/viralevolution,
new /datum/disease_ability/symptom/medium/disfiguration,
new /datum/disease_ability/symptom/medium/polyvitiligo,
new /datum/disease_ability/symptom/medium/itching,
new /datum/disease_ability/symptom/medium/heal/weight_loss,
new /datum/disease_ability/symptom/medium/heal/sensory_restoration,
new /datum/disease_ability/symptom/medium/heal/mind_restoration,
new /datum/disease_ability/symptom/powerful/fire,
new /datum/disease_ability/symptom/powerful/flesh_eating,
new /datum/disease_ability/symptom/powerful/genetic_mutation,
new /datum/disease_ability/symptom/powerful/inorganic_adaptation,
new /datum/disease_ability/symptom/powerful/heal/starlight,
new /datum/disease_ability/symptom/powerful/heal/oxygen,
new /datum/disease_ability/symptom/powerful/heal/chem,
new /datum/disease_ability/symptom/powerful/heal/metabolism,
new /datum/disease_ability/symptom/powerful/heal/dark,
new /datum/disease_ability/symptom/powerful/heal/water,
new /datum/disease_ability/symptom/powerful/heal/plasma,
new /datum/disease_ability/symptom/powerful/heal/radiation,
new /datum/disease_ability/symptom/powerful/heal/coma,
new /datum/disease_ability/symptom/powerful/youth
))

/datum/disease_ability
	var/name
	var/cost = 0
	var/required_total_points = 0
	var/start_with = FALSE
	var/short_desc = ""
	var/long_desc = ""
	var/stat_block = ""
	var/threshold_block = list()
	var/category = ""

	var/list/symptoms
	var/list/actions

/datum/disease_ability/New()
	..()
	if(symptoms)
		var/stealth = 0
		var/resistance = 0
		var/stage_speed = 0
		var/transmittable = 0
		for(var/T in symptoms)
			var/datum/symptom/S = T
			stealth += initial(S.stealth)
			resistance += initial(S.resistance)
			stage_speed += initial(S.stage_speed)
			transmittable += initial(S.transmittable)
			threshold_block += initial(S.threshold_descs)
			stat_block = "耐药性: [resistance]<br>隐蔽性: [stealth]<br>阶段速度: [stage_speed]<br>传染性: [transmittable]<br><br>"
			if(symptoms.len == 1) //lazy boy's dream
				name = initial(S.name)
				if(short_desc == "")
					short_desc = initial(S.desc)
				if(long_desc == "")
					long_desc = initial(S.desc)

/datum/disease_ability/proc/CanBuy(mob/camera/disease/D)
	if(world.time < D.next_adaptation_time)
		return FALSE
	if(!D.unpurchased_abilities[src])
		return FALSE
	return (D.points >= cost) && (D.total_points >= required_total_points)

/datum/disease_ability/proc/Buy(mob/camera/disease/D, silent = FALSE, trigger_cooldown = TRUE)
	if(!silent)
		to_chat(D, span_notice("已购买 [name]."))
	D.points -= cost
	D.unpurchased_abilities -= src
	if(trigger_cooldown)
		D.adapt_cooldown()
	D.purchased_abilities[src] = TRUE
	for(var/V in (D.disease_instances+D.disease_template))
		var/datum/disease/advance/sentient_disease/SD = V
		if(symptoms)
			for(var/T in symptoms)
				var/datum/symptom/S = new T()
				SD.symptoms += S
				S.OnAdd(SD)
				if(SD.processing)
					if(S.Start(SD))
						S.next_activation = world.time + rand(S.symptom_delay_min * 10, S.symptom_delay_max * 10)
			SD.Refresh()
	for(var/T in actions)
		var/datum/action/A = new T()
		A.Grant(D)


/datum/disease_ability/proc/CanRefund(mob/camera/disease/D)
	if(world.time < D.next_adaptation_time)
		return FALSE
	return D.purchased_abilities[src]

/datum/disease_ability/proc/Refund(mob/camera/disease/D, silent = FALSE, trigger_cooldown = TRUE)
	if(!silent)
		to_chat(D, span_notice("已退还 [name]."))
	D.points += cost
	D.unpurchased_abilities[src] = TRUE
	if(trigger_cooldown)
		D.adapt_cooldown()
	D.purchased_abilities -= src
	for(var/V in (D.disease_instances+D.disease_template))
		var/datum/disease/advance/sentient_disease/SD = V
		if(symptoms)
			for(var/T in symptoms)
				var/datum/symptom/S = locate(T) in SD.symptoms
				if(S)
					SD.symptoms -= S
					S.OnRemove(SD)
					if(SD.processing)
						S.End(SD)
					qdel(S)
			SD.Refresh()
	for(var/T in actions)
		var/datum/action/A = locate(T) in D.actions
		qdel(A)

//these sybtypes are for conveniently separating the different categories, they have no unique code.

/datum/disease_ability/action
	category = "行为"

/datum/disease_ability/symptom
	category = "症状"

//active abilities and their associated actions

/datum/disease_ability/action/cough
	name = "主动性咳嗽"
	actions = list(/datum/action/cooldown/disease_cough)
	cost = 0
	required_total_points = 0
	start_with = TRUE
	short_desc = "强迫你跟随的宿主咳嗽，将你传播给附近的人."
	long_desc = "强迫你跟随的宿主咳嗽，将你传播给宿主两米内的人.<br>冷却时间: 10 秒"


/datum/action/cooldown/disease_cough
	name = "咳嗽"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "cough"
	desc = "强迫你跟随的宿主咳嗽，将你传播给宿主两米内的人.<br>冷却时间: 10 秒"
	cooldown_time = 100

/datum/action/cooldown/disease_cough/Activate(atom/target)
	StartCooldown(10 SECONDS)
	trigger_cough()
	StartCooldown()
	return TRUE

/*
 * Cause a cough to happen from the host.
 */
/datum/action/cooldown/disease_cough/proc/trigger_cough()
	var/mob/camera/disease/our_disease = owner
	var/mob/living/host = our_disease.following_host
	if(!host)
		return FALSE
	if(host.stat != CONSCIOUS)
		to_chat(our_disease, span_warning("你的宿主能意识到咳嗽."))
		return FALSE
	to_chat(our_disease, span_notice("你强迫[host.real_name]咳嗽."))
	host.emote("cough")
	if(host.CanSpreadAirborneDisease()) //don't spread germs if they covered their mouth
		var/datum/disease/advance/sentient_disease/disease_datum = our_disease.hosts[host]
		disease_datum.spread(2)
	return TRUE

/datum/disease_ability/action/sneeze
	name = "主动性喷嚏"
	actions = list(/datum/action/cooldown/disease_sneeze)
	cost = 2
	required_total_points = 3
	short_desc = "强迫你跟随的宿主咳嗽，将你传播给前方的人."
	long_desc = "强迫你跟随的宿主咳嗽，将你传播给宿主前方四米内的任何人.<br>冷却时间: 20 秒"

/datum/action/cooldown/disease_sneeze
	name = "喷嚏"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "sneeze"
	desc = "强迫你跟随的宿主咳嗽，将你传播给宿主前方四米内的任何人.<br>冷却时间: 20 秒"
	cooldown_time = 200

/datum/action/cooldown/disease_sneeze/Activate(atom/target)
	StartCooldown(10 SECONDS)
	trigger_sneeze()
	StartCooldown()
	return TRUE

/*
 * Cause a sneeze to happen from the host.
 */
/datum/action/cooldown/disease_sneeze/proc/trigger_sneeze()
	var/mob/camera/disease/our_disease = owner
	var/mob/living/host = our_disease.following_host
	if(!host)
		return FALSE
	if(host.stat != CONSCIOUS)
		to_chat(our_disease, span_warning("你的宿主能意识到喷嚏."))
		return FALSE
	to_chat(our_disease, span_notice("你强迫[host.real_name]打喷嚏."))
	host.emote("sneeze")
	if(host.CanSpreadAirborneDisease()) //don't spread germs if they covered their mouth
		var/datum/disease/advance/sentient_disease/disease_datum = our_disease.hosts[host]
		for(var/mob/living/nearby_mob in oview(4, disease_datum.affected_mob))
			if(!is_source_facing_target(disease_datum.affected_mob, nearby_mob))
				continue
			if(!disease_air_spread_walk(get_turf(disease_datum.affected_mob), get_turf(nearby_mob)))
				continue
			nearby_mob.AirborneContractDisease(disease_datum, TRUE)

	return TRUE

/datum/disease_ability/action/infect
	name = "分泌物传染"
	actions = list(/datum/action/cooldown/disease_infect)
	cost = 2
	required_total_points = 3
	short_desc = "一定时间内让你的宿主所接触到的所有物体都具有传染性，任何接触到这些物体的人都会被传染."
	long_desc = "让你跟随的宿主从毛孔中分泌出感染物质，所有接触到他们皮肤的物体在接下来30秒内会传染给其他接触到他们的人. 可附着物体包括地板，但前提是宿主没有穿鞋，也包括他们手接触到的物体，但前提是宿主没有戴手套.<br>冷却时间: 40 秒"

/datum/action/cooldown/disease_infect
	name = "分泌物传染"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	button_icon_state = "infect"
	desc = "让你跟随的宿主从毛孔中分泌出感染物质，所有接触到他们皮肤的物体在接下来30秒内会传染给其他接触到他们的人. 可附着物体包括地板，但前提是宿主没有穿鞋，也包括他们手接触到的物体，但前提是宿主没有戴手套.<br>冷却时间: 40 秒"
	cooldown_time = 400

/datum/action/cooldown/disease_infect/Activate(atom/target)
	StartCooldown(10 SECONDS)
	trigger_infection()
	StartCooldown()
	return TRUE

/*
 * Trigger the infection action.
 */
/datum/action/cooldown/disease_infect/proc/trigger_infection()
	var/mob/camera/disease/our_disease = owner
	var/mob/living/carbon/human/host = our_disease.following_host
	if(!host)
		return FALSE
	for(var/obj/thing as anything in host.get_equipped_items(include_accessories = TRUE))
		thing.AddComponent(/datum/component/infective, our_disease.disease_template, 300)
	//no shoes? infect the floor.
	if(!host.shoes)
		var/turf/host_turf = get_turf(host)
		if(host_turf && !isspaceturf(host_turf))
			host_turf.AddComponent(/datum/component/infective, our_disease.disease_template, 300)
	//no gloves? infect whatever we are holding.
	if(!host.gloves)
		for(var/obj/held_thing as anything in host.held_items)
			if(isnull(held_thing))
				continue
			held_thing.AddComponent(/datum/component/infective, our_disease.disease_template, 300)
	return TRUE

/*******************BASE 症状TYPES*******************/
// cost is for convenience and can be changed. If you're changing req_tot_points then don't use the subtype...
//healing costs more so you have to techswitch from naughty disease otherwise we'd have friendly disease for easy greentext (no fun!)

/datum/disease_ability/symptom/mild
	cost = 2
	required_total_points = 4
	category = "症状(弱)"

/datum/disease_ability/symptom/medium
	cost = 4
	required_total_points = 8
	category = "症状"

/datum/disease_ability/symptom/medium/heal
	cost = 5
	category = "症状(+)"

/datum/disease_ability/symptom/powerful
	cost = 4
	required_total_points = 16
	category = "症状(强)"

/datum/disease_ability/symptom/powerful/heal
	cost = 8
	category = "症状(强+)"

/******MILD******/

/datum/disease_ability/symptom/mild/cough
	name = "自发性咳嗽"
	symptoms = list(/datum/symptom/cough)
	short_desc = "导致患者间歇性咳嗽."
	long_desc = "导致患者间歇性咳嗽，传染他人."

/datum/disease_ability/symptom/mild/sneeze
	name = "自发性喷嚏"
	symptoms = list(/datum/symptom/sneeze)
	short_desc = "导致患者间歇性喷嚏."
	long_desc = "导致患者间歇性打喷嚏，传染他人，同时能以隐蔽性为代价增加你的传染性和耐药性，"

/******MEDIUM******/

/datum/disease_ability/symptom/medium/shedding
	symptoms = list(/datum/symptom/shedding)

/datum/disease_ability/symptom/medium/beard
	symptoms = list(/datum/symptom/beard)
	short_desc = "导致患者长出飘逸胡须."
	long_desc = "导致患者长出飘逸胡须. 对圣诞老人无效."

/datum/disease_ability/symptom/medium/hallucigen
	symptoms = list(/datum/symptom/hallucigen)
	short_desc = "导致患者产生幻觉."
	long_desc = "导致患者产生幻觉. 会降低属性，尤其是耐药性."

/datum/disease_ability/symptom/medium/choking
	symptoms = list(/datum/symptom/choking)
	short_desc = "导致患者咽喉堵塞."
	long_desc = "导致患者咽喉堵塞，直至窒息. 会降低属性，尤其是传染性."

/datum/disease_ability/symptom/medium/confusion
	symptoms = list(/datum/symptom/confusion)
	short_desc = "导致患者陷入混乱."
	long_desc = "导致患者间歇性陷入混乱."

/datum/disease_ability/symptom/medium/vomit
	symptoms = list(/datum/symptom/vomit)
	short_desc = "导致患者呕吐."
	long_desc = "导致患者呕吐. 稍微增加传染性，呕吐会使患者失去营养，并消除一些毒素伤害."

/datum/disease_ability/symptom/medium/voice_change
	symptoms = list(/datum/symptom/voice_change)
	short_desc = "改变患者声音."
	long_desc = "改变患者声音，在交流中造成混乱."

/datum/disease_ability/symptom/medium/visionloss
	symptoms = list(/datum/symptom/visionloss)
	short_desc = "对患者眼睛造成伤害，最终导致失明."
	long_desc = "对患者眼睛造成伤害，最终导致失明. 降低所有属性."

/datum/disease_ability/symptom/medium/deafness
	symptoms = list(/datum/symptom/deafness)

/datum/disease_ability/symptom/medium/fever
	symptoms = list(/datum/symptom/fever)

/datum/disease_ability/symptom/medium/chills
	symptoms = list(/datum/symptom/chills)

/datum/disease_ability/symptom/medium/headache
	symptoms = list(/datum/symptom/headache)

/datum/disease_ability/symptom/medium/viraladaptation
	symptoms = list(/datum/symptom/viraladaptation)
	short_desc = "让你更加难以被发现和被根除."
	long_desc = "让你的病原体模仿正常身体细胞工作，更加难以被发现和被根除，但会降低速度."

/datum/disease_ability/symptom/medium/viralevolution
	symptoms = list(/datum/symptom/viralevolution)

/datum/disease_ability/symptom/medium/polyvitiligo
	symptoms = list(/datum/symptom/polyvitiligo)

/datum/disease_ability/symptom/medium/disfiguration
	symptoms = list(/datum/symptom/disfiguration)

/datum/disease_ability/symptom/medium/itching
	symptoms = list(/datum/symptom/itching)
	short_desc = "导致患者发痒."
	long_desc = "导致患者发痒，增加除隐蔽性之外的所有属性."

/datum/disease_ability/symptom/medium/heal/weight_loss
	symptoms = list(/datum/symptom/weight_loss)
	short_desc = "导致患者体重减轻."
	long_desc = "导致患者体重减轻，并让他们几乎无法从食物中获取营养. 缺乏营养会让病原体更容易借由宿主传播，尤其是通过打喷嚏传播."

/datum/disease_ability/symptom/medium/heal/sensory_restoration
	symptoms = list(/datum/symptom/sensory_restoration)
	short_desc = "减少患者眼睛和耳朵所受的伤害."
	long_desc = "减少患者眼睛和耳朵所受的伤害."

/datum/disease_ability/symptom/medium/heal/mind_restoration
	symptoms = list(/datum/symptom/mind_restoration)

/******POWERFUL******/

/datum/disease_ability/symptom/powerful/fire
	symptoms = list(/datum/symptom/fire)

/datum/disease_ability/symptom/powerful/flesh_eating
	symptoms = list(/datum/symptom/flesh_eating)

/datum/disease_ability/symptom/powerful/genetic_mutation
	symptoms = list(/datum/symptom/genetic_mutation)
	cost = 8

/datum/disease_ability/symptom/powerful/inorganic_adaptation
	symptoms = list(/datum/symptom/inorganic_adaptation)

/datum/disease_ability/symptom/powerful/narcolepsy
	symptoms = list(/datum/symptom/narcolepsy)

/datum/disease_ability/symptom/powerful/youth
	symptoms = list(/datum/symptom/youth)
	short_desc = "导致患者永葆青春."
	long_desc = "导致患者永葆青春. 提供除传染力以外的所有属性的提升."

/****HEALING SUBTYPE****/

/datum/disease_ability/symptom/powerful/heal/starlight
	symptoms = list(/datum/symptom/heal/starlight)

/datum/disease_ability/symptom/powerful/heal/oxygen
	symptoms = list(/datum/symptom/oxygen)

/datum/disease_ability/symptom/powerful/heal/chem
	symptoms = list(/datum/symptom/heal/chem)

/datum/disease_ability/symptom/powerful/heal/metabolism
	symptoms = list(/datum/symptom/heal/metabolism)
	short_desc = "加速患者的新陈代谢，使他们更快地消化化学物质，更快地感到饥饿."
	long_desc = "加速患者的新陈代谢，使他们对化学物质的代谢速度提高一倍，并更快地感到饥饿."

/datum/disease_ability/symptom/powerful/heal/dark
	symptoms = list(/datum/symptom/heal/darkness)

/datum/disease_ability/symptom/powerful/heal/water
	symptoms = list(/datum/symptom/heal/water)

/datum/disease_ability/symptom/powerful/heal/plasma
	symptoms = list(/datum/symptom/heal/plasma)

/datum/disease_ability/symptom/powerful/heal/radiation
	symptoms = list(/datum/symptom/heal/radiation)

/datum/disease_ability/symptom/powerful/heal/coma
	symptoms = list(/datum/symptom/heal/coma)
	short_desc = "导致患者在受到伤害时陷入自愈性昏迷."
	long_desc = "导致患者在受到伤害时陷入自愈性昏迷."
