`timescale 1ns / 1ps

module tb;

// Testbench signals
reg clk;
reg resetn;
reg btn_clk;
reg [1:0] input_sel;
reg input_valid;
reg [31:0] input_value;
wire lcd_rst, lcd_cs, lcd_rs, lcd_wr, lcd_rd, lcd_bl_ctr;
wire ct_int, ct_sda, ct_scl, ct_rstn;
wire [31:0] display_value;  // 32-bit data displayed on the screen

// Instantiate the DUT (Device Under Test)
single_cycle_cpu_display uut (
    .clk(clk),
    .resetn(resetn),
    .input_sel(input_sel),
    .btn_clk(btn_clk),
    .lcd_rst(lcd_rst),
    .lcd_cs(lcd_cs),
    .lcd_rs(lcd_rs),
    .lcd_wr(lcd_wr),
    .lcd_rd(lcd_rd),
    .lcd_bl_ctr(lcd_bl_ctr),
    .ct_int(ct_int),
    .ct_sda(ct_sda),
    .ct_scl(ct_scl),
    .ct_rstn(ct_rstn)
);

// Clock generation
always begin
    #5 clk = ~clk;  // 100 MHz clock (5ns period)
end

// Testbench procedure
initial begin
    // Initialize signals
    clk = 0;
    resetn = 0;
    btn_clk = 0;
    input_sel = 2'd0;
    input_valid = 0;
    input_value = 32'd0;

    // Apply reset
    #10 resetn = 1;
    #10 resetn = 0;
    #10 resetn = 1;

    // Test Case 1: Write `input_n` to register $2 (select `input_sel = 2'd0`)
    #10 input_sel = 2'd0; input_valid = 1; input_value = 32'd100;  // Set input_n = 100
    #10 input_valid = 0;

    // Test Case 2: Write `input_a` to register $1 (select `input_sel = 2'd1`)
    #10 input_sel = 2'd1; input_valid = 1; input_value = 32'd50;   // Set input_a = 50
    #10 input_valid = 0;

    // Test Case 3: Write a new value to `input_n` and `input_a`
    #10 input_sel = 2'd0; input_valid = 1; input_value = 32'd200;  // Set input_n = 200
    #10 input_valid = 0;

    #10 input_sel = 2'd1; input_valid = 1; input_value = 32'd150;  // Set input_a = 150
    #10 input_valid = 0;

    // Test Case 4: Toggle `btn_clk` for single-step execution
    #10 btn_clk = 1;
    #10 btn_clk = 0;

    // Test Case 5: Monitor the display value (output)
    #10 input_sel = 2'd2; input_valid = 1; input_value = 32'd1;  // Observe display value for register $1
    #10 input_valid = 0;
    #10 input_sel = 2'd2; input_valid = 1; input_value = 32'd2;  // Observe display value for register $2
    #10 input_valid = 0;

    // Finish the simulation
    #10 $finish;
end

endmodule
