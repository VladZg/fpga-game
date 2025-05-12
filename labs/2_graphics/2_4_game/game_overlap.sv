`include "game_config.svh"

module game_overlap
#(
    parameter screen_width  = 640,
              screen_height = 480,

              w_x           = $clog2 ( screen_width  ),
              w_y           = $clog2 ( screen_height )
)
//----------------------------------------------------------------------------
(
    input                       clk,
    input                       rst,

    input      [w_x      - 1:0] left_1_1,
    input      [w_x      - 1:0] right_1_1,
    input      [w_y      - 1:0] top_1_1,
    input      [w_y      - 1:0] bottom_1_1,

    input      [w_x      - 1:0] left_1_2,
    input      [w_x      - 1:0] right_1_2,
    input      [w_y      - 1:0] top_1_2,
    input      [w_y      - 1:0] bottom_1_2,

    input      [w_x      - 1:0] left_1_3,
    input      [w_x      - 1:0] right_1_3,
    input      [w_y      - 1:0] top_1_3,
    input      [w_y      - 1:0] bottom_1_3,

    input      [w_x      - 1:0] left_bullet,
    input      [w_x      - 1:0] right_bullet,
    input      [w_y      - 1:0] top_bullet,
    input      [w_y      - 1:0] bottom_bullet,

    input      [w_x      - 1:0] left_2,
    input      [w_x      - 1:0] right_2,
    input      [w_y      - 1:0] top_2,
    input      [w_y      - 1:0] bottom_2,

    output logic                  overlap,
    output logic                  overlap_bullet
);

    always_ff @ (posedge clk or posedge rst)
        if (rst) begin
            overlap <= 1'b0;
            overlap_bullet <= 1'b0;
        end else begin
            overlap <= ! (    right_1_1  < left_2
                           || right_2  < left_1_1
                           || bottom_1_1 < top_2
                           || bottom_2 < top_1_1  ) || ! (    right_1_2  < left_2
                           || right_2  < left_1_2
                           || bottom_1_2 < top_2
                           || bottom_2 < top_1_2  ) || ! (    right_1_3  < left_2
                           || right_2  < left_1_3
                           || bottom_1_3 < top_2
                           || bottom_2 < top_1_3  );

            overlap_bullet <= ! (    right_1_1  < left_bullet
                           || right_bullet  < left_1_1
                           || bottom_1_1 < top_bullet
                           || bottom_bullet < top_1_1  ) || ! (    right_1_2  < left_bullet
                           || right_bullet  < left_1_2
                           || bottom_1_2 < top_bullet
                           || bottom_bullet < top_1_2  ) || ! (    right_1_3  < left_bullet
                           || right_bullet  < left_1_3
                           || bottom_1_3 < top_bullet
                           || bottom_bullet < top_1_3  );
        end
endmodule
