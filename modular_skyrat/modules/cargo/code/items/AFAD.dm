#define PHYSICAL_DAMAGE_HEALING -0.2
#define EXOTIC_DAMAGE_HEALING -0.1

/obj/item/gun/medbeam/afad
	name = "AFAD 自动急救枪"
	desc = "常见于医疗包中，AFAD是一款用于修复擦伤和瘀伤的革命性设备，绝对不是传说中的医疗光束山寨品，底部的标签提醒：请勿穿过医疗射线."
	icon = 'icons/obj/chronos.dmi'
	icon_state = "chronogun"
	inhand_icon_state = "chronogun"
	w_class = WEIGHT_CLASS_NORMAL



/obj/item/gun/medbeam/afad/on_beam_tick(mob/living/target)
	if(target.health != target.maxHealth)
		new /obj/effect/temp_visual/heal(get_turf(target), "#80F5FF")
	target.adjustBruteLoss(PHYSICAL_DAMAGE_HEALING)
	target.adjustFireLoss(PHYSICAL_DAMAGE_HEALING)
	target.adjustToxLoss(EXOTIC_DAMAGE_HEALING)
	target.adjustOxyLoss(EXOTIC_DAMAGE_HEALING)
	return
