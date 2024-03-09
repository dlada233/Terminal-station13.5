/obj/item/organ/internal/heart/gland/access
	abductor_hint = "全地形电路扰频器.激活后将给被劫持者体内植入所有的权限."
	cooldown_low = 600
	cooldown_high = 1200
	uses = 1
	icon_state = "mindshock"
	mind_control_uses = 3
	mind_control_duration = 900

/obj/item/organ/internal/heart/gland/access/activate()
	to_chat(owner, span_notice("因为一些原因你感觉自己像个VIP."))
	owner.AddComponent(/datum/component/simple_access, SSid_access.get_region_access_list(list(REGION_ALL_GLOBAL)), src)
