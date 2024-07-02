/obj/item/book/granter/martial/cqc
	martial = /datum/martial_art/cqc
	name = "老旧的手册"
	martial_name = "close quarters combat-近身格斗术"
	desc = "一本黑色的手册，里面有CQC-近身格斗术的教学."
	greet = "<span class='boldannounce'>你已经掌握了CQC的基础招式.</span>"
	icon_state = "cqcmanual"
	remarks = list(
		"前踢... 猛摔...",
		"锁喉... 后蹬...",
		"击腹，然后撕裂颈部与背部...",
		"猛锤... 锁拳...",
		"这些招式或许也能同其他武术结合使用!",
		"全是杀招...",
		"我将战至最后一人...",
	)

/obj/item/book/granter/martial/cqc/on_reading_finished(mob/living/carbon/user)
	. = ..()
	if(uses <= 0)
		to_chat(user, span_warning("[src]发出不详的哔哔声..."))

/obj/item/book/granter/martial/cqc/recoil(mob/living/user)
	to_chat(user, span_warning("[src]爆炸了!"))
	playsound(src,'sound/effects/explosion1.ogg',40,TRUE)
	user.flash_act(1, 1)
	user.adjustBruteLoss(6)
	user.adjustFireLoss(6)
	qdel(src)
