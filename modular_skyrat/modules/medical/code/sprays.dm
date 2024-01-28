/obj/item/reagent_containers/spray/hercuri/chilled
	name = "冷藏海格力喷雾" // effective at cooling low-temperature burns but also is more efficienct at cooling high-temperature
	desc = "一个医用喷雾，含有Hercuri-海格力，一种用来消除高温危险环境影响的药物，已经过预先冷却，适合治疗合成人烧伤，注意应在紧急情况下使用.</b>"
	var/starting_temperature = 100

/obj/item/reagent_containers/spray/hercuri/chilled/add_initial_reagents()
	. = ..()

	reagents.chem_temp = starting_temperature
