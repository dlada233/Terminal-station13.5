/obj/item/book/granter/martial/cqc
	martial = /datum/martial_art/cqc
	name = "老旧的手册"
	martial_name = "close quarters combat-近身格斗术"
	desc = "一本黑色的手册，里面有CQC-近身格斗术的教学."
	greet = "<span class='boldannounce'>You've mastered the basics of CQC.</span>"
	icon_state = "cqcmanual"
	remarks = list(
		"Kick... Slam...",
		"Lock... Kick...",
		"Strike their abdomen, neck and back for critical damage...",
		"Slam... Lock...",
		"I could probably combine this with some other martial arts!",
		"Words that kill...",
		"The last and final moment is yours...",
	)

/obj/item/book/granter/martial/cqc/on_reading_finished(mob/living/carbon/user)
	. = ..()
	if(uses <= 0)
		to_chat(user, span_warning("[src] beeps ominously..."))

/obj/item/book/granter/martial/cqc/recoil(mob/living/user)
	to_chat(user, span_warning("[src] explodes!"))
	playsound(src,'sound/effects/explosion1.ogg',40,TRUE)
	user.flash_act(1, 1)
	user.adjustBruteLoss(6)
	user.adjustFireLoss(6)
	qdel(src)
