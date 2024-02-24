/obj/machinery/rnd/production/techfab/department
	name = "部门复合机"
	desc = "一台先进的制造设备，可以打印出科研部门最新的研究原型和电路板.包含了用于同步研究网络的硬件, 该复合机仅限特定部门使用，并且只有一组内容有限的解密密钥."
	icon_state = "protolathe"
	circuit = /obj/item/circuitboard/machine/techfab/department

/obj/machinery/rnd/production/techfab/department/engineering
	name = "复合机 - 工程"
	allowed_department_flags = DEPARTMENT_BITFLAG_ENGINEERING
	circuit = /obj/item/circuitboard/machine/techfab/department/engineering
	stripe_color = "#EFB341"
	payment_department = ACCOUNT_ENG

/obj/machinery/rnd/production/techfab/department/service
	name = "复合机 - 服务"
	allowed_department_flags = DEPARTMENT_BITFLAG_SERVICE
	circuit = /obj/item/circuitboard/machine/techfab/department/service
	stripe_color = "#83ca41"
	payment_department = ACCOUNT_SRV

/obj/machinery/rnd/production/techfab/department/medical
	name = "复合机 - 医疗"
	allowed_department_flags = DEPARTMENT_BITFLAG_MEDICAL
	circuit = /obj/item/circuitboard/machine/techfab/department/medical
	stripe_color = "#52B4E9"
	payment_department = ACCOUNT_MED

/obj/machinery/rnd/production/techfab/department/cargo
	name = "复合机 - 补给"
	allowed_department_flags = DEPARTMENT_BITFLAG_CARGO
	circuit = /obj/item/circuitboard/machine/techfab/department/cargo
	stripe_color = "#956929"
	payment_department = ACCOUNT_CAR

/obj/machinery/rnd/production/techfab/department/science
	name = "复合机 - 科研"
	allowed_department_flags = DEPARTMENT_BITFLAG_SCIENCE
	circuit = /obj/item/circuitboard/machine/techfab/department/science
	stripe_color = "#D381C9"
	payment_department = ACCOUNT_SCI

/obj/machinery/rnd/production/techfab/department/security
	name = "复合机 - 安保"
	allowed_department_flags = DEPARTMENT_BITFLAG_SECURITY
	circuit = /obj/item/circuitboard/machine/techfab/department/security
	stripe_color = "#486091" //SKYRAT EDIT - ORIGINAL "#DE3A3A"
	payment_department = ACCOUNT_SEC
