// bonus probability to chase the target granted by eating a supermatter
#define DARK_MATTER_SUPERMATTER_CHANCE_BONUS 10

/// This type of singularity cannot grow as big, but it constantly hunts down living targets.
/obj/singularity/dark_matter
	name = "暗物质奇点"
	desc = "<i>\"它既美丽又可怕，\
		是一个违背所有逻辑的悖论合集. 我不能将目光\
		从它的身上移开，尽管我知道它会\
		瞬间吞噬我们所有人.\
		\"</i><br>- 工程师长迈尔斯·奥布莱恩"
	ghost_notification_message = "IT'S HERE"
	icon_state = "dark_matter_s1"
	singularity_icon_variant = "dark_matter"
	maximum_stage = STAGE_FOUR
	singularity_component_type = /datum/component/singularity/bloodthirsty
	///to avoid cases of the singuloth getting blammed out of existence by the very meteor it rode in on...
	COOLDOWN_DECLARE(initial_explosion_immunity)

/obj/singularity/dark_matter/Initialize(mapload, starting_energy = 250)
	. = ..()
	COOLDOWN_START(src, initial_explosion_immunity, 5 SECONDS)

/obj/singularity/dark_matter/examine(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, initial_explosion_immunity))
		. += span_warning("收到暗物质的保护, [src]视乎对[DisplayTimeText(COOLDOWN_TIMELEFT(src, initial_explosion_immunity))]的爆炸免疫.")
	if(consumed_supermatter)
		. += span_userdanger("它饿了")
	else
		. += span_warning("<i>\"该奇点最令人不安的是它对生物体具有明显的兴趣. 它似乎能感受到它们的存在，并会以惊人的速度向它们移动. \
		我们已经观察到它吸收了我们的一些动植物样本. 奇点似乎并不关心其他无生命的物体或机器，但同样会吸收它们. 我们尝试了各种方式与它沟通，但没有得到任何回应.\
		\"</i><br>- 研究主管贾齐亚·达克斯")

/obj/singularity/dark_matter/ex_act(severity, target)
	if(!COOLDOWN_FINISHED(src, initial_explosion_immunity))
		return FALSE
	return ..()

/obj/singularity/dark_matter/supermatter_upgrade()
	var/datum/component/singularity/resolved_singularity = singularity_component.resolve()
	resolved_singularity.chance_to_move_to_target += DARK_MATTER_SUPERMATTER_CHANCE_BONUS
	name = "黑魔王辛格洛斯"
	desc = "你成功地用暗物质制造了一个奇点，然后你把超物质扔了进去? 你他妈疯了吗? 他妈的，赞美魔王辛格洛斯."
	consumed_supermatter = TRUE

#undef DARK_MATTER_SUPERMATTER_CHANCE_BONUS
