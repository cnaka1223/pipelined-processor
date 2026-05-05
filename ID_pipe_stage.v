`timescale 1ns / 1ps


module ID_pipe_stage(
    input  clk, reset,
    input  [9:0] pc_plus4,
    input  [31:0] instr,
    input  mem_wb_reg_write,
    input  [4:0] mem_wb_write_reg_addr,
    input  [31:0] mem_wb_write_back_data,
    input  Data_Hazard,
    input  Control_Hazard,
    output [31:0] reg1, reg2,
    output [31:0] imm_value,
    output [9:0] branch_address,
    output [9:0] jump_address,
    output branch_taken,
    output [4:0] destination_reg, 
    output mem_to_reg,
    output [1:0] alu_op,
    output mem_read,  
    output mem_write,
    output alu_src,
    output reg_write,
    output jump
    );
    
    // write your code here 
    // Remember that we test if the branch is taken or not in the decode stage. 	
    
    wire branch;
    wire eq_test_result;
    assign eq_test_result = ((reg1 ^ reg2 ) == 32'd0) ? 1'b1 : 1'b0;
    assign branch_taken = eq_test_result & branch;
    assign jump_address = instr[25:0] << 2;
    wire [31:0] sign_extend_instr;
    
    sign_extend extend(
        .sign_ex_in(instr[15:0]),
        .sign_ex_out(sign_extend_instr)
        );
    assign imm_value = sign_extend_instr;
    assign branch_address = (sign_extend_instr << 2) + pc_plus4;
    wire reg_dst;
   wire mem_to_reg_c, mem_read_c, mem_write_c, alu_src_c, reg_write_c;
   wire [1:0] alu_op_c;
   
    control control_unit(
        .reset(reset),
        .opcode(instr[31:26]),
        .reg_dst(reg_dst),
        .mem_to_reg(mem_to_reg_c),
        .alu_op(alu_op_c),
        .mem_read(mem_read_c),
        .mem_write(mem_write_c),
        .alu_src(alu_src_c),
        .reg_write(reg_write_c),
        .branch(branch),
        .jump(jump)
        );     
    
    register_file reg_file(
        .clk(clk),
        .reset(reset),
        .reg_write_en(mem_wb_reg_write),
        .reg_write_dest(mem_wb_write_reg_addr),
        .reg_write_data(mem_wb_write_back_data),
        .reg_read_addr_1(instr[25:21]),
        .reg_read_addr_2(instr[20:16]),
        .reg_read_data_1(reg1),
        .reg_read_data_2(reg2)
        );
         
    mux2 # (.mux_width(5)) reg_dst_mux
(   .a(instr[20:16]),
    .b(instr[15:11]),
    .sel(reg_dst),
    .y(destination_reg)
    );
    
    assign mem_to_reg = (~Data_Hazard | Control_Hazard) ? 0 : mem_to_reg_c;
    assign alu_op = (~Data_Hazard | Control_Hazard) ? 0 : alu_op_c;
    assign mem_read = (~Data_Hazard | Control_Hazard) ? 0 : mem_read_c;
    assign mem_write = (~Data_Hazard | Control_Hazard) ? 0 : mem_write_c;
    assign alu_src = (~Data_Hazard | Control_Hazard) ? 0 : alu_src_c;
    assign reg_write = (~Data_Hazard | Control_Hazard) ? 0 : reg_write_c;
    
    
    
        
       
endmodule
