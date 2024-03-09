/obj/item/organ/internal/heart/gland/trauma
	abductor_hint = "白质随机转化器. 被劫持者偶尔会获得最多五次的随机脑部创伤，创伤类型从最基础的到最高级的‘根深蒂固的’都有."
	cooldown_low = 800
	cooldown_high = 1200
	uses = 5
	icon_state = "emp"
	mind_control_uses = 3
	mind_control_duration = 1800

/obj/item/organ/internal/heart/gland/trauma/activate()
	to_chat(owner, span_warning("你感到头一阵剧痛."))
	if(prob(33))
		owner.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
	else
		if(prob(20))
			owner.gain_trauma_type(BRAIN_TRAUMA_SEVERE, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
		else
			owner.gain_trauma_type(BRAIN_TRAUMA_MILD, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
