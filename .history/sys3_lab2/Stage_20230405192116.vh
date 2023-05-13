`ifndef STAGE_H
`define STAGE_H

parameter   S_IDLE = 3'b0000,
            S_BACK = 3'b0001,
            S_BACK_WAIT = 3'b0010,
            S_FILL = 3'b0011,
            S_FILL_WAIT = 3'b0100;

`endif