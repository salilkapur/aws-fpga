module read_response (
    clk,
    i_reset,
    i_rvalid,
    i_rready,
    i_arvalid_internal,
    i_araddr_internal,
    i_data_internal,
    o_rvalid,
    o_rresp,
    o_rdata
);

    input           clk;
    input           i_reset;
    input           i_rvalid;
    input           i_rready;
    input           i_arvalid_internal;
    input [31:0]    i_araddr_internal;
    input [31:0]    i_data_internal;

    output logic        o_rvalid;
    output logic        o_rresp;
    output logic [31:0] o_rdata;

    logic r_reset;
    logic r_rvalid;
    logic r_rready;
    logic r_arvalid_internal;
    logic r_araddr_internal;
    logic r_data_internal;

    always_ff @(posedge clk)
    begin
        r_reset <= i_reset;
        r_rvalid <= i_rvalid;
        r_rready <= i_rready;
        r_arvalid_internal <= i_arvalid_internal;
        r_araddr_internal <= i_araddr_internal;
        r_data_internal <= i_data_internal;
    end

    always_comb
    begin
        if (~r_reset)
        begin
            o_rvalid = 0;
            o_rdata = 0;
            o_rresp = 0;
        end
        else if (r_rvalid && r_rready)
        begin
            o_rvalid = 0;
            o_rdata = 0;
            o_rresp = 0;
        end
        else if (r_arvalid_internal)
        begin
            o_rvalid = 1;
            // Logic for address and data mapping can be kept outside this
            // module
            //if (r_araddr_internal == `HELLO_WORLD_REG_ADDR)
            o_rdata = r_data_internal;
            o_rresp = 0;
        end
    end
endmodule
