module FSM (
    input clk,
    input rst,
    input data,
    output reg out
);

reg [2:0] current_state, next_state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;
parameter S6 = 3'b110;
parameter S7 = 3'b111;

// sequential logic: state update
always @(posedge clk or negedge rst) begin
    if (!rst)
        current_state <= S0;
    else   
        current_state <= next_state;
end

// combinational logic: next state
always @(*) begin
    case(current_state)
        S0: next_state = (data) ? S1:S0;
        S1: next_state = (data) ? S2:S0; 
        S2: next_state = (data) ? S2:S3;
        S3: next_state = (data) ? S4:S0;
        S4: next_state = (data) ? S5:S0;
        S5: next_state = (data) ? S2:S6;
        S6: next_state = (data) ? S7:S0;
        S7: next_state = (data) ? S5:S0;
        default: next_state = S0;   
    endcase
end

// combinational logic: output
always @(*) begin
    if (current_state == S7)
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule