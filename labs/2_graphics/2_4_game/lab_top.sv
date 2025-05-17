`include "config.svh"
`include "game_config.svh"

module lab_top
# (
    parameter  clk_mhz       = 50,
               pixel_mhz     = 25,


               w_key         = 4,
               w_sw          = 8,
               w_led         = 8,
               w_digit       = 8,
               w_gpio        = 100,

               screen_width  = 640,
               screen_height = 480,

               w_red         = 4,
               w_green       = 4,
               w_blue        = 4,

               w_x           = $clog2 ( screen_width  ),
               w_y           = $clog2 ( screen_height ),

               strobe_to_update_xy_counter_width
                   = $clog2 (clk_mhz * 1000 * 1000) - 6
)
(
    input                        clk,
    input                        slow_clk,
    input                        rst,

    // Keys, switches, LEDs

    input        [w_key   - 1:0] key,
    input        [w_sw    - 1:0] sw,
    output logic [w_led   - 1:0] led,

    // A dynamic seven-segment display

    output logic [          7:0] abcdefgh,
    output logic [w_digit - 1:0] digit,

    // Graphics

    input                        display_on,

    input        [w_x     - 1:0] x,
    input        [w_y     - 1:0] y,

    output logic [w_red   - 1:0] red,
    output logic [w_green - 1:0] green,
    output logic [w_blue  - 1:0] blue,

    // Microphone, sound output and UART

    input        [         23:0] mic,
    output       [         15:0] sound,

    input                        uart_rx,
    output                       uart_tx,

    // General-purpose Input/Output

    inout        [w_gpio  - 1:0] gpio
);

    //------------------------------------------------------------------------

       assign led        = '0;
    //    assign abcdefgh   = '0;
    //    assign digit      = '0;
    // assign red        = '0;
    // assign green      = '0;
    // assign blue       = '0;
       assign sound      = '0;
       assign uart_tx    = '1;

    //------------------------------------------------------------------------

    wire [`GAME_RGB_WIDTH - 1:0] rgb;
    logic [2:0] score;
    logic [2:0] n_lifes;

    game_top
    # (
        .clk_mhz                           (clk_mhz                          ),
        .pixel_mhz                         (pixel_mhz                        ),
        .screen_width                      (screen_width                     ),
        .screen_height                     (screen_height                    ),
        .strobe_to_update_xy_counter_width (strobe_to_update_xy_counter_width)
    )
    i_game_top
    (
        .clk              (   clk                ),
        .rst              (   rst                ),

        .launch_key       ( | key                ),
        .left_right_keys  ( { key [3], key [0] } ),
        .shoot  ( key [1] ),

        .display_on       (   display_on         ),

        .x                (   x                  ),
        .y                (   y                  ),

        .score            ( score                ),
        .n_lifes          ( n_lifes              ),

        .rgb              (   rgb                )
    );



    localparam frame_left   = screen_width * 3 / 10;
    localparam frame_right  = screen_width * 7 / 10;
    localparam frame_top    = 1;
    localparam frame_bottom = screen_height - 1;

    wire on_frame = ((x == frame_left || x == frame_right - 1)  &&
                     (y >= frame_top  && y < frame_bottom) ||
                     (y == frame_top  || y == frame_bottom - 1) &&
                     (x >= frame_left && x < frame_right)
    );

    always_comb begin
        red   = '0;
        green = '0;
        blue  = '0;

        if (on_frame) begin
            red   = { w_red   { 1'b1 } };
            green = { w_green { 1'b1 } };
            blue  = { w_blue  { 1'b1 } };
        end

        if (rgb != 3'b000) begin
            red   = { w_red   { rgb[2] } };
            green = { w_green { rgb[1] } };
            blue  = { w_blue  { rgb[0] } };
        end
    end

    typedef enum bit [7:0]
    {
        ZERO  = 8'b1111_1100,
        ONE   = 8'b0110_0000,
        TWO   = 8'b1101_1100,
        THREE = 8'b1111_0010,
        FOUR  = 8'b0110_0110,
        SPACE = 8'b0000_0000
    }
    seven_seg_encoding_e;

    assign abcdefgh = (score == 0) ? ZERO : (score == 1) ? ONE : (score == 2) ? TWO : (score == 3) ? THREE : (score == 4) ? FOUR : SPACE;
    assign digit = 4'b1111;

    // assign red   = { w_red   { rgb [2] } };
    // assign green = { w_green { rgb [1] } };
    // assign blue  = { w_blue  { rgb [0] } };

endmodule
