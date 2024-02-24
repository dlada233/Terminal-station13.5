/obj/item/reagent_containers/spray/hercuri/chilled
	name = "赫库里冷却喷雾" // effective at cooling low-temperature burns but also is more efficienct at cooling high-temperature
	desc = "一个医用喷雾，含有Hercuri-赫库里，一种用来消除高温危险环境影响的药物，已经过预先冷却，适合治疗合成人烧伤.\n\
	喷嘴附近有一个醒目的警告标签：仅在紧急情况下使用！会引起冻伤！辅助效果仅对活体合成人有效！对已停机的无效！\n\
	喷雾瓶身上还有一个较小的警告标签：如果发生失控吸热反应，请使用系统清洁剂！</b>"
	var/starting_temperature = 100

/obj/item/reagent_containers/spray/hercuri/chilled/add_initial_reagents()
	. = ..()

	reagents.chem_temp = starting_temperature
