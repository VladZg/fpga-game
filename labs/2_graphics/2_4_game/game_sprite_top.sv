`include "game_config.svh"

module game_sprite_top
#(
    parameter SPRITE_WIDTH  = 16,
              SPRITE_HEIGHT = 16,

              DX_WIDTH      = 2,  // X speed width in bits
              DY_WIDTH      = 2,  // Y speed width in bits

              ROW_0         = 64'h0000000000000000,
              ROW_1         = 64'h00f0000ff0000f00,
              ROW_2         = 64'h0f9ff0fbbf0ff9f0,
              ROW_3         = 64'h0fbbaf9999fabbf0,
              ROW_4         = 64'h0fb9aaaaaaaa9bf0,
              ROW_5         = 64'h00fa99affa99af00,
              ROW_6         = 64'h00fa9aaeeaa9af00,
              ROW_7         = 64'h0faa9a0cc0a9aaf0,
              ROW_8         = 64'h0f9a9ac00ca9a9f0,
              ROW_9         = 64'h0fb99acccca99bf0,
              ROW_10        = 64'h00fb9aaccaa9bf00,
              ROW_11        = 64'h000f9a9aa9a9f000,
              ROW_12        = 64'h0000fa9999fd0000,
              ROW_13        = 64'h00000fbffbf00000,
              ROW_14        = 64'h000000f00f000000,
              ROW_15        = 64'h0000000000000000,

              screen_width  = 640,
              screen_height = 480,

              w_x           = $clog2 ( screen_width  ),
              w_y           = $clog2 ( screen_height ),

              strobe_to_update_xy_counter_width = 20
)

//----------------------------------------------------------------------------

(
    input                          clk,
    input                          rst,

    input  [w_x             - 1:0] pixel_x,
    input  [w_y             - 1:0] pixel_y,

    input                          sprite_write_xy,
    input                          sprite_write_dxy,

    input  [w_x             - 1:0] sprite_write_x,
    input  [w_y             - 1:0] sprite_write_y,

    input  [DX_WIDTH        - 1:0] sprite_write_dx,
    input  [DY_WIDTH        - 1:0] sprite_write_dy,

    input                          sprite_enable_update,
    input                          is_meteor,
    input                          is_bullet,

    output [w_x             - 1:0] sprite_x,
    output [w_y             - 1:0] sprite_y,

    output                         sprite_within_screen,

    output [w_x             - 1:0] sprite_out_left,
    output [w_x             - 1:0] sprite_out_right,
    output [w_y             - 1:0] sprite_out_top,
    output [w_y             - 1:0] sprite_out_bottom,

    output                         rgb_en,
    output [`GAME_RGB_WIDTH - 1:0] rgb
);

    game_sprite_control
    #(
        .DX_WIDTH              ( DX_WIDTH              ),
        .DY_WIDTH              ( DY_WIDTH              ),

        .screen_width
        (screen_width),

        .screen_height
        (screen_height),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_control
    (
        .clk                   ( clk                   ),
        .rst                   ( rst                   ),

        .sprite_write_xy       ( sprite_write_xy       ),
        .sprite_write_dxy      ( sprite_write_dxy      ),

        .sprite_write_x        ( sprite_write_x        ),
        .sprite_write_y        ( sprite_write_y        ),

        .sprite_write_dx       ( sprite_write_dx       ),
        .sprite_write_dy       ( sprite_write_dy       ),

        .sprite_enable_update  ( sprite_enable_update  ),
        .is_meteor  ( is_meteor  ),
        .is_bullet  ( is_bullet  ),

        .sprite_x              ( sprite_x              ),
        .sprite_y              ( sprite_y              )
    );

    `GAME_SPRITE_DISPLAY_MODULE
    #(
        .SPRITE_WIDTH          ( SPRITE_WIDTH          ),
        .SPRITE_HEIGHT         ( SPRITE_HEIGHT         ),

        .ROW_0                 ( ROW_0                 ),
        .ROW_1                 ( ROW_1                 ),
        .ROW_2                 ( ROW_2                 ),
        .ROW_3                 ( ROW_3                 ),
        .ROW_4                 ( ROW_4                 ),
        .ROW_5                 ( ROW_5                 ),
        .ROW_6                 ( ROW_6                 ),
        .ROW_7                 ( ROW_7                 ),
        .ROW_8                 ( ROW_8                 ),
        .ROW_9                 ( ROW_9                 ),
        .ROW_10                ( ROW_10                ),
        .ROW_11                ( ROW_11                ),
        .ROW_12                ( ROW_12                ),
        .ROW_13                ( ROW_13                ),
        .ROW_14                ( ROW_14                ),
        .ROW_15                ( ROW_15                ),

        

        .screen_width
        (screen_width),

        .screen_height
        (screen_height)
    )
    sprite_display
    (
        .clk                   ( clk                   ),
        .rst                   ( rst                   ),

        .pixel_x               ( pixel_x               ),
        .pixel_y               ( pixel_y               ),

        .sprite_x              ( sprite_x              ),
        .sprite_y              ( sprite_y              ),

        .sprite_within_screen  ( sprite_within_screen  ),

        .sprite_out_left       ( sprite_out_left       ),
        .sprite_out_right      ( sprite_out_right      ),
        .sprite_out_top        ( sprite_out_top        ),
        .sprite_out_bottom     ( sprite_out_bottom     ),

        .rgb_en                ( rgb_en                ),
        .rgb                   ( rgb                   )
    );

endmodule
