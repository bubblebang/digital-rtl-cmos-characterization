`timescale 1ns / 1ps 
module FSM_tb;
    
    reg clk;
    reg rst;
    reg data;
    wire out;

    FSM uut (
        .clk(clk),
        .rst(rst),
        .data(data),
        .out(out)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task drive_bit;
        input x;
        begin
            @ (negedge clk);
            data = x;
        end
    endtask

    initial begin
        rst = 0;
        data = 0;
        #20;
        rst = 1;

        drive_bit(1);
        drive_bit(1); 
        drive_bit(0);
        drive_bit(1);
        drive_bit(1);
        drive_bit(0);
        drive_bit(1); // pattern found
        drive_bit(1); // back to S5
        #50;
        $stop;
    end

    initial begin
        $monitor("Time = %0t | State = %d | Input = %b | Output = %b", $time, uut.current_state, data, out);
    end
endmodule
