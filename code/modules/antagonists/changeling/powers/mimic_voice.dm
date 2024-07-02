/datum/action/changeling/mimicvoice
	name = "声音模仿"
	desc = "我们重新塑造声腺，让它发出我们想要的声音，激活该能力将减缓化学物质的分泌."
	button_icon_state = "mimic_voice"
	helptext = "输入你所要模拟的对象名字就能发出该对象的声音，但必须不断消耗化学物质来维持这种状态."
	chemical_cost = 0//constant chemical drain hardcoded
	dna_cost = 1
	req_human = TRUE

// Fake Voice
/datum/action/changeling/mimicvoice/sting_action(mob/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	if(changeling.mimicing)
		changeling.mimicing = ""
		changeling.chem_recharge_slowdown -= 0.25
		to_chat(user, span_notice("我们将声腺复位."))
		return

	var/mimic_voice = sanitize_name(tgui_input_text(user, "输入模仿对象名字", "模仿声音", max_length = MAX_NAME_LEN))
	if(!mimic_voice)
		return
	..()
	changeling.mimicing = mimic_voice
	changeling.chem_recharge_slowdown += 0.25
	to_chat(user, span_notice("我们塑造声腺来模仿<b>[mimic_voice]</b>的声音，但这将减缓化学物质的分泌."))
	to_chat(user, span_notice("再次使用技能将恢复到原本的声音，化学物质的分泌也将回到正常水平."))
	return TRUE

/datum/action/changeling/mimicvoice/Remove(mob/user)
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(user)
	if(changeling?.mimicing)
		changeling.chem_recharge_slowdown = max(0, changeling.chem_recharge_slowdown - 0.25)
		changeling.mimicing = ""
		to_chat(user, span_notice("我们的声腺复位了"))
	. = ..()
