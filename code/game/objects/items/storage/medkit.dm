/* First aid storage
 * Contains:
 * First Aid Kits
 * Pill Bottles
 * Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 */
/obj/item/storage/medkit
	name = "医疗包"
	desc = "这是给那些严重的问题准备的急救箱."
	icon = 'icons/obj/storage/medkit.dmi'
	icon_state = "medkit"
	inhand_icon_state = "medkit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	var/empty = FALSE
	/// Defines damage type of the medkit. General ones stay null. Used for medibot healing bonuses
	var/damagetype_healed
	/// you just type this in holdables list of medkits instead of copypasting bunch of text.
	var/static/list/list_of_everything_medkits_can_hold = list(
		/obj/item/healthanalyzer,
		/obj/item/dnainjector,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/medigel,
		/obj/item/reagent_containers/spray,
		/obj/item/lighter,
		/obj/item/storage/box/bandages,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/flashlight/pen,
		/obj/item/extinguisher/mini,
		/obj/item/reagent_containers/hypospray,
		/obj/item/sensor_device,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/lazarus_injector,
		/obj/item/bikehorn/rubberducky,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/mask/breath/medical,
		/obj/item/surgical_drapes,
		/obj/item/scalpel,
		/obj/item/circular_saw,
		/obj/item/bonesetter,
		/obj/item/surgicaldrill,
		/obj/item/retractor,
		/obj/item/cautery,
		/obj/item/hemostat,
		/obj/item/blood_filter,
		/obj/item/shears,
		/obj/item/geiger_counter,
		/obj/item/clothing/neck/stethoscope,
		/obj/item/stamp,
		/obj/item/clothing/glasses,
		/obj/item/wrench/medical,
		/obj/item/clothing/mask/muzzle,
		/obj/item/reagent_containers/blood,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/gun/syringe/syndicate,
		/obj/item/implantcase,
		/obj/item/implant,
		/obj/item/implanter,
		/obj/item/pinpointer/crew,
		/obj/item/holosign_creator/medical,
		/obj/item/stack/sticky_tape,
	)

/obj/item/storage/medkit/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL

/obj/item/storage/medkit/regular
	icon_state = "medkit"
	desc = "一个能够治愈常见伤害的急救箱."

/obj/item/storage/medkit/regular/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]用[src]给你做了什么! 这是一种自杀行为!"))
	return BRUTELOSS

/obj/item/storage/medkit/regular/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/healthanalyzer/simple = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/emergency
	icon_state = "medbriefcase"
	name = "急救箱"
	desc = "一个非常简单的急救箱，只能用来固定和稳定严重的伤口，以便以后治疗."

/obj/item/storage/medkit/emergency/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/healthanalyzer/simple = 1,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/suture/emergency = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 2,
		/obj/item/storage/pill_bottle/iron = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/surgery
	name = "手术医疗箱"
	icon_state = "medkit_surgery"
	inhand_icon_state = "medkit"
	desc = "医生的高容量急救箱，装满医疗用品和基本手术设备."

/obj/item/storage/medkit/surgery/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL //holds the same equipment as a medibelt
	atom_storage.max_slots = 12
	atom_storage.max_total_storage = 24
	atom_storage.set_holdable(list_of_everything_medkits_can_hold)

/obj/item/storage/medkit/surgery/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/stack/medical/gauze/twelve = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/cautery = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/ancient
	icon_state = "oldfirstaid"
	desc = "一个能够治愈常见伤害的急救箱."

/obj/item/storage/medkit/ancient/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment= 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/ancient/heirloom
	desc = "一个能够治愈常见伤害的急救箱，只要看着它，你就会开始想起过去的美好时光."
	empty = TRUE // long since been ransacked by hungry powergaming assistants breaking into med storage

/obj/item/storage/medkit/fire
	name = "烧伤医疗箱"
	desc = "特制的医疗箱为军械实验室<i>-意外地-</i>烧毁使使用."
	icon_state = "medkit_burn"
	inhand_icon_state = "medkit-ointment"
	damagetype_healed = BURN

/obj/item/storage/medkit/fire/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始用[src]摩擦自己! 看起来是要生火!"))
	return FIRELOSS

/obj/item/storage/medkit/fire/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/pill/patch/aiuri = 3,
		/obj/item/reagent_containers/spray/hercuri = 1,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/toxin
	name = "毒素医疗箱"
	desc = "用于治疗血液中的毒素和辐射中毒."
	icon_state = "medkit_toxin"
	inhand_icon_state = "medkit-toxin"
	damagetype_healed = TOX

/obj/item/storage/medkit/toxin/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始舔[src]的含铅油漆! 这是一种自杀行为."))
	return TOXLOSS


/obj/item/storage/medkit/toxin/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/storage/pill_bottle/multiver/less = 1,
		/obj/item/reagent_containers/syringe/syriniver = 3,
		/obj/item/storage/pill_bottle/potassiodide = 1,
		/obj/item/reagent_containers/hypospray/medipen/penacid = 1,
		/obj/item/healthanalyzer/simple/disease = 1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/o2
	name = "窒息医疗箱"
	desc = "一个装满氧气的盒子."
	icon_state = "medkit_o2"
	inhand_icon_state = "medkit-o2"
	damagetype_healed = OXY

/obj/item/storage/medkit/o2/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始用[src]攻击自己的脖子! 这是一种自杀行为."))
	return OXYLOSS

/obj/item/storage/medkit/o2/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/syringe/convermol = 3,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/storage/pill_bottle/iron = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/brute
	name = "创伤医疗箱"
	desc = "一个急救箱，当你需要工具箱的时候."
	icon_state = "medkit_brute"
	inhand_icon_state = "medkit-brute"
	damagetype_healed = BRUTE

/obj/item/storage/medkit/brute/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始用[src]打自己的头! 这是一种自杀行为."))
	return BRUTELOSS

/obj/item/storage/medkit/brute/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/pill/patch/libital = 3,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/storage/pill_bottle/probital = 1,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 1,
		/obj/item/healthanalyzer/simple = 1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/advanced
	name = "先进急救箱"
	desc = "一个先进的工具来帮助处理严重的伤口."
	icon_state = "medkit_advanced"
	inhand_icon_state = "medkit-rad"
	custom_premium_price = PAYCHECK_COMMAND * 6
	damagetype_healed = HEAL_ALL_DAMAGE

/obj/item/storage/medkit/advanced/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/pill/patch/synthflesh = 3,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/stack/medical/gauze = 1,
		/obj/item/storage/pill_bottle/penacid = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/tactical
	name = "战斗医疗箱"
	desc = "我希望你有保险."
	icon_state = "medkit_tactical"
	inhand_icon_state = "medkit-tactical"
	damagetype_healed = HEAL_ALL_DAMAGE

/obj/item/storage/medkit/tactical/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_slots = 21
	atom_storage.max_total_storage = 24
	atom_storage.set_holdable(list_of_everything_medkits_can_hold)

/obj/item/storage/medkit/tactical/PopulateContents()
	if(empty)
		return
	var/static/list/items_inside = list(
		/obj/item/cautery = 1,
		/obj/item/scalpel = 1,
		/obj/item/healthanalyzer/advanced = 1,
		/obj/item/hemostat = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/storage/box/bandages = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/stack/medical/gauze = 2,
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 2,
		/obj/item/reagent_containers/pill/patch/libital = 4,
		/obj/item/reagent_containers/pill/patch/aiuri = 4,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/tactical/premium
	name = "先进战斗医疗箱"
	desc = "可能含有或不含有微量铅."
	grind_results = list(/datum/reagent/lead = 10)

/obj/item/storage/medkit/tactical/premium/Initialize(mapload)
	. = ..()
	atom_storage.allow_big_nesting = TRUE // so you can put back the box you took out
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_slots = 21
	atom_storage.max_total_storage = 34
	atom_storage.set_holdable(list_of_everything_medkits_can_hold)

/obj/item/storage/medkit/tactical/premium/PopulateContents()
	if(empty)
		return
	var/static/list/items_inside = list(
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 2,
		/obj/item/reagent_containers/pill/patch/libital = 3,
		/obj/item/reagent_containers/pill/patch/aiuri = 3,
		/obj/item/healthanalyzer/advanced = 1,
		/obj/item/stack/medical/gauze = 2,
		/obj/item/mod/module/thread_ripper = 1,
		/obj/item/mod/module/surgical_processor/preloaded = 1,
		/obj/item/mod/module/defibrillator/combat = 1,
		/obj/item/mod/module/health_analyzer = 1,
		/obj/item/autosurgeon/syndicate/emaggedsurgerytoolset = 1,
		/obj/item/reagent_containers/hypospray/combat/empty = 1,
		/obj/item/storage/box/bandages = 1,
		/obj/item/storage/box/evilmeds = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/clothing/glasses/hud/health/night/science = 1,
	)
	generate_items_inside(items_inside,src)
	list_of_everything_medkits_can_hold += items_inside

/obj/item/storage/medkit/coroner
	name = "紧凑型验尸医疗箱"
	desc = "一种较小的医疗箱，主要用于帮助解剖死者，而不是治疗生者."
	icon = 'icons/obj/storage/medkit.dmi'
	icon_state = "compact_coronerkit"
	inhand_icon_state = "coronerkit"

/obj/item/storage/medkit/coroner/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.max_slots = 14
	atom_storage.max_total_storage = 24
	atom_storage.set_holdable(list(
		/obj/item/reagent_containers,
		/obj/item/bodybag,
		/obj/item/toy/crayon,
		/obj/item/pen,
		/obj/item/paper,
		/obj/item/surgical_drapes,
		/obj/item/scalpel,
		/obj/item/retractor,
		/obj/item/hemostat,
		/obj/item/cautery,
		/obj/item/autopsy_scanner,
	))

/obj/item/storage/medkit/coroner/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/reagent_containers/cup/bottle/formaldehyde = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/reagent_containers/blood = 1,
		/obj/item/bodybag = 2,
		/obj/item/reagent_containers/syringe = 1,
	)
	generate_items_inside(items_inside,src)

//medibot assembly
/obj/item/storage/medkit/attackby(obj/item/bodypart/bodypart, mob/user, params)
	if((!istype(bodypart, /obj/item/bodypart/arm/left/robot)) && (!istype(bodypart, /obj/item/bodypart/arm/right/robot)))
		return ..()

	//Making a medibot!
	if(contents.len >= 1)
		balloon_alert(user, "内有物品!")
		return

	///if you add a new one don't forget to update /datum/crafting_recipe/medbot/on_craft_completion()
	var/obj/item/bot_assembly/medbot/medbot_assembly = new
	if (istype(src, /obj/item/storage/medkit/fire))
		medbot_assembly.set_skin("ointment")
	else if (istype(src, /obj/item/storage/medkit/toxin))
		medbot_assembly.set_skin("tox")
	else if (istype(src, /obj/item/storage/medkit/o2))
		medbot_assembly.set_skin("o2")
	else if (istype(src, /obj/item/storage/medkit/brute))
		medbot_assembly.set_skin("brute")
	else if (istype(src, /obj/item/storage/medkit/advanced))
		medbot_assembly.set_skin("advanced")
	else if (istype(src, /obj/item/storage/medkit/tactical))
		medbot_assembly.set_skin("bezerk")
	user.put_in_hands(medbot_assembly)
	medbot_assembly.balloon_alert(user, "arm added")
	medbot_assembly.robot_arm = bodypart.type
	medbot_assembly.medkit_type = type
	qdel(bodypart)
	qdel(src)

/*
 * Pill Bottles
 */

/obj/item/storage/pill_bottle
	name = "药瓶"
	desc = "这是一个储存药物的密闭容器."
	icon_state = "pill_canister"
	icon = 'icons/obj/medical/chemical.dmi'
	inhand_icon_state = "contsolid"
	worn_icon_state = "nothing"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/pill_bottle/Initialize(mapload)
	. = ..()
	atom_storage.allow_quick_gather = TRUE
	atom_storage.set_holdable(list(
		/obj/item/reagent_containers/pill,
		/obj/item/food/bait/natural,
	))

/obj/item/storage/pill_bottle/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]试图打开[src]的盖子! 这是一种自杀行为."))
	return TOXLOSS

/obj/item/storage/pill_bottle/multiver
	name = "multiver-木太尔药瓶"
	desc = "含有用于净化毒素的药丸."

/obj/item/storage/pill_bottle/multiver/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/multiver(src)

/obj/item/storage/pill_bottle/multiver/less

/obj/item/storage/pill_bottle/multiver/less/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/multiver(src)

/obj/item/storage/pill_bottle/epinephrine
	name = "epinephrine-肾上腺素药瓶"
	desc = "含有稳定病人的药片."

/obj/item/storage/pill_bottle/epinephrine/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/epinephrine(src)

/obj/item/storage/pill_bottle/mutadone
	name = "mutadone-突变稳定啶瓶"
	desc = "含有用于治疗基因不稳定的药丸."

/obj/item/storage/pill_bottle/mutadone/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/mutadone(src)

/obj/item/storage/pill_bottle/potassiodide
	name = "potassium iodide-碘化钾药瓶"
	desc = "含有用于治疗辐射病的药丸."

/obj/item/storage/pill_bottle/potassiodide/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/potassiodide(src)

/obj/item/storage/pill_bottle/probital
	name = "probital-疗素药瓶"
	desc = "含有用于缓慢治疗撕裂伤的药丸，瓶子的说明标签上写着'可能会引起疲劳'."

/obj/item/storage/pill_bottle/probital/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/reagent_containers/pill/probital(src)

/obj/item/storage/pill_bottle/iron
	name = "iron-铁药瓶"
	desc = "含有用于缓慢补充血液含量的药丸，瓶子的说明标签上写着'每五分钟只服用一颗'."

/obj/item/storage/pill_bottle/iron/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/reagent_containers/pill/iron(src)

/obj/item/storage/pill_bottle/mannitol
	name = "mannitol-甘露醇药瓶"
	desc = "含有用于治疗脑损伤的药丸."

/obj/item/storage/pill_bottle/mannitol/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/mannitol(src)

//Contains 4 pills instead of 7, and 5u pills instead of 50u (50u pills heal 250 brain damage, 5u pills heal 25)
/obj/item/storage/pill_bottle/mannitol/braintumor
	desc = "含有用于治疗脑肿瘤症状的稀释药片，头晕时吃一片."

/obj/item/storage/pill_bottle/mannitol/braintumor/PopulateContents()
	for(var/i in 1 to 4)
		new /obj/item/reagent_containers/pill/mannitol/braintumor(src)

/obj/item/storage/pill_bottle/stimulant
	name = "stimulant-兴奋剂药瓶"
	desc = "保证在长时间的轮班中给你额外的能量爆发!"

/obj/item/storage/pill_bottle/stimulant/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/stimulant(src)

/obj/item/storage/pill_bottle/sansufentanyl
	name = "实验药丸瓶"
	desc = "由Interdyne制药公司开发，其中药物用于治疗多种遗传性疾病."

/obj/item/storage/pill_bottle/sansufentanyl/PopulateContents()
	for(var/i in 1 to 6)
		new /obj/item/reagent_containers/pill/sansufentanyl(src)

/obj/item/storage/pill_bottle/mining
	name = "贴片瓶"
	desc = "包含用于处理创伤和烧伤的补丁."

/obj/item/storage/pill_bottle/mining/PopulateContents()
	new /obj/item/reagent_containers/pill/patch/aiuri(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/patch/libital(src)

/obj/item/storage/pill_bottle/zoom
	name = "可疑的药瓶"
	desc = "标签旧到几乎看不清，你能认出一些化合物."

/obj/item/storage/pill_bottle/zoom/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/zoom(src)

/obj/item/storage/pill_bottle/happy
	name = "可疑的药瓶"
	desc = "上面有一个笑脸."

/obj/item/storage/pill_bottle/happy/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/happy(src)

/obj/item/storage/pill_bottle/lsd
	name = "可疑的药瓶"
	desc = "上面有一些很潦草的涂鸦，可能是一个蘑菇，也可能是一个变了形的月亮."

/obj/item/storage/pill_bottle/lsd/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/lsd(src)

/obj/item/storage/pill_bottle/aranesp
	name = "可疑的药瓶"
	desc = "标签上用黑色马克笔潦草地写着'fuck disablers'."

/obj/item/storage/pill_bottle/aranesp/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/aranesp(src)

/obj/item/storage/pill_bottle/psicodine
	name = "可疑的药瓶"
	desc = "内含用于治疗精神痛苦和创伤的药片."

/obj/item/storage/pill_bottle/psicodine/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/psicodine(src)

/obj/item/storage/pill_bottle/penacid
	name = "pentetic acid-戊酸药瓶"
	desc = "内含能清楚辐射和毒素的药丸."

/obj/item/storage/pill_bottle/penacid/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/pill/penacid(src)


/obj/item/storage/pill_bottle/neurine
	name = "neurine-神经碱药瓶"
	desc = "含有治疗非严重精神创伤的药片."

/obj/item/storage/pill_bottle/neurine/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/neurine(src)

/obj/item/storage/pill_bottle/maintenance_pill
	name = "维护管道药瓶"
	desc = "一个旧药瓶，闻起来有霉味."

/obj/item/storage/pill_bottle/maintenance_pill/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/pill/P = locate() in src
	name = "[P.name]药瓶"

/obj/item/storage/pill_bottle/maintenance_pill/PopulateContents()
	for(var/i in 1 to rand(1,7))
		new /obj/item/reagent_containers/pill/maintenance(src)

/obj/item/storage/pill_bottle/maintenance_pill/full/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/pill/maintenance(src)

///////////////////////////////////////// Psychologist inventory pillbottles
/obj/item/storage/pill_bottle/happinesspsych
	name = "快乐药丸"
	desc = "含有药片，作为最后的手段，暂时稳定抑郁和焦虑；警告:副作用可能包括口齿不清、流口水和严重上瘾."

/obj/item/storage/pill_bottle/happinesspsych/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/happinesspsych(src)

/obj/item/storage/pill_bottle/lsdpsych
	name = "销魂毒素药丸"
	desc = "!仅供治疗使用! 内含减轻现实分离综合症的药片."

/obj/item/storage/pill_bottle/lsdpsych/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/lsdpsych(src)

/obj/item/storage/pill_bottle/paxpsych
	name = "重熙药丸"
	desc = "含有用于暂时安抚对自己或他人造成伤害的患者的药丸，暂时消除他们的暴力倾向."

/obj/item/storage/pill_bottle/paxpsych/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/paxpsych(src)

/obj/item/storage/pill_bottle/naturalbait
	name = "新鲜的罐子"
	desc = "全是天然鱼饵."

/obj/item/storage/pill_bottle/naturalbait/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/food/bait/natural(src)

/obj/item/storage/pill_bottle/ondansetron
	name = "枢复宁贴片"
	desc = "一种装有昂丹司琼片的瓶子，一种用于治疗恶心和呕吐的药物，可能引起嗜睡."

/obj/item/storage/pill_bottle/ondansetron/PopulateContents()
	for(var/i in 1 to 5)
		new /obj/item/reagent_containers/pill/patch/ondansetron(src)

/// A box which takes in coolant and uses it to preserve organs and body parts
/obj/item/storage/organbox
	name = "器官运送箱"
	desc = "一种先进的装有冷却装置的冷藏箱，使用冰甾烷或其他冷试剂来保存里面的器官或身体部位."
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "organbox"
	base_icon_state = "organbox"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	custom_premium_price = PAYCHECK_CREW * 4
	/// var to prevent it freezing the same things over and over
	var/cooling = FALSE

/obj/item/storage/organbox/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/organ_box, max_specific_storage = WEIGHT_CLASS_BULKY, max_total_storage = 21)
	atom_storage.set_holdable(list(
		/obj/item/organ,
		/obj/item/bodypart,
		/obj/item/food/icecream
		))

	create_reagents(100, TRANSPARENT)
	START_PROCESSING(SSobj, src)

/obj/item/storage/organbox/process(seconds_per_tick)
	///if there is enough coolant var
	var/using_coolant = coolant_to_spend()
	if (isnull(using_coolant))
		if (cooling)
			cooling = FALSE
			update_appearance()
			for(var/obj/stored in contents)
				stored.unfreeze()
		return

	var/amount_used = 0.05 * seconds_per_tick
	if (using_coolant != /datum/reagent/cryostylane)
		amount_used *= 2
	reagents.remove_reagent(using_coolant, amount_used)

	if(cooling)
		return
	cooling = TRUE
	update_appearance()
	for(var/obj/stored in contents)
		stored.freeze()

/// Returns which coolant we are about to use, or null if there isn't any
/obj/item/storage/organbox/proc/coolant_to_spend()
	if (reagents.get_reagent_amount(/datum/reagent/cryostylane))
		return /datum/reagent/cryostylane
	if (reagents.get_reagent_amount(/datum/reagent/consumable/ice))
		return /datum/reagent/consumable/ice
	return null

/obj/item/storage/organbox/update_icon_state()
	icon_state = "[base_icon_state][cooling ? "-working" : null]"
	return ..()

/obj/item/storage/organbox/attackby(obj/item/I, mob/user, params)
	if(is_reagent_container(I) && I.is_open_container())
		var/obj/item/reagent_containers/RC = I
		var/units = RC.reagents.trans_to(src, RC.amount_per_transfer_from_this, transferred_by = user)
		if(units)
			balloon_alert(user, "[units]u 已转移")
			return
	if(istype(I, /obj/item/plunger))
		balloon_alert(user, "plunging...")
		if(do_after(user, 10, target = src))
			balloon_alert(user, "plunged")
			reagents.clear_reagents()
		return
	return ..()

/obj/item/storage/organbox/suicide_act(mob/living/carbon/user)
	if(HAS_TRAIT(user, TRAIT_RESISTCOLD)) //if they're immune to cold, just do the box suicide
		var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
		if(myhead)
			user.visible_message(span_suicide("[user]把头放进[src]并试图关上! 这是一种自杀行为."))
			myhead.dismember()
			myhead.forceMove(src) //force your enemies to kill themselves with your head collection box!
			playsound(user, "desecration-01.ogg", 50, TRUE, -1)
			return BRUTELOSS
		user.visible_message(span_suicide("[user]用[src]攻击自己! 这是一种自杀行为."))
		return BRUTELOSS
	user.visible_message(span_suicide("[user]把头放进[src], 这是一种自杀行为."))
	user.adjust_bodytemperature(-300)
	user.apply_status_effect(/datum/status_effect/freon)
	return FIRELOSS

/// A subtype of organ storage box which starts with a full coolant tank
/obj/item/storage/organbox/preloaded

/obj/item/storage/organbox/preloaded/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/cryostylane, reagents.maximum_volume)

/obj/item/storage/test_tube_rack
	name = "试管架"
	desc = "存放试管的木架."
	icon_state = "rack"
	base_icon_state = "rack"
	icon = 'icons/obj/medical/chemical.dmi'
	inhand_icon_state = "contsolid"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/test_tube_rack/Initialize(mapload)
	. = ..()
	atom_storage.allow_quick_gather = TRUE
	atom_storage.max_slots = 8
	atom_storage.screen_max_columns = 4
	atom_storage.screen_max_rows = 2
	atom_storage.set_holdable(list(
		/obj/item/reagent_containers/cup/tube,
	))

/obj/item/storage/test_tube_rack/attack_self(mob/user)
	emptyStorage()

/obj/item/storage/test_tube_rack/update_icon_state()
	icon_state = "[base_icon_state][contents.len > 0 ? contents.len : null]"
	return ..()
