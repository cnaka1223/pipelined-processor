`timescale 1ns / 1ps

module EX_pipe_stage(
    input [31:0] id_ex_instr,
    input [31:0] reg1, reg2,
    input [31:0] id_ex_imm_value,
    input [31:0] ex_mem_alu_result,
    input [31:0] mem_wb_write_back_result,
    input id_ex_alu_src,
    input [1:0] id_ex_alu_op,
    input [1:0] Forward_A, Forward_B,
    output [31:0] alu_in2_out,
    output [31:0] alu_result
    );
    
    // Write your code here
    wire [31:0] reg1_mux_out;
    wire [31:0] reg2_mux_out;
    wire [31:0] imm_value_mux_out;
    wire [3:0] alu_control;
    wire zero;
    
    ALUControl alu_control_inst(
        .ALUOp(id_ex_alu_op),
        .Function(id_ex_instr[5:0]),
        .ALU_Control(alu_control)
        );
    
    ALU alu_inst(
        .a(reg1_mux_out),
        .b(imm_value_mux_out),
        .alu_control(alu_control),
        .zero(zero),
        .alu_result(alu_result)
        );
    
    mux4 # (.mux_width(32)) reg1_mux
(   .a(reg1),
    .b(mem_wb_write_back_result),
    .c(ex_mem_alu_result),
    .d(0),
    .sel(Forward_A),
    .y(reg1_mux_out)
    );    
    
    mux4 # (.mux_width(32)) reg2_mux
(   .a(reg2),
    .b(mem_wb_write_back_result),
    .c(ex_mem_alu_result),
    .d(0),
    .sel(Forward_B),
    .y(reg2_mux_out)
    ); 
    
    assign alu_in2_out = reg2_mux_out; 
    
    mux2 # (.mux_width(32)) imm_value_mux
(   .a(reg2_mux_out),
    .b(id_ex_imm_value),
    .sel(id_ex_alu_src),
    .y(imm_value_mux_out)
    ); 
       
endmodule
