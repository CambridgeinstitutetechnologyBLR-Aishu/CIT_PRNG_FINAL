`default_nettype none

module tt_um_prng_aishu (
    input  wire [7:0] ui_in,    // Seed Value
    output wire [7:0] uo_out,   // Random Number Output
    input  wire [7:0] uio_in,   // uio_in[0]: Load, uio_in[1]: Enable
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

    reg [7:0] lfsr;
    wire load_en = uio_in[0];
    wire gen_en  = uio_in[1];

    // Fibonacci LFSR Taps for 8-bits: bits 8, 6, 5, 4 (indexed 7, 5, 4, 3)
    wire feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    always @(posedge clk) begin
        if (!rst_n) begin
            lfsr <= 8'h01; // Start with 1 (LFSR can never be all 0s)
        end else if (ena) begin
            if (load_en)
                lfsr <= (ui_in == 8'h00) ? 8'h01 : ui_in;
            else if (gen_en)
                lfsr <= {lfsr[6:0], feedback};
        end
    end

    assign uo_out = lfsr;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
