`timescale 1ns / 1ps


  module IF_pipe_stage(
    input clk, reset,
    input en,
    input [9:0] branch_address,
    input [9:0] jump_address,
    input branch_taken,
    input jump,
    output [9:0] pc_plus4,
    output [31:0] instr
    );
    
// write your code here
   reg [9:0] PC;
   wire [9:0] jump_out_wire, branch_out_wire;
   
   assign pc_plus4 = PC + 4;
   
   instruction_mem inst_mem(
   .read_addr(PC),
   .data(instr)
   );
   
   mux2 # (.mux_width(10)) branch_mux
(   .a(pc_plus4),
    .b(branch_address),
    .sel(branch_taken),
    .y(branch_out_wire)
    );
    
    mux2 # (.mux_width(10)) jump_mux
(   .a(branch_out_wire),
    .b(jump_address),
    .sel(jump),
    .y(jump_out_wire)
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            PC <= 0;
        else if (en)
            PC <= jump_out_wire;
     end
                          
endmodule
