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
    output logic sprite_torpedo_write_xy,

    output logic sprite_target_write_dxy_1,
    output logic sprite_target_write_dxy_2,
    output logic sprite_target_write_dxy_3,

    output logic sprite_bullet_write_dxy,
    output logic sprite_torpedo_write_dxy,

    output logic sprite_target_enable_update_1,
    output logic sprite_target_enable_update_2,
    output logic sprite_target_enable_update_3,

    output logic sprite_bullet_enable_update,
    output logic sprite_torpedo_enable_update,

    input      sprite_target_within_screen_1,
    input      sprite_target_within_screen_2,
    input      sprite_target_within_screen_3,

    input      sprite_bullet_within_screen,
    input      sprite_torpedo_within_screen,
    input      collision,
    input      collision_bullet,

    output logic end_of_game_timer_start,
    output logic game_won,

    output logic [3:0] score,

    input      end_of_game_timer_running
);

    localparam [2:0] STATE_START_GAME   = 0,
                     STATE_START_ROUND  = 1,
                     STATE_AIM          = 2,
                     STATE_SHOOT        = 3,
                     STATE_END_ROUND    = 4,
                     STATE_END_GAME     = 5;

    logic [1:0] state;
    logic [1:0] d_state;

    logic d_sprite_target_write_xy_1;
    logic d_sprite_target_write_xy_2;
    logic d_sprite_target_write_xy_3;

    logic d_sprite_torpedo_write_xy;
    logic d_sprite_bullet_write_xy;

    logic d_sprite_target_write_dxy_1;
    logic d_sprite_target_write_dxy_2;
    logic d_sprite_target_write_dxy_3;

    logic d_sprite_torpedo_write_dxy;
    logic d_sprite_bullet_write_dxy;

    logic d_sprite_target_enable_update_1;
    logic d_sprite_target_enable_update_2;
    logic d_sprite_target_enable_update_3;

    logic d_sprite_torpedo_enable_update;
    logic d_sprite_bullet_enable_update;

    logic d_end_of_game_timer_start;
    logic d_game_won;
    logic d_round_won;

    logic d_shoot;
    logic [3:0] d_score;

    //------------------------------------------------------------------------

    wire game_end = collision;

    wire round_won = collision_bullet;

    wire round_end =
          ~sprite_target_within_screen_1
        | ~sprite_target_within_screen_2
        | ~sprite_target_within_screen_3
        | ~sprite_torpedo_within_screen
        | ~sprite_bullet_within_screen;

    //------------------------------------------------------------------------

    always_comb
    begin
        d_state = state;

        d_sprite_target_write_xy_1        = 1'b0;
        d_sprite_target_write_xy_2        = 1'b0;
        d_sprite_target_write_xy_3        = 1'b0;

        d_sprite_bullet_write_xy          = 1'b0;
        d_sprite_torpedo_write_xy         = 1'b0;

        d_sprite_target_write_dxy_1       = 1'b0;
        d_sprite_target_write_dxy_2       = 1'b0;
        d_sprite_target_write_dxy_3       = 1'b0;

        d_sprite_torpedo_write_dxy        = 1'b0;
        d_sprite_bullet_write_dxy         = 1'b0;

        d_sprite_target_enable_update_1   = 1'b0;
        d_sprite_target_enable_update_2   = 1'b0;
        d_sprite_target_enable_update_3   = 1'b0;

        d_sprite_torpedo_enable_update    = 1'b0;
        d_sprite_bullet_enable_update     = 1'b0;

        d_end_of_game_timer_start         = 1'b0;
        d_shoot                           = 1'b0;
        d_game_won                        = game_won;
        d_round_won                       = 1'b0;

        //--------------------------------------------------------------------

        case (state)

        STATE_START_GAME:
        begin
            d_game_won                        = 1'b0;
            d_round_won                       = 1'b0;

            d_state = STATE_START_ROUND;
        end

        STATE_START_ROUND:
        begin
            d_sprite_target_write_xy_1        = 1'b1;
            d_sprite_target_write_xy_2        = 1'b1;
            d_sprite_target_write_xy_3        = 1'b1;

            d_sprite_torpedo_write_xy         = 1'b1;
            d_sprite_bullet_write_xy          = 1'b1;

            d_sprite_target_write_dxy_1       = 1'b1;
            d_sprite_target_write_dxy_2       = 1'b1;
            d_sprite_target_write_dxy_3       = 1'b1;

            d_round_won                       = 1'b0;

            d_state = STATE_AIM;
        end

        STATE_AIM:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (game_end)
            begin
                d_end_of_game_timer_start   = 1'b1;
                d_state = STATE_END_GAME;
            end

            else if (launch_key)
            begin
                d_state = STATE_SHOOT;
            end
        end

        STATE_SHOOT:
        begin
            d_sprite_torpedo_write_dxy      = 1'b1;
            d_sprite_bullet_write_dxy       = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_bullet_enable_update   = 1'b1;

            d_sprite_torpedo_enable_update  = 1'b1;

            if (round_won)
            begin
                d_score = d_score + 1;
                d_state = STATE_END_ROUND;
            end
            else if (round_end)
                d_state = STATE_START_ROUND;
            else if (game_end)
            begin
                d_end_of_game_timer_start   = 1'b1;
                d_state = STATE_END_GAME;
            end

        end

        STATE_END_ROUND:
        begin
            if (score == 4'd10)
                d_state = STATE_END_GAME;
            else
                d_state = STATE_START_ROUND;
        end

        STATE_END_GAME:
        begin
            if (!end_of_game_timer_running)
                d_state = STATE_START_GAME;

        end

        endcase
    end

    //------------------------------------------------------------------------

    always_ff @ (posedge clk or posedge rst)
        if (rst)
        begin
            state                           <= STATE_START_GAME;
            score                           <= 4'b0;

            sprite_target_write_xy_1        <= 1'b0;
            sprite_target_write_xy_2        <= 1'b0;
            sprite_target_write_xy_3        <= 1'b0;

            sprite_torpedo_write_xy         <= 1'b0;
            sprite_bullet_write_xy          <= 1'b0;

            sprite_target_write_dxy_1       <= 1'b0;
            sprite_target_write_dxy_2       <= 1'b0;
            sprite_target_write_dxy_3       <= 1'b0;

            sprite_torpedo_write_dxy        <= 1'b0;
            sprite_bullet_write_dxy         <= 1'b0;

            sprite_target_enable_update_1   <= 1'b0;
            sprite_target_enable_update_2   <= 1'b0;
            sprite_target_enable_update_3   <= 1'b0;

            sprite_torpedo_enable_update    <= 1'b0;
            sprite_bullet_enable_update     <= 1'b0;

            end_of_game_timer_start         <= 1'b0;
            game_won                        <= 1'b0;
        end
        else
        begin
            state                           <= d_state;
            score                           <= d_score;

            sprite_target_write_xy_1        <= d_sprite_target_write_xy_1;
            sprite_target_write_xy_2        <= d_sprite_target_write_xy_2;
            sprite_target_write_xy_3        <= d_sprite_target_write_xy_3;

            sprite_torpedo_write_xy         <= d_sprite_torpedo_write_xy;
            sprite_bullet_write_xy          <= d_sprite_bullet_write_xy;

            sprite_target_write_dxy_1       <= d_sprite_target_write_dxy_1;
            sprite_target_write_dxy_2       <= d_sprite_target_write_dxy_2;
            sprite_target_write_dxy_3       <= d_sprite_target_write_dxy_3;

            sprite_torpedo_write_dxy        <= d_sprite_torpedo_write_dxy;
            sprite_bullet_write_dxy         <= d_sprite_bullet_write_dxy;

            sprite_target_enable_update_1   <= d_sprite_target_enable_update_1;
            sprite_target_enable_update_2   <= d_sprite_target_enable_update_2;
            sprite_target_enable_update_3   <= d_sprite_target_enable_update_3;

            sprite_torpedo_enable_update    <= d_sprite_torpedo_enable_update;
            sprite_bullet_enable_update     <= d_sprite_bullet_enable_update;

            end_of_game_timer_start         <= d_end_of_game_timer_start;

            game_won                        <= d_game_won;
        end

endmodule
