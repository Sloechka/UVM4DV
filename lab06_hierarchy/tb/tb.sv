`timescale 1ps/1ps

module lab6_tb();

    import test_pkg::*;

    logic clk;

    reset_if reset_if_0();

    axis_if axis_if_0(
        .clk(clk),
        .rst_n(reset_if_0.rst_n)
    );

    axis_dummy dut(
        .aif(axis_if_0.receiver)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        uvm_pkg::uvm_resource_db#(virtual axis_if)::set("*axis_ag.*", "axis_if", axis_if_0);
        uvm_pkg::uvm_resource_db#(virtual reset_if)::set("*reset_ag.*", "reset_if", reset_if_0);
        
        uvm_pkg::run_test();
    end

endmodule: lab5_tb
