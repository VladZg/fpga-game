`include "game_config.svh"

module game_mixer
#(
    parameter screen_width  = 640,
              screen_height = 480
)
(
    input                          clk,
    input                          rst,

    input                          display_on,
    input        [w_x     - 1:0]   x,
    input        [w_y     - 1:0]   y,

    input                          sprite_target_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb,

    input                          sprite_torpedo_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_torpedo_rgb,

    input                          game_won,
    input                          end_of_game_timer_running,
    input                          random,

    output logic [`GAME_RGB_WIDTH - 1:0] rgb
);

    // Параметры для центрального квадрата
    localparam SQUARE_SIZE = 100;
    localparam HALF_SQUARE = SQUARE_SIZE / 2;
    localparam CENTER_X = screen_width / 2;
    localparam CENTER_Y = screen_height / 2;

    logic [`GAME_RGB_WIDTH - 1:0] rgb_comb;

    always_comb begin
        if (!display_on) begin
            rgb_comb = '0;
        end
        else if (end_of_game_timer_running) begin
            rgb_comb = { 1'b1, ~game_won, random };
        end
        else if (sprite_torpedo_rgb_en) begin
            rgb_comb = sprite_torpedo_rgb;
        end
        else if (sprite_target_rgb_en) begin
            rgb_comb = sprite_target_rgb;
        end
        else begin
            if (x >= CENTER_X - HALF_SQUARE && 
                x <  CENTER_X + HALF_SQUARE &&
                y >= CENTER_Y - HALF_SQUARE && 
                y <  CENTER_Y + HALF_SQUARE) 
            begin
                rgb_comb = '0;
            end
            else begin
                rgb_comb = {`GAME_RGB_WIDTH{1'b1}};
            end
        end
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rgb <= '0;
        end
        else begin
            rgb <= rgb_comb;
        end
    end

endmodule
