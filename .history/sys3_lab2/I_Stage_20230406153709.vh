`ifndef I_STAGE_H
`define I_STAGE_H

parameter   IDLE = 3'b000,
            CompareTag = 3'b001,
            Allocate = 3'b010,
            WriteBack = 3'b011;
            TagMSB = 31;
            TagLSB = 4;
            V = 45;
            D = 44
`endif