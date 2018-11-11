# Synthesis and Implementation script

set CL_DIR $::env(CL_DIR)

#Set part number
#set_part xc7a35tcpg236-1

set HDK_SHELL_DIR $::env(HDK_SHELL_DIR)
set HDK_SHELL_DESIGN_DIR $::env(HDK_SHELL_DESIGN_DIR)
set CL_DIR $::env(CL_DIR)
set TARGET_DIR $CL_DIR/build/staging
set UNUSED_TEMPLATES_DIR $HDK_SHELL_DESIGN_DIR/interfaces
# Remove any previously encrypted files, that may no longer be used
if {[llength [glob -nocomplain -dir $TARGET_DIR *]] != 0} {
  eval file delete -force [glob $TARGET_DIR/*]
}

file copy -force $CL_DIR/design/cl_axi_write_response.sv              $TARGET_DIR
file copy -force $CL_DIR/design/cl_axi_write_request.sv               $TARGET_DIR
file copy -force $CL_DIR/design/cl_axi_read_response.sv               $TARGET_DIR
file copy -force $CL_DIR/design/cl_axi_read_request.sv                $TARGET_DIR
file copy -force $CL_DIR/design/cl_hello_world.sv                     $TARGET_DIR
file copy -force $CL_DIR/../common/design/cl_common_defines.vh        $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_apppf_irq_template.inc  $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_cl_sda_template.inc     $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_ddr_a_b_d_template.inc  $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_ddr_c_template.inc      $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_dma_pcis_template.inc   $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_pcim_template.inc       $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_sh_bar1_template.inc    $TARGET_DIR
file copy -force $UNUSED_TEMPLATES_DIR/unused_flr_template.inc        $TARGET_DIR

read_verilog -sv [ list \
  $HDK_SHELL_DESIGN_DIR/lib/lib_pipe.sv \
  $HDK_SHELL_DESIGN_DIR/sh_ddr/synth/sync.v \
  $HDK_SHELL_DESIGN_DIR/sh_ddr/synth/flop_ccf.sv \
  $HDK_SHELL_DESIGN_DIR/sh_ddr/synth/ccf_ctl.v \
  $HDK_SHELL_DESIGN_DIR/sh_ddr/synth/sh_ddr.sv \
  $HDK_SHELL_DESIGN_DIR/interfaces/cl_ports.vh
]

#Read IP for axi register slices
read_ip [ list \
  $HDK_SHELL_DESIGN_DIR/ip/src_register_slice/src_register_slice.xci \
  $HDK_SHELL_DESIGN_DIR/ip/dest_register_slice/dest_register_slice.xci \
  $HDK_SHELL_DESIGN_DIR/ip/axi_register_slice/axi_register_slice.xci \
  $HDK_SHELL_DESIGN_DIR/ip/axi_register_slice_light/axi_register_slice_light.xci
]
# Read verilog source files
read_verilog -sv  $TARGET_DIR/cl_axi_write_response.sv
read_verilog -sv  $TARGET_DIR/cl_axi_write_request.sv
read_verilog -sv  $TARGET_DIR/cl_axi_read_request.sv
read_verilog -sv  $TARGET_DIR/cl_axi_read_response.sv
read_verilog -sv  $TARGET_DIR/cl_hello_world.sv

#Read constraints file
#read_xdc constraints_artix_7.xdc

# Run Synthesis
synth_design -top cl_hello_world

# Create reports directory
exec mkdir -p -- ./reports

# Reports after synthesis
#report_timing -setup  -file ./reports/synth_aes_setup_report.txt
#report_timing -hold   -file ./reports/synth_aes_hold_report.txt
#report_timing_summary -file ./reports/synth_timing_report_aes.txt
#report_utilization    -file ./reports/synth_utilization_report.txt

#Run implementation
#place_design
#route_design

# Reports after implementation
#report_timing -setup  -file ./reports/impl_aes_setup_report.txt
#report_timing -hold   -file ./reports/impl_aes_hold_report.txt
#report_timing_summary -file ./reports/impl_timing_report_aes.txt
#report_utilization    -file ./reports/impl_utilization_report.txt

# Create bitstreams directory
#exec mkdir -p -- ./bitstreams

#Write bitstream
#write_bitstream -force ./bitstreams/aes.bit
