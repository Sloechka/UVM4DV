`timescale 1ps/1ps

interface axis_if(
    input logic clk,
    input logic rst_n
);

    logic valid;
    logic ready;
    // logic last;

    logic [31:0] data;
    logic [7:0] id;

    modport transmitter(
        input clk, rst_n, ready,
        output valid, data, id
    );

    modport receiver(
        input clk, rst_n, valid, data, id,
        output ready
    );

endinterface: axis_if