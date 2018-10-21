#
#Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
#
set_param power.enableLutRouteBelPower 1
set_param power.enableCarry8RouteBelPower 1
set_param power.enableUnconnectedCarry8PinPower 1
set_param hd.clockRoutingWireReduction 0
set_param chipscope.flow 0
set part xcvu9p-flgb2104-2-i
set tool_flow Vivado
set ip_vlnv xilinx.com:ip:xsdbm:3.0
set ip_module_name xsdbm_CV
set params {{{PARAM_VALUE.C_BSCAN_MODE} {false} {PARAM_VALUE.C_BSCAN_MODE_WITH_CORE} {false} {PARAM_VALUE.C_CLK_INPUT_FREQ_HZ} {300000000} {PARAM_VALUE.C_ENABLE_CLK_DIVIDER} {false} {PARAM_VALUE.C_EN_BSCANID_VEC} {false} {PARAM_VALUE.C_NUM_BSCAN_MASTER_PORTS} {0} {PARAM_VALUE.C_TWO_PRIM_MODE} {false} {PARAM_VALUE.C_USER_SCAN_CHAIN} {1} {PARAM_VALUE.C_USE_EXT_BSCAN} {true} {PARAM_VALUE.C_XSDB_NUM_SLAVES} {4}}}
set output_xci /home/centos/salil/Work/aws-fpga/hdk/cl/examples/cl_hello_world/build/scripts/.Xil/Vivado-1783-ip-172-31-30-42.ec2.internal/xsdbm_CV.0/out/result.xci
set output_dcp /home/centos/salil/Work/aws-fpga/hdk/cl/examples/cl_hello_world/build/scripts/.Xil/Vivado-1783-ip-172-31-30-42.ec2.internal/xsdbm_CV.0/out/result.dcp
set output_dir /home/centos/salil/Work/aws-fpga/hdk/cl/examples/cl_hello_world/build/scripts/.Xil/Vivado-1783-ip-172-31-30-42.ec2.internal/xsdbm_CV.0/out
set ip_repo_paths /home/centos/salil/Work/aws-fpga/hdk/common/shell_v04261818/design/cache/ddr4_phy
set ip_output_repo ./.cache/ip
set ip_cache_permissions {read write}

set oopbus_ip_repo_paths [get_param chipscope.oopbus_ip_repo_paths]

set synth_opts {}
set xdc_files {}
source {/opt/Xilinx/Vivado/2017.4.op/scripts/ip/ipxchipscope.tcl}

set failed [catch {ipx::chipscope::gen_and_synth_ip $part $tool_flow $ip_vlnv $ip_module_name $params $output_xci $output_dcp $output_dir $ip_repo_paths $ip_output_repo $ip_cache_permissions $oopbus_ip_repo_paths $synth_opts $xdc_files} errMessage]

if { $failed } {
send_msg_id {IP_Flow-19-3805} ERROR "Failed to generate and synthesize debug IP $ip_vlnv. \n $errMessage"
  exit 1
}
