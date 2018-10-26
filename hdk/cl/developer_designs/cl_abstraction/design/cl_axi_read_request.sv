module read_request(
    clk,
    i_reset,
    i_arvalid,
    i_araddr,
    i_rvalid,
    o_arready,
    o_arvalid_internal,
    o_araddr_internal
);
    
    input clk;
    input i_reset;
    input i_arvalid;
    input i_araddr;
    input i_rvalid;

    output logic        o_arvalid_internal;
    output logic [31:0] o_araddr_internal;
    output logic        o_arready;

    logic           r_reset;
    logic           r_arvalid;
    logic           r_rvalid;
    logic [31:0]    r_araddr;
    logic           r_arvalid_internal;
    logic [31:0]    r_araddr_internal;

    logic [31:0]    w_araddr_internal;

    always_ff @(posedge clk)
    begin
        r_reset     <= i_reset;
        r_arvalid   <= i_arvalid;
        r_araddr    <= i_araddr;
        r_rvalid    <= i_rvalid;
        r_araddr_internal <= w_araddr_internal;
    end

    always_comb
    begin
        if (!r_reset)
        begin
            o_arvalid_internal = 0;
            o_araddr_internal = 0;
        end
        else
        begin
            o_arvalid_internal = r_arvalid;
            if (r_arvalid)
                w_araddr_internal = r_araddr;
            else
                w_araddr_internal = r_araddr_internal;
        end

        o_araddr_internal = w_araddr_internal;
        o_arready = ~r_arvalid && ~r_rvalid;
    end
endmodule
