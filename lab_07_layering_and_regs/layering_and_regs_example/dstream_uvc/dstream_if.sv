/**
 * @author radigast
 */

`timescale 1ns/1ps

interface dstream_if(input  clk, input rst_n);

  // Interface Net Declarations
  logic [31:0] d_master;  // data from master
  logic [31:0] d_slave;   // data from slave
  logic        d_valid;   // indicate active tranfer

  clocking drv_cb @(posedge clk);
    default input #1step output #1ns;

    // Interface Clocked Driver Direction Declarations
    input  d_slave;
    output d_master, d_valid;

  endclocking: drv_cb

  clocking mon_cb @(posedge clk);
    default input #1step;

    // Interface Clocked Monitor Direction Declarations
    input  d_slave;
    input  d_master, d_valid;

  endclocking: mon_cb

  modport drv_mp (
    clocking drv_cb,
    input  d_slave, rst_n,
    output d_master, d_valid
        
  );

  modport mon_mp (
    clocking mon_cb,
    output d_master, d_valid, d_slave, rst_n
  );

endinterface: dstream_if
