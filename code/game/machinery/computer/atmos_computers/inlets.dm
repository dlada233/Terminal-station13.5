/obj/machinery/atmospherics/components/unary/outlet_injector/monitored
	on = TRUE
	volume_rate = MAX_TRANSFER_RATE
	/// The air sensor type this injector is linked to
	var/chamber_id

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/Initialize(mapload)
	id_tag = CHAMBER_INPUT_FROM_ID(chamber_id)
	return ..()

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/plasma_input
	name = "plasma-等离子气体罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_PLAS

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/oxygen_input
	name = "oxygen-氧气罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_O2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/nitrogen_input
	name = "nitrogen-氮气罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_N2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/mix_input
	name = "mix-混合气体罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_MIX

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/nitrous_input
	name = "nitrous oxide-一氧化二氮罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_N2O

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/air_input
	name = "air mix-混合空气罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_AIR

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/carbon_input
	name = "carbon dioxide-二氧化氮罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_CO2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/bz_input
	name = "bz罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_BZ

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/freon_input
	name = "freon-氟利昂罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_FREON

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/halon_input
	name = "halon-哈龙罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_HALON

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/healium_input
	name = "healium-疗气罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_HEALIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/hydrogen_input
	name = "hydrogen-氢气罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_H2

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/hypernoblium_input
	name = "hypernoblium-超铌罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_HYPERNOBLIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/miasma_input
	name = "miasma-瘴气罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_MIASMA

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/nitrium_input
	name = "nitrium-亚硝基兴奋气体罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_NITRIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/pluoxium_input
	name = "pluoxium-钷罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_PLUOXIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/proto_nitrate_input
	name = "proto-nitrate-原硝酸罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_PROTO_NITRATE

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/tritium_input
	name = "tritium-氚罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_TRITIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/water_vapor_input
	name = "water vapor-水蒸气罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_H2O

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/zauker_input
	name = "zauker-扎克罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_ZAUKER

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/helium_input
	name = "helium-氦罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_HELIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/antinoblium_input
	name = "antinoblium-反铌罐体注入器"
	chamber_id = ATMOS_GAS_MONITOR_ANTINOBLIUM

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/incinerator_input
	name = "燃烧室气体注入器"
	chamber_id = ATMOS_GAS_MONITOR_INCINERATOR

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/ordnance_burn_chamber_input
	on = FALSE
	name = "军械燃烧室气体注入器"
	chamber_id = ATMOS_GAS_MONITOR_ORDNANCE_BURN

/obj/machinery/atmospherics/components/unary/outlet_injector/monitored/ordnance_freezer_chamber_input
	on = FALSE
	name = "军械冷却室气体注入器"
	chamber_id = ATMOS_GAS_MONITOR_ORDNANCE_FREEZER
