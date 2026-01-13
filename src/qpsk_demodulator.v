module qpsk_demodulator #(
    parameter DATA_WIDTH = 16
) (
    // Clock and Reset
    input wire clk,
    input wire reset,  // Synchronous reset
    
    // Input I/Q data (from RF front-end)
    input wire [DATA_WIDTH-1:0] i_data,
    input wire [DATA_WIDTH-1:0] q_data,
    input wire iq_valid,
    
    // Demodulated output bits
    output wire [1:0] bit_out,
    output wire bit_valid,
    
    // Status
    output wire symbol_lock,
    output wire error_flag
);

    // Internal signals
    wire signed [DATA_WIDTH-1:0] i_signed;
    wire signed [DATA_WIDTH-1:0] q_signed;
    
    // State machine
    localparam WAIT_DATA      = 2'd0;
    localparam PROCESS_SYMBOL = 2'd1;
    localparam OUTPUT_BITS    = 2'd2;
    
    reg [1:0] demod_state;
    
    // FIXED: All registers now have proper synchronous reset
    reg [1:0] bit_pair_reg;
    reg [1:0] bit_out_reg;
    reg bit_valid_reg;
    reg symbol_lock_reg;
    reg error_flag_reg;
    
    // Convert inputs to signed
    assign i_signed = $signed(i_data);
    assign q_signed = $signed(q_data);
    
    // Function to compute absolute value
    function signed [DATA_WIDTH-1:0] abs_value;
        input signed [DATA_WIDTH-1:0] value;
        begin
            if (value < 0)
                abs_value = -value;
            else
                abs_value = value;
        end
    endfunction
    
    // QPSK Demodulation Process with PROPER SYNCHRONOUS RESET
    always @(posedge clk) begin
        if (reset) begin
            // FIXED: Synchronous reset for all registers
            demod_state <= WAIT_DATA;
            bit_pair_reg <= 2'b00;
            bit_out_reg <= 2'b00;
            bit_valid_reg <= 1'b0;
            symbol_lock_reg <= 1'b0;
            error_flag_reg <= 1'b0;
        end else begin
            case (demod_state)
                WAIT_DATA: begin
                    bit_valid_reg <= 1'b0;
                    error_flag_reg <= 1'b0;
                    
                    if (iq_valid) begin
                        demod_state <= PROCESS_SYMBOL;
                    end
                end
                
                PROCESS_SYMBOL: begin
                    // QPSK Decision Logic
                    // Quadrant detection based on I/Q signs
                    if (i_signed >= 0 && q_signed >= 0) begin
                        bit_pair_reg <= 2'b00;  // First quadrant
                    end else if (i_signed < 0 && q_signed >= 0) begin
                        bit_pair_reg <= 2'b01;  // Second quadrant  
                    end else if (i_signed < 0 && q_signed < 0) begin
                        bit_pair_reg <= 2'b11;  // Third quadrant
                    end else begin  // i_signed >= 0 && q_signed < 0
                        bit_pair_reg <= 2'b10;  // Fourth quadrant
                    end
                    
                    // Check for potential errors (very weak signals)
                    if (abs_value(i_signed) < 100 && abs_value(q_signed) < 100) begin
                        error_flag_reg <= 1'b1;
                    end else begin
                        error_flag_reg <= 1'b0;
                    end
                    
                    symbol_lock_reg <= 1'b1;
                    demod_state <= OUTPUT_BITS;
                end
                
                OUTPUT_BITS: begin
                    bit_out_reg <= bit_pair_reg;
                    bit_valid_reg <= 1'b1;
                    demod_state <= WAIT_DATA;
                end
                
                default: begin
                    demod_state <= WAIT_DATA;
                end
            endcase
        end
    end
    
    // Output assignments
    assign bit_out = bit_out_reg;
    assign bit_valid = bit_valid_reg;
    assign symbol_lock = symbol_lock_reg;
    assign error_flag = error_flag_reg;
    
endmodule