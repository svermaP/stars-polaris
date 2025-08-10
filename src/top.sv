`default_nettype none

module top(
    input logic clk, reset,
    input logic [2:0] inputs,
    output logic [9:0] outputs
);

    stabilizer dut (
        .hz100(clk),
        .reset(reset),
        .pb({2'b0, inputs[2], 15'b0, inputs[1:0], 1'b0}),
        .left({7'b0, outputs[2:0]}),
        .right({2'b0, outputs[7:4], 1'b0, outputs[3]})
        .ss0({outputs[9], 5'b0, outputs[8], 1'b0})
    );

    // input output connections:
    /*
        inputs[0] -> pb[1] -> SDO from IMU
        inputs[1] -> pb[2] -> SDI from shift register for IR interface
        inputs[2] -> pb[18] -> Enable IMU

        outputs[0] -> left[0] -> SDI into IMU
        outputs[1] -> left[1] -> SCLK into IMU
        outputs[2] -> left[2] -> CS into IMU
        outputs[3] -> right[0] -> SDO into LCD Display // optional
        outputs[4] -> right[2] -> PWM out for X axis servo
        outputs[5] -> right[3] -> PWM out for Y axis servo
        outputs[6] -> right[4] -> SCLK into shift register
        outputs[7] -> right[5] -> Latch for shift register
        outputs[8] -> ss0[1] -> CS into LCD // optional
        outputs[9] -> ss0[7] -> SCLK into LCD // optional



    */


    // once connected -- compile, synthesize, or cram, and view results!


endmodule