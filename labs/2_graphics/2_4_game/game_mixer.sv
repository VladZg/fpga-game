`include "game_config.svh"

module game_mixer
(
    input                                clk,
    input                                rst,

    input                                sprite_target_rgb_en_1,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb_1,
    input                                sprite_target_rgb_en_2,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb_2,
    input                                sprite_target_rgb_en_3,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_target_rgb_3,

    input                                sprite_heart_1_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_heart_1_rgb,
    input                                sprite_heart_2_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_heart_2_rgb,
    input                                sprite_heart_3_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_heart_3_rgb,

    input                                sprite_score_1_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_score_1_rgb,
    input                                sprite_score_2_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_score_2_rgb,
    input                                sprite_score_3_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_score_3_rgb,

    input                                sprite_bullet_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_bullet_rgb,

    input                                sprite_spaceship_rgb_en,
    input        [`GAME_RGB_WIDTH - 1:0] sprite_spaceship_rgb,

    input                                game_won,
    input                                end_of_game_timer_running,
    input                                random,

    output logic [`GAME_RGB_WIDTH - 1:0] rgb
);

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            rgb <= 3'b000;
        else if (end_of_game_timer_running)
            rgb <= { 1'b1, ~ game_won, random };
        else if (sprite_spaceship_rgb_en)
            rgb <= sprite_spaceship_rgb;
        else if (sprite_target_rgb_en_1)
            rgb <= sprite_target_rgb_1;
        else if (sprite_target_rgb_en_2)
            rgb <= sprite_target_rgb_2;
        else if (sprite_target_rgb_en_3)
            rgb <= sprite_target_rgb_3;
        else if (sprite_bullet_rgb_en)
            rgb <= sprite_bullet_rgb;
        else if (sprite_heart_1_rgb_en)
            rgb <= sprite_heart_1_rgb;
        else if (sprite_heart_2_rgb_en)
            rgb <= sprite_heart_2_rgb;
        else if (sprite_heart_3_rgb_en)
            rgb <= sprite_heart_3_rgb;
        else if (sprite_score_1_rgb_en)
            rgb <= sprite_score_1_rgb;
        else if (sprite_score_2_rgb_en)
            rgb <= sprite_score_2_rgb;
        else if (sprite_score_3_rgb_en)
            rgb <= sprite_score_3_rgb;
        else
            rgb <= 3'b000;

endmodule
