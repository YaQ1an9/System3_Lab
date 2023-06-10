`ifndef I_STAGE_H
`define I_STAGE_H

parameter   IDLE = 3'b000,
            CompareTag = 3'b001,
            Allocate = 3'b010,
            WriteBack = 3'b011;
parameter   TagMSB = 43;
parameter   TagLSB = 32;
parameter   BlockMSB = 31;
parameter   BlockLSB = 0;
parameter   V = 45;
parameter   D = 44;

`endif