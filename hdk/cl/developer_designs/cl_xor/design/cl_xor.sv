module cl_xor #(parameter NUM_PCIE=1, parameter NUM_DDR=4, parameter NUM_HMC=4, parameter NUM_GTY = 4)
(
 `include "cl_ports.vh" // Fixed port definition
);
    // Vendor IDs and Subsystem IDs
    assign cl_sh_id0[31:0]       = 32'hF000_1D0F;
    assign cl_sh_id1[31:0]       = 32'h1D51_FEDD;

    // Tie off unused interfaces
    `include "unused_flr_template.inc"
    `include "unused_ddr_a_b_d_template.inc"
    `include "unused_ddr_c_template.inc"
    `include "unused_pcim_template.inc"
    `include "unused_dma_pcis_template.inc"
    `include "unused_cl_sda_template.inc"
    `include "unused_sh_bar1_template.inc"
    `include "unused_apppf_irq_template.inc"

    //-------------------------------------------------
    // Reset Synchronization
    //-------------------------------------------------
    logic pre_sync_rst_n;
    logic sync_rst_n;

    always_ff @(negedge rst_main_n or posedge clk)
    if (!rst_main_n)
    begin
        pre_sync_rst_n <= 0;
        sync_rst_n <= 0;
    end
    else
    begin
        pre_sync_rst_n <= 1;
        sync_rst_n <= pre_sync_rst_n;
    end

    // Not sure what there are
    `ifndef CL_VERSION
        `define CL_VERSION 32'hee_ee_ee_00
    `endif

    assign cl_sh_status0[31:0]   = 32'h0000_0000;
    assign cl_sh_status1[31:0]   = `CL_VERSION;


    // Look at the variable names from the perspective of the FPGA
    // A write request is a request from the host to the FPGA

    // Custom code [START]
    logic           w_host_fpga_adr_wr_valid;
    logic           w_host_fpga_adr_wr;
    logic           w_host_fpga_adr_wr_valid;

    // Write data
    logic           w_host_fpga_data_wr_valid;
    logic [31:0]    w_host_fpga_data_wr;
    logic [3:0]     w_host_fpga_wstrb; // Write strobe signal (Refer to AIX protocol for more information)
    logic           w_fpga_host_data_wr_ready;

    // Write response
    logic           w_fpga_host_burst_valid;
    logic [1:0]     w_fpga_host_burst_resp;
    logic           w_host_fpga_burst_ready;

    // Read address
    logic           w_host_fpga_adr_rd_valid;
    logic [31:0]    w_host_fpga_adr_rd;
    logic           w_fpga_host_adr_rd_ready;

    // Read data/response
    logic           w_fpga_host_data_rd_valid;
    logic [31:0]    w_fpga_host_data_rd;
    logic [1:0]     w_fpga_host_data_rd_resp;
    logic           w_host_fpga_data_rd_ready;

    axi_register_slice_light AXIL_OCL_REG_SLC (
        .aclk          (clk_main_a0),
        .aresetn       (rst_main_n_sync),
        .s_axi_awaddr  (sh_ocl_awaddr),
        .s_axi_awprot   (2'h0),
        .s_axi_awvalid (sh_ocl_awvalid),
        .s_axi_awready (ocl_sh_awready),
        .s_axi_wdata   (sh_ocl_wdata),
        .s_axi_wstrb   (sh_ocl_wstrb),
        .s_axi_wvalid  (sh_ocl_wvalid),
        .s_axi_wready  (ocl_sh_wready),
        .s_axi_bresp   (ocl_sh_bresp),
        .s_axi_bvalid  (ocl_sh_bvalid),
        .s_axi_bready  (sh_ocl_bready),
        .s_axi_araddr  (sh_ocl_araddr),
        .s_axi_arvalid (sh_ocl_arvalid),
        .s_axi_arready (ocl_sh_arready),
        .s_axi_rdata   (ocl_sh_rdata),
        .s_axi_rresp   (ocl_sh_rresp),
        .s_axi_rvalid  (ocl_sh_rvalid),
        .s_axi_rready  (sh_ocl_rready),
        .m_axi_awaddr  (sh_ocl_awaddr_q),
        .m_axi_awprot  (),
        .m_axi_awvalid (sh_ocl_awvalid_q),
        .m_axi_awready (ocl_sh_awready_q),
        .m_axi_wdata   (sh_ocl_wdata_q),
        .m_axi_wstrb   (sh_ocl_wstrb_q),
        .m_axi_wvalid  (sh_ocl_wvalid_q),
        .m_axi_wready  (ocl_sh_wready_q),
        .m_axi_bresp   (ocl_sh_bresp_q),
        .m_axi_bvalid  (ocl_sh_bvalid_q),
        .m_axi_bready  (sh_ocl_bready_q),
        .m_axi_araddr  (sh_ocl_araddr_q),
        .m_axi_arvalid (sh_ocl_arvalid_q),
        .m_axi_arready (ocl_sh_arready_q),
        .m_axi_rdata   (ocl_sh_rdata_q),
        .m_axi_rresp   (ocl_sh_rresp_q),
        .m_axi_rvalid  (ocl_sh_rvalid_q),
        .m_axi_rready  (sh_ocl_rready_q)
    );
endmodule
