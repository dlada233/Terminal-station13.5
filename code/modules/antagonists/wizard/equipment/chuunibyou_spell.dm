/datum/action/cooldown/spell/chuuni_invocations
    name = "中二吟唱词"
    desc = "让你在释放所有法术时喊出愚蠢施法词，你在施法后会有轻微的恢复效果."
    button_icon_state = "chuuni"

    school = SCHOOL_FORBIDDEN
    cooldown_time = 1 SECONDS

    invocation = "以黑暗之主的名义，我召唤中二的诅咒，让我的所有法术被妄想的力量所玷污！爆裂吧，现实！粉碎吧，精神！"
    invocation_type = INVOCATION_SHOUT
    spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_STATION|SPELL_REQUIRES_MIND
    antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY
    spell_max_level = 1

/datum/action/cooldown/spell/chuuni_invocations/cast(mob/living/cast_on)
    . = ..()

    to_chat(cast_on, span_green("你将青春的思绪融入到魔法的实际应用中去..."))
    if(!do_after(cast_on, 5 SECONDS))
        to_chat(cast_on, span_warning("你沉浸的思绪被打断，日常情景喜剧的感觉慢慢消失."))
        return

    playsound(cast_on, 'sound/effects/bamf.ogg', 75, TRUE, 5)
    to_chat(cast_on, span_danger("你感觉到自己的本质正被绑定到这中二病的日常中去！"))

    cast_on.AddComponent(/datum/component/chuunibyou)

    if(ishuman(cast_on))
        var/mob/living/carbon/human/human_cast_on = cast_on
        human_cast_on.dropItemToGround(human_cast_on.glasses)
        var/obj/item/clothing/head/wizard/wizhat = human_cast_on.head
        if(istype(wizhat))
            to_chat(human_cast_on, span_notice("你的[wizhat]变成了一个眼罩."))
            qdel(wizhat)
        else
            to_chat(human_cast_on, span_notice("一个眼罩突然出现在你的眼睛上."))
        human_cast_on.equip_to_slot_or_del(new /obj/item/clothing/glasses/eyepatch/medical/chuuni(human_cast_on), ITEM_SLOT_EYES)

    qdel(src)
