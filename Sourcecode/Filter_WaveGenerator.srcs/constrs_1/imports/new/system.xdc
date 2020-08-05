#system CLK,100MHz
set_property PACKAGE_PIN H4 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
#Key1 for DACOutButton
set_property PACKAGE_PIN C3 [get_ports {DACOutButton}]
set_property IOSTANDARD LVCMOS33 [get_ports {DACOutButton}]
#Key2 for FIROutButton
set_property PACKAGE_PIN M4 [get_ports {FIROutButton}]
set_property IOSTANDARD LVCMOS33 [get_ports {FIROutButton}]
#io0 for RXD
set_property PACKAGE_PIN N14 [get_ports {uart_rx}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_rx}]
#io1 for TXD
set_property PACKAGE_PIN M14 [get_ports {uart_tx}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_tx}]
#LED1 for SettingDone
set_property PACKAGE_PIN J1 [get_ports {SettingDone}]
set_property IOSTANDARD LVCMOS33 [get_ports {SettingDone}]
set_property PULLDOWN true [get_ports {SettingDone}]
#LED2 for DAC_Out
set_property PACKAGE_PIN A13 [get_ports {DAC_Out}]
set_property IOSTANDARD LVCMOS33 [get_ports {DAC_Out}]
set_property PULLDOWN true [get_ports {DAC_Out}]
#K2 for WaveGeneratorRunning
#set_property PACKAGE_PIN L2 [get_ports {WaveGeneratorRunning}]
#set_property IOSTANDARD LVCMOS33 [get_ports {WaveGeneratorRunning}]