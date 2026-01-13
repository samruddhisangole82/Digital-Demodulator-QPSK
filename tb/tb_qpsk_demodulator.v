// Testbench for FPGA Top Module
// Tests the complete QPSK system with automatic test pattern generation

`timescale 1ns / 1ps

module tb_fpga_top;

    // Clock period
    parameter CLK_PERIOD = 10;  // 100 MHz = 10ns period
    
    // Inputs
    reg clk_100mhz;
    reg reset_btn;
    reg [15:0] sw;
    reg uart_rxd;
    
    // Outputs
    wire [15:0] led;
    wire [6:0] seg;
    wire [3:0] an;
    wire uart_txd;
    
    // Instantiate the Unit Under Test (UUT)
    fpga_top uut (
        .clk_100mhz(clk_100mhz),
        .reset_btn(reset_btn),
        .sw(sw),
        .led(led),
        .seg(seg),
        .an(an),
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd)
    );
    
    // Clock generation
    initial begin
        clk_100mhz = 0;
        forever #(CLK_PERIOD/2) clk_100mhz = ~clk_100mhz;
    end
    
    // Test stimulus
    initial begin
        // Initialize signals
        $display("========================================");
        $display("FPGA Top Module Test Starting...");
        $display("========================================");
        
        reset_btn = 1;
        sw = 16'h0000;
        uart_rxd = 1;
        
        // Hold reset for a while
        #200;
        reset_btn = 0;
        $display("Reset released at %0t ns", $time);
        
        // Wait for system to stabilize
        #500;
        
        // Test 1: Manual Mode - Test all quadrants
        $display("\n--- Test 1: Manual Mode ---");
        
        // Quadrant 1: +I, +Q (sw[7]=1, sw[6]=1, sw[4]=1 for enable)
        sw = 16'h00D0;  // sw[7:6]=11, sw[4]=1
        $display("Manual: Quadrant 1 (+I,+Q) at %0t ns", $time);
        #1000;
        $display("  LED[1:0] = %b (expected 00)", led[1:0]);
        
        // Quadrant 2: -I, +Q (sw[7]=1, sw[6]=0, sw[4]=1)
        sw = 16'h0090;  // sw[7]=1, sw[6]=0, sw[4]=1
        $display("Manual: Quadrant 2 (-I,+Q) at %0t ns", $time);
        #1000;
        $display("  LED[1:0] = %b (expected 01)", led[1:0]);
        
        // Quadrant 3: -I, -Q (sw[7]=0, sw[6]=0, sw[4]=1)
        sw = 16'h0010;  // sw[7]=0, sw[6]=0, sw[4]=1
        $display("Manual: Quadrant 3 (-I,-Q) at %0t ns", $time);
        #1000;
        $display("  LED[1:0] = %b (expected 11)", led[1:0]);
        
        // Quadrant 4: +I, -Q (sw[7]=0, sw[6]=1, sw[4]=1)
        sw = 16'h0050;  // sw[7]=0, sw[6]=1, sw[4]=1
        $display("Manual: Quadrant 4 (+I,-Q) at %0t ns", $time);
        #1000;
        $display("  LED[1:0] = %b (expected 10)", led[1:0]);
        
        // Test 2: Automatic Mode
        $display("\n--- Test 2: Automatic Test Mode ---");
        sw = 16'h0030;  // sw[5]=1, sw[4]=1 for auto test mode
        $display("Automatic mode enabled at %0t ns", $time);
        $display("Waiting for automatic cycling through quadrants...");
        
        // Wait for several automatic cycles (slow_clk is 1Hz, so 1 second per cycle)
        // In simulation, we can speed this up or just observe a few transitions
        #5000;
        
        $display("\nTest Pattern Observations:");
        $display("  LED[9] (test_active) = %b", led[9]);
        $display("  LED[11:10] (test_counter) = %b", led[11:10]);
        $display("  LED[1:0] (bit_output) = %b", led[1:0]);
        $display("  LED[2] (bit_valid) = %b", led[2]);
        $display("  LED[3] (symbol_lock) = %b", led[3]);
        $display("  LED[4] (error_flag) = %b", led[4]);
        
        // Disable automatic mode
        sw = 16'h0000;
        #1000;
        
        $display("\n========================================");
        $display("FPGA Top Module Test Complete!");
        $display("========================================");
        $display("Check waveform for detailed signal transitions");
        $display("Expected behavior:");
        $display("  - Manual mode: LED[1:0] follows quadrant selection");
        $display("  - Auto mode: LED[1:0] cycles through 00->01->11->10");
        $display("  - bit_valid pulses high when new data is ready");
        $display("  - symbol_lock should be high during operation");
        $display("========================================");
        
        #1000;
        $finish;
    end
    
    // Monitor key signals
    initial begin
        $monitor("Time=%0t | Reset=%b | SW=%h | LED=%h | bit_out=%b bit_valid=%b lock=%b err=%b", 
                 $time, reset_btn, sw, led, led[1:0], led[2], led[3], led[4]);
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("tb_fpga_top.vcd");
        $dumpvars(0, tb_fpga_top);
    end
    
endmodule