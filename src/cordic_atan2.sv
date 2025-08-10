// not currently used, but easy to implement in complementary filter

`default_nettype none



module cordic_atan2 (
    input  logic             clk,
    input  logic             n_rst,
    input  logic             start,
    input  logic signed [15:0] x_in,            // signed 16-bit X
    input  logic signed [15:0] y_in,            // signed 16-bit Y
    output logic signed [15:0] angle_out,       // signed 17-bit Q8.8 (–180…+180)
    output logic             done
    // output logic signed [16:0] angle_full
    // // debug
    // output logic signed [16:0] z_reg_debug,
    // output logic signed [15:0] x_orig_debug,
    // output logic signed [15:0] y_orig_debug
);

    // localparam int N = 12;

    // shift-and-add registers
    logic signed [15:0] x_reg, y_reg;
    logic signed [16:0] z_reg;
    logic [3:0]         iter;
    logic               busy;
    // logic signed [15:0] angle_out;
    logic [16:0] angle_full;

    // latch inputs for quadrant decode
    logic signed [15:0] x_orig, y_orig;

    // 12-entry LUT of arctan(2^-i) in Q8.8, via individual assigns
    logic signed [15:0] atan_rom [0:11];
    assign atan_rom[0]  = 16'sd11520;  // 45.000°
    assign atan_rom[1]  = 16'sd6802;   // 26.565°
    assign atan_rom[2]  = 16'sd3597;   // 14.036°
    assign atan_rom[3]  = 16'sd1824;   // 7.125°
    assign atan_rom[4]  = 16'sd919;    // 3.576°
    assign atan_rom[5]  = 16'sd461;    // 1.790°
    assign atan_rom[6]  = 16'sd231;    // 0.895°
    assign atan_rom[7]  = 16'sd116;    // 0.448°
    assign atan_rom[8]  = 16'sd58;     // 0.224°
    assign atan_rom[9]  = 16'sd29;     // 0.112°
    assign atan_rom[10] = 16'sd15;     // 0.056°
    assign atan_rom[11] = 16'sd7;      // 0.028°

    // // debug out
    // assign z_reg_debug  = z_reg;
    // assign x_orig_debug = x_orig;
    // assign y_orig_debug = y_orig;

    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            x_reg     <= 0;
            y_reg     <= 0;
            z_reg     <= 0;
            iter      <= 0;
            busy      <= 0;
            done      <= 0;
            angle_full <= 0;
            x_orig    <= 0;
            y_orig    <= 0;
            angle_out <= 0;
        end else begin
            done <= 0;

            if (start && !busy) begin
                // latch inputs & prep CORDIC
                x_orig <= x_in;
                y_orig <= y_in;
                busy   <= 1;
                z_reg  <= 0;
                iter   <= 0;

                if (x_in >= 0) begin
                    // Q1 / Q4
                    x_reg <= x_in;
                    y_reg <= y_in;
                end else begin
                    // Q2 / Q3: force x positive
                    x_reg <= -x_in;
                    y_reg <=  y_in;
                end

            end else if (busy) begin
                // one CORDIC step
                if (y_reg >= 0) begin
                    x_reg <= x_reg + (y_reg >>> iter);
                    y_reg <= y_reg - (x_reg >>> iter);
                    z_reg <= z_reg + $signed(atan_rom[iter]);
                end else begin
                    x_reg <= x_reg - (y_reg >>> iter);
                    y_reg <= y_reg + (x_reg >>> iter);
                    z_reg <= z_reg - $signed(atan_rom[iter]);
                end

                // final iteration: quadrant correction
                if (iter == 4'd11) begin
                    if (x_orig >= 0) begin
                        // Q1 or Q4
                        angle_full <= z_reg;
                    end else if (y_orig >= 0) begin
                        // Q2:  180° - θ
                        angle_full <= 17'sd46080 - z_reg;
                    end else begin
                        // Q3: -180° + θ
                        angle_full <= -17'sd46080 - z_reg;
                    end

                    busy <= 0;
                    done <= 1;
                end

                iter <= iter + 1;
            end

            if (done) begin
                angle_out <= angle_full[16:1];
            end
        end
    end

endmodule
