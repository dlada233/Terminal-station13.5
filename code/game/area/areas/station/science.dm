/area/station/science
	name = "\improper Science-科研部"
	icon_state = "science"
	airlock_wires = /datum/wires/airlock/science
	sound_environment = SOUND_AREA_STANDARD_STATION

/area/station/science/lobby
	name = "\improper Science-科研部大厅"
	icon_state = "science_lobby"

/area/station/science/lower
	name = "\improper Science-低层科研部"
	icon_state = "lower_science"

/area/station/science/breakroom
	name = "\improper Science-科研部休息室"
	icon_state = "science_breakroom"

/area/station/science/lab
	name = "R&D-研究开发实验室"
	icon_state = "research"

/area/station/science/xenobiology
	name = "\improper Xenobiology-异种学实验室"
	icon_state = "xenobio"

/area/station/science/xenobiology/hallway
	name = "\improper Xenobiology-异种学走廊"
	icon_state = "xenobio_hall"

/area/station/science/cytology
	name = "\improper Cytology-细胞学实验室"
	icon_state = "cytology"

/area/station/science/cubicle
	name = "\improper Science Cubicles"
	icon_state = "science"
	sound_environment = SOUND_AREA_MEDIUM_SOFTFLOOR

/area/station/science/genetics
	name = "\improper Genetics-基因实验室"
	icon_state = "geneticssci"

/area/station/science/server
	name = "\improper Science-科研部服务器机房"
	icon_state = "server"

/area/station/science/circuits
	name = "\improper Circuit-电路实验室"
	icon_state = "cir_lab"

/area/station/science/explab
	name = "\improper Experimentation-危险实验室"
	icon_state = "exp_lab"

/area/station/science/auxlab
	name = "\improper Auxiliary Lab-辅助实验室"
	icon_state = "aux_lab"

/area/station/science/auxlab/firing_range
	name = "\improper Science-测试靶场"

/area/station/science/robotics
	name = "Robotics-机械学"
	icon_state = "robotics"

/area/station/science/robotics/mechbay
	name = "\improper Mech Bay-机械学区"
	icon_state = "mechbay"

/area/station/science/robotics/lab
	name = "\improper Robotics-机器人学实验室"
	icon_state = "ass_line"

/area/station/science/robotics/storage
	name = "\improper Robotics-机器人学仓库"
	icon_state = "ass_line"

/area/station/science/robotics/augments
	name = "\improper Augmentation-义肢升级处"
	icon_state = "robotics"
	sound_environment = SOUND_AREA_TUNNEL_ENCLOSED

/area/station/science/research
	name = "\improper Research Division-研究部门"
	icon_state = "science"

/area/station/science/research/abandoned
	name = "\improper Abandoned Research Lab-废弃研究部门"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/*
* Ordnance Areas
*/

// Use this for the main lab. If test equipment, storage, etc is also present use this one too.
/area/station/science/ordnance
	name = "\improper Ordnance-军械实验室"
	icon_state = "ord_main"

/area/station/science/ordnance/office
	name = "\improper Ordnance-军械办公室"
	icon_state = "ord_office"

/area/station/science/ordnance/storage
	name = "\improper Ordnance-军械仓库"
	icon_state = "ord_storage"

/area/station/science/ordnance/burnchamber
	name = "\improper Ordnance-军械燃烧室"
	icon_state = "ord_burn"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/station/science/ordnance/freezerchamber
	name = "\improper Ordnance-军械冷却室"
	icon_state = "ord_freeze"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

// Room for equipments and such
/area/station/science/ordnance/testlab
	name = "\improper Ordnance-军械测试处"
	icon_state = "ord_test"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED

/area/station/science/ordnance/bomb
	name = "\improper Ordnance-军械试爆场"
	icon_state = "ord_boom"
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | CULT_PERMITTED
