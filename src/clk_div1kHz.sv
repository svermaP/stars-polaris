`default_nettype none
module clk_div1kHz (
    input logic clk_12mhz, // 12MHz system clock
    input logic reset_n, // Active-low reset
    output logic pid_clk_en, // 1kHz clock enable pulse
    output logic sck
);

// Counter for 1kHz generation (12MHz/12,000 = 1kHz)
logic [16:0] counter; // 14-bit counter (max 16,383 > 11,999)


// count before imu test was 11_999


always_ff @(posedge clk_12mhz or negedge reset_n) begin
    if (!reset_n) begin
        counter <= 0;
        pid_clk_en <= 0;
    end else begin
        // Default assignment
        pid_clk_en <= 0;
        
        // Count to 11,999 (0-11,999 = 12,000 cycles for 12MHz/1kHz)
        if (counter == 17'd5999) begin
            counter <= 0;
            pid_clk_en <= 1; // Single-cycle enable pulse
        end else begin
            counter <= counter + 1;
        end
    end
end

always_comb begin
    sck = 0;
    if (counter < 3000) begin
        sck = 1;
    end
end

endmodule




// 100 hZ


// `default_nettype none

// module clk_div1kHz (
//     input logic clk_12mhz,    // 10MHz system clock
//     input logic reset_n,      // Active-low reset
//     output logic pid_clk_en  // 100Hz clock enable pulse
// );

//     logic [29:0] ctr = 0;
//     always @ (posedge clk_12mhz, negedge reset_n) begin
//         if (~reset_n) begin
//             pid_clk_en <= 1'b0;
//         end else if (ctr == 2999) begin
//             ctr <= 0;
//             pid_clk_en <= ~pid_clk_en;
//         end else begin
//             ctr <= ctr + 1;
//         end
//     end

    //2999
    // 5999
    // Counter for 100Hz generation (10MHz/100,000 = 100Hz)


    // logic [16:0] counter;     // 17-bit counter (needs to count to 99,999)

    // always_ff @(posedge clk_12mhz or negedge reset_n) begin
    //     if (!reset_n) begin
    //         counter <= 0;
    //         pid_clk_en <= 0;
    //     end else begin
    //         // Default assignment
    //         pid_clk_en <= 0;
            
    //         // Count to 99,999 (0-99,999 = 100,000 cycles for 10MHz/100Hz)
    //         if (counter == 17'd99_999) begin
    //             counter <= 0;
    //             pid_clk_en <= 1;      // Single-cycle enable pulse
    //         end else begin
    //             counter <= counter + 1;
    //         end
    //     end
    // end

// endmodule


// 1 hZ

// `default_nettype none

// module clk_div1kHz (
//     input logic clk_12mhz,    // 10MHz system clock
//     input logic reset_n,      // Active-low reset
//     output logic pid_clk_en  // 1Hz clock enable pulse
// );

//     // Counter for 1Hz generation (10MHz/10,000,000 = 1Hz)
//     logic [23:0] counter;     // 24-bit counter (needs to count to 9,999,999)

//     always_ff @(posedge clk_12mhz or negedge reset_n) begin
//         if (!reset_n) begin
//             counter <= 0;
//             pid_clk_en <= 0;
//         end else begin
//             // Default assignment
//             pid_clk_en <= 0;
            
//             // Count to 9,999,999 (0-9,999,999 = 10,000,000 cycles for 10MHz/1Hz)
//             if (counter == 24'd9_999_999) begin
//                 counter <= 0;
//                 pid_clk_en <= 1;      // Single-cycle enable pulse
//             end else begin
//                 counter <= counter + 1;
//             end
//         end
//     end

// endmodule


// 10 Hz
// `default_nettype none

// module clk_div1kHz (
//     input logic clk_12mhz,    // 10MHz system clock
//     input logic reset_n,      // Active-low reset
//     output logic pid_clk_en  // 10Hz clock enable pulse
// );

//     // Counter for 10Hz generation (10MHz/1,000,000 = 10Hz)
//     logic [19:0] counter;     // 20-bit counter (needs to count to 999,999)

//     always_ff @(posedge clk_12mhz or negedge reset_n) begin
//         if (!reset_n) begin
//             counter <= 0;
//             pid_clk_en <= 0;
//         end else begin
//             // Default assignment
//             pid_clk_en <= 0;
            
//             // Count to 999,999 (0-999,999 = 1,000,000 cycles for 10MHz/10Hz)
//             if (counter == 20'd999_999) begin
//                 counter <= 0;
//                 pid_clk_en <= 1;      // Single-cycle enable pulse
//             end else begin
//                 counter <= counter + 1;
//             end
//         end
//     end

// endmodule

// `default_nettype none

// module clk_div1kHz (
//     input logic clk_12mhz,    // 10MHz system clock
//     input logic reset_n,      // Active-low reset
//     output logic pid_clk_en // 200Hz clock enable pulse
// );

//     // Counter for 200Hz generation (10MHz/50,000 = 200Hz)
//     logic [15:0] counter;     // 16-bit counter (needs to count to 49,999)

//     always_ff @(posedge clk_12mhz or negedge reset_n) begin
//         if (!reset_n) begin
//             counter <= 0;
//             pid_clk_en <= 0;
//         end else begin
//             // Default assignment
//             pid_clk_en <= 0;
            
//             // Count to 49,999 (0-49,999 = 50,000 cycles for 10MHz/200Hz)
//             if (counter == 16'd49_999) begin
//                 counter <= 0;
//                 pid_clk_en <= 1;      // Single-cycle enable pulse
//             end else begin
//                 counter <= counter + 1;
//             end
//         end
//     end

// endmodule