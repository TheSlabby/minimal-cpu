`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module cpu_sim;
    // Testbench signals
    reg clk = 0;
    reg reset;
    wire [7:0] AN;
    wire [6:0] sevenseg_out;
    wire [31:0] basic_out;
    reg [7:0] input_1;
    reg [7:0] input_2;
    
    // Instance of CPU
    cpu cpu_inst(
        .clk(clk),
        .reset(reset),
        .AN(AN),
        .sevenseg_out(sevenseg_out),
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
        
        // Hold reset for a few cycles
        #20;
        reset = 0;
        
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