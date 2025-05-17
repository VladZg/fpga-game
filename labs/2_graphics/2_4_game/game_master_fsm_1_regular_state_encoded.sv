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
    output logic sprite_score_1_write_xy,
    output logic sprite_score_2_write_xy,
    output logic sprite_score_3_write_xy,

    output logic sprite_target_write_dxy_1,
    output logic sprite_target_write_dxy_2,
    output logic sprite_target_write_dxy_3,
    output logic sprite_bullet_write_dxy,
    output logic sprite_spaceship_write_dxy,
    output logic sprite_heart_1_write_dxy,
    output logic sprite_heart_2_write_dxy,
    output logic sprite_heart_3_write_dxy,
    output logic sprite_score_1_write_dxy,
    output logic sprite_score_2_write_dxy,
    output logic sprite_score_3_write_dxy,

    output logic sprite_target_enable_update_1,
    output logic sprite_target_enable_update_2,
    output logic sprite_target_enable_update_3,
    output logic sprite_bullet_enable_update,
    output logic sprite_spaceship_enable_update,
    output logic sprite_heart_1_enable_update,
    output logic sprite_heart_2_enable_update,
    output logic sprite_heart_3_enable_update,
    output logic sprite_score_1_enable_update,
    output logic sprite_score_2_enable_update,
    output logic sprite_score_3_enable_update,

    output logic sprite_bullet_rgb_en_fsm,
    output logic sprite_heart_1_rgb_en_fsm,
    output logic sprite_heart_2_rgb_en_fsm,
    output logic sprite_heart_3_rgb_en_fsm,
    output logic sprite_score_1_rgb_en_fsm,
    output logic sprite_score_2_rgb_en_fsm,
    output logic sprite_score_3_rgb_en_fsm,

    input      sprite_target_within_screen_1,
    input      sprite_target_within_screen_2,
    input      sprite_target_within_screen_3,
    input      sprite_bullet_within_screen,
    input      sprite_spaceship_within_screen,
    input      sprite_heart_1_within_screen,
    input      sprite_heart_2_within_screen,
    input      sprite_heart_3_within_screen,
    input      sprite_heart_within_screen,
    input      sprite_score_1_within_screen,
    input      sprite_score_2_within_screen,
    input      sprite_score_3_within_screen,

    input      collision,
    input      collision_bullet,

    output logic end_of_game_timer_start,
    output logic game_won,

    input      end_of_game_timer_running
);

    localparam [3:0]
                     STATE_HP3_SC0     = 1,
                     STATE_HP3_SC1     = 2,
                     STATE_HP3_SC2     = 3,
                     STATE_HP2_SC0     = 4,
                     STATE_HP2_SC1     = 5,
                     STATE_HP2_SC2     = 6,
                     STATE_HP1_SC0     = 7,
                     STATE_HP1_SC1     = 8,
                     STATE_HP1_SC2     = 9;

    localparam [4:0] STATE_START_GAME       = 0,
                     STATE_END_GAME         = 1,
                     STATE_START_ROUND      = 2,

                     STATE_AIM_HP3_SC0      = 3,
                     STATE_SHOOT_HP3_SC0    = 4,
                     STATE_AIM_HP3_SC1      = 5,
                     STATE_SHOOT_HP3_SC1    = 6,
                     STATE_AIM_HP3_SC2      = 7,
                     STATE_SHOOT_HP3_SC2    = 8,

                     STATE_AIM_HP2_SC0      = 9,
                     STATE_SHOOT_HP2_SC0    = 10,
                     STATE_AIM_HP2_SC1      = 11,
                     STATE_SHOOT_HP2_SC1    = 12,
                     STATE_AIM_HP2_SC2      = 13,
                     STATE_SHOOT_HP2_SC2    = 14,

                     STATE_AIM_HP1_SC0      = 15,
                     STATE_SHOOT_HP1_SC0    = 16,
                     STATE_AIM_HP1_SC1      = 17,
                     STATE_SHOOT_HP1_SC1    = 18,
                     STATE_AIM_HP1_SC2      = 19,
                     STATE_SHOOT_HP1_SC2    = 20;

    logic [4:0] state;
    logic [4:0] d_state;

    logic [3:0] game_stats;
    logic [3:0] d_game_stats;

    logic d_sprite_target_write_xy_1;
    logic d_sprite_target_write_xy_2;
    logic d_sprite_target_write_xy_3;
    logic d_sprite_spaceship_write_xy;
    logic d_sprite_bullet_write_xy;
    logic d_sprite_heart_1_write_xy;
    logic d_sprite_heart_2_write_xy;
    logic d_sprite_heart_3_write_xy;
    logic d_sprite_score_1_write_xy;
    logic d_sprite_score_2_write_xy;
    logic d_sprite_score_3_write_xy;

    logic d_sprite_target_write_dxy_1;
    logic d_sprite_target_write_dxy_2;
    logic d_sprite_target_write_dxy_3;
    logic d_sprite_spaceship_write_dxy;
    logic d_sprite_bullet_write_dxy;
    logic d_sprite_heart_1_write_dxy;
    logic d_sprite_heart_2_write_dxy;
    logic d_sprite_heart_3_write_dxy;
    logic d_sprite_score_1_write_dxy;
    logic d_sprite_score_2_write_dxy;
    logic d_sprite_score_3_write_dxy;

    logic d_sprite_target_enable_update_1;
    logic d_sprite_target_enable_update_2;
    logic d_sprite_target_enable_update_3;
    logic d_sprite_spaceship_enable_update;
    logic d_sprite_bullet_enable_update;
    logic d_sprite_heart_1_enable_update;
    logic d_sprite_heart_2_enable_update;
    logic d_sprite_heart_3_enable_update;
    logic d_sprite_score_1_enable_update;
    logic d_sprite_score_2_enable_update;
    logic d_sprite_score_3_enable_update;

    logic d_sprite_bullet_rgb_en_fsm;
    logic d_sprite_heart_1_rgb_en_fsm;
    logic d_sprite_heart_2_rgb_en_fsm;
    logic d_sprite_heart_3_rgb_en_fsm;
    logic d_sprite_score_1_rgb_en_fsm;
    logic d_sprite_score_2_rgb_en_fsm;
    logic d_sprite_score_3_rgb_en_fsm;

    logic d_end_of_game_timer_start;
    logic d_game_won;
    logic d_round_won;

    logic [3:0] d_score;
    logic [3:0] score;

    logic [3:0] d_lifes;
    logic [3:0] lifes;

    reg collision_del;
    wire posedge_collision;

    assign posedge_collision = collision & !collision_del;

    always_ff @ (posedge clk or posedge rst) begin
        if (rst)
            collision_del <= 0;
        else begin
            collision_del <= collision;

        end
    end

    reg collision_bullet_del;
    wire posedge_collision_bullet;

    assign posedge_collision_bullet = collision_bullet & !collision_bullet_del;

    always_ff @ (posedge clk or posedge rst) begin
        if (rst)
            collision_bullet_del <= 0;
        else begin
            collision_bullet_del <= collision_bullet;

        end
    end

    //------------------------------------------------------------------------

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
        d_game_stats = game_stats;

        d_sprite_target_write_xy_1        = 1'b0;
        d_sprite_target_write_xy_2        = 1'b0;
        d_sprite_target_write_xy_3        = 1'b0;
        d_sprite_bullet_write_xy          = 1'b0;
        d_sprite_spaceship_write_xy       = 1'b0;
        d_sprite_heart_1_write_xy         = 1'b0;
        d_sprite_heart_2_write_xy         = 1'b0;
        d_sprite_heart_3_write_xy         = 1'b0;
        d_sprite_score_1_write_xy         = 1'b0;
        d_sprite_score_2_write_xy         = 1'b0;
        d_sprite_score_3_write_xy         = 1'b0;

        d_sprite_target_write_dxy_1       = 1'b0;
        d_sprite_target_write_dxy_2       = 1'b0;
        d_sprite_target_write_dxy_3       = 1'b0;
        d_sprite_spaceship_write_dxy      = 1'b0;
        d_sprite_bullet_write_dxy         = 1'b0;
        d_sprite_heart_1_write_dxy        = 1'b0;
        d_sprite_heart_2_write_dxy        = 1'b0;
        d_sprite_heart_3_write_dxy        = 1'b0;
        d_sprite_score_1_write_dxy        = 1'b0;
        d_sprite_score_2_write_dxy        = 1'b0;
        d_sprite_score_3_write_dxy        = 1'b0;

        d_sprite_target_enable_update_1   = 1'b0;
        d_sprite_target_enable_update_2   = 1'b0;
        d_sprite_target_enable_update_3   = 1'b0;
        d_sprite_spaceship_enable_update  = 1'b0;
        d_sprite_bullet_enable_update     = 1'b0;

        d_sprite_heart_1_enable_update    = 1'b1;
        d_sprite_heart_2_enable_update    = 1'b1;
        d_sprite_heart_3_enable_update    = 1'b1;

        d_sprite_score_1_enable_update    = 1'b0;
        d_sprite_score_2_enable_update    = 1'b0;
        d_sprite_score_3_enable_update    = 1'b0;

        d_sprite_bullet_rgb_en_fsm        = 0;
        d_sprite_heart_1_rgb_en_fsm       = 1'b1;
        d_sprite_heart_2_rgb_en_fsm       = 1'b1;
        d_sprite_heart_3_rgb_en_fsm       = 1'b1;
        d_sprite_score_1_rgb_en_fsm       = 1'b0;
        d_sprite_score_2_rgb_en_fsm       = 1'b0;
        d_sprite_score_3_rgb_en_fsm       = 1'b0;

        d_end_of_game_timer_start         = 1'b0;
        d_game_won                        = game_won;
        d_round_won                       = 1'b0;

        //--------------------------------------------------------------------

        case (state)

        STATE_START_GAME:
        begin
            d_game_won                  = 1'b0;
            d_round_won                 = 1'b0;
            d_end_of_game_timer_start   = 1'b1;

            d_sprite_heart_1_write_xy   = 1'b1;
            d_sprite_heart_2_write_xy   = 1'b1;
            d_sprite_heart_3_write_xy   = 1'b1;
            d_sprite_score_1_write_xy   = 1'b0;
            d_sprite_score_2_write_xy   = 1'b0;
            d_sprite_score_3_write_xy   = 1'b0;

            d_sprite_bullet_rgb_en_fsm  = 0;
            d_sprite_heart_1_rgb_en_fsm = 1'b1;
            d_sprite_heart_2_rgb_en_fsm = 1'b1;
            d_sprite_heart_3_rgb_en_fsm = 1'b1;
            d_sprite_score_1_rgb_en_fsm = 1'b0;
            d_sprite_score_2_rgb_en_fsm = 1'b0;
            d_sprite_score_3_rgb_en_fsm = 1'b0;

            d_sprite_target_write_xy_1        = 1'b1;
            d_sprite_target_write_xy_2        = 1'b1;
            d_sprite_target_write_xy_3        = 1'b1;

            d_sprite_target_write_dxy_1       = 1'b1;
            d_sprite_target_write_dxy_2       = 1'b1;
            d_sprite_target_write_dxy_3       = 1'b1;

            d_sprite_spaceship_write_xy       = 1'b1;
            d_sprite_bullet_write_xy          = 1'b1;

            d_round_won                       = 1'b0;

            if (!end_of_game_timer_running)
                d_state = STATE_END_GAME;
            else
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

            if (!end_of_game_timer_running)
                d_state = STATE_END_GAME;
            else begin
                case (d_game_stats)
                    STATE_HP3_SC0: begin
                        d_state = STATE_AIM_HP3_SC0;
                    end
                    STATE_HP3_SC1: begin
                        d_state = STATE_AIM_HP3_SC1;
                    end
                    STATE_HP3_SC2: begin
                        d_state = STATE_AIM_HP3_SC2;
                    end
                    STATE_HP2_SC0: begin
                        d_state = STATE_AIM_HP2_SC0;
                    end
                    STATE_HP2_SC1: begin
                        d_state = STATE_AIM_HP2_SC1;
                    end
                    STATE_HP2_SC2: begin
                        d_state = STATE_AIM_HP2_SC2;
                    end
                    STATE_HP1_SC0: begin
                        d_state = STATE_AIM_HP1_SC0;
                    end
                    STATE_HP1_SC1: begin
                        d_state = STATE_AIM_HP1_SC1;
                    end
                    STATE_HP1_SC2: begin
                        d_state = STATE_AIM_HP1_SC2;
                    end
                    default: begin
                        d_state = STATE_END_GAME;
                    end
                endcase
            end
        end

        STATE_AIM_HP3_SC0:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 1;
            d_sprite_heart_1_rgb_en_fsm        = 1;
            d_sprite_heart_1_enable_update     = 1;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (shoot) begin
                d_state = STATE_SHOOT_HP3_SC0;
            end  if (posedge_collision) begin
                d_game_stats = STATE_HP2_SC0;
                d_state = STATE_START_ROUND;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP3_SC1:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 1;
            d_sprite_heart_1_rgb_en_fsm        = 1;
            d_sprite_heart_1_enable_update     = 1;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 0;
            d_sprite_score_2_rgb_en_fsm        = 0;
            d_sprite_score_2_enable_update     = 0;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (shoot) begin
                d_state = STATE_SHOOT_HP3_SC1;
            end  if (posedge_collision) begin
                d_game_stats = STATE_HP2_SC1;
                d_state = STATE_START_ROUND;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP3_SC1:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 1;
            d_sprite_heart_1_rgb_en_fsm        = 1;
            d_sprite_heart_1_enable_update     = 1;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 0;
            d_sprite_score_2_rgb_en_fsm        = 0;
            d_sprite_score_2_enable_update     = 0;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP2_SC1;
                d_state = STATE_START_ROUND;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP3_SC2;
                d_state = STATE_START_ROUND;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP3_SC2:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 1;
            d_sprite_heart_1_rgb_en_fsm        = 1;
            d_sprite_heart_1_enable_update     = 1;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 1;
            d_sprite_score_2_rgb_en_fsm        = 1;
            d_sprite_score_2_enable_update     = 1;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (shoot) begin
                d_state = STATE_SHOOT_HP3_SC2;
            end  if (posedge_collision) begin
                d_game_stats = STATE_HP2_SC2;
                d_state = STATE_START_ROUND;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP3_SC2:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 1;
            d_sprite_heart_1_rgb_en_fsm        = 1;
            d_sprite_heart_1_enable_update     = 1;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 1;
            d_sprite_score_2_rgb_en_fsm        = 1;
            d_sprite_score_2_enable_update     = 1;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP2_SC2;
                d_state = STATE_START_ROUND;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP3_SC0:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 1;
            d_sprite_heart_1_rgb_en_fsm        = 1;
            d_sprite_heart_1_enable_update     = 1;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP2_SC0;
                d_state = STATE_START_ROUND;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP3_SC1;
                d_state = STATE_START_ROUND;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end

        end

        STATE_AIM_HP2_SC0:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP1_SC0;
                d_state = STATE_START_ROUND;
            end else if (shoot) begin
                d_state = STATE_SHOOT_HP2_SC0;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP2_SC0:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP1_SC0;
                d_state = STATE_START_ROUND;
            end else if (shoot) begin
                d_state = STATE_SHOOT_HP2_SC0;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP1_SC0:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 0;
            d_sprite_heart_2_rgb_en_fsm        = 0;
            d_sprite_heart_2_enable_update     = 0;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end else if (shoot) begin
                d_state = STATE_SHOOT_HP1_SC0;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP2_SC1:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 0;
            d_sprite_score_2_rgb_en_fsm        = 0;
            d_sprite_score_2_enable_update     = 0;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP1_SC1;
                d_state = STATE_START_ROUND;
            end else if (shoot) begin
                d_state = STATE_SHOOT_HP2_SC1;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP1_SC1:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 0;
            d_sprite_heart_2_rgb_en_fsm        = 0;
            d_sprite_heart_2_enable_update     = 0;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 0;
            d_sprite_score_2_rgb_en_fsm        = 0;
            d_sprite_score_2_enable_update     = 0;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end else if (shoot) begin
                d_state = STATE_SHOOT_HP1_SC1;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP2_SC2:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 1;
            d_sprite_score_2_rgb_en_fsm        = 1;
            d_sprite_score_2_enable_update     = 1;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP1_SC2;
                d_state = STATE_START_ROUND;
            end else if (shoot) begin
                d_state = STATE_SHOOT_HP2_SC2;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP2_SC2:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 1;
            d_sprite_score_2_rgb_en_fsm        = 1;
            d_sprite_score_2_enable_update     = 1;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP1_SC2;
                d_state = STATE_START_ROUND;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_AIM_HP1_SC2:
        begin
            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 0;
            d_sprite_heart_2_rgb_en_fsm        = 0;
            d_sprite_heart_2_enable_update     = 0;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 1;
            d_sprite_score_2_rgb_en_fsm        = 1;
            d_sprite_score_2_enable_update     = 1;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 0;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end else if (shoot) begin
                d_state = STATE_SHOOT_HP1_SC2;
            end
            else if (round_end) begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP1_SC2:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 0;
            d_sprite_heart_2_rgb_en_fsm        = 0;
            d_sprite_heart_2_enable_update     = 0;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 1;
            d_sprite_score_2_rgb_en_fsm        = 1;
            d_sprite_score_2_enable_update     = 1;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP1_SC1:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 0;
            d_sprite_heart_2_rgb_en_fsm        = 0;
            d_sprite_heart_2_enable_update     = 0;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 0;
            d_sprite_score_2_rgb_en_fsm        = 0;
            d_sprite_score_2_enable_update     = 0;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP1_SC2;
                d_state = STATE_START_ROUND;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP2_SC1:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_score_1_write_xy          = 0;
            d_sprite_score_1_rgb_en_fsm        = 0;
            d_sprite_score_1_enable_update     = 0;
            d_sprite_score_2_write_xy          = 0;
            d_sprite_score_2_rgb_en_fsm        = 0;
            d_sprite_score_2_enable_update     = 0;
            d_sprite_score_3_write_xy          = 1;
            d_sprite_score_3_rgb_en_fsm        = 1;
            d_sprite_score_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP1_SC1;
                d_state = STATE_START_ROUND;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP2_SC2;
                d_state = STATE_START_ROUND;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP2_SC0:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 1;
            d_sprite_heart_2_rgb_en_fsm        = 1;
            d_sprite_heart_2_enable_update     = 1;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP1_SC0;
                d_state = STATE_START_ROUND;
            end
            else if (posedge_collision_bullet) begin
                d_game_stats = STATE_HP2_SC1;
                d_state = STATE_START_ROUND;
            end
            else if (round_end)
            begin
                d_state = STATE_START_ROUND;
            end
        end

        STATE_SHOOT_HP1_SC0:
        begin
            d_sprite_bullet_write_dxy         = 1'b1;
            d_sprite_bullet_enable_update     = 1'b1;
            d_sprite_bullet_rgb_en_fsm        = 1;

            d_sprite_heart_1_write_xy          = 0;
            d_sprite_heart_1_rgb_en_fsm        = 0;
            d_sprite_heart_1_enable_update     = 0;
            d_sprite_heart_2_write_xy          = 0;
            d_sprite_heart_2_rgb_en_fsm        = 0;
            d_sprite_heart_2_enable_update     = 0;
            d_sprite_heart_3_write_xy          = 1;
            d_sprite_heart_3_rgb_en_fsm        = 1;
            d_sprite_heart_3_enable_update     = 1;

            d_sprite_target_enable_update_1   = 1'b1;
            d_sprite_target_enable_update_2   = 1'b1;
            d_sprite_target_enable_update_3   = 1'b1;

            d_sprite_spaceship_enable_update  = 1'b1;
            d_sprite_spaceship_write_dxy      = 1'b1;

            if (posedge_collision) begin
                d_game_stats = STATE_HP3_SC0;
                d_state = STATE_END_GAME;
            end
            else if (collision_bullet) begin
                d_game_stats = STATE_HP1_SC1;
                d_state = STATE_START_ROUND;
            end
            else if (round_end)
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


    //------------------------------------------------------------------------

    always_ff @ (posedge clk or posedge rst)
        if (rst)
        begin
            state                           <= STATE_START_GAME;
            game_stats                      <= STATE_HP3_SC0;

            sprite_target_write_xy_1        <= 1'b0;
            sprite_target_write_xy_2        <= 1'b0;
            sprite_target_write_xy_3        <= 1'b0;
            sprite_spaceship_write_xy       <= 1'b0;
            sprite_bullet_write_xy          <= 1'b0;
            sprite_heart_1_write_xy         <= 1'b0;
            sprite_heart_2_write_xy         <= 1'b0;
            sprite_heart_3_write_xy         <= 1'b0;
            sprite_score_1_write_xy         <= 1'b0;
            sprite_score_2_write_xy         <= 1'b0;
            sprite_score_3_write_xy         <= 1'b0;

            sprite_target_write_dxy_1       <= 1'b0;
            sprite_target_write_dxy_2       <= 1'b0;
            sprite_target_write_dxy_3       <= 1'b0;
            sprite_spaceship_write_dxy      <= 1'b0;
            sprite_bullet_write_dxy         <= 1'b0;
            sprite_heart_1_write_dxy        <= 1'b0;
            sprite_heart_2_write_dxy        <= 1'b0;
            sprite_heart_3_write_dxy        <= 1'b0;
            sprite_score_1_write_dxy        <= 1'b0;
            sprite_score_2_write_dxy        <= 1'b0;
            sprite_score_3_write_dxy        <= 1'b0;

            sprite_target_enable_update_1   <= 1'b0;
            sprite_target_enable_update_2   <= 1'b0;
            sprite_target_enable_update_3   <= 1'b0;
            sprite_spaceship_enable_update  <= 1'b0;
            sprite_bullet_enable_update     <= 1'b0;
            sprite_heart_1_enable_update    <= 1'b0;
            sprite_heart_2_enable_update    <= 1'b0;
            sprite_heart_3_enable_update    <= 1'b0;
            sprite_score_1_enable_update    <= 1'b0;
            sprite_score_2_enable_update    <= 1'b0;
            sprite_score_3_enable_update    <= 1'b0;

            sprite_bullet_rgb_en_fsm        <= 0;
            sprite_heart_1_rgb_en_fsm       <= 0;
            sprite_heart_2_rgb_en_fsm       <= 0;
            sprite_heart_3_rgb_en_fsm       <= 0;
            sprite_score_1_rgb_en_fsm       <= 0;
            sprite_score_2_rgb_en_fsm       <= 0;
            sprite_score_3_rgb_en_fsm       <= 0;

            end_of_game_timer_start         <= 1'b0;
            game_won                        <= 1'b0;
        end
        else
        begin
            state                           <= d_state;
            game_stats                      <= d_game_stats;

            sprite_target_write_xy_1        <= d_sprite_target_write_xy_1;
            sprite_target_write_xy_2        <= d_sprite_target_write_xy_2;
            sprite_target_write_xy_3        <= d_sprite_target_write_xy_3;
            sprite_spaceship_write_xy       <= d_sprite_spaceship_write_xy;
            sprite_bullet_write_xy          <= d_sprite_bullet_write_xy;
            sprite_heart_1_write_xy         <= d_sprite_heart_1_write_xy;
            sprite_heart_2_write_xy         <= d_sprite_heart_2_write_xy;
            sprite_heart_3_write_xy         <= d_sprite_heart_3_write_xy;
            sprite_score_1_write_xy         <= d_sprite_score_1_write_xy;
            sprite_score_2_write_xy         <= d_sprite_score_2_write_xy;
            sprite_score_3_write_xy         <= d_sprite_score_3_write_xy;

            sprite_target_write_dxy_1       <= d_sprite_target_write_dxy_1;
            sprite_target_write_dxy_2       <= d_sprite_target_write_dxy_2;
            sprite_target_write_dxy_3       <= d_sprite_target_write_dxy_3;
            sprite_spaceship_write_dxy      <= d_sprite_spaceship_write_dxy;
            sprite_bullet_write_dxy         <= d_sprite_bullet_write_dxy;
            sprite_heart_1_write_dxy        <= d_sprite_heart_1_write_dxy;
            sprite_heart_2_write_dxy        <= d_sprite_heart_2_write_dxy;
            sprite_heart_3_write_dxy        <= d_sprite_heart_3_write_dxy;
            sprite_score_1_write_dxy        <= d_sprite_score_1_write_dxy;
            sprite_score_2_write_dxy        <= d_sprite_score_2_write_dxy;
            sprite_score_3_write_dxy        <= d_sprite_score_3_write_dxy;

            sprite_target_enable_update_1   <= d_sprite_target_enable_update_1;
            sprite_target_enable_update_2   <= d_sprite_target_enable_update_2;
            sprite_target_enable_update_3   <= d_sprite_target_enable_update_3;
            sprite_spaceship_enable_update  <= d_sprite_spaceship_enable_update;
            sprite_bullet_enable_update     <= d_sprite_bullet_enable_update;

            sprite_heart_1_enable_update    <= d_sprite_heart_1_enable_update;
            sprite_heart_2_enable_update    <= d_sprite_heart_2_enable_update;
            sprite_heart_3_enable_update    <= d_sprite_heart_3_enable_update;

            sprite_score_1_enable_update    <= d_sprite_score_1_enable_update;
            sprite_score_2_enable_update    <= d_sprite_score_2_enable_update;
            sprite_score_3_enable_update    <= d_sprite_score_3_enable_update;

            sprite_bullet_rgb_en_fsm        <= d_sprite_bullet_rgb_en_fsm;
            sprite_heart_1_rgb_en_fsm       <= d_sprite_heart_1_rgb_en_fsm;
            sprite_heart_2_rgb_en_fsm       <= d_sprite_heart_2_rgb_en_fsm;
            sprite_heart_3_rgb_en_fsm       <= d_sprite_heart_3_rgb_en_fsm;
            sprite_score_1_rgb_en_fsm       <= d_sprite_score_1_rgb_en_fsm;
            sprite_score_2_rgb_en_fsm       <= d_sprite_score_2_rgb_en_fsm;
            sprite_score_3_rgb_en_fsm       <= d_sprite_score_3_rgb_en_fsm;

            end_of_game_timer_start         <= d_end_of_game_timer_start;

            game_won                        <= d_game_won;
        end

endmodule
