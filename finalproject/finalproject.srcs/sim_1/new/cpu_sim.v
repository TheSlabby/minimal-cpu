`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module cpu_sim;
    // Testbench signals
    reg clk = 0;
    reg reset;
    wire [7:0] DISPLAY_AN;
    wire [6:0] DISPLAY_OUT;
    wire [31:0] basic_out;
    reg [7:0] input_1;
    reg [7:0] input_2;
    
    // Instance of CPU
    cpu cpu_inst(
        .clk(clk),
        .reset(reset),
        .DISPLAY_AN(DISPLAY_AN),
        .DISPLAY_OUT(DISPLAY_OUT),
        .basic_out(basic_out),
        .input_1(input_1),
        .input_2(input_2)
    );
    
    // Clock generation (100MHz - 10ns period)
    always begin
        #2 clk = ~clk;
    end
    
    
    
    // Test sequence
    initial begin
        $display("First instruction: %b", cpu_inst.instructions[0]);
        $display("Second instruction: %b", cpu_inst.instructions[1]);

        // Initialize inputs
        reset = 1;
        input_1 = 0;
        input_2 = 0;
        
        // Hold reset for a few cycles
        #20;
        reset = 0;
        
        #40;
        input_1 = 3;
        input_2 = 7;
        
        #100; // basic out should be equal to 10
        input_1 = 6;
        input_2 = 10;
        
        #100; // basic out should be 16
        
        #1600;
                
        // End simulation
        $finish;
    end
    
    // Monitor changes
//    initial begin
//        $monitor("Time=%0t reset=%b pc=%d instruction=%h state=%d basic_out=%h", 
//                 $time, reset, cpu_inst.pc, cpu_inst.current_instruction, 
//                 cpu_inst.STATE, basic_out);
//    end
    

endmodule