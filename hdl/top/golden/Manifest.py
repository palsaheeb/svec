files = [ "svec_top.vhd", "svec_top.ucf", "synthesis_descriptor.vhd" ]

fetchto = "../../ip_cores"

modules = {
		"local": [ "../../platform", "../../rtl/golden" ],
    "git" : [ "git://ohwr.org/hdl-core-lib/general-cores.git",
    					"git://ohwr.org/hdl-core-lib/vme64x-core.git" ]
    }
