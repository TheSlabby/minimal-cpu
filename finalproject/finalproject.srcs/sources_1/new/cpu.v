`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Walker McGilvary
// Final Project - ELEC 4200
// 12/3/2024


module cpu(
    input clk,
    input reset,
    output reg [7:0] AN,
    output reg [6:0] sevenseg_out,
    output reg [31:0] basic_out,
    input [7:0] input_1, // switches 0-7
    input [7:0] input_2  // switches 8-15
);
    parameter WIDTH = 32; //32-bit cpu (registers are 32-bit)
    parameter FETCH_STATE = 0;
    parameter EXECUTE_STATE = 1;
    parameter UPDATE_STATE = 2;
    parameter DONE_STATE = 3;


    // REGISTERS
    // 16 general purpose registers
    reg [WIDTH-1:0] registers [0:15];
    // alu inputs
    reg [WIDTH-1:0] alu_in1;
    reg [WIDTH-1:0] alu_in2;
    wire [WIDTH-1:0] alu_out;
    // program counter
    reg [WIDTH-1:0] pc;
    // instructions
    reg [15:0] instructions [255:0];
    reg [15:0] current_instruction; // 16-bit instructions
    // hold current state
    reg [1:0] STATE;
    
    
    
    // flags
    reg BRANCH_SUCCESS;
    
    
    
    // initialize instructions
    initial begin
        $readmemb("E:/ELEC 4200/FinalProject/finalproject/program.mem", instructions);
    end
    
    
    // PARSE CURRENT INSTRUCTION
    wire [2:0] opcode = current_instruction[15:13];
    wire [3:0] source_register = current_instruction[12:9];
    // next registers depend on opcode
    wire [3:0] destination_register = current_instruction[8:5]; // for mov
    wire [7:0] load_value = current_instruction[8:1]; // used as a constant that can be loaded, for LOAD CONSTANT instruction
    wire [2:0] alu_mode_wanted = current_instruction[4:2];
    wire [7:0] branch_destination = current_instruction[8:1];
    
    reg [2:0] alu_mode;
    
    // instantiate 32-bit ALU
        alu #(
            .WIDTH(32)
        ) alu_core (
            .alu_mode(alu_mode),
            .alu_in1(alu_in1),     // input 1 comes from source register
            .alu_in2(alu_in2), // input 2 comes from destination register
            .alu_out(alu_out)
        );

    
    
    
    // CPU LOOP - this has states:
    // 0 - fetch instruction (set current_instruction)
    // 1 - execute instruction
    // 2 - increment pc & update outputs (7seg, leds, ...)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 0;
            STATE <= 0;
            BRANCH_SUCCESS <= 0;
        end else begin
            case (STATE)
                FETCH_STATE: begin
                    STATE <= EXECUTE_STATE;
                    
                    current_instruction <= instructions[pc];
                end
                
                EXECUTE_STATE: begin
                    STATE <= UPDATE_STATE;
                    
                    // reset flags
                    BRANCH_SUCCESS <= 0;
                    
                    // run CPU instruction (like ALU execute, or something)
                    case (opcode)
                        3'b000: begin // MOV
                            registers[destination_register] <= registers[source_register];
                        end
                        
                        3'b001: begin // LOAD CONSTANT
                            registers[source_register] <= load_value;
                        end
                        
                        3'b010: begin // ARITHMETIC (use ALU)
                            // set ALU registers
                            alu_in1 <= registers[source_register];
                            alu_in2 <= registers[destination_register];
                            alu_mode <= alu_mode_wanted;
                        end
                        
                        3'b011: begin // SAVE ARITHMETIC
                            registers[source_register] <= alu_out;
                        end
                        
                        3'b100: begin // LOAD INPUT (FROM FPGA BOARD SWITCHES)
                            
                        end
                        
                        3'b101: begin // CONDITIONAL BRANCH (branch if register is zero)
                            if (registers[source_register] == 0) begin
                                pc <= branch_destination;
                                BRANCH_SUCCESS <= 1;
                            end
                        end
                        
                        3'b111: begin // END PROGRAM
                            STATE <= DONE_STATE;
                        end
                    endcase
                end 
                
                UPDATE_STATE: begin
                    STATE <= FETCH_STATE;
                    basic_out <= registers[15]; // mostly for debugging. just set this to reg 15
                    
                    if (BRANCH_SUCCESS == 0)
                        pc <= pc + 1;
                end
                
                DONE_STATE: begin
                    // we're done, so show done LED or something
                end
            endcase
            
        end
    end
    
endmodule
