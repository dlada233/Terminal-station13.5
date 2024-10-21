/obj/machinery/wish_granter
	name = "许愿机"
	desc = "万事皆有可能..."
	icon = 'icons/obj/machines/beacon.dmi'
	icon_state = "syndbeacon"

	use_power = NO_POWER_USE
	density = TRUE

	var/charges = 1
	var/insisting = 0

/obj/machinery/wish_granter/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(charges <= 0)
		to_chat(user, span_boldnotice("许愿机沉默不语."))
		return

	else if(!ishuman(user))
		to_chat(user, span_boldnotice("你感到许愿机内部的黑暗在涌动，这可能不是你想要的东西，此时你比世界上任何人都强烈地感觉到!"))
		return

	else if(is_special_character(user))
		to_chat(user, span_boldnotice("你直面着内心突然翻涌上来的黑暗欲望，你知道这不会有什么好结果，某种本能在让你收手."))

	else if (!insisting)
		to_chat(user, span_boldnotice("你的第一次触碰就会让许愿机苏醒, 倾听你的愿望. 你真的确定要这么做吗?"))
		insisting++

	else
		to_chat(user, span_boldnotice("你说，[pick("我希望空间站消失","人类太过肮脏，必须被毁灭","我希望变得有钱", "我想统治世界","我想要永生.")]. 许愿机答复了."))
		to_chat(user, span_boldnotice("你的头砰砰直跳，视力艰难地恢复着. 你成为了许愿机的化身, 拥有了无穷的力量! 所有的一切都属于你. 你只需要确保没人能夺走它."))

		charges--
		insisting = 0

		user.mind.add_antag_datum(/datum/antagonist/wishgranter)

		to_chat(user, span_warning("你有非常糟糕的预感."))

	return
