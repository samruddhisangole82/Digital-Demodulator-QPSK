## Constraints File for QPSK Demodulator Project
## Target Board: Nexys A7 (or similar Xilinx FPGA board)
## Created for Variable Data Rate Digital Demodulator

##############################################################################
## Clock Signal (100 MHz)
##############################################################################
set_property PACKAGE_PIN E3 [get_ports {clk_100mhz}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk_100mhz}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk_100mhz}]

##############################################################################
## Reset Button (Center Button)
##############################################################################
set_property PACKAGE_PIN E16 [get_ports {reset_btn}]
set_property IOSTANDARD LVCMOS33 [get_ports {reset_btn}]

##############################################################################
## Switches (SW0-SW15)
## SW[3:0]  - Data rate selection
## SW[4]    - Manual enable / Auto test trigger
## SW[5]    - Auto test mode enable
## SW[6]    - I channel polarity (manual mode)
## SW[7]    - Q channel polarity (manual mode)
## SW[15:8] - Reserved for future use
##############################################################################
set_property PACKAGE_PIN U9 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN U8 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN R7 [get_ports {sw[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN R6 [get_ports {sw[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
set_property PACKAGE_PIN R5 [get_ports {sw[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property PACKAGE_PIN V7 [get_ports {sw[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property PACKAGE_PIN V6 [get_ports {sw[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
set_property PACKAGE_PIN V5 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
set_property PACKAGE_PIN U4 [get_ports {sw[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
set_property PACKAGE_PIN V2 [get_ports {sw[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
set_property PACKAGE_PIN U2 [get_ports {sw[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
set_property PACKAGE_PIN T3 [get_ports {sw[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
set_property PACKAGE_PIN T1 [get_ports {sw[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
set_property PACKAGE_PIN R3 [get_ports {sw[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
set_property PACKAGE_PIN P3 [get_ports {sw[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[14]}]
set_property PACKAGE_PIN P4 [get_ports {sw[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[15]}]

##############################################################################
## LEDs (LED0-LED15)
## LED[1:0]   - Demodulated bit output (2-bit QPSK symbol)
## LED[2]     - Bit valid indicator
## LED[3]     - Symbol lock status
## LED[4]     - Error flag
## LED[8:5]   - Data rate selection display
## LED[9]     - Test active indicator
## LED[11:10] - Test counter state
## LED[15:12] - Reserved
##############################################################################
set_property PACKAGE_PIN T8 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN V9 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN R8 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN T6 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN T5 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN T4 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U7 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN U6 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN V4 [get_ports {led[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
set_property PACKAGE_PIN U3 [get_ports {led[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
set_property PACKAGE_PIN V1 [get_ports {led[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
set_property PACKAGE_PIN R1 [get_ports {led[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
set_property PACKAGE_PIN P5 [get_ports {led[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
set_property PACKAGE_PIN U1 [get_ports {led[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
set_property PACKAGE_PIN R2 [get_ports {led[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
set_property PACKAGE_PIN P2 [get_ports {led[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]

##############################################################################
## 7-Segment Display Cathodes (segments a-g)
## Displays demodulated symbol value (0, 1, 2, 3)
##############################################################################
set_property PACKAGE_PIN L3 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]
set_property PACKAGE_PIN N1 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN L5 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN L4 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN K3 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN M2 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN L6 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

##############################################################################
## 7-Segment Display Anodes (digit select)
## Only using first digit (AN[0])
##############################################################################
set_property PACKAGE_PIN N6 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN M6 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN M3 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN N5 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

##############################################################################
## UART (Required for board constraints, tied off in design)
##############################################################################
set_property PACKAGE_PIN C4 [get_ports {uart_rxd}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_rxd}]
set_property PACKAGE_PIN D4 [get_ports {uart_txd}]
set_property IOSTANDARD LVCMOS33 [get_ports {uart_txd}]

##############################################################################
## Timing Constraints
##############################################################################

## Input delays for switches (assumed external delay)
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {sw[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {sw[*]}]

## Input delays for reset button
set_input_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {reset_btn}]
set_input_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {reset_btn}]

## Output delays for LEDs
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {led[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {led[*]}]

## Output delays for 7-segment display
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {seg[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {seg[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -min 0.000 [get_ports {an[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max 2.000 [get_ports {an[*]}]

##############################################################################
## Configuration Options
##############################################################################
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

##############################################################################
## Additional Timing Constraints for Internal Signals
##############################################################################

## Set false path for reset synchronizer
set_false_path -from [get_ports {reset_btn}] -to [get_registers {*reset_sync*}]

## Set false path for switch synchronizers (they have their own synchronization)
set_false_path -from [get_ports {sw[*]}] -to [get_registers {*sw_sync1*}]

## Set max delay for slow clock enable path (relaxed timing)
set_max_delay 20.000 -from [get_registers {*slow_clk_counter*}] -to [get_registers {*slow_clk_enable*}]