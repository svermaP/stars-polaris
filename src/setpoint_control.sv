`default_nettype none
module setpoint_control(
    input logic clk,
    input logic rst_n,
    input logic clk_en,
    input logic ball_detected,
    input logic [3:0] x_pos_calc, // 0-7 sensor position (0=bottom, 7=top)
    input logic [3:0] y_pos_calc, // 0-4 sensor position (0=right, 4=left)
    output logic signed [15:0] setpoint_x, 
    output logic signed [15:0] setpoint_y,
    output logic [1:0] state_out
);

// State indication: ball detected or not
assign state_out = ball_detected ? 2'b01 : 2'b00;

// Previous position tracking for jerk detection
logic [3:0] x_pos_prev, y_pos_prev;
logic ball_detected_prev;
logic entering_deadzone;

// Track previous positions on clock edge
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        x_pos_prev <= 4'b0;
        y_pos_prev <= 4'b0;
        ball_detected_prev <= 1'b0;
    end else if (clk_en) begin
        x_pos_prev <= x_pos_calc;
        y_pos_prev <= y_pos_calc;
        ball_detected_prev <= ball_detected;
    end
end

    always_comb begin
        // Edge midpoint cases - single axis control (adjusted for weighted center)
        if (x_pos_calc == 0 && y_pos_calc == 2) begin
            // Bottom edge midpoint → tilt only in Y direction (push toward center)
            setpoint_x = 16'sd0; 
            setpoint_y = 16'sd10;

        end else if (x_pos_calc == 7 && y_pos_calc == 2) begin
            // Top edge midpoint → tilt only in Y direction (push toward center)
            setpoint_x = 16'sd0; 
            setpoint_y = -16'sd10;

        end
        else if (y_pos_calc == 0 && x_pos_calc >= 3 && x_pos_calc <= 4) begin
            // Right edge midpoint → tilt only in X direction (push toward center)
            setpoint_y = 16'sd0; 
            setpoint_x = -16'sd10;

        end
        else if (y_pos_calc == 4 && x_pos_calc >= 3 && x_pos_calc <= 4) begin
            // Left edge midpoint → tilt only in X direction (push toward center)
            setpoint_y = 16'sd0; 
            setpoint_x = 16'sd10;

        end
        
        else if (x_pos_calc <= 2 && y_pos_calc <= 1) begin
            // Bottom-right quadrant → push left & up
            setpoint_x = -16'sd10; 
            setpoint_y = 16'sd10;

        end
        else if (x_pos_calc >= 4 && y_pos_calc <= 2) begin
            // Top-right quadrant → push left & down
            setpoint_x = -16'sd10; 
            setpoint_y = -16'sd10;

        end
        else if (x_pos_calc <= 2 && y_pos_calc >= 3) begin
            // Bottom-left quadrant → push right & up
            setpoint_x = 16'sd10; 
            setpoint_y = 16'sd10;

        end
        else if (x_pos_calc >= 4 && y_pos_calc >= 2) begin
            // Top-left quadrant → push right & down
            setpoint_x = -16'sd10; 
            setpoint_y = 16'sd10; 
        end else begin
            setpoint_x = 16'sd0;
            setpoint_y = 16'sd0;
        end
    end


endmodule