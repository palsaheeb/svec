files = [ "svec_sfpga_top.vhd", "svec_sfpga_top.ucf", "reset_gen.vhd" ]

fetchto = "../../ip_cores"

modules = {
    "local" : ["../../rtl/bootloader" ],
    "git" : [ "git://ohwr.org/hdl-core-lib/general-cores.git" ]
    }
