#define RABBIT_CD_TIME (30 SECONDS)

/obj/item/clothing/head/hats/tophat
	name = "高顶帽"
	desc = "看着像是一顶阿米什人的帽子."
	icon_state = "tophat"
	inhand_icon_state = "that"
	dog_fashion = /datum/dog_fashion/head
	throwforce = 1
	/// 拉出兔子的冷却时间
	COOLDOWN_DECLARE(rabbit_cooldown)

/obj/item/clothing/head/hats/tophat/attackby(obj/item/hitby_item, mob/user, params)
	. = ..()
	if(istype(hitby_item, /obj/item/gun/magic/wand))
		abracadabra(hitby_item, user)

/obj/item/clothing/head/hats/tophat/proc/abracadabra(obj/item/hitby_wand, mob/magician)
	if(!COOLDOWN_FINISHED(src, rabbit_cooldown))
		to_chat(magician, span_warning("你没法从[src]里变出另一只兔子！看来还没有兔子迷路到里面..."))
		return

	COOLDOWN_START(src, rabbit_cooldown, RABBIT_CD_TIME)
	playsound(get_turf(src), 'sound/weapons/emitter.ogg', 70)
	do_smoke(amount = DIAMOND_AREA(1), holder = src, location = src, smoke_type=/obj/effect/particle_effect/fluid/smoke/quick)

	if(prob(10))
		magician.visible_message(span_danger("[magician]用[hitby_wand]敲了敲[src]，然后伸手进去拽出了一群...等下，是一群蜜蜂！"), span_danger("你用你的[hitby_wand.name]敲了敲[src]，拽出了...<b>蜜蜂！</b>"))
		var/wait_how_many_bees_did_that_guy_pull_out_of_his_hat = rand(4, 8)
		for(var/b in 1 to wait_how_many_bees_did_that_guy_pull_out_of_his_hat)
			var/mob/living/basic/bee/barry = new(get_turf(magician))
			if(prob(20))
				barry.say(pick("嗡 嗡", "从帽子里变出兔子是个老掉牙的把戏", "这里我不想呆下去了"), forced = "bee hat")
	else
		magician.visible_message(span_notice("[magician]用[hitby_wand]敲了敲[src]，然后伸手进去拽出了一只兔子！好可爱！"), span_notice("你用你的[hitby_wand.name]敲了敲[src]，拽出了一只可爱的兔子！"))
		var/mob/living/basic/rabbit/bunbun = new(get_turf(magician))
		bunbun.mob_try_pickup(magician, instant=TRUE)

/obj/item/clothing/head/hats/tophat/balloon
	name = "气球高顶帽"
	desc = "一顶色彩鲜艳的礼帽，凸显你丰富多彩的个性."
	icon_state = "balloon_tophat"
	inhand_icon_state = "balloon_that"
	throwforce = 0
	resistance_flags = FIRE_PROOF
	dog_fashion = null

#undef RABBIT_CD_TIME
