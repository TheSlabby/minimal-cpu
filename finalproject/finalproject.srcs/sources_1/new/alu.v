`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ALU MODULE


module alu #(parameter WIDTH = 32)(
    input [2:0] alu_mode,
    input [WIDTH-1:0] alu_in1, alu_in2,
    output reg [WIDTH-1:0] alu_out
);
    
    // alu always executing
    always @(*) begin
        case (alu_mode)
            3'b000: begin // ADD
                alu_out <= alu_in1 + alu_in2;
            end
            
            3'b001: begin // SUB
                alu_out <= alu_in1 - alu_in2;
            end
            
            3'b010: begin // MULTIPLY
                alu_out <= alu_in1 * alu_in2;
            end
            
            3'b101: begin // EQUAL TO
                alu_out <= (alu_in1 == alu_in2) ? 1 : 0;
            end
            
            default: alu_out <= 0;
        endcase
    end
endmodule
