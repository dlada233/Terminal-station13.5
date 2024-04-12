/datum/action/cooldown/spell/pointed/burglar_finesse
	name = "夜盗妙术"
	desc = "从目标背包里随机偷一样东西."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "burglarsfinesse"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 40 SECONDS

	invocation = "Y'O'K!"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	cast_range = 4

/datum/action/cooldown/spell/pointed/burglar_finesse/is_valid_target(atom/cast_on)
	return ..() && ishuman(cast_on) && (locate(/obj/item/storage/backpack) in cast_on.contents)

/datum/action/cooldown/spell/pointed/burglar_finesse/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_danger("你感到一股轻微的拉力，除此之外就没有什么了，神圣的力量保护了你."))
		to_chat(owner, span_danger("[cast_on]被神圣力量保护了!"))
		return FALSE

	var/obj/storage_item = locate(/obj/item/storage/backpack) in cast_on.contents

	if(isnull(storage_item))
		return FALSE

	var/item = pick(storage_item.contents)
	if(isnull(item))
		return FALSE

	to_chat(cast_on, span_warning("你的[storage_item]感觉变轻了..."))
	to_chat(owner, span_notice("只是眨眼间，你就将[item]从[cast_on]的[storage_item]中取了出来."))
	owner.put_in_active_hand(item)
