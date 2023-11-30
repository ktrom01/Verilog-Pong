# Clock signal
set_property PACKAGE_PIN W5 [get_ports clock_100Mhz]       
set_property IOSTANDARD LVCMOS33 [get_ports clock_100Mhz]
#set_property BITSTREAM.GENERAL.UNCONSTRAINEDPINS Allow [current_design]
#Reset Signal
set_property PACKAGE_PIN T18 [get_ports {rst}]  
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]
#Buttons
set_property PACKAGE_PIN W19 [get_ports {right}]  
set_property IOSTANDARD LVCMOS33 [get_ports {right}]
set_property PACKAGE_PIN T17 [get_ports {left}]  
set_property IOSTANDARD LVCMOS33 [get_ports {left}]
#Color outputs
#RED
set_property PACKAGE_PIN G19 [get_ports {red[0]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {red[0]}]
set_property PACKAGE_PIN H19 [get_ports {red[1]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {red[1]}]
set_property PACKAGE_PIN J19 [get_ports {red[2]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {red[2]}]
set_property PACKAGE_PIN N19 [get_ports {red[3]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {red[3]}]
#GRN
set_property PACKAGE_PIN J17 [get_ports {grn[0]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {grn[0]}]
set_property PACKAGE_PIN H17 [get_ports {grn[1]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {grn[1]}]
set_property PACKAGE_PIN G17 [get_ports {grn[2]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {grn[2]}]
set_property PACKAGE_PIN D17 [get_ports {grn[3]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {grn[3]}]
#BLU
set_property PACKAGE_PIN N18 [get_ports {blu[0]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {blu[0]}]
set_property PACKAGE_PIN L18 [get_ports {blu[1]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {blu[1]}]
set_property PACKAGE_PIN K18 [get_ports {blu[2]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {blu[2]}]
set_property PACKAGE_PIN J18 [get_ports {blu[3]}]       
set_property IOSTANDARD LVCMOS33 [get_ports {blu[3]}]
#Sync values
set_property PACKAGE_PIN R19 [get_ports {vertsync}]       
set_property IOSTANDARD LVCMOS33 [get_ports {vertsync}]
set_property PACKAGE_PIN P19 [get_ports {horzsync}]       
set_property IOSTANDARD LVCMOS33 [get_ports {horzsync}]



