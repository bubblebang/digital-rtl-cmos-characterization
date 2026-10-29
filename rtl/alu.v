////////////////////////////////////////////////////////////////
//
// Module: HW2_alu.v
// Author: Ang Chen
//         angchen@ucla.edu
//
// Description:
//      ALU for HW2
//
// Parameters:
//      (List parameters and their descriptions here)
//
// Inputs:
//      (List inputs and their descriptions here)
//
// Outputs:
//      (List outputs and their descriptions here)
//
////////////////////////////////////////////////////////////////

module HW2_alu ( 
    clk_p_i,
    reset_n_i,
    data_a_i,
    data_b_i,
    inst_i,
    data_o
    );

////////////////////////////////////////////////////////////////
//  Inputs & Outputs
input           clk_p_i;
input           reset_n_i;
input   [7:0]   data_a_i;
input   [7:0]   data_b_i;
input   [2:0]   inst_i;

output  [15:0]  data_o;
	
////////////////////////////////////////////////////////////////
//  reg & wire declarations
wire    [15:0]   out_inst_0; // Unsigned Add
wire    [15:0]   out_inst_1; // Unsigned Sub
wire    [15:0]   out_inst_2; // Unsigned Multiply
wire    [15:0]   out_inst_3; // Bitwise AND
wire    [15:0]   out_inst_4; // Bitwise XOR
wire    [15:0]   out_inst_5; // ABS(a)
wire    [15:0]   out_inst_6; // (a-b)*4
wire    [15:0]   out_inst_7; // Unused

reg     [15:0]   ALU_out_inst;

wire    [15:0]   ALU_d2_w;

reg     [15:0]   ALU_d2_r;
reg     [7:0]    Data_A_o_r;
reg     [7:0]    Data_B_o_r;
reg     [2:0]    Inst_o_r;

////////////////////////////////////////////////////////////////
//  Combinational Logic
assign ALU_d2_w = ALU_out_inst;
assign data_o = ALU_d2_r;

// The output MUX
always @(*) begin
    case(Inst_o_r)
        3'b000:	    ALU_out_inst = out_inst_0; // Comment your code!
        3'b001:	    ALU_out_inst = out_inst_1;
        3'b010:	    ALU_out_inst = out_inst_2;
        3'b011:	    ALU_out_inst = out_inst_3;
        3'b100:	    ALU_out_inst = out_inst_4;
        3'b101:	    ALU_out_inst = out_inst_5;
        3'b110:	    ALU_out_inst = out_inst_6;
        3'b111:	    ALU_out_inst = out_inst_7;
        default:    ALU_out_inst = out_inst_7;
    endcase
end
///////////////////////////////////////////////////////////////
// ALU Operation Definition
assign out_inst_0 = {8'b0, Data_A_o_r} +{8'b0,  Data_B_o_r};


wire signed [8:0] diff;
assign diff =  $signed({1'b0, Data_B_o_r}) - $signed({1'b0, Data_A_o_r}); 
assign out_inst_1 = {{7{diff[8]}}, diff};

assign out_inst_2 = Data_A_o_r * Data_B_o_r;
assign out_inst_3 = {8'b0,(Data_A_o_r & Data_B_o_r)};
assign out_inst_4 = {8'b0,(Data_A_o_r ^ Data_B_o_r)};
assign out_inst_5 = Data_A_o_r[7]? (~{8'b1111_1111, Data_A_o_r})+16'b1 : {8'b0000_0000, Data_A_o_r};
assign out_inst_6 = {{7{diff[8]}},diff} << 2; 
assign out_inst_7 = 16'b0; 


//////////////////////////////////////////////////////////////
//  Registers
always @(posedge clk_p_i or negedge reset_n_i) begin
    if (reset_n_i == 1'b0) begin
        ALU_d2_r    <= {16{1'b0}};
        Data_A_o_r  <= {8{1'b0}};
        Data_B_o_r  <= {8{1'b0}};
        Inst_o_r    <= 3'b111;
    end
    else begin
        ALU_d2_r    <= ALU_d2_w;
        Data_A_o_r  <= data_a_i;
        Data_B_o_r  <= data_b_i;
        Inst_o_r    <= inst_i; 
    end
end


endmodule
