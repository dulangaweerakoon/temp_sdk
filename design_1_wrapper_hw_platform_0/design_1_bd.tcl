
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART xilinx.com:zc702:part0:1.2 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
CONFIG.c_include_mm2s {1} \
CONFIG.c_include_sg {0} \
CONFIG.c_m_axis_mm2s_tdata_width {8} \
CONFIG.c_sg_include_stscntrl_strm {0} \
 ] $axi_dma_0

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {3} \
 ] $axi_mem_intercon

  # Create instance: doCNN_0, and set properties
  set doCNN_0 [ create_bd_cell -type ip -vlnv xilinx.com:hls:doCNN:1.0 doCNN_0 ]

  # Create instance: fifo_generator_0, and set properties
  set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.0 fifo_generator_0 ]
  set_property -dict [ list \
CONFIG.Empty_Threshold_Assert_Value_rach {14} \
CONFIG.Empty_Threshold_Assert_Value_wach {14} \
CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
CONFIG.Enable_TLAST {true} \
CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
CONFIG.Full_Flags_Reset_Value {1} \
CONFIG.Full_Threshold_Assert_Value_rach {15} \
CONFIG.Full_Threshold_Assert_Value_wach {15} \
CONFIG.Full_Threshold_Assert_Value_wrch {15} \
CONFIG.HAS_TKEEP {true} \
CONFIG.HAS_TSTRB {true} \
CONFIG.INTERFACE_TYPE {AXI_STREAM} \
CONFIG.Reset_Type {Asynchronous_Reset} \
CONFIG.TDEST_WIDTH {1} \
CONFIG.TID_WIDTH {1} \
CONFIG.TUSER_WIDTH {1} \
 ] $fifo_generator_0

  # Create instance: fifo_generator_2, and set properties
  set fifo_generator_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.0 fifo_generator_2 ]
  set_property -dict [ list \
CONFIG.Empty_Threshold_Assert_Value_rach {14} \
CONFIG.Empty_Threshold_Assert_Value_wach {14} \
CONFIG.Empty_Threshold_Assert_Value_wrch {14} \
CONFIG.Enable_TLAST {true} \
CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} \
CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} \
CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} \
CONFIG.Full_Flags_Reset_Value {1} \
CONFIG.Full_Threshold_Assert_Value_rach {15} \
CONFIG.Full_Threshold_Assert_Value_wach {15} \
CONFIG.Full_Threshold_Assert_Value_wrch {15} \
CONFIG.HAS_TKEEP {true} \
CONFIG.HAS_TSTRB {true} \
CONFIG.INTERFACE_TYPE {AXI_STREAM} \
CONFIG.Reset_Type {Asynchronous_Reset} \
CONFIG.TDEST_WIDTH {1} \
CONFIG.TID_WIDTH {1} \
CONFIG.TUSER_WIDTH {1} \
 ] $fifo_generator_2

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.preset {ZC702} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_50M, and set properties
  set rst_processing_system7_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_50M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins doCNN_0/in_p0]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_mem_intercon/S01_AXI]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_S2MM [get_bd_intf_pins axi_dma_0/M_AXI_S2MM] [get_bd_intf_pins axi_mem_intercon/S02_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net doCNN_0_out_p0 [get_bd_intf_pins axi_dma_0/S_AXIS_S2MM] [get_bd_intf_pins doCNN_0/out_p0]
  connect_bd_intf_net -intf_net doCNN_0_out_p1 [get_bd_intf_pins doCNN_0/out_p1] [get_bd_intf_pins fifo_generator_2/S_AXIS]
  connect_bd_intf_net -intf_net doCNN_0_out_p2 [get_bd_intf_pins doCNN_0/out_p2] [get_bd_intf_pins fifo_generator_0/S_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_0_M_AXIS [get_bd_intf_pins doCNN_0/in_p2] [get_bd_intf_pins fifo_generator_0/M_AXIS]
  connect_bd_intf_net -intf_net fifo_generator_2_M_AXIS [get_bd_intf_pins doCNN_0/in_p1] [get_bd_intf_pins fifo_generator_2/M_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins doCNN_0/s_axi_CRTL_BUS] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]

  # Create port connections
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net axi_dma_0_s2mm_introut [get_bd_pins axi_dma_0/s2mm_introut] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net doCNN_0_interrupt [get_bd_pins doCNN_0/interrupt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins fifo_generator_0/s_aresetn] [get_bd_pins fifo_generator_2/s_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/m_axi_s2mm_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins doCNN_0/ap_clk] [get_bd_pins fifo_generator_0/s_aclk] [get_bd_pins fifo_generator_2/s_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_50M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_50M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_50M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_50M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins doCNN_0/ap_rst_n] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_50M/peripheral_aresetn]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x40000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs doCNN_0/s_axi_CRTL_BUS/Reg] SEG_doCNN_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y -190 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y -170 -defaultsOSRD
preplace inst axi_dma_0 -pg 1 -lvl 3 -y -320 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 3 -y -30 -defaultsOSRD
preplace inst proc_sys_reset_0 -pg 1 -lvl 1 -y 190 -defaultsOSRD
preplace inst rst_processing_system7_0_50M -pg 1 -lvl 5 -y -250 -defaultsOSRD
preplace inst doCNN_0 -pg 1 -lvl 2 -y -80 -defaultsOSRD
preplace inst fifo_generator_0 -pg 1 -lvl 2 -y 240 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 6 -y 90 -defaultsOSRD
preplace inst fifo_generator_2 -pg 1 -lvl 2 -y 90 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 6 -y -210 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 4 -y -110 -defaultsOSRD
preplace netloc fifo_generator_2_M_AXIS 1 1 2 440 -180 1180
preplace netloc doCNN_0_out_p1 1 1 2 440 20 1160
preplace netloc processing_system7_0_DDR 1 4 3 NJ -440 NJ -440 NJ
preplace netloc doCNN_0_out_p2 1 1 2 440 160 1170
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 1 6 NJ -440 NJ -440 NJ -440 NJ -430 NJ -430 2830
preplace netloc rst_processing_system7_0_50M_interconnect_aresetn 1 5 1 2470
preplace netloc processing_system7_0_M_AXI_GP0 1 4 2 NJ -340 2490
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 5 -430 -220 NJ -220 NJ -200 NJ -250 2130
preplace netloc fifo_generator_0_M_AXIS 1 1 2 430 170 1160
preplace netloc axi_mem_intercon_M00_AXI 1 3 4 1620 -400 NJ -400 NJ -400 2810
preplace netloc rst_processing_system7_0_50M_peripheral_aresetn 1 1 5 NJ -190 NJ -190 NJ -240 NJ -160 2490
preplace netloc axi_dma_0_s2mm_introut 1 2 2 1220 -160 1560
preplace netloc axi_dma_0_M_AXI_MM2S 1 3 3 NJ -380 NJ -380 2510
preplace netloc xlconcat_0_dout 1 3 1 1590
preplace netloc processing_system7_0_FIXED_IO 1 4 3 NJ -390 NJ -390 NJ
preplace netloc axi_dma_0_mm2s_introut 1 2 2 1200 -170 1570
preplace netloc axi_dma_0_M_AXI_S2MM 1 3 3 NJ -370 NJ -370 2500
preplace netloc proc_sys_reset_0_peripheral_aresetn 1 1 1 420
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 -420 280 400 -200 1200 -180 1600 -260 2110 -350 2480
preplace netloc axi_dma_0_M_AXIS_MM2S 1 1 3 NJ -210 NJ -210 1580
preplace netloc doCNN_0_out_p0 1 2 1 1190
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 2 5 1220 -430 NJ -430 NJ -420 NJ -420 NJ
preplace netloc doCNN_0_interrupt 1 2 1 1190
levelinfo -pg 1 -450 230 1000 1390 1840 2300 2660 2870 -top -450 -bot 310
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


