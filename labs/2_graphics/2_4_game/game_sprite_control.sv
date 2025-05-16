`include "game_config.svh"

module game_sprite_control
#(
    parameter DX_WIDTH      = 2,  // X speed width in bits
              DY_WIDTH      = 2,  // Y speed width in bits

              screen_width  = 640,
              screen_height = 480,

              w_x           = $clog2 ( screen_width  ),
              w_y           = $clog2 ( screen_height ),

              strobe_to_update_xy_counter_width = 20
)

//----------------------------------------------------------------------------

(
    input                    clk,
    input                    rst,

    input                    sprite_write_xy,
    input                    sprite_write_dxy,

    input  [w_x       - 1:0] sprite_write_x,
    input  [w_y       - 1:0] sprite_write_y,

    input  [ DX_WIDTH - 1:0] sprite_write_dx,
    input  [ DY_WIDTH - 1:0] sprite_write_dy,

    input                    sprite_enable_update,
    input                    is_meteor,
    input                    is_bullet,
    input                    shoot,

    output [w_x       - 1:0] sprite_x,
    output [w_y       - 1:0] sprite_y
);

    wire strobe_to_update_xy;

    game_strobe
    # (.width (strobe_to_update_xy_counter_width))
    strobe_generator
    (clk, rst, strobe_to_update_xy);

    logic [w_x       - 1:0] x;
    logic [w_y       - 1:0] y;

    logic [ DX_WIDTH - 1:0] dx;
    logic [ DY_WIDTH - 1:0] dy;
    logic                   bullet_is_shot;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
        begin
            x  <= 1'b0;
            y  <= 1'b0;
            bullet_is_shot <= 1'b0;
        end
        else if (sprite_write_xy)
        begin
            x  <= sprite_write_x;
            y  <= sprite_write_y;
            bullet_is_shot <= bullet_is_shot | (is_bullet & shoot);
        end
        else if (sprite_enable_update && strobe_to_update_xy)
        begin
            bullet_is_shot <= bullet_is_shot | (is_bullet & shoot);

            if (bullet_is_shot) begin
                y <= y - 1;
                x <= x;
            end

            if (is_meteor) begin
                y <= y + 3;
            end else if (!bullet_is_shot && (!is_meteor || is_bullet)) begin
                // Add with signed-extended dx and dy
                x <= x + { { w_x - DX_WIDTH { dx [DX_WIDTH - 1] } }, dx };
            end
        end

    always_ff @ (posedge clk or posedge rst)
        if (rst)
        begin
            dx <= 1'b0;
            dy <= 1'b0;
        end
        else if (sprite_write_dxy)
        begin
            dx <= sprite_write_dx;
            dy <= sprite_write_dy;
        end


    assign sprite_x = x;
    assign sprite_y = y;

endmodule
