///AI Upgrades


//Malf Picker
/obj/item/malf_upgrade
	name = "战争升级模块"
	desc = "高度非法、极度危险的AI升级模块，赋予安装AI各种各样的能力，如攻击APC的能力.<br>该升级模块不会覆盖任何有效法律，仅仅作用于一个有效的AI核心."
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "datadisk3"


/obj/item/malf_upgrade/pre_attack(atom/A, mob/living/user, proximity)
	if(!proximity)
		return ..()
	if(!isAI(A))
		return ..()
	var/mob/living/silicon/ai/AI = A
	if(AI.malf_picker)
		AI.malf_picker.processing_time += 50
		to_chat(AI, span_userdanger("[user] has attempted to upgrade you with combat software that you already possess. You gain 50 points to spend on Malfunction Modules instead."))
	else
		to_chat(AI, span_userdanger("[user] has upgraded you with combat software!"))
		to_chat(AI, span_userdanger("Your current laws and objectives remain unchanged.")) //this unlocks malf powers, but does not give the license to plasma flood
		AI.add_malf_picker()
		AI.hack_software = TRUE
		log_silicon("[key_name(user)] has upgraded [key_name(AI)] with a [src].")
		message_admins("[ADMIN_LOOKUPFLW(user)] has upgraded [ADMIN_LOOKUPFLW(AI)] with a [src].")
	to_chat(user, span_notice("You install [src], upgrading [AI]."))
	qdel(src)
	return TRUE


//Lipreading
/obj/item/surveillance_upgrade
	name = "监控升级模块"
	desc = "一个非法的软件包，可以让AI通过读唇语以及启用隐蔽的麦克风来‘听到’摄像头的声音."
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "datadisk3"

/obj/item/surveillance_upgrade/pre_attack(atom/A, mob/living/user, proximity)
	if(!proximity)
		return ..()
	if(!isAI(A))
		return ..()
	var/mob/living/silicon/ai/AI = A
	if(AI.eyeobj)
		AI.eyeobj.relay_speech = TRUE
		to_chat(AI, span_userdanger("[user] has upgraded you with surveillance software!"))
		to_chat(AI, "Via a combination of hidden microphones and lip reading software, you are able to use your cameras to listen in on conversations.")
	to_chat(user, span_notice("You upgrade [AI]. [src] is consumed in the process."))
	user.log_message("has upgraded [key_name(AI)] with a [src].", LOG_GAME)
	message_admins("[ADMIN_LOOKUPFLW(user)] has upgraded [ADMIN_LOOKUPFLW(AI)] with a [src].")
	qdel(src)
	return TRUE
