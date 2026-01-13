`timescale 1ns / 1ps

module fpga_top (
    // Clock and Reset
    input wire clk_100mhz,        // FPGA board clock
    input wire reset_btn,         // Reset button (active high)
    
    // Switches for Input Control
    input wire [15:0] sw,         // 16 switches
    
    // LEDs for Output Display
    output wire [15:0] led,       // 16 LEDs
    
    // 7-segment display
    output wire [6:0] seg,        // 7-segment cathodes
    output wire [3:0] an,         // 7-segment anodes
    
    // UART (unused but required for constraints)
    input wire uart_rxd,
    output wire uart_txd
);

    // *SIMPLIFIED APPROACH: Use only 100MHz clock with enable signals*
    // This eliminates clock domain crossing issues entirely
    
    // Reset synchronizer
    reg reset_sync1 = 1'b1;
    reg reset_sync2 = 1'b1;
    wire reset_n;
    
    // Switch synchronizers  
    reg [15:0] sw_sync1;
    reg [15:0] sw_sync2;
    wire [15:0] sw_stable;
    
    // Clock enable for slow operations (~1Hz)
    reg [26:0] slow_clk_counter = 27'd0;
    reg slow_clk_enable = 1'b0;
    
    // Demodulator signals
    reg [15:0] i_data = 16'd0;
    reg [15:0] q_data = 16'd0;
    reg iq_valid = 1'b0;
    wire [1:0] bit_output;
    wire bit_valid;
    wire symbol_lock;
    wire error_flag;
    
    // Test pattern generator
    reg [1:0] test_counter = 2'b00;
    reg test_active = 1'b0;
    
    // Output registers
    reg [15:0] led_reg = 16'd0;
    reg [6:0] seg_reg = 7'b1111111;
    reg [3:0] an_reg = 4'b1110;
    
    // **FIX: Add register to hold the last valid bit output for 7-segment display**
    reg [1:0] last_bit_output = 2'b00;

    // *Step 1: Proper Reset Synchronizer*
    always @(posedge clk_100mhz or posedge reset_btn) begin
        if (reset_btn) begin
            reset_sync1 <= 1'b1;
            reset_sync2 <= 1'b1;
        end else begin
            reset_sync1 <= 1'b0;
            reset_sync2 <= reset_sync1;
        end
    end
    
    assign reset_n = ~reset_sync2;
    
    // *Step 2: Switch Synchronizer*
    always @(posedge clk_100mhz) begin
        if (reset_sync2) begin
            sw_sync1 <= 16'd0;
            sw_sync2 <= 16'd0;
        end else begin
            sw_sync1 <= sw;
            sw_sync2 <= sw_sync1;
        end
    end
    
    assign sw_stable = sw_sync2;
    
    // *Step 3: Clock Enable Generator (instead of separate clock)*
    always @(posedge clk_100mhz) begin
        if (reset_sync2) begin
            slow_clk_counter <= 27'd0;
            slow_clk_enable <= 1'b0;
        end else begin
            if (slow_clk_counter == 27'd50000000) begin  // 1Hz enable
                slow_clk_counter <= 27'd0;
                slow_clk_enable <= 1'b1;
            end else begin
                slow_clk_counter <= slow_clk_counter + 1'b1;
                slow_clk_enable <= 1'b0;
            end
        end
    end
    
    // *Step 4: Test Pattern Generator*
    always @(posedge clk_100mhz) begin
        if (reset_sync2) begin
            test_counter <= 2'b00;
            test_active <= 1'b0;
            iq_valid <= 1'b0;
            i_data <= 16'd0;
            q_data <= 16'd0;
        end else begin
            // Default values
            iq_valid <= 1'b0;
            
            if (sw_stable[5] && sw_stable[4]) begin  // Auto test mode
                test_active <= 1'b1;
                if (slow_clk_enable) begin
                    test_counter <= test_counter + 1'b1;
                    iq_valid <= 1'b1;
                end
            end else begin
                test_active <= 1'b0;
                test_counter <= 2'b00;
                // Manual mode
                if (sw_stable[4]) begin  // Manual enable
                    iq_valid <= 1'b1;
                end
            end
            
            // Generate I/Q patterns
            if (test_active) begin
                // Automatic cycling through quadrants
                case (test_counter)
                    2'b00: begin  // +I, +Q -> "00"
                        i_data <= 16'sd1000;
                        q_data <= 16'sd1000;
                    end
                    2'b01: begin  // -I, +Q -> "01"
                        i_data <= -16'sd1000;
                        q_data <= 16'sd1000;
                    end
                    2'b10: begin  // -I, -Q -> "11"
                        i_data <= -16'sd1000;
                        q_data <= -16'sd1000;
                    end
                    2'b11: begin  // +I, -Q -> "10"
                        i_data <= 16'sd1000;
                        q_data <= -16'sd1000;
                    end
                endcase
            end else begin
                // Manual control
                if (sw_stable[6]) begin
                    i_data <= 16'sd1000;
                end else begin
                    i_data <= -16'sd1000;
                end
                
                if (sw_stable[7]) begin
                    q_data <= 16'sd1000;
                end else begin
                    q_data <= -16'sd1000;
                end
            end
        end
    end
    
    // *Step 5: Instantiate QPSK Demodulator*
    qpsk_demodulator #(
        .DATA_WIDTH(16)
    ) qpsk_inst (
        .clk(clk_100mhz),
        .reset(reset_sync2),
        .i_data(i_data),
        .q_data(q_data),
        .iq_valid(iq_valid),
        .bit_out(bit_output),
        .bit_valid(bit_valid),
        .symbol_lock(symbol_lock),
        .error_flag(error_flag)
    );
    
    // **FIX: Capture and hold the last valid bit output**
    always @(posedge clk_100mhz) begin
        if (reset_sync2) begin
            last_bit_output <= 2'b00;
        end else begin
            if (bit_valid) begin
                last_bit_output <= bit_output;
            end
        end
    end
    
    // *Step 6: Output Logic*
    always @(posedge clk_100mhz) begin
        if (reset_sync2) begin
            led_reg <= 16'd0;
            seg_reg <= 7'b1111111;
            an_reg <= 4'b1110;
        end else begin
            // LED assignments
            led_reg[1:0] <= bit_output;
            led_reg[2] <= bit_valid;
            led_reg[3] <= symbol_lock;
            led_reg[4] <= error_flag;
            led_reg[8:5] <= sw_stable[3:0];  // Data rate
            led_reg[9] <= test_active;
            led_reg[11:10] <= test_counter;
            led_reg[15:12] <= 4'd0;
            
            // **FIX: 7-segment display - use last_bit_output instead of bit_output**
            // This holds the value continuously instead of only when bit_valid is high
            case (last_bit_output)
                2'b00: seg_reg <= 7'b1000000; // "0"
                2'b01: seg_reg <= 7'b1111001; // "1" 
                2'b10: seg_reg <= 7'b0100100; // "2"
                2'b11: seg_reg <= 7'b0110000; // "3"
            endcase
            
            an_reg <= 4'b1110; // Enable first digit
        end
    end
    
    // Output assignments
    assign led = led_reg;
    assign seg = seg_reg;
    assign an = an_reg;
    assign uart_txd = 1'b1;

endmodule