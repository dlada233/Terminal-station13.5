/datum/action/changeling/digitalcamo
	name = "数码伪装"
	desc = "通过进化出能扭曲形体与比例的能力，在摄像头中用于探测生命形式的图像识别算法对我们不再起作用."
	helptext = "当我们使用该技能时，我们不会被摄像头跟踪，也不会被人工智能单位看到，但若被人类观察到则依然会暴露."
	button_icon_state = "digital_camo"
	dna_cost = 1
	active = FALSE

//Prevents AIs tracking you but makes you easily detectable to the human-eye.
/datum/action/changeling/digitalcamo/sting_action(mob/user)
	..()
	if(active)
		to_chat(user, span_notice("我们变回平常形态."))
		user.RemoveElement(/datum/element/digitalcamo)
	else
		to_chat(user, span_notice("我们扭曲形体来躲避人工智能."))
		user.AddElement(/datum/element/digitalcamo)
	active = !active
	return TRUE

/datum/action/changeling/digitalcamo/Remove(mob/user)
	user.RemoveElement(/datum/element/digitalcamo)
	..()
