`default_nettype none

module lcd_decoder(
    input  logic signed [15:0] tilt_x,
    input  logic signed [15:0] tilt_y,
    input  logic        [3:0]  ball_x_pos,    // 0–7
    input  logic        [3:0]  ball_y_pos,    // 0–4
    output logic       [31:0] out_x,
    output logic       [31:0] out_y,
    output logic [7:0] ball_x_lcd,
    output logic [7:0] ball_y_lcd
);

    // Internal signals for processing each axis
    logic [31:0] ascii_x, ascii_y;
    
    // Generate ASCII for X axis
    q8_8_to_ascii x_converter (
        .q8_8_in(tilt_x),
        .ascii_out(ascii_x)
    );
    
    // Generate ASCII for Y axis  
    q8_8_to_ascii y_converter (
        .q8_8_in(tilt_y),
        .ascii_out(ascii_y)
    );
    
    assign out_x = ascii_x;
    assign out_y = ascii_y;

        // clamp & convert ball-pos → ASCII '0'..'9'
    logic [3:0] bx = (ball_x_pos <= 4'd7 ? ball_x_pos : 4'd7);
    logic [3:0] by = (ball_y_pos <= 4'd4 ? ball_y_pos : 4'd4);
    logic [7:0] ball_x_ascii = 8'h30 + {4'b0, bx};
    logic [7:0] ball_y_ascii = 8'h30 + {4'b0, by};

    // pack into final outputs: [tens][ones][dot][ball-pos]
    assign ball_x_lcd = ball_x_ascii;       // new X ball-pos;
    assign ball_y_lcd = ball_y_ascii;       // new X ball-pos;
endmodule


// Sub-module to convert Q8.8 signed to ASCII
// Output format: [digit1][digit0].[frac1][frac2]
// Example: 12.34, 05.67
module q8_8_to_ascii(
    input logic signed [15:0] q8_8_in,
    output logic [31:0] ascii_out  // 4 characters * 8 bits = 32 bits
);

    logic [15:0] abs_value;
    logic sign_bit;
    logic [7:0] integer_part;
    logic [7:0] fractional_part;
    
    // Extract sign and absolute value
    assign sign_bit = q8_8_in[15];
    assign abs_value = sign_bit ? (~q8_8_in + 1) : q8_8_in;
    
    // Split into integer and fractional parts
    assign integer_part = abs_value[15:8];
    assign fractional_part = abs_value[7:0];
    
    // Convert integer part to two decimal digits
    logic [3:0] tens_digit, ones_digit;
    logic [7:0] frac_scaled;
    logic [3:0] frac_tens, frac_ones;
    
    // Integer part conversion (0-99)
    assign tens_digit = (integer_part >= 8'd100) ? 4'd9 : 
                       (integer_part >= 8'd90) ? 4'd9 :
                       (integer_part >= 8'd80) ? 4'd8 :
                       (integer_part >= 8'd70) ? 4'd7 :
                       (integer_part >= 8'd60) ? 4'd6 :
                       (integer_part >= 8'd50) ? 4'd5 :
                       (integer_part >= 8'd40) ? 4'd4 :
                       (integer_part >= 8'd30) ? 4'd3 :
                       (integer_part >= 8'd20) ? 4'd2 :
                       (integer_part >= 8'd10) ? 4'd1 : 4'd0;
                       
    logic [7:0] ones_temp;
    assign ones_temp = (integer_part >= 8'd100) ? 8'd9 :
                      (integer_part >= 8'd90) ? (integer_part - 8'd90) :
                      (integer_part >= 8'd80) ? (integer_part - 8'd80) :
                      (integer_part >= 8'd70) ? (integer_part - 8'd70) :
                      (integer_part >= 8'd60) ? (integer_part - 8'd60) :
                      (integer_part >= 8'd50) ? (integer_part - 8'd50) :
                      (integer_part >= 8'd40) ? (integer_part - 8'd40) :
                      (integer_part >= 8'd30) ? (integer_part - 8'd30) :
                      (integer_part >= 8'd20) ? (integer_part - 8'd20) :
                      (integer_part >= 8'd10) ? (integer_part - 8'd10) : integer_part;
    assign ones_digit = ones_temp[3:0];
    
    // Fractional part conversion (multiply by 100 to get 2 decimal places)
    // For Q8.8: fractional_part represents value/256
    // To get 2 decimal places: (fractional_part * 100) / 256
    logic [15:0] frac_temp;
    assign frac_temp = fractional_part * 8'd100;
    assign frac_scaled = frac_temp[15:8]; // Divide by 256 (shift right 8)
    
    assign frac_tens = (frac_scaled >= 8'd90) ? 4'd9 :
                      (frac_scaled >= 8'd80) ? 4'd8 :
                      (frac_scaled >= 8'd70) ? 4'd7 :
                      (frac_scaled >= 8'd60) ? 4'd6 :
                      (frac_scaled >= 8'd50) ? 4'd5 :
                      (frac_scaled >= 8'd40) ? 4'd4 :
                      (frac_scaled >= 8'd30) ? 4'd3 :
                      (frac_scaled >= 8'd20) ? 4'd2 :
                      (frac_scaled >= 8'd10) ? 4'd1 : 4'd0;
                      
    logic [7:0] frac_ones_temp;
    assign frac_ones_temp = (frac_scaled >= 8'd90) ? (frac_scaled - 8'd90) :
                           (frac_scaled >= 8'd80) ? (frac_scaled - 8'd80) :
                           (frac_scaled >= 8'd70) ? (frac_scaled - 8'd70) :
                           (frac_scaled >= 8'd60) ? (frac_scaled - 8'd60) :
                           (frac_scaled >= 8'd50) ? (frac_scaled - 8'd50) :
                           (frac_scaled >= 8'd40) ? (frac_scaled - 8'd40) :
                           (frac_scaled >= 8'd30) ? (frac_scaled - 8'd30) :
                           (frac_scaled >= 8'd20) ? (frac_scaled - 8'd20) :
                           (frac_scaled >= 8'd10) ? (frac_scaled - 8'd10) : frac_scaled;
    assign frac_ones = frac_ones_temp[3:0];
    
    // Convert to ASCII
    logic [7:0] tens_ascii, ones_ascii, dot_ascii, frac_tens_ascii;
    
    assign tens_ascii = 8'h30 + {4'h0, tens_digit};  // '0' + digit
    assign ones_ascii = 8'h30 + {4'h0, ones_digit}; // '0' + digit  
    assign dot_ascii = 8'h2E;  // '.'
    assign frac_tens_ascii = 8'h30 + {4'h0, frac_tens}; // '0' + digit
    
    // Pack into output (MSB first: tens, ones, dot, frac_tens)
    assign ascii_out = {tens_ascii, ones_ascii, dot_ascii, frac_tens_ascii};

endmodule