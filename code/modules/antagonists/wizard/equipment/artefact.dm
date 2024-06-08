
//学徒合同 - 移动到antag_spawner.dm

///////////////////////////帷幕破隙圆刃//////////////////////

/obj/item/veilrender
    name = "帷幕破隙圆刃"
    desc = "来自异星的奇异圆刃，回收自某个已化为废墟的庞大城市."
    icon = 'icons/obj/weapons/khopesh.dmi'
    icon_state = "bone_blade"
    inhand_icon_state = "bone_blade"
    worn_icon_state = "bone_blade"
    lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
    righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
    inhand_x_dimension = 64
    inhand_y_dimension = 64
    force = 15
    throwforce = 10
    w_class = WEIGHT_CLASS_NORMAL
    hitsound = 'sound/weapons/bladeslice.ogg'
    var/charges = 1
    var/spawn_type = /obj/tear_in_reality
    var/spawn_amt = 1
    var/activate_descriptor = "现实"
    var/rend_desc = "你应该立刻逃跑."
    var/spawn_fast = FALSE //如果为TRUE，则忽略在生成之前检查位置上的生物

/obj/item/veilrender/attack_self(mob/user)
    if(charges > 0)
        new /obj/effect/rend(get_turf(user), spawn_type, spawn_amt, rend_desc, spawn_fast)
        charges--
        user.visible_message(span_boldannounce("[user]的[src]在切开[activate_descriptor]时仍充盈着能量."))
    else
        to_chat(user, span_danger("圆刃的奇异能量现在消散无踪了."))

/obj/effect/rend
    name = "现实裂隙"
    desc = "你可以逃跑了."
    icon = 'icons/effects/effects.dmi'
    icon_state = "rift"
    density = TRUE
    anchored = TRUE
    var/spawn_path = /mob/living/basic/cow //默认生成牛以防止意外生成纳尔希
    var/spawn_amt_left = 20
    var/spawn_fast = FALSE

/obj/effect/rend/Initialize(mapload, spawn_type, spawn_amt, desc, spawn_fast)
    . = ..()
    src.spawn_path = spawn_type
    src.spawn_amt_left = spawn_amt
    src.desc = desc
    src.spawn_fast = spawn_fast
    START_PROCESSING(SSobj, src)

/obj/effect/rend/process()
    if(!spawn_fast)
        if(locate(/mob) in loc)
            return
    new spawn_path(loc)
    spawn_amt_left--
    if(spawn_amt_left <= 0)
        qdel(src)

/obj/effect/rend/attackby(obj/item/I, mob/user, params)
    if(istype(I, /obj/item/nullrod))
        user.visible_message(span_danger("[user]使用[I]封印了[src]."))
        qdel(src)
        return
    else
        return ..()

/obj/effect/rend/singularity_act()
    return

/obj/effect/rend/singularity_pull()
    return

/obj/item/veilrender/vealrender
    name = "牛肉破隙圆刃"
    desc = "来自异星的奇异圆刃，回收自某个已化为废墟的庞大农场."
    spawn_type = /mob/living/basic/cow
    spawn_amt = 20
    activate_descriptor = "饥饿"
    rend_desc = "回荡着一万头牛的叫声."

/obj/item/veilrender/honkrender
    name = "滑稽破隙圆刃"
    desc = "来自异星的奇异圆刃，回收自某个已化为废墟的庞大马戏团."
    spawn_type = /mob/living/basic/clown
    spawn_amt = 10
    activate_descriptor = "沮丧"
    rend_desc = "轻轻飘荡着无尽笑声."
    icon_state = "banana_blade"
    inhand_icon_state = "banana_blade"
    worn_icon_state = "render"

/obj/item/veilrender/honkrender/honkhulkrender
    name = "高级滑稽破隙圆刃"
    desc = "来自异星的奇异圆刃，回收自某个已化为废墟的庞大马戏团，刃锋中闪耀着不同寻常的光芒."
    spawn_type = /mob/living/basic/clown/clownhulk
    spawn_amt = 5
    activate_descriptor = "沮丧"
    rend_desc = "轻轻飘荡着愉悦的哼叫."

#define TEAR_IN_REALITY_CONSUME_RANGE 3
#define TEAR_IN_REALITY_SINGULARITY_SIZE STAGE_FOUR

/// 由虚空裂隙之刃生成的现实裂隙
/obj/tear_in_reality
    name = "现实裂隙"
    desc = "这不对劲."
    icon = 'icons/effects/224x224.dmi'
    icon_state = "reality"
    pixel_x = -96
    pixel_y = -96
    anchored = TRUE
    density = TRUE
    move_resist = INFINITY
    plane = MASSIVE_OBJ_PLANE
    plane = ABOVE_LIGHTING_PLANE
    light_range = 6
    appearance_flags = LONG_GLIDE
    resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
    obj_flags = CAN_BE_HIT | DANGEROUS_POSSESSION

/obj/tear_in_reality/Initialize(mapload)
    . = ..()

    AddComponent(
        /datum/component/singularity, \
        consume_range = TEAR_IN_REALITY_CONSUME_RANGE, \
        notify_admins = !mapload, \
        roaming = FALSE, \
        singularity_size = TEAR_IN_REALITY_SINGULARITY_SIZE, \
    )

/obj/tear_in_reality/attack_tk(mob/user)
    if(!iscarbon(user))
        return
    . = COMPONENT_CANCEL_ATTACK_CHAIN
    var/mob/living/carbon/jedi = user
    if(jedi.mob_mood.sanity < 15)
        return //他们已经看到了并且快要死了，或者已经太疯狂了，无法在意
    to_chat(jedi, span_userdanger("哦，天哪！这不是真的！这一切都不是真的！！！！！！！！！！！！！！！"))
    jedi.mob_mood.sanity = 0
    for(var/lore in typesof(/datum/brain_trauma/severe))
        jedi.gain_trauma(lore)
    addtimer(CALLBACK(src, PROC_REF(deranged), jedi), 10 SECONDS)

/obj/tear_in_reality/proc/deranged(mob/living/carbon/C)
    if(!C || C.stat == DEAD)
        return
    C.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 0, distance = 3)
    C.spew_organ(3, 2)
    C.investigate_log("因在现实裂隙上使用心灵遥感而死亡.", INVESTIGATE_DEATHS)
    C.death()

#undef TEAR_IN_REALITY_CONSUME_RANGE
#undef TEAR_IN_REALITY_SINGULARITY_SIZE

/////////////////////////////////////////占卜///////////////////

/obj/item/scrying
    name = "洞悉之球"
    desc = "发出炫目蓝光的能量球体，仅仅握住它就能让你拥有远超凡人的视力和听觉，凝视它则能让你看到整个宇宙."
    icon = 'icons/obj/weapons/guns/projectiles.dmi'
    icon_state ="bluespace"
    throw_speed = 3
    throw_range = 7
    throwforce = 15
    damtype = BURN
    force = 15
    hitsound = 'sound/items/welder2.ogg'

    var/mob/current_owner

/obj/item/scrying/Initialize(mapload)
    . = ..()
    START_PROCESSING(SSobj, src)

/obj/item/scrying/Destroy()
    STOP_PROCESSING(SSobj, src)
    return ..()

/obj/item/scrying/process()
    var/mob/holder = get(loc, /mob)
    if(current_owner && current_owner != holder)

        to_chat(current_owner, span_notice("你的超人视力消失了..."))

        current_owner.remove_traits(list(TRAIT_SIXTHSENSE, TRAIT_XRAY_VISION), SCRYING_ORB)
        current_owner.update_sight()

        current_owner = null

    if(!current_owner && holder)
        current_owner = holder

        to_chat(current_owner, span_notice("你可以看到...一切！"))

        current_owner.add_traits(list(TRAIT_SIXTHSENSE, TRAIT_XRAY_VISION), SCRYING_ORB)
        current_owner.update_sight()

/obj/item/scrying/attack_self(mob/user)
    visible_message(span_danger("[user]凝视着[src]，眼神变得呆滞起来."))
    user.ghostize(1)

/////////////////////////////////////////不死石///////////////////

/obj/item/necromantic_stone
    name = "不死石"
    desc = "将死人复活为骷髅仆从的石头."
    icon = 'icons/obj/mining_zones/artefacts.dmi'
    icon_state = "necrostone"
    inhand_icon_state = "electronic"
    lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
    righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
    w_class = WEIGHT_CLASS_TINY
    var/list/spooky_scaries = list()
    ///允许生产无限数量的奴仆.
    var/unlimited = FALSE
    ///复活的人形生物的种族.
    var/applied_species = /datum/species/skeleton
    ///复活的人形生物将穿的装备.
    var/applied_outfit = /datum/outfit/roman
    ///可以创建的最大奴仆数量.
    var/max_thralls = 3

/obj/item/necromantic_stone/unlimited
    unlimited = 1

/obj/item/necromantic_stone/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
    if(!istype(target))
        return ..()

    if(!istype(user) || !user.can_perform_action(target))
        return

    if(target.stat != DEAD)
        to_chat(user, span_warning("这东西只对死人起作用！"))
        return

    for(var/mob/dead/observer/ghost in GLOB.dead_mob_list) // 排除新玩家
        if(ghost.mind && ghost.mind.current == target && ghost.client) // 死亡的角色列表可能包含没有客户端的角色
            ghost.reenter_corpse()
            break

    if(!target.mind || !target.client)
        to_chat(user, span_warning("这具身体没有连接的灵魂..."))
        return

    check_spooky() // 清理/刷新列表
    if(spooky_scaries.len >= max_thralls && !unlimited)
        to_chat(user, span_warning("不死石只能同时维持[convert_integer_to_words(max_thralls)]个仆从！"))
        return
    if(applied_species)
        target.set_species(applied_species, icon_update=0)
    target.revive(ADMIN_HEAL_ALL)
    spooky_scaries |= target
    to_chat(target, span_userdanger("你被<B>[user.real_name]</B>复活了！"))
    to_chat(target, span_userdanger("[user.real_name]现在是你至高无上的主人，无条件地追随主人，即便再死一次！"))
    var/datum/antagonist/wizard/antag_datum = user.mind.has_antag_datum(/datum/antagonist/wizard)
    if(antag_datum)
        if(!antag_datum.wiz_team)
            antag_datum.create_wiz_team()
        target.mind.add_antag_datum(/datum/antagonist/wizard_minion, antag_datum.wiz_team)

    equip_revived_servant(target)

/obj/item/necromantic_stone/examine(mob/user)
    . = ..()
    if(!unlimited)
        . += span_notice("[spooky_scaries.len]/[max_thralls]个活跃的仆从.")

/obj/item/necromantic_stone/proc/check_spooky()
    if(unlimited) // 无意义，列表未使用.
        return

    for(var/X in spooky_scaries)
        if(!ishuman(X))
            spooky_scaries.Remove(X)
            continue
        var/mob/living/carbon/human/H = X
        if(H.stat == DEAD)
            H.dust(TRUE)
            spooky_scaries.Remove(X)
            continue
    list_clear_nulls(spooky_scaries)

/obj/item/necromantic_stone/proc/equip_revived_servant(mob/living/carbon/human/human)
    if(!applied_outfit)
        return
    for(var/obj/item/worn_item in human)
        human.dropItemToGround(worn_item)

    human.equipOutfit(applied_outfit)

//有趣的小花招，骷髅总是穿着罗马/古代盔甲
/datum/outfit/roman
    name = "罗马士兵"
    head = /obj/item/clothing/head/helmet/roman
    uniform = /obj/item/clothing/under/costume/roman
    shoes = /obj/item/clothing/shoes/roman
    back = /obj/item/spear
    r_hand = /obj/item/claymore
    l_hand = /obj/item/shield/roman

/datum/outfit/roman/pre_equip(mob/living/carbon/human/H, visualsOnly)
    . = ..()
    head = pick(/obj/item/clothing/head/helmet/roman, /obj/item/clothing/head/helmet/roman/legionnaire)

//提供一个不错的治疗效果，每6秒需要泵一次
/obj/item/organ/internal/heart/cursed/wizard
    pump_delay = 6 SECONDS
    heal_brute = 25
    heal_burn = 25
    heal_oxy = 25

///传送哨子，召唤一个龙卷风传送你
/obj/item/warp_whistle
    name = "传送哨"
    desc = "召唤一阵风将你吹到站内的随机位置."
    icon = 'icons/obj/art/musician.dmi'
    icon_state = "whistle"

    /// 使用传送哨子的人
    var/mob/living/whistler

/obj/item/warp_whistle/attack_self(mob/user)
    if(whistler)
        to_chat(user, span_warning("[src]正在冷却中."))
        return

    whistler = user
    var/turf/current_turf = get_turf(user)
    var/turf/spawn_location = locate(user.x + pick(-7, 7), user.y, user.z)
    playsound(current_turf, 'sound/magic/warpwhistle.ogg', 200, TRUE)
    new /obj/effect/temp_visual/teleporting_tornado(spawn_location, src)

///传送龙卷风，由传送哨子生成，如果它们设法接住用户则传送用户.
/obj/effect/temp_visual/teleporting_tornado
    name = "龙卷风"
    desc = "这东西吸人吸得很厉害！"
    icon = 'icons/effects/magic.dmi'
    icon_state = "tornado"
    layer = FLY_LAYER
    plane = ABOVE_GAME_PLANE
    randomdir = FALSE
    duration = 8 SECONDS
    movement_type = PHASING

    /// 引用传送哨子
    var/obj/item/warp_whistle/whistle
    /// 当前由龙卷风携带的所有角色列表.
    var/list/pickedup_mobs = list()

/obj/effect/temp_visual/teleporting_tornado/Initialize(mapload, obj/item/warp_whistle/whistle)
    . = ..()
    src.whistle = whistle
    if(!whistle)
        qdel(src)
        return
    RegisterSignal(src, COMSIG_MOVABLE_CROSS_OVER, PROC_REF(check_teleport))
    SSmove_manager.move_towards(src, get_turf(whistle.whistler))

///检查龙卷风经过的任何东西是否为创建者.
/obj/effect/temp_visual/teleporting_tornado/proc/check_teleport(datum/source, atom/movable/crossed)
    SIGNAL_HANDLER
    if(crossed != whistle.whistler || (crossed in pickedup_mobs))
        return

    pickedup_mobs += crossed
    buckle_mob(crossed, TRUE, FALSE)
    ADD_TRAIT(crossed, TRAIT_INCAPACITATED, WARPWHISTLE_TRAIT)
    animate(src, alpha = 20, pixel_y = 400, time = 3 SECONDS)
    animate(crossed, pixel_y = 400, time = 3 SECONDS)
    addtimer(CALLBACK(src, PROC_REF(send_away)), 2 SECONDS)

/obj/effect/temp_visual/teleporting_tornado/proc/send_away()
    var/turf/ending_turfs = find_safe_turf()
    for(var/mob/stored_mobs as anything in pickedup_mobs)
        do_teleport(stored_mobs, ending_turfs, channel = TELEPORT_CHANNEL_MAGIC)
        animate(stored_mobs, pixel_y = null, time = 1 SECONDS)
        stored_mobs.log_message("传送与 [whistle].", LOG_ATTACK, color = "red")
        REMOVE_TRAIT(stored_mobs, TRAIT_INCAPACITATED, WARPWHISTLE_TRAIT)

///摧毁龙卷风并传送所有在它上的人.
/obj/effect/temp_visual/teleporting_tornado/Destroy()
    if(whistle)
        whistle.whistler = null
        whistle = null
    return ..()

/////////////////////////////////////////Scepter of Vendormancy///////////////////
#define RUNIC_SCEPTER_MAX_CHARGES 3
#define RUNIC_SCEPTER_MAX_RANGE 7

/obj/item/runic_vendor_scepter
    name = "符文售货机法杖"
    desc = "这根法杖允许你投掷然后引爆符文售货机，最多可储存3发，然后需要进行简单的魔法引导来恢复，是对古老地灵魔法的一种现代演绎."
    icon_state = "vendor_staff"
    inhand_icon_state = "vendor_staff"
    lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
    righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
    icon = 'icons/obj/weapons/guns/magic.dmi'
    slot_flags = ITEM_SLOT_BACK
    w_class = WEIGHT_CLASS_NORMAL
    force = 10
    damtype = BRUTE
    resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
    attack_verb_continuous = list("猛击", "击打", "敲打")
    attack_verb_simple = list("猛击", "击打", "敲打")

    /// 召唤售货机的最大距离.
    var/max_summon_range = RUNIC_SCEPTER_MAX_RANGE
    /// 召唤售货机的引导时间.
    var/summoning_time = 1 SECONDS
    /// 检查法杖是否已经在引导一个售货机.
    var/scepter_is_busy_summoning = FALSE
    /// 检查法杖是否正在进行充能引导
    var/scepter_is_busy_recharging = FALSE
    /// 剩余的召唤次数.
    var/summon_vendor_charges = RUNIC_SCEPTER_MAX_CHARGES

/obj/item/runic_vendor_scepter/Initialize(mapload)
    . = ..()

    RegisterSignal(src, COMSIG_ITEM_MAGICALLY_CHARGED, PROC_REF(on_magic_charge))
    var/static/list/loc_connections = list(
        COMSIG_ITEM_MAGICALLY_CHARGED = PROC_REF(on_magic_charge),
    )

/obj/item/runic_vendor_scepter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
    if(scepter_is_busy_recharging)
        user.balloon_alert(user, "忙碌中!")
        return
    if(!check_allowed_items(target, not_inside = TRUE))
        return
    . |= AFTERATTACK_PROCESSED_ITEM
    var/turf/afterattack_turf = get_turf(target)
    if(istype(target, /obj/machinery/vending/runic_vendor))
        var/obj/machinery/vending/runic_vendor/runic_explosion_target = target
        runic_explosion_target.runic_explosion()
        return
    var/obj/machinery/vending/runic_vendor/vendor_on_turf = locate() in afterattack_turf
    if(vendor_on_turf)
        vendor_on_turf.runic_explosion()
        return
    if(!summon_vendor_charges)
        user.balloon_alert(user, "没有充能!")
        return
    if(get_dist(afterattack_turf,src) > max_summon_range)
        user.balloon_alert(user, "太远了!")
        return
    if(get_turf(src) == afterattack_turf)
        user.balloon_alert(user, "太近了!")
        return
    if(scepter_is_busy_summoning)
        user.balloon_alert(user, "已经在召唤中!")
        return
    if(afterattack_turf.is_blocked_turf(TRUE))
        user.balloon_alert(user, "被阻挡了!")
        return
    if(summoning_time)
        scepter_is_busy_summoning = TRUE
        user.balloon_alert(user, "召唤中...")
        if(!do_after(user, summoning_time, target = target))
            scepter_is_busy_summoning = FALSE
            return
        scepter_is_busy_summoning = FALSE
    if(summon_vendor_charges)
        playsound(src,'sound/weapons/resonator_fire.ogg',50,TRUE)
        user.visible_message(span_warning("[user] 召唤了一个符文售货机!"))
        new /obj/machinery/vending/runic_vendor(afterattack_turf)
        summon_vendor_charges--
        user.changeNext_move(CLICK_CD_MELEE)
        return
    return ..()

/obj/item/runic_vendor_scepter/attack_self(mob/user, modifiers)
    . = ..()
    user.balloon_alert(user, "充能中...")
    scepter_is_busy_recharging = TRUE
    if(!do_after(user, 5 SECONDS))
        scepter_is_busy_recharging = FALSE
        return
    user.balloon_alert(user, "已完全充能")
    scepter_is_busy_recharging = FALSE
    summon_vendor_charges = RUNIC_SCEPTER_MAX_CHARGES

/obj/item/runic_vendor_scepter/afterattack_secondary(atom/target, mob/user, proximity_flag, click_parameters)
	var/turf/afterattack_secondary_turf = get_turf(target)
	var/obj/machinery/vending/runic_vendor/vendor_on_turf = locate() in afterattack_secondary_turf
	if(istype(target, /obj/machinery/vending/runic_vendor))
		var/obj/machinery/vending/runic_vendor/vendor_being_throw = target
		vendor_being_throw.throw_at(get_edge_target_turf(target, get_cardinal_dir(src, target)), 4, 20, user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(vendor_on_turf)
		vendor_on_turf.throw_at(get_edge_target_turf(target, get_cardinal_dir(src, target)), 4, 20, user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/runic_vendor_scepter/proc/on_magic_charge(datum/source, datum/action/cooldown/spell/charge/spell, mob/living/caster)
	SIGNAL_HANDLER

	if(!ismovable(loc))
		return

	. = COMPONENT_ITEM_CHARGED

	summon_vendor_charges = RUNIC_SCEPTER_MAX_CHARGES
	return .

#undef RUNIC_SCEPTER_MAX_CHARGES
#undef RUNIC_SCEPTER_MAX_RANGE
