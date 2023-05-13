`ifndef I_STAGE_H
`define I_STAGE_H

parameter   IDLE = 3'b000,
            CompareTag = 3'b001,
            Allocate = 3'b010,
            WriteBack = 3'b011;
            TagMSB = 43;
            TagLSB = 32;
            BlockMSB = 1;
            BlockLSSB = 1;
            V = 45;
            D = 44;

`endif