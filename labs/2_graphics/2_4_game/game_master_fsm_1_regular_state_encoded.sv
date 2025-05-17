`include "game_config.svh"

module game_master_fsm_1_regular_state_encoded
(
    input      logic      clk,
    input      logic      rst,

    input      logic      launch_key,
    input      logic      shoot,

    output logic sprite_target_write_xy_1,
    output logic sprite_target_write_xy_2,
    output logic sprite_target_write_xy_3,
    output logic sprite_bullet_write_xy,
    output logic sprite_spaceship_write_xy,
    output logic sprite_heart_1_write_xy,
    output logic sprite_heart_2_write_xy,
    output logic sprite_heart_3_write_xy,

    output logic sprite_target_write_dxy_1,
    output logic sprite_target_write_dxy_2,
    output logic sprite_target_write_dxy_3,
    output logic sprite_bullet_write_dxy,
    output logic sprite_spaceship_write_dxy,
    output logic sprite_heart_1_write_dxy,
    output logic sprite_heart_2_write_dxy,
    output logic sprite_heart_3_write_dxy,

    output logic sprite_target_enable_update_1,
    output logic sprite_target_enable_update_2,
    output logic sprite_target_enable_update_3,
    output logic sprite_bullet_enable_update,
    output logic sprite_spaceship_enable_update,
    output logic sprite_heart_1_enable_update,
    output logic sprite_heart_2_enable_update,
    output logic sprite_heart_3_enable_update,

    input      logic      sprite_target_within_screen_1,
    input      logic      sprite_target_within_screen_2,
    input      logic      sprite_target_within_screen_3,
    input      logic      sprite_bullet_within_screen,
    input      logic      sprite_spaceship_within_screen,
    input      logic      sprite_heart_1_within_screen,
    input      logic      sprite_heart_2_within_screen,
    input      logic      sprite_heart_3_within_screen,

    input      logic      collision,
    input      logic      collision_bullet,

    output logic end_of_game_timer_start,
    output logic game_won,

    output logic [2:0] score,
    output logic [2:0] debug,
    output logic [2:0] n_lifes,

    input      logic      end_of_game_timer_running
);

    //------------------------------------------------------------------------
    localparam [2:0] STATE_START_GAME   = 3'd0,
                     STATE_START_ROUND  = 3'd1,
                     STATE_AIM          = 3'd2,
                     STATE_SHOOT        = 3'd3,
                     STATE_END_ROUND    = 3'd4,
                     STATE_END_GAME     = 3'd5;

    logic [2:0] state, next_state;

    //------------------------------------------------------------------------
    // Registers for next-state outputs
    logic d_sprite_target_write_xy_1, d_sprite_target_write_xy_2, d_sprite_target_write_xy_3;
    logic d_sprite_bullet_write_xy, d_sprite_spaceship_write_xy;
    logic d_sprite_heart_1_write_xy, d_sprite_heart_2_write_xy, d_sprite_heart_3_write_xy;

    logic d_sprite_target_write_dxy_1, d_sprite_target_write_dxy_2, d_sprite_target_write_dxy_3;
    logic d_sprite_bullet_write_dxy, d_sprite_spaceship_write_dxy;
    logic d_sprite_heart_1_write_dxy, d_sprite_heart_2_write_dxy, d_sprite_heart_3_write_dxy;

    logic d_sprite_target_enable_update_1, d_sprite_target_enable_update_2, d_sprite_target_enable_update_3;
    logic d_sprite_bullet_enable_update, d_sprite_spaceship_enable_update;
    logic d_sprite_heart_1_enable_update, d_sprite_heart_2_enable_update, d_sprite_heart_3_enable_update;

    logic d_end_of_game_timer_start, d_game_won;
    logic [2:0] d_score, d_debug, d_n_lifes;

    //------------------------------------------------------------------------
    // Round end detection
    wire round_end =
          ~sprite_target_within_screen_1
        | ~sprite_target_within_screen_2
        | ~sprite_target_within_screen_3
        | ~sprite_spaceship_within_screen
        | ~sprite_bullet_within_screen;

    //------------------------------------------------------------------------
    always_comb begin
        // default next-state
        next_state = state;
        // preserve current score/lives/debug
        d_score   = score;
        d_n_lifes = n_lifes;
        d_debug   = state;

        // default outputs
        d_sprite_target_write_xy_1     = 1'b0;
        d_sprite_target_write_xy_2     = 1'b0;
        d_sprite_target_write_xy_3     = 1'b0;
        d_sprite_bullet_write_xy       = 1'b0;
        d_sprite_spaceship_write_xy    = 1'b0;
        d_sprite_heart_1_write_xy      = 1'b0;
        d_sprite_heart_2_write_xy      = 1'b0;
        d_sprite_heart_3_write_xy      = 1'b0;

        d_sprite_target_write_dxy_1    = 1'b0;
        d_sprite_target_write_dxy_2    = 1'b0;
        d_sprite_target_write_dxy_3    = 1'b0;
        d_sprite_bullet_write_dxy      = 1'b0;
        d_sprite_spaceship_write_dxy   = 1'b0;
        d_sprite_heart_1_write_dxy     = 1'b0;
        d_sprite_heart_2_write_dxy     = 1'b0;
        d_sprite_heart_3_write_dxy     = 1'b0;

        d_sprite_target_enable_update_1 = 1'b0;
        d_sprite_target_enable_update_2 = 1'b0;
        d_sprite_target_enable_update_3 = 1'b0;
        d_sprite_bullet_enable_update   = 1'b0;
        d_sprite_spaceship_enable_update= 1'b0;
        d_sprite_heart_1_enable_update  = 1'b1;
        d_sprite_heart_2_enable_update  = 1'b1;
        d_sprite_heart_3_enable_update  = 1'b1;

        d_end_of_game_timer_start       = 1'b0;
        d_game_won                      = game_won;

        // FSM
        case (state)

        STATE_START_GAME: begin
            d_game_won                  = 1'b0;
            d_end_of_game_timer_start   = 1'b1;

            d_score                     = 3'd0;
            d_n_lifes                   = 3'd3;

            d_sprite_heart_1_write_xy   = 1'b1;
            d_sprite_heart_2_write_xy   = 1'b1;
            d_sprite_heart_3_write_xy   = 1'b1;

            next_state = STATE_START_ROUND;
        end

        STATE_START_ROUND: begin
            // init targets and spaceship
            d_sprite_target_write_xy_1   = 1'b1;
            d_sprite_target_write_xy_2   = 1'b1;
            d_sprite_target_write_xy_3   = 1'b1;
            d_sprite_spaceship_write_xy  = 1'b1;
            // init bullet
            d_sprite_bullet_write_xy     = shoot;

            // init movement
            d_sprite_target_write_dxy_1  = 1'b1;
            d_sprite_target_write_dxy_2  = 1'b1;
            d_sprite_target_write_dxy_3  = 1'b1;

            next_state = STATE_AIM;
        end

        STATE_AIM: begin
            // move targets
            d_sprite_target_enable_update_1 = 1'b1;
            d_sprite_target_enable_update_2 = 1'b1;
            d_sprite_target_enable_update_3 = 1'b1;

            if (collision_bullet) begin
                d_score = score + 1;
                next_state = STATE_END_ROUND;
            end
            else if (launch_key) begin
                next_state = STATE_SHOOT;
            end
            else if (round_end) begin
                next_state = STATE_END_ROUND;
            end
        end

        STATE_SHOOT: begin
            // fire and move
            d_sprite_spaceship_write_dxy   = 1'b1;
            d_sprite_bullet_write_dxy      = shoot;

            d_sprite_target_enable_update_1 = 1'b1;
            d_sprite_target_enable_update_2 = 1'b1;
            d_sprite_target_enable_update_3 = 1'b1;

            d_sprite_bullet_enable_update   = shoot;
            d_sprite_spaceship_enable_update= 1'b1;

            if (collision) begin
                // decrease life and hide heart
                d_n_lifes = n_lifes - 1;
                unique case (n_lifes)
                3'd3: d_sprite_heart_3_write_xy = 1'b0;
                3'd2: d_sprite_heart_2_write_xy = 1'b0;
                3'd1: d_sprite_heart_1_write_xy = 1'b0;
                endcase
                next_state = STATE_END_ROUND;
            end
            else if (collision_bullet) begin
                d_score = score + 1;
                next_state = STATE_END_ROUND;
            end
            else if (round_end) begin
                next_state = STATE_END_ROUND;
            end
        end

        STATE_END_ROUND: begin
            if (d_score == 3'd3 || d_n_lifes == 3'd0)
                next_state = STATE_END_GAME;
            else
                next_state = STATE_START_ROUND;
        end

        STATE_END_GAME: begin
            d_game_won = 1'b1;
            if (!end_of_game_timer_running)
                next_state = STATE_START_GAME;
        end

        endcase
    end

    //------------------------------------------------------------------------
    // Register state and outputs
    always_ff @ (posedge clk or posedge rst) begin
        if (rst) begin
            state   <= STATE_START_GAME;
            score   <= 3'd0;
            n_lifes <= 3'd3;
            debug   <= 3'd0;

            sprite_target_write_xy_1   <= 1'b0;
            sprite_target_write_xy_2   <= 1'b0;
            sprite_target_write_xy_3   <= 1'b0;
            sprite_bullet_write_xy     <= 1'b0;
            sprite_spaceship_write_xy  <= 1'b0;
            sprite_heart_1_write_xy    <= 1'b0;
            sprite_heart_2_write_xy    <= 1'b0;
            sprite_heart_3_write_xy    <= 1'b0;

            sprite_target_write_dxy_1  <= 1'b0;
            sprite_target_write_dxy_2  <= 1'b0;
            sprite_target_write_dxy_3  <= 1'b0;
            sprite_spaceship_write_dxy <= 1'b0;
            sprite_bullet_write_dxy    <= 1'b0;
            sprite_heart_1_write_dxy   <= 1'b0;
            sprite_heart_2_write_dxy   <= 1'b0;
            sprite_heart_3_write_dxy   <= 1'b0;

            sprite_target_enable_update_1 <= 1'b0;
            sprite_target_enable_update_2 <= 1'b0;
            sprite_target_enable_update_3 <= 1'b0;
            sprite_bullet_enable_update   <= 1'b0;
            sprite_spaceship_enable_update<= 1'b0;
            sprite_heart_1_enable_update  <= 1'b0;
            sprite_heart_2_enable_update  <= 1'b0;
            sprite_heart_3_enable_update  <= 1'b0;

            end_of_game_timer_start <= 1'b0;
            game_won                <= 1'b0;
        end else begin
            state   <= next_state;
            score   <= d_score;
            n_lifes <= d_n_lifes;
            debug   <= d_debug;

            sprite_target_write_xy_1   <= d_sprite_target_write_xy_1;
            sprite_target_write_xy_2   <= d_sprite_target_write_xy_2;
            sprite_target_write_xy_3   <= d_sprite_target_write_xy_3;
            sprite_bullet_write_xy     <= d_sprite_bullet_write_xy;
            sprite_spaceship_write_xy  <= d_sprite_spaceship_write_xy;
            sprite_heart_1_write_xy    <= d_sprite_heart_1_write_xy;
            sprite_heart_2_write_xy    <= d_sprite_heart_2_write_xy;
            sprite_heart_3_write_xy    <= d_sprite_heart_3_write_xy;

            sprite_target_write_dxy_1  <= d_sprite_target_write_dxy_1;
            sprite_target_write_dxy_2  <= d_sprite_target_write_dxy_2;
            sprite_target_write_dxy_3  <= d_sprite_target_write_dxy_3;
            sprite_spaceship_write_dxy <= d_sprite_spaceship_write_dxy;
            sprite_bullet_write_dxy    <= d_sprite_bullet_write_dxy;
            sprite_heart_1_write_dxy   <= d_sprite_heart_1_write_dxy;
            sprite_heart_2_write_dxy   <= d_sprite_heart_2_write_dxy;
            sprite_heart_3_write_dxy   <= d_sprite_heart_3_write_dxy;

            sprite_target_enable_update_1 <= d_sprite_target_enable_update_1;
            sprite_target_enable_update_2 <= d_sprite_target_enable_update_2;
            sprite_target_enable_update_3 <= d_sprite_target_enable_update_3;
            sprite_bullet_enable_update   <= d_sprite_bullet_enable_update;
            sprite_spaceship_enable_update<= d_sprite_spaceship_enable_update;
            sprite_heart_1_enable_update  <= d_sprite_heart_1_enable_update;
            sprite_heart_2_enable_update  <= d_sprite_heart_2_enable_update;
            sprite_heart_3_enable_update  <= d_sprite_heart_3_enable_update;

            end_of_game_timer_start <= d_end_of_game_timer_start;
            game_won                <= d_game_won;
        end
    end

endmodule
