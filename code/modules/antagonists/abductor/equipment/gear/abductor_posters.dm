
/obj/item/poster/random_abductor
	name = "随机绑架者海报"
	poster_type = /obj/structure/sign/poster/abductor/random
	icon = 'icons/obj/poster.dmi'
	icon_state = "rolled_abductor"

/obj/structure/sign/poster/abductor
	icon = 'icons/obj/poster.dmi'
	poster_item_name = "绑架者海报"
	poster_item_desc = "一张全纤维树脂海报，背面有纳米尖孔来获得最大的吸附力."
	poster_item_icon_state = "rolled_abductor"

/obj/structure/sign/poster/abductor/tear_poster(mob/user)
	if(!isabductor(user))
		balloon_alert(user, "它没法移动!")
		return
	return ..()

/obj/structure/sign/poster/abductor/random
	name = "随机绑架者海报"
	icon_state = "random_abductor"
	never_random = TRUE
	random_basetype = /obj/structure/sign/poster/abductor

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/random, 32)

/obj/structure/sign/poster/abductor/ayylian
	name = "Ayylian"
	desc = "天啊，Ian最近看起来真的很奇怪."
	icon_state = "ayylian"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayylian, 32)

/obj/structure/sign/poster/abductor/ayy
	name = "绑架者"
	desc = "嘿，他并不是蜥蜴人!"
	icon_state = "ayy"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy, 32)

/obj/structure/sign/poster/abductor/ayy_over_tizira
	name = "绑架者在缇兹兰"
	desc = "这张海报改编自一张讲述人类与蜥蜴战争的电影海报，当时由于两位主演拒绝说台词，演出受到了很大的阻碍."
	icon_state = "ayy_over_tizira"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_over_tizira, 32)

/obj/structure/sign/poster/abductor/ayy_recruitment
	name = "绑架者招聘"
	desc = "今天就加入母舰探测部门!"
	icon_state = "ayy_recruitment"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_recruitment, 32)

/obj/structure/sign/poster/abductor/ayy_cops
	name = "绑架者警察"
	desc = "评论两极分化的‘绑架者警察’系列海报，一些批评人士声称这让他们感到震惊，而另一些人则说这让他们昏昏欲睡."
	icon_state = "ayyce_cops"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_cops, 32)

/obj/structure/sign/poster/abductor/ayy_no
	name = "Uayy No"
	desc = "这东西全是日文的，而且他们把海报上的动漫女孩去掉了，令人发指."
	icon_state = "ayy_no"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_no, 32)

/obj/structure/sign/poster/abductor/ayy_piping
	name = "安保绑架者 - 管道"
	desc = "安保绑架者无话可说，不是因为他们不会说话，而是因为绑架者不需要处理气氛之类的东西."
	icon_state = "ayy_piping"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_piping, 32)

/obj/structure/sign/poster/abductor/ayy_fancy
	name = "绑架者幻想"
	desc = "绑架者什么都很擅长！当然也包括让自己看起来很棒！"
	icon_state = "ayy_fancy"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/abductor/ayy_fancy, 32)
