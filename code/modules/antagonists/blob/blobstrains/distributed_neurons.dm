//kills unconscious targets and turns them into blob zombies, produces fragile spores when killed.  Spore produced by factories are sentient.
/datum/blobstrain/reagent/distributed_neurons
	name = "散布式神经元"
	description = "造成中低程度的毒素伤害，并把无意识的目标转变成真菌僵尸."
	effectdesc = "僵尸在被杀死后也会产生脆弱的孢子球，并且由工厂真菌体生产出的孢子球是有知觉的."
	shortdesc = "造成中低程度的毒素伤害，并在攻击时杀死任何无意识的目标，并且工厂单位生产出的孢子球是有知觉的."
	analyzerdescdamage = "造成中低程度的毒素伤害并杀死无意识的人类."
	analyzerdesceffect = "被杀死后产生孢子球，由工厂真菌体生产出的孢子球是有知觉的."
	color = "#E88D5D"
	complementary_color = "#823ABB"
	message_living = "，你感到疲倦"
	reagent = /datum/reagent/blob/distributed_neurons

/datum/blobstrain/reagent/distributed_neurons/damage_reaction(obj/structure/blob/blob_tile, damage, damage_type, damage_flag)
	if((damage_flag == MELEE || damage_flag == BULLET || damage_flag == LASER) && damage <= 20 && blob_tile.get_integrity() - damage <= 0 && prob(15)) //if the cause isn't fire or a bomb, the damage is less than 21, we're going to die from that damage, 15% chance of a shitty spore.
		blob_tile.visible_message(span_boldwarning("孢子球从团块中漂了出来!"))
		blob_tile.overmind.create_spore(blob_tile.loc, /mob/living/basic/blob_minion/spore/minion/weak)
	return ..()

/datum/reagent/blob/distributed_neurons
	name = "散布式神经元"
	color = "#E88D5D"
	taste_description = "气泡水"

/datum/reagent/blob/distributed_neurons/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	exposed_mob.apply_damage(0.6*reac_volume, TOX)
	if(overmind && ishuman(exposed_mob))
		if(exposed_mob.stat == UNCONSCIOUS || exposed_mob.stat == HARD_CRIT)
			exposed_mob.investigate_log("被散布式神经元(真菌体)杀死.", INVESTIGATE_DEATHS)
			exposed_mob.death() //sleeping in a fight? bad plan.
		if(exposed_mob.stat == DEAD && overmind.can_buy(5))
			var/mob/living/basic/blob_minion/spore/minion/spore = overmind.create_spore(get_turf(exposed_mob))
			spore.zombify(exposed_mob)
			overmind.add_points(-5)
			to_chat(overmind, span_notice("花费5点资源将[exposed_mob]僵尸化."))
