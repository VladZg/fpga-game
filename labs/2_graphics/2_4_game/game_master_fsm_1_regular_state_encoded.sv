`include "game_config.svh"

module game_master_fsm_1_regular_state_encoded
(
    input      clk,
    input      rst,

    input      launch_key,
    input      shoot,

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

    input      sprite_target_within_screen_1,
    input      sprite_target_within_screen_2,
    input      sprite_target_within_screen_3,
    input      sprite_bullet_within_screen,
    input      sprite_spaceship_within_screen,
    input      sprite_heart_1_within_screen,
    input      sprite_heart_2_within_screen,
    input      sprite_heart_3_within_screen,
    input      sprite_heart_within_screen,

    input      collision,
    input      collision_bullet,

    output logic end_of_game_timer_start,
    output logic game_won,

    output logic [2:0] score,
    output logic [2:0] debug,
    output logic [2:0] n_lifes,

    input      end_of_game_timer_running
);

    localparam [2:0] STATE_START_GAME   = 0,
                     STATE_START_ROUND  = 1,
                     STATE_AIM          = 2,
                     STATE_SHOOT        = 3,
                     STATE_END_ROUND    = 4,
                     STATE_END_GAME     = 5,
                     STATE_DEBUG        = 6,
                     STATE_MINUS_LIFE   = 7,
                     STATE_PLUS_SCORE   = 8;

    logic [2:0] state;
    logic [2:0] d_state;

    logic d_sprite_target_write_xy_1;
    logic d_sprite_target_write_xy_2;
    logic d_sprite_target_write_xy_3;
    logic d_sprite_spaceship_write_xy;
    logic d_sprite_bullet_write_xy;
    logic d_sprite_heart_1_write_xy;
    logic d_sprite_heart_2_write_xy;
    logic d_sprite_heart_3_write_xy;

    logic d_sprite_target_write_dxy_1;
    logic d_sprite_target_write_dxy_2;
    logic d_sprite_target_write_dxy_3;
    logic d_sprite_spaceship_write_dxy;
    logic d_sprite_bullet_write_dxy;
    logic d_sprite_heart_1_write_dxy;
    logic d_sprite_heart_2_write_dxy;
    logic d_sprite_heart_3_write_dxy;


    logic d_sprite_target_enable_update_1;
    logic d_sprite_target_enable_update_2;
    logic d_sprite_target_enable_update_3;
    logic d_sprite_spaceship_enable_update;
    logic d_sprite_bullet_enable_update;
    logic d_sprite_heart_1_enable_update;
    logic d_sprite_heart_2_enable_update;
    logic d_sprite_heart_3_enable_update;


    logic d_end_of_game_timer_start;
    logic d_game_won;
    logic d_round_won;

    logic d_shoot;
    logic [2:0] d_score;
    logic [2:0] d_debug;
    logic [2:0] d_n_lifes;

    logic [2:0] sasalka;

    //------------------------------------------------------------------------

    // wire game_end = collision;
    // wire round_won = collision_bullet;

    wire round_end =
          ~sprite_target_within_screen_1
        | ~sprite_target_within_screen_2
        | ~sprite_target_within_screen_3
        | ~sprite_spaceship_within_screen
        | ~sprite_bullet_within_screen;

    //------------------------------------------------------------------------

    always_comb
    begin
        d_state   = state;
        d_score   = score;
        d_n_lifes = n_lifes;
        d_debug   = n_lifes;

        d_sprite_target_write_xy_1        = 1'b0;
        d_sprite_target_write_xy_2        = 1'b0;
        d_sprite_target_write_xy_3        = 1'b0;
        d_sprite_bullet_write_xy          = 1'b0;
        d_sprite_spaceship_write_xy       = 1'b0;
        d_sprite_heart_1_write_xy         = 1'b0;
        d_sprite_heart_2_write_xy         = 1'b0;
        d_sprite_heart_3_write_xy         = 1'b0;

        d_sprite_target_write_dxy_1       = 1'b0;
        d_sprite_target_write_dxy_2       = 1'b0;
        d_sprite_target_write_dxy_3       = 1'b0;
        d_sprite_spaceship_write_dxy      = 1'b0;
        d_sprite_bullet_write_dxy         = 1'b0;
        d_sprite_heart_1_write_dxy        = 1'b0;
        d_sprite_heart_2_write_dxy        = 1'b0;
        d_sprite_heart_3_write_dxy        = 1'b0;

        d_sprite_target_enable_update_1   = 1'b0;
        d_sprite_target_enable_update_2   = 1'b0;
        d_sprite_target_enable_update_3   = 1'b0;
        d_sprite_spaceship_enable_update  = 1'b0;
        d_sprite_bullet_enable_update     = 1'b0;
        d_sprite_heart_1_enable_update    = 1'b1;
        d_sprite_heart_2_enable_update    = 1'b1;
        d_sprite_heart_3_enable_update    = 1'b1;

        d_end_of_game_timer_start         = 1'b0;
        d_shoot                           = 1'b0;
        d_game_won                        = game_won;
        d_round_won                       = 1'b0;

        //--------------------------------------------------------------------

        case (state)

        STATE_START_GAME:
        begin
            d_game_won                  = 1'b0;
            d_round_won                 = 1'b0;
            d_end_of_game_timer_start   = 1'b1;

            d_score                     = 0;
            d_n_lifes                   = 3;
            d_debug                     = 0;

            d_sprite_heart_1_write_xy   = 1'b1;
            d_sprite_heart_2_write_xy   = 1'b1;
            d_sprite_heart_3_write_xy   = 1'b1;

            d_state = STATE_START_ROUND;
        end

        STATE_START_ROUND:
        begin
            d_sprite_target_write_xy_1        = 1'b1;
            d_sprite_target_write_xy_2        = 1'b1;
            d_sprite_target_write_xy_3        = 1'b1;

            d_sprite_target_write_dxy_1       = 1'b1;
            d_sprite_target_write_dxy_2       = 1'b1;
            d_sprite_target_write_dxy_3       = 1'b1;

            d_sprite_spaceship_write_xy       = 1'b1;
            d_sprite_bullet_write_xy          = 1'b1;

            d_round_won                       = 1'b0;

            // if (!end_of_game_timer_running)
                // d_state = STATE_END_GAME;
            // else
                d_state = STATE_AIM;
        end

        STATE_AIM:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            // if (!end_of_game_timer_running || )
            if (collision)
            begin
                d_state = STATE_MINUS_LIFE;
            end
            else if (launch_key)
            begin
                d_state = STATE_SHOOT;
            end
            else if (round_end)
            begin
                d_state = STATE_END_ROUND;
            end
        end

        STATE_SHOOT:
        begin
            d_sprite_spaceship_write_dxy     = 1'b1;
            d_sprite_bullet_write_dxy        = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_spaceship_enable_update  = 1'b1;

            // if (!end_of_game_timer_running)
                // d_state = STATE_END_GAME;
            if (collision)
            begin
                d_state = STATE_MINUS_LIFE;
            end
            else if (collision_bullet)
            begin
                d_state = STATE_PLUS_SCORE;
            end
            else if (round_end)
            begin
                d_state = STATE_END_ROUND;
            end

        end

        STATE_MINUS_LIFE:
        begin
            case (d_n_lifes)
            3'd3:
                d_sprite_heart_1_write_xy = 1'b0;
            3'd2:
                d_sprite_heart_2_write_xy = 1'b0;
            3'd1:
                d_sprite_heart_3_write_xy = 1'b0;
            endcase
            d_n_lifes = n_lifes - 1;  // FIXME: DELETE LATER
            d_state = STATE_END_ROUND;
        end

        STATE_PLUS_SCORE:
        begin
            d_score = score + 1;  // FIXME: DELETE LATER
            d_state = STATE_END_ROUND;
        end

        STATE_END_ROUND:
        begin
            // if (!end_of_game_timer_running)
                // d_state = STATE_END_GAME;
            if (d_score == 3 || d_n_lifes == 0) // TODO: declare 3 as a const
            begin
                d_state = STATE_END_GAME;
            end
            else
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_END_GAME:
        begin
            d_state = STATE_START_GAME;
        end

        endcase
    end

    always_ff @ (posedge clk or posedge rst)
    begin
        if (rst) begin
            // "ZA ZARIPOVA" LOGIC UNIT
            sasalka <= 0;
        end
        else if (state == STATE_PLUS_SCORE)
            sasalka <= sasalka + 1;
        // else if (state == STATE_MINUS_LIFE)
            // d_n_lifes <= d_n_lifes - 1;
        // else if (state == STATE_PLUS_SCORE)
            // d_score <= d_score + 1;
    end

    //------------------------------------------------------------------------

    always_ff @ (posedge clk or posedge rst)
        if (rst)
        begin
            state                           <= STATE_START_GAME;
            score                           <= 3'd0;
            n_lifes                         <= 3'd3;
            debug                           <= 3'd0;

            sprite_target_write_xy_1        <= 1'b0;
            sprite_target_write_xy_2        <= 1'b0;
            sprite_target_write_xy_3        <= 1'b0;
            sprite_spaceship_write_xy       <= 1'b0;
            sprite_bullet_write_xy          <= 1'b0;
            sprite_heart_1_write_xy         <= 1'b0;
            sprite_heart_2_write_xy         <= 1'b0;
            sprite_heart_3_write_xy         <= 1'b0;

            sprite_target_write_dxy_1       <= 1'b0;
            sprite_target_write_dxy_2       <= 1'b0;
            sprite_target_write_dxy_3       <= 1'b0;
            sprite_spaceship_write_dxy      <= 1'b0;
            sprite_bullet_write_dxy         <= 1'b0;
            sprite_heart_1_write_dxy        <= 1'b0;
            sprite_heart_2_write_dxy        <= 1'b0;
            sprite_heart_3_write_dxy        <= 1'b0;

            sprite_target_enable_update_1   <= 1'b0;
            sprite_target_enable_update_2   <= 1'b0;
            sprite_target_enable_update_3   <= 1'b0;
            sprite_spaceship_enable_update  <= 1'b0;
            sprite_bullet_enable_update     <= 1'b0;
            sprite_heart_1_enable_update    <= 1'b0;
            sprite_heart_2_enable_update    <= 1'b0;
            sprite_heart_3_enable_update    <= 1'b0;

            end_of_game_timer_start         <= 1'b0;
            game_won                        <= 1'b0;
        end
        else
        begin
            state                           <= d_state;
            score                           <= d_score;
            n_lifes                         <= d_n_lifes;
            debug                           <= sasalka;   //d_state

            sprite_target_write_xy_1        <= d_sprite_target_write_xy_1;
            sprite_target_write_xy_2        <= d_sprite_target_write_xy_2;
            sprite_target_write_xy_3        <= d_sprite_target_write_xy_3;
            sprite_spaceship_write_xy       <= d_sprite_spaceship_write_xy;
            sprite_bullet_write_xy          <= d_sprite_bullet_write_xy;
            sprite_heart_1_write_xy         <= d_sprite_heart_1_write_xy;
            sprite_heart_2_write_xy         <= d_sprite_heart_2_write_xy;
            sprite_heart_3_write_xy         <= d_sprite_heart_3_write_xy;

            sprite_target_write_dxy_1       <= d_sprite_target_write_dxy_1;
            sprite_target_write_dxy_2       <= d_sprite_target_write_dxy_2;
            sprite_target_write_dxy_3       <= d_sprite_target_write_dxy_3;
            sprite_spaceship_write_dxy      <= d_sprite_spaceship_write_dxy;
            sprite_bullet_write_dxy         <= d_sprite_bullet_write_dxy;
            sprite_heart_1_write_dxy        <= d_sprite_heart_1_write_dxy;
            sprite_heart_2_write_dxy        <= d_sprite_heart_2_write_dxy;
            sprite_heart_3_write_dxy        <= d_sprite_heart_3_write_dxy;

            sprite_target_enable_update_1   <= d_sprite_target_enable_update_1;
            sprite_target_enable_update_2   <= d_sprite_target_enable_update_2;
            sprite_target_enable_update_3   <= d_sprite_target_enable_update_3;
            sprite_spaceship_enable_update  <= d_sprite_spaceship_enable_update;
            sprite_bullet_enable_update     <= d_sprite_bullet_enable_update;
            sprite_heart_1_enable_update    <= d_sprite_heart_1_enable_update;
            sprite_heart_2_enable_update    <= d_sprite_heart_2_enable_update;
            sprite_heart_3_enable_update    <= d_sprite_heart_3_enable_update;

            end_of_game_timer_start         <= d_end_of_game_timer_start;

            game_won                        <= d_game_won;
        end

endmodule
