`include "game_config.svh"

module game_mixer
#(
    parameter screen_width  = 640,
              screen_height = 480,
              w_x = $clog2(screen_width),
              w_y = $clog2(screen_height)
)
(
    input                          clk,
    input                          rst,

    input                          display_on,
    input        [w_x - 1:0]       x,
    input        [w_y - 1:0]       y,

    input                          sprite_target_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb,
    input                          sprite_torpedo_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_torpedo_rgb,

    input                          game_won,
    input                          end_of_game_timer_running,
    input                          random,

    output logic [`GAME_RGB_WIDTH - 1:0] rgb
);

    localparam SQUARE_SIZE = 100;
    localparam CENTER_X = screen_width / 2;
    localparam CENTER_Y = screen_height / 2;
    localparam SQUARE_START_X = CENTER_X - SQUARE_SIZE/2;
    localparam SQUARE_END_X = CENTER_X + SQUARE_SIZE/2;
    localparam SQUARE_START_Y = CENTER_Y - SQUARE_SIZE/2;
    localparam SQUARE_END_Y = CENTER_Y + SQUARE_SIZE/2;

    logic [`GAME_RGB_WIDTH - 1:0] rgb_comb;

    always_comb begin
        if (!display_on) begin
            rgb_comb = '0;
        end
        else if (end_of_game_timer_running) begin
            rgb_comb = {1'b1, ~game_won, random};
        end
        else if (sprite_torpedo_rgb_en) begin
            rgb_comb = sprite_torpedo_rgb;
        end
        else if (sprite_target_rgb_en) begin
            rgb_comb = sprite_target_rgb;
        end
        else begin
            if ((x >= SQUARE_START_X) && (x < SQUARE_END_X) && 
                (y >= SQUARE_START_Y) && (y < SQUARE_END_Y)) begin
                rgb_comb = '0;
            end
            else begin
                rgb_comb = {`GAME_RGB_WIDTH{1'b1}};
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) rgb <= '0;
        else     rgb <= rgb_comb;
    end

endmodule