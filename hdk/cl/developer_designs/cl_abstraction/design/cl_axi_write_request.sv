/*
* File to implement AXI4-Lite protocol channels
*/

// From master to slave
module write_request(
    clk,
    i_reset,
    i_awaddr, // AXI
    i_awvalid, // This comes from master | AXI
    i_wvalid, // This comes from master | AXI
    i_bvalid, // AXI
    i_bready, // AXI
    o_awready,
    o_wready,
    o_write_address // Internal value
);
    input clk;
    input i_reset;
    input i_awaddr;
    input i_awvalid;
    input i_wvalid;
    input i_bvalid;
    input i_bready;

    output logic        o_awready;
    output logic        o_wready;
    output logic [31:0] o_write_address;

    logic r_reset;
    logic r_write_active;
    logic r_awaddr;
    logic r_bvalid;
    logic r_bready;
    logic r_awvalid;
    logic r_wvalid;
    
    logic w_write_active;
    logic w_write_address;

    always_ff @(posedge clk)
    begin
        r_reset         <= i_reset;
        r_awaddr        <= i_awaddr;
        r_awvalid       <= i_awvalid;
        r_wvalid        <= i_wvalid;
        r_bvalid        <= i_bvalid;
        r_bready        <= i_bready;

        r_write_active  <= w_write_active; // Internal state
    end

    always_comb
    begin
        // Signal handling
        if (!r_reset)
        begin
            w_write_active = 0;
            w_write_address = 0;
        end
        else
        begin
            w_write_active = r_write_active;
            w_write_address = r_awaddr;
        end

        if (w_write_active && r_bvalid && r_bready)
        begin
            // Check if a write is active or a write response is active
            w_write_active = 0;
        end
        else if (!r_write_active && r_awvalid)
        begin
            // There is no existing write happening
            w_write_active = 1;
        end
    
        o_awready = ~w_write_active;
        o_wready = w_write_active && r_wvalid;

        // Address handling
        if (w_write_active && ~r_awvalid)
        begin
            o_write_address = r_awaddr;
        end
    end
endmodule
