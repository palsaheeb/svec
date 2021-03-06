files = [ "svec_afpga_top.vhd",
          "svec_v1_afpga.ucf",
          "csr.vhd",
          "wb_addr_decoder.vhd",
          "../bicolor_led_test/bicolor_led_ctrl.vhd",
          "../bicolor_led_test/bicolor_led_ctrl_pkg.vhd"]
"""
fetchto = "ip_cores"

modules = {
    "git"   : [ "git://ohwr.org/hdl-core-lib/general-cores.git" ],
    "svn"   : [ "http://svn.ohwr.org/ddr3-sp6-core/trunk/hdl",
                "http://svn.ohwr.org/vme64x-core/trunk/hdl/vme64x-core/rtl"
                ]
    }
"""
modules = {
    "local"   : [ "ip_cores/general-cores" ,
                  "ip_cores/ddr3-sp6-core/trunk/hdl",
                  "ip_cores/vme64x-core/trunk/hdl/vme64x-core/rtl" ]
    }
