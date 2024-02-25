/obj/projectile/bullet/dnainjector
	name = "\improper DNA注射器"
	icon_state = "syringeproj"
	var/obj/item/dnainjector/injector
	damage = 5
	hitsound_wall = SFX_SHATTER
	embedding = null
	shrapnel_type = null

/obj/projectile/bullet/dnainjector/on_hit(atom/target, blocked = 0, pierce_hit)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		if(blocked != 100)
			if(M.can_inject(target_zone = def_zone))
				if(injector.inject(M, firer))
					QDEL_NULL(injector)
					return BULLET_ACT_HIT
			else
				blocked = 100
				target.visible_message(span_danger("[src]被偏斜了!"), \
									   span_userdanger("你受到[src]的保护!"))
	return ..()

/obj/projectile/bullet/dnainjector/Destroy()
	QDEL_NULL(injector)
	return ..()
