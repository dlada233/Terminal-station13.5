/obj/item/clothing/head/costume/garland
	name = "花环"
	desc = "在某个地方，某个带着这个的人在挨饿，你肯定不是那个人."
	icon_state = "garland"
	worn_icon_state = "garland"

/obj/item/clothing/head/costume/garland/equipped(mob/living/user, slot)
	. = ..()
	if(slot_flags & slot)
		user.add_mood_event("garland", /datum/mood_event/garland)

/obj/item/clothing/head/costume/garland/dropped(mob/living/user)
	. = ..()
	user.clear_mood_event("garland")

/obj/item/clothing/head/costume/garland/rainbowbunch
	name = "彩虹花冠"
	desc = "由各色颜色的花朵制成的花冠，"
	icon_state = "rainbow_bunch_crown_1"
	base_icon_state = "rainbow_bunch_crown"

/obj/item/clothing/head/costume/garland/rainbowbunch/Initialize(mapload)
	. = ..()
	var/crown_type = rand(1,4)
	icon_state = "[base_icon_state]_[crown_type]"
	switch(crown_type)
		if(1)
			desc += " 这个有红色、黄色和白色的花."
		if(2)
			desc += " 这个有蓝色、黄色、绿色和白色的花."
		if(3)
			desc += " 这个有红色、蓝色、紫色和粉色的花."
		if(4)
			desc += " 这个有黄色、绿色和白色的花."

/obj/item/clothing/head/costume/garland/sunflower
	name = "向日葵花冠"
	desc = "一个由向日葵制成的阳光花冠，肯定会让任何人心情愉悦！"
	icon_state = "sunflower_crown"
	worn_icon_state = "sunflower_crown"

/obj/item/clothing/head/costume/garland/poppy
	name = "罂粟花冠"
	desc = "由一串亮红色罂粟花制成的花冠."
	icon_state = "poppy_crown"
	worn_icon_state = "poppy_crown"

/obj/item/clothing/head/costume/garland/lily
	name = "百合花冠"
	desc = "一个叶状的花冠，前面有一簇大白百合."
	icon_state = "lily_crown"
	worn_icon_state = "lily_crown"

