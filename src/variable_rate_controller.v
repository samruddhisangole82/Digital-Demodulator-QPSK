`timescale 1ns / 1ps

module variable_rate_controller #(
    parameter DATA_WIDTH = 16,
    parameter RATE_WIDTH = 4
) (
    // Clock and Reset
    input wire clk,
    input wire reset,
    
    // Rate Selection (from spacecraft command)
    input wire [RATE_WIDTH-1:0] rate_select,
    
    // Input data stream
    input wire [DATA_WIDTH-1:0] data_in,
    input wire data_valid_in,
    
    // Output data stream (rate converted)
    output reg [DATA_WIDTH-1:0] data_out,
    output reg data_valid_out,
    
    // Status outputs
    output reg [RATE_WIDTH-1:0] current_rate,
    output reg [31:0] symbol_rate,
    output reg ready
);

    // CCSDS Proximity Protocol Data Rates (in bps)
    function integer get_data_rate;
        input [3:0] index;
        begin
            case (index)
                4'd0:  get_data_rate = 1000;
                4'd1:  get_data_rate = 2000;
                4'd2:  get_data_rate = 4000;
                4'd3:  get_data_rate = 8000;
                4'd4:  get_data_rate = 16000;
                4'd5:  get_data_rate = 32000;
                4'd6:  get_data_rate = 64000;
                4'd7:  get_data_rate = 128000;
                4'd8:  get_data_rate = 256000;
                4'd9:  get_data_rate = 512000;
                4'd10: get_data_rate = 1000000;
                4'd11: get_data_rate = 2000000;
                4'd12: get_data_rate = 4000000;
                default: get_data_rate = 1000;
            endcase
        end
    endfunction
    
    // Internal signals
    reg [3:0] rate_index;
    integer current_data_rate;
    integer symbol_rate_int;
    reg [31:0] rate_counter;
    reg output_enable;
    
    // State machine for rate control
    localparam IDLE        = 2'd0;
    localparam RATE_CHANGE = 2'd1;
    localparam ACTIVE      = 2'd2;
    localparam WAIT_SYMBOL = 2'd3;
    
    reg [1:0] current_state;
    
    // Convert rate_select to array index
    always @(*) begin
        if (rate_select < 4'd13)
            rate_index = rate_select;
        else
            rate_index = 4'd0;
    end
    
    // Get current data rate from lookup table
    always @(*) begin
        current_data_rate = get_data_rate(rate_index);
    end
    
    // Calculate symbol rate (QPSK: symbol_rate = data_rate / 2)
    always @(*) begin
        symbol_rate_int = current_data_rate / 2;
    end
    
    // Output current configuration
    always @(*) begin
        if (rate_select < 4'd13)
            current_rate = rate_select;
        else
            current_rate = 4'd0;
            
        symbol_rate = symbol_rate_int;
    end
    
    // Main control process
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            data_out <= {DATA_WIDTH{1'b0}};
            data_valid_out <= 1'b0;
            rate_counter <= 32'd0;
            output_enable <= 1'b0;
            ready <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    ready <= 1'b1;
                    if (data_valid_in) begin
                        current_state <= RATE_CHANGE;
                        ready <= 1'b0;
                    end
                end
                
                RATE_CHANGE: begin
                    // Configure for new rate
                    rate_counter <= 32'd0;
                    output_enable <= 1'b1;
                    current_state <= ACTIVE;
                end
                
                ACTIVE: begin
                    // Process data at selected rate
                    if (data_valid_in) begin
                        data_out <= data_in;
                        data_valid_out <= output_enable;
                        current_state <= WAIT_SYMBOL;
                        rate_counter <= rate_counter + 1'b1;
                    end
                end
                
                WAIT_SYMBOL: begin
                    data_valid_out <= 1'b0;
                    if (rate_counter >= (symbol_rate_int/1000)) begin
                        current_state <= ACTIVE;
                        rate_counter <= 32'd0;
                    end
                end
            endcase
        end
    end
    
endmodule