module write_response (
    clk,
    i_reset,
    i_bvalid,
    i_bready,
    i_wready,
    o_bvalid,
    o_bresp
);
    input clk;
    input i_reset;
    input i_bvalid;
    input i_bready;
    input i_wready;

    output logic          o_bvalid;
    output logic [1:0]    o_bresp;

    logic r_reset;
    logic r_bvalid;
    logic r_bready;
    logic r_wready;

    always_ff @(posedge clk)
    begin
        r_reset     <= i_reset;
        r_bvalid    <= i_bvalid;
        r_bready    <= i_bready;
        r_wready    <= i_wready;
    end

    always_comb
    begin
        if (!r_reset)
        begin
            o_bvalid = 0;
        end
        else
        begin
            if (r_bvalid && r_bready)
                o_bvalid = 0;
            else if (~r_bvalid && r_wready)
                o_bvalid = 1;
            else
                o_bvalid = r_bvalid;
        end

        // This can be used to send the response code. Sending OKAY for now.
        // Page 54 for reference
        // http://www.gstitt.ece.ufl.edu/courses/fall15/eel4720_5721/labs/refs/AXI4_specification.pdf#E7.BABBIHDJ
        o_bresp = 0;
    end
endmodule
