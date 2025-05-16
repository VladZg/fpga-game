`include "game_config.svh"

module game_top
# (
    parameter  clk_mhz       = 50,
               pixel_mhz     = 25,

               screen_width  = 640,
               screen_height = 480,

               w_x           = $clog2 ( screen_width  ),
               w_y           = $clog2 ( screen_height ),

               strobe_to_update_xy_counter_width = 20
)
(
    input                          clk,
    input                          rst,

    input                          launch_key,
    input  [                  1:0] left_right_keys,
    input                          shoot,

    input                          display_on,

    input  [w_x             - 1:0] x,
    input  [w_y             - 1:0] y,

    output logic [3:0]             score,

    output [`GAME_RGB_WIDTH - 1:0] rgb
);

    //------------------------------------------------------------------------

    wire [15:0] random_1;
    wire                          sprite_target_write_xy_1;
    wire                          sprite_target_write_dxy_1;

    logic [w_x             - 1:0] sprite_target_write_x_1;
    logic [w_y             - 1:0] sprite_target_write_y_1;

    logic [                  1:0] sprite_target_write_dx_1;
    logic [                  1:0] sprite_target_write_dy_1;

    wire                          sprite_target_enable_update_1;

    wire  [w_x             - 1:0] sprite_target_x_1;
    wire  [w_y             - 1:0] sprite_target_y_1;

    wire                          sprite_target_within_screen_1;

    wire  [w_x             - 1:0] sprite_target_out_left_1;
    wire  [w_x             - 1:0] sprite_target_out_right_1;
    wire  [w_y             - 1:0] sprite_target_out_top_1;
    wire  [w_y             - 1:0] sprite_target_out_bottom_1;

    wire                          sprite_target_rgb_en_1;
    wire  [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb_1;

    // Generate block for sprite instances
    game_random random_generator_1 (clk, rst, random_1);
    always_comb
    begin
        if (random_1 [7])
        begin
            sprite_target_write_x_1  = screen_width * 3 / 10 + 2;
            sprite_target_write_dx_1 = 2'b01;
        end else begin
            sprite_target_write_x_1  = screen_width * 3 / 10 + random_1 [6:0];
            sprite_target_write_dx_1 = 1'd0;
        end
    end

    assign sprite_target_write_dy_1 = 1'd0;
    assign sprite_target_write_y_1 = 1'd1;

    game_sprite_top
    #(
        .SPRITE_WIDTH  ( 16 ),
        .SPRITE_HEIGHT ( 16 ),

        .DX_WIDTH      ( 2 ),
        .DY_WIDTH      ( 1 ),

        .ROW_0  ( 64'h00000bb9b9b00000 ),
        .ROW_1  ( 64'h000fffbb9b9bb000 ),
        .ROW_2  ( 64'h00fffffbb9b9b900 ),
        .ROW_3  ( 64'h0ffffffbb9b9b990 ),
        .ROW_4  ( 64'h0fffffbbb9b9bbb0 ),
        .ROW_5  ( 64'hbffffbbbbbb9b999 ),
        .ROW_6  ( 64'hbbffbbbb9bbb9999 ),
        .ROW_7  ( 64'h9bbbbbb9bb9b9999 ),
        .ROW_8  ( 64'hb9bbbb9bb9bb9999 ),
        .ROW_9  ( 64'hbb999bbb9bbbb999 ),
        .ROW_10 ( 64'h9bbbbbb9bbb99999 ),
        .ROW_11 ( 64'h099999bbbb999990 ),
        .ROW_12 ( 64'h09bbbb9b9b999990 ),
        .ROW_13 ( 64'h0099999999999900 ),
        .ROW_14 ( 64'h0009999999999000 ),
        .ROW_15 ( 64'h0000099999900000 ),

        .screen_width
        (screen_width),

        .screen_height
        (screen_height),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_target_1
    (
        .clk                   ( clk                          ),
        .rst                   ( rst                          ),

        .pixel_x               ( x                            ),
        .pixel_y               ( y                            ),

        .sprite_write_xy       ( sprite_target_write_xy_1       ),
        .sprite_write_dxy      ( sprite_target_write_dxy_1      ),

        .sprite_write_x        ( sprite_target_write_x_1        ),
        .sprite_write_y        ( sprite_target_write_y_1        ),

        .sprite_write_dx       ( sprite_target_write_dx_1       ),
        .sprite_write_dy       ( sprite_target_write_dy_1       ),

        .sprite_enable_update  ( sprite_target_enable_update_1  ),
        .is_meteor             ( 1                              ),
        .is_bullet             ( 0                              ),
        .shoot                 ( shoot                          ),

        .sprite_x              ( sprite_target_x_1              ),
        .sprite_y              ( sprite_target_y_1              ),

        .sprite_within_screen  ( sprite_target_within_screen_1  ),

        .sprite_out_left       ( sprite_target_out_left_1       ),
        .sprite_out_right      ( sprite_target_out_right_1      ),
        .sprite_out_top        ( sprite_target_out_top_1        ),
        .sprite_out_bottom     ( sprite_target_out_bottom_1     ),

        .rgb_en                ( sprite_target_rgb_en_1         ),
        .rgb                   ( sprite_target_rgb_1            )
    );

    //------------------------------------------------------------------------

    wire                          sprite_target_write_xy_2;
    wire                          sprite_target_write_dxy_2;

    logic [w_x             - 1:0] sprite_target_write_x_2;
    logic [w_y             - 1:0] sprite_target_write_y_2;

    logic [                  1:0] sprite_target_write_dx_2;
    logic [                  1:0] sprite_target_write_dy_2;

    wire                          sprite_target_enable_update_2;

    wire  [w_x             - 1:0] sprite_target_x_2;
    wire  [w_y             - 1:0] sprite_target_y_2;

    wire                          sprite_target_within_screen_2;

    wire  [w_x             - 1:0] sprite_target_out_left_2;
    wire  [w_x             - 1:0] sprite_target_out_right_2;
    wire  [w_y             - 1:0] sprite_target_out_top_2;
    wire  [w_y             - 1:0] sprite_target_out_bottom_2;

    wire                          sprite_target_rgb_en_2;
    wire  [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb_2;

    always_comb
    begin
        if (random_1 [7])
        begin
            sprite_target_write_x_2  = screen_width / 2;
            sprite_target_write_dx_2 = 2'b01;
        end else begin
            sprite_target_write_x_2 =  screen_width / 2 + random_1 [7:3];

            sprite_target_write_dx_2 = 1'd0;
        end
    end

    assign sprite_target_write_dy_2 = 1'd0;
    assign sprite_target_write_y_2 = 1'd0;

    game_sprite_top
    #(
        .SPRITE_WIDTH  ( 16 ),
        .SPRITE_HEIGHT ( 16 ),

        .DX_WIDTH      ( 2 ),
        .DY_WIDTH      ( 1 ),

        .ROW_0  ( 64'h00000bb9b9b00000 ),
        .ROW_1  ( 64'h000fffbb9b9bb000 ),
        .ROW_2  ( 64'h00fffffbb9b9b900 ),
        .ROW_3  ( 64'h0ffffffbb9b9b990 ),
        .ROW_4  ( 64'h0fffffbbb9b9bbb0 ),
        .ROW_5  ( 64'hbffffbbbbbb9b999 ),
        .ROW_6  ( 64'hbbffbbbb9bbb9999 ),
        .ROW_7  ( 64'h9bbbbbb9bb9b9999 ),
        .ROW_8  ( 64'hb9bbbb9bb9bb9999 ),
        .ROW_9  ( 64'hbb999bbb9bbbb999 ),
        .ROW_10 ( 64'h9bbbbbb9bbb99999 ),
        .ROW_11 ( 64'h099999bbbb999990 ),
        .ROW_12 ( 64'h09bbbb9b9b999990 ),
        .ROW_13 ( 64'h0099999999999900 ),
        .ROW_14 ( 64'h0009999999999000 ),
        .ROW_15 ( 64'h0000099999900000 ),

        .screen_width
        (screen_width),

        .screen_height
        (screen_height),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_target_2
    (
        .clk                   ( clk                          ),
        .rst                   ( rst                          ),

        .pixel_x               ( x                            ),
        .pixel_y               ( y                            ),

        .sprite_write_xy       ( sprite_target_write_xy_2       ),
        .sprite_write_dxy      ( sprite_target_write_dxy_2      ),

        .sprite_write_x        ( sprite_target_write_x_2        ),
        .sprite_write_y        ( sprite_target_write_y_2        ),

        .sprite_write_dx       ( sprite_target_write_dx_2       ),
        .sprite_write_dy       ( sprite_target_write_dy_2       ),

        .sprite_enable_update  ( sprite_target_enable_update_2  ),
        .is_meteor             ( 1                              ),
        .is_bullet             ( 0                              ),
        .shoot                 ( shoot                          ),

        .sprite_x              ( sprite_target_x_2              ),
        .sprite_y              ( sprite_target_y_2              ),

        .sprite_within_screen  ( sprite_target_within_screen_2  ),

        .sprite_out_left       ( sprite_target_out_left_2       ),
        .sprite_out_right      ( sprite_target_out_right_2      ),
        .sprite_out_top        ( sprite_target_out_top_2        ),
        .sprite_out_bottom     ( sprite_target_out_bottom_2     ),

        .rgb_en                ( sprite_target_rgb_en_2         ),
        .rgb                   ( sprite_target_rgb_2            )
    );

    //------------------------------------------------------------------------

    wire                          sprite_target_write_xy_3;
    wire                          sprite_target_write_dxy_3;

    logic [w_x             - 1:0] sprite_target_write_x_3;
    logic [w_y             - 1:0] sprite_target_write_y_3;

    logic [                  1:0] sprite_target_write_dx_3;
    logic [                  1:0] sprite_target_write_dy_3;

    wire                          sprite_target_enable_update_3;

    wire  [w_x             - 1:0] sprite_target_x_3;
    wire  [w_y             - 1:0] sprite_target_y_3;

    wire                          sprite_target_within_screen_3;

    wire  [w_x             - 1:0] sprite_target_out_left_3;
    wire  [w_x             - 1:0] sprite_target_out_right_3;
    wire  [w_y             - 1:0] sprite_target_out_top_3;
    wire  [w_y             - 1:0] sprite_target_out_bottom_3;

    wire                          sprite_target_rgb_en_3;
    wire  [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb_3;

    always_comb
    begin
        if (random_1 [7])
        begin
            sprite_target_write_x_3  = (7 * screen_width / 10) - 20;
            sprite_target_write_dx_3 = 2'b01;
        end else begin
            sprite_target_write_x_3  = ((7 * screen_width / 10) - 20) - random_1 [10:7];
            sprite_target_write_dx_3 = 1'd0;
        end
    end

    assign sprite_target_write_dy_3 = 1'd0;
    assign sprite_target_write_y_3 = 1'd0;

    game_sprite_top
    #(
        .SPRITE_WIDTH  ( 16 ),
        .SPRITE_HEIGHT ( 16 ),

        .DX_WIDTH      ( 2 ),
        .DY_WIDTH      ( 1 ),

        .ROW_0  ( 64'h00000bb9b9b00000 ),
        .ROW_1  ( 64'h000fffbb9b9bb000 ),
        .ROW_2  ( 64'h00fffffbb9b9b900 ),
        .ROW_3  ( 64'h0ffffffbb9b9b990 ),
        .ROW_4  ( 64'h0fffffbbb9b9bbb0 ),
        .ROW_5  ( 64'hbffffbbbbbb9b999 ),
        .ROW_6  ( 64'hbbffbbbb9bbb9999 ),
        .ROW_7  ( 64'h9bbbbbb9bb9b9999 ),
        .ROW_8  ( 64'hb9bbbb9bb9bb9999 ),
        .ROW_9  ( 64'hbb999bbb9bbbb999 ),
        .ROW_10 ( 64'h9bbbbbb9bbb99999 ),
        .ROW_11 ( 64'h099999bbbb999990 ),
        .ROW_12 ( 64'h09bbbb9b9b999990 ),
        .ROW_13 ( 64'h0099999999999900 ),
        .ROW_14 ( 64'h0009999999999000 ),
        .ROW_15 ( 64'h0000099999900000 ),

        .screen_width
        (screen_width),

        .screen_height
        (screen_height),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_target_3
    (
        .clk                   ( clk                          ),
        .rst                   ( rst                          ),

        .pixel_x               ( x                            ),
        .pixel_y               ( y                            ),

        .sprite_write_xy       ( sprite_target_write_xy_3       ),
        .sprite_write_dxy      ( sprite_target_write_dxy_3      ),

        .sprite_write_x        ( sprite_target_write_x_3        ),
        .sprite_write_y        ( sprite_target_write_y_3        ),

        .sprite_write_dx       ( sprite_target_write_dx_3       ),
        .sprite_write_dy       ( sprite_target_write_dy_3       ),

        .sprite_enable_update  ( sprite_target_enable_update_3  ),
        .is_meteor             ( 1                              ),
        .is_bullet             ( 0                              ),
        .shoot                 ( shoot                          ),

        .sprite_x              ( sprite_target_x_3              ),
        .sprite_y              ( sprite_target_y_3              ),

        .sprite_within_screen  ( sprite_target_within_screen_3  ),

        .sprite_out_left       ( sprite_target_out_left_3       ),
        .sprite_out_right      ( sprite_target_out_right_3      ),
        .sprite_out_top        ( sprite_target_out_top_3        ),
        .sprite_out_bottom     ( sprite_target_out_bottom_3     ),

        .rgb_en                ( sprite_target_rgb_en_3         ),
        .rgb                   ( sprite_target_rgb_3            )
    );

    //------------------------------------------------------------------------

    wire                          sprite_torpedo_write_xy;
    wire                          sprite_torpedo_write_dxy;

    wire  [w_x             - 1:0] sprite_torpedo_write_x;
    wire  [w_y             - 1:0] sprite_torpedo_write_y;

    logic [                  1:0] sprite_torpedo_write_dx;
    logic [                  2:0] sprite_torpedo_write_dy;

    wire                          sprite_torpedo_enable_update;

    wire  [w_x             - 1:0] sprite_torpedo_x;
    wire  [w_y             - 1:0] sprite_torpedo_y;

    wire                          sprite_torpedo_within_screen;

    wire  [w_x             - 1:0] sprite_torpedo_out_left;
    wire  [w_x             - 1:0] sprite_torpedo_out_right;
    wire  [w_y             - 1:0] sprite_torpedo_out_top;
    wire  [w_y             - 1:0] sprite_torpedo_out_bottom;

    wire                          sprite_torpedo_rgb_en;
    wire  [`GAME_RGB_WIDTH - 1:0] sprite_torpedo_rgb;

    //------------------------------------------------------------------------

    assign sprite_torpedo_write_x  = screen_width / 2 + random_1 [15:10];
    assign sprite_torpedo_write_y  = screen_height - 20;

    always_comb
    begin
        case (left_right_keys)
        2'b00: sprite_torpedo_write_dx = 2'b00;
        2'b01: sprite_torpedo_write_dx = 2'b01;
        2'b10: sprite_torpedo_write_dx = 2'b11;
        2'b11: sprite_torpedo_write_dx = 2'b00;
        endcase

        case (left_right_keys)
        2'b00: sprite_torpedo_write_dy = 3'b111;
        2'b01: sprite_torpedo_write_dy = 3'b110;
        2'b10: sprite_torpedo_write_dy = 3'b110;
        2'b11: sprite_torpedo_write_dy = 3'b110;
        endcase
    end

    //------------------------------------------------------------------------

    game_sprite_top
    #(
        .SPRITE_WIDTH  ( 16 ),
        .SPRITE_HEIGHT ( 16 ),

        .DX_WIDTH      ( 2 ),
        .DY_WIDTH      ( 3 ),

        .ROW_0  ( 64'h0000000000000000 ),
        .ROW_1  ( 64'h00f0000ff0000f00 ),
        .ROW_2  ( 64'h0f9ff0fbbf0ff9f0 ),
        .ROW_3  ( 64'h0fbbaf9999fabbf0 ),
        .ROW_4  ( 64'h0fb9aaaaaaaa9bf0 ),
        .ROW_5  ( 64'h00fa99affa99af00 ),
        .ROW_6  ( 64'h00fa9aaeeaa9af00 ),
        .ROW_7  ( 64'h0faa9a0cc0a9aaf0 ),
        .ROW_8  ( 64'h0f9a9ac00ca9a9f0 ),
        .ROW_9  ( 64'h0fb99acccca99bf0 ),
        .ROW_10 ( 64'h00fb9aaccaa9bf00 ),
        .ROW_11 ( 64'h000f9a9aa9a9f000 ),
        .ROW_12 ( 64'h0000fa9999fd0000 ),
        .ROW_13 ( 64'h00000fbffbf00000 ),
        .ROW_14 ( 64'h000000f00f000000 ),
        .ROW_15 ( 64'h0000000000000000 ),

        .screen_width
        (screen_width),

        .screen_height
        (screen_height),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_torpedo
    (
        .clk                   ( clk                           ),
        .rst                   ( rst                           ),

        .pixel_x               ( x                             ),
        .pixel_y               ( y                             ),

        .sprite_write_xy       ( sprite_torpedo_write_xy       ),
        .sprite_write_dxy      ( sprite_torpedo_write_dxy      ),

        .sprite_write_x        ( sprite_torpedo_write_x        ),
        .sprite_write_y        ( sprite_torpedo_write_y        ),

        .sprite_write_dx       ( sprite_torpedo_write_dx       ),
        .sprite_write_dy       ( 0                             ),

        .sprite_enable_update  ( sprite_torpedo_enable_update  ),
        .is_meteor             ( 0                             ),
        .is_bullet             ( 0                             ),
        .shoot                 ( shoot                          ),

        .sprite_x              ( sprite_torpedo_x              ),
        .sprite_y              ( sprite_torpedo_y              ),

        .sprite_within_screen  ( sprite_torpedo_within_screen  ),

        .sprite_out_left       ( sprite_torpedo_out_left       ),
        .sprite_out_right      ( sprite_torpedo_out_right      ),
        .sprite_out_top        ( sprite_torpedo_out_top        ),
        .sprite_out_bottom     ( sprite_torpedo_out_bottom     ),

        .rgb_en                ( sprite_torpedo_rgb_en         ),
        .rgb                   ( sprite_torpedo_rgb            )
    );

    //------------------------------------------------------------------------

    wire                          sprite_bullet_write_xy;
    wire                          sprite_bullet_write_dxy;

    logic [w_x             - 1:0] sprite_bullet_write_x;
    logic [w_y             - 1:0] sprite_bullet_write_y;

    logic [                  1:0] sprite_bullet_write_dx;
    logic [                  2:0] sprite_bullet_write_dy;

    wire                          sprite_bullet_enable_update;

    wire  [w_x             - 1:0] sprite_bullet_x;
    wire  [w_y             - 1:0] sprite_bullet_y;

    wire                          sprite_bullet_within_screen;

    wire  [w_x             - 1:0] sprite_bullet_out_left;
    wire  [w_x             - 1:0] sprite_bullet_out_right;
    wire  [w_y             - 1:0] sprite_bullet_out_top;
    wire  [w_y             - 1:0] sprite_bullet_out_bottom;

    wire                          sprite_bullet_rgb_en;
    wire  [`GAME_RGB_WIDTH - 1:0] sprite_bullet_rgb;

    assign sprite_bullet_write_x = screen_width / 2 + + random_1 [15:10];
    assign sprite_bullet_write_y = screen_height - 37;

    always_comb
    begin
        case (left_right_keys)
        2'b00: sprite_bullet_write_dx = 2'b00;
        2'b01: sprite_bullet_write_dx = 2'b01;
        2'b10: sprite_bullet_write_dx = 2'b11;
        2'b11: sprite_bullet_write_dx = 2'b00;
        endcase

        case (left_right_keys)
        2'b00: sprite_bullet_write_dy = 3'b111;
        2'b01: sprite_bullet_write_dy = 3'b110;
        2'b10: sprite_bullet_write_dy = 3'b110;
        2'b11: sprite_bullet_write_dy = 3'b110;
        endcase
    end

    game_sprite_top
    #(
        .SPRITE_WIDTH  ( 16 ),
        .SPRITE_HEIGHT ( 16 ),

        .DX_WIDTH      ( 2 ),
        .DY_WIDTH      ( 1 ),

        .ROW_0  ( 64'hffffffffffffffff ),
        .ROW_1  ( 64'hffffffffffffffff ),
        .ROW_2  ( 64'hffffffffffffffff ),
        .ROW_3  ( 64'hffffffffffffffff ),
        .ROW_4  ( 64'hffffffffffffffff ),
        .ROW_5  ( 64'hffffffffffffffff ),
        .ROW_6  ( 64'hffffffffffffffff ),
        .ROW_7  ( 64'hffffffffffffffff ),
        .ROW_8  ( 64'hffffffffffffffff ),
        .ROW_9  ( 64'hffffffffffffffff ),
        .ROW_10 ( 64'hffffffffffffffff ),
        .ROW_11 ( 64'hffffffffffffffff ),
        .ROW_12 ( 64'hffffffffffffffff ),
        .ROW_13 ( 64'hffffffffffffffff ),
        .ROW_14 ( 64'hffffffffffffffff ),
        .ROW_15 ( 64'hffffffffffffffff ),

        .screen_width
        (screen_width),

        .screen_height
        (screen_height),

        .strobe_to_update_xy_counter_width
        (strobe_to_update_xy_counter_width)
    )
    sprite_bullet
    (
        .clk                   ( clk                          ),
        .rst                   ( rst                          ),

        .pixel_x               ( x                            ),
        .pixel_y               ( y                            ),

        .sprite_write_xy       ( sprite_bullet_write_xy       ),
        .sprite_write_dxy      ( sprite_bullet_write_dxy      ),

        .sprite_write_x        ( sprite_bullet_write_x        ),
        .sprite_write_y        ( sprite_bullet_write_y        ),

        .sprite_write_dx       ( sprite_bullet_write_dx       ),
        .sprite_write_dy       ( sprite_bullet_write_dy       ),

        .sprite_enable_update  ( sprite_bullet_enable_update  ),
        .is_meteor             ( 0                            ),
        .is_bullet             ( 1                            ),
        .shoot                 ( shoot                        ),

        .sprite_x              ( sprite_bullet_x              ),
        .sprite_y              ( sprite_bullet_y              ),

        .sprite_within_screen  ( sprite_bullet_within_screen  ),

        .sprite_out_left       ( sprite_bullet_out_left       ),
        .sprite_out_right      ( sprite_bullet_out_right      ),
        .sprite_out_top        ( sprite_bullet_out_top        ),
        .sprite_out_bottom     ( sprite_bullet_out_bottom     ),

        .rgb_en                ( sprite_bullet_rgb_en         ),
        .rgb                   ( sprite_bullet_rgb            )
    );

    //------------------------------------------------------------------------

    wire collision;
    wire collision_bullet;

    game_overlap
    #(
        .screen_width  ( screen_width  ),
        .screen_height ( screen_height )
    )
    overlap
    (
        .clk         ( clk                          ),
        .rst         ( rst                          ),

        .left_1_1    ( sprite_target_out_left_1     ),
        .right_1_1   ( sprite_target_out_right_1    ),
        .top_1_1     ( sprite_target_out_top_1      ),
        .bottom_1_1  ( sprite_target_out_bottom_1   ),

        .left_1_2    ( sprite_target_out_left_2     ),
        .right_1_2   ( sprite_target_out_right_2    ),
        .top_1_2     ( sprite_target_out_top_2      ),
        .bottom_1_2  ( sprite_target_out_bottom_2   ),

        .left_1_3    ( sprite_target_out_left_3     ),
        .right_1_3   ( sprite_target_out_right_3    ),
        .top_1_3     ( sprite_target_out_top_3      ),
        .bottom_1_3  ( sprite_target_out_bottom_3   ),

        .left_bullet    ( sprite_bullet_out_left    ),
        .right_bullet   ( sprite_bullet_out_right   ),
        .top_bullet     ( sprite_bullet_out_top     ),
        .bottom_bullet  ( sprite_bullet_out_bottom  ),

        .left_2      ( sprite_torpedo_out_left      ),
        .right_2     ( sprite_torpedo_out_right     ),
        .top_2       ( sprite_torpedo_out_top       ),
        .bottom_2    ( sprite_torpedo_out_bottom    ),

        .overlap            ( collision             ),
        .overlap_bullet     ( collision_bullet      )
    );

    //------------------------------------------------------------------------

    wire end_of_game_timer_start;
    wire end_of_game_timer_running;

    game_timer # (.width (25)) timer
    (
        .clk     ( clk                       ),
        .rst     ( rst                       ),
        .value   ( 25'h1000000               ),
        .start   ( end_of_game_timer_start   ),
        .running ( end_of_game_timer_running )
    );

    //------------------------------------------------------------------------

    wire game_won;

    game_mixer mixer
    (
        .clk                           ( clk                           ),
        .rst                           ( rst                           ),

        .sprite_target_rgb_en_1        ( sprite_target_rgb_en_1        ),
        .sprite_target_rgb_1           ( sprite_target_rgb_1           ),
        .sprite_target_rgb_en_2        ( sprite_target_rgb_en_2        ),
        .sprite_target_rgb_2           ( sprite_target_rgb_2           ),
        .sprite_target_rgb_en_3        ( sprite_target_rgb_en_3        ),
        .sprite_target_rgb_3           ( sprite_target_rgb_3           ),

        .sprite_bullet_rgb_en          ( sprite_bullet_rgb_en          ),
        .sprite_bullet_rgb             ( sprite_bullet_rgb             ),

        .sprite_torpedo_rgb_en         ( sprite_torpedo_rgb_en         ),
        .sprite_torpedo_rgb            ( sprite_torpedo_rgb            ),

        .game_won                      ( game_won                      ),
        .end_of_game_timer_running     ( end_of_game_timer_running     ),
        .random                        ( random_1 [0]                  ),

        .rgb                           ( rgb                           )
    );

    //------------------------------------------------------------------------

    `GAME_MASTER_FSM_MODULE master_fsm
    (
        .clk                            ( clk                           ),
        .rst                            ( rst                           ),

        .launch_key                     ( launch_key                    ),
        .shoot                          ( shoot                         ),

        .sprite_target_write_xy_1       ( sprite_target_write_xy_1      ),
        .sprite_target_write_xy_2       ( sprite_target_write_xy_2      ),
        .sprite_target_write_xy_3       ( sprite_target_write_xy_3      ),

        .sprite_torpedo_write_xy        ( sprite_torpedo_write_xy       ),

        .sprite_target_write_dxy_1      ( sprite_target_write_dxy_1     ),
        .sprite_target_write_dxy_2      ( sprite_target_write_dxy_2     ),
        .sprite_target_write_dxy_3      ( sprite_target_write_dxy_3     ),

        .sprite_torpedo_write_dxy       ( sprite_torpedo_write_dxy      ),

        .sprite_target_enable_update_1  ( sprite_target_enable_update_1 ),
        .sprite_target_enable_update_2  ( sprite_target_enable_update_2 ),
        .sprite_target_enable_update_3  ( sprite_target_enable_update_3 ),

        .sprite_torpedo_enable_update   ( sprite_torpedo_enable_update  ),

        .sprite_target_within_screen_1  ( sprite_target_within_screen_1 ),
        .sprite_target_within_screen_2  ( sprite_target_within_screen_2 ),
        .sprite_target_within_screen_3  ( sprite_target_within_screen_3 ),

        .sprite_torpedo_within_screen   ( sprite_torpedo_within_screen  ),
        .sprite_bullet_within_screen    ( sprite_bullet_within_screen   ),
        .sprite_bullet_enable_update    ( sprite_bullet_enable_update   ),
        .sprite_bullet_write_dxy        ( sprite_bullet_write_dxy       ),
        .sprite_bullet_write_xy         ( sprite_bullet_write_xy        ),

        .collision                      ( collision                     ),
        .collision_bullet               ( collision_bullet              ),

        .game_won                       ( game_won                      ),
        .end_of_game_timer_start        ( end_of_game_timer_start       ),

        .score                          ( score                         ),

        .end_of_game_timer_running      ( end_of_game_timer_running     )
    );

endmodule
