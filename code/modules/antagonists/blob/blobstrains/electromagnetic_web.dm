//does burn damage and EMPs, slightly fragile
/datum/blobstrain/reagent/electromagnetic_web
	name = "电磁网络体"
	color = "#83ECEC"
	complementary_color = "#EC8383"
	description = "对目标造成高额烧伤和EMP效果."
	effectdesc = "受到的伤害也会增加，在被杀死时释放EMP."
	analyzerdescdamage = "对目标造成低额烧伤和EMP效果."
	analyzerdesceffect = "对所有类型的伤害都缺乏抗性，尤其害怕受到创伤攻击；在被杀死时将会释放一次小范围的EMP攻击."
	reagent = /datum/reagent/blob/electromagnetic_web

/datum/blobstrain/reagent/electromagnetic_web/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if(damage_type == BRUTE) // take full brute, divide by the multiplier to get full value
		return damage / B.brute_resist
	return damage * 1.25 //a laser will do 25 damage, which will kill any normal blob

/datum/blobstrain/reagent/electromagnetic_web/death_reaction(obj/structure/blob/B, damage_flag)
	if(damage_flag == MELEE || damage_flag == BULLET || damage_flag == LASER)
		empulse(B.loc, 1, 3) //less than screen range, so you can stand out of range to avoid it

/datum/reagent/blob/electromagnetic_web
	name = "电磁网络体"
	taste_description = "跳跳糖"
	color = "#83ECEC"

/datum/reagent/blob/electromagnetic_web/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	if(prob(reac_volume*2))
		exposed_mob.emp_act(EMP_LIGHT)
	if(exposed_mob)
		exposed_mob.apply_damage(reac_volume, BURN, wound_bonus=CANT_WOUND)
